; =====================================
; LEITURA DA PORTA DO VDP 
; =====================================

; =====================================
; LE O ENDERECO 0006H
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
	ld c,(0006H)		; LE A PORTA PADRAO DO VDP NO REGISTRADOR C
	inc c				; SETA A PORTA DO REGISTRADOR DE STATUS NO C
	in a,(c)			; LE O STATUS NO ACUMULADOR 
	call ImprimeNumero  ; IMPRIME O REG DE STATUS DO VDP 
  	DI
  	Halt

; =============================================================================
; FIM PROGRAMA
; =============================================================================
include "HWD\LIB.ASM"

; =============================================================================
; PADDING
; =============================================================================
romPad:
 ds romSize-(romPad-romArea),0