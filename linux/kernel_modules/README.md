# Linux - Kernel Module Development

## Topics

- C
- Makefile
- Linux kernel module
- `/proc` filesystem

## Context

In this section I want to demonstrate how to develop Linux kernel modules and
use the `/proc` filesystem. Linux kernel modules can be loaded/unloaded
dynamically at runtime (not considering kernel lockdown). Kernel modules are
specifically interesting for driver development. But beware, you're running in
kernel mode. If your code contains bugs, this can crash the entire system.

## Task

Develop a Linux kernel module that creates a read/write `/proc` entry. Writing
to the write `/proc` entry shall overwrite a string buffer. When reading from
the `/proc` entry the latest value that was written to the string buffer will
be returned. Make sure that everything is deallocated appropriately when
removing the kernel submodule.

## Build Instructions

- build the project:

```bash
make
```

- clean the project:

```bash
make clean
```

## Test Instructions

- execute all tests:

```bash
./test.sh
```

The test suite checks whether a `/proc` entry is created and whether the
read/write operations to the `/proc` entry work as expected.

## Usage

- load the kernel module:

```bash
sudo insmod hello.ko
```

-> check if `proc/hello` file exists

- unload kernel module:

```bash
sudo rmmod hello.ko
```

- write to `/proc` entry:

```bash
echo "hello" > /proc/hello
```

- read from `/proc` entry:

```bash
head -c 10 /proc/entry
```

## Resources

- [Website 1](https://tuxthink.blogspot.com/2011/02/creating-readwrite-proc-entry.html)
- [Website 2](https://gist.github.com/BrotherJing/c9c5ffdc9954d998d1336711fa3a6480)

