<?php

	if(!defined('AthenaHTTP')) header('Location: ..');
	
	$STATUS_MESSAGE = 'Website added to queue.';
	$STATUS_NOTE = false;
	
	if($_POST['checker_clear'])
	{
		mysql_query('TRUNCATE webcheck');
	}
	
	if($_POST['checker_website'])
	{
		$WEBSITE = trim($_POST['checker_website']);
		
		mysql_query('INSERT INTO tasks SET ' . 
							'username=\'' . $_SESSION['username'] . '\', ' .
							'task=\'!http.status\', ' . 
							'parameter=\'' . mysql_real_escape_string($WEBSITE) . '\', ' . 
							'country=\'*\', ' . 
							'os=\'*\', ' . 
							'cpu=\'*\', ' . 
							'type=\'*\', ' . 
							'version=\'*\', ' . 
							'net=\'*\', ' . 
							'admin=\'*\', ' . 
							'busy=\'0\', ' . 
							'botid=\'*\', ' . 
							'`limit`=\'5\';') or die(mysql_error());
		
		$STATUS_NOTE = true;
	}
	
	$result = mysql_query('SELECT webcheck.botid, botlist.country, botlist.country_code, webcheck.website, webcheck.status FROM webcheck, botlist WHERE webcheck.botid = botlist.botid;');
	
	while($row = mysql_fetch_array($result))
	{
		$host = $row['website'];
		$host = str_replace('http://', '', $host);
		if(strpos($host, '/') !== false) $host = str_replace(substr($host, strpos($host, '/')), '', $host);
		
	
		$PAGE_INCLUDE_CHECKLIST .= '					<tr>' . "\n";
		$PAGE_INCLUDE_CHECKLIST .= '						<td>' . htmlentities($row['botid']) . '</td>' . "\n";
		$PAGE_INCLUDE_CHECKLIST .= '						<td><img src="./img/flags/' . strtolower(htmlentities($row['country_code'])) . '.gif"></img> ' . htmlentities($row['country']) . '</td>' . "\n";
		$PAGE_INCLUDE_CHECKLIST .= '						<td>' . htmlentities($row['website']) . '</td>' . "\n";
		$PAGE_INCLUDE_CHECKLIST .= '						<td>' . htmlentities(gethostbyname($host)) . '</td>' . "\n";
		$PAGE_INCLUDE_CHECKLIST .= '						<td>' . htmlentities($row['status']) . '</td>' . "\n";
		$PAGE_INCLUDE_CHECKLIST .= '					</tr>' . "\n";
	}
	
?>