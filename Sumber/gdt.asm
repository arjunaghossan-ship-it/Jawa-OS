[bits 16]
[org 0x7C00]

mulai_gdt_setup:
    cli
    lgdt [penunjuk_gdt]

    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    jmp KODE_SEGMENT:inisialisasi_pm ; HAPUS dword nya!

[bits 32]
inisialisasi_pm:
    mov ax, DATA_SEGMENT
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    ; Buat test dulu, jangan langsung call 0x1000
    ; Cetak huruf P (Protected) putih di pojok kiri atas
    mov byte [0xB8000], 'P'
    mov byte [0xB8001], 0x0F
    mov byte [0xB8002], 'M'
    mov byte [0xB8003], 0x0F

    jmp $

; --- GDT ---
alamat_gdt:
    dd 0x0, 0x0
    dw 0xFFFF, 0x0
    db 0x0, 10011010b, 11001111b, 0x0
    dw 0xFFFF, 0x0
    db 0x0, 10010010b, 11001111b, 0x0
alamat_gdt_pungkasan:

penunjuk_gdt:
    dw alamat_gdt_pungkasan - alamat_gdt - 1
    dd alamat_gdt

KODE_SEGMENT equ 0x08
DATA_SEGMENT equ 0x10

times 510-($-$$) db 0
dw 0xAA55