<?
  require("passwd.inc");
  require("../cfg.php");
  
  function line_count($file) {
    $f=@fopen("../macro/$file","r");
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
    $name = $_POST['name'];
    for ($i=0; $i < strlen($name); $i++) {
      if (  ((Ord($name[$i]) >= 65) && (Ord($name[$i]) <= 90)) || ($name[$i] === '_') ) ;
      else exit("Bad macros name.");
    }
    $type = $_POST['type'];
    $t_body = $_POST['t_body'];
    if (strlen($t_body) > 5) {
      $fp = fopen ("../macro/$name.txt", "w") or die("Cant create file '$name'.");
      fwrite ($fp, $t_body);
      fclose ($fp);
    }
    $linec = line_count($name.".txt");
    @mysql_query("INSERT INTO macro (name,type,file,count) VALUES ('$name','$type','$name.txt','$linec');");
    Header("Location: http://$server/spm/admin/macros.php");
    
    
  } elseif ($action === "delete") {
    $macid = $_GET['macid'];
    $res = @mysql_query("SELECT * FROM macro WHERE `id` = $macid;");
    @mysql_query("DELETE FROM macro WHERE `id` = $macid;");
    /*
    if ($res) {
      $file = "../macro/".mysql_result($res,0,'file');
      if (file_exists($file)) unlink($file);
      Header("Location: http://$server/spm/admin/macros.php");
    } else echo "Netu takogo macrosa.";
    */
  }

  echo "<hr>\r\n";
  echo "<div align='center'><h2>Macros</h2></div>\r\n";
  include("menu.inc");
  echo "<hr>\r\n";
  
  $macros = @mysql_query("SELECT * FROM macro;");
  $macros_count = @mysql_num_rows($macros);
  if ($macros_count > 0) {
    echo "<table border='1' align='center'>";
    echo "<tr><td>Name</td><td>Type</td><td>File</td><td>Count</td><td>Reload</td><td>Delete</td></tr>\r\n";
    for ($i=0; $i < $macros_count; $i++) {
      $macid = mysql_result($macros,$i,'id');
      echo "<tr>";
      echo "<td>".mysql_result($macros,$i,'name')."</td>";
      if (mysql_result($macros,$i,'type') === "s") echo "<td>Static</td>";
      else echo "<td>Dynamic</td>";
      echo "<td>".mysql_result($macros,$i,'file')."</td>";
      echo "<td>".mysql_result($macros,$i,'count')."</td>";
      echo "<td><a href='./macros.php?macid=$macid&action=reload'>Reload</a></td>";
      echo "<td><a href='./macros.php?macid=$macid&action=delete'>Delete</a></td>";
      echo "</tr>";
      echo "\r\n";
    }
    echo "</table>\r\n";
  }
  echo "<hr>\r\n";
  echo "<div align='center'>Add Macros</div>\r\n";
  echo "<hr>\r\n";
?>
<form action="./macros.php?action=add" method="POST">
<table align='center'>
<tr><td>Name</td><td><input type="TEXT" name="name"></td></tr>
<tr><td>Type</td><td><select name="type" size="1"><option value="s" SELECTED>Static</option><option value="d">Dynamic</option></select></td></tr>
<tr><td colspan="2"><textarea name="t_body" cols="30" rows="7"></textarea></td></tr>
<tr><td>&nbsp;</td><td><input type="SUBMIT" value="Add"></td></tr>
</table>
</form>
