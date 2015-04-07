#include <windows.h>

#include "defines.h"
#include "dllfile32.h"
#include "dllfile64.h"
#include "languages.h"
#include "main.h"

#include "..\common\config.h"
#include "..\common\str.h"

//Английский язык.
static const LPWSTR languageEn[] =
{
  L"Not enough memory",
  L"Failed to write output file.",
  L"\r\nERROR: %s",

  BOT_NAME L" Builder",

  L"Builder",
  L"Settings",

  L"Version: %u.%u.%u.%u\r\nBuild time: %s\r\n",

  L"Bot\'s source configuartion file:",
  L"Browse...",
  L"Edit...",
  
  L"Actions",
  L"Build dll",
  L"Build Dropper",
  L"-- file not selected --",
  L"Failed to execute external editor.",
  L"Failed to read configuration file.",

  L"Building the dll...",
  L"Loading configuration...",
  L"Creating dll file...",
  L"Size of output file is %u bytes.",
  L"\r\nBUILD SUCCEEDED!",

  L"Source executable file corrupted.",
  L"Failed to find \"DllConfig\".",
  L"Failed to find \"DropperConfig\".",
  L"Error found in \"DllConfig/notify_server\".",
  L"Error found in \"DllConfig/url_server\".",
  L"Failed to find \"DllConfig/encryption_key\".",
  L"Error found in \"DllConfig/WebFilters\".",
  L"Error found in \"DllConfig/CaptchaList\".",
  L"Error found in \"DropperConfig/url1\".",
  L"Error found in \"DropperConfig/url2\".",
  L"Error found in \"DropperConfig/url3\".",
  L"Error found in \"DropperConfig/delay\".",
  L"Error found in \"DropperConfig/retry\".",
  L"Error found in \"DropperConfig/buildid\".",
  L"Dropper successfuly builded.",
  L"Error when building dropper.",
  
  L"Error found in \"DllConfig/file_webinjects\".",
  L"Building the HTTP injects...",
  L"Failed to open HTTP injects file.",
  L"Bad HTTP-inject found.",

  L"Language:",
  L"Apply",
  L"For language to change you should restart application.",
  L"Failed to save all settings.",
};

//Русский язык.
static const LPWSTR languageRu[] =
{
  L"Недостаточно памяти.",
  L"Не удалось сохранить файл.",
  L"\r\nОШИБКА: %s",

  BOT_NAME L" Builder",

  L"Сборка",
  L"Опции",

  L"Версия: %u.%u.%u.%u\r\nВремя сборки: %s",

  L"Исходный файл конфигурации бота:",
  L"Обзор...",
  L"Правка...",
  
  L"Действия",
  L"Собрать длл",
  L"Собрать дроппер",
  L"-- файл не выбран --",
  L"Не удалось запустить внешний редактор.",
  L"Не удалось прочитать файл конфигурации.",

  L"Сборка длл...",
  L"Загрузка конфигурации...",
  L"Создание DLL-файла...",
  L"Размер файла %u байт.",
  L"\r\nСБОРКА УСПЕШНО ЗАВЕРШЕНА!",

  L"Исходный PE-файл поврежден.",
  L"Не удалось найти \"DllConfig\".",
  L"Не удалось найти \"DropperConfig\".",
  L"Обнаружена ошибка в \"DllConfig/notify_server\".",
  L"Обнаружена ошибка в \"DllConfig/url_server\".",
  L"Не удалось найти \"DllConfig/encryption_key\".",
  L"Обнаружена ошибка в \"DllConfig/WebFilters\".",
  L"Обнаружена ошибка в \"DllConfig/CaptchaList\".",
  L"Обнаружена ошибка в \"DropperConfig/url1\".",
  L"Обнаружена ошибка в \"DropperConfig/url2\".",
  L"Обнаружена ошибка в \"DropperConfig/url3\".",
  L"Обнаружена ошибка в \"DropperConfig/delay\".",
  L"Обнаружена ошибка в \"DropperConfig/retry\".",
  L"Обнаружена ошибка в \"DropperConfig/buildid\".",
  L"Дроппер успешно создан.",
  L"Обнаружена ошибка при создании дроппера.",
  
  L"Обнаружена ошибка в \"DllConfig/file_webinjects\".",
  L"Сборка HTTP-инжектов...",
  L"Не удалось открыть файл с HTTP-инжектами.",
  L"Обнаружен HTTP-инжект с ошибкой.",

  L"Язык интерфейса:",
  L"Применить",
  L"Для применения языка необходимо перезапустить приложение.",
  L"Не удалось сохранить все настройки.",
};

//Список доступных языков.
static const Languages::LANGINFO languages[] =
{
  {L"English",           languageEn, sizeof(languageEn) / sizeof(LPWSTR), 1033},
  {L"Русский (Russian)", languageRu, sizeof(languageRu) / sizeof(LPWSTR), 1049}
};

//Данные текущего языка.
static const Languages::LANGINFO *languageCur;

void Languages::init(void)
{
  //Язык по умолчанию.
  languageCur = &languages[0];
  
  //Получаем язык из системы.
  WORD langId = CWA(kernel32, GetUserDefaultUILanguage)();
  for(BYTE i = 0; i < sizeof(languages) / sizeof(Languages::LANGINFO); i++)
	  if(langId == languages[i].id)
	  {
		  languageCur = &languages[i]; 
		  break;
	  }
  
  //Получем язык из конфига.
  langId = CWA(kernel32, GetPrivateProfileIntW)(L"settings", L"language", langId, settingsFile);
  for(BYTE i = 0; i < sizeof(languages) / sizeof(Languages::LANGINFO); i++)
	  if(langId == languages[i].id)
	  {
		  languageCur = &languages[i]; 
		  break;
	  }
}

void Languages::uninit(void)
{

}

LPWSTR Languages::get(DWORD id)
{
  return (id < languageCur->stringsCount) ? languageCur->strings[id] : NULL;
}

bool Languages::setDefaultLangId(WORD langId)
{
  WCHAR str[10];
  Str::_FromInt32W(langId, str, 10, false);
  return CWA(kernel32, WritePrivateProfileStringW)(L"settings", L"language", str, settingsFile) == FALSE ? false : true;
}

const Languages::LANGINFO *Languages::getLangInfo(WORD index)
{
  if(index < sizeof(languages) / sizeof(Languages::LANGINFO))
	  return &languages[index];
  return NULL;
}

const Languages::LANGINFO *Languages::getCurLangInfo(void)
{
  return languageCur;
}
