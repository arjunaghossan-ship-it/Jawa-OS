# JawaOS - OS e Wong Jowo                                                                                                    

OS soko nol nganggo Assembly

### 💻Cara Mlakune
```
# install qemu dulu
sudo apt install nasm qemu-system-x86_64 make -y

# Compile dulu boot.asm nya
nasm -f bin boot.asm -o boot.bin

# Baru jalanin
qemu-system-x86_64 boot.bin```


## Cara Nge-build JawaOS

```b

# clone dulu
git clone https://github.com/username/JawaOS.git
cd JawaOS

# build iso nya
make

# jalanin di qemu
make run

# bersihin build
make clean
```

