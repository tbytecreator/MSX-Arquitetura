; =====================================
; TABELAS DO VDP MSX 1
; =====================================
include "HWD\BIOS.ASM"
include "HWD\CONST.ASM"
include "HWD\VAR.ASM"

org romArea
	db "AB"
	dw ProgramStart
	db 00,00,00,00,00

ProgramStart:
Screen1:
	call INIT32     	; entra na screen 1
	call SC1LOADPATTERN ; carrega a tabela de padrões
	ld a,65				; vamos escrever o caractere 'A'
	ld b,0				; zera MSB
	ld c,0 				; na coluna 15
	ld d,0				; zera MSB 
	ld e,23         	; na linha 12	
	CALL SC1LOCATE		; rotina para posicionar o cursor
EndLoop:	
	di
	halt 
	
; =====================================
; FIM PROGRAMA
; =====================================
include "HWD\Z80.ASM"
include "HWD\PT-BR.ASM"
include "HWD\TMS9918.ASM"
include "AST\FONT.ASM"

; =====================================
; PADDING
; =====================================
romPad:
 ds romSize-(romPad-romArea),0