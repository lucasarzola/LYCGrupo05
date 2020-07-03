include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA
@Cte_String1 db "hola", '$', 30 dup (?)
@Cte_String2 db "chau", '$', 30 dup (?)
@Cte_Real1 dd 1.600000
@Cte_Real2 dd 2.350000
@Cte_Entera1 dd 3
@Cte_Entera2 dd 2
@Cte_Entera3 dd 5
@Cte_Entera4 dd 16
@Cte_Entera5 dd 1
@Cte_String3 db "Esto", '$', 30 dup (?)
@Cte_Entera6 dd 7
@Cte_Entera7 dd 8
@Cte_Entera8 dd 323
@Cte_Entera9 dd 1
@Cte_Entera10 dd 1
@_a dd ?
@_b dd ?
@_c dd ?
@_d dd ?
@_str1 db ?, '$', 30 dup (?)

@_str2 db ?, '$', 30 dup (?)

@_f dd ?
@_j dd ?
@_@r dd ?
@_@resFact1 dd ?
@_@fact dd ?
@_@resExp1 dd ?
@_@resExp2 dd ?
@_@F1 dd ?
@_@F2 dd ?
@_@resExp3 dd ?
@_@resComb1 dd ?
@_@F3 dd ?
@auxFloat0 dd 0.0
@auxInt0 dd 0
@auxFloat1 dd 0.0
@auxInt1 dd 0
@auxFloat2 dd 0.0
@auxInt2 dd 0
@auxFloat3 dd 0.0
@auxInt3 dd 0
@auxFloat4 dd 0.0
@auxInt4 dd 0
@auxFloat5 dd 0.0
@auxInt5 dd 0
@auxFloat6 dd 0.0
@auxInt6 dd 0
@auxFloat7 dd 0.0
@auxInt7 dd 0
@auxFloat8 dd 0.0
@auxInt8 dd 0
@auxFloat9 dd 0.0
@auxInt9 dd 0
@auxFloat10 dd 0.0
@auxInt10 dd 0
@auxFloat11 dd 0.0
@auxInt11 dd 0
@auxFloat12 dd 0.0
@auxInt12 dd 0
@auxFloat13 dd 0.0
@auxInt13 dd 0
@auxFloat14 dd 0.0
@auxInt14 dd 0
@auxFloat15 dd 0.0
@auxInt15 dd 0

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
;Asignacon String
	mov si, OFFSET	@Cte_String1
	mov di, OFFSET	@_str1
	call copy
;SALIDA
	displayString 	@_str1
	newLine 1
;ASIGNACION
;Asignacon String
	mov si, OFFSET	@Cte_String2
	mov di, OFFSET	@_str1
	call copy
;SALIDA
	displayString 	@_str1
	newLine 1
;ASIGNACION
;Asignacon Float
	fld	@Cte_Real1
	fstp	@_f
;ASIGNACION
;Asignacon Float
	fld	@Cte_Real2
	fstp	@_j
;SALIDA
	displayFloat 	@_f,3
	newLine 1
;SALIDA
	displayFloat 	@_j,3
	newLine 1
;ASIGNACION
;Asignacion Integer
	fild	@Cte_Entera1
	fistp	@_b
;ASIGNACION
;Asignacion Integer
	fild	@Cte_Entera2
	fistp	@_a
;ASIGNACION
;Asignacion Integer
	fild	@Cte_Entera3
	fistp	@_c
fild	@_c
fidivr	@_b
fistp	@auxInt0
fild	@auxInt0
fiadd	@_a
fistp	@auxInt1
;ASIGNACION
;Asignacion Integer
	fild	@auxInt1
	fistp	@_d
;SALIDA
	displayInteger 	@_d,3
	newLine 1
	fild 	@Cte_Entera1
	fild 	@_a
	fcomp
	fstsw	ax
	sahf
	ja		ETIQ46
;ASIGNACION
;Asignacion Integer
	fild	@Cte_Entera4
	fistp	@_c

ETIQ46:

ETIQ46:
	fild 	@Cte_Entera2
	fild 	@_d
	fcomp
	fstsw	ax
	sahf
	jbe		ETIQ70
fild	@Cte_Entera5
fisubr	@_d
fistp	@auxInt2
;ASIGNACION
;Asignacion Integer
	fild	@auxInt2
	fistp	@_d

ETIQ56:
	fild 	@Cte_Entera2
	fild 	@_c
	fcomp
	fstsw	ax
	sahf
	jbe		ETIQ68
fild	@Cte_Entera5
fisubr	@_c
fistp	@auxInt3
;ASIGNACION
;Asignacion Integer
	fild	@auxInt3
	fistp	@_c
	jmp		ETIQ56

ETIQ68:
	jmp		ETIQ46

ETIQ70:
;SALIDA
	displayInteger 	@_d,3
	newLine 1
;SALIDA
	displayString 	@Cte_String3
	newLine 1
;SALIDA
	displayInteger 	@_C,3
	newLine 1
	fild 	@Cte_Entera5
	fild 	@_b
	fcomp
	fstsw	ax
	sahf
	jbe		ETIQ86
