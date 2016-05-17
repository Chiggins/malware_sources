unit Main;

interface

uses
  Windows, Classes, Controls, Forms, StdCtrls, CoolTrayIcon;

type
  TMainForm = class(TForm)
    CoolTrayIcon1: TCoolTrayIcon;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    procedure CheckBox1Click(Sender: TObject);
    procedure CoolTrayIcon1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CoolTrayIcon1Startup(Sender: TObject; var ShowMainForm: Boolean);
    procedure Button1Click(Sender: TObject);
  private
    function LoadSetting(Key, Item: String; DefValue: Boolean): Boolean;
    procedure SaveSetting(Key, Item: String; Value: Boolean);
    procedure RemoveSetting(Key: String);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  Registry;

const
  StartHiddenKey = 'Software\CoolTrayIcon\StartHiddenDemo';


function TMainForm.LoadSetting(Key, Item: String; DefValue: Boolean): Boolean;
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.Create(Key);
  Result := Reg.ReadBool('', Item, DefValue);
  Reg.Free;
end;


procedure TMainForm.SaveSetting(Key, Item: String; Value: Boolean);
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.Create(Key);
  Reg.WriteBool('', Item, Value);
  Reg.Free;
end;


procedure TMainForm.RemoveSetting(Key: String);
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.Create(Key);
  Reg.EraseSection('');
  Reg.Free;
end;


procedure TMainForm.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
    SaveSetting(StartHiddenKey, 'StartHidden', True)
  else
    RemoveSetting(StartHiddenKey);
end;


procedure TMainForm.CoolTrayIcon1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  CoolTrayIcon1.ShowMainForm;
end;


procedure TMainForm.CoolTrayIcon1Startup(Sender: TObject; var ShowMainForm: Boolean);
var
  StartHidden: Boolean;
begin
  StartHidden := LoadSetting(StartHiddenKey, 'StartHidden', False);
  CheckBox1.Checked := StartHidden;
  ShowMainForm := not StartHidden;
end;


procedure TMainForm.Button1Click(Sender: TObject);
begin
  Close;
end;

end.

