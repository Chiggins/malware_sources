<?php
include("parameters.php");

mysql_connect($db_host,$db_user,$db_pass) or die("Unable to connect to database");
mysql_select_db($database) or die("Unable to select database");

//****** determination IP¨& country - START
$flag="0";
$country="";
$ip=$_SERVER["REMOTE_ADDR"];
if(isset($_POST["ip"]) && ($_POST["ip"]==long2ip(ip2long($_POST["ip"]))))
	{$ip=long2ip(ip2long($_POST["ip"]));}
$resultat=mysql_query("SELECT COUNTRY_CODE2 FROM ip2country WHERE (IP_FROM<=inet_aton('".$ip."') AND IP_TO>=inet_aton('".$ip."'))");
if(!($ligne=mysql_fetch_array($resultat)))
	{$country="1";}
	else
	{
	$resultat2=mysql_query("SELECT printable_name FROM country WHERE iso='".$ligne["COUNTRY_CODE2"]."'");
	if(!($ligne2=mysql_fetch_array($resultat2)))
		{$country="2";}
		else
		{
		$flag=strtolower($ligne["COUNTRY_CODE2"]).".png";
		if(!file_exists($flag)){$flag="0";}
		$country=$ligne2["printable_name"];
		}
	}

//****** determination IP¨& country - END


echo '<div class="top_ip">';
//*********** Display IP & country

if($country=="1"){echo 'Sorry but this IP isn&#39;t in our database.';}
else if($country=="2"){echo 'There was an error matching your country&#39;s name and iso code. Please contact us through the forum, indicating your country and it&#39;s iso code ('.$_COOKIE["country_code"].').<br/>Thank you.';}
else
	{
	if($flag=="0"){echo 'We don&#39;t have your country&#39;s flag&nbsp;! We&#39;d like to have it, please contact us through the forum.';} else {echo '<img src="'.$flag.'" alt="" style="float:left;"/>';}
	echo $ip.' is from '.$country.'.';
	}

echo '</div>
<form action="" method="post">
	<div>
	<label for="ip">IP</label>&nbsp;: <input type="text" name="ip" id="ip" size="50" value="'.$ip.'"/>
	<input type="submit" value=" Get country " />
	</div>
</form>';
?>