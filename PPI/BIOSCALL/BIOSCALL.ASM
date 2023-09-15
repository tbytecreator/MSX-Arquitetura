; =====================================
; CHAMADAS DA BIOS RELACIONADAS
; A PPI DO MSX 
; =====================================

; =====================================
; 0138h (RSLREG)
; =====================================
; DESCRICAO	: 	LE UM BYTE DA PORTA DE 
;			  	I/O 0A8h PARA O 
;				ACUMULADOR
; PARMETROS	:	---
; SAIDA 	: 	A
; MODIFICA 	: 	A
; =====================================

; =====================================
; 013Bh (WSLREG)
; =====================================
; DESCRICAO	:	ESCREVE O REGISTRADOR A
;               NA PORTA I/O 0A8h
; PARMETROS	:	A
; SAIDA		:	---
; MODIFICA	:	---
; =====================================

; =====================================
; 000Ch (RDSLT)
; =====================================
; DESCRICAO	:	LE UM BYTE DE MEMORIA 
; 				DE UM SLOT ESPECIFICADO
; PARMETROS	:	A = ID DO SLOT A SER 
;               LIDO NO FORMATO 
; 				F000EEPP
; 				HL = ENDERECO DO BYTE A 
; 				A SER LIDO 
;				(0000h ATE BFFFh)
; SAIDA		:	A = Byte read
; MODIFICA	:	AF, BC, DE
; NOTAS		:	ESSA ROTINA DESABILITA 
;               AS INTERRUPÇÕES E 
;               EXISTE NO MSX-DOS.
; =====================================

; =====================================
; 0014h (WRSLT)
; =====================================
; Function:	Writes one byte to memory 
;           of the slot specified.
; Entry:	A = Slot ID
;           E = Byte to write
;           HL = Writing address 
;           (from 0000h to BFFFh)
; Output:	None
; Modify:	AF, BC, D
; Notes:	
; This routine disables the interrupts
; Call the hook H.OUTD (0FEE4h)
; This routine also exists under 
; MSX-DOS.
; =====================================

; =====================================
; 001Ch (CALSLT)
; =====================================
; Function:	Calls the routine in 
; another slot (inter-slot call)
; Entry:	IX = Address to call
;           IY = Slot ID
; Output:	Depends on the calling 
;           routine.
; Modify:	AF, IX, IY, auxiliary 
;           registers, and other 
;           registers depending on 
;           thecalling routine
; Notes:	
; Interrupts are disabled by the routine.
; Can not call another extended slot of 
; the same primary slot where the BIOS 
; is located. This routine also exists 
; under MSX-DOS.
; =====================================

; =====================================
; 0024h (ENASLT)
; =====================================
; Function:	Selects the specified slot.
; Entry:	HL = Page to select the 
;           slot
;           A = Slot ID to select
; Output:	None
; Modify:	All Registers
; Notes:	
; Unlike the RDSLT, WRSLT and CALSLT 
; routines, the primary slot switching 
; is performed directly in page 0, thus,
; addresses in page 0 (0000H to 3FFFh) 
; will cause a system crash.
; This routine also exists under MSXDOS
; , where it will work also for page 0, 
; with the sole limit that it cannot 
; call another extended slot of the 
; same primary slot where the BIOS is 
; located.
; This routine disables the interrupts.
; =====================================

; =====================================
; LE A PORTA A8H
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
    ld hl,Message1
  	call ImprimeString
	call RSLREG
	call ImprimeNumero
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