.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH  
    
    NL DB CR,LF,'$'
    X DB ? 

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; INPUT
    MOV AH, 1
    INT 21H  
    MOV X, AL
         
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
    
    ;DOX exit
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP
END MAIN


