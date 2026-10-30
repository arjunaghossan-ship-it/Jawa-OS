#include <stdint.h>
#include <stddef.h>

// --- DARI GRUB (Multiboot) ---
struct multiboot_info {
    uint32_t flags;
    uint32_t mem_lower;
    uint32_t mem_upper;
    uint32_t boot_device;
    uint32_t cmdline;
    uint32_t mods_count;
    uint32_t mods_addr;
    uint32_t syms[4];
    uint32_t mmap_length;
    uint32_t mmap_addr;
    uint32_t drives_length;
    uint32_t drives_addr;
    uint32_t config_table;
    uint32_t boot_loader_name;
    uint32_t apm_table;
    uint32_t vbe_control_info;
    uint32_t vbe_mode_info;
    uint32_t vbe_mode;
    uint32_t vbe_interface_seg;
    uint32_t vbe_interface_off;
    uint32_t vbe_interface_len;
    uint64_t framebuffer_addr; // INI ALAMAT LAYAR ASLI! Biasane 0xFD000000
    uint32_t framebuffer_pitch;
    uint32_t framebuffer_width;
    uint32_t framebuffer_height;
    uint8_t framebuffer_bpp;
    uint8_t framebuffer_type;
    uint8_t color_info[6];
};

// --- GLOBAL ---
uint32_t* fb = 0;
uint32_t fb_width = 1024;
uint32_t fb_height = 768;

// --- BABU FRAMEBUFFER (DIPANGGIL PYTHON) ---
void jawaos_put_pixel(int x, int y, uint32_t color) {
    // color = 0xFF0000 (WARNA)
    // fb = 0xFD000000 (ALAMAT) -> BEDA!
    if (x >= 0 && x < fb_width && y >= 0 && y < fb_height) {
        fb[y * fb_width + x] = color;
    }
}

void jawaos_clear(uint32_t color) {
    for (int i = 0; i < fb_width * fb_height; i++) {
        fb[i] = color;
    }
}

void jawaos_draw_rect(int x, int y, int w, int h, uint32_t color) {
    for (int j = y; j < y + h; j++) {
        for (int i = x; i < x + w; i++) {
            jawaos_put_pixel(i, j, color);
        }
    }
}

// Font 8x8 super simpel
extern char _binary_font_psf_start;
void jawaos_draw_text(int x, int y, char* str, uint32_t color) {
    // versi simpel: kotak-kotak dulu ben gak ribet
    // nanti tak ganti font beneran
    for (int i = 0; str[i] != '\0'; i++) {
        jawaos_draw_rect(x + i*8, y, 6, 8, color);
    }
}

// --- EMBED GUI.PY ---
extern char _binary_gui_py_start[];
extern char _binary_gui_py_end[];

// --- KERNEL MAIN (DIPANGGIL boot.asm) ---
void kernel_main(struct multiboot_info* mbi) {
    // 1. Ambil alamat framebuffer asli dari GRUB, BUKAN 0xFF0000
    fb = (uint32_t*) (uintptr_t) mbi->framebuffer_addr;
    fb_width = mbi->framebuffer_width;
    fb_height = mbi->framebuffer_height;

    // Kalau GRUB gak kasih framebuffer, pakai default QEMU
    if ((uint32_t)fb == 0) {
        fb = (uint32_t*)0xFD000000;
    }

    // 2. Test awal ben gak blank
    jawaos_clear(0x001122); // HITAM JAWAOS
    jawaos_draw_rect(100, 100, 400, 25, 0xFF5500); // Title bar oren

    // 3. DI SINI NANTI MICRPYTHON DIPANGGIL
    // Untuk sementara kita simulasi gui.py manual dulu
    // Biar iso boot walau micropython belum di-link
    
    // Simulasi desktop() dari gui.py
    jawaos_clear(0x001122);
    jawaos_draw_rect(0, 580, 1024, 20, 0x2A2A2A);
    // Window
    jawaos_draw_rect(104, 104, 400, 200, 0x000000); // shadow
    jawaos_draw_rect(100, 100, 400, 200, 0xFFFFFF);
    jawaos_draw_rect(100, 100, 400, 25, 0xFF5500);

    // Loop abadi
    while(1) {
        __asm__ volatile("hlt");
    }
}