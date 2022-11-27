.MODEL SMALL 
.STACK 100H 


.DATA


CR EQU 0DH
LF EQU 0AH 

NL DB CR, LF , "$"

n DW ? ; user input
NEG_FLAG DB 0 ; flag for negative input
ARR DW 100 DUP(?) ; array for storing input
PROMT_0 DB CR,"Enter array size: $"
PROMT_1 DB CR,"Enter numbers: $"
PROMT_2 DB "Sorted array: $" 
PROMT_3 DB "Search a number: $"
NOT_FOUND DB CR,LF,"NOT FOUND$"
FOUND_AT DB "FOUND AT INDEX $"
SEARCH_AGAIN DB CR,LF, "Search again?(y/n): $"


.CODE 
MAIN PROC 
    MOV AX, @DATA
    MOV DS, AX
    
    ; ========= input array size N =============
    LEA DX, PROMT_0
    CALL PRINT_STR
    
    CALL INPUT_NUM_IN_BX
    MOV N,BX ; save to the input to N
    
    ; if n<= 0 go to END
    CMP BX, 0
    JLE END 
   
    LEA DX, PROMT_1
    CALL PRINT_STR
    
    ;========== take array of n integer as input ============= 
    LEA SI, ARR  ; point to the start of the array
    MOV CX, N 
    ARR_INPUT_LOOP:
        CALL INPUT_NUM_IN_BX 
        MOV [SI], BX
        ADD SI, 2  
    LOOP ARR_INPUT_LOOP
     
     
    ; ============= sort the array ===================
    LEA SI, ARR
    MOV DX, N
    CALL INSERTION_SORT_SI_DX
    
    ; ============ now print the number================ 
      
    LEA DX, PROMT_2 ; Sorted array:
    CALL PRINT_STR
    
    LEA SI, ARR
    MOV CX, N 
    ARR_OUTPUT_LOOP: 
        MOV BX, [SI]
        CALL PRINT_NUM_FROM_BX 
        ADD SI, 2 
         
        MOV DL , ' '
        MOV AH, 2
        INT 21H  
    LOOP ARR_OUTPUT_LOOP
    
    ; ============ input a number for binary search =============
    SEARCH:
    CALL PRINT_NEWLINE
    LEA DX, PROMT_3
    CALL PRINT_STR
    
    CALL INPUT_NUM_IN_BX
    MOV DX,BX ; number to be searched
    LEA SI, ARR ; array pointer 
    MOV BX, N ; size of the array
    CALL BINARY_SEARCH_SI_BX_DX
    
    ; if BX == -1
    CMP BX, -1
    JNE FOUND
        LEA DX, NOT_FOUND
        CALL PRINT_STR
        JMP END
    ; else
    FOUND:
        LEA DX, FOUND_AT
        CALL PRINT_STR
        CALL PRINT_NUM_FROM_BX
        
    
    END:
    ; ========= Ask user to search again ============
    CALL PRINT_NEWLINE
    LEA DX,SEARCH_AGAIN
    CALL PRINT_STR 
    
    MOV AH, 1
    INT 21H
    
    CMP AL, 'y'
    JE SEARCH
    
	; interrupt to exit
    MOV AH, 4CH
    INT 21H
MAIN ENDP 

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
; DX must be 1 if the number is negative
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

; before calling the function
; put array base address to SI
; and put array size in DX
; see: https://www.geeksforgeeks.org/insertion-sort/
INSERTION_SORT_SI_DX PROC
    ;back up
    PUSH SI
    PUSH DI
    
    MOV CX, DX ; CX -> N  
    DEC CX ; loop runs N-1 times
    ;LEA SI, ARR; SI -> arr[0]
    
    MOV BX, SI; BX = i = 0    
    
    ; clear register
    XOR DX, DX
   
    INSERTION_SORT_LOOP:
        ;PUSH BX ; back up BX to use it
        PUSH CX 
        
        MOV DI, SI; DI -> arr[i-1]
        
        ADD SI, 2 ; SI -> arr[i]
        MOV DX, [SI]; key = arr[i] 
                
        INSERTION_SORT_WHILE:  
            ; j >= 0
            CMP DI, BX
            JNGE END_INSERTION_SORT_WHILE
            
            ;arr[j] > key
            CMP [DI], DX
            JNG END_INSERTION_SORT_WHILE 
            
            ; Arr[j+1] = arr[j]
            MOV CX, [DI] ; temp = arr[j] 
            MOV [DI+2], CX ; arr[j+1] = temp 
            
            SUB DI,2 ; j--    
            
            JMP INSERTION_SORT_WHILE
     
        END_INSERTION_SORT_WHILE:
        
        MOV [DI+2], DX ; Arr[j+1] = key 
        
        POP CX; restore CX      
    LOOP INSERTION_SORT_LOOP 
    ; restore
    POP DI
    POP SI
    RET    
INSERTION_SORT_SI_DX ENDP  

; before calling the function
; put array base address to SI
; put array size in BX
; put number in DX 
; BX = index if found
; BX = -1 if not found
BINARY_SEARCH_SI_BX_DX PROC 
     ; backup registers
     PUSH AX
     PUSH CX
     PUSH SI
     PUSH DI  
     
     ; clear  registers
     XOR AX, AX
     XOR CX, CX
     
     ; will use AX = l, BX = m , CX = r
     MOV AX, 0 ; AX -> l 
     MOV CX, BX; CX = N
     DEC CX; CX -> r
     
     BS_LOOP:
         ; if l > r(AX>CX) then break
         CMP AX, CX
         JG END_BS_LOOP_NOT_FOUND
         
         ; else
         ; calculate mid
         MOV BX, AX
         ADD BX, CX ; BX = AX + CX = l + r
         SHR BX, 1 ; BX = BX/2 = (l+r)/2
         
         PUSH BX ; backup
         MOV DI, SI ; DI -> arr[0] 
         SHL BX, 1 ; BX = BX*2, 2 byte = 1 word
         ADD DI, BX ; DI -> arr[m]
         POP BX; restore
         
         CMP DX, [DI]
         JE BS_FOUND ; if arr[m] == DX
         JNG BS_LESS ; if arr[m] > DX    
         
             ; l = m + 1
             MOV AX, BX ; l = m
             INC AX ; l++ 
             JMP BS_LOOP
         
         ; else arr[m] <= DX   
         BS_LESS:
             ; r = m-1
             MOV CX, BX ; r = m
             DEC CX ; r-- 
             JMP BS_LOOP
            
     END_BS_LOOP_NOT_FOUND:
         MOV BX, -1;
         JMP END_BS_LOOP
         
     BS_FOUND:
        ADD BX, 1    
         
     END_BS_LOOP: 
         ; restore register 
         POP DI
         POP SI 
         POP CX
         POP AX 
     
     RET
     
BINARY_SEARCH_SI_BX_DX ENDP
    

END MAIN 


