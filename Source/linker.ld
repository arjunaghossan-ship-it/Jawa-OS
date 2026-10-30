/* JawaOS - Linker Script */
/* Atur alamat RAM ben gak tabrakan karo 0xFF0000 */

ENTRY(_start)

SECTIONS
{
    /* Kernel mulai di 1MB = 0x00100000, STANDAR MULTIBOOT */
    . = 0x00100000;

    .multiboot :
    {
        *(.multiboot)
    }

    .text :
    {
        *(.text)
    }

    .rodata :
    {
        *(.rodata)
        /* Embed gui.py jadi binary, nanti alamat e otomatis 0x01000000 ke atas */
        _binary_gui_py_start = .;
        *(.rodata.gui)
        _binary_gui_py_end = .;
    }

    .data :
    {
        *(.data)
    }

    .bss :
    {
        *(COMMON)
        *(.bss)
    }
}