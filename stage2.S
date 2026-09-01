bits 16

global stage2
extern NexisLoader

stage2:
    cli

    mov ax, 0x1000
    mov ds, ax

    lgdt [gdt_descriptor - stage2]
        
    mov eax, cr0
    or eax, 0x00000001
    mov cr0, eax

    jmp dword 0x08:protected_mode

bits 32

protected_mode:
    mov ax, 0x10

    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esp, 0x00090000

    call NexisLoader

halt:
    cli
    hlt
    jmp halt


align 4

gdt_start:

gdt_null:
    dq 0x0000000000000000

gdt_code:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00

gdt_data:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start