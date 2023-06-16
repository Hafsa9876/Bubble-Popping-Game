[org 0x0100]
jmp start
e1:db '     _____          __  __ ______     '  
e2:db '    / ____|   /\   |  \/  |  ____|    '        
e3:db '   | |  __   /  \  | \  / | |__       '        
e4:db '   | | |_ | / /\ \ | |\/| |  __|      '
e5:db '   | |__| |/ ____ \| |  | | |____     '
e6:db '    \_____/_/    \_\_|  |_|______|    '
e7:db '     _____ ___      ___ ______ ___    '
e8:db '    / ___ \\  \    /  /|  ____|  _ \  '
e9:db '   | |   | |\  \  /  / | |__  | |_| | '    
e10:db'   | |   | | \  \/  /  |  __| |  _ /  '
e11:db'   | |___| |  \    /   | |____| |\ \  '
e12:db'    \_____/    \__/    |______|_| \_\ '
e13:db'                                      '  		
e14:db'                                      '  		
e15:db'                                      '  			         
len_over:dw 40
top_row: db 0
top_col: db 0
bot_row: db 0
bot_col: db 0
colour: db 0
msg: db 'Time:  :'
len: dw 8
msg1: db 'Score: '
len1: dw 7
msg_sl: db '-'
char : db ' '
length:dw 1
msg2: db 'x '
len2: dw 1
row_inp:dw 0
row_index: db 0
col_index: db 0
score : dw 00
Time_m:dw 0
Time_s1:dw 0
Time_s2:dw 0
comp:dw 0
old_kbisr: dd 0
temp:dw 0

	; subroutine to clear the screen
	sleep: push cx
	mov cx, 0xFFFF
	delay: loop delay
	pop cx
	ret
		sec_delay:
    MOV     CX, 07H
	MOV     DX, 0xa120
	MOV     AH, 86H
	INT     15H
	ret

