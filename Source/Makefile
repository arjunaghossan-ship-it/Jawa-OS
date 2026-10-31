ASM=nasm
QEMU=qemu-system-i386
SRC=jawaos.asm
IMG=jawaos.img

all: $(IMG)

$(IMG): $(SRC)
	$(ASM) -f bin $(SRC) -o $(IMG)
	@echo "[OK] JawaOS $(IMG) - 20KB"

run: $(IMG)
	$(QEMU) -fda $(IMG) -boot a -m 128M -display gtk

clean:
	rm -f build/*.bin build/*.img *.img
	@echo "[CLEAN] resik"

list:
	ls -lh *.asm
	@echo "--- build/ ---"
	ls -lh build/ 2>/dev/null || echo "kosong"
	@echo "--- old/ ---"
	ls -lh old/ 2>/dev/null || echo "kosong"
