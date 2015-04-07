<?
if (!isset($_SERVER['PHP_AUTH_USER'])) {
header("WWW-Authenticate: Basic realm=\"Autorisation\"");
header("HTTP/1.0 401 Unauthorized");
exit;
} else {
$vxod = "0";
if (($_SERVER['PHP_AUTH_USER'] == "admin") && (md5($_SERVER['PHP_AUTH_PW']) === "21232f297a57a5a743894a0e4a801fc3")) {
$vxod = "1";
}
if ($vxod == "0") {
echo "Ne pravilnii login ili parol!";
exit;
}
}
?>