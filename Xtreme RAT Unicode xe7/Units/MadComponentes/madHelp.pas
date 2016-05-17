// ***************************************************************
//  madHelp.pas               version:  1.1a  ·  date: 2004-11-07
//  -------------------------------------------------------------
//  IDE context help integration
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2004 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2004-11-07 1.1a problems with XPSP2's IE due to a HTML format bug

unit madHelp;

{$I mad.inc}

{$ifndef ver120}{$ifndef ver130}{$define d6}{$endif}{$endif}

interface

function TranslateHelpString(const HelpString: string; var Caption, Description, Link, Group: string) : boolean;

procedure Register;

implementation

uses Windows, ShellAPI, Classes, SysUtils {$ifdef d6}, HelpIntfs{$endif};

// ***************************************************************

{$ifndef d6}
  type TWinHelp        = function (wndMain: dword; help: PAnsiChar; command, data: dword) : longBool; stdcall;
  var  HookWinHelpDll  : dword;
       HookWinHelp     : procedure (callback: TWinHelp; var nextHook: TWinHelp);
       UnhookWinHelp   : procedure (                    var nextHook: TWinHelp);
       WinHelpNextHook : TWinHelp;
{$endif}

type TDAString   = array of AnsiString;
var  WinHelpList : TStringList;
     WinHelpTime : int64;
     WinHelpSize : cardinal;

function QuickSort(list: TStringList) : boolean;
var sl : TStringList;

  procedure InternalQuickSort(l, r: integer);
  var i1, i2, i3, i4 : integer;
      s2             : string;
  begin
    result := false;
    repeat
      i1 := l;
      i2 := r;
      i3 := (l + r) shr 1;
      repeat
        while true do begin
          i4 := AnsiCompareText(sl[i1], sl[i3]);
          if i4 = 0 then
            i4 := AnsiCompareText(list[i1], list[i3]);
          if i4 >= 0 then break;
          inc(i1);
        end;
        while true do begin
          i4 := AnsiCompareText(sl[i2], sl[i3]);
          if i4 = 0 then
            i4 := AnsiCompareText(list[i2], list[i3]);
          if i4 <= 0 then break;
          dec(i2);
        end;
        if i1 <= i2 then begin
          result   := true;
          s2       := sl[i1];
          sl[i1]   := sl[i2];
          sl[i2]   := s2;
          s2       := list[i1];
          list[i1] := list[i2];
          list[i2] := s2;
          if      i3 = i1 then i3 := i2
          else if i3 = i2 then i3 := i1;
          inc(i1);
          dec(i2);
        end;
      until i1 > i2;
      if l < i2 then InternalQuickSort(l, i2);
      l := i1;
    until i1 >= r;
  end;

var i1, i2 : integer;
    s1     : string;
begin
  result := false;
  sl := TStringList.Create;
  for i1 := 0 to list.Count - 1 do begin
    s1 := list[i1];
    i2 := Pos('=', s1); if i2 > 0 then Delete(s1, i2, maxInt);
    i2 := Pos('|', s1); if i2 > 0 then Delete(s1, i2, maxInt);
    sl.Add(s1);
  end;
  InternalQuickSort(0, list.Count - 1);
  sl.Free;
end;

function Extract2FilePaths(path: AnsiString) : AnsiString;
var i1 : integer;
begin
  result := AnsiString(ExtractFilePath(string(path)));
  i1 := Length(result);
  if i1 > 0 then begin
    if result[i1] = '\' then Delete(result, i1, 1);
    result := AnsiString(ExtractFilePath(string(result)));
  end;
end;

procedure CheckWordList;
var c1  : cardinal;
    wfd : TWin32FindDataA;
    i1  : integer;
    s1  : AnsiString;
