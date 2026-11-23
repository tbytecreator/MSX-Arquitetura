@echo off
echo ====== Apagando a ROM antiga =====
del ROM\TESTE.ROM
echo ======= Compilando nova ROM ======
pasmo TESTE.ASM ROM\TESTE.ROM
echo ============= Pronto =============
openmsx -machine Gradiente_Expert_GPC-1 -cart ROM\TESTE.ROM