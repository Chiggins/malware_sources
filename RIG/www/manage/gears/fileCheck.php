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
if ($config['user']['id']!=$_POST['user_id']) exit(json_encode(array('type'=>'error','msg'=>'It\'s not your stat.')));
if (!preg_match("/[0-9]+/",$user_id)) exit(json_encode(array('type'=>'error','msg'=>'User id not valid!')));


$file_id = intval($_POST['file_id']);
if (!preg_match("/[0-9]+/",$file_id)) exit(json_encode(array('type'=>'error','msg'=>'File id not valid!')));


$sql = "SELECT * FROM `files` WHERE `id` = ".$file_id." AND `user_id` = ".$user_id;
$result = cdim('db', 'query', $sql);
if (!isset($result[0])) exit(json_encode(array('type'=>'error','msg'=>'File not found!')));

file_put_contents("../files/".$result[0]->filename, $result[0]->file);

/* ПРОВЕРКА НА CHECK4U */

$file = "../files/".$result[0]->filename;
$format='json'; // json - for JSON return

if (!file_exists($file)) exit(json_encode(array('type'=>'error','msg'=>'Call admin. Error in file check!')));

$ch = curl_init();
curl_setopt($ch, CURLOPT_HEADER, 0);
curl_setopt($ch, CURLOPT_VERBOSE, 0);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_URL, 'http://scan4you.net/remote.php'); //$url='http://scan4you.org/remote.php'; // Try this if .net dosn`t work
curl_setopt($ch, CURLOPT_POST, true);

$post = array('id'=>"13350",'token'=>"515fdabc0d8b3b7928c3",'action'=>'file','av_disable'=>'','av_enabled'=>'','link'=>1,'frmt'=>'json');

if (class_exists('CURLFile')){
	$cfile = new CURLFile($file,'application/octet-stream','file');
	$post['uppload']=$cfile;
} else {
	$post['uppload']='@'.$file;
}



curl_setopt($ch, CURLOPT_POSTFIELDS, $post);
$response = curl_exec($ch);
if ($response === false || curl_errno($ch) || curl_getinfo($ch, CURLINFO_HTTP_CODE) != 200){
    exit(json_encode(array('type'=>'error','msg'=>curl_error($ch))));
}

$response = json_decode($response);
$total = 0;
$fired = 0;
$avlink = '';
foreach($response as $k=>$v) {
	if ($k=='LINK') { $avlink = str_replace("URL=", "", $v); continue; }
	if ($response->$k!='OK') $fired++;
	$total++;
}

$shortRes = $fired.'/'.$total;

$fileSize = filesize('../files/'.$result[0]->filename);

unlink('../files/'.$result[0]->filename);

cdim('db','query',"UPDATE `files` SET `avcheck` = '".$shortRes."' WHERE `id` = ".$file_id." LIMIT 1 ;");

/* отдали результаты */
exit(json_encode(array('type'=>'success','msg'=>'File Checked', 'shortresult'=>$shortRes, 'avlink'=>$avlink, 'fileid'=>$file_id, 'fileSize'=>$fileSize, 'fileName'=>$result[0]->filename)));
?>
