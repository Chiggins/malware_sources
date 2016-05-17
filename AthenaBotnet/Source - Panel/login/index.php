<?php

	error_reporting(E_ERROR | E_WARNING | E_PARSE);
	
	define('AthenaHTTP', '');
	require_once '../config.php';
	
	$keycheck = mysql_fetch_array(mysql_query('SELECT data FROM config WHERE value = \'loginpagekey\';'));
	
	if($keycheck['data'] == 1)
	{
		if(!IsCorrectKey($_GET['key'])) die();
	}
	
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
	
	if(!$LOGIN)
	{
			require_once '../include/tpl_login.php';
			print $PAGE;
	}
	else
	{
		header('Location: ..');
	}
	
	function IsCorrectKey($key)
	{
		$RETURN = FALSE;
		
		$correctkey = mysql_fetch_array(mysql_query('SELECT `key` FROM config WHERE value = \'loginpagekey\';'));
		if($key == $correctkey['key'])	$RETURN = TRUE;
		
		return $RETURN;
	}
?>