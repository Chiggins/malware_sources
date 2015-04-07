<?php
 
class RC4 {
   
	var $s = array();
	var $x;
	var $y;
	var $staticKey;
   
	function key($key) {
   
		$this->x = 1;
		$this->y = 0;
		$len = strlen($key);
		for ($i = 0; $i < 256; $i++) {
			$this->s[$i] = $i;
		}
	   
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
   
?>