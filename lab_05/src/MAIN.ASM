EXTRN INCMD: NEAR
EXTRN INDECUNSGN: NEAR
;EXTRN OUTBINSGN: NEAR

EXTRN CRLF: NEAR

; Stack segment.
STACKSEG SEGMENT PARA STACK 'STACK'
    DB 200H DUP(0)
STACKSEG ENDS

; Data segment.
DATASEG SEGMENT PARA 'DATA'
    MENU DB 'Available actions:', 13, 10, 10
        DB '0. Input unsigned decimal number;', 13, 10
        DB '1. Convert to unsigned hexadecimal;', 13, 10
        DB '2. Convert to signed binary;', 13, 10, 10
        DB '3. Exit program.', 13, 10, 10
        DB 'Choose action: $'
    ACTIONS DW INDECUNSGN, EXIT
DATASEG ENDS

; Main code segment.
CODESEG SEGMENT PARA 'CODE'
    ASSUME CS:CODESEG, DS:DATASEG, SS:STACKSEG

OUTMENU PROC NEAR
    MOV AH, 9
    MOV DX, OFFSET MENU
    INT 21H
    RET
OUTMENU ENDP

EXIT PROC NEAR
    MOV AX, 4C00H
    INT 21H
EXIT ENDP

; Main code segment.
MAIN:
    ; DATASEG preparation.
    MOV AX, DATASEG
    MOV DS, AX

    MAINLOOP:
        CALL OUTMENU
        CALL INCMD
        CALL CRLF
        CALL ACTIONS[SI]
        JMP MAINLOOP

CODESEG ENDS
END MAIN
