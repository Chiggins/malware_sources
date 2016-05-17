unit UnitDesktop;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, UnitMain, JPeg, ExtCtrls, Mask,
  sSkinManager, sSkinProvider, sTrackBar, UnitConexao, sUpDown;

type
  TFormDesktop = class(TForm)
    Timer1: TTimer;
    Edit2: TEdit;
    SpeedButton1: TButton;
    SpeedButton2: TButton;
    AdvTrackBar1: TsTrackBar;
    Label1: TLabel;
    SRCheckBox1: TCheckBox;
    UpDown1: TsUpDown;
    Edit1: TEdit;
    SRCheckBox2: TCheckBox;
    SRCheckBox3: TCheckBox;
    Image1: TImage;
    SpeedButton3: TSpeedButton;
    bsSkinStdLabel1: TLabel;
    StatusBar1: TStatusBar;
    sSkinProvider1: TsSkinProvider;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SRCheckBox3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1Click(Sender: TObject);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AdvTrackBar1Change(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
    imagematual: integer;
    Servidor: TConexaoNew;
    ServidorTransferencia: TConexaoNew;
    LastQuality: integer;
    LastInterval: integer;
    LastWidth, LastHeight: integer;
    OriginalCaption: string;
    Ratio: Single;
    Diferenca: integer;
    OriginalX, OriginalY: integer;
    Texto: string;
    LastTick: integer;
    MouseCommand: string;
    NomePC: string;
    LiberarForm: boolean;
  	procedure WMCloseFree(var Message: TMessage); message WM_CLOSEFREE;
    procedure AtualizarIdioma;
    procedure WMEXITSIZEMOVE(var Message: TMessage); message WM_EXITSIZEMOVE;
    procedure WMENTERSIZEMOVE(var Message: TMessage); message WM_ENTERSIZEMOVE;
    procedure Mouse(Direction: byte; Button: TMouseButton; X, Y: integer);
   	procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
    procedure CreateParams(var Params : TCreateParams); override;
  public
    { Public declarations }
    procedure OnRead(Recebido: String; ConAux: TConexaoNew); overload;
    constructor Create(aOwner: TComponent; ConAux: TConexaoNew); overload;
  end;

var
  FormDesktop: TFormDesktop;

implementation

{$R *.dfm}

uses
  UnitConstantes,
  UnitStrings,
  CustomIniFiles,
  UnitCommonProcedures,
  UnitSettings;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormDesktop.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdioma;
end;

procedure TFormDesktop.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

//Here's the implementation of CreateParams
procedure TFormDesktop.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  Params.WndParent := GetDesktopWindow;
end;

type
  TKeys = record
    key: integer;
    shift: TShiftState;
end;

procedure TFormDesktop.WMEXITSIZEMOVE(var Message: TMessage);
var
  w, h: integer;
  Mudou: boolean;
begin
  w := Image1.Width;
  h := Image1.Height;

  Mudou := true;
  if LastWidth <> Width then ClientHeight := Round(w * Ratio) + Diferenca else
  if LastHeight <> Height then ClientWidth := Round(h / Ratio) else Mudou := false;

  if (Mudou = true) or (LastQuality <> AdvTrackBar1.Position) or (LastInterval <> UpDown1.Position) then
  begin
    LastQuality := AdvTrackBar1.Position;
    LastInterval := UpDown1.Position;
    if (SpeedButton1.Visible = false) and (SpeedButton2.Visible = false) then exit;
    Servidor.EnviarString(DESKTOPCONFIG + '|' +
                                   Inttostr(LastQuality) + '|' +
                                   Inttostr(Image1.Width) + '|' +
                                   Inttostr(Image1.Height) + '|' +
                                   Inttostr(LastInterval) + '|');
  end;
end;

procedure TFormDesktop.WMENTERSIZEMOVE(var Message: TMessage);
begin
  LastWidth := Width;
  LastHeight := Height;
end;

procedure TFormDesktop.FormCreate(Sender: TObject);
var
  i: integer;
  TempStr: WideString;
  IniFile: TIniFile;
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;

  ServidorTransferencia := nil;

  FormMain.ImageListDiversos.GetBitmap(76, SpeedButton3.Glyph);
  Image1.Width := ClientWidth - 1;
  DoubleBuffered := true;
  Diferenca := ClientHeight - Image1.Height;
  Ratio := 0.5;

  TempStr := ExtractFilePath(ParamStr(0)) + 'Settings\';
  ForceDirectories(TempStr);
  TempStr := TempStr + NomePC + '.ini';

  if FileExists(TempStr) = True then
  try
    IniFile := TIniFile.Create(TempStr, IniFilePassword);

    ClientHeight := IniFile.ReadInteger('Desktop', 'Height', ClientHeight);
    ClientWidth := IniFile.ReadInteger('Desktop', 'Width', ClientWidth);
    Left := IniFile.ReadInteger('Desktop', 'Left', Left);
    Top := IniFile.ReadInteger('Desktop', 'Top', Top);
    AdvTrackBar1.Position := IniFile.ReadInteger('Desktop', 'Quality', AdvTrackBar1.Position);
    UpDown1.Position := IniFile.ReadInteger('Desktop', 'Interval', UpDown1.Position);
    Ratio := IniFile.ReadFloat('Desktop', 'Ratio', 0.5); // somente exemplo... quem enviará o "Ratio" será o server
    if Ratio <= 0 then Ratio := 0.5;

    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;
end;

constructor TFormDesktop.Create(aOwner: TComponent; ConAux: TConexaoNew);
begin
  inherited Create(aOwner);
  Servidor := ConAux;
  NomePC := Servidor.NomeDoServidor;
end;

procedure TFormDesktop.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  k: TKeys;
  TempStr: string;
begin
  if not SRCheckBox3.Checked then exit;
  setlength(tempstr, sizeof(tkeys));
  k.key := key;
  k.shift := Shift;
  key := 0;  // assim eu posso até digitar alt + F4 que não fecha minha janela, mas sim envia o comando para o server
  move(k, Tempstr[1], sizeof(Tkeys));
  Texto := Texto + Tempstr;
  edit2.Clear;
end;

procedure TFormDesktop.AdvTrackBar1Change(Sender: TObject);
begin
  bsSkinStdLabel1.Caption := traduzidos[475] + ':' + IntToStr(AdvTrackBar1.Position) + '%';
end;

procedure TFormDesktop.AtualizarIdioma;
begin
  bsSkinStdLabel1.Caption := traduzidos[475] + ':' + IntToStr(AdvTrackBar1.Position) + '%';
  SpeedButton1.Caption := traduzidos[256];
  SpeedButton2.Caption := traduzidos[257];
  Label1.Caption := traduzidos[469] + ':';
  SRCheckBox1.Caption := traduzidos[470];
  SRCheckBox2.Caption := traduzidos[471];
  SRCheckBox3.Caption := traduzidos[472];
end;

function ShowTime(DayChar: Char = '/'; DivChar: Char = ' '; HourChar: Char = ':'): String;
var
  SysTime: TSystemTime;
  Month, Day, Hour, Minute, Second: String;
begin
  GetSystemTime(Systime);
  month := inttostr(systime.wMonth);
  day := inttostr(systime.wDay);
  hour := inttostr(Systime.wHour +1);
  minute := inttostr(Systime.wMinute);
  Second := inttostr(systime.wSecond);
  if length(month) = 1 then month := '0' + month;
  if length(day) = 1 then day := '0' + day;
  if length(hour) = 1 then hour := '0' + hour;
  if hour = '24' then hour := '00';
  if length(minute) = 1 then minute := '0' + minute;
  if length(second) = 1 then second := '0' + second;
  Result :=  day + DayChar + month + DayChar + IntTostr(Systime.wYear) + DivChar + hour + HourChar + minute + HourChar + second;
end;

procedure TFormDesktop.OnRead(Recebido: String; ConAux: TConexaoNew);
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
  if Copy(Recebido, 1, posex('|', Recebido) - 1) = STARTDESKTOP then
  begin
    ServidorTransferencia := ConAux;
    if ServidorTransferencia.MasterIdentification <> 1234567890 then Exit;

    delete(Recebido, 1, posex('|', recebido));
    OriginalX := StrToInt(Copy(Recebido, 1, posex('|', recebido) - 1));
    delete(Recebido, 1, posex('|', recebido));
    OriginalY := StrToInt(Copy(Recebido, 1, posex('|', recebido) - 1));
    Ratio := OriginalY / OriginalX;
    ClientHeight := Round(Image1.Width * Ratio) + Diferenca;
    ClientWidth := Round(Image1.Height / Ratio);

    Self.Refresh;
    Application.ProcessMessages;

    SpeedButton2.Visible := true;
    SpeedButton1.Visible := false;

    ServidorTransferencia.enviarString(
                 STARTDESKTOP + '|' +
                 Inttostr(LastQuality) + '|' +
                 Inttostr(Image1.Width) + '|' +
                 Inttostr(Image1.Height) + '|' +
                 Inttostr(LastInterval) + '|');
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = DESKTOPSTREAM then
  begin
    ServidorTransferencia := ConAux;
    if ServidorTransferencia.MasterIdentification <> 1234567890 then Exit;

    SpeedButton1.Visible := false;
    SpeedButton2.Visible := true;

    delete(Recebido, 1, posex('|', recebido));
    if Recebido = '' then exit;
    Caption := OriginalCaption + ' --- (' + FileSizeToStr(length(Recebido)) + ')';
    inc(imagematual);
    StatusBar1.Panels.Items[0].Text := traduzidos[473] + ': ' + IntToStr(ImagemAtual) + ' --- (' + FileSizeToStr(length(Recebido)) + ')';
    Stream := TMemoryStream.Create;
    Stream.Write(Recebido[1], Length(Recebido) * 2);
    Stream.Position := 0;
    j := TJpegImage.Create;
    j.LoadFromStream(Stream);
    Stream.Free;

    if SRCheckbox1.Checked = true then
    begin
      TempDir := ExtractFilePath(paramstr(0)) + 'Downloads\' + NomePC + '\DesktopImages';
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

    if (AdvTrackBar1.Position <> LastQuality) or (UpDown1.Position <> LastInterval) then
    begin
      LastQuality := AdvTrackBar1.Position;
      LastInterval := UpDown1.Position;
      Servidor.EnviarString(DESKTOPCONFIG + '|' +
                                     Inttostr(LastQuality) + '|' +
                                     Inttostr(Image1.Width) + '|' +
                                     Inttostr(Image1.Height) + '|' +
                                     Inttostr(LastInterval) + '|');
    end;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = DESKTOPPREVIEW then
  begin
    delete(Recebido, 1, posex('|', recebido));
    if Recebido = '' then exit;
    Caption := OriginalCaption + ' --- (' + FileSizeToStr(length(Recebido)) + ')';
    Stream := TMemoryStream.Create;
    Stream.Write(Recebido[1], Length(Recebido) * 2);
    Stream.Position := 0;
    j := TJpegImage.Create;
    j.LoadFromStream(Stream);
    Stream.Free;

    if SRCheckbox1.Checked = true then
    begin
      TempDir := ExtractFilePath(paramstr(0)) + 'Downloads\' + NomePC + '\DesktopImages';
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


end;

procedure TFormDesktop.FormClose(Sender: TObject; var Action: TCloseAction);
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
    IniFile.WriteInteger('Desktop', 'Width', ClientWidth);
    IniFile.WriteInteger('Desktop', 'Height', ClientHeight);
    IniFile.WriteInteger('Desktop', 'Left', Left);
    IniFile.WriteInteger('Desktop', 'Top', Top);
    IniFile.WriteInteger('Desktop', 'Quality', AdvTrackBar1.Position);
    IniFile.WriteInteger('Desktop', 'Interval', UpDown1.Position);
    IniFile.WriteFloat('Desktop', 'Ratio', Ratio);
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

procedure TFormDesktop.FormShow(Sender: TObject);
begin
  imagematual := 0;
  StatusBar1.Panels.Items[0].Text := '';
  AtualizarIdioma;
  ServidorTransferencia := nil;
  SrCheckbox3.Checked := false;
  SrCheckbox2.Checked := false;
  SrCheckbox1.Checked := false;
  Timer1.Enabled := false;
  ClientHeight := Round(Image1.Width * Ratio) + Diferenca;
  ClientWidth := Round(Image1.Height / Ratio);
  OriginalCaption := Caption;
  SpeedButton1.Visible := true;
  SpeedButton2.Visible := false;

  if FormMain.AutoDesktop then SpeedButton1Click(SpeedButton1);

  edit1.Text := IntToStr(UpDown1.Position);
  bsSkinStdLabel1.Caption := traduzidos[475] + ':' + IntToStr(AdvTrackBar1.Position) + '%';
end;

procedure TFormDesktop.Image1Click(Sender: TObject);
begin
  edit2.SetFocus;
end;

procedure TFormDesktop.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not SRCheckBox2.Checked then Exit;
  MouseCommand := '';
  Mouse(1, Button, X, Y);
end;

var
  LastMoveMouse: integer = 0;

procedure TFormDesktop.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Point: TPoint;
  TempStr: string;
begin
//A captura fica muito lenta ao movimentar o mouse
  Exit;



  if GetTickCount < LastMoveMouse + 10 then Exit;
  LastMoveMouse := GetTickCount;

  if (SRCheckBox2.Checked) and (Image1.Picture <> nil) then
  begin
    Point.X := (X * OriginalX) div Image1.Picture.Bitmap.Width;
    Point.Y := (Y * OriginalY) div Image1.Picture.Bitmap.Height;
    TempStr := DESKTOPMOVEMOUSE + '|' +
               inttostr(Point.X) + '|' +
               inttostr(Point.Y) + '|';
    Servidor.EnviarString(TempStr);
  end;
end;

procedure TFormDesktop.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not SRCheckBox2.Checked then Exit;
  Mouse(2, Button, X, Y);
end;

procedure TFormDesktop.SpeedButton1Click(Sender: TObject);
begin
  imagematual := 0;
  LastQuality := AdvTrackBar1.Position;
  LastInterval := UpDown1.Position;

  SpeedButton2.Visible := true;
  SpeedButton1.Visible := false;

  Servidor.EnviarString(DESKTOP + '|');
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormDesktop.SpeedButton2Click(Sender: TObject);
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

procedure TFormDesktop.Timer1Timer(Sender: TObject);
begin
  if Texto = '' then exit;
  Servidor.EnviarString(TECLADOEXECUTAR + '|' + Texto);
  Texto := '';
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

  Point.X := (X * OriginalX) div Image1.Picture.Bitmap.Width;
  Point.Y := (Y * OriginalY) div Image1.Picture.Bitmap.Height;

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
    MouseCommand := MOUSECLICK + '|' +
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
    Servidor.EnviarString(ToSend);

    MouseCommand := '';
  end;
  LastTick := GetTickCount;
end;

procedure TFormDesktop.SpeedButton3Click(Sender: TObject);
begin
  LastQuality := AdvTrackBar1.Position;
  LastInterval := UpDown1.Position;

  Servidor.EnviarString(DESKTOPPREVIEW + '|' +
                                 Inttostr(LastQuality) + '|' +
                                 Inttostr(Image1.Width) + '|' +
                                 Inttostr(Image1.Height) + '|' +
                                 Inttostr(LastInterval) + '|');
end;

procedure TFormDesktop.SRCheckBox3Click(Sender: TObject);
begin
  Texto := '';
  Timer1.Enabled := SRCheckBox3.Checked;
end;

end.
