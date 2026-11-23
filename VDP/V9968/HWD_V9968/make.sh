#!/bin/sh
set -eu

# Uso: ./make.sh V9968CHECK.ASM (ou ./make.sh V9968CHECK)
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 programa[.ASM]" >&2
    exit 1
fi

cd "$(dirname "$0")"
case "$1" in
    *.[aA][sS][mM]) source_file=$1 ;;
    *) source_file=$1.ASM ;;
esac
if [ ! -f "$source_file" ]; then
    echo "Arquivo nao encontrado: $source_file" >&2
    exit 1
fi

name=$(basename "$source_file")
name=${name%.*}
dev_dir=$(CDPATH= cd -- ../V9968-DEV && pwd)
emulator=$dev_dir/derived/x86_64-linux-opt/bin/openmsx
if [ ! -x "$emulator" ] || [ ! -d "$dev_dir/roms" ]; then
    echo "Emulador ou pasta de ROMs nao encontrados em $dev_dir" >&2
    exit 1
fi

mkdir -p ROM
local_rom=ROM/$name.ROM
emulator_rom=$dev_dir/roms/$name.ROM
echo "Compilando $source_file"
pasmo "$source_file" "$local_rom"
if [ -e "$emulator_rom" ] && ! cmp -s "$local_rom" "$emulator_rom"; then
    printf 'Substituir %s? [s/N] ' "$emulator_rom" >&2
    IFS= read -r answer || exit 1
    case "$answer" in
        s|S) ;;
        *) echo "Copia cancelada." >&2; exit 1 ;;
    esac
fi
cp "$local_rom" "$emulator_rom"

export OPENMSX_SYSTEM_DATA=$dev_dir/share
export OPENMSX_USER_DATA=${OPENMSX_USER_DATA:-$HOME/.openMSX/share}
exec "$emulator" -machine Panasonic_FS-A1ST_V9968 -ext ram4mb \
    -cart "$emulator_rom" -diska "$dev_dir/dsk"
