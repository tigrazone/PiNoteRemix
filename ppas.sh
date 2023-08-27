#!/bin/sh
DoExitAsm ()
{ echo "An error occurred while assembling $1"; exit 1; }
DoExitLink ()
{ echo "An error occurred while linking $1"; exit 1; }
echo Linking /mnt/7F7408AC62D689EC/Sviluppo/PiNote/pinote
OFS=$IFS
IFS="
"
/usr/bin/ld.bfd -b elf64-x86-64 -m elf_x86_64  --dynamic-linker=/lib64/ld-linux-x86-64.so.2    -L. -o /mnt/7F7408AC62D689EC/Sviluppo/PiNote/pinote /mnt/7F7408AC62D689EC/Sviluppo/PiNote/link.res
if [ $? != 0 ]; then DoExitLink /mnt/7F7408AC62D689EC/Sviluppo/PiNote/pinote; fi
IFS=$OFS
