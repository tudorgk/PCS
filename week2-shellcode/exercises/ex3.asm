bits 32
%include "include/all.asm"
global main
section .text
main:
	mov edx, 14
	mov ecx, mystr
	mov ebx, STD_OUT
	mov eax, SYS_write
	int 0x80
	mov eax, 0

section .data
mystr: 
	db "Hello, world!", 10