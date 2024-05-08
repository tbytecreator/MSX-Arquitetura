; =====================================
; LEITURA DO REG DE STATUS DO VDP
; =====================================

; =====================================
; LE AS PORTAS DO VDP (READ E WRITE)
; =====================================
include "HWD\BIOS.ASM"
include "HWD\CONST.ASM"
include "HWD\VAR.ASM"

org romArea
	db "AB"
	dw ProgramStart
	db 00,00,00,00,00

ProgramStart:
	CALL ReadVDPport
	CALL ReadVDPStatus
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