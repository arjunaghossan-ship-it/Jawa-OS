cat > Makefile << 'ENDOFFILE'
CC=gcc
ASM=nasm
LD=ld

CFLAGS=-ffreestanding -nostdlib -fno-stack-protector -O2 -m32 -Wall
ASMFLAGS=-f elf32
LDFLAGS=-T linker.ld -m elf_i386

KERNEL=kernel.bin

all: $(KERNEL)

boot.o: boot.asm
	nasm -f elf32 boot.asm -o boot.o

gdt.o: gdt.asm
	nasm -f elf32 gdt.asm -o gdt.o

gui.o: GUI/gui.py
	ld -r -b binary -o gui.o GUI/gui.py --oformat elf32-i386
	objcopy --rename-section .data=.rodata.gui,contents,alloc,load,readonly,data gui.o

kernel.o: kernel.c
	gcc -ffreestanding -nostdlib -fno-stack-protector -O2 -m32 -c kernel.c -o kernel.o

$(KERNEL): boot.o gdt.o kernel.o gui.o
	ld -T linker.ld -m elf_i386 -o $(KERNEL) boot.o gdt.o kernel.o gui.o

run: $(KERNEL)
	qemu-system-i386 -kernel $(KERNEL) -m 512M -accel tcg -vga std

clean:
	rm -f *.o *.bin GUI/*.o
ENDOFFILE

# cek tab e bener pora
cat -A Makefile | head -20
# kudu metu ^I iku tanda TAB, nek spasi berarti salah

make clean
make run