#define LAYAR ((unsigned char*)0xA0000)
#define LEBAR 320
#define DHUWUR 200

#define IJO_TUA 2
#define IJO 10
#define KREM 14
#define COKLAT 4
#define IRU 5
#define PUTIH 15

static void kotak(int x, int y, int lebar, int dhuwur, unsigned char warna) {
    int baris;
    int kolom;
    for (baris = 0; baris < dhuwur; baris++) {
        for (kolom = 0; kolom < lebar; kolom++) {
            LAYAR[(y + baris) * LEBAR + x + kolom] = warna;
        }
    }
}

static void pigura(int x, int y, int lebar, int dhuwur, unsigned char warna) {
    kotak(x, y, lebar, 1, warna);
    kotak(x, y + dhuwur - 1, lebar, 1, warna);
    kotak(x, y, 1, dhuwur, warna);
    kotak(x + lebar - 1, y, 1, dhuwur, warna);
}

static void aksara_jawa(int x, int y, unsigned char warna) {
    kotak(x + 2, y, 2, 16, warna);
    kotak(x + 4, y + 2, 7, 2, warna);
    kotak(x + 8, y + 4, 3, 5, warna);
    kotak(x + 4, y + 8, 7, 2, warna);
    kotak(x + 6, y + 10, 3, 6, warna);
    kotak(x + 14, y + 2, 2, 14, warna);
    kotak(x + 16, y + 2, 6, 2, warna);
    kotak(x + 20, y + 4, 2, 10, warna);
    kotak(x + 16, y + 12, 6, 2, warna);
}

static const unsigned char huruf[5][7] = {
    {14, 17, 17, 31, 17, 17, 17}, {17, 27, 21, 21, 17, 17, 17},
    {17, 17, 17, 21, 21, 27, 17}, {14, 17, 17, 17, 17, 17, 14},
    {31, 16, 16, 30, 1, 1, 31}
};

static void huruf_judul(int x, int y, int indeks, unsigned char warna) {
    int baris;
    int kolom;
    for (baris = 0; baris < 7; baris++) {
        for (kolom = 0; kolom < 5; kolom++) {
            if (huruf[indeks][baris] & (1 << (4 - kolom))) {
                kotak(x + kolom * 2, y + baris * 2, 2, 2, warna);
            }
        }
    }
}

static void judul(void) {
    huruf_judul(24, 5, 0, KREM);
    huruf_judul(36, 5, 1, KREM);
    huruf_judul(48, 5, 2, KREM);
    huruf_judul(60, 5, 0, KREM);
    huruf_judul(78, 5, 3, KREM);
    huruf_judul(90, 5, 4, KREM);
}

static const unsigned char font[10][7] = {
    {14, 17, 19, 21, 25, 17, 14}, {4, 12, 4, 4, 4, 4, 14},
    {14, 17, 1, 2, 4, 8, 31}, {30, 1, 1, 14, 1, 1, 30},
    {2, 6, 10, 18, 31, 2, 2}, {31, 16, 16, 30, 1, 1, 30},
    {6, 8, 16, 30, 17, 17, 14}, {31, 1, 2, 4, 8, 8, 8},
    {14, 17, 17, 14, 17, 17, 14}, {14, 17, 17, 15, 1, 2, 12}
};

static void digit(int x, int y, int angka, unsigned char warna, int skala) {
    int baris;
    int kolom;
    for (baris = 0; baris < 7; baris++) {
        for (kolom = 0; kolom < 5; kolom++) {
            if (font[angka][baris] & (1 << (4 - kolom))) {
                kotak(x + kolom * skala, y + baris * skala, skala, skala, warna);
            }
        }
    }
}

static void angka(int x, int y, int nilai, unsigned char warna, int skala) {
    digit(x, y, (nilai / 10) % 10, warna, skala);
    digit(x + 6 * skala, y, nilai % 10, warna, skala);
}

static void gambar_desktop(void) {
    kotak(0, 0, LEBAR, DHUWUR, IJO_TUA);
    kotak(0, 0, LEBAR, 24, COKLAT);
    kotak(0, 176, LEBAR, 24, COKLAT);
    judul();
    kotak(12, 38, 296, 124, KREM);
    pigura(12, 38, 296, 124, COKLAT);
    kotak(18, 44, 284, 18, COKLAT);
    kotak(287, 48, 9, 9, IRU);
    kotak(28, 72, 90, 62, IJO);
    pigura(28, 72, 90, 62, COKLAT);
    aksara_jawa(47, 84, KREM);
    kotak(136, 72, 148, 62, PUTIH);
    pigura(136, 72, 148, 62, COKLAT);
    angka(164, 88, 13, COKLAT, 3);
    angka(164, 112, 20, COKLAT, 2);
    kotak(0, 180, 74, 16, IJO);
    pigura(0, 180, 74, 16, KREM);
    kotak(246, 180, 74, 16, IJO);
    pigura(246, 180, 74, 16, KREM);
}

void main(void) {
    gambar_desktop();
    while (1) { }
}
