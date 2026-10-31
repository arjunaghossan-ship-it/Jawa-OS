[bits 16]
org 0x7C00
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00
    mov ah, 0x02
    mov al, 20
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
fail: mov si, msgF
    mov ah, 0x0E
.l: lodsb
    or al, al
    jz .h
    int 0x10
    jmp .l
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

; =================== KERNEL V0.5 KEYBOARD ===================
[bits 32]
kmain:
    mov edi, 0xB8000
    mov ecx, 2000
    mov eax, 0x07200720 ; 2 spasi abu-abu
.cl: mov [edi], eax
    add edi, 4
    loop .cl

    mov dword [cursor], 0
    mov esi, welcome
    call print

shell_loop:
    mov esi, prompt
    call print
    mov byte [buf_pos], 0

.input:
    call get_key
    cmp al, 13
    je .enter
    cmp al, 8
    je .back
    cmp al, 0
    je .input
    ; cek buffer penuh?
    movzx ebx, byte [buf_pos]
    cmp bl, 100
    jae .input
    ; simpan ke buffer
    mov [input_buf + ebx], al
    inc byte [buf_pos]
    ; print char
    mov ah, 0x0A
    movzx edi, word [cursor]
    shl edi, 1
    add edi, 0xB8000
    mov [edi], ax
    inc word [cursor]
    call check_scroll
    jmp .input

.back:
    movzx ebx, byte [buf_pos]
    or bl, bl
    jz .input
    dec byte [buf_pos]
    dec word [cursor]
    movzx edi, word [cursor]
    shl edi, 1
    add edi, 0xB8000
    mov word [edi], 0x0700
    jmp .input

.enter:
    ; null terminate
    movzx ebx, byte [buf_pos]
    mov byte [input_buf + ebx], 0
    call newline

    ; cek command
    mov esi, input_buf
    mov edi, cmd_help
    call strcmp
    or al, al
    jz .do_help

    mov esi, input_buf
    mov edi, cmd_clear
    call strcmp
    or al, al
    jz .do_clear

    mov esi, input_buf
    mov edi, cmd_about
    call strcmp
    or al, al
    jz .do_about

    mov esi, input_buf
    mov edi, cmd_binong
    call strcmp
    or al, al
    jz .do_binong

    ; empty?
    mov al, [input_buf]
    or al, al
    jz shell_loop

    mov esi, msg_notfound
    call print
    mov esi, input_buf
    call print
    call newline
    jmp shell_loop

.do_help:
    mov esi, help_text
    call print
    jmp shell_loop
.do_clear:
    mov edi, 0xB8000
    mov ecx, 2000
    mov ax, 0x0700
.cl2: mov [edi], ax
    add edi, 2
    loop .cl2
    mov word [cursor], 0
    mov esi, welcome
    call print
    jmp shell_loop
.do_about:
    mov esi, about_text
    call print
    jmp shell_loop
.do_binong:
    mov esi, binong_art
    call print
    jmp shell_loop

; ========== FUNGSI ==========
print:
    lodsb
    or al, al
    jz .ret
    cmp al, 10
    je newline
    mov ah, 0x0A
    movzx edi, word [cursor]
    shl edi, 1
    add edi, 0xB8000
    mov [edi], ax
    inc word [cursor]
    call check_scroll
    jmp print
.ret: ret

newline:
    mov ax, [cursor]
    mov bl, 80
    div bl
    inc al
    mov ah, 0
    mov bl, 80
    mul bl
    mov [cursor], ax
    call check_scroll
    ret

check_scroll:
    cmp word [cursor], 2000
    jb .ret
    ; scroll up 1 line
    mov esi, 0xB80A0
    mov edi, 0xB8000
    mov ecx, 1920
    rep movsw
    mov edi, 0xB8F00
    mov ecx, 80
    mov ax, 0x0700
    rep stosw
    mov word [cursor], 1920
.ret: ret

get_key:
    in al, 0x64
    test al, 1
    jz get_key
    in al, 0x60
    cmp al, 0x80
    jae .no
    movzx ebx, al
    mov al, [keymap + ebx]
    ret
.no: xor al, al
    ret

strcmp:
    lodsb
    mov ah, [edi]
    inc edi
    cmp al, ah
    jne .neq
    or al, al
    jnz strcmp
    xor al, al
    ret
.neq: mov al, 1
    ret

; ========== DATA ==========
cursor: dw 0
buf_pos: db 0
input_buf: times 128 db 0

welcome: db 'JawaOS v0.5 - Binong Edition',10,'Ketik help buat bantuan',10,10,0
prompt: db 'jawaos@binong:~$ ',0
msg_notfound: db 'command not found: ',0
help_text: db 'Commands:',10,' help  - bantuan',10,' clear - bersih layar',10,' about - tentang',10,' binong - rahasia',10,10,0
about_text: db 'JawaOS by Lur Binong, Banten',10,'Built with NASM on MSYS2',10,'2026',10,10,0
binong_art: db '  ____  _                 ',10,' | __ )(_)_ __   ___  _ __   __ _',10,' |  _ \| | |_ \ / _ \| |_ \ / _` |',10,' | |_) | | | | | (_) | | | | (_| |',10,' |____/|_|_| |_|\___/|_| |_|\__, |',10,'                          |___/',10,10,0
cmd_help: db 'help',0
cmd_clear: db 'clear',0
cmd_about: db 'about',0
cmd_binong: db 'binong',0

keymap:
    db 0,0, '1','2','3','4','5','6','7','8','9','0','-','=',8
    db 0, 'q','w','e','r','t','y','u','i','o','p','[',']',13,0
    db 'a','s','d','f','g','h','j','k','l',';',"'" ,'`',0
    db '\','z','x','c','v','b','n','m',',','.','/',0,0,0,' '
    times 64 db 0

times 18432-($-$$) db 0
