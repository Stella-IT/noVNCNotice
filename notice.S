bits 16
org 0x7C00

xor ah, ah
mov al, 3
int 10h

pusha
mov cl, 1Ah
mov dl, 1Ch
mov dh, 0Bh
call set_color_fl
mov cl, 1Dh
mov dl, 20h
mov dh, 09h
call set_color_fl
mov cl, 21h
mov dl, 23h
mov dh, 0Dh
call set_color_fl
mov cl, 24h
mov dl, 25h
mov dh, 0Ah
call set_color_fl
mov cl, 26h
mov dl, 28h
mov dh, 0Eh
call set_color_fl
mov cl, 2Ah
mov dl, 2Eh
mov dh, 0Ch
call set_color_fl
mov cl, 30h
mov dl, 35h
mov dh, 0Fh
call set_color_fl
popa

xor dh, dh
mov dl, 1Ah
call move_cursor

mov si, yummy_nutella
call print

mov ah, 3
int 10h
pusha

xor dl, dl
mov dh, 24
call move_cursor

mov si, memes
call print

popa
call move_cursor

;int 18h ; for debug
jmp $ ; no more cli-hlt because Xen shuts down the VM

set_color_fl:
    pusha
    mov ax, 0xB800
    mov es, ax
    xor bh, bh
    .sc_internal:
        mov bl, cl
        add bl, cl
        inc bl
        cbw
        mov byte [es:bx], dh
        cmp cl, dl
        jge .sc_ret
        inc cl
        jmp .sc_internal
    .sc_ret:
        popa
        ret

print:
    pusha
    xor bh, bh

    .p_internal:
        lodsb
        cmp al, 0
        je .p_ret
        cmp al, 0Ah
        je .p_newline
        mov ah, 0Eh
        int 10h
        jmp .p_internal

    .p_newline:
        mov ah, 3
        int 10h
        mov ah, 2
        xor dl, dl
        inc dh
        int 10h
        jmp .p_internal

    .p_ret:
        popa
        ret


move_cursor:
    pusha
    mov ah, 2
    int 10h
    popa
    ret

yummy_nutella: db "Stella IT noVNC Proxy Notice", 0Ah, 0Ah, "Sorry, but this product doesn't support noVNC Remote Console.", 0Ah, 0Ah, "Please consult https://s4a.it/nonovnc to details.", 0Ah, 0Ah, "Thank you.", 0Ah, "Stella IT Inc.", 0Ah, 0
memes: db "...btw we use arch, Do YoU kNoW sAnS?", 0

times 510-($-$$) db 0
dw 0xAA55