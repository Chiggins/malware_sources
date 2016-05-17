unit UnitInstalledApplications;

interface

uses
  windows;

function ListarProgramasInstalados: widestring;

implementation

uses
  UnitConstantes;

function RegReadString(Key: HKey; SubKey: widestring; DataType: integer; Data: widestring): widestring;
var
  RegKey: HKey;
  Buffer: array[0..9999] of WideChar;
  BufSize: Integer;
begin
  BufSize := SizeOf(Buffer);
  Result := '';
  if RegOpenKeyW(Key,pwidechar(SubKey),RegKey) = ERROR_SUCCESS then begin;
    if RegQueryValueExW(RegKey, pwidechar(Data), nil,  @DataType, @Buffer, @BufSize) = ERROR_SUCCESS then begin;
      RegCloseKey(RegKey);
      Result := widestring(Buffer);
    end;
  end;
end;

function _regEnumKeys(hkKey: HKEY; lpSubKey: PWideChar): widestring;
var
  dwIndex, lpcbName: DWORD;
  phkResult: HKEY;
  lpName: Array[0..MAX_PATH * 2] of WideChar;
begin
  Result := '';

  if RegOpenKeyExW(hkKey, lpSubKey, 0, KEY_READ, phkResult) = ERROR_SUCCESS then begin
    dwIndex := 0;
    lpcbName := sizeof(lpName);
    ZeroMemory(@lpName, sizeof(lpName));

    while RegEnumKeyExW(phkResult, dwIndex, @lpName, lpcbName, nil, nil, nil, nil) <> ERROR_NO_MORE_ITEMS do begin

      Result := Result + RegReadString(HKEY_LOCAL_MACHINE,'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\' + lpName + '\',REG_SZ,'DisplayName') ;
      Result := Result + delimitadorComandos;

      Result := Result + RegReadString(HKEY_LOCAL_MACHINE,'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\' + lpName + '\',REG_SZ,'DisplayVersion') ;
      Result := Result + delimitadorComandos;

      Result := Result + RegReadString(HKEY_LOCAL_MACHINE,'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\' + lpName + '\',REG_SZ,'Publisher') ;
      Result := Result + delimitadorComandos;

      Result := Result + RegReadString(HKEY_LOCAL_MACHINE,'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\' + lpName + '\',REG_SZ,'UninstallString') ;
      Result := Result + delimitadorComandos;

      Result := Result + RegReadString(HKEY_LOCAL_MACHINE,'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\' + lpName + '\',REG_SZ,'QuietUninstallString') ;
      Result := Result + delimitadorComandos + #13#10;


      ZeroMemory(@lpName, sizeof(lpName));
      lpcbName := sizeof(lpName);
      inc(dwIndex);
    end;

    RegCloseKey(phkResult);
  end;
end;

function ListarProgramasInstalados: widestring;
begin
  result := _regEnumKeys(HKEY_LOCAL_MACHINE,'software\microsoft\windows\currentversion\uninstall\');
end;

end.
