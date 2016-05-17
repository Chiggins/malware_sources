unit UnitRegistry;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, IdAntiFreezeBase,
  IdAntiFreeze, IdBaseComponent, IdComponent, IdTCPServer, IdThreadMgr,
  IdThreadMgrDefault, ComCtrls, Menus, ExtCtrls, UnitPrincipal;

type
  TFormRegistry = class(TForm)
    TreeViewRegedit: TTreeView;
    ListViewRegistro: TListView;
    PopupRegistro: TPopupMenu;
    Nuevo1: TMenuItem;
    Clave1: TMenuItem;
    N2: TMenuItem;
    Valoralfanumrico1: TMenuItem;
    Valorbinerio1: TMenuItem;
    valorDWORD1: TMenuItem;
    Valordecadenamltiple1: TMenuItem;
    N3: TMenuItem;
    N1: TMenuItem;
    Eliminar1: TMenuItem;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    Splitter1: TSplitter;
    procedure TreeViewRegeditChange(Sender: TObject; Node: TTreeNode);
    procedure TreeViewRegeditContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: Boolean);
    procedure TreeViewRegeditDblClick(Sender: TObject);
    procedure ListViewRegistroContextPopup(Sender: TObject;
      MousePos: TPoint; var Handled: Boolean);
    procedure Clave1Click(Sender: TObject);
    procedure Valoralfanumrico1Click(Sender: TObject);
    procedure Valorbinerio1Click(Sender: TObject);
    procedure valorDWORD1Click(Sender: TObject);
    procedure Valordecadenamltiple1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure Eliminar1Click(Sender: TObject);
    procedure ListViewRegistroEdited(Sender: TObject; Item: TListItem;
      var S: String);
    procedure FormShow(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
  private
    Servidor: PConexao;
    TreeNodePrincipal: array [1..99999] of TTreeNode;
    NumArrayPrincipal: integer;

    procedure AniadirValoresARegistro(Valores: String);
    procedure AniadirClavesARegistro(Claves: String; NumArray: integer);
    function ObtenerRutaAbsolutaDeArbol(Nodo: TTreeNode): String;
    function CountChars(char, str: string): integer;
    { Private declarations }
  public
    NomePC: String;
    procedure atualizarstrings;
    procedure OnRead(Recebido: String; ConAux: PConexao); overload;
    constructor Create(aOwner: TComponent; ConAux: PConexao); overload;
    { Public declarations }
  end;

var
  FormRegistry: TFormRegistry;

implementation

{$R *.dfm}

uses
  UnitComandos,
  UnitFormReg,
  UnitStrings,
  UnitConexao,
  UnitCryptString;

Type
  KeysRecord = record
    Name: shortString;
  end;

type
  ValoresRecord = record
    Name: shortstring;
    Tipo: shortString;
    Dados: shortstring;
  end;

function TFormRegistry.CountChars(char, str: string): integer;
var
  i: integer;
begin
  result := 0;
  if str = '' then exit;
  if pos(char, str) <= 0 then exit;
  i := 1;
  for i := 1 to length(str) do
  begin
    if str[i] = char then inc(result, 1);
  end;
end;


//Obtiene la ruta completa del arbol padre\hijo\nieto\ xD
function TFormRegistry.ObtenerRutaAbsolutaDeArbol(Nodo: TTreeNode): String;
begin
  repeat
    Result := Nodo.Text + '\' + Result;
    Nodo := Nodo.Parent;
  until not Assigned(Nodo);
end;

//Lo hacemos en una función a parte para no saturar de código la función OnRead
procedure TFormRegistry.AniadirClavesARegistro(Claves: String; NumArray: integer);
var
  Nodo: TTreeNode;
  KR: KeysRecord;
begin
  TreeNodePrincipal[NumArray].DeleteChildren;

  while length(Claves) > 0 do
  begin
    CopyMemory(@KR, @Claves[1], sizeof(KeysRecord));
    delete(Claves, 1, sizeof(KeysRecord));

    Nodo := TreeViewRegedit.Items.AddChild(TreeNodePrincipal[NumArray], KR.Name);
    //Sin seleccionar mostrar el icono de carpeta cerrada
    Nodo.ImageIndex := 244;
    //Seleccionado mostrar el icono de carpeta abierta
    Nodo.SelectedIndex := 243;

  end;
  TreeNodePrincipal[NumArray].Expand(False);
end;

procedure TFormRegistry.AniadirValoresARegistro(Valores: String);
var
  Item: TListItem;

  VR: ValoresRecord;
begin
  if ListViewRegistro.Items.Count > 0 then
  ListViewRegistro.Clear;

  while length(Valores) > 0 do
  begin
    CopyMemory(@VR, @Valores[1], sizeof(ValoresRecord));
    delete(Valores, 1, sizeof(ValoresRecord));

    Item := ListViewRegistro.Items.Add;
    Item.Caption := VR.Name;

    if (VR.Tipo = REG_BINARY_) or (VR.Tipo = REG_DWORD_) then Item.ImageIndex := 245 else
      Item.ImageIndex := 246;

    Item.SubItems.Add(VR.Tipo);
    Item.SubItems.Add(VR.Dados);
  end;
end;

constructor TFormRegistry.Create(aOwner: TComponent; ConAux: PConexao);
begin
  inherited Create(aOwner);
  Servidor := ConAux;
end;

function LerTraduzidos(i: integer): string;
begin
  result := traduzidos[i];
end;

procedure TFormRegistry.OnRead(Recebido: String; ConAux: PConexao);
var
  TempStr, TempStr1: string;
  TempInt, TempInt1: integer;

  ArrayTreeNodePrincipal: integer;
begin
  if Copy(recebido, 1, pos('|', recebido) - 1) = REGISTRO then
  begin
    Delete(recebido, 1, pos('|', recebido));

    TempInt := strtoint(Copy(recebido, 1, pos('|', recebido) - 1));
    Delete(recebido, 1, pos('|', recebido));

    Statusbar1.Panels.Items[1].Text := LerTraduzidos(TempInt) + ' ' + Copy(recebido, 1, pos('|', recebido) - 1);
  end else

  if Copy(recebido, 1, pos('|', recebido) - 1) = RENAMEKEY then
  begin
    Delete(recebido, 1, pos('|', recebido));

    TempInt1 := strtoint(Copy(recebido, 1, pos('|', recebido) - 1));
    Delete(recebido, 1, pos('|', recebido));

    TempInt := strtoint(Copy(recebido, 1, pos('|', recebido) - 1));
    Delete(recebido, 1, pos('|', recebido));

    TempStr := Copy(recebido, 1, pos('|', recebido) - 1);
    TempStr1 := Tempstr;
    Delete(recebido, 1, pos('|', recebido));
    delete(TempStr, 1, pos(' <---> ', tempstr));

    while CountChars('\', TempStr) > 1 do delete(tempstr, 1, 1);
    delete(tempstr, length(tempstr), 1);
    delete(tempstr, length(tempstr), 1);

    Statusbar1.Panels.Items[1].Text := LerTraduzidos(TempInt) + ' ' + TempStr1;

    if TempInt = 272 then
    begin
      TreeNodePrincipal[TempInt1].Text := TempStr;
      TreeViewRegedit.Select(TreeViewRegedit.TopItem);
      TreeViewRegedit.Select(TreeNodePrincipal[TempInt1]);
    end;
  end else

  if Copy(recebido, 1, pos('|', recebido) - 1) = LISTARCHAVES then
  begin
    Delete(recebido, 1, pos('|', recebido));
    ArrayTreeNodePrincipal := strtoint(Copy(recebido, 1, pos('|', recebido) - 1));
    Delete(recebido, 1, Pos('|', recebido));
    AniadirClavesARegistro(recebido, ArrayTreeNodePrincipal);

  end else

  if Copy(recebido, 1, pos('|', recebido) - 1) = LISTARVALORES then
  begin
    Delete(recebido, 1, pos('|', recebido));
    AniadirValoresARegistro(recebido);
  end else





end;

procedure TFormRegistry.TreeViewRegeditChange(Sender: TObject;
  Node: TTreeNode);
var
  ToSend: string;
begin
  if TreeViewRegedit.Selected <> nil then
  begin
    StatusBar1.Panels.Items[0].Text := ObtenerRutaAbsolutaDeArbol(TreeViewRegedit.Selected);

    ToSend := LISTARVALORES + '|' + StatusBar1.Panels.Items[0].Text + '|';

    enviarstring(Servidor.Athread, ToSend, true);
  end;
end;

procedure TFormRegistry.TreeViewRegeditContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  //Para ao fazer um clique com o botão direito sobre um item, este fique selecionado
  if TreeViewRegedit.GetNodeAt(MousePos.X, MousePos.Y) <> nil then
  begin
    TreeViewRegedit.Selected := TreeViewRegedit.GetNodeAt(MousePos.X, MousePos.Y);

    if CountChars('\', StatusBar1.Panels.Items[0].Text) <= 1 then
    begin
      PopupRegistro.Items[1].Enabled := False;
      PopupRegistro.Items[2].Enabled := False;
      PopupRegistro.Items[3].Enabled := false;
    end else
    begin
      PopupRegistro.Items[1].Enabled := true;
      PopupRegistro.Items[2].Enabled := true;
      PopupRegistro.Items[3].Enabled := true;
    end;
  end
  else //se não existir item selecionado
  begin
    PopupRegistro.Items[1].Enabled := False;
    PopupRegistro.Items[2].Enabled := False;
    PopupRegistro.Items[3].Enabled := False;
  end;

end;

procedure TFormRegistry.TreeViewRegeditDblClick(Sender: TObject);
var
  ToSend: string;
begin
  if TreeViewRegedit.Selected = nil then exit;
  try
    sleep(50);
    TreeNodePrincipal[NumArrayPrincipal] := TreeViewRegedit.Selected;

    ToSend := LISTARCHAVES + '|' + inttostr(NumArrayPrincipal) + '|' + StatusBar1.Panels.Items[0].Text + '|';

    enviarstring(Servidor.Athread, ToSend, true);
    inc(NumArrayPrincipal, 1);
    except
  end;
end;

procedure TFormRegistry.ListViewRegistroContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
begin
  //se algum item estiver selecionado
  if ListViewRegistro.Selected <> nil then
  begin
    //habilitamos as opções pare trabalharmos com as chaves
    PopupRegistro.Items[1].Enabled := True;
    PopupRegistro.Items[2].Enabled := True;
    PopupRegistro.Items[3].Enabled := True;
  end
  else
  begin
    //se algum item não estiver selecionado, só mostrar o menu novo
    PopupRegistro.Items[1].Enabled := False;
    PopupRegistro.Items[2].Enabled := False;
    PopupRegistro.Items[3].Enabled := False;
  end;
end;

procedure TFormRegistry.Clave1Click(Sender: TObject);
var
  NewClave: String;
begin
  NewClave := traduzidos[259];
  if InputQuery(pchar(traduzidos[260]), pchar(traduzidos[261]), NewClave) = true then
  EnviarString(Servidor.Athread, NOVACHAVE + '|' + StatusBar1.Panels.Items[0].Text + '|' + NewClave + '|', true);
end;

procedure TFormRegistry.Valoralfanumrico1Click(Sender: TObject);
var
  NewRegistro: TFormReg;
begin
  NewRegistro := TFormReg.Create(self, Servidor, StatusBar1.Panels.Items[0].Text, REG_SZ_);
  NewRegistro.ShowModal;
end;

procedure TFormRegistry.Valorbinerio1Click(Sender: TObject);
var
  NewRegistro: TFormReg;
begin
  NewRegistro := TFormReg.Create(self, Servidor, StatusBar1.Panels.Items[0].Text, REG_BINARY_);
  NewRegistro.ShowModal;
end;

procedure TFormRegistry.valorDWORD1Click(Sender: TObject);
var
  NewRegistro: TFormReg;
begin
  NewRegistro := TFormReg.Create(self, Servidor, StatusBar1.Panels.Items[0].Text, REG_DWORD_);
  NewRegistro.ShowModal;
end;

procedure TFormRegistry.Valordecadenamltiple1Click(Sender: TObject);
var
  NewRegistro: TFormReg;
begin
  NewRegistro := TFormReg.Create(self, Servidor, StatusBar1.Panels.Items[0].Text, REG_MULTI_SZ_);
  NewRegistro.ShowModal;
end;

procedure TFormRegistry.N1Click(Sender: TObject);
var
  TempStr, TempStr1: string;
begin
  if PopupRegistro.PopupComponent.ClassType  = TListView then
  begin
    if ListViewRegistro.Selected <> nil then
      //Pone el cursor para editar en el item
      ListViewRegistro.Selected.EditCaption;
  end else
  if PopupRegistro.PopupComponent.ClassType  = TTreeView then
  begin
    if TreeViewRegedit.Selected = nil then exit;

    TreeNodePrincipal[NumArrayPrincipal] := TreeViewRegedit.Selected;

    TempStr := StatusBar1.Panels.Items[0].Text;
    TempStr1 := TempStr;

    delete(tempstr, length(tempstr), 1);
    delete(tempstr1, length(tempstr1), 1);

    if CountChars('\', TempStr) > 0 then
    begin
      tempstr1 := copy(tempstr1, 1, lastdelimiter('\', tempstr1));

      while CountChars('\', TempStr) > 0 do delete(tempstr, 1, 1);
      if inputquery(pchar(traduzidos[129]), pchar(traduzidos[260]), TempStr) then
      begin
        //messagebox(0, pchar(StatusBar1.Panels.Items[0].Text + #13#10 + tempstr1 + TempStr + '\'), '', 0);
        EnviarString(Servidor.Athread,
                     RENAMEKEY + '|' + inttostr(NumArrayPrincipal) + '|' +
                     StatusBar1.Panels.Items[0].Text + '|' + tempstr1 + TempStr + '\' + '|', true);
        inc(NumArrayPrincipal, 1);
      end;
    end;
  end;
end;

procedure TFormRegistry.Eliminar1Click(Sender: TObject);
begin
  if PopupRegistro.PopupComponent.ClassType = TListView then
  begin
    if MessageDlg(pchar(traduzidos[262]) + ' ' + ListViewRegistro.Selected.Caption + '?', mtConfirmation, [MbYes, MBNo], 0) <> IdNo then
    begin
      EnviarString(Servidor.Athread, APAGARREGISTRO + '|' +
                   StatusBar1.Panels.Items[0].Text + ListViewRegistro.Selected.Caption + '|', true);
    end;
  end else
  if MessageDlg(pchar(traduzidos[263]) + ' ' + TreeViewRegedit.Selected.Text + '?', mtConfirmation, [MbYes, MBNo], 0) <> IdNo then
  EnviarString(Servidor.Athread, APAGARREGISTRO + '|' + StatusBar1.Panels.Items[0].Text + '|', true);
end;

procedure TFormRegistry.ListViewRegistroEdited(Sender: TObject;
  Item: TListItem; var S: String);
begin
  if ListViewRegistro.Selected = nil then exit;
  EnviarString(Servidor.Athread, NOVONOMEVALOR + '|' +
               StatusBar1.Panels.Items[0].Text + '|' + Item.Caption + '|' + S + '|', true);
end;

procedure TFormRegistry.AtualizarStrings;
var
  i: integer;
begin
  NumArrayPrincipal := 1;

  ListviewRegistro.Column[0].Caption := traduzidos[231];
  ListviewRegistro.Column[1].Caption := traduzidos[264];
  ListviewRegistro.Column[2].Caption := traduzidos[265];
  Nuevo1.Caption := traduzidos[80];
  N1.Caption := traduzidos[155];
  Eliminar1.Caption := traduzidos[32];
  Clave1.Caption := traduzidos[266];
  Valoralfanumrico1.Caption := traduzidos[267];
  Valorbinerio1.Caption := traduzidos[268];
  valorDWORD1.Caption := traduzidos[269];
  Valordecadenamltiple1.Caption := traduzidos[270];
end;

procedure TFormRegistry.FormShow(Sender: TObject);
begin
  AtualizarStrings;
  Statusbar1.Panels.Items[0].Width := Treeviewregedit.Width;
end;

procedure TFormRegistry.Splitter1Moved(Sender: TObject);
begin
  Statusbar1.Panels.Items[0].Width := Treeviewregedit.Width;
end;

end.
