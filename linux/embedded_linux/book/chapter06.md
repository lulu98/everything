# Chapter 6: User Space Initialization

- after kernel has initialized, it must mount a root file system and execute a
set of developer-defined initialization routines -> post-kernel system
initialization

## Root File System

- Linux requires a root file system
- root file system refers to the file system mounted at the base of the file
system hierarchy, designated as `/`
- root file system is the first file system mounted at the top of the file
system hierarchy
- Linux expects the root file system to contain programs and utilities to boot
the system, initialize services such as networking and a system console, load
device drivers, and mount additional filesystems

### FHS: File System Hierarchy Standard

- standard governing the organization and layout of a UNIX file system
- FHS establishes a minimum baseline of compatibility between Linux distributions
and application programs
- FHS allows your application software (and developers) to predict where certain
system elements, including files and directories, can be found in the file
system

### File System Layout

- in the embedded space, typically there is only a very small root file system
on a bootable device (e.g. flash memory)
- later, a larger file system is mounted from another device -> can be loaded on
top of smaller one
- typical simple Linux root file system

```bash
.
|
|__ bin
|__ dev
|__ etc
|__ home
|__ lib
|__ sbin
|__ usr
|__ var
|__ tmp
```

Explanation of directories:

| Directory | Contents |
| --------- | -------- |
| `bin`     | Binary executables, usable by all users on the system (often embedded system do not have user accounts, other than a single root user) |
| `dev`     | Device Nodes |
| `etc`     | Local system configuration files |
| `home`    | User account files |
| `lib`     | System libraries, such as the standard C library and many others |
| `sbin`    | Binary executables usually reserved for superuser accounts on the system |
| `tmp`     | Temporary files |
| `usr`     | A secondary file system hierarchy for application programs, usually read-only |
| `var`     | Contains variable files, such as system logs and temporary configuration files |

Other directory entries:
- `/proc`: special file system containing system information
- `/mnt`: placeholder for user-mounted devices and file systems

### Minimal File System

Contents of Minimal (fully functioning) Root File System:

```bash
.
|
|__ bin
|   |__ busybox
|   |__ sh -> busybox
|
|__ dev
|   |__ console
|
|__ etc
|   |__ init.d
|       |__ rcS
|
|__ lib
    |__ ld-2.3.2.so
    |__ ld-linux.so.2 -> ld-2.3.2.so
    |__ libc-2.3.2.so
    |__ libc.so.6 -> libc-2.3.2.so
```

- `busybox`: toolkit for embedded systems, a stand-alone binary that supports many
common Linux command-line utilities
- `/dev/console`: device node required to open a console device for input and ouput
- `/etc/init.d/rcS`: default initialization script processed by `busybox` on startup
- files in `/lib`:
    * two libraries: soft links that provide version immunity and backward
    compatibility for the libraries themselves
    * glibc (`libc-2.3.2.so`): contains the standard C library functions that
    most application programs depend on
    * Linux dynamic loader (`ld-2.3.2.so`): responsible for loading the binary
    executable into memory and performing dynamic linking required by the
    application's reference to shared library functions

## Kernel's Last Boot Steps

```bash
...
if (execute_command) {
    run_init_process(execute_command);
    printk(KERN_WARNING “Failed to execute %s. Attempting defaults...\n”, execute_command);
}

run_init_process(“/sbin/init”);
run_init_process(“/etc/init”);
run_init_process(“/bin/init”);
run_init_process(“/bin/sh”);

panic(“No init found. Try passing init= option to kernel.”);
```

### First User Space Program

- `/sbin/init` is spawned by the kernel on boot in `.../init/main.c` through
`run_init_process("sbin/init")`
- it is the first user space program to run
- steps:
1. mount the root file system
2. spawn the first user space program, e.g. `/sbin/init`
- in our minimal root file system, only the last option `/bin/sh` would have been
triggered -> busybox spawns a shell

### Resolving dependencies

Two types of dependencies:
- library dependencies -> tool `ldd` to load dynamically linked binaries -> can
find out the library dependencies
- external configuration or data files that an application might need -> developer
must have knowledge of application/subsystem

### Customized Initial Process

- user can control which initial process is executed at startup
- through kernel command-line parameter `init=<path/to/binary/on/root/filesystem`

## The `init` Process

- the `init` program (and other startup scripts) implements what is commonly
called `System V Init`
- it is a powerful configuration and control utility
- it is the first user space process spawned by the kernel after completion of
the boot process
- `init` is the ultimate parent of all user space processes in a Linux system
- `init` provides the default set of environment parameters for all other
processes to inherit, e.g. the initial system `PATH`
- its primary role is to spawn additional processes under the direction of a
special configuration file, stored in `/etc/inittab`
- `init` has different runlevels, similar to a system state
- `init` can exist in a single runlevel at any given time
- runlevels from 0 to 6 and a special runlevel called `s`
- for each runlevel a set of startup and shutdown scripts is provided that
define the action a system should take for each runlevel
- `init` runlevels:

