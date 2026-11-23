; =============================================================================
; V9968.ASM
; =============================================================================
; (C) 2026 Manoel Neto - tbytecreator@gmail.com
; Biblioteca de acesso ao VDP V9968 para Z80 / MSX
; Referencia: V9968 User's Manual, capitulos 2, 3, 7, 8 e 11.
; =============================================================================
; V9968_BASE: 98h para o VDP principal; 88h para o segundo VDP.
; Ajuste a constante conforme a instalacao. Esta biblioteca nao usa a BIOS
; e nao atualiza as copias dos registradores na area de trabalho da BIOS.
;
; IMPORTANTE: o chamador deve desabilitar interrupcoes antes de cada chamada
; e mante-las desabilitadas durante sequencias que compartilham ponteiros do
; VDP. As rotinas nao alteram o estado das interrupcoes. Isto evita que uma
; interrupcao interrompa um par de escritas ou altere o estado selecionado.
;
; R#20, R#21 e R#28-R#30 exigem o desbloqueio em V9968_UNLOCK. Os bancos
; exigem tambem V58=0 (V9968_EXTMODE). R#8 VR=1 e necessario para acessar
; os bits altos da VRAM; A17 exige tambem V58=0. Estas rotinas nao alteram
; R#8 nem escolhem o modo de tela.
;
; Evite acesso da CPU a VRAM enquanto um comando estiver ativo; com MXC=1
; o acesso e bloqueado. Em certos modos o incremento automatico da VRAM
; retorna no limite de 16 KB; nesse caso reposicione o endereco a cada pagina.
; O banco nao muda automaticamente. A temporizacao minima de acesso sequencial
; nao esta especificada no manual: valide as transferencias no hardware alvo.
; =============================================================================
V9968_BASE:             equ &98
V9968_DATA:             equ V9968_BASE
V9968_CONTROL:          equ V9968_BASE+1
V9968_PALETTE:          equ V9968_BASE+2
V9968_INDIRECT:         equ V9968_BASE+3
V9968_INTERRUPT:        equ V9968_BASE+4

; =============================================================================
; MODOS DE OPERACAO DO VDP
; =============================================================================
; M1  M2  M3  M4  M5   Modo                 MSX de origem    BASIC
;  1   0   X   0   0   Text1 40 colunas     MSX 1            SCREEN 0 WIDTH 40
;  0   0   0   0   0   Graphic1             MSX 1            SCREEN 1
;  0   0   1   0   0   Graphic2             MSX 1            SCREEN 2
;  0   1   X   0   0   Multicolor           MSX 1            SCREEN 3
;  0   0   0   1   0   Graphic3             MSX 2            SCREEN 4
;  0   0   1   1   0   Graphic4             MSX 2            SCREEN 5
;  0   0   0   0   1   Graphic5             MSX 2            SCREEN 6
;  0   0   1   0   1   Graphic6             MSX 2            SCREEN 7
;  0   0   1   1   1   Graphic7             MSX 2            SCREEN 8
;  1   0   0   1   0   Text2 80 colunas     MSX 2            SCREEN 0 WIDTH 80
;  0   0   1   1   1   Graphic7-YAE         MSX 2+           SCREEN 10/11
;  0   0   1   1   1   Graphic7-YJK         MSX 2+           SCREEN 12
; =============================================================================
; M1/M2: R#1 bits 4/3; M3/M4/M5: R#0 bits 1/2/3.
; X: M3 pode ser 0 ou 1 no V9968. MSX de origem indica a primeira geracao.
; Em Graphic7, R#25 seleciona o formato: YJK/YAE (bits 3/4) = 0/0
; para SCREEN 8, 1/1 para SCREEN 10/11 e 1/0 para SCREEN 12.
; SCREEN 10 e 11 tem a mesma exibicao, mas diferem na interpretacao dos
; dados pelos comandos VDP. YJK/YAE = 0/1 nao e definido.
; Referencia: V9968 User's Manual, secoes 3.1 e 5.2.
; =============================================================================

