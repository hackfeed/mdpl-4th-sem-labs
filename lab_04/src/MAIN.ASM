; Stack segment.
STACKSEG SEGMENT PARA STACK 'STACK'
    DB 100 DUP(0)
STACKSEG ENDS

; Matrix segment.
DATASEG SEGMENT PARA 'DATA'
    DECR DW 0
    ROWS DB ?
    COLS DB ?
    MATRIX DB 9 * 9 DUP(?)
DATASEG ENDS

; Main code segment.
CODESEG SEGMENT PARA 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG, SS:STACKSEG

INSYMB:
    MOV AH, 1
    INT 21H
    RET

OUTSYMB:
    MOV AH, 2
    INT 21H
    RET

CRLF:
    MOV AH, 2
    MOV DL, 13
    INT 21H
    MOV DL, 10
    INT 21H
    RET

PRINTSPACE:
    MOV AH, 2
    MOV DL, ' '
    INT 21H
    RET

MAIN:
    ; DATASEG preparation.
    MOV AX, DATASEG
    MOV DS, AX

    ; Input ROWS.
    CALL INSYMB
    MOV ROWS, AL
    SUB ROWS, '0'
    CALL CRLF

    ; Input COLS.
    CALL INSYMB
    MOV COLS, AL
    SUB COLS, '0'
    CALL CRLF

    ; Set CX to be ROWS * COLS.
    MOV BX, 0
    MOV CL, ROWS
    INMAT:
        MOV CL, COLS
        INROW:
            CALL INSYMB
            MOV MATRIX[BX], AL
            ADD BX, 1
            CALL PRINTSPACE
            LOOP INROW
        CALL CRLF
        MOV CL, ROWS
        MOV DX, DECR
        SUB CX, DX
        ADD DECR, 1
        LOOP INMAT

    CALL CRLF
    
    MOV AL, ROWS
    MOV BL, COLS
    MUL BL
    MOV CX, AX

    MOV BX, 0
    OUTMAT:
        MOV DL, MATRIX[BX]
        CALL OUTSYMB
        CALL CRLF
        ADD BX, 1
        LOOP OUTMAT

    ; Program termination.
    MOV AX, 4C00H
    INT 21H
CODESEG ENDS
END MAIN
