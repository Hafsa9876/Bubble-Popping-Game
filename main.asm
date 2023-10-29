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
 printnum_s2: push bp 
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
		nextdigitp: mov dx, 0 ; zero upper half of dividend
		 div bx ; divide by 10
		 add dl, 0x30 ; convert digit into ascii value
		 push dx ; save ascii value on stack
		 inc cx ; increment count of values
		 cmp ax, 0 ; is the quotient zero
		 jnz nextdigitp ; if no divide it again
		 mov di, 986 ; point di to top left column
		 nextposp: pop dx ; remove a digit from the stack
		 mov dh, 00001011b ; use normal attribute
		 mov [es:di], dx ; print char on screen
		 add di, 2 ; move to next screen location
		 loop nextposp ; repeat for all digits on stack
		 pop di
		 pop dx
		 pop cx
		 pop bx
		 pop ax
		 pop es
		 pop bp
		 ret 2 
	
	printnum2: push bp 
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
		nextdigit2: mov dx, 0 ; zero upper half of dividend
		 div bx ; divide by 10
		 add dl, 0x30 ; convert digit into ascii value
		 push dx ; save ascii value on stack
		 inc cx ; increment count of values
		 cmp ax, 0 ; is the quotient zero
		 jnz nextdigit2 ; if no divide it again
		 mov di, 2776 ; point di to top left column
		 nextpos2: pop dx ; remove a digit from the stack
		 mov dh, 00111111b ; use normal attribute
		 mov [es:di], dx ; print char on screen
		 add di, 2 ; move to next screen location
		 loop nextpos2 ; repeat for all digits on stack
		 pop di
		 pop dx
		 pop cx
		 pop bx
		 pop ax
		 pop es
		 pop bp
		 ret 2 
		cmp_s:
		mov ch,0  ;row
			l02:mov cl,20 ;col
				l3:mov dh, ch
					mov dl, cl
					mov bh, 0
					mov ah, 2
					int 10h
					mov bh,0
					mov ah,08h
					int 10h
					cmp al,'s'
					je ptnt_s
					add cl,1
					cmp cl,78
					jne l3
				add ch,1
				cmp ch,24
				jne l02
			jmp s_end
				ptnt_s:		
				add word[score],10
				
				 mov ax,[score]
				 push ax
				 call printnum
		      call beep				
				mov byte[row_index],ch
				mov byte[col_index],cl
				sub byte[col_index],3
				sub byte[row_index],1
				mov si,0
				j2:mov dh, byte[row_index]
				mov dl, byte[col_index]
				mov bh, 0
				mov ah, 2
				int 10h
				
				mov al,'*'
				mov bh,0
				mov bl,10001011b
				mov cx,6
				mov ah,09h
				int 10h
				add byte[row_index],1
				add si,1
				cmp si,3
				jne j2
				
				
				s_end:
				ret
					
scrollup: push ax
		push bx
		push cx
		push dx
		mov ah,6
		mov al,1 ; no of lines to scroll up
		mov bh,0 ; colour of bg
		mov ch,0
		mov cl,20
		mov dl,79
		mov dh,24 
		int 10h  

		 pop dx
		 pop cx
		 pop bx
		 pop ax
		 ret
		 
		cmp_a:
		
		mov ch,0  ;row
			l01:mov cl,20 ;col
				l2:mov dh, ch
					mov dl, cl
					mov bh, 0
					mov ah, 2
					int 10h
					mov bh,0
					mov ah,08h
					int 10h
					cmp al,'a'
					je ptnt_a
					add cl,1
					cmp cl,78
					jne l2
				add ch,1
				cmp ch,24
				jne l01
				jmp a_end
				ptnt_a:		
		add word[score],10
		 mov ax,[score]
		 push ax
		 call printnum
		  call beep 
		mov byte[row_index],ch
		mov byte[col_index],cl
		sub byte[col_index],3
		sub byte[row_index],1
		mov si,0
		j1:mov dh, byte[row_index]
		mov dl, byte[col_index]
		mov bh, 0
		mov ah, 2
		int 10h
		
		mov al,'*'
		mov bh,0
		mov bl,10001001b
		mov cx,6
		mov ah,09h
		int 10h
		add byte[row_index],1
		add si,1
		cmp si,3
		jne j1
		
		
		a_end:
		ret	
		cmp_k:
		
		mov ch,0  ;row
			l04:mov cl,20 ;col
				l5:mov dh, ch
					mov dl, cl
					mov bh, 0
					mov ah, 2
					int 10h
					mov bh,0
					mov ah,08h
					int 10h
					cmp al,'k'
					je ptnt_k
					add cl,1
					cmp cl,78
					jne l5
				add ch,1
				cmp ch,24
				jne l04
		jmp k_end
						ptnt_k:		
				add word[score],10
				
				 mov ax,[score]
				 push ax
				 call printnum
				  call beep
				mov byte[row_index],ch
				mov byte[col_index],cl
				sub byte[col_index],3
				sub byte[row_index],1
				mov si,0
				j4:mov dh, byte[row_index]
				mov dl, byte[col_index]
				mov bh, 0
				mov ah, 2
				int 10h
				
				mov al,'*'
				mov bh,0
				mov bl,10000010b
				mov cx,6
				mov ah,09h
				int 10h
				add byte[row_index],1
				add si,1
				cmp si,3
				jne j4
				
				
				k_end:
				ret
