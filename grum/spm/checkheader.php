<?
  require("admin/passwd.inc");
  require("./cfg.php");
  require("./macro.php");
  $headers_dir = "./headers/";
  
  $fn = $_GET['filename'];
  $full_fn = $headers_dir.$fn;
  
  $text = stripslashes(join('',file($full_fn)));

  MacroBody($text);
/*
  $tbl = nl2br($text);
  $tbl = str_replace("$DATE","<font color='green'>%DATE</font>",$tbl);
  $tbl = str_replace("$TO_EMAIL","<font color='green'>%TO_EMAIL</font>",$tbl);
  $tbl = str_replace("$FROM_EMAIL","<font color='green'>%FROM_EMAIL</font>",$tbl);
  $tbl = str_replace("$FROM_DOMAIN","<font color='green'>%FROM_DOMAIN</font>",$tbl);
  $tbl = str_replace("$REAL_IP","<font color='green'>%REAL_IP</font>",$tbl);
  $tbl = str_replace("$","<font color='red'>%</font>",$tbl);
*/

  echo "<hr>\r\n";
  echo "<div align='center'><h2>Check Header '$fn'.</h2></div>\r\n";
  echo "<hr>\r\n";

  echo "<div align='center'><textarea cols='80' rows='25'>$text</textarea></div>";
  //echo "<table align='center'><tr><td>$tbl</td></tr></table>";
?>
