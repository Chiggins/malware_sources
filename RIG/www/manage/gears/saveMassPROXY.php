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

//set_error_handler('errorHandler');
//register_shutdown_function('fatalErrorShutdownHandler');


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

if ($config['user']['rights']['rolename']!='admin') exit('Hacking attempt');

//cdim('db','query',"TRUNCATE TABLE proxy");

if (!is_array($_POST['data'])) {
	exit(json_encode(array('type'=>'error','msg'=>'Что-то пошло не так!')));
}


foreach($_POST['data'] as $k=>$v) {

	$proxy = cdim('db','query',"SELECT * FROM `proxy` WHERE `url` = '".$v."';");
	// новая прокся
	if (!isset($proxy)) {
		cdim('db','query',"INSERT INTO `proxy` VALUES ('', '".$v."', '', 0);");
	} else {
		cdim('db','query',"UPDATE `proxy` SET `last_check` = 0 WHERE `url` = '".$v."';");
	}
	
}

exit(json_encode(array('type'=>'success','msg'=>'Серверы проксирования обновлены')));

?>
