  .-------------------------------.
  |  PROACTIVE COMPUTER SECURITY  |
  |    Week 3: Reversing          |
  |      Exercises                |
  '-------------------------------'

= Ex. 1

First you should set up your GDB properly.  Make sure you have a file in your
home directory called `.gdbinit` with the following contents:

,---- .gdbinit --
| # Settings
| set disassembly-flavor intel
| set disable-randomization off
| set pagination off
| set follow-fork-mode child
|
| # History
| set history filename ~/.gdbhistory
| set history save
| set history expansion
|
| # Output format
| set output-radix 0x1
`----

Let's find out what those settings do.

Fire up GDB in a terminal:

  $ gdb
  ...
  (gdb)

Use the help command to read about each setting:

  (gdb) help set
  Evaluate expression EXP and assign result to variable VAR, using assignment
  syntax appropriate for the current language (VAR = EXP or VAR := EXP for
  example).  VAR may be a debugger "convenience" variable (names starting
  with $), a register (a few standard names starting with $), or an actual
  variable in the program being debugged.  EXP is any valid expression.
  Use "set variable" for variables with names identical to set subcommands.

  With a subcommand, this command modifies parts of the gdb environment.
  You can see these environment settings with the "show" command.

  List of set subcommands:

  set ada -- Prefix command for changing Ada-specfic settings
  set agent -- Set debugger's willingness to use agent as a helper
  ...

You can get more detailed information about a command by writing `help set
<command>`:

  (gdb) help set pagination
  Set state of GDB output pagination.
  When pagination is ON, GDB pauses at end of each screenful of
  its output and asks you whether to continue.
  Turning pagination off is an alternative to "set height unlimited".

For this exercise you should look up the settings that you don't know, or can't
guess what are doing.  In particular you should look up `follow-fork-mode`,
because that is a setting that you *don't* want for week 5.

Questions:
 1. What does the `follow-fork-mode` setting do?  What are valid options for it
    and in which cases might we prefer one over the other?  Discuss.
 2. What about `disable-randomization`?  Try Googling "ASLR" and "virtual
    memory".  Don't worry if it doesn't make complete sense; we'll work with
    ASLR later in the course.
 3. Type `help`.  Explore.

= Ex. 2

For this exercise you will run a shell with GDB attached.  Simply type:

  $ gdb sh
  ...
  (gdb)

Now GDB is started and has loaded the `sh` program, but it hasn't started it
yet.  Use the `run` command to execute the shell:

  (gdb) run
  Starting program: /bin/sh
  $

What happened?  Where did the GDB prompt go?  What happens if you type `ls`?
Can you explain the behavior?  Try pressing ^D (control+d) to send EOF to the
program.  What happens?

Now exit GDB and start it again, but instead of `run` try the command `start`.
What happens?

Questions:
 1. What is the difference between `run` and `start`.  Look them up with the
   `help` command.
 2. Can you combine the `run` and `break` commands to accomplish what `start`
    does?

= Ex. 3

We have seen how to start a program in GDB, but what if your program is already
running and you want to attach GDB to it?  Let's try attaching to a running
shell.  In a terminal (which is probably running Bash) start a new shell by
typing `sh`.  Now find the PID of your shell by typing `ps`:

  $ ps
    PID TTY          TIME CMD
      356 pts/1    00:00:00 sh
      358 pts/1    00:00:00 ps
      899 pts/1    00:00:00 bash

Your output may (and probably is) different.  In this case the PID of the shell
is 356.  Now, in another terminal start GDB and attach to the running shell:

  $ gdb sh 356
  0xf76914ee in read () from /lib/libc.so.6
  (gdb)

Now go back to the shell you just started and type `ls`.  What happens (or
doesn't happen)?  Explain.

Go back to GDB and type `continue` (or just the shorthand `c`).  See what
happens to your terminal.  Explain.

Finally try pressing ^C (control+c) in GDB and see what happens.

Exercises:
 1. Try attaching to a PID that doesn't exist.  What does GDB tell you?  Take
    note of the message; you might see it later, so it's good to know what it
    means.
 2. Try using the `pidof` program to find the PID of your shell.
 3. Use the GDB command `attach` to attach to a running program from inside GDB.
 4. Try attaching GDB to itself.

= Ex. 4

As you saw in exercise 2, programs that read and write to STDIN and STDOUT can
be annoying to debug with GDB.  The problem was partly solved in exercise 3 by
running the program in another terminal and attaching to it.  But what if you
want GDB attached from the start, but still have the debugee running in its own
terminal?  For that we have `gdbserver`.

Run `gdbserver` with no arguments and/or fire up your trusty friend Google to
learn about GDB server.

Fire up `sh` with a GDB server attached:

  $ gdbserver localhost:1337 sh
  Process sh created: pid = 2721
  Listening on port 1337

Now try connecting to the GDB server in another terminal:

  $ gdb
  ...
  (gdb) target remote localhost:1337
  0xf7fdaa90 in ?? () from target:/lib/ld-linux.so.2

Compare this output to what you saw when you attached GDB to a running shell.
Can you spot the difference?  Try continuing the shell (type `c`) and then
stopping it again (press ^C).  What do you see.

Questions:
 1. Why may we need to have GDB attached right from when a program is started?
    What's the alternative (i.e. what is the earliest point at which we can
    attach to an already running process)? Try writing a script or program which
    attaches to a process as early as possible.
 2. Apart from handling programs what read and write to STDIN and STDOUT, what
    else can GDB server be ued for.
 3. Read about the `set architecture` command.  Why is that relevant?

= Ex. 5

Here is a list of useful GDB commands:

 - ni: Go to the next instruction, but skipping over call instructions.
 - si: Step one instruction, possibly going into calls.
 - x/[n]fmt[size] addr: Examine memory.  The format can be o(octal), x(hex),
   d(decimal), u(unsigned decimal), t(binary), f(float), a(address),
   i(instruction), c(char) or s(string), and the size can be b(byte), h(2
   bytes), w(4 bytes) or g(giant, 8 bytes).
   Examples:
    - x/15i $pc
    - x/5s $esp
    - x/16xw $sp
    - x/s (*((char***)($ebp + 12)))[0]
 - disp/[n]fmt[size] addr: Same as x/ but shows memory each time GDB stops.
 - i r: Shows info about the registers.
 - b symb: Sets a breakpoint at symbol symb.
 - b *addr: Sets a breakpoint at the address addr. Examples: b *0xDECAFBAD, b
   *$ecx.
 - tb: Set a temporary breakpoint.

Read about each of them.  Try using them in a debugging session.

= Ex. 6

Write off the following C program:

,---- hello.c --
| #include <stdio.h>
| #include <stdlib.h>
| #include <unistd.h>
|
| int main(int argc, char *argv[]) {
|   int i;
|   char buf[512];
|
|   if (argc <= 1) {
|     printf("No arguments :'(\n");
|     return EXIT_FAILURE;
|   }
|
|   printf("Hello from %s\n", argv[0]);
|   printf("These are my arguments:\n");
|   for (i = 1; i < argc; i++) {
|     printf("  %d: %s\n", i, argv[i]);
|   }
|
|   return EXIT_SUCCESS;
| }
`----

