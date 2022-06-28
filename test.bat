:: turn off echo, so we only print intentional user messages.
@echo off

setlocal enableDelayedExpansion


SET td_year=2021
SET td_version=16410
SET td_zip_file_name="TouchDesigner.%td_year%.%td_version%"
SET td_url="https://download.derivative.ca/%td_zip_file_name%.exe"
SET td_registry_query="HKEY_CLASSES_ROOT\TouchDesigner.%td_year%.%td_version%\shell\open\command"

SET td_executable_path=

:: currently this does not work, why is unclear since it's direct copy paste from GP's startup script.
:: perhaps we just give in and install TD locally no matter what?

reg query %td_registry_query%>nul
if %errorlevel% equ 0 (
    for /f "tokens=3" %%a in ('reg query %td_registry_query%') do set td_executable_path=%%a
    SET td_executable_path=!td_executable_path!
    if exist !td_executable_path! goto TD_Is_Already_Installed
) else (
    goto TD_Needs_To_Be_Installed
)

:TD_Needs_To_Be_Installed

echo "INSTALL TD"

:TD_Is_Already_Installed

echo "TD ALREADY INSTALLED"



