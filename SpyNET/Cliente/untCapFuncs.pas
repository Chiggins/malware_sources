unit untCapFuncs;

interface

uses
  windows,
  jpeg,
  gr32,
  Graphics,
  classes,
  sysutils,
  Zlib;


procedure CompressStream(inpStream, outStream: TMemoryStream);
procedure DecompressStream(inpStream, outStream: TMemoryStream);
procedure TakeCapture(quality, Tox, Toy: integer; Bmp: TBitmap; var ResultStream: TMemoryStream);
procedure ScreenCapture(var res: TBitmap);
procedure GetDesktopImage(Quality, Tox, Toy: integer; var S: TMemoryStream);
procedure SaveAndScaleScreen(quality, Tox, Toy: integer; Bmp: TBitmap; var StreamToSave: TMemoryStream);
function JPGtoBMP(InFilename, OutFileName: string): boolean;

var
  TheCapture: TMemoryStream = nil;

implementation

procedure CompressStream(inpStream, outStream: TMemoryStream);
var
  InpBuf, OutBuf: Pointer;
  InpBytes, OutBytes: Integer;
begin
  InpBuf := nil;
  OutBuf := nil;
  try
    GetMem(InpBuf, inpStream.Size);
    inpStream.Position := 0;
    InpBytes := inpStream.Read(InpBuf^, inpStream.Size);
    CompressBuf(InpBuf, InpBytes, OutBuf, OutBytes);
    outStream.Write(OutBuf^, OutBytes);
  finally
    if InpBuf <> nil then FreeMem(InpBuf);
    if OutBuf <> nil then FreeMem(OutBuf);
  end;
end;

{ Decompress a stream }
procedure DecompressStream(inpStream, outStream: TMemoryStream);
var
  InpBuf, OutBuf: Pointer;
  OutBytes, sz: Integer;
begin
  InpBuf := nil;
  OutBuf := nil;
  sz     := inpStream.Size - inpStream.Position;
  if sz > 0 then 
    try
      GetMem(InpBuf, sz);
      inpStream.Read(InpBuf^, sz);
      DecompressBuf(InpBuf, sz, 0, OutBuf, OutBytes);
      outStream.Write(OutBuf^, OutBytes);
    finally
      if InpBuf <> nil then FreeMem(InpBuf);
      if OutBuf <> nil then FreeMem(OutBuf);
    end;
  outStream.Position := 0;
end;

procedure ScreenCapture(var res: TBitmap);
// this function captures the screen
var
  ScreenDC: HDC;
  ARect:TRect;
begin
  ARect := Rect(0, 0, GetSystemMetrics(SM_CXSCREEN),GetSystemMetrics(SM_CYSCREEN));
  res.Width := ARect.Right - ARect.Left;
  res.Height := ARect.Bottom - ARect.Top;
  ScreenDC := GetDC(0);
  try
    BitBlt(res.Canvas.Handle, 0, 0, res.Width, res.Height, ScreenDC, ARect.Left, ARect.Top, SRCCOPY );
    finally
    ReleaseDC(0, ScreenDC );
  end;
end;

procedure SaveAndScaleScreen(quality, Tox, Toy: integer; Bmp: TBitmap; var StreamToSave: TMemoryStream);
var
  tempstream: TmemoryStream;
  BitmapImage, Resized: TBitmap32;
  ARect, DRect: TRect;
  JPEGImage: TJPEGImage;
begin
  tempstream := TmemoryStream.Create;
  BitmapImage := TBitmap32.Create;
  Resized := TBitmap32.Create;
  JPEGImage := TJPEGImage.Create;

  try
    Bmp.SaveToStream(tempstream);
    tempstream.Position := 0;

    BitmapImage.LoadFromStream(tempStream);
    tempstream.Position := 0;

    Arect := Rect(0, 0, BitmapImage.Width, BitmapImage.Height);
    Resized.Width := Tox;
    Resized.Height := Toy;
    Drect:= Rect(0, 0, Tox, Toy);

    BitmapImage.StretchFilter := sfLinear;
    Resized.StretchFilter := sfLinear;

    BitmapImage.DrawTo(Resized, Drect, Arect);

    Resized.SaveToStream(tempstream);
    tempstream.Position := 0;
    Bmp.LoadFromStream(tempstream);

    //Resized bitmap stored in "Bmp"

    JPEGImage.CompressionQuality := quality;
    JPEGImage.Assign(Bmp);
    JPEGImage.SaveToStream(StreamToSave);

    Finally
    JPEGImage.Free;
    BitmapImage.Free;
    Resized.Free;
    tempstream.Free;
  end;
end;

procedure TakeCapture(quality, Tox, Toy: integer; Bmp: TBitmap; var ResultStream: TMemoryStream);
begin
  try
    TheCapture.Free;
    except on exception do;
  end;
  SaveAndScaleScreen(quality, Tox, Toy, Bmp, ResultStream);
  ResultStream.Position := 0;
end;

procedure GetDesktopImage(Quality, Tox, Toy: integer; var S: TMemoryStream);
var
  bmp: TBitmap;
  Stream: TMemoryStream;
begin
  Bmp := TBitmap.Create;
  Stream := TMemoryStream.Create;
  Stream.Clear;
  ScreenCapture(Bmp);
  TakeCapture(Quality, Tox, Toy, Bmp, Stream);
  s.Clear;
  s.Position := 0;
  S.CopyFrom(Stream, Stream.Size);
  Stream.Free;
  Bmp.Free;
end;

function JPGtoBMP(InFilename, OutFileName: string): boolean;
var
  j: TJpegImage;
  b: TBitmap;
begin
  result := false;
  j := TJpegImage.Create;
  b := TBitmap.Create;
  try
    j.LoadFromFile(InFilename);
    b.Assign(j);
    j.Free;
    b.SaveToFile(OutFileName);
    b.Free;
    except
    begin
      result := false;
      exit;
    end;
  end;
  Result := true;
end;

end.
