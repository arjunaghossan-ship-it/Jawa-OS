#define LAYAR ((unsigned char*)0xA0000)
#define LEBAR 320
#define DHUWUR 200
#define IJO_TUA 2
#define IJO 10
#define KREM 14
#define COKLAT 4
#define IRU 5
#define PUTIH 15

static void kotak(int x, int y, int lebar, int dhuwur, unsigned char warna){
    for(int b=0;b<dhuwur;b++) for(int k=0;k<lebar;k++) LAYAR[(y+b)*LEBAR+x+k]=warna;
}
static void pigura(int x,int y,int l,int d,unsigned char w){kotak(x,y,l,1,w);kotak(x,y+d-1,l,1,w);kotak(x,y,1,d,w);kotak(x+l-1,y,1,d,w);}
static void aksara_jawa(int x,int y,unsigned char w){kotak(x+2,y,2,16,w);kotak(x+4,y+2,7,2,w);kotak(x+8,y+4,3,5,w);kotak(x+4,y+8,7,2,w);kotak(x+6,y+10,3,6,w);kotak(x+14,y+2,2,14,w);kotak(x+16,y+2,6,2,w);kotak(x+20,y+4,2,10,w);kotak(x+16,y+12,6,2,w);}
static const unsigned char font[10][7]={{14,17,19,21,25,17,14},{4,12,4,4,4,4,14},{14,17,1,2,4,8,31},{30,1,1,14,1,1,30},{2,6,10,18,31,2,2},{31,16,16,30,1,1,30},{6,8,16,30,17,17,14},{31,1,2,4,8,8,8},{14,17,17,14,17,17,14},{14,17,17,15,1,2,12}};
static void digit(int x,int y,int a,unsigned char w,int s){for(int b=0;b<7;b++)for(int k=0;k<5;k++)if(font[a][b]&(1<<(4-k)))kotak(x+k*s,y+b*s,s,s,w);}
static void angka(int x,int y,int n,unsigned char w,int s){digit(x,y,(n/10)%10,w,s);digit(x+6*s,y,n%10,w,s);}
static void gambar_desktop(void){
    kotak(0,0,LEBAR,DHUWUR,IJO_TUA);kotak(0,0,LEBAR,24,COKLAT);kotak(0,176,LEBAR,24,COKLAT);
    kotak(12,38,296,124,KREM);pigura(12,38,296,124,COKLAT);kotak(18,44,284,18,COKLAT);kotak(287,48,9,9,IRU);
    kotak(28,72,90,62,IJO);pigura(28,72,90,62,COKLAT);aksara_jawa(47,84,KREM);
    kotak(136,72,148,62,PUTIH);pigura(136,72,148,62,COKLAT);angka(164,88,13,COKLAT,3);angka(164,112,20,COKLAT,2);
    kotak(0,180,74,16,IJO);pigura(0,180,74,16,KREM);kotak(246,180,74,16,IJO);pigura(246,180,74,16,KREM);
}
void kernel_main(void){gambar_desktop();while(1){}}