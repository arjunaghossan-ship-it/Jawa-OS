@echo off
cls
echo ===================================================
echo     NEMBE NGOMPILASI OS BASA JAWA (BUILDING...)
echo ===================================================

:: Memastikan folder output 'hasil' dan 'iso_root' sudah tersedia
if not exist hasil mkdir hasil
if not exist iso_root mkdir iso_root

echo [1/6] Ngrakit Bootloader Grafis VGA...
nasm -f bin sumber/boot.asm -o hasil/boot.bin

echo [2/6] Ngrakit GDT 32-bit...
nasm -f elf32 sumber/gdt.asm -o hasil/gdt.o

echo [3/6] Ngompilasi Kernel UI C...
gcc -m32 -c sumber/kernel.c -o hasil/kernel.o -ffreestanding -O2 -Wall -Wextra

echo [4/6] Nyambungake File (Linking)...
ld -m elf_i386 -T Linker.id -o hasil/kernel.bin hasil/gdt.o hasil/kernel.o --oformat binary

echo [5/6] Nggabungake dadi Image Disk Mentah...
copy /b hasil\boot.bin+hasil\kernel.bin hasil\os_jawa.img

echo [6/6] Nembe Bungkus dadi File ISO Bootable...
:: Salin file image disk mentah ke folder root ISO
copy hasil\os_jawa.img iso_root\os_jawa.img

:: Proses cetak file ISO menggunakan perkakas mkisofs
mkisofs -R -b os_jawa.img -no-emul-boot -boot-load-size 4 -o hasil/jawa_os.iso iso_root

echo ===================================================
echo     SUKSES! File 'hasil/jawa_os.iso' sampun siyap.
echo     Nembe nglakokake QEMU Mode Grafis VGA...
echo ===================================================
qemu-system-i386 -cdrom hasil/jawa_os.iso -vga std
