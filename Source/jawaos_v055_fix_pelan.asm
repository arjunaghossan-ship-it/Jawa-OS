[bits 16]
org 0x7C00
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; KILL 1: BIOS - mateni blink cepet
    mov ax, 0x1003
    mov bl, 0
    int 0x10

    mov ah, 0x02
    mov al, 20
    mov ch, 0
    mov cl, 2
    mov dh, 0
    xor bx, bx
    mov es, bx
    mov bx, 0x7E00
    int 0x13
    jc $

    in al, 0x92
    or al, 2
    out 0x92, al
    lgdt [gdt_desc]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 0x08:pm

[bits 32]
pm:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000

    ; KILL 2: VGA PORT - mateni blink pelan langsung
    mov dx, 0x3DA
    in al, dx          ; reset flip-flop
    mov dx, 0x3C0
    mov al, 0x10        ; Mode Control register
    out dx, al
    mov al, 0x0C        ; 0x0C = no blink, enable line graphics
    out dx, al

    ; KILL 3: Mateni cursor hardware total
    mov dx, 0x3D4
    mov al, 0x0A
    out dx, al
    inc dx
    mov al, 0x20
    out dx, al
    dec dx
    mov al, 0x0B
    out dx, al
    inc dx
    mov al, 0x20
    out dx, al

    jmp 0x7E00

gdt_start:
    dq 0
    dq 0x00CF9A000000FFFF
    dq 0x00CF92000000FFFF
gdt_end:
gdt_desc: dw gdt_end - gdt_start -1
    dd gdt_start
times 510-($-$$) db 0
dw 0xAA55

[bits 32]
kmain:
    mov edi, 0xB8000
    mov ecx, 2000
    mov ax, 0x0700      ; 0x07 = putih, bukan 0x0A ijo sing bikin blink pelan
    rep stosw
    mov word [cursor], 0
    mov esi, welcome
    call print
shell:
    mov esi, prompt
    call print
    mov byte [buf_pos],0
.lp: hlt
    call get_key
    or al,al
    jz .lp
    cmp al,13
    je .ent
    cmp al,8
    je .bs
    cmp byte [buf_pos],80
    jae .lp
    movzx ebx,byte [buf_pos]
    mov [input_buf+ebx],al
    inc byte [buf_pos]
    call putc
    jmp .lp
.bs: cmp byte [buf_pos],0
    je .lp
    dec byte [buf_pos]
    dec word [cursor]
    movzx edi,word [cursor]
    shl edi,1
    add edi,0xB8000
    mov word [edi],0x0700
    jmp .lp
.ent:
    movzx ebx,byte [buf_pos]
    mov byte [input_buf+ebx],0
    call newline
    cmp byte [buf_pos],0
    je shell
    mov esi,input_buf
    mov edi,c_help
    call streq
    jz .h
    mov esi,input_buf
    mov edi,c_clear
    call streq
    jz .c
    mov esi,msg_nf
    call print
    mov esi,input_buf
    call print
    call newline
    jmp shell
.h: mov esi,t_help
    call print
    jmp shell
.c: mov edi,0xB8000
    mov ecx,2000
    mov ax,0x0700
    rep stosw
    mov word [cursor],0
    mov esi,welcome
    call print
    jmp shell

putc: mov ah,0x07       ; PUTIH SOLID, ANTI BLINK PELAN
    movzx edi,word [cursor]
    shl edi,1
    add edi,0xB8000
    mov [edi],ax
    inc word [cursor]
    cmp word [cursor],2000
    jb .r
    call scroll
.r: ret
print: lodsb
    or al,al
    jz .r
    cmp al,10
    je newline
    call putc
    jmp print
.r: ret
newline:
    mov ax,[cursor]
    mov bl,80
    div bl
    inc al
    xor ah,ah
    mov bl,80
    mul bl
    mov [cursor],ax
    cmp word [cursor],2000
    jb .r
    call scroll
.r: ret
scroll:
    mov esi,0xB80A0
    mov edi,0xB8000
    mov ecx,1920
    rep movsw
    mov edi,0xB8F00
    mov ecx,80
    mov ax,0x0700
    rep stosw
    mov word [cursor],1920
    ret
get_key:
    in al,0x64
    test al,1
    jz .n
    in al,0x60
    cmp al,0x80
    jae .n
    movzx ebx,al
    mov al,[keymap+ebx]
    ret
.n: xor al,al
    ret
streq:
    push esi
    push edi
.l: lodsb
    mov ah,[edi]
    inc edi
    cmp al,ah
    jne .nq
    or al,al
    jnz .l
    pop edi
    pop esi
    xor al,al
    ret
.nq: pop edi
    pop esi
    mov al,1
    ret
cursor: dw 0
buf_pos: db 0
input_buf: times 128 db 0
welcome: db 'JawaOS v0.5.5 ANTI KEDIP TOTAL',10,'help clear',10,10,0
prompt: db 'jawaos@binong:~$ ',0
msg_nf: db 'not found: ',0
t_help: db 'help clear',10,10,0
c_help: db 'help',0
c_clear: db 'clear',0
keymap:
    db 0,0,'1','2','3','4','5','6','7','8','9','0','-','=',8
    db 0,'q','w','e','r','t','y','u','i','o','p','[',']',13,0
    db 'a','s','d','f','g','h','j','k','l','; ',"'",'`',0
    db '\','z','x','c','v','b','n','m',',','.','/',0,0,0,' '
    times 64 db 0
times 18432-($-$$) db 0
