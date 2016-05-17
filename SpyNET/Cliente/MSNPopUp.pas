{
    MsnPopup - using MSN-style popup windows in your Delphi programs
    Copyright (C) 2001-2003 JWB Software

    Web:   http://people.zeelandnet.nl/famboek/delphi/
    Email: jwbsoftware@zeelandnet.nl
}

Unit MSNPopUp;

Interface

Uses
  Windows, Classes, Graphics, StdCtrls, ExtCtrls, Controls, Forms,
  ShellApi, Dialogs, SysUtils, Messages;

// fix for Delphi-5 users
Const
  WS_EX_NOACTIVATE = $8000000;

Type
  TURLEvent = Procedure(Sender: TObject; URL: String) Of Object;

Type
  TMouseLabel = Class(TLabel)
  private
    { Private declarations }
    fMouseEnter: TNotifyEvent;
    fMouseLeave: TNotifyEvent;
    Procedure CMMouseEnter(Var Message: TMessage); message CM_MOUSEENTER;
    Procedure CMMouseLeave(Var Message: TMessage); message CM_MOUSELEAVE;
  published
    { Published declarations }
    Property OnMouseEnter: TNotifyEvent read fMouseEnter write fMouseEnter;
    Property OnMouseLeave: TNotifyEvent read fMouseLeave write fMouseLeave;
  End;

Type
  TOrientation = (mbHorizontal, mbVertical);
  TScrollSpeed = 1..50;

  TMSNPopupOption = (msnAutoOpenURL, msnSystemFont, msnCascadePopups,
    msnAllowScroll, msnAllowHyperlink);

  // Anomy
  TMSNImageDrawMethod = (dmActualSize, dmTile, dmFit);

  TMSNPopupOptions = Set Of TMSNPopupOption;

  TMSNPopUp = Class(TComponent)
  private
    { Private declarations }
    FURL: String;
    FText: String;
    FTitle: String;
    FIcon: TBitmap;
    FWidth: Integer;
    FHeight: Integer;
    FTimeOut: Integer;
    FScrollSpeed: TScrollSpeed;
    FColor1: TColor;
    FColor2: TColor;
    FGradientOrientation: TOrientation;
    FFont: TFont;
    FHoverFont: TFont;
    FTitleFont: TFont;
    FCursor: TCursor;
    FOptions: TMSNPopupOptions;

    // Anomy
    FTextAlignment: TAlignment;
    FBackgroundDrawMethod: TMSNImageDrawMethod;

    //Jelmer
    FPopupMarge, FPopupStartX, FPopupStartY: Integer;
    PopupCount, NextPopupPos: Integer;
    LastBorder: Integer;
    FDefaultMonitor: TDefaultMonitor;
    FBackground: TBitmap;

    FIconLeft, FIconTop: Integer;

    FOnClick: TNotifyEvent;
    FOnURLClick: TURLEvent;

    Procedure SetIcon(Value: TBitmap);
    Function GetEdge: Integer;
    Function GetCaptionFont: TFont;

    // Jiang Hong
    Procedure SetFont(Value: TFont);
    Procedure SetHoverFont(Value: TFont);
    Procedure SetTitleFont(Value: TFont);

    //Jelmer
    Procedure SetBackground(Value: TBitmap);
  public
    { Public declarations }
    Function ShowPopUp: Boolean;
    Procedure ClosePopUps;
  published
    { Published declarations }
    Property Text: String read FText write FText;
    Property URL: String read FURL write FURL;
    Property IconBitmap: TBitmap read FIcon write SetIcon stored True;
    Property IconLeft: Integer read FIconLeft write FIconLeft;
    Property IconTop: Integer read FIconTop write FIconTop;
    Property TimeOut: Integer read FTimeOut write FTimeOut default 10;
    Property Width: Integer read FWidth write FWidth default 175;
    Property Height: Integer read FHeight write FHeight default 175;
    Property GradientColor1: TColor read FColor1 write FColor1;
    Property GradientColor2: TColor read FColor2 write FColor2;
    Property GradientOrientation: TOrientation read FGradientOrientation write FGradientOrientation default mbVertical;
    Property ScrollSpeed: TScrollSpeed read FScrollSpeed write FScrollSpeed default 5;
    Property Font: TFont read FFont write SetFont;
    Property HoverFont: TFont read FHoverFont write SetHoverFont; //Jiang Hong
    Property Title: String read FTitle write FTitle;              //Jiang Hong
    Property TitleFont: TFont read FTitleFont write SetTitleFont; //Jiang Hong
    Property Options: TMSNPopupOptions read FOptions write FOptions;
    // Anomy
    Property TextAlignment: TAlignment read FTextAlignment write FTextAlignment default taLeftJustify;
    Property BackgroundDrawMethod: TMSNImageDrawMethod read FBackgroundDrawMethod write FBackgroundDrawMethod default dmActualSize;
    //Jelmer
    Property TextCursor: TCursor read FCursor write FCursor;
    Property PopupMarge: Integer read FPopupMarge write FPopupMarge;
    Property PopupStartX: Integer read FPopupStartX write FPopupStartX;
    Property PopupStartY: Integer read FPopupStartY write FPopupStartY;
    Property DefaultMonitor: TDefaultMonitor read FDefaultMonitor write FDefaultMonitor;
    Property BackgroundImage: TBitmap read FBackground write SetBackground;

    Property OnClick: TNotifyEvent read FOnClick write FOnClick;
    Property OnURLClick: TURLEvent read FOnURLClick write FOnURLClick;

    Constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
  End;

