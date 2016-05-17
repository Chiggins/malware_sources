unit UnitListarPortasAtivas;

interface

uses
  Windows,
  winsock,
  tlhelp32,
  UnitServerUtils;


resourcestring
  ResTCPStateClosed = 'CLOSED';
  ResTCPStateListen = 'LISTEN';
  ResTCPStateSynSent = 'SYNSENT';
  ResTCPStateSynRcvd = 'SYNRCVD';
  ResTCPStateEst = 'ESTABLISHED';
  ResTCPStateFW1 = 'FIN_WAIT1';
  ResTCPStateFW2 = 'FIN_WAIT2';
  ResTCPStateCloseWait = 'CLOSE_WAIT';
  ResTCPStateClosing = 'CLOSING';
  ResTCPStateLastAck = 'LAST_ACK';
  ResTCPStateTimeWait = 'TIME_WAIT';
  ResTCPStateDeleteTCB = 'DELETE_TCB';

const

     TCP_STATES: array[1..12] of string = (ResTCPStateClosed,
                                           ResTCPStateListen,
                                           ResTCPStateSynSent,
                                           ResTCPStateSynRcvd,
                                           ResTCPStateEst,
                                           ResTCPStateFW1,
                                           ResTCPStateFW2,
                                           ResTCPStateCloseWait,
                                           ResTCPStateClosing,
                                           ResTCPStateLastAck,
                                           ResTCPStateTimeWait,
                                           ResTCPStateDeleteTCB);

type
 
    TCP_TABLE_CLASS = (TCP_TABLE_BASIC_LISTENER, TCP_TABLE_BASIC_CONNECTIONS,
                       TCP_TABLE_BASIC_ALL, TCP_TABLE_OWNER_PID_LISTENER,
                       TCP_TABLE_OWNER_PID_CONNECTIONS, TCP_TABLE_OWNER_PID_ALL,
                       TCP_TABLE_OWNER_MODULE_LISTENER, TCP_TABLE_OWNER_MODULE_CONNECTIONS,
                       TCP_TABLE_OWNER_MODULE_ALL);

    UDP_TABLE_CLASS = (UDP_TABLE_BASIC, UDP_TABLE_OWNER_PID, UDP_TABLE_OWNER_MODULE);

    PMIB_TCPROW = ^MIB_TCPROW;
    MIB_TCPROW = packed record
      dwState: DWORD;
      dwLocalAddr: DWORD;
      dwLocalPort: DWORD;
      dwRemoteAddr: DWORD;
      dwRemotePort: DWORD;
    end;

    PMIB_TCPROW_OWNER_PID = ^MIB_TCPROW_OWNER_PID;
    MIB_TCPROW_OWNER_PID = packed record
      dwState: DWORD;
      dwLocalAddr: DWORD;
      dwLocalPort: DWORD;
      dwRemoteAddr: DWORD;
      dwRemotePort: DWORD;
      dwOwnerPID: DWORD;
    end;

    PMIB_UDPROW_OWNER_PID = ^MIB_UDPROW_OWNER_PID;
    MIB_UDPROW_OWNER_PID = packed record
      dwLocalAddr: DWORD;
      dwLocalPort: DWORD;
      dwOwnerPID: DWORD;
    end;

    PMIB_TCPTABLE_OWNER_PID = ^MIB_TCPTABLE_OWNER_PID;
    MIB_TCPTABLE_OWNER_PID = packed record
      dwNumEntries: DWORD;
      table: array [0..0] of MIB_TCPROW_OWNER_PID;
    end;

    PMIB_UDPTABLE_OWNER_PID = ^MIB_UDPTABLE_OWNER_PID;
    MIB_UDPTABLE_OWNER_PID = packed record
      dwNumEntries: DWORD;
      table: array [0..0] of MIB_UDPROW_OWNER_PID;
    end;

    TAllocateAndGetTcpExTableFromStack = function (pTcpTable: PMIB_TCPTABLE_OWNER_PID;bOrder: BOOL;heap: THandle;
                                                   zero: DWORD;flags: DWORD):DWORD;stdcall;
    TAllocateAndGetUdpExTableFromStack = function (pTcpTable: PMIB_TCPTABLE_OWNER_PID;bOrder: BOOL;heap: THandle;
                                                   zero: DWORD;flags: DWORD):DWORD;stdcall;
    TSendTcpEntry = function (pTCPRow: PMIB_TCPROW):DWORD;stdcall;
    TGetExtendedTcpTable = function (pTcpTable: PMIB_TCPTABLE_OWNER_PID;pdwSize: PDWORD;bOrder: BOOL;ulAf: ULONG;
                                     TableClass: TCP_TABLE_CLASS;Reserved: ULONG):DWORD;stdcall;
    TGetExtendedUdpTable = function (pTcpTable: PMIB_UDPTABLE_OWNER_PID;pdwSize: PDWORD;bOrder: BOOL;ulAf: ULONG;
                                     TableClass: UDP_TABLE_CLASS;Reserved: ULONG):DWORD;stdcall;

