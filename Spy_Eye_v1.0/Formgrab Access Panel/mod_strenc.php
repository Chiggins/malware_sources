<?php

function ucs2html($str) {
	$str=trim($str); // if you are reading from file
	$len=strlen($str);
	$html='';
	for($i=0;$i<$len;$i+=2)
		$html.='&#'.hexdec(dechex(ord($str[$i+1])).
	sprintf("%02s",dechex(ord($str[$i])))).';';
	return($html);
}

?>