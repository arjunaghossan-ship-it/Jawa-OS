ENTRY(_start)
SECTIONS{ . = 0x7E00; .text : { *(.multiboot) *(.text) } .rodata : { *(.rodata) } .data : { *(.data) } .bss : { *(.bss) } }
