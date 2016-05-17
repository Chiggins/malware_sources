#include "../Includes/includes.h"


/*---------------------------------------------------------------------
 *
 * Program: MS_ICMP.EXE
 *
 * filename: ms_icmp.c
 *
 *  Copyright by Bob Quinn, 1997          http://www.sockets.com
 *
 * Description:
 *  This is a ping program that uses Microsoft's ICMP.DLL functions
 *  for access to Internet Control Message Protocol.  This is capable
 *  of doing "ping or "traceroute", although beware that Microsoft
 *  discourages the use of these APIs.
 *
 *  Tested with MSVC 5 compile with "cl ms_icmp.c /link ws2_32.lib"
 *  from the console (if you've run VCVARS32.BAT batch file that
 *  ships with MSVC to set the proper environment variables)
 *
 * NOTES:
 * - With both "Don't Fragment" and "Router Alert" set, the
 *    IP don't fragment bit is set, but not the router alert option.
 * - The ICMP.DLL calls are not redirected to the TCP/IP service
 *    provider (what's interesting about this is that the setsockopt()
 *    IP_OPTION flag can't do Router Alert, but this API can ...hmmm.
 * - Although the IcmpSendEcho() docs say it can return multiple
 *    responses, if I receive multiple responses (e.g. sending to
 *    a limited or subnet broadcast address) IcmpSendEcho() only
 *    returns one.  Interesting that NT4 and Win98 don't respond
 *    to broadcast pings.
 * - using winsock.h  WSOCK32.LIB and version 1.1 works as well as
 *    using winsock2.h WS2_32.LIB  and version 2.2
 *
 * Some Background:
 *
 * The standard Berkeley Sockets SOCK_RAW socket type, is normally used
 * to create ping (echo request/reply), and sometimes traceroute applications
 * (the original traceroute application from Van Jacobson used UDP, rather
 * than ICMP). Microsoft's WinSock version 2 implementations for NT4 and
 * Windows 95 support raw sockets, but none of their WinSock version 1.1
 * implementations (WFWG, NT3.x or standard Windows 95) did.
 *
 * Microsoft has their own API for an ICMP.DLL that their ping and tracert
 * applications use (by the way, they are both non-GUI text-based console
 * applications. This is a proprietary API, and all function calls that
 * involve network functions operate in blocking mode. They still include
 * it with WinSock 2 implementations.
 *
 * There is little documentation available (I first found it in the Win32
 * SDK in \MSTOOLS\ICMP, and it exists on the MS&nbsp;Developers' Network
 * CD-ROM now, also). Microsoft disclaims this API about as strongly as
 * possible.  The README.TXT that accompanies it says:
 *
 * [DISCLAIMER]
 *
 * We have had requests in the past to expose the functions exported from
 * icmp.dll. The files in this directory are provided for your convenience
 * in building applications which make use of ICMPSendEcho(). Notice that
 * the functions in icmp.dll are not considered part of the Win32 API and
 * will not be supported in future releases. Once we have a more complete
 * solution in the operating system, this DLL, and the functions it exports,
 * will be dropped.
 *
 * [DOCUMENTATION]
 *
 * The ICMPSendEcho() function sends an ICMP echo request to the specified
 * destination IP address and returns any replies received within the timeout
 * specified. The API is synchronous, requiring the process to spawn a thread
 * before calling the API to avoid blocking. An open IcmpHandle is required
 * for the request to complete. IcmpCreateFile() and IcmpCloseHandle()
 * functions are used to create and destroy the context handle.
 *
 * Edit History:
 *  rcq  11/16/97  created
 */


// #include <winsock.h>
#include <winsock2.h>

#include "ms_icmp.h"

#define BUFSIZE     8192
#define DEFAULT_LEN 32
#define LOOPLIMIT   4
#define TIMEOUT     5000
#define DEFAULT_TTL 64

/* IP Flags - 3 bits
 *
 *  bit 0: reserved
 *  bit 1: 0=May Fragment, 1=Don't Fragment
 *  bit 2: 0=Last Fragment, 1=More Fragments
 */
#define IPFLAG_DONT_FRAGMENT 0x02

