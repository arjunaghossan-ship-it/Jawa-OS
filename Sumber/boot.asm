[bits 32]
section .multiboot
align 4
    dd 0x1BADB002
    dd 0x00
    dd -(0x1BADB002 + 0x00)
section .text
global _start
extern _kernel_main
_start:
    cli
    mov esp, stack_top
    call _kernel_main
.hang:
    hlt
    jmp .hang
section .bss
stack_bottom:
    resb 16384
stack_top: