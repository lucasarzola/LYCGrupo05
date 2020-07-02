include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
@Cte_Entera1 dw 1
@_a dw ?
@_b dw ?

.CODE
MAIN:
MOV EAX,@DATA
MOV DS,EAX
MOV ES,EAX
;ASIGNACION
	fild	@Cte_Entera1
	fistp	@_b

	displayInteger @_b,3


	MOV EAX, 4c00h
	INT 21h
END MAIN

;FIN DEL PROGRAMA DE USUARIO
