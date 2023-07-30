# Process Monitoring

A process is an instance of a computer program that is being executed. Each
process is identified by a unique number called a process ID (PID). The
operating system manages processes with the help of the scheduler. To understand
what is going on in the system, it is important to understand how to monitor
processes.

## `ps`

The `ps` command reports a snapshot of the current processes. It basically
just displays information of currently active processes. To get a repetitive
update on the system state use `top`. The `ps` command in the end accepts
several different standards with UNIX (one-dash), BSD style (no dash) and GNU
long options (two-dashes).

## `top`

This program is pre-installed on all Linux distros and displays all Linux
processes. This way it provides a real-time view of a running system. It can
list all processes and threads currently being managed by the Linux kernel.

## `htop`

Is the newer command and adds color and gives a more interactive user interface
than `top`.

## `atop`

Yet another advanced system and process monitor. It views the load of a Linux
system by showing the occupation of the most critical hardware resources on
system level, i.e. cpu, memory, disk and network. It also shows which processes
are responsible for the indicated load.

## `lsof`

In Linux everything is a file. Therefore, the probability is high that processes
interact with files. The `lsof` command lists all open files belonging to all
active processes. To see all files for one specific process use `lsof -p <pid>`.
An open file may be a regular file, a directory, a block special file, a
character special file, a library, a stream or network file.

