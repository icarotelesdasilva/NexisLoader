bits 16
org 0x0000

stage2:
mov ax, 0x1000
mov ds, ax
mov si, message

loop:
mov al, [si]


cmp al, 0
je fim

mov ah, 0x0E
int 0x10

inc si

jmp loop


fim:
jmp fim

message db "Hello World!", 0

times 2048 - ($ - $$) db 0
