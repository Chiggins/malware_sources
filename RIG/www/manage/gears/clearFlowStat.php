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


$user_id = intval($_POST['user_id']);
$flow_id = intval($_POST['flow_id']);
if (!preg_match("/[0-9]+/",$flow_id)) exit(json_encode(array('type'=>'error','msg'=>'Flow id not valid!')));

if ($config['user']['id']!=$_POST['user_id']) exit(json_encode(array('type'=>'error','msg'=>'It\'s not your stat.')));
if (!preg_match("/[0-9]+/",$user_id)) exit(json_encode(array('type'=>'error','msg'=>'User id not valid!')));

	// удаляем все задачи из тасков для этого user_id кроме sys_release
	cdim('db','query',"DELETE FROM `traff` WHERE `user_id` = ".$user_id." AND `flow_id` = ".$flow_id);
	
	exit(json_encode(array('type'=>'success','msg'=>'Flow stat cleared')));
?>
