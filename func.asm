print:
pusha
print_loop:
mov al, [si]
cmp al, 0
jne disp_char
popa
ret
disp_char:
mov ah, 0x0E
int 0x10
add si, 1
jmp print_loop

clearscreen:
pusha
mov ah, 0
mov al, 3
int 0x10
popa
ret

bluescreen:
pusha
mov ah, 0x09
mov al, 0x20
mov bh, 0x00
mov bl, 0x1F
mov cx, 0x1000
int 0x10
popa
ret

yellowscreen:
pusha
mov ah, 0x09
mov al, 0x20
mov bh, 0x00
mov bl, 0xE0
mov cx, 0x1000
int 0x10
popa
ret

readkernel:
pusha
mov ah, 0x02
mov al, 1
mov ch, 0
mov cl, 2
mov dh, 0
mov dl, 0x80

xor bx, bx
mov es, bx
mov bx, 0x7E00

int 0x13

jc diskerr
popa
ret

diskerr:
mov si, str_diskerr
call print
jmp $

EnterProtectedMode:
call EnableA20
cli
lgdt [gdt_descriptor]
mov cr0, eax
or eax, 1
mov cr0, eax
jmp codeseg:startProtectedMode

EnableA20:
in al, 0x92
or al, 2
out 0x92, al
ret

[bits 32]

startProtectedMode:

    mov ax, dataseg
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp

    mov [0xb8000], byte "B"
    mov [0xb8002], byte "r"
    mov [0xb8004], byte "u"
    mov [0xb8006], byte "h"
    mov [0xb8008], byte " "
    mov [0xb800A], byte "M"
    mov [0xb800C], byte "o"
    mov [0xb800E], byte "m"
    mov [0xb8010], byte "e"
    mov [0xb8012], byte "n"
    mov [0xb8014], byte "t"

    call DetectCPUID
    call DetectLongMode
    call SetUpIdentityPaging
    call EditGDT
    jmp codeseg:Start64Bit

[bits 64]

Start64Bit:
    mov edi, 0xb8000
    mov rax, 0x1f201f201f201f20
    mov rcx, 500
    rep stosq
    jmp $

str_diskerr: db "DISK ERROR!", 10, 13, 0
