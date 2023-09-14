@echo off
echo ====== Apagando a ROM antiga =====
del ROM\BIOSCALL.ROM
echo ======= Compilando nova ROM ======
pasmo BIOSCALL.ASM ROM\BIOSCALL.ROM
echo ============= Pronto =============
openmsx -machine Gradiente_Expert_DD_Plus -cart ROM\BIOSCALL.ROM