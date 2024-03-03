; =====================================
; LEITURA DA PORTA DO VDP 
; =====================================

; =====================================
; LE AS PORTAS DO VDP (READ E WRITE)
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
  	call INIT32
	ld hl,Message0
	call ImprimeString
	call NovaLinha		; PULA LINHA
	ld hl,Message1
	call ImprimeString
	call NovaLinha		; PULA LINHA
	ld hl,Message2
	call ImprimeString
	ld a,(0006H)		; LE A PORTA PADRAO DO VDP NO ACUMULADOR
	call ImprimeNumero  ; IMPRIME O REG DE STATUS DO VDP
	call NovaLinha		; PULA LINHA
	ld hl,Message3
	call ImprimeString
	ld a,(0007H)		; LE A PORTA PADRAO DO VDP NO ACUMULADOR
	call ImprimeNumero  ; IMPRIME O REG DE STATUS DO VDP
	call NovaLinha		; PULA LINHA
	ld hl,Message1
	call ImprimeString
  	DI
  	Halt

; =============================================================================
; FIM PROGRAMA
; =============================================================================
include "HWD\LIB.ASM"
include "HWD\PT-BR.ASM"

; =============================================================================
; PADDING
; =============================================================================
romPad:
 ds romSize-(romPad-romArea),0