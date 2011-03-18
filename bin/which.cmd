@echo off
:: Copyright © 2010-2011 Olivier Mengu‚
:: License: GPLv3

if "%1"=="" exit /B 1

setlocal
set SPEC=First
if "%1"=="-a" (
    set SPEC=All
    shift
)
if "%1"=="--" shift

:: Add the current directory to the PATH
call :$AbsolutePath P .
set PATH=%P%;%PATH%

goto :Find%SPEC%

:FindFirst
if "%~x1"=="" goto :NoExt

:: Extension provided
if exist "%~1" echo %~f1& goto :EOF
call :Find "%~1"
goto :End

:NoExt
set F=%~1
for %%e in (%PATHEXT%) do call :Find "%F%%%e"

:End
if "%Found%"=="1" goto :OK
echo %~1 not found.>&2
endlocal
exit /B 1

:Find
::echo.%~1
call :$PathFinder P "%~1"
if "%P%"=="" goto :EOF
if "%~f1"=="" call :Found?2 "%P%" & goto :EOF
:Found?2
if "%~x1"=="" goto :EOF
set Found=1
echo.%P%
goto :EOF

:FindAll
echo Not yet implemented.>&2
exit /B 1


:OK
endlocal
exit /B 0

:$PathFinder
set "%1=%~$PATH:2"
goto :EOF

:$AbsolutePath
set "%1=%~f2"
goto :EOF

