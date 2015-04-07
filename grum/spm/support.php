<?php

  function GetCountryInfo($ip)
  {
    $ip = sprintf("%u", ip2long($ip));
    $ci=array('name' => 'Unknown country', 'a2' => 'xx', 'a3' =>'---' );
    $sql="SELECT `country`,`a2`,`a3` FROM `ip2country` WHERE `ipfrom`<=$ip AND `ipto`>=$ip LIMIT 0, 1";
    $query=mysql_query($sql);
    if($row = mysql_fetch_row($query))
    {
      $ci['name']=$row[0];
      $ci['a2']=$row[1];
      $ci['a3']=$row[2];
    }
    return $ci;
  }

  function ip2int($ip) {
    $a=explode(".",$ip);
    return $a[0]*256*256*256+$a[1]*256*256+$a[2]*256+$a[3];
  }

  function CryptData($str,$key) {
    $j = 0;
    $newstr = "";
    for ($i=0; $i < strlen($str); $i++) {
      $symb = ord($str[$i]) ^ ord($key[$j]) + 32;
      $newstr .=  str_pad(dechex($symb), 2, '0', STR_PAD_LEFT);
      $j++;
      if ($j == strlen($key)) $j = 0;
    }
    return strtoupper($newstr);
  }

  function rnd_header($str) {
    global $headers_dir;
    $arrhdr=explode(",",$str);
    $file = $headers_dir.$arrhdr[mt_rand(0,count($arrhdr)-1)];
    while (!file_exists($file)) $file = $headers_dir.$arrhdr[mt_rand(0,count($arrhdr)-1)];
    return $file;
  }

  function get_list($file,$ofile,$count,&$resint) {
    global $lists_dir,$tasks_dir,$status_in_process,$status_in_success;
    $str = "";
    $f=@fopen($lists_dir.$file,"rb");
    if (!$f) return $str;

    $ft = fopen($tasks_dir.$ofile,"ab+");
    if (!$ft) return $str;
    flock($ft,2);
    $c = fread($ft,100);
    fseek($f,$c);
       
   //  $status_in_success = 0;
   //  $status_in_process = 1;

    $resint = $status_in_process;

    for($i=0;$i < $count;$i++) {
      if (feof($f)) {
        $resint = $status_in_success;
        break;
      }
      //------------------
      $str1=fgets($f,150);
      $str1 = str_replace(" ","",$str1);
      $str .= $str1;
      //------------------
      if (feof($f)) {
        $resint = $status_in_success;
        break;
      }
    }
    $offset=ftell($f);
    ftruncate($ft,0);
    fwrite($ft,$offset);
    flock($ft,3);
    fclose($ft);
    fclose($f);
    return $str;
  }

  function index_inc($file,$count) {
    $f = fopen($file,"a+");
    if (!$f) return -1;
    flock($f,2);
    $c = fread($f,100);
    $cc = $c + $count;
    ftruncate($f,0);
    fwrite($f,$cc);
    flock($f,3);
    fclose($f);
    return $c;
  }

?>