cmp_z:
		
		mov ch,0  ;row
			l05:mov cl,20 ;col
				l6:mov dh, ch
					mov dl, cl
					mov bh, 0
					mov ah, 2
					int 10h
					mov bh,0
					mov ah,08h
					int 10h
					cmp al,'z'
					je ptnt_z
					add cl,1
					cmp cl,78
					jne l6
				add ch,1
				cmp ch,24
				jne l05	
		jmp z_end
						ptnt_z:		
				add word[score],10
				
				 mov ax,[score]
				 push ax
				 call printnum
				  call beep
				mov byte[row_index],ch
				mov byte[col_index],cl
				sub byte[col_index],3
				sub byte[row_index],1
				mov si,0
				j5:mov dh, byte[row_index]
				mov dl, byte[col_index]
				mov bh, 0
				mov ah, 2
				int 10h
				
				mov al,'*'
				mov bh,0
				mov bl,10001100b
				mov cx,6
				mov ah,09h
				int 10h
				add byte[row_index],1
				add si,1
				cmp si,3
				jne j5
				
				
				z_end:
				ret
	cmp_l:
		mov ch,0  ;row
			l06:mov cl,20 ;col
				l7:mov dh, ch
					mov dl, cl
					mov bh, 0
					mov ah, 2
					int 10h
					mov bh,0
					mov ah,08h
					int 10h
					cmp al,'l'
					je ptnt_l
					add cl,1
					cmp cl,78
					jne l7
				add ch,1
				cmp ch,24
				jne l06
		jmp l_end
						ptnt_l:		
				add word[score],10
				
				 mov ax,[score]
				 push ax
				 call printnum
				 call beep
				mov byte[row_index],ch
				mov byte[col_index],cl
				sub byte[col_index],3
				sub byte[row_index],1
				mov si,0
				j6:mov dh, byte[row_index]
				mov dl, byte[col_index]
				mov bh, 0
				mov ah, 2
				int 10h
				
				mov al,'*'
				mov bh,0
				mov bl,10000101b
				mov cx,6
				mov ah,09h
				int 10h
				add byte[row_index],1
				add si,1
				cmp si,3
				jne j6
				
				
				l_end:
				ret
		compare:
		mov ah,00h
		int 16h
		cmp al,'a'
		je pop_bubble1
		cmp al,'s'
		je pop_bubble2
		cmp al,'g'
		je pop_bubble3
		cmp al,'k'
		je pop_bubble4
		cmp al,'z'
		je pop_bubble5
		cmp al,'l'
		je pop_bubble6
		cmp al,'p'
		je  pop_bubble7
		jne end
		;if a is presses the print time and function
			pop_bubble1:	
			call cmp_a
				jmp end
				
				
				pop_bubble2:	
				call cmp_s
				jmp end
				
				
				pop_bubble3:	
				call cmp_g
				jmp end
				
				pop_bubble4:	
				call cmp_k
				jmp end
				
				pop_bubble5:	
				call cmp_z
				jmp end
				
				pop_bubble6:	
			call cmp_l
				jmp end
				
				pop_bubble7:	
			call cmp_p
				jmp end
				
		
		end:
		ret
	printrec:
		push bp
		mov bp,sp
		sub sp,2
		sub sp,2
		sub sp,2
		push ax
		push bx
		push cx
		push dx
		push si
		mov ah,06h
		mov al,3
		mov bh,byte[colour]
		mov ch,byte[top_row]  ;top left row
		mov cl,byte[top_col]  ;top left col
		mov dh,25;bottom right row
		mov dl,byte[bot_col]  ;bottom right col
		int 10h
		
		; alphabet
		 mov ax, [bp+8]
		 push ax ; push x position
		 mov ax, [bp+6]
		 push ax ; push y position
		 mov ax, [bp+4] ; blue on black attribute
		 push ax ; push attribute
		 mov ax, char
		 push ax ; push address of message
		push  word [length];; push message length
		 call printstr 
	
		 mov cx,8
		l1:
		;check if any key is pressed
		mov ah,01h
		int 16h
		;if pressed jump to check which one is pressed
		jnz key_pressed
		;if not then continue
		jmp cont
		
		key_pressed:call compare
		
		cont:
		
		call scrollup
		 
		call update_time
		
		sub cx,1
		jnz l1
		
		
		add sp,6
		pop si
		pop dx
		pop cx
		pop bx
		pop ax
		mov sp,bp
		pop bp
		ret 6
			print_sc:
	push ax
	push cx
		;1st
		mov byte[top_col],44
		mov byte[top_row],10	
		mov byte[bot_col],49
		mov byte[colour],15h
		mov ax,47
		push ax
		mov ax,23
		push ax
		mov ax,00011111b
		push ax
		mov byte[char],'a'
		call printrec	
		
		
		;2nd
		mov byte[top_col],31
		mov byte[top_row],10	
		mov byte[bot_col],36
		mov byte[colour],33h
		mov ax,34
		push ax
		mov ax,23
		push ax
		mov ax,00111111b
		push ax
		mov byte[char],'s'
		call printrec	
		;3rth
		mov byte[top_col],70
		mov byte[top_row],20
		mov byte[bot_col],75
		mov byte[colour],64h
		mov ax,73
		push ax
		mov ax,23
		push ax
		mov ax,01101111b
		push ax
		mov byte[char],'g'
		call printrec
		;4th
		mov byte[top_col],21
		mov byte[top_row],7	
		mov byte[bot_col],26
		mov byte[colour],22h
		mov ax,24
		push ax
		mov ax,23
		push ax
		mov ax,00101111b
		push ax
		mov byte[char],'k'
		call printrec	
