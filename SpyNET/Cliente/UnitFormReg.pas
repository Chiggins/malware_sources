unit UnitFormReg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, IdTCPServer, UnitPrincipal;

type
  TFormReg = class(TForm)
    LabelNombre: TLabel;
    EditNombreValor: TEdit;
    LabelInformacion: TLabel;
    MemoInformacionValor: TMemo;
    BtnAceptar: TSpeedButton;
    BtnCancelar: TSpeedButton;
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnAceptarClick(Sender: TObject);
    procedure MemoInformacionValorKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    Servidor: PConexao;
    Ruta, Tipo: String;
    procedure CerrarVentana();
    { Private declarations }
  public
    constructor Create(aOwner: TComponent; ConAux: PConexao; RegistroRuta, RegistroTipo: String);
    { Public declarations }
  end;

var
  FormReg: TFormReg;

implementation

uses
  UnitComandos,
  UnitStrings,
  UnitConexao;

{$R *.dfm}

constructor TFormReg.Create(aOwner: TComponent; ConAux: PConexao; RegistroRuta, RegistroTipo: String);
begin
  inherited Create(aOwner);
  Servidor := ConAux;
  Ruta := RegistroRuta;
  Tipo := RegistroTipo;
  Caption := pchar(traduzidos[257]) + ' ' + Tipo;
end;

procedure TFormReg.CerrarVentana();
begin
  //Deja todo como estaba
  EditNombreValor.Text := '';
  EditNombreValor.Enabled := True;
  MemoInformacionValor.Text := '';
  MemoInformacionValor.Enabled := True;
  Close;
end;

procedure TFormReg.BtnCancelarClick(Sender: TObject);
begin
  CerrarVentana();
end;

procedure TFormReg.BtnAceptarClick(Sender: TObject);
begin
    EnviarString(Servidor.Athread, ADICIONARVALOR + '|' + Ruta +
       EditNombreValor.Text + '|' + Tipo + '|' + MemoInformacionValor.Text + '|');
  CerrarVentana();
end;

procedure TFormReg.MemoInformacionValorKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Tipo = REG_SZ_) or (Tipo = REG_EXPAND_SZ_) then
    if (key = #10) or (key = #13) then
    begin
      MessageDlg(pchar(traduzidos[258]), mtwarning, [mbok], 0);
      Key := #0;
      MessageBeep($FFFFFFFF);
    end;
  if Tipo = REG_BINARY_ then  //Si es un valor binario solo deja introducir valores hexadeciamles y espacios
    if not (key in ['0'..'9', 'A'..'F', 'a'..'f', ' ', #8]) then  //#8 es el backspace, borrar
    begin
      key := #0;
      MessageBeep($FFFFFFFF);
    end;
  if Tipo = REG_DWORD_ then  //Si es un valor binario solo deja introducir números
    if not (key in ['0'..'9', #8]) then
    begin
      key := #0;
      MessageBeep($FFFFFFFF);
    end;
end;

procedure TFormReg.FormCreate(Sender: TObject);
begin
  FormPrincipal.ImageListIcons.GetBitmap(249, btnAceptar.Glyph);
  FormPrincipal.ImageListIcons.GetBitmap(279, btnCancelar.Glyph);
end;

procedure TFormReg.FormShow(Sender: TObject);
begin
  btnaceptar.Caption := traduzidos[58];
  btncancelar.Caption := traduzidos[59];
  labelnombre.Caption := traduzidos[231];
  labelinformacion.Caption := traduzidos[232];
end;

end.
