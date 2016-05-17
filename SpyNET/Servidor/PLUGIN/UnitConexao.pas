unit UnitConexao;

interface

uses
  windows;

procedure EnviarStream(Host: string; Port: integer; MasterPassword, TextString: string);

implementation

uses
  IdTCPClient,
  UnitCryptString,
  UnitCompressString,
  UnitServerUtils;

Type
  TConnection = class
    IdTCPClient1: TIdTCPClient;
    TextString: string;
    PodeSair: boolean;
    MasterPassword: string;
    procedure OnConnected(Sender: TObject);
    procedure OnDisconnected(Sender: TObject);
end;

function xProcessMessage(var Msg: TMsg): Boolean;
begin
  Result := False;
  if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
  begin
    Result := True;
    if Msg.Message <> $0012 then
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
  end;
  sleep(20);
end;

procedure ProcessMessages;
var
  Msg: TMsg;
begin
  while xProcessMessage(Msg) do ;
end;

procedure TConnection.OnDisconnected(Sender: TObject);
begin
  PodeSair := true;
end;

procedure TConnection.OnConnected(Sender: TObject);
begin
  TextString := CompressString(TextString);
  TextString := EnDecryptStrRC4B(TextString, MasterPassword);
  try
    IdTCPClient1.WriteLn(IntToStr(length(TextString)) + '|');
    except
    PodeSair := true;
  end;
  try
    IdTCPClient1.WriteBuffer(pointer(TextString)^, length(TextString));
    except
    PodeSair := true;
  end;
  PodeSair := true;
end;

procedure EnviarStream(Host: string; Port: integer; MasterPassword, TextString: string);
var
  IdTCPClient1: TIdTCPClient;
  Connection: TConnection;
begin
  Connection := TConnection.Create;
  IdTCPClient1 := TIdTCPClient.Create(nil);

  Connection.IdTCPClient1 := IdTCPClient1;
  Connection.TextString := TextString;
  Connection.MasterPassword := MasterPassword;
  Connection.PodeSair := false;

  IdTCPClient1.OnConnected := Connection.OnConnected;
  IdTCPClient1.OnDisconnected := Connection.OnDisconnected;
  IdTCPClient1.Host := Host;
  IdTCPClient1.Port := Port;
  try
    IdTCPClient1.Connect;
    except
    exit;
  end;
  while Connection.PodeSair = false do processmessages;
  IdTCPClient1.Disconnect;
  IdTCPClient1.Free;
end;

end.
