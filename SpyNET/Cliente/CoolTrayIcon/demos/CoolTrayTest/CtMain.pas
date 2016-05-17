unit CtMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, Menus, ImgList, CoolTrayIcon;

type
  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    PopupMenu1: TPopupMenu;
    ShowWindow1: TMenuItem;
    HideWindow1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    ImageList1: TImageList;
    rdoCycle: TRadioGroup;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    Label7: TLabel;
    ComboBox1: TComboBox;
    TrayIcon1: TCoolTrayIcon;
    Edit2: TEdit;
    Label4: TLabel;
    ImageList2: TImageList;
    ImageList3: TImageList;
    ImageList4: TImageList;
    ImageList5: TImageList;
    ImageList6: TImageList;
    Button4: TButton;
    N2: TMenuItem;
    BalloonHint1: TMenuItem;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Button5: TButton;
    Button6: TButton;
    ImageList7: TImageList;
    Button7: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ShowWindow1Click(Sender: TObject);
    procedure HideWindow1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure TrayIcon1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrayIcon1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure rdoCycleClick(Sender: TObject);
    procedure TrayIcon1Cycle(Sender: TObject; NextIndex: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button4Click(Sender: TObject);
    procedure TrayIcon1MouseExit(Sender: TObject);
    procedure TrayIcon1MouseEnter(Sender: TObject);
    procedure TrayIcon1Startup(Sender: TObject; var ShowMainForm: Boolean);
    procedure TrayIcon1BalloonHintClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    // Some extra stuff necessary for the "Close to tray" option:
    SessionEnding: Boolean;
    procedure WMQueryEndSession(var Message: TMessage); message WM_QUERYENDSESSION;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Edit1Change(Self);
  CheckBox1Click(Self);
  CheckBox2Click(Self);
  CheckBox3Click(Self);
  CheckBox4Click(Self);
  CheckBox5Click(Self);
  rdoCycleClick(Self);
  ComboBox1.ItemIndex := 0;
end;


procedure TMainForm.ShowWindow1Click(Sender: TObject);
begin
  TrayIcon1.ShowMainForm;    // ALWAYS use this method to restore!!!
end;


procedure TMainForm.HideWindow1Click(Sender: TObject);
begin
  Application.Minimize;      // Will hide dialogs and popup windows as well (this demo has none)
  TrayIcon1.HideMainForm;
end;


procedure TMainForm.Exit1Click(Sender: TObject);
begin
  // We kill the "Close to tray" feature to be able to exit.
  if CheckBox6.Checked then
    CheckBox6.Checked := False;
  Close;
end;


procedure TMainForm.Button1Click(Sender: TObject);
begin
  HideWindow1Click(Self);
end;


procedure TMainForm.Button2Click(Sender: TObject);
begin
  TrayIcon1.IconVisible := not TrayIcon1.IconVisible;
end;


procedure TMainForm.Button6Click(Sender: TObject);
begin
  if IsWindowVisible(Application.Handle) then
    TrayIcon1.HideTaskbarIcon
  else
    TrayIcon1.ShowTaskbarIcon;
end;


procedure TMainForm.Button4Click(Sender: TObject);
begin
  TrayIcon1.ShowBalloonHint('Balloon hint',
        'Use the balloon hint to display important information.' + #13 +
        'The text can be max. 255 chars. and the title max. 64 chars.',
        bitInfo, 10);
end;


procedure TMainForm.Button5Click(Sender: TObject);
begin
  TrayIcon1.HideBalloonHint;
end;


procedure TMainForm.Button7Click(Sender: TObject);
begin
  TrayIcon1.SetFocus;
end;


procedure TMainForm.Edit1Change(Sender: TObject);
begin
  TrayIcon1.Hint := Edit1.Text;
end;


procedure TMainForm.CheckBox1Click(Sender: TObject);
begin
  TrayIcon1.ShowHint := CheckBox1.Checked;
end;


procedure TMainForm.CheckBox2Click(Sender: TObject);
begin
  { Setting the popupmenu's AutoPopup to false will prevent the menu from displaying
    when you click the tray icon. You can still show the menu programmatically,
    using the Popup or PopupAtCursor methods. }
  if Assigned(PopupMenu1) then
    PopupMenu1.AutoPopup := CheckBox2.Checked;
end;


procedure TMainForm.CheckBox3Click(Sender: TObject);
begin
  TrayIcon1.LeftPopup := CheckBox3.Checked;
end;


procedure TMainForm.CheckBox4Click(Sender: TObject);
begin
  TrayIcon1.Enabled := CheckBox4.Checked;
end;


procedure TMainForm.CheckBox5Click(Sender: TObject);
begin
  TrayIcon1.MinimizeToTray := CheckBox5.Checked;
end;


procedure TMainForm.ComboBox1Change(Sender: TObject);
begin
  TrayIcon1.Behavior := TBehavior(ComboBox1.ItemIndex);
end;


procedure TMainForm.TrayIcon1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(PopupMenu1) then
    if not PopupMenu1.AutoPopup then
    begin
      SetForegroundWindow(Application.Handle);  // Move focus from tray icon to this form
      MessageDlg('The popup menu is disabled.', mtInformation, [mbOk], 0);
    end;
end;


procedure TMainForm.TrayIcon1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Pt: TPoint;
begin
  Label1.Caption := 'Mouse pos.: ' + IntToStr(X) + ',' + IntToStr(Y);
  Label2.Caption := 'Key status: ';
  if ssCtrl in Shift then
    Label2.Caption := Label2.Caption + ' Ctrl ';
  if ssAlt in Shift then
    Label2.Caption := Label2.Caption + ' Alt ';
  if ssShift in Shift then
    Label2.Caption := Label2.Caption + ' Shift ';
  // Get client coords.
  Pt := TrayIcon1.GetClientIconPos(X, Y);
  Label6.Caption := 'Client pos.: ' + IntToStr(Pt.X) + ',' + IntToStr(Pt.Y);
end;


procedure TMainForm.rdoCycleClick(Sender: TObject);
begin
  case rdoCycle.ItemIndex of
    0: begin
      TrayIcon1.CycleIcons := False;
      TrayIcon1.IconList := nil;
      ImageList1.GetIcon(0, TrayIcon1.Icon);
      Edit2.Text := IntToStr(TrayIcon1.IconIndex);
    end;
    1: begin
      TrayIcon1.IconList := ImageList1;
      TrayIcon1.CycleInterval := 400;
      TrayIcon1.CycleIcons := True;
    end;
    2: begin
      TrayIcon1.IconList := ImageList2;
      TrayIcon1.CycleInterval := 400;
      TrayIcon1.CycleIcons := True;
    end;
    3: begin
      TrayIcon1.IconList := ImageList3;
      TrayIcon1.CycleInterval := 300;
      TrayIcon1.CycleIcons := True;
    end;
    4: begin
      TrayIcon1.IconList := ImageList4;
      TrayIcon1.CycleInterval := 100;
      TrayIcon1.CycleIcons := True;
    end;
    5: begin
      TrayIcon1.IconList := ImageList5;
      TrayIcon1.CycleInterval := 400;
      TrayIcon1.CycleIcons := True;
    end;
    6: begin
      TrayIcon1.IconList := ImageList6;
      TrayIcon1.CycleInterval := 100;
      TrayIcon1.CycleIcons := True;
    end;
    7: begin
      TrayIcon1.IconList := ImageList7;
      TrayIcon1.CycleInterval := 150;
      TrayIcon1.CycleIcons := True;
    end;
  end;
end;


procedure TMainForm.TrayIcon1Cycle(Sender: TObject; NextIndex: Integer);
begin
  Edit2.Text := IntToStr(TrayIcon1.IconIndex);
end;


procedure TMainForm.WMQueryEndSession(var Message: TMessage);
{ This method is a hack. It intercepts the WM_QUERYENDSESSION message.
  This way we can decide if we want to ignore the "Close to tray" option.
  Otherwise, when selected, the option would make Windows unable to shut down. }
begin
  SessionEnding := True;
  Message.Result := 1;
end;


procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := ((not CheckBox6.Checked) or SessionEnding);
  if not CanClose then
  begin
    TrayIcon1.HideMainForm;
    TrayIcon1.IconVisible := True;
  end;
end;


procedure TMainForm.TrayIcon1MouseEnter(Sender: TObject);
begin
  Label5.Caption := 'ENTER';
end;


procedure TMainForm.TrayIcon1MouseExit(Sender: TObject);
begin
  Label5.Caption := 'EXIT';
end;


procedure TMainForm.TrayIcon1Startup(Sender: TObject; var ShowMainForm: Boolean);
begin
//  ShowMainForm := False;
end;


procedure TMainForm.TrayIcon1BalloonHintClick(Sender: TObject);
begin
  SetForegroundWindow(Application.Handle);  // Move focus from tray icon to this form
  ShowMessage('POP!');
end;

end.

