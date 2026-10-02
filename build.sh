#!/bin/bash
mkdir -p build Hasil

echo "[1] ASM..."
nasm -f win32 Sumber/boot.asm -o build/boot.o

echo "[2] GCC..."
gcc -m32 -c Sumber/kernel.c -o build/kernel.o -ffreestanding -fno-pie

echo "[3] LINK PE -> ELF..."
/usr/bin/ld.bfd.exe -m i386pe -T Linker.ld -o Hasil/kernel.tmp --oformat elf32-i386 build/boot.o build/kernel.o

# CEK, nek sukses baru timpa
if [ -s Hasil/kernel.tmp ]; then
    mv Hasil/kernel.tmp Hasil/kernel.elf
    ls -lh Hasil/kernel.elf
    echo "SUKSES! Ukuran di atas kudu > 0"
    qemu-system-i386 -kernel Hasil/kernel.elf
else
    echo "LINK MASIH GAGAL! File lama tak jaga, ga tak hapus."
    rm -f Hasil/kernel.tmp
    ls -lh Hasil/
fi