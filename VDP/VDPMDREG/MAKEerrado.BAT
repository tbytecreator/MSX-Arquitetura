@echo off
echo ====== Apagando a ROM antiga =====
del ROM\ERRADO.ROM
echo ======= Compilando nova ROM ======
pasmo ERRADO.ASM ROM\ERRADO.ROM
echo ============= Pronto =============
openmsx -machine Gradiente_Expert_GPC-1 -cart ROM\ERRADO.ROM