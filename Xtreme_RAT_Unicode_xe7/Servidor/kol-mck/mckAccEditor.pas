unit mckAccEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TKOLAccEdit = class(TForm)
  public
    btOK: TButton;
    edAcc: TEdit;
    btCancel: TButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btOKClick(Sender: TObject);
    procedure btCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create( AOwner: TComponent ); override;
  end;

var
  KOLAccEdit: TKOLAccEdit;

implementation

procedure TKOLAccEdit.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var S, K: String;
begin
  if (Key = VK_CONTROL) or (Key = VK_SHIFT) or (Key = VK_MENU) then Exit;
  if Shift * [ ssShift, ssAlt, ssCtrl ] = [ ] then Exit;
  S := '';
  if ssCtrl in Shift then S := S + 'Ctrl+';
  if ssAlt in Shift then S := S + 'Alt+';
  if ssShift in Shift then S := S + 'Shift+';
  case Key of
  VK_CANCEL       : K := 'Cancel'            ;
  VK_BACK         : K := 'Back'              ;
  VK_TAB          : K := 'Tab'               ;
  VK_CLEAR        : K := 'Clear'             ;
  VK_RETURN       : K := 'Enter'             ;
  VK_PAUSE        : K := 'Pause'             ;
  VK_CAPITAL      : K := 'CapsLock'          ;
  VK_ESCAPE       : K := 'Escape'            ;
  VK_SPACE        : K := 'Space'             ;
  VK_PRIOR        : K := 'PgUp'              ;
  VK_NEXT         : K := 'PgDn'              ;
  VK_END          : K := 'End'               ;
  VK_HOME         : K := 'Home'              ;
  VK_LEFT	  : K := 'Left'              ;
  VK_UP           : K := 'Up'                ;
  VK_RIGHT        : K := 'Right'             ;
  VK_DOWN         : K := 'Down'              ;
  VK_SELECT       : K := 'Select'            ;
  VK_EXECUTE      : K := 'Execute'           ;
  VK_SNAPSHOT     : K := 'PrintScreen'       ;
  VK_INSERT       : K := 'Insert'            ;
  VK_DELETE       : K := 'Delete'            ;
  VK_HELP         : K := 'Help'              ;
  $30..$39, $41..$5A : K := Char( Key );
  VK_LWIN         : K := 'LWin'              ;
  VK_RWIN         : K := 'RWin'              ;
  VK_APPS         : K := 'Apps'              ;
  VK_NUMPAD0      : K := 'Num0'              ;
  VK_NUMPAD1      : K := 'Num1'              ;
  VK_NUMPAD2      : K := 'Num2'              ;
  VK_NUMPAD3      : K := 'Num3'              ;
  VK_NUMPAD4      : K := 'Num4'              ;
  VK_NUMPAD5      : K := 'Num5'              ;
  VK_NUMPAD6      : K := 'Num6'              ;
  VK_NUMPAD7      : K := 'Num7'              ;
  VK_NUMPAD8      : K := 'Num8'              ;
  VK_NUMPAD9      : K := 'Num9'              ;
  VK_MULTIPLY     : K := '*'                 ;
  VK_ADD          : K := '+'                 ;
  VK_SEPARATOR    : K := ';'                 ;
  VK_SUBTRACT     : K := '-'                 ;
  VK_DECIMAL      : K := ','                 ;
  VK_DIVIDE       : K := '/'                 ;
  VK_F1           : K := 'F1'                ;
  VK_F2           : K := 'F2'                ;
  VK_F3           : K := 'F3'                ;
  VK_F4           : K := 'F4'                ;
  VK_F5           : K := 'F5'                ;
  VK_F6           : K := 'F6'                ;
  VK_F7           : K := 'F7'                ;
  VK_F8           : K := 'F8'                ;
  VK_F9           : K := 'F9'                ;
  VK_F10          : K := 'F10'               ;
  VK_F11          : K := 'F11'               ;
  VK_F12          : K := 'F12'               ;
  VK_F13          : K := 'F13'               ;
  VK_F14          : K := 'F14'               ;
  VK_F15          : K := 'F15'               ;
  VK_F16          : K := 'F16'               ;
  VK_F17          : K := 'F17'               ;
  VK_F18          : K := 'F18'               ;
  VK_F19          : K := 'F19'               ;
  VK_F20          : K := 'F20'               ;
  VK_F21          : K := 'F21'               ;
  VK_F22          : K := 'F22'               ;
  VK_F23          : K := 'F23'               ;
  VK_F24          : K := 'F24'               ;
  VK_NUMLOCK      : K := 'NumLock'           ;
  VK_SCROLL       : K := 'ScrollLock'        ;
  VK_ATTN	  : K := 'ATTN'              ;
  VK_CRSEL        : K := 'CRSel'             ;
  VK_EXSEL        : K := 'EXSel'             ;
  VK_EREOF        : K := 'EREOF'             ;
  VK_PLAY	  : K := 'Play'              ;
  VK_ZOOM         : K := 'Zoom'              ;
  VK_NONAME       : K := 'Noname'            ;
  VK_PA1          : K := 'PA1'               ;
  VK_OEM_CLEAR    : K := 'OEMClear'          ;
  else K := '';
  end;
  if K <> '' then
    edAcc.Text := S+K;
end;

procedure TKOLAccEdit.btOKClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TKOLAccEdit.btCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

constructor TKOLAccEdit.Create(AOwner: TComponent);
begin
  CreateNew(AOwner);

  Left := 208                              ;
  Top := 213                               ;
  BorderIcons := [biSystemMenu]            ;
  BorderStyle := bsToolWindow              ;
  Caption := 'Enter accelerator key for '  ;
  ClientHeight := 38                       ;
  ClientWidth := 317                       ;
  Color := clBtnFace                       ;
  //Font.Charset := DEFAULT_CHARSET        ;
  //Font.Color := clWindowText             ;
  //Font.Height := -11                     ;
  //Font.Name := 'MS Sans Serif'           ;
  //Font.Style := []                       ;
  KeyPreview := True                       ;
  //OldCreateOrder := False                ;
  Scaled := False                          ;
  OnKeyDown := FormKeyDown                 ;
  //PixelsPerInch := 96                    ;
  //TextHeight := 13                       ;

  btOK := TButton.Create( Self )           ;
  btOK.Parent := Self                      ;
  btOK.Left := 154                         ;
  btOK.Top := 6                            ;
  btOK.Width := 75                         ;
  btOK.Height := 25                        ;
  btOK.Caption := 'OK'                     ;
  btOK.Default := True                     ;
  //btOK.TabOrder := 0                     ;
  btOK.OnClick := btOKClick                ;

  btCancel := TButton.Create( Self )       ;
  btCancel.Parent := Self                  ;
  btCancel.Left := 236                     ;
  btCancel.Top := 6                        ;
  btCancel.Width := 75                     ;
  btCancel.Height := 25                    ;
  btCancel.Cancel := True                  ;
  btCancel.Caption := 'Cancel'             ;
  //btCancel.TabOrder := 1                 ;
  btCancel.OnClick := btCancelClick        ;

  edAcc := TEdit.Create( Self );           ;
  edAcc.Parent := Self;                    ;
  edAcc.Left := 10                         ;
  edAcc.Top := 6                           ;
  edAcc.Width := 135                       ;
  edAcc.Height := 21                       ;
  edAcc.Color := clBtnFace                 ;
  edAcc.ReadOnly := True                   ;
  edAcc.TabOrder := 2                      ;

end;

end.
