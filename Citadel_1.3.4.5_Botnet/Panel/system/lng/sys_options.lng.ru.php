<?php if(!defined('__CP__'))die();
define('LNG_SYS', 'Параметры');

define('LNG_SYS_REPORTS',      'Отчеты');
define('LNG_SYS_REPORTS_PATH', 'Локальный путь:');
define('LNG_SYS_REPORTS_TODB', 'Запись отчетов в базу данных.');
define('LNG_SYS_REPORTS_TOFS', 'Запись отчетов в локальный путь.');
define('LNG_SYS_REPORTS_GEOIP', 'Постоянный GeoIP (высокая нагрузка, но необходим для запуска скриптов по странам)');

define('LNG_SYS_BOTNET',          'Ботнет');
define('LNG_SYS_BOTNET_TIMEOUT',  'Таймаут онлайн-статуса (минуты):');
define('LNG_SYS_BOTNET_CRYPTKEY', 'Ключ шифрования:');

define('LNG_SYS_ALLOWED_COUNTRIES',  'Разрешённые страны');
define('LNG_SYS_ALLOWED_COUNTRIES_ENABLED',  'Контроль включён');

define('LNG_SYS_FEATURES', 'Функции');
define('LNG_SYS_FEATURES_REPORTS_DEDUPLICATION', 'Дедупликация отчётов');

define('LNG_SYS_JABBER_BOT', 'Jabber бот');
define('LNG_SYS_JABBER_BOT_USER', 'Логин');
define('LNG_SYS_JABBER_BOT_PASS', 'Пароль');
define('LNG_SYS_JABBER_BOT_HOST', 'Сервер[:порт]');

define('LNG_SYS_E1', 'Не верно указан локальный путь для отчетов.');
define('LNG_SYS_E2', 'Не верно указано время таймаута для ботнета.');
define('LNG_SYS_E3', 'Не верно указан ключ шифрования для ботнета.');
define('LNG_SYS_E4', 'Не удалось обновить файл конфигурации, возможно не достаточно прав.');

define('LNG_SYS_SAVE', 'Сохранить');

define('LNG_SYS_UPDATED', 'Настройки успешно обновлены.');
?>