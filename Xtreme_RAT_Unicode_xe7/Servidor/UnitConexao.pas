Unit UnitConexao;

interface

uses
  Windows,
  Classes,

  IdTCPClient,
  IdIOHandler, 
  UnitCompressString, 
  UnitConstantes, 
  InformacoesServidor, 
  UnitConfigs,
  UnitExecutarComandos;

type
  TConnectionHeader = record
    Password: int64;
    PacketSize: int64;
  end;

type
  TIdTCPClientNew = class(TIdTCPClient)
  private
    EnviandoString: boolean;
    RecebendoString: boolean;
    ConnectionPassword: int64;
    procedure _EnviarString(xStr: WideString);
    function _ReceberString: WideString;
  public
    constructor Create(AOwner: TComponent; Pass: int64);
    procedure EnviarString(Str: WideString);
    function ReceberString: WideString;
    property FEnviandoString: boolean read EnviandoString write EnviandoString;
    property FRecebendoString: boolean read RecebendoString write RecebendoString;
    property FConnectionPassword: int64 read ConnectionPassword write ConnectionPassword;
  end;

implementation

constructor TIdTCPClientNew.Create(AOwner: TComponent; Pass: int64);
begin
  inherited Create(AOwner);
  FEnviandoString := False;
  FRecebendoString := False;
  FConnectionPassword := Pass;
end;

procedure TIdTCPClientNew.EnviarString(Str: WideString);
begin
  _EnviarString(Str);
end;

procedure TIdTCPClientNew._EnviarString(xStr: WideString);
var
  ConnectionHeader: TConnectionHeader;
  BytesHeader, ToSendStream: TMemoryStream;
  i: integer;
  Str: Widestring;
begin
  Str := xStr;
  if Str = '' then Exit;
  if Connected = False then Exit;
  i := 0;
  while (i < 1000) and (Connected = True) and ((EnviandoString = True) or (RecebendoString = True)) do Sleep(random(100));
  if Connected = False then Exit;
  if i >= 1000 then Exit;

  Str := CompressString(Str);

  ToSendStream := TMemoryStream.Create;
  ToSendStream.Write(pointer(Str)^, Length(Str) * 2);
  ToSendStream.Position := 0;

  ConnectionHeader.PacketSize := ToSendStream.Size;
  ConnectionHeader.Password := ConnectionPassword;

  BytesHeader := TMemoryStream.Create;
  BytesHeader.Write(ConnectionHeader, SizeOf(TConnectionHeader));
  BytesHeader.Position := 0;

  EnviandoString := True;
  try
    IOHandler.Write(BytesHeader, BytesHeader.Size);
    IOHandler.Write(ToSendStream, ToSendStream.Size);
    finally
    IOHandler.WriteBufferClear;
  end;
  EnviandoString := False;

  BytesHeader.Free;
  ToSendStream.Free;

end;

function TIdTCPClientNew.ReceberString: WideString;
begin
  Result := _ReceberString;
end;

function TIdTCPClientNew._ReceberString: WideString;
var
  ConnectionHeader: TConnectionHeader;
  BytesHeader, ToRecvStream: TMemoryStream;
  IsOK, Continue: boolean;
  i: integer;
begin
  result := '';
  IsOK := True;
  Continue := True;

  if IOHandler.InputBufferIsEmpty then
  begin
    try
      IOHandler.CheckForDataOnSource(10);
      finally
      if IOHandler.InputBufferIsEmpty then Continue := False;
    end;  
  end;
  if Continue = False then Exit;
  if Connected = False then Exit;
  i := 0;
  while (i < 1000) and (Connected = True) and ((EnviandoString = True) or (RecebendoString = True)) do
  begin
    inc(i);
    Sleep(random(100));
  end;
  if Connected = False then Exit;
  if i >= 1000 then Exit;

  RecebendoString := True;
  try
    Result := IOHandler.ReadLn;
    except
    Result := '';
  end;

  if Result = '' then
  begin
    RecebendoString := False;
    Exit;
  end else
  if Result = PING then
  begin
    Result := PING + DelimitadorComandos;
    RecebendoString := False;
    Exit;
  end;

  BytesHeader := TMemoryStream.Create;
  try
    IOHandler.ReadStream(BytesHeader, SizeOf(TConnectionHeader), False);
    except
    Result := '';
    RecebendoString := False;
    Exit;
  end;
  if BytesHeader.Size >= SizeOf(TConnectionHeader) then
  begin
    BytesHeader.Position := 0;
    BytesHeader.Read(ConnectionHeader, SizeOf(TConnectionHeader));
  end else ConnectionHeader.Password := ConnectionPassword + 1;
  BytesHeader.Free;

  if ConnectionHeader.Password = ConfiguracoesServidor.Password then
  begin
    ToRecvStream := TMemoryStream.Create;
    try
      IOHandler.ReadStream(ToRecvStream, ConnectionHeader.PacketSize, False);
      except
      Result := '';
      RecebendoString := False;
      Exit;
    end;
    ToRecvStream.Position := 0;
    if ToRecvStream.Size = ConnectionHeader.PacketSize then
    begin
      SetLength(Result, ToRecvStream.Size div 2);
      ToRecvStream.Read(pointer(Result)^, ToRecvStream.Size);
      Result := DecompressString(Result);
    end;
    ToRecvStream.Free;
  end else IsOK := False;

  RecebendoString := False;

  if IsOK = False then Disconnect;
end;

end.