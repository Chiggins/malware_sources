{*****************************************************************}
{ This is a component for placing icons in the notification area  }
{ of the Windows taskbar (aka. the traybar).                      }
{                                                                 }
{ It is an expanded version of my CoolTrayIcon component, which   }
{ you will need to make this work. The expanded features allow    }
{ you to easily draw text in the tray icon.                       }
{                                                                 }
{ The component is freeware. Feel free to use and improve it.     }
{ I would be pleased to hear what you think.                      }
{                                                                 }
{ Troels Jakobsen - troels.jakobsen@gmail.com                     }
{ Copyright (c) 2006                                              }
{                                                                 }
{ Portions by Jouni Airaksinen - mintus@codefield.com             }
{*****************************************************************}

unit TextTrayIcon;

interface

uses
  CoolTrayIcon, Windows, Graphics, Classes, Controls;

type
  TOffsetOptions = class(TPersistent)
  private
    FOffsetX,
    FOffsetY,
    FLineDistance: Integer;
    FOnChange: TNotifyEvent;           // Procedure var.
    procedure SetOffsetX(Value: Integer);
    procedure SetOffsetY(Value: Integer);
    procedure SetLineDistance(Value: Integer);
  protected
    procedure Changed; dynamic;
  published
    property OffsetX: Integer read FOffsetX write SetOffsetX;
    property OffsetY: Integer read FOffsetY write SetOffsetY;
    property LineDistance: Integer read FLineDistance write SetLineDistance;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TTextTrayIcon = class(TCoolTrayIcon)
  private
    FFont: TFont;
    FColor: TColor;
    FInvertTextColor: TColor;
    FBorder: Boolean;
    FBorderColor: TColor;
    FText: String;
    FTextBitmap: TBitmap;
    FOffsetOptions: TOffsetOptions;
    FBackgroundIcon: TIcon;
    procedure FontChanged(Sender: TObject);
    procedure SplitText(const Strings: TList);
    procedure OffsetOptionsChanged(OffsetOptions: TObject);
    procedure SetBackgroundIcon(Value: TIcon);
  protected
    procedure Loaded; override;
    function LoadDefaultIcon: Boolean; override;
    function LoadDefaultBackgroundIcon: Boolean; virtual;
    procedure Paint; virtual;
    procedure SetText(Value: String);
    procedure SetTextBitmap(Value: TBitmap);
    procedure SetFont(Value: TFont);
    procedure SetColor(Value: TColor);
    procedure SetBorder(Value: Boolean);
    procedure SetBorderColor(Value: TColor);
    procedure SetOffsetOptions(Value: TOffsetOptions);
    function TransparentBitmapToIcon(const Bitmap: TBitmap; const Icon: TIcon;
      MaskColor: TColor): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Draw;
  published
    property BackgroundIcon: TIcon read FBackgroundIcon write SetBackgroundIcon;
    property Text: String read FText write SetText;
    property Font: TFont read FFont write SetFont;
    property Color: TColor read FColor write SetColor default clBtnFace;
    property Border: Boolean read FBorder write SetBorder;
    property BorderColor: TColor read FBorderColor write SetBorderColor
      default clBlack;
    property Options: TOffsetOptions read FOffsetOptions write SetOffsetOptions;
  end;


implementation

uses
  SysUtils;

{------------------- TOffsetOptions -------------------}

procedure TOffsetOptions.Changed;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;


procedure TOffsetOptions.SetOffsetX(Value: Integer);
begin
  if Value <> FOffsetX then
  begin
    FOffsetX := Value;
    Changed;
  end;
end;


procedure TOffsetOptions.SetOffsetY(Value: Integer);
begin
  if Value <> FOffsetY then
  begin
    FOffsetY := Value;
    Changed;
  end;
end;


procedure TOffsetOptions.SetLineDistance(Value: Integer);
begin
  if Value <> FLineDistance then
  begin
    FLineDistance := Value;
    Changed;
  end;
end;

{------------------- TTextTrayIcon --------------------}

