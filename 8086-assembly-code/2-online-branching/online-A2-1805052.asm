.MODEL SMALL 
.STACK 100H 
.DATA

N DW ?
CR EQU 0DH
LF EQU 0AH 

NL DB CR, LF , "$"
MSG DB "Invalid$"



.CODE 
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    
    ; fast BX = 0
    XOR BX, BX
    
    INPUT_LOOP:
    ; char input 
    MOV AH, 1
    INT 21H
    
    ; if \n\r, stop taking input
    CMP AL, CR    
    JE END_INPUT_LOOP
    CMP AL, LF
    JE END_INPUT_LOOP
    
    ; fast char to digit
    ; also clears AH
    AND AX, 000FH
    
    ; save AX 
    MOV CX, AX
    
    ; BX = BX * 10 + AX
    MOV AX, 10
    MUL BX
    ADD AX, CX
    MOV BX, AX
    JMP INPUT_LOOP
    
    END_INPUT_LOOP:
    MOV N, BX
    
    ; printing CR and LF
    MOV AH, 2
    MOV DL, CR
    INT 21H
    MOV DL, LF
    INT 21H
    
    
    ;------------------------------------
    ; start from here
    ; input is in N
    
    
    
    MOV DX, N
    
    ; if N >= 80
    CMP DX, 100
    JG INVALID
    ; if N >= 80
    CMP DX, 80
    JGE A_PLUS
    ; if N >= 75
    CMP DX, 75
    JGE A
    ; if N >= 70
    CMP DX, 70
    JGE A_MINUS
    ; if N >= 65
    CMP DX, 65
    JGE B_PLUS
    ; if N >= 60
    CMP DX, 60
    JGE B 
    ; if N >= 60
    CMP DX, 0
    JGE F
    
    ; ELSE
    INVALID: 
    LEA DX, MSG
    MOV AH, 9
    INT 21H
    
    JMP END_IF 
        
    
    
    A_PLUS:
        MOV AH, 2
        MOV DL, 41H ; PRINT A
        INT 21H
        MOV AH, 2
        MOV DL, 2BH ; PRINT +
        INT 21H
        
        JMP END_IF
    A:
        MOV AH, 2
        MOV DL, 41H ; PRINT A
        INT 21H
        
        JMP END_IF 
    A_MINUS:
        MOV AH, 2
        MOV DL, 41H ; PRINT A
        INT 21H
        MOV AH, 2
        MOV DL, 2DH ; PRINT -
        INT 21H
        
        JMP END_IF
    B_PLUS:
        MOV AH, 2
        MOV DL, 42H ; PRINT B
        INT 21H
        MOV AH, 2
        MOV DL, 2BH ; PRINT +
        INT 21H
        
        JMP END_IF
    B:
        MOV AH, 2
        MOV DL, 42H ; PRINT B
        INT 21H
        
        JMP END_IF 
    F:  
        MOV AH, 2
        MOV DL, 46H ; PRINT F
        INT 21H

        
        JMP END_IF
    
    END_IF:
    
    
    
      

	; interrupt to exit
    MOV AH, 4CH
    INT 21H
    
  
MAIN ENDP 
END MAIN 




