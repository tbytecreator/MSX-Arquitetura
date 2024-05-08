; =====================================
; LEITURA DO REG DE STATUS DO VDP
; =====================================
include "HWD\BIOS.ASM"
include "HWD\CONST.ASM"
include "HWD\VAR.ASM"

org romArea
	db "AB"
	dw ProgramStart
	db 00,00,00,00,00

ProgramStart:
	CALL LimparTela		; LIMPA A TELA
	CALL ReadVDPPorts	; LE AS PORTAS DO VDP PARA RAM
	CALL ReadVDPStatus	; LE O STATUS DO VDP
	CALL ImprimeNumero	; IMPRIME O NUMERO LIDO
  	DI
  	Halt

; =============================================================================
; FIM PROGRAMA
; =============================================================================
include "HWD\LIB.ASM"
include "HWD\PT-BR.ASM"
include "HWD\TMS9918.ASM"

; =============================================================================
; PADDING
; =============================================================================
romPad:
 ds romSize-(romPad-romArea),0