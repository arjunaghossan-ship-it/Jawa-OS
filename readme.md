Sistem Operasi Gawean Dewe, Soko nol, Nganggo Assembly & C

> "OS ne wong Jowo, Anti Ribet"
Lisence


### ⚜ Fitur Saiki
- [x] BootLoader 16-Bit (0x7c00)
- [x] Iso nge-print tulisan di layar
- [x] Iso ngetik keyboard (Disimpen neng 0x7d00)

### 💻 Cara Mlakune
**1. Sing dibutuhke (neng WSL Ubuntu)**
```bash
$Jokowie> sudo apt update
$Jokowie> sudo apt install nasm qemu-system-x86 make -y

make
# Utowo Manual
$Jokowie> nasm -f bin boot.asm -o boot.bin
$Jokowie> qemu-system-x86_64 boot.bin

### 🛠 Panggone RAM
0x7c00 - BootLoader mu
0x7d00 - Panggone nyimpen ketikan
0xB8000 - Memory Layar

Jawa OS/
|-- Build/
|-- .vscode/
|   |-- Task.json
|-- Hasil/
|   |-- boot.bin
|   |-- gdt.bin
|   |-- kernel.bin
|   |-- kernel.o
|-- iso_root/
|   |-- iso_jawa.img
|   |-- os_jawa.img
|   |-- Pembuat.txt
|-- Sumber/
|   |-- boot.asm
|   |-- gdt.asm
|   |-- iso_jawa.img
|   |-- Kernel.c
|-- build.bat
|-- License
|-- Linker.id
|-- readme.md

### 💡 Rencana Selanjutnya
Tahap Pengembanagan: Netepake Dhasar-dhasar Sistem  #Sekarang
v0.1: Iso Ngetik & Dibales
v0.2: Command Help, clear, echo -> versi jowo tulung, resik, bengok
v0.3: Kernel C + print lewat 0xB8000
v1.0: Filesystem JFS(Jawa Files System)

### 📜 Lisensi
MIT Lisence - Bebas dinggo, diutak-atik, didol, sing penting nyebut jenenge

🤝 Melu Ngewangi
Monggo PR! Sing jago OSDev ayo agbung.
make
