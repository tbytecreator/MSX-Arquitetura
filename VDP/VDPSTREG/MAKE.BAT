@echo off
echo ====== Apagando a ROM antiga =====
del ROM\LESTSVDP.ROM
echo ======= Compilando nova ROM ======
pasmo LESTSVDP.ASM ROM\LESTSVDP.ROM
echo ============= Pronto =============
openmsx -machine Gradiente_Expert_GPC-1 -cart ROM\LESTSVDP.ROM