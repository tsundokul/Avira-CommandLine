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

:menu
cls
Mode con cols=60 lines=17  | MORE
Echo: [1] Scan                
Echo: [2] Update Avira   
Echo: [3] Cofing Scan 
Echo: [4] Github  | MORE
Set /P optm=^>^> 
If "%optm%"=="1" (Goto :scanmenu)
If "%optm%"=="2" (Goto :update)
If "%optm%"=="3" (start notepad "scancl.conf")
If "%optm%"=="4" (start "" https://github.com/SegoCode?tab=repositories)
goto menu


:update
cls
Mode con cols=90 lines=10
del *.zip
del *.vdf
del *.gz
del *.crt
del *.yml
del *.idx
del *.rdf
del *.dat
for %%i in (*.dll) do if not "%%i"=="msvcr90.dll" del "%%i"
cls
Echo:
echo     Updating Avira . . . 
Echo: 
fusebundle.exe
powershell -Command "expand-archive -path 'install\vdf_fusebundle.zip'" 
xcopy /q /y "vdf_fusebundle" "%~dp0" 
rmdir /s /q install 
rmdir /s /q temp 
rmdir /s /q vdf_fusebundle 
cls
echo m=msgbox("Avira successfully updated." ,0, "Updater") >> msgbox.vbs
msgbox.vbs
del *.vbs
goto menu