/*
 * Router Alert is defined by Dave Katz of Cisco in
 *  ftp://ds.internic.net/rfc/rfc2113.txt
 * and is used by RSVP and IGMPv2
 *
 *  The Router Alert option has the following format:
 *
 *    +--------+--------+--------+--------+
 *    |10010100|00000100|  2 octet value  |
 *    +--------+--------+--------+--------+
 *
 * Type:
 *   Copied flag:   1  (all fragments must carry the option)
 *   Option class:  0  (control)
 *   Option number: 20 (decimal)
 *
 * Length: 4
 *
 * Value:  A two octet code with the following values:
 *   0 - Router shall examine packet
 *   1 - 65535 - Reserved
 */
#define IPOPT_ROUTER_ALERT 0x94040000L

char achReqData[BUFSIZE];
char achRepData[sizeof(ICMPECHO) + BUFSIZE];

char achBCastAddr[] = {"255.255.255.255"};

FARPROC lpfnIcmpCreateFile;
FARPROC lpfnIcmpCloseHandle;
FARPROC lpfnIcmpSendEcho;

void DisplayErr(int);
void PIcmpErr(int);

/*---------------------------------------------------------
 * IcmpSendEcho() Error Strings
 *
 * The values in the status word returned in the ICMP Echo
 *  Reply buffer after calling IcmpSendEcho() all have a
 *  base value of 11000 (IP_STATUS_BASE).  At times,
 *  when IcmpSendEcho() fails outright, GetLastError() will
 *  subsequently return these error values also.
 *
 * Two Errors value defined in ms_icmp.h are missing from
 *  this string table (just to simplify use of the table):
 *    "IP_GENERAL_FAILURE (11050)"
 *    "IP_PENDING (11255)"
 */
#define MAX_ICMP_ERR_STRING  IP_STATUS_BASE + 22
char *aszSendEchoErr[] =
{
    "IP_STATUS_BASE (11000)",
    "IP_BUF_TOO_SMALL (11001)",
    "IP_DEST_NET_UNREACHABLE (11002)",
    "IP_DEST_HOST_UNREACHABLE (11003)",
    "IP_DEST_PROT_UNREACHABLE (11004)",
    "IP_DEST_PORT_UNREACHABLE (11005)",
    "IP_NO_RESOURCES (11006)",
    "IP_BAD_OPTION (11007)",
    "IP_HW_ERROR (11008)",
    "IP_PACKET_TOO_BIG (11009)",
    "IP_REQ_TIMED_OUT (11010)",
    "IP_BAD_REQ (11011)",
    "IP_BAD_ROUTE (11012)",
    "IP_TTL_EXPIRED_TRANSIT (11013)",
    "IP_TTL_EXPIRED_REASSEM (11014)",
    "IP_PARAM_PROBLEM (11015)",
    "IP_SOURCE_QUENCH (11016)",
    "IP_OPTION_TOO_BIG (11017)",
    "IP_BAD_DESTINATION (11018)",
    "IP_ADDR_DELETED (11019)",
    "IP_SPEC_MTU_CHANGE (11020)",
    "IP_MTU_CHANGE (11021)",
    "IP_UNLOAD (11022)"
};

void show_usage(void)
{
    printf(
        "Usage: ms_icmp {Destination} [Options]\n\n");
    printf("Options available:\n");
    printf("\t-c              Send pings continuously (1 second delay)\n");
    printf("\t-d              Enable debug output (displays response buf)\n");
    printf("\t-i <TimeToLive> Specify maximum number of router hops\n");
    printf("\t-l <BufSize>    Specify number of bytes of data to send\n");
    printf("\t-m              Set IP don't fragment flag (to check MTU)\n");
    printf("\t-n <Count>      Specify number of requests to send\n");
    printf("\t-r              Enable Router Alert IP Option (just a test)\n");
    printf("\t-t              Do a traceroute\n");
    printf("\t-w <TimeOut>    Specify timeout (in milliseconds)\n");
}

