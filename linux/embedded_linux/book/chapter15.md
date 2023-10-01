# Chapter 15: Debugging Embedded Linux Applications

- basically how to debug application code in user space

## Target Debugging

- typical tools such as `strace`, `ltrace`, `dmalloc`, `ps` and `top` are
designed to run directly on the target hardware

## Remote (Cross) Debugging

- cross-development tools were developed primarily to overcome the resource
limitations of embedded platforms
- application with debug information can easily exceed several MBs
- pass cross version of GDB on development host an ELF file with symbolic
debug information and pass stripped ELF file without unnecessary debugging
information to the target -> keeps resulting image at minimum size
- use `gdbserver` on target board to provide an interface back to your development
host, where you run the full-blown version of GDB (your cross-gdb) on your
unstripped binary

### `gdbserver`

- allows you to run GDB from a development workstation rather than on the target
embedded Linux platform
- `gdbserver` is a small program that runs on the target board and allows remote
debugging of a process on the board
- invoked on the target board specifying the program to be debugged, as well as
IP address and port number on which it will listen for connecting requests from
GDB
- so basically start `gdbserver` on the target board, and connect with cross-version
of GDB to gdbserver on target by passing application program name
- then issue `target remote ...` command to inititate TCP/IP connection from your
development workstation to target board by specifying IP address and port number

## Debugging with Shared Libraries

- if application is not a statically linked executable, many symbols in your
application will reference code outside your application
- to have symbols from dynamically linked code, you must satisfy 2 requirements
for GDB:
    * You must have debug versions of the libraries available
    * GDB must know where to find them

### Shared Library Events in GDB

- GDB can alert you to shared library events -> `i shared` GDB command
- `set stop-on-solib-event` GDB command: when the application tries to execute
a function from another shared library, that library is loaded and we break
- `set solib-absolute-prefix` or `set solib-search-path` GDB command: you can
set or change where GDB searches for shared libraries

## Debugging Multiple Tasks

- two scenarios when dealing with multiple threads of execution:
    * independent processes not sharing common address space -> must be debugged
    using separate independent debug sessions
    * processes shared an address space with other threads of execution

### Debugging Multiple Processes

- when `fork()` syscall to spawn a new process, GDB can take two courses of action:
    * continue to control and debug the parent process
    * stop debugging the parent process and attach to the newly formed child
    process
- control this behavior through `set follow-fork-mode` command (mode 1: follow
parent (default), mode 2: follow child)
- scenario: if staying attached to parent and breakpoint is set for a child
process, then GDB will not break -> use `set follow-fork-mode child` before
setting a breakpoint of a child
- problem: you are limited to debugging a single process at a time -> must
spawn multiple independent GDB sessions when debugging more than one cooperating
process at a time

### Debugging Multithreaded Applications

- if application uses POSIX thread library for threading functions, GDB has
additional capabilities to handle concurrent debugging for a multithreaded
application
- Native POSIX Thread Library (NPTL) is the standard thread library in use on
Linux systems
- `i threads` command: gives information about all spawned threads of the
application
- `thread <x>` command: makes thread x the current thread

### Debugging Bootloader/Flash Code

- how are breakpoints inserted into an application: GDB replaces the opcode at
the breakpoint location with an architecture-specific opcode that passes control
to the debugger
- but in ROM or Flash, GDB cannot overwrite the opcode -> this method of setting
breakpoints does not work
- solution: hardware debug registers on modern processors -> use JTAG hardware
probes

## Additional Remote Debug Options

### Debugging Using a Serial Port

- additional serial port on target and host should not be used by another
process, e.g. serial console
- invoke `gdbserver` instead of `<ip-address>:<port-number>` with
`<serial-port-spec>`

### Attaching to a Running Process

- use `--attach <pid>` with `gdbserver`
- use `detach` command: `gdbserver` detaches from the application on the target
and terminates the debug session; the application continues where it left off

