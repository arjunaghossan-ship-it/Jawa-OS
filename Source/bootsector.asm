[bits 16]
org 0x7C00
start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    mov [bootdrive], dl

    mov si, msg1
    call print

    ; TRY CHS READ ke 0x7E00
    mov ah, 0x02
    mov al, 15
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [bootdrive]
    mov bx, 0x7E00
    int 0x13
    jc fail

    mov si, msg2
    call print

    in al, 0x92
    or al, 2
    out 0x92, al
    lgdt [gdt_desc]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 0x08:protected

fail:
    mov si, msgFail
    call print
.halt: hlt
    jmp .halt

print:
    lodsb
    or al, al
    jz .ret
    mov ah, 0x0E
    int 0x10
    jmp print
.ret: ret

[bits 32]
protected:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000
    ; TULIS 'P' NENG VGA BUAT TANDA MASUK PROTECTED MODE
    mov byte [0xB8000], 'P'
    mov byte [0xB8001], 0x0A
    jmp 0x7E00

bootdrive: db 0
msg1: db '1-Boot...',13,10,0
msg2: db '2-Load OK! JMP...',13,10,0
msgFail: db 'FAIL!',0

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
