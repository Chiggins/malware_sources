unit UnitChat;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UnitMain, ExtCtrls, Mask, sLabel, UnitConexao, sSkinProvider;

type
  TFormChat = class(TForm)
    bsSkinPanel1: TPanel;
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TsLabel;
    Label3: TLabel;
    SaveDialog1: TSaveDialog;
    sSkinProvider1: TsSkinProvider;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    ChatServerName, ChatClientName, ChatWinTitle: WideString;
    Servidor: TConexaoNew;
    NomePC: string;
    MostrarMsgOnClose: boolean;
    LiberarForm: boolean;
  	procedure WMCloseFree(var Message: TMessage); message WM_CLOSEFREE;
    procedure AtualizarIdioma;
	  procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
    procedure CreateParams(var Params : TCreateParams); override;
  public
    { Public declarations }
    property MyChatServerName: WideString read ChatServerName write ChatServerName;
    property MyChatClientName: WideString read ChatClientName write ChatClientName;
    property MyChatWinTitle: WideString read ChatWinTitle write ChatWinTitle;
    procedure OnRead(Recebido: String; ConAux: TConexaoNew); overload;
    constructor Create(aOwner: TComponent; ConAux: TConexaoNew; ServerName, ClientName, WinTitle: WideString); overload;
  end;

var
  FormChat: TFormChat;

implementation

{$R *.dfm}

uses
  CustomIniFiles,
  UnitStrings,
  UnitCommonProcedures,
  UnitConstantes;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormChat.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdioma;
end; 

procedure TFormChat.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

//Here's the implementation of CreateParams
procedure TFormChat.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  if FormMain.ControlCenter = True then Exit;
  Params.WndParent := GetDesktopWindow;
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

procedure TFormChat.Button1Click(Sender: TObject);
var
  TempStr: widestring;
begin
  TempStr := Edit1.Text;
  Servidor.EnviarString(CHATTEXT + '|' + TempStr);
  Edit1.Clear;
  Memo1.Text := Memo1.Text + ShowTime + ' --- ' + ChatClientName + #13#10 + TempStr + #13#10#13#10;
  Edit1.SetFocus;
end;

procedure TFormChat.Button2Click(Sender: TObject);
begin
  Close;
end;

Procedure CriarArquivo(NomedoArquivo: pWideChar; Buffer: pWideChar; Size: int64);
var
  hFile: THandle;
  lpNumberOfBytesWritten: DWORD;
  unicode: array [0..1] of byte;
begin
  hFile := CreateFileW(NomedoArquivo, GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);

  if hFile <> INVALID_HANDLE_VALUE then
  begin
    if Size = INVALID_HANDLE_VALUE then
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    unicode[0] := $FF;
    unicode[1] := $FE;
    WriteFile(hFile, unicode, sizeof(unicode), lpNumberOfBytesWritten, nil);
    WriteFile(hFile, Buffer[0], Size, lpNumberOfBytesWritten, nil);
  end;

  CloseHandle(hFile);
end;

procedure TFormChat.Button3Click(Sender: TObject);
var
  TempStr: WideString;
begin
  TempStr := Memo1.Text;
  savedialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;;
  savedialog1.Filter := 'Text files (*.txt)|*.txt';
  savedialog1.InitialDir := ExtractFilePath(Paramstr(0));
  if savedialog1.Execute then
  begin
    CriarArquivo(pWideChar(savedialog1.Filename), pWideChar(TempStr), Length(TempStr) * 2);
  end;
end;

constructor TFormChat.Create(aOwner: TComponent; ConAux: TConexaoNew; ServerName, ClientName, WinTitle: WideString);
var
  TempStr: WideString;
  IniFile: TIniFile;
  i: integer;
begin
  inherited Create(aOwner);

  ChatServerName := ServerName;
  ChatClientName := ClientName;
  ChatWinTitle := WinTitle;

  For i:= 0 to ComponentCount - 1 do
  begin
    if (Components[i] is TLabel) then
    TLabel(Components[i]).Transparent := True;
  end;
  Label2.Transparent := False;

  Servidor := ConAux;
  NomePC := Servidor.NomeDoServidor;

  TempStr := ExtractFilePath(ParamStr(0)) + 'Settings\';
  ForceDirectories(TempStr);
  TempStr := TempStr + NomePC + '.ini';

  try
    IniFile := TIniFile.Create(TempStr, IniFilePassword);
    Width := IniFile.ReadInteger('CHAT', 'Width', Width);
    Height := IniFile.ReadInteger('CHAT', 'Height', Height);
    Left := IniFile.ReadInteger('CHAT', 'Left', Left);
    Top := IniFile.ReadInteger('CHAT', 'Top', Top);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

end;

procedure TFormChat.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then Button1Click(Button1);
end;

procedure TFormChat.FormClose(Sender: TObject; var Action: TCloseAction);
var
  TempStr: WideString;
  IniFile: TIniFile;
begin
  if LiberarForm then Action := caFree;

  Memo1.Clear;

  MostrarMsgOnClose := False;
  TempStr := ExtractFilePath(ParamStr(0)) + 'Settings\';
  ForceDirectories(TempStr);
  TempStr := TempStr + NomePC + '.ini';

  try
    IniFile := TIniFile.Create(TempStr, IniFilePassword);
    IniFile.WriteInteger('CHAT', 'Width', Width);
    IniFile.WriteInteger('CHAT', 'Height', Height);
    IniFile.WriteInteger('CHAT', 'Left', Left);
    IniFile.WriteInteger('CHAT', 'Top', Top);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

  if Servidor <> nil then
  if Servidor.MasterIdentification = 1234567890 then Servidor.EnviarString(CHATSTOP + '|');
end;

procedure TFormChat.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
end;

procedure TFormChat.FormShow(Sender: TObject);
begin
  MostrarMsgOnClose := True;
  AtualizarIdioma;
  Memo1.Clear;
  Edit1.Clear;
  Edit1.SetFocus;
  Servidor.EnviarString(CHAT + '|' + ChatServerName + DelimitadorComandos +
                                               ChatClientName + DelimitadorComandos +
                                               ChatWinTitle);
end;

procedure TFormChat.OnRead(Recebido: String; ConAux: TConexaoNew);
var
  TempStr: string;
begin
  if Copy(Recebido, 1, posex('|', Recebido) - 1) = CHATTEXT then
  begin
    delete(recebido, 1, posex('|', recebido));
    Memo1.Text := Memo1.Text + ShowTime + ' --- ' + ChatServerName + #13#10 + Recebido + #13#10#13#10;
    Memo1.SelStart := Length(Memo1.Text);
    SendMessage(Memo1.handle, EM_SCROLLCARET, 0, 0);
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = CHATSTART then
  begin
    Memo1.Clear;
    Edit1.Clear;
    Edit1.SetFocus;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = CHATSTOP then
  begin
    if MostrarMsgOnClose then
    begin
      MessageBox(Handle, pchar(Traduzidos[496]), pChar(NomeDoPrograma + ' ' + VersaoDoPrograma), MB_ICONWARNING);
      Close;
    end;
  end;
end;

procedure TFormChat.AtualizarIdioma;
begin
  Button1.Caption := Traduzidos[442];
  Button3.Caption := Traduzidos[387];
  Button2.Caption := Traduzidos[461];

  Label3.Caption := Traduzidos[491];
  Label1.Caption := Traduzidos[492];
end;

end.


