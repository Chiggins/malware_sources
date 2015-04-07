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

$file_id = is_numeric($_GET['file_id']) ? intval($_GET['file_id']) : false;
if ($file_id===false) exit(json_encode(array('type'=>'success','msg'=>'Файл отсутствует')));

$xf = cdim('db','query',"SELECT `filename` FROM `files` WHERE `id` = ".$_GET['file_id']." AND `user_id` = ".$config['user']['id']." LIMIT 1;");
if (isset($xf[0]))
  {
  $autoupdate_url = (isset($_POST['autoupdate_url'])) ? addslashes($_POST['autoupdate_url']) : '';
  $autoupdate_filename = isset($xf[0]->filename) ? addslashes($xf[0]->filename) : '';
  $autoupdate_user_id = isset($config['user']['id']) ? (int) $config['user']['id'] : 0;

  $autoupdate_runfile = '../autoupdate/autoupdate_runfile_'.$autoupdate_user_id;
  $a_file_arr = array();
    if (file_exists($autoupdate_runfile))
      {
      $a_filedata = @file_get_contents($autoupdate_runfile);
      if ($a_filedata !== FALSE)
	{
	$a_file_arr = unserialize($a_filedata);
	}
      }
    unset($a_file_arr[$autoupdate_filename]);

    @file_put_contents($autoupdate_runfile, serialize($a_file_arr));
  }

$file = cdim('db','query',"UPDATE `flows` SET `file_id` = NULL, `last_token` = 0 WHERE `file_id` = ".$_GET['file_id']." AND `user_id` = ".$config['user']['id'].";");
$file = cdim('db','query',"DELETE FROM `files` WHERE `id` = ".$_GET['file_id']." AND `user_id` = ".$config['user']['id'].";");

exit(json_encode(array('type'=>'success','msg'=>'File Deleted')));

?>