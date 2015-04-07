<?
  require("passwd.inc");
  $headers_dir = "../headers/";
  
  $action = $_GET['action'];
  if ($action === "delete") {
    $id = $_GET['id'];
    unlink($headers_dir.$id);
  } elseif ($action === "new") {
    $fn = $_POST['filename'];
    $hdr = $_POST['header'];
    //while (substr($hdr,-4) !== "\r\n\r\n") $hdr .= "\r\n";
    $fp = fopen($headers_dir.$fn, "w");
    fwrite ($fp, $hdr);
    fclose ($fp);
  }
  
  $dir = opendir($headers_dir);
  chdir($headers_dir);
  
 
  echo "<div align='center'><h2>Headers</h2></div>\r\n";
  include("menu.inc");
  
  echo "<hr>\r\n";
  echo "<SCRIPT>function ow(e) { newWindow=window.open(e); newWindow.focus(); }</SCRIPT>";

  echo "<table width=90% border='1' align='CENTER'><tr><td><table border='1' align='LEFT'>";
  echo "<tr><td>File</td><td>Edit</td><td>Check</td><td>Delete</td><td>Header</td></tr>\r\n";

  while (($d = readdir($dir)) !== false) {
    if (is_file($d)) {
      if ($d === ".htaccess") continue;
      $filename = $headers_dir."$d";
      $text = stripslashes(join('',file($filename)));
      echo "<tr>";
      echo "<td>$d</td>";      
      echo "<td><a href='javascript:ow(\"./editheader.php?filename=$d\");'>Edit</a></td>";
      echo "<td><a href='javascript:ow(\"../checkheader.php?filename=$d\");'>Check</a></td>";
      echo "<td><a href='./headers.php?id=$d&action=delete'>Delete</a></td>";
      echo "<td><pre cols='50' rows='5'>$text</pre></td>";
      echo "</tr>";
    }
  }
  closedir($dir);

?>  
  <tr><td>
  
  <table align='LEFT'>
  <form action='./headers.php?action=new' method='POST'>
  <tr><td>File Name:&nbsp;<input type='text' name='filename' value=''></td></tr>
  <tr><td><textarea name='header' cols='50' rows='25'></textarea></td></tr>
  <tr><td><input type='SUBMIT' value='Add'></td></tr></form></table>
  </table>
  
  </td></tr>
  </table>
  

