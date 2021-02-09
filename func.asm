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

str_diskerr: db "DISK ERROR!", 10, 13, 0