;5th
		mov byte[top_col],53
		mov byte[top_row],7	
		mov byte[bot_col],58
		mov byte[colour],44h
		mov ax,56
		push ax
		mov ax,23
		push ax
		mov ax,01001111b
		push ax
		mov byte[char],'z'
		call printrec
		;6th
		mov byte[top_col],33
		mov byte[top_row],7	
		mov byte[bot_col],38
		mov byte[colour],51h
		mov ax,36
		push ax
		mov ax,23
		push ax
		mov ax,01011111b
		push ax
		mov byte[char],'l'
		call printrec
;7th
		mov byte[top_col],60
		mov byte[top_row],7	
		mov byte[bot_col],65
		mov byte[colour],33h
		mov ax,63
		push ax
		mov ax,23
		push ax
		mov ax,00111111b
		push ax
		mov byte[char],'p'
		call printrec
		pop cx
		pop ax
ret
main_print:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		push cx
		mov cx,4   ;2 loop take 68 sec
		lop1:call print_sc
		sub cx,1
		je pp_end
		loop lop1
		pp_end:
		pop cx
		ret
;;;;;;;;;;;;;;;;time ;;;;;;;;;;;;;;;;;
		timer:
		;call update_time
		call print_t_s
		call main_print
		MOV     CX, 0FH ;;these 4 lines when runs at once produce 18.6seconds
		MOV     DX, 4240H
		MOV     AH, 86H
		INT     15H
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
 print_t_s:
 push ax
 push bx
		
 	mov bx,3
	loop1:	 mov ax, bx
		 push ax ; push x position
		 mov ax, 4
		 push ax ; push y position
		 mov ax, 00001011b ; blue on black attribute
		 push ax ; push attribute
		 mov ax, msg_sl
		 push ax ; push address of message
		 push  word [length];; push message length
		 call printstr 
		 add bx,1
		 cmp bx,18
		 jne loop1
	 
		 mov bx,3
	loop2:	 mov ax, bx
		 push ax ; push x position
		 mov ax, 8
		 push ax ; push y position
		 mov ax, 00001011b ; blue on black attribute
		 push ax ; push attribute
		 mov ax, msg_sl
		 push ax ; push address of message
		push  word [length];; push message length
		 call printstr 
		 add bx,1
		 cmp bx,18
		 jne loop2
		 mov bx,3
	loop11:	 mov ax, bx
		 push ax ; push x position
		 mov ax, 12
		 push ax ; push y position
		 mov ax, 00001011b ; blue on black attribute
		 push ax ; push attribute
		 mov ax, msg_sl
		 push ax ; push address of message
		push  word [length];; push message length
		 call printstr 
		 add bx,1
		 cmp bx,18
		 jne loop11
		 
		  mov ax,4
		  push ax ; push x position
		 mov ax, 14
		 push ax ; push y position
		 mov ax, 00001011b ; blue on black attribute
		 push ax ; push attribute
		 mov ax, msg1
		 push ax ; push address of message
		push  word [len1];; push message length
		 call printstr
		 ;printing score
		 mov ax,[score]
		 push ax
		 call printnum
 mov bx,3
	loop22:	 mov ax, bx
		 push ax ; push x position
		 mov ax, 16
		 push ax ; push y position
		 mov ax, 00001011b ; blue on black attribute
		 push ax ; push attribute
		 mov ax, msg_sl
		 push ax ; push address of message
		push  word [length];; push message length
		 call printstr 
		add bx,1
		cmp bx,18
		jne loop22
		mov ax,[Time_m]
	push ax
	call printnum_m
		mov ax,[Time_s1]
	push ax
	call printnum_s1
		mov ax,[Time_s2]
	push ax
	call printnum_s2
		;call update_time
		pop bx
		 pop ax

	ret
