@rem Project build batch script

@set projdir=PonySrc\
@set projname=Pony
@set masmdir=..\masm32
@set build_rc=0
@set align_16=
@set build_dll=
@set projext=exe
@set linker=polink.exe 
@set libextra=
@set relocs=
:loop1

@if "%1" == "build_rc" @set build_rc=1
@if "%1" == "align" @set align_16=/ALIGN:16
@if "%1" == "dll" @set projext=dll
@if "%1" == "dll" @set build_dll=/DLL
@if "%1" == "lib" @set projname=PonyStatic
@if "%1" == "lib" @set projext=lib
@if "%1" == "lib" @set build_dll=/LIB
@if "%1" == "lib" @set linker=polib.exe
@if "%1" == "relocs" @set relocs=/FIXED:no
@shift

@if not "%1" == "" goto loop1

@set app_run_on_build=0
@set debug=0

@cd %projdir%

@echo off
@cls
@break on

if exist %projname%.%projext% del %projname%.%projext%
if exist %projname%.%projext% goto err_common

if %build_rc% == 0 goto no_rc
rem Build resources...
%masmdir%\bin\wrc.exe -q -zm -r -fo"%projname%.res" "%projname%.rc" >rc_err.txt
if not exist %projname%.res goto err_brcc

:no_rc

@set dodebuglnk=/RELEASE
if %debug% == 0 goto no_debug
@set dodebugml=/DDEBUG
@set dodebuglnk=/DEBUG /PDB:NONE
:no_debug

rem Compile...
%masmdir%\bin\jwasm -W2 -Zg /nologo %dodebugml% /c /coff /Cp /WX /I%masmdir%\include\ /I%masmdir%\com\include\ %projname%.asm >ml_err.txt
if not exist %projname%.obj goto err_ml

if %build_rc% == 0 goto no_rc_link
rem Link with resources...
@set vlink=%projname%.res
goto rc_link
:no_rc_link
rem Link...
@set vlink=
:rc_link

%masmdir%\bin\%linker% %dodebuglnk% %build_dll% %relocs% /OUT:../%projname%.%projext% %align_16% /NOLOGO /SUBSYSTEM:WINDOWS /LIBPATH:%masmdir%\lib %projname%.obj %vlink% >l_err.txt

if exist %projname%.obj del %projname%.obj
if exist ../%projname%.%projext% goto ok

echo -LINKER- Reported:
type l_err.txt
goto err_common

:err_brcc
echo -RESOURCE COMPILER- Reported:
type rc_err.txt
goto err_common

:err_ml
echo -COMPILER- Reported:
type ml_err.txt

:err_common
echo.
echo.

goto end

:ok
if %app_run_on_build%==0 goto end
%projname%.%projext%

:end

rem Clean up...
if exist ml_err.txt del ml_err.txt
if exist l_err.txt del l_err.txt
if exist rc_err.txt del rc_err.txt
if exist %projname%.res del %projname%.res
if exist %projname%_rc.obj del %projname%_rc.obj
if exist %projname%.ilk del %projname%.ilk
if exist %projname%.pdb del %projname%.pdb
if exist %projname%.err del %projname%.err

if exist *.bin del *.bin
if exist ..\*.bin del ..\*.bin

@echo on