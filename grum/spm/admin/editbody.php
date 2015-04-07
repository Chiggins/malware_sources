<?
  require("passwd.inc");
  $bodys_dir = "../bodys/";
  $headers_dir = "../headers/";
  $lists_dir = "../lists/";
  $tasks_dir = "../tasks/";

  require("../cfg.php");

  $tid = $_GET['id'];
  $action = $_GET['action'];
  
  
  if ($action === "setbody") {
  
  
    $bbody = $_POST['body'];
    if (strlen($bbody)>0) {
      $fp = fopen($bodys_dir.$tid, "w");
      fwrite ($fp, $bbody);
      fclose ($fp);
    }    
  }
  elseif($action === "setemail") {
  
    $fmail = $_POST['b_mails'];
    mysql_query("UPDATE tasks SET `fmail`='$fmail' WHERE `id`='$tid';");
  
  }
  elseif($action === "setlinks") {
  
    $b_links = $_POST['b_links'];
    mysql_query("UPDATE tasks SET `links`='$b_links' WHERE `id`='$tid';");
  
  }
  elseif($action === "setlinksserver") {
  
    $b_links_server = $_POST['b_links_server'];
    mysql_query("UPDATE tasks SET `links_server`='$b_links_server' WHERE `id`='$tid';");
  
  }
  elseif($action === "setver") {
  
    $b_ver = $_POST['b_ver'];
    mysql_query("UPDATE tasks SET `ver`='$b_ver' WHERE `id`='$tid';");
  
  }

  $tasks = @mysql_query("SELECT * FROM tasks WHERE `id` = $tid;");
  if (mysql_num_rows($tasks) < 1) exit("Netu takogo taska.");
  
  
  $links_server = mysql_result($tasks,0,'links_server');
  $links = mysql_result($tasks,0,'links');
  $ver =  mysql_result($tasks,0,'ver');
  $body = stripslashes(join('',file($bodys_dir.mysql_result($tasks,0,'body_id'))));
?>  


  
<hr>
<div align='center'><h2>Edit Body #<?=$tid?></h2></div>
<hr>
<table align="CENTER">
<tr>
  <form action='editbody.php?action=setemail&id=<?=$tid?>' method='POST'>
  <td align="RIGHT" valign="TOP">
    <b>From Email:</b>&nbsp;
  </td>
  <td align="LEFT" valign="TOP" rowspan="2">
    <textarea name='b_mails' cols='50' rows='5' wrap='off'><?=$fmail?></textarea>
  </td>
</tr>
<tr>
  <td align="RIGHT" valign="CENTER">
    <input type='SUBMIT' value='Save Emails'>&nbsp;
  </td>
  </form>
</tr>

<tr>
  <form action='editbody.php?action=setsubjs&id=<?=$tid?>' method='POST'>
  <td align="RIGHT" valign="TOP">
    <b>Subjects:</b>&nbsp;
  </td>
  <td align="LEFT" valign="TOP" rowspan="2">
    <textarea name='b_subjs' cols='50' rows='5' wrap='off'><?=$subjects?></textarea>
  </td>
</tr>
<tr>
  <td align="RIGHT" valign="CENTER">
    <input type='SUBMIT' value='Save Subjects'>&nbsp;
  </td>
  </form>
</tr>

<tr>
  <form action='editbody.php?action=setlinksserver&id=<?=$tid?>' method='POST'>
  <td align="RIGHT" valign="TOP">
    <b>Links Server:</b>&nbsp;
  </td>
  <td align="LEFT" valign="TOP">
    <input name='b_links_server' type='TEXT' value=<?=$links_server?>>
  </td>
</tr>
<tr>
  <td align="RIGHT" valign="CENTER">
    <input type='SUBMIT' value='Save Links Server'>&nbsp;
  </td>
  </form>
</tr>
<tr>
  <form action='editbody.php?action=setlinks&id=<?=$tid?>' method='POST'>
  <td align="RIGHT" valign="TOP">
    <b>Links:</b>&nbsp;
  </td>
  <td align="LEFT" valign="TOP">
    <input name='b_links' type='TEXT' value=<?=$links?>>
  </td>
</tr>
<tr>
  <td align="RIGHT" valign="CENTER">
    <input type='SUBMIT' value='Save Links'>&nbsp;
  </td>
  </form>
</tr>
<tr>
  <form action='editbody.php?action=setver&id=<?=$tid?>' method='POST'>
  <td align="RIGHT" valign="TOP">
    <b>Ver:</b>&nbsp;
  </td>
  <td align="LEFT" valign="TOP">
    <input name='b_ver' type='TEXT' value=<?=$ver?>>
  </td>
</tr>
<tr>
  <td align="RIGHT" valign="CENTER">
    <input type='SUBMIT' value='Save ver'>&nbsp;
  </td>
  </form>
</tr>
</table>
</div>
<table>
<tr>
  <form action='editbody.php?action=setbody&id=<?=$tid?>' method='POST'>
  <td>
    <textarea name='body' cols='120' rows='75' wrap='off'><?=$body?></textarea>
  </td>  
</tr>
<tr>
  <td colspan='2' align="CENTER">
    <input type='SUBMIT' value='Save Body'>
  </td>
  </form>
</tr>
</table>
  
  
  
<?
/*
echo "<hr>\r\n";
  echo "<div align='center'><h2>Edit Body #$tid</h2></div>\r\n";
  echo "<hr>\r\n";

  echo "<div align='CENTER'>";

  echo "<form action='./editbody.php?action=set&id=$tid' method='POST'>";
  echo "<textarea name='body' cols='80' rows='25'>$body</textarea>";
  echo "<input type='SUBMIT' value='Save'>";
  echo "</form>";

  echo "</div>";
  
  */
?>
  
  


