bits 32
%include "include/all.asm"
global _start
_start:
	jmp message ; jumo to message and push
proc:
	xor eax, eax
    mov al, 0x04
    xor ebx, ebx
    mov bl, 0x01
    pop ecx
    xor edx, edx
    mov dl, 0x16
    int 0x80

    xor eax, eax
    mov al, 0x01
    xor ebx, ebx
    mov bl, 0x2A   ; return 1
    int 0x80

message:
	call proc
    msg db "goodbye", 10