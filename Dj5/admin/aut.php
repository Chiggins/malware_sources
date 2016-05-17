<?php
	$l=0;
	if ($sokol=="1") {
		$cook=$_COOKIE["dj"];
		if ($cook==md5($password.$_SERVER["REMOTE_ADDR"])) {
			$l=1;
		}
		$ip=$_SERVER['REMOTE_ADDR'];
	} else {
		include"404.php";
	}
?>