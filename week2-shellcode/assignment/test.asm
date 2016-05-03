bits 32
%include "include/all.asm"
global main
section .text
main:
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	
	push eax
	push byte `a`
	mov ecx, esp
	mov dl, 1
    mov bl, STD_OUT
    mov al, SYS_write 
    int 0x80 ; print the letter

alphaloop:
	cmp byte[ecx], 'z'
	je exit
	; increment the letter
	add byte [esp], 1

    mov dl, 1
    mov bl, STD_OUT
    mov al, SYS_write 
    int 0x80 ; print the letter

    jmp alphaloop
	
	

exit:
	mov     bl, 1 ; Exit code
	mov     al, SYS_exit ; SYS_EXIT
	int     0x80