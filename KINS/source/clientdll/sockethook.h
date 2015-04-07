/*
  Перехват WinSocket.
*/
#pragma once

namespace SocketHook
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
    Перехватчик closesocket.
  */
  int WSAAPI hookerCloseSocket(SOCKET s);
  
  /*
    Перехватчик send.
  */
  int WSAAPI hookerSend(SOCKET s, const char *buf, int len, int flags);

  /*
    Перехватчик WSASend.
  */
  int WSAAPI hookerWsaSend(SOCKET s, LPWSABUF buffers, DWORD bufferCount, LPDWORD numberOfBytesSent, DWORD flags, LPWSAOVERLAPPED overlapped, LPWSAOVERLAPPED_COMPLETION_ROUTINE completionRoutine);

  /*
    Перехватчик connect.
  */
  int WSAAPI hookerConnect(SOCKET s, const struct sockaddr FAR * name, int namelen);

  /*
    Перехватчик WSAConnect.
  */
  int WINAPI hookerWSAConnect(SOCKET s, const struct sockaddr *name, int namelen, LPWSABUF lpCallerData, LPWSABUF lpCalleeData, LPQOS lpSQOS, LPQOS lpGQOS);
};