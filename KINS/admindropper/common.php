<?php

function curPageURL() {
 $pageURL = 'http';
 if ($_SERVER["HTTPS"] == "on") {$pageURL .= "s";}
 $pageURL .= "://";
 if ($_SERVER["SERVER_PORT"] != "80") {
  $pageURL .= $_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"].$_SERVER["REQUEST_URI"];
 } else {
  $pageURL .= $_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"];
 }
 return $pageURL;
}

function percent($val, $p)
{
	return @round(($val * 100) / $p, 2);
}

$allCountries = array
(
    'AP','EU','AD','AE','AF','AG','AI','AL','AM','AN','AO','AQ','AR','AS','AT','AU','AW','AZ','BA','BB','BD','BE','BF','BG','BH','BI','BJ','BM','BN','BO','BR','BS','BT','BV','BW','BY','BZ','CA','CC','CD','CF','CG','CH','CI','CK','CL','CM','CN','CO','CR','CU','CV','CX','CY','CZ','DE','DJ','DK','DM','DO','DZ','EC','EE','EG',
    'EH','ER','ES','ET','FI','FJ','FK','FM','FO','FR','FX','GA','GB','GD','GE','GF','GH','GI','GL','GM','GN','GP','GQ','GR','GS','GT','GU','GW','GY','HK','HM','HN','HR','HT','HU','ID','IE','IL','IN','IO','IQ','IR','IS','IT','JM','JO','JP','KE','KG','KH','KI','KM','KN','KP','KR','KW','KY','KZ','LA','LB','LC','LI','LK','LR',
    'LS','LT','LU','LV','LY','MA','MC','MD','MG','MH','MK','ML','MM','MN','MO','MP','MQ','MR','MS','MT','MU','MV','MW','MX','MY','MZ','NA','NC','NE','NF','NG','NI','NL','NO','NP','NR','NU','NZ','OM','PA','PE','PF','PG','PH','PK','PL','PM','PN','PR','PS','PT','PW','PY','QA','RE','RO','RU','RW','SA','SB','SC','SD','SE','SG',
    'SH','SI','SJ','SK','SL','SM','SN','SO','SR','ST','SV','SY','SZ','TC','TD','TF','TG','TH','TJ','TK','TM','TN','TO','TL','TR','TT','TV','TW','TZ','UA','UG','UM','US','UY','UZ','VA','VC','VE','VG','VI','VN','VU','WF','WS','YE','YT','RS','ZA','ZM','ME','ZW','A1','A2','O1','AX','GG','IM','JE','UNKNOWN'
);

$mixCountries = array
(
    'AP','EU','AD','AE','AF','AG','AI','AL','AM','AN','AO','AQ','AR','AS','AT','AW','AZ','BA','BB','BD','BE','BF','BG','BH','BI','BJ','BM','BN','BO','BS','BT','BV','BW','BZ','CC','CD','CF','CG','CH','CI','CK','CL','CM','CO','CR','CU','CV','CX','CY','CZ','DJ','DK','DM','DO','DZ','EC','EE','EG',
    'EH','ER','ET','FI','FJ','FK','FM','FO','FX','GA','GD','GE','GF','GH','GI','GL','GM','GN','GP','GQ','GS','GT','GU','GW','GY','HK','HM','HN','HR','HT','HU','ID','IE','IL','IN','IO','IQ','IR','IS','JM','JO','KE','KG','KH','KI','KM','KN','KP','KR','KW','KY','LA','LB','LC','LI','LK','LR',
    'LS','LT','LU','LV','LY','MA','MC','MD','MG','MH','MK','ML','MM','MN','MO','MP','MQ','MR','MS','MT','MU','MV','MW','MX','MY','MZ','NA','NC','NE','NF','NG','NI','NP','NR','NU','OM','PA','PE','PF','PG','PH','PK','PM','PN','PR','PS','PW','PY','QA','RE','RO','RW','SA','SB','SC','SD','SG',
    'SH','SI','SJ','SK','SL','SM','SN','SO','SR','ST','SV','SY','SZ','TC','TD','TF','TG','TH','TJ','TK','TM','TN','TO','TL','TT','TV','TW','TZ','UG','UM','UY','UZ','VA','VC','VE','VG','VI','VN','VU','WF','WS','YE','YT','RS','ZA','ZM','ME','ZW','A1','A2','O1','AX','GG','IM','JE', 'UNKNOWN'
);

function notEmpty($el)
{
    return !empty($el);
}

function countryFromDB($c1, $c2, $c3, $c4)
{
    global $allCountries, $mixCountries;

    $m = array_filter(array_unique(array_merge(explode(',', $c1), explode(',', $c2), explode(',', $c3), explode(',', $c4))), 'notEmpty');
    if (0 == count(array_diff($allCountries, $m))) {
        $m = array('ALL');
    } elseif (0 == count(array_diff($mixCountries, $m))) {
        $m = array_merge(array_diff($m, $mixCountries), array('MIX'));
    }
    return implode(', ', $m);
}

