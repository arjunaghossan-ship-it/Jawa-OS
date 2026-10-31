# Security Policy - JawaOS

## About JawaOS
JawaOS is a 32-bit OS hobby project from Bonang. It is still in the early stages (bootloader + VGA + keyboard), so there are no real security features like user privilege, memory protection, etc.

But still, we take it seriously that there is a gap.

## Supported Versions

| Version | Security Status |
| --- | --- |
| v0.2 (current) | ✅ Supported |
| < v0.2 | ❌ Not supported |

## How to Report a Gap

If you find a security bug (for example: buffer overflow in `cmd_buffer`, crash after input, or bypass in bootloader), **don't post it in Public Issue.**

Contact directly:

- **Email:** arjuna.ghossan@gmail.com
- **DM GitHub:** arjunaghossan-ship-it
- **WhatsApp:** +62 895-3921-64783

Include:
1. Description of the bug
2. Reproductive steps
3. Impact (can crash, hang, code execution)
4. JawaOS + QEMU version

## Our Promise

1. No response maximum 2x24 hours (Hopefully).
2. If it is valid, do not fix it in `security-fix` branch.
3. You will not be listed in `CREDITS.md` as an inventor (if you want).
4. Do not distribute it before the release fix.

## Which is not a gap

This is not a loophole, because it hasn't been created yet:
- There is no password / login yet
- No memory isolation yet
- QEMU escape (it's QEMU's fault, not JawaOS)

## Thank you

Thank you for helping JawaOS become more secure. Bonang's small project is big because of your contribution!
---
*Bonang, Banten - 2026*
