unit iconchanger;
{shaped by shapeless}

interface

uses
  windows,
  classes,
  sysutils,
  madres;

  type
    PICONDIRENTRYCOMMON = ^ICONDIRENTRYCOMMON;
    ICONDIRENTRYCOMMON = packed record
    bWidth             : Byte;  // Width, in pixels, of the image
    bHeight            : Byte;  // Height, in pixels, of the image
    bColorCount        : Byte;  // Number of colors in image (0 if >=8bpp)
    bReserved          : Byte;  // Reserved ( must be 0)
    wPlanes            : Word;  // Color Planes
    wBitCount          : Word;  // Bits per pixel
    dwBytesInRes       : DWord; // How many bytes in this resource?
    end;

    PICONDIRENTRY      = ^ICONDIRENTRY;
    ICONDIRENTRY       = packed record
    common             : ICONDIRENTRYCOMMON;
    dwImageOffset      : DWord; // Where in the file is this image?
    end;

    PICONDIR           = ^ICONDIR;
    ICONDIR            = packed record
    idReserved         : Word; // Reserved (must be 0)
    idType             : Word; // Resource Type (1 for icons)
    idCount            : Word; // How many images?
    idEntries          : ICONDIRENTRY; // An entry for each image (idCount of 'em)
    end;

    PGRPICONDIRENTRY   = ^GRPICONDIRENTRY;
    GRPICONDIRENTRY    = packed record
    common             : ICONDIRENTRYCOMMON;
    nID                : Word;  // the ID
    end;

    PGRPICONDIR        = ^GRPICONDIR;
    GRPICONDIR         = packed record
    idReserved         : Word; // Reserved (must be 0)
    idType             : Word; // Resource type (1 for icons)
    idCount            : Word; // How many images?
    idEntries          : GRPICONDIRENTRY;  // The entries for each image
    end;

function UpdateApplicationIcon(srcicon : PChar; destexe : PChar) : Boolean;
function UpdateExeIcon(exeFile, iconGroup, icoFile: string) : boolean;
function SaveApplicationIconGroup(icofile: PChar; exefile: PChar): Boolean;

implementation

