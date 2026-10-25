class ScreenBuffer {
private:
    unsigned int* lfb; // Pointer ke alamat dasar memori grafis (Hex)

public:
    ScreenBuffer(unsigned int* target_address) {
        lfb = target_address; // Misal diisi dengan 0xFD000000 dari Bootloader
    }

    void drawPixel(int x, int y, unsigned int hex_color) {
        // Angka 1024 di bawah ini adalah resolusi lebar layar Anda
        int index = y * 1024 + x;
        
        // Menulis langsung warna Hex ke alamat memori kartu grafis
        lfb[index] = hex_color;
    }
};

void createDesktop() {
    // Inisialisasi dengan alamat Hex tiruan dari kartu grafis
    ScreenBuffer screen((unsigned int*)0xFD000000);

    // Menggambar piksel di koordinat (10, 20) dengan warna Hex
    // 0xFFFF0000 = Kuning Murni (Red=FF, Green=FF, Blue=00)
    screen.drawPixel(10, 20, 0xFFFF0000); 
}
