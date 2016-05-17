program cryptfile;
{$APPTYPE CONSOLE}
uses
  windows,
  UnitCryptString;

function LerArquivo(FileName: WideString; var Size: int64): Pointer;
var
  hFile: Cardinal;
  lpNumberOfBytesRead: DWORD;
begin
  result := nil;
  hFile := CreateFileW(PWChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  Size := GetFileSize(hFile, nil);
  GetMem(Result, Size);
  ReadFile(hFile, Result^, Size, lpNumberOfBytesRead, nil);
  CloseHandle(hFile);
end;

Procedure CriarArquivo(NomedoArquivo: WideString; imagem: pointer; Size: DWORD);
var
  hFile: THandle;
  lpNumberOfBytesWritten: DWORD;

begin
  hFile := CreateFileW(PWChar(NomedoArquivo), GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);

  if hFile <> INVALID_HANDLE_VALUE then
  begin
    if Size = INVALID_HANDLE_VALUE then
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    WriteFile(hFile, imagem^, Size, lpNumberOfBytesWritten, nil);
    CloseHandle(hFile);
  end;
end;

var
  p: pointer;
  s: int64;
  TempStr: WideString;
begin
  if paramstr(1) = '' then exit;

  p := LerArquivo(WideString(paramstr(1)), s);
  deletefileW(pWchar(WideString(paramstr(1))));

  if (p = nil) or (s <= 0) then exit;
  SetLength(TempStr, s div 2);
  CopyMemory(@TempStr[1], p, s);

  writeln('');
  writeln('');
  writeln('');
  writeln('Iniciando a encriptção do arquivo' + ' ' + paramstr(1));
  writeln('');
  writeln('');
  writeln('');
  EnDecryptStrRC4B(@TempStr[1], Length(TempStr) * 2, 'XTREME');

  writeln('Salvando o arquivo...');
  writeln('');
  writeln('');
  writeln('');
  CriarArquivo(paramstr(1), @TempStr[1], s);
end.
