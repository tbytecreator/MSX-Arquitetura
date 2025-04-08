; =============================================================================
; TMS9918.ASM
; =============================================================================
; (C) 2024 Manoel Neto - tbytecreator@gmail.com
; Biblioteca para uso do VDP do MSX 1
; =============================================================================

; =============================================================================
; MODOS DE OPERACAO DO VDP
; =============================================================================
;	M1	M2	M3	M4	M5	Mode	 	MSX Version	    BASIC           
;	1	0	0	0	0	40x24 Text	1 2 2+ tR		0
;	0	0	0	0	0	32x24 Text	1 2 2+ tR	 	1
;	0	0	1	0	0	Graphics 1	1 2 2+ tR		2
;	0	1	0	0	0	Multicolour	1 2 2+ tR		3
; =============================================================================

; =============================================================================
; CORES
; =============================================================================
; 00	0000 transparent		06	0110 dark red		12	1100 dark green
; 01	0001 black				07	0111 cyan			13	1101 magenta
; 02	0010 medium green		08	1000 medium red		14	1110 gray
; 03	0011 light green 		09	1001 light red		15	1111 white
; 04	0100 dark blue			10	1010 dark yellow
; 05	0101 light blue			11	1011 light yellow
; =============================================================================

; =============================================================================
; VDP MODO TEXTO 40X24 (SCREEN 0)
; =============================================================================
; Name Table	=> 0000H to 03BFH => 960 Bytes
; Pattern Table => 0800H to 0FFFH => 2 KB 
; =============================================================================
SC0NAMETBL:		        equ &0000
SC0PATTERNTBL:	        equ &0800
; =============================================================================
; VDP MODO HIBRIDO 32X24 (SCREEN 1)
; =============================================================================
; Pattern Table             => 0000H to 05FFH => 2 KB
; Name Table	            => 1800H to 1AFFH => 768 Bytes
; Sprite Attributes Table   => 1B00H to 1B7FH => 128 Bytes
; Color Table               => 2000H to 201FH => 32 Bytes
; Sprite Pattern Table      => 3800H to 03FFH => 2 KB 
; =============================================================================
SC1PATTERNTBL:	        equ &0000
SC1NAMETBL:		        equ &1800
SC1SPRATTTBL:           equ &1B00
SC1COLORTBL:	        equ &2000
SC1SPRITEPATTERNTBL:    equ &3800

; =============================================================================
; SC0LOADPATTERN 
; carrega a tabela de padroes na memoria do VDP (SCR 0)
; =============================================================================	
; Entrada:	
;	None
; Saida:
;	None
; Altera:
;	de, hl, bc
; =============================================================================
SC0LOADPATTERN:			
	ld de,SC0PATTERNTBL	; endereco de carga na memoria do VDP
	ld hl,FONT			; endereco dos bytes a serem carregados			
	ld bc,208 			; quantos bytes vamos carregar (maximo 2 KB)
	call LDIRVM     	; comando que faz a copia do bloco de memoria 
ret                  
; =============================================================================

; =============================================================================
; SC1LOADPATTERN 
; Load pattern table into VDP memory
; =============================================================================	
; Entrada:	
;	None
; Saida:
;	None
; Altera:
;	de, hl, bc
; =============================================================================
SC1LOADPATTERN:			
	ld de,SC1PATTERNTBL	; endereco de carga na memoria do VDP
	ld hl,FONT			; endereco dos bytes a serem carregados			
	ld bc,208 			; quantos bytes vamos carregar (maximo 2 KB)
	call LDIRVM     	; comando que faz a copia do bloco de memoria
ret                  
; =============================================================================

; =============================================================================
; POSICIONAR CURSOR NA SCREEN 1
; =============================================================================
; Entrada:
;   A => Caractere a ser escrito
;   C => coluna (0 a 31)
;   E => linha (0 a 23)
; =============================================================================
; Altera:
;   HL
; =============================================================================
SC1LOCATE:
CalculaPosVRAM:
    ld h,0 
    ld l,0
    add hl,de
MultiplyHLBy32:
    sla l                   ; Desloca o byte menos significativo (L) 1 vez à esquerda
    rl h                    ; Propaga o carry para o byte mais significativo (H)
    sla l                   ; Desloca L novamente
    rl h                    ; Propaga o carry para H
    sla l                   ; Desloca L novamente
    rl h                    ; Propaga o carry para H
    sla l                   ; Desloca L novamente
    rl h                    ; Propaga o carry para H
    sla l                   ; Desloca L novamente (5º deslocamento)
    rl h                    ; Propaga o carry para H
Adicoes:
    ld de,SC1NAMETBL        ; Carrega o endereco base da tabela de nomes da sc1
    add hl,de               ; Adiciona o endereço base
    add hl,bc               ; Adiciona a coluna            	
    call WRTVRM          	; Escreve o caractere no endereço calculado
ret
; =============================================================================