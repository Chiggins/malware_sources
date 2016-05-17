program teste;
{$imagebase 13400000}

uses
  windows,
  Functions,
  UnitInjectProcess;
  
type
  xString = Array [0..MAX_PATH] of WideChar;

function StrToxString(Str: WideString): xString;
begin
  if Length(Str) * 2 > SizeOf(xString) then CopyMemory(@Result[0], @Str[1], SizeOf(Xstring)) else
  CopyMemory(@Result[0], @Str[1], Length(Str) * 2);
end;

procedure Start(p: pointer); stdcall;
var
  pp: pointer;
begin
  LoadLibrary('user32.dll');
  MessageBox(0, 'TESTE', '', 0);
  GetMem(pp, 1000);
  MessageboxW(0, Paramstr(0), '', 0);
  ExitProcess(0);
end;

var
  p, p1: pWideChar;
  i: int64;
  h: Cardinal;
  Str: xString;
  Injected: boolean;
begin
  p := ParamStr(1);
  p1 := ' TESTE';

  MessageBoxW(0, SomarPWideChar(p, p1), '', 0);

  MessageBoxW(0, ParamStr(1), '', 0);
  //GetMem(p, 1000); não reservar memória qdo usar InjectIntoProcess
  Str := StrToxString('explorer.exe');
  h := CreateAndGetProcessHandle(Str);
  InjectIntoProcess(h, @Start, nil);
end.