; =============================================================================
; MAPAS DE VRAM DOS MODOS DE VIDEO
; =============================================================================
; Os enderecos abaixo sao exemplos do Apendice C do manual, nao enderecos
; fixos. Configure os registradores e os bancos de exibicao antes do uso.
; Os mapas de sprites correspondem aos modos 1 e 2 convencionais; o modo 3
; do V9968 tem outra organizacao e exige configuracao propria.
; =============================================================================

; =============================================================================
; VDP MODO TEXTO 40X24 (SCREEN 0 WIDTH 40 / TEXT1)
; =============================================================================
; Name Table                => 00000H a 003BFH => 960 bytes
; Pattern Table             => 00800H a 00FFFH => 2 KB
; =============================================================================
; Cores em R#7; sprites nao disponiveis.
; =============================================================================
V9968_SC0W40NAMETBL:          equ &0000
V9968_SC0W40PATTERNTBL:       equ &0800

; =============================================================================
; VDP MODO TEXTO 80X24 (SCREEN 0 WIDTH 80 / TEXT2)
; =============================================================================
; Name Table                => 00000H a 0077FH => 1.920 bytes
; Blink Table               => 00800H a 008EFH => 240 bytes
; Pattern Table             => 01000H a 017FFH => 2 KB
; =============================================================================
; Cores em R#7/R#12; sprites nao disponiveis.
; Com LN=1 em R#9, a Name Table ocupa 2.160 bytes e a Blink Table,
; 270 bytes: reposicione a Blink Table para evitar sobreposicao.
; =============================================================================
V9968_SC0W80NAMETBL:          equ &0000
V9968_SC0W80BLINKTBL:         equ &0800
V9968_SC0W80PATTERNTBL:       equ &1000

; =============================================================================
; VDP MODO HIBRIDO 32X24 (SCREEN 1 / GRAPHIC1)
; =============================================================================
; Pattern Table             => 0000H a 07FFH => 2 KB
; Name Table                => 1800H a 1AFFH => 768 bytes
; Sprite Attributes Table   => 1B00H a 1B7FH => 128 bytes
; Color Table               => 2000H a 201FH => 32 bytes
; Sprite Pattern Table      => 3800H a 3FFFH => 2 KB
; =============================================================================
; Exemplo de distribuicao no banco de exibicao. Os registradores do VDP
; devem ser configurados para estes enderecos; as constantes nao os alteram.
; =============================================================================
V9968_SC1PATTERNTBL:        equ &0000
V9968_SC1NAMETBL:           equ &1800
V9968_SC1SPRATTTBL:         equ &1B00
V9968_SC1COLORTBL:          equ &2000
V9968_SC1SPRITEPATTERNTBL:  equ &3800
; =============================================================================

; =============================================================================
; VDP MODO GRAFICO 256X192 (SCREEN 2 / GRAPHIC2)
; =============================================================================
; Pattern Table             => 00000H a 017FFH => 6 KB
; Name Table                => 01800H a 01AFFH => 768 bytes
; Sprite Attributes Table   => 01B00H a 01B7FH => 128 bytes
; Color Table               => 02000H a 037FFH => 6 KB
; Sprite Pattern Table      => 03800H a 03FFFH => 2 KB
; =============================================================================
; Pattern e Color usam tres conjuntos de 2 KB; R#4/R#3 aplicam mascaras.
; =============================================================================
V9968_SC2PATTERNTBL:          equ &0000
V9968_SC2NAMETBL:             equ &1800
V9968_SC2SPRATTTBL:           equ &1B00
V9968_SC2COLORTBL:            equ &2000
V9968_SC2SPRITEPATTERNTBL:    equ &3800