function countryArrayToDB($a)
{
    global $allCountries, $mixCountries;

    $str = implode(',', array_keys(array_filter($a, 'notEmpty')));

    $str = str_replace('MIX', implode(',', $mixCountries), $str);
    $str = str_replace('ALL', implode(',', $allCountries), $str);

    return $str;
}

function countryListFromDB($db)
{
    $c = $db->query('SELECT cName, 0 FROM country')->fetchAllAssoc('cName');
    foreach ($c as $k => $v)
    {
        $c[$k] = 0;
    }
    return $c;
}

function format_bytes($bytes)
{
   if ($bytes < 1024) return $bytes.' B';
   elseif ($bytes < 1048576) return round($bytes / 1024, 2).' KB';
   elseif ($bytes < 1073741824) return round($bytes / 1048576, 2).' MB';
   elseif ($bytes < 1099511627776) return round($bytes / 1073741824, 2).' GB';
   else return round($bytes / 1099511627776, 2).' TB';
}

function httpRedirect($url)
{
    header("Location: $url");
    exit();
}

function httpNoCache()
{
    header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
    header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
    header("Pragma: no-cache");
    header("Cache-Control: no-cache, must-revalidate");
}

function httpSendAuthForm()
{
    header( 'WWW-Authenticate: Basic realm="Restricted area"' );
    header( "HTTP/1.0 401 Unauthorized" );
    echo "Access denied";
    exit();
}

function httpAuth()
{
    if (!isset($_SERVER['PHP_AUTH_USER'])) httpSendAuthForm();
    if (USER != $_SERVER['PHP_AUTH_USER'] || PASS != md5($_SERVER['PHP_AUTH_PW'])) httpSendAuthForm();
}

function metaRefresh($url)
{
    echo "<meta http-equiv='refresh' content='0;url={$url}'>";
}

function error404()
{
	header('HTTP/1.1 404 Not Found', TRUE, 404);
	echo <<<HTML
	<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
	<HTML><HEAD>
	<TITLE>404 Not Found</TITLE>
	</HEAD><BODY>
	<H1>Not Found</H1>
	The requested URL $_SERVER[REQUEST_URI] was not found on this server.
	<HR>
	<I>$_SERVER[HTTP_HOST]</I>
	</BODY></HTML>
HTML;
	echo str_repeat ("\r\n", 50);
	exit();
}

function getIP()
{
	if (isset($_SERVER["HTTP_X_REAL_IP"]))
	{
		return $_SERVER["HTTP_X_REAL_IP"];
	}
	else if (isset($_SERVER["HTTP_X_FORWARDED_FOR"]))
	{
		return $_SERVER ["HTTP_X_FORWARDED_FOR"];
	}

	return $_SERVER ['REMOTE_ADDR'];
}

class Db_Mysql
{
	var $host       = '';
	var $user 	= '';
	var $password	= '';
	var $database 	= '';
	var $persistent = false;

	var $conn = false;

	var $result = false;

	var $debug = false;
	var $error = false;

	static $instance = null;
	static $opened = false;

	public static function getInstance()
	{
		if (self::$instance === null) {
			trigger_error('Mysql class not initialised!', E_USER_ERROR);
		}
		else {
			if (!self::$opened) {
				self::$opened = true;
				self::$instance->open();
			}
			return self::$instance;
		}
	}

	public static function init($host, $user, $password, $database, $persistent=false)
	{
		self::$instance = new Db_Mysql();
		self::$instance->host = $host;
		self::$instance->user = $user;
		self::$instance->password = $password;
		self::$instance->database = $database;
		self::$instance->persistent = $persistent;
	}

	function open()
	{
		if ($this->persistent)
			$this->conn = mysql_pconnect($this->host, $this->user, $this->password);
		else
			$this->conn = mysql_connect($this->host, $this->user, $this->password);

		if (!$this->conn)
		{
			$this->error = "Could not create database connection";
			return false;
		}

		if (!mysql_select_db($this->database, $this->conn))
		{
			$this->error = "Could not select database";
			return false;
		}

		return true;
	}

	function close()
	{
		return (mysql_close($this->conn));
	}

	function query($sql)
	{
	    $this->result = mysql_query($sql, $this->conn);

	    if ($this->debug)
	    {
			debug("<pre>".$sql."</pre>\n");
			if (mysql_errno($this->conn))
				debug("<pre>Error in query: ".mysql_error($this->conn)."</pre>");
	    }
	    return ( ($this->result != false) ? $this : false);
	}

	function affectedRows()
	{
		return(mysql_affected_rows($this->conn));
	}

	function getResult($col)
	{
		return(mysql_result($this->result,$col));
	}

	function numRows()
	{
		return(mysql_num_rows($this->result));
	}

