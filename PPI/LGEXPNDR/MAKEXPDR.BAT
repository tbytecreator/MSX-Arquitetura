@echo off
echo ====== Apagando a BIN antiga =====
del DSK\LGEXPNDR.BIN
echo ======= Compilando nova BIN ======
pasmo --msx LGEXPNDR.ASM DSK\LGEXPNDR.BIN
echo ============= Pronto =============
openmsx -machine Gradiente_Expert_GPC-1 -ext DDX_3.0 -diska DSK\. -ext slotexpander
