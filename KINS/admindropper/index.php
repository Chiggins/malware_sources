<?php

ob_start();

$start_time = microtime(true);

require_once('common.php');

if (!is_readable('config.php')) httpRedirect('install.php');

require_once('config.php');
error_reporting(0);

httpAuth(); 
httpNoCache();

Db_Mysql::init(MYSQL_HOST, MYSQL_LOGIN, MYSQL_PASSWORD, MYSQL_DB);
$db = Db_Mysql::getInstance();
$db->query('SET NAMES "utf8" COLLATE "utf8_unicode_ci";');
$db->debug = 0;

if (isset($_GET['b']))
{
	header('Content-Type: text/xml');
	echo '<?xml version="1.0" encoding="utf-8"?>' . "\r\n";
	$page = $_GET['b'];
    if (preg_match('/^[a-zA-Z]{1,20}$/', $page)) if (file_exists("act/$page.php")) include("act/$page.php"); else echo "Illegal page"; else echo "Illegal page";
	@ob_end_flush();
	exit();
}

header('Content-Type: text/html; charset=UTF-8');

require_once("templates/header.tpl");

if (!$_GET['act']) $_GET['act'] = 'stats';
$page = $_GET['act'];
if (preg_match('/^[a-zA-Z]{1,20}$/', $page)) if (file_exists("act/$page.php")) include("act/$page.php"); else echo "Illegal page"; else echo "Illegal page";

require_once('templates/footer.tpl');

@ob_end_flush();

$db->close();

?>
