<?php
    	//Connect to shitty DB
	$dbname = "";
	$user = "";
	$pw = "";
    	$link = mysql_connect('localhost',$user,$pw);
    	$db = mysql_select_db($dbname,$link);
    	/////////////////////////////////////////
?>