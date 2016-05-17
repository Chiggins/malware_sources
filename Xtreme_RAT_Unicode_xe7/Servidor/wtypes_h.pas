(* this ALWAYS GENERATED file contains the definitions for the interfaces */


(* File created by MIDL compiler version 3.03.0110 *)
(* at Thu Sep 11 10:57:03 1997
 *)
(* Compiler settings for wtypes.idl:
    Oicf (OptLev=i2), W1, Zp8, env=Win32, ms_ext, c_ext
    error checks: none
*)
{$ifndef __wtypes_h__}
  {$define __wtypes_h__}
{$endif}
unit wtypes_h;

interface

uses Windows;

{$ifndef _FILETIME_}
  {$define _FILETIME_}
type _FILETIME = record
  dwLowDateTime: DWORD;
  dwHighDateTime: DWORD;
end;
type FILETIME   = _FILETIME;
type PFILETIME  = ^_FILETIME;
type LPFILETIME = ^_FILETIME;
{$endif _FILETIME_}

{$ifndef _SYSTEMTIME_}
  {$define _SYSTEMTIME_}
type _SYSTEMTIME = record
  wYear        : WORD;
  wMonth       : WORD;
  wDayOfWeek   : WORD;
  wDay         : WORD;
  wHour        : WORD;
  wMinute      : WORD;
  wSecond      : WORD;
  wMilliseconds: WORD;
end;
  SYSTEMTIME   = _SYSTEMTIME;
  PSYSTEMTIME  = ^_SYSTEMTIME;
  LPSYSTEMTIME = ^_SYSTEMTIME;
{$endif _SYSTEMTIME_}

implementation

end.