begin
  SetLength(s1, MAX_PATH + 1);
  GetModuleFileNameA(HInstance, PAnsiChar(s1), MAX_PATH);
  s1 := Extract2FilePaths(PAnsiChar(s1)) + 'Help\Data\wordlist.txt';
  c1 := FindFirstFileA(PAnsiChar(s1), wfd);
  if c1 <> INVALID_HANDLE_VALUE then
    try
      if (WinHelpList = nil) or (int64(wfd.ftLastWriteTime) <> WinHelpTime) or
                                (      wfd.nFileSizeLow     <> WinHelpSize) then begin
        WinHelpTime := int64(wfd.ftLastWriteTime);
        WinHelpSize := wfd.nFileSizeLow;
        if WinHelpList = nil then
          WinHelpList := TStringList.Create;
        WinHelpList.LoadFromFile(string(s1));
        QuickSort(WinHelpList);
        while (WinHelpList.Count > 0) and (Trim(WinHelpList[0]) = '') do
          WinHelpList.Delete(0);
        i1 := WinHelpList.Count - 1;
        while i1 > 0 do begin
          if AnsiCompareText(WinHelpList[i1], WinHelpList[i1 - 1]) = 0 then
            WinHelpList.Delete(i1);
          dec(i1);
        end; 
      end;
    finally windows.FindClose(c1) end;
end;

function HtmlHead(title, forwardTo: AnsiString) : AnsiString;
begin
  result :=
    '<html>'                                                                     + #$D#$A +
                                                                                   #$D#$A +
    '  <head>'                                                                   + #$D#$A +
    '    <title>mad* Help...</title>'                                            + #$D#$A +
    '    <meta name="description" content="mad* Help...">'                       + #$D#$A +
    '    <meta name="keywords" content="madshi, freeware, shareware, sources, components, tips, delphi, windows">' + #$D#$A;
  if forwardTo <> '' then
    result := result + '    <meta http-equiv="refresh" content="0; URL=' + forwardTo + '">' + #$D#$A;
  result := result +
    '    <link rel=stylesheet type="text/css" href="style.css">'                 + #$D#$A +
    '  </head>'                                                                  + #$D#$A +
                                                                                   #$D#$A +
    '  <body background="bcklight.gif" bgcolor=#F8F8F8>'                         + #$D#$A +
    '    <table border=0 cellpadding=0 callspacing=0><tr>'                       + #$D#$A +
    '      <td valign=bottom>'                                                   + #$D#$A +
    '        <table border=0 cellpadding=0 cellspacing=0><tr><td bgcolor=#D8D8D8>' + #$D#$A +
    '          <table cellpadding=3 border=0>'                                   + #$D#$A +
    '            <tr><td bgcolor=#FFFFF0>'                                       + #$D#$A +
    '              <div id="verySmall"><br></div>'                               + #$D#$A +
    '              <div id="bigTitle">&nbsp;' + title + '&nbsp;</div>'           + #$D#$A +
    '              <div id="verySmall"><br></div>'                               + #$D#$A +
//    '              <div id="small">...</div>'                                    + #$D#$A +
    '            </td></tr>'                                                     + #$D#$A +
    '          </table>'                                                         + #$D#$A +
    '        </td></tr></table>'                                                 + #$D#$A +
    '      </td>'                                                                + #$D#$A +
    '      <td valign=bottom>'                                                   + #$D#$A +
    '        <table border=0 cellpadding=0 cellspacing=0><tr><td bgcolor=#D8D8D8>' + #$D#$A +
    '          <table cellpadding=7 border=0>'                                   + #$D#$A +
    '            <tr><td bgcolor=#F4F4F8><a href="http://www.madshi.net">www.madshi.net</a></td></tr>' + #$D#$A +
    '          </table>'                                                         + #$D#$A +
    '        </td></tr></table>'                                                 + #$D#$A +
    '      </td>'                                                                + #$D#$A +
    '    </tr></table>'                                                          + #$D#$A +
    '    <table cellpadding=0 border=0>'                                         + #$D#$A +
    '      <tr>'                                                                 + #$D#$A +
    '        <td bgcolor=#D8D8D8>'                                               + #$D#$A +
    '          <table width=100% cellpadding=7 border=0>'                        + #$D#$A +
    '            <tr>'                                                           + #$D#$A +
    '              <td id=''linkTitle'' bgcolor=#6060B0>Topic</td>'              + #$D#$A +
    '              <td id=''linkTitle'' align=center bgcolor=#6060B0>Type</td>'  + #$D#$A +
    '            </tr>'                                                          + #$D#$A;
end;

function HtmlEnd : AnsiString;
begin
  result :=
    '          </table>'                                                         + #$D#$A +
    '        </td>'                                                              + #$D#$A +
    '      </tr>'                                                                + #$D#$A +
    '    </table>'                                                               + #$D#$A +
    '  </body>'                                                                  + #$D#$A +
                                                                                   #$D#$A +
    '</html>';
