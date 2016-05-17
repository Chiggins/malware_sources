unit UnitClipBoard;

interface

Uses
  windows,
  funcoesdiversasCliente;

function GetClipboardFiles(var FileList: String): Boolean;
function GetClipboardText(Wnd: HWND; var Str: string): Boolean;
procedure SetClipboardText(const S: String);

implementation

type
  HDROP = Longint;
  PPWideChar = ^PWideChar;

type TFileList = Array of String;

function GetClipboardFiles(var FileList: String): Boolean;
var
  f: THandle;
  buffer: Array [0..MAX_PATH] of Char;
  i, numFiles: Integer;
begin
  Result:=FALSE;
  OpenClipboard(0);
  try
    f := GetClipboardData(CF_HDROP);
    If f <> 0 then
    begin
      numFiles := MyDragQueryFile(f, $FFFFFFFF, nil, 0);
      FileList := '';
      for i:= 0 to numfiles - 1 do
      begin
        buffer[0] := #0;
        myDragQueryFile( f, i, buffer, sizeof(buffer));
        FileList := FileList + string(buffer) + '|';
      end;
      Result:=TRUE;
    end;
    finally
    CloseClipboard;
  end;
end;

function GetClipboardText(Wnd: HWND; var Str: string): Boolean;
var
  hData: HGlobal;
begin
  Result := True;
  if OpenClipboard(Wnd) then
  begin
    try
      hData := GetClipboardData(CF_TEXT);
      if hData <> 0 then
      begin
        try
          SetString(Str, PChar(GlobalLock(hData)), GlobalSize(hData));
        finally
          GlobalUnlock(hData);
        end;
      end
      else
        Result := False;
      Str := PChar(@Str[1]);
    finally
      CloseClipboard;
    end;
  end
  else
    Result := False;
end;

function AllocMem(Size: Cardinal): Pointer;
begin
  GetMem(Result, Size);
  FillChar(Result^, Size, 0);
end;

procedure SetClipboardText(const S: String);
var
  Data: THandle;
  DataPtr: Pointer;
  Size: Integer;
  WStr: PWideChar;
begin
  Size := Length(S) * 4;
  WStr := AllocMem(Size);
  try
    StringToWideChar(S, WStr, Size);
    OpenClipboard(0);
    EmptyClipboard;
    Data := GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE, Size);
    try
      DataPtr := GlobalLock(Data);
      try
        Move(WStr^, DataPtr^, Size);
        SetClipboardData(CF_UNICODETEXT, Data);
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
      raise;
    end;
  finally
    CloseClipboard;
    FreeMem(WStr);
  end;
end;

end.
