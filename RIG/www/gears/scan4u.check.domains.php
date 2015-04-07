<?php

//This script will check domain from file active.txt, and if it failed on same AV will replace it with some clean from domains.txt file.

$s4y_id = "13350";
$s4y_token = "4f77dcbd7ea525982fb8";
$f_a=dirname(__FILE__).'/active.txt';		// file with active clean domain
$f_s=dirname(__FILE__).'/domains.txt';		// file with list of domains
$disable='';					// Disable AV
$enable='';					// Enable AV
$debug=0;					// If you have problem set it to 1;
error_reporting(E_ALL ^ E_NOTICE);

function s4t_check($file){
    global $debug;
    $url=s4t_get_url();
    if(!$url) return 'ERROR:cant get s4y url';
    if($url == 'FAIL') return 'ERROR:cant get s4y url';
    $type='domain'; $format='txt';
    global $s4y_id, $s4y_token, $disable,$enable;
    $post=array('id'=>$s4y_id,'token'=>$s4y_token,'action'=>$type);
    if($disable) $post['av_disable']=$disable;
    if($enable) $post['av_enabled']=$enable;
//    $post['uppload']='@'.$file;
    $post[$type]=$file;
    $c=curl_init();
    curl_setopt_array($c,array(CURLOPT_HEADER=>0,CURLOPT_VERBOSE=>0,CURLOPT_RETURNTRANSFER=>true,
        CURLOPT_URL=>$url,CURLOPT_TIMEOUT=>35,CURLOPT_POST=>true,CURLOPT_POSTFIELDS=>$post));
    $r = curl_exec($c);
    if ($debug) echo "DEBUG: get from host $r\n\n";
    if($r===false) return 'ERROR:'.curl_error($c);
    if(curl_getinfo($c,CURLINFO_HTTP_CODE) != 200) return 'ERROR:'.curl_error($c);
    return $r;
}

function s4t_get_url(){
    global $s4t_url, $debug;
    if($s4t_url) return $s4t_url;
    $us = explode('|','scan4you.net|scan4you.org|85.31.101.187|85.31.101.148');
    foreach ($us as $v){
	if ($debug) echo "DEBUG: try $v domain\n";
        $c=curl_init();
        curl_setopt_array($c,array(CURLOPT_HEADER=>0,CURLOPT_VERBOSE=>0,CURLOPT_RETURNTRANSFER=>true,
            CURLOPT_URL=>"http://$v/z325.txt",CURLOPT_TIMEOUT,5));
        $r=curl_exec($c);
        curl_close($c);
        if($r=='qga34'){
            $s4t_url="http://$v/remote.php";
	    if ($debug) echo "DEBUG: $v domain is working\n";
            return $s4t_url;
        }
    }
    die("can`t find s4y server");
}

function is_ok($o){
    $o=trim($o);
    if(!$o) return '';
    $r=s4t_check($o);
    if(!$r) return;
    $f=0;
    foreach (explode("\n",$r) as $v){
        list($a,$x) = explode(':',$v,2);
        if($a=='ERROR') die($v);
        if(!$a) continue;
        if($x!='OK')$f++;
        $t++;
    }
    if($t<3||$t>40) die('Strange responce :'.$r);
    if($f) return 0;
    return 1;
}

function w($f,$d){
    file_put_contents($f,$d)||die("can`t write to $f, check permisions\n");
}

if ($debug) echo "DEBUG: Start\n";
$ad=@file_get_contents($f_a);
if($ad&&is_ok($ad)) exit;
$d=@file($f_s);
if(!is_array($d)) $d=array();
if ($debug) echo "DEBUG: ".count($d)." domains\n";
while(count($d)>0){
    $cd = array_shift($d);
    if ($debug) echo "DEBUG: Try to check $cd\n";
    if($cd&&is_ok($cd)){
        w($f_a,trim($cd));
        w($f_s,implode('',$d));
        exit;
    }
}
die("no more clean domains in $f_s\n");
