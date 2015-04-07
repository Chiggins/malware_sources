<?php
define('AV_SERVICE_APIKEY', 'c77548c5e8bd449ad912171b8ed336afe5fabf85');
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

include('./manage/gears/checkAvURLCLASS.php');

$checkURL = new checkURL();

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

	return $header['httpCode'];
}

function delProxy($id, $url = '') {

	global $config;
	cdim('db','query','DELETE FROM `proxy` WHERE `id` = '.$id);

	$ex = (strpos($url, '?') === false) ? '?' : '&';
	$url = $url.$ex.'del=true&delpass='.DELPASS;
	$qq = get_web_page($url);
//file_put_contents('bbb.bbb', 'checkurl4u.php->DEL PROXY'."\r\n\r\n", FILE_APPEND);

}

function get_web_page2($url, $post = false) {
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

/*
тут чекали все
$proxy = cdim('db','query','SELECT * FROM `proxy`');
if (isset($proxy)) 
  foreach($proxy as $k=>$v)
    {
    $pong = get_web_page($v->url);
    if ($pong == 200)
      {
      $res = $checkURL->is_ok($v->url);
      if ($res['inBan']>$config['options']['exploit_count_fail'])
	{ 
	delProxy($v->id, $v->url); 
	}
	else
	{
	cdim('db','query','UPDATE `proxy` SET `last_check` = '.time().' WHERE `id` = '.$v->id);
	}
      }
      else
      {
      delProxy($v->id, $v->url);
      }
    }
*/


// чекаем первый в списке
$proxy = cdim('db','query','SELECT * FROM `proxy` ORDER BY `id` LIMIT 1');

if (isset($proxy))
  foreach($proxy as $k=>$v)
  {
    //OLD//$res = $checkURL->is_ok($v->url);
    //OLD//if ($res['inBan']>$config['options']['exploit_count_fail'])
    $wp = get_web_page2('https://avdetect.com/api/', array('api_key'=>AV_SERVICE_APIKEY, 'check_type'=>'domain', 'data'=>$v->url));
    $wp = json_decode($wp, true);
    if ($wp === false)
      die();
    $detects = 0;
    if (isset($wp[0]['detectavs']))
      $detects = (int) $wp[0]['detectavs'];

//file_put_contents('bbb.bbb', 'url='.$v->url.'; detects='.$detects.'; serialize === '.serialize($wp)."\r\n\r\n", FILE_APPEND);
    if ($detects > $config['options']['exploit_count_fail'])
      {
      delProxy($v->id, $v->url); 
	//$xurl = $v->url;
	//$ex = (strpos($xurl, '?') === false) ? '?' : '&';
	//$xurl = $xurl.$ex.'del=true&delpass='.DELPASS;
	//$qq = get_web_page($xurl);
      }
      else
      {
      cdim('db','query','UPDATE `proxy` SET `last_check` = '.time().' WHERE `id` = '.$v->id);
      }
  }

?>