@echo off
echo ====== Apagando a ROM antiga =====
del ROM\WRTVDPMD.ROM
echo ======= Compilando nova ROM ======
pasmo WRTVDPMD.ASM ROM\WRTVDPMD.ROM
echo ============= Pronto =============
openmsx -machine Gradiente_Expert_GPC-1 -cart ROM\WRTVDPMD.ROM