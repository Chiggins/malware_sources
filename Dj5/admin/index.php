<?
	include"core.php";
	include"config.php";
	if ($_POST['k']=='') {
		include"404.php";
	}
	$ip=$_POST['k'];
	$ip2=$_SERVER['REMOTE_ADDR'];
	$time=time();
	mysql_query(" INSERT INTO `n` (`ip`,`n`)VALUES('$ip2','$time') ") or die("Error"); 
	mysql_query(" INSERT INTO `td` (`ip`,`ip2`,`time`)VALUES('$ip','$ip2','$time')");
	include "img.gif";
?>