unit UnitClipboard;

interface

Uses
  windows,
  shellapi,
  UnitConstantes;

function GetClipboardFiles(var Resultado: widestring): Boolean;
function GetClipboardText(Wnd: HWND; var Resultado: widestring): Boolean;
procedure SetClipboardText(const S: wideString);

implementation

function GetClipboardFiles(var Resultado: widestring): Boolean;
var
  f: THandle;
  buffer: Array [0..MAX_PATH * 2] of WideChar;
  i, numFiles: Integer;
begin
  Result := FALSE;
  Resultado := '';
  OpenClipboard(0);
  try
    f := GetClipboardData(CF_HDROP);
    If f <> 0 then
    begin
      numFiles := DragQueryFileW(f, $FFFFFFFF, nil, 0);
      Resultado := '';
      for i:= 0 to numfiles - 1 do
      begin
        buffer[0] := #0;
        DragQueryFileW(f, i, buffer, sizeof(buffer));
        Resultado := Resultado + widestring(buffer) + delimitadorComandos;
      end;
      Result := TRUE;
    end;
    finally
    CloseClipboard;
  end;
end;

function AllocMem(Size: Cardinal): Pointer;
begin
  GetMem(Result, Size);
  FillChar(Result^, Size, 0);
end;
function GetClipboardText(Wnd: HWND; var Resultado: widestring): Boolean;
var
  hData: HGlobal;
  Arr: array of WideChar;
  p: pointer;
  i: int64;
begin
  Result := True;
  Resultado := '';
  if OpenClipboard(Wnd) then
  begin
    try
      hData := GetClipboardData(CF_UNICODETEXT{CF_TEXT});
      if hData <> 0 then
      begin
        try
          p := GlobalLock(hData);
          i := GlobalSize(hData);
          setlength(Arr, i);
          CopyMemory(@Arr[0], p, i);
          Resultado := WideString(Arr);
        finally
          GlobalUnlock(hData);
        end;
      end
      else
        Result := False;
    finally
      CloseClipboard;
    end;
  end
  else
    Result := False;
end;

procedure SetClipboardText(Const S: widestring);
var
  Data: THandle;
  DataPtr: Pointer;
  Size: integer;
begin
  Size := length(S);
  OpenClipboard(0);
  try
    Data := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, (Size * 2) + 2);
    try
      DataPtr := GlobalLock(Data);
      try
        Move(S[1], DataPtr^, Size * 2);
        SetClipboardData(CF_UNICODETEXT{CF_TEXT}, Data);
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
      raise;
    end;
  finally
    CloseClipboard;
  end;
end;

end.
