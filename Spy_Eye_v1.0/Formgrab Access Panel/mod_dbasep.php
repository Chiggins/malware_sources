<?php

require_once 'config.php';

function db_open() {

	//$dbase = mysqli_connect (DB_SERVER, DB_USER, DB_PASSWORD, DB_NAME);
	$dbconn = mysql_pconnect (DB_SERVER, DB_USER, DB_PASSWORD);
	
	if ($dbconn === FALSE) {
		require_once 'mod_file.php';
		writelog('error.log', "Connect failed : dbconn === FALSE ( " . mysql_error() . " )");
		return null;
	}
	
	$dbase = mysql_select_db(DB_NAME);
	if ($dbase === FALSE) {
		require_once 'mod_file.php';
		writelog('error.log', "Select DB failed : dbase === FALSE");
		return null;
	}
	
	return $dbconn;
}

function db_close($dbconn) {
	//mysqli_close($dbase);
	mysql_close($dbconn);
}

?>