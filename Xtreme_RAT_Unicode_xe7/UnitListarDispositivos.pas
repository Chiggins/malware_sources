unit UnitListarDispositivos;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ExtCtrls, UnitMain, UnitConexao, sSkinProvider;

type
  TFormListarDispositivos = class(TForm)
    StatusBar1: TStatusBar;
    tvDevices: TTreeView;
    Splitter1: TSplitter;
    lvAdvancedInfo: TListView;
    ilDevices: TImageList;
    sSkinProvider1: TsSkinProvider;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvAdvancedInfoCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure tvDevicesCompare(Sender: TObject; Node1, Node2: TTreeNode;
      Data: Integer; var Compare: Integer);
    procedure tvDevicesChange(Sender: TObject; Node: TTreeNode);
  private
    { Private declarations }
    Servidor: TConexaoNew;
    NomePC: string;
    LiberarForm: boolean;
  	procedure WMCloseFree(var Message: TMessage); message WM_CLOSEFREE;
  	procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
    procedure AtualizarStrings;
    procedure ListarTodosDispositivos(Lista: string);
    procedure ListarDispositivosExtras(TempStr: string);
    procedure InitImageList;
    procedure ReleaseImageList;
    function GetDeviceImageIndex(DeviceGUID: TGUID): Integer;
    procedure CreateParams(var Params : TCreateParams); override;
  public
    { Public declarations }
    procedure OnRead(Recebido: String; ConAux: TConexaoNew); overload;
    constructor Create(aOwner: TComponent; ConAux: TConexaoNew);overload;
  end;

var
  FormListarDispositivos: TFormListarDispositivos;

implementation

{$R *.dfm}

uses
  UnitConstantes,
  ListarDispositivos,
  SetupAPI,
  UnitStrings,
  CustomIniFiles,
  UnitCommonProcedures;

//Here's the implementation of CreateParams
procedure TFormListarDispositivos.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  if FormMain.ControlCenter = True then Exit;
  Params.WndParent := GetDesktopWindow;
end;

procedure TFormListarDispositivos.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarStrings;
end;

procedure TFormListarDispositivos.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

constructor TFormListarDispositivos.Create(aOwner: TComponent; ConAux: TConexaoNew);
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
    Width := IniFile.ReadInteger('Devices', 'Width', Width);
    Height := IniFile.ReadInteger('Devices', 'Height', Height);
    Left := IniFile.ReadInteger('Devices', 'Left', Left);
    Top := IniFile.ReadInteger('Devices', 'Top', Top);

    tvDevices.Width := IniFile.ReadInteger('Devices', 'TV1', tvDevices.Width);
    lvAdvancedInfo.Column[0].Width := IniFile.ReadInteger('Devices', 'LV1_0', lvAdvancedInfo.Column[0].Width);
    lvAdvancedInfo.Column[1].Width := IniFile.ReadInteger('Devices', 'LV1_1', lvAdvancedInfo.Column[1].Width);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

end;

procedure TFormListarDispositivos.OnRead(Recebido: String; ConAux: TConexaoNew);
var
  DeviceClassesCount,
  DevicesCount: string;
begin
  if copy(recebido, 1, posex('|', recebido) - 1) = LISTADEDISPOSITIVOSPRONTA then
  begin
    delete(recebido, 1, posex('|', recebido));

    DeviceClassesCount := copy(recebido, 1, posex('|', recebido) - 1);
    delete(recebido, 1, posex('|', recebido));

    DevicesCount := copy(recebido, 1, posex('|', recebido) - 1);
    delete(recebido, 1, posex('|', recebido));

    ListarTodosDispositivos(recebido);

    StatusBar1.Panels.Items[0].Text := traduzidos[400] + ': ' + DeviceClassesCount;
    StatusBar1.Panels.Items[1].Text := traduzidos[401] + ': ' + DevicesCount;
    tvDevices.Enabled := true;
  end else

  if copy(recebido, 1, posex('|', recebido) - 1) = LISTADEDISPOSITIVOSEXTRASPRONTA then
  begin
    delete(recebido, 1, posex('|', recebido));
    ListarDispositivosExtras(recebido);
    tvDevices.Enabled := true;
  end else




end;

