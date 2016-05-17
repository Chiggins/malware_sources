unit UnitGetWAMip;

interface

function GetWanIP: String;
function GetLocalIP : string;

implementation

uses
  StrUtils,Windows,
  winsock,
  IdTCPClient;

function GetWanIP: String;
var
  IdTCPClient1: TIdTCPClient;
  i: integer;
begin
  result := '';

  // usando o site DynDNS
  IdTCPClient1 := TIdTCPClient.Create(nil);
  IdTCPClient1.Host := 'checkip.dyndns.org';
  IdTCPClient1.Port := 80;
  try
    IdTCPClient1.Connect;
    except
    try
      IdTCPClient1.Free;
      exit;
      except
    end;
  end;
  i := 0;

  while (IdTCPClient1.Connected = false) and (i < 5) do
  begin
    sleep(200);
    inc(i);
  end;

  try
    IdTCPClient1.IOHandler.WriteLn('GET / HTTP/1.1' + #13#10);
    result := IdTCPClient1.IOHandler.ReadLn('</body></html>');
    except
    result := '';
  end;

  if result = '' then result := '127.0.0.1' else Delete(result, 1, (posex('Current IP Address: ', result) - 1) + length('Current IP Address: '));

  if IdTCPClient1.Connected then IdTCPClient1.Disconnect;
  IdTCPClient1.Free;


{
  // usando o site no-ip
  IdTCPClient1 := TIdTCPClient.Create(nil);
  IdTCPClient1.Host := 'ip1.dynupdate.no-ip.com';
  IdTCPClient1.Port := 8245;
  try
    IdTCPClient1.Connect;
    except
    try
      IdTCPClient1.Free;
      exit;
      except
    end;
  end;
  i := 0;

  while (IdTCPClient1.Connected = false) and (i < 5) do
  begin
    sleep(200);
    inc(i);
  end;

  try
    IdTCPClient1.IOHandler.WriteLn('GET / HTTP/1.1' + #13#10);
    IdTCPClient1.ReadTimeout := 1000;
    while IdTCPClient1.Connected do result := result + IdTCPClient1.IOHandler.ReadChar;
    except
  end;

  if result = '' then result := '127.0.0.1' else Delete(result, 1, ((posex(#13#10#13#10, result) - 1) + 4));

  if IdTCPClient1.Connected then IdTCPClient1.Disconnect;
  IdTCPClient1.Free;
}
end;

function StrPas(const Str: PChar): string;
begin
  Result := Str;
end;

function GetLocalIP : string;
type
  TaPInAddr = array [0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe  : PHostEnt;
  pptr : PaPInAddr;
  Buffer : pAnsiChar;
  I    : Integer;
  GInitData      : TWSADATA;
begin
  WSAStartup($101, GInitData);
  Result := '';
  GetMem(Buffer, 64);
  GetHostName(Buffer, 64);
  phe := GetHostByName(buffer);
  if phe = nil then Exit;
  pptr := PaPInAddr(Phe^.h_addr_list);
  I := 0;
  while pptr^[I] <> nil do begin
    result := inet_ntoa(pptr^[I]^);
    result := inet_ntoa(pptr^[I]^);
    Inc(I);
  end;
  FreeMem(Buffer, 64);
  WSACleanup;
end;

end.
