; Stack segment.
STACKSEG SEGMENT PARA STACK 'STACK'
    DB 100 DUP(0)
STACKSEG ENDS

; Matrix segment.
DATASEG SEGMENT PARA 'DATA'
    RMSG DB 'Enter matrix rows: $'
    CMSG DB 'Enter matrix columns: $'
    MMSG DB 'Enter matrix:$'
    RESMSG DB 'Reversed matrix:$'
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

; Input symbol with echo.
INSYMB:
    MOV AH, 1
    INT 21H
    RET

; Echo symbol.
OUTSYMB:
    MOV AH, 2
    INT 21H
    RET

; Carriage return + line feed.
CRLF:
    MOV AH, 2
    MOV DL, 13
    INT 21H
    MOV DL, 10
    INT 21H
    RET

; Echo space symbol.
PRINTSPACE:
    MOV AH, 2
    MOV DL, ' '
    INT 21H
    RET

; Main code segment.
MAIN:
    ; DATASEG preparation.
    MOV AX, DATASEG
    MOV DS, AX

    ; Input invitation.
    MOV AH, 9
    MOV DX, OFFSET RMSG
    INT 21H

    ; Input ROWS.
    CALL INSYMB
    MOV ROWS, AL
    SUB ROWS, '0'
    CALL CRLF

    ; Input invitation.
    MOV AH, 9
    MOV DX, OFFSET CMSG
    INT 21H

    ; Input COLS.
    CALL INSYMB
    MOV COLS, AL
    SUB COLS, '0'
    CALL CRLF

    ; Input invitation.
    MOV AH, 9
    MOV DX, OFFSET MMSG
    INT 21H
    CALL CRLF

    ; Input matrix in matrix style.
    MOV BX, 0 ; Array index.
    MOV CL, ROWS ; Cycle index.
    INMAT:
        MOV CL, COLS ; Rewrite cycle index.
        INROW:
            CALL INSYMB ; Input symbol.
            MOV MATRIX[BX], AL ; Write it to Matrix.
            INC BX ; Increment array index.
            CALL PRINTSPACE ; Echo space.
            LOOP INROW
        CALL CRLF ; Start next row input from new line.
        MOV CL, ROWS ; Reset cycle index to rows.
        MOV SI, DECR ; Move decrement to register.
        SUB CX, SI ; Decrease cycle index.
        INC DECR ; Increase decrement.
        LOOP INMAT
     
    CALL CRLF

    ; Find half of columns to iterate over it.
    MOV AH, 0
    MOV AL, COLS 
    MOV BL, 2
    DIV BL

    ; If matrix is one-columned, then make it 1.
    CMP AL, 0
    JNE CODE
    ADD AL, 1
    CODE:
    MOV COLSDIVTWO, AL

    ; Reset decrement.
    MOV DECR, 0

    ; Swap Matrix columns.
    ; 1 with N, 2 with N-1 and so on.
    MOV BX, 0 ; Array index.
    MOV CL, ROWS ; Cycle index.
    EXCHANGE:
        MOV CL, COLSDIVTWO ; Rewrite cycle index.
        MOV DI, 1 ; Prepare to find N-m index.
        COLEXCHANGE:
            MOV AL, MATRIX[BX] ; Store m element in AL.
            ; Start N-m index magic.
            MOV SI, BX
            MOV DL, COLS
            MOV DH, 0
            ADD SI, DX
            SUB SI, DI
            ; End N-m index magic.
            MOV DL, MATRIX[SI] ; Store N-m element in DL.
            ; Exchange m and N-m elements of row.
            MOV MATRIX[SI], AL
            MOV MATRIX[BX], DL
            ADD DI, 2 ; Magic continues.
            INC BX ; Increase array index.
            LOOP COLEXCHANGE
        ADD BL, COLSDIVTWO ; Go to next row.
        TEST COLS, 1 ; If columns is odd.
        JP EVENN ; Jump when it is even.
        INC BX ; Increase BX in case of odd.
        EVENN:
        MOV CL, ROWS ; Reset cycle index to rows.
        MOV SI, DECR ; Move decrement to register.
        SUB CX, SI ; Decrease cycle index.
        INC DECR ; Increase decrement.
        LOOP EXCHANGE

    ; Output label.
    MOV AH, 9
    MOV DX, OFFSET RESMSG
    INT 21H
    CALL CRLF

    ; Reset decrement.
    MOV DECR, 0

    ; Output matrix in matrix style.
    MOV BX, 0 ; Array index.
    MOV CL, ROWS ; Cycle index.
    OUTMAT:
        MOV CL, COLS ; Rewrite cycle index.
        OUTROW:
            MOV DL, MATRIX[BX] ; Get element from Matrix.
            CALL OUTSYMB ; Echo it.
            INC BX ; Increment array index.
            CALL PRINTSPACE ; Echo space.
            LOOP OUTROW
        CALL CRLF ; Start next row output from new line.
        MOV CL, ROWS ; Reset cycle index to rows.
        MOV SI, DECR ; Move decrement to register.
        SUB CX, SI ; Decrease cycle index.
        INC DECR ; Increase decrement.
        LOOP OUTMAT

    ; Program termination.
    MOV AX, 4C00H
    INT 21H
CODESEG ENDS
END MAIN
