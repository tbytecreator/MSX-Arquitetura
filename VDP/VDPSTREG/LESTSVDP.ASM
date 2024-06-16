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
	call LimparTela			; LIMPA A TELA
	call ReadVDPPorts		; LE AS PORTAS DO VDP PARA RAM
	ld a,1
	call CHGMOD				; SETA O MODO DE TELA
	call LoadSpritesTable   ; CARREGA A TABELA DE SPRITES

	; =================================
	; DESENHAR SPRITE NA TELA
	; =================================
	; A => Numero do Sprite na tabela de atributos
	; D => posicao Y
	; E => posicao X
	; B => Numero do sprite na tabela de sprites
	; C => Early / Cor
	; =================================
	ld a,0
	ld D, 80
	ld E, 80 
loopSprites:
	call DesenhaSprite
	cp 5
	jp z, vdpStatus
	inc a
	push af
		ld  a,e
		add a,20
		ld  e,a
	pop af
	jr loopSprites
vdpStatus:
	call ReadVDPStatus	; LE O STATUS DO VDP
	call ImprimeBinario	; IMPRIME O NUMERO LIDO
	DI
  	Halt

DesenhaSprite:
	; BOTA SPRITE 1 DA NAVE
	ld B, 0
	ld C, 3
	call PutSprite
RET

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