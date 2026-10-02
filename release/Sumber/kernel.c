// JavaOS CLI v1 - Simpl// JavaOS CLI v1 - tanpa __asm__
#define VGA 0xB8000
#define W 80
#define H 25

// ambil dari boot.asm
extern unsigned char inb(unsigned short p);
extern void outb(unsigned short p, unsigned char d);
#define inb inb
#define outb outb

int cx=0, cy=0;
int strcmp(char* a,char* b){int i=0;while(a[i]&&b[i]){if(a[i]!=b[i])return 1; i++;} return a[i]!=b[i];}

void scroll(){
 if(cy>=H){
  char* v=(char*)VGA;
  for(int i=0;i<(H-1)*W;i++){v[i*2]=v[(i+W)*2]; v[i*2+1]=v[(i+W)*2+1];}
  for(int i=0;i<W;i++){v[((H-1)*W+i)*2]=' '; v[((H-1)*W+i)*2+1]=0x1F;}
  cy=H-1;
 }
}
void putc(char c){
 char* v=(char*)VGA;
 if(c=='\n'){cx=0;cy++; scroll(); return;}
 if(c=='\b'){if(cx>0){cx--; v[(cy*W+cx)*2]=' '; } return;}
 v[(cy*W+cx)*2]=c; v[(cy*W+cx)*2+1]=0x1F; cx++; if(cx>=W){cx=0;cy++; scroll();}
}
void puts(char* s){for(int i=0;s[i];i++) putc(s[i]);}
void clear(){char* v=(char*)VGA; for(int i=0;i<W*H;i++){v[i*2]=' '; v[i*2+1]=0x1F;} cx=0; cy=0;}

char keymap[128]={0,0,'1','2','3','4','5','6','7','8','9','0','-','=',0,0,'q','w','e','r','t','y','u','i','o','p','[',']',0,0,'a','s','d','f','g','h','j','k','l',';','\'','`',0,'\\','z','x','c','v','b','n','m',',','.','/',0,0,0,' '};

char get_key(){
 while(1){
  if(inb(0x64)&1){
   unsigned char sc=inb(0x60);
   if(sc<128 && keymap[sc]) return keymap[sc];
   if(sc==0x0E) return '\b';
   if(sc==0x1C) return '\n';
  }
 }
}

char buf[64];
int bi=0;

void cmd(){
 buf[bi]=0;
 if(bi==0) return;
 puts("\n");
 if(!strcmp(buf,"help")) puts("cmd: help, clear, about, reboot\n");
 else if(!strcmp(buf,"clear")) clear();
 else if(!strcmp(buf,"about")) puts("JavaOS v0.2 by HP - Bonang, Banten\n");
 else if(!strcmp(buf,"reboot")){outb(0x64,0xFE); while(1){}}
 else {puts("unknown: "); puts(buf); puts("\n");}
 bi=0;
}

void gambar_desktop(){clear(); puts("JavaOS Desktop OK!\n"); puts("Type 'help' for commands\n\n");}

void kernel_main(void){
 gambar_desktop();
 puts("> ");
 while(1){
  char k=get_key();
  if(k=='\n'){cmd(); puts("> ");}
  else if(k=='\b'){if(bi>0){bi--; putc('\b');}}
  else{if(bi<63){buf[bi++]=k; putc(k);}}
 }
}