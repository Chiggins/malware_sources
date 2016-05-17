unit TtMain;

interface

uses
  Windows, SysUtils, Classes, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, Menus, Graphics, CoolTrayIcon, TextTrayIcon;

type
  TMainForm = class(TForm)
    Timer1: TTimer;
    FontDialog1: TFontDialog;
    ColorDialog1: TColorDialog;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button7: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Label2: TLabel;
    Edit2: TEdit;
    UpDown2: TUpDown;
    Label3: TLabel;
    Edit3: TEdit;
    UpDown3: TUpDown;
    Label4: TLabel;
    Edit4: TEdit;
    UpDown4: TUpDown;
    TrayIcon1: TTextTrayIcon;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure TrayIcon1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
  private
    TrayCounter: Integer;
    LoopNumbers: Boolean;
    BgIcon: TIcon;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  BgIcon := TIcon.Create;
  BgIcon.Assign(TrayIcon1.BackgroundIcon);
  Edit1Change(Self);
  CheckBox1Click(Self);
  CheckBox2Click(Self);
  Edit2Change(Self);
  Edit3Change(Self);
  Edit4Change(Self);
end;


procedure TMainForm.FormDestroy(Sender: TObject);
begin
  BgIcon.Free;
end;


procedure TMainForm.Button7Click(Sender: TObject);
begin
  Close;
end;


procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  if TrayCounter < 91 then
  begin
    if LoopNumbers then
      Edit1.Text := IntToStr(TrayCounter-65)
    else
//      Edit1.Text := Char(TrayCounter) + #13 + Char(TrayCounter+32);
      Edit1.Text := Char(TrayCounter) + Char(TrayCounter) + #13 + Char(TrayCounter) + Char(TrayCounter);
    Inc(TrayCounter);
  end;
  if TrayCounter = 91 then
    TrayCounter := 65;
end;


procedure TMainForm.Button1Click(Sender: TObject);
begin
  // Loop numbers
  LoopNumbers := True;
  TrayCounter := 65;
  Timer1.Enabled := True;
end;


procedure TMainForm.Button2Click(Sender: TObject);
begin
  // Loop characters
  LoopNumbers := False;
  TrayCounter := 65;
  Timer1.Enabled := True;
end;


procedure TMainForm.Button3Click(Sender: TObject);
begin
  Timer1.Enabled := False;
end;


procedure TMainForm.Button4Click(Sender: TObject);
begin
  FontDialog1.Font.Assign(TrayIcon1.Font);
  if FontDialog1.Execute then
    TrayIcon1.Font.Assign(FontDialog1.Font);
//  Alternative:   TrayIcon1.Font := FontDialog1.Font;
end;


procedure TMainForm.Button5Click(Sender: TObject);
begin
  ColorDialog1.Color := TrayIcon1.Color;
  if ColorDialog1.Execute then
    TrayIcon1.Color := ColorDialog1.Color;
end;


procedure TMainForm.Button6Click(Sender: TObject);
begin
  ColorDialog1.Color := TrayIcon1.BorderColor;
  if ColorDialog1.Execute then
    TrayIcon1.BorderColor := ColorDialog1.Color;
end;


procedure TMainForm.Edit1Change(Sender: TObject);
begin
  TrayIcon1.Text := Edit1.Text;
end;


procedure TMainForm.CheckBox1Click(Sender: TObject);
begin
  TrayIcon1.Border := CheckBox1.Checked;
end;


procedure TMainForm.CheckBox2Click(Sender: TObject);
begin
  if CheckBox2.Checked then
    TrayIcon1.BackgroundIcon := BgIcon
  else
    TrayIcon1.BackgroundIcon := nil;
end;


procedure TMainForm.Edit2Change(Sender: TObject);
begin
  TrayIcon1.Options.OffsetX := StrToInt(Edit2.Text);
end;


procedure TMainForm.Edit3Change(Sender: TObject);
begin
  TrayIcon1.Options.OffsetY := StrToInt(Edit3.Text);
end;


procedure TMainForm.Edit4Change(Sender: TObject);
begin
  TrayIcon1.Options.LineDistance := StrToInt(Edit4.Text);
end;


procedure TMainForm.TrayIcon1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
//  Timer1.Enabled := not Timer1.Enabled;
end;

end.

