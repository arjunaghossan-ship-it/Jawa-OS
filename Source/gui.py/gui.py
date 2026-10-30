import jawaos

# --- PALET WARNA JAWAOS ---
HITAM = 0x001122
PUTIH = 0xFFFFFF
ABU = 0x2A2A2A
OREN_JAWA = 0xFF5500
IJO_NEON = 0x00FF88

def draw_window(x, y, w, h, title):
    # Bayangan
    jawaos.draw_rect(x+4, y+4, w, h, 0x000000)
    # Body
    jawaos.draw_rect(x, y, w, h, PUTIH)
    # Title bar
    jawaos.draw_rect(x, y, w, 25, OREN_JAWA)
    jawaos.draw_text(x+10, y+5, title, PUTIH)

def desktop():
    # 1. Clear layar (alamat framebuffer otomatis diurus C, bukan 0xFF0000!)
    jawaos.clear(HITAM)
    
    # 2. Taskbar bawah
    jawaos.draw_rect(0, 580, 1024, 20, ABU)
    jawaos.draw_text(10, 583, "JAWA OS v0.1 [Python] - 16:30 WIB", IJO_NEON)
    
    # 3. Icon Desktop
    jawaos.draw_rect(20, 20, 60, 60, OREN_JAWA)
    jawaos.draw_text(25, 85, "MyKom", PUTIH)
    
    # 4. Window 1 - Terminal
    draw_window(100, 100, 400, 200, "Terminal - Python")
    jawaos.draw_text(110, 135, "> python3 gui.py", HITAM)
    jawaos.draw_text(110, 155, "> GUI Loaded! Gas!", IJO_NEON)
    jawaos.draw_text(110, 175, "> Alamat FB: OK", HITAM)
    jawaos.draw_text(110, 195, "> Warna 0xFF5500: OK", HITAM)
    
    # 5. Window 2 - Tentang
    draw_window(550, 150, 300, 150, "Tentang")
    jawaos.draw_text(560, 185, "OS Gawean Arjuna", HITAM)
    jawaos.draw_text(560, 205, "Powered by Python", OREN_JAWA)
    jawaos.draw_text(560, 225, "Anti C Mumet!", HITAM)

# JALANKE!
desktop()