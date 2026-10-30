<p align="center">
  <img src="https://img.shields.io/badge/JawaOS-v0.1%20BETA-brown?style=for-the-badge&logo=linux&logoColor=white" />
  <img src="https://img.shields.io/badge/Arch-i386%20%7C%2032--bit-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Build-UCRT64%20%7C%20MSYS2-00A6ED?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Platform-QEMU-red?style=for-the-badge" />
</p>

# JawaOS - A Javanese Inspired Operating System

> "Alon-alon waton kelakon" - A simple 32-bit OS from Bonang, Banten, Indonesia.

JawaOS is an experimental 32-bit operating system that runs on QEMU. Built with MSYS2 UCRT64, no Hyper-V required - perfect for legacy HP Pavilion laptops.

### Features

- [x] **Multiboot Bootloader** (`boot.asm`) - GRUB compatible
- [x] **GDT** (`gdt.asm`) - Global Descriptor Table to prevent triple faults
- [x] **Freestanding C Kernel** (`kernel.c`) - No stdlib
- [x] **Embedded Python GUI** (`gui.py`) - Loaded as rodata into kernel
- [ ] JFS - Javanese File System
- [ ] Wayang Desktop Environment
- [ ] PS/2 Keyboard Driver

### Project Structure

```
JawaOS/
├── .gitignore
├── README.md
└── source/
    ├── boot.asm
    ├── gdt.asm
    ├── linker.ld
    ├── Makefile
    ├── kernel.c
    └── GUI/
        ├── gui.c
        └── gui.py
```

### Prerequisites

Install **MSYS2** from https://www.msys2.org/, then open **MSYS2 UCRT64** (blue icon).

```bash
pacman -Syu
pacman -S --needed mingw-w64-ucrt-x86_64-nasm mingw-w64-ucrt-x86_64-qemu mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-binutils make git
```

### Build & Run

```bash
git clone https://github.com/arjunaghossan-ship-it/JawaOS.git
cd JawaOS/source
make clean
make run
```

If successful, QEMU window will appear with JawaOS booted.

### Makefile Commands

| Command | Description |
| :--- | :--- |
| `make` | Build kernel only |
| `make run` | Build and run in QEMU |
| `make clean` | Remove .o and .bin files |

### Troubleshooting

**`make: *** No rule to make target 'boot.asm'`**
You are in the wrong directory. You must `cd source` first.

**`Linker.ld: No such file`**
Linux/MSYS2 is case-sensitive. Rename it:
```bash
mv Linker.ld linker.ld
```

**`GUI vs gui.py`**
Rename to lowercase:
```bash
mv GUI gui.py
```

**QEMU WHPX / Hyper-V Error**
This build already uses `-accel tcg` in Makefile, so Hyper-V is not required. Safe for locked F10 BIOS.

### Roadmap

- v0.2 - Keyboard input & Javanese Shell
- v0.3 - Simple File System
- v0.4 - Real Wayang GUI

### License

MIT - Free to fork.

---
<p align="center">Built with coffee in Bonang, Banten, Indonesia</p>
