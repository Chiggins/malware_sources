unit UnitSendKeys;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormSendKeys = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSendKeys: TFormSendKeys;

implementation

{$R *.dfm}

uses
  UnitStrings,
  UnitConstantes;

procedure TFormSendKeys.Button1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFormSendKeys.Button2Click(Sender: TObject);
begin
  MessageBox(Handle, pChar(Traduzidos[608] + ': ' + #13#10#13#10 +
             'BACKSPACE: {BACKSPACE}, {BS}, or {BKSP}' + #13#10 +
             'BREAK: {BREAK}' + #13#10 +
             'CAPS LOCK: {CAPSLOCK}' + #13#10 +
             'DEL or DELETE: {DELETE} or {DEL}' + #13#10 +
             'DOWN ARROW: {DOWN}' + #13#10 +
             'END: {END}' + #13#10 +
             'ENTER: {ENTER} or $' + #13#10 +
             'ESC: {ESC}' + #13#10 +
             'HELP: {HELP}' + #13#10 +
             'HOME: {HOME}' + #13#10 +
             'INS or INSERT: {INSERT} or {INS}' + #13#10 +
             'LEFT ARROW: {LEFT}' + #13#10 +
             'NUM LOCK: {NUMLOCK}' + #13#10 +
             'PAGE DOWN: {PGDN}' + #13#10 +
             'PAGE UP: {PGUP}' + #13#10 +
             'PRINT SCREEN: {PRTSC}' + #13#10 +
             'RIGHT ARROW: {RIGHT}' + #13#10 +
             'SCROLL LOCK: {SCROLLLOCK}' + #13#10 +
             'TAB: {TAB}' + #13#10 +
             'UP ARROW: {UP}' + #13#10 +
             'vF1: {F1}' + #13#10 +
             'vF2: {F2}' + #13#10 +
             'F3: {F3}' + #13#10 +
             'F4: {F4}' + #13#10 +
             'F5: {F5}' + #13#10 +
             'F6: {F6}' + #13#10 +
             'F7: {F7}' + #13#10 +
             'F8: {F8}' + #13#10 +
             'F9: {F9}' + #13#10 +
             'F10: {F10}' + #13#10 +
             'F11: {F11}' + #13#10 +
             'F12: {F12}' + #13#10 +
             'F13: {F13}' + #13#10 +
             'F14: {F14}' + #13#10 +
             'F15: {F15}' + #13#10 +
             'F16: {F16}' + #13#10 +
             'SHIFT: +' + #13#10 +
             'CTRL: !' + #13#10 +
             'ALT: %'), pChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
             MB_OK or MB_ICONINFORMATION);
end;

procedure TFormSendKeys.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then Button1.Click;
end;

procedure TFormSendKeys.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
end;

procedure TFormSendKeys.FormShow(Sender: TObject);
begin
  Edit1.Clear;
  Caption := Traduzidos[607];
  Label1.Caption := Traduzidos[607] + ':';
  Button1.Caption := Traduzidos[442];
end;

end.
