# JawaOS - OS Jawa Pertama 🇮🇩

OS eksperimental berbahasa Jawa, di-build dari nol pake C & Assembly.

> "Kernel Panic? Alah, Sistem e Error Cak!"

### ✨ Fitur
- [x] Bootloader GRUB
- [x] Pesan error full bahasa Jawa (`panic.h`)
- [x] 32-bit Protected Mode

### 📁 Struktur Folder
```
JawaOS/
├── Makefile
├── linker.ld
├── grub.cfg
└── Sumber/
    ├── boot.asm
    ├── kernel.c
    └── panic.h
```

### 🚀 Cara Build & Run

Pastikan udah install `gcc`, `nasm`, `qemu`, `grub-mkrescue`

```bash
# 1. Clone repo
git clone https://github.com/username-mu/JawaOS.git
cd JawaOS

# 2. Build jadi ISO
make

# 3. Jalanin di QEMU
make run

# 4. Bersih-bersih
make clean
```

### 🧠 Alur Build
`.c/.asm` -> `.o` -> `.elf` -> `.iso` -> QEMU

### 🤝 Kontribusi
Pull request welcome, lur!

---
Dibuat dengan kopi dan begadang oleh Arjuna
```

Udah ada tombol copy semua itu di Github nanti.

Tinggal ganti `username-mu` sama `Nama Mu` tok.

Mau tak tambahin badge keren kaya `Build Passing` juga?