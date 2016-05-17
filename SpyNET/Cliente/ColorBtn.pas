unit ColorBtn;

interface
  uses
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
    Dialogs, StdCtrls, Buttons;

  type
    TColorBtn = class(TButton)
    private
      IsFocused: boolean;
      FCanvas: TCanvas;
      F3DFrame: boolean;
      FButtonColor: TColor;
      procedure Set3DFrame(Value: boolean);
      procedure SetButtonColor(Value: TColor);
      procedure CNDrawItem(var Message: TWMDrawItem);
        message CN_DRAWITEM;
      procedure WMLButtonDblClk(var Message: TWMLButtonDblClk);
        message WM_LBUTTONDBLCLK;
      procedure DrawButtonText(const Caption: string; TRC: TRect;
        State: TButtonState; BiDiFlags: Longint);
      procedure CalcuateTextPosition(const Caption: string;
        var TRC: TRect; BiDiFlags: Longint);
    protected
      procedure CreateParams(var Params: TCreateParams); override;
      procedure SetButtonStyle(ADefault: boolean); override;
    public
      constructor Create(AOwner: TComponent); override;
      destructor Destroy; override;
    published
      property ButtonColor: TColor read FButtonColor
        write SetButtonColor default clBtnFace;
      property Frame3D: boolean read F3DFrame write Set3DFrame
        default False;
  end;

  procedure Register;

implementation

{ TColorBtn  }

constructor TColorBtn.Create(AOwner: TComponent);
begin
  Inherited Create(AOwner);
  FCanvas:= TCanvas.Create;
  FButtonColor:= clBtnFace;
  F3DFrame:= False;
end;

destructor TColorBtn.Destroy;
begin
  FCanvas.Free;
  Inherited Destroy;
end;

procedure TColorBtn.CreateParams(var Params: TCreateParams);
begin
  Inherited CreateParams(Params);
  with Params do Style:= Style or BS_OWNERDRAW;
end;

procedure TColorBtn.Set3DFrame(Value: boolean);
begin
  if F3DFrame <> Value then F3DFrame:= Value;
end;

procedure TColorBtn.SetButtonColor(Value: TColor);
begin
  if FButtonColor <> Value then begin
    FButtonColor:= Value;
    Invalidate;
  end;
end;

procedure TColorBtn.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  Perform(WM_LBUTTONDOWN, Message.Keys, Longint(Message.Pos));
end;

procedure TColorBtn.SetButtonStyle(ADefault: Boolean);
begin
  if IsFocused <> ADefault then IsFocused:= ADefault;
end;

procedure TColorBtn.CNDrawItem(var Message: TWMDrawItem);
var
  RC: TRect;
  Flags: Longint;
  State: TButtonState;
  IsDown, IsDefault: Boolean;
  DrawItemStruct: TDrawItemStruct;
begin
  DrawItemStruct:= Message.DrawItemStruct^;
  FCanvas.Handle:= DrawItemStruct.HDC;
  RC:= ClientRect;
  with DrawItemStruct do begin
    IsDown:= ItemState and ODS_SELECTED <> 0;
    IsDefault:= ItemState and ODS_FOCUS <> 0;
    if not Enabled then State:= bsDisabled
    else if IsDown then State:= bsDown
    else State:= bsUp;
  end;
  Flags:= DFCS_BUTTONPUSH or DFCS_ADJUSTRECT;
  if IsDown then Flags:= Flags or DFCS_PUSHED;
  if DrawItemStruct.ItemState and ODS_DISABLED <> 0 then
    Flags:= Flags or DFCS_INACTIVE;
  if IsFocused or IsDefault then begin
    FCanvas.Pen.Color:= clWindowFrame;
    FCanvas.Pen.Width:= 1;
    FCanvas.Brush.Style:= bsClear;
    FCanvas.Rectangle(RC.Left, RC.Top, RC.Right, RC.Bottom);
    InflateRect(RC, -1, -1);
  end;
  if IsDown then begin
    FCanvas.Pen.Color:= clBtnShadow;
    FCanvas.Pen.Width:= 1;
    FCanvas.Rectangle(RC.Left, RC.Top, RC.Right, RC.Bottom);
    InflateRect(RC, -1, -1);
    if F3DFrame then begin
      FCanvas.Pen.Color:= FButtonColor;
      FCanvas.Pen.Width:= 1;
      DrawFrameControl(DrawItemStruct.HDC, RC, DFC_BUTTON, Flags);
    end;
  end else
    DrawFrameControl(DrawItemStruct.HDC, RC, DFC_BUTTON, Flags);
  FCanvas.Brush.Color:= FButtonColor;
  FCanvas.FillRect(RC);
  InflateRect(RC, 1, 1);
  if IsFocused then begin
    RC:= ClientRect;
    InflateRect(RC, -1, -1);
  end;
  if IsDown then OffsetRect(RC, 1, 1);
  FCanvas.Font:= Self.Font;
  DrawButtonText(Caption, RC, State, 0);
  if IsFocused and IsDefault then begin
    RC:= ClientRect;
    InflateRect(RC, -4, -4);
    FCanvas.Pen.Color:= clWindowFrame;
    Windows.DrawFocusRect(FCanvas.Handle, RC);
  end;
  FCanvas.Handle:= 0;
end;

procedure TColorBtn.CalcuateTextPosition(const Caption: string;
      var TRC: TRect; BiDiFlags: Integer);
var
  TB: TRect;
  TS, TP: TPoint;
begin
  with FCanvas do begin
    TB:= Rect(0, 0, TRC.Right + TRC.Left, TRC.Top + TRC.Bottom);
    DrawText(Handle, PChar(Caption), Length(Caption), TB,
      DT_CALCRECT or BiDiFlags);
    TS := Point(TB.Right - TB.Left, TB.Bottom - TB.Top);
    TP.X := ((TRC.Right - TRC.Left) - TS.X + 1) div 2;
    TP.Y := ((TRC.Bottom - TRC.Top) - TS.Y + 1) div 2;
    OffsetRect(TB, TP.X + TRC.Left, TP.Y + TRC.Top);
    TRC:= TB;
  end;
end;

procedure TColorBtn.DrawButtonText(const Caption: string; TRC: TRect;
  State: TButtonState; BiDiFlags: Integer);
begin
  with FCanvas do begin
    CalcuateTextPosition(Caption, TRC, BiDiFlags);
    Brush.Style:= bsClear;
    if State = bsDisabled then begin
      OffsetRect(TRC, 1, 1);
      Font.Color:= clBtnHighlight;
      DrawText(Handle, PChar(Caption), Length(Caption), TRC,
        DT_CENTER or DT_VCENTER or BiDiFlags);
      OffsetRect(TRC, -1, -1);
      Font.Color:= clBtnShadow;
      DrawText(Handle, PChar(Caption), Length(Caption), TRC,
        DT_CENTER or DT_VCENTER or BiDiFlags);
    end else
      DrawText(Handle, PChar(Caption), Length(Caption), TRC,
        DT_CENTER or DT_VCENTER or BiDiFlags);
    end;
end;

procedure Register;
begin
  RegisterComponents('Samples', [TColorBtn]);
end;

end.