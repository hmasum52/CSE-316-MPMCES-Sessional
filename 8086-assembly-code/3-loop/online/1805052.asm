.MODEL SMALL 
.STACK 100H 


.DATA


CR EQU 0DH
LF EQU 0AH 

NL DB CR, LF , "$"

n DW ? ; user input
NEG_FLAG DB 0

.CODE 
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    
    CALL INPUT_NUM_IN_BX
    MOV n, BX 
       
    MOV DX, 0; cnt = 0
    MOV CX, n 
    
    ;MOV AX, n
    ;CALL DIVISOR_SUM_AX_BX
    FOR_LOOP:
        MOV AX, CX
        CALL DIVISOR_SUM_AX_BX 
        
        CMP BX, N
        JNG NOT_FAUTLY
            
        INC DX
           
        NOT_FAUTLY:   
       
    LOOP FOR_LOOP
    
    MOV BX, DX 
    CALL PRINT_NUM_FROM_BX
    
	; interrupt to exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP 


DIVISOR_SUM_AX_BX PROC
    PUSH AX
    PUSH CX
    PUSH DX
    
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX 
    
    MOV CX, 2 ; i
    MOV BX, 0 ; sum
    
    DS_LOOP:
        PUSH AX
        CMP CX, AX ; CX = AX = n
        JE END_DS_LOOP ;break
        
        XOR DX, DX
        
        DIV CX 
        
        CMP DX, 0 ; if reminder dx == 0
        JNE DS_INC ; continue
        
        
        ADD BX, CX ; sum += i;
        
        DS_INC:
        INC CX ; i++
        POP AX 
        JMP DS_LOOP; next iteration
        
    END_DS_LOOP: 
    POP AX
    
    POP DX
    POP CX
    POP AX
    RET
    
DIVISOR_SUM_AX_BX ENDP


; ========= print new line ============
PRINT_NEWLINE PROC
    LEA DX,NL
    CALL PRINT_STR
PRINT_NEWLINE ENDP

; ========= print string ==============
PRINT_STR PROC
    MOV AH, 9
    INT 21H
    RET
PRINT_STR ENDP

; take a input from user
; store the integer input in BX
INPUT_NUM_IN_BX PROC 
    MOV NEG_FLAG,0 ; reset to 0
    XOR AX, AX; Clear AX ===============
    
    XOR BX, BX ; clear BX ==============
    
    PUSH CX; back CX register to use it
    
    ; loop starts ======================
    INPUT_LOOP:
        ; char input 
        MOV AH, 1
        INT 21H
    
        ; if \n\r, stop taking input
        CMP AL, CR ; \r input
        JE END_INPUT_LOOP_WITH_NEWLINE
        CMP AL, LF ; \n input
        JE END_INPUT_LOOP_WITH_NEWLINE
        CMP AL, ' ' ; space input
        JE END_INPUT_LOOP
    
        ; check if the number is negative number
        ; if AL == '-'
        CMP AL, 2DH ; - input
        JNE DIGIT_INPUT
        MOV NEG_FLAG, 1
        JMP INPUT_LOOP ; iterate from here to read digit
    
        ; else
        DIGIT_INPUT:
        ; char to digit
        ; also clears AH
        AND AX, 000FH 
        
        ; save AX 
        MOV CX, AX
        
        ; BX = BX * 10 + CX
        MOV AX, 10 ; AX = 10
        MUL BX ; AX = BX * AX = BX * 10
        ADD AX, CX ; AX = AX + CX = BX*10 + CX
        MOV BX, AX 
        JMP INPUT_LOOP; iterate again
    END_INPUT_LOOP_WITH_NEWLINE:
    CALL PRINT_NEWLINE
    
    END_INPUT_LOOP: ; loop ends ===========
    
    ; if NEG_FLAG == 1
    CMP NEG_FLAG, 1
    JNE END_INPUT
    NEG BX ; BX = -BX
    ; esle
    END_INPUT:
    POP CX
    RET
INPUT_NUM_IN_BX ENDP

; print the integer stored in AX
PRINT_NUM_FROM_BX PROC
    PUSH CX  
    ; push to stack to 
    ; check the end of the number  
    MOV AX, 'X'
    PUSH AX
    
    CMP BX, 0  
    JE ZERO_NUM
    JNL NON_NEGATIVE 
    
    NEG BX
    ; print - for negative number
    MOV DL, '-'
    MOV AH, 2
    INT 21H
    JMP NON_NEGATIVE  
    
    ZERO_NUM:
        MOV DX, 0
        PUSH DX
        JMP POP_PRINT_LOOP
    
    NON_NEGATIVE:
    
    MOV CX, 10 
    
    MOV AX, BX
    PRINT_LOOP:
        ; if AX == 0
        CMP AX, 0
        JE END_PRINT_LOOP
        ; else
        MOV DX, 0 ; DX:AX = 0000:AX
        
        ; AX = AX / 10 ; store reminder in DX 
        DIV CX
    
        PUSH DX
        
        JMP PRINT_LOOP

    END_PRINT_LOOP:
    
    
    
    POP_PRINT_LOOP:
        POP DX
        ; loop ending condition
        ; if DX == 'X'
        CMP DX, 'X'
        JE END_POP_PRINT_LOOP
        
        ; if DX == '-'
        CMP DX, '-'
        JE PRINT_TO_CONSOLE
        
        ; convert to ascii
        ADD DX, 30H       
        ; print the digit
        PRINT_TO_CONSOLE:
        MOV AH, 2
        INT 21H
        
        JMP POP_PRINT_LOOP
    
    END_POP_PRINT_LOOP: 
    POP CX
    RET
PRINT_NUM_FROM_BX ENDP      



