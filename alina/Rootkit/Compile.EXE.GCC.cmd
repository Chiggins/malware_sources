@echo off

SET Libraries=-lmsvcrt -lkernel32 -luser32 -lgcc -lshell32 -ladvapi32
SET SourceFiles=%ProjectName%.c
SET Extention=exe
SET ExtraFlags=-shared -Wl,--enable-stdcall-fixup

IF EXIST InjectedDLL.dll DEL InjectedDLL.dll
IF EXIST InjectedDLL.inc DEL InjectedDLL.inc

gcc InjectedDLL.c %ExtraFlags% -Wl,--relax  -masm=intel -Wl,--gc-sections -fno-asynchronous-unwind-tables -Wall -Wextra -o InjectedDLL.dll %Libraries% -nostdlib -Wl,-e__DllMain  -O1 -O2 -O3 -Os -s
gcc FileToByteArray.c -o FileToByteArray.exe %Libraries% -O1 -O2 -O3 -Os -s
FileToByteArray.exe InjectedDLL.dll InjectedDLL
IF EXIST FileToByteArray.exe DEL FileToByteArray.exe
IF EXIST InjectedDLL.dll DEL InjectedDLL.dll

IF EXIST InjectedDLL.inc (
echo Compiled
) ELSE (
echo Error Compiling !
)
pause