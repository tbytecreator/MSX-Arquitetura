@echo off
SET ASMFILE=MVSPRITE.ASM
SET ROMFILE=ROM\MVSPRITE.ROM
echo ====== Apagando a ROM antiga =====
del %ROMFILE%
echo ======= Compilando nova ROM ======
pasmo %ASMFILE% %ROMFILE%
echo ============= Pronto =============
openmsx -machine Gradiente_Expert_GPC-1 -cart %ROMFILE%