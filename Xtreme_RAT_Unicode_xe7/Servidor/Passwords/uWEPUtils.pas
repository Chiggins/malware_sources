//*****************************************//
// Carlo Pasolini                          //
// http://pasotech.altervista.org          //
// email: cdpasop@hotmail.it               //
//*****************************************//
//http://pasotech.altervista.org/delphi/articolo95.htm

unit uWEPUtils;

interface

uses
  Windows;//, Kol;

type
  TCallBackFunc = function(DataType: Cardinal; Data: Pointer; DataSize: Cardinal): Boolean;

function GetWZCSVCData(funz: TCallBackFunc): Boolean;

implementation

uses
  uUtils,
  uCodeInjection_RemoteUncrypt, uStrList;

const
  RegKeyStr = 'Software\Microsoft\WZCSVC\Parameters\Interfaces';
  PIPE_NAME = '\\.\pipe\wzcsvc_wep_keys';


function RegOpenKeyExA(
            hKey: Cardinal;
            lpSubKey: PAnsiChar;
            ulOptions: Cardinal;
            samDesired: Cardinal;
            var phkResult: Cardinal
            ): Integer; stdcall; external 'advapi32.dll' name 'RegOpenKeyExA';

function RegQueryInfoKeyA(
            hKey: Cardinal;
            lpClass: PAnsiChar;
            lpcbClass: PCardinal;
            lpReserved: Pointer;
            lpcSubKeys,
            lpcbMaxSubKeyLen,
            lpcbMaxClassLen,
            lpcValues,
            lpcbMaxValueNameLen,
            lpcbMaxValueLen,
            lpcbSecurityDescriptor: PCardinal;
            lpftLastWriteTime: Pointer
            ): Integer; stdcall; external 'advapi32.dll' name 'RegQueryInfoKeyA';

function RegEnumKeyExA(
            hKey: Cardinal;
            dwIndex: Cardinal;
            lpName: PAnsiChar;
            lpcbName: PCardinal;
            lpReserved: Pointer;
            lpClass: PAnsiChar;
            lpcbClass: PCardinal;
            lpftLastWriteTime: Pointer
            ): Integer; stdcall; external 'advapi32.dll' name 'RegEnumKeyExA';

function RegCloseKey(
            hKey: Cardinal
            ): Integer; stdcall; external 'advapi32.dll' name 'RegCloseKey';

function RegQueryValueExA(
             hKey: Cardinal;
             lpValueName: PAnsiChar;
             lpReserved: Pointer;
             lpType: PCardinal;
             lpData: PByte;
             lpcbData: PCardinal
             ): Integer; stdcall; external 'advapi32.dll' name 'RegQueryValueExA';
             
function RemoteCryptUnprotect(
               ProcName: PAnsiChar;
               NamedPipeName: PAnsiChar;
               pDataIn: Pointer;
               DataInSize: Cardinal;
               var pDataOut: Pointer;
               var DataOutSize: Cardinal
               ): Boolean;
const
  BytesToRead = 1000;

var
  FPipeHandle: Cardinal;
  success: Boolean;
  output: Cardinal;
  err: Cardinal;

  PID: Cardinal;

  BytesRead: Cardinal;
  DataRead: Array[0..BytesToRead] Of Char;

begin

  Result := False;

  try
    FPipeHandle := CreateNamedPipe(
                               NamedPipeName,
                               PIPE_ACCESS_INBOUND,
                               PIPE_TYPE_MESSAGE or PIPE_READMODE_MESSAGE or PIPE_WAIT,
                               1,
                               8096,
                               8096,
                               5000,
                               nil);

     PID := PidProcesso(ProcName);
    //ScriviLog(DumpData(pDataIn, DataInSize));
    if not RemoteUncrypt(PID, pDataIn, DataInSize, NamedPipeName, output, err, True) then
      begin
        Exit;
      end;

    //leggo dal pipe
    if not ReadFile(FPipeHandle, DataRead, BytesToRead, BytesRead, nil) then
      begin
        //ErrStr('ReadFile');
        Exit;
      end;

    //ScriviLog(DumpData(@DataRead[0], BytesRead));

    if (BytesRead <> 0) then
      begin
        DataOutSize := BytesRead;
        GetMem(pDataOut, DataOutSize);
        CopyMemory(pDataOut, @DataRead[0], DataOutSize);
      end;

    Result := True;

  finally
    if (FPipeHandle <> INVALID_HANDLE_VALUE) then
      begin
        DisconnectNamedPipe(FPipeHandle);
        CloseHandle(FPipeHandle);
      end;
  end;

