@echo off
echo ====== Apagando a ROM antiga =====
del ROM\LEVDP.ROM
echo ======= Compilando nova ROM ======
pasmo LEVDP.ASM ROM\LEVDP.ROM
echo ============= Pronto =============
openmsx -machine Gradiente_Expert_GPC-1 -cart ROM\LEVDP.ROM