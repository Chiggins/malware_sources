// ***************************************************************
//  madStrings.pas            version:  1.6a  ·  date: 2009-07-13
//  -------------------------------------------------------------
//  string routines
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2009 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2009-07-13 1.6a fixed bug in unicode PosPChar function
// 2009-02-09 1.6  (1) Delphi 2009 support
//                 (2) made most functions available for unicode strings
// 2003-11-02 1.5k (1) booleanToChar parameter name changed -> BCB support
//                 (2) ErrorCodeToStr unknown errors are shown in hex now
//                 (3) SizeToStr/MsToStr: language dependent decimal seperator
// 2003-06-09 1.5j (1) IntToHex now returns low characters, looks nicer
//                 (2) ErrorCodeToStr understands nt status errors ($Cxxxxxxx)
// 2002-05-07 1.5i SubStrExists/SubTextExists speed up
// 2001-05-17 1.5h ReplaceText added
// 2001-02-01 1.5g FileMatch rewritten
// 2001-01-31 1.5f bug in PosPChar fixed
// 2001-01-03 1.5e bug in recursive ReplaceStr fixed
// 2000-11-13 1.5d little bug in PosPChar fixed
// 2000-08-18 1.5c bugs in SubStrExists + SubTextExists + SubStr fixed
// 2000-07-25 1.5b minor changes in order to get rid of SysUtils

unit madStrings;

{$I mad.inc}

interface

uses madTypes;

// deletes all control and space characters at the end and the beginning of "str"
procedure    TrimStr (  var str:    AnsiString); {$ifdef UnicodeOverloads} overload;
procedure    TrimStr (  var str: UnicodeString); overload; {$endif}
function  RetTrimStr (const str:    AnsiString) :    AnsiString; {$ifdef UnicodeOverloads} overload;
function  RetTrimStr (const str: UnicodeString) : UnicodeString; overload; {$endif}

// deletes all "killChr(s)" characters from "str"
function KillChar  (var str:    AnsiString; killChr : AnsiChar) : boolean; {$ifdef UnicodeOverloads} overload;
function KillChar  (var str: UnicodeString; killChr : WideChar) : boolean; overload; {$endif}
function KillChars (var str:    AnsiString; killChrs: TSChar  ) : boolean; {$ifdef UnicodeOverloads} overload;
function KillChars (var str: UnicodeString; killChrs: TSChar  ) : boolean; overload; {$endif}

// deletes all occurences of "killStr" from "str"
function KillStr (var str:    AnsiString; const killStr:    AnsiString) : boolean; {$ifdef UnicodeOverloads} overload;
function KillStr (var str: UnicodeString; const killStr: UnicodeString) : boolean; overload; {$endif}

// replaces all occurences of "replaceThis" in "str" with "withThis"
function ReplaceStr  (var   str         : AnsiString;
                      const replaceThis : AnsiString;
                      const withThis    : AnsiString;
                      replaceSelf       : boolean = false) : boolean; {$ifdef UnicodeOverloads} overload;
function ReplaceStr  (var   str         : UnicodeString;
                      const replaceThis : UnicodeString;
                      const withThis    : UnicodeString;
                      replaceSelf       : boolean = false) : boolean; overload; {$endif}
function ReplaceText (var   str         : AnsiString;
                      const replaceThis : AnsiString;
                      const withThis    : AnsiString;
                      replaceSelf       : boolean = false) : boolean; {$ifdef UnicodeOverloads} overload;
function ReplaceText (var   str         : UnicodeString;
                      const replaceThis : UnicodeString;
                      const withThis    : UnicodeString;
                      replaceSelf       : boolean = false) : boolean; overload; {$endif}

// same as System.Delete, but returns the result instead of changing the "str" parameter
function RetDelete (const str : AnsiString;
                    index     : cardinal;
                    count     : cardinal = maxInt) : AnsiString; {$ifdef UnicodeOverloads} overload;
function RetDelete (const str : UnicodeString;
                    index     : cardinal;
                    count     : cardinal = maxInt) : UnicodeString; overload; {$endif}

// deletes "count" characters from the end of the string "str"
procedure    DeleteR (  var str:    AnsiString; count: cardinal); {$ifdef UnicodeOverloads} overload;
procedure    DeleteR (  var str: UnicodeString; count: cardinal); overload; {$endif}
function  RetDeleteR (const str:    AnsiString; count: cardinal) :    AnsiString; {$ifdef UnicodeOverloads} overload;
function  RetDeleteR (const str: UnicodeString; count: cardinal) : UnicodeString; overload; {$endif}

// same as System.Copy, but changes the parameter instead of returning the result string
procedure Keep (var str : AnsiString;
                index   : cardinal;
                count   : cardinal = maxInt); {$ifdef UnicodeOverloads} overload;
procedure Keep (var str : UnicodeString;
                index   : cardinal;
                count   : cardinal = maxInt); overload; {$endif}

// copies/keeps the last "count" characters
procedure KeepR (  var str:    AnsiString; count: cardinal); {$ifdef UnicodeOverloads} overload;
procedure KeepR (  var str: UnicodeString; count: cardinal); overload; {$endif}
function  CopyR (const str:    AnsiString; count: cardinal) :    AnsiString; {$ifdef UnicodeOverloads} overload;
function  CopyR (const str: UnicodeString; count: cardinal) : UnicodeString; overload; {$endif}

// same as AnsiUpperCase/AnsiLowerCase, but much faster
function UpChar  (const c:    AnsiChar  ) :    AnsiChar;   {$ifdef UnicodeOverloads} overload;
function UpChar  (const c:    WideChar  ) :    WideChar;   overload; {$endif}
function UpStr   (const s:    AnsiString) :    AnsiString; {$ifdef UnicodeOverloads} overload;
function UpStr   (const s: UnicodeString) : UnicodeString; overload; {$endif}
function LowChar (const c:    AnsiChar  ) :    AnsiChar;   {$ifdef UnicodeOverloads} overload;
function LowChar (const c:    WideChar  ) :    WideChar;   overload; {$endif}
function LowStr  (const s:    AnsiString) :    AnsiString; {$ifdef UnicodeOverloads} overload;
function LowStr  (const s: UnicodeString) : UnicodeString; overload; {$endif}

// boolean -> char
function BooleanToChar (value: boolean) : AnsiString;

// tests (case insensitivly) if "s1" and "s2" are identical
function IsTextEqual (const s1, s2:    AnsiString) : boolean; {$ifdef UnicodeOverloads} overload;
function IsTextEqual (const s1, s2: UnicodeString) : boolean; overload; {$endif}

// same as SysUtils.CompareStr/CompareText, but supports ['ä', 'é', ...]
function CompareStr  (const s1, s2:    AnsiString) : integer; {$ifdef UnicodeOverloads} overload;
function CompareStr  (const s1, s2: UnicodeString) : integer; overload; {$endif}
function CompareText (const s1, s2:    AnsiString) : integer; {$ifdef UnicodeOverloads} overload;
function CompareText (const s1, s2: UnicodeString) : integer; overload; {$endif}

// SysUtils.Pos with extended functionality
// searches only the sub areas "fromPos..toPos"
// is "fromPos > toPos", the search works backwards
function PosStr   (const subStr : AnsiString;
                   const str    : AnsiString;
                   fromPos      : cardinal = 1;
                   toPos        : cardinal = maxInt) : integer; {$ifdef UnicodeOverloads} overload;
function PosStr   (const subStr : UnicodeString;
                   const str    : UnicodeString;
                   fromPos      : cardinal = 1;
                   toPos        : cardinal = maxInt) : integer; overload; {$endif}
function PosText  (const subStr : AnsiString;
                   const str    : AnsiString;
                   fromPos      : cardinal = 1;
                   toPos        : cardinal = maxInt) : integer; {$ifdef UnicodeOverloads} overload;
function PosText  (const subStr : UnicodeString;
                   const str    : UnicodeString;
                   fromPos      : cardinal = 1;
                   toPos        : cardinal = maxInt) : integer; overload; {$endif}
function PosPChar (subStr       : PAnsiChar;
                   str          : PAnsiChar;
                   subStrLen    : cardinal = 0;   // 0 -> StrLen is called internally
                   strLen       : cardinal = 0;
                   ignoreCase   : boolean  = false;
                   fromPos      : cardinal = 0;
                   toPos        : cardinal = maxInt) : integer; {$ifdef UnicodeOverloads} overload;
function PosPChar (subStr       : PWideChar;
                   str          : PWideChar;
                   subStrLen    : cardinal = 0;   // 0 -> StrLen is called internally
                   strLen       : cardinal = 0;
                   ignoreCase   : boolean  = false;
                   fromPos      : cardinal = 0;
                   toPos        : cardinal = maxInt) : integer; overload; {$endif}

// same as "PosStr(...) = 1" and "PosText(...) = 1", but much faster
function PosStrIs1  (const subStr :    AnsiString;
                     const str    :    AnsiString) : boolean; {$ifdef UnicodeOverloads} overload;
function PosStrIs1  (const subStr : UnicodeString;
                     const str    : UnicodeString) : boolean; overload; {$endif}
function PosTextIs1 (const subStr :    AnsiString;
                     const str    :    AnsiString) : boolean; {$ifdef UnicodeOverloads} overload;
function PosTextIs1 (const subStr : UnicodeString;
                     const str    : UnicodeString) : boolean; overload; {$endif}

// returns the first occurence of one of the characters in "str"
function PosChars (const ch  : TSChar;
                   const str : AnsiString;
                   fromPos   : cardinal = 1;
                   toPos     : cardinal = maxInt) : integer; {$ifdef UnicodeOverloads} overload;
function PosChars (const ch  : TSChar;
                   const str : UnicodeString;
                   fromPos   : cardinal = 1;
                   toPos     : cardinal = maxInt) : integer; overload; {$endif}

// tests, if the string "str" matches the "mask"
// examples:
// StrMatch  ('test123abc', 'test???abc') = true
// StrMatch  ('test123abc', 'test?abc')   = false
// StrMatch  ('test123abc', 'test*abc')   = true
// StrMatch  ('test123abc', 'TEST*abc')   = false
// TextMatch ('test123abc', 'TEST*abc')   = true
// TextMatch ('test123abc', '*.*')        = false
// FileMatch ('test123abc', '*.*')        = true
function  StrMatch (const str,   mask:    AnsiString) : boolean; {$ifdef UnicodeOverloads} overload;
function  StrMatch (const str,   mask: UnicodeString) : boolean; overload; {$endif}
function TextMatch (const str,   mask:    AnsiString) : boolean; {$ifdef UnicodeOverloads} overload;
function TextMatch (const str,   mask: UnicodeString) : boolean; overload; {$endif}
function FileMatch (const file_, mask:    AnsiString) : boolean; {$ifdef UnicodeOverloads} overload;
function FileMatch (const file_, mask: UnicodeString) : boolean; overload; {$endif}

// same as StrMatch/TextMatch...
// extended sytax capabilities:    [!Length:0,1,2,4..7]
// examples:
// StrMatchEx  ('test123abc', 'test[3:0..9]abc')       = true
// TextMatchEx ('test123abc', 'test123[3:A,b,C]')      = true
// StrMatchEx  ('test123abc', 'test[!3:a..z,A..Z]abc') = true
function  StrMatchEx (const str, mask: AnsiString) : boolean;
function TextMatchEx (const str, mask: AnsiString) : boolean;

// returns "str", but with a minimal Length of "minLen" characters
// if nessecary, the string is filled up with "fillChar"
// if minLen is negative, the string is filled at the end, otherwise at the beginning
function FillStr (const str      : AnsiString;
                  minLen         : integer;
                  fillChar       : AnsiChar = ' ') : AnsiString; {$ifdef UnicodeOverloads} overload;
function FillStr (const str      : UnicodeString;
                  minLen         : integer;
                  fillChar       : WideChar = ' ') : UnicodeString; overload; {$endif}

// same as SysUtils.IntToStr/IntToHex, but with extended functionality
function IntToStrEx (value    : integer;
                     minLen   : integer  = 1;
                     fillChar : AnsiChar = '0') : AnsiString; overload;
function IntToStrEx (value    : cardinal;
                     minLen   : integer  = 1;
                     fillChar : AnsiChar = '0') : AnsiString; overload;
