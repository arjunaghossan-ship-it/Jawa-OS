void kernel_main(void);
__attribute__((naked, section(".text"), noreturn))
void _start(void){
    __asm__ volatile(
        "mov $0x90000, %%esp\n"
        "call _kernel_main\n"
        "cli\n1: hlt\n jmp 1b\n"
    );
}

#define VGA ((volatile char*)0xB8000)
static int cur=0;
static void putc(char c){
    if(c=='\n'){cur=(cur/80+1)*80; if(cur>=2000)cur=0; return;}
    VGA[cur*2]=c; VGA[cur*2+1]=0x0A; cur++; if(cur>=2000)cur=0;
}
static void clear(){ for(int i=0;i<2000;i++){VGA[i*2]=0; VGA[i*2+1]=0x07;} cur=0;}

__attribute__((section(".text"))) void _kernel_main(void){ kernel_main(); }

__attribute__((section(".text")))
void kernel_main(void){
    clear();
    // TULIS LANGSUNG TANPA STRING LITERAL - ANTI .rodata
    putc('J'); putc('a'); putc('w'); putc('a'); putc('O'); putc('S');
    putc(' '); putc('v'); putc('0'); putc('.'); putc('4'); putc(' ');
    putc('-'); putc(' '); putc('B'); putc('i'); putc('n'); putc('o'); putc('n'); putc('g'); putc('\n');
    putc('j'); putc('a'); putc('w'); putc('a'); putc('o'); putc('s'); putc('@');
    putc('b'); putc('i'); putc('n'); putc('o'); putc('n'); putc('g'); putc(':'); putc('~'); putc('$'); putc(' ');
    while(1){ __asm__ volatile("hlt"); }
}
