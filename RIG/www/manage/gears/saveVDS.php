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

//cdim('db','query',"TRUNCATE TABLE vds");

foreach($_POST as $k=>$v) {

	// убиваем
	if ($v['ip']==='') {
		cdim('db','query',"DELETE FROM `vds` WHERE `id` = '".$v['id']."';");
		continue;
	}

	$vds = cdim('db','query',"SELECT * FROM `vds` WHERE `id` = ".$v['id'].";");


	// новая прокся
	if (!isset($vds)) {
		cdim('db','query',"INSERT INTO `vds` VALUES ('', '".$v['ip']."', '".$v['description']."');");
		// надо знать id последней записи
		$pdoLink = $di->objects['db']->getVar('link');
		$bdId = $pdoLink->lastInsertId();
	} else {
		cdim('db','query',"UPDATE `vds` SET `ip` = '".$v['ip']."', `description` = '".$v['description']."' WHERE `id` = ".$v['id'].";");
		$lastUpdateId = $v['id'];
	}

}

if (!isset($bdId)) $bdId = $lastUpdateId;


exit(json_encode(array('type'=>'success','msg'=>'Серверы VDS обновлены','vds_id'=>$bdId)));

?>
