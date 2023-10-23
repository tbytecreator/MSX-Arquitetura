; =====================================
; PPI - DESCOBRE O STATUS DO CAPS LOCK
; =====================================
include "HWD\CONST.ASM"
include "HWD\BIOS.ASM"
include "HWD\VAR.ASM"

org prgArea

Inicio:

LePortaC:
	; =======================
	; LE A PORTA DA PPI 
	; =======================
  	ld a,(CAPST)
	cp 0
	jp z,Desligado
	ld hl,Message6
	call ImprimeString
	jp EndProgram
Desligado:
	ld hl,Message7
	call ImprimeString
EndProgram:
	call CHGET

; =====================================
; FIM PROGRAMA
; =====================================
include "HWD\LIB.ASM"
include "HWD\PT-BR.ASM"