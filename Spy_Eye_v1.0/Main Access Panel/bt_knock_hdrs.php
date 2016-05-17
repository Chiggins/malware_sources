<?php

$page = $_GET['page'];
if (!isset($page))
	exit;

switch ( $page ) {
	case "http://ya.ru":
		echo "http://%smth%/check_ip.php<br>Referrer: http://www.besecuresallpcs.com/\r\nAccept: *//*\r\nConnection: Keep-Alive\r\nCache-Control: no-cache\r\n";
	break;
}

?>