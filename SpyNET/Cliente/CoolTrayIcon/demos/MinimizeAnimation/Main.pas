unit Main;

{$DEFINE DELPHI_6_UP}
{$IFDEF VER80}  {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF VER90}  {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF VER100} {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF VER120} {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF VER130} {$UNDEF DELPHI_6_UP} {$ENDIF}

interface

uses
  Windows, Messages, Classes, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  CoolTrayIcon;

type
  TMainForm = class(TForm)
    CoolTrayIcon1: TCoolTrayIcon;
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure CoolTrayIcon1Click(Sender: TObject);
    procedure CoolTrayIcon1MinimizeToTray(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  private
    IsMinimized: Boolean;
    procedure FloatRectangles(Minimizing, OverrideUserSettings: Boolean);
    procedure FadeWindow(Minimizing: Boolean);
    procedure ImplodeWindow(Minimizing: Boolean);
    procedure ImplodeOutlineWindow(Minimizing: Boolean);
  public
    StartX, StartY, StartW, StartH: Integer;
  end;

var
  MainForm: TMainForm;

implementation

uses
  TrayAnimation;

{$R *.dfm}

{--------------------- TMainForm ----------------------}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  StartW := Width;
  StartH := Height;
  RadioGroup1Click(Self);
end;


procedure TMainForm.CoolTrayIcon1MinimizeToTray(Sender: TObject);
begin
  case RadioGroup1.ItemIndex of
    1: FloatRectangles(True, True);
    2: FadeWindow(True);
    3: ImplodeWindow(True);
    4: ImplodeOutlineWindow(True);
  end;
  IsMinimized := True;
end;


procedure TMainForm.CoolTrayIcon1Click(Sender: TObject);
begin
  if IsMinimized then
  begin
    case RadioGroup1.ItemIndex of
      1: begin
        FloatRectangles(False, True);
        CoolTrayIcon1.ShowMainForm;
      end;
      2: begin
        CoolTrayIcon1.ShowMainForm;
        FadeWindow(False);
      end;
      3: begin
        CoolTrayIcon1.ShowMainForm;
        ImplodeWindow(False);
      end;
      4: begin
        ImplodeOutlineWindow(False);
        CoolTrayIcon1.ShowMainForm;
      end;
      else
        CoolTrayIcon1.ShowMainForm;
    end;
    IsMinimized := False;
  end;
end;


procedure TMainForm.FloatRectangles(Minimizing, OverrideUserSettings: Boolean);
begin
  FloatingRectangles(Minimizing, OverrideUserSettings);
end;


procedure TMainForm.FadeWindow(Minimizing: Boolean);
var
  WindowFader: TWindowFader;
begin
  WindowFader := TWindowFader.Create(False);
  WindowFader.FadeOut := Minimizing;
  WindowFader.Execute;
  WindowFader.Free;
end;


procedure TMainForm.ImplodeWindow(Minimizing: Boolean);
var
  WindowImploder: TWindowImploder;
begin
  WindowImploder := TWindowImploder.Create(False);
  WindowImploder.Imploding := Minimizing;
  WindowImploder.Execute;
  WindowImploder.Free;
end;


procedure TMainForm.ImplodeOutlineWindow(Minimizing: Boolean);
var
  WindowOutlineImploder: TWindowOutlineImploder;
begin
  WindowOutlineImploder := TWindowOutlineImploder.Create;
  WindowOutlineImploder.Imploding := Minimizing;
  WindowOutlineImploder.Execute;
  WindowOutlineImploder.Free;
end;


procedure TMainForm.Button1Click(Sender: TObject);
begin
  Close;
end;


procedure TMainForm.RadioGroup1Click(Sender: TObject);
begin
  { We turn AlphaBlend on/off as needed because when AlphaBlend is true
    the form flickers when it's resized. }
{$IFDEF DELPHI_6_UP}
  if RadioGroup1.ItemIndex = 2 then
  begin
    AlphaBlend := True;
    AlphaBlendValue := 255;
  end
  else
    AlphaBlend := False;
{$ELSE}
  if RadioGroup1.ItemIndex = 2 then
    MessageDlg('Alpha-blend (fade) not supported in this Delphi version.',
               mtInformation, [mbOk], 0);
{$ENDIF}
end;

end.

