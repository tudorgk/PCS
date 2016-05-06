bits 32
%include "include/all.asm"
global _start
_start:
	jmp message ; jump to message and push to get the address
proc:
	xor eax, eax    ;clean up the registers
    xor ebx, ebx
    xor edx, edx
    xor ecx, ecx

    ; write "Hello world!\n" to STD_OUT
	mov dl, 0xD
	pop ecx
    mov bl, STD_OUT
    mov al, SYS_write 
    int 0x80

    ; execute /usr/bin/wall with the single command line argument "hello".

  	; push 'hello' onto stack 
    xor eax, eax ; make eax null
    push eax ; use eax as  null terminator
	push byte `o`
	push `hell`
	mov ecx, esp

	; Push string
	push eax ; use eax as null terminator
	push byte `l`
	push `/wal`
	push `/bin`
	push `/usr`
	mov ebx, esp

	; Push envp and null pointer of argv
	push eax ; use eax as  null terminator
	mov edx, esp 

	; Push rest of argv
	push ecx
	push ebx
	mov ecx, esp

	; Perform execve with /usr/bin/id -u
	mov al, SYS_execve
	int 0x80

    ; exit
    xor eax, eax
    mov al, 0x01
    xor ebx, ebx
    mov bl, 0x01   ; return 1
    int 0x80

message:
	call proc ; push next address to the stack and jump back
    msg db "Hello world!", 10 
 