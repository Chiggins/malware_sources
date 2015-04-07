<?php

require("cfg.php");

$ip=$_SERVER['REMOTE_ADDR'];

$Config = @mysql_query("SELECT * FROM Config WHERE (Name='LastBotId') LIMIT 1;");
if (mysql_num_rows($Config) < 1)
{
  echo "0";
} else {
  $id = mysql_result($Config,0,'Value') + 1;
  @mysql_query("UPDATE Config SET `Value`='$id' WHERE `Name`='LastBotId';");

//  $f = fopen("get_id.log","a+");
//  fwrite($f, date("Y-m-d H:i:s")." $id $ip\r\n");
//  fclose($f);
  echo $id;
}

?>