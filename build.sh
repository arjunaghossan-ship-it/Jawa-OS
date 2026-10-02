#!/bin/bash
set -e
echo "[1] ASM..."
nasm -f win32 Sumber/boot.asm -o boot.o
echo "[2] CC..."
gcc -m32 -c Sumber/kernel.c -o kernel.o -ffreestanding -nostdlib -O2 -fno-pie
echo "[3] LD PE..."
ld -m i386pe -T linker.ld -o kernel.pe boot.o kernel.o
echo "[4] PE -> ELF..."
objcopy -O elf32-i386 kernel.pe kernel.elf
echo "[5] RUN..."
qemu-system-i386 -kernel kernel.elf