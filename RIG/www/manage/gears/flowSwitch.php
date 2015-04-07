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


$user_id = (isset($_POST['user_id'])) ? intval($_POST['user_id']) : false;
$flow_id = (isset($_POST['flow_id'])) ? intval($_POST['flow_id']) : false;
//$user_id = $_GET['user_id'];
//$flow_id = $_GET['flow_id'];
if ($user_id === false || $flow_id === false)
  die();
if (!preg_match("/[0-9]+/",$flow_id)) exit(json_encode(array('type'=>'error','msg'=>'Flow id not valid!')));

if ($config['user']['id']!=$user_id) exit(json_encode(array('type'=>'error','msg'=>'It\'s not your stat.')));
if (!preg_match("/[0-9]+/",$user_id)) exit(json_encode(array('type'=>'error','msg'=>'User id not valid!')));

function FindData($arr, $where_data)
  {
  //query = FindData($arr, array('name'=>'val', 'name2'=>'val2'));
  if ($arr === FALSE)
    return false;
  $e = FALSE;
  if (count($arr) == 0)
    return false;
  foreach($arr AS $k=>$v)
    {
    $q = 0;
    $w_count = count($where_data);
    if ($w_count == 0)
      return false;
    foreach($where_data AS $ka=>$va)
      {
      if (isset($arr[$k][$ka]) && $arr[$k][$ka] == $va)
	$q++;
      }
    if ($q == $w_count)
      {
      $e = $k;
      break;
      }
    }
  if ($e !== FALSE)
    {
    $p = $e;
    $e = $arr[$e];
    $e['num'] = $p;
    unset($arr);
    return $e;
    }
  return false;
  }

  $ps_runfile = '../addl/ps_runfile';
  $ps_file_arr = array();
    if (file_exists($ps_runfile))
      {
      $ps_filedata = @file_get_contents($ps_runfile);
      if ($ps_filedata !== FALSE)
	{
	$ps_file_arr = unserialize($ps_filedata);
	$fd = FindData($ps_file_arr, array('user_id'=>$user_id, 'flow_id'=>$flow_id));
	if ($fd === false)
	  {
	  $public_key = md5($user_id.$flow_id.time()+rand(1000,9999));
	  $ps_file_arr[] = array('user_id'=>$user_id, 'flow_id'=>$flow_id, 'public_key'=>$public_key);
	  }
	  else
	  {
	  $num = $fd['num'];
	  unset($ps_file_arr[$num]);
	  }
	@file_put_contents($ps_runfile, serialize($ps_file_arr));
	}
      }
  
	
	exit(json_encode(array('type'=>'success','msg'=>'Public stats was switched')));
?>