function IntToStrEx (value    : int64;
                     minLen   : integer  = 1;
                     fillChar : AnsiChar = '0') : AnsiString; overload;
function IntToHexEx (value    : integer;
                     minLen   : integer  = 1;
                     fillChar : AnsiChar = '0') : AnsiString; overload;
function IntToHexEx (value    : cardinal;
                     minLen   : integer  = 1;
                     fillChar : AnsiChar = '0') : AnsiString; overload;
function IntToHexEx (value    : int64;
                     minLen   : integer  = 1;
                     fillChar : AnsiChar = '0') : AnsiString; overload;

// same as SysUtils.StrToInt, but with different parameters
// no exceptions are raised, an invalid string results in an invalid result
// this function is *very* fast...
function StrToIntEx (hex : boolean;
                     str : PAnsiChar;
                     len : integer) : integer; 

// handles strings like this: "*.txt|c:\dokumente\*.doc|test.bat"
// the first subString has the index "1"
procedure FormatSubStrs (var   str:    AnsiString;                               delimiter: AnsiChar = '|'); {$ifdef UnicodeOverloads} overload;
procedure FormatSubStrs (var   str: UnicodeString;                               delimiter: AnsiChar = '|'); overload; {$endif}
function  SubStrCount   (const str:    AnsiString;                               delimiter: AnsiChar = '|') : integer; {$ifdef UnicodeOverloads} overload;
function  SubStrCount   (const str: UnicodeString;                               delimiter: AnsiChar = '|') : integer; overload; {$endif}
function  SubStr        (const str:    AnsiString;       index  :      cardinal; delimiter: AnsiChar = '|') : AnsiString; {$ifdef UnicodeOverloads} overload;
function  SubStr        (const str: UnicodeString;       index  :      cardinal; delimiter: AnsiChar = '|') : UnicodeString; overload; {$endif}
function  SubStrExists  (const str:    AnsiString; const subStr :    AnsiString; delimiter: AnsiChar = '|') : boolean; {$ifdef UnicodeOverloads} overload;
function  SubStrExists  (const str: UnicodeString; const subStr : UnicodeString; delimiter: AnsiChar = '|') : boolean; overload; {$endif}
function  SubTextExists (const str:    AnsiString; const subText:    AnsiString; delimiter: AnsiChar = '|') : boolean; {$ifdef UnicodeOverloads} overload;
function  SubTextExists (const str: UnicodeString; const subText: UnicodeString; delimiter: AnsiChar = '|') : boolean; overload; {$endif}

// converts "fileSize" to a string
// examples:
//  500       ->  '500 Bytes'
// 1024       ->  '1 KB'
// 1024*1024  ->  '1 MB'
function SizeToStr (size: int64) : AnsiString;

// converts "time" to a string
// examples:
// 15          ->  '15 ms'
// 1000        ->  '1 s'
// 60*1000     ->  '1 min'
// 60*60*1000  ->  '1 h'
function MsToStr (time: cardinal) : AnsiString;

// converts the "error" code to a string
// 5  ->  'Access denied'
function ErrorCodeToStr (error: cardinal) : AnsiString;

// ***************************************************************

{$ifndef ver120}{$ifndef ver130}{$define d6}{$ifndef ver140}{$define d7}{$endif}{$endif}{$endif}

// internal stuff, please ignore
function DecryptStr(const str: AnsiString) : AnsiString;
function AnsiToWideEx(const ansi: AnsiString; addTerminatingZero: boolean = true) : AnsiString;
function WideToAnsiEx(wide: PWideChar) : AnsiString;
function InternalStrMatchW(const str, mask: UnicodeString; fileMode: boolean) : boolean;
const CNtDll : AnsiString = (* ntdll.dll *)  #$3B#$21#$31#$39#$39#$7B#$31#$39#$39;
{$ifndef d6}
  function Utf8Decode(const S: AnsiString) : UnicodeString;
  function Utf8Encode(const WS: UnicodeString) : AnsiString;
{$endif}

implementation

uses Windows;

// ***************************************************************