; =============================================================================
; VDP MODO MULTICOLOR 64X48 BLOCOS (SCREEN 3 / MULTICOLOR)
; =============================================================================
; Pattern Table / cores     => 00000H a 007FFH => 2 KB
; Name Table                => 00800H a 00AFFH => 768 bytes
; Sprite Attributes Table   => 01B00H a 01B7FH => 128 bytes
; Sprite Pattern Table      => 03800H a 03FFFH => 2 KB
; =============================================================================
; Cada bloco corresponde a 4x4 pontos; nao ha Color Table separada.
; =============================================================================
V9968_SC3PATTERNTBL:          equ &0000
V9968_SC3NAMETBL:             equ &0800
V9968_SC3SPRATTTBL:           equ &1B00
V9968_SC3SPRITEPATTERNTBL:    equ &3800

; =============================================================================
; VDP MODO GRAFICO 256X192 (SCREEN 4 / GRAPHIC3)
; =============================================================================
; Pattern Table             => 00000H a 017FFH => 6 KB
; Name Table                => 01800H a 01AFFH => 768 bytes
; Sprite Color Table        => 01C00H a 01DFFH => 512 bytes
; Sprite Attributes Table   => 01E00H a 01E7FH => 128 bytes
; Color Table               => 02000H a 037FFH => 6 KB
; Sprite Pattern Table      => 03800H a 03FFFH => 2 KB
; =============================================================================
; Mesmo layout de padroes e cores da SCREEN 2; sprites no modo 2.
; =============================================================================
V9968_SC4PATTERNTBL:          equ &0000
V9968_SC4NAMETBL:             equ &1800
V9968_SC4SPRCOLORTBL:         equ &1C00
V9968_SC4SPRATTTBL:           equ &1E00
V9968_SC4COLORTBL:            equ &2000
V9968_SC4SPRITEPATTERNTBL:    equ &3800

; =============================================================================
; VDP MODO BITMAP 256 PONTOS (SCREEN 5 / GRAPHIC4)
; =============================================================================
; Bitmap, pagina 0          => 00000H a 05FFFH => 192 linhas, 24.576 bytes
;                           => 00000H a 069FFH => 212 linhas, 27.136 bytes
; Sprite Color Table        => 07400H a 075FFH => 512 bytes
; Sprite Attributes Table   => 07600H a 0767FH => 128 bytes
; Sprite Pattern Table      => 07800H a 07FFFH => 2 KB
; =============================================================================
; Pagina de 32 KB; 2 pontos por byte; 16 cores da paleta.
; =============================================================================
V9968_SC5BITMAPPAGE0:         equ &0000
V9968_SC5SPRCOLORTBL:         equ &7400
V9968_SC5SPRATTTBL:           equ &7600
V9968_SC5SPRITEPATTERNTBL:    equ &7800

; =============================================================================
; VDP MODO BITMAP 512 PONTOS (SCREEN 6 / GRAPHIC5)
; =============================================================================
; Bitmap, pagina 0          => 00000H a 05FFFH => 192 linhas, 24.576 bytes
;                           => 00000H a 069FFH => 212 linhas, 27.136 bytes
; Sprite Color Table        => 07400H a 075FFH => 512 bytes
; Sprite Attributes Table   => 07600H a 0767FH => 128 bytes
; Sprite Pattern Table      => 07800H a 07FFFH => 2 KB
; =============================================================================
; Pagina de 32 KB; 4 pontos por byte; 4 cores da paleta.
; =============================================================================
V9968_SC6BITMAPPAGE0:         equ &0000
V9968_SC6SPRCOLORTBL:         equ &7400
V9968_SC6SPRATTTBL:           equ &7600
V9968_SC6SPRITEPATTERNTBL:    equ &7800

