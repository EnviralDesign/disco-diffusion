:: turn off echo, so we only print intentional user messages.
@echo off

:: use this to break the script at this point, and not go any further
rem exit /b 1

:: set this for proper variable expansion in for loops.
setlocal enableDelayedExpansion

:: change current working cmd directory to the root where batch executes from.
:: NOTE we might be able to nix this if we expand all our paths to absolute..
cd /d %~dp0

:: wipe and reinit our log, with blank.
:: break>start_geopix_Log.txt

:: log some things
@echo.
:: @echo "============================================">>start_geopix_Log.txt
:: @echo "====== BEGIN Disco Diffusion BootStrap =====">>start_geopix_Log.txt
:: @echo "============================================">>start_geopix_Log.txt
@echo "============================================"
@echo "====== BEGIN Disco Diffusion BootStrap ====="
@echo "============================================"

:: Define some variables.
SET ffmpeg_zip_file_name=ffmpeg-release-essentials.zip
SET ffmpeg_url="https://www.gyan.dev/ffmpeg/builds/%ffmpeg_zip_file_name%"

SET git_zip_file_name=PortableGit-2.36.1-64-bit.7z.exe
SET git_url="https://github.com/git-for-windows/git/releases/download/v2.36.1.windows.1/%git_zip_file_name%"

:: Define some paths
SET tmp_dir=%~dp0.tmp
SET ffmpeg_dir=%~dp0.ffmpeg
SET ffmpeg_zip=%~dp0.ffmpeg\%ffmpeg_zip_file_name%
SET git_dir=%~dp0.ddgit
SET git_zip=%~dp0.ddgit\%git_zip_file_name%

:: Define some executables
SET wget=%~dp0thirdparty\wget\wget.exe
SET unzip=%~dp0thirdparty\7zip\7za.exe
SET ffmpeg=%ffmpeg_dir%\ffmpeg.exe
SET git=%git_dir%\bin\git.exe

:: Define some commands
SET ffmpeg_download_cmd="%wget%" -nv --show-progress -P "%ffmpeg_dir%" "%ffmpeg_url%"
SET ffmpeg_unzip_cmd="%unzip%" e "%ffmpeg_zip%" -o"%ffmpeg_dir%"

SET git_download_cmd="%wget%" -nv --show-progress -P "%git_dir%" "%git_url%"
SET git_unzip_cmd="%unzip%" e "%git_zip%" -o"%git_dir%"

:: only download ffmpeg if it doesn't already exist.
if not exist "%ffmpeg_zip%" (
    start "" /WAIT /B %ffmpeg_download_cmd%
)

:: only unzip ffmpeg if it doesn't already exist. we check for ffmpeg.exe and assume if it's present, so is the rest.
if not exist "%ffmpeg%" (
    start "" /WAIT /B %ffmpeg_unzip_cmd%
)

:: only download git if it doesn't already exist.
if not exist "%git_zip%" (
    start "" /WAIT /B %git_download_cmd%
)

:: only unzip git if it doesn't already exist. we check for bin\git.exe and assume if it's present, so is the rest.
if not exist "%git%" (
    start "" /WAIT /B %git_unzip_cmd%
)






Pause