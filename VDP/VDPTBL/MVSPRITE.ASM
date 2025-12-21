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

Init:
	ld a,0 		  	  	; indice do sprite
	ld b,0            	; padrao do sprite
	ld c,3            	; cor do sprite
	ld d,16           	; posicao inicial X
	ld e,2           	; posicao inicial Y 
SpriteLoop:
	call PUTSPRITESC1 	; desenha sprite na posição (d,e)
	inc D
	inc E
	push af
	call PausaUmSegundo
	pop af
	jp SpriteLoop
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