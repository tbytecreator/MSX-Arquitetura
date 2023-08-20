; =====================================
; 0138h (RSLREG)
; =====================================
; Function:	Reads a byte from I/O port 
;           0A8h to register A
; Entry:	---
; Output:	A
; Modify:	A
; =====================================

; =====================================
; 013Bh (WSLREG)
; =====================================
; Function:	Writes register A to I/O 
;           port 0A8h
; Entry:	A
; Output:	---
; Modify:	---
; =====================================

; =====================================
; 000Ch (RDSLT)
; =====================================
; Function:	Reads one byte from memory 
; of the slot specified.
; Entry:	A = Slot ID to read 
; (F000EEPP format)
; HL = Address of byte to read 
; (from 0000h to BFFFh)
; Output:	A = Byte read
; Modify:	AF, BC, DE
; Notes:	
; This routine disables the 
; interrupts. This routine also exists 
; under MSX-DOS.
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

; Back to Basic from MSX-DOS 

MNROM	equ	0FCC1h
ENASLT 	equ	00024h
RETURN	equ	0409Bh

	org	0D000h
DEBUT:
	ld	a,(MNROM)
	ld	hl,0
	call	ENASLT	; Select main ROM on page 0 (0000h~3FFFh)
	ld	a,(MNROM)
	ld	hl,04000h
	call	ENASLT	; Select main ROM on page 1 (4000h~7FFFh)
	jp	RETURN	; 