bits 32
extern write
global main
section .text
main:
	push 14
	push mystr
	push 1
	call write
	add esp, 12
	mov eax, 0

section .data
mystr:
	db "Hello, world!", 10
