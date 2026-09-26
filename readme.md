# Jawa OS

**Sistem operasi cilik nganggo basa Jawa: dirakit saka nol nganggo Assembly lan C.**

Jawa OS is an experimental x86 hobby operating system. It starts in 16-bit real mode, sets up a 32-bit protected-mode environment, and draws a small desktop directly into VGA memory. Isih tahap sinau lan eksperimen; durung kanggo panggunaan saben dina.

## Sing Wis Bisa

- Boot nganggo bootloader 16-bit lan mlebu protected mode 32-bit.
- Ngganti VGA menyang mode 13h kanthi resolusi 320 × 200.
- Nglakokake kernel C freestanding kanggo nggambar desktop nganggo piksel.
- Ngrakit disk image lan ISO bootable liwat skrip Windows.

## Lelampahan Boot

```text
BIOS -> boot.asm -> GDT / protected mode -> kernel C -> desktop VGA
```

Kernel nggambar menyang framebuffer VGA ing alamat `0xA0000`. Bootloader lan GDT/kernel dimuat saka disk menyang memori sadurunge kontrol dipasrahake menyang `main()`.

## Mbangun lan Nglakokake

Build script saiki kanggo Windows. Siapna perkakas iki lan priksa kabeh wis bisa ditemokake liwat `PATH`:

- NASM
- GCC sing ndhukung target 32-bit (`-m32`)
- GNU `ld` kanthi dhukungan `elf_i386`
- `mkisofs`
- QEMU (`qemu-system-i386`)

Sawise perkakas siap, bukak terminal ing folder proyek banjur jalanake:

```bat
build.bat
```

Skrip ngrakit kernel, nggawe `Hasil/os_jawa.img` lan `Hasil/jawa_os.iso`, banjur nyoba mbukak ISO nganggo QEMU. Yen nggunakake VS Code, task **Mbangun OS Jawa** nglakokake skrip sing padha (`Ctrl+Shift+B`).

## Struktur Proyek

```text
.
|-- Sumber/
|   |-- boot.asm       # Bootloader 16-bit
|   |-- gdt.asm        # GDT lan transisi protected mode
|   `-- Kernel.c       # Gambar desktop VGA
|-- Linker.id          # Tata letak kernel ing memori
|-- build.bat          # Rakit, link, gawe ISO, lan jalanake QEMU
|-- Hasil/             # File asil build (ora dilebokake ing Git)
|-- iso_root/          # Isi kanggo proses nggawe ISO
`-- .vscode/           # Task build VS Code
```

## Peta Memori

| Alamat | Panggunaan |
| --- | --- |
| `0x7C00` | Bootloader sing dimuat BIOS |
| `0x10000` | GDT lan kernel sing dimuat saka disk |
| `0x90000` | Stack mode 32-bit |
| `0xA0000` | Framebuffer VGA mode 13h |

## Rencana

- [x] Bootloader lan transisi protected mode
- [x] Kernel C freestanding kanthi desktop VGA
- [ ] Input keyboard lan command prasaja: `tulung`, `resik`, `bengok`
- [ ] Ngrancang filesystem JFS (Jawa File System)

Iki proyek sinau sing isih owah. Yen nemokake bug utawa duwe gagasan, monggo gawe issue utawa pull request.

## Lisensi

MIT. Delengen [LICENSE](LICENSE).