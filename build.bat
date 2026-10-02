@echo off
if not exist build mkdir build
if not exist Hasil mkdir Hasil

echo [1] ASM...
C:\msys64\ucrt64\bin\nasm.exe -f win32 Sumber/boot.asm -o build/boot.o
if errorlevel 1 goto error

echo [2] GCC...
C:\msys64\ucrt64\bin\gcc.exe -m32 -c Sumber/kernel.c -o build/kernel.o -ffreestanding -fno-pie
if errorlevel 1 goto error

echo [3] LINK...
C:\msys64\ucrt64\bin\ld.exe -m i386pe -T Linker.ld -o Hasil/kernel.elf build/boot.o build/kernel.o --oformat pei-i386
if errorlevel 1 goto error

echo [SUKSES] Hasil/kernel.elf dadi!
dir Hasil
goto end
:error
echo GAGAL!
:end