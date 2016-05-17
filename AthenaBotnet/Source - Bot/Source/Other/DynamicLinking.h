//advapi32.dll
typedef BOOL (__stdcall *vConvertStringSecurityDescriptorToSecurityDescriptor)(LPCWSTR StringSecurityDescriptor, DWORD StringSDRevision, PSECURITY_DESCRIPTOR *SecurityDescriptor, PULONG SecurityDescriptorSize);
typedef BOOL (__stdcall *vConvertSecurityDescriptorToSecurityDescriptorString)(PSECURITY_DESCRIPTOR SecurityDescriptor, DWORD RequestedStringSDRevision, SECURITY_INFORMATION SecurityInformation, LPTSTR *StringSecurityDescriptor, PULONG StringSecurityDescriptorLen);
extern vConvertStringSecurityDescriptorToSecurityDescriptor fncConvertStringSecurityDescriptorToSecurityDescriptor;
extern vConvertSecurityDescriptorToSecurityDescriptorString fncConvertSecurityDescriptorToSecurityDescriptorString;
typedef BOOL WINAPI (__stdcall *vGetCurrentHwProfile)(LPHW_PROFILE_INFO lpHwProfileInfo);
extern vGetCurrentHwProfile fncGetCurrentHwProfile;

//icmp.dll
typedef HANDLE (__stdcall *vIcmpCreateFile)(void);
typedef BOOL (__stdcall *vIcmpCloseHandle)(HANDLE IcmpHandle);
//typedef DWORD (__stdcall *vIcmpSendEcho)(HANDLE IcmpHandle, IPAddr DestinationAddress, LPVOID RequestData, WORD RequestSize, PIP_OPTION_INFORMATION RequestOptions, LPVOID ReplyBuffer, DWORD ReplySize, DWORD Timeout);
typedef DWORD (__stdcall *vIcmpParseReplies)(LPVOID ReplyBuffer, DWORD ReplySize);
extern vIcmpCreateFile fncIcmpCreateFile;
extern vIcmpCloseHandle fncIcmpCloseHandle;
//extern vIcmpSendEcho fncIcmpSendEcho;
extern vIcmpParseReplies fncIcmpParseReplies;

//urlmon.dll
typedef HRESULT (__stdcall *vObtainUserAgentString)(DWORD dwOption, char *pcszUAOut, DWORD *cbSize);
extern vObtainUserAgentString fncObtainUserAgentString;

//kernel32.dll
typedef BOOL (__stdcall *vIsWow64Process)(HANDLE hProcess, PBOOL Wow64Process);
extern vIsWow64Process fncIsWow64Process;

//wininet.dll
/*typedef HINTERNET (__stdcall *vInternetConnect)(HINTERNET hInternet, LPCTSTR lpszServerName, INTERNET_PORT nServerPort, LPCTSTR lpszUsername, LPCTSTR lpszPassword, DWORD dwService, DWORD dwFlags, DWORD_PTR dwContext);
typedef HINTERNET (__stdcall *vInternetOpen)(LPCTSTR lpszAgent, DWORD dwAccessType, LPCTSTR lpszProxyName, LPCTSTR lpszProxyBypass, DWORD dwFlags);
typedef HINTERNET (__stdcall *vInternetOpenUrl)(HINTERNET hInternet, LPCTSTR lpszUrl, LPCTSTR lpszHeaders, DWORD dwHeadersLength, DWORD dwFlags, DWORD_PTR dwContext);
typedef BOOL (__stdcall *vInternetCloseHandle)(HINTERNET hInternet);
typedef BOOL (__stdcall *vInternetReadFile)(HINTERNET hFile, LPVOID lpBuffer, DWORD dwNumberOfBytesToRead, LPDWORD lpdwNumberOfBytesRead);
typedef BOOL (__stdcall *vFtpPutFile)(HINTERNET hConnect, LPCTSTR lpszLocalFile, LPCTSTR lpszNewRemoteFile, DWORD dwFlags, DWORD_PTR dwContext);
extern vInternetConnect fncInternetConnect;
extern vInternetOpen fncInternetOpen;
extern vInternetOpenUrl fncInternetOpenUrl;
extern vInternetCloseHandle fncInternetCloseHandle;
extern vInternetReadFile fncInternetReadFile;
extern vFtpPutFile fncFtpPutFile;*/

