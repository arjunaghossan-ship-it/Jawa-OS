[bits 16]

mulai_gdt_setup:
    cli                         ; Matikan interrupt sementara
    lgdt [penunjuk_gdt]         ; Muat tabel GDT ke dalam prosesor
    
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax                ; Masuk Protected Mode 32-bit
    
    jmp KODE_SEGMENT:dword inisialisasi_pm

[bits 32]
inisialisasi_pm:
    mov ax, DATA_SEGMENT
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000            ; Set Stack Pointer 32-bit
    mov esp, ebp

    ; Format flat binary tidak mendukung simbol eksternal. main() harus
    ; ditempatkan pada alamat tetap oleh proses build.
    mov eax, MAIN_ADDRESS       ; Muat alamat absolut main() ke register
    call eax
    jmp $

; --- STRUKTUR TABEL GDT ---
alamat_gdt:
    dd 0x0, 0x0                 ; Null Descriptor
    
    ; Code Segment Descriptor
    dw 0xFFFF, 0x0
    db 0x0, 10011010b, 11001111b, 0x0

    ; Data Segment Descriptor
    dw 0xFFFF, 0x0
    db 0x0, 10010010b, 11001111b, 0x0
alamat_gdt_pungkasan:

penunjuk_gdt:
    dw alamat_gdt_pungkasan - alamat_gdt - 1
    dd alamat_gdt

KODE_SEGMENT equ 0x08
DATA_SEGMENT equ 0x10
MAIN_ADDRESS equ 0x1000
