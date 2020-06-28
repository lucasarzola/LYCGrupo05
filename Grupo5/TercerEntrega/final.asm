include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA

a   dd  ?
b   dd  ?
result  dd  ?
R   dd  ?
_100m   dd  100000.0

.CODE
    MOV AX,@DATA
    MOV DS,AX
    FINIT
FFREE
FLD _100m
FSTP    a
DisplayFloat a,2
FINAL:
    mov ah, 1
    int 21h
    MOV AX, 4c00h
    INT 21h
END

;FIN DEL PROGRAMA DE USUARIO