end;

function Int2Str(I: integer): string;
begin
  Str(I, Result);
end;

//enumera gli HotSpot memorizzati da una interface WiFi
function GetHotSpotsData(InterfaceName: PAnsiChar; funz: TCallBackFunc): Boolean;
const
  xor_key: array[0..31] of Byte =
(
    $56, $66, $09, $42, $08, $03, $98, $01,
    $4D, $67, $08, $66, $11, $56, $66, $09,
    $42, $08, $03, $98, $01, $4D, $67, $08,
    $66, $11, $56, $66, $09, $42, $08, $03
);


var
  hKey: Cardinal;
  KeyName: PAnsiChar;
  Data: array[1..$400] of Byte;
  DataSize: Cardinal;
  ValueName: PAnsiChar;
  i, j: Cardinal;

  DataOffset: Cardinal;

  WepKey: array[0..128] of Byte;

  pDataIn, pDataOut: Pointer;
  DataInSize, DataOutSize: Cardinal;

begin

  Result := False;

  KeyName := PAnsiChar(RegKeyStr + '\' + InterfaceName);

  if (RegOpenKeyExA(HKEY_LOCAL_MACHINE, KeyName, 0, KEY_READ, hKey ) <> 0) then begin
      //ErrStr('RegOpenKeyEx');
    Exit;
  end;



  //eseguo il loop su Static#<numero>
  i := 0;
  while (True) do begin

      ValueName :=  pchar('Static#000' + Int2Str(i));

      if (RegQueryValueExA(hKey, ValueName, nil, nil, @Data[1], @DataSize) <> 0) then begin
        //ErrStr('RegQueryValueExA');
        //Exit;
        Break;
      end;

      funz(1, InterfaceName, Length(InterfaceName));

      funz(2, PAnsiChar(@Data[$15]), Length(PAnsiChar(@Data[$15])));
      DataOffset := pcardinal(@Data[1])^;

      DataInSize := DataSize - DataOffset;
      pDataIn := Pointer(Cardinal(@Data[1]) + DataOffset);

      if RemoteCryptUnprotect('winlogon.exe', PIPE_NAME, pDataIn, DataInSize, pDataOut, DataOutSize) then begin
        for j := 0 to DataOutSize -1 do begin
          WepKey[j] := (pbyte(Cardinal(pDataOut) + j * SizeOf(Byte)))^ xor (xor_key[j mod 32]);
        end;
        funz(3, @WepKey[0], DataOutSize);
        FreeMem(pDataOut);
      end else begin
        funz(3, nil, 0);
      end;

      Inc(i);

    end;

  RegCloseKey(hKey);
  Result := True;

end;

//vado ad enumerare le interfacce Wireless riconosciute dal sistema
function GetWZCSVCData(funz: TCallBackFunc): Boolean;
var
  KeyName: PAnsiChar;
  hKey: Cardinal;
  NumSubKeys: Cardinal;
  i: Cardinal;
  SubKeyName: array[1..255] of Char;
  SubKeyNameSize: Cardinal;

  StrList: TStrList;
  WiFiGUID: string;

begin
  //
  StrList := nil;
  Result := False;

  try

    KeyName := PAnsiChar(RegKeyStr);
    if (RegOpenKeyExA(HKEY_LOCAL_MACHINE, KeyName, 0, KEY_READ, hKey) <> 0) then begin
        //ErrStr('RegOpenKeyEx');
      Exit;
    end;

    if (RegQueryInfoKeyA(hKey, nil, nil, nil, @NumSubKeys, nil, nil, nil, nil, nil, nil, nil ) <> 0) then begin
       // ErrStr('RegQueryInfoKeyA');
      Exit;
    end;


    if NumSubKeys < 1 then exit;
    StrList := TStrList.Create;

    for i := 0 to NumSubKeys - 1 do begin
      SubKeyNameSize := 255;
      RegEnumKeyExA(hKey,i,@SubKeyName[1],@SubKeyNameSize,nil,nil,nil,nil);
      StrList.Add(SubKeyName);
        //GetHotSpotsData(PAnsiChar(@SubKeyName[1]), funz);
    end;

    Result := True;

  finally

    if hKey <> 0 then RegCloseKey(hKey);

    if Result then begin
      for i := 0 to StrList.Count - 1 do begin
        WiFiGUID := StrList.strings(i);
        GetHotSpotsData(PAnsiChar(WiFiGUID), funz);
      end;
    end;

    if StrList <> nil then StrList.Free;

  end;

end;

end.
