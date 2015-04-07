<?
  require("passwd.inc");
  require("../cfg.php");
  $date_u = date("U");
  $need_date_u = $date_u - 30*60;
    
  $tasks = mysql_query("SELECT * FROM robo WHERE (`time` > $need_date_u) AND (`smtp` = 'ok');");
  
  for ($i=0; $i < mysql_num_rows($tasks); $i++) {
    
    $ip = mysql_result($tasks,$i,'ip');
    $host=gethostbyaddr($ip);
    
    echo "$ip,$host\r\n";
    
  }
    
    
 
?>