Type
  TfrmMSNPopUp = Class(TCustomForm)
    pnlBorder: TPanel;
    imgIcon: TImage;
    lblText: TMouseLabel;
    imgGradient: TImage;
    //
    tmrExit: TTimer;
    tmrScroll: TTimer;
    // add by Ahmed Hamed 20-3-2002
    tmrScrollDown: TTimer;
    //
    lblTitle: TMouseLabel;
    // Added by Anomy

    Procedure lblTextMouseEnter(Sender: TObject);
    Procedure lblTextMouseLeave(Sender: TObject);
    Procedure lblTextClick(Sender: TObject);
    Procedure tmrExitTimer(Sender: TObject);
    // add by Ahmed Hamed 20-3-2002
    Procedure tmrscrollDownTimer(Sender: TObject);
    //
    Procedure lblTextMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    Procedure lblTitleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    Procedure tmrScrollTimer(Sender: TObject);
    Procedure imgIconMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    Procedure imgGradientMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  protected
    Procedure CreateParams(Var Params: TCreateParams); override;
    Procedure DoClose(Var Action: TCloseAction); override;
  private
    //Jelmer
    PopupPos: Integer;
    ParentMSNPopup: TMSNPopup;
    CanClose: Boolean;

    // Anomy
    BGDrawMethod: TMSNImageDrawMethod;

    Function CalcColorIndex(StartColor, EndColor: TColor; Steps, ColorIndex: Integer): TColor;
    Procedure PositionText;
    Function IsWinXP: Boolean;
  public
    { Public declarations }
    URL, Text, Title: String;
    TimeOut: Integer;
    Icon: TBitmap;
    sWidth: Integer;
    sHeight: Integer;
    bScroll, bHyperlink: Boolean;
    Color1, Color2: TColor;
    Orientation: TOrientation;
    ScrollSpeed: TScrollSpeed;
    Font, HoverFont, TitleFont: TFont;
    StoredBorder: Integer;
    Cursor: TCursor;

    Constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
    Procedure PopUp;
  End;

Procedure Register;
Function IsNT4: Boolean;

Implementation

Function IsNT4: Boolean;
Var
  VersionInfo: _OSVERSIONINFOA;
Begin
  Result := False;

  VersionInfo.dwOSVersionInfoSize := sizeof(VersionInfo);
  GetVersionEx(VersionInfo);

  If VersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT Then
   Begin
    If (VersionInfo.dwMajorVersion <= 4) and ((VersionInfo.dwMinorVersion = 0) or
      (VersionInfo.dwMinorVersion = 51)) Then
      Result := True;
   End;
End;

Procedure Register;
Begin
  RegisterComponents('Custom', [TMSNPopUp]);
End;

// mouselabel-stuff

Procedure TMouseLabel.CMMouseEnter(Var Message: TMessage);
Begin
  If assigned(fMouseEnter) Then
    fMouseEnter(self);
End;

Procedure TMouseLabel.CMMouseLeave(Var Message: TMessage);
Begin
  If assigned(fMouseLeave) Then
    fMouseLeave(self);
End;

// component stuff

