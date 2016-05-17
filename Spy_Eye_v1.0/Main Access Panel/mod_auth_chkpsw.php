<?php

$pass = $_GET['password'];
setcookie ("password", $pass, time() + 60*60*24);

require_once 'mod_auth.php';
if (isauth($pass)) {
	echo "Your password is <font class='ok'>OK</font>\n";
	echo "<script type='text/javascript'>document.location = 'index.php?r=" . rand() . "';</script>\n";
}
else {
	echo "<font class='error'>Wrong password</font>\n";
}


?>