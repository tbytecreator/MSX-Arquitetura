echo ====== Apagando a ROM antiga =====
rm ROM/SSCOLOR.ROM
echo ======= Compilando nova ROM ======
pasmo SSCOLOR.ASM ROM/SSCOLOR.ROM
echo ============= Pronto =============
flatpak run org.openmsx.openMSX -machine Gradiente_Expert_GPC-1 -cart ROM/SSCOLOR.ROM