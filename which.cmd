@echo off
:: Copyright: © 2010 Olivier Mengué
:: License: GPLv3

if not "%~x1"=="" if exist "%1" echo %~f1& goto :EOF
setlocal
set F=%~nx1
call :$PathFinder P "%F%"
call :Found?
for %%e in (%PATHEXT%) do (
    call :$PathFinder P "%F%%%e"
    call :Found?
)

if "%Found%"=="1" goto :OK
echo %F% not found.>&2
endlocal
exit /B 1

:Found?
if "%P%"=="" goto :EOF
if "%~f1"=="" call :Found?2 "%P%" & goto :EOF
:Found?2
if "%~x1"=="" goto :EOF
set Found=1
echo.%P%
goto :EOF

:OK
endlocal
exit /B 0

:$PathFinder
set "%1=%~$PATH:2"
goto :EOF