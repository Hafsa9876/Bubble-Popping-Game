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

	
		
		scrollup: push bp
		 mov bp,sp
		 push ax
		 push cx
		 push si
		 push di
		 push es
		 push ds
		 mov ax, 80 ; load chars per row in ax
		 mul byte [bp+4] ; calculate source position
		 mov si, ax ; load source position in si
		 push si ; save position for later use
		 shl si, 1 ; convert to byte offset
		 mov cx, 2000 ; number of screen locations
		 sub cx, ax ; count of words to move
		 mov ax, 0xb800
		 mov es, ax ; point es to video base
		 mov ds, ax ; point ds to video base
		 xor di, di ; point di to top left column
		 cld ; set auto increment mode
		 rep movsw ; scroll up

		 mov ax, 0x0720 ; space in normal attribute
		 pop cx ; count of positions to clear
		 rep stosw ; clear the scrolled space
		 pop ds
		 pop es
		 pop di
		 pop si
		 pop cx
		 pop ax
		 pop bp
		 ret 2 
		 
		 

		printrec:
		push ax
		push bx
		push cx
		push dx
		mov ah,06h
		mov al,3
		mov bh,byte[colour]
		mov ch,byte[top_row]  ;top left row
		mov cl,byte[top_col]  ;top left col
		mov dh,25;bottom right row
		mov dl,byte[bot_col]  ;bottom right col
		int 10h
		mov cx,14
	l1:mov ax,1
		push ax 
		call scrollup
		;mnaging speed
		call sleep
		call sleep
		call sleep
		call sleep
		call sleep
		call sleep
		call sleep
		call sleep
		call sleep
		call sleep
		call sleep
		call sleep
		sub cx,1
		loop l1
		pop dx
		pop cx
		pop bx
		pop ax
		ret
		
start:
	call clrscr
	call main_print

mov ax,0x4c00
int 0x21
