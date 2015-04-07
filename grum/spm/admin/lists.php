<?
  require("passwd.inc");
  
  require("../cfg.php");

  function line_count($file) {
    $f=@fopen($file,"r");
    if (!$f) return 0;
    $linecount = 0;
    while (!feof($f)) {
      $str1 = fgets($f,1024);
      $linecount++;
    }
    fclose($f);
    //$linecount--;
    return $linecount;
  }

  
  
  $action = $_GET['action'];
  
  if ($action === "add") {
    $file = $_POST['file'];
    $linec = line_count("../lists/".$file);
    
    mysql_query("INSERT INTO lists (file,count) VALUES ('$file','$linec');");
    
    Header("Location: http://$server/spm/admin/lists.php");
  } elseif ($action === "delete") {
    $listid = $_GET['listid'];
    @mysql_query("DELETE FROM lists WHERE `id` = $listid;");
  }
  
  echo "<hr>\r\n";
  echo "<div align='center'><h2>Lists</h2></div>\r\n";
  include("menu.inc");
  echo "<hr>\r\n";
  $list = @mysql_query("SELECT * FROM lists;");
  $list_count = @mysql_num_rows($list);
  if ($list_count > 0) {
    echo "<table border='1' align='center'>";
    echo "<tr><td>File</td><td>Count</td><td>Delete</td></tr>\r\n";
    for ($i=0; $i < $list_count; $i++) {
      $listid = mysql_result($list,$i,'id');
      echo "<tr>";
      echo "<td>".mysql_result($list,$i,'file')."</td>";
      echo "<td>".mysql_result($list,$i,'count')."</td>";
      echo "<td><a href='./lists.php?listid=$listid&action=delete'>Delete</a></td>";
      echo "</tr>";
      echo "\r\n";
    }
    echo "</table>\r\n";
  }
  echo "<hr>\r\n";
  echo "<div align='center'>Add List</div>\r\n";
  echo "<hr>\r\n";
?>
<form action="./lists.php?action=add" method="POST">
<table align='CENTER'>
<tr><td>File</td><td><input type="TEXT" name="file"></td></tr>
<tr><td>&nbsp;</td><td><input type="SUBMIT" value="Add"></td></tr>
</table>
</form>
