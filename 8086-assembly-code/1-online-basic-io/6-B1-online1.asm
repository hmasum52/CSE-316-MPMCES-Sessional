.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH  
    
    NL DB CR,LF,'$'
    PRMT DB CR,LF,"Enter a character: $"
    X DB ? 

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; INPUT A CHARACTER
    LEA DX, PRMT
    MOV AH, 9
    INT 21H

    MOV AH, 1
    INT 21H  
    MOV X, AL
    SUB X, 61H ; a is 61H
         
    ; CALCUALTE OUTPUT
    MOV BL, X
    SUB BL, 48H ; SUBSTRUCT 'H'
    NEG BL
    ADD BL, 30H   
     
    ; PRINT NEWLINE
    LEA DX, NL
    MOV AH, 9
    INT 21H
           
    ; PRINT 1
    MOV DL, 31H 
    MOV AH, 2
    INT 21H
            
    ; PRINT 2ND DIGIT
    MOV DL, BL
    MOV AH, 2
    INT 21H   
    
    ;DOS exit
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP
END MAIN


