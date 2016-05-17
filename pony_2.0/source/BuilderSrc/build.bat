@echo off

cd CalcModuleSize
call CalcModuleSize.exe
cd ..

rem Delphi XE3
set RAD="C:\Program Files (x86)\Embarcadero\RAD Studio\10.0\"

pushd %RAD%\bin\
call rsvars.bat
popd

call brcc32.exe Resources\Images\Resources.rc -foResources.res -32
call dcc32.exe -UASkin\DelphiXE3\ -IASkin\DelphiXE3\ -NSsystem;System.Win;WinAPI;Vcl;Vcl.Imaging;Data; -B -DRELEASE PonyBuilder.dpr -E..\

call ..\masm32\bin\upx.exe --best ..\PonyBuilder.exe

call cleanup.bat