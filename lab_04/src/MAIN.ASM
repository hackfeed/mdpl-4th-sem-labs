; Stack segment.
STACKSEG SEGMENT PARA STACK 'STACK'
    DB 100 DUP(0)
STACKSEG ENDS

; Matrix segment.
DATASEG SEGMENT PARA 'DATA'
    DECR DW 0
    STEP DW 0
    ROWS DB ?
    COLS DB 0
    COLSDIVTWO DB ?
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
        MOV SI, DECR
        SUB CX, SI
        ADD DECR, 1
        LOOP INMAT

    CALL CRLF

    MOV AH, 0
    MOV AL, COLS 
    MOV BL, 2
    DIV BL

    MOV COLSDIVTWO, AL

    MOV DECR, 0

    MOV BX, 0
    MOV CL, ROWS
    EXCHANGE:
        MOV CL, COLSDIVTWO
        MOV DI, 0
        COLEX:
            MOV AL, MATRIX[BX]
            MOV SI, BX
            MOV DH, COLS
            ADD SI, DX
            SUB SI, DI
            MOV DL, MATRIX[SI]
            MOV MATRIX[SI], AL
            MOV MATRIX[BX], DL
            ADD DI, 1
            ADD BX, 1
            LOOP COLEX
        MOV CL, ROWS
        MOV SI, DECR
        SUB CX, SI
        ADD DECR, 1
        LOOP EXCHANGE

    MOV DECR, 0

    MOV BX, 0
    MOV CL, ROWS
    OUTMAT:
        MOV CL, COLS
        OUTROW:
            MOV DL, MATRIX[BX]
            CALL OUTSYMB
            ADD BX, 1
            CALL PRINTSPACE
            LOOP OUTROW
        CALL CRLF
        MOV CL, ROWS
        MOV SI, DECR
        SUB CX, SI
        ADD DECR, 1
        LOOP OUTMAT


    ; Program termination.
    MOV AX, 4C00H
    INT 21H
CODESEG ENDS
END MAIN