procedure TFormListarDispositivos.AtualizarStrings;
begin
  lvAdvancedInfo.Columns.Items[0].Caption := traduzidos[402];
  lvAdvancedInfo.Columns.Items[1].Caption := traduzidos[403];
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
    while (length(Lista) > 2) and (Visible = True) do // tamanho #13#10
    begin
      DeviceClassName := copy(Lista, 1, posex(SeparadorDevices, Lista) - 1);
      delete(Lista, 1, posex(SeparadorDevices, Lista) + length(SeparadorDevices) - 1);

      tvRoot := tvDevices.Items.Add(nil, DeviceClassName);

      TempStr := copy(Lista, 1, posex('##' + SeparadorDevices, Lista) - 1);
      delete(Lista, 1, posex('##' + SeparadorDevices, Lista) + 1);
      delete(Lista, 1, length(SeparadorDevices));

      copymemory(@ClassGUID, @tempstr[1], sizeof(ClassGUID));

      tvRoot.ImageIndex := GetDeviceImageIndex(ClassGUID);
      tvRoot.SelectedIndex := tvRoot.ImageIndex;
      tvRoot.StateIndex := strtoint(copy(Lista, 1, posex(SeparadorDevices, Lista) - 1));
      delete(Lista, 1, posex(SeparadorDevices, Lista) + length(SeparadorDevices) - 1);
      delete(Lista, 1, 2); // #13#10

      while posex('@@', Lista) = 1 do
      begin
        delete(Lista, 1, 2); // '@@'

        DeviceName := copy(Lista, 1, posex(SeparadorDevices, Lista) - 1);
        delete(Lista, 1, posex(SeparadorDevices, Lista) + length(SeparadorDevices) - 1);

        TempStr := copy(Lista, 1, posex('##' + SeparadorDevices, Lista) - 1);
        delete(Lista, 1, posex('##' + SeparadorDevices, Lista) + 1);
        delete(Lista, 1, length(SeparadorDevices));

        copymemory(@DeviceInfoData.ClassGuid, @tempstr[1], sizeof(DeviceInfoData.ClassGuid));

        dwIndex := strtoint(copy(Lista, 1, posex(SeparadorDevices, Lista) - 1));
        delete(Lista, 1, posex(SeparadorDevices, Lista) + length(SeparadorDevices) - 1);
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
  if lvAdvancedInfo.Items.Count > 0 then lvAdvancedInfo.Items.Clear;

  try
    lvAdvancedInfo.Items.BeginUpdate;
    while length(Tempstr) > 2 do
    begin
      Item := lvAdvancedInfo.Items.Add;
      Item.Caption := copy(TempStr, 1, posex(SeparadorDevices, Tempstr) - 1);
      delete(TempStr, 1, posex(SeparadorDevices, Tempstr) + length(SeparadorDevices) - 1);
      Item.SubItems.Add(copy(TempStr, 1, posex(SeparadorDevices, Tempstr) - 1));
      delete(TempStr, 1, posex(SeparadorDevices, Tempstr) + length(SeparadorDevices) - 1);
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

procedure TFormListarDispositivos.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  TempStr: WideString;
  IniFile: TIniFile;
begin
  if LiberarForm then Action := caFree;

  TempStr := ExtractFilePath(ParamStr(0)) + 'Settings\';
  ForceDirectories(TempStr);
  TempStr := TempStr + NomePC + '.ini';

  try
    IniFile := TIniFile.Create(TempStr, IniFilePassword);
    IniFile.WriteInteger('Devices', 'Width', Width);
    IniFile.WriteInteger('Devices', 'Height', Height);
    IniFile.WriteInteger('Devices', 'Left', Left);
    IniFile.WriteInteger('Devices', 'Top', Top);
    IniFile.WriteInteger('Devices', 'TV1', tvDevices.Width);
    IniFile.WriteInteger('Devices', 'LV1_0', lvAdvancedInfo.Column[0].Width);
    IniFile.WriteInteger('Devices', 'LV1_1', lvAdvancedInfo.Column[1].Width);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;
end;

procedure TFormListarDispositivos.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;

  if lvAdvancedInfo.Items.Count > 0 then lvAdvancedInfo.Items.Clear;
  InitImageList;
end;

procedure TFormListarDispositivos.FormShow(Sender: TObject);
begin
  tvDevices.Enabled := true;
  if lvAdvancedInfo.Items.Count > 0 then lvAdvancedInfo.Items.Clear;
  tvDevices.Items.Clear;
  AtualizarStrings;
  StatusBar1.Panels.Items[0].Text := Traduzidos[205];
  StatusBar1.Panels.Items[1].Text := Traduzidos[205];
  sleep(10);
  Servidor.enviarString(LISTDEVICES + '|');
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
    Servidor.enviarString(LISTEXTRADEVICES + '|' + inttostr(ANode.StateIndex) + '|');
  end;
end;

end.