end;

function TrimHelp(str: AnsiString) : AnsiString;
var i1     : integer;
    s1, s2 : AnsiString;
begin
  result := str;
  i1 := Pos(AnsiString('='), result);
  if i1 > 0 then begin
    s1 := Copy(result, i1 + 1, maxInt);
    Delete(result, i1, maxInt);
  end else
    s1 := result;
  i1 := Pos(AnsiString('|'), result);
  if i1 > 0 then Delete(result, 1, i1);
  i1 := Pos(AnsiString(' ('), result);
  if i1 > 0 then Delete(result, i1, maxInt);
  i1 := Pos(AnsiString('.'), result);
  if i1 > 0 then begin
    if true and (result[i1 + 1] = '<') and (result[i1 + 2] in ['m', 'r', 'w']) and (result[i1 + 3] = '>') then begin
      s2 := Copy(result, i1 + 1, 3);
      Delete(result, i1 + 1, 3);
      Insert('.gif"', s2, 3);
      Insert('img src="', s2, 2);
    end else
      s2 := '';
    result := Copy(result, 1, i1) + Copy(result, i1 + 1, maxInt);
  end;
end;

function GetHelpStrings(help: AnsiString; exact: boolean) : TDAString;

  function TrimHelp1(str: AnsiString) : AnsiString;
  var i1 : integer;
  begin
    result := str;
    i1 := Pos(AnsiString('='), result); if i1 > 0 then Delete(result, i1, maxInt);
    i1 := Pos(AnsiString('|'), result); if i1 > 0 then Delete(result, i1, maxInt);
  end;

var i2, i3, i4, i5 : integer;
    s2             : AnsiString;
begin
  result := nil;
  CheckWordList;
  if WinHelpList <> nil then
    if not exact then begin
      i2 := 0;
      i3 := WinHelpList.Count - 1;
      while i2 <= i3 do begin
        i4 := (i2 + i3) div 2;
        s2 := AnsiString(WinHelpList[i4]);
        i5 := Pos(AnsiString('='), s2);
        if i5 > 0 then
          Delete(s2, i5, maxInt);
        i5 := Pos(AnsiString('|'), s2);
        if i5 > 0 then Delete(s2, i5, maxInt);
        i5 := AnsiCompareText(string(help), string(s2));
        if i5 = 0 then begin
          i2 := i4; while (i2 > 0                    ) and (AnsiCompareText(string(s2), string(TrimHelp1(AnsiString(WinHelpList[i2 - 1])))) = 0) do dec(i2);
          i3 := i4; while (i3 < WinHelpList.Count - 1) and (AnsiCompareText(string(s2), string(TrimHelp1(AnsiString(WinHelpList[i3 + 1])))) = 0) do inc(i3);
          SetLength(result, i3 - i2 + 1);
          for i4 := 0 to high(result) do
            result[i4] := AnsiString(WinHelpList[i4 + i2]);
          break;
        end;
        if i5 > 0 then i2 := i4 + 1
        else           i3 := i4 - 1;
      end;
    end else
      for i2 := 0 to WinHelpList.Count - 1 do
        if AnsiCompareText(string(help), string(TrimHelp(AnsiString(WinHelpList[i2])))) = 0 then begin
          SetLength(result, 1);
          result[0] := AnsiString(WinHelpList[i2]);
          break;
        end;
end;

