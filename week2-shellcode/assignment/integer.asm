bits 32
%include "include/all.asm"
global main
section .text
print_integer:
    mov ecx, 10 ; divider
    mov edx, 0
    ;int3
    div ecx ; divided eax with ecx , result in ecx
    ;int3
    or edx, 0x30 ; convert remainder to ascii
    push edx	; push the remainder
    cmp eax, 0	; compare if eax is zero
    jnz print_integer  ; if not zero repeat
   	
   	;int3
   	mov edx, 16
	mov ecx, esp
	mov ebx, STD_OUT
	mov eax, SYS_write
	int 0x80 
    jmp exit 

main:
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx

    mov eax, 3421
    push byte 0
    jmp print_integer
    mov eax, 1 ; exit
    mov ebx, 0
    int 0x80

print:
	mov edx, 14
	push 0x68656c6c
	mov ecx, esp
	mov ebx, STD_OUT
	mov eax, SYS_write
	int 0x80             ; sys_write call
    
exit:
	mov     bl, 1 ; Exit code
	mov     al, SYS_exit ; SYS_EXIT
	int     0x80