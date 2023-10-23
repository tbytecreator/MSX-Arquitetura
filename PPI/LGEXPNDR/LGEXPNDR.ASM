; =====================================
; LE E GRAVA EM SLOTS EXPANDIDOS
; =====================================
include "HWD\CONST.ASM"
include "HWD\BIOS.ASM"
include "HWD\VAR.ASM"

org prgArea

Inicio:
	ld hl,Message0
	call ImprimeString
	call CHGET
	ld (NumSlotPrimario),a
	call NovaLinha
	call DSLOTEX
	cp 0
	jp z,EndProgram
	ld hl,Message1
	call ImprimeString
	call CHGET
	ld (NumSlotSecundario),a
MontarId:
	; ================================
	; MODELO DO ID DE SLOT  
	; ================================
	; I000SSPP 
	; (I) 1=EXPANDIDO;0=NAO EXPANDIDO
	; (SS) NUMERO DO SLOT SECUNDARIO
	; (PP) NUMERO DO SLOT PRIMARIO
	; ================================
	ld b,(NumSlotPrimario)
	or b 
	bit 0,a
	ld (NumSlotID),a
	call ImprimeNumero
	call NovaLinha
GravaByte:
	; ================================
	; GRAVA NO SLOT 
	; ================================
	; I000SSPP 
	; (I) 1=EXPANDIDO;0=NAO EXPANDIDO
	; (SS) NUMERO DO SLOT SECUNDARIO
	; (PP) NUMERO DO SLOT PRIMARIO
	; ================================
	; A => ID DO SLOT
	; HL=> ENDERECO A SER GRAVADO
	; E => BYTE A SER GRAVADO 
	; ================================
	ld hl,C000
	ld e,255
	call WRSLT
	ld hl,Message4
	call ImprimeString
	call NovaLinha
LeByte:
	; ================================
	; LE O SLOT 
	; ================================
	; A => ID DO SLOT
	; HL=> ENDERECO A SER LIDO
	; ================================
	; A => BYTE LIDO 
	; ================================
	ld a,(NumSlotID)
	ld hl,C000
	call RDSLT
	call ImprimeNumero
EndProgram:
	ld hl,Message1
	call ImprimeString
	
; =====================================
; FIM PROGRAMA
; =====================================
include "HWD\LIB.ASM"
include "HWD\PPI.ASM"
include "HWD\PT-BR.ASM"