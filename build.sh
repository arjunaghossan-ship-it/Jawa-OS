#!/bin/bash
set -e
mkdir -p build

echo "[1] ASM..."
nasm -f elf32 Sumber/boot.asm -o build/boot.o

echo "[2] CC..."
gcc -m32 -march=i386 -ffreestanding -fno-pic -fno-stack-protector -c Sumber/kernel.c -o build/kernel.o -nostdlib -O0

echo "[3] LD PE..."
/ucrt64/bin/ld.exe -m i386pe -T Sumber/linker.ld -o kernel.pe build/boot.o build/kernel.o -nostdlib -e _start --image-base 0x100000

echo "[4] PE -> ELF..."
/ucrt64/bin/objcopy.exe -I pe-i386 -O elf32-i386 kernel.pe kernel.elf

echo "[SUKSES]"