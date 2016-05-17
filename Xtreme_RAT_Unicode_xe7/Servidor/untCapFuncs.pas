unit untCapFuncs;

interface

uses
  windows,
  UnitFuncoesDiversas,
  UnitCompressString,
  GDIPAPI,
  GDIPOBJ,
  GDIPUTIL,
  ClassesMOD,
  ActiveX,
  Classes;


procedure TakeCapture(quality, Tox, Toy: integer; BmpStream: TMemoryStream; var ResultStream: TMemoryStream);
procedure ScreenCapture(var Stream: TMemoryStream; Janela: THandle = 0);
procedure SaveAndScaleScreen(quality, Tox, Toy: integer; BmpStream: TMemoryStream; var StreamToSave: TMemoryStream);
function GetDesktopImage(Quality, Tox, Toy: integer): Widestring;
function GetWindowImage(Janela: THandle; Quality, Tox, Toy: integer): Widestring;

function JPGtoBMP(InFilename, OutFileName: Widestring): boolean;
procedure ConvertImageToBMPStream(OriginalFile: Widestring; var BMPStream: TMemoryStream);
function BMPFiletoJPGString(InFilename: Widestring; Quality: integer): Widestring;

function GetAnyImageToString(FileName: Widestring; Quality, Tox, Toy: integer): Widestring;
procedure SaveAnyImageToBMPFile(FileNameIn: Widestring; var FileNameOut: Widestring);


var
  TheCapture: TMemoryStream = nil;

implementation

uses
  GlobalVars,
  UnitDrawMousePosition; // Somente para colocar o mouse na captura do desktop.

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

function GetBitmapFromWindow(Window: HWND): HBitmap;
var
  DC, MemDC: HDC;
  Bitmap, OBitmap: HBitmap;
  BitmapWidth, BitmapHeight: integer;
  Rect: TRect;
begin
  if Window = 0 then Window := GetDeskTopWindow;
  DC := GetDC(Window);
  MemDC := CreateCompatibleDC(DC);
  if Window <> 0 then
  begin
    GetClientRect(Window, Rect);
    BitmapWidth := Rect.Right - Rect.Left;
    BitmapHeight := Rect.Bottom - Rect.Top;
  end
  else
  begin
    BitmapWidth := GetDeviceCaps(DC, 8);
    BitmapHeight := GetDeviceCaps(DC, 10);
  end;
  Bitmap := CreateCompatibleBitmap(DC, BitmapWidth, BitmapHeight);
  OBitmap := SelectObject(MemDC, Bitmap);
  BitBlt(MemDC, 0, 0, BitmapWidth, BitmapHeight, DC, 0, 0, SRCCOPY);
  SelectObject(MemDC, OBitmap);
  DeleteDC(MemDC);
  ReleaseDC(Window, DC);
  Result := Bitmap;
end;

procedure ScreenCapture(var Stream: TMemoryStream; Janela: THandle = 0);
begin
  Stream.Clear;
  Stream.Position := 0;
  if Janela = 0 then Janela := GetDeskTopWindow;

  if ShowMouseDesktop = True then
  DrawCursor(GetBitMapFromWindow(Janela), Stream) else
  SaveBitmapToStream(Stream, GetBitMapFromWindow(Janela));
end;

type
TResizeMode = (rmDefault, rmNearest, rmBilinear, rmBicubic);

function ResizeImage(var bmp: TGPBitmap; width, Height: integer; mode: TResizeMode): Boolean;
var
  gr: TGPGraphics;
  buf: TGPBitmap;
begin
  buf := TGPBitmap.Create(Width, Height, bmp.GetPixelFormat);
  gr := TGPGraphics.Create(buf);
  case mode of
    rmDefault: ;
    rmNearest:  gr.SetInterpolationMode(InterpolationModeNearestNeighbor);
    rmBilinear: gr.SetInterpolationMode(InterpolationModeHighQualityBilinear);
    rmBicubic:  gr.SetInterpolationMode(InterpolationModeHighQualityBicubic);
  end;
  result := gr.DrawImage(bmp, 0, 0, Width, Height) = Ok;
  gr.Free;
  bmp.Free;
  bmp := buf;
end;

procedure SaveAndScaleScreen(quality, Tox, Toy: integer; BmpStream: TMemoryStream; var StreamToSave: TMemoryStream);
var
  encoderClsid: TGUID;
  encoderParameters: TEncoderParameters;
  Image: TGPBitmap;
  tmpstr: widestring;
  xIs: IStream;
  yIs: IStream;
begin
   yIS := TStreamAdapter.Create(BmpStream, soReference);
   Image := TGPBitmap.Create(yIs);

   ResizeImage(Image, Tox, Toy, rmDefault);
   GetEncoderClsid('image/jpeg', encoderClsid);
   encoderParameters.Count := 1;
   encoderParameters.Parameter[0].Guid := EncoderQuality;
   encoderParameters.Parameter[0].Type_ := EncoderParameterValueTypeLong;
   encoderParameters.Parameter[0].NumberOfValues := 1;
   encoderParameters.Parameter[0].Value := @quality;

   StreamToSave.Clear;
   StreamToSave.Position := 0;

   xIS := TStreamAdapter.Create(StreamToSave, soReference);
   image.Save(xIS, encoderClsid, @encoderParameters);
   //StreamToSave.SaveToFile('Teste3.jpg');

   image.Free;
