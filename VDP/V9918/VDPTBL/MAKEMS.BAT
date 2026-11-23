@echo off
SET ASMFILE=MSPRITES.ASM
SET ROMFILE=ROM\MSPRITES.ROM
echo ====== Apagando a ROM antiga =====
del %ROMFILE%
echo ======= Compilando nova ROM ======
pasmo %ASMFILE% %ROMFILE%
echo ============= Pronto =============
openmsx -machine Gradiente_Expert_GPC-1 -cart %ROMFILE%