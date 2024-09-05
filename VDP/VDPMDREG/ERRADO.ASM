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
	call LimparTela
	call ImprimeRegMode
	call NovaLinha
	call CHGET
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
	ld a,(RG1SAV)
	set 4,a
	ld b,a
	call ImprimeBinario
	call NovaLinha
	call CHGET
	call NovaLinha
	ld a,129
	call WR2VDPREG
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
	push bc
	call ReadVDPPorts
	ld	a,(VDPCONTROL)	; A = First writing port used to access the internal VDP
	call ImprimeBinario
	call NovaLinha
	call NovaLinha
	ld	c,a
	di					; Interrupts must be disabled here
	pop	af
	pop bc
	out	(c),b			; Write the data
	out	(c),a			; Write the register number (with the bit 7 always set)
	ei					; Interrupts can be enabled here
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