Function TMSNPopUp.ShowPopUp: Boolean;
Var
  r: TRect;
  MSNPopUp: TfrmMSNPopUp;
Begin
  //Jelmer
  If GetEdge <> LastBorder Then
   Begin
    LastBorder := GetEdge;
    PopupCount := 0;
   End;
  Result := True;
  SystemParametersInfo(SPI_GETWORKAREA, 0, @r, 0);
  If PopupCount > 0 Then
   Begin
    Case LastBorder Of
      ABE_BOTTOM:
        If (r.Bottom - (NextPopupPos + FHeight + PopupStartY)) < 0 Then
         Begin
          Result := False;
          Exit;
         End;
      ABE_LEFT:
        If (NextPopupPos + FWidth + PopupStartX) > r.Right Then
         Begin
          Result := False;
          Exit;
         End;
      ABE_RIGHT:
        If (r.Right - (NextPopupPos + FHeight + PopupStartY)) < 0 Then
         Begin
          Result := False;
          Exit;
         End;
      ABE_TOP:
        If ((NextPopupPos + FHeight + PopupStartY)) > r.Bottom Then
         Begin
          Result := False;
          Exit;
         End;
     End;
   End
  Else
    NextPopupPos := 0;
  Inc(PopupCount);

  MSNPopUp := TfrmMSNPopUp.CreateNew(Self.Owner);
  MSNPopUp.Hide;

  //Jelmer
  MSNPopUp.ParentMSNPopup := Self;
  MSNPopUp.DefaultMonitor := FDefaultMonitor;

  MSNPopUp.sWidth  := FWidth;
  MSNPopUp.sHeight := FHeight;

  MSNPopUp.Text    := FText;
  MSNPopUp.URL     := FURL;
  MSNPopUp.Title   := FTitle;
  MSNPopUp.TimeOut := FTimeOut;

  MSNPopUp.Icon := FIcon;

  MSNPopUp.bScroll     := msnAllowScroll in FOptions;
  MSNPopUp.bHyperlink  := msnAllowHyperlink in FOptions;
  MSNPopUp.ScrollSpeed := FScrollSpeed;

  MSNPopUp.Font      := FFont;
  MSNPopUp.HoverFont := FHoverFont;
  MSNPopUp.TitleFont := FTitleFont;
  MSNPopUp.Cursor    := FCursor;

  MSNPopUp.Color1      := FColor1;
  MSNPopUp.Color2      := FColor2;
  MSNPopUp.Orientation := FGradientOrientation;

  // Anomy
  MSNPopUp.lblText.Alignment := FTextAlignment;
  MSNPopUp.pnlBorder.Align   := alClient;
  MSNPopUp.BGDrawMethod      := FBackgroundDrawMethod;

  MSNPopUp.PopUp;
End;

// JWB
Procedure TMSNPopUp.ClosePopUps;
Var
  hTfrmMSNPopUp: Cardinal;
  i: Integer;
Begin
  For i := 0 To PopUpCount Do
   Begin
    hTfrmMSNPopUp := FindWindow(PChar('TfrmMSNPopUP'), nil);
    If hTfrmMSNPopUp <> 0 Then
     Begin
      SendMessage(hTfrmMSNPopUp, WM_CLOSE, 0,0);
      Application.ProcessMessages;
     End;
   End;
End;

//Jiang Hong
Procedure TMSNPopup.SetFont(Value: TFont);
Begin
  If not (FFont = Value) Then
    FFont.Assign(Value);
End;

//Jiang Hong
Procedure TMSNPopup.SetHoverFont(Value: TFont);
Begin
  If not (FHoverFont = Value) Then
    FHoverFont.Assign(Value);
End;

//Jiang Hong
Procedure TMSNPopup.SetTitleFont(Value: TFont);
Begin
  If not (FTitleFont = Value) Then
    FTitleFont.Assign(Value);
End;

Procedure TMSNPopUp.SetIcon(Value: TBitmap);
Begin
  If Value <> Self.FIcon Then
   Begin
    Self.FIcon.Assign(Value);
   End;
End;

// function to find out system's default font
Function TMSNPopUp.GetCaptionFont: TFont;
Var
  ncMetrics: TNonClientMetrics;
Begin
  ncMetrics.cbSize := sizeof(TNonClientMetrics);
  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, sizeof(TNonClientMetrics), @ncMetrics, 0);

  Result        := TFont.Create;
  Result.Handle := CreateFontIndirect(ncMetrics.lfMenuFont);
