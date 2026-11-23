echo ====== Apagando a ROM antiga =====
rm ROM/TABLES.ROM
echo ======= Compilando nova ROM ======
pasmo TABLES.ASM ROM/TABLES.ROM
echo ============= Pronto =============
openmsx -machine Gradiente_Expert_GPC-1 -cart ROM/TABLES.ROM