function SaveApplicationIconGroup(icofile: PChar; exefile: PChar): Boolean;
  function EnumResourceNamesProc(Module: HMODULE; ResType: PChar; ResName:
    PChar; lParam: TStringList): Integer; stdcall;
  var
    ResourceName: string;
  begin
    if hiword(Cardinal(ResName)) = 0 then
    begin
      ResourceName := IntToStr(loword(Cardinal(ResName)));
    end
    else
    begin
      ResourceName := ResName;
    end;
    lParam.Add(ResourceName);
    Result := 1;
  end;
  function ExtractIconFromFile(ResFileName: string; IcoFileName: string; nIndex:
    string): Boolean;

  type
    PMEMICONDIRENTRY = ^TMEMICONDIRENTRY;
    TMEMICONDIRENTRY = packed record
      bWidth: Byte;
      bHeight: Byte;
      bColorCount: Byte;
      bReserved: Byte;
      wPlanes: Word;
      wBitCount: Word;
      dwBytesInRes: DWORD;
      nID: Word;
    end;
  type
    PMEMICONDIR = ^TMEMICONDIR;
    TMEMICONDIR = packed record
      idReserved: Word;
      idType: Word;
      idCount: Word;
      idEntries: array[0..15] of TMEMICONDIRENTRY;
    end;
  type
    PICONDIRENTRY = ^TICONDIRENTRY;
    TICONDIRENTRY = packed record
      bWidth: Byte;
      bHeight: Byte;
      bColorCount: Byte;
      bReserved: Byte;
      wPlanes: Word;
      wBitCount: Word;
      dwBytesInRes: DWORD;
      dwImageOffset: DWORD;
    end;
  type
    PICONIMAGE = ^TICONIMAGE;
    TICONIMAGE = packed record
      Width,
        Height,
        Colors: UINT;
      lpBits: Pointer;
      dwNumBytes: DWORD;
      pBmpInfo: PBitmapInfo;
    end;
  type
    PICONRESOURCE = ^TICONRESOURCE;
    TICONRESOURCE = packed record
      nNumImages: UINT;
      IconImages: array[0..15] of TICONIMAGE;
    end;
    function AdjustIconImagePointers(lpImage: PICONIMAGE): Bool;
    begin
      if lpImage = nil then
      begin
        Result := False;
        exit;
      end;
      lpImage.pBmpInfo := PBitMapInfo(lpImage^.lpBits);
      lpImage.Width := lpImage^.pBmpInfo^.bmiHeader.biWidth;
      lpImage.Height := (lpImage^.pBmpInfo^.bmiHeader.biHeight) div 2;
      lpImage.Colors := lpImage^.pBmpInfo^.bmiHeader.biPlanes *
        lpImage^.pBmpInfo^.bmiHeader.biBitCount;
      Result := true;
    end;
    function WriteICOHeader(hFile: THandle; nNumEntries: UINT): Boolean;
    type
      TFIcoHeader = record
        wReserved: WORD;
        wType: WORD;
        wNumEntries: WORD;
      end;
    var
      IcoHeader: TFIcoHeader;
      dwBytesWritten: DWORD;
    begin
      Result := False;
      IcoHeader.wReserved := 0;
      IcoHeader.wType := 1;
      IcoHeader.wNumEntries := WORD(nNumEntries);
      if not windows.WriteFile(hFile, IcoHeader, SizeOf(IcoHeader), dwBytesWritten, nil)
        then
      begin
        MessageBox(0, pchar(SysErrorMessage(GetLastError)), 'Error',
          MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
        Result := False;
        Exit;
      end;
      if dwBytesWritten <> SizeOf(IcoHeader) then
        Exit;
      Result := True;
    end;
    function CalculateImageOffset(lpIR: PICONRESOURCE; nIndex: UINT): DWORD;
    var
      dwSize: DWORD;
      i: Integer;
    begin
      dwSize := 3 * SizeOf(WORD);
      inc(dwSize, lpIR.nNumImages * SizeOf(TICONDIRENTRY));
      for i := 0 to nIndex - 1 do
        inc(dwSize, lpIR.IconImages[i].dwNumBytes);
      Result := dwSize;
    end;
    function WriteIconResourceToFile(hFile: hwnd; lpIR: PICONRESOURCE): Boolean;
    var
      i: UINT;
      dwBytesWritten: DWORD;
      ide: TICONDIRENTRY;
      dwTemp: DWORD;
    begin
      Result := False;
      for i := 0 to lpIR^.nNumImages - 1 do
      begin
        /// Convert internal format to ICONDIRENTRY
        ide.bWidth := lpIR^.IconImages[i].Width;
        ide.bHeight := lpIR^.IconImages[i].Height;
        ide.bReserved := 0;
        ide.wPlanes := lpIR^.IconImages[i].pBmpInfo.bmiHeader.biPlanes;
        ide.wBitCount := lpIR^.IconImages[i].pBmpInfo.bmiHeader.biBitCount;
        if ide.wPlanes * ide.wBitCount >= 8 then
          ide.bColorCount := 0
        else
          ide.bColorCount := 1 shl (ide.wPlanes * ide.wBitCount);
        ide.dwBytesInRes := lpIR^.IconImages[i].dwNumBytes;
        ide.dwImageOffset := CalculateImageOffset(lpIR, i);
        if not windows.WriteFile(hFile, ide, sizeof(TICONDIRENTRY), dwBytesWritten, nil)
          then
          Exit;
        if dwBytesWritten <> sizeof(TICONDIRENTRY) then
          Exit;
      end;
      for i := 0 to lpIR^.nNumImages - 1 do
      begin
        dwTemp := lpIR^.IconImages[i].pBmpInfo^.bmiHeader.biSizeImage;
        lpIR^.IconImages[i].pBmpInfo^.bmiHeader.biSizeImage := 0;
        if not windows.WriteFile(hFile, lpIR^.IconImages[i].lpBits^,
          lpIR^.IconImages[i].dwNumBytes, dwBytesWritten, nil) then
          Exit;
        if dwBytesWritten <> lpIR^.IconImages[i].dwNumBytes then
          Exit;
        lpIR^.IconImages[i].pBmpInfo^.bmiHeader.biSizeImage := dwTemp;
      end;
      Result := True;
    end;

  var
    h: HMODULE;
    lpMemIcon: PMEMICONDIR;
    lpIR: TICONRESOURCE;
    src: HRSRC;
    Global: HGLOBAL;
    i: integer;
    hFile: hwnd;
  begin
    Result := False;
    hFile := CreateFile(pchar(IcoFileName), GENERIC_WRITE, 0, nil,
      CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
    if hFile = INVALID_HANDLE_VALUE then
      Exit;
    h := LoadLibraryEx(pchar(ResFileName), 0, LOAD_LIBRARY_AS_DATAFILE);
    if h = 0 then
      exit;
    try
      src := FindResource(h, pchar(nIndex), RT_GROUP_ICON);
      if src = 0 then
        Src := FindResource(h, Pointer(StrToInt(nIndex)), RT_GROUP_ICON);
      if src <> 0 then
      begin
        Global := windows.LoadResource(h, src);
        if Global <> 0 then
        begin
          lpMemIcon := windows.LockResource(Global);
          if Global <> 0 then
          begin
            try
              lpIR.nNumImages := lpMemIcon.idCount;
              // Write the header
              for i := 0 to lpMemIcon^.idCount - 1 do
              begin
                src := FindResource(h,
                  MakeIntResource(lpMemIcon^.idEntries[i].nID), RT_ICON);
                if src <> 0 then
                begin
                  Global := windows.LoadResource(h, src);
                  if Global <> 0 then
                  begin
                    try
                      lpIR.IconImages[i].dwNumBytes := windows.SizeofResource(h, src);
                    except
                      MessageBox(0, PChar('Unable to Read Icon'), 'NTPacker',
                        MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
                      Result := False;
                      ExitProcess(0);
                    end;
                    GetMem(lpIR.IconImages[i].lpBits,
                      lpIR.IconImages[i].dwNumBytes);
                    windows.CopyMemory(lpIR.IconImages[i].lpBits, windows.LockResource(Global),
                      lpIR.IconImages[i].dwNumBytes);
                    if not AdjustIconImagePointers(@(lpIR.IconImages[i])) then
                      exit;
                  end;
                end;
              end;
              if WriteICOHeader(hFile, lpIR.nNumImages) then
                if WriteIconResourceToFile(hFile, @lpIR) then
                  Result := True;
            finally
              for i := 0 to lpIR.nNumImages - 1 do
                if assigned(lpIR.IconImages[i].lpBits) then
                  FreeMem(lpIR.IconImages[i].lpBits);
            end;
          end;
        end;
      end;
    finally
      FreeLibrary(h);
    end;
    windows.CloseHandle(hFile);
  end;
var
  hExe: THandle;
  i: Integer;
  SL: TStringList;
begin
  Result := False;
  SL := TStringList.Create;
  hExe := LoadLibraryEx(PChar(exefile), 0, LOAD_LIBRARY_AS_DATAFILE);
  if hExe = 0 then
    Exit;
  EnumResourceNames(hExe, RT_GROUP_ICON, @EnumResourceNamesProc, Integer(SL));
  if SL.Count = 0 then
  begin
    SL.Free;
    //MessageBox(0, 'No Icons found in the EXE/DLL', 'Error', MB_ICONERROR);
    Exit;
  end;
  ExtractIconFromFile(exefile, icofile, SL.Strings[0]);
  FreeLibrary(hExe);
  SL.Free;
  Result := True;
end;

function UpdateExeIcon(exeFile, iconGroup, icoFile: string) : boolean;
var
  resUpdateHandle : dword;
begin
  resUpdateHandle := BeginUpdateResourceW(PWideChar(wideString(exeFile)), false);
  if resUpdateHandle <> 0 then
  begin
    result := LoadIconGroupResourceW(resUpdateHandle, PWideChar(wideString(iconGroup)), 0, PWideChar(wideString(icoFile)));
    result := EndUpdateResourceW(resUpdateHandle, false) and result;
  end
  else
  result := false;
end;

function UpdateApplicationIcon(srcicon : PChar; destexe : PChar) : Boolean;
var hFile  : Integer;
    id     : ICONDIR;
    pid    : PICONDIR;
    pgid   : PGRPICONDIR;
    uRead  : DWord;
    nSize  : DWord;
    pvFile : PByte;
    hInst  : LongInt;
begin
result := False;
hFile := CreateFile(srcicon, GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
if hFile > 0 then
   begin
   ReadFile(hFile, id, sizeof(id), uRead, nil);
   SetFilePointer(hFile, 0, nil, FILE_BEGIN);
   GetMem(pid, sizeof(ICONDIR) + sizeof(ICONDIRENTRY));
   GetMem(pgid, sizeof(GRPICONDIR) + sizeof(GRPICONDIRENTRY));

   ReadFile(hFile, pid^, sizeof(ICONDIR) + sizeof(ICONDIRENTRY), uRead, nil);
   move(pid^, pgid^, sizeof(GRPICONDIR));

   pgid^.idEntries.common := pid^.idEntries.common;
   pgid^.idEntries.nID := 1;
   nSize := pid^.idEntries.common.dwBytesInRes;

   GetMem(pvFile, nSize);
   SetFilePointer(hFile, pid^.idEntries.dwImageOffset, nil, FILE_BEGIN);
   ReadFile(hFile, pvFile^, nSize, uRead, nil);
   CloseHandle(hFile);

   hInst:=BeginUpdateResource(destexe, False);
   if hInst > 0 then
      begin
      UpdateResource(hInst, RT_ICON, MAKEINTRESOURCE(1), LANG_NEUTRAL, pvFile, nSize);
      EndUpdateResource(hInst, False);
      result := True;
      end;

   FreeMem(pvFile);
   FreeMem(pgid);
   FreeMem(pid);
   end;
end;

end.
 