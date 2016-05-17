unit UnitBindFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Menus, StdCtrls, Buttons, ComCtrls, ExtCtrls;

type
  TFormBindFiles = class(TForm)
    Panel1: TPanel;
    ListView2: TListView;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    ComboBox4: TComboBox;
    ComboBox3: TComboBox;
    Edit5: TEdit;
    Edit6: TEdit;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    ImageList1: TImageList;
    Delete1: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    procedure BitBtn4Click(Sender: TObject);
    procedure Edit5Enter(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure AtualizarStrings;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormBindFiles: TFormBindFiles;

implementation

{$R *.dfm}

uses
  UnitPrincipal,
  UnitDiversos,
  CommCtrl,
  UnitBytesSize,
  UnitStrings,
  Shellapi,
  UnitComandos;

type
  TIconSize = (isSmall, isLarge);

procedure GetFileIcon(IsFolder: boolean; ImageList: TImageList; ListItem: TListItem;
  Name: String; IconSize: TIconSize);
var
  FInfo: TSHFileInfo;
  ImageListHandle: THandle;
begin
  if IsFolder = false then
  begin
    if IconSize = isLarge then
    ImageListHandle := SHGetFileInfo(PAnsiChar(Name),0,FInfo,SizeOf(TSHFileInfo),
    SHGFI_LARGEICON or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES)
    else
    ImageListHandle := SHGetFileInfo(PAnsiChar(Name),0,FInfo,SizeOf(TSHFileInfo),
    SHGFI_SMALLICON or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
  end else

  begin
    if IconSize = isLarge then
    ImageListHandle := SHGetFileInfo(PAnsiChar(Name),FILE_ATTRIBUTE_DIRECTORY,FInfo,SizeOf(TSHFileInfo),
    SHGFI_LARGEICON or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES)
    else
    ImageListHandle := SHGetFileInfo(PAnsiChar(Name),FILE_ATTRIBUTE_DIRECTORY,FInfo,SizeOf(TSHFileInfo),
    SHGFI_SMALLICON or SHGFI_SYSICONINDEX or SHGFI_USEFILEATTRIBUTES);
  end;

  SendMessage(ListItem.Owner.Owner.Handle, LVM_SETIMAGELIST, LVSIL_SMALL, ImageListHandle);
  SendMessage(ListItem.Owner.Owner.Handle, LVM_SETIMAGELIST, LVSIL_NORMAL, ImageListHandle);

  ListItem.ImageIndex := FInfo.iIcon;
end;

procedure TFormBindFiles.AtualizarStrings;
begin
  listview2.Column[0].Caption := traduzidos[20];
  listview2.Column[1].Caption := traduzidos[464];
  listview2.Column[2].Caption := traduzidos[365];
  listview2.Column[3].Caption := traduzidos[465];
  listview2.Column[4].Caption := traduzidos[466];

  label5.Caption := listview2.Column[0].Caption + ':';
  label6.Caption := listview2.Column[1].Caption + ':';
  label8.Caption := listview2.Column[3].Caption + ':';
  label2.Caption := listview2.Column[4].Caption + ':';
  BitBtn4.Caption := traduzidos[43];

  Delete1.Caption := traduzidos[32];
  label1.Caption := traduzidos[463];
end;

function IsValidPE(Fichier: String): Boolean;
var
  EnteteDOS: TImageDosHeader;  //Structure pour l'entête DOS MZ
  EntetePE : TImageNtHeaders;  //Structure pour l'entête PE
  FStream  : TFileStream;      //Stream de lecture
begin

  Result := True;

  If not FileExists(Fichier) then
  begin
    Result := False;
    Exit;
  end;

  FStream := TFileStream.Create(Fichier, fmOpenRead);
  try
    try
      //Lecture de l'entête DOS MZ
      FStream.ReadBuffer(EnteteDOS, SizeOf(EnteteDOS));

      //Comparaison de la signature du fichier avec la signature DOS
      If EnteteDOS.e_magic <> IMAGE_DOS_SIGNATURE then
        Result := False
      else
      begin
        //Déplacement jusqu'à l'entête PE dont l'offset est indiqué par _lfanew
        FStream.Seek(EnteteDOS._lfanew, soFromBeginning);
        //Lecture de l'entête PE
        FStream.ReadBuffer(EntetePE, SizeOf(EntetePE));

        //Comparaison de la signature de l'entête avec la signature PE
        If EntetePE.Signature <> IMAGE_NT_SIGNATURE then
          Result := False;
      end;
    except
      //En cas de problème, on renvoie False
      On Exception do
        Result := False;
    end;
  finally
    FStream.Free;
  end;
end;

procedure TFormBindFiles.BitBtn4Click(Sender: TObject);
var
  ListItem: TListItem;
  tamanho: cardinal;
  Size: int64;
begin
  if Edit5.Text = '' then
  begin
    messagedlg(pchar(traduzidos[461]), mtWarning, [mbOK], 0);
    exit;
  end;

  if listview2.Items.Count >= 10 then
  begin
    messagedlg(pchar(traduzidos[460]), mtWarning, [mbOK], 0);
    exit;
  end;

  if combobox4.ItemIndex = 2 then
  begin
    if IsValidPE(Edit5.Text) = false then
    begin
      edit5.Clear;
      messagedlg(pchar(traduzidos[467]), mtWarning, [mbOK], 0);
      exit;
    end;
  end;

  ListItem := Listview2.Items.Add;
  ListItem.Caption := Edit5.Text;
  ListItem.SubItems.AddObject(combobox3.Text, TObject(combobox3.ItemIndex));

  size := MyGetFileSize(edit5.Text);
  ListItem.SubItems.AddObject(BytesSize(Size), TObject(Size));
  ListItem.SubItems.AddObject(combobox4.Text, TObject(combobox4.ItemIndex));
  if edit6.Text <> '' then ListItem.SubItems.Add(edit6.Text) else ListItem.SubItems.Add(' ');
  GetFileIcon(false, Imagelist1, ListView2.Items.Item[ListView2.Items.Count - 1], ListItem.Caption, isSmall);
  edit5.Clear;
end;

procedure TFormBindFiles.Edit5Enter(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  if (Ctrl is TEdit) then
  TEdit(Ctrl).Color := clSkyBlue;
  if (Ctrl is TMemo) then
  TMemo(Ctrl).Color := clSkyBlue;
  if (Ctrl is TListView) then
  TListView(Ctrl).Color := clSkyBlue;
  if (Ctrl is TRichEdit) then
  TRichEdit(Ctrl).Color := clSkyBlue;
  if (Ctrl is TComboBox) then
  TComboBox(Ctrl).Color := clSkyBlue;
  if (Ctrl is TListBox) then
  TListBox(Ctrl).Color := clSkyBlue;
end;

procedure TFormBindFiles.Edit5Exit(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  if (Ctrl is TEdit) then
  TEdit(Ctrl).Color := clWindow;
  if (Ctrl is TMemo) then
  TMemo(Ctrl).Color := clWindow;
  if (Ctrl is TListView) then
  TListView(Ctrl).Color := clWindow;
  if (Ctrl is TRichEdit) then
  TRichEdit(Ctrl).Color := clWindow;
  if (Ctrl is TComboBox) then
  TComboBox(Ctrl).Color := clWindow;
  if (Ctrl is TListBox) then
  TListBox(Ctrl).Color := clWindow;
end;

procedure TFormBindFiles.BitBtn3Click(Sender: TObject);
begin
  opendialog1.Filter := 'All Files (*.*)' + '|*.*';
  opendialog1.InitialDir := ExtractFilePath(paramstr(0));
  opendialog1.Title := Application.Title + ' ' + VersaoPrograma;
  if opendialog1.Execute then Edit5.Text := opendialog1.FileName else
  edit5.Clear;
end;

procedure TFormBindFiles.Delete1Click(Sender: TObject);
var
  i: integer;
begin
  if Listview2.Selected <> nil then
  begin
    for i := ListView2.Items.Count - 1 downto 0 do
    if Listview2.Items.Item[i].Selected = true then Listview2.Items.Item[i].Delete;
  end;
end;

procedure TFormBindFiles.PopupMenu1Popup(Sender: TObject);
begin
  delete1.Enabled := listview2.Selected <> nil;
end;

procedure TFormBindFiles.FormShow(Sender: TObject);
begin
  Caption := traduzidos[462];
  AtualizarStrings;
end;

end.
