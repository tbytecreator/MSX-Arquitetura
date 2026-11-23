; =====================================
; DEMO REGISTRADPRES DE MODO
; =====================================
include "HWD\BIOS.ASM"
include "HWD\CONST.ASM"
include "HWD\VAR.ASM"

org romArea
	db "AB"
	dw ProgramStart
	db 00,00,00,00,00

ProgramStart:
	call ReadVDPPorts	; lemos as portas do VDP
	call LimparTela		; limpamos a tela
	call ImprimeRegMode	; imprimimos os regs de modo
	call NovaLinha		; pulamos uma linha	
	call CHGET			; esperamos um tecla
	; ==================================================
	; PARA MUDAR A SCREEN, PRECISAMOS 
	; MUDAR OS REGS 0 E 1 DO VDP
	; ==================================================
	; M1 M2	M3 M4 M5 Mode	 	MSX Version BASIC Screen
	; ==================================================
	; 0  0  0  0  0	 32x24 Text	1 2 2+ tR	1
	; 1  0  0  0  0  40x24 Text	1 2 2+ tR	0
	; ==================================================
	; screen 1
	; ==================================================
	; 0	DG	IE2	IE1	M5	M4	M3	EV
	; 				0	0	0
	;
	; 4/16K	Blank	IE	M1	M2	0	Size	Mag
	; 					0	0	
	; ==================================================
	; screen 0
	; ==================================================
	; 0	DG	IE2	IE1	M5	M4	M3	EV
	; 				0	0	0
	;
	; 4/16K	Blank	IE	M1	M2	0	Size	Mag
	; 					1	0	
	; ==================================================
	; PARA ISSO, USAMOS O COMANDO WRITE VDP
	; ==================================================
	ld a,(RG1SAV)		; lemos o valor do reg de modo 1
	set 4,a				; setamos o bit 4
	ld b,a				; salvamos o valor
	call ImprimeBinario ; imprimimos o valor
	call NovaLinha		; pulamos uma linha
	call CHGET			; esperamos um tecla
	call NovaLinha		; pulamos uma linha
	ld a,129			; carregamos o valor com 10000001
	call WR2VDPREG		; escrevemos o valor no VDP
	ld a,(RG1SAV)
	call ImprimeRegMode
	call CHGET
Fim:
	di
	halt

WR2VDPREG:
	; A = Register number (0-31)
	; B = Data to write
	push af
	  	ld a,(VDPCONTROL)	
		ld c,a
		call ImprimeBinario
		call CHGET
	pop af
	di					; desabilitamos as interrupções
		out	(c),b		; escrevemos o dado
		out	(c),a		; escrevemos o registrador com o bit 7 setado
	ei					; reativamos as interrupções
ret

ImprimeRegMode:
	ld a,(RG0SAV)
	call ImprimeBinario
	call NovaLinha
	ld a,(RG1SAV)
	call ImprimeBinario
	call NovaLinha
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