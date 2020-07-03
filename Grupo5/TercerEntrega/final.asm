include macros2.asm
include number.asm

.MODEL LARGE
.386
.STACK 200h

.DATA

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

	MOV EAX, 4c00h
	INT 21h
END MAIN

;FIN DEL PROGRAMA DE USUARIO