constructor TTextTrayIcon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBackgroundIcon := TIcon.Create;
  FTextBitmap := TBitmap.Create;
  FFont := TFont.Create;
  FFont.OnChange := FontChanged;
  FColor := clBtnFace;
  FBorderColor := clBlack;
  FOffsetOptions := TOffsetOptions.Create;
  FOffsetOptions.OnChange := OffsetOptionsChanged;

  { Assign a default bg. icon if BackgroundIcon property is empty.
    This will assign a bg. icon to the component when it is created for
    the very first time. When the user assigns another icon it will not
    be overwritten next time the project loads.
    This is similar to the default Icon in parent class CoolTrayIcon. }
  { On second thought: do we really want a default bg. icon? Probably not.
    For this reason the class method LoadDefaultBackgroundIcon will
    return false. }
  if (csDesigning in ComponentState) then
    if FBackgroundIcon.Handle = 0 then
      if LoadDefaultBackgroundIcon then
      begin
        FBackgroundIcon.Handle := LoadIcon(0, IDI_WINLOGO);
        Draw;
      end;
end;


destructor TTextTrayIcon.Destroy;
begin
  try
    FFont.Free;
    FTextBitmap.Free;
    FOffsetOptions.Free;
    try
      if FBackgroundIcon <> nil then
        FBackgroundIcon.Free;
    except
      on Exception do
        // Do nothing; the background icon seems to be invalid
    end;
  finally
    inherited Destroy;
  end;
end;


procedure TTextTrayIcon.Loaded;
begin
  inherited Loaded;          // Always call inherited Loaded first
  // No extra handling needed
end;


function TTextTrayIcon.LoadDefaultIcon: Boolean;
{ We don't want a default icon, so we override this method inherited
  from CoolTrayIcon. }
begin
  Result := False;           // No thanks, no default icon
end;


function TTextTrayIcon.LoadDefaultBackgroundIcon: Boolean;
{ This method is called to determine whether to assign a default bg. icon
  to the component. Descendant classes can override the method to change
  this behavior. }
begin
  Result := False;           // No thanks, no default bg. icon
end;


procedure TTextTrayIcon.FontChanged(Sender: TObject);
{ This method is invoked when user assigns to Font (but not when Font is set
  directly to another TFont var.) }
begin
  Draw;
end;


procedure TTextTrayIcon.SetText(Value: String);
begin
  FText := Value;
  Draw;
end;


procedure TTextTrayIcon.SetTextBitmap(Value: TBitmap);
begin
  FTextBitmap := Value;      // Assign?
  Draw;
end;


procedure TTextTrayIcon.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
  Draw;
end;


procedure TTextTrayIcon.SetColor(Value: TColor);
begin
  FColor := Value;
  Draw;
end;


procedure TTextTrayIcon.SetBorder(Value: Boolean);
begin
  FBorder := Value;
  Draw;
end;


procedure TTextTrayIcon.SetBorderColor(Value: TColor);
begin
  FBorderColor := Value;
  Draw;
end;


procedure TTextTrayIcon.SetOffsetOptions(Value: TOffsetOptions);
{ This method will only be invoked if the user creates a new
  TOffsetOptions object. User will probably just set the values
  of the existing TOffsetOptions object. }
begin
  FOffsetOptions.Assign(Value);
  Draw;
end;


procedure TTextTrayIcon.OffsetOptionsChanged(OffsetOptions: TObject);
{ This method will be invoked when the user changes the values of the
  existing TOffsetOptions object. }
begin
  Draw;
end;


procedure TTextTrayIcon.SetBackgroundIcon(Value: TIcon);
begin
  FBackgroundIcon.Assign(Value);
  Draw;
end;


procedure TTextTrayIcon.Draw;
var
  Ico: TIcon;
  rc: Boolean;
begin
  CycleIcons := False;       // We cannot cycle and draw at the same time
  Paint;                     // Render FTextBitmap
  Ico := TIcon.Create;
  if (Assigned(FBackgroundIcon)) and not (FBackgroundIcon.Empty) then
    // Draw text transparently on background icon
    rc := TransparentBitmapToIcon(FTextBitmap, Ico, FColor)
  else
  begin
    // Just draw text; no background icon
    if FColor <> clNone then
      FInvertTextColor := clNone;
    rc := BitmapToIcon(FTextBitmap, Ico, FInvertTextColor);
  end;

  if rc then
  begin
    Icon.Assign(Ico);
//    Refresh;                 // Always refresh after icon assignment
    Ico.Free;
  end;
end;


function TTextTrayIcon.TransparentBitmapToIcon(const Bitmap: TBitmap;
  const Icon: TIcon; MaskColor: TColor): Boolean;
{ Render an icon from a 16x16 bitmap. Return false if error.
  MaskColor is a color that will be rendered transparently. Use clNone for
  no transparency. }
var
  BitmapImageList: TImageList;
  Bmp: TBitmap;
  FInvertColor: TColor;
