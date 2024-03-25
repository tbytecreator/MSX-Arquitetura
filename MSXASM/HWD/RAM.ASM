; =============================================================================
; RAM.ASM
; =============================================================================
; Manoel Neto 2024-03-23
; RAM MEMORY MAP
; =============================================================================
ramArea             equ &E000       ; RAM STARTING ADDRESS
VRAMDTRD            equ ramArea	    ; VRAM datum read
VRAMDTWR 		    equ ramArea+1   ; VRAM datum write
VDPCMD 		        equ ramArea+2   ; VDP Command
PALETTEREG 		    equ ramArea+3   ; Palette registers access
SEQREGACC   		equ ramArea+4   ; Sequential registers access
; =============================================================================