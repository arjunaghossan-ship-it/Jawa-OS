// Alamat memori grafis VESA 1024x768 32-bit (Sesuaikan jika layar QEMU hitam/kosong)
#define LFB_ALAMAT (unsigned int*)0xFD000000 

// Definisi Warna (Format Hex RGB: 0x00RRGGBB)
#define WARNA_LATAR_DESKTOP 0x001A4D2E  // Hijau Botol Estetik
#define WARNA_JENDELA       0x00DFDFDF  // Abu-abu Klasik
#define WARNA_BILAH_JUDUL   0x00000080  // Biru Tua
#define WARNA_TOMBOL_METU   0x00FF0000  // Merah (Tombol Keluar)

void nggawe_kotak(int x, int y, int lebar, int tinggi, unsigned int warna);
void nggawe_desktop_jawa();
void nggawe_jendela_jawa(int x, int y, int lebar, int tinggi);

void main() {
    // 1. Gambar latar belakang Desktop Jawa
    nggawe_desktop_jawa();

    // 2. Gambar Jendela UI Utama di tengah layar (Koordinat X=300, Y=200)
    nggawe_jendela_jawa(300, 200, 450, 300);

    // Loop selamanya agar sistem tetap menyala
    while(1);
}

// Fungsi dasar mewarnai area kotak berdasarkan piksel
void nggawe_kotak(int x, int y, int lebar, int tinggi, unsigned int warna) {
    unsigned int* layar = LFB_ALAMAT;
    for (int i = 0; i < tinggi; i++) {
        for (int j = 0; j < lebar; j++) {
            // Rumus index pixel pada resolusi layar lebar 1024
            layar[(y + i) * 1024 + (x + j)] = warna;
        }
    }
}

// Fungsi menggambar background Desktop dan Taskbar bawah
void nggawe_desktop_jawa() {
    // Mewarnai seluruh layar 1024x768 dengan warna hijau botol
    nggawe_kotak(0, 0, 1024, 768, WARNA_LATAR_DESKTOP);
    
    // Nggawe 'Bilah Ngisor' (Taskbar) di bagian paling bawah layar
    nggawe_kotak(0, 728, 1024, 40, WARNA_JENDELA);
    
    // Nggawe 'Tombol Wiwit' (Start Button) di pojok kiri bawah
    nggawe_kotak(5, 733, 80, 30, 0x00C0C0C0);
}

// Fungsi menggambar komponen Jendela Aplikasi (Caliṅan)
void nggawe_jendela_jawa(int x, int y, int lebar, int tinggi) {
    // Latar belakang isi jendela (Abu-abu)
    nggawe_kotak(x, y, lebar, tinggi, WARNA_JENDELA);
    
    // Bilah judul atas (Title Bar) jendela
    nggawe_kotak(x, y, lebar, 30, WARNA_BILAH_JUDUL);
    
    // Tombol silang / keluar ("Metu") di pojok kanan atas jendela
    nggawe_kotak(x + lebar - 25, y + 5, 20, 20, WARNA_TOMBOL_METU);
}
