__asm__(
".globl _kernel_main\n"
".globl kernel_main\n"
"_kernel_main:\n"
"kernel_main:\n"
);

void _kernel_main() {
    char* vga = (char*)0xB8000;
    for(int i=0;i<80*25;i++){vga[i*2]=' ';vga[i*2+1]=0x0F;}
    const char* m="JawaOS OK! Bonang Banten - FINAL FIX :)";
    for(int i=0;m[i];i++){vga[i*2]=m[i];vga[i*2+1]=0x0A;}
    while(1){__asm__ volatile("hlt");}
}
