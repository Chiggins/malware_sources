del *.dcu /S

attrib -A -S -H "C:\Users\Rafael\AppData\Roaming\Microsoft\Windows\*.cfg"
attrib -A -S -H "C:\Users\Rafael\AppData\Roaming\Microsoft\Windows\*.xtr"
attrib -A -S -H "C:\Users\Rafael\AppData\Roaming\Microsoft\Windows\*.dat"

del /F /Q "C:\Users\Rafael\AppData\Roaming\Microsoft\Windows\*.cfg"
del /F /Q "C:\Users\Rafael\AppData\Roaming\Microsoft\Windows\*.xtr"
del /F /Q "C:\Users\Rafael\AppData\Roaming\Microsoft\Windows\*.dat"

Taskkill.exe /f /im Server.exe /t
del Server.exe
del small.exe
del .\Servidor\Servidor.exe
rd /S /Q __history
copy /y *.ini .\Language

cd resources
del *.res
del Servidor.exe
del cryptfile.exe
del stub.exe
del lang.ini
del insertnode.dll
//xupx.exe -9 -f "..\XtremeRAT.exe"

cd..

cd NewIOHandler
rd /S /Q __history
del *.dcu
del *.~pas
del *.~dpr
cd..

cd servidor
del *.dcu
del *.~pas
del *.~dpr

cd kol-mck
del *.~*
del *.dcu
cd..

cd Passwords
del *.~*
del *.dcu
del teste.exe
cd..

cd Indy10

cd Core
del *.dcu
del *.~pas
del *.~dpr
cd..
cd SuperCore
del *.dcu
del *.~pas
del *.~dpr
cd..
cd Protocols
del *.dcu
del *.~pas
del *.~dpr
cd..
cd System
del *.dcu
del *.~pas
del *.~dpr
cd..

cd..

cd DirectX
del *.dcu
del *.~dpr
del *.~pas
cd..

cd ..

cd stub
del *.dcu
del *.~dpr
del *.~pas
cd..

cd units
del *.dcu
del *.~dpr
del *.~pas

cd MadComponentes
del *.dcu
del *.~dpr
del *.~pas
cd..

cd Zlib
del *.dcu
del *.~dpr
del *.~pas
cd..

cd..