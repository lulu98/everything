# Chapter 11: BusyBox

- BusyBox: a small and efficient replacement for a large collection of standard
Linux command-line utilities
- often serves as the foundation for a resource-limited embedded platform

## Introduction to BusyBox

- reduces the overall system resources required to support a wide collection of
common Linux utilities such as:
    * file utilities: `ls`, `cat`, `cp`, `dir`, `head`, `tail`
    * general utilities: `dmesk`, `kill`, `halt`, `fdisk`, `mount`, `umount`
    * network utilities: `ifconfig`, `netstat`, `route`
    * many more...
- BusyBox is modular and highly configurable -> can be tailored to particular
requirements
- commands in BusyBox are simpler implementations than their full-blown
counterparts
- can significantly reduce the size of your root file system image

### BusyBox is easy

- required steps:

1. Execute a configuration utility and enable your choice of features.
2. Run `make` to build the package.
3. Install the binary and a series of `symbolic links` on your target system.

- cross-compilation compiler controlled through the `CROSS_COMPILE` environment
variable
- can be compiled as a static or dynamic binary
- if compiled as static library: no support for libc and other system libraries -> can't
implement your own applications
- configuration through `make menuconfig`

## BusyBox operation

- `BusyBox` is also the name of the generated binary
- launched via symlink -> no need to type `busybox <command-name>`
- to invoke the `ls` function of BusyBox, issue the following command: `busybox ls /`
- BusyBox is a multicall binary = combining many common utilities into a single
executable -> BusyBox is invoked by a symlink named for the function it will
perform, e.g.:

```bash
|__ cat -> busybox
|__ cp -> busybox
|__ ...
```

- due to symlinks, we can now simply issue the actual command without the
`busybox` prefix
- BusyBox reads `argv[0]` to determine what functionality is being requested


### BusyBox init

- kernel attempts to execute a program called `/sbin/init` as the last step in
kernel initialization
- so BusyBox emulates the `init` functionality -> symlink from `init` to `busybox`
- BusyBox handles system initialization differently from standard System V `init`
- normal System V `init` requires `inittab` file in `/etc` directory
- BusyBox also reads `inittab` file, but syntax is different -> instead of using
`inittab` in BusyBox, it is actually preferred to use `/etc/init.d/rcS`
- exemplary `rcS` initialization script sets up the system before interactive
shell is started:

```bash
#!/bin/sh

echo “Mounting proc”
mount -t proc /proc /proc

echo “Starting system loggers”
syslogd

klogd

echo “Configuring loopback interface”
ifconfig lo 127.0.0.1

echo “Starting inetd”
xinetd

# start a shell
busybox sh
```

- a lot is specified since utilities require this kind of informationj, e.g.
mounted `/proc` filesystem, system loggers or a loopback interface

### BusyBox Target Installation

- `make install` (BusyBox Makefile): creates a directory structure containing
the BusyBox executable and a symlink tree -> this environment must be migrated
to your target embedded system's root directory, complete with the symlink tree
- to populate root file system with symlink farm, let BusyBox build system do it
for you -> mount root file system on development platform and use
`make CONFIG_PREFIX=<mount-point> install`
- need to make `busybox` binary `setuid` (`chmod +s`) in order for non-root user to invoke
functions that require root access -> not strictly necessary for embedded system,
since typically only as root executed
- busybox applets typically only support subset of original package
- when full capabilities of a utility are needed -> delete support for that
particular utility in the BusyBox configuration, and add the standard Linux
utility to your target system