; =============================================================================
; VDP MODO BITMAP 512 PONTOS (SCREEN 7 / GRAPHIC6)
; =============================================================================
; Bitmap, pagina 0          => 00000H a 0BFFFH => 192 linhas, 49.152 bytes
;                           => 00000H a 0D3FFH => 212 linhas, 54.272 bytes
; Sprite Pattern Table      => 0F000H a 0F7FFH => 2 KB
; Sprite Color Table        => 0F800H a 0F9FFH => 512 bytes
; Sprite Attributes Table   => 0FA00H a 0FA7FH => 128 bytes
; =============================================================================
; Pagina de 64 KB; 2 pontos por byte; 16 cores da paleta.
; =============================================================================
V9968_SC7BITMAPPAGE0:         equ &0000
V9968_SC7SPRITEPATTERNTBL:    equ &F000
V9968_SC7SPRCOLORTBL:         equ &F800
V9968_SC7SPRATTTBL:           equ &FA00

; =============================================================================
; VDP MODO BITMAP 256 PONTOS (SCREEN 8 / GRAPHIC7)
; =============================================================================
; Bitmap, pagina 0          => 00000H a 0BFFFH => 192 linhas, 49.152 bytes
;                           => 00000H a 0D3FFH => 212 linhas, 54.272 bytes
; Sprite Pattern Table      => 0F000H a 0F7FFH => 2 KB
; Sprite Color Table        => 0F800H a 0F9FFH => 512 bytes
; Sprite Attributes Table   => 0FA00H a 0FA7FH => 128 bytes
; =============================================================================
; Pagina de 64 KB; 1 ponto por byte; 256 cores diretas; YJK/YAE=0/0.
; =============================================================================
V9968_SC8BITMAPPAGE0:         equ &0000
V9968_SC8SPRITEPATTERNTBL:    equ &F000
V9968_SC8SPRCOLORTBL:         equ &F800
V9968_SC8SPRATTTBL:           equ &FA00

; =============================================================================
; VDP MODO YJK COM PALETA (SCREEN 10 / GRAPHIC7-YAE)
; =============================================================================
; Bitmap, pagina 0          => 00000H a 0BFFFH => 192 linhas, 49.152 bytes
;                           => 00000H a 0D3FFH => 212 linhas, 54.272 bytes
; Sprite Pattern Table      => 0F000H a 0F7FFH => 2 KB
; Sprite Color Table        => 0F800H a 0F9FFH => 512 bytes
; Sprite Attributes Table   => 0FA00H a 0FA7FH => 128 bytes
; =============================================================================
; Pagina de 64 KB; YJK/YAE=1/1 em R#25; cores YJK e da paleta.
; =============================================================================
V9968_SC10BITMAPPAGE0:        equ &0000
V9968_SC10SPRITEPATTERNTBL:   equ &F000
V9968_SC10SPRCOLORTBL:        equ &F800
V9968_SC10SPRATTTBL:          equ &FA00

; =============================================================================
; VDP MODO YJK COM PALETA (SCREEN 11 / GRAPHIC7-YAE)
; =============================================================================
; Bitmap, pagina 0          => 00000H a 0BFFFH => 192 linhas, 49.152 bytes
;                           => 00000H a 0D3FFH => 212 linhas, 54.272 bytes
; Sprite Pattern Table      => 0F000H a 0F7FFH => 2 KB
; Sprite Color Table        => 0F800H a 0F9FFH => 512 bytes
; Sprite Attributes Table   => 0FA00H a 0FA7FH => 128 bytes
; =============================================================================
; Mesma exibicao da SCREEN 10; interpretacao dos comandos VDP diferente.
; Pagina de 64 KB; YJK/YAE=1/1 em R#25.
; =============================================================================
V9968_SC11BITMAPPAGE0:        equ &0000
V9968_SC11SPRITEPATTERNTBL:   equ &F000
V9968_SC11SPRCOLORTBL:        equ &F800
V9968_SC11SPRATTTBL:          equ &FA00

