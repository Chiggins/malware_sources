unit UnitFTPsettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFormFTPsettings = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    PodeEnviar: boolean;
    { Public declarations }
  end;

var
  FormFTPsettings: TFormFTPsettings;

implementation

{$R *.dfm}

uses
  UnitStrings;

procedure TFormFTPsettings.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  If not(key in['0'..'9', #08, #13]) then
  begin
    beep;
    key := #0;
  end;
  if key = #13 then button1.Click;
end;

procedure TFormFTPsettings.Edit1Enter(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  if (Ctrl is TEdit) then
  TEdit(Ctrl).Color := clSkyBlue;
end;

procedure TFormFTPsettings.Edit1Exit(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  if (Ctrl is TEdit) then
  TEdit(Ctrl).Color := clWindow;
end;

procedure TFormFTPsettings.FormShow(Sender: TObject);
begin
  caption := traduzidos[495];
  PodeEnviar := false;
  close;
end;

procedure TFormFTPsettings.Button1Click(Sender: TObject);
begin
  PodeEnviar := true;
  close;
end;

procedure TFormFTPsettings.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then button1.Click;
end;

procedure TFormFTPsettings.Button2Click(Sender: TObject);
begin
  close;
end;

end.
