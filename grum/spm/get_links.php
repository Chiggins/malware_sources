<?php


$LinksName = $_GET['links'];

$links = file_get_contents('links/'.$LinksName.'.txt');
$LinksPerMessage = file_get_contents('links/'.$LinksName.'.txt.lpm');
$Timeout = file_get_contents('links/'.$LinksName.'.txt.tmt');

$count=0;
$lnk = array();

while (strpos($links, "\r\n") > 0) {
  $lnk[$count] = substr($links, 0, strpos($links, "\r\n"));
  $pos = strpos($links, "\r\n");
  $pos = $pos + strlen("\r\n");
  $links = substr($links, $pos);
  $count++;
}
if (strlen($links) > 0) {
  $lnk[$count] = $links;
  $count++;
}

$groups = round($count/$LinksPerMessage);
$start = round(time()/$Timeout)%$groups;

for ($i=0;$i<$LinksPerMessage;$i++)
  echo $lnk[$i+$start*$LinksPerMessage]."\r\n";
?>
