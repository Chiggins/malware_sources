<?php
	error_reporting(0);
	$dbhost="localhost";

	/* User database */
	$dbuname="klomp_dj";

	/* Database Name */
	$dbname="klomp_dj";

	/* Password Database */
	$dbpass="123123";

	/* GET Login */
	$GET_login="dj5";

	/* Login */
	$login="dj5";

	/* Password */
	$password="dj5";

	/* Interval */
	$interval="60";

	if ($sokol=="1") {
		$ip=$_SERVER['REMOTE_ADDR'];
		if (($ip!=$ip1)and($ip!=$ip2)and($ip!=$ip3)and($ip1.$ip2.$ip3!='')) {
			include"404.php";
		}
		mysql_connect($dbhost, $dbuname, $dbpass) or include"404.php";
		mysql_select_db($dbname);
	} else {
		include"404.php";
	}
?>