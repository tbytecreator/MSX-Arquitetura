; =====================================
; TABELAS DO VDP MSX 1
; =====================================
include "HWD/BIOS.ASM"
include "HWD/CONST.ASM"
include "HWD/VAR.ASM"

org romArea
	db "AB"
	dw ProgramStart
	db 00,00,00,00,00

ProgramStart:
Screen1:
	call INIT32     			; entra na screen 1
	call SC1LOADPATTERN 		; carrega a tabela de padrões
	call SC1LOADCOLOR			; carrega a tabela de cores
	call SC1LOADSPRITEPATTERN 	; carrega a tabela de sprites
init:
    ld a,'A'
loop:
    call CHPUT
    inc a
    cp 91
    jr nz, loop
endprogram:
    jp endprogram
    
; =====================================
; FIM PROGRAMA
; =====================================
include "HWD/Z80.ASM"
include "HWD/PT-BR.ASM"
include "HWD/TMS9918.ASM"
include "AST/FONT.ASM"
include "AST/COLOR.ASM"
include "AST/SPRITES.ASM"

; =====================================
; PADDING
; =====================================
romPad:
 ds romSize-(romPad-romArea),0