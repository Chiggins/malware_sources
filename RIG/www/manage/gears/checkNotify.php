<?php
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


include_once('../../config.php');			// берем конфиг
include_once('../../gears/functions.php');	// подключаем функции
include_once('../../gears/di.php');			// подключаем класс библиотеки класов
include_once('../../gears/db.php');			// подключаем класс базы


// создаем подключение к базе
cdim('db','connect',$config);


// забираем из базы опции и кладем их в конфиг
$options = cdim('db','query',"SELECT * FROM options");

// кладем в конфиг все что забрали из базы (все опции)
if (isset($options)) foreach($options as $k=>$v) {
	$config['options'][$v->option_name]=$v->option_value;
}

// авторизация
include_once('../auth/auth.php');


	// убираем все нотифаи старше 5 минут
	cdim('db','query',"DELETE FROM `notifyQueue` WHERE `timeBirth` < UNIX_TIMESTAMP(NOW())-300;");

	$res = cdim('db','query',"SELECT * FROM `botnets` WHERE `user_id` = '".$config['user']['id']."' ORDER BY `botnetname` ASC;");
	// проверяем наш ли ботнет
	if (isset($res[0])) foreach ($res as $k=>$v) {
		$tasks = cdim('db','query',"SELECT * FROM `notifyQueue` WHERE `botnetname` = '".$v->botnetname."';");
		if (isset($tasks[0])) {
			cdim('db','query',"DELETE FROM `notifyQueue` WHERE `id` = ".$tasks[0]->id.";");
			exit(json_encode(array('type'=>'info','msg'=>'Bot: '.$tasks[0]->botid.'<br>From: '.$tasks[0]->botnetname.'<br>'.$tasks[0]->msg))); 
		}
	}

exit(json_encode(array('type'=>'none','msg'=>'')));
?>
