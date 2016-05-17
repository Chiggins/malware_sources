unit UnitGetWAMip;

interface

function GetWanIP: String;
function GetLocalIP : string;

implementation

uses
  Windows,
  winsock;

function fileexists(filename: string): boolean;
var
  hfile: thandle;
  lpfindfiledata: twin32finddata;

begin
  result := false;
  hfile := findfirstfile(pchar(filename), lpfindfiledata);
  if hfile <> invalid_handle_value then
  begin
    findclose(hfile);
    result := true;
  end;
end;

function LerArquivo(FileName: String; var tamanho: DWORD): String;
var
  hFile: Cardinal;
  lpNumberOfBytesRead: DWORD;
  imagem: pointer;

begin
  result := '';
  if fileexists(filename) = false then exit;
  
  imagem := nil;
  hFile := CreateFile(PChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  tamanho := GetFileSize(hFile, nil);
  GetMem(imagem, tamanho);
  ReadFile(hFile, imagem^, tamanho, lpNumberOfBytesRead, nil);
  setstring(result, Pchar(imagem), tamanho);
  freemem(imagem, tamanho);
  CloseHandle(hFile);
end;

function URLDownloadToFile(Caller: IUnknown; URL: PChar; FileName: PChar;
  Reserved: DWORD;LPBINDSTATUSCALLBACK: pointer): HResult;
var
  xURLDownloadToFile: function(Caller: IUnknown; URL: PChar; FileName: PChar;
    Reserved: DWORD;LPBINDSTATUSCALLBACK: pointer): HResult; stdcall;
begin
  xURLDownloadToFile := GetProcAddress(LoadLibrary(pchar('urlmon.dll')), pchar('URLDownloadToFileA'));
  Result := xURLDownloadToFile(Caller, URL, FileName, Reserved, LPBINDSTATUSCALLBACK);
end;

// obtains your outside world IP.
function GetWanIP: String;
var
 TempList: string;
 len: cardinal;
 DestFile:String;
const
  SourceFile = 'http://www.ip-adress.com/';
begin
  result := '127.0.0.1';
  DestFile := 'IP.txt';
  if UrlDownloadToFile(nil, PChar(SourceFile), PChar(DestFile), 0, nil) = S_OK then
  try
    TempList := lerarquivo(DestFile, len);
    DeleteFile(PChar(DestFile));
    if TempList = '' then exit;
    Result := TempList;
    except
    exit;
  end;
  delete(result, 1, pos('My IP address:', result) + 13);
  result := copy(result, 1, pos('<', result) - 1);

  if result = '' then result := '127.0.0.1';
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
  Buffer : array [0..63] of char;
  I    : Integer;
  GInitData      : TWSADATA;
begin
  WSAStartup($101, GInitData);
  Result := '';
  GetHostName(Buffer, SizeOf(Buffer));
  phe :=GetHostByName(buffer);
  if phe = nil then Exit;
  pptr := PaPInAddr(Phe^.h_addr_list);
  I := 0;
  while pptr^[I] <> nil do begin
    result := StrPas(inet_ntoa(pptr^[I]^));
    result := StrPas(inet_ntoa(pptr^[I]^));
    Inc(I);
  end;
  WSACleanup;
end;

{
var
  Host, IP, Err: string;
begin
  if GetIPFromHost(Host, IP, Err) then
  messagebox(0, PChar('Your Hostname: ' + host + #13+
                      'Your Dialup or LAN IP: ' + IP + #13 +
                      'Your WAN IP: ' + GetWanIp), 'Network Info', MB_OK or MB_ICONINFORMATION);
end.
}
end.
