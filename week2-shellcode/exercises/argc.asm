bits 32
%include "include/all.asm"
	mov eax, [ebp + 8]
	add eax, 0x30
	mov ah, `\n`
	push eax
	mov edx, 2
	mov ecx, esp
	mov ebx, STD_OUT
	mov eax, SYS_write
	int 0x80
	mov ebx, 0
	mov eax, SYS_exit
	int 0x80