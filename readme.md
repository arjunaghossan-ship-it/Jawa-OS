# JawaOS - OS e Wong Jowo

+----------------+      gcc/nasm     +---------------+        ld + linker.ld       +----------------+   grub-mkrescue    +-------------+
| Sumber/        |  --------------> | build/        |  ------------------------> | build/         |  --------------> | JawaOS.iso  |
|  - boot.asm    |                  |  - boot.o     |                           |  kernel.elf    |                  |  (CD Image) |
|  - kernel.c    |                  |  - kernel.o   |                           |  (Otak OS)     |                  +------+------+ 
|  - panic.h     |                  +---------------+                           +----------------+                         |
+----------------+                                                                                                        | QEMU
                                                                                                                         v
                                                                                                                  [JawaOS MLAKU!]

OS soko nol nganggo Assembly

### 💻Cara Mlakune
sudo apt install nasm qemu-system-x86_64 make -y

nasm -f bin boot.asm -o boot.bin

qemu-system-x86_64 boot.bin

