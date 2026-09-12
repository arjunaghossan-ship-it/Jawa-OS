[org 0x7c00]
BITS 16

start:
    ; 1. AMANAKAN DRIVE NUMBER SAKING BIOS
    mov [DRIVE_SISTEM], dl

    ; 2. INSIALISASI STACK POINTER
    xor ax, ax
    mov es, ax
    mov ds, ax
    mov ss, ax
    mov sp, 0x7C00

    ; 3. MUAT KERNEL & GDT SAKING DISK KE MEMORI (0x1000:0x0000)
    mov bx, 0x1000          
    mov es, bx
    xor bx, bx
    
    mov ah, 0x02            ; Fungsi BIOS: Moco Sektor Disk
    mov al, 20              ; Moco 20 sektor (GDT + Kernel C)
    mov ch, 0x00            ; Cylinder 0
    mov dh, 0x00            ; Head 0
    mov cl, 0x02            ; Mulai moco soko Sektor 2 (Tepat setelah bootloader)
    mov dl, [DRIVE_SISTEM]  
    int 0x13
    jc .disk_error          

    xor ax, ax
    mov es, ax

    ; 4. LOMPAT LANGSUNG KE KODE GDT (Diletakkan tepat di awal sektor ke-2 / memori 0x10000)
    jmp 0x1000:0000

.disk_error:
    mov si, pesen_disk_error
    call cetak_teks_16bit
    jmp $

cetak_teks_16bit:
    lodsb
    or al, al
    jz .rampung
    mov ah, 0x0e
    int 0x10
    jmp cetak_teks_16bit
.rampung:
    ret

DRIVE_SISTEM     db 0
pesen_disk_error db 'Eror: Gagal moco komponen saking disk!', 0x0D, 0x0A, 0

times 510-($-$$) db 0
dw 0xaa55
