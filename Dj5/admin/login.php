<?
	include"core.php";
	include"config.php";
	if (($_POST['login']=='') and ($_POST['pass']=='')) {
		include"404.php";
	}
	if(($_POST['login']==$login) and ($_POST['pass']==$password)) {

		setcookie("dj",md5($password.$_SERVER["REMOTE_ADDR"]), time()+8640000);
		echo '<meta http-equiv="REFRESH" CONTENT="0;URL=admin.php?login='.$GET_login.'">';	
	} else {
		include"404.php";	
	}

?>