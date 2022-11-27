.MODEL SMALL
.STACK 100

.DATA   

CR EQU 0DH
    LF EQU 0AH  
    
    NL DB CR,LF,'$'
    PRMT DB CR,LF,"Enter a number: $"
    EQLT  DB CR,LF,"Equilateral $"
    ISOT  DB CR,LF, "Isocelous $"
    SCLT  DB CR,LF, "Scaling $" 

    a DB ? 
    b DB ? 
    c DB ?

.CODE
MAIN PROC
    ; load data
    MOV AX, @DATA
    MOV DS, AX 
    
    ; INPUT A number
    LEA DX, PRMT
    MOV AH, 9
    INT 21H 
    
    MOV AH, 1
    INT 21H
    MOV a, AL 
    
    ; INPUT A number
    LEA DX, PRMT
    MOV AH, 9
    INT 21H 
    
    MOV AH, 1
    INT 21H
    MOV b, AL  
    
    ; INPUT A number
    LEA DX, PRMT
    MOV AH, 9
    INT 21H 
    
    MOV AH, 1
    INT 21H
    MOV c, AL    
    
    ; if a==b
    MOV DL, a
    CMP DL, b
    JE A_EQ_B
    ;else
    JMP A_NEQ_B
    
    A_EQ_B:  
        ; if a==c   
        MOV DL, a
        CMP DL, c
        JNE ISO ; jmp to else
        ; print iso
        JMP EQ_LATERAL ; jmp to if body
    A_NEQ_B:
        ; if a == c
        MOV DL, a
        CMP DL, c
        JE ISO
        ; else if b == c
        MOV DL, b
        CMP DL, c
        JE ISO
        ; else
        JMP SCALING     
            
    EQ_LATERAL:
       LEA DX, EQLT
       MOV AH, 9
       INT 21H
       JMP END_IF
    
    ISO:
       LEA DX, ISOT
       MOV AH, 9
       INT 21H
       JMP END_IF
    
    SCALING: 
       LEA DX, SCLT
       MOV AH, 9
       INT 21H
       JMP END_IF
    
    END_IF:
        

    ;DOS exit
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP
END MAIN