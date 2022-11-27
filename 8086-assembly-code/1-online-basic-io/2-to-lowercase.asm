
.MODEL SMALL
.STACK 100H

.DATA
CR EQU 0DH ;hex D is carriage return in ascii. will use it for new line
LF EQU 0AH ;hex A is Line feed in ascii  

X DB ? ; 1 byte(0000) ; will be init later


.CODE
MAIN PROC
    ; DATA SEGMENT INIT
    MOV AX, @DATA
    MOV DS, AX 
     
    
    ; take user input
    MOV AH, 1 ; 1 takes a character input from console
    INT 21H 
    MOV X, AL ; copy input value to X
    
    
    ; add 5 with 
    ADD X, 32 ; convert to lower case
    
    MOV DL, 20H
    MOV AH, 2  ; 2 PRINTS 1 CHARACTER TO CONSOLE
    INT 21H   
    
    MOV DL, X
    MOV AH, 2  ; 2 PRINTS 1 CHARACTER TO CONSOLE
    INT 21H 
    
    ; exit procedure
    MOV AH, 4CH
    INT 21H  
    

MAIN ENDP  ; end of main procedure
END MAIN ; end of the program






