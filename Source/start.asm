[bits 32]
org 0x7E00
_start:
    mov esp, 0x90000
    call kernel_start
    cli
.hang:  hlt
    jmp .hang
kernel_start:
