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
