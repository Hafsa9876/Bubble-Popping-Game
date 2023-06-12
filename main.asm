[org 0x0100]
jmp start
top_row: db 0
top_col: db 0
bot_row: db 0
bot_col: db 0
colour: db 0

	; subroutine to clear the screen
	sleep: push cx
	mov cx, 0xFFFF
	delay: loop delay
	pop cx
	ret

clrscr:

	push es
	push di
	push ax

	mov ax,0xb800
	mov es,ax
	mov di,0

	nextchar:
			mov word[es:di],0x0720
			add di,2
			cmp di,4000
			jne nextchar

	pop ax
	pop di
	pop es
	ret


start:
	call clrscr

mov ax,0x4c00
int 0x21
