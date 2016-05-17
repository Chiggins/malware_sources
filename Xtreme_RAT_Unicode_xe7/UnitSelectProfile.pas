unit UnitSelectProfile;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvMemo, ExtCtrls, ComCtrls, Buttons, ImgList, Menus, UnitConfigs,
  sPanel, UnitMain;

type
  TFormSelectProfile = class(TForm)
    MainPanel: TsPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Bevel1: TBevel;
    ListView1: TListView;
    Memo1: TAdvMemo;
    ImageList1: TImageList;
    ImageList2: TImageList;
    PopupMenu1: TPopupMenu;
    Adicionarusurio1: TMenuItem;
    Removerusurio1: TMenuItem;
    N1: TMenuItem;
    Selecionarusurio1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormShow(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Selecionarusurio1Click(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure Adicionarusurio1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Removerusurio1Click(Sender: TObject);
  private
    { Private declarations }
    procedure ListFileDir(Path: string);
	procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
  public
    { Public declarations }
    ProfilesDir: string;
    procedure AtualizarIdiomas;
  end;

function BoolToStr(Bool: boolean): string;

var
  FormSelectProfile: TFormSelectProfile;

implementation

{$R *.dfm}

uses
  UnitStrings,
  UnitConstantes,
  CustomIniFiles,
  UnitCommonProcedures,
  UnitCreateServer;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormSelectProfile.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdiomas;
end;  

function BoolToStr(Bool: boolean): string;
begin
  Result := Traduzidos[95];
  if Bool = false then Result := Traduzidos[96];
end;

procedure TFormSelectProfile.Adicionarusurio1Click(Sender: TObject);
begin
  SpeedButton1.Click;
end;

procedure TFormSelectProfile.AtualizarIdiomas;
begin
  SpeedButton1.Hint := Traduzidos[35];
  SpeedButton2.Hint := Traduzidos[36];
  SpeedButton3.Hint := Traduzidos[37];
  ListView1.Column[0].Caption := Traduzidos[38];
  Adicionarusurio1.Caption := SpeedButton1.Hint;
  Removerusurio1.Caption := SpeedButton2.Hint;
  Selecionarusurio1.Caption := SpeedButton3.Hint
end;

procedure TFormSelectProfile.ListFileDir(Path: string);
var
  SR: TSearchRec;
  Item: TListItem;
begin
  if FindFirst(Path + '*.ini', faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Attr <> faDirectory) then
      begin
        if posex('.', SR.Name) > 0 then
        begin
          Item := ListView1.Items.Add;
          Item.ImageIndex := 0;
          Item.Caption := Copy(SR.Name, 1, LastDelimiter('.', SR.Name) - 1);
        end;
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure TFormSelectProfile.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  ProfilesDir := ExtractFilePath(ParamStr(0)) + 'Profiles\';
  ImageList1.GetBitmap(0, SpeedButton1.Glyph);
  ImageList1.GetBitmap(1, SpeedButton2.Glyph);
  ImageList1.GetBitmap(2, SpeedButton3.Glyph);
  SpeedButton2.Visible := False;
  SpeedButton3.Visible := SpeedButton2.Visible;
end;

procedure TFormSelectProfile.FormShow(Sender: TObject);
var
  TempStr: string;
begin
  AtualizarIdiomas;
  ListView1.Items.Clear;
  ListFileDir(ProfilesDir);
  Memo1.Clear;
  Memo1.SetFocus;
  ZeroMemory(@ConfiguracoesServidor, SizeOf(ConfiguracoesServidor));
  FormCreateServer.SpeedButton7.Visible := False;
  FormCreateServer.SpeedButton6.Visible := False;
  FormCreateServer.SpeedButton5.Visible := False;
  FormCreateServer.SpeedButton4.Visible := False;
  FormCreateServer.SpeedButton3.Visible := False;
  FormCreateServer.SpeedButton2.Visible := False;
end;

procedure TFormSelectProfile.ListView1DblClick(Sender: TObject);
begin
  if ListView1.Selected = nil then Exit;
  SpeedButton3.Click;
end;

procedure TFormSelectProfile.ListView1SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  SpeedButton2.Visible := ListView1.Selected <> nil;
  SpeedButton3.Visible := SpeedButton2.Visible;

  if ListView1.Selected = nil then
  begin
    Memo1.Clear;
    exit;
  end;

  if FileExists(ProfilesDir + ListView1.Selected.Caption + '.ini') = False then
  begin
    Listview1.DeleteSelected;
    exit;
  end;

  FormCreateServer.SelectedProfile := ProfilesDir + ListView1.Selected.Caption + '.ini';
  FormCreateServer.LerDados(FormCreateServer.SelectedProfile);
  FormCreateServer.InserirDadosNoMemo(Memo1);
end;

procedure TFormSelectProfile.PopupMenu1Popup(Sender: TObject);
begin
  Removerusurio1.Enabled := ListView1.Selected <> nil;
  Selecionarusurio1.Enabled := ListView1.Selected <> nil;
end;

procedure TFormSelectProfile.Removerusurio1Click(Sender: TObject);
begin
  SpeedButton2.Click;
end;

procedure TFormSelectProfile.Selecionarusurio1Click(Sender: TObject);
begin
  SpeedButton3.Click;
end;

procedure TFormSelectProfile.SpeedButton1Click(Sender: TObject);
var
  TempName, s: string;
  Item: TListItem;
begin
  ForceDirectories(ProfilesDir);

  TempName := 'Profile';
  if Inputquery(traduzidos[97], traduzidos[98] + ':', TempName) = false then exit;
  if TempName = '' then exit;

  s := TempName;
  TempName := ProfilesDir + TempName + '.ini';

  if FileExists(TempName) then
  if MessageBox(Handle,
                pchar(Traduzidos[99] + '?'),
                pchar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_ICONQUESTION or MB_YESNO or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then Exit;

  DeleteFile(TempName);
  FormCreateServer.LerDados(TempName);
  FormCreateServer.SalvarDados(TempName);

  Item := ListView1.Items.Add;
  Item.Caption := s;
  Item.ImageIndex := 0;
end;

procedure TFormSelectProfile.SpeedButton2Click(Sender: TObject);
var
  i: integer;
begin
  if ListView1.Selected = nil then Exit;

  if MessageBox(Handle,
                pwidechar(traduzidos[100] + ' ?'),
                pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> IdYes then exit;
  for i := ListView1.Items.Count - 1 downto 0 do
  if ListView1.Items.Item[i].Selected then
  begin
    DeleteFile(ProfilesDir + ListView1.Items.Item[i].Caption + '.ini');
    ListView1.Items.Item[i].Delete;
  end;
end;

procedure TFormSelectProfile.SpeedButton3Click(Sender: TObject);
begin
  FormCreateServer.SpeedButton2.Visible := True;
  FormCreateServer.SpeedButton3.Visible := True;
  FormCreateServer.SpeedButton4.Visible := True;
  FormCreateServer.SpeedButton5.Visible := True;
  FormCreateServer.SpeedButton6.Visible := True;
  FormCreateServer.SpeedButton7.Visible := True;
  FormCreateServer.SpeedButton2.Down := True;
  FormCreateServer.SpeedButton2.Click;
end;

end.
