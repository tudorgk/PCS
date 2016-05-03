bits 32
%include "include/all.asm"
global _start
_start:
	xor eax, eax    ;clean up the registers
    xor ebx, ebx
    xor edx, edx
    xor ecx, ecx
    
	mov bx, 42
	mov ax, SYS_exit
	int 0x80
	xor eax, eax