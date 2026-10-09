#define VGA_ADDRESS 0xB8000
#define WHITE_ON_BLUE 0x1F
#define MAX_FILES 16

// ===== GLOBAL =====
int cursor_pos = 0;
char current_dir[64] = "/";
char cmd_buffer[128];
int cmd_index = 0;

struct File {
    char name[32];
    char content[256];
    int used;
};
struct File fs[MAX_FILES];

// ===== STRING =====
int strlen(char* s){ int i=0; while(s[i]!='\0') i++; return i; }
int strcmp(char* a, char* b){ int i=0; while(a[i]!='\0' && b[i]!='\0'){ if(a[i]!=b[i]) return a[i]-b[i]; i++; } return a[i]-b[i]; }
int strncmp(char* a, char* b, int n){ for(int i=0;i<n;i++){ if(a[i]!=b[i] || a[i]=='\0') return a[i]-b[i]; } return 0; }
void strcpy(char* dst, char* src){ int i=0; while(src[i]!='\0'){ dst[i]=src[i]; i++; } dst[i]='\0'; }
void strcat(char* dst, char* src){ int len=strlen(dst); int i=0; while(src[i]!='\0'){ dst[len+i]=src[i]; i++; } dst[len+i]='\0'; }

// ===== VGA =====
void print(char* str){
    char* vga = (char*) VGA_ADDRESS;
    for(int i=0; str[i]!='\0'; i++){
        if(str[i]=='\n') cursor_pos=(cursor_pos/80+1)*80;
        else { vga[cursor_pos*2]=str[i]; vga[cursor_pos*2+1]=WHITE_ON_BLUE; cursor_pos++; }
        if(cursor_pos>=80*25){ cursor_pos=0; } // simple scroll wrap
    }
}
void clear_screen(){
    char* vga=(char*)VGA_ADDRESS;
    for(int i=0;i<80*25;i++){ vga[i*2]=' '; vga[i*2+1]=WHITE_ON_BLUE; }
    cursor_pos=0;
}

// ===== RAM FS =====
void fs_init(){
    for(int i=0;i<MAX_FILES;i++) fs[i].used=0;
    strcpy(fs[0].name, "readme.txt");
    strcpy(fs[0].content, "Iki JavaOS soko Binong!");
    fs[0].used=1;
}
int fs_find(char* name){
    for(int i=0;i<MAX_FILES;i++) if(fs[i].used && strcmp(fs[i].name,name)==0) return i;
    return -1;
}
int fs_create(char* name, char* content){
    int idx = fs_find(name);
    if(idx!=-1){ strcpy(fs[idx].content, content); return idx; }
    for(int i=0;i<MAX_FILES;i++) if(!fs[i].used){
        strcpy(fs[i].name, name);
        strcpy(fs[i].content, content);
        fs[i].used=1;
        return i;
    }
    return -1;
}

// ===== COMMAND =====
void handle_command(char* command){
    if(strcmp(command,"help")==0){
        print("help, clear, ls, cat <f>, echo <t> > <f>, rm <f>, about\n");
    }
    else if(strcmp(command,"clear")==0) clear_screen();
    else if(strcmp(command,"ls")==0){
        print("Isi /:\n");
        for(int i=0;i<MAX_FILES;i++) if(fs[i].used){ print(" - "); print(fs[i].name); print("\n"); }
    }
    else if(strncmp(command,"cat ",4)==0){
        int idx = fs_find(command+4);
        if(idx==-1) print("File ora ono\n");
        else { print(fs[idx].content); print("\n"); }
    }
    else if(strncmp(command,"rm ",3)==0){
        int idx = fs_find(command+3);
        if(idx==-1) print("File ora ono\n");
        else { fs[idx].used=0; print("Dihapus\n"); }
    }
    else if(strncmp(command,"echo ",5)==0){
        int pos = -1;
        /* Find pattern " > " safely: ensure we don't read past the string end. */
        for (int i = 0; command[i] != '\0' && command[i+1] != '\0' && command[i+2] != '\0'; i++) {
            if (command[i] == ' ' && command[i+1] == '>' && command[i+2] == ' ') { pos = i; break; }
        }
        if (pos != -1 && pos > 5) {
            char text[128]; char fname[32];
            int len = pos - 5;
            if (len > 127) len = 127; /* clamp to buffer */
            for (int i = 0; i < len; i++) text[i] = command[5 + i];
            text[len] = '\0';
            /* copy filename safely */
            int fnlen = 0;
            for (int i = 0; command[pos + 3 + i] != '\0' && fnlen < 31; i++) fname[fnlen++] = command[pos + 3 + i];
            fname[fnlen] = '\0';
            if (fs_create(fname, text) == -1) print("FS penuh!\n"); else print("Tersimpan\n");
        } else { print(command+5); print("\n"); }
    }
    else if(strcmp(command,"about")==0) print("JavaOS v0.2 RAM-FS - Binong Jos!\n");
    else if(strlen(command)!=0) print("Perintah ora dikenal, ketik help\n");
}

// ===== IO PORT - FIX UCRT64 =====
unsigned char inb(int port){
    unsigned char ret;
    __asm__ __volatile__ ("inb %%dx, %%al" : "=a"(ret) : "d"(port));
    return ret;
}
void outb(int port, unsigned char data){
    __asm__ __volatile__ ("outb %%al, %%dx" : : "a"(data), "d"(port));
}

// ===== MAIN =====
void kernel_main(){
    fs_init();
    clear_screen();
    print("JawaOS v0.2 - RAM FS Aktif!\nKetik help\n> ");

    char keymap[128] = {
        0,27,'1','2','3','4','5','6','7','8','9','0','-','=','\b',
        '\t','q','w','e','r','t','y','u','i','o','p','[',']','\n',
        0,'a','s','d','f','g','h','j','k','l',';','\'','`',
        0,'\\','z','x','c','v','b','n','m',',','.','/',0,
        '*',0,' ',0,0,0,0,0,0,0,0,0
    };
    cmd_index=0;
    while(1){
        if(inb(0x64) & 1){
            unsigned char sc = inb(0x60);
            if(sc & 0x80) continue;
            char c = keymap[sc];
            if(c == '\n'){
                cmd_buffer[cmd_index] = '\0';
                print("\n");
                handle_command(cmd_buffer);
                cmd_index = 0;
                print("> ");
            } else if(c == '\b'){
                if(cmd_index > 0){
                    cmd_index--; cursor_pos--;
                    char* vga=(char*)VGA_ADDRESS;
                    vga[cursor_pos*2]=' '; vga[cursor_pos*2+1]=WHITE_ON_BLUE;
                }
            } else if(c!=0 && cmd_index < 127){
                cmd_buffer[cmd_index++] = c;
                char s[2] = {c, '\0'}; print(s);
            }
        }
    }
}