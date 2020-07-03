include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
@Cte_Entera1 dd 3
@Cte_Entera2 dd 2
@Cte_Entera3 dd 5
@Cte_Entera4 dd 16
@Cte_Entera5 dd 1
@Cte_Entera6 dd 8
@Cte_Entera7 dd 323
@_a dd ?
@_b dd ?
@_c dd ?

.CODE

copy proc
	cpy_nxt:
	mov al, [si]
	mov [di], al
	inc si
	inc di
	cmp byte ptr [si],0
	jne cpy_nxt
	ret
	copy endp
MAIN:
MOV EAX,@DATA
MOV DS,EAX
MOV ES,EAX
;ASIGNACION
;Asignacon Integer
	fild	@Cte_Entera1
	fistp	@_b
;ASIGNACION
;Asignacon Integer
	fild	@Cte_Entera2
	fistp	@_a
;ASIGNACION
;Asignacon Integer
	fild	@Cte_Entera3
	fistp	@_c
	fild 	@Cte_Entera1
	fild 	@_a
	fcomp
	fstsw	ax
	sahf
	ja		ETIQ17
;ASIGNACION
;Asignacon Integer
	fild	@Cte_Entera4
	fistp	@_c
ETIQ17:	fild 	@Cte_Entera5
	fild 	@_b
	fcomp
	fstsw	ax
	sahf
	jbe		ETIQ27
;ASIGNACION
;Asignacon Integer
	fild	@Cte_Entera6
	fistp	@_a
	jmp		ETIQ30
ETIQ27:;ASIGNACION
;Asignacon Integer
	fild	@Cte_Entera7
	fistp	@_b
ETIQ30:;SALIDA
	displayInteger 	@_a,3
	newLine 1
;SALIDA
	displayInteger 	@_b,3
	newLine 1
;SALIDA
	displayInteger 	@_c,3
	newLine 1

	MOV EAX, 4c00h
	INT 21h
END MAIN

;FIN DEL PROGRAMA DE USUARIO
