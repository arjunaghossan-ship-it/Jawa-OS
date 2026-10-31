<p align="center">
  <img src="https://img.shields.io/badge/JawaOS-v0.1%20BETA-brown?style=for-the-badge&logo=linux&logoColor=white" />
  <img src="https://img.shields.io/badge/Arch-i386%20%7C%2032--bit-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Build-UCRT64%20%7C%20MSYS2-00A6ED?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Platform-QEMU-red?style=for-the-badge" />
</p>

<h1 align="center">🇮🇩 JawaOS - A Javanese Inspired Operating System</h1>

<p align="center">
  <i>"Alon-alon waton kelakon" - Slowly but surely, it will be done</i><br>
  An experimental 32-bit OS from Binong, Banten, Indonesia. No Hyper-V needed.
</p>

<p align="center">
  <a href="https://hub.xerj.org/contributors/arjunaghossan-ship-it">
    <img src="https://hub.xerj.org/contributors/arjunaghossan-ship-it/badge.svg" alt="XERJ Corpus Hub contributor" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/arjunaghossan-ship-it/Jawa-OS"><img src="https://img.shields.io/github/stars/arjunaghossan-ship-it/Jawa-OS?style=social" /></a>
  <img src="https://img.shields.io/badge/Made%20in-Banten,%20Indonesia-red" />
</p>

---

### ✨ Features

- [x] **Multiboot Bootloader** (`boot.asm`) - GRUB compatible
- [x] **GDT** (`gdt.asm`) - Global Descriptor Table
- [x] **Freestanding C Kernel** (`kernel.c`) - No stdlib
- [x] **Embedded Python GUI** (`GUI/gui.py`) - Loaded as rodata
- [ ] JFS - Javanese File System
- [ ] Wayang Desktop Environment
- [ ] PS/2 Keyboard Driver

### 📁 Project Structure

```
JawaOS/
├── .gitignore
├── README.md
├── images/
│   └── screenshot.png
└── source/
    ├── boot.asm
    ├── gdt.asm
    ├── kernel.c
    ├── linker.ld
    ├── Makefile
    └── GUI/
        ├── gui.c
        └── gui.py
```

### 🛠️ Prerequisites

1. Install **MSYS2** from https://www.msys2.org/
2. Open **MSYS2 UCRT64** (blue icon)

```bash
pacman -Syu
pacman -S --needed mingw-w64-ucrt-x86_64-nasm mingw-w64-ucrt-x86_64-qemu mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-binutils make git
```

### 🚀 Build & Run

```bash
git clone https://github.com/arjunaghossan-ship-it/JawaOS.git
cd JawaOS/source
make clean
make run
```

### 🔧 Commands

| Command | Description |
| :--- | :--- |
| `make` | Build kernel only |
| `make run` | Build + Run in QEMU with `-accel tcg` |
| `make clean` | Remove .o and .bin files |

### ❓ Troubleshooting

**`make: *** No rule to make target 'boot.asm'`**
```bash
# you are in root, must enter source/
cd source
make run
```

**`missing separator`**
Makefile must use TAB, not spaces. Recreate Makefile with TAB indentation.

**`Linker.ld: No such file`**
```bash
mv Linker.ld linker.ld
```

### 🗺️ Roadmap

- v0.2 - Keyboard & Javanese Shell (`ls` -> `deloken`)
- v0.3 - Simple File System (JFS)
- v0.4 - Wayang GUI

### 🙏 Acknowledgments

- [![XERJ Corpus Hub contributor](https://hub.xerj.org/contributors/arjunaghossan-ship-it/badge.svg)](https://hub.xerj.org/contributors/arjunaghossan-ship-it) - JawaOS is indexed in XERJ Corpus Hub as AI reference

### 📜 License

MIT - Free to fork.

---
<p align="center">Built in Bonang, Banten, Indonesia</p>