const
  MIB_TCP_STATE_CLOSED = 1;
  MIB_TCP_STATE_LISTEN = 2;
  MIB_TCP_STATE_SYN_SENT = 3;
  MIB_TCP_STATE_SYN_RCVD = 4;
  MIB_TCP_STATE_ESTAB = 5;
  MIB_TCP_STATE_FIN_WAIT1 = 6;
  MIB_TCP_STATE_FIN_WAIT2 = 7;
  MIB_TCP_STATE_CLOSE_WAIT = 8;
  MIB_TCP_STATE_CLOSING = 9;
  MIB_TCP_STATE_LAST_ACK = 10;
  MIB_TCP_STATE_TIME_WAIT = 11;
  MIB_TCP_STATE_DELETE_TCB = 12;

var
   IPHelperLoaded: Boolean;
   IPHelperXPLoaded: Boolean;
   IPHelperVistaLoaded: Boolean;
   AllocateAndGetTcpExTableFromStack: TAllocateAndGetTcpExTableFromStack;
   AllocateAndGetUdpExTableFromStack: TAllocateAndGetUdpExTableFromStack;
   SetTcpEntry: TSendTcpEntry;
   GetExtendedTcpTable: TGetExtendedTcpTable;
   GetExtendedUdpTable: TGetExtendedUdpTable;

   FBufferTCP : PMIB_TCPTABLE_OWNER_PID;
   FBufferUDP : PMIB_UDPTABLE_OWNER_PID;

function GetIP(AIP: DWORD): WideString;
function GetPort(APort: DWORD): DWORD;
procedure ReadTCPTable;
procedure ReadUdpTable;
function CriarLista(ResolveDNS: boolean): string;
function CloseTcpConnect(LocalHost, RemoteHost: string; LocalPort, RemotePort: integer): boolean;

implementation

const
     iphelper = 'iphlpapi.dll';
var
   LibHandle: THandle;

function GetNameFromIP(const IP: String): String;
var
  WSA: TWSAData;
  Host: PHostEnt;
  Addr: Integer;
  Err: Integer;
begin
  Result := IP;
  if IP = '127.0.0.1' then
  begin
    result := 'localhost';
    exit;
  end;
  Err := WSAStartup($101, WSA);
  if Err <> 0 then Exit;
  try
    Addr := inet_addr(PChar(IP));
    if Addr = INADDR_NONE then
    begin
      WSACleanup;
      Exit;
    end;
    Host := gethostbyaddr(@Addr, SizeOf(Addr), PF_INET);
    if Assigned(Host) then Result := Host.h_name;
    finally
    WSACleanup;
  end;
end;

function CloseTcpConnect(LocalHost, RemoteHost: string; LocalPort, RemotePort: integer): boolean;
var
  item: MIB_TCPROW_OWNER_PID;
  I : Integer;
begin
  result := false;

  For I := 0 To FBufferTCP^.dwNumEntries Do
  begin
    item := FBufferTCP^.table[I];
    if ( (GetIP(item.dwLocalAddr) = LocalHost) or (GetNameFromIP(GetIP(item.dwLocalAddr)) = LocalHost) ) and
       (GetPort(item.dwLocalPort) = LocalPort) and
       ( (GetIP(item.dwRemoteAddr) = RemoteHost) or (GetNameFromIP(GetIP(item.dwRemoteAddr)) = RemoteHost) ) and
       (GetPort(item.dwRemotePort) = RemotePort) then
     begin
       item.dwState := MIB_TCP_STATE_DELETE_TCB;
       SetTcpEntry(@item);
       result := true;
       break;
     end;
  end;
end;

function GetIP(AIP: DWORD): WideString;
var bytes: array[0..3] of Byte;
begin
  Move(AIP, bytes[0], SizeOf(AIP));
  Result := IntToStr(bytes[0]) + '.' +
            IntToStr(bytes[1]) + '.' +
            IntToStr(bytes[2]) + '.' +
            IntToStr(bytes[3]);
