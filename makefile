NASM := nasm
GCC  := gcc
LD   := ld
QEMU := qemu-system-i386

BUILD := build

STAGE1 := $(BUILD)/stage1.bin
STAGE2 := $(BUILD)/stage2.bin
DISK   := $(BUILD)/disk.img

STAGE2_OBJ := $(BUILD)/stage2.o
BOOT_OBJ   := $(BUILD)/boot.o
VGA_OBJ    := $(BUILD)/vga.o

all: $(DISK)

$(BUILD):
	mkdir -p $(BUILD)

$(STAGE1): stage1.S | $(BUILD)
	$(NASM) -f bin $< -o $@

$(STAGE2_OBJ): stage2.S | $(BUILD)
	$(NASM) -f elf32 $< -o $@

$(BOOT_OBJ): boot/boot.c | $(BUILD)
	$(GCC) -m32 -march=i386 \
		-ffreestanding \
		-fno-pie \
		-fno-stack-protector \
		-fno-builtin \
		-nostdlib \
		-nodefaultlibs \
		-c $< -o $@

$(VGA_OBJ): buffers/vga.c | $(BUILD)
	$(GCC) -m32 -march=i386 \
		-ffreestanding \
		-fno-pie \
		-fno-stack-protector \
		-fno-builtin \
		-nostdlib \
		-nodefaultlibs \
		-c $< -o $@

$(STAGE2): $(STAGE2_OBJ) $(BOOT_OBJ) $(VGA_OBJ)
	$(LD) -m elf_i386 \
		-Ttext 0x10000 \
		-e stage2 \
		--oformat binary \
		$^ -o $@

$(DISK): $(STAGE1) $(STAGE2)
	cat $(STAGE1) $(STAGE2) > $(DISK)

run: $(DISK)
	$(QEMU) -drive format=raw,file=$(DISK) -net none

clean:
	rm -rf $(BUILD)

.PHONY: all run clean