end;

procedure TakeCapture(quality, Tox, Toy: integer; BmpStream: TMemoryStream; var ResultStream: TMemoryStream);
begin
  BmpStream.Position := 0;
  ResultStream.Position := 0;
  SaveAndScaleScreen(quality, Tox, Toy, BmpStream, ResultStream);
  ResultStream.Position := 0;
end;

function GetDesktopImage(Quality, Tox, Toy: integer): Widestring;
var
  bmpStream: TMemoryStream;
  Stream: TmemoryStream;
begin
  result := '';
  try
  bmpStream := TmemoryStream.Create;
  Stream := TmemoryStream.Create;
  screencapture(bmpStream);
  bmpStream.position := 0;
  TakeCapture(Quality, Tox, Toy, bmpStream, Stream);
  Stream.Position := 0;
  //Stream.SaveToFile('teste3.jpg');
  Result := StreamToStr(Stream);
  finally
  Stream.Free;
  bmpStream.Free;
  end;

end;

function GetWindowImage(Janela: THandle; Quality, Tox, Toy: integer): Widestring;
var
  bmpStream: TMemoryStream;
  Stream: TmemoryStream;
begin
  result := '';
  try
  bmpStream := TmemoryStream.Create;
  Stream := TmemoryStream.Create;
  screencapture(bmpStream, Janela);
  bmpStream.position := 0;
  TakeCapture(Quality, Tox, Toy, bmpStream, Stream);
  Stream.Position := 0;
  //Stream.SaveToFile('teste3.jpg');
  Result := StreamToStr(Stream);
  finally
   Stream.Free;
  bmpStream.Free;
  end;

end;

procedure ConvertImageToBMPStream(OriginalFile: Widestring; var BMPStream: TMemoryStream);
var
  encoderClsid: TGUID;
  transformation: TEncoderValue;
  Image: TGPBitmap;
  xIs: IStream;
begin
  Image := TGPBitmap.Create(pwidechar(OriginalFile));
  GetEncoderClsid('image/bmp', encoderClsid);
  xIS := TStreamAdapter.Create(BMPStream, soReference);
  image.Save(xIS, encoderClsid);
  image.Free;
end;

function GetAnyImageToString(FileName: Widestring; Quality, Tox, Toy: integer): Widestring;
var
  Stream: TMemoryStream;
  BmpStream: TMemoryStream;
begin
  result := '';
    try
  Stream := TMemoryStream.Create;
  BmpStream := TMemoryStream.Create;

  ConvertImageToBMPStream(FileName, BmpStream);
  BmpStream.Position := 0;

  TakeCapture(Quality, Tox, Toy, BmpStream, Stream);
  Stream.Position := 0;
  Result := StreamToStr(Stream);


    finally
      BmpStream.Free;
  Stream.Free;
    end;
end;

procedure SaveAnyImageToBMPFile(FileNameIn: Widestring; var FileNameOut: Widestring);
var
  Stream: TMemoryStream;
begin
try
  Stream := TMemoryStream.Create;
  ConvertImageToBMPStream(FileNameIn, Stream);
  Stream.Position := 0;
  FileNameOut := MyTempFolder + inttostr(gettickcount) + '.bmp';
  deleteFileW(Pwidechar(FileNameOut));
  Stream.SaveToFile(FileNameOut);
finally
 Stream.Free;
end;

end;

function JPGtoBMP(InFilename, OutFileName: WideString): boolean;
var
  encoderClsid: TGUID;
  transformation: TEncoderValue;
  Image: TGPBitmap;
  xIs: IStream;
  BMPStream: TMemoryStream;
begin
  result := false;
  BMPStream := TmemoryStream.Create;
  Image := TGPBitmap.Create(pWidechar(InFilename));
  if GetEncoderClsid('image/bmp', encoderClsid) = - 1 then
  begin
    BMPStream.Free;
    exit;
  end;
  xIS := TStreamAdapter.Create(BMPStream, soReference);
  image.Save(xIS, encoderClsid);
  image.Free;
  BMPStream.Position := 0;
  BMPStream.SaveToFile(OutFileName);
  BMPStream.Free;
end;

function BMPFiletoJPGString(InFilename: WideString; Quality: integer): WideString;
var
  encoderParameters: TEncoderParameters;
  encoderClsid: TGUID;
  transformation: TEncoderValue;
  Image: TGPBitmap;
  xIs: IStream;
  BMPStream: TMemoryStream;
begin
  BMPStream := TmemoryStream.Create;
  Image := TGPBitmap.Create(pwidechar(InFilename));
  GetEncoderClsid('image/jpeg', encoderClsid);

  encoderParameters.Count := 1;
  encoderParameters.Parameter[0].Guid := EncoderQuality;
  encoderParameters.Parameter[0].Type_ := EncoderParameterValueTypeLong;
  encoderParameters.Parameter[0].NumberOfValues := 1;
  encoderParameters.Parameter[0].Value := @quality;

  xIS := TStreamAdapter.Create(BMPStream, soReference);
  image.Save(xIS, encoderClsid, @encoderParameters);
  image.Free;
  BMPStream.Position := 0;
  result := streamtostr(BMPStream);
  BMPStream.Free;
end;

end.
