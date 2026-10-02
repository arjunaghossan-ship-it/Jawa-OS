#!/bin/bash
mkdir -p build Hasil

echo "[1] ASM..."
nasm -f win32 Sumber/boot.asm -o build/boot.o

echo "[2] GCC..."
gcc -m32 -c Sumber/kernel.c -o build/kernel.o -ffreestanding -fno-pie

echo "[3] LINK jadi PE dulu (memenuhi i386pe)..."
/usr/bin/ld.bfd.exe -m i386pe -T Linker.ld -o Hasil/kernel.pe build/boot.o build/kernel.o

echo "[4] Convert PE -> ELF ben QEMU gelem..."
/usr/bin/objcopy.exe -O elf32-i386 Hasil/kernel.pe Hasil/kernel.elf

ls -lh Hasil/
echo "Cek..."
file Hasil/kernel.elf
qemu-system-i386 -kernel Hasil/kernel.elf