@echo off
:: Copyright © 2010-2011 Olivier Mengu‚
:: License: GPLv3

setlocal
set SPEC=First
if "%~1"=="-a" (
    set SPEC=All
    shift
)
if "%~1"=="--" shift

if "%~1"=="" exit /B 2

:: Add the current directory to the PATH
call :$AbsolutePath P .
set PATH=%P%;%PATH%

set Found=

:: Shortcut for this special case that the shell knows how to handle
if %SPEC%==First if not "%~x1"=="" goto :FirstExtBuiltin

::Slow
if not "%~x1"=="" call :VisitPATH :Visit%SPEC%Ext "%~1"
if not "%~x1"=="" (
    if not #%Found%==#1 call :VisitPATH :Visit%SPEC% "%~n1"
) else (
    call :VisitPATH :Visit%SPEC% "%~1"
)
:End
endlocal & if #%Found%==#1 exit /B 0
echo %~1 not found.>&2
exit /B 1

:: Use builtin for this special case
:FirstExtBuiltin
set Found=%~$PATH:1
if not "%Found%"=="" echo %Found%& set Found=1
goto :End

:: Test one filename
:VisitFirstExt2
if #%Found%==#1 goto :EOF
:VisitFirstExt
:VisitAllExt
:VisitAllExt1
:VisitAllExt2
::echo %~1 ?
if not exist "%~1" goto :EOF
echo %~f1
set Found=1
goto :EOF

:: Test all extensions for the %1 filename
:VisitFirst
:VisitAll
:VisitAll1
for %%e in (%PATHEXT%) do call :Visit%SPEC%Ext2 "%~1%%e"
:VisitFirst1
:VisitFirstExt1
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
call :VisitPATH_Loop . %1 "%~2"
goto :EOF

:VisitPATH_Loop
set VisitPATH_Q=%PATH%
:: Find the first "." (%1) in the reduced %PATH% => first directory in %PATH%
set PATH=%VisitPATH_P%& call %2%Found% "%~$PATH:1\%~3"
:: Delete the first path
set PATH=%VisitPATH_Q:*;=%
if not "%PATH%"=="%VisitPATH_Q%" goto :VisitPATH_Loop

set PATH=%VisitPATH_P%
set VisitPATH_P=
set VisitPATH_Q=
goto :EOF