int main(int argc, char* argv[])
{
    WSADATA wsaData;
    IPINFO stIPInfo, *lpstIPInfo;
    u_long lIPOption;
    LPHOSTENT lpstHost = NULL;
    HANDLE hICMP, hICMP_DLL;
    int nRet, i, j, k, nDataLen, nLoopLimit, nTimeOut, nTTL, nTOS;
    DWORD dwReplyCount;
    IN_ADDR stDestAddr;
    BOOL fRet, fFlag, fDontStop, fDontFrag, fDebug, fRouterAlert;
    BOOL fTraceRoute;

    printf ("\n-------------------------------------------------------\n");
    printf (" MS_ICMP - ping application using Microsoft's ICMP.DLL\n");
    printf ("  v1.0 (c) 1997    Bob Quinn    http://www.sockets.com\n");
    printf ("-------------------------------------------------------\n");

    /* Help Needed ? */
    if ((argc < 2) || (argc >= 2) &&
            ((strcmp(argv[1],"/help")==0) || (strcmp(argv[1],"/?")==0) ||
             (strcmp(argv[1],"-help")==0) || (strcmp(argv[1],"-?")==0)))
    {
        show_usage();
        exit(1);
    }

    nRet = WSAStartup(MAKEWORD(2, 2), &wsaData);
    if (nRet)
    {
        printf ("WSAStartup() failed, err: %d\n", nRet);
        exit(2);
    }

    /* Evaluate string provided provided to get destination address */
    if (argv[1] != '\0')
    {
        u_long lAddr;

        if ((argv[1][0] == '-') || (argv[1][0] == '/'))
        {
            show_usage();
            WSACleanup();
            exit(1);
        }

        /* Is the string an address? */
        lAddr = inet_addr(argv[1]);
        if (lAddr == INADDR_NONE)
        {

            /* Is it a limited broadcast address? */
            for (i=0; i<16; i++)
            {
                if (*(argv[1]+i) != achBCastAddr[i])
                {
                    lAddr = 0L;
                    break;
                }
            }
        }
        if (!lAddr)
        {

            /* Or, is it a hostname? */
            lpstHost = gethostbyname(argv[1]);
            if (!lpstHost)
            {
                printf ("%s is an invalid address or hostname (err: %d)\n",
                        argv[1], WSAGetLastError());
                WSACleanup();
                exit(1);
            }
            else
            {
                /* Hostname was resolved, save the address */
                stDestAddr.s_addr = *(u_long*)lpstHost->h_addr;
            }
        }
        else
        {
            /* Address is ok */
            stDestAddr.s_addr = lAddr;
        }
    }

    /*
     * Initialize default settings
     */
    nDataLen   = DEFAULT_LEN;
    nLoopLimit = LOOPLIMIT;
    nTimeOut   = TIMEOUT;
    fDontStop  = FALSE;
    fDontFrag  = FALSE;
    lpstIPInfo = NULL;
    fDebug     = FALSE;
    nTTL       = DEFAULT_TTL;
    nTOS       = 0;
    fRouterAlert = FALSE;
    fTraceRoute  = FALSE;

    /*
     * Process command line arguments (if present)
     */
    fFlag = FALSE;
    for (i=2; i<argc; i++)
    {

        if (fFlag)
        {
            fFlag = FALSE;
            continue;
        }

        if (!((argv[i][0] == '-') || (argv[i][0] == '/')))
        {
            show_usage();
            exit(1);
        }

        /* Set Loop Limit */
        if (argv[i][1] == 'n')
        {
            fFlag = TRUE;
            nLoopLimit = atoi(argv[i+1]);
            printf("Number of pings to attempt: %d\n", nLoopLimit);
        }

        /* Set Time To Live */
        if (argv[i][1] == 'i')
        {
            fFlag = TRUE;
            nTTL = atoi(argv[i+1]);
            printf("IP Time to Live set to: %d\n", nTTL);
        }

        /* Set Data Length */
        if (argv[i][1] == 'l')
        {
            fFlag = TRUE;
            nDataLen = atoi(argv[i+1]);
            if (nDataLen > BUFSIZE)
            {
                printf ("Sorry, but Data Length is too big (must be <= %d)\n",
                        BUFSIZE);
                WSACleanup();
                exit(1);
            }
            printf("Number of bytes to send: %d\n", nDataLen);
        }

        /* Set Timeout */
        if (argv[i][1] == 'w')
        {
            fFlag = TRUE;
            nTimeOut = atoi(argv[i+1]);
            printf("Number of milliseconds to wait for response: %d\n",
                   nTimeOut);
        }

        /* Set IP Type of Service field value:
         *  bits
         * 0-2: Precedence bits = 000
         *   3: Delay bit       = 0
         *   4: Throughput bit  = 1 (to maximize throughput)
         *   5: Reliability bit = 0
         *   6: Cost bit        = 0
         *   7: <reserved>      = 0
         *
         * See RFCs 1340, and 1349 for appropriate settings
         */
        if (argv[i][1] == 'v')
        {
            fFlag = TRUE;
            nTOS = atoi(argv[i+1]);
            printf("Set IP Type of Service (TOS) value: %d\n", nTOS);
        }

        /* Set Router Alert flag */
        if (argv[i][1] == 'r')
        {
            fDontStop = TRUE;
            printf("Set Router Alert IP Option (as an experiment)\n");
        }

        /* Set "send forever" flag */
        if (argv[i][1] == 'c')
        {
            fDontStop = TRUE;
            printf("Send continuous pings indefinately (1 sec spacing)\n");
        }

        /* Set Debug flag */
        if (argv[i][1] == 'd')
        {
            fDebug = TRUE;
            printf("Debug output enabled\n");
        }

        /* Set Traceroute flag */
        if (argv[i][1] == 't')
        {
            fTraceRoute = TRUE;
            printf("TraceRoute enabled\n");
        }

        /* Set Dont Fragment (IP) flag */
        if (argv[i][1] == 'm')
        {
            fDontFrag = TRUE;
            printf("IP Don't Fragment flag is set\n");
        }
    } /* end for() loop input argument processing */

    /*
     *  Load the ICMP.DLL
     */
    hICMP_DLL = LoadLibrary("ICMP.DLL");
    if (hICMP_DLL == 0)
    {
        printf ("LoadLibrary() failed: Unable to locate ICMP.DLL!\n");
        exit(3);
    }

    /*
     * Get pointers to ICMP.DLL functions
     */
    lpfnIcmpCreateFile  = (FARPROC)GetProcAddress(hICMP_DLL,"IcmpCreateFile");
    lpfnIcmpCloseHandle = (FARPROC)GetProcAddress(hICMP_DLL,"IcmpCloseHandle");
    lpfnIcmpSendEcho    = (FARPROC)GetProcAddress(hICMP_DLL,"IcmpSendEcho");
    if ((!lpfnIcmpCreateFile) ||
            (!lpfnIcmpCloseHandle) ||
            (!lpfnIcmpSendEcho))
    {
        printf ("GetProcAddr() failed for at least one function.\n");
        exit(4);
    }

    /*
     * IcmpCreateFile() - Open the ping service
     */
    hICMP = (HANDLE) lpfnIcmpCreateFile();
    if (hICMP == INVALID_HANDLE_VALUE)
    {
        printf ("IcmpCreateFile() failed, err: ");
        PIcmpErr(GetLastError());
        exit(5);
    }
    else if (fDebug)
    {
        printf ("\nIcmpCreateFile() gave us handle: 0x%lxd\n", hICMP);
    }

    /*
     * Init data buffer printable ASCII
     *  32 (space) through 126 (tilde)
     */
    for (j=0, i=32; j<nDataLen; j++, i++)
    {
        if (i>=126)
            i= 32;
        achReqData[j] = i;
    }

    /*
     * Init for Traceroute (if selected)
     *
     * (obviously, this overrides TTL and continous settings)
     */
    if (fTraceRoute)
    {
        fDontStop = TRUE;
        nTTL = 0;
    }

    /*
     * Init IPInfo structure
     */
    lpstIPInfo = &stIPInfo;
    stIPInfo.Ttl      = nTTL;
    stIPInfo.Tos      = nTOS;
    stIPInfo.Flags    = fDontFrag ? IPFLAG_DONT_FRAGMENT : 0;
    if (fRouterAlert)
    {
        lIPOption  = htonl(IPOPT_ROUTER_ALERT);  // Works if IP Flags NOT set
        stIPInfo.OptionsSize = sizeof(lIPOption);
        stIPInfo.OptionsData = (char *)&lIPOption;
    }
    else
    {
        stIPInfo.OptionsSize = 0;
        stIPInfo.OptionsData = NULL;
    }

    if (lpstHost)
    {
        printf ("\nPinging %s [%s] with %d bytes of data:\n\n",
                lpstHost->h_name, inet_ntoa(stDestAddr), nDataLen);
    }
    else
    {
        printf ("\nPinging %s with %d bytes of data:\n\n",
                inet_ntoa(stDestAddr), nDataLen);
    }

    /*
     * Ping Loop
     */
    for (k=0; k<nLoopLimit; k++)
    {

        if (k) SleepEx(1000, TRUE);   /* delay between each ping */

        if (fDontStop && (k+1 == nLoopLimit)) k=0;  /* keep it going */

        if (fTraceRoute)    /* if traceroute, inc IP Time To Live */
        {
            ++stIPInfo.Ttl;
        }

        /*
         * IcmpSendEcho() - Send the ICMP Echo Request
         *                   and read the Reply
         */
        dwReplyCount = lpfnIcmpSendEcho(hICMP,
                                        stDestAddr.s_addr,
                                        achReqData,
                                        nDataLen,
                                        lpstIPInfo,
                                        achRepData,
                                        sizeof(achRepData),
                                        nTimeOut);
        if (dwReplyCount != 0)
        {
            IN_ADDR stDestAddr;
            DWORD   dwStatus;
            int i;

            if (fDebug)
            {
                int l;
                printf ("\nIcmpSendEcho() received %d echo replies\n",
                        dwReplyCount);
                printf ("Contents of echo reply buffer:\n");
                for (l=0; l < nDataLen+8; l++)
                {
                    printf ("0x%02x ",
                            achRepData[l] & 0x00FF);
                    if (l && !(l+1%16))
                        printf("\n");
                }
                printf ("\n");
            }

            stDestAddr.s_addr = *(u_long *)achRepData;
            printf ("Reply from %s: bytes=%d time=%ldms TTL=%u\n",
                    inet_ntoa(stDestAddr),
                    *(u_long *) &(achRepData[12]),
                    *(u_long *) &(achRepData[8]),
                    fTraceRoute ?
                    stIPInfo.Ttl :
                    (*(char *)&(achRepData[20]))&0x00FF);

            dwStatus = *(DWORD *) &(achRepData[4]);
            if (dwStatus != IP_SUCCESS)
            {
                if (!fTraceRoute)
                    PIcmpErr(dwStatus);
            }
            else if (fTraceRoute)
            {
                printf ("\nTraceroute complete: Destination is %d hops away\n",
                        stIPInfo.Ttl);
                break;  /* We're done, since we reached the destination! */
            }

        }
        else
        {
            printf ("IcmpSendEcho() failed, err: ");
            PIcmpErr(GetLastError());
            if (!fTraceRoute)
                break;  // end loop
        }
    } /* end ping loop */

    /*
     * IcmpCloseHandle - Close the ICMP handle
     */
    fRet = lpfnIcmpCloseHandle(hICMP);
    if (fRet == FALSE)
    {
        int nErr = GetLastError();

        printf ("Error closing ICMP handle, err: ");
        PIcmpErr(GetLastError());
    }

    // Shut down...
    FreeLibrary(hICMP_DLL);

    WSACleanup();

    exit(0);
}


void PIcmpErr(int nICMPErr)
{
    char *szIcmpErr;
    int  nErrIndex = nICMPErr - IP_STATUS_BASE;

    if ((nICMPErr > MAX_ICMP_ERR_STRING) ||
            (nICMPErr < IP_STATUS_BASE+1))
    {

        /* Error value is out of range, display normally */
        printf ("(%d) ", nICMPErr);
        DisplayErr(nICMPErr);
        printf ("\n");
    }
    else
    {

        /* Display ICMP Error String */
        printf ("%s\n", aszSendEchoErr[nErrIndex]);
    }

    return;
} /* end PIcmpErr() */

void DisplayErr(int nWSAErr)
{
    LPVOID lpMsgBuf;

    FormatMessage(
        FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM,
        NULL,
        nWSAErr,
        MAKELANGID(LANG_NEUTRAL,
                   SUBLANG_DEFAULT), // Default language
        (LPTSTR) &lpMsgBuf,
        0,
        NULL );
    printf (lpMsgBuf);

    /* Free the buffer */
    LocalFree (lpMsgBuf);

    return;
} /* end DisplayErr() */

