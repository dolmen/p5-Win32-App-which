@echo off
:: Copyright © 2010-2011 Olivier Mengu‚
:: License: GPLv3

if "%~1"=="" exit /B 1

setlocal
set SPEC=First
if "%~1"=="-a" (
    set SPEC=All
    shift
)
if "%1"=="--" shift

:: Add the current directory to the PATH
call :$AbsolutePath P .
set PATH=%P%;%PATH%

set Found=

if not "%~x1"=="" set F=%~1& call :VisitPATH :Visit%SPEC%Ext
set F=%~1
if "%Found%"=="1" exit /B 0
call :VisitPATH :Visit%SPEC%
endlocal & if "%Found%"=="1" exit /B 0
echo %~1 not found.>&2
endlocal
exit /B 1

:VisitFirstExt
if "%Found%"=="1" goto :EOF
if not exist "%~1\%F%" goto :EOF
echo %~1\%F%
set Found=1
goto :EOF

:VisitFirst
if "%Found%"=="1" goto :EOF
set G=%F%
for %%e in (%PATHEXT%) do set F=%G%%%e& call :VisitFirstExt "%~1"
set F=%G%
goto :EOF
::if not "%Found%"=="1" if exist "%~1\%F%%%e" echo %~1\%F%%%e& set Found=1

:VisitAllExt
if not exist "%~1\%F%" goto :EOF
echo %~1\%F%
set Found=1
goto :EOF

:VisitAll
for %%e in (%PATHEXT%) do (
    if exist "%~1\%F%%%e" echo %~1\%F%%%e& set Found=1
)
goto :EOF

:$AbsolutePath
set "%1=%~f2"
goto :EOF

:: VisitPATH
::
:: %1 callback name
::
: == VisitPATH ==
set VisitPATH_P=%PATH%
call :VisitPATH_Loop %1 .
goto :EOF

:VisitPATH_Loop
set VisitPATH_Q=%PATH%
:: Find the first "." in the reduced %PATH% => first directory in %PATH%
set PATH=%VisitPATH_P%& call %1 "%~$PATH:2"
set PATH=%VisitPATH_Q:*;=%
if not "%PATH%"=="%VisitPATH_Q%" goto :VisitPATH_Loop

set PATH=%VisitPATH_P%
set VisitPATH_P=
set VisitPATH_Q=
goto :EOF

