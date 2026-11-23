; =============================================================================
; V9968CHECK.ASM
; =============================================================================
; Identifica o V9968 e apresenta o resultado na tela do VDP principal.
; A classificacao usa as portas 98h e 88h; nao identifica o slot fisico.
; Um cartucho configurado em 98h sera apresentado como VDP principal.
; =============================================================================

include "HWD/BIOS.ASM"
include "HWD/CONST.ASM"

org romArea
    db "AB"
    dw ProgramStart
    dw 0,0,0,0,0,0

ProgramStart:
    ld a,40
    ld (LINL40),a
    xor a
    call CHGMOD
    call ERAFNK
    call CLS

    di
    call V9968_CHECK
    ei
    or a
    jr z,VDPPrincipal
    cp 1
    jr z,VDPSecundario
    ld hl,MsgAusente
    ld a,1+(40-(MsgAusenteEnd-MsgAusente))/2
    jr ExibirResultado

VDPPrincipal:
    ld hl,MsgPrincipal
    ld a,1+(40-(MsgPrincipalEnd-MsgPrincipal))/2
    jr ExibirResultado

VDPSecundario:
    ld hl,MsgSecundario
    ld a,1+(40-(MsgSecundarioEnd-MsgSecundario))/2

ExibirResultado:
    push hl
    ld h,a
    ld l,12
    call POSIT
    pop hl
ProximoCaractere:
    ld a,(hl)
    or a
    jr z,Fim
    push hl
    call CHPUT
    pop hl
    inc hl
    jr ProximoCaractere

Fim:
    di
    halt

MsgPrincipal:
    db "V9968: VDP PRINCIPAL (98H)"
MsgPrincipalEnd:
    db 0
MsgSecundario:
    db "V9968: CARTUCHO / VDP 2 (88H)"
MsgSecundarioEnd:
    db 0
MsgAusente:
    db "V9968 NAO DETECTADO"
MsgAusenteEnd:
    db 0

include "HWD/V9968.ASM"

romPad:
    ds romSize-(romPad-romArea),0
