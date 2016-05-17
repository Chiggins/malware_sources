  ; ===========================================
  ; wsock32.inc copyright MASM32 1998 - 2005
  ; ===========================================

IFNDEF WSOCK32_INC
WSOCK32_INC equ <1>

AcceptEx PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
EnumProtocolsA PROTO :DWORD,:DWORD,:DWORD
EnumProtocols equ <EnumProtocolsA>

EnumProtocolsW PROTO :DWORD,:DWORD,:DWORD
GetAcceptExSockaddrs PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetAddressByNameA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetAddressByName equ <GetAddressByNameA>

GetAddressByNameW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetNameByTypeA PROTO :DWORD,:DWORD,:DWORD
GetNameByType equ <GetNameByTypeA>

GetNameByTypeW PROTO :DWORD,:DWORD,:DWORD
GetServiceA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetService equ <GetServiceA>

GetServiceW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
GetTypeByNameA PROTO :DWORD,:DWORD
GetTypeByName equ <GetTypeByNameA>

GetTypeByNameW PROTO :DWORD,:DWORD
MigrateWinsockConfiguration PROTO :DWORD,:DWORD,:DWORD
NPLoadNameSpaces PROTO :DWORD,:DWORD,:DWORD
SetServiceA PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
SetService equ <SetServiceA>

SetServiceW PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
TransmitFile PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WEP PROTO 
WSAAsyncGetHostByAddr PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WSAAsyncGetHostByName PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WSAAsyncGetProtoByName PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WSAAsyncGetProtoByNumber PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WSAAsyncGetServByName PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WSAAsyncGetServByPort PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
WSAAsyncSelect PROTO :DWORD,:DWORD,:DWORD,:DWORD
WSACancelAsyncRequest PROTO :DWORD
WSACancelBlockingCall PROTO 
WSACleanup PROTO 
WSAGetLastError PROTO 
WSAIsBlocking PROTO 
WSARecvEx PROTO :DWORD,:DWORD,:DWORD,:DWORD
WSASetBlockingHook PROTO :DWORD
WSASetLastError PROTO :DWORD
WSAStartup PROTO :DWORD,:DWORD
WSAUnhookBlockingHook PROTO 
__WSAFDIsSet PROTO :DWORD,:DWORD
accept PROTO :DWORD,:DWORD,:DWORD
bind PROTO :DWORD,:DWORD,:DWORD
closesocket PROTO :DWORD
connect PROTO :DWORD,:DWORD,:DWORD
dn_expand PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
gethostbyaddr PROTO :DWORD,:DWORD,:DWORD
gethostbyname PROTO :DWORD
gethostname PROTO :DWORD,:DWORD
getnetbyname PROTO :DWORD
getpeername PROTO :DWORD,:DWORD,:DWORD
getprotobyname PROTO :DWORD
getprotobynumber PROTO :DWORD
getservbyname PROTO :DWORD,:DWORD
getservbyport PROTO :DWORD,:DWORD
getsockname PROTO :DWORD,:DWORD,:DWORD
getsockopt PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
htonl PROTO :DWORD
htons PROTO :DWORD
inet_addr PROTO :DWORD
inet_network PROTO :DWORD
inet_ntoa PROTO :DWORD
ioctlsocket PROTO :DWORD,:DWORD,:DWORD
listen PROTO :DWORD,:DWORD
ntohl PROTO :DWORD
ntohs PROTO :DWORD
rcmd PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
recv PROTO :DWORD,:DWORD,:DWORD,:DWORD
recvfrom PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
rexec PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
rresvport PROTO :DWORD
s_perror PROTO :DWORD,:DWORD
select PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
send PROTO :DWORD,:DWORD,:DWORD,:DWORD
sendto PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
sethostname PROTO :DWORD,:DWORD
setsockopt PROTO :DWORD,:DWORD,:DWORD,:DWORD,:DWORD
shutdown PROTO :DWORD,:DWORD
socket PROTO :DWORD,:DWORD,:DWORD

ELSE
echo -----------------------------------------
echo WARNING Duplicate include file wsock32.inc
echo -----------------------------------------
ENDIF
