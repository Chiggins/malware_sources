//*****************************************//
// Carlo Pasolini                          //
// http://pasotech.altervista.org          //
// email: cdpasop@hotmail.it               //
//*****************************************//
unit uUtils;

interface

function DumpData(Buffer: Pointer; BufLen: Cardinal): String;
function PidProcesso(NomeProcesso: string): Cardinal;

implementation

uses
  Windows, TlHelp32, uDecls;



(*function FileTimeToDateTime(const FileTime: FILETIME): TDateTime;
const
  FileTimeBase = -109205.0;
  FileTimeStep: Extended = 24.0 * 60.0 * 60.0 * 1000.0 * 1000.0 * 10.0; // 100 nSek per Day
begin
  Result := Int64(FileTime) / FileTimeStep;
  Result := Result + FileTimeBase;
end;*)

function IntToHex(dwValue, dwDigits: Cardinal): String; stdcall;
const
  hex: array[0..$F] of char = ('0','1','2','3','4','5','6','7',
                               '8','9','A','B','C','D','E','F');
begin
  if (dwDigits > 8) then
    dwDigits := 8;
  Result := Copy(
       hex[(dwValue and $F0000000) shr 28]+
       hex[(dwValue and $0F000000) shr 24]+
       hex[(dwValue and $00F00000) shr 20]+
       hex[(dwValue and $000F0000) shr 16]+
       hex[(dwValue and $0000F000) shr 12]+
       hex[(dwValue and $00000F00) shr 8]+
       hex[(dwValue and $000000F0) shr 4]+
       hex[(dwValue and $0000000F) shr 0],9-dwDigits,dwDigits);
end;

function ConvertDataToAscii(Buffer: pointer; Length: Word): string;
var
  Iterator: integer;
  AsciiBuffer: string;
begin
  AsciiBuffer := '';
  for Iterator := 0 to Length - 1 do
    begin
      if char(pointer(integer(Buffer) + Iterator)^) in [#32..#127] then
        AsciiBuffer := AsciiBuffer + '' + char(pointer(integer(Buffer) + Iterator)^) + ''
      else
        AsciiBuffer := AsciiBuffer + '.';
    end;
  Result := AsciiBuffer;
end;

function ConvertDataToHex(Buffer: pointer; Length: Word): string;
var
  Iterator: integer;
  HexBuffer: string;
begin
  HexBuffer := '';
  for Iterator := 0 to Length - 1 do
    begin
      HexBuffer := HexBuffer + IntToHex(Ord(char(pointer(integer(Buffer) + Iterator)^)), 2) + ' ';
    end;
  Result := HexBuffer;
end;

{function DumpData(Buffer: Pointer; BufLen: Cardinal): String;
var
  i, j, c: Integer;
begin
  c := 0;
  Result := '';
  for i := 1 to BufLen div 16 do //vado a blocchi di 16 alla volta
    begin
      Result := Result + IntToHex((i-1)*16, 4) + '     ' + ConvertDataToHex(Pointer(Integer(Buffer) + c), 16) + '     ';
      Result := Result + ConvertDataToAscii(Pointer(Integer(Buffer) + c), 16) + #13#10;
      c := c + 16;
    end;
  if BufLen mod 16 <> 0 then
    begin
      Result := Result + IntToHex((i-1)*16, 4) + '     ' +  ConvertDataToHex(Pointer(Integer(Buffer) + Integer(BufLen) - (BufLen mod 16)), (BufLen mod 16));
      for j := ((BufLen mod 16) + 1) to 16 do
        begin
          Result := Result + '  ' + ' ';
        end;
      Result := Result +  '     ';
      Result := Result + ConvertDataToAscii(Pointer(Integer(Buffer) + Integer(BufLen) - (BufLen mod 16)), (BufLen mod 16));
    end;
end; }

function DumpData(Buffer: Pointer; BufLen: DWord): String; 
var 
  i, j, c: Integer; 
begin 
  c := 0; 
Result := ''; 
  for i := 1 to BufLen div 16 do begin 
    for j := c to c + 15 do 
      if (PByte(Integer(Buffer) + j)^ < $20) or (PByte(Integer(Buffer) + j)^ > $FA) then 
        Result := Result 
      else 
        Result := Result + PChar(Integer(Buffer) + j)^; 
    c := c + 16; 
  end; 
  if BufLen mod 16 <> 0 then begin 
    for i := BufLen mod 16 downto 1 do begin 
      if (PByte(Integer(Buffer) + Integer(BufLen) - i)^ < $20) or (PByte(Integer(Buffer) + Integer(BufLen) - i)^ > $FA) then 
        Result := Result 
      else 
        Result := Result + PChar(Integer(Buffer) + Integer(BufLen) - i)^;
        end;
  end;
end;




function PidProcesso(NomeProcesso: string): Cardinal;
var
  pe: TProcessEntry32;
  hSnap: THandle;
  n1,n2: string;
begin
  Result := 0;

  hSnap := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);

  pe.dwSize := sizeof(TProcessEntry32);

  //Prelevo informazioni sul primo processo nello snapshot di sistema
  Process32First(hSnap, pe);
  repeat  //loop sui processi
    //messagebox(0,pchar(CharUpper(pe.szExeFile) + #13#10 + CharUpper(pchar(NomeProcesso))),'',0);
    n1 := CharUpper(pe.szExeFile);
    n2 := CharUpper(pchar(NomeProcesso));
    if n1 = n2 then
      begin
        Result := pe.th32ProcessID;
        break;
      end;
  until (not (Process32Next(hSnap, pe)) ) ;

  CloseHandle(hSnap);

end;


end.