begin
  BitmapImageList := TImageList.CreateSize(16, 16);
  try
    Result := False;
    BitmapImageList.AddIcon(FBackgroundIcon);
    Bmp := TBitmap.Create;

    if (FColor = clNone) or (FColor = FFont.Color) then
      FInvertColor := ColorToRGB(FFont.Color) xor $00FFFFFF
    else
      FInvertColor := MaskColor;

    Bmp.Canvas.Brush.Color := FInvertColor;
    BitmapImageList.GetBitmap(0, Bmp);
    Bitmap.Transparent := True;
    Bitmap.TransParentColor := FInvertTextColor;
    Bmp.Canvas.Draw(0, 0, Bitmap);

    BitmapImageList.AddMasked(Bmp, FInvertColor);
    BitmapImageList.GetIcon(1, Icon);
    Bmp.Free;
    Result := True;
  finally
    BitmapImageList.Free;
  end;
end;


procedure TTextTrayIcon.Paint;
var
  Bitmap: TBitmap;
  Left, Top, LinesTop, LineHeight: Integer;
  Substr: PChar;
  Strings: TList;
  I: Integer;
begin
  Bitmap := TBitmap.Create;
  try
    Bitmap.Width := 16;
    Bitmap.Height := 16;
//    Bitmap.Canvas.TextFlags := 2;         // ETO_OPAQUE

    // Render background rectangle
    if (FColor = clNone) or (FColor = FFont.Color) then
      FInvertTextColor := ColorToRGB(FFont.Color) xor $00FFFFFF
    else
      FInvertTextColor := FColor;
    Bitmap.Canvas.Brush.Color := FInvertTextColor;
    Bitmap.Canvas.FillRect(Rect(0, 0, 16, 16));

    // Render text; check for line breaks
    Bitmap.Canvas.Font.Assign(FFont);
    Substr := StrPos(PChar(FText), #13);
    if Substr = nil then
    begin
      // No line breaks
      Left := (15 - Bitmap.Canvas.TextWidth(FText)) div 2;
      if FOffsetOptions <> nil then
        Left := Left + FOffsetOptions.OffsetX;
      Top := (15 - Bitmap.Canvas.TextHeight(FText)) div 2;
      if FOffsetOptions <> nil then
        Top := Top + FOffsetOptions.OffsetY;
      Bitmap.Canvas.TextOut(Left, Top, FText);
    end
    else
    begin
      // Line breaks
      Strings := TList.Create;
      SplitText(Strings);
      LineHeight := Bitmap.Canvas.TextHeight(Substr);
      if FOffsetOptions <> nil then
        LineHeight := LineHeight + FOffsetOptions.LineDistance;
      LinesTop := (15 - (LineHeight * Strings.Count)) div 2;
      if FOffsetOptions <> nil then
        LinesTop := LinesTop + FOffsetOptions.OffsetY;
      for I := 0 to Strings.Count -1 do
      begin
        Substr := Strings[I];
        Left := (15 - Bitmap.Canvas.TextWidth(Substr)) div 2;
        if FOffsetOptions <> nil then
          Left := Left + FOffsetOptions.OffsetX;
        Top := LinesTop + (LineHeight * I);
        Bitmap.Canvas.TextOut(Left, Top, Substr);
      end;
      for I := 0 to Strings.Count -1 do
        StrDispose(Strings[I]);
      Strings.Free;
    end;

    // Render border
    if FBorder then
    begin
      Bitmap.Canvas.Brush.Color := FBorderColor;
      Bitmap.Canvas.FrameRect(Rect(0, 0, 16, 16));
    end;

    // Assign the final bitmap
    FTextBitmap.Assign(Bitmap);

  finally
    Bitmap.Free;
  end;
end;


procedure TTextTrayIcon.SplitText(const Strings: TList);

  function PeekedString(S: String): String;
  var
    P: Integer;
  begin
    P := Pos(#13, S);
    if P = 0 then
      Result := S
    else
      Result := Copy(S, 1, P-1);
  end;

var
  Substr: String;
  P: Integer;
  S: PChar;
begin
  Strings.Clear;
  Substr := FText;
  repeat
    P := Pos(#13, Substr);
    if P = 0 then
    begin
      S := StrNew(PChar(Substr));
      Strings.Add(S);
    end
    else
    begin
      S := StrNew(PChar(PeekedString(Substr)));
      Strings.Add(S);
      Delete(Substr, 1, P);
    end;
  until P = 0;
end;

end.