;ASIGNACION
;Asignacion Integer
	fild	@Cte_Entera3
	fistp	@_@r
	jmp		ETIQ89

ETIQ86:
;ASIGNACION
;Asignacion Integer
	fild	@Cte_Entera6
	fistp	@_@r

ETIQ89:
;ASIGNACION
;Asignacion Integer
	fild	@_@r
	fistp	@_a
;SALIDA
	displayInteger 	@_a,3
	newLine 1
	fild 	@Cte_Entera5
	fild 	@_b
	fcomp
	fstsw	ax
	sahf
	jbe		ETIQ104
;ASIGNACION
;Asignacion Integer
	fild	@Cte_Entera7
	fistp	@_a
	jmp		ETIQ107

ETIQ104:
;ASIGNACION
;Asignacion Integer
	fild	@Cte_Entera8
	fistp	@_b

ETIQ107:
;SALIDA
	displayInteger 	@_a,3
	newLine 1
;ASIGNACION
;Asignacion Integer
	fild	@Cte_Entera1
	fistp	@_@resFact1
;ASIGNACION
;Asignacion Integer
	fild	@Cte_Entera5
	fistp	@_@fact

ETIQ115:
	fild 	@Cte_Entera5
	fild 	@_@resFact1
	fcomp
	fstsw	ax
	sahf
	jb		ETIQ132
fild	@_@resFact1
fimul	@_@fact
fistp 	@auxInt4
;ASIGNACION
;Asignacion Integer
	fild	@auxInt4
	fistp	@_@fact
fild	@Cte_Entera5
fisubr	@_@resFact1
fistp	@auxInt5
;ASIGNACION
;Asignacion Integer
	fild	@auxInt5
	fistp	@_@resFact1
	jmp		ETIQ115

ETIQ132:
;ASIGNACION
;Asignacion Integer
	fild	@_@fact
	fistp	@_c
fild	@_b
fiadd	@_a
fistp	@auxInt6
;ASIGNACION
;Asignacion Integer
	fild	@auxInt6
	fistp	@_d
;SALIDA
	displayInteger 	@_c,3
	newLine 1
;ASIGNACION
;Asignacion Integer
	fild	@Cte_Entera5
	fistp	@_@resExp1
;ASIGNACION
;Asignacion Integer
	fild	@Cte_Entera2
	fistp	@_@resExp2
;ASIGNACION
;Asignacion Integer
	fild	@Cte_Entera5
	fistp	@_@F1
;ASIGNACION
;Asignacion Integer
	fild	@Cte_Entera5
	fistp	@_@F2
fild	@_@resExp2
fisubr	@_@resExp1
fistp	@auxInt7
;ASIGNACION
;Asignacion Integer
	fild	@auxInt7
	fistp	@_@resExp3

ETIQ159:
	fild 	@Cte_Entera5
	fild 	@_@resExp1
	fcomp
	fstsw	ax
	sahf
	jb		ETIQ176
fild	@_@resExp1
fimul	@_@F1
fistp 	@auxInt8
;ASIGNACION
;Asignacion Integer
	fild	@auxInt8
	fistp	@_@F1
fild	@Cte_Entera5
fisubr	@_@resExp1
fistp	@auxInt9
;ASIGNACION
;Asignacion Integer
	fild	@auxInt9
	fistp	@_@resExp1
	jmp		ETIQ159

ETIQ176:
	fild 	@Cte_Entera5
	fild 	@_@resExp2
	fcomp
	fstsw	ax
	sahf
	jb		ETIQ193
fild	@_@resExp2
fimul	@_@F1
fistp 	@auxInt10
;ASIGNACION
;Asignacion Integer
	fild	@auxInt10
	fistp	@_@F1
fild	@Cte_Entera5
fisubr	@_@resExp2
fistp	@auxInt11
;ASIGNACION
;Asignacion Integer
	fild	@auxInt11
	fistp	@_@resExp2
	jmp		ETIQ176

ETIQ193:
	fild 	@Cte_Entera5
	fild 	@_@resExp3
	fcomp
	fstsw	ax
	sahf
	jb		ETIQ210
fild	@_@resExp3
fimul	@_@F1
fistp 	@auxInt12
;ASIGNACION
;Asignacion Integer
	fild	@auxInt12
	fistp	@_@F1
fild	@Cte_Entera5
fisubr	@_@resExp3
fistp	@auxInt13
;ASIGNACION
;Asignacion Integer
	fild	@auxInt13
	fistp	@_@resExp3
	jmp		ETIQ193

ETIQ210:
fild	@_@F3
fimul	@_@F2
fistp 	@auxInt14
fild	@auxInt14
fidivr	@_@F1
fistp	@auxInt15
;ASIGNACION
;Asignacion Integer
	fild	@auxInt15
	fistp	@_@resComb1
;ASIGNACION
;Asignacion Integer
	fild	@_@resComb1
	fistp	@_d
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