function ShowHelp(const astr: array of AnsiString) : boolean;

  function TrimHelp2(str: AnsiString) : AnsiString;
  var i1     : integer;
      s1, s2 : AnsiString;
  begin
    result := str;
    i1 := Pos(AnsiString('='), result);
    if i1 > 0 then begin
      s1 := Copy(result, i1 + 1, maxInt);
      Delete(result, i1, maxInt);
    end else
      s1 := result;
    i1 := Pos(AnsiString('|'), result);
    if i1 > 0 then Delete(result, 1, i1);
    i1 := Pos(AnsiString(' ('), result);
    if i1 > 0 then Delete(result, i1, maxInt);
    i1 := Pos(AnsiString('.'), result);
    if i1 > 0 then begin
      if (result[i1 + 1] = '<') and (result[i1 + 2] in ['m', 'r', 'w']) and (result[i1 + 3] = '>') then begin
        s2 := Copy(result, i1 + 1, 3);
        Delete(result, i1 + 1, 3);
        Insert('.gif"', s2, 3);
        Insert('img src="', s2, 2);
      end else
        s2 := '';
      result := Copy(result, 1, i1) + s2 + '<a href="' + s1 + '">' + Copy(result, i1 + 1, maxInt) + '</a>';
    end else
      result := '<a href="' + s1 + '">' + result + '</a>';
  end;

  function TrimHelp3(str: AnsiString) : AnsiString;
  var i1 : integer;
  begin
    result := str;
    i1 := Pos(AnsiString('='),  result); if i1 > 0 then Delete(result, i1, maxInt);
    i1 := Pos(AnsiString('|'),  result); if i1 > 0 then Delete(result, 1, i1);
    i1 := Pos(AnsiString(' ('), result); if i1 > 0 then Delete(result, 1, i1 + 1);
    i1 := Pos(AnsiString(')'),  result); if i1 > 0 then Delete(result, i1, maxInt);
  end;

  function TrimHelp4(str: AnsiString) : AnsiString;
  var i1 : integer;
  begin
    result := str;
    i1 := Pos(AnsiString('='), result);
    if i1 > 0 then Delete(result, 1, i1);
  end;

const tdCols : array [0..1] of PAnsiChar = ('#F8F0F0', '#F4F4F8');
var s1, s2 : AnsiString;
    i1     : integer;
    arrCh  : array [0..MAX_PATH] of AnsiChar;
begin
  if Length(astr) > 0 then begin
    if Length(astr) = 1 then
         s1 := HtmlHead('Choose Topic', TrimHelp4(astr[0]))
    else s1 := HtmlHead('Choose Topic', '');
    for i1 := 0 to high(astr) do
      s1 := s1 + '<tr><td bgcolor=' + tdCols[    i1 and 1] + '>' + TrimHelp2(astr[i1]) + '</td>' +
                     '<td bgcolor=' + tdCols[1 - i1 and 1] + '>' + TrimHelp3(astr[i1]) + '</td></tr>' + #$D#$A;
    s1 := s1 + HtmlEnd;
    GetModuleFileNameA(HInstance, arrCh, MAX_PATH);
    s2 := Extract2FilePaths(arrCh) + 'Help\Data\Choose.htm';
    with TFileStream.Create(string(s2), fmCreate) do
      try
        Write(pointer(s1)^, Length(s1));
      finally Free end;
    result := (FindExecutableA(PAnsiChar(s2), nil, arrCh) > 32) and
              (ShellExecuteA(0, nil, arrCh, PAnsiChar('"' + s2 + '"'), nil, SW_SHOWNORMAL{MAXIMIZED}) > 32);
  end else
    result := false;
end;

{$M+}

{$ifdef d6}
type
  // ICustomHelpProvider.
  // TranslateHelpString() is used to get information about a HelpString
  // provided by GetHelpStrings().
  // The class is asked to supply a list of custom help uri's through
  // GetHelpStrings(); CustomHelp allows the user to choose one, and then calls
  // ShowCustomHelp(), if the option 'replace default viewer' is not checked.
  // Otherwise, the link given in the selected uri will be used to show help
  // with the default viewing system.
  ICustomHelpProvider = interface(ICustomHelpViewer)
    ['{DFCBE0F2-B3AC-4D1D-B3FF-919FEAD3988B}']
    function TranslateHelpString(const HelpString: string; var Caption, Description, Link, Group: string) : boolean;
    function GetCustomHelpStrings(const HelpString: string) : TStringList;
    procedure ShowCustomHelp(const HelpString: string);
  end;

function GetCustomHelpStrings(const HelpString: string) : TStringList;
var topics : TDAString;
    idx    : Integer;
    caption, description, link, group : string;
begin
  topics := GetHelpStrings(AnsiString(HelpString), false);
  result := TStringList.Create;
  for idx := 0 to Length(topics) - 1 do
    if TranslateHelpString(string(topics[idx]), caption, description, link, group) then
      result.Add('CustomHelp://' + caption + '|' + description + '|' + link + '|' + group);
end;
{$endif}

