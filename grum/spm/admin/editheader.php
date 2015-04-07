<?
  require("passwd.inc");
  $bodys_dir = "../bodys/";
  $headers_dir = "../headers/";
  $lists_dir = "../lists/";
  $tasks_dir = "../tasks/";

  $fn = $_GET['filename'];
  $action = $_GET['action'];
  if ($action === "set") {
    $hdr = $_POST['header'];
    if (strlen($hdr)>0) {
      //while (substr($hdr,-4) !== "\r\n\r\n") $hdr .= "\r\n";
      $fp = fopen($headers_dir.$fn, "w");
      //ftruncate(
      fwrite ($fp, $hdr);
      fclose ($fp);
    }
  }
  $txt = stripslashes(join('',file($headers_dir.$fn)));
  
  echo "<hr>\r\n";
  echo "<div align='center'><h2>Edit Header '$fn'</h2></div>\r\n";
  echo "<hr>\r\n";

  echo "<div align='CENTER'>";

  echo "<form action='./editheader.php?action=set&filename=$fn' method='POST'>";
  echo "<textarea name='header' cols='80' rows='25'>$txt</textarea>";
  echo "<input type='SUBMIT' value='Save'>";
  echo "</form>";

  echo "</div>";

?>
