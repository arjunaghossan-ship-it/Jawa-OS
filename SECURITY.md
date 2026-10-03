# Security Policy - JawaOS

## Tentang JawaOS
JawaOS adalah project hobi OS 32-bit dari Binong. Saiki iseh tahap awal (bootloader + VGA + keyboard), jadi belum ada fitur security beneran kayak user privilege, memory protection, dll.

Tapi tetep, kita anggap serius lek ono celah.

## Versi yang Didukung

| Versi | Status Keamanan |
| --- | --- |
| v0.2 (saiki) | ✅ Didukung |
| < v0.2 | ❌ Tidak didukung |

## Cara Melaporkan Celah

Nek kowe nemu bug keamanan (misal: buffer overflow neng `cmd_buffer`, crash pas input, atau bypass neng bootloader), **ojo di-post neng Issue umum.**

Langsung hubungi:

- **Email:** arjuna.ghossan@gmail.com
- **DM GitHub:** arjunaghossan-ship-it
- **WhatsApp:** +62 895-3921-64783

Sertakan:
1. Deskripsi bug
2. Langkah reproduksi
3. Dampak (apa iso crash, hang, eksekusi kode)
4. Versi JavaOS + QEMU

## Janji Kita

1. Tak respon maksimal 2x24 jam.
2. Nek valid, tak fix neng branch `security-fix`.
3. Kowe bakal tak cantumke neng `CREDITS.md` sebagai penemu (lek gelem).
4. Ojo disebar dulu sebelum fix rilis.

## Yang Bukan Celah

Iki dudu celah, mergo memang durung digawe:
- Belum ada password / login
- Belum ada isolasi memory
- QEMU escape (iku salah QEMU, dudu JawaOS)

## Terima Kasih

Suwun wes bantu JawaOS dadi luwih aman. Project cilik soko Bonang iki iso gede mergo kontribusi mu!
---
*Bonang, Banten - 2026*
