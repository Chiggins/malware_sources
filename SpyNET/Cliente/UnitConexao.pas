unit UnitConexao;

interface

uses
  windows, IdThreadMgr, IdThreadMgrDefault, IdAntiFreezeBase, IdAntiFreeze,
  IdBaseComponent, IdComponent, IdTCPServer, sysutils, classes, ComCtrls,
  UnitPrincipal, Forms;

var
  IdTCPServer: array [1..65535] of TIdTCPServer;
  IdThreadMgrDefault: array [1..65535] of TIdThreadMgrDefault;
  PortasAtivas: array [1..65535] of integer;
  SenhaConexao: string;

function PossoUsarPorta(port: integer): boolean;
procedure DesativarPorta(Porta: Integer);
function AtivarPorta(Porta: integer): boolean;
function ReceberString(AThread: TIdPeerThread): string;
procedure EnviarString(AThread: TIdPeerThread; ToSend: string; StringPequena: boolean = false);
function StreamToStr(S: TStream):string;
procedure StrToStream(S: TStream; const SS: string);
procedure ReceberArquivo(SizeFile: int64; OndeSalvar: string; AThread: TIdPeerThread; progressbar1: TProgressbar);
function ReceberBuffer(SizeBuffer: int64; AThread: TIdPeerThread; progressbar1: TProgressbar): string;

implementation

uses
  UnitCryptString,
  UnitComandos,
  UnitCompressString,
  UnitDebug;

function StreamToStr(S: TStream):string;
var
  SizeStr: integer;
begin
  S.Position := 0;
  SizeStr := S.Size;
  SetLength(Result, SizeStr);
  S.Read(Result[1], SizeStr);
end;

procedure StrToStream(S: TStream; const SS: string);
var
  SizeStr: integer;
begin
  S.Position := 0;
  SizeStr := Length(SS);
  S.Write(SS[1], SizeStr);
end;

procedure DesativarPorta(Porta: Integer);
var
  i: integer;
  AThread: TIdPeerThread;
begin
  if (IdTCPServer[Porta] <> nil) and (IdTCPServer[Porta].Active) then

  with IdTCPServer[Porta].Threads.LockList do
  try
    for i := Count - 1 downto 0 do
    begin
      AThread := Items[i];
      if AThread = nil then Continue;
      AThread.Connection.DisconnectSocket;
    end;
    finally
    IdTCPServer[Porta].Threads.UnlockList;
    try
      IdTCPServer[Porta].Active := false;
      except
    end;
    PortasAtivas[Porta] := 0;
  end;
end;

function AtivarPorta(Porta: integer): boolean;
begin
  result := false;
  try
    if IdTCPServer[Porta] = nil then IdTCPServer[Porta] := TIdTcpServer.Create(nil);
    if IdThreadMgrDefault[Porta] = nil then IdThreadMgrDefault[Porta] := TIdThreadMgrDefault.Create(nil);
    IdTCPServer[porta].Active := false;
    IdTCPServer[porta].OnExecute := FormPrincipal.IdTCPServer1Execute;
    IdTCPServer[porta].OnDisconnect := FormPrincipal.IdTCPServer1Disconnect;
    IdTCPServer[porta].ThreadMgr := IdThreadMgrDefault[porta];
    IdTCPServer[porta].DefaultPort := porta;
    IdTCPServer[porta].Active := true;
    except
    begin
      if DebugAtivo then AddDebug(Erro46);
      IdTCPServer[Porta].Free;
      IdThreadMgrDefault[Porta].Free;
      exit;
    end;
  end;
  result := true;
  PortasAtivas[Porta] := porta;
end;

function PossoUsarPorta(port: integer): boolean;
var
  TcpServer: TIdTcpServer;
begin
  result := false;
  TcpServer := TIdTcpServer.Create(nil);
  TcpServer.OnExecute := FormPrincipal.IdTCPServer1Execute;
  TcpServer.OnDisconnect := FormPrincipal.IdTCPServer1Disconnect;
  TcpServer.Active := false;
  TcpServer.DefaultPort := port;
  try
    TcpServer.Active := true;
    result := true;
    except
    if DebugAtivo then AddDebug(Erro47);
    result := false;
  end;
  TcpServer.Active := false;
  TcpServer.Free;
end;

function ReceberString(AThread: TIdPeerThread): string;
var
  StringSize: integer;
  Tempstr: string;
