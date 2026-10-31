[bits 16]
org 0x7C00
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    mov ah, 0x02
    mov al, 15
    mov ch, 0
    mov cl, 2
    mov dh, 0
    xor bx, bx
    mov es, bx
    mov bx, 0x7E00
    int 0x13
    jc fail
    in al, 0x92
    or al, 2
    out 0x92, al
    lgdt [gdt_desc]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 0x08:pm
fail:
    mov si, msgF
    mov ah, 0x0E
.l1: lodsb
    or al, al
    jz .h
    int 0x10
    jmp .l1
.h: hlt
    jmp .h

[bits 32]
pm:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000
    jmp 0x7E00

msgF: db 'FAIL',0
gdt_start:
    dq 0
    dq 0x00CF9A000000FFFF
    dq 0x00CF92000000FFFF
gdt_end:
gdt_desc:
    dw gdt_end - gdt_start -1
    dd gdt_start

times 510-($-$$) db 0
dw 0xAA55

; === KERNEL MULAI DI 0x7E00, GAK USAH ORG LAGI (udah di 0x7E00) ===
[bits 32]
kmain:
    mov edi, 0xB8000
    mov ecx, 2000
    mov ah, 0x07
    mov al, 0
.clear_loop:
    mov word [edi], ax
    add edi, 2
    loop .clear_loop

    mov edi, 0xB8000
    mov esi, txt
    mov ah, 0x0A
.print_loop:
    lodsb
    or al, al
    jz .halt
    cmp al, 10
    je .newline
    mov word [edi], ax
    add edi, 2
    jmp .print_loop
.newline:
    mov eax, edi
    sub eax, 0xB8000
    mov ebx, 160
    xor edx, edx
    div ebx
    inc eax
    mul ebx
    add eax, 0xB8000
    mov edi, eax
    jmp .print_loop
.halt:
    cli
    hlt
    jmp .halt

txt: db 'JawaOS v0.4 - Binong Edition',10,'jawaos@binong:~$ ',0

times 16384-($-$$) db 0
