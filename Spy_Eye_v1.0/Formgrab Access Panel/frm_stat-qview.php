<table cellspacing="0" cellpadding="0" border="0" width="100px" height="50px">
<tr>
	<td width="39px" style='background: url("img/p-stat-p1.png"); background-repeat: no-repeat;' title="Total reports and Today reports"></td>
	<td width="61px" style='background: url("img/p-stat-p2.png"); background-repeat: no-repeat;' id='bstat' title="Total reports and Today reports"></td>
</tr>
</table>

<script type="text/javascript" src="js/ajax.js"></script>

<script type="text/javascript" defer>
function setStat (stat) {
	el = document.getElementById('bstat');
	val = '<center>' + stat + '</center>';
	el.innerHTML = val;
}
function setStatAjax () {
	ajax_load('mod_stat-qview.php', ':restofunc:', setStat);
<?php
	$icfg = parse_ini_file('config.ini');
	$ajaxre = $icfg['ajax_panel_autoreload'];
	if (intval($ajaxre) == 1) {
		echo "	setTimeout(setStatAjax, 3000);\n";
	}
?>
}
setStatAjax();
</script>