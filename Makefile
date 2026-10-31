CC=gcc
ASM=nasm
LD=ld

CFLAGS=-ffreestanding -nostdlib -fno-stack-protector -O2 -m32 -Wall
LDFLAGS=-T linker.ld -m elf_i386
KERNEL=kernel.bin

all: $(KERNEL)

boot.o: boot.asm
	nasm -f elf32 boot.asm -o boot.o

gdt.o: gdt.asm
	nasm -f elf32 gdt.asm -o gdt.o

gui.o: GUI/gui.py
	ld -r -b binary -o gui.o GUI/gui.py --oformat elf32-i386
	objcopy --rename-section .data=.rodata,alloc,load,readonly,data gui.o gui.o

kernel.o: kernel.c
	gcc -ffreestanding -nostdlib -fno-stack-protector -O2 -m32 -c kernel.c -o kernel.o

$(KERNEL): boot.o gdt.o kernel.o gui.o
	ld -T linker.ld -m elf_i386 -o $(KERNEL) boot.o gdt.o kernel.o gui.o

run: $(KERNEL)
	qemu-system-i386 -kernel $(KERNEL) -m 512M -accel tcg -vga std

clean:
	rm -f *.o *.bin
