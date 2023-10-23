@echo off
echo ====== Apagando a BIN antiga =====
del DSK\EXPANDER.BIN
del DSK\CAPS.BIN
echo ======= Compilando nova BIN ======
pasmo --msx EXPANDER.ASM DSK\EXPANDER.BIN
pasmo --msx CAPS.ASM DSK\CAPS.BIN
echo ============= Pronto =============
openmsx -machine Gradiente_Expert_GPC-1 -ext DDX_3.0 -diska DSK\. 
