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
	; A = Register number (0-31)
	; B = Data to write	
	di					        ; desabilitamos as interrupções
        ld a,240
		out(&H99),a      	    ; escrevemos o dado
        ld a,129
		out(&H99),a	            ; escrevemos o registrador com o bit 7 setado
	ei					        ; reativamos as interrupções
    call ImprimeRegMode
    call CHGET 
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