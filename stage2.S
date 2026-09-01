bits 16
org 0x0000

mov ah, 0x0E
mov al, 'o'
int 0x10

jmp $

times 2048 - ($ - $$) db 0