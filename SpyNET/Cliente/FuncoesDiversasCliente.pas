Unit FuncoesDiversasCliente;

interface

uses
  windows,
  StrUtils, // gerar relatório
  Sysutils;

type
  HDROP = Longint;
  PPWideChar = ^PWideChar;

function MyGetFileSize(const FileName: string): Integer;
function LerArquivo(FileName: String; var tamanho: DWORD): String;
function ReplaceString(ToBeReplaced, ReplaceWith : string; TheString :string):string;
function StartThread(pFunction : TFNThreadStartRoutine; iPriority : Integer = Thread_Priority_Normal; iStartFlag : Integer = 0) : THandle;
function CloseThread( ThreadHandle : THandle) : Boolean;
procedure CriarArquivo(NomedoArquivo: String; imagem: string; Size: DWORD);
function write2reg(key: Hkey; subkey, name, value: string): boolean;
function lerreg(Key:HKEY; Path:string; Value, Default: string): string;
function GetDefaultBrowser: string;
function GetProgramFilesDir: string;
function MyDragQueryFile(Drop: HDROP; FileIndex: UINT; FileName: PChar; cb: UINT): UINT;
function MyTempFolder: String;
function randomstring: string;
function MegaTrim(str: string): string;
function MyGetFileSize2(path:String): int64;
function justr(s : string; tamanho : integer) : string;
function justl(s : string; tamanho : integer) : string;
function FormatByteSize(const bytes: Longint): string;

implementation

function FormatByteSize(const bytes: Longint): string;
const
  B = 1; //byte
  KB = 1024 * B; //kilobyte
  MB = 1024 * KB; //megabyte
  GB = 1024 * MB; //gigabyte
  //TB = 1024 * GB; //Terabyte
  //PB = 1024 * TB; //Petabyte
  //EB = 1024 * PB; //Exabyte
  //ZB = 1024 * EB; //Zettabyte
  //YB = 1024 * ZB; //Yottabyte
begin
  //if bytes > YB then
  //result := FormatFloat('#.## YB', bytes / YB)
  //if bytes > ZB then
  //result := FormatFloat('#.## ZB', bytes / ZB)
  //if bytes > EB then
  //result := FormatFloat('#.## EB', bytes / EB)
  //if bytes > PB then
  //result := FormatFloat('#.## PB', bytes / PB)
  //if bytes > TB then
  //result := FormatFloat('#.## TB', bytes / TB)
  if bytes > GB then
  result := FormatFloat('#.## GB', bytes / GB)
  else
  if bytes > MB then
  result := FormatFloat('#.## MB', bytes / MB)
  else
  if bytes > KB then
  result := FormatFloat('#.## KB', bytes / KB)
  else
  result := FormatFloat('#.## bytes', bytes) ;
end;

function justr(s : string; tamanho : integer) : string;
var i : integer;
begin
   i := tamanho-length(s);
   if i>0 then
     s := DupeString(' ', i)+s;
   justr := s;
end;

function justl(s : string; tamanho : integer) : string;
var i : integer;
begin
   i := tamanho-length(s);
   if i>0 then
     s := s+DupeString('.', i);
   justl := s;
end;

function MyGetFileSize2(path:String): int64;
var
  SearchRec : TSearchRec;
begin
  if fileexists(path) = false then
  begin
    result := 0;
    exit;
  end;
  if FindFirst(path, faAnyFile, SearchRec ) = 0 then                  // if found
  Result := Int64(SearchRec.FindData.nFileSizeHigh) shl Int64(32) +    // calculate the size
  Int64(SearchREc.FindData.nFileSizeLow)
  else
  Result := -1;
  findclose(SearchRec);
end;

function MyGetFileSize(const FileName: string): Integer;
var
  sr: TSearchRec;
begin
  Result := 0;

  if FindFirst(FileName, faAnyFile, sr) = 0 then
  begin
    Result := sr.Size;
    FindClose(sr);
  end;
end;

function LerArquivo(FileName: String; var tamanho: DWORD): String;
var
  hFile: THandle;
  lpNumberOfBytesRead: DWORD;
  imagem: pointer;

