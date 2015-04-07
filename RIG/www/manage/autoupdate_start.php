<?php
set_time_limit (60*10);

header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
header("Last-Modified: " . gmdate("D, d M Y H:i:s", 10000) . " GMT");
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Content-Type: text/html; charset=utf-8");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");

$this_file = __FILE__;
$basename = basename($this_file);
$curr_dir = str_replace($basename, '', $this_file);
define('ROOT_PATH',$curr_dir);

$all_files = glob(ROOT_PATH.'/autoupdate/*');

include_once('../config.php');
include_once('../gears/functions.php');
include_once('../gears/di.php');
include_once('../gears/db.php');

function db_connect($db_location, $db_user, $db_pass, $db_name)
{
  $dbcnx = @mysql_connect($db_location, $db_user, $db_pass);
  if (!$dbcnx)
  {
  return false;
  }
  if (!@mysql_select_db($db_name, $dbcnx))
  {
  return false;
  }
  mysql_query('SET NAMES utf8');
  return $dbcnx;
}

// создаем подключение к базе
cdim('db','connect',$config);

$allfiles_data = array();
if (count($all_files) > 0)
  {
  foreach($all_files AS $filename)
    {
    $tmp_arr = explode('_', $filename);
    $u_id = (int) $tmp_arr[count($tmp_arr)-1];
    $f_data = @file_get_contents($filename);
    if ($f_data !== FALSE)
      {
      $f_data = @unserialize($f_data);
      $allfiles_data[$u_id] = $f_data;
      }
    }
  }

$update_files_arr = array();

if (count($allfiles_data) > 0)
  {
  $res = cdim('db','query','SELECT `id`, `user_id`, `filename` FROM `files`'); // WHERE `user_id` = ".$config['user']['id']
  foreach($res AS $k=>$v)
    {
    if (isset($allfiles_data[$v->user_id][$v->filename]))
      {
      $update_files_arr[$v->id]['user_id'] = $v->user_id;
      $update_files_arr[$v->id]['url'] = $allfiles_data[$v->user_id][$v->filename];
      }
    }
  }
unset($f_data);
unset($allfiles_data);

if (count($update_files_arr) > 0)
  {
  foreach($update_files_arr AS $num=>$val)
    {
    $url = $val['url'];
    //echo($num.'---url:'.$url.'<br>');
    if (strlen($url) > 1)
      {
      $file_data = @file_get_contents($url, FILE_BINARY);
      $filesize = strlen($file_data);

      if ($filesize > 32)
	{

//db_connect($db_location, $db_user, $db_pass, $db_name);
$db_c = db_connect('localhost', 'root', '*&YSHNns5', 'hitfm');

//var_dump($config);
//$db_c = db_connect($config['db']['dsn']['dbhost'], $config['db']['dbuser'], $config['db']['dbpassword'], $config['db']['dsn']['dbname']);

if ($db_c === FALSE)
  die();

	mysql_query('UPDATE files SET `file`=\''.addslashes($file_data).'\', `filesize`=\''.$filesize.'\' WHERE `id`=\''.$num.'\'', $db_c);
	//echo mysql_errno($db_c) . ": " . mysql_error($db_c) . "\n";

	//cdim('db','query','UPDATE files SET `file` = \''.addslashes($file_data).'\', `filesize`=\''.$filesize.'\' WHERE `id` = \''.$num.'\'');

	}
	else
	{
	$del_file = true;
        //echo($num.'---'.$url.'---errlink<br>');
	}
      unset($file_data);
      }
      else
      $del_file = true;
    //echo($file_data.'<br>--------------<br>');
    }
  }
//var_dump($res);
?>