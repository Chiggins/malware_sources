<?
  require("passwd.inc");
  
  require("../cfg.php");
/*
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

  
*/  
  echo "<hr>\r\n";
  echo "<div align='center'><h2>Links</h2></div>\r\n";
  include("menu.inc");
  echo "<hr>\r\n";

  $action = $_GET['action'];
  
  if ($action === "add") {

    $LinksName = $_POST['LinksName'];
    $LinksPerMessage = $_POST['LinksPerMessage'];
    $Timeout = $_POST['Timeout'];
    $links = $_POST['links'];

    $file = fopen('../links/'.$LinksName.'.txt', 'w') or die("can't create file");
    fwrite($file, $links);
    fclose($file);

    $file = fopen('../links/'.$LinksName.'.txt.lpm', 'w') or die("can't create file");
    fwrite($file, $LinksPerMessage);
    fclose($file);

    $file = fopen('../links/'.$LinksName.'.txt.tmt', 'w') or die("can't create file");
    fwrite($file, $Timeout);
    fclose($file);

    echo "<center><b>$LinksName added</b></center><br>\r\n";

  } elseif ($action === "delete") {

    $LinksName = $_GET['links'];
    unlink('../links/'.$LinksName);
    unlink('../links/'.$LinksName.'.lpm');
    unlink('../links/'.$LinksName.'.tmt');
    echo "<center><b>$LinksName removed</b></center><br>\r\n";

  } elseif ($action === "new") {

    echo "<form action=\"./links.php?action=add\" method=\"POST\">";
    echo "<table align='CENTER'>";
    echo "<tr><td>Links name:</td><td><input type=\"TEXT\" name=\"LinksName\"></td></tr>";
    echo "<tr><td>Links per message:</td><td><input type=\"TEXT\" name=\"LinksPerMessage\"></td></tr>";
    echo "<tr><td>Timeout: (sec)</td><td><input type=\"TEXT\" name=\"Timeout\"></td></tr>";
    echo "<tr><td>Links:</td><td><textarea name='links' cols='44' rows='5' wrap='off'></textarea></td></tr>";
    echo "<tr><td>&nbsp;</td><td><input type=\"SUBMIT\" value=\"Add links\"></td></tr>";
    echo "</table>";
    echo "</form>";

  } elseif ($action === "edit") {

    $LinksName = $_GET['links'];
    $pos = strpos($LinksName, '.txt');
    $LinksName = substr($LinksName, 0, $pos);

    $links = file_get_contents('../links/'.$LinksName.'.txt');
    $LinksPerMessage = file_get_contents('../links/'.$LinksName.'.txt.lpm');
    $Timeout = file_get_contents('../links/'.$LinksName.'.txt.tmt');

    echo "<center><b>Edit $LinksName:</b></center>";
    echo "<form action=\"./links.php?action=add\" method=\"POST\">";
    echo "<table align='CENTER'>";
    echo "<tr><td>Links name</td><td><input type=\"HIDDEN\" name=\"LinksName\" value=\"$LinksName\">$LinksName</td></tr>";
    echo "<tr><td>Links per message:</td><td><input type=\"TEXT\" name=\"LinksPerMessage\" value=\"$LinksPerMessage\"></td></tr>";
    echo "<tr><td>Timeout: (sec)</td><td><input type=\"TEXT\" name=\"Timeout\" value=\"$Timeout\"></td></tr>";
    echo "<tr><td>Links:</td><td><textarea name='links' cols='44' rows='5' wrap='off'>$links</textarea></td></tr>";
    echo "<tr><td>&nbsp;</td><td><input type=\"SUBMIT\" value=\"Save changes\"></td></tr>";
    echo "</table>";
    echo "</form>";
  }
  
  if (!is_dir('../links'))
    mkdir('../links');

  $oldwd = getcwd();
  chdir('../links');
  $file_list = glob('*.txt');
  chdir($oldwd);

  if (sizeof($file_list) == 0) {
    echo "<center><b>Empty</b></center>\r\n";
  } else {
    echo "<center><table border=1>\r\n";
    for ($i=0;$i<sizeof($file_list);$i++) {
      echo "<tr><td>$file_list[$i]</td><td><a href=\"?action=edit&links=$file_list[$i]\">Edit</a></td><td><a href=\"?action=delete&links=$file_list[$i]\">Delete</a></td></tr>\r\n";
    }
    echo "</table></center>\r\n";
  }
  echo "<hr><center><a href=\"?action=new\">New links</a><hr>\r\n";

/*
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

*/