; =============================================================================
; VDP MODO YJK (SCREEN 12 / GRAPHIC7-YJK)
; =============================================================================
; Bitmap, pagina 0          => 00000H a 0BFFFH => 192 linhas, 49.152 bytes
;                           => 00000H a 0D3FFH => 212 linhas, 54.272 bytes
; Sprite Pattern Table      => 0F000H a 0F7FFH => 2 KB
; Sprite Color Table        => 0F800H a 0F9FFH => 512 bytes
; Sprite Attributes Table   => 0FA00H a 0FA7FH => 128 bytes
; =============================================================================
; Pagina de 64 KB; YJK/YAE=1/0 em R#25.
; =============================================================================
V9968_SC12BITMAPPAGE0:        equ &0000
V9968_SC12SPRITEPATTERNTBL:   equ &F000
V9968_SC12SPRCOLORTBL:        equ &F800
V9968_SC12SPRATTTBL:          equ &FA00


; =============================================================================
; V9968_UNLOCK / V9968_LOCK
; =============================================================================
; Libera ou bloqueia os registradores estendidos sem limpar interrupcoes.
; Entrada: nenhuma. Saida: nenhuma. Altera: AF.
; =============================================================================
V9968_UNLOCK:
    xor a
    out (V9968_INTERRUPT),a
    ret

V9968_LOCK:
    ld a,&80
    out (V9968_INTERRUPT),a
    ret

; =============================================================================
; V9968_EXTMODE
; =============================================================================
; Libera os registradores estendidos e seleciona V58=0 em R#21.
; Nao altera R#8, R#20, os bancos ou o modo de tela.
; Entrada: nenhuma. Saida: nenhuma. Altera: AF, B.
; =============================================================================
V9968_EXTMODE:
    call V9968_UNLOCK
    xor a
    ld b,21
    jp V9968_WREG

; =============================================================================
; V9968_WREG
; =============================================================================
; Escreve um registrador de controle por acesso direto.
; Entrada: B = numero do registrador (0-63); A = valor.
; Saida: nenhuma. Altera: AF. Preserva: BC, DE, HL.
; =============================================================================
V9968_WREG:
    out (V9968_CONTROL),a
    ld a,b
    and &3F
    or &80
    out (V9968_CONTROL),a
    ret

; =============================================================================
; V9968_SETIND / V9968_WRITE_IND
; =============================================================================
; Seleciona R#17 e escreve no registrador indicado por acesso indireto.
; SETIND: A = registrador em bits 5-0; bit 7 inibe o incremento automatico.
; WRITE_IND: A = valor. R#17 nao pode ser escrito pela porta indireta.
; Saida: nenhuma. SETIND altera: AF, B. WRITE_IND preserva os registradores.
; =============================================================================
V9968_SETIND:
    ld b,17
    jp V9968_WREG

V9968_WRITE_IND:
    out (V9968_INDIRECT),a
    ret

; =============================================================================
; V9968_RSTATUS
; =============================================================================
; Le S#0-S#9 e restaura R#15 para S#0, como esperado pela BIOS.
; A leitura pode limpar flags, conforme o registrador selecionado.
; Entrada: A = numero do status. Saida: A = valor. Altera: AF, B.
; =============================================================================
V9968_RSTATUS:
    ld b,15
    call V9968_WREG
    in a,(V9968_CONTROL)
    push af
    xor a
    call V9968_WREG
    pop af
    ret

; =============================================================================
; V9968_RINT / V9968_WINT
; =============================================================================
; Le ou escreve a porta de interrupcoes e bloqueio.
; WINT: bit 7 define o bloqueio; bits 2-0 em 1 limpam as respectivas flags.
; Entrada WINT: A = valor. Saida RINT: A = valor. Altera: A.
; =============================================================================
V9968_RINT:
    in a,(V9968_INTERRUPT)
    ret

V9968_WINT:
    out (V9968_INTERRUPT),a
    ret

