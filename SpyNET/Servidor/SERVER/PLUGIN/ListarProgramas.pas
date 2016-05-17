Unit ListarProgramas;

interface

uses
  windows;

const
  UNINST_PATH = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  Separador = '##@@';

function ListarApp(Clave: String): String;

implementation

uses
  UnitDiversos;

function GetValueName(chave, valor: string): string;
begin
  try
    result := lerreg(HKEY_LOCAL_MACHINE, pchar(chave), pchar(valor), '');
    except
    result := '';
  end;
end;

function ToKey(Clave: String): HKEY;
begin
  if Clave = 'HKEY_CLASSES_ROOT' then
    Result := HKEY_CLASSES_ROOT
  else if Clave = 'HKEY_CURRENT_CONFIG' then
    Result := HKEY_CURRENT_CONFIG
  else if Clave = 'HKEY_CURRENT_USER' then
    Result := HKEY_CURRENT_USER
  else if Clave = 'HKEY_LOCAL_MACHINE' then
    Result := HKEY_LOCAL_MACHINE
  else if Clave = 'HKEY_USERS' then
    Result := HKEY_USERS
  else
    Result:=0;
end;

function ListarApp(Clave: String): String;
var
  phkResult: hkey;
  lpName: PChar;
  lpcbName, dwIndex: Cardinal;
  lpftLastWriteTime: FileTime;
  DispName, UninstStr, QuietUninstallString: string;
begin
  result := '';
  if clave = '' then exit;

  RegOpenKeyEx(ToKey(Copy(Clave, 1, Pos('\', Clave) - 1)),
                PChar(Copy(Clave, Pos('\', Clave) + 1, Length(Clave))),
                0,
                KEY_ENUMERATE_SUB_KEYS,
                phkResult);

  lpcbName := 255;
  GetMem(lpName, lpcbName);
  dwIndex := 0;
  while RegEnumKeyEx(phkResult, dwIndex, @lpName[0] , lpcbName, nil, nil, nil, @lpftLastWriteTime) = ERROR_SUCCESS do
  begin
    DispName := getvaluename(UNINST_PATH + '\' + lpname, 'DisplayName');
    UninstStr := getvaluename(UNINST_PATH + '\' + lpname, 'UninstallString');
    QuietUninstallString := getvaluename(UNINST_PATH + '\' + lpname, 'QuietUninstallString');

    if DispName <> '' then
    begin
      Result := Result + DispName + Separador;
      if QuietUninstallString <> '' then Result := Result + QuietUninstallString + Separador + 'YYY' + separador + #13#10 else
      if UninstStr <> '' then Result := Result + UninstStr + Separador + 'NNN' + separador + #13#10 else Result := Result + ' ' + separador + 'NNN' + separador + #13#10;
    end;
    Inc(dwIndex);
    lpcbName := 255;
  end;
  RegCloseKey(phkResult);
end;

end.