end;

function GetPort(APort: DWORD): DWORD;
begin
  Result := (APort div 256) + (APort mod 256) * 256;
end;

procedure ReadTCPTable;
var wsadata: TWSAData;
    ret: DWORD;
    dwSize: DWORD;
begin
  if not IPHelperLoaded then
    Exit;
  WSAStartup(2, wsadata);
  try
    if IPHelperVistaLoaded then begin
      dwSize := 0;
      ret := GetExtendedTcpTable(FBufferTCP, @dwSize, True, AF_INET, TCP_TABLE_OWNER_PID_ALL, 0);
      if ret = ERROR_INSUFFICIENT_BUFFER then begin
        GetMem(FBufferTCP, dwSize);
        GetExtendedTcpTable(FBufferTCP, @dwSize, True, AF_INET, TCP_TABLE_OWNER_PID_ALL, 0);
      end;
    end else if IPHelperXPLoaded then
      AllocateAndGetTcpExTableFromStack(@FBufferTCP, True, GetProcessHeap, 2, 2);
  finally
    WSACleanup;
  end;
end;

procedure ReadUdpTable;
var wsadata: TWSAData;
    ret: DWORD;
    dwSize: DWORD;
begin
  if not IPHelperLoaded then
    Exit;
  WSAStartup(2, wsadata);
  try
    if IPHelperVistaLoaded then begin
      dwSize := 0;
      ret := GetExtendedUdpTable(FBufferUdp, @dwSize, True, AF_INET, Udp_TABLE_OWNER_PID, 0);
      if ret = ERROR_INSUFFICIENT_BUFFER then begin
        GetMem(FBufferUdp, dwSize);
        GetExtendedUdpTable(FBufferUdp, @dwSize, True, AF_INET, Udp_TABLE_OWNER_PID, 0);
      end;
    end else if IPHelperXPLoaded then
      AllocateAndGetTcpExTableFromStack(@FBufferUdp, True, GetProcessHeap, 2, 2);
  finally
    WSACleanup;
  end;
end;

procedure LoadIPHelper;
begin
  LibHandle := LoadLibrary(iphelper);
  if LibHandle <> INVALID_HANDLE_VALUE then begin
    @AllocateAndGetTcpExTableFromStack := GetProcAddress(LibHandle, 'AllocateAndGetTcpExTableFromStack');
    @AllocateAndGetUdpExTableFromStack := GetProcAddress(LibHandle, 'AllocateAndGetUdpExTableFromStack');
    @SetTcpEntry := GetProcAddress(LibHandle, 'SetTcpEntry');
    @GetExtendedTcpTable := GetProcAddress(LibHandle, 'GetExtendedTcpTable');
    @GetExtendedUdpTable := GetProcAddress(LibHandle, 'GetExtendedUdpTable');
  end;
  IPHelperLoaded := (LibHandle <> INVALID_HANDLE_VALUE) and Assigned(SetTcpEntry);
  IPHelperXPLoaded := IPHelperLoaded and
                      (Assigned(AllocateAndGetTcpExTableFromStack) and Assigned(AllocateAndGetUdpExTableFromStack));
  IPHelperVistaLoaded := IPHelperLoaded and
                         (Assigned(GetExtendedTcpTable) and Assigned(GetExtendedUdpTable));
end;

procedure ReleaseIPHelper;
begin
  if LibHandle <> INVALID_HANDLE_VALUE then
    FreeLibrary(LibHandle);
end;

function ProcessName(PID: DWORD; DefaultName: string): string;
var
  Entry: TProcessEntry32;
  ProcessHandle : THandle;
begin
  Entry.dwSize := SizeOf(TProcessEntry32);
  ProcessHandle := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if not Process32First(ProcessHandle, Entry) then Result := DefaultName else
  repeat
    if Entry.th32ProcessID = PID then Result := Entry.szExeFile;
  until not Process32Next(ProcessHandle, Entry);
end;

function CriarLista(ResolveDNS: boolean): string;
var
  item: MIB_TCPROW_OWNER_PID;
  item2: MIB_UDPROW_OWNER_PID;
  I : Integer;
  Protocolo: string;
  LocalHost, RemoteHost: string;
  LocalPort, RemotePort: integer;
  RemoteHostUDP, RemotePortUDP: string;
  ProcName: string;
  Status: string;
  PID: integer;
