extern void vga_print(char *str);
extern void vga_clear(void);

void NexisLoader(void)
{
	vga_clear();
    vga_print("Bootloader on");

    for (;;)
    {
    }
}