@echo off
TITLE Avira command line scanner (All in One)
:: ---------------------ADMIN PRIVILEGES-------------------
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
::---------------------------------------------------------

::-----------------------FIRST RUN-------------------------
if not exist *.key (
    COLOR 0c
    echo You need a Avira license - Put .key file in "%~dp0" 
    pause > nul
    exit
)

if exist "scancl.exe" (
   if exist "fusebundle.exe" (
       goto menu
   )
)
powershell -Command "Invoke-WebRequest http://professional.avira-update.com/package/scancl/win32/en/scancl-win32.zip -OutFile scancl-win32.zip"
powershell -Command "Invoke-WebRequest http://install.avira-update.com/package/fusebundlegen/win32/en/avira_fusebundlegen-win32-en.zip -OutFile avira_fusebundlegen-win32-en.zip"
powershell -Command "expand-archive -path 'avira_fusebundlegen-win32-en.zip'"
powershell -Command "expand-archive -path 'scancl-win32.zip'"
xcopy /Q /Y "scancl-win32\scancl-1.9.161.2" "%~dp0"
xcopy /Q /Y "avira_fusebundlegen-win32-en" "%~dp0"
rmdir /s /q scancl-win32
rmdir /s /q avira_fusebundlegen-win32-en
goto update
::---------------------------------------------------------

