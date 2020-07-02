include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
@Cte_Entera1 dw 1
@Cte_Entera2 dw 2
@_a dw ?
@_b dw ?
@auxFloat0 dd 0
@auxInt0 dw 0

.CODE
MAIN:
MOV EAX,@DATA
MOV DS,EAX
MOV ES,EAX
fild    @Cte_Entera2
fiadd   @Cte_Entera1
fistp   @auxInt0
;ASIGNACION
    fild    @auxInt0
    fistp   @_b

    displayInteger @_b,3


    MOV EAX, 4c00h
    INT 21h
END MAIN

;FIN DEL PROGRAMA DE USUARIO
