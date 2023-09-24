; =====================================
; CHAMADAS DA BIOS RELACIONADAS
; A PPI DO MSX 
; =====================================

; =====================================
; 0138h (RSLREG)
; =====================================
; DESCRICAO	: 	LE UM BYTE DA PORTA DE 
;			  	I/O 0A8h PARA O 
;				ACUMULADOR
; PARMETROS	:	---
; SAIDA 	: 	A
; MODIFICA 	: 	A
; =====================================

; =====================================
; LE A PORTA A8H
; =====================================
include "HWD\BIOS.ASM"
include "HWD\CONST.ASM"
include "HWD\VAR.ASM"

org romArea
	db "AB"
	dw ProgramStart
	db 00,00,00,00,00

ProgramStart:
	call LimparTela
  	call INIT32
    ld hl,Message1
  	call ImprimeString
	call RSLREG
	call ImprimeNumero
  	DI
  	Halt

; =============================================================================
; FIM PROGRAMA
; =============================================================================
include "HWD\LIB.ASM"
include "HWD\PT-BR.ASM"

; =============================================================================
; PADDING
; =============================================================================
romPad:
 ds romSize-(romPad-romArea),0