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
Screen0
	call INITXT
	call ImprimeRegMode
	call NovaLinha 
Screen1:
	;call INIT32
	;call ImprimeRegMode
Fim:
	di
	halt
ImprimeRegMode:
	ld a,(RG1SAV)
	call ImprimeBinario
	call NovaLinha
	ld a,(RG2SAV)
	call ImprimeBinario
	call NovaLinha
	ld a,(RG3SAV)
	call ImprimeBinario
	call NovaLinha
	ld a,(RG4SAV)
	call ImprimeBinario
	call NovaLinha
	ld a,(RG5SAV)
	call ImprimeBinario
	call NovaLinha
	ld a,(RG6SAV)
	call ImprimeBinario
	call NovaLinha
	ld a,(RG7SAV)
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