unit UnitShell;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UnitMain, UnitConexao, sSkinProvider;

type
  TFormShell = class(TForm)
    Memo1: TMemo;
    sSkinProvider1: TsSkinProvider;
    procedure FormShow(Sender: TObject);
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    Servidor: TConexaoNew;
    ServidorAux: TConexaoNew;
    lastcommand: string;
    LastLine: string;
    NomePC: string;
    LiberarForm: boolean;
  	procedure WMCloseFree(var Message: TMessage); message WM_CLOSEFREE;
    procedure CreateParams(var Params : TCreateParams); override;
  public
    { Public declarations }
    procedure OnRead(Recebido: String; ConAux: TConexaoNew); overload;
    constructor Create(aOwner: TComponent; ConAux: TConexaoNew); overload;
  end;

var
  FormShell: TFormShell;

implementation

{$R *.dfm}

uses
  UnitStrings,
  UnitConstantes,
  CustomIniFiles,
  UnitCommonProcedures;

procedure TFormShell.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

//Here's the implementation of CreateParams
procedure TFormShell.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  if FormMain.ControlCenter = True then Exit;
  Params.WndParent := GetDesktopWindow;
end;

procedure TFormShell.FormShow(Sender: TObject);
begin
  Memo1.Clear;
  Memo1.Color := clWhite;
  Memo1.Font.Color := clBlack;
  Memo1.ReadOnly := true;
  lastcommand := '';
  ServidorAux := nil;
end;

constructor TFormShell.Create(aOwner: TComponent; ConAux: TConexaoNew);
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
    ClientWidth := IniFile.ReadInteger('Prompt', 'Width', Width);
    ClientHeight := IniFile.ReadInteger('Prompt', 'Height', Height);
    Left := IniFile.ReadInteger('Prompt', 'Left', Left);
    Top := IniFile.ReadInteger('Prompt', 'Top', Top);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

end;

procedure TFormShell.OnRead(Recebido: String; ConAux: TConexaoNew);
var
  TempInt: Integer;
  TempStr: string;
  i: integer;
  Result: TSplit;
begin
  if Copy(Recebido, 1, posex('|', Recebido) - 1) = SHELLCOMMAND then
  begin
    delete(recebido, 1, posex('|', recebido));
    if Length(Memo1.Text) > 0 then
    begin
      delete(recebido, 1, length(LastCommand) + 1);
      recebido := #13#10 + recebido;
    end else
    begin
      delete(recebido, 1, length(LastCommand));
    end;
	  LastCommand := '';

    Memo1.Text := Memo1.Text + recebido;
    Memo1.SetFocus;
    Memo1.SelStart := Length(Memo1.Text);
    SendMessage(Memo1.handle, EM_SCROLLCARET, 0, 0);

    TempStr := Memo1.Lines.Strings[Memo1.Lines.Count - 1];
    if TempStr[length(tempstr)] = '>' then LastLine := Memo1.Lines.Strings[Memo1.Lines.Count - 1] else
    if length(Memo1.Lines.Strings[Memo1.Lines.Count - 1]) <= 2 then
    begin
      Memo1.Lines.Add('');
      Memo1.Lines.Add('');
      Memo1.Text := Memo1.Text + LastLine;
      Memo1.SetFocus;
      Memo1.SelStart := Length(Memo1.Text);
      SendMessage(Memo1.handle, EM_SCROLLCARET, 0, 0);
    end;
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = SHELLSTART then
  begin
    ServidorAux := ConAux;
    Memo1.Color := clBlack;
    Memo1.Font.Color := clLime;
    Memo1.ReadOnly := false;
    ServidorAux.enviarString(SHELLSTART + '|')
  end else

  if Copy(Recebido, 1, posex('|', Recebido) - 1) = SHELLDESATIVAR then
  begin
    Memo1.Clear;
    Memo1.Color := clWhite;
    Memo1.Font.Color := clBlack;
    Memo1.ReadOnly := true;
    lastcommand := '';
  end else

end;

procedure TFormShell.Memo1KeyPress(Sender: TObject; var Key: Char);
var
  TempStr: string;
begin
  Memo1.SelStart := Length(Memo1.Text);
  SendMessage(Memo1.handle, EM_SCROLLCARET, 0, 0);

  if Length(Memo1.Text) = 0 then
  begin
    Key := #0;
    Exit;
  end;

  if Key = #8 then
  begin
    if Memo1.SelStart <= LastDelimiter('>', Memo1.Text) then
    begin
      Key:= #0;
      exit;
    end;
  end;

  if Memo1.SelStart <> Length(Memo1.Text) then
  begin
    Memo1.SelStart := Length(Memo1.Text);
    Exit;
  end;

  if Key = #13 then
  begin
    Key := #0;
    TempStr := memo1.Text;
    delete(TempStr, 1, LastDelimiter('>', TempStr));
    LastCommand := TempStr;
    if UpperCase(TempStr) = 'CLS' then
    begin
      memo1.Clear;
      Memo1.Text := LastLine;
    end else
    begin
      ServidorAux.enviarString(SHELLCOMMAND + '|' + TempStr);
    end;
  end

end;

procedure TFormShell.FormClose(Sender: TObject; var Action: TCloseAction);
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
    IniFile.WriteInteger('Prompt', 'Width', ClientWidth);
    IniFile.WriteInteger('Prompt', 'Height', ClientHeight);
    IniFile.WriteInteger('Prompt', 'Left', Left);
    IniFile.WriteInteger('Prompt', 'Top', Top);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

  Memo1.Clear;
  Memo1.Color := clWhite;
  Memo1.Font.Color := clBlack;
  Memo1.ReadOnly := true;
  lastcommand := '';

  if Servidor = nil then Exit;
  if Servidor.MasterIdentification <> 1234567890 then Exit;

  if ServidorAux = nil then Exit;
  if ServidorAux.MasterIdentification = 1234567890 then
  ServidorAux.enviarString(SHELLCOMMAND + '|' + 'exit' + #13#10);
end;

end.
