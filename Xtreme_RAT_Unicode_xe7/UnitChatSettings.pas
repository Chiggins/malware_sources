unit UnitChatSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, UnitMain, Mask, sLabel;

type
  TFormChatSettings = class(TForm)
    Label2: TsLabel;
    Button2: TButton;
    Edit3: TEdit;
    Label4: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Edit1: TEdit;
    Label1: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormChatSettings: TFormChatSettings;

implementation

{$R *.dfm}

uses
  UnitCommonProcedures;

procedure TFormChatSettings.Button1Click(Sender: TObject);
begin
  if (Edit1.Text <> '') and (Edit2.Text <> '') then
  modalresult := mrOK else modalresult := mrCancel;
end;

procedure TFormChatSettings.Button2Click(Sender: TObject);
begin
  close;
end;

procedure TFormChatSettings.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then Edit2.SetFocus;
end;

procedure TFormChatSettings.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then Edit3.SetFocus;
end;

procedure TFormChatSettings.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then button1Click(button1);
end;

procedure TFormChatSettings.FormCreate(Sender: TObject);
var
  i: integer;
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  Label2.Transparent := False;
end;

procedure TFormChatSettings.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then Edit2.SetFocus;
end;

procedure TFormChatSettings.FormShow(Sender: TObject);
begin
  edit1.SetFocus;
end;

end.
