unit UnitCommonProcedures;

interface

uses
  Windows,
  Controls,
  StdCtrls,
  Graphics,
  ComCtrls,
  StrUtils;

type
  TFormBase = class
  public
    const CorEntrada = $00E7EC7D;
    procedure MudarDeCorEnter(Sender: TObject);
    procedure MudarDeCorExit(Sender: TObject);
  end;

const
  NumeroDeVariaveis = 20; // um número maior que o número de colunas do listview...
type
  TSplit = array [0..NumeroDeVariaveis] of string;

var
  FormBase: TFormBase;

Function ReplaceString(ToBeReplaced, ReplaceWith : string; TheString :string): string;
function justr(s : string; tamanho : integer) : string;
function justl(s : string; tamanho : integer) : string;
function FileSizeToStr(SizeInBytes: int64): string;
function SplitString(Str, Delimitador: string): TSplit;
function CheckValidName(Str: string): boolean;
function ShowTime(DayChar: Char = '/'; DivChar: Char = ' ';
  HourChar: Char = ':'): String;

implementation

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

function ShowTime(DayChar: Char = '/'; DivChar: Char = ' ';
  HourChar: Char = ':'): String;
var
  SysTime: TSystemTime;
  Month, Day, Hour, Minute, Second: String;
begin
  GetLocalTime(SysTime);
  Month := inttostr(SysTime.wMonth);
  Day := inttostr(SysTime.wDay);
  Hour := inttostr(SysTime.wHour);
  Minute := inttostr(SysTime.wMinute);
  Second := inttostr(SysTime.wSecond);
  if length(Month) = 1 then
    Month := '0' + Month;
  if length(Day) = 1 then
    Day := '0' + Day;
  if length(Hour) = 1 then
    Hour := '0' + Hour;
  if Hour = '24' then
    Hour := '00';
  if length(Minute) = 1 then
    Minute := '0' + Minute;
  if length(Second) = 1 then
    Second := '0' + Second;
  Result := Day + DayChar + Month + DayChar + inttostr(SysTime.wYear)
    + DivChar + Hour + HourChar + Minute + HourChar + Second;
end;

procedure TFormBase.MudarDeCorEnter(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  if (Ctrl is TEdit) then
  TEdit(Ctrl).Color := CorEntrada;
  if (Ctrl is TListView) then
  TListView(Ctrl).Color := CorEntrada;
  if (Ctrl is TMemo) then
  TMemo(Ctrl).Color := CorEntrada;
  if (Ctrl is TRichEdit) then
  TRichEdit(Ctrl).Color := CorEntrada;
  if (Ctrl is TComboBox) then
  TComboBox(Ctrl).Color := CorEntrada;
end;

procedure TFormBase.MudarDeCorExit(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  if (Ctrl is TEdit) then
  TEdit(Ctrl).Color := clWindow;
  if (Ctrl is TListView) then
  TListView(Ctrl).Color := clWindow;
  if (Ctrl is TMemo) then
  TMemo(Ctrl).Color := clWindow;
  if (Ctrl is TRichEdit) then
  TRichEdit(Ctrl).Color := clWindow;
  if (Ctrl is TComboBox) then
  TComboBox(Ctrl).Color := clWindow;
end;

Function ReplaceString(ToBeReplaced, ReplaceWith : string; TheString :string):string;
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
    position := posex(ToBeReplaced, TempSource);
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
     s := s+DupeString(' ', i);
   justl := s;
end;

function StrFormatByteSize(qdw: int64; pszBuf: PWideChar; uiBufSize: UINT): PWideChar; stdcall;
  external 'shlwapi.dll' name 'StrFormatByteSizeW';

function FileSizeToStr(SizeInBytes: int64): string;
var
  arrSize: PWideChar;
begin
  GetMem(arrSize, MAX_PATH);
  StrFormatByteSize(SizeInBytes, arrSize, MAX_PATH);
  Result := string(arrSize);
  FreeMem(arrSize, MAX_PATH);
end;

function CheckValidName(Str: string): boolean;
begin
  result := false;
  if (posex('\', Str) > 0) or
     (posex('/', Str) > 0) or
     (posex(':', Str) > 0) or
     (posex('*', Str) > 0) or
     (posex('?', Str) > 0) or
     (posex('"', Str) > 0) or
     (posex('<', Str) > 0) or
     (posex('>', Str) > 0) or
     (posex('|', Str) > 0) or
     (posex('/', Str) > 0) then exit;
  result := true;
end;

function SplitString(Str, Delimitador: string): TSplit;
var
  i: integer;
  TempStr: string;
begin
  i := 0;
  TempStr := Str;
  if posex(Delimitador, TempStr) <= 0 then exit;

  while (TempStr <> '') and (i <= NumeroDeVariaveis) do
  begin
    Result[i] := Copy(TempStr, 1, posex(Delimitador, TempStr) - 1);
    delete(TempStr, 1, posex(Delimitador, TempStr) - 1);
    delete(TempStr, 1, length(Delimitador));
    inc(i);
  end;
end;

initialization
  FormBase := TFormBase.Create;

finalization
  FormBase.Free;

end.
