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

if (!isset($_POST['user_id']))
  die('err2...');
$user_id = intval($_POST['user_id']);
$filename = $_POST['filename'];
$filename = str_replace(array('..', '/', '\\', ' '), '', $filename);
$fileway = '../files/'.$filename;
if (!file_exists($fileway))
  die('err...');
$filesize = filesize($fileway);

//print_r($_POST);


$binary = file_get_contents('../files/'.$filename);

$sql = "INSERT INTO `files` VALUES('', ".$user_id.", :file_source, :file_name, ".$filesize.", '');";

$pdoLink = $di->objects['db']->getVar('link');
$stmt = $pdoLink->prepare($sql);
$stmt->bindParam(":file_name", $filename, PDO::PARAM_STR);
$stmt->bindParam(":file_source", $binary, PDO::PARAM_LOB, sizeof($binary));
$stmt->execute();
$bdId = $pdoLink->lastInsertId();


unlink('../files/'.$filename);



/* отдали результаты */
exit(json_encode(array('type'=>'success','msg'=>'File Uploaded','fileid'=>$bdId)));
?>
