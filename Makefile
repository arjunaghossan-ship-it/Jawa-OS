ASM=nasm
CC=gcc
LD=ld

ASMFLAGS=-f elf32
CFLAGS=-m32 -ffreestanding -fno-pie -nostdlib -nostartfiles -nodefaultlibs -Wall -Wextra
LDFLAGS=-m elf_i386 -T Linker.ld

SRC_DIR=Sumber
BUILD_DIR=Build
HASIL_DIR=Hasil

ASM_SRC=$(wildcard $(SRC_DIR)/*.asm)
C_SRC=$(wildcard $(SRC_DIR)/*.c)

# IKI SING BENER - OJO KEBALIK
C_OBJ=$(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(C_SRC))
ASM_OBJ=$(patsubst $(SRC_DIR)/%.asm, $(BUILD_DIR)/%.o, $(ASM_SRC))

TARGET=$(HASIL_DIR)/kernel.elf
ISO=$(HASIL_DIR)/JawaOS.iso

all: $(TARGET) $(ISO)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm
	@mkdir -p $(BUILD_DIR)
	$(ASM) $(ASMFLAGS) $< -o $@

$(TARGET): $(C_OBJ) $(ASM_OBJ)
	@mkdir -p $(HASIL_DIR)
	$(CC) -m32 -T Linker.ld -o $@ -ffreestanding -O2 -nostdlib -lgcc $^

$(ISO): $(TARGET)
	@mkdir -p iso/boot/grub
	@cp $(TARGET) iso/boot/
	@echo 'menuentry "JawaOS" {' > iso/boot/grub/grub.cfg
	@echo '  multiboot /boot/kernel.elf' >> iso/boot/grub/grub.cfg
	@echo '  boot' >> iso/boot/grub/grub.cfg
	@echo '}' >> iso/boot/grub/grub.cfg
	grub-mkrescue -o $@ iso
	@echo "[SUKSES] $(ISO) dadi lur!"

clean:
	rm -rf $(BUILD_DIR) iso $(HASIL_DIR)/*.iso

run: $(ISO)
	qemu-system-i386 -cdrom $(ISO)