| Runlevel | Purpose |
| -------- | ------- |
| 0 | System shutdown (halt) |
| 1 | Single-user system configuration for maintenance |
| 2 | User-defined |
| 3 | General-purpose multiuser configuration |
| 4 | User-defined |
| 5 | Multiuser with graphical user interface on startup |
| 6 | System restart (reboot) |

- runlevel scripts can be found under a directory called `/etc/rc.d/init.d`
- services in `/etc/rc.d/init.d` can be invoked manually with options `start,stop,restart`
- `init` executes startup scripts corresponding to the current runlevel upon
entry and exit of the current runlevel
- `inittab` instructs `init` which scripts to associate with a given runlevel
- each of the runlevels is defined by the scripts contained in `rcN.d`, where N
is the runlevel
- inside `rcN.d` directory, you will find numerous symlinks
- symlinks start either with a `K` or an `S`
- `S` symlinks: point to service scripts, invoked with startup instructions
- `K` symlinks: point to service scripts, invoked with shutdown instructions
- when entering runlevel the `S` scripts are executed, when leavin runlevel the
`K` scripts are executed
- typically two-digit number after the letter -> defines the order of execution

### `inittab`

- when `init` is started, it reads the system configuration file `/etc/inittab`
- this file contains directives for each runlevel, as well as directives that
apply to all runlevels

## Initial RAM Disk

- Linux kernel contains two mechanisms to mount an early root file system to
perform certain startup-related system initialization and configuration:
1. legacy method: the initial ramdisk `initrd`
2. new method: `initramfs`
- must be enabled during kernel configuration step
- initial RAM disk is a small, self-contained root file system that usually
contains directives to load specific device drivers before the completion of the
boot cycle
- it is often used to load a device driver that is required in order to access
a real root file system

### Booting with `initrd`

- bootloader passes the `initrd` image to the kernel
- bootloader loads compressed kernel image into memory and then loads an `initrd`
image into another section of available memory and passes the load address to
kernel -> simply pass start address and size of `initrd` image to the kernel on
the kernel command line (option `initrd=<start-address>,<size>`)
- sometimes kernel and `initrd` image are concatenated into a single composite
image
- typically `initrd` is compressed

### Bootloader Support for `initrd`

- U-Boot get kernel and initrd through TFTP and execute
command `bootm <load-address-kernel> <load-address-initrd>`

### `initrd` Magic: `linuxrc`

- kernel detects presence of the `initrd` image and copies and decompresses binary
file into a proper kernel ramdisk and mounts it as the root file system
- special file within the `initrd` image called `linuxrc`
- the kernel treats this file as a script file and executes the commands contained
therein
- this way, the system designer has control over the behavior of `initrd`

### The `initrd` Plumbing

- the kernel decompresses the compressed `initrd` image from physical memory and
copies the contents of this file into a ramdisk device (`/dev/ram`) -> now there
is a proper file system on a kernel ramdisk
- after the filesystem has been read into ramdisk, the kernel effectively mounts
this ramdisk device as its root file system
- afterwards the kernel spawns a kernel thread to execute `linuxrc` file on the
`initrd` image
- when `linuxrc` script is done, the kernel unmounts the `initrd` and proceeds
with the final stages of system boot
- if root device has directory `/initrd`, Linux mounts the `initrd` filesystem
on this path, otherwise discarded

## Using `initramfs`

- conceptually similar to `initrd`
- enable loading of drivers that might be required before mounting the real (final)
root file system
- implementation details are much different between `initramfs` and `initrd`
- much easier to use than `initrd`
- `initramfs` is a CPIO archive that gets linked into the kernel image, `initrd`
is a gzipped file system image
- integrated into the Linux kernel source tree, and a small default image is
built automatically when you build the kernel image

### Customizing `initramfs`

Two options:
1. create a cpio archive with required files
2. specify a list of directories and files whose contents are merged with the
default created by `gen_initramfs_list.sh`

## Shutdown

- each embedded project typically has its own shutdown strategy
- typical Linux shutdown utilities: `shutdown`, `halt`, `reboot`
- a shutdown script should terminate all user space processes -> closing any
open files used by those processes
- with `init`, the command `init 0` halts the system
- the shutdown process first sends all processes the `SIGTERM` signal to notify
them that system is shutting down
- short delay ensures that all processes have the opportunity to perform shutdown
actions, such as closing files, saving stage, so on
- then all processes are sent the `SIGKILL` signal, which results in their
termination
- also unmount any mounted filesystems and call architecture-specific halt or
reboot routines

