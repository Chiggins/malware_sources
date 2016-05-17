<?php

	include"core.php";
	include"config.php";
	mysql_query("CREATE TABLE `n` (`ip` VARCHAR( 15 ) NOT NULL ,`n` INT( 10 ) NOT NULL ) ENGINE = MYISAM ;") or include"404.php";

	mysql_query("CREATE TABLE `td` (`ip` VARCHAR( 15 ) NOT NULL ,`ip2` VARCHAR( 15 ) NOT NULL ,`time` INT( 10 ) NOT NULL) ENGINE = MYISAM ;") or include"404.php";
	mysql_query("ALTER TABLE `td` ADD UNIQUE (`ip`);") or include"404.php";
	echo'<meta http-equiv=REFRESH CONTENT="0;URL=admin.php?login='.$GET_login.'">';

?>