function TranslateHelpString(const HelpString: string; var Caption, Description, Link, Group: string): Boolean;
var s1, s2, s3, s4 : AnsiString;
    i1, i2, i3     : integer;
    topics         : TDAString;
    arrCh          : array [0..MAX_PATH] of AnsiChar;
begin
  result := False;
  s1 := AnsiString(HelpString);
  if (Length(s1) > 16) and (Copy(s1, Length(s1) - 15, 16) = ' (madCollection)') then
    Delete(s1, Length(s1) - 15, 16);
  madHelp.CheckWordList;

  topics := madHelp.GetHelpStrings(s1, true);
  if topics <> nil then begin
    s2 := topics[0];
    s3 := '';
    s4 := '';

    i1 := Pos(AnsiString('='), s2);
    if i1 > 0 then begin
      GetModuleFileNameA(HInstance, arrCh, MAX_PATH);
      s1 := Extract2FilePaths(arrCh) + 'Help\Data\' + Copy(s2, i1 + 1, MaxInt);
      Delete(s2, i1, MaxInt);
      s3 := 'file:///';
      i2 := Length(s1);
      for i3 := 1 to i2 do begin
        case s1[i3] of
          '\'               : s3 := s3 + '/';
          ' ', #160 .. #255 : s3 := s3 + AnsiString('%' + IntToHex(ord(s1[i3]), 2));
          else                s3 := s3 + s1[i3];
        end;
      end;
    end;

    i1 := Pos(AnsiString('|'), s2);
    if i1 > 0 then begin
      s4 := Copy(s2, i1 + 1, MaxInt);
      Delete(s2, i1, MaxInt);
    end;

    Caption     := string(s2);
    Link        := string(s3);
    Description := string(s4);
    Group       := 'madCollection Help';

    result := true;
  end;
end;

{$ifndef d6}

  function WinHelpHookFunc(wndMain: dword; help: PAnsiChar; command, data: dword) : longBool; stdcall;
  var s1 : AnsiString;
      i1 : integer;
      b1 : boolean;
  begin
    if command <> HELP_FORCEFILE then begin
      if data <> 0 then begin
        s1 := '';
        case command of
          HELP_KEY     : s1 := PAnsiChar(data);
          HELP_COMMAND : begin
                           s1 := PAnsiChar(data);
                           b1 := true;
                           if Copy(s1, 1, 7) = 'IE(AL("' then
                             for i1 := 8 to Length(s1) do
                               if s1[i1] = '"' then begin
                                 s1 := Copy(s1, 8, i1 - 8);
                                 b1 := false;
                                 break;
                               end;
                           if b1 then
                             s1 := '';
                         end;
        end;
        result := (s1 <> '') and ShowHelp(GetHelpStrings(s1, false));
        if result then
          exit;
      end;
      WinHelpNextHook(wndMain, help, HELP_FORCEFILE, 0);
      result := WinHelpNextHook(wndMain, help, command, data);
    end else result := true;
  end;

