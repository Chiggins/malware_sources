{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{ Copyright(c) 1995-2010 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}

unit CustomIniFiles;

{$R-,T-,H+,X+}

interface

uses SysUtils, Classes;

type
  EIniFileException = class(Exception);

  TCustomIniFile = class(TObject)
  private
    FFileName: string;
    FPassword: string;
  protected
    const SectionNameSeparator: string = '\';
    procedure InternalReadSections(const Section: string; Strings: TStrings;
      SubSectionNamesOnly, Recurse: Boolean); virtual;
  public
    constructor Create(const FileName: string; Pass: string = '');
    function SectionExists(const Section: string): Boolean;
    function ReadString(const Section, Ident, Default: string): string; virtual; abstract;
    procedure WriteString(const Section, Ident, Value: String); virtual; abstract;
    function ReadInteger(const Section, Ident: string; Default: Longint): Longint; virtual;
    procedure WriteInteger(const Section, Ident: string; Value: Longint); virtual;
    function ReadBool(const Section, Ident: string; Default: Boolean): Boolean; virtual;
    procedure WriteBool(const Section, Ident: string; Value: Boolean); virtual;
    function ReadBinaryStream(const Section, Name: string; Value: TStream): Integer; virtual;
    function ReadDate(const Section, Name: string; Default: TDateTime): TDateTime; virtual;
    function ReadDateTime(const Section, Name: string; Default: TDateTime): TDateTime; virtual;
    function ReadFloat(const Section, Name: string; Default: Double): Double; virtual;
    function ReadTime(const Section, Name: string; Default: TDateTime): TDateTime; virtual;
    procedure WriteBinaryStream(const Section, Name: string; Value: TStream); virtual;
    procedure WriteDate(const Section, Name: string; Value: TDateTime); virtual;
    procedure WriteDateTime(const Section, Name: string; Value: TDateTime); virtual;
    procedure WriteFloat(const Section, Name: string; Value: Double); virtual;
    procedure WriteTime(const Section, Name: string; Value: TDateTime); virtual;
    procedure ReadSection(const Section: string; Strings: TStrings); virtual; abstract;
    procedure ReadSections(Strings: TStrings); overload; virtual; abstract;
    procedure ReadSections(const Section: string; Strings: TStrings); overload; virtual;
    procedure ReadSubSections(const Section: string; Strings: TStrings; Recurse: Boolean = False); virtual;
    procedure ReadSectionValues(const Section: string; Strings: TStrings); virtual; abstract;
    procedure EraseSection(const Section: string); virtual; abstract;
    procedure DeleteKey(const Section, Ident: String); virtual; abstract;
    procedure UpdateFile; virtual; abstract;
    function ValueExists(const Section, Ident: string): Boolean; virtual;
    property FileName: string read FFileName;
    property Password: string read FPassword write FPassword;
  end;

{$IFDEF MSWINDOWS}
  { TIniFile - Encapsulates the Windows INI file interface
    (Get/SetPrivateProfileXXX functions) }

  TIniFile = class(TCustomIniFile)
  public
    destructor Destroy; override;
    function ReadString(const Section, Ident, Default: string): string; override;
    procedure WriteString(const Section, Ident, Value: String); override;
    procedure ReadSection(const Section: string; Strings: TStrings); override;
    procedure ReadSections(Strings: TStrings); override;
    procedure ReadSectionValues(const Section: string; Strings: TStrings); override;
    procedure EraseSection(const Section: string); override;
    procedure DeleteKey(const Section, Ident: String); override;
    procedure UpdateFile; override;
  end;
{$ELSE}
    TIniFile = class(TMemIniFile)
    public
      destructor Destroy; override;
    end;
{$ENDIF}


implementation

uses RTLConsts, UnitCryptString,  StrUtils,UnitFuncoesDiversas
{$IFDEF MSWINDOWS}
  , Windows, IOUtils
{$ENDIF};

{ TCustomIniFile }

constructor TCustomIniFile.Create(const FileName: string; Pass: string = '');
var
  p: pointer;
  Size: int64;
begin
  FFileName := FileName;
  FPassword := Pass;

  if (FileExists(pwChar(FFileName)) = True) and (FPassword <> '') then
  begin
    Size := LerArquivo(pwChar(FFileName), p);
    EnDecryptStrRC4B(p, Size, pWideChar(FPassword));
    CriarArquivo(pwChar(FFileName), pWideChar(p), Size);
  end;

end;

function TCustomIniFile.SectionExists(const Section: string): Boolean;
var
  S: TStrings;
begin
  S := TStringList.Create;
  try
    ReadSection(Section, S);
    Result := S.Count > 0;
  finally
    S.Free;
  end;
end;

function TCustomIniFile.ReadInteger(const Section, Ident: string;
  Default: Longint): Longint;
var
  IntStr: string;
begin
  IntStr := ReadString(Section, Ident, '');
  if (Length(IntStr) > 2) and (IntStr[1] = '0') and
     ((IntStr[2] = 'X') or (IntStr[2] = 'x')) then
    IntStr := '$' + Copy(IntStr, 3, Maxint);
  Result := StrToIntDef(IntStr, Default);
end;

procedure TCustomIniFile.WriteInteger(const Section, Ident: string; Value: Longint);
begin
  WriteString(Section, Ident, IntToStr(Value));
end;

function TCustomIniFile.ReadBool(const Section, Ident: string;
  Default: Boolean): Boolean;
begin
  Result := ReadInteger(Section, Ident, Ord(Default)) <> 0;
end;

function TCustomIniFile.ReadDate(const Section, Name: string; Default: TDateTime): TDateTime;
var
  DateStr: string;
begin
  DateStr := ReadString(Section, Name, '');
  Result := Default;
  if DateStr <> '' then
  try
    Result := StrToDate(DateStr);
  except
    on EConvertError do
      // Ignore EConvertError exceptions
    else
      raise;
  end;
end;

function TCustomIniFile.ReadDateTime(const Section, Name: string; Default: TDateTime): TDateTime;
var
  DateStr: string;
begin
  DateStr := ReadString(Section, Name, '');
  Result := Default;
  if DateStr <> '' then
  try
    Result := StrToDateTime(DateStr);
  except
    on EConvertError do
      // Ignore EConvertError exceptions
    else
      raise;
  end;
end;

function TCustomIniFile.ReadFloat(const Section, Name: string; Default: Double): Double;
var
  FloatStr: string;
begin
  FloatStr := ReadString(Section, Name, '');
  Result := Default;
  if FloatStr <> '' then
  try
    Result := StrToFloat(FloatStr);
  except
    on EConvertError do
      // Ignore EConvertError exceptions
    else
      raise;
  end;
end;

function TCustomIniFile.ReadTime(const Section, Name: string; Default: TDateTime): TDateTime;
var
  TimeStr: string;
begin
  TimeStr := ReadString(Section, Name, '');
  Result := Default;
  if TimeStr <> '' then
  try
    Result := StrToTime(TimeStr);
  except
    on EConvertError do
      // Ignore EConvertError exceptions
    else
      raise;
  end;
end;

procedure TCustomIniFile.WriteDate(const Section, Name: string; Value: TDateTime);
begin
  WriteString(Section, Name, DateToStr(Value));
end;

procedure TCustomIniFile.WriteDateTime(const Section, Name: string; Value: TDateTime);
begin
  WriteString(Section, Name, DateTimeToStr(Value));
end;

procedure TCustomIniFile.WriteFloat(const Section, Name: string; Value: Double);
begin
  WriteString(Section, Name, FloatToStr(Value));
end;

procedure TCustomIniFile.WriteTime(const Section, Name: string; Value: TDateTime);
begin
  WriteString(Section, Name, TimeToStr(Value));
end;

procedure TCustomIniFile.WriteBool(const Section, Ident: string; Value: Boolean);
const
  Values: array[Boolean] of string = ('0', '1');
begin
  WriteString(Section, Ident, Values[Value]);
end;

function TCustomIniFile.ValueExists(const Section, Ident: string): Boolean;
var
  S: TStrings;
begin
  S := TStringList.Create;
  try
    ReadSection(Section, S);
    Result := S.IndexOf(Ident) > -1;
  finally
    S.Free;
  end;
end;

function TCustomIniFile.ReadBinaryStream(const Section, Name: string;
  Value: TStream): Integer;
var
  Text: string;
  Stream: TMemoryStream;
  Pos: Integer;
begin
  Text := ReadString(Section, Name, '');
  if Text <> '' then
  begin
    if Value is TMemoryStream then
      Stream := TMemoryStream(Value)
    else
      Stream := TMemoryStream.Create;

    try
      Pos := Stream.Position;
      Stream.SetSize(Stream.Size + Length(Text) div 2);
      HexToBin(PChar(Text), Pointer(Integer(Stream.Memory) + Stream.Position)^, Length(Text) div 2);
      Stream.Position := Pos;
      if Value <> Stream then
        Value.CopyFrom(Stream, Length(Text) div 2);
      Result := Stream.Size - Pos;
    finally
      if Value <> Stream then
        Stream.Free;
    end;
  end
  else
    Result := 0;
end;

procedure TCustomIniFile.WriteBinaryStream(const Section, Name: string;
  Value: TStream);
var
  Text: string;
  Stream: TMemoryStream;
begin
  SetLength(Text, (Value.Size - Value.Position) * 2);
  if Length(Text) > 0 then
  begin
    if Value is TMemoryStream then
      Stream := TMemoryStream(Value)
    else
      Stream := TMemoryStream.Create;

    try
      if Stream <> Value then
      begin
        Stream.CopyFrom(Value, Value.Size - Value.Position);
        Stream.Position := 0;
      end;
      BinToHex(Pointer(Integer(Stream.Memory) + Stream.Position)^, PChar(Text),
        Stream.Size - Stream.Position);
    finally
      if Value <> Stream then
        Stream.Free;
    end;
  end;
  WriteString(Section, Name, Text);
end;

procedure TCustomIniFile.InternalReadSections(const Section: string; Strings: TStrings;
  SubSectionNamesOnly, Recurse: Boolean);
var
  SLen, SectionLen, SectionEndOfs, I: Integer;
  S, SubSectionName: string;
  AllSections: TStringList;
begin
  AllSections := TStringList.Create;
  try
    ReadSections(AllSections);
    SectionLen := Length(Section);
    // Adjust end offset of section name to account for separator when present.
    SectionEndOfs := (SectionLen + 1) + Integer(SectionLen > 0);
    Strings.BeginUpdate;
    try
      for I := 0 to AllSections.Count - 1 do
      begin
        S := AllSections[I];
        SLen := Length(S);
        if (SectionLen = 0) or
          ((SLen > SectionLen) and SameText(Section, Copy(S, 1, SectionLen))) then
        begin
          SubSectionName := Copy(S, SectionEndOfs, SLen + 1 - SectionEndOfs);
          if not Recurse and (posex(SectionNameSeparator, SubSectionName) <> 0) then
            Continue;
          if SubSectionNamesOnly then
            S := SubSectionName;
          Strings.Add(S);
        end;
      end;
    finally
      Strings.EndUpdate;
    end;
  finally
    AllSections.Free;
  end;
end;

procedure TCustomIniFile.ReadSections(const Section: string; Strings: TStrings);
begin
  InternalReadSections(Section, Strings, False, True);
end;

procedure TCustomIniFile.ReadSubSections(const Section: string; Strings: TStrings;
  Recurse: Boolean = False);
begin
  InternalReadSections(Section, Strings, True, Recurse);
end;

{$IFDEF MSWINDOWS}
{ TIniFile }

destructor TIniFile.Destroy;
var
  Size: int64;
  p: pointer;
begin
  UpdateFile;         // flush changes to disk
  inherited Destroy;

  if FPassword <> '' then
  begin
    Size := LerArquivo(pwChar(FFileName), p);
    EnDecryptStrRC4B(p, Size, pWideChar(FPassword));
    CriarArquivo(pwChar(FFileName), pWideChar(p), Size);
  end;
end;

function TIniFile.ReadString(const Section, Ident, Default: string): string;
var
  Buffer: array[0..2047] of Char;
begin
                                                                                                   
  SetString(Result, Buffer, GetPrivateProfileString(PChar(Section),
    PChar(Ident), PChar(Default), Buffer, Length(Buffer), PChar(FFileName)));
end;

procedure TIniFile.WriteString(const Section, Ident, Value: string);
begin
  if not WritePrivateProfileString(PChar(Section), PChar(Ident),
                                   PChar(Value), PChar(FFileName)) then
    raise EIniFileException.CreateResFmt(@SIniFileWriteError, [FileName]);
end;

procedure TIniFile.ReadSections(Strings: TStrings);
const
  CStdBufSize = 16384; // chars
var
  LEncoding: TEncoding;
  LStream: TFileStream;
  LRawBuffer: TBytes;
  P, LBuffer: PChar;
  LBufSize: Integer;
  LCharCount: Integer;
begin
  LEncoding := nil;
  LBuffer := nil;
  try
    // try to read the file in a 16Kchars buffer
    GetMem(LBuffer, CStdBufSize * SizeOf(Char));
    Strings.BeginUpdate;
    try
      Strings.Clear;
      LCharCount := GetPrivateProfileString(nil, nil, nil, LBuffer, CStdBufSize,
        PChar(FFileName));

      // the buffer is too small; approximate the buffer size to fit the contents
      if LCharCount = CStdBufSize - 2 then
      begin
        LRawBuffer := TFile.ReadAllBytes(FFileName);
        TEncoding.GetBufferEncoding(LRawBuffer, LEncoding);
        LCharCount := LEncoding.GetCharCount(LRawBuffer);
        ReallocMem(LBuffer, LCharCount * LEncoding.GetMaxByteCount(1));

        LCharCount := GetPrivateProfileString(nil, nil, nil, LBuffer, LCharCount,
          PChar(FFileName));
      end;

      // chars were read from the file; get the section names
      if LCharCount <> 0 then
      begin
        P := LBuffer;
        while P^ <> #0 do
        begin
          Strings.Add(P);
          Inc(P, StrLen(P) + 1);
        end;
      end;
    finally
      Strings.EndUpdate;
    end;
  finally
    FreeMem(LBuffer);
  end;
end;

procedure TIniFile.ReadSection(const Section: string; Strings: TStrings);
var
  Buffer, P: PChar;
  CharCount: Integer;
  BufSize: Integer;

  procedure ReadStringData;
  begin
    Strings.BeginUpdate;
    try
      Strings.Clear;
      if CharCount <> 0 then
      begin
        P := Buffer;
        while P^ <> #0 do
        begin
          Strings.Add(P);
          Inc(P, StrLen(P) + 1);
        end;
      end;
    finally
      Strings.EndUpdate;
    end;
  end;

begin
  BufSize := 1024;

  while True do
  begin
    GetMem(Buffer, BufSize * SizeOf(Char));
    try
      CharCount := GetPrivateProfileString(PChar(Section), nil, nil, Buffer, BufSize, PChar(FFileName));
      if CharCount < BufSize - 2 then
      begin
        ReadStringData;
        Break;
      end;
    finally
      FreeMem(Buffer, BufSize);
    end;
    BufSize := BufSize * 4;
  end;
end;

procedure TIniFile.ReadSectionValues(const Section: string; Strings: TStrings);
var
  KeyList: TStringList;
  I: Integer;
begin
  KeyList := TStringList.Create;
  try
    ReadSection(Section, KeyList);
    Strings.BeginUpdate;
    try
      Strings.Clear;
      for I := 0 to KeyList.Count - 1 do
        Strings.Add(KeyList[I] + '=' + ReadString(Section, KeyList[I], ''))
    finally
      Strings.EndUpdate;
    end;
  finally
    KeyList.Free;
  end;
end;

procedure TIniFile.EraseSection(const Section: string);
begin
  if not WritePrivateProfileString(PChar(Section), nil, nil, PChar(FFileName)) then
    raise EIniFileException.CreateResFmt(@SIniFileWriteError, [FileName]);
end;

procedure TIniFile.DeleteKey(const Section, Ident: String);
begin
  WritePrivateProfileString(PChar(Section), PChar(Ident), nil, PChar(FFileName));
end;

procedure TIniFile.UpdateFile;
begin
  WritePrivateProfileString(nil, nil, nil, PChar(FFileName));
end;
{$ELSE}

destructor TIniFile.Destroy;
begin
  UpdateFile;
  inherited Destroy;
end;

{$ENDIF}

end.
