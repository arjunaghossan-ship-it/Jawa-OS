ASM=nasm
CC=gcc
LD=ld

ASMFLAGS=-f elf32
CFLAGS=-m32 -ffreestanding -fno-pie -nostdlib -nostartfiles -nodefaultlibs -Wall -Wextra
LDFLAGS=-m elf_i386 -T Linker.ld

SRC_DIR=Sumber
BUILD_DIR=build
HASIL_DIR=Hasil

ASM_SRC=$(wildcard $(SRC_DIR)/*.asm)
C_SRC=$(wildcard $(SRC_DIR)/*.c)

ASM_OBJ=$(patsubst $(SRC_DIR)/%.asm, $(BUILD_DIR)/%.o, $(ASM_SRC))
C_OBJ=$(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(C_SRC))

TARGET=$(HASIL_DIR)/kernel.elf
ISO=$(HASIL_DIR)/os_jawa.img

all: $(ISO)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm
	@mkdir -p $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET): $(ASM_OBJ) $(C_OBJ)
	@mkdir -p $(HASIL_DIR)
	$(LD) $(LDFLAGS) -o $@ $^

$(ISO): $(TARGET)
	@mkdir -p iso/boot/grub
	@cp $(TARGET) iso/boot/
	@echo 'menuentry "JawaOS" { multiboot /boot/kernel.elf }' > iso/boot/grub/grub.cfg
	grub-mkrescue -o $@ iso
	@echo "[SUKSES] $(ISO) dadi lur!"

clean:
	rm -rf $(BUILD_DIR) iso $(HASIL_DIR)/*.bin $(HASIL_DIR)/*.elf $(HASIL_DIR)/*.img

run: $(ISO)
	qemu-system-i386 -cdrom $(ISO)

.PHONY: all clean run