{$else}

  type
    TMadHelpViewer = class (TInterfacedObject, ICustomHelpViewer, ICustomHelpProvider)
      function  GetViewerName : string;
      function  UnderstandsKeyword(const HelpString: string) : integer;
      function  GetHelpStrings(const HelpString: string) : TStringList;
      function  CanShowTableOfContents : boolean;
      procedure ShowTableOfContents;
      procedure ShowHelp(const HelpString: string);
      procedure NotifyID(const ViewerID: integer);
      procedure SoftShutDown;
      procedure ShutDown;
      function TranslateHelpString(const HelpString: string; var Caption, Description, Link, Group: string) : boolean;
      function GetCustomHelpStrings(const HelpString: string) : TStringList;
      procedure ShowCustomHelp(const HelpString: string);
    end;

  var
    FViewerID   : integer;
    HelpManager : IHelpManager;
 
  function TMadHelpViewer.TranslateHelpString(const HelpString: string; var Caption, Description, Link, Group: string) : boolean;
  begin
    result := madHelp.TranslateHelpString(HelpString, Caption, Description, Link, Group);
  end;

  function TMadHelpViewer.GetCustomHelpStrings(const HelpString: string) : TStringList;
  begin
    result := madHelp.GetCustomHelpStrings(HelpString);
  end;

  procedure TMadHelpViewer.ShowCustomHelp(const HelpString: string);
  var s1 : string;
      i1 : Integer;
  begin
    s1 := HelpString;
    if (Length(s1) > 13) and (Copy(s1, 1, 13) = 'CustomHelp://') then
      Delete(s1, 1, 13);
    i1 := Pos('|', s1);
    if i1 > 0 then
      Delete(s1, i1, maxInt);
    ShowHelp(s1);
  end;

  function TMadHelpViewer.GetViewerName : string;
  begin
    result := 'madCollection help';
  end;

  function TMadHelpViewer.UnderstandsKeyword(const HelpString: string) : integer;
  begin
    if madHelp.GetHelpStrings(AnsiString(HelpString), false) <> nil then
         result := 1
    else result := 0;
  end;

  function TMadHelpViewer.GetHelpStrings(const HelpString: string) : TStringList;
  begin
    result := TStringList.Create;
    if madHelp.GetHelpStrings(AnsiString(HelpString), false) <> nil then
      result.Add(HelpString + ' (madCollection)');
  end;

  function TMadHelpViewer.CanShowTableOfContents : boolean;
  begin
    result := true;
  end;

  procedure TMadHelpViewer.ShowTableOfContents;
  var arrCh : array [0..MAX_PATH] of AnsiChar;
      s1    : AnsiString;
  begin
    GetModuleFileNameA(HInstance, arrCh, MAX_PATH);
    s1 := Extract2FilePaths(arrCh) + 'Help\Content.htm';
    if (FindExecutableA(PAnsiChar(s1), nil, arrCh) > 32) then
      ShellExecuteA(0, nil, arrCh, PAnsiChar(s1), nil, SW_SHOWNORMAL{MAXIMIZED});
  end;

  procedure TMadHelpViewer.ShowHelp(const HelpString: string);
  var s1 : AnsiString;
  begin
    s1 := AnsiString(HelpString);
    if (Length(s1) > 16) and (Copy(s1, Length(s1) - 15, 16) = ' (madCollection)') then
      Delete(s1, Length(s1) - 15, 16);
    madHelp.ShowHelp(madHelp.GetHelpStrings(s1, false));
  end;

  procedure TMadHelpViewer.NotifyID(const ViewerID: integer);
  begin
    FViewerID := ViewerID;
  end;

  procedure TMadHelpViewer.SoftShutDown; begin end;
  procedure TMadHelpViewer.ShutDown;     begin end;

{$endif}

// ***************************************************************

procedure Register;
var arrCh : array [0..MAX_PATH] of AnsiChar;
begin
  GetModuleFileNameA(HInstance, arrCh, MAX_PATH);
  SetFileAttributesA(PAnsiChar(Extract2FilePaths(arrCh) + 'Help\Data\Choose.htm'), 0);
  DeleteFile(string(Extract2FilePaths(arrCh)) + 'Help\Data\Choose.htm');
  {$ifndef d6}
    HookWinHelpDll := LoadLibraryA(PAnsiChar(AnsiString(ExtractFilePath(string(arrCh))) + 'madHookWinHelp.dll'));
    if HookWinHelpDll <> 0 then begin
      HookWinHelp := GetProcAddress(HookWinHelpDll, 'HookWinHelpA');
      HookWinHelp(WinHelpHookFunc, WinHelpNextHook);
    end;
  {$else}
    RegisterViewer(TMadHelpViewer.Create, HelpManager);
  {$endif}
end;

var arrCh : array [0..MAX_PATH] of AnsiChar;
initialization
finalization
  {$ifndef d6}
    if HookWinHelpDll <> 0 then begin
      UnhookWinHelp := GetProcAddress(HookWinHelpDll, 'UnhookWinHelpA');
      UnhookWinHelp(WinHelpNextHook);
      FreeLibrary(HookWinHelpDll);
    end;
  {$else}
    HelpManager.Release(FViewerID);
  {$endif}
  WinHelpList.Free;
  GetModuleFileNameA(HInstance, arrCh, MAX_PATH);
  SetFileAttributesA(PAnsiChar(Extract2FilePaths(arrCh) + 'Help\Data\Choose.htm'), 0);
  DeleteFile(string(Extract2FilePaths(arrCh)) + 'Help\Data\Choose.htm');
end.
