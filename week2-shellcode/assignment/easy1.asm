bits 32
%include "include/all.asm"
global _start
_start:
	jmp message ; jumo to message and push
proc:
	xor eax, eax    ;clean up the registers
    xor ebx, ebx
    xor edx, edx
    xor ecx, ecx

    ; write Hello world!\n
	mov dl, 0xD
	pop ecx
    mov bl, STD_OUT
    mov al, SYS_write 
    int 0x80

    xor eax, eax
    mov al, 0x01
    xor ebx, ebx
    mov bl, 0x01   ; return 1
    int 0x80

message:
	call proc
    msg db "Hello world!", 10 
 