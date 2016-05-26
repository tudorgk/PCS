.PHONY: all clean

all: exploit

exploit: exploit.c shellcode.txt
	gcc -g -Wall -Werror -o $@ $<

shellcode.txt: shellcode
	hexdump -v -e '"\\""x" 1/1 "%02x" ""' shellcode >shellcode.txt

shellcode: shellcode.asm
	nasm shellcode.asm

clean:
	rm -f exploit shellcode.txt shellcode
