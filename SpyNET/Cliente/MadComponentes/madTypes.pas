// ***************************************************************
//  madTypes.pas              version:  1.4c  ·  date: 2000-07-25
//  -------------------------------------------------------------
//  general purpose types
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2000 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2000-07-25 1.4c MadException/TMethod added (to get rid of SysUtils)

unit madTypes;

{$I mad.inc}

interface

// ***************************************************************

const
  maxCard        = high(cardinal);

type
  TExtBool       = (no, yes, other);

  // TSxxx = set of xxx
  TSByte         = set of byte;
  TSChar         = set of char;
  TSBoolean      = set of boolean;
  TSExtBool      = set of TExtBool;

  // TPSxxx = ^(set of xxx)
  TPSByte        = ^TSByte;
  TPSChar        = ^TSChar;
  TPSBoolean     = ^TSBoolean;
  TPSExtBool     = ^TSExtBool;

  // TPxxx = ^xxx
  TPByte         = ^byte;
  TPShortInt     = ^shortInt;
  TPChar         = ^char;
  TPBoolean      = ^boolean;
  TPExtBool      = ^TExtBool;
  TPWord         = ^word;
  TPSmallInt     = ^smallInt;
  TPCardinal     = ^cardinal;
  TPInteger      = ^integer;
  TPPointer      = ^pointer;
  TPString       = ^string;
  TPIUnknown     = ^IUnknown;
  TPInt64        = ^int64;

  // TAxxx = array [0..maxPossible] of xxx
  TAByte         = array [0..maxInt      -1] of byte;
  TAShortInt     = array [0..maxInt      -1] of shortInt;
  TAChar         = array [0..maxInt      -1] of char;
  TABoolean      = array [0..maxInt      -1] of boolean;
  TAExtBool      = array [0..maxInt      -1] of TExtBool;
  TAWord         = array [0..maxInt shr 1-1] of word;
  TASmallInt     = array [0..maxInt shr 1-1] of smallInt;
  TACardinal     = array [0..maxInt shr 2-1] of cardinal;
  TAInteger      = array [0..maxInt shr 2-1] of integer;
  TAPointer      = array [0..maxInt shr 2-1] of pointer;
  TAString       = array [0..maxInt shr 2-1] of string;
  TAIUnknown     = array [0..maxInt shr 2-1] of IUnknown;
  TAInt64        = array [0..maxInt shr 3-1] of int64;

  // TPAxxx = ^(array [0..maxPossible] of xxx)
  TPAByte        = ^TAByte;
  TPAShortInt    = ^TAShortInt;
  TPAChar        = ^TAChar;
  TPABoolean     = ^TABoolean;
  TPAExtBool     = ^TAExtBool;
  TPAWord        = ^TAWord;
  TPASmallInt    = ^TASmallInt;
  TPACardinal    = ^TACardinal;
  TPAInteger     = ^TAInteger;
  TPAPointer     = ^TAPointer;
  TPAString      = ^TAString;
  TPAIUnknown    = ^TAIUnknown;
  TPAInt64       = ^TAInt64;

  // TDAxxx = array of xxx
  TDAByte        = array of byte;
  TDAShortInt    = array of shortInt;
  TDAChar        = array of char;
  TDABoolean     = array of boolean;
  TDAExtBool     = array of TExtBool;
  TDAWord        = array of word;
  TDASmallInt    = array of smallInt;
  TDACardinal    = array of cardinal;
  TDAInteger     = array of integer;
  TDAPointer     = array of pointer;
  TDAString      = array of string;
  TDAIUnknown    = array of IUnknown;
  TDAInt64       = array of int64;

  // TPDAxxx = ^(array of xxx)
  TPDAByte       = ^TDAByte;
  TPDAShortInt   = ^TDAShortInt;
  TPDAChar       = ^TDAChar;
  TPDABoolean    = ^TDABoolean;
  TPDAExtBool    = ^TDAExtBool;
  TPDAWord       = ^TDAWord;
  TPDASmallInt   = ^TDASmallInt;
  TPDACardinal   = ^TDACardinal;
  TPDAInteger    = ^TDAInteger;
  TPDAPointer    = ^TDAPointer;
  TPDAString     = ^TDAString;
  TPDAIUnknown   = ^TDAIUnknown;
  TPDAInt64      = ^TDAInt64;

// ***************************************************************

  MadException = class(TObject)
  private
    FMessage : string;
  public
    constructor Create (const msg: string);
    property Message : string read FMessage write FMessage;
  end;

  TMethod = record code, data: pointer; end;

// ***************************************************************

implementation

// ***************************************************************

constructor MadException.Create(const msg: string);
begin
  FMessage := msg;
end;

// ***************************************************************

end.
