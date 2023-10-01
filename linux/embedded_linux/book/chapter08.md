# Chapter 8: Device Driver Basics

## Device Driver Concepts

- device drivers isolate user programs from ready access to critical kernel data
structures and hardware devices
- a well-written device driver hides from the user the complexity and variability
of the hardware device
- a device driver provides a consistent user interface to a large variety of
hardware devices

### Loadable Modules

- Linux lets you dynamically add and remove kernel components at runtime on a
running kernel -> advantage: no need to reboot the kernel to test a device driver
module
- loadable modules enhance field upgrade capabilities since the module itself
can be updated in a live system without the need for a reboot
- device drivers can still be statically compiled into the kernel if needed
- Linux Kernel Module (LKM)

### Device Driver Architecture

Device drivers are broadly classified into:
- character devices: serial streams of sequential data, e.g. serial ports and
keyboards
- block devices: can read and write blocks of data to and from random locations
on an addressable medium, e.g. hard drives and USB flash drives

### Minimal Device Driver Example

```bash
#include <linux/module.h>

static int __init hello_init(void)
{
    printk(KERN_INFO “Hello Example Init\n”);
    return 0;
}

static void __exit hello_exit(void)
{
    printk(“Hello Example Exit\n”);
}

module_init(hello_init);
module_exit(hello_exit);

MODULE_AUTHOR(“Chris Hallinan”);
MODULE_DESCRIPTION(“Hello World Example”);
MODULE_LICENSE(“GPL”);
```

- a device driver module is a special kind of binary module, it can't be executed
from the command-line like a stand-alone binary executable application
- device driver module gets compiled into a special "kernel object" format
- device driver binary module ends with `.ko` suffix

### Module Build Infrastructure

- a device driver must be compiled against the kernel on which it will execute
- build the module within the kernel's own source tree
- note: how to build a device driver module might have changed and if needed I
have to look this up for a more modern kernel version

### Installing a Device Driver

- move device driver binary to `/lib/modules/<kernel-version>/...`
- beware for cross-compiling need to put it in the right location

### Loading a Module

- use `modprobe` or `insmod` to load and unload a device driver binary module

### Module Options

- `module_init(<function-name>)`: initialization function when kernel module is
loaded
- `module_exit(<function-name>)`: exit function when kernel module is unloaded
- `module_param(<var-name>,<var-type>,<default-value>)`: can be specified on
command line when using `insmod`:

```bash
static int debug_enable = 0;        /* Added driver parameter */
module_param(debug_enable, int, 0); /* and these 2 lines */
MODULE_PARM_DESC(debug_enable, “Enable module debug mode.”);
```

## Module Utilities

### `insmod`

- simple way to insert a module into a running kernel
- compared to `modprobe`, not able to determine and load any dependencies that
may be required for the module

### `lsmod`

- displays a formatted list of the modules that are inserted into the kernel
- simply formats the output of `/proc/modules`
- last column shows dependency to other modules

### `modprobe`

- the `modprobe` utility can discover the dependency relationship between modules
and load the dependent modules in the proper order
- can also be used to remove modules through `-r` option, also removes any
dependent kernel module
- utility is driven by configuration file called `modprobe.conf`
- `modprobe.conf` functionality has been mostly displaced by `udev`

### `depmod`

- used by `modprobe` to identify dependencies of a given module
- the `depmod` utility creates `modules.dep` automatically during kernel build
which tracks module-dependencies
- for cross-development, requires specific `depmod` version

### `rmmod`

- removes a module from a running kernel -> executes the modules `*_exit()`
function
- does not remove dependent modules (unlike `modprobe`)

### `modinfo`

- macros in module file to place tags in the binary module to facilitate their
administration and management
- easy way to get general information (also placed through the macros) about the
kernel module and the parameters that a module supports

## Driver Methods

### Driver File System Operations

- after loading the device driver into a live kernel, the driver must be
prepared for subsequent operations -> `open()` method is used for this purpose
- after opening the device, we need methods for reading and writing to the
driver
- `release()` routine will clean up after operations are complete
- `iotctl()` system call for nonstandard communication with the driver
- function name convention: `<module-name>_<function-name>`
- separate function call to register driver module with kernel in `<module-name>_init()`,
is passed a `struct file_operations`

### Device Nodes and `mknod`

- device node: a special file type in Linux that represents a device
- devices nodes are kept in `/dev`
- `mknod` utility creates a device node on a file system
- device node is just another file in our filesystem, but we use it to bind to
an installed device driver
- major number is used to associate a particular device to the device node
- minor number is used to handle multiple devices or subdevices with a single
device driver
- device node creation is typically handled automatically by `udev`

## Bringing it all together

- normal user space programs can now open a specific device node on the filesystem
and perform the typical filesystem operations to interact with the device driver

## Building Out-of-Tree Drivers

- typically it is convenient to build device drivers outside of the kernel
source tree and let makefiles take care of the necessary compilation

## Device Drivers and the GPL

- if device driver is based, even in part, on existing GPL software, it is
considered a derived work
- if you start with current Linux device driver and modify it, this is considered
derived work -> modified device driver must be licensed under the terms of GPL
- if driver does not assume "intimate knowledge" of the Linux kernel, the
developers are free to license it in any way they see fit
- if modification are made to the kernel to accommodate a special need of the
driver, it is considered a derived work -> subject to GPL

