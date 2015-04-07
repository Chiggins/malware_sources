<?php

@set_time_limit(120);

function errorHandler($code, $message, $file, $line) {
	debug(array('Error'=>$code,'Message'=>$message,'In file'=>$file,'On line'=>$line));
	exit();
}

function fatalErrorShutdownHandler() {
	$last_error = error_get_last();
	if ($last_error['type'] === E_ERROR) {
	// fatal error
		errorHandler(E_ERROR, $last_error['message'], $last_error['file'], $last_error['line']);
	}
}

set_error_handler('errorHandler');
register_shutdown_function('fatalErrorShutdownHandler');


include_once('config.php');			// берем конфиг
include_once('./gears/functions.php');	// подключаем функции
include_once('./gears/di.php');			// подключаем класс библиотеки класов
include_once('./gears/db.php');			// подключаем класс базы


// создаем подключение к базе
cdim('db','connect',$config);


// забираем из базы опции и кладем их в конфиг
$options = cdim('db','query',"SELECT * FROM options");

// кладем в конфиг все что забрали из базы (все опции)
if (isset($options)) foreach($options as $k=>$v) {
	$config['options'][$v->option_name]=$v->option_value;
}

function get_web_page($url) {
	$options = array (
		CURLOPT_RETURNTRANSFER => true, // return web page
		CURLOPT_HEADER => true, // return headers
		CURLOPT_ENCODING => "", // handle compressed
		CURLOPT_USERAGENT => "ping", // who am i
		CURLOPT_AUTOREFERER => true, // set referer on redirect
		CURLOPT_CONNECTTIMEOUT => 120, // timeout on connect
		CURLOPT_TIMEOUT => 120, // timeout on response
		CURLOPT_FOLLOWLOCATION => true, // follow redirects
		CURLOPT_MAXREDIRS => 10, // stop after 10 redirects
		CURLOPT_VERBOSE => false
	); 

	$ch = curl_init ( $url );
	curl_setopt_array ( $ch, $options );
	$content = curl_exec ( $ch );
	$err = curl_errno ( $ch );
	$errmsg = curl_error ( $ch );
	$header = curl_getinfo ( $ch );
	$httpCode = curl_getinfo ( $ch, CURLINFO_HTTP_CODE );

	curl_close ( $ch );
	$header ['httpCode'] = $httpCode;
	$header ['header'] = $header;
	$header ['errno'] = $err;
	$header ['errmsg'] = $errmsg;
	//$header ['content'] = $content;
	$check_pong = (strpos($content, 'pong') !== false) ? true : false;

//file_put_contents('bbb.bbb', $content."\r\n\r\n", FILE_APPEND);

	if (!$check_pong)
	  return 700;
	return $header['httpCode'];
}

function delProxy($id) {
	global $config;
	cdim('db','query','DELETE FROM `proxy` WHERE `id` = '.$id);
//file_put_contents('bbb.bbb', 'checkurl.php->'.$id."\r\n\r\n", FILE_APPEND);
}

/*
тут чекали все
$proxy = cdim('db','query','SELECT * FROM `proxy`');
if (isset($proxy)) foreach($proxy as $k=>$v) {
	$pong = get_web_page($v->url);
	if ($pong != 200) {
		delProxy($v->id);
	}
}
*/

// чекаем первый в списке
$proxy = cdim('db','query','SELECT * FROM `proxy` LIMIT 1');
if (isset($proxy)) foreach($proxy as $k=>$v) {
	$pong = get_web_page($v->url);
	if ($pong = 200) {
		delProxy($v->id);
	}
}

?>