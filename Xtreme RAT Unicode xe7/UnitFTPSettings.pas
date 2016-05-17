unit UnitFTPSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, sLabel;

type
  TFormFTPSettings = class(TForm)
    Button2: TButton;
    Label2: TsLabel;
    Button1: TButton;
    Edit4: TEdit;
    Edit3: TEdit;
    Edit2: TEdit;
    Edit1: TEdit;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormFTPSettings: TFormFTPSettings;

implementation

{$R *.dfm}

uses
  UnitCommonProcedures,
  UnitMain;

procedure TFormFTPSettings.Button1Click(Sender: TObject);
begin
  modalresult := mrOK;
end;

procedure TFormFTPSettings.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFormFTPSettings.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then Edit2.SetFocus;
end;

procedure TFormFTPSettings.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then Edit3.SetFocus;
end;

procedure TFormFTPSettings.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then Edit4.SetFocus;
end;

procedure TFormFTPSettings.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then button1Click(button1);
end;

procedure TFormFTPSettings.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  Label2.Transparent := False;
end;

procedure TFormFTPSettings.FormShow(Sender: TObject);
begin
  Label2.Transparent := False;
  Label2.Color := $000D8A77;
  edit1.SetFocus;
end;

end.
