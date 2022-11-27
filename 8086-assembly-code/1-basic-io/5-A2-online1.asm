
.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH  
    
    NL DB CR,LF,'$'
    FL_PRMT DB CR,LF,'Enter first letter: $'
    ML_PRMT DB CR,LF,'Enter middle letter: $'
    LL_PRMT DB CR,LF,'Enter last letter: $' 
    STAR_ROW DB CR,LF,'*******$' 
    THREE_STAR DB '***$'
    TWO_STAR DB '**$'
    X DB ? 
    Y DB ? 
    Z DB ?

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; FRIST LETTER INPUT  
    LEA DX, FL_PRMT
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H  
    MOV X, AL
    
    ; MIDDLE LETTER INPUT  
    LEA DX, ML_PRMT
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H  
    MOV Y, AL
    
    ; LAST LETTER INPUT  
    LEA DX, LL_PRMT
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H  
    MOV Z, AL
         
     
    ; OUTPUT  
    
    ; 1ST ROW
    LEA DX, STAR_ROW
    MOV AH, 9
    INT 21H 
      
    ; 2ND ROW
    LEA DX, STAR_ROW
    MOV AH, 9
    INT 21H
    
    LEA DX, NL
    MOV AH, 9
    INT 21H
       
    ; 3RD ROW
    LEA DX, THREE_STAR
    MOV AH, 9
    INT 21H
           
     
    MOV DL, X
    MOV AH, 2
    INT 21H
    
    LEA DX, THREE_STAR
    MOV AH, 9
    INT 21H 
    
    
    LEA DX, NL
    MOV AH, 9
    INT 21H
    
    ; 4TH ROW
    LEA DX, TWO_STAR
    MOV AH, 9
    INT 21H
           
     
    MOV DL, X
    MOV AH, 2
    INT 21H
    
    MOV DL, Y
    MOV AH, 2
    INT 21H
    
    MOV DL, Z
    MOV AH, 2
    INT 21H
    
    LEA DX, TWO_STAR
    MOV AH, 9
    INT 21H 
    
    
    LEA DX, NL
    MOV AH, 9
    INT 21H
    
    ; 5TH ROW
    LEA DX, THREE_STAR
    MOV AH, 9
    INT 21H
           
     
    MOV DL, Z
    MOV AH, 2
    INT 21H
    
    LEA DX, THREE_STAR
    MOV AH, 9
    INT 21H 
    
    ; 6TH ROW
    LEA DX, STAR_ROW
    MOV AH, 9
    INT 21H 
      
    ; 7TH ROW
    LEA DX, STAR_ROW
    MOV AH, 9
    INT 21H
    
    ;DOS exit
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP
END MAIN


