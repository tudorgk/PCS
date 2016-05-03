bits 32
%include "include/all.asm"
global _start
_start:
	xor eax, eax    ;clean up the registers
    xor ebx, ebx
    xor edx, edx
    xor ecx, ecx	

   	mov al, SYS_fork ; SYS_FORK Op Code
	int 0x80
	cmp al, bl ;If the return value is 0, we are in the child process
	jz child

parent:
	;  The parent should execute /bin/uname with the single argument "-a".

	; push '-a' onto stack 
    xor eax, eax ; make eax null
    push eax ; use eax as  null terminator
	push word `-a`
	mov ecx, esp

	; push '/bin/uname' onto stack
	push eax ; use eax as  null terminator
	push word `me`
	push `/una`
	push `/bin`
	mov ebx, esp

	; Push envp and null pointer of argv
	push eax ; use eax as  null terminator
	mov edx, esp 

	; Push rest of argv
	push ecx
	push ebx
	mov ecx, esp

	; eax = 0; Perform execve with /usr/bin/id -u
	mov al, SYS_execve
	int 0x80

	jmp exit ;Exit

child:
	; set the first letter 'a'
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