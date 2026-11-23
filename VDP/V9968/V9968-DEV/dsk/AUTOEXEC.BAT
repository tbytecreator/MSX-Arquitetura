mode 80
echo ====================================
echo TBYTECREATOR AUTOEXEC.BAT
echo ====================================
ver
path %1\utils
set expert=on
if not %_MSXVER% == Turbo-R alias mode = '"@MODE %&^YENSLASH"'
set BACKSLASH ON
echo ====================================