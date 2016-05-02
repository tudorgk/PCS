bits 32
extern printf
global main
section .text
main:
	push mystr
	call printf
	add esp, 4
	mov eax, 0

section .data
mystr:
	db "Hello, world!", 10, 0