begin
  result := '';
  try
    if (AThread = nil) or (AThread.Connection.Connected = false) then exit;
    Tempstr := AThread.Connection.ReadLn;
    except
    if DebugAtivo then AddDebug(Erro45);
    AThread.Connection.Disconnect;
    exit;
  end;

  if copy(Tempstr, 1, pos('|', Tempstr) - 1) = PONG then
  begin
    result := Tempstr;
    exit;
  end;

  if copy(Tempstr, 1, pos('|', Tempstr) - 1) = PONGTEST then
  begin
    result := Tempstr;
    exit;
  end;

  if pos('|', Tempstr) <= 0 then exit;

  try
    StringSize := strtoint(copy(Tempstr, 1, pos('|', Tempstr) - 1));
    except
    if DebugAtivo then  AddDebug(Erro46 + ' ' + Tempstr);
    exit;
  end;

  if StringSize = 0 then exit;

  setlength(Tempstr, StringSize);
  AThread.Connection.ReadBuffer(pointer(Tempstr)^, StringSize);
  if DebugAtivo then AddDebug('Compressed: ' + inttostr(length(TempStr)));
  result := EnDecryptStrRC4B(Tempstr, MasterPassword);
  result := DecompressString(result);
  if DebugAtivo then AddDebug('DeCompressed: ' + inttostr(length(result)));
end;

procedure EnviarString(AThread: TIdPeerThread; ToSend: string; StringPequena: boolean = false);
var
  S: TMemoryStream;
  byteArray : array[0..MaxBufferSize] of byte;
  BytesRead: integer;
  i: integer;
begin
  while FormPrincipal.EnviandoPing = true do Application.ProcessMessages;

  if StringPequena = true then
  begin
    //try AThread.Connection.WriteLn(Encode64(EnDecryptStrRC4B(ToSend, MasterPassword))) except exit; end;
    try AThread.Connection.WriteLn(Encode64(ToSend) + '###@@@') except if DebugAtivo then AddDebug(Erro47); exit; end;
    exit;
  end;

  ToSend := CompressString(ToSend);
  ToSend := EnDecryptStrRC4B(ToSend, MasterPassword);
  try AThread.Connection.WriteLn(inttostr(length(ToSend)) + '|') except if DebugAtivo then AddDebug(Erro48); exit; end;
  i := gettickcount;
  while i + 20 > gettickcount do application.ProcessMessages;

  S := TMemoryStream.Create;
  StrToStream(s, ToSend);
  S.Position := 0;
  try
    while S.Position < length(ToSend) do
    begin
      BytesRead := S.Read(bytearray, MaxBufferSize);
      AThread.Connection.WriteBuffer(bytearray, BytesRead);
      Zeromemory(@bytearray, MaxBufferSize);
    end;
    except
    if DebugAtivo then AddDebug(Erro49);
  end;
  S.Free;
end;

procedure ReceberArquivo(SizeFile: int64; OndeSalvar: string; AThread: TIdPeerThread; progressbar1: TProgressbar);
var
  F : File;
  read, currRead : integer;
  Buffer : array[0..MaxBufferSize] of Byte;
  buffSize : integer;
  TempStr: string;
begin
  AssignFile(F, OndeSalvar);
  Rewrite(F, 1);
  read := 0;
  currRead := 0;
  buffSize := SizeOf(Buffer);
  try
    while((read < SizeFile) and Athread.Connection.Connected) do
    begin
      if (SizeFile - read) >= buffSize then currRead := buffSize else currRead := (SizeFile - read);
      Athread.Connection.ReadBuffer(buffer, currRead);
      read := read + currRead;
      setlength(TempStr, currRead);
      copymemory(@tempstr[1], @Buffer, currRead);
      //TempStr := EnDecryptStrRC4b(TempStr, 'spynet');
      BlockWrite(F, Tempstr[1], currRead);
      if progressbar1 <> nil then progressbar1.Position := progressbar1.Position  + currRead;
      currRead := 0;
    end;
    finally
    CloseFile(F);
  end;
  if Athread.Connection.Connected = true then Athread.Connection.Disconnect;
end;

function ReceberBuffer(SizeBuffer: int64; AThread: TIdPeerThread; progressbar1: TProgressbar): string;
var
  read, currRead : integer;
  Buffer : array[0..MaxBufferSize] of Byte;
  buffSize : integer;
  TempStr: string;
  S: TMemoryStream;
begin
  read := 0;
  currRead := 0;
  buffSize := SizeOf(Buffer);
  S := TMemoryStream.Create;
  result := '';
  try
    while((read < SizeBuffer) and Athread.Connection.Connected) do
    begin
      if (SizeBuffer - read) >= buffSize then currRead := buffSize else currRead := (SizeBuffer - read);
      Athread.Connection.ReadBuffer(buffer, currRead);
      read := read + currRead;
      setlength(TempStr, currRead);
      copymemory(@tempstr[1], @Buffer, currRead);
      //TempStr := EnDecryptStrRC4b(TempStr, 'spynet');
      S.WriteBuffer(Tempstr[1], currRead);
      if progressbar1 <> nil then progressbar1.Position := progressbar1.Position  + currRead;
      currRead := 0;
    end;
    finally
    result := streamtostr(S);
    S.Free;
  end;
end;

end.

