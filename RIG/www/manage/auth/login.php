<?php

if (!defined('REQ')) define('REQ','ok');

header('Content-Type:text/html;charset=UTF-8', true);
define('TIMER', microtime(true));

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


// берем реальный путь
function getRealPath() {
	$iPos = strrpos(__FILE__, "/");
	$out = substr(__FILE__, 0, $iPos);
	return $out;
}

include_once('../../config.php');			// берем конфиг
include_once('../../gears/functions.php');	// подключаем функции
include_once('../../gears/di.php');			// подключаем класс библиотеки класов
include_once('../../gears/db.php');			// подключаем класс базы


// создаем подключение к базе
cdim('db','connect',$config);


// забираем из базы опции и кладем их в конфиг
$options = cdim('db','query',"SELECT * FROM options");

// кладем в конфиг все что забрали из базы (все опции)
foreach($options as $k=>$v) {
	$config['options'][$v->option_name]=$v->option_value;
}


if (isset($_POST['login']) && isset($_POST['password'])) {
	$login=$_POST['login'];
	$password=$_POST['password'];
} else {
	exit(json_encode(Array('error'=>'1','text'=>'no login or password')));
}


if (!preg_match("/^[a-zA-Z\d-_.]{3,25}$/", $login)) 
  {
  exit(json_encode(Array('error'=>'1','text'=>'incorrect login')));
  }
  else
  { //preg

// смотрим есть ли в базе такая учетка
$value = cdim('db','query',"SELECT * FROM users WHERE (`user_login` = '".$login."') AND (`user_pass` = '".md5($password)."')");

// если нет
if (count($value)<=0) {
	// отдаем ошибку
	exit(json_encode(Array('error'=>'1','text'=>'incorrect login or password')));
} else {
	$hash = md5($login.md5($password).$_SERVER['REMOTE_ADDR']);
	// если есть то ставим куку до конца сессии на весь домен
	setcookie($config["cookiename"], $hash, NULL, '/');
	// обновляем данные куки в базе
	cdim('db','query',"UPDATE `users` SET  `sid` =  '".$hash."' WHERE `id` = ".$value[0]->id.";");
	// отдаем ответ
	exit(json_encode(Array('error'=>'0','text'=>'all ok')));
}
  } //preg
?>