; =============================================================================
; V9968_CPU_BANK / V9968_DISPLAY_BANKS / V9968_COMMAND_BANKS
; =============================================================================
; Seleciona bancos de 256 KB. Requer V58=0 e registradores desbloqueados.
; Entrada: A = banco CPU (0-15), ou bancos combinados:
;   DISPLAY: bits 3-0 fundo, bits 7-4 sprites.
;   COMMAND: bits 3-0 origem, bits 7-4 destino.
; Para leitura da VRAM, selecione o banco antes de V9968_SETRD.
; Saida: nenhuma. Altera: AF, B.
; =============================================================================
V9968_CPU_BANK:
    and &0F
    ld b,28
    jp V9968_WREG

V9968_DISPLAY_BANKS:
    ld b,29
    jp V9968_WREG

V9968_COMMAND_BANKS:
    ld b,30
    jp V9968_WREG

; =============================================================================
; V9968_SETRD / V9968_SETWRT
; Define o endereco de leitura ou escrita no banco CPU selecionado.
; Entrada: A = bits A17-A16 (0-3); HL = bits A15-A0.
; Saida: nenhuma. Altera: AF. Preserva: BC, DE, HL.
; O endereco de leitura faz prefetch; alteracoes posteriores em R#14 ou R#28
; exigem chamar V9968_SETRD novamente antes de ler.
; =============================================================================
V9968_SETRD:
    push de
    ld d,0
    jr V9968_SETADDR

V9968_SETWRT:
    push de
    ld d,&40
V9968_SETADDR:
    push bc
    and &03
    add a,a
    add a,a
    ld e,a
    ld a,h
    rlca
    rlca
    and &03
    or e
    ld b,14
    call V9968_WREG
    ld a,l
    out (V9968_CONTROL),a
    ld a,h
    and &3F
    or d
    out (V9968_CONTROL),a
    pop bc
    pop de
    ret

; =============================================================================
; V9968_READ / V9968_WRITE
; Le ou escreve um byte no endereco previamente selecionado.
; Entrada WRITE: A = byte. Saida READ: A = byte. Altera: A.
; =============================================================================
V9968_READ:
    in a,(V9968_DATA)
    ret

V9968_WRITE:
    out (V9968_DATA),a
    ret

; =============================================================================
; V9968_READ_BLOCK / V9968_WRITE_BLOCK
; Transfere bytes a partir do endereco VRAM previamente selecionado.
; Entrada: HL = endereco na RAM; BC = quantidade (0 nao transfere bytes).
; Saida: BC = 0; HL aponta apos os dados. Altera: AF, BC, HL.
; Respeite os limites de incremento e as restricoes de temporizacao acima.
; =============================================================================
V9968_READ_BLOCK:
    ld a,b
    or c
    ret z
V9968_READ_BLOCK_LOOP:
    in a,(V9968_DATA)
    ld (hl),a
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,V9968_READ_BLOCK_LOOP
    ret

V9968_WRITE_BLOCK:
    ld a,b
    or c
    ret z
V9968_WRITE_BLOCK_LOOP:
    ld a,(hl)
    out (V9968_DATA),a
    inc hl
    dec bc
    ld a,b
    or c
    jr nz,V9968_WRITE_BLOCK_LOOP
    ret

; =============================================================================
; V9968_PALETTE_NORMAL / V9968_PALETTE_EXT
; Escreve uma entrada da paleta, selecionando-a por R#16.
; NORMAL exige EPAL=0 em R#20: A = indice 0-15, D = 0RRR0BBB, E = 00000GGG.
; EXT exige EPAL=1 em R#20: A = indice 0-255, D = R, E = G, H = B (0-31).
; O chamador configura R#20; estas rotinas nao alteram o modo da paleta.
; Saida: nenhuma. Altera: AF, B.
; =============================================================================
V9968_PALETTE_NORMAL:
    ld b,16
    call V9968_WREG
    ld a,d
    out (V9968_PALETTE),a
    ld a,e
    out (V9968_PALETTE),a
    ret

