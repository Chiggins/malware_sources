unit UnitDesktopPreview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, VirtualTrees;

type
  TFormDesktopPreview = class(TForm)
    Image1: TImage;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    LastNode: pVirtualNode;
    procedure CloseForm;
    { Public declarations }
  end;

var
  FormDesktopPreview: TFormDesktopPreview;

implementation

{$R *.dfm}

const
  WS_EX_LAYERED = $80000;
  WS_EX_NOACTIVATE = $08000000;
  LWA_COLORKEY = 1;
  LWA_ALPHA = 2;

function SetLayeredWindowAttributes(hwnd : HWND; // handle to the layered window
                                    crKey : TColor; // specifies the color key
                                    bAlpha : byte; // value for the blend function
                                    dwFlags : DWORD // action
                                    ): BOOL; stdcall; external 'user32.dll' name 'SetLayeredWindowAttributes';

procedure TFormDesktopPreview.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Timer1.Enabled := false;
  LastNode := nil;
end;

procedure TFormDesktopPreview.FormCreate(Sender: TObject);
begin
  FormStyle := fsStayOnTop;
  SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED or WS_EX_NOACTIVATE);
  SetLayeredWindowAttributes(Handle, 0, 180, LWA_ALPHA);
end;

procedure TFormDesktopPreview.Timer1Timer(Sender: TObject);
begin
  close;
end;

procedure TFormDesktopPreview.CloseForm;
begin
  Timer1.Enabled := false;
  Timer1.Enabled := true;
end;

end.
