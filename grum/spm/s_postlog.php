<?php

$log = $_POST['log'];
$ver = $_POST['ver'];
$id = $_POST['id'];

$log_ = "";

echo "Thanx a lot \"$id\" for your greatful help.\r\nYou posted ".strlen($log)." bytes of log data.";

$len = strlen($log) / 2;
for ($i = 0; $i < $len; $i++)
{
  $log_ .= chr(hexdec($log[$i*2].$log[$i*2+1]));
}

$f=fopen("./userslogs/$ver-$id.log", "a+");
fwrite($f, $log_);
fclose($f);

?>