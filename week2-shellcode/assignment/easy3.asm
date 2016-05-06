bits 32
%include "include/all.asm"
global _start
_start:
	xor eax, eax    ;make all registers NULL
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
	mov bl, 99 

start:
	xor ecx, ecx
    mov eax, ebx
    push byte ecx
    jmp print_integer
    mov al, 1 ; exit
    xor ecx, ecx
    mov ebx, ecx
    int 0x80

print_integer:
    mov cl, 10 ; divider

    ; have to set the remainder 0 (set 1, then decrement)
    mov dl, 0x01 
    dec dl

    div ecx ; divide eax with ecx , result in ecx
    or edx, 0x30 ; convert remainder to ascii
    push edx	; push the remainder
    xor edx, edx ; set edx 0
    cmp eax, edx	; compare if eax is zero
    jnz print_integer  ; if not zero repeat
   	
   	;print 
   	mov dl, 8 ; nr of bytes (because we pushed \0\0\0digit for each digit)
	mov ecx, esp
	push ebx ; push to stack the ebx value
	mov bl, STD_OUT
	mov al, SYS_write
	int 0x80 

	; pop value back
	pop ebx
	dec ebx ;decrement the value
	xor ecx, ecx ; make ecx 0
	cmp ebx, ecx ; compare if our value has reached zero 
    jne start ; if not, go to start and print the number

exit:
	mov     bl, 1 ; Exit code
	mov     al, SYS_exit ; SYS_EXIT
	int     0x80