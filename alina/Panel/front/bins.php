<?php
if (!defined('AUTHED') || !AUTHED)
	die('no direct xs');

if (isset($_POST['submit'])) {
	$arr = explode("\r\n", $_POST['bins']);
	
	$binlist = array();
	foreach ($arr as $trk) {
		$a = explode("=", $trk);
		
		if ($a === false || count($a) != 2)
			continue;
			
		$bin = substr($a[0], 0, 6);
		$len = strlen($a[1]);
		
		if (!in_array($bin[0], array('3', '4', '5', '6')))
			continue;
			
		if (!is_array(@$binlist[$bin]))
			$binlist[$bin] = array($len);
		else
			array_push($binlist[$bin], $len);
	}
	
	$sql = "INSERT INTO bins(bin, len) VALUES ";
	$updated = 0;
	$inserted = 0;
	foreach ($binlist as $bin => $freq) {
		$cnt = array_count_values($freq);
		asort($cnt, SORT_NUMERIC);
		end($cnt);
		$len = key($cnt);
		
		$bin = mysql_real_escape_string($bin);
		$res = mysql_query("SELECT id,len FROM bins WHERE bin='$bin' LIMIT 1");
		
		if (mysql_num_rows($res)) {
			$row = mysql_fetch_assoc($res);
			if ($row['len'] < $len) {
				$updated++;
				mysql_query("UPDATE bins SET len=$len WHERE id=$row[id] LIMIT 1");
			}
		} else {
			$inserted++;
			$sql .= "('$bin', $len),";
		}
	}
	
	$sql = substr($sql, 0, strlen($sql) - 1);
	mysql_query($sql);
	
	print "$updated Bins updated and $inserted Bins inserted<br />";
}

$res = mysql_query("SELECT COUNT(*) FROM bins");
$arr = mysql_fetch_array($res);

print "We have $arr[0] Bins in the Database currently<br /><br />";
print '<form action="" method="POST">' .
	'<textarea cols="100" rows="35" name="bins"></textarea>' .
	'<br /><input type="submit" name="submit" value="Add" /></form>';
?>
