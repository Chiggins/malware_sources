#pragma once

namespace Languages
{
  typedef struct
  {
    const LPWSTR name;     //Имя
    const LPWSTR *strings; //Список строк.
    WORD stringsCount;     //Кол. строк.
    WORD id;               //ID языка.
  }LANGINFO;

  //ID строк.
  enum
  {
    error_not_enough_memory,
    error_fwrite_failed,
    error_output_template,

    main_title,

    tool_title_builder,
    tool_title_settings,

    tool_info_version,
	
    tool_builder_source_title,
    tool_builder_source_browse,
    tool_builder_source_edit,

    tool_builder_build_title,
    tool_builder_build_bot,
	tool_builder_build_dropper,
    tool_builder_source_not_defined,
    tool_builder_source_edit_failed,
    tool_builder_source_fopen_failed,

    builder_bot_proc_begin,
    builder_bot_proc_config,
    builder_bot_proc_creating,
    builder_bot_proc_output_info,
    builder_bot_proc_end,

    builder_bot_corrupted,
    builder_dllconfig_not_founded,
	builder_dropperconfig_not_founded,
	builder_dllconfig_notifyserver_error,
	builder_dllconfig_urlserver_error,
	builder_dllconfig_encryptionkey_error,
    builder_dllconfig_webfilters_error,
    builder_dllconfig_captchas_error,
	builder_dropperconfig_url1_error,
	builder_dropperconfig_url2_error,
	builder_dropperconfig_url3_error,
	builder_dropperconfig_delay_error,
	builder_dropperconfig_retry_error,
	builder_dropperconfig_buildid_error,
	builder_dropper_success,
	builder_dropper_error,

    builder_dll_file_webinjects_error,
    builder_httpinjects_begin,
    builder_httpinjects_fopen_failed,
    builder_httpinjects_bad_format,

    tool_settings_language_title,
    tool_settings_apply,
    tool_settings_language_saved,
    tool_settings_apply_failed,
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
    Получение строки для id.

    IN id  - ID.

    Return - строка, или NULL.
  */
  LPWSTR get(DWORD id);

  /*
    Сохраняет код языка в качастве языка по умолчанию.

    IN langId - код языка.

    Return    - true - если успешно сохранено,
                false - в случаи ошибки.
  */
  bool setDefaultLangId(WORD langId);

  /*
    Получение информации о языке.

    IN index - индекс языка.

    Return   - информация о языке, или NULL если index привысил кол. языков.
  */
  const LANGINFO *getLangInfo(WORD index);

  /*
    Получение информации о текущем языке.

    Return - язык.
  */
  const Languages::LANGINFO *getCurLangInfo(void);
};
