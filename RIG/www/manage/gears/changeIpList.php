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

function CheckIPValid($ip)
  {
  if (preg_match('/^([0-9]|[0-9][0-9]|[01][0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[0-9][0-9]|[01][0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$/', $ip))
    return true;
    else
    return false;
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
$ip_list = isset($_POST['ip_list']) ? $_POST['ip_list'] : false;
if (!preg_match("/[0-9]+/",$flow_id)) exit(json_encode(array('type'=>'error','msg'=>'Flow id not valid!')));

if ($config['user']['id']!=$_POST['user_id']) exit(json_encode(array('type'=>'error','msg'=>'It\'s not your stat.')));
if (!preg_match("/[0-9]+/",$user_id)) exit(json_encode(array('type'=>'error','msg'=>'User id not valid!')));
if ($ip_list === false) exit(json_encode(array('type'=>'error','msg'=>'Ip list is empty')));

$ip_list = str_replace(' ', '', $ip_list);
$ip_list_arr = explode(',', $ip_list);
$true_list = array();
for($i=0;$i<count($ip_list_arr);$i++)
  {
  if (CheckIPValid($ip_list_arr[$i]))
    $true_list[] = $ip_list_arr[$i];
  }

  if (1 == 1)
    {
    $srl = serialize($true_list);
    
    $block_list_way = '../addl/block_list_'.$user_id.'.lst';
    if (file_exists($block_list_way))
      {
      $file_data = file_get_contents($block_list_way);
      $file_arr = unserialize($file_data);
      $file_arr[$flow_id] = $true_list;
      $new_data = serialize($file_arr);
      }
      else
      {
      $file_arr[$flow_id] = $true_list; 
      $new_data = serialize($file_arr);
      }
    file_put_contents($block_list_way, $new_data);
    exit(json_encode(array('type'=>'success','msg'=>'Ip list changed')));
    }
    else
    exit(json_encode(array('type'=>'error','msg'=>'Ip list is not valid')));

?>