game_ending:
		 push ax
		 mov ax, 10
		 push ax ; push x position
		 mov ax, 4
		 push ax ; push y position
		 mov ax,  00111111b ; blue on black attribute
		 push ax ; push attribute
		 mov ax, e1
		 push ax ; push address of message
		push  word [len_over];; push message length
		 call printstr 

		  mov ax, 10
		 push ax ; push x position
		 mov ax, 5
		 push ax ; push y position
		 mov ax,  00111111b ; blue on black attribute
		 push ax ; push attribute
		 mov ax, e2
		 push ax ; push address of message
		push  word [len_over];; push message length
		 call printstr

				  mov ax, 10
		 push ax ; push x position
		 mov ax, 6
		 push ax ; push y position
		 mov ax,  00111111b ; blue on black attribute
		 push ax ; push attribute
		 mov ax, e3
		 push ax ; push address of message
		push  word [len_over];; push message length
		 call printstr
			  mov ax, 10
		 push ax ; push x position
		 mov ax, 7
		 push ax ; push y position
		 mov ax,  00111111b; blue on black attribute
		 push ax ; push attribute
		 mov ax, e4
		 push ax ; push address of message
		push  word [len_over];; push message length
		 call printstr

				  mov ax, 10
		 push ax ; push x position
		 mov ax, 8
		 push ax ; push y position
		 mov ax,  00111111b; blue on black attribute
		 push ax ; push attribute
		 mov ax, e5
		 push ax ; push address of message
		push  word [len_over];; push message length
		 call printstr
			  mov ax, 10
		 push ax ; push x position
		 mov ax, 9
		 push ax ; push y position
		 mov ax, 00111111b; blue on black attribute
		 push ax ; push attribute
		 mov ax, e6
		 push ax ; push address of message
		push  word [len_over];; push message length
		 call printstr
		  mov ax, 10
		 push ax ; push x position
		 mov ax, 10
		 push ax ; push y position
		 mov ax,  00111111b ; blue on black attribute
		 push ax ; push attribute
		 mov ax, e7
		 push ax ; push address of message
		push  word [len_over];; push message length
		 call printstr
		ret
start:
	call clrscr
	call main_print

mov ax,0x4c00
int 0x21
