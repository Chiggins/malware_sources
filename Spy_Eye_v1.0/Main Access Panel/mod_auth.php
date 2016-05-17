<?php
require_once 'config.php';

function isauth ($pass) {
	if (!$pass)
		$pass = $_COOKIE['password'];
	if (@$pass) {
		$pass == ADMIN_PASSWORD ? $isadm = true : $isadm = false;
	} else
		$isadm = false;
		
	return $isadm;
}

function auth () {
	if (!isauth(null)) {
		readfile('frm_auth.php');
		return false;
	}
	return true;
}
?>