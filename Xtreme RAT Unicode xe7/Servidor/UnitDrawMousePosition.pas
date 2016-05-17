unit UnitDrawMousePosition;

interface

uses
  windows,

  Classes,
  vcl.Graphics;

procedure DrawCursor(ScreenShot: HBitmap; var Result: TMemoryStream);

implementation

function SaveBitmapToStream(Stream: TMemoryStream; HBM: HBitmap): Integer;
const
  BMType = $4D42;
type
  TBitmap = record
    bmType: Integer;
    bmWidth: Integer;
    bmHeight: Integer;
    bmWidthBytes: Integer;
    bmPlanes: Byte;
    bmBitsPixel: Byte;
    bmBits: Pointer;
  end;
var
  BM: TBitmap;
  BFH: TBitmapFileHeader;
  BIP: PBitmapInfo;
  DC: HDC;
  HMem: THandle;
  Buf: Pointer;
  ColorSize, DataSize: Longint;
  BitCount: word;

  function AlignDouble(Size: Longint): Longint;
  begin
    Result := (Size + 31) div 32 * 4;
  end;

begin
  Result := 0;
  if GetObject(HBM, SizeOf(TBitmap), @BM) = 0 then Exit;
  BitCount := 32;
  if (BitCount <> 24) then
    ColorSize := SizeOf(TRGBQuad) * (1 shl BitCount)
  else
    ColorSize := 0;
  DataSize := AlignDouble(bm.bmWidth * BitCount) * bm.bmHeight;
  GetMem(BIP, SizeOf(TBitmapInfoHeader) + ColorSize);
  if BIP <> nil then
    begin
      with BIP^.bmiHeader do
        begin
          biSize := SizeOf(TBitmapInfoHeader);
          biWidth := bm.bmWidth;
          biHeight := bm.bmHeight;
          biPlanes := 1;
          biBitCount := BitCount;
          biCompression := 0;
          biSizeImage := DataSize;
          biXPelsPerMeter := 0;
          biYPelsPerMeter := 0;
          biClrUsed := 0;
          biClrImportant := 0;
        end;
      with BFH do
        begin
          bfOffBits := SizeOf(BFH) + SizeOf(TBitmapInfo) + ColorSize;
          bfReserved1 := 0;
          bfReserved2 := 0;
          bfSize := longint(bfOffBits) + DataSize;
          bfType := BMType;
        end;
      HMem := GlobalAlloc(gmem_Fixed, DataSize);
      if HMem <> 0 then
        begin
          Buf := GlobalLock(HMem);
          DC := GetDC(0);
          if GetDIBits(DC, hbm, 0, bm.bmHeight,
            Buf, BIP^, dib_RGB_Colors) <> 0 then
          begin
            Stream.WriteBuffer(BFH, SizeOf(BFH));
            Stream.WriteBuffer(PWideChar(BIP)^, SizeOf(TBitmapInfo) + ColorSize);
            Stream.WriteBuffer(Buf^, DataSize);
            Result := 1;
          end;
          ReleaseDC(0, DC);
          GlobalUnlock(HMem);
          GlobalFree(HMem);
        end;
    end;
  FreeMem(BIP, SizeOf(TBitmapInfoHeader) + ColorSize);
  DeleteObject(HBM);
end;

procedure DrawCursor(ScreenShot: HBitmap; var Result: TMemoryStream);
var
  r: TRect;
  CI: TCursorInfo;
  Icon: TIcon;
  II: TIconInfo;
  ScreenShotBitmap: TBitmap;
  MS: TMemoryStream;
  TempStr: WideString;
begin
  MS := TMemoryStream.Create;
  SaveBitmapToStream(MS, ScreenShot);
  MS.Position := 0;

  ScreenShotBitmap := TBitmap.Create;
  ScreenShotBitmap.LoadFromStream(MS);

  MS.Free;

  r := ScreenShotBitmap.Canvas.ClipRect;
  Icon := TIcon.Create;
  try
    CI.cbSize := SizeOf(CI);
    if GetCursorInfo(CI) then
      if CI.Flags = CURSOR_SHOWING then
      begin
        Icon.Handle := CopyIcon(CI.hCursor);
        if GetIconInfo(Icon.Handle, II) then
        begin
          ScreenShotBitmap.Canvas.Draw(
                ci.ptScreenPos.x - Integer(II.xHotspot) - r.Left,
                ci.ptScreenPos.y - Integer(II.yHotspot) - r.Top,
                Icon
                );
        end;
      end;
  finally
    Icon.Free;
  end;

  MS := TMemoryStream.Create;
  ScreenShotBitmap.SaveToStream(MS);
  ScreenShotBitmap.Free;

  SetLength(TempStr, MS.Size div 2);
  MS.Position := 0;
  MS.Read(TempStr[1], MS.Size);

  Result.Position := 0;
  Result.Write(TempStr[1], MS.Size);

  MS.Free;
  TempStr := '';  
end;

end.