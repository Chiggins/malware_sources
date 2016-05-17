unit UnitClipboard;

interface

Uses
  windows,
  shellapi;

function GetClipboardFiles(var Resultado: string): Boolean;
function GetClipboardText(Wnd: HWND; var Resultado: string): Boolean;
procedure SetClipboardText(const S: String);

implementation

function GetClipboardFiles(var Resultado: string): Boolean;
var
  f: THandle;
  buffer: Array [0..MAX_PATH] of Char;
  i, numFiles: Integer;
begin
  Result := FALSE;
  Resultado := '';
  OpenClipboard(0);
  try
    f := GetClipboardData(CF_HDROP);
    If f <> 0 then
    begin
      numFiles := DragQueryFile(f, $FFFFFFFF, nil, 0);
      Resultado := '';
      for i:= 0 to numfiles - 1 do
      begin
        buffer[0] := #0;
        DragQueryFile(f, i, buffer, sizeof(buffer));
        Resultado := Resultado + string(buffer) + '|';
      end;
      Result := TRUE;
    end;
    finally
    CloseClipboard;
  end;
end;

function GetClipboardText(Wnd: HWND; var Resultado: string): Boolean;
var
  hData: HGlobal;
begin
  Result := True;
  Resultado := '';
  if OpenClipboard(Wnd) then
  begin
    try
      hData := GetClipboardData(CF_TEXT);
      if hData <> 0 then
      begin
        try
          SetString(Resultado, PChar(GlobalLock(hData)), GlobalSize(hData));
        finally
          GlobalUnlock(hData);
        end;
      end
      else
        Result := False;
      Resultado := PChar(@Resultado[1]);
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

procedure SetClipboardText(Const S: string);
var
  Data: THandle;
  DataPtr: Pointer;
  Size: integer;
begin
  Size := length(S);
  OpenClipboard(0);
  try
    Data := GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE, Size);
    try
      DataPtr := GlobalLock(Data);
      try
        Move(S[1], DataPtr^, Size);
        SetClipboardData(CF_TEXT, Data);
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
