; Stack segment.
STACKSEG SEGMENT PARA STACK 'STACK'
    DB 100 DUP(0)
STACKSEG ENDS

; Buffer segment.
DATASEG1 SEGMENT PARA 'DATA'
    DB 100
    DB 0
    DB 101 DUP(0)
DATASEG1 ENDS

; Result data segment.
DATASEG2 SEGMENT PARA 'DATA'
    DB 2 DUP(0)
DATASEG2 ENDS

; Main code segment.
CODESEG SEGMENT PARA 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG1, ES:DATASEG2, SS:STACKSEG
MAIN:
    ; DATASEG1 preparation.
    MOV AX, DATASEG1
    MOV DS, AX

    ; Echoed input.
    MOV AH, 0AH
    MOV DX, 0
    INT 21H
    
    ; Sum of 2nd and 5th digits from input.
    MOV DH, DS:3
    SUB DH, 48
    ADD DH, DS:6
    MOV ES:1, DH
    
    ; Output of found sum.
    MOV AH, 2
    MOV DL, 13
    INT 21H
    MOV DL, 10
    INT 21H
    MOV DL, ES:1
    INT 21H
    
    ; Program termination.
    MOV AH, 4CH
    INT 21H
CODESEG ENDS
END MAIN
