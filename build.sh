#!/bin/bash
echo "[JawaOS] Lagi nge-build lur..."

# Bikin folder build
mkdir -p build

# 1. Compile asm
nasm -f elf32 Sumber/boot.asm -o build/boot.o

# 2. Compile kernel
gcc -m32 -c Sumber/kernel.c -o build/kernel.o -ffreestanding -nostdlib

# 3. Link
ld -m elf_i386 -T linker.ld -o build/kernel.elf build/boot.o build/kernel.o

# 4. Bikin ISO
mkdir -p iso/boot/grub
cp build/kernel.elf iso/boot/
cp grub.cfg iso/boot/grub/
grub-mkrescue -o JawaOS.iso iso

echo "[SUKSES] JawaOS.iso dadi lur! Tinggal make run"