begin
  imagem := nil;
  hFile := CreateFile(PChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  //if hFile <> INVALID_HANDLE_VALUE then
  //begin
    tamanho := GetFileSize(hFile, nil);
    GetMem(imagem, tamanho);
    ReadFile(hFile, imagem^, tamanho, lpNumberOfBytesRead, nil);
    setstring(result, Pchar(imagem), tamanho);
    freemem(imagem, tamanho);
    CloseHandle(hFile);
  //end;
end;

Function ReplaceString(ToBeReplaced, ReplaceWith : string; TheString :string):string;
//
// Substitui, em uma cadeia de caracteres, todas as ocorrências
// de uma string por outra
//
// ToBeReplaced: String a ser substituida
// ReplaceWith : String Substituta
// TheString: Cadeia de strings
//
// Ex.: memo1.text := ReplaceString('´a', 'á', memo1.text);
var
  Position: Integer;
  LenToBeReplaced: Integer;
  TempStr: String;
  TempSource: String;
begin
  LenToBeReplaced:=length(ToBeReplaced);
  TempSource:=TheString;
  TempStr:='';
  repeat
    position := pos(ToBeReplaced, TempSource);
    if (position <> 0) then
    begin
      TempStr := TempStr + copy(TempSource, 1, position-1); //Part before ToBeReplaced
      TempStr := TempStr + ReplaceWith; //Tack on replace with string
      TempSource := copy(TempSource, position+LenToBeReplaced, length(TempSource)); // Update what's left
    end else
    begin
      Tempstr := Tempstr + TempSource; // Tack on the rest of the string
    end;
  until (position = 0);
  Result:=Tempstr;
end;

Function StartThread(pFunction : TFNThreadStartRoutine; iPriority : Integer = Thread_Priority_Normal; iStartFlag : Integer = 0) : THandle;
var
  ThreadID : DWORD;
begin
  Result := CreateThread(nil, 0, pFunction, nil, iStartFlag, ThreadID);
  SetThreadPriority(Result, iPriority);
end;

Function CloseThread( ThreadHandle : THandle) : Boolean;
begin
  Result := TerminateThread(ThreadHandle, 1);
  CloseHandle(ThreadHandle);
end;

Procedure CriarArquivo(NomedoArquivo: String; imagem: string; Size: DWORD);
var
  hFile: THandle;
  lpNumberOfBytesWritten: DWORD;

begin
  hFile := CreateFile(PChar(NomedoArquivo), GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);

  if hFile <> INVALID_HANDLE_VALUE then
  begin
    if Size = INVALID_HANDLE_VALUE then
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    WriteFile(hFile, imagem[1], Size, lpNumberOfBytesWritten, nil);
    CloseHandle(hFile);
  end;
end;

function write2reg(key: Hkey; subkey, name, value: string): boolean;
var
  regkey: hkey;
begin
  result := false;
  RegCreateKey(key, PChar(subkey), regkey);
  if RegSetValueEx(regkey, Pchar(name), 0, REG_EXPAND_SZ, pchar(value), length(value)) = 0 then
    result := true;
  RegCloseKey(regkey);
end;

Function lerreg(Key:HKEY; Path:string; Value, Default: string): string;
Var
  Handle:HKEY;
  RegType:integer;
  DataSize:integer;

begin
  Result := Default;
  if (RegOpenKeyEx(Key, pchar(Path), 0, KEY_ALL_ACCESS, Handle) = ERROR_SUCCESS) then
  begin
    if RegQueryValueEx(Handle, pchar(Value), nil, @RegType, nil, @DataSize) = ERROR_SUCCESS then
    begin
      SetLength(Result, Datasize);
      RegQueryValueEx(Handle, pchar(Value), nil, @RegType, PByte(pchar(Result)), @DataSize);
      SetLength(Result, Datasize - 1);
    end;
    RegCloseKey(Handle);
  end;
end;

function GetDefaultBrowser: string;
var
  chave, valor: string;
begin
  chave := 'http\shell\open\command';
  valor := '';
  result := lerreg(HKEY_CLASSES_ROOT, chave, valor, '');

  if result = '' then
  exit;
  if result[1] = '"' then
  result := copy(result, 2, pos('.exe', result) + 2)
  else
  result := copy(result, 1, pos('.exe', result) + 3);

  if uppercase(extractfileext(result)) <> '.EXE' then
  result := GetProgramFilesDir + '\Internet Explorer\iexplore.exe';
end;

function GetProgramFilesDir: string;
var
  chave, valor: string;
begin
  chave := 'SOFTWARE\Microsoft\Windows\CurrentVersion';
  valor := 'ProgramFilesDir';
  result := lerreg(HKEY_LOCAL_MACHINE, chave, valor, '');
end;

function MyDragQueryFile(Drop: HDROP; FileIndex: UINT; FileName: PChar; cb: UINT): UINT;
var
  xDragQueryFile: function(Drop: HDROP; FileIndex: UINT; FileName: PChar; cb: UINT): UINT; stdcall;
begin
  xDragQueryFile := GetProcAddress(LoadLibrary('shell32.dll'), 'DragQueryFileA');
  Result := xDragQueryFile(Drop, FileIndex, FileName, cb);
end;

function MegaTrim(str: string): string;
begin
  while pos('  ', str) >= 1 do delete(str, pos('  ', str), 1);
  result := str;
end;

function MyGetTemp(nBufferLength: DWORD; lpBuffer: PChar): DWORD;
var
  xGetTemp: function(nBufferLength: DWORD; lpBuffer: PChar): DWORD; stdcall;
begin
  xGetTemp := GetProcAddress(LoadLibrary('kernel32.dll'), 'GetTempPathA');
  Result := xGetTemp(nBufferLength, lpBuffer);
end;

function MyTempFolder: String;
var
  lpBuffer: Array[0..MAX_PATH] of Char;
begin
  MyGetTemp(sizeof(lpBuffer), lpBuffer);
  Result := String(lpBuffer);
end;

function randomstring: string;
var
  s:string;
  rs:string;
  ind:integer;
begin
  s := 'ABCDEFGHIJKLMNOPQRSTUWVXYZabcdefghijklmnopqrstuwvxyz0123456789';
  rs := '';
  RANDOMIZE;
  while length(s) > 38 do
  begin
    ind := random(length(s));
    rs := rs + s[ind + 1];
    delete(s, ind + 1, 1);
  end;
  result := inttostr(gettickcount) + rs;
end;

end.