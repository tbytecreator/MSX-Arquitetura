; =====================================
; DEMO REGISTRADPRES DE MODO DO VDP
; =====================================
include "HWD\BIOS.ASM"
include "HWD\CONST.ASM"
include "HWD\VAR.ASM"

; ======================================================
; M1 M2	M3 M4 M5 Mode	 		MSX Version BASIC Screen
; ======================================================
; 1	 0	0  0  0	 40x24 Text		1 2 2+ tR	0
; 1	 0	0  1  0	 80x24 Text	  	2 2+ tR	    0
; 0	 0	0  0  0	 32x24 Text		1 2 2+ tR	1
; 0	 0	1  0  0	 Graphics 1		1 2 2+ tR	2
; 0	 1	0  0  0	 Multicolour	1 2 2+ tR	3
; ======================================================

;INITXT: Inicializa VDP em modo texto 40x24
;INIT32: Inicializa VDP em modo texto 32x24
;INIGRP: Inicializa VDP em modo gráfico 256x192
;INIMLT: Inicializa VDP em modo multicolorido 64x48

org romArea
	db "AB"
	dw ProgramStart
	db 00,00,00,00,00

ProgramStart:
Screen0:
	call INITXT
	ld hl,Message0
	call ImprimeString
	call NovaLinha
	call ImprimeRegMode 
	call CHGET
Screen1:
	call INIT32
	ld hl,Message1
	call ImprimeString
	call NovaLinha
	call ImprimeRegMode
	call CHGET
Screen2:
	call INIGRP
	ld hl,Message2
	call ImprimeStringSC2
	call NovaLinhaSC2
	call ImprimeRegModeSC2
	call CHGET
Screen3:
	call INIMLT
	ld hl,Message3
	call ImprimeStringSC2
	call NovaLinhaSC2
	call ImprimeRegModeSC2
	call CHGET
Fim:
	di
	halt

ImprimeRegMode:
	ld a,(RG0SAV)
	call ImprimeBinario
	call NovaLinha
	ld a,(RG1SAV)
	call ImprimeBinario
	call NovaLinha
ret

ImprimeRegModeSC2:
	ld a,(RG0SAV)
	call ImprimeBinarioSC2
	call NovaLinhaSC2
	ld a,(RG1SAV)
	call ImprimeBinarioSC2
	call NovaLinhaSC2
ret

; =====================================
; FIM PROGRAMA
; =====================================
include "HWD\Z80.ASM"
include "HWD\PT-BR.ASM"
include "HWD\TMS9918.ASM"
include "AST\SPRITES.ASM"

; =====================================
; PADDING
; =====================================
romPad:
 ds romSize-(romPad-romArea),0