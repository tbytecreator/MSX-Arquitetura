@echo off
echo ====== Apagando a ROM antiga =====
del ROM\KBRPORTS.BIN
echo ======= Compilando nova ROM ======
pasmo --msx KBRPORTS.ASM DSK\KBRPORTS.BIN
echo ============= Pronto =============
openmsx -machine Gradiente_Expert_DD_Plus -diska DSK\. 