# GDB

GDB is a popular debugger to understand what is going on inside another program
while it executes.

## Useful Commands

- start debug elf file output with:

```bash
gdb <elf-file>
```

- run application with:

```bash
run
```

- run application with cmd arguments:

```bash
run a b c
```

- breakpoint:

```bash
break <filename>:<linenumber>
```

- hardware breakpoint:

```bash
hbreak <func_name>
```

- print register contents:

```bash
info registers
```

- continue: go to next breakpoint
- step: single-step through instructions
- next: single-step but don't go inside of function calls
- bt: backtrace will list current stack
- layout asm: create an assembler level view
- stepi, nexti: the assembly-level equivalent to step and next

## Task

The `factorial.c` program uses the first command line argument as the number to
calculate the factorial from. Use GDB to debug this program with the following
commands:

- calculate the program with the `-g` flag:

```bash
gcc -g factorial.c -o factorial
```

- debug the program:

```bash
gdb factorial
...
(gdb) layout asm
(gdb) break factorial.c:12 # or break printf
(gdb) run 5 # calculate factorial of 5, will break at printf
(gdb) ...
```

