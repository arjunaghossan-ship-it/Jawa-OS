#define VGA ((volatile char*)0xB8000)
static int cur=0;
static void putc(char c){
    if(c=='\n'){cur=(cur/80+1)*80; if(cur>=2000)cur=0; return;}
    VGA[cur*2]=c; VGA[cur*2+1]=0x0A; cur++; if(cur>=2000)cur=0;
}
static void clear(){ for(int i=0;i<2000;i++){VGA[i*2]=0; VGA[i*2+1]=0x07;} cur=0;}

// INI ENTRY SING DIPANGGIL start.asm
void kernel_start(void){
    clear();
    putc('J'); putc('a'); putc('w'); putc('a'); putc('O'); putc('S');
    putc(' '); putc('v'); putc('0'); putc('.'); putc('4'); putc('\n');
    putc('j'); putc('a'); putc('w'); putc('a'); putc('o'); putc('s');
    putc('@'); putc('b'); putc('i'); putc('n'); putc('o'); putc('n'); putc('g'); putc(':'); putc('~'); putc('$'); putc(' ');
    while(1){ __asm__ volatile("hlt"); }
}
