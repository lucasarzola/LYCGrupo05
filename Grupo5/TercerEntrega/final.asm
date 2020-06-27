include macros2.asm
include number.asm

.MODEL LARGE
.STACK 200h
.386
.387
.DATA

	MAXTEXTSIZE equ 50
	FLD 1
	FLD 2
	FADD
	FSTP a
