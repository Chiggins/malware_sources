<?php /*
AthenaHTTP - Do not distribute.
*/

	if(!defined('AthenaHTTP')) header('Location: .');
	
	$DB_HOST = 'localhost';
	$DB_USER = 'user';
	$DB_PASS = 'pass';
	$DB_NAME = 'name';
	
	$TIME = strtotime(gmdate('M d Y H:i:s'));
		
	mysql_connect($DB_HOST, $DB_USER, $DB_PASS) or die(mysql_error());
	mysql_select_db($DB_NAME) or die(mysql_error());

?>