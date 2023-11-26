@echo off
echo ====== Apagando a ROM antiga =====
del ROM\KBRPORTS.BIN
echo ======= Compilando nova ROM ======
pasmo --msx KBRPORTS.ASM DSK\KBRPORTS.BIN
echo ============= Pronto =============
openmsx -machine Gradiente_Expert_GPC-1 -ext DDX_3.0 -diska DSK\. 