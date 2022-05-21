
.MODEL SMALL
.STACK 100H

.DATA
CR EQU 0DH ;hex D is carriage return in ascii. will use it for new line
LF EQU 0AH ;hex A is Line feed in ascii or new line

X_PROMT DB "Enter X: $"
Y_PROMT DB "Enter Y: $" 

X DB ? 
Y DB ?
Z DB ? 
temp DB ?


.CODE
MAIN PROC
    ; DATA SEGMENT INIT
    MOV AX, @DATA
    MOV DS, AX 
     
    
    ; take X input 
    LEA DX, X_PROMT
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H 
    MOV X, AL  
             
    ; print new line by printing both CR and LF
    MOV DL, CR
    MOV AH, 2  ; 
    INT 21H
    MOV DL, LF
    MOV AH, 2  ; 
    INT 21H 
    
    ; take Y input
    LEA DX, Y_PROMT
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H 
    MOV Y, AL
    
    
    ; Z = X - 2Y
    MOV AL, X
    MOV BL, Y
    SUB AL, BL
    ADD AL, 30H
    SUB AL, BL 
    ADD AL, 30H 
    MOV Z, AL  
    
    ; print new line by printing both CR and LF
    MOV DL, CR
    MOV AH, 2  ; 
    INT 21H
    MOV DL, LF
    MOV AH, 2  ; 
    INT 21H  
    
    ; print Z
    MOV DL, Z
    MOV AH, 2; print single char
    INT 21H
    
    
    ; exit procedure
    MOV AH, 4CH
    INT 21H  
    
MAIN ENDP  ; end of main procedure
END MAIN ; end of the program