	function fetchRow()
	{
		return(mysql_fetch_row($this->result));
	}

	function fetchObject($class_name = null)
	{
		return(mysql_fetch_object($this->result, $class_name));
	}

	function fetchArray()
	{
		return(mysql_fetch_array($this->result));
	}

	function fetchAssoc()
	{
		return(mysql_fetch_assoc($this->result));
	}

	function freeResult()
	{
		return(mysql_free_result($this->result));
	}

	function lastInsert()
	{
		return(mysql_insert_id($this->conn));
	}

	function insert($table, $assoc) {
		//prepare
		foreach ($assoc as &$value) {
			if (!is_numeric($value)) $value = '"'.mysql_escape_string($value).'"';
		}

		$this -> query('INSERT INTO `'.$table.'` ('.implode(', ', array_keys($assoc)).') VALUES ('.implode(', ', $assoc).')');

		return $this -> lastInsert();
	}

	function fetchPairs() {
		//init array
		$list = array();
		//fetch
		while ($result = $this -> fetchRow()) $list[@$result[0]] = @$result[1];
		//return list
		return $list;
	}

	function fetchAll() {
		//init array
		$list = array();
		//fetch
		while ($result = $this -> fetchRow()) $list[] = $result;
		//return list
		return $list;
	}

	function fetchAllAssoc($keyColumn = null) {
		//init array
		$list = array();
		//fetch
		while ($result = $this -> fetchAssoc()) {
			if ($keyColumn != null) {
				$list[$result[$keyColumn]] = $result;
			}
			else {
				$list[] = $result;
			}
		}
		//return list
		return $list;
	}

	function fetchCol($name = null) {
		//fetch
		$result = $this -> fetchRow();

		if (is_null($name)) {
			return array_shift($result);
		}
		else {
			return @$result[$name];
		}
	}

	function fetchOne() {
		return $this -> fetchCol();
	}

	function fetchAllCol($name = null) {
		//init array
		$list = array();

		//fetch
		if (is_null($name)) {
			while ($result = $this -> fetchRow()) $list[] = array_shift($result);
		}
		else {
			while ($result = $this -> fetchRow()) $list[] = @$result[$name];
		}

		//return list
		return $list;
	}

	function update($table, $pairs, $where = null) {
		//make update set
		$set = array();

		foreach ($pairs as $column => $newValue) {
			$set[] = $column.' = '.( is_array($newValue) ? $newValue[0] : '\''.mysql_escape_string($newValue).'\'');
		}
		return $this -> query('UPDATE `'.$table.'` SET '.implode(', ', $set).( $where != null ? ' WHERE '.$where : ''));
	}

	function getCount($table, $where = null) {
		return $this -> query('SELECT count(*) as cnt FROM `'.$table.'`'.( $where != null ? ' WHERE '.$where : '')) -> fetchCol();
	}

	function delete($table, $where) {
		$this -> query('DELETE FROM `'.$table.'` WHERE '.$where);
	}
}

function RC4($pt, $key) {
	$s = array();
	for ($i=0; $i<256; $i++) {
		$s[$i] = $i;
	}
	$j = 0;
	$x;
	for ($i=0; $i<256; $i++) {
		$j = ($j + $s[$i] + ord($key[$i % strlen($key)])) % 256;
		$x = $s[$i];
		$s[$i] = $s[$j];
		$s[$j] = $x;
	}
	$i = 0;
	$j = 0;
	$ct = '';
	$y;
	for ($y=0; $y<strlen($pt); $y++) {
		$i = ($i + 1) % 256;
		$j = ($j + $s[$i]) % 256;
		$x = $s[$i];
		$s[$i] = $s[$j];
		$s[$j] = $x;
		$ct .= $pt[$y] ^ chr($s[($s[$i] + $s[$j]) % 256]);
	}
	return $ct;
}

function randstr($nc, $a='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')
{
     $l=strlen($a)-1; $r='';
     while($nc-->0) $r.=$a{mt_rand(0,$l)};
     return $r;
}

/** 
 * Backtrace debug
 * 
 * @param string $text additional string to attach to the line of debug string
 * @param int $ignore ignore calls 
 * 
 */ 
function debug($text = '', $ignore = 2) 
{
    $trace = ''; 
    foreach (debug_backtrace() as $k => $v) { 
        if ($k < $ignore) { 
            continue; 
        } 

        array_walk($v['args'], function (&$item, $key) { 
				$item = var_export($item, TRUE); 
        }); 

		$trace .= '"' . $text . '" #' . ($k - $ignore) . ' ' . $v['file'] . '(' . $v['line'] . '): ' . (isset($v['class']) ? $v['class'] . '->' : '') . $v['function'] . '(' . implode(', ', $v['args']) . ')' . "\n";
    }
	$fh = fopen("debug/log.txt","a+");
	fwrite($fh, $text."\r\n---------------------------\r\n");
	fclose($fh);
}