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

SET magick_zip_file_name=ImageMagick-7.1.0-portable-Q16-x64.zip
SET magick_url="https://download.imagemagick.org/ImageMagick/download/binaries/%magick_zip_file_name%"

SET curl_zip_file_name=curl-7.83.1_4-win64-mingw.zip
SET curl_url="https://curl.se/windows/dl-7.83.1_4/%curl_zip_file_name%"

SET conda_zip_file_name=Miniconda3-py39_4.12.0-Windows-x86_64.exe
SET conda_url="https://repo.anaconda.com/miniconda/%conda_zip_file_name%"



:: Define some paths
SET tmp_dir=%~dp0.tmp

SET ffmpeg_dir=%~dp0.ffmpeg
SET ffmpeg_zip=%~dp0.ffmpeg\%ffmpeg_zip_file_name%

SET git_dir=%~dp0.ddgit
SET git_zip=%~dp0.ddgit\%git_zip_file_name%

SET magick_dir=%~dp0.magick
SET magick_zip=%~dp0.magick\%magick_zip_file_name%

SET curl_dir=%~dp0.curl
SET curl_zip=%~dp0.curl\%curl_zip_file_name%

SET conda_dir=%~dp0.conda
SET conda_zip=%~dp0.conda\%conda_zip_file_name%




:: Define some executables that are already included with repo
SET wget=%~dp0thirdparty\wget\wget.exe
SET unzip=%~dp0thirdparty\7zip\7za.exe

:: Define some executables that will be downloaded/checked for in this script.
SET ffmpeg=%ffmpeg_dir%\ffmpeg-5.0.1-essentials_build\bin\ffmpeg.exe
SET git=%git_dir%\bin\git.exe
SET magick=%magick_dir%\magick.exe
SET curl=%curl_dir%\curl-7.83.1_4-win64-mingw\bin\curl.exe
SET conda=%conda_dir%\_conda.exe


:: Define some commands
SET ffmpeg_download_cmd="%wget%" -nv --show-progress -P "%ffmpeg_dir%" "%ffmpeg_url%"
SET ffmpeg_unzip_cmd="%unzip%" x "%ffmpeg_zip%" -aoa -o"%ffmpeg_dir%"

SET git_download_cmd="%wget%" -nv --show-progress -P "%git_dir%" "%git_url%"
SET git_unzip_cmd="%unzip%" x "%git_zip%" -aoa -o"%git_dir%"

SET magick_download_cmd="%wget%" -nv --show-progress -P "%magick_dir%" "%magick_url%"
SET magick_unzip_cmd="%unzip%" x "%magick_zip%" -aoa -o"%magick_dir%"

SET curl_download_cmd="%wget%" -nv --show-progress -P "%curl_dir%" "%curl_url%"
SET curl_unzip_cmd="%unzip%" x "%curl_zip%" -aoa -o"%curl_dir%"

SET conda_download_cmd="%wget%" -nv --show-progress -P "%conda_dir%" "%conda_url%"
:: we need to follow the command line instructions to install conda portably:
:: https://docs.conda.io/projects/conda/en/latest/user-guide/install/windows.html#installing-in-silent-mode

:: ======================= FFMPEG =============================
:: only download ffmpeg if it doesn't already exist.
if not exist "%ffmpeg_zip%" (
    start "" /WAIT /B %ffmpeg_download_cmd%
)

:: only unzip ffmpeg if it doesn't already exist. we check for ffmpeg.exe and assume if it's present, so is the rest.
if not exist "%ffmpeg%" (
    start "" /WAIT /B %ffmpeg_unzip_cmd%
)

:: ======================= GIT =============================
:: only download git if it doesn't already exist.
if not exist "%git_zip%" (
    start "" /WAIT /B %git_download_cmd%
)

:: only unzip git if it doesn't already exist. we check for bin\git.exe and assume if it's present, so is the rest.
if not exist "%git%" (
    start "" /WAIT /B %git_unzip_cmd%
    %git_dir%\git-bash.exe --no-needs-console --hide --no-cd --command=post-install.bat
)

:: ======================= IMAGE MAGICK =============================
:: only download image magick if it doesn't already exist.
if not exist "%magick_zip%" (
    start "" /WAIT /B %magick_download_cmd%
)

:: only unzip image magick if it doesn't already exist. we check for main executable.
if not exist "%magick%" (
    start "" /WAIT /B %magick_unzip_cmd%
)

:: ======================= CURL =============================
:: only download curl if it doesn't already exist.
if not exist "%curl_zip%" (
    start "" /WAIT /B %curl_download_cmd%
)

:: only unzip curl if it doesn't already exist. we check for main executable.
if not exist "%curl%" (
    start "" /WAIT /B %curl_unzip_cmd%
)

:: ======================= CONDA =============================
:: only download conda if it doesn't already exist.
if not exist "%conda_zip%" (
    start "" /WAIT /B %conda_download_cmd%
)

:: only unzip conda if it doesn't already exist. we check for main executable.
if not exist "%conda%" (
    %conda_zip% /InstallationType=JustMe /AddToPath=0 /RegisterPython=0 /NoRegistry=1 /S /D=%conda_dir%
)

@REM start "" /WAIT /B "conda create --name disco-diffusion python=3.9"
@REM start "" /WAIT /D %conda_dir% "_conda.exe create -y --name disco-diffusion python=3.9"
%conda% create -y --name disco-diffusion python=3.9

:: ok the problem here is that we are not finding opencv-python in the default conda repos.
:: need to find out what version is installed at home (can test here by manually making conda env, activate, install)
:: and then try to find out which channel we need to include.
%conda% install -n disco-diffusion -y -c conda-forge ipykernel opencv-python pandas regex matplotlib ipywidgets


:: NO GO PAST!!!
@REM exit /b 1





Pause