# JawaOS - OS e Wong Jowo                                                                                                    

OS soko nol nganggo Assembly

### 💻Cara Mlakune
make run

sudo apt install nasm qemu-system-x86_64 make -y

nasm -f bin boot.asm -o boot.bin

qemu-system-x86_64 boot.bin