//ws2_32.dll
typedef int (__stdcall *vWSAStartup)(WORD wVersionRequested, LPWSADATA lpWSAData);
typedef int (__stdcall *vWSACleanup)(void);
typedef struct hostent* FAR (__stdcall *vgethostbyname)(const char *name);
typedef u_short WSAAPI (__stdcall *vhtons)(u_short hostshort);
typedef SOCKET WSAAPI (__stdcall *vsocket)(int af, int type, int protocol);
typedef int (__stdcall *vioctlsocket)(SOCKET s, long cmd, u_long *argp);
typedef int (__stdcall *vconnect)(SOCKET s, const struct sockaddr *name, int namelen);
typedef int (__stdcall *vclosesocket)(SOCKET s);
typedef int (__stdcall *vsend)(SOCKET s, char *buf, int len, int flags);
typedef int (__stdcall *vrecv)(SOCKET s, char *buf, int len, int flags);
typedef int (__stdcall *vsendto)(SOCKET s, const char *buf, int len, int flags, const struct sockaddr *to, int tolen);
typedef char* FAR (__stdcall *vinet_ntoa)(struct in_addr in);
typedef unsigned long (__stdcall *vinet_addr)(const char *cp);
extern vWSAStartup fncWSAStartup;
extern vWSACleanup fncWSACleanup;
extern vgethostbyname fncgethostbyname;
extern vhtons fnchtons;
extern vsocket fncsocket;
extern vioctlsocket fncioctlsocket;
extern vconnect fncconnect;
extern vclosesocket fncclosesocket;
extern vsend fncsend;
extern vrecv fncrecv;
extern vsendto fncsendto;
extern vinet_ntoa fncinet_ntoa;
extern vinet_addr fncinet_addr;

//rpcrt4.dll
typedef RPC_STATUS RPC_ENTRY (__stdcall *vUuidCreate)(UUID __RPC_FAR *Uuid);
typedef RPC_STATUS RPC_ENTRY (__stdcall *vUuidToString)(const UUID __RPC_FAR *Uuid, unsigned char *  __RPC_FAR *StringUuid);
typedef RPC_STATUS RPC_ENTRY (__stdcall *vRpcStringFree)(unsigned char **String);
extern vUuidCreate fncUuidCreate;
extern vUuidToString fncUuidToString;
extern vRpcStringFree fncRpcStringFree;

//typedef DWORD   (__stdcall *vGetProcAddress)(HMODULE hModule, LPCSTR lpProcName);
//typedef HMODULE (__stdcall *vLoadLibraryA)(LPCSTR lpLibFileName);
//typedef INT     (__stdcall *vMessageBoxA)(HWND hWnd, LPCSTR lpText, LPCSTR lpCaption, UINT uType);

/*
//Temporary storage for function used in injected threads:
typedef HMODULE (__stdcall *vLoadLibraryA)(LPCTSTR lpFileName);
typedef FARPROC WINAPI (__stdcall *vGetProcAddress)(HMODULE hModule, LPCSTR lpProcName);

typedef int WINAPI (__stdcall *vMessageBoxA)(HWND hWnd, LPCTSTR lpText, LPCTSTR lpCaption, UINT uType);
typedef DWORD (__stdcall *vNtTerminateProcess)(HANDLE ProcessHandle, DWORD ExitStatus);
typedef HANDLE WINAPI (__stdcall *vOpenMutexA)(DWORD dwDesiredAccess, BOOL bInheritHandle, LPCTSTR lpName);
typedef HANDLE WINAPI (__stdcall *vCreateMutexA)(LPVOID, BOOL bInitialOwner, LPCTSTR lpName);
typedef BOOL WINAPI (__stdcall *vReleaseMutex)(HANDLE hMutex);
typedef BOOL WINAPI (__stdcall *vCloseHandle)(HANDLE hObject);
typedef VOID WINAPI (__stdcall *vSleep)(DWORD dwMilliseconds);
typedef HINSTANCE (__stdcall *vShellExecuteA)(HWND hwnd, LPCTSTR lpOperation, LPCTSTR lpFile, LPCTSTR lpParameters, LPCTSTR lpDirectory, INT nShowCmd);
typedef DWORD WINAPI (__stdcall *vGetLastError)(void);

extern vLoadLibraryA fLoadLibraryA = (vLoadLibraryA)pstInjectData->dwLoadLibraryA;
extern vGetProcAddress fGetProcAddress = (vGetProcAddress)pstInjectData->dwGetProcAddress;

extern vMessageBoxA fMessageBoxA;
extern vNtTerminateProcess fNtTerminateProcess;
extern vOpenMutexA fOpenMutexA;
extern vCreateMutexA fCreateMutexA;
extern vReleaseMutex fReleaseMutex;
extern vCloseHandle fCloseHandle;
extern vSleep fSleep;
extern vShellExecuteA fShellExecuteA;
extern vGetLastError fGetLastError;*/
