; =====================================
; TABELAS DO VDP MSX 1
; =====================================
include "HWD/BIOS.ASM"
include "HWD/CONST.ASM"
include "HWD/VAR.ASM"

org romArea
	db "AB"
	dw ProgramStart
	db 00,00,00,00,00

ProgramStart:
Screen1:
	call INIT32     			; entra na screen 1
	call SC1LOADPATTERN 		; carrega a tabela de padrões
	call SC1LOADCOLOR			; carrega a tabela de cores
	call SC1LOADSPRITEPATTERN 	; carrega a tabela de sprites
	ld a,65						; vamos escrever o caractere 'A'
	ld b,0						; zera MSB
	ld c,15 					; na coluna 15
	ld d,0						; zera MSB 
	ld e,12         			; na linha 12	
	call SC1LOCATE				; rotina para posicionar o cursor
	ld a,0						; A = índice do sprite (0-31)
	ld b,0						; B = padrão do sprite (0-255)
	ld c,3						; C = cor do sprite (0-15)
	ld d,15						; D = coordenada X (0-32)
	ld e,12						; E = coordenada Y (0-24)
loop:
	call PUTSPRITESC1			; coloca o sprite na tela
	ld d,16
	ld e,13						; 
	call PUTSPRITESC1			; coloca o sprite na tela
	ld d,17
	ld e,14						; 
	call PUTSPRITESC1			; coloca o sprite na tela
	ld d,18
	ld e,15						
	call PUTSPRITESC1			; coloca o sprite na tela
	jp loop						; loop infinito
EndProgram:	
	call CHGET					; espera por uma tecla
	di
	halt 
	
; =====================================
; FIM PROGRAMA
; =====================================
include "HWD/Z80.ASM"
include "HWD/PT-BR.ASM"
include "HWD/TMS9918.ASM"
include "AST/FONT.ASM"
include "AST/COLOR.ASM"
include "AST/SPRITES.ASM"

; =====================================
; PADDING
; =====================================
romPad:
 ds romSize-(romPad-romArea),0