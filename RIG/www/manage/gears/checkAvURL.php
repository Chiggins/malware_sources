<?php


include('./checkAvURLCLASS.php');

$checkURL = new checkURL();

$url = parse_url($_POST['proxyURL']);
$path = pathinfo($url['path']);
if (!isset($url['scheme'])) exit(json_encode(array('type'=>'error','msg'=>'Ошибка в имени домена','proxy_id'=>$_POST['proxyURL'])));

//$url = $url['scheme'].'://'.$url['host'].str_replace('//','/',$path['dirname']);
$url = $_POST['proxyURL']; // проверяем целиком
unset($path);

$res = $checkURL->is_ok($url);

exit(json_encode(array('type'=>'success','msg'=>$res['msg'],'f'=>$res['inBan'],'full'=>$res['full'])));

?>