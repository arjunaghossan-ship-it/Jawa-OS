[org 0x7c00]
[bits 16]
start:
 xor ax,ax
 mov ds,ax
 mov es,ax
 mov sp,0x7c00
 mov si,msg1
 call print
main:
 mov si,prompt
 call print
 mov di,buf
 call input
 mov si,buf
 mov di,c1
 call cmp
 je help
 mov di,c2
 call cmp
 je resik
 mov si,msg2
 call print
 jmp main
help:
 mov si,msg3
 call print
 jmp main
resik:
 mov ah,0
 mov al,3
 int 0x10
 mov si,msg1
 call print
 jmp main
print:
 lodsb
 or al,al
 jz.d
 mov ah,0x0e
 int 0x10
 jmp print
.d: ret
input:
 xor cx,cx
.l:
 mov ah,0
 int 0x16
 cmp al,13
 je.e
 cmp al,8
 je.b
 mov ah,0x0e
 int 0x10
 stosb
 inc cx
 jmp.l
.b:
 cmp cx,0
 je.l
 dec di
 dec cx
 mov ah,0x0e
 mov al,8
 int 0x10
 mov al,32
 int 0x10
 mov al,8
 int 0x10
 jmp.l
.e:
 mov byte [di],0
 mov si,nl
 call print
 ret
cmp:
 pusha
.l:
 mov al,[si]
 mov bl,[di]
 cmp al,bl
 jne.n
 cmp al,0
 je.y
 inc si
 inc di