begin
  result := inttostr(getcurrentprocessid) + '|'; // para saber qual é o meu hehehehe

  For I := 0 To FBufferTCP^.dwNumEntries Do
  begin
    item := FBufferTCP^.table[I];
    Protocolo := 'TCP';

    if ResolveDNS = false then
      LocalHost := GetIP(item.dwLocalAddr) else
      LocalHost := GetNameFromIP(GetIP(item.dwLocalAddr));

    LocalPort := GetPort(item.dwLocalPort);
    if ResolveDNS = false then
      RemoteHost := GetIP(item.dwRemoteAddr) else
      RemoteHost := GetNameFromIP(GetIP(item.dwRemoteAddr));

    RemotePort := GetPort(item.dwRemotePort);
    ProcName := ProcessName(item.dwOwnerPID, 'Unknown');
    PID := item.dwOwnerPID;

    // problema aqui...
    if (item.dwState = 0) or (item.dwState > 12) then Status := '-' else
    Status := TCP_STATES[item.dwState];


    Result := Result + Protocolo + '|' +
                       LocalHost + '|' +
                       inttostr(LocalPort) + '|' +
                       RemoteHost + '|' +
                       inttostr(RemotePort) + '|' +
                       status + '|' +
                       inttostr(PID) + '|' +
                       procname + '|' + #13#10;
  end;

  For I := 0 To FBufferUdp^.dwNumEntries Do
  begin
    item2 := FBufferUdp^.table[I];

    Protocolo := 'UDP';
    if ResolveDNS = false then
      LocalHost := GetIP(item2.dwLocalAddr) else LocalHost := GetNameFromIP(GetIP(item2.dwLocalAddr));
    LocalPort := GetPort(item2.dwLocalPort);
    RemoteHostUDP := '*';
    RemotePortUDP := '*';
    ProcName := ProcessName(item2.dwOwnerPID, 'Unknown');
    PID := item2.dwOwnerPID;
    Status := '-';
    Result := Result + Protocolo + '|' +
                       LocalHost + '|' +
                       inttostr(LocalPort) + '|' +
                       RemoteHostUDP + '|' +
                       RemotePortUDP + '|' +
                       status + '|' +
                       inttostr(PID) + '|' +
                       procname + '|' + #13#10;
  end;
end;

initialization

  LoadIPHelper;

finalization

  ReleaseIPHelper;

end.
{
sample usage for TCP:

procedure TExtTCPTable.ReadTCPTable;
var wsadata: TWSAData;
    ret: DWORD;
    dwSize: DWORD;
begin
  if not IPHelperLoaded then
    Exit;
  WSAStartup(2, wsadata);
  try
    if IPHelperVistaLoaded then begin
      dwSize := 0;
      ret := GetExtendedTcpTable(FBufferTCP, @dwSize, True, AF_INET, TCP_TABLE_OWNER_PID_ALL, 0);
      if ret = ERROR_INSUFFICIENT_BUFFER then begin
        GetMem(FBufferTCP, dwSize);
        GetExtendedTcpTable(FBufferTCP, @dwSize, True, AF_INET, TCP_TABLE_OWNER_PID_ALL, 0);
      end;
    end else if IPHelperXPLoaded then
      AllocateAndGetTcpExTableFromStack(@FBufferTCP, True, GetProcessHeap, 2, 2);
  finally
    WSACleanup;
  end;
end;

where

FBufferTCP: PMIB_TCPTABLE_OWNER_PID;


FBufferTCP^.dwNumEntries returns number of entries

var item: MIB_TCPROW_OWNER_PID;

item := FBufferTCP^.table[ARow];

GetIP(item.dwLocalAddr);
GetPort(item.dwLocalPort);

function GetIP(AIP: DWORD): WideString;
var bytes: array[0..3] of Byte;
begin
  Move(AIP, bytes[0], SizeOf(AIP));
  Result := IntToStr(bytes[0]) + '.' +
            IntToStr(bytes[1]) + '.' +
            IntToStr(bytes[2]) + '.' +
            IntToStr(bytes[3]);
end;

function GetPort(APort: DWORD): DWORD;
begin
  Result := (APort div 256) + (APort mod 256) * 256;
end;

if you want to try close connection, you should use:
SetTcpEntry and set MIB_TCPROW.dwState to MIB_TCP_STATE_DELETE_TCB

it's a bit messy but I had to retrieve it from bigger project, but should give you enough information to complete your task.


ziolko.
}
