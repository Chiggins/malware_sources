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


if ($config['user']['rights']['rolename']!='admin') exit('Hacking attempt');

if (!preg_match("/[a-z0-9_-]+/is",$_POST['newUserName'])) exit(json_encode(array('type'=>'error','msg'=>'Имя пользователя не соответствует "a-z0-9_-"!')));
if (!preg_match("/[0-9]+/is",$_POST['newUserRole'])) exit(json_encode(array('type'=>'error','msg'=>'Права пользователя заданы неверно!')));
if (!preg_match("/[a-z0-9!@#$%&_-]+/is",$_POST['newUserPass'])) exit(json_encode(array('type'=>'error','msg'=>'Пароль пользователя не соответствует "a-z0-9!@#$%&_-"!')));


$user_login = $_POST['newUserName'];
$user_role = $_POST['newUserRole'];
$user_password = $_POST['newUserPass'];

if ($config['user']['rights']['rolename']!='admin') {
	exit(json_encode(array('type'=>'error','msg'=>'Только админ может создавать пользователей!')));
}

// смотрим, есть ли такие имя
$isExist = cdim('db','query',"SELECT * FROM `users` WHERE `user_login` = '".$user_login."';");
if (isset($isExist)) exit(json_encode(array('type'=>'error','msg'=>'Такое имя пользователя уже занято!')));

$rights = cdim('db','query',"SELECT * FROM `userrights` WHERE `id` = '".$user_role."';");
if (!isset($rights))  exit(json_encode(array('type'=>'error','msg'=>'Таких ролей в системе нет!')));

$rights =  unserialize($rights[0]->rights);

$color = $rights['rolename'] == 'admin' ? 'FF0000' : '0000FF';

cdim('db','query',"INSERT INTO `users` VALUES (NULL, '".$user_login."', '".md5($user_password)."','".$rights['rolename']."','".$color."','".time()."','0','','');");
$pdoLink = $di->objects['db']->getVar('link');
$userID = $pdoLink->lastInsertId();

cdim('db','query',"INSERT INTO `flows` VALUES ('', ".$userID.", NULL, 0);");
cdim('db','query',"INSERT INTO `flows` VALUES ('', ".$userID.", NULL, 0);");


exit(json_encode(array('type'=>'ok','msg'=>'')));
?>
