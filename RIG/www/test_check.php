<?php
define('AV_SERVICE_APIKEY', 'e692bc1b12ef51d53e39bd5f614eac08ed081ae9');
define('DELPASS', 'kjsdjhf8913uiifnsd98fi23874*djnkjf33fnjndvf');

@set_time_limit(9999999999);

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

function get_web_page($url, $post = false) {
	$options = array (
		CURLOPT_RETURNTRANSFER => true, // return web page
		CURLOPT_CONNECTTIMEOUT => 120, // timeout on connect
		CURLOPT_TIMEOUT => 120, // timeout on response
		CURLOPT_FOLLOWLOCATION => true, // follow redirects
		CURLOPT_MAXREDIRS => 10 // stop after 10 redirects
	); 

	$ch = curl_init ( $url );
	curl_setopt_array ( $ch, $options );
	if ($post !== false)
	  {
	  $pd = '';
	  foreach($post AS $k=>$v)
	    {
	    if (strlen($pd) > 0)
	      $pd .= '&';
	    $pd .= $k.'='.$v;
	    }
	  curl_setopt($ch, CURLOPT_POST, true);
	  curl_setopt($ch, CURLOPT_POSTFIELDS, $pd);
	  }

	$content = curl_exec ( $ch );
	$httpCode = curl_getinfo ( $ch, CURLINFO_HTTP_CODE );
	curl_close ( $ch );
	if ($httpCode != 200)
	  return false;
	return $content;
}

$ee = get_web_page('https://avdetect.com/api/', array('api_key'=>AV_SERVICE_APIKEY, 'check_type'=>'domain', 'data'=>'http://jikoiuuada.co.vu/'));
$ee = json_decode($ee, true);
var_dump($ee);


?>