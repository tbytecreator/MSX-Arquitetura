; =============================================================================
; FUNCOES DE ACESSO A PPI
; =============================================================================
; MANOEL NETO - 2023-10-10
; =============================================================================

; =============================================================================
; DETECTAR SE UM SLOT ESTA EXPANDIDO
; =============================================================================
; A => IDENTIFICADOR DO SLOT
; =============================================================================
; A => BYTE LIDO (0 NAO EXPANDIDO, 80H EXPANDIDO)
; =============================================================================
DSLOTEX:
	; =======================
	; SLOT 0
	; =======================
	ld a,(EXPTBL+a)	
ret