[org 0x7C00]
call readkernel
jmp 0x7E00
jmp $
%include "func.asm"
%include "gdt.asm"
[bits 32]
%include "CPUID.asm"
%include "SimplePaging.asm"
[bits 16]
times 510-($-$$) db 0
dw 0xAA55