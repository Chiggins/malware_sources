{ KOL MCK } // Do not remove this line!
{$DEFINE KOL_MCK}
unit unitChat;

interface

{$IFDEF KOL_MCK}
uses Windows, Messages, KOL {$IF Defined(KOL_MCK)}{$ELSE}, mirror, Classes, Controls, mckCtrls,
  mckObjs, Graphics {$IFEND},
  UnitConfigs,
  UnitConexao,
  SysUtils,
  ShellApi,
  UnitExecutarComandos,
  GlobalVars,
  UnitFuncoesDiversas,
  UnitConstantes,
  UnitObjeto;
{$ELSE}
{$I uses.inc}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, mirror;
{$ENDIF}

type
  {$IF Defined(KOL_MCK)}
  {$I MCKfakeClasses.inc}
  {$IFDEF KOLCLASSES} {$I TForm1class.inc} {$ELSE OBJECTS} PFormChat = ^TFormChat; {$ENDIF CLASSES/OBJECTS}
  {$IFDEF KOLCLASSES}{$I TForm1.inc}{$ELSE} TFormChat = object(TObj) {$ENDIF}
    Form: PControl;
  {$ELSE not_KOL_MCK}
  TFormChat = class(TForm)
  {$IFEND KOL_MCK}
    KOLProj: TKOLProject;
    KOLForm: TKOLForm;
    GradientPanel1: TKOLGradientPanel;
    Label1: TKOLLabel;
    EditBox1: TKOLEditBox;
    Label2: TKOLLabel;
    Button1: TKOLButton;
    Button2: TKOLButton;
    Button3: TKOLButton;
    Memo1: TKOLMemo;
    Label3: TKOLLabel;
    OpenSaveDialog1: TKOLOpenSaveDialog;
    procedure KOLFormClose(Sender: PObj; var Accept: Boolean);
    procedure KOLFormShow(Sender: PObj);
    procedure EditBox1KeyChar(Sender: PControl; var Key: KOLChar;
      Shift: Cardinal);
    procedure Button3Click(Sender: PObj);
    procedure Button1Click(Sender: PObj);
    procedure Button2Click(Sender: PObj);
    procedure EditBox1Enter(Sender: PObj);
    procedure EditBox1Leave(Sender: PObj);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ServerName, ClientName: WideString;
  FormChat {$IF Defined(KOL_MCK)} : PFormChat {$ELSE} : TFormChat {$IFEND} ;

{$IFDEF KOL_MCK}procedure NewFormChat( var Result: PFormChat; AParent: PControl );{$ENDIF}
implementation
{$IF Defined(KOL_MCK)}{$I ChatFormCreate.inc}{$ELSE}{$R *.DFM}{$IFEND}

procedure TFormChat.KOLFormClose(Sender: PObj; var Accept: Boolean);
begin
  Accept := False;
  FormChat.Form.Visible := False;
  if (MainIdTCPClient <> nil) and (MainIdTCPClient.Connected = True) then
  GlobalVars.MainIdTCPClient.EnviarString(CHAT + '|' + CHATSTOP + '|');
end;

procedure TFormChat.KOLFormShow(Sender: PObj);
var
  r,rd: TRect;
  h: HWND;
begin
  FormChat.Memo1.Clear;
  FormChat.EditBox1.Clear;

  h := FormChat.Form.Handle; // Your window HWND
  GetWindowRect(h, r);
  GetWindowRect(GetDesktopWindow, rd);
  SetWindowpos(h,0,((rd.Right-rd.Left)-(r.Right-r.Left)) div 2,
  ((rd.Bottom -rd.Top) - (r.Bottom -r.Top)) div 2,0,0, SWP_SHOWWINDOW + SWP_NOZORDER + SWP_NOSIZE);
end;

procedure TFormChat.EditBox1KeyChar(Sender: PControl; var Key: KOLChar;
  Shift: Cardinal);
begin
  if key = #13 then FormChat.Button2.Click;
end;

procedure TFormChat.Button3Click(Sender: PObj);
begin
  FormChat.Form.Close;
end;

Procedure CriarArquivo(NomedoArquivo: pWideChar; Buffer: pWideChar; Size: int64);
var
  hFile: THandle;
  lpNumberOfBytesWritten: DWORD;
  unicode: array [0..1] of byte;
begin
  hFile := CreateFileW(NomedoArquivo, GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);

  if hFile <> INVALID_HANDLE_VALUE then
  begin
    if Size = INVALID_HANDLE_VALUE then
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    unicode[0] := $FF;
    unicode[1] := $FE;
    WriteFile(hFile, unicode, sizeof(unicode), lpNumberOfBytesWritten, nil);
    WriteFile(hFile, Buffer[0], Size, lpNumberOfBytesWritten, nil);
  end;

  CloseHandle(hFile);
end;

procedure TFormChat.Button1Click(Sender: PObj);
var
  TempStr: WideString;
begin
  TempStr := FormChat.Memo1.Text;
  FormChat.OpenSaveDialog1.Title := 'Xtreme RAT';
  FormChat.OpenSaveDialog1.Filter := 'Text files (*.txt)|*.txt';
  FormChat.OpenSaveDialog1.InitialDir := GetShellFolder($0000);
  if FormChat.OpenSaveDialog1.Execute then
  begin
    CriarArquivo(pWideChar(FormChat.OpenSaveDialog1.Filename), pWideChar(TempStr), Length(TempStr) * 2);
  end;
end;

procedure TFormChat.Button2Click(Sender: PObj);
var
  TempStr: WideString;
begin
  TempStr := FormChat.Editbox1.Text;
  if TempStr = '' then exit;
  FormChat.Editbox1.Clear;
  GlobalVars.MainIdTCPClient.EnviarString(CHAT + '|' + CHATTEXT + '|' + TempStr);
  FormChat.Memo1.Text := FormChat.Memo1.Text + ShowTime + ' --- ' + ServerName +  #13#10 + TempStr + #13#10#13#10;
  FormChat.Memo1.SelStart := Length(FormChat.Memo1.Text);
  SendMessage(FormChat.Memo1.handle, EM_SCROLLCARET, 0, 0);
  FormChat.Editbox1.Focused := True;
end;

procedure TFormChat.EditBox1Enter(Sender: PObj);
begin
  FormChat.EditBox1.Color := clSkyBlue;
end;

procedure TFormChat.EditBox1Leave(Sender: PObj);
begin
  FormChat.EditBox1.Color := clWindow;
end;

end.
