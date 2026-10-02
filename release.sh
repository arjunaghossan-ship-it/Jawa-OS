#!/bin/bash
set -e
VER="v0.2-cli"
echo "[1] Build..."
nasm -f win32 Sumber/boot.asm -o boot.o
gcc -m32 -c Sumber/kernel.c -o kernel.o -ffreestanding -nostdlib -O2 -fno-pie
ld -m i386pe -T Sumber/linker.ld -o kernel.pe boot.o kernel.o
objcopy -O elf32-i386 kernel.pe kernel.elf

echo "[2] Release..."
mkdir -p release
cp kernel.elf release/
cp -r Sumber release/ 2>/dev/null || true
echo "JavaOS v0.2 CLI - Binong Banten" > release/README.txt
echo "Run: qemu-system-i386 -kernel kernel.elf" >> release/README.txt

cd release
# ganti baris zip dadi iki
tar -czf JavaOS-$VER.tar.gz kernel.elf Sumber/
echo "SELESAI"
ls -lh *.tar.gz
ls -lh kernel.elf