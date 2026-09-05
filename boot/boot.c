/*
 NexisLoader
 Handcrafted x86 Kernel Bootloader
 Independent project within the Nexis ecosystem
 Copyright (c) 2026 icarotelesdasilva
 Licensed under the MIT License
*/

extern void vga_print(char *str);
extern void vga_clear(void);

void NexisLoader(void)
{

vga_clear();
vga_print("NexisK Loader on");

    for (;;)
    {
    }
}