V9968_PALETTE_EXT:
    ld b,16
    call V9968_WREG
    ld a,d
    out (V9968_PALETTE),a
    ld a,e
    out (V9968_PALETTE),a
    ld a,h
    out (V9968_PALETTE),a
    ret

; =============================================================================
; V9968_WAIT_COMMAND
; Aguarda CE=0 em S#2 antes de iniciar outro comando ou acessar VRAM.
; Nao use para aguardar comandos que ainda precisam de dados da CPU:
; nesses casos o chamador deve atender TR (S#2 bit 7) durante a execucao.
; Entrada: nenhuma. Saida: nenhuma. Altera: AF, B. R#15 termina em zero.
; =============================================================================
V9968_WAIT_COMMAND:
    ld a,2
    call V9968_RSTATUS
    bit 0,a
    jr nz,V9968_WAIT_COMMAND
    ret

; =============================================================================
; V9968_CHECK
; Procura o V9968 primeiro como VDP principal (98h), depois como segundo VDP
; (88h). Se ambos estiverem presentes, retorna o principal.
; A classificacao e pela porta, nao pela presenca fisica de um cartucho:
; um cartucho configurado em 98h sera identificado como VDP principal.
; Entrada: interrupcoes desabilitadas; nenhum comando VDP em execucao.
; Saida: A = 0 principal, 1 segundo VDP, FFh nao detectado.
; Altera: AF, BC, DE. Preserva: HL. Nao altera V9968_BASE.
;
; A sondagem acessa 99h/9Ch e, se necessario, 89h/8Ch; dispositivos nao
; identificados nessas portas podem ser afetados. Em um V9968, preserva o
; modo V58 e o bloqueio de registradores, mas deixa R#15 em zero e a leitura
; de S#1 limpa a flag FH de interrupcao de linha. Ao retornar ao modo
; compativel, a escrita em R#21 limpa A17 das bases de tabelas.
; Referencia: V9968 User's Manual, secoes 2.7, 4 e 12.4.
; =============================================================================
V9968_CHECK:
    ld c,&98
    call V9968_CHECK_PORT
    or a
    ret z
    ld c,&88
    call V9968_CHECK_PORT
    or a
    jr nz,V9968_CHECK_NOT_FOUND
    ld a,1
    ret
V9968_CHECK_NOT_FOUND:
    ld a,&FF
    ret

; C = base a sondar; A = 0 se V9968, 1 caso contrario.
V9968_CHECK_PORT:
    ld a,c
    add a,4
    ld c,a
    in a,(c)
    ld d,a
    and &78
    jr nz,V9968_CHECK_PORT_ABSENT
    ld e,1
    ld a,&80
    out (c),a
    in a,(c)
    and &F8
    cp &80
    jr nz,V9968_CHECK_RESTORE_LOCK
    xor a
    out (c),a
    in a,(c)
    and &F8
    jr nz,V9968_CHECK_RESTORE_LOCK
    dec c
    dec c
    dec c
    ld a,1
    out (c),a
    ld a,&8F
    out (c),a
    in a,(c)
    and &3E
    cp &06
    jr z,V9968_CHECK_FOUND
    cp &04
    jr nz,V9968_CHECK_RESTORE_STATUS
    xor a
    out (c),a
    ld a,&95
    out (c),a
    in a,(c)
    and &3E
    cp &06
    jr nz,V9968_CHECK_COMPAT_RESTORE
    ld e,0
V9968_CHECK_COMPAT_RESTORE:
    ld a,1
    out (c),a
    ld a,&95
    out (c),a
    jr V9968_CHECK_RESTORE_STATUS
V9968_CHECK_FOUND:
    ld e,0
V9968_CHECK_RESTORE_STATUS:
    xor a
    out (c),a
    ld a,&8F
    out (c),a
    inc c
    inc c
    inc c
V9968_CHECK_RESTORE_LOCK:
    ld a,d
    and &80
    out (c),a
    ld a,e
    ret
V9968_CHECK_PORT_ABSENT:
    ld a,1
    ret
