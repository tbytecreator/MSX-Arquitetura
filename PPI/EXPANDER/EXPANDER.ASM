; =====================================
; PPI - SLOTS EXPANDIDOS
; =====================================
include "HWD\CONST.ASM"
include "HWD\BIOS.ASM"
include "HWD\VAR.ASM"

org prgArea

Inicio:
	call LimparTela
	call INIT32
  	ld hl, Message1
  	call ImprimeString
	call CHGET

; =====================================
; FIM PROGRAMA
; =====================================
include "HWD\LIB.ASM"
include "HWD\PT-BR.ASM"