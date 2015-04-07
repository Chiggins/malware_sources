<?php

header('Content-Type: text/html; charset=utf-8'); 

// output from admin
if ((isset($_POST['exit']) && $_POST['exit'] == 1) || (isset($_GET['exit']) && $_GET['exit'] == 1)) {

	setcookie($config["cookiename"], "", time()-3600, '/');
	header('Location: index.php');
	exit();
}

// If the cookie does not come in PHP that show login
if (!isset($_COOKIE[$config["cookiename"]])) {
	if (!file_exists('./auth/index.php')) {
		include('./auth/index.php');
	} else {
		include('./auth/index.php');
	}
	
	exit();
}

// if the cookie is that check whether there uchetku with hash
if (isset($_COOKIE[$config["cookiename"]])) {
	$cn = isset($config["cookiename"]) ? $config["cookiename"] : '';
	if (!is_string($_COOKIE[$cn]))
	  die('err...');
	$cookie_data = addslashes($_COOKIE[$cn]);
	$value=cdim('db','query',"SELECT * FROM `users` WHERE `sid` = '".$cookie_data."'");
	// if the hash is not that show login
	if (count($value)<=0) { 
		if (!file_exists('../auth/index.php')) {
			include('../auth/index.php');
		} else {
			include('../auth/index.php');
		}
		exit(); 
	} else {
		// If everything is OK then put user data in the config
		foreach($value[0] as $k=>$v) {
			$config['user'][$k]=$v;
		}
		$config['user']['rights'] = getUserRights($config['user']['id']);
		// update last_time
		$cookie_data = addslashes($_COOKIE[$config["cookiename"]]);
		cdim('db','query',"UPDATE `users` SET `last_time` = '".time()."' WHERE `sid` = '".$_COOKIE[$config["cookiename"]]."'");
	}
}

// cookie is ok, go on...

?>