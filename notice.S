bits 16
org 0x7C00

xor ah, ah ; set video mode
mov al, 03h ; to 03h in order to clear screen
int 10h ; video call

mov si, colordb
call set_color

xor dh, dh
mov dl, 1Ah ; centralize first line
call move_cursor

mov si, yummy_nutella
call print

mov ah, 03h ; get cursor's location
int 10h ; video call
pusha ; backup cursor's location

xor dl, dl
mov dh, 18h ; 80x24 / bottom
call move_cursor ; write to bottom
mov si, memes
call print

popa
call move_cursor ; rollback cursor's location

;int 18h ; for debug
jmp $ ; loop rather than cli-hlt; because Xen shuts down the VM

set_color:
    pusha
    mov ax, 0xB800 ; video memory base path
    mov es, ax
    xor bh, bh ; set bh to zero
    .loop1:
        lodsb ; get next byte
        cmp al, 00h ; 00h = exit
        je .ret
        mov cl, al ; startloc
        lodsb
        mov dl, al ; endloc
        lodsb
        mov dh, al ; color
    .loop2:
        mov bl, cl
        add bl, cl
        inc bl ; bl = cl * 2 + 1
        cbw ; bx = bh(00h) + bl
        mov BYTE [es:bx], dh ; set color of this door
        cmp cl, dl
        jge .loop1 ; coloring end if cl >= dl
        inc cl ; fill next door
        jmp .loop2
    .ret:
        popa
        ret

print:
    pusha
    xor bh, bh ; we won't use page number

    .loop:
        lodsb
        cmp al, 00h ; '\0' = exit
        je .ret
        cmp al, 0Ah ; '\n' = newline
        je .newline
        mov ah, 0Eh ; write character 
        int 10h ; video call
        jmp .loop

    .newline:
        mov ah, 03h ; get cursor's location
        int 10h ; video call
        mov ah, 02h ; move cursor's location
        xor dl, dl ; set row to zero
        inc dh ; increase column
        int 10h ; video call
        jmp .loop
    
    .ret:
        popa
        ret


move_cursor:
    pusha
    mov ah, 02h ; set cursor's location
    int 10h ; video call
    popa
    ret

yummy_nutella: db "Stella IT noVNC Proxy Notice", 0Ah, 0Ah, "Sorry, but this product doesn't support noVNC Remote Console.", 0Ah, 0Ah, "Please consult https://s4a.it/nonovnc to details.", 0Ah, 0Ah, "Thank you.", 0Ah, "Stella IT Inc.", 0Ah, 00h
memes: db "...btw we use arch, Do YoU kNoW sAnS?", 00h
colordb: db 1Ah, 1Ch, 0Bh, 1Dh, 20h, 09h, 21h, 23h, 0Dh, 24h, 25h, 0Ah, 26h, 28h, 0Eh, 2Ah, 2Eh, 0Ch, 30h, 35h, 0Fh, 00h ;StartLoc, EndLoc, Color

times 510-($-$$) db 00h ; fill zero to fit 512 bytes
dw 0xAA55 ; boot signature