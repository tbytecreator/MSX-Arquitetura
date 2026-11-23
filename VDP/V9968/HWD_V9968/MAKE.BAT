@echo off
setlocal
rem Uso: MAKE.BAT V9968CHECK.ASM (ou MAKE.BAT V9968CHECK)
if "%~1"=="" (
    echo Uso: %~nx0 programa[.ASM] 1>&2
    exit /b 1
)
if not "%~2"=="" (
    echo Uso: %~nx0 programa[.ASM] 1>&2
    exit /b 1
)

pushd "%~dp0"
if errorlevel 1 exit /b 1
set "SOURCE=%~1"
if "%~x1"=="" set "SOURCE=%~1.ASM"
if not exist "%SOURCE%" (
    echo Arquivo nao encontrado: %SOURCE% 1>&2
    goto error
)

for %%I in ("..\..\..\V9968-DEV") do set "DEV_DIR=%%~fI"
rem Defina V9968_OPENMSX se o executavel Windows estiver em outro local.
if not defined V9968_OPENMSX set "V9968_OPENMSX=%DEV_DIR%\openmsx.exe"
if not exist "%V9968_OPENMSX%" (
    echo Executavel Windows nao encontrado: %V9968_OPENMSX% 1>&2
    goto error
)
if not exist "%DEV_DIR%\roms\" (
    echo Pasta de ROMs nao encontrada: %DEV_DIR%\roms 1>&2
    goto error
)

if not exist ROM mkdir ROM
set "LOCAL_ROM=ROM\%~n1.ROM"
set "EMULATOR_ROM=%DEV_DIR%\roms\%~n1.ROM"
echo Compilando %SOURCE%
pasmo "%SOURCE%" "%LOCAL_ROM%"
if errorlevel 1 goto error
if exist "%EMULATOR_ROM%" (
    fc /b "%LOCAL_ROM%" "%EMULATOR_ROM%" >nul
    if errorlevel 2 goto error
    if errorlevel 1 (
        choice /C SN /N /M "Substituir %EMULATOR_ROM%? [s/N] "
        if errorlevel 2 goto error
        if not errorlevel 1 goto error
    )
)
copy /Y "%LOCAL_ROM%" "%EMULATOR_ROM%" >nul
if errorlevel 1 goto error
set "OPENMSX_SYSTEM_DATA=%DEV_DIR%\share"
"%V9968_OPENMSX%" -machine Panasonic_FS-A1ST_V9968 -ext ram4mb -cart "%EMULATOR_ROM%" -diska "%DEV_DIR%\dsk"
if errorlevel 1 goto error
popd
exit /b 0

:error
popd
exit /b 1
