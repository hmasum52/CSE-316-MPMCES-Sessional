
.MODEL SMALL
.STACK 100H

.DATA
CR EQU 0DH ;hex D is carriage return in ascii. will use it for new line
LF EQU 0AH ;hex A is Line feed in ascii  

X DB ? ; 1 byte(0000) ; will be init later

Y DW ? ; 2 byte <0001>

; hello world string const
HW DB 'HELLO WORLD!$' ; 1 byte <0003> ; HW STORES POINTER TO THE STRING

.CODE
MAIN PROC
    ; DATA SEGMENT INIT
    MOV AX, @DATA
    MOV DS, AX 
    
    
    ; PRINT HELLO WORLD
    ;LEA DX, HW ; LOAD EFFECTIVE ADDRESS OF HW(POINTER TO THE STRING)
    ; or use offeset to copy the address to DX
    MOV DX, OFFSET HW ; LEA and MOV + OFFSET do the same  
    ; MOV DL, HW  ; store 48H(asscii of H> to DL
    MOV AH, 9 ; 9 PRINTS STRING TO THE CONSOLE
    INT 21H 
    
    
    
    ; take user input
    MOV AH, 1 ; call input function 1. take input to AL(only 1 character)
    INT 21H 
    MOV X, AL ; copy input value to X
    
    
    ; add 5 with 
    ADD X, 5 ; if X is ascii 31H(or 1) X+5 will be ascii 35H which is 6 in decimal  
    
    MOV DL, X
    MOV AH, 2  ; 2 PRINTS 1 CHARACTER TO CONSOLE
    INT 21H 
    
    ; exit procedure
    MOV AH, 4CH
    INT 21H  
    

MAIN ENDP  ; end of main procedure
END MAIN ; end of the program


