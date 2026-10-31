import struct
# baca kernel.bin (PE) 6.9K - ambil code mentah
with open('kernel.bin','rb') as f:
    data=f.read()
# cari multiboot header 1BADB002
idx=data.find(b'\x02\xB0\xAD\x1B')
print(f"Multiboot header at offset {idx} in PE")
if idx==-1:
    idx=0
code=data[idx:]

# bikin ELF32 minimal
# ELF header 52 byte + program header 32 byte
entry = 0x100000
with open('kernel_true.elf','wb') as out:
    # ELF header
    out.write(b'\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00')
    out.write(struct.pack('<HHIIIIIHHHHHH', 2, 3, 1, entry, 52, 0, 0, 52, 32, 1, 0, 0, 0))
    # Program header - loadable
    filesz = len(code)
    memsz = filesz
    out.write(struct.pack('<IIIIIIII', 1, 0, entry, entry, filesz, memsz, 5, 0x1000))
    out.write(code)
print(f"Made kernel_true.elf {len(code)} bytes at entry {hex(entry)}")
