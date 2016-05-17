#include "../Includes/includes.h"

//kernel32.dll
vIsWow64Process fncIsWow64Process;

//advapi32.dll
vConvertStringSecurityDescriptorToSecurityDescriptor fncConvertStringSecurityDescriptorToSecurityDescriptor;
vConvertSecurityDescriptorToSecurityDescriptorString fncConvertSecurityDescriptorToSecurityDescriptorString;
vGetCurrentHwProfile fncGetCurrentHwProfile;

//icmp.dll
vIcmpCreateFile fncIcmpCreateFile;
vIcmpCloseHandle fncIcmpCloseHandle;
//vIcmpSendEcho fncIcmpSendEcho;
vIcmpParseReplies fncIcmpParseReplies;

//urlmon.dll
vObtainUserAgentString fncObtainUserAgentString;

//wininet.dll
/*vInternetConnect fncInternetConnect;
vInternetOpen fncInternetOpen;
vInternetOpenUrl fncInternetOpenUrl;
vInternetCloseHandle fncInternetCloseHandle;
vInternetReadFile fncInternetReadFile;
vFtpPutFile fncFtpPutFile;*/

//ws2_32.dll
vWSAStartup fncWSAStartup;
vWSACleanup fncWSACleanup;
vgethostbyname fncgethostbyname;
vhtons fnchtons;
vsocket fncsocket;
vioctlsocket fncioctlsocket;
vconnect fncconnect;
vclosesocket fncclosesocket;
vsend fncsend;
vrecv fncrecv;
vsendto fncsendto;
vinet_ntoa fncinet_ntoa;
vinet_addr fncinet_addr;

//rpcrt4.dll
vUuidCreate fncUuidCreate;
vUuidToString fncUuidToString;
vRpcStringFree fncRpcStringFree;

bool DynamicLoadLibraries()
{
    HMODULE dll_kernel32 = LoadLibraryW(L"kernel32.dll");
    if(dll_kernel32 != NULL)
    {
        fncIsWow64Process = (vIsWow64Process)GetProcAddress(dll_kernel32, "IsWow64Process");
    }
    else
        return FALSE;
    //FreeLibrary(dll_kernel32);

    HMODULE dll_advapi32 = LoadLibraryW(L"advapi32.dll");
    if(dll_advapi32 != NULL)
    {
        fncConvertStringSecurityDescriptorToSecurityDescriptor = (vConvertStringSecurityDescriptorToSecurityDescriptor)GetProcAddress(dll_advapi32, "ConvertStringSecurityDescriptorToSecurityDescriptorW");
        fncConvertSecurityDescriptorToSecurityDescriptorString = (vConvertSecurityDescriptorToSecurityDescriptorString)GetProcAddress(dll_advapi32, "ConvertSecurityDescriptorToSecurityDescriptorStringW");
        fncGetCurrentHwProfile = (vGetCurrentHwProfile)GetProcAddress(dll_advapi32, "GetCurrentHwProfileA");
    }
    else
        return FALSE;
    //FreeLibrary(dll_advapi32);

    HMODULE dll_icmp = LoadLibraryW(L"icmp.dll");
    if(dll_icmp != NULL)
    {
        fncIcmpCreateFile = (vIcmpCreateFile)GetProcAddress(dll_icmp, "IcmpCreateFile");
        fncIcmpCloseHandle = (vIcmpCloseHandle)GetProcAddress(dll_icmp, "IcmpCloseHandle");
        //fncIcmpSendEchofncIcmpParseReplies = (vIcmpSendEcho)GetProcAddress(dll_icmp, "IcmpSendEcho");
        fncIcmpParseReplies = (vIcmpParseReplies)GetProcAddress(dll_icmp, "IcmpParseReplies");

    }
    else
        return FALSE;
    //FreeLibrary(dll_icmp);

    HMODULE dll_urlmon = LoadLibraryW(L"urlmon.dll");
    if(dll_urlmon != NULL)
    {
        fncObtainUserAgentString = (vObtainUserAgentString)GetProcAddress(dll_urlmon, "ObtainUserAgentString");
    }
    else
        return FALSE;
    //FreeLibrary(dll_urlmon);

    /*HMODULE dll_wininet = LoadLibraryW(L"wininet.dll");
    if(dll_wininet != NULL)
    {
        fncInternetConnect = (vInternetConnect)GetProcAddress(dll_wininet, "InternetConnect");
        fncInternetOpen = (vInternetOpen)GetProcAddress(dll_wininet, "InternetOpen");
        fncInternetOpenUrl = (vInternetOpenUrl)GetProcAddress(dll_wininet, "InternetOpenUrl");
        fncInternetCloseHandle = (vInternetCloseHandle)GetProcAddress(dll_wininet, "InternetCloseHandle");
        fncInternetReadFile = (vInternetReadFile)GetProcAddress(dll_wininet, "InternetReadFile");
    }
    else
        return FALSE;
    FreeLibrary(dll_wininet);*/

    HMODULE dll_ws2_32 = LoadLibraryW(L"ws2_32.dll");
    if(dll_ws2_32 != NULL)
    {
        fncWSAStartup = (vWSAStartup)GetProcAddress(dll_ws2_32, "WSAStartup");
        fncgethostbyname = (vgethostbyname)GetProcAddress(dll_ws2_32, "gethostbyname");
        fnchtons = (vhtons)GetProcAddress(dll_ws2_32, "htons");
        fncsocket = (vsocket)GetProcAddress(dll_ws2_32, "socket");
        fncioctlsocket = (vioctlsocket)GetProcAddress(dll_ws2_32, "ioctlsocket");
        fncconnect = (vconnect)GetProcAddress(dll_ws2_32, "connect");
        fncclosesocket = (vclosesocket)GetProcAddress(dll_ws2_32, "closesocket");
        fncsend = (vsend)GetProcAddress(dll_ws2_32, "send");
        fncrecv = (vrecv)GetProcAddress(dll_ws2_32, "recv");
        fncsendto = (vsendto)GetProcAddress(dll_ws2_32, "sendto");
        fncinet_ntoa = (vinet_ntoa)GetProcAddress(dll_ws2_32, "inet_ntoa");
        fncinet_addr = (vinet_addr)GetProcAddress(dll_ws2_32, "inet_addr");
    }
    else
        return FALSE;
    //FreeLibrary(dll_ws2_32);

    HMODULE dll_rpcrt4 = LoadLibraryW(L"rpcrt4.dll");
    if(dll_rpcrt4 != NULL)
    {
        fncUuidCreate = (vUuidCreate)GetProcAddress(dll_rpcrt4, "UuidCreate");
        fncUuidToString = (vUuidToString)GetProcAddress(dll_rpcrt4, "UuidToStringA");
        fncRpcStringFree = (vRpcStringFree)GetProcAddress(dll_rpcrt4, "RpcStringFreeA");
    }
    else
        return FALSE;
    //FreeLibrary(dll_rpcrt4);

    return TRUE;
}
