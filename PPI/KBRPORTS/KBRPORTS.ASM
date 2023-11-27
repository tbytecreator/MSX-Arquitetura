; =====================================
; LEITURA DO TECLADO
; A PARTIR DA BIOS
; =====================================
; https://konamiman.github.io/MSX2-Technical-Handbook/md/Chapter5a.html#31-key-scanning
; =====================================
include "HWD\CONST.ASM"
include "HWD\VAR.ASM"
include "HWD\BIOS.ASM"
;CHPUT:   EQU     0x00A2
;BREAKX:  EQU     0x00B7
;POSIT:   EQU     0x00C6
;SNSMAT:  EQU     0x0141

org prgArea
START:  CALL ERAFNK
        XOR A 
        CALL CLS
SCAN:   LD      C,0             ;C := LINHA DA MATRIZ DE TECLADO
SC1:    LD      A,C
        CALL    SNSMAT          ;LE A MATRIZ DE TECLADO
        LD      B,8
        LD      HL,BUFF         ;HL : = ENDERECO DO BUFFER
SC2:    LD      D,'.'
        RLA                     ;CHECA O BIT 
        JR      C,SC3
        LD      D,'#'
SC3:    LD      (HL),D          ;GUARDA '.' OU '#' PARA O BUFFER
        INC     HL
        DJNZ    SC2
        LD      H,05H           ;x := 5
        LD      L,C             
        INC     L               ;y := C+1
        CALL    POSIT           ;SETA A POSICAO DO CURSOR
        LD      B,8             ;MANDA O PADRAO DOS BITS DE SAIDA PARA O MONITOR
        LD      HL,BUFF
SC4:    LD      A,(HL)
        CALL    CHPUT
        INC     HL
        DJNZ    SC4
        CALL    BREAKX          ;CHECA O CONTROL+STOP
        RET     C
        INC     C               ;INCREMENTA O NUMERO DA LINHA
        LD      A,C
        CP      09
        JR      NZ,SC1
        JR      SCAN
BUFF:   DS      8
        END

; =====================================
; FIM PROGRAMA
; =====================================
include "HWD\LIB.ASM"
include "HWD\PT-BR.ASM"