procedure TrimStr(var str: AnsiString);
var c1, c2 : cardinal;
begin
  c1 := PosChars([#33..#255], str);
  if c1 <> 0 then begin
    c2 := PosChars([#33..#255], str, maxInt, 1);
    Keep(str, c1, c2 - c1 + 1);
  end else
    str := '';
end;

{$ifdef UnicodeOverloads}
procedure TrimStr(var str: UnicodeString);
var c1, c2 : cardinal;
begin
  c1 := PosChars([#33..#255], str);
  if c1 <> 0 then begin
    c2 := PosChars([#33..#255], str, maxInt, 1);
    Keep(str, c1, c2 - c1 + 1);
  end else
    str := '';
end;
{$endif}

function RetTrimStr(const str: AnsiString) : AnsiString;
var c1, c2 : cardinal;
begin
  c1 := PosChars([#33..#255], str);
  if c1 <> 0 then begin
    c2 := PosChars([#33..#255], str, maxInt, 1);
    result := Copy(str, c1, c2 - c1 + 1);
  end else
    result := '';
end;

{$ifdef UnicodeOverloads}
function RetTrimStr(const str: UnicodeString) : UnicodeString;
var c1, c2 : cardinal;
begin
  c1 := PosChars([#33..#255], str);
  if c1 <> 0 then begin
    c2 := PosChars([#33..#255], str, maxInt, 1);
    result := Copy(str, c1, c2 - c1 + 1);
  end else
    result := '';
end;
{$endif}

function KillChar(var str: AnsiString; killChr: AnsiChar) : boolean;
var cursor1, cursor2, lastChar : PAnsiChar;
    ch1 : AnsiChar;
begin
  UniqueString(str);
  cursor1 := PAnsiChar(str);
  cursor2 := cursor1;
  lastChar := cursor1 + Length(str) - 1;
  while cursor2 <= lastChar do begin
    ch1 := cursor2^;
    if ch1 <> killChr then begin
      cursor1^ := ch1;
      inc(cursor1);
    end;
    inc(cursor2);
  end;
  result := cursor1 <> cursor2;
  if result then
    SetLength(str, cursor1 - PAnsiChar(str));
end;

{$ifdef UnicodeOverloads}
function KillChar(var str: UnicodeString; killChr: WideChar) : boolean;
var cursor1, cursor2, lastChar : PWideChar;
    ch1 : WideChar;
begin
  UniqueString(str);
  cursor1 := PWideChar(str);
  cursor2 := cursor1;
  lastChar := cursor1 + Length(str) - 1;
  while cursor2 <= lastChar do begin
    ch1 := cursor2^;
    if ch1 <> killChr then begin
      cursor1^ := ch1;
      inc(cursor1);
    end;
    inc(cursor2);
  end;
  result := cursor1 <> cursor2;
  if result then
    SetLength(str, cursor1 - PWideChar(str));
end;
{$endif}

function KillChars(var str: AnsiString; killChrs: TSChar) : boolean;
var cursor1, cursor2, lastChar : PAnsiChar;
    ch1 : AnsiChar;
begin
  UniqueString(str);
  cursor1 := PAnsiChar(str);
  cursor2 := cursor1;
  lastChar := cursor1 + Length(str) - 1;
  while cursor2 <= lastChar do begin
    ch1 := cursor2^;
    if not (ch1 in killChrs) then begin
      cursor1^ := ch1;
      inc(cursor1);
    end;
    inc(cursor2);
  end;
  result := cursor1 <> cursor2;
  if result then
    SetLength(str, cursor1 - PAnsiChar(str));
end;

{$ifdef UnicodeOverloads}
function KillChars(var str: UnicodeString; killChrs: TSChar) : boolean;
var cursor1, cursor2, lastChar : PWideChar;
    ch1 : WideChar;
begin
  UniqueString(str);
  cursor1 := PWideChar(str);
  cursor2 := cursor1;
  lastChar := cursor1 + Length(str) - 1;
  while cursor2 <= lastChar do begin
    ch1 := cursor2^;
    if (word(ch1) and $ff00 <> 0) or (not (AnsiChar(ch1) in killChrs)) then begin
      cursor1^ := ch1;
      inc(cursor1);
    end;
    inc(cursor2);
  end;
  result := cursor1 <> cursor2;
  if result then
    SetLength(str, cursor1 - PWideChar(str));
end;
{$endif}

function KillStr(var str: AnsiString; const killStr: AnsiString) : boolean; 
var cursor1, cursor2 : PAnsiChar;
    ps  : PAnsiChar;   // PAnsiChar(str);
    pks : PAnsiChar;   // PAnsiChar(killStr)
    ls  : integer;     // length(str)
    lks : integer;     // length(killStr)
    i1  : integer;
begin
  lks := length(killStr);
  UniqueString(str);
  ps := PAnsiChar(str);
  ls := Length(str);
  pks := PAnsiChar(killStr);
  i1 := PosPChar(pks, ps, lks, ls);
  result := i1 <> -1;
  if result then begin
    cursor1 := PAnsiChar(str);
    cursor2 := cursor1;
    repeat
      ls := ls - i1 - lks;
      inc(cursor1, i1);
      inc(cursor2, i1 + lks);
      i1 := PosPChar(pks, cursor2, lks, ls);
      if i1 > 0 then
        Move(cursor2^, cursor1^, i1);
    until i1 = -1;
    if ls > 0 then
      Move(cursor2^, cursor1^, ls);
    SetLength(str, cursor1 - ps + ls);
  end;
end;

{$ifdef UnicodeOverloads}
function KillStr(var str: UnicodeString; const killStr: UnicodeString) : boolean;
var cursor1, cursor2 : PWideChar;
    ps  : PWideChar;   // PWideChar(str);
    pks : PWideChar;   // PWideChar(killStr)
    ls  : integer;     // length(str)
    lks : integer;     // length(killStr)
    i1  : integer;
begin
  lks := length(killStr);
  UniqueString(str);
  ps := PWideChar(str);
  ls := Length(str);
  pks := PWideChar(killStr);
  i1 := PosPChar(pks, ps, lks, ls);
  result := i1 <> -1;
  if result then begin
    cursor1 := PWideChar(str);
    cursor2 := cursor1;
    repeat
      ls := ls - i1 - lks;
      inc(cursor1, i1);
      inc(cursor2, i1 + lks);
      i1 := PosPChar(pks, cursor2, lks, ls);
      if i1 > 0 then
        Move(cursor2^, cursor1^, i1 * 2);
    until i1 = -1;
    if ls > 0 then
      Move(cursor2^, cursor1^, ls * 2);
    SetLength(str, dword(cursor1 - ps) + dword(ls));
  end;
end;
{$endif}

function Replace(var str: AnsiString; const replaceThis, withThis: AnsiString; replaceSelf, ignoreCase: boolean) : boolean; {$ifdef UnicodeOverloads} overload; {$endif}
var cursor1, cursor2 : PAnsiChar;
    ps  : PAnsiChar;   // PAnsiChar(str);
    prt : PAnsiChar;   // PAnsiChar(replaceThis)
    pwt : PAnsiChar;   // PAnsiChar(withThis)
    ls  : integer;     // length(str)
    lrt : integer;     // length(replaceThis)
    lwt : integer;     // length(withThis)
    ld  : integer;     // length difference
    id  : integer;     // inc difference
    i1  : integer;
begin
  lrt := length(replaceThis);
  lwt := length(withThis);
  ld := lwt - lrt;
  if ld <= 0 then begin
    UniqueString(str);
    ps := PAnsiChar(str);
    ls := Length(str);
    prt := PAnsiChar(replaceThis);
    i1 := PosPChar(prt, ps, lrt, ls, ignoreCase);
    result := i1 <> -1;
    if result then begin
      cursor1 := PAnsiChar(str);
      pwt := PAnsiChar(withThis);
      if replaceSelf then begin
        repeat
          ls := ls - i1;
          inc(cursor1, i1);
          Move(pwt^, cursor1^, lwt);
          if ld <> 0 then begin
            Move(pointer(dword(cursor1) + dword(lrt))^, pointer(dword(cursor1) + dword(lwt))^, ls - lrt);
            ls := ls + ld;
          end;
          i1 := PosPChar(prt, cursor1, lrt, ls, ignoreCase);
        until i1 = -1;
        SetLength(str, dword(cursor1) - dword(ps) + dword(ls));
      end else begin
        cursor2 := cursor1;
        repeat
          ls := ls - i1 - lrt;
          inc(cursor1, i1);
          inc(cursor2, i1);
          Move(pwt^, cursor1^, lwt);
          inc(cursor1, lwt);
          inc(cursor2, lrt);
          i1 := PosPChar(prt, cursor2, lrt, ls, ignoreCase);
          if i1 > 0 then
            Move(cursor2^, cursor1^, i1);
        until i1 = -1;
        if ls > 0 then
          Move(cursor2^, cursor1^, ls);
        SetLength(str, dword(cursor1) - dword(ps) + dword(ls));
      end;
    end;
  end else begin
    i1 := PosPChar(PAnsiChar(replaceThis), PAnsiChar(str), Length(replaceThis), Length(str), ignoreCase) + 1;
    result := i1 <> 0;
    if result then begin
      if replaceSelf then
        id := 1
      else
        id := lwt;
      ls := length(str);
      repeat
        inc(ls, ld);
        SetLength(str, ls);
        Move(str[i1], str[i1 + ld], ls - i1 + 1 - ld);
        Move(withThis[1], str[i1], lwt);
        inc(i1, id);
        i1 := PosPChar(PAnsiChar(replaceThis), PAnsiChar(str), Length(replaceThis), Length(str), ignoreCase, i1 - 1, maxInt) + 1;
      until i1 = 0;
    end;
  end;
end;

{$ifdef UnicodeOverloads}
function Replace(var str: UnicodeString; const replaceThis, withThis: UnicodeString; replaceSelf, ignoreCase: boolean) : boolean; overload;
var cursor1, cursor2 : PWideChar;
    ps  : PWideChar;   // PWideChar(str);
    prt : PWideChar;   // PWideChar(replaceThis)
    pwt : PWideChar;   // PWideChar(withThis)
    ls  : integer;     // length(str)
    lrt : integer;     // length(replaceThis)
    lwt : integer;     // length(withThis)
    ld  : integer;     // length difference
    id  : integer;     // inc difference
    i1  : integer;
begin
  lrt := length(replaceThis);
  lwt := length(withThis);
  ld := lwt - lrt;
  if ld <= 0 then begin
    UniqueString(str);
    ps := PWideChar(str);
    ls := Length(str);
    prt := PWideChar(replaceThis);
    i1 := PosPChar(prt, ps, lrt, ls, ignoreCase);
    result := i1 <> -1;
    if result then begin
      cursor1 := PWideChar(str);
      pwt := PWideChar(withThis);
      if replaceSelf then begin
        repeat
          ls := ls - i1;
          inc(cursor1, i1);
          Move(pwt^, cursor1^, lwt * 2);
          if ld <> 0 then begin
            Move(pointer(dword(cursor1) + dword(lrt) * 2)^, pointer(dword(cursor1) + dword(lwt) * 2)^, (ls - lrt) * 2);
            ls := ls + ld;
          end;
          i1 := PosPChar(prt, cursor1, lrt, ls, ignoreCase);
        until i1 = -1;
        SetLength(str, dword(cursor1 - ps) + dword(ls));
      end else begin
        cursor2 := cursor1;
        repeat
          ls := ls - i1 - lrt;
          inc(cursor1, i1);
          inc(cursor2, i1);
          Move(pwt^, cursor1^, lwt * 2);
          inc(cursor1, lwt);
          inc(cursor2, lrt);
          i1 := PosPChar(prt, cursor2, lrt, ls, ignoreCase);
          if i1 > 0 then
            Move(cursor2^, cursor1^, i1 * 2);
        until i1 = -1;
        if ls > 0 then
          Move(cursor2^, cursor1^, ls * 2);
        SetLength(str, dword(cursor1 - ps) + dword(ls));
      end;
    end;
  end else begin
    i1 := PosPChar(PWideChar(replaceThis), PWideChar(str), Length(replaceThis), Length(str), ignoreCase) + 1;
    result := i1 <> 0;
    if result then begin
      if replaceSelf then
        id := 1
      else
        id := lwt;
      ls := length(str);
      repeat
        inc(ls, ld);
        SetLength(str, ls);
        Move(str[i1], str[i1 + ld], (ls - i1 + 1 - ld) * 2);
        Move(withThis[1], str[i1], lwt * 2);
        inc(i1, id);
        i1 := PosPChar(PWideChar(replaceThis), PWideChar(str), Length(replaceThis), Length(str), ignoreCase, i1 - 1, maxInt) + 1;
      until i1 = 0;
    end;
  end;
end;
{$endif}

function ReplaceStr(var str: AnsiString; const replaceThis, withThis: AnsiString;
                    replaceSelf: boolean = false) : boolean;
begin
  result := Replace(str, replaceThis, withThis, replaceSelf, false);
end;

{$ifdef UnicodeOverloads}
function ReplaceStr(var str: UnicodeString; const replaceThis, withThis: UnicodeString;
                    replaceSelf: boolean = false) : boolean;
begin
  result := Replace(str, replaceThis, withThis, replaceSelf, false);
end;
{$endif}

function ReplaceText(var str: AnsiString; const replaceThis, withThis: AnsiString;
                     replaceSelf: boolean = false) : boolean;
begin
  result := Replace(str, replaceThis, withThis, replaceSelf, true);
end;

{$ifdef UnicodeOverloads}
function ReplaceText(var str: UnicodeString; const replaceThis, withThis: UnicodeString;
                     replaceSelf: boolean = false) : boolean;
begin
  result := Replace(str, replaceThis, withThis, replaceSelf, true);
end;
{$endif}

function RetDelete(const str : AnsiString;
                   index     : cardinal;
                   count     : cardinal = maxInt) : AnsiString;
begin
  result := str;
  Delete(result, index, count);
end;

{$ifdef UnicodeOverloads}
function RetDelete(const str : UnicodeString;
                   index     : cardinal;
                   count     : cardinal = maxInt) : UnicodeString;
begin
  result := str;
  Delete(result, index, count);
end;
{$endif}

procedure DeleteR(var str: AnsiString; count: cardinal);
begin
  Delete(str, Length(str) - integer(count) + 1, maxInt);
end;

{$ifdef UnicodeOverloads}
procedure DeleteR(var str: UnicodeString; count: cardinal);
begin
  Delete(str, Length(str) - integer(count) + 1, maxInt);
end;
{$endif}

function RetDeleteR(const str: AnsiString; count: cardinal) : AnsiString;
begin
  result := Copy(str, 1, Length(str) - integer(count));
end;

{$ifdef UnicodeOverloads}
function RetDeleteR(const str: UnicodeString; count: cardinal) : UnicodeString;
begin
  result := Copy(str, 1, Length(str) - integer(count));
end;
{$endif}

procedure Keep(var str : AnsiString;
               index   : cardinal;
               count   : cardinal = maxInt);
begin
  str := Copy(str, index, count);
end;

{$ifdef UnicodeOverloads}
procedure Keep(var str : UnicodeString;
               index   : cardinal;
               count   : cardinal = maxInt);
begin
  str := Copy(str, index, count);
end;
{$endif}

procedure KeepR(var str: AnsiString; count: cardinal);
begin
  Delete(str, 1, Length(str) - integer(count));
end;

{$ifdef UnicodeOverloads}
procedure KeepR(var str: UnicodeString; count: cardinal);
begin
  Delete(str, 1, Length(str) - integer(count));
end;
{$endif}

function CopyR(const str: AnsiString; count: cardinal) : AnsiString;
begin
  result := Copy(str, Length(str) - integer(count) + 1, maxInt);
end;

{$ifdef UnicodeOverloads}
function CopyR(const str: UnicodeString; count: cardinal) : UnicodeString;
begin
  result := Copy(str, Length(str) - integer(count) + 1, maxInt);
end;
{$endif}

var lowCharTable : array [AnsiChar] of AnsiChar =
  (#$00,#$01,#$02,#$03,#$04,#$05,#$06,#$07,#$08,#$09,#$0A,#$0B,#$0C,#$0D,#$0E,#$0F,
   #$10,#$11,#$12,#$13,#$14,#$15,#$16,#$17,#$18,#$19,#$1A,#$1B,#$1C,#$1D,#$1E,#$1F,
   #$20,#$21,#$22,#$23,#$24,#$25,#$26,#$27,#$28,#$29,#$2A,#$2B,#$2C,#$2D,#$2E,#$2F,
   #$30,#$31,#$32,#$33,#$34,#$35,#$36,#$37,#$38,#$39,#$3A,#$3B,#$3C,#$3D,#$3E,#$3F,
   #$40,#$61,#$62,#$63,#$64,#$65,#$66,#$67,#$68,#$69,#$6A,#$6B,#$6C,#$6D,#$6E,#$6F,
   #$70,#$71,#$72,#$73,#$74,#$75,#$76,#$77,#$78,#$79,#$7A,#$5B,#$5C,#$5D,#$5E,#$5F,
   #$60,#$61,#$62,#$63,#$64,#$65,#$66,#$67,#$68,#$69,#$6A,#$6B,#$6C,#$6D,#$6E,#$6F,
   #$70,#$71,#$72,#$73,#$74,#$75,#$76,#$77,#$78,#$79,#$7A,#$7B,#$7C,#$7D,#$7E,#$7F,
   #$80,#$81,#$82,#$83,#$84,#$85,#$86,#$87,#$88,#$89,#$9A,#$8B,#$9C,#$8D,#$9E,#$8F,
   #$90,#$91,#$92,#$93,#$94,#$95,#$96,#$97,#$98,#$99,#$9A,#$9B,#$9C,#$9D,#$9E,#$FF,
   #$A0,#$A1,#$A2,#$A3,#$A4,#$A5,#$A6,#$A7,#$A8,#$A9,#$AA,#$AB,#$AC,#$AD,#$AE,#$AF,
   #$B0,#$B1,#$B2,#$B3,#$B4,#$B5,#$B6,#$B7,#$B8,#$B9,#$BA,#$BB,#$BC,#$BD,#$BE,#$BF,
   #$E0,#$E1,#$E2,#$E3,#$E4,#$E5,#$E6,#$E7,#$E8,#$E9,#$EA,#$EB,#$EC,#$ED,#$EE,#$EF,
   #$F0,#$F1,#$F2,#$F3,#$F4,#$F5,#$F6,#$D7,#$F8,#$F9,#$FA,#$FB,#$FC,#$FD,#$FE,#$DF,
   #$E0,#$E1,#$E2,#$E3,#$E4,#$E5,#$E6,#$E7,#$E8,#$E9,#$EA,#$EB,#$EC,#$ED,#$EE,#$EF,
   #$F0,#$F1,#$F2,#$F3,#$F4,#$F5,#$F6,#$F7,#$F8,#$F9,#$FA,#$FB,#$FC,#$FD,#$FE,#$FF);
{
procedure SaveLowCharTable(fileName: AnsiString);
var s1, s2 : AnsiString;
    i1     : integer;
begin
  SetLength(s1, 255);
  for i1 := 1 to 255 do s1[i1] := AnsiChar(i1);
  s1 := AnsiLowerCase(s1);
  with TFileStream.Create(fileName, fmCreate) do
    try
      s2 := '#$00,';
      for i1 := 1 to 255 do begin
        if i1 mod 16 = 0 then s2 := s2 + #$D#$A;
        s2 := s2 + '#$' + IntToHex(cardinal(s1[i1]), 2) + ',';
      end;
      WriteBuffer(pointer(s2)^, Length(s2));
    finally Free end;
end;
}

function UpChar(const c: AnsiChar) : AnsiChar;
begin
  if c in ['a'..'z', 'ö', 'ä', 'ü'] then
    result := AnsiChar(ord(c) - 32)
  else
    result := c;
end;

{$ifdef UnicodeOverloads}
function UpChar(const c: WideChar) : WideChar;
begin
  if (word(c) and $ff00 = 0) and (AnsiChar(c) in ['a'..'z', 'ö', 'ä', 'ü']) then
    result := WideChar(ord(c) - 32)
  else
    result := c;
end;
{$endif}

function UpStr(const s: AnsiString) : AnsiString;
var i1, i2 : integer;
begin
  result := s;
  i2 := Length(s);
  for i1 := 1 to i2 do
    if s[i1] in ['a'..'z','ö','ä','ü'] then
      result[i1] := AnsiChar(ord(s[i1]) - 32);
end;

{$ifdef UnicodeOverloads}
function UpStr(const s: UnicodeString) : UnicodeString;
var i1, i2 : integer;
begin
  result := s;
  i2 := Length(s);
  for i1 := 1 to i2 do
    if (word(s[i1]) and $ff00 = 0) and (AnsiChar(s[i1]) in ['a'..'z','ö','ä','ü']) then
      result[i1] := WideChar(ord(s[i1]) - 32);
end;
{$endif}

function LowChar(const c: AnsiChar) : AnsiChar;
begin
  result := lowCharTable[c];
end;

{$ifdef UnicodeOverloads}
function LowChar(const c: WideChar) : WideChar;
begin
  if word(c) and $ff00 <> 0 then
    result := c
  else
    result := WideChar(lowCharTable[AnsiChar(c)]);
end;
{$endif}

function LowStr(const s: AnsiString) : AnsiString;
var i1, i2 : integer;
begin
  result := s;
  i2 := Length(s);
  for i1 := 1 to i2 do
    if s[i1] in ['A'..'Z','Ö','Ä','Ü'] then
      result[i1] := AnsiChar(ord(s[i1]) + 32);
end;

{$ifdef UnicodeOverloads}
function LowStr(const s: UnicodeString) : UnicodeString;
var i1, i2 : integer;
begin
  result := s;
  i2 := Length(s);
  for i1 := 1 to i2 do
    if (word(s[i1]) and $ff00 = 0) and (AnsiChar(s[i1]) in ['A'..'Z','Ö','Ä','Ü']) then
      result[i1] := WideChar(ord(s[i1]) + 32);
end;
{$endif}

function BooleanToChar(value: boolean) : AnsiString;
begin
  if value then result := '+' else result := '-';
end;

function IsTextEqual(const s1, s2: AnsiString) : boolean;
var c1, c2 : cardinal;
begin
  c1 := Length(s1);
  result := cardinal(Length(s2)) = c1;
  if result then
    for c2 := 1 to c1 do
      if lowCharTable[s1[c2]] <> lowCharTable[s2[c2]] then begin
        result := false;
        break;
      end;
end;

{$ifdef UnicodeOverloads}
function IsTextEqual(const s1, s2: UnicodeString) : boolean;
var c1, c2 : cardinal;
    b1, b2 : boolean;
begin
  c1 := Length(s1);
  result := cardinal(Length(s2)) = c1;
  if result then
    for c2 := 1 to c1 do begin
      b1 := word(s1[c2]) and $ff00 = 0;
      b2 := word(s2[c2]) and $ff00 = 0;
      if b1 <> b2 then begin
        result := false;
        break;
      end;
      if b1 then begin
        if lowCharTable[AnsiChar(s1[c2])] <> lowCharTable[AnsiChar(s2[c2])] then begin
          result := false;
          break;
        end;
      end else
        if s1[c2] <> s2[c2] then begin
          result := false;
          break;
        end;
    end;
end;
{$endif}

function CompareStr(const s1, s2: AnsiString) : integer;
asm      //               EAX EDX           EAX
        CMP     EAX,EDX
        JNE     @@doIt
        XOR     EAX,EAX
        JMP     @@noWork
@@doIt:
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX
        OR      EAX,EAX
        JE      @@s1Nil
        MOV     EAX,[EAX-4]
@@s1Nil:
        OR      EDX,EDX
        JE      @@s2Nil
        MOV     EDX,[EDX-4]
@@s2Nil:
        MOV     ECX,EAX
        CMP     ECX,EDX
        JBE     @@s1Shorter
        MOV     ECX,EDX
@@s1Shorter:
        CMP     ECX,ECX
        REPE    CMPSB
        JE      @@firstCharsEqual
        MOVZX   EAX,BYTE PTR [ESI-1]
        MOVZX   EDX,BYTE PTR [EDI-1]
@@firstCharsEqual:
        SUB     EAX,EDX
        POP     EDI
        POP     ESI
@@noWork:
end;

{$ifdef UnicodeOverloads}
function CompareStr(const s1, s2: UnicodeString) : integer; 
asm      //               EAX EDX           EAX
        CMP     EAX,EDX
        JNE     @@doIt
        XOR     EAX,EAX
        JMP     @@noWork
@@doIt:
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,EAX
        MOV     EDI,EDX
        OR      EAX,EAX
        JE      @@s1Nil
        MOV     EAX,[EAX-4]
        {$ifndef UNICODE}
          SHR     EAX,1
        {$ENDIF}
@@s1Nil:
        OR      EDX,EDX
        JE      @@s2Nil
        MOV     EDX,[EDX-4]
        {$ifndef UNICODE}
          SHR     EDX,1
        {$ENDIF}
@@s2Nil:
        MOV     ECX,EAX
        CMP     ECX,EDX
        JBE     @@s1Shorter
        MOV     ECX,EDX
@@s1Shorter:
        CMP     ECX,ECX
        REPE    CMPSW
        JE      @@firstCharsEqual
        MOVZX   EAX,WORD PTR [ESI-2]
        MOVZX   EDX,WORD PTR [EDI-2]
@@firstCharsEqual:
        SUB     EAX,EDX
        POP     EDI
        POP     ESI
@@noWork:
end;
{$endif}

function CompareText(const s1, s2: AnsiString) : integer;
var c1, c2, c3, c4 : cardinal;
    ch1, ch2       : AnsiChar;
begin
  c1 := Length(s1);
  c2 := Length(s2);
  if c1 < c2 then
    c3 := c1
  else
    c3 := c2;
  for c4 := 1 to c3 do begin
    ch1 := lowCharTable[s1[c4]];
    ch2 := lowCharTable[s2[c4]];
    if ch1 <> ch2 then begin
      result := ord(ch1) - ord(ch2);
      exit;
    end;
  end;
  result := integer(c1) - integer(c2);
end;

{$ifdef UnicodeOverloads}
function CompareText(const s1, s2: UnicodeString) : integer;
var c1, c2, c3, c4 : cardinal;
    ch1, ch2       : WideChar;
begin
  c1 := Length(s1);
  c2 := Length(s2);
  if c1 < c2 then
    c3 := c1
  else
    c3 := c2;
  for c4 := 1 to c3 do begin
    ch1 := s1[c4];
    if word(ch1) and $ff00 = 0 then
      ch1 := WideChar(lowCharTable[AnsiChar(ch1)]);
    ch2 := s2[c4];
    if word(ch2) and $ff00 = 0 then
      ch2 := WideChar(lowCharTable[AnsiChar(ch2)]);
    if ch1 <> ch2 then begin
      result := ord(ch1) - ord(ch2);
      exit;
    end;
  end;
  result := integer(c1) - integer(c2);
end;
{$endif}

function PosStr(const subStr : AnsiString;
                const str    : AnsiString;
                fromPos      : cardinal = 1;
                toPos        : cardinal = maxInt) : integer;
begin
  if (fromPos > 0) and (toPos > 0) then
       result := PosPChar(PAnsiChar(subStr), PAnsiChar(str), Length(subStr), Length(str), false, fromPos - 1, toPos - 1) + 1
  else result := 0;
end;

{$ifdef UnicodeOverloads}
function PosStr(const subStr : UnicodeString;
                const str    : UnicodeString;
                fromPos      : cardinal = 1;
                toPos        : cardinal = maxInt) : integer;
begin
  if (fromPos > 0) and (toPos > 0) then
       result := PosPChar(PWideChar(subStr), PWideChar(str), Length(subStr), Length(str), false, fromPos - 1, toPos - 1) + 1
  else result := 0;
end;
{$endif}

function PosText(const subStr : AnsiString;
                 const str    : AnsiString;
                 fromPos      : cardinal = 1;
                 toPos        : cardinal = maxInt) : integer;
begin
  if (fromPos > 0) and (toPos > 0) then
       result := PosPChar(PAnsiChar(subStr), PAnsiChar(str), Length(subStr), Length(str), true, fromPos - 1, toPos - 1) + 1
  else result := 0;
end;

{$ifdef UnicodeOverloads}
function PosText(const subStr : UnicodeString;
                 const str    : UnicodeString;
                 fromPos      : cardinal = 1;
                 toPos        : cardinal = maxInt) : integer;
begin
  if (fromPos > 0) and (toPos > 0) then
       result := PosPChar(PWideChar(subStr), PWideChar(str), Length(subStr), Length(str), true, fromPos - 1, toPos - 1) + 1
  else result := 0;
end;
{$endif}

function PosPChar(subStr       : PAnsiChar;
                  str          : PAnsiChar;
                  subStrLen    : cardinal = 0;   // 0 -> StrLen is called internally
                  strLen       : cardinal = 0;
                  ignoreCase   : boolean  = false;
                  fromPos      : cardinal = 0;
                  toPos        : cardinal = maxInt) : integer;

  function GetPCharLen(const pc: PAnsiChar) : cardinal;
  asm
    MOV     EDX,EDI
    MOV     EDI,EAX
    MOV     ECX,0FFFFFFFFH
    XOR     AL,AL
    REPNE   SCASB
    MOV     EAX,0FFFFFFFEH
    SUB     EAX,ECX
    MOV     EDI,EDX
  end;

var pc1, pc2, pc3, pc4, pc5, pc6 : PAnsiChar;
    c1                           : cardinal;
    ch1                          : AnsiChar;
begin
  result := -1;
  if (subStr <> nil) and ((subStrLen <> 0) or (subStr^ <> #0)) and
     (   str <> nil) and ((   strLen <> 0) or (   str^ <> #0)) then begin
    if subStrLen = 0 then subStrLen := GetPCharLen(subStr);
    if    strLen = 0 then    strLen := GetPCharLen(   str);
    if strLen >= subStrLen then begin
      c1 := strLen - subStrLen;
      if ignoreCase then
        ch1 := lowCharTable[subStr^]
      else
        ch1 := subStr^;
      if fromPos > toPos then begin
        if toPos <= c1 then begin
          if fromPos > c1 then
            fromPos := c1;
          pc1 := str + fromPos;
          pc2 := str + toPos;
          pc3 := subStr + 1;
          pc4 := subStr + subStrLen - 1;
          pc6 := pc3;
          if ignoreCase then begin
            while pc1 >= pc2 do
              if lowCharTable[pc1^] = ch1 then begin
                inc(pc1);
                pc5 := pc1;
                while (pc3 <= pc4) and (lowCharTable[pc1^] = lowCharTable[pc3^]) do begin
                  inc(pc1);
                  inc(pc3);
                end;
                if pc3 > pc4 then begin
                  result := pc5 - PAnsiChar(str) - 1;
                  break;
                end;
                pc3 := pc6;
                pc1 := pc5 - 2;
              end else
                dec(pc1);
          end else
            while pc1 >= pc2 do
              if pc1^ = ch1 then begin
                inc(pc1);
                pc5 := pc1;
                while (pc3 <= pc4) and (pc1^ = pc3^) do begin
                  inc(pc1); inc(pc3);
                end;
                if pc3 > pc4 then begin
                  result := pc5 - PAnsiChar(str) - 1;
                  break;
                end;
                pc3 := pc6;
                pc1 := pc5 - 2;
              end else
                dec(pc1);
        end;
      end else
        if fromPos <= c1 then begin
          if toPos > c1 then
            toPos := c1;
          pc1 := str + fromPos;
          pc2 := str + toPos;
          pc3 := subStr + 1;
          pc4 := subStr + subStrLen - 1;
          pc6 := pc3;
          if ignoreCase then begin
            while pc1 <= pc2 do
              if lowCharTable[pc1^] = ch1 then begin
                inc(pc1);
                pc5 := pc1;
                while (pc3 <= pc4) and (lowCharTable[pc1^] = lowCharTable[pc3^]) do begin
                  inc(pc1);
                  inc(pc3);
                end;
                if pc3 > pc4 then begin
                  result := pc5 - PAnsiChar(str) - 1;
                  break;
                end;
                pc3 := pc6;
                pc1 := pc5;
              end else
                inc(pc1);
          end else
            while pc1 <= pc2 do
              if pc1^ = ch1 then begin
                inc(pc1);
                pc5 := pc1;
                while (pc3 <= pc4) and (pc1^ = pc3^) do begin
                  inc(pc1); inc(pc3);
                end;
                if pc3 > pc4 then begin
                  result := pc5 - PAnsiChar(str) - 1;
                  break;
                end;
                pc3 := pc6;
                pc1 := pc5;
              end else
                inc(pc1);
        end;
    end;
  end;
end;

{$ifdef UnicodeOverloads}
function PosPChar(subStr       : PWideChar;
                  str          : PWideChar;
                  subStrLen    : cardinal = 0;   // 0 -> StrLen is called internally
                  strLen       : cardinal = 0;
                  ignoreCase   : boolean  = false;
                  fromPos      : cardinal = 0;
                  toPos        : cardinal = maxInt) : integer;

  function GetPCharLen(const pc: PWideChar) : cardinal;
  asm
    MOV     EDX,EDI
    MOV     EDI,EAX
    MOV     ECX,0FFFFFFFFH
    XOR     AX,AX
    REPNE   SCASW
    MOV     EAX,0FFFFFFFEH
    SUB     EAX,ECX
    MOV     EDI,EDX
  end;

var pc1, pc2, pc3, pc4, pc5, pc6 : PWideChar;
    c1                           : cardinal;
    ch1, ch2, ch3                : WideChar;
begin
  result := -1;
  if (subStr <> nil) and ((subStrLen <> 0) or (subStr^ <> #0)) and
     (   str <> nil) and ((   strLen <> 0) or (   str^ <> #0)) then begin
    if subStrLen = 0 then subStrLen := GetPCharLen(subStr);
    if    strLen = 0 then    strLen := GetPCharLen(   str);
    if strLen >= subStrLen then begin
      c1 := strLen - subStrLen;
      ch1 := subStr^;
      if ignoreCase and (word(ch1) and $ff00 = 0) then
        ch1 := WideChar(lowCharTable[AnsiChar(ch1)]);
      if fromPos > toPos then begin
        if toPos <= c1 then begin
          if fromPos > c1 then
            fromPos := c1;
          pc1 := str + fromPos;
          pc2 := str + toPos;
          pc3 := subStr + 1;
          pc4 := subStr + subStrLen - 1;
          pc6 := pc3;
          if ignoreCase then begin
            while pc1 >= pc2 do begin
              ch3 := pc1^;
              if word(ch3) and $ff00 = 0 then
                ch3 := WideChar(lowCharTable[AnsiChar(ch3)]);
              if ch1 = ch3 then begin
                inc(pc1);
                pc5 := pc1;
                while pc3 <= pc4 do begin
                  ch2 := pc1^;
                  if word(ch2) and $ff00 = 0 then
                    ch2 := WideChar(lowCharTable[AnsiChar(ch2)]);
                  ch3 := pc3^;
                  if word(ch3) and $ff00 = 0 then
                    ch3 := WideChar(lowCharTable[AnsiChar(ch3)]);
                  if ch2 <> ch3 then
                    break;
                  inc(pc1);
                  inc(pc3);
                end;
                if pc3 > pc4 then begin
                  result := integer(pc5 - str) - 1;
                  break;
                end;
                pc3 := pc6;
                pc1 := pc5;
                dec(pc1, 2);
              end else
                dec(pc1);
            end;
          end else
            while pc1 >= pc2 do
              if pc1^ = ch1 then begin
                inc(pc1);
                pc5 := pc1;
                while (pc3 <= pc4) and (pc1^ = pc3^) do begin
                  inc(pc1);
                  inc(pc3);
                end;
                if pc3 > pc4 then begin
                  result := integer(pc5 - str) - 1;
                  break;
                end;
                pc3 := pc6;
                pc1 := pc5;
                dec(pc1, 2);
              end else
                dec(pc1);
        end;
      end else
        if fromPos <= c1 then begin
          if toPos > c1 then
            toPos := c1;
          pc1 := str + fromPos;
          pc2 := str + toPos;
          pc3 := subStr + 1;
          pc4 := subStr + subStrLen - 1;
          pc6 := pc3;
          if ignoreCase then begin
            while pc1 <= pc2 do begin
              ch3 := pc1^;
              if word(ch3) and $ff00 = 0 then
                ch3 := WideChar(lowCharTable[AnsiChar(ch3)]);
              if ch1 = ch3 then begin
                inc(pc1);
                pc5 := pc1;
                while pc3 <= pc4 do begin
                  ch2 := pc1^;
                  if word(ch2) and $ff00 = 0 then
                    ch2 := WideChar(lowCharTable[AnsiChar(ch2)]);
                  ch3 := pc3^;
                  if word(ch3) and $ff00 = 0 then
                    ch3 := WideChar(lowCharTable[AnsiChar(ch3)]);
                  if ch2 <> ch3 then
                    break;
                  inc(pc1);
                  inc(pc3);
                end;
                if pc3 > pc4 then begin
                  result := integer(pc5 - str) - 1;
                  break;
                end;
                pc3 := pc6;
                pc1 := pc5;
              end else
                inc(pc1);
            end;
          end else
            while pc1 <= pc2 do
              if pc1^ = ch1 then begin
                inc(pc1);
                pc5 := pc1;
                while (pc3 <= pc4) and (pc1^ = pc3^) do begin
                  inc(pc1);
                  inc(pc3);
                end;
                if pc3 > pc4 then begin
                  result := integer(pc5 - str) - 1;
                  break;
                end;
                pc3 := pc6;
                pc1 := pc5;
              end else
                inc(pc1);
        end;
    end;
  end;
end;
{$endif}

function PosStrIs1(const subStr : AnsiString;
                   const str    : AnsiString) : boolean;
var c1, c2 : cardinal;
begin
  c1 := Length(   str);
  c2 := Length(subStr);
  if      c1 < c2 then result := false
  else if c2 = 0  then result := true
  else if c1 = c2 then result := subStr = str
  else                 result := PosPChar(PAnsiChar(subStr), PAnsiChar(str), Length(subStr), Length(str), false, 0, 0) = 0;
end;

{$ifdef UnicodeOverloads}
function PosStrIs1(const subStr : UnicodeString;
                   const str    : UnicodeString) : boolean;
var c1, c2 : cardinal;
begin
  c1 := Length(   str);
  c2 := Length(subStr);
  if      c1 < c2 then result := false
  else if c2 = 0  then result := true
  else if c1 = c2 then result := subStr = str
  else                 result := PosPChar(PWideChar(subStr), PWideChar(str), Length(subStr), Length(str), false, 0, 0) = 0;
end;
{$endif}

function PosTextIs1(const subStr : AnsiString;
                    const str    : AnsiString) : boolean;
var c1, c2 : cardinal;
begin
  c1 := Length(   str);
  c2 := Length(subStr);
  if      c1 < c2 then result := false
  else if c2 = 0  then result := true
  else if c1 = c2 then result := IsTextEqual(subStr, str)
  else                 result := PosPChar(PAnsiChar(subStr), PAnsiChar(str), Length(subStr), Length(str), true, 0, 0) = 0;
end;

{$ifdef UnicodeOverloads}
function PosTextIs1(const subStr : UnicodeString;
                    const str    : UnicodeString) : boolean;
var c1, c2 : cardinal;
begin
  c1 := Length(   str);
  c2 := Length(subStr);
  if      c1 < c2 then result := false
  else if c2 = 0  then result := true
  else if c1 = c2 then result := IsTextEqual(subStr, str)
  else                 result := PosPChar(PWideChar(subStr), PWideChar(str), Length(subStr), Length(str), true, 0, 0) = 0;
end;
{$endif}

function PosChars(const ch  : TSChar;
                  const str : AnsiString;
                  fromPos   : cardinal = 1;
                  toPos     : cardinal = maxInt) : integer;
var c1 : cardinal;
begin
  result := 0;
  if str <> '' then begin
    c1 := Length(str);
    if fromPos > toPos then begin
      if toPos <= c1 then begin
        if fromPos > c1 then fromPos := c1;
        for c1 := fromPos downto toPos do
          if str[c1] in ch then begin
            result := c1;
            break;
          end;
      end;
    end else
      if fromPos <= c1 then begin
        if toPos > c1 then toPos := c1;
        for c1 := fromPos to toPos do
          if str[c1] in ch then begin
            result := c1;
            break;
          end;
      end;
  end;
end;

{$ifdef UnicodeOverloads}
function PosChars(const ch  : TSChar;
                  const str : UnicodeString;
                  fromPos   : cardinal = 1;
                  toPos     : cardinal = maxInt) : integer;
var c1  : cardinal;
    ch1 : WideChar;
begin
  result := 0;
  if str <> '' then begin
    c1 := Length(str);
    if fromPos > toPos then begin
      if toPos <= c1 then begin
        if fromPos > c1 then
          fromPos := c1;
        for c1 := fromPos downto toPos do begin
          ch1 := str[c1];
          if (word(ch1) and $ff00 = 0) and (AnsiChar(ch1) in ch) then begin
            result := c1;
            break;
          end;
        end;
      end;
    end else
      if fromPos <= c1 then begin
        if toPos > c1 then
          toPos := c1;
        for c1 := fromPos to toPos do begin
          ch1 := str[c1];
          if (word(ch1) and $ff00 = 0) and (AnsiChar(ch1) in ch) then begin
            result := c1;
            break;
          end;
        end;
      end;
  end;
end;
{$endif}

function StrMatch(const str, mask: AnsiString) : boolean;
var cs, cm : PAnsiChar;
    ms, mm : PAnsiChar;
    b1     : boolean;
begin
  cm := PAnsiChar(mask);
  result := (cm[0] = '*') and (cm[1] = #0);
  if not result then begin
    cs := PAnsiChar(str);
    ms := cs;
    mm := cm;
    b1 := false;
    while (cm^ <> #0) or (cs^ <> #0) do begin
      if cm^ = #0 then
        exit;
      if cs^ = #0 then begin
        while cm^ <> #0 do begin
          if cm^ <> '*' then
            exit;
          inc(cm);
        end;
        break;
      end;
      case cm^ of
        '*': if cm[1] <> #0 then begin
               b1 := true;
               inc(cm);
               ms := cs + 1;
               mm := cm;
             end else
               break;
        '?': begin
               inc(cs);
               inc(cm);
             end;
        else if cm^ <> cs^ then begin
               if b1 then begin
                 cm := mm;
                 cs := ms;
                 inc(ms);
               end else
                 exit;
             end else begin
               inc(cs);
               inc(cm);
             end;
      end;
    end;
    result := true;
  end;
end;

function InternalStrMatchW(const str, mask: UnicodeString; fileMode: boolean) : boolean;
var cs, cm : PWideChar;
    ms, mm : PWideChar;
    b1     : boolean;
begin
  cm := PWideChar(mask);
  result := (cm[0] = '*') and (cm[1] = #0);
  if not result then begin
    cs := PWideChar(str);
    ms := cs;
    mm := cm;
    b1 := false;
    while (cm^ <> #0) or (cs^ <> #0) do begin
      if cm^ = #0 then
        exit;
      if cs^ = #0 then begin
        if fileMode and (cm^ = '.') and (cs > PWideChar(str)) and ((cs - 1)^ <> '.') then
          inc(cm);
        while cm^ = '*' do
          inc(cm);
        result := cm^ = #0;
        exit;
      end;
      case cm^ of
        '*': if cm[1] <> #0 then begin
               b1 := true;
               inc(cm);
               ms := cs + 1;
               mm := cm;
             end else
               break;
        '?': begin
               inc(cs);
               inc(cm);
             end;
        else if cm^ <> cs^ then begin
               if b1 then begin
                 cm := mm;
                 cs := ms;
                 inc(ms);
               end else
                 exit;
             end else begin
               inc(cs);
               inc(cm);
             end;
      end;
    end;
    result := true;
  end;
end;

{$ifdef UnicodeOverloads}
function StrMatch(const str, mask: UnicodeString) : boolean; overload;
begin
  result := InternalStrMatchW(str, mask, false);
end;
{$endif}

function TextMatch(const str, mask: AnsiString) : boolean;
var cs, cm : PAnsiChar;
    ms, mm : PAnsiChar;
    b1     : boolean;
begin
  cm := PAnsiChar(mask);
  result := (cm[0] = '*') and (cm[1] = #0);
  if not result then begin
    cs := PAnsiChar(str);
    ms := cs;
    mm := cm;
    b1 := false;
    while (cm^ <> #0) or (cs^ <> #0) do begin
      if cm^ = #0 then
        exit;
      if cs^ = #0 then begin
        while cm^ <> #0 do begin
          if cm^ <> '*' then
            exit;
          inc(cm);
        end;
        break;
      end;
      case cm^ of
        '*': if cm[1] <> #0 then begin
               b1 := true;
               inc(cm);
               ms := cs + 1;
               mm := cm;
             end else
               break;
        '?': begin
               inc(cs);
               inc(cm);
             end;
        else if lowCharTable[cm^] <> lowCharTable[cs^] then begin
               if b1 then begin
                 cm := mm;
                 cs := ms;
                 inc(ms);
               end else
                 exit;
             end else begin
               inc(cs);
               inc(cm);
             end;
      end;
    end;
    result := true;
  end;
end;

{$ifdef UnicodeOverloads}
function TextMatch(const str, mask: UnicodeString) : boolean;
var cs, cm   : PWideChar;
    ms, mm   : PWideChar;
    b1       : boolean;
    ch1, ch2 : WideChar;
begin
  cm := PWideChar(mask);
  result := (cm[0] = '*') and (cm[1] = #0);
  if not result then begin
    cs := PWideChar(str);
    ms := cs;
    mm := cm;
    b1 := false;
    while (cm^ <> #0) or (cs^ <> #0) do begin
      if cm^ = #0 then
        exit;
      if cs^ = #0 then begin
        while cm^ <> #0 do begin
          if cm^ <> '*' then
            exit;
          inc(cm);
        end;
        break;
      end;
      case cm^ of
        '*': if cm[1] <> #0 then begin
               b1 := true;
               inc(cm);
               ms := cs + 1;
               mm := cm;
             end else
               break;
        '?': begin
               inc(cs);
               inc(cm);
             end;
        else begin
               ch1 := cm^;
               if word(ch1) and $ff00 = 0 then
                 ch1 := WideChar(lowCharTable[AnsiChar(ch1)]);
               ch2 := cs^;
               if word(ch2) and $ff00 = 0 then
                 ch2 := WideChar(lowCharTable[AnsiChar(ch2)]);
               if ch1 <> ch2 then begin
                 if b1 then begin
                   cm := mm;
                   cs := ms;
                   inc(ms);
                 end else
                   exit;
               end else begin
                 inc(cs);
                 inc(cm);
               end;
             end;
      end;
    end;
    result := true;
  end;
end;
{$endif}

const CSpecialCharBegin = '[';
      CSpecialCharEnd   = ']';

function ParseSpecialString(ignoreCase: boolean; var cm: PAnsiChar; var cset: TSChar;
                                                 var b2: boolean; var sc: integer) : boolean;
const CControlChars : TSChar = [#0, CSpecialCharEnd, ':', ',', '.'];
var pc1 : PAnsiChar;    // PAnsiChar memory
    s1  : AnsiString;   // string help variable
    ch1 : AnsiChar;     // char counter variable
begin
  result := false;
  cset := []; sc := 1;   // inizialize return values to default value
  inc(cm);               // skip CSpecialCharBegin char
  b2 := cm^ = '!';
  if b2 then inc(cm);    // (match) or (not match) ?
  while true do begin
    pc1 := cm;           // remember current char
    while not (cm^ in CControlChars) do inc(cm);        // search first control char
    case cm^ of
      #0                  : exit;                       // CSpecialCharEnd char missing!!
      ':'                 : begin                       // Length value found
                              SetLength(s1, cm - pc1);
                              Move(pc1^, pointer(s1)^, cm - pc1);
                              sc := StrToIntEx(false, PAnsiChar(s1), Length(s1));
                              if sc = 0 then exit;      // if Length is 0 or no integer value -> error!!
                            end;
      ',',CSpecialCharEnd : if cm - pc1 = 1 then begin  // ",x," single char, must be 1 byte long
                              if ignoreCase then
                                   Include(cset, lowCharTable[pc1^])      // fill char set
                              else Include(cset, pc1^);
                              if cm^ = CSpecialCharEnd then begin           // we are ready with parsing...
                                inc(cm);
                                break;
                              end;
                            end else exit;
      '.'                 : if cm - pc1 = 1 then begin  // ",x..y," multiple chars, both x and y must be 1 byte long
                              inc(cm);
                              while cm^ = '.' do inc(cm);                 // skip all '.' chars
                              if cm^ in CControlChars then exit;          // y must not be a control char
                              if cm^ < pc1^ then exit;                    // ",y..x," is not valid
                              for ch1 := pc1^ to cm^ do                   // fill char set
                                if ignoreCase then
                                     Include(cset, lowCharTable[ch1])
                                else Include(cset, ch1);
                              inc(cm);
                              if cm^ = CSpecialCharEnd then begin         // we are ready with parsing...
                                inc(cm);
                                break;
                              end;
                              if cm^ <> ',' then exit;                    // otherwise a ',' MUST follow...
                            end else exit;
    end;
    inc(cm);
  end;
  result := true;
end;

function StrMatchEx(const str, mask: AnsiString) : boolean;
var cs, cm : PAnsiChar;    // cursorString, cursorMask
    ms, mm : PAnsiChar;    // memoryString, memoryMask
    b1     : boolean;      // found "*" in mask ?
    cset   : TSChar;       // for special purposes...
    b2     : boolean;      // special or not special, that's here the question...   :-)
    sc     : integer;      // special char count
    i1     : integer;      // integer counter variable
begin
  cm := PAnsiChar(mask);
  result := (cm^ = '*') and ((cm + 1)^ = #0);  // mask = '*' ?
  if not result then begin
    cs := PAnsiChar(str);
    ms := cs;
    mm := cm;
    b1 := false;
    while (cm^ <> #0) or (cs^ <> #0) do begin
      if cm^ = #0 then exit;   // if mask is empty before string is empty -> no match
      if cs^ = #0 then begin   // if string is empty before mask is empty -> match only if rest of mask '*****'...
        while cm^ <> #0 do begin
          if cm^ <> '*' then exit;
          inc(cm);
        end;
        break;
      end;
      case cm^ of
        '*': if (cm + 1)^ <> #0 then begin        // '*' found -> match if '*' is last char of mask
               b1 := true;                        // else continue testing...
               inc(cm);                           // memoryMask   -> first char after '*'
               ms := cs + 1;                      // memoryString -> currentPos + 1
               mm := cm;
             end else break;
        '?': begin
               inc(cs); inc(cm);                  // '?' simply means, we can skip one char in both string and mask
             end;
        CSpecialCharBegin:                        // ooops... now it gets more difficult...  :-)
             begin
               if not ParseSpecialString(false, cm, cset, b2, sc) then exit;  // wrong special character syntax !!
               for i1 := 1 to sc do
                 if (cs^ in cset) = b2 then begin // current char does match ?
                   if b1 then begin               // it does not, but we have already found a '*' some time ago...
                     cm := mm;                    // continue with memoryMask /
                     cs := ms;                    //                            memoryString /
                     inc(ms);                     //                                           inc(memoryString)
                     break;                       // break the special loop...
                   end else exit;                 // it does not match, and we had no '*' yet, so -> no match
                 end else inc(cs);                // current char matches, so move string cursors + 1
             end;
        else if cm^ <> cs^ then begin             // current char does match ?
               if b1 then begin                   // it does not, but we have already found a '*' some time ago...
                 cm := mm;                        // continue with memoryMask /
                 cs := ms;                        //                            memoryString /
                 inc(ms);                         //                                           inc(memoryString)
               end else exit;                     // it does not match, and we had no '*' yet, so -> no match
             end else begin
               inc(cs); inc(cm);                  // current char matches, so move both cursors + 1
             end;
      end;
    end;
    result := true;
  end;
end;

function TextMatchEx(const str, mask: AnsiString) : boolean;
var cs, cm : PAnsiChar;
    ms, mm : PAnsiChar;
    b1     : boolean;
    cset   : TSChar;
    b2     : boolean;
    sc     : integer;
    i1     : integer;
begin
  cm := PAnsiChar(mask);
  result := (cm^ = '*') and ((cm + 1)^ = #0);
  if not result then begin
    cs := PAnsiChar(str);
    ms := cs;
    mm := cm;
    b1 := false;
    while (cm^ <> #0) or (cs^ <> #0) do begin
      if cm^ = #0 then exit;
      if cs^ = #0 then begin
        while cm^ <> #0 do begin
          if cm^ <> '*' then exit;
          inc(cm);
        end;
        break;
      end;
      case cm^ of
        '*': if (cm + 1)^ <> #0 then begin
               b1 := true;
               inc(cm);
               ms := cs + 1;
               mm := cm;
             end else break;
        '?': begin
               inc(cs); inc(cm);
             end;
        CSpecialCharBegin:
             begin
               if not ParseSpecialString(true, cm, cset, b2, sc) then exit;
               for i1 := 1 to sc do
                 if (lowCharTable[cs^] in cset) = b2 then begin
                   if b1 then begin
                     cm := mm;
                     cs := ms;
                     inc(ms);
                     break;
                   end else exit;
                 end else inc(cs);
             end;
        else if lowCharTable[cm^] <> lowCharTable[cs^] then begin
               if b1 then begin
                 cm := mm;
                 cs := ms;
                 inc(ms);
               end else exit;
             end else begin
               inc(cs); inc(cm);
             end;
      end;
    end;
    result := true;
  end;
end;

function FileMatch(const file_, mask: AnsiString) : boolean;
var f1, f2, m1, m2 : AnsiString;
    i1             : integer;
begin
  if mask <> '*.*' then begin
    i1 := PosStr(AnsiString('.'), file_, maxInt, 1);
    if i1 > 0 then begin
      f1 := Copy(file_, 1,      i1 - 1);
      f2 := Copy(file_, i1 + 1, maxInt);
    end else begin
      f1 := file_;
      f2 := '';
    end;
    i1 := PosStr(AnsiString('.'), mask, maxInt, 1);
    if i1 > 0 then begin
      m1 := Copy(mask, 1,      i1 - 1);
      m2 := Copy(mask, i1 + 1, maxInt);
    end else begin
      m1 := mask;
      m2 := '';
    end;
    result := TextMatch(file_, mask) or (TextMatch(f2, m2) and TextMatch(f1, m1));
  end else
    result := true;
end;

{$ifdef UnicodeOverloads}
function FileMatch(const file_, mask: UnicodeString) : boolean;
var f1, f2, m1, m2 : UnicodeString;
    i1             : integer;
begin
  if mask <> '*.*' then begin
    i1 := PosStr('.', file_, maxInt, 1);
    if i1 > 0 then begin
      f1 := Copy(file_, 1,      i1 - 1);
      f2 := Copy(file_, i1 + 1, maxInt);
    end else begin
      f1 := file_;
      f2 := '';
    end;
    i1 := PosStr('.', mask, maxInt, 1);
    if i1 > 0 then begin
      m1 := Copy(mask, 1,      i1 - 1);
      m2 := Copy(mask, i1 + 1, maxInt);
    end else begin
      m1 := mask;
      m2 := '';
    end;
    result := TextMatch(file_, mask) or (TextMatch(f2, m2) and TextMatch(f1, m1));
  end else
    result := true;
end;
{$endif}

procedure _FillStr(var str: AnsiString; fillLen: integer; addLeft: boolean; fillChar: AnsiChar); {$ifdef UnicodeOverloads} overload; {$endif}
var s1 : AnsiString;
begin
  if fillLen > 0 then begin
    SetLength(s1, fillLen);
    system.FillChar(pointer(s1)^, fillLen, byte(fillChar));
    if addLeft then begin
      if (fillChar in ['0'..'9']) and (str <> '') and (str[1] = '-') then
        str := '-' + s1 + RetDelete(str, 1, 1)
      else
        str := s1 + str;
    end else
      str := str + s1;
  end;
end;

{$ifdef UnicodeOverloads}
procedure _FillStr(var str: UnicodeString; fillLen: integer; addLeft: boolean; fillChar: WideChar); overload;
var s1 : UnicodeString;
    i1 : integer;
begin
  if fillLen > 0 then begin
    SetLength(s1, fillLen);
    for i1 := 1 to fillLen do
      s1[i1] := fillChar;
    if addLeft then begin
      if (word(fillChar) and $ff00 = 0) and (AnsiChar(fillChar) in ['0'..'9']) and (str <> '') and (str[1] = '-') then
        str := '-' + s1 + RetDelete(str, 1, 1)
      else
        str := s1 + str;
    end else
      str := str + s1;
  end;
end;
{$endif}

function FillStr(const str : AnsiString;
                 minLen    : integer;
                 fillChar  : AnsiChar = ' ') : AnsiString;
begin
  result := str;
  _FillStr(result, abs(minLen) - Length(result), minLen > 0, fillChar);
end;

{$ifdef UnicodeOverloads}
function FillStr(const str : UnicodeString;
                 minLen    : integer;
                 fillChar  : WideChar = ' ') : UnicodeString;
begin
  result := str;
  _FillStr(result, abs(minLen) - Length(result), minLen > 0, fillChar);
end;
{$endif}

function IntToStr(value: integer) : AnsiString; overload;
var i1, i2 : integer;
    b1     : boolean;
begin
  if value <> 0 then begin
    b1 := value < 0;
    SetLength(result, 11);
    i1 := 11;
    repeat
      i2    := abs(value mod 10);
      value :=     value div 10;
      result[i1] := AnsiChar(ord('0') + i2);
      dec(i1);
    until value = 0;
    if b1 then begin
      result[i1] := '-';
      dec(i1);
    end;
    if i1 > 0 then begin
      Move(result[i1 + 1], result[1], 11 - i1);
      SetLength(result, 11 - i1);
    end;
  end else
    result := '0';
end;

function IntToStr(value: int64) : AnsiString; overload;
var i1, i2 : integer;
    b1     : boolean;
begin
  if value <> 0 then begin
    b1 := value < 0;
    SetLength(result, 20);
    i1 := 20;
    repeat
      i2    := abs(value mod 10);
      value :=     value div 10;
      result[i1] := AnsiChar(ord('0') + i2);
      dec(i1);
    until value = 0;
    if b1 then begin
      result[i1] := '-';
      dec(i1);
    end;
    if i1 > 0 then begin
      Move(result[i1 + 1], result[1], 20 - i1);
      SetLength(result, 20 - i1);
    end;
  end else
    result := '0';
end;

function IntToHex(value: integer) : AnsiString; overload;
var c1, c2, c3 : cardinal;
begin
  if value <> 0 then begin
    c3 := cardinal(value);
    SetLength(result, 8);
    c1 := 8;
    repeat
      c2 := c3 mod $10;
      c3 := c3 div $10;
      if c2 > 9 then result[c1] := AnsiChar(ord('a') + c2 - $A)
      else           result[c1] := AnsiChar(ord('0') + c2 -  0);
      dec(c1);
    until c3 = 0;
    if c1 > 0 then begin
      Move(result[c1 + 1], result[1], 8 - c1);
      SetLength(result, 8 - c1);
    end;
  end else
    result := '0';
end;

function IntToHex(value: int64) : AnsiString; overload;
var splitInt64 : packed record
                   loCard, hiCard : cardinal;
                 end absolute value;
begin
  if value <> 0 then begin
    result := IntToHex(integer(splitInt64.loCard));
    if splitInt64.hiCard <> 0 then
      result := IntToHex(integer(splitInt64.hiCard)) + FillStr(result, 8, '0');
  end else
    result := '0';
end;

function IntToStrEx(value    : integer;
                    minLen   : integer  = 1;
                    fillChar : AnsiChar = '0') : AnsiString; overload;
begin
  result := IntToStr(value);
  _FillStr(result, abs(minLen) - Length(result), minLen > 0, fillChar);
end;

function IntToHexEx(value    : integer;
                    minLen   : integer  = 1;
                    fillChar : AnsiChar = '0') : AnsiString; overload;
begin
  result := IntToHex(value);
  if (minLen < 0) or (fillChar in ['0'..'9','A'..'F','a'..'f']) then begin
    _FillStr(result, abs(minLen) - Length(result), minLen > 0, fillChar);
    result := '$' + result;
  end else begin
    result := '$' + result;
    _FillStr(result, abs(minLen) - Length(result) + 1, true, fillChar);
  end;
end;

function IntToStrEx(value    : cardinal;
                    minLen   : integer  = 1;
                    fillChar : AnsiChar = '0') : AnsiString; overload;
begin
  result := IntToStr(value);
  _FillStr(result, abs(minLen) - Length(result), minLen > 0, fillChar);
end;

function IntToStrEx(value    : int64;
                    minLen   : integer  = 1;
                    fillChar : AnsiChar = '0') : AnsiString; overload;
begin
  result := IntToStr(value);
  _FillStr(result, abs(minLen) - Length(result), minLen > 0, fillChar);
end;

function IntToHexEx(value    : cardinal;
                    minLen   : integer  = 1;
                    fillChar : AnsiChar = '0') : AnsiString; overload;
begin
  result := IntToHex(cardinal(value));
  if (minLen < 0) or (fillChar in ['0'..'9','A'..'F','a'..'f']) then begin
    _FillStr(result, abs(minLen) - Length(result), minLen > 0, fillChar);
    result := '$' + result;
  end else begin
    result := '$' + result;
    _FillStr(result, abs(minLen) - Length(result) + 1, true, fillChar);
  end;
end;

function IntToHexEx(value    : int64;
                    minLen   : integer  = 1;
                    fillChar : AnsiChar = '0') : AnsiString; overload;
begin
  result := IntToHex(value);
  if (minLen < 0) or (fillChar in ['0'..'9','A'..'F','a'..'f']) then begin
    _FillStr(result, abs(minLen) - Length(result), minLen > 0, fillChar);
    result := '$' + result;
  end else begin
    result := '$' + result;
    _FillStr(result, abs(minLen) - Length(result) + 1, true, fillChar);
  end;
end;

var valTable : array [AnsiChar] of byte =
  ($00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
   $00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$00,$00,$00,$00,$00,$00,
   $00,$0A,$0B,$0C,$0D,$0E,$0F,$00,$00,$00,$00,$00,$00,$00,$00,$00,
   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
   $00,$0A,$0B,$0C,$0D,$0E,$0F,$00,$00,$00,$00,$00,$00,$00,$00,$00,
   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
   $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00);

function StrToIntEx(hex: boolean; str: PAnsiChar; len: integer) : integer;
var b1 : boolean;
    i1 : integer;
begin
  result := 0;
  if str <> nil then begin
    b1 := str^ = '-';
    if not b1 then
      result := valTable[str^];
    inc(str);
    if hex then begin
      for i1 := 1 to len - 1 do begin
        result := (result shl 4) + valTable[str^];
        inc(str);
      end;
    end else
      for i1 := 1 to len - 1 do begin
        result := (result * 10) + valTable[str^];
        inc(str);
      end;
    if b1 then
      result := -result;
  end;
end;

procedure FormatSubStrs(var str: AnsiString; delimiter: AnsiChar = '|');
var c1, c2 : cardinal;
    chs    : TSChar;
begin
  chs := [#32..#255] - [' ',delimiter];
  c1 := PosChars(chs, str);
  if c1 <> 0 then begin
    c2 := PosChars(chs, str, maxInt, 1);
    Keep(str, c1, c2 - c1 + 1);
    c1 := PosStr(delimiter, str);
    while c1 > 0 do begin
      c2 := PosChars(chs, str, c1 + 1);
      if c2 - c1 > 1 then
        Delete(str, c1 + 1, c2 - c1 - 1);
      c2 := PosChars(chs, str, c1 - 1, 1);
      if c1 - c2 > 1 then begin
        Delete(str, c2 + 1, c1 - c2 - 1);
        c1 := c2 + 1;
      end;
      c1 := PosStr(delimiter, str, c1 + 2);
    end;
  end else
    str := '';
end;

{$ifdef UnicodeOverloads}
procedure FormatSubStrs(var str: UnicodeString; delimiter: AnsiChar = '|');
var c1, c2 : cardinal;
    chs    : TSChar;
begin
  chs := [#32..#255] - [' ',delimiter];
  c1 := PosChars(chs, str);
  if c1 <> 0 then begin
    c2 := PosChars(chs, str, maxInt, 1);
    Keep(str, c1, c2 - c1 + 1);
    c1 := PosStr(WideChar(delimiter), str);
    while c1 > 0 do begin
      c2 := PosChars(chs, str, c1 + 1);
      if c2 - c1 > 1 then
        Delete(str, c1 + 1, c2 - c1 - 1);
      c2 := PosChars(chs, str, c1 - 1, 1);
      if c1 - c2 > 1 then begin
        Delete(str, c2 + 1, c1 - c2 - 1);
        c1 := c2 + 1;
      end;
      c1 := PosStr(WideChar(delimiter), str, c1 + 2);
    end;
  end else
    str := '';
end;
{$endif}

function SubStrCount(const str: AnsiString; delimiter: AnsiChar = '|') : integer;
var i1 : integer;
begin
  if str <> '' then begin
    result := 1;
    for i1 := 1 to length(str) do
      if str[i1] = delimiter then
        inc(result);
  end else
    result := 0;
end;

{$ifdef UnicodeOverloads}
function SubStrCount(const str: UnicodeString; delimiter: AnsiChar = '|') : integer;
var i1  : integer;
    ch1 : WideChar;
begin
  if str <> '' then begin
    result := 1;
    ch1 := WideChar(delimiter);
    for i1 := 1 to length(str) do
      if str[i1] = ch1 then
        inc(result);
  end else
    result := 0;
end;
{$endif}

function SubStr(const str: AnsiString; index: cardinal; delimiter: AnsiChar = '|') : AnsiString;
var c1, c2 : cardinal;
begin
  result := '';
  if (str <> '') and (index >= 1) then begin
    c2 := 0;
    repeat
      dec(index);
      c1 := c2 + 1;
      c2 := PosStr(delimiter, str, c1);
    until (index = 0) or (c2 = 0);
    if index = 0 then
      if c2 = 0 then
        result := Copy(str, c1, maxInt )
      else
        result := Copy(str, c1, c2 - c1);
  end;
end;

{$ifdef UnicodeOverloads}
function SubStr(const str: UnicodeString; index: cardinal; delimiter: AnsiChar = '|') : UnicodeString;
var c1, c2 : cardinal;
begin
  result := '';
  if (str <> '') and (index >= 1) then begin
    c2 := 0;
    repeat
      dec(index);
      c1 := c2 + 1;
      c2 := PosStr(WideChar(delimiter), str, c1);
    until (index = 0) or (c2 = 0);
    if index = 0 then
      if c2 = 0 then
        result := Copy(str, c1, maxInt )
      else
        result := Copy(str, c1, c2 - c1);
  end;
end;
{$endif}

function SubStrExists(const str: AnsiString; const subStr: AnsiString; delimiter: AnsiChar = '|') : boolean;
var i1, lstr, lsub : integer;
begin
  if subStr <> '' then begin
    lstr := Length(str);
    lsub := Length(subStr);
    i1 := -lsub;
    repeat
      inc(i1, lsub);
      i1 := PosStr(subStr, str, i1 + 1);
      result := (i1 > 0) and
                ( (i1 =               1) or (str[i1 -    1] = delimiter) ) and
                ( (i1 = lstr - lsub + 1) or (str[i1 + lsub] = delimiter) );
    until result or (i1 = 0);
  end else
    result := false;
end;

{$ifdef UnicodeOverloads}
function SubStrExists(const str: UnicodeString; const subStr: UnicodeString; delimiter: AnsiChar = '|') : boolean;
var i1, lstr, lsub : integer;
begin
  if subStr <> '' then begin
    lstr := Length(str);
    lsub := Length(subStr);
    i1 := -lsub;
    repeat
      inc(i1, lsub);
      i1 := PosStr(subStr, str, i1 + 1);
      result := (i1 > 0) and
                ( (i1 =               1) or (str[i1 -    1] = WideChar(delimiter)) ) and
                ( (i1 = lstr - lsub + 1) or (str[i1 + lsub] = WideChar(delimiter)) );
    until result or (i1 = 0);
  end else
    result := false;
end;
{$endif}

function SubTextExists(const str: AnsiString; const subText: AnsiString; delimiter: AnsiChar = '|') : boolean;
var i1, lstr, lsub : integer;
begin
  if subText <> '' then begin
    lstr := Length(str);
    lsub := Length(subText);
    i1 := -lsub;
    repeat
      inc(i1, lsub);
      i1 := PosText(subText, str, i1 + 1);
      result := (i1 > 0) and
                ( (i1 =               1) or (str[i1 -    1] = delimiter) ) and
                ( (i1 = lstr - lsub + 1) or (str[i1 + lsub] = delimiter) );
    until result or (i1 = 0);
  end else
    result := false;
end;

{$ifdef UnicodeOverloads}
function SubTextExists(const str: UnicodeString; const subText: UnicodeString; delimiter: AnsiChar = '|') : boolean;
var i1, lstr, lsub : integer;
begin
  if subText <> '' then begin
    lstr := Length(str);
    lsub := Length(subText);
    i1 := -lsub;
    repeat
      inc(i1, lsub);
      i1 := PosText(subText, str, i1 + 1);
      result := (i1 > 0) and
                ( (i1 =               1) or (str[i1 -    1] = WideChar(delimiter)) ) and
                ( (i1 = lstr - lsub + 1) or (str[i1 + lsub] = WideChar(delimiter)) );
    until result or (i1 = 0);
  end else
    result := false;
end;
{$endif}

var FDecSep : AnsiChar = #0;
function DecSep : AnsiChar;
var buf : array [0..1] of AnsiChar;
begin
  if FDecSep = #0 then
    if GetLocaleInfoA(GetThreadLocale, LOCALE_SDECIMAL, buf, 2) > 0 then
      FDecSep := buf[0]
    else
      FDecSep := ',';
  result := FDecSep;
end;

function SizeToStr(size: int64) : AnsiString;
begin
  if abs(size) >= 1024 then begin
    if abs(size) >= 1024 * 1024 then begin
      if abs(size) >= 1024 * 1024 * 1024 then begin
        result := IntToStrEx(abs(size div 1024 div 1024 * 100 div 1024)) + ' GB';
        Insert(AnsiString(DecSep), result, Length(result) - 4);
      end else begin
        result := IntToStrEx(abs(size div 1024 * 100 div 1024)) + ' MB';
        Insert(AnsiString(DecSep), result, Length(result) - 4);
      end;
    end else begin
      result := IntToStrEx(abs(size * 100 div 1024)) + ' KB';
      Insert(AnsiString(DecSep), result, Length(result) - 4);
    end;
  end else
    result := IntToStrEx(abs(size)) + ' Bytes';
end;

function MsToStr(time: cardinal) : AnsiString;
begin
  if time >= 1000 then begin
    if time >= 1000 * 60 then begin
      if time >= 1000 * 60 * 60 then begin
        time := time div (1000 * 60);
        result := IntToStrEx(time mod 60);
        if Length(result) = 1 then result := '0' + result;
        result := IntToStrEx(time div 60) + ':' + result + ' h';
      end else begin
        time := time div 1000;
        result := IntToStrEx(time mod 60);
        if Length(result) = 1 then result := '0' + result;
        result := IntToStrEx(time div 60) + ':' + result + ' min';
      end;
    end else begin
      result := IntToStrEx(time mod 1000 div 10);
      if Length(result) = 1 then result := '0' + result;
      result := IntToStrEx(time div 1000) + DecSep + result + ' s';
    end;
  end else
    result := IntToStrEx(time) + ' ms';
end;

function ErrorCodeToStr(error: cardinal) : AnsiString;
const
  NERR_BASE              = 2100;
  MAX_NERR               = NERR_BASE + 899;
  CNetMsg                : AnsiString = (* netmsg.dll            *)  #$3B#$30#$21#$38#$26#$32#$7B#$31#$39#$39;
  CRtlNtStatusToDosError : AnsiString = (* RtlNtStatusToDosError *)  #$07#$21#$39#$1B#$21#$06#$21#$34#$21#$20#$26#$01#$3A#$11#$3A#$26#$10#$27#$27#$3A#$27;
  CWinErrNr              : AnsiString = (* Windows error number  *)  #$02#$3C#$3B#$31#$3A#$22#$26#$75#$30#$27#$27#$3A#$27#$75#$3B#$20#$38#$37#$30#$27;
var pc1   : PAnsiChar;
    c1    : cardinal;
    dll   : cardinal;
    flags : cardinal;
    ns2de : function (ntstatus: dword) : dword; stdcall;
begin
  if error and $c0000000 <> 0 then begin
    ns2de := GetProcAddress(GetModuleHandleA(PAnsiChar(DecryptStr(CNtDll))), PAnsiChar(DecryptStr(CRtlNtStatusToDosError)));
    if @ns2de <> nil then
      error := ns2de(error);
  end;
  flags := FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_IGNORE_INSERTS or FORMAT_MESSAGE_FROM_SYSTEM;
  if (error >= NERR_BASE) and (error <= MAX_NERR) then begin
    // network error codes are in this dll...
    dll := LoadLibraryExA(PAnsiChar(DecryptStr(CNetMsg)), 0, LOAD_LIBRARY_AS_DATAFILE);
    if dll <> 0 then
      flags := flags or FORMAT_MESSAGE_FROM_HMODULE;
  end else
    dll := 0;
  try
    if FormatMessageA(flags, pointer(dll), error, SUBLANG_DEFAULT shl 10 or LANG_NEUTRAL, @pc1, 0, nil) <> 0 then begin
      try
        result := pc1;
        c1 := Length(result);
        while c1 > 0 do begin
          if      result[c1] = #$D then result[c1] := ' '
          else if result[c1] = #$A then Delete(result, c1, 1);
          dec(c1);
        end;
      finally LocalFree(cardinal(pc1)) end;
    end else
      result := DecryptStr(CWinErrNr) + ' ' + IntToHexEx(error);
  finally
    if dll <> 0 then
      FreeLibrary(dll);
  end;
end;

// ***************************************************************

function DecryptStr(const str: AnsiString) : AnsiString;
var i1 : integer;
begin
  result := str;
  UniqueString(result);
  for i1 := 1 to Length(result) do
    byte(result[i1]) := byte(result[i1]) xor $55;
end;

function AnsiToWideEx(const ansi: AnsiString; addTerminatingZero: boolean = true) : AnsiString;
var pwc : PWideChar;
    i1  : integer;
begin
  SetLength(result, Length(ansi) * 2);
  pwc := pointer(result);
  for i1 := 1 to Length(ansi) do begin
    pwc^ := WideChar(ansi[i1]);
    inc(pwc);
  end;
  if addTerminatingZero then
    result := result + #0#0;
end;

function WideToAnsiEx(wide: PWideChar) : AnsiString;
var i1 : integer;
begin
  SetLength(result, lstrlenW(wide));
  for i1 := 1 to Length(result) do
    result[i1] := AnsiChar(wide[i1 - 1]);
end;

{$ifndef d6}

  function Utf8Decode(const S: AnsiString) : UnicodeString;

    function Utf8ToUnicode(Dest: PWideChar; MaxDestChars: Cardinal; Source: PChar; SourceBytes: Cardinal): Cardinal;
    var
      i, count: Cardinal;
      c: Byte;
      wc: Cardinal;
    begin
      if Source = nil then
      begin
        Result := 0;
        Exit;
      end;
      Result := Cardinal(-1);
      count := 0;
      i := 0;
      if Dest <> nil then
      begin
        while (i < SourceBytes) and (count < MaxDestChars) do
        begin
          wc := Cardinal(Source[i]);
          Inc(i);
          if (wc and $80) <> 0 then
          begin
            if i >= SourceBytes then Exit;          // incomplete multibyte char
            wc := wc and $3F;
            if (wc and $20) <> 0 then
            begin
              c := Byte(Source[i]);
              Inc(i);
              if (c and $C0) <> $80 then Exit;      // malformed trail byte or out of range char
              if i >= SourceBytes then Exit;        // incomplete multibyte char
              wc := (wc shl 6) or (c and $3F);
            end;
            c := Byte(Source[i]);
            Inc(i);
            if (c and $C0) <> $80 then Exit;       // malformed trail byte

            Dest[count] := WideChar((wc shl 6) or (c and $3F));
          end
          else
            Dest[count] := WideChar(wc);
          Inc(count);
        end;
        if count >= MaxDestChars then count := MaxDestChars-1;
        Dest[count] := #0;
      end
      else
      begin
        while (i < SourceBytes) do
        begin
          c := Byte(Source[i]);
          Inc(i);
          if (c and $80) <> 0 then
          begin
            if i >= SourceBytes then Exit;          // incomplete multibyte char
            c := c and $3F;
            if (c and $20) <> 0 then
            begin
              c := Byte(Source[i]);
              Inc(i);
              if (c and $C0) <> $80 then Exit;      // malformed trail byte or out of range char
              if i >= SourceBytes then Exit;        // incomplete multibyte char
            end;
            c := Byte(Source[i]);
            Inc(i);
            if (c and $C0) <> $80 then Exit;       // malformed trail byte
          end;
          Inc(count);
        end;
      end;
      Result := count+1;
    end;

  var
    L: Integer;
    Temp: UnicodeString;
  begin
    Result := '';
    if S = '' then Exit;
    SetLength(Temp, Length(S));

    L := Utf8ToUnicode(PWideChar(Temp), Length(Temp)+1, PChar(S), Length(S));
    if L > 0 then
      SetLength(Temp, L-1)
    else
      Temp := '';
    Result := Temp;
  end;

  function Utf8Encode(const WS: UnicodeString) : AnsiString;

    function UnicodeToUtf8(Dest: PAnsiChar; MaxDestBytes: Cardinal; Source: PWideChar; SourceChars: Cardinal): Cardinal;
    var
      i, count: Cardinal;
      c: Cardinal;
    begin
      Result := 0;
      if Source = nil then Exit;
      count := 0;
      i := 0;
      if Dest <> nil then
      begin
        while (i < SourceChars) and (count < MaxDestBytes) do
        begin
          c := Cardinal(Source[i]);
          Inc(i);
          if c <= $7F then
          begin
            Dest[count] := AnsiChar(c);
            Inc(count);
          end
          else if c > $7FF then
          begin
            if count + 3 > MaxDestBytes then
              break;
            Dest[count] := AnsiChar($E0 or (c shr 12));
            Dest[count+1] := AnsiChar($80 or ((c shr 6) and $3F));
            Dest[count+2] := AnsiChar($80 or (c and $3F));
            Inc(count,3);
          end
          else //  $7F < Source[i] <= $7FF
          begin
            if count + 2 > MaxDestBytes then
              break;
            Dest[count] := AnsiChar($C0 or (c shr 6));
            Dest[count+1] := AnsiChar($80 or (c and $3F));
            Inc(count,2);
          end;
        end;
        if count >= MaxDestBytes then count := MaxDestBytes-1;
        Dest[count] := #0;
      end
      else
      begin
        while i < SourceChars do
        begin
          c := Integer(Source[i]);
          Inc(i);
          if c > $7F then
          begin
            if c > $7FF then
              Inc(count);
            Inc(count);
          end;
          Inc(count);
        end;
      end;
      Result := count+1;  // convert zero based index to byte count
    end;

  var
    L: Integer;
    Temp: AnsiString;
  begin
    Result := '';
    if WS = '' then Exit;
    SetLength(Temp, Length(WS) * 3); // SetLength includes space for null terminator

    L := UnicodeToUtf8(PAnsiChar(Temp), Length(Temp) + 1, PWideChar(WS), Length(WS));
    if L > 0 then
      SetLength(Temp, L-1)
    else
      Temp := '';
    Result := Temp;
  end;

{$endif}

end.
