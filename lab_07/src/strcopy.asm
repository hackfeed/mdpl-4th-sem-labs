GLOBAL strcopy
SECTION .TEXT

strcopy:
    MOV RCX, RDX
    CMP RSI, RDI
    JG SGETDIST
    JMP DGETDIST
    SGETDIST:
        MOV RAX, RSI
        SUB RAX, RDI
    DGETDIST:
        MOV RAX, RDI
        SUB RAX, RSI
    CMP RAX, RCX
    JG REPMOVSB
    CMP RSI, RDI
    JG REPMOVSB
    JMP REVERSE 
    REPMOVSB:
        REP MOVSB
        JMP ENDCP
    REVERSE:
        ADD RDI, RCX
        ADD RSI, RCX
        DEC RSI
        DEC RDI
        CPY:
            MOVSB
            SUB RSI, 2
            SUB RDI, 2
            LOOP CPY
    ENDCP:
    RET