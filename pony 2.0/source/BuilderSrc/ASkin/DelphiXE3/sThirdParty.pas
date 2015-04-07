unit sThirdParty;
{$I sDefs.inc}

interface

uses
  Messages, SysUtils, Classes, Windows, Graphics, Controls, Forms, Dialogs, ActnList, imglist, comctrls, StdCtrls, sCommonData, sConst, sBitBtn,
  sSpeedButton{$IFNDEF ALITE}, sToolBar{$ENDIF} {$IFDEF USEPNG}, PngImageList, PngFunctions, PngImage{$ENDIF};

var
  ThirdPartySkipForms: TStringList;
  InitDevEx: procedure (const Active : boolean);
  CheckDevEx: function (const Control : TControl) : boolean;
  RefreshDevEx: procedure;

function GetImageCount(ImgList : TCustomImageList) : integer;
procedure DrawBtnGlyph(Button : TControl; Canvas : TCanvas = nil);
{$IFNDEF ALITE}
procedure CopyToolBtnGlyph(ToolBar : TsToolBar; Button : TToolButton; State: TCustomDrawState; Stage: TCustomDrawStage; var Flags: TTBCustomDrawFlags; BtnBmp : TBitmap); overload;
procedure CopyToolBtnGlyph(ToolBar : TToolBar; Button : TToolButton; State: TCustomDrawState; Stage: TCustomDrawStage; var Flags: TTBCustomDrawFlags; BtnBmp : TBitmap); overload;
{$ELSE}
procedure CopyToolBtnGlyph(ToolBar : TToolBar; Button : TToolButton; State: TCustomDrawState; Stage: TCustomDrawStage; var Flags: TTBCustomDrawFlags; BtnBmp : TBitmap);
{$ENDIF}

implementation

