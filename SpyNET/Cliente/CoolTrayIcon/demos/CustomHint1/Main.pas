unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ImgList, CoolTrayIcon, Menus;

type
  TForm1 = class(TForm)
    CoolTrayIcon1: TCoolTrayIcon;
    PopupMenu1: TPopupMenu;
    Exit1: TMenuItem;
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Loaded; override;
    procedure CoolTrayIcon1MouseEnter(Sender: TObject);
    procedure CoolTrayIcon1MouseExit(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    HTooltip: HWND;
    CustomFont: TFont;
    BackColor, TextColor: COLORREF;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const
  // Tooltip constants
  TTM_SETMAXTIPWIDTH = (WM_USER + 24);
  TTM_SETTIPBKCOLOR = (WM_USER + 19);
  TTM_SETTIPTEXTCOLOR = (WM_USER + 20);
  TTM_SETTITLEA = (WM_USER + 32);

procedure TForm1.FormCreate(Sender: TObject);
begin
  CustomFont := TFont.Create;
  CustomFont.Size := 14;
  CustomFont.Name := 'Verdana';
  BackColor := RGB(0, 0, 255);
  TextColor := RGB(255, 255, 0);
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  CustomFont.Free;
end;


procedure TForm1.Loaded;
begin
  inherited;
  HTooltip := CoolTrayIcon1.GetTooltipHandle;
end;


procedure TForm1.CoolTrayIcon1MouseEnter(Sender: TObject);
begin
  if HTooltip = 0 then
    Exit;
  // Set colors
  SendMessage(HTooltip, TTM_SETTIPBKCOLOR, BackColor, 0);
  SendMessage(HTooltip, TTM_SETTIPTEXTCOLOR, TextColor, 0);
  // Set max width
//  SendMessage(HTooltip, TTM_SETMAXTIPWIDTH, 0, 999);       //???
  // Set font
  SendMessage(HTooltip, WM_SETFONT, CustomFont.Handle, 0);
end;


procedure TForm1.CoolTrayIcon1MouseExit(Sender: TObject);
begin
  if HTooltip = 0 then
    Exit;
  // Close tooltip immediately (by moving it off-screen)
  SetWindowPos(HTooltip, 0, -500, -500, 0, 0, SWP_NOZORDER or SWP_NOACTIVATE or SWP_NOSIZE);
  // Reset tooltip properties to defaults
  SendMessage(HTooltip, TTM_SETMAXTIPWIDTH, 0, -1);
  SendMessage(HTooltip, WM_SETFONT, 0, 0);
  SendMessage(HTooltip, TTM_SETTIPBKCOLOR, GetSysColor(COLOR_INFOBK), 0);
  SendMessage(HTooltip, TTM_SETTIPTEXTCOLOR, GetSysColor(COLOR_INFOTEXT), 0);
end;


procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
  Exit1Click(Self);
end;

end.

