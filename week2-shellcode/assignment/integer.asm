bits 32
%include "include/all.asm"
global main
section .text
print_integer:
    mov ecx, 10 ; divider
    mov edx, 0
    div ecx ; divided eax with ecx , result in ecx
    or edx, 0x30 ; convert remainder to ascii
    push edx	; push the remainder
    cmp eax, 0	; compare if eax is zero
    jnz print_integer  ; if not zero repeat
   	
   	;print 
   	mov edx, 8 ; nr of bytes (because we pushed \0\0\0# for each digit)
	mov ecx, esp
	push ebx ; push to stack the ebx value
	mov ebx, STD_OUT
	mov eax, SYS_write
	int 0x80 

	; pop value back
	pop ebx
	dec ebx
	cmp ebx, 0
    jne start
    jmp exit

main:
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	mov ebx, 99    ; using ebx to store var

start:
    mov eax, ebx
    push byte 0
    jmp print_integer
    mov eax, 1 ; exit
    mov ebx, 0
    int 0x80
    
exit:
	mov     bl, 1 ; Exit code
	mov     al, SYS_exit ; SYS_EXIT
	int     0x80