  .-------------------------------.
  |  PROACTIVE COMPUTER SECURITY  |
  |    Week 5: Fuzzing            |
  |      Exercises                |
  '-------------------------------'

For this week exercises you are given two example programs, bmp2png
and wav2flac.

The program bmp2png converts images from BMP to PNG format, and the
program wav2flac converts audio files from WAVE to FLAC. Your task is
to find input files that will crash the programs.

Be sure to enable core dumps before you proceed:
  $ ulimit -c unlimited

This will result in a core file being produced in the event of a crash.

You should probably familiarize yourself with the BMP image format and
the WAVE audio format. Look it up on Wikipedia.


= Make your own

For each program write your own fuzzer that can produce an input file
which will crash the program.

That is, start by writing a program that can generate a valid BMP
picture and save that to a file, then do the same for WAVE files.


= Use zzuf

Use zzuf to find an input file which will crash the programs.


= Use American Fuzzing Lop

Use afl-fuzz to find input files which will crash the programs. The
binaries {bmp2png,wav2flac}-afl are compiled with afl instrumentation.


= Reflection

Now that you (might) have found several crashes, try to explain what
triggers a crash. Also, think about the strengths of the different
approaches.


Happy hunting!
