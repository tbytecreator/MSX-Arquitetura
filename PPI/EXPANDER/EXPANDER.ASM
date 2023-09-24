; =====================================
; PPI - DESCOBRE SLOTS EXPANDIDOS
; =====================================
include "HWD\CONST.ASM"
include "HWD\BIOS.ASM"
include "HWD\VAR.ASM"

org prgArea

Inicio:
	call LimparTela
	call INIT32
Slot0:
	; =======================
	; SLOT 0
	; =======================
  	ld hl, Message0
	call ImprimeString
	ld a,(EXPTBL)	
	cp 0 
	jp z,NaoExpandido0
	ld hl,Message5
	call ImprimeString
	jp Slot1
NaoExpandido0:
	ld hl,Message4
	call ImprimeString
	call NovaLinha
	; =======================

Slot1:
	; =======================
	; SLOT 1
	; =======================
  	ld hl, Message1
	call ImprimeString
	ld a,(EXPTBL+1)
	cp 0 
	jp z,NaoExpandido1
	ld hl,Message5
	call ImprimeString
	jp Slot2
NaoExpandido1:
	ld hl,Message4
	call ImprimeString
	call NovaLinha
	; =======================

Slot2:
	; =======================
	; SLOT 2
	; =======================
  	ld hl, Message2
	call ImprimeString
	ld a,(EXPTBL+2)	
	cp 0 
	jp z,NaoExpandido2
	ld hl,Message5
	call ImprimeString
	jp Slot3
NaoExpandido2:
	ld hl,Message4
	call ImprimeString
	call NovaLinha
	; =======================

Slot3:
	; =======================
	; SLOT 3
	; =======================
  	ld hl, Message3
	call ImprimeString
	ld a,(EXPTBL+3)	
	cp 0 
	jp z,NaoExpandido3
	ld hl,Message5
	call ImprimeString
	jp EndProgram
NaoExpandido3:
	ld hl,Message4
	call ImprimeString
	call NovaLinha
	; =======================
EndProgram:
	call CHGET

; =====================================
; FIM PROGRAMA
; =====================================
include "HWD\LIB.ASM"
include "HWD\PT-BR.ASM"