uses sGraphUtils, acAlphaImageList, CommCtrl, acntUtils, acPNG, sButton, sAlphaGraph, math {$IFDEF DEVEX2011}, acLFPainter{$ENDIF}{$IFDEF DEVEX6}, acLFPainter6{$ENDIF} { // for projects which uses the DEVEX key};

function GetImageCount(ImgList : TCustomImageList) : integer;
begin
  Result := 0;
  if ImgList = nil then Exit;
{$IFDEF USEPNG}
  if ImgList is TPngImageList then begin
    Result := TPngImageList(ImgList).PngImages.Count;
  end
  else
{$ENDIF}
  if ImgList is TsVirtualImageList
    then Result := TsVirtualImageList(ImgList).Count
    else Result := ImgList.Count;
end;

procedure MakeMask32(const Bmp : TBitmap);
var
  MaskColor: TsColor;
  TransColor: TsColor;
  X, Y : integer;
begin
  TransColor.C := Bmp.Canvas.Pixels[0, Bmp.Height - 1];
  TransColor.A := MaxByte;
  for X := 0 to Bmp.Width - 1 do for Y := 0 to Bmp.Height - 1 do begin
    MaskColor := GetAPixel(Bmp, X, Y);
    if MaskColor.C <> TransColor.C then begin
      MaskColor.A := MaxByte;
      SetAPixel(Bmp, X, Y, MaskColor);
    end
    else SetAPixel(Bmp, X, Y, sFuchsia);
  end;
end;

procedure DrawBtnGlyph(Button : TControl; Canvas : TCanvas = nil);
var
  IRect : TRect;
  Bmp : TBitmap;
  MaskColor: TsColor;
  TmpPng : TPNGGraphic;

  Images : TCustomImageList;
  Glyph : TBitmap;
  ImageIndex, X, Y : integer;
  SkinData : TsCommonData;
  ImgRect : TRect;
  NumGlyphs : integer;
  Enabled : boolean;
  DisabledGlyphKind : TsDisabledGlyphKind;
  Blend : integer;
  Down : boolean;
  CurrentState : integer;
  Grayed, Reflected : boolean;
  GrayColor : TColor;
  SrcRect : TRect;
  SLine : PRGBAArray;
  b : boolean;
  nEvent : TNotifyEvent;
{$IFDEF USEPNG}
  PngCopy: TPNGObject;
{$ENDIF}
  procedure PrepareGlyph;
  begin
    Bmp.Width := Images.Width;
    Bmp.Height := Images.Height;
    Bmp.PixelFormat := pf32bit;
    if Images.BkColor <> clNone then MaskColor.C := Images.BkColor else MaskColor.C := clFuchsia;
    Bmp.Canvas.Brush.Color := MaskColor.C;
    Bmp.Canvas.FillRect(Rect(0, 0, Bmp.Width, Bmp.Height));
    Images.GetBitmap(ImageIndex, Bmp);
  end;
begin
  if Button is TsButton then begin
    Images     := TsButton(Button).Images;
    Glyph      := nil;
    ImageIndex := TsButton(Button).GlyphIndex;
    SkinData   := TsButton(Button).SkinData;
    ImgRect    := TsButton(Button).GlyphRect;
    NumGlyphs  := 1;
    Enabled    := TsButton(Button).Enabled;
    Blend      := 0;
    Down       := TsButton(Button).CurrentState = 2;
    Grayed     := False;
    CurrentState := TsButton(Button).CurrentState;
    DisabledGlyphKind := [dgBlended];//TsButton(Button).DisabledGlyphKind;
    Reflected := TsButton(Button).Reflected;
  end
  else if Button is TsBitBtn then begin
    Images     := TsBitBtn(Button).Images;
    Glyph      := TsBitBtn(Button).Glyph;
    ImageIndex := TsBitBtn(Button).ImageIndex;
    SkinData   := TsBitBtn(Button).SkinData;
    ImgRect    := TsBitBtn(Button).ImgRect;
    NumGlyphs  := TsBitBtn(Button).NumGlyphs;
    Enabled    := TsBitBtn(Button).Enabled;
    Blend      := TsBitBtn(Button).Blend;
    Down       := TsBitBtn(Button).Down;
    Grayed     := TsBitBtn(Button).Grayed;
    CurrentState := TsBitBtn(Button).CurrentState;
    DisabledGlyphKind := TsBitBtn(Button).DisabledGlyphKind;
    Reflected := TsBitBtn(Button).Reflected;
  end
  else if Button is TsSpeedButton then begin
    Images     := TsSpeedButton(Button).Images;
    Glyph      := TsSpeedButton(Button).Glyph;
    ImageIndex := TsSpeedButton(Button).ImageIndex;
    SkinData   := TsSpeedButton(Button).SkinData;
    ImgRect    := TsSpeedButton(Button).ImgRect;
    NumGlyphs  := TsSpeedButton(Button).NumGlyphs;
    Enabled    := TsSpeedButton(Button).Enabled;
    Blend      := TsSpeedButton(Button).Blend;
    Down       := TsSpeedButton(Button).Down;
    Grayed     := TsSpeedButton(Button).Grayed;
    CurrentState := TsSpeedButton(Button).CurrentState;
    DisabledGlyphKind := TsSpeedButton(Button).DisabledGlyphKind;
    Reflected := TsSpeedButton(Button).Reflected;
  end
  else Exit;
  if SkinData.Skinned
    then GrayColor := iffi(((CurrentState = 0) and Grayed) or (not Enabled and (dgGrayed in DisabledGlyphKind)), SkinData.SkinManager.gd[SkinData.SkinIndex].Color, clNone)
    else GrayColor := iffi(((CurrentState = 0) and Grayed) or (not Enabled and (dgGrayed in DisabledGlyphKind)), ColorToRGB(clBtnFace), clNone);

  if Canvas = nil then Canvas := SkinData.FCacheBmp.Canvas;

  if Assigned(Images) and (ImageIndex > -1) and (GetImageCount(Images) > ImageIndex) then begin
    IRect := ImgRect;
{$IFDEF USEPNG}
    if (Images is TPngImageList) and (TPngImageCollectionItem(TPngImageList(Images).PngImages.Items[ImageIndex]).PngImage <> nil) then begin
      PngCopy := nil;
      if Enabled then begin
        if ControlIsActive(SkinData) or ((Blend = 0) and not Grayed) then begin
          PngCopy := TPngImageCollectionItem(TPngImageList(Images).PngImages.Items[ImageIndex]).PngImage;
          if SkinData.Skinned
            then PngCopy.Draw(SkinData.FCacheBmp.Canvas, IRect)
            else PngCopy.Draw(Canvas, IRect);
        end
        else begin
          if Blend > 0 then begin
            PngCopy := TPNGObject.Create;
            PngCopy.Assign(TPngImageCollectionItem(TPngImageList(Images).PngImages.Items[ImageIndex]).PngImage);
            MakeImageBlended(PngCopy);
          end;
          if Grayed then begin
            if PngCopy = nil then begin
              PngCopy := TPNGObject.Create;
              PngCopy.Assign(TPngImageCollectionItem(TPngImageList(Images).PngImages.Items[ImageIndex]).PngImage);
            end;
            MakeImageGrayscale(PngCopy);
          end;
          if SkinData.Skinned
            then PngCopy.Draw(SkinData.FCacheBmp.Canvas, IRect)
            else PngCopy.Draw(Canvas, IRect);
          FreeAndNil(PngCopy);
        end;
      end
      else begin
        if dgBlended in DisabledGlyphKind then begin
          PngCopy := TPNGObject.Create;
          PngCopy.Assign(TPngImageCollectionItem(TPngImageList(Images).PngImages.Items[ImageIndex]).PngImage);
          MakeImageBlended(PngCopy);
        end;
        if dgGrayed in DisabledGlyphKind then begin
          if PngCopy = nil then begin
            PngCopy := TPNGObject.Create;
            PngCopy.Assign(TPngImageCollectionItem(TPngImageList(Images).PngImages.Items[ImageIndex]).PngImage);
          end;
          MakeImageGrayscale(PngCopy);
        end;
        if PngCopy = nil then begin
          PngCopy := TPngImageCollectionItem(TPngImageList(Images).PngImages.Items[ImageIndex]).PngImage;
          if SkinData.Skinned then PngCopy.Draw(SkinData.FCacheBmp.Canvas, IRect) else PngCopy.Draw(Canvas, IRect);
        end
        else begin
          if SkinData.Skinned then PngCopy.Draw(SkinData.FCacheBmp.Canvas, IRect) else PngCopy.Draw(Canvas, IRect);
          FreeAndNil(PngCopy);
        end;
      end;
    end
    else
{$ENDIF}
    if (Images is TsAlphaImageList) or (Images is TsVirtualImageList) then begin
      if SkinData.Skinned
        then DrawAlphaImgList(Images, SkinData.FCacheBmp, IRect.Left, IRect.Top, ImageIndex,
               max(iffi((CurrentState = 0), Blend, 0), iffi(not Enabled and (dgBlended in DisabledGlyphKind), 50, 0)), GrayColor,
               CurrentState + integer(Down), NumGlyphs, Reflected)
        else DrawAlphaImgListDC(Images, Canvas.Handle, IRect.Left, IRect.Top, ImageIndex,
               max(iffi((CurrentState = 0), Blend, 0), iffi(not Enabled and (dgBlended in DisabledGlyphKind), 50, 0)), GrayColor,
               CurrentState + integer(Down), NumGlyphs, Reflected);
    end
    else begin
      Bmp := TBitmap.Create;
      try
        PrepareGlyph;
        if SkinData.Skinned then begin
          if not Enabled then begin
            if dgGrayed in DisabledGlyphKind then GrayScaleTrans(Bmp, TsColor(Bmp.Canvas.Pixels[0, 0]));
            if dgBlended in DisabledGlyphKind
              then BlendTransRectangle(SkinData.FCacheBmp, IRect.Left, IRect.Top, Bmp, Rect(0, 0, Bmp.Width, Bmp.Height), 0.5)
              else CopyTransBitmaps(SkinData.FCacheBmp, Bmp, IRect.Left, IRect.Top, MaskColor);
          end
          else begin
            if not ControlIsActive(SkinData) and Grayed then GrayScaleTrans(Bmp, TsColor(Bmp.Canvas.Pixels[0, 0]));
            if not ControlIsActive(SkinData) and (Blend > 0)
              then BlendTransRectangle(SkinData.FCacheBmp, IRect.Left, IRect.Top, Bmp, Rect(0, 0, Bmp.Width, Bmp.Height), Blend / 100)
              else CopyTransBitmaps(SkinData.FCacheBmp, Bmp, IRect.Left, IRect.Top, MaskColor);
          end;
        end
        else begin
          Bmp.Transparent := True;
          Bmp.TransparentColor := clFuchsia;
          if not Enabled then begin
            if dgGrayed in DisabledGlyphKind then GrayScaleTrans(Bmp, TsColor(Bmp.Canvas.Pixels[0, 0]));
{            if dgBlended in DisabledGlyphKind
              then BlendTransRectangle(Bmp, IRect.Left, IRect.Top, Bmp, Rect(0, 0, Bmp.Width, Bmp.Height), 0.5, MaskColor)
              else CopyTransBitmaps(SkinData.FCacheBmp, Bmp, IRect.Left, IRect.Top, MaskColor);
}
          end;
          Canvas.Draw(IRect.Left, IRect.Top, Bmp);
        end;
      finally
        FreeAndNil(Bmp);
      end;
    end;
  end
  else if Assigned(Glyph) and not Glyph.Empty then begin
    if (Glyph.PixelFormat = pfDevice) or not Enabled or ac_CheckEmptyAlpha and (Glyph.PixelFormat = pf32bit) then begin
      nEvent := Glyph.OnChange;
      Glyph.OnChange := nil;
      Glyph.HandleType := bmDIB;
      if (Glyph.Handle <> 0) and (Glyph.PixelFormat = pf32bit) then begin // Checking for an empty alpha-channel
        b := False;
        for Y := 0 to Glyph.Height - 1 do begin
          SLine := Glyph.ScanLine[Y];
          for X := 0 to Glyph.Width - 1 do if SLine[X].A <> 0 then begin
            b := True;
            Break;
          end;
        end;
        if not b then Glyph.PixelFormat := pf24bit;
      end;
      Glyph.OnChange := nEvent;
    end;
    if (Glyph.PixelFormat = pf32bit) then begin // Patch if Png, don't work in std. mode
      SrcRect.Left := WidthOf(ImgRect) * min(CurrentState, NumGlyphs - 1);
      SrcRect.Top := 0;
      SrcRect.Right := SrcRect.Left + WidthOf(ImgRect);
      SrcRect.Bottom := Glyph.Height;

      if SkinData.FCacheBmp.Canvas = Canvas then begin
        Glyph.Handle;
        CopyBmp32(ImgRect, SrcRect, SkinData.FCacheBmp, Glyph, EmptyCI, False, GrayColor, iffi(CurrentState = 0, Blend, 0), Reflected);
      end
      else begin
        TmpPng := TPNGGraphic.Create;
        TmpPng.PixelFormat := pf32bit;
        TmpPng.Width := WidthOf(ImgRect);
        TmpPng.Height := HeightOf(ImgRect);
        BitBlt(TmpPng.Canvas.Handle, 0, 0, TmpPng.Width, Glyph.Height, Glyph.Canvas.Handle, SrcRect.Left, SrcRect.Top, SRCCOPY);
        TmpPng.Reflected := Reflected;

        if not Enabled and (dgBlended in DisabledGlyphKind) then Blend := max(50, Blend);

        if (CurrentState = 0) and (Blend <> 0) then begin
          for Y := 0 to TmpPng.Height - 1 do begin
            SLine := TmpPng.ScanLine[Y];
            for X := 0 to TmpPng.Width - 1 do SLine[X].A := (SLine[X].A * Blend) div 100;
          end;
        end;

        if (not Enabled and (dgGrayed in DisabledGlyphKind)) or ((CurrentState = 0) and Grayed) then GrayScale(TmpPng);

        if SkinData.FCacheBmp.Canvas = Canvas then SkinData.FCacheBmp.Canvas.Draw(ImgRect.Left, ImgRect.Top, TmpPng) else begin
          Bmp := CreateBmp32(Button.Width, Button.Height);
          BitBlt(Bmp.Canvas.Handle, 0, 0, Button.Width, Button.Height, Canvas.Handle, 0, 0, SRCCOPY);
          Bmp.Canvas.Draw(ImgRect.Left, ImgRect.Top, TmpPng);
          BitBlt(Canvas.Handle, 0, 0, Button.Width, Button.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
          FreeAndNil(Bmp);
        end;
        FreeAndNil(TmpPng);
      end;
    end
    else begin
      if Canvas <> SkinData.FCacheBmp.Canvas then begin
        Bmp := CreateBmp32(Button.Width, Button.Height);
        BitBlt(Bmp.Canvas.Handle, 0, 0, Button.Width, Button.Height, Canvas.Handle, 0, 0, SRCCOPY);

{        if Reflected then begin
          Glyph.PixelFormat := pf32bit;
          MakeMask32(Glyph);
          CopyBmp32(Classes.Rect(0, 0, Glyph.Width, Glyph.Height), Classes.Rect(0, 0, Glyph.Width, Glyph.Height), Bmp, Glyph, EmptyCI, False, clNone, 0, Reflected);
        end
        else}
        sGraphUtils.DrawGlyphEx(Glyph, Bmp, ImgRect, NumGlyphs, Enabled, DisabledGlyphKind, CurrentState, Blend, Down, Reflected);
        BitBlt(Canvas.Handle, 0, 0, Button.Width, Button.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
        FreeAndNil(Bmp);
      end
      else sGraphUtils.DrawGlyphEx(Glyph, SkinData.FCacheBmp, ImgRect, NumGlyphs, Enabled, DisabledGlyphKind, CurrentState, Blend, Down, Reflected);
    end;
  end
end;

{$IFNDEF ALITE}
procedure CopyToolBtnGlyph(ToolBar : TsToolBar; Button : TToolButton; State: TCustomDrawState; Stage: TCustomDrawStage; var Flags: TTBCustomDrawFlags; BtnBmp : TBitmap);
var
  IRect : TRect;
  Mode : integer;
  Bmp : TBitmap;
  MaskColor : TsColor;
{$IFDEF USEPNG}
  PngCopy: TPNGObject;
{$ENDIF}
  function AddedWidth : integer; begin
    Result := integer(Button.Style = tbsDropDown) * 8;
  end;
  function ImgRect : TRect;
  begin
    with ToolBar do begin
      if not List then begin
        Result.Left := (Button.Width - Images.Width) div 2 + 1 - AddedWidth;
        Result.Top := (Button.Height - Images.Height - integer(ShowCaptions) * (SkinData.FCacheBMP.Canvas.TextHeight('A') + 3)) div 2;
        Result.Right := Result.Left + Images.Width;
        Result.Bottom := Result.Top + Images.Height;
      end
      else begin
        Result.Left := 5;
        Result.Top := (Button.Height - Images.Height) div 2;
        Result.Right := Result.Left + Images.Width;
        Result.Bottom := Result.Top + Images.Height;
      end;
      if (Mode = 2) then OffsetRect(Result, 1, 1);
    end;
  end;
  function Imges : TCustomImageList; begin
    with ToolBar do begin
      if not Button.Enabled and Assigned(DisabledImages) then begin
        Result := DisabledImages;
      end
      else if (Mode <> 0) and Assigned(HotImages) and (Button.ImageIndex < GetImageCount(HotImages)) then begin
        Result := HotImages;
      end
      else Result := Images;
    end;
  end;
  procedure PrepareGlyph;
  begin
    Bmp.Width := Imges.Width;
    Bmp.Height := Imges.Height;
    Bmp.PixelFormat := pf32bit;
    if ToolBar.Images.BkColor <> clNone then MaskColor.C := ToolBar.Images.BkColor else MaskColor.C := clFuchsia;
    Bmp.Canvas.Brush.Color := MaskColor.C;
    Bmp.Canvas.FillRect(Rect(0, 0, Bmp.Width, Bmp.Height));
    Imges.GetBitmap(Button.ImageIndex, Bmp);
  end;
begin
  with ToolBar do begin
    if (State = []) or (State = [cdsDisabled]) then Mode := 0 else if (cdsSelected in State) or (cdsChecked in State) then Mode := 2 else Mode := 1;
    IRect := ImgRect;
{$IFDEF USEPNG}
    if Imges is TPngImageList then begin
      PngCopy := nil;
      if Enabled then begin
        PngCopy := TPngImageCollectionItem(TPngImageList(Imges).PngImages.Items[Button.ImageIndex]).PngImage;
        PngCopy.Draw(BtnBmp.Canvas, IRect);
      end
      else begin
        PngCopy := TPNGObject.Create;
        PngCopy.Assign(TPngImageCollectionItem(TPngImageList(Imges).PngImages.Items[Button.ImageIndex]).PngImage);
        MakeImageBlended(PngCopy);
        if PngCopy = nil then begin
          PngCopy := TPngImageCollectionItem(TPngImageList(Imges).PngImages.Items[Button.ImageIndex]).PngImage;
          PngCopy.Draw(BtnBmp.Canvas, IRect);
        end
        else begin
          PngCopy.Draw(BtnBmp.Canvas, IRect);
          FreeAndNil(PngCopy);
        end;
      end;
    end
    else
{$ENDIF}
    {if (Imges is TsAlphaImageList) or not SkinData.Skinned then }begin
      IRect := ImgRect;
      Imges.Draw(BtnBmp.Canvas, IRect.Left, IRect.Top, Button.ImageIndex)
{    end
    else if (Imges is TsVirtualImageList) or not SkinData.Skinned then begin
      IRect := ImgRect;
      Imges.Draw(BtnBmp.Canvas, IRect.Left, IRect.Top, Button.ImageIndex)
    end
    else begin
      Bmp := TBitmap.Create;
      try
        PrepareGlyph;
        CopyTransBitmaps(BtnBmp, Bmp, ImgRect.left, ImgRect.Top, MaskColor);
      finally
        FreeAndNil(Bmp);
      end;}
    end;
  end;
end;

{$ENDIF}

procedure CopyToolBtnGlyph(ToolBar : TToolBar; Button : TToolButton; State: TCustomDrawState; Stage: TCustomDrawStage; var Flags: TTBCustomDrawFlags; BtnBmp : TBitmap);
var
  IRect : TRect;
  Mode : integer;
  Bmp : TBitmap;
  MaskColor : TsColor;
  ImgList : TCustomImageList;
  function AddedWidth : integer; begin
    Result := integer(Button.Style = tbsDropDown) * 8;
  end;
  function ImgRect : TRect;
  begin
    with ToolBar do begin
      if not List then begin
        Result.Left := (Button.Width - Images.Width) div 2 + 1 - AddedWidth;
        Result.Top := (Button.Height - Images.Height - integer(ShowCaptions) * (BtnBmp.Canvas.TextHeight('A') + 3)) div 2;
        Result.Right := Result.Left + Images.Width;
        Result.Bottom := Result.Top + Images.Height;
      end
      else begin
        Result.Left := 5;
        Result.Top := (Button.Height - Images.Height) div 2;
        Result.Right := Result.Left + Images.Width;
        Result.Bottom := Result.Top + Images.Height;
      end;
      if (Mode = 2) //or (cdsChecked in State)
        then OffsetRect(Result, 1, 1);
    end;
  end;
  function GetImages : TCustomImageList; begin
    with ToolBar do
    if (Mode <> 0) and Assigned(HotImages) and (Button.ImageIndex < GetImageCount(HotImages)) then begin
      Result := HotImages;
    end
    else if not Button.Enabled and Assigned(DisabledImages)
      then Result := DisabledImages
      else Result := Images;
  end;
  procedure PrepareGlyph;
  begin
    Bmp.Width := ImgList.Width;
    Bmp.Height := ImgList.Height;
    Bmp.PixelFormat := pf32bit;
    if ToolBar.Images.BkColor <> clNone then MaskColor.C := ToolBar.Images.BkColor else MaskColor.C := clFuchsia;
    Bmp.Canvas.Brush.Color := MaskColor.C;
    Bmp.Canvas.FillRect(Rect(0, 0, Bmp.Width, Bmp.Height));
    ImgList.GetBitmap(Button.ImageIndex, Bmp);
  end;
begin
  with ToolBar do begin
    if (State = []) or (State = [cdsDisabled]) then Mode := 0 else if (cdsSelected in State) or (cdsChecked in State)
      then Mode := 2
      else Mode := 1;
    IRect := ImgRect;
    ImgList := GetImages;
{$IFDEF USEPNG}
    if ImgList is TPngImageList then begin
      TPngImageCollectionItem(TPngImageList(ImgList).PngImages.Items[Button.ImageIndex]).PngImage.Draw(BtnBmp.Canvas, IRect);
    end
    else
{$ENDIF}
    if ImgList is TsAlphaImageList then begin
      if (cdsHot in State) then Mode := 1 else if (cdsChecked in State) then Mode := 2 else Mode := 0;
      DrawAlphaImgList(ImgList, BtnBmp, IRect.Left, IRect.Top, Button.ImageIndex, 0, clNone, Mode, 1, False)
    end
    else if (ImgList is TsVirtualImageList) then begin
      if (cdsHot in State) then Mode := 1 else if (cdsChecked in State) then Mode := 2 else Mode := 0;
      DrawAlphaImgList(ImgList, BtnBmp, IRect.Left, IRect.Top, Button.ImageIndex, 0, clNone, Mode, 1, False)
    end
    else begin
      Bmp := TBitmap.Create;
      try
        PrepareGlyph;
        CopyTransBitmaps(BtnBmp, Bmp, IRect.left, IRect.Top, MaskColor);
      finally
        FreeAndNil(Bmp);
      end;
    end;
  end;
end;

initialization
  // Create a list of form types which will be excluded from skinning
  ThirdPartySkipForms := TStringList.Create;
  ThirdPartySkipForms.Sorted := True;
  ThirdPartySkipForms.Add('TApplication');
//  ThirdPartySkipForms.Add('TQRStandardPreview');
  ThirdPartySkipForms.Add('TfcPopup'); {FastCube popup}

finalization
  ThirdPartySkipForms.Free;

end.