beep:

     push ax
      push bx
      push cx
      push dx


      mov     al, 182         ; Prepare the speaker for the
      out     43h, al         ;  note.
      mov     ax, 9121        ; Frequency number (in decimal)
      ;  for middle C.
      out     42h, al         ; Output low byte.
      mov     al, ah          ; Output high byte.
      out     42h, al
      in      al, 61h         ; Turn on note (get value from
      ;  port 61h).
      or      al, 00000011b   ; Set bits 1 and 0.
      out     61h, al         ; Send new value.
      mov     bx, 25          ; Pause for duration of note.
      .pause1:
     mov     cx, 6535
      .pause2:
     dec     cx
      jne     .pause2
      dec     bx
      jne     .pause1
      in      al, 61h         ; Turn off note (get value from
      ;  port 61h).
      and     al, 11111100b   ; Reset bits 1 and 0.
      out     61h, al         ; Send new value.

      pop dx
      pop cx
      pop bx
      pop ax

      ret


	add_score:
		 push cx
		 mov cx,0
		 add cx,10
		 pop cx
		   ret
		   
		t1:
	add word[Time_s2],1
	call sec_delay
	mov ax,[Time_s2]
	push ax
	call printnum_s2
	ret
	
	t2:add word[Time_s2],1
	call sec_delay
	mov ax,[Time_s2]
	push ax
	call printnum_s1
	ret

	
	t3:add word[Time_m],1
	call sec_delay
	mov ax,[Time_m]
	push ax
	call printnum_m
	mov word[Time_s1],0
		mov word[Time_s2],0
	mov ax,[Time_s1]
	push ax
	call printnum_s1
		mov ax,[Time_s2]
	push ax
	call printnum_s2
	ret
	update_time:
	push ax
	push cx
	push si
	cmp word[Time_m],2
	je m_end
	cmp word[Time_m],1
	jge m2
	cmp word[Time_s2],9
	jge t_l2
	



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
		
		
		
	print_sc:
		;1st
		mov byte[top_col],34
		mov byte[top_row],10	
		mov byte[bot_col],39
		mov byte[colour],15h
		call printrec	

		;2nd
		mov byte[top_col],21
		mov byte[top_row],10	
		mov byte[bot_col],26
		mov byte[colour],33h
		call printrec	
		
		;3rth
		mov byte[top_col],60
		mov byte[top_row],20
		mov byte[bot_col],65
		mov byte[colour],64h
		call printrec
		;4th
		mov byte[top_col],7
		mov byte[top_row],7	
		mov byte[bot_col],12
		mov byte[colour],22h
		call printrec	
		;5th
		mov byte[top_col],43
		mov byte[top_row],7	
		mov byte[bot_col],48
		mov byte[colour],44h
		call printrec
		;6th
		mov byte[top_col],23
		mov byte[top_row],7	
		mov byte[bot_col],28
		mov byte[colour],51h
		call printrec
		;7th
		mov byte[top_col],50
		mov byte[top_row],7	
		mov byte[bot_col],55
		mov byte[colour],33h
		call printrec
	
		ret
	
			 printnum_s1: push bp 
		 mov bp, sp
		 push es
		 push ax
		 push bx
		 push cx
		 push dx
		 push di
		 mov ax, 0xb800
		 mov es, ax ; point es to video base
		 mov ax, [bp+4] ; load number in ax
		 mov bx, 10 ; use base 10 for division
		 mov cx, 0 ; initialize count of digits
		nextdigitps1: mov dx, 0 ; zero upper half of dividend
		 div bx ; divide by 10
		 add dl, 0x30 ; convert digit into ascii value
		 push dx ; save ascii value on stack
		 inc cx ; increment count of values
		 cmp ax, 0 ; is the quotient zero
		 jnz nextdigitps1 ; if no divide it again
		 mov di, 984 ; point di to top left column
		 nextposps1: pop dx ; remove a digit from the stack
		 mov dh, 00001011b ; use normal attribute
		 mov [es:di], dx ; print char on screen
		 add di, 2 ; move to next screen location
		 loop nextposps1 ; repeat for all digits on stack
		 pop di
		 pop dx
		 pop cx
		 pop bx
		 pop ax
		 pop es
		 pop bp
		 ret 2 	
		main_print:
		push cx
		mov cx,6
		lop1:call print_sc
		sub cx,1
		loop lop1
		pop cx
		ret
				
		printstr: push bp
		 mov bp, sp
		 push es
		 push ax
		 push cx
		 push si
		 push di
		 mov ax, 0xb800
		 mov es, ax ; point es to video base
		 mov al, 80 ; load al with columns per row
		 mul byte [bp+10] ; multiply with y position
		 add ax, [bp+12] ; add x position
		 shl ax, 1 ; turn into byte offset
		 mov di,ax ; point di to required location
		 mov si, [bp+6] ; point si to string
		 mov cx, [bp+4] ; load length of string in cx
		 mov ah, [bp+8] ; load attribute in ah
		nextchar1: mov al, [si] ; load next char of string
		 mov [es:di], ax ; show this char on screen
		 add di, 2 ; move to next screen location
		 add si, 1 ; move to next char in string
		 loop nextchar1 ; repeat the operation cx times
		 pop di
		 pop si
		 pop cx
		 pop ax
		 pop es
		 pop bp
		 ret 10 
		printnum_m: push bp 
		 mov bp, sp
		 push es
		 push ax
		 push bx
		 push cx
		 push dx
		 push di
		 mov ax, 0xb800
		 mov es, ax ; point es to video base
		 mov ax, [bp+4] ; load number in ax
		 mov bx, 10 ; use base 10 for division
		 mov cx, 0 ; initialize count of digits
		nextdigitpm: mov dx, 0 ; zero upper half of dividend
		 div bx ; divide by 10
		 add dl, 0x30 ; convert digit into ascii value
		 push dx ; save ascii value on stack
		 inc cx ; increment count of values
		 cmp ax, 0 ; is the quotient zero
		 jnz nextdigitpm ; if no divide it again
		 mov di, 980 ; point di to top left column
		 nextpospm: pop dx ; remove a digit from the stack
		 mov dh, 00001011b ; use normal attribute
		 mov [es:di], dx ; print char on screen
		 add di, 2 ; move to next screen location
		 loop nextpospm ; repeat for all digits on stack
		 pop di
		 pop dx
		 pop cx
		 pop bx
		 pop ax
		 pop es
		 pop bp
		 ret 2 
start:
	call clrscr
	call main_print

mov ax,0x4c00
int 0x21
