<table cellspacing="0" cellpadding="0" border="0" width="100px" height="50px">
<tr>
	<td width="39px" style='background: url("img/p-clock-p1.png"); background-repeat: no-repeat;' title="Server's time"></td>
	<td width="61px" style='background: url("img/p-clock-p2.png"); background-repeat: no-repeat;' id='time' title="Server's time"></td>
</tr>
</table>

<script type="text/javascript" src="js/ajax.js"></script>

<script type="text/javascript">
function setTime (time) {
	year = time.substr(0, 4);
	month = time.substr(4, 2);
	day = time.substr(6, 2);
	hour = time.substr(8, 2);
	min = time.substr(10, 2);
	sec = time.substr(12, 2);
	
	el = document.getElementById('time');
	val = '<font style="font-size: 8px;">';
	val += '<center>';
	val += '<b>' + year + '<br>' + month + '/' + day + '<br>' + hour + ':' + min + ':' + sec + '</b>';
	val += '</center>';
	val += '</font>';
	el.innerHTML = val;
}
function setTimeAjax () {
	ajax_load('datetime.php', ':restofunc:', setTime);
<?php
	$icfg = parse_ini_file('config.ini');
	$ajaxre = $icfg['ajax_panel_autoreload'];
	if (intval($ajaxre) == 1) {
		echo "	setTimeout(setTimeAjax, 5000);\n";
	}
?>

}
setTimeAjax();
</script>