End;

Constructor TMSNPopUp.Create(AOwner: TComponent);
Begin
  Inherited;

  FOptions := [msnAllowScroll, msnAllowHyperlink, msnAutoOpenURL, msnCascadePopups];

  FIcon      := TBitmap.Create;
  FFont      := TFont.Create;
  FHoverFont := TFont.Create;
  FTitleFont := TFont.Create;

  //Jelmer
  FBackground := TBitmap.Create();

  If msnSystemFont in FOptions Then
   Begin
    FFont.Name      := GetCaptionFont.Name;
    FHoverFont.Name := GetCaptionFont.Name;
    FTitleFont.Name := GetCaptionFont.Name;
   End;

  FWidth  := 148;
  FHeight := 121;

  FTimeOut     := 10;
  FScrollSpeed := 9;

  FIconLeft := 8;
  FIconTop  := 8;

  FText  := 'text';
  FURL   := 'http://www.url.com/';
  FTitle := 'title';

  FCursor := crDefault;

  FColor1 := $00FFCC99;
  FColor2 := $00FFFFFF;
  FGradientOrientation := mbVertical;

  FHoverFont.Style := [fsUnderline];
  FHoverFont.Color := clBlue;

  FTitleFont.Style := [fsBold];

  // Anomy
  FBackgroundDrawMethod := dmActualSize;
  FTextAlignment        := taLeftJustify;

  //Jelmer
  PopupCount   := 0;
  LastBorder   := 0;
  FPopupMarge  := 2;
  FPopupStartX := 16;
  FPopupStartY := 2;
  //---
End;

Destructor TMSNPopUp.Destroy;
Begin
  FIcon.Free;
  FFont.Free;
  FHoverFont.Free;
  FTitleFont.Free;

  //Jelmer
  FBackground.Free;

  Inherited;
End;

// form's functions

Procedure TfrmMSNPopUp.CreateParams(Var Params: TCreateParams);
Const
  CS_DROPSHADOW = $00020000;   // MS 12/01/2002
Begin
  Inherited;
  Params.Style := Params.Style and not WS_CAPTION or WS_POPUP;

  If IsNT4 Then
    Params.ExStyle := Params.ExStyle or WS_EX_TOOLWINDOW
  Else
    Params.ExStyle := Params.ExStyle or WS_EX_TOOLWINDOW or WS_EX_NOACTIVATE;

  If (IsWinXP) Then
    Params.WindowClass.Style := Params.WindowClass.Style or CS_DROPSHADOW;

  Params.WndParent := GetDesktopWindow;
End;

Constructor TfrmMSNPopUp.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
Begin
  Inherited;
  //BorderStyle := bsDialog;
  BorderStyle := bsNone;

  pnlBorder        := TPanel.Create(Self);
  pnlBorder.Parent := Self;
  pnlBorder.Align  := alClient;
  pnlBorder.BevelWidth := 1;
  pnlBorder.BevelOuter := bvLowered;

  imgGradient           := TImage.Create(Self);
  imgGradient.Parent    := pnlBorder;
  imgGradient.Align     := alClient;
  imgGradient.Anchors   := [akTop, akLeft, akRight, akBottom];
  imgGradient.OnMouseUp := Self.imgGradientMouseUp;

  imgIcon           := TImage.Create(Self);
  imgIcon.Parent    := pnlBorder;
  imgIcon.Left      := 3;
  imgIcon.Top       := 8;
  imgIcon.OnMouseUp := Self.imgIconMouseUp;

  lblText           := TMouseLabel.Create(Self);
  lblText.ShowAccelChar := False;
  lblText.Layout    := tlCenter;
  lblText.AutoSize  := True;
  lblText.WordWrap  := True;
  lblText.Parent    := pnlBorder;
  lblText.Transparent := True;
  lblText.OnMouseEnter := Self.lblTextMouseEnter;
  lblText.OnMouseLeave := Self.lblTextMouseLeave;
  lblText.OnClick   := Self.lblTextClick;
  lblText.OnMouseUp := Self.lblTextMouseUp;
  lblText.Left      := 9;
  lblText.Top       := 49;
  lblText.Width     := 3;
  lblText.Height    := 13;

  lblTitle           := TMouseLabel.Create(Self);
  lblTitle.ShowAccelChar := False;
  lblTitle.Parent    := pnlBorder;
  lblTitle.Transparent := True;
  lblTitle.Top       := 8;
  lblTitle.Left      := 48;
  lblTitle.OnMouseUp := Self.lblTitleMouseUp;

  tmrExit          := TTimer.Create(Self);
  tmrExit.Enabled  := False;
  tmrExit.OnTimer  := tmrExitTimer;
  tmrExit.Interval := 10000;

  tmrScroll          := TTimer.Create(Self);
  tmrScroll.Enabled  := False;
  tmrScroll.OnTimer  := tmrScrollTimer;
  tmrScroll.Interval := 25;
  // add by Ahmed Hamed 20-3-2002
  tmrScrollDown          := TTimer.Create(Self);
  tmrScrollDown.Enabled  := False;
  tmrScrollDown.OnTimer  := tmrScrollDownTimer;
  tmrScrollDown.Interval := 25;
  //
End;

Function TMSNPopup.GetEdge: Integer;
Var
  AppBar: TAppbarData;
Begin
  Result := -1;

  FillChar(AppBar, sizeof(AppBar), 0);
  AppBar.cbSize := Sizeof(AppBar);

  If ShAppBarMessage(ABM_GETTASKBARPOS, AppBar) <> 0 Then
   Begin
    If ((AppBar.rc.top = AppBar.rc.left) and (AppBar.rc.bottom > AppBar.rc.right)) Then
      Result := ABE_LEFT
    Else If ((AppBar.rc.top = AppBar.rc.left) and (AppBar.rc.bottom < AppBar.rc.right)) Then
      Result := ABE_TOP
    Else If (AppBar.rc.top > AppBar.rc.left) Then
      Result := ABE_BOTTOM
    Else
      Result := ABE_RIGHT;
   End;
End;

Procedure TfrmMSNPopUp.PopUp;
Var
  r: TRect;
  gradient: TBitmap;
  i: Integer;
  tileX, tileY: Integer;
  //Jelmer
  OldLeft, OldTop: Integer;
Begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @r, 0);

  Self.AutoScroll := False;

  Self.Height := sHeight;
  Self.Width  := sWidth;

  lblText.Cursor := Cursor;

  //Jelmer
  StoredBorder := ParentMSNPopup.GetEdge;
  CanClose     := True;

  Case StoredBorder Of
    ABE_LEFT:
       Begin
        Self.Left := r.Left + ParentMSNPopup.PopupStartX;

        //Jelmer
        Self.Top := r.Bottom - ParentMSNPopup.PopupStartY - Self.Height - ParentMSNPopup.NextPopupPos;
       End;

    ABE_TOP:
       Begin
        Self.Left := r.Right - Self.Width - ParentMSNPopup.PopupStartX;

        //Jelmer
        Self.Top := r.Top + ParentMSNPopup.PopupStartY + ParentMSNPopup.NextPopupPos;
       End;

    ABE_BOTTOM:
       Begin
        Self.Left := r.Right - Self.Width - ParentMSNPopup.PopupStartX;

        //Jelmer
        Self.Top := r.Bottom - ParentMSNPopup.PopupStartY - Self.Height - ParentMSNPopup.NextPopupPos;
       End;

    ABE_RIGHT:
       Begin
        Self.Left := r.Right - Self.Width - ParentMSNPopup.PopupStartX;

        //Jelmer
        Self.Top := r.Bottom - ParentMSNPopup.PopupStartY - Self.Height - ParentMSNPopup.NextPopupPos;
       End;
   End;

  //Jelmer
  PopupPos := ParentMSNPopup.NextPopupPos;
  If msnCascadePopups in ParentMSNPopup.FOptions = True Then
   Begin
    If (StoredBorder = ABE_BOTTOM) or (StoredBorder = ABE_TOP) Then
     Begin
      ParentMSNPopup.NextPopupPos := ParentMSNPopup.NextPopupPos + sHeight + ParentMSNPopup.FPopupMarge;
     End
    Else If (StoredBorder = ABE_RIGHT) or (StoredBorder = ABE_LEFT) Then
     Begin
      ParentMSNPopup.NextPopupPos := ParentMSNPopup.NextPopupPos + sHeight + ParentMSNPopup.FPopupMarge;
     End;
   End
  Else
    ParentMSNPopup.NextPopupPos := 0;

  lblTitle.Font    := TitleFont;
  lblTitle.Caption := Title;

  //Jelmer
  OldLeft := Left;
  OldTop  := Top;
  Left    := -Width - 10;
  Top     := -Height - 10;
  Visible := True;
  Visible := False;
  Left    := OldLeft;
  Top     := OldTop;

  imgGradient.Align := alClient;
  imgGradient.Align := alNone;
  pnlBorder.Align   := alNone;

  //Jelmer
  If Self.ParentMSNPopup.FBackground.Empty Then
   Begin
    gradient        := TBitmap.Create;
    gradient.Width  := imgGradient.Width;
    gradient.Height := imgGradient.Height;

    If Orientation = mbVertical Then
     Begin
      For i := 0 To gradient.Height Do
       Begin
        gradient.Canvas.Pen.Color := CalcColorIndex(Color1, Color2, gradient.Height + 1, i + 1);
        gradient.Canvas.MoveTo(0,i);
        gradient.Canvas.LineTo(gradient.Width, i);
       End;
     End;

    If Orientation = mbHorizontal Then
     Begin
      For i := 0 To gradient.Width Do
       Begin
        gradient.Canvas.Pen.Color := CalcColorIndex(Color1, Color2, gradient.Height + 1, i + 1);
        gradient.Canvas.MoveTo(i, 0);
        gradient.Canvas.LineTo(i, gradient.Height);
       End;
     End;

    imgGradient.Canvas.Draw(0,0,gradient);
    gradient.Free;
   End
  Else
   Begin
    //Jelmer
    //imgGradient.Canvas.
    ParentMSNPopup.FBackground.Transparent := True;

    // Anomy
    Case BGDrawMethod Of
      dmActualSize:
        imgGradient.Canvas.Draw(0, 0, ParentMSNPopup.BackgroundImage);
      dmTile:
         Begin
          tileX := 0;
          While tileX < imgGradient.Width Do
           Begin
            application.ProcessMessages;
            tileY := 0;
            While tileY < imgGradient.Height Do
             Begin
              application.ProcessMessages;
              imgGradient.Canvas.Draw(tileX, tileY, ParentMSNPopup.BackgroundImage);
              tileY := tileY + ParentMSNPopup.BackgroundImage.Height;
             End;
            tileX := tileX + ParentMSNPopup.BackgroundImage.Width;
           End;
         End;
      dmFit:
        imgGradient.Canvas.StretchDraw(Bounds(0,0,imgGradient.Width,
          imgGradient.Height),
          ParentMSNPopup.BackgroundImage
          );
     End;
   End;

  If ParentMSNPopUp.IconBitmap.Empty = False Then
   Begin
    //imgIcon.Picture.Icon := Icon;
    ParentMSNPopup.IconBitmap.Transparent := True;
    imgGradient.Canvas.Draw(ParentMSNPopUp.IconLeft, ParentMSNPopUp.IconTop,
      ParentMSNPopUp.IconBitmap);
   End
  Else
    lblTitle.Left := 8;

  tmrExit.Interval := TimeOut * 1000;

  If bScroll Then
   Begin
    Case ParentMSNPopup.GetEdge Of
      ABE_TOP:
         Begin
          Self.Height := 1;
         End;

      ABE_BOTTOM:
         Begin
          Self.Top    := Self.Top + Self.Height;
          Self.Height := 1;
         End;

      ABE_LEFT:
         Begin
          Self.Width := 1;
         End;

      ABE_RIGHT:
         Begin
          Self.Left  := Self.Left + Self.Width;
          Self.Width := 1;
         End;
     End;
    tmrScroll.Enabled := True;
   End;

  If not bScroll Then
    tmrExit.Enabled := True;

  Self.FormStyle := fsStayOnTop;
  ShowWindow(Self.Handle, SW_SHOWNOACTIVATE);
  Self.Visible := True;

  lblText.Font := HoverFont;
  PositionText;

  lblText.Font := Font;
  PositionText;
End;

Procedure TfrmMSNPopUp.lblTextMouseEnter(Sender: TObject);
Begin
  // when mouse cursor enters the url area,
  // the text is made blue & underlined
  If bHyperlink Then
   Begin
    lblText.Font := HoverFont;
    PositionText;
   End;
End;

Procedure TfrmMSNPopUp.lblTextMouseLeave(Sender: TObject);
Begin
  // when mouse cursor leaves the url area,
  // style of text is normal again
  If bHyperlink Then
   Begin
    lblText.Font := Font;
    PositionText;
   End;
End;

Procedure TfrmMSNPopUp.PositionText;
Begin
  lblText.Caption := Text;
  lblText.Width   := pnlBorder.Width - 15;

  lblText.Left := Round((pnlBorder.Width - lblText.Width) / 2);
  //lblText.Top  := Round((pnlBorder.Height - lblText.Height) / 2);
  lblText.Top  := Round((pnlBorder.Height - lblText.Height) - 5);
End;

Function TfrmMSNPopUp.CalcColorIndex(StartColor, EndColor: TColor; Steps, ColorIndex: Integer): TColor;
Var
  BeginRGBValue: Array[0..2] Of Byte;
  RGBDifference: Array[0..2] Of Integer;
  Red, Green, Blue: Byte;
  NumColors: Integer;
Begin
  // Initialize
  NumColors := Steps;
  Dec(ColorIndex);

  // Values are set
  BeginRGBValue[0] := GetRValue(ColorToRGB(StartColor));
  BeginRGBValue[1] := GetGValue(ColorToRGB(StartColor));
  BeginRGBValue[2] := GetBValue(ColorToRGB(StartColor));
  RGBDifference[0] := GetRValue(ColorToRGB(EndColor)) - BeginRGBValue[0];
  RGBDifference[1] := GetGValue(ColorToRGB(EndColor)) - BeginRGBValue[1];
  RGBDifference[2] := GetBValue(ColorToRGB(EndColor)) - BeginRGBValue[2];

  // Calculate the bands color
  Red   := BeginRGBValue[0] + MulDiv(ColorIndex, RGBDifference[0], NumColors - 1);
  Green := BeginRGBValue[1] + MulDiv(ColorIndex, RGBDifference[1], NumColors - 1);
  Blue  := BeginRGBValue[2] + MulDiv(ColorIndex, RGBDifference[2], NumColors - 1);

  // The final color is returned
  Result := RGB(Red, Green, Blue);
End;

Procedure TfrmMSNPopUp.lblTextClick(Sender: TObject);
Begin
  // when user clicks the hyperlink, and the Hyperlink
  // property is true, a browser window opens
  //Jelmer
  CanClose := False;
  If bHyperlink Then
   Begin
    If Assigned(ParentMSNPopup.FOnURLClick) Then
      ParentMSNPopup.FOnURLClick(Self, URL);
    If msnAutoOpenURL in ParentMSNPopup.FOptions = True Then
      ShellExecute(0, nil, PChar(URL), nil, nil, SW_SHOWDEFAULT);
   End
  Else If Assigned(ParentMSNPopup.FOnClick) Then
    ParentMSNPopup.FOnClick(Self);
  CanClose := True;
  Close;
End;

Procedure TfrmMSNPopUp.tmrExitTimer(Sender: TObject);
Begin
  // after several seconds, the popup window will disappear
  // add by Ahmed Hamed 20-3-2002
  tmrExit.Enabled       := False;
  tmrScrollDown.Enabled := True;
  //
End;

// add by Ahmed Hamed 20-3-2002
Procedure TfrmMSNPopUp.tmrScrollDownTimer(Sender: TObject);
Var
  r: TRect;
Begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @r, 0);

  Case StoredBorder Of
    ABE_LEFT:
       Begin
        If (Self.Width - Scrollspeed) > 0 Then
         Begin
          Self.Width := Self.Width - ScrollSpeed;
         End
        Else
          Self.Close;
       End;

    ABE_TOP:
       Begin
        If (Self.Height - ScrollSpeed) > 0 Then
         Begin
          Self.Height := Self.Height - ScrollSpeed;
         End
        Else
          Self.Close;
       End;

    ABE_BOTTOM:
       Begin
        If (Self.Height - ScrollSpeed) > 0 Then
         Begin
          Self.Top    := Self.Top + ScrollSpeed;
          Self.Height := Self.Height - ScrollSpeed;
         End
        Else
          Self.Close;
       End;

    ABE_RIGHT:
       Begin
        If (Self.Width - ScrollSpeed) > 0 Then
         Begin
          Self.Left  := Self.Left + ScrollSpeed;
          Self.Width := Self.Width - ScrollSpeed;
         End
        Else
          Self.Close;
       End;
   End;
End;
//

Procedure TfrmMSNPopUp.lblTextMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  // close the popup window on right click
  //Jelmer
  If Button = mbRight Then
   Begin
    If Assigned(Self.ParentMSNPopup.FOnClick) Then
     Begin
      CanClose := False;
      Self.ParentMSNPopup.FOnClick(Self.ParentMSNPopup);
      CanClose := True;
     End;
    Self.Close;
   End;
End;

Procedure TfrmMSNPopUp.tmrScrollTimer(Sender: TObject);
Var
  r: TRect;
Begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @r, 0);

  Case StoredBorder Of
    ABE_LEFT:
       Begin
        If (Self.Width + Scrollspeed) < sWidth Then
         Begin
          Self.Width := Self.Width + ScrollSpeed;
         End
        Else
         Begin
          Self.Width        := sWidth;
          tmrScroll.Enabled := False;
          tmrExit.Enabled   := True;
         End;
       End;

    ABE_TOP:
       Begin
        If (Self.Height + ScrollSpeed) < sHeight Then
         Begin
          Self.Height := Self.Height + ScrollSpeed;
         End
        Else
         Begin
          Self.Height       := sHeight;
          tmrScroll.Enabled := False;
          tmrExit.Enabled   := True;
         End;
       End;

    ABE_BOTTOM:
       Begin
        If (Self.Height + ScrollSpeed) < sHeight Then
         Begin
          Self.Top    := Self.Top - ScrollSpeed;
          Self.Height := Self.Height + ScrollSpeed;
         End
        Else
         Begin
          Self.Height := sHeight;

          //Jelmer
          Self.Top := r.Bottom - ParentMSNPopup.PopupStartY - Self.Height - Self.PopupPos;

          tmrScroll.Enabled := False;
          tmrExit.Enabled   := True;
         End;
       End;

    ABE_RIGHT:
       Begin
        If (Self.Width + ScrollSpeed) < sWidth Then
         Begin
          Self.Left  := Self.Left - ScrollSpeed;
          Self.Width := Self.Width + ScrollSpeed;
         End
        Else
         Begin
          Self.Width := sWidth;

          //Jelmer
          Self.Left := r.Right - ParentMSNPopup.PopupStartX - Self.Width;

          tmrScroll.Enabled := False;
          tmrExit.Enabled   := True;
         End;
       End;
   End;
End;

Procedure TfrmMSNPopUp.imgIconMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  // close the popup window on click
  //Jelmer
  If Assigned(Self.ParentMSNPopup.FOnClick) Then
   Begin
    CanClose := False;
    Self.ParentMSNPopup.FOnClick(Self.ParentMSNPopup);
    CanClose := True;
   End;
  Self.Close;
End;

Procedure TfrmMSNPopUp.imgGradientMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  // close the popup window on click
  //Jelmer
  If Assigned(Self.ParentMSNPopup.FOnClick) Then
   Begin
    CanClose := False;
    Self.ParentMSNPopup.FOnClick(Self.ParentMSNPopup);
    CanClose := True;
   End;
  Self.Close;
End;

Procedure TfrmMSNPopUp.lblTitleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Begin
  // close the popup window on click
  //Jelmer
  If Assigned(Self.ParentMSNPopup.FOnClick) Then
   Begin
    CanClose := False;
    Self.ParentMSNPopup.FOnClick(Self.ParentMSNPopup);
    CanClose := True;
   End;
  Self.Close;
End;

Procedure TfrmMSNPopUp.DoClose(Var Action: TCloseAction);
Begin
  //Jelmer
  If CanClose = False Then
   Begin
    Action := caHide;
   End
  Else
   Begin
    If ParentMSNPopup.PopupCount > 0 Then
      Dec(ParentMSNPopup.PopupCount);
    Action := caFree;
   End;
  Inherited;
End;

Procedure TMSNPopUp.SetBackground(Value: TBitmap);
Begin
  If Value <> Self.FBackground Then
   Begin
    Self.FBackground.Assign(Value);
   End;
End;

Function TfrmMSNPopUp.IsWinXP: Boolean;     // MS 12/01/2002
Begin
  Result := (Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion >= 5) and (Win32MinorVersion >= 1);
End;

End.
