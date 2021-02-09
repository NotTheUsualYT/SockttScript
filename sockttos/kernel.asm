[org 0x7E00]
call EnterProtectedMode
jmp $
%include "func.asm"
%include "gdt.asm"
[bits 32]
%include "CPUID.asm"
%include "SimplePaging.asm"
[bits 16]
times 16384-($-$$) db 0