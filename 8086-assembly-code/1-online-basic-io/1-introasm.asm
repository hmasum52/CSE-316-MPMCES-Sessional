.MODEL SMALL
.STACK 100h
.DATA

	g DW 0   			; variable g declared
	ag DW 3 DUP(0)		; array ag declared

.CODE
	main PROC
		MOV AX, @DATA
		mov DS, AX
		; data segment loaded

		MOV BP, SP

		SUB SP, 2	;line 4: a declared: W. [BP-2]
		SUB SP, 2	;line 4: b declared: W. [BP-4]
		SUB SP, 6	;line 4: array c of size 3 declared
		; from W. [BP-6] to W. [BP-10]
	
		PUSH 1001	
		PUSH 2	
; line 5: 1001+2
		POP BX	;line 5: load 2
		POP AX	;line 5: load 1001
		ADD AX, BX	
		PUSH AX	;line 5: save 1001

; line 5: a=1001+2
		POP AX	;line 5: get 1001+2
		MOV W. [BP-2], AX	
		PUSH AX	;line 5: ;save a

		POP AX	;line 5: evaluated exp: a=1001+2;

		MOV AX, W. [BP-2]	;line 10: load a
		PUSH AX	
		INC AX	;line 10: a++
		MOV W. [BP-2], AX
	
; line 10: b=a++
		POP AX	;line 10: get a++
		MOV W. [BP-4], AX	
		PUSH AX	;line 10: ;save b

		POP AX	;line 10: evaluated exp: b=a++;

		MOV AX, W. [BP-4]	;line 11: load b
		PUSH AX	
		DEC AX	;line 11: b--
		MOV W. [BP-4], AX
	
		POP AX	;line 11: evaluated exp: b--;

		PUSH W. [BP-2]	;line 13: save a

; line 13: -a
		POP AX	
		NEG AX	
		PUSH AX	
		PUSH 10	
; line 13: -a+10
		POP BX	;line 13: load 10
		POP AX	;line 13: load -a
		ADD AX, BX	
		PUSH AX	;line 13: save -a

; line 13: b=-a+10
		POP AX	;line 13: get -a+10
		MOV W. [BP-4], AX	
		PUSH AX	;line 13: ;save b

		POP AX	;line 13: evaluated exp: b=-a+10;

; line 14: println(a)
		MOV BX, W. [BP-2]	;line 14: load a
		PUSH BX	
		CALL PRINT_DECIMAL_INTEGER
	
; line 15: println(b)
		MOV BX, W. [BP-4]	;line 15: load b
		PUSH BX	
		CALL PRINT_DECIMAL_INTEGER
	
		PUSH 0	
; line 17: a=0
		POP AX	;line 17: get 0
		MOV W. [BP-2], AX	
		PUSH AX	;line 17: ;save a

		POP AX	;line 17: evaluated exp: a=0;

		PUSH W. [BP-2]	;line 18: save a

; line 18: !a
		POP AX		;load a	
		CMP AX, 0	
		JE @L_1	
			PUSH 0	
			JMP @L_2	
		@L_1:
		PUSH 1
	
		@L_2:	
; line 18: b=!a
		POP AX	;line 18: get !a
		MOV W. [BP-4], AX	
		PUSH AX	;line 18: ;save b

		POP AX	;line 18: evaluated exp: b=!a;

; line 20: println(b)
		MOV BX, W. [BP-4]	;line 20: load b
		PUSH BX	
		CALL PRINT_DECIMAL_INTEGER
	

		@L_0:
		MOV AH, 4CH
		INT 21H
	main ENDP

	PRINT_NEWLINE PROC
        ; PRINTS A NEW LINE WITH CARRIAGE RETURN
        PUSH AX
        PUSH DX
        MOV AH, 2
        MOV DL, 0Dh
        INT 21h
        MOV DL, 0Ah
        INT 21h
        POP DX
        POP AX
        RET
    PRINT_NEWLINE ENDP

	PRINT_CHAR PROC
        ; PRINTS A 8 bit CHAR 
        ; INPUT : GETS A CHAR VIA STACK 
        ; OUTPUT : NONE    
        PUSH BP
        MOV BP, SP
        
        ; STORING THE GPRS
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSHF
        
        MOV DX, [BP + 4]
        MOV AH, 2
        INT 21H
    
        POPF  
        
        POP DX
        POP CX
        POP BX
        POP AX
        
        POP BP
        RET 2
    PRINT_CHAR ENDP

	PRINT_DECIMAL_INTEGER PROC NEAR
        ; PRINTS SIGNED INTEGER NUMBER WHICH IS IN HEX FORM IN ONE OF THE REGISTER
        ; INPUT : CONTAINS THE NUMBER  (SIGNED 16BIT) IN STACK
        ; OUTPUT : 
        
        ; STORING THE REGISTERS
        PUSH BP
        MOV BP, SP
        
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
        PUSHF
        
        MOV AX, [BP+4]
        ; CHECK IF THE NUMBER IS NEGATIVE
        OR AX, AX
        JNS @POSITIVE_NUMBER
        ; PUSHING THE NUMBER INTO STACK BECAUSE A OUTPUT IS WILL BE GIVEN
        PUSH AX

        MOV AH, 2
        MOV DL, 2Dh
        INT 21h

        ; NOW IT'S TIME TO GO BACK TO OUR MAIN NUMBER
        POP AX

        ; AX IS IN 2'S COMPLEMENT FORM
        NEG AX

        @POSITIVE_NUMBER:
            ; NOW PRINTING RELATED WORK GOES HERE

            XOR CX, CX      ; CX IS OUR COUNTER INITIALIZED TO ZERO
            MOV BX, 0Ah
            @WHILE_PRINT:
                
                ; WEIRD DIV PROPERTY DX:AX / BX = VAGFOL(AX) VAGSESH(DX)
                XOR DX, DX
                ; AX IS GUARRANTEED TO BE A POSITIVE NUMBER SO DIV AND IDIV IS SAME
                DIV BX                     
                ; NOW AX CONTAINS NUM/10 
                ; AND DX CONTAINS NUM%10
                ; WE SHOULD PRINT DX IN REVERSE ORDER
                PUSH DX
                ; INCREMENTING COUNTER 
                INC CX

                ; CHECK IF THE NUM IS 0
                OR AX, AX
                JZ @BREAK_WHILE_PRINT; HERE CX IS ALWAYS > 0

                ; GO AGAIN BACK TO LOOP
                JMP @WHILE_PRINT

            @BREAK_WHILE_PRINT:

            ;MOV AH, 2
            ;MOV DL, CL 
            ;OR DL, 30H
            ;INT 21H
            @LOOP_PRINT:
                POP DX
                OR DX, 30h
                MOV AH, 2
                INT 21h

                LOOP @LOOP_PRINT

        CALL PRINT_NEWLINE
        ; RESTORE THE REGISTERS
        POPF
        POP DX
        POP CX
        POP BX
        POP AX
        
        POP BP
        RET
    PRINT_DECIMAL_INTEGER ENDP


END MAIN