And compile it with GCC:

  $ gcc -m32 hello.c -o hello

(The `-m32` may or may not be necessary.  Why/why not?)

Now inspect the program with readelf:

  $ readelf -a hello | less

How much of the output do you understand?  What about the rest?  Google and/or
your TA is your friend.

Now try disassembling your program with objdump:

  $ objdump -d -M intel hello > hello.txt

Take a look at the code.  Is it anything like what you expected?  Ask your TA
about the parts that you don't understand.

Finally, use GDB to debug your program.  Use the `--args` flag to pass command
line arguments to the program:

  $ gdb --args hello hi there

= Ex. 7

Write some GDB commands into a file.  F.x.:

,---- debug.gdb --
| disp/15i $pc
| disp/16xw $sp
| disp $eflags
| disp $ebp
| disp $edi
| disp $esi
| disp $edx
| disp $ecx
| disp $ebx
| disp $eax
`----

Now run your program from exercise 6 in GDB like this:

  $ gdb -ex start -x debug.gdb --args hello hi there

Now try single-stepping a few instructions with the `si` command (that you
looked up in exercise 5, right?).  What do you see?  Explain.

= Ex. 8

Now strip away symbols from your `hello` program:

  $ strip -s hello

Now repeat exercise 6 and 7.  What is different?

Question:
  1. What does the `-s` flag to strip do?
  2. Can you find `main`?  (Try breaking on `__libc_start_main` or disassemble
     the programs entry point.)

= Ex. 9

Copy the `demo` program from last week to your working directory and run these commands:

  $ echo -en "\xcc" > shellcode
  $ gdb --args demo shellcode
  ...
  (gdb) run

What do you see?  Did you just learn a neat trick?

= Ex. 10

Reverse engineer the program `mud`.  Or go solve some CTF challenges.  Have fun!
