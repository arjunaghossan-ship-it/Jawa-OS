; ==============================================================================
; gdt.asm - Defenisi Global Descriptor Table (GDT) untuk Mode Proteksi 32-bit
; ==============================================================================

gdt_start:
    ; 1. Entri Pertama: Deskriptor Null (Wajib bernilai 8-byte berisi 0)
    gdt_null:
        dd 0x0          ; 4 byte pertama
        dd 0x0          ; 4 byte kedua

    ; 2. Entri Kedua: Deskriptor Segmen Kode (Code Segment Descriptor)
    ; Base = 0x0, Limit = 0xfffff
    ; Access Byte: 10011010b (Present, Privilege=0, Code, Executable, Readable)
    ; Flags      : 11001111b (Granularity=4KB, 32-bit)
    gdt_code:
        dw 0xffff       ; Limit (bit 0-15)
        dw 0x0          ; Base (bit 0-15)
        db 0x0          ; Base (bit 16-23)
        db 10011010b    ; Access byte
        db 11001111b    ; Flags (4 bit) + Limit (4 bit terakhir, bit 16-19)
        db 0x0          ; Base (bit 24-31)

    ; 3. Entri Ketiga: Deskriptor Data Segmen (Data Segment Descriptor)
    ; Sama seperti kode segmen, tetapi tipenya writable (bukan executable)
    ; Access Byte: 10010010b (Present, Privilege=0, Data, Writable)
    gdt_data:
        dw 0xffff       ; Limit (bit 0-15)
        dw 0x0          ; Base (bit 0-15)
        db 0x0          ; Base (bit 16-23)
        db 10010010b    ; Access byte
        db 11001111b    ; Flags (4 bit) + Limit (4 bit terakhir, bit 16-19)
        db 0x0          ; Base (bit 24-31)

gdt_end:

; 4. GDT Descriptor (GDTR) - Struktur data yang dimuat ke register CPU
gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Ukuran GDT (Limit), dikurangi 1 byte
    dd gdt_start                ; Alamat memori awal (Base) dari GDT

; 5. Konstanta Konstanta Segment Selector (Offset dari gdt_start)
; Konstanta ini akan dimasukkan ke register segmen (CS, DS, SS, dll.)
CODE_SEG equ gdt_code - gdt_start  ; Biasanya bernilai 0x08
DATA_SEG equ gdt_data - gdt_start  ; Biasanya bernilai 0x10
