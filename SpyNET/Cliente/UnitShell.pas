unit UnitShell;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitPrincipal, Menus, StdCtrls, ExtCtrls;

type
  TFormShell = class(TForm)
    Memo1: TMemo;
    PopupMenu1: TPopupMenu;
    Ativar1: TMenuItem;
    Desativar1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    Salvar1: TMenuItem;
    N2: TMenuItem;
    SaveDialog1: TSaveDialog;
    Timer1: TTimer;
    procedure Sair1Click(Sender: TObject);
    procedure Salvar1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Ativar1Click(Sender: TObject);
    procedure Desativar1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Memo1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
  private
    Servidor: PConexao;
  public
    { Public declarations }
    procedure OnRead(Recebido: String; ConAux: PConexao); overload;
    constructor Create(aOwner: TComponent; ConAux: PConexao);overload;
  end;

var
  FormShell: TFormShell;
  Posicao: integer;
implementation

{$R *.dfm}

uses
  UnitStrings,
  UnitConexao,
  UnitComandos;

constructor TFormShell.Create(aOwner: TComponent; ConAux: PConexao);
begin
  inherited Create(aOwner);
  Servidor := ConAux;
end;

procedure TFormShell.OnRead(Recebido: String; ConAux: PConexao);
var
  TempStr: string;
begin
  if copy(recebido, 1, pos('|', recebido) - 1) = SHELLATIVAR then
  begin
    delete(recebido, 1, pos('|', recebido));
    Desativar1.Enabled := true;
    Ativar1.Enabled := false;
    Timer1.Enabled := true;
    Memo1.Font.Color := clLime;
    Memo1.Color := clBlack;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = SHELLDESATIVAR then
  begin
    delete(recebido, 1, pos('|', recebido));
    Desativar1.Enabled := false;
    Ativar1.Enabled := true;
    Timer1.Enabled := false;
    Memo1.Font.Color := clBlack;
    Memo1.Color := clWindow;
  end else

  if copy(recebido, 1, pos('|', recebido) - 1) = SHELLRESPOSTA then
  begin
    delete(recebido, 1, pos('|', recebido));
    Memo1.Lines.BeginUpdate;
    Memo1.Text := Memo1.Text + recebido;
    Posicao := length(Memo1.Text);
    Memo1.Lines.EndUpdate;

    //Aqui faz um Scroll no memo até o final do próprio
    Memo1.Perform(WM_VSCROLL, SB_BOTTOM, SB_THUMBTRACK);
    Memo1.SelStart := Length(Memo1.Text);
  end else


  
end;

procedure TFormShell.Sair1Click(Sender: TObject);
begin
  close;
end;

procedure TFormShell.Salvar1Click(Sender: TObject);
var
  TextFile: string;
begin
  savedialog1.Filter := 'Text Files (*.txt)' + '|*.txt';
  savedialog1.InitialDir := ExtractFilePath(paramstr(0));
  savedialog1.Title := Application.Title + ' ' + VersaoPrograma;

  if savedialog1.Execute = false then exit;
  TextFile := savedialog1.FileName;
  if extractfileext(TextFile) <> '.txt' then TextFile := TextFile + '.txt';

  memo1.Lines.SaveToFile(TextFile);
end;

procedure TFormShell.FormShow(Sender: TObject);
begin
  memo1.Font.Color := clBlack;
  memo1.Color := clWindow;
  Desativar1.Enabled := false;
  Ativar1.Enabled := true;
  Ativar1.Caption := traduzidos[252];
  Desativar1.Caption := traduzidos[253];
  Salvar1.Caption := traduzidos[254];
  Sair1.Caption := traduzidos[22];
  Memo1.Clear;
  Posicao := 0;
end;

procedure TFormShell.Ativar1Click(Sender: TObject);
begin
  memo1.Clear;
  Posicao := 0;
  Ativar1.Enabled := false;
  EnviarString(Servidor.Athread, SHELLATIVAR + '|');
end;

procedure TFormShell.Desativar1Click(Sender: TObject);
begin
  Timer1.Enabled := false;
  Memo1.Clear;
  Posicao := 0;
  Desativar1.Enabled := false;
  EnviarString(Servidor.Athread, SHELLDESATIVAR + '|');
end;

procedure TFormShell.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Desativar1.Enabled = true then Desativar1.Click;
end;

procedure TFormShell.Memo1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if memo1.selstart < posicao then memo1.SelStart := posicao;
end;

procedure TFormShell.Memo1KeyPress(Sender: TObject; var Key: Char);
var
  TempStr, TempStr1: string;
begin
  if ((key = #8) or (key = #46)) and
     (memo1.selstart <= posicao) then key := #0 else
  if key = #13 then
  begin
    key := #0;
    if length(memo1.Text) > posicao then
    begin
      if Memo1.Color = clWindow then
      begin
        messagedlg(pchar(traduzidos[256]), mtWarning, [mbOk], 0);
        exit;
      end;
      TempStr := copy(memo1.Text, (posicao + 1), length(memo1.Text) - posicao);
      TempStr1 := copy(memo1.Text, 1, posicao);
      memo1.Lines.BeginUpdate;
      Memo1.Text := TempStr1;
      if uppercase(TempStr) = 'CLS' then memo1.Clear;
      memo1.Lines.EndUpdate;

      EnviarString(Servidor.Athread, SHELLRESPOSTA + '|' + TempStr + '|');
    end;
  end;
end;

procedure TFormShell.Timer1Timer(Sender: TObject);
begin
  if memo1.selstart < posicao then memo1.SelStart := posicao;
end;

end.
