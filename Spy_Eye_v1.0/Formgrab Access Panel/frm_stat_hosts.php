<script type="text/javascript">
    var GB_ROOT_DIR = "js/greybox/";
</script>

<script type="text/javascript" src="js/greybox/AJS.js"></script>
<script type="text/javascript" src="js/greybox/AJS_fx.js"></script>
<script type="text/javascript" src="js/greybox/gb_scripts.js"></script>
<link href="js/greybox/gb_styles.css" rel="stylesheet" type="text/css" />

<?

$repdateday = $_POST['repdateday'];
if ( ( !isset($repdateday) ) || !strlen($repdateday) ) {
	echo '<b>ERROR</b> : repdateday is empty';
	exit;
}
list($day, $month, $year) = split('[ :\/.-]', $repdateday);
$tstamp = gmmktime (0, 0, 0, $month, $day, $year);
$dt = gmdate('Ymd', $tstamp);

$limit = intval($_POST['limit']);
if ($limit <= 0) {
	$limit = 100;
}

$sql = "SELECT LEFT(SUBSTR(func_data, LOCATE('//', func_data) + 2), LOCATE('/', SUBSTR(func_data, LOCATE('//', func_data) + 2)) - 1) AS host, COUNT(*) AS cnt"
	 . "  FROM rep2_$dt"
	 . " GROUP BY host"
	 . " ORDER BY cnt DESC"
	 . " LIMIT $limit";
?>

<script type="text/javascript"> 
function cc(id, color) { // "cc" = changeColor
	var el = document.getElementById(id).style;
	var cols = '' + el.backgroundColor;
	(cols.indexOf('204') == -1) ? el.backgroundColor = '#cce7ef' : el.backgroundColor = color; 
}
</script>

<table width='730' border='1' cellspacing='0' cellpadding='3' style='border: 1px solid #BBBBBB; font-size: 9px; border-collapse: collapse; background-color: #4992a7;'>

<th style=' color: #EEEEEE;'>host</th>
<th style=' color: #EEEEEE;'>count</th>  
<th style=' color: #EEEEEE;'>[controls]</th>  

<script type="text/javascript"> 
function onclickBanHost(host) {
	host = prompt('Do you really want to ban this host ?', '/' + host + '/');
	if (!host) return false;
	GB_show('Ban host', '../../mod_hostban_add.php?host=' + host, 470, 550);
	return false;
}
</script>

<?

require_once 'mod_file.php';
require_once 'mod_time.php';
require_once 'mod_dbase.php';

$dbase = db_open();

$res = mysqli_query($dbase, $sql);
if (!(@($res))) {
	writelog("error.log", "Wrong query : \" $sql \"");
	db_close($dbase);
	return 0;
} 

$i = 0;
while ( list($host, $cnt) = mysqli_fetch_row($res) ) {
	echo "<tr id='tr$i' align='center' valign='middle' style=' background-color: #cce7ef; ' onclick='cc(this.id, \"#ffc946\");'>";
	echo "<td>$host</td>";
	echo "<td>$cnt</td>";
	echo "<td>";
	echo "<a href='#null' onclick=\"return onclickBanHost('$host');\"><img src='img/ban.png' border='0' title='Ban this host'></a>";
	echo "<a href='#null' onclick=\"if (!confirm('Do you really want to delete all records of this host ( $host ) from database?')) return false; GB_show('Delete host', '../../mod_hostdelete.php?host=$host', 450, 550); return false;\"><img src='img/delete.png' border='0' title='Delete this host'></a>";
	echo "</td>";
	echo '</tr>';
	$i++;
}
db_close($dbase);

?>

</table>