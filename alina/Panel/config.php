<?php
$host = "localhost:3306";
$user = "root";
$pass = "cocalarus1234567";
$db = "duck";

$frontend = array("cards", "logs", "settings", "stats", "bins");
$backend = array("c", "d", "l");

if (mysql_connect($host, $user, $pass) === false ||
	mysql_select_db($db) === false)
	die("Cant connect to mysql");

$sql = "SELECT * FROM settings";
$res = mysql_query($sql);
while ($row = mysql_fetch_assoc($res))
	$GLOBALS[$row["skey"]] = $row["sval"];
if (!isset($GLOBALS["admin"]) || empty($GLOBALS["admin"]))
	die("No admin password record found.");
?>
