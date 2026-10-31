all: kernel.elf

boot.o: boot.asm
	nasm -f elf32 boot.asm -o boot.o

gdt.o: gdt.asm
	nasm -f elf32 gdt.asm -o gdt.o

kernel.o: kernel.c
	gcc -ffreestanding -nostdlib -fno-stack-protector -O2 -m32 -c kernel.c -o kernel.o

kernel.bin: boot.o gdt.o kernel.o linker.ld
	gcc -m32 -T linker.ld -o kernel.bin -ffreestanding -O2 -nostdlib -nostartfiles boot.o gdt.o kernel.o

kernel.elf: kernel.bin
	objcopy -I pei-i386 -O elf32-i386 kernel.bin kernel.elf 2> /dev/null || objcopy -O elf32-i386 kernel.bin kernel.elf

run: kernel.elf
	qemu-system-i386 -kernel ./kernel.elf -m 512M

clean:
	rm -f *.o kernel.bin
