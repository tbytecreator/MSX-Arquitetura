; ====================================
; GAME LOOP
; ====================================
; Manoel Neto 2024-03-23
; ====================================
__VERSION:  equ 1
__RELEASE:  equ 0
include "HWD\AY38910.ASM"
include "HWD\BIOS.ASM"
include "HWD\RAM.ASM"
include "HWD\ROM.ASM"
include "HWD\TMS9918.ASM"
include "HWD\Z80.ASM"

org romArea
	db "AB"		
 	dw startCode
 	db "CW01"   
 	ds 6,0

; ====================================
; startCode
; ====================================
startCode:
	call CLEAN							
	call SSCREEN		
	call INIT			
GameLoopBegin:				
	call UPDATE							
	call DRAW													
GameLoopEnd:
	jp GameLoopBegin
; ====================================
; SUBROUTINES 
; ====================================
include "CLEAN.ASM"
include "SSCREEN.ASM"
include "INIT.ASM"
include "UPDATE.ASM"
include "DRAW.ASM"
; ====================================
; ASSETS
; ====================================
include "AST\PT-BR.ASM"
include "AST\FONT.ASM"
; ====================================
; Padding
; ====================================
romPad:
 ds romSize-(romPad-romArea),0