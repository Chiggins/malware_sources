<?php if(!defined('__CP__'))die();

require_once 'system/lib/guiutil.php';

$os = php_uname('s').' '.php_uname('r').' '.php_uname('v').', '.php_uname('m');
$php = phpversion().', '.php_sapi_name();
$dir = dirname($_SERVER['SCRIPT_FILENAME']);

ThemeBegin(LNG_SYS, 0, 0, 0);
echo
str_replace('{WIDTH}', 'auto', THEME_LIST_BEGIN).

//Версии ПО.
str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, LNG_SYS_VERSIONS), THEME_LIST_TITLE).
  THEME_LIST_ROW_BEGIN.
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', 'Operation system:'),                              THEME_LIST_ITEM_LTEXT_U1).
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', htmlEntitiesEx($os)),                              THEME_LIST_ITEM_LTEXT_U1).
  THEME_LIST_ROW_END.
  THEME_LIST_ROW_BEGIN.
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', 'Control panel:'),                                 THEME_LIST_ITEM_LTEXT_U2).
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', htmlEntitiesEx(BO_CLIENT_VERSION)),                THEME_LIST_ITEM_LTEXT_U2).
  THEME_LIST_ROW_END.
  THEME_LIST_ROW_BEGIN.
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', 'PHP:'),                                           THEME_LIST_ITEM_LTEXT_U1).
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', htmlEntitiesEx($php)),                             THEME_LIST_ITEM_LTEXT_U1).
  THEME_LIST_ROW_END.
  THEME_LIST_ROW_BEGIN.
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', 'Zend engine:'),                                   THEME_LIST_ITEM_LTEXT_U2).
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', htmlEntitiesEx(zend_version())),                   THEME_LIST_ITEM_LTEXT_U2).
  THEME_LIST_ROW_END.
  THEME_LIST_ROW_BEGIN.
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', 'MySQL server:'),                                  THEME_LIST_ITEM_LTEXT_U1).
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', htmlEntitiesEx(mysql_get_server_info())),          THEME_LIST_ITEM_LTEXT_U1).
  THEME_LIST_ROW_END.
  THEME_LIST_ROW_BEGIN.
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', 'MySQL client:'),                                  THEME_LIST_ITEM_LTEXT_U2).
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', htmlEntitiesEx(mysql_get_client_info())),          THEME_LIST_ITEM_LTEXT_U2).
  THEME_LIST_ROW_END.

//Пути.
str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, LNG_SYS_PATHS), THEME_LIST_TITLE).
  THEME_LIST_ROW_BEGIN.
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', 'Local path:'),                                    THEME_LIST_ITEM_LTEXT_U1).
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', htmlEntitiesEx($dir)),                             THEME_LIST_ITEM_LTEXT_U1).
  THEME_LIST_ROW_END.
  THEME_LIST_ROW_BEGIN.
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', 'Reports path:'),                                  THEME_LIST_ITEM_LTEXT_U2).
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', htmlEntitiesEx($dir.'/'.$config['reports_path'])), THEME_LIST_ITEM_LTEXT_U2).
  THEME_LIST_ROW_END.

//Клиент.
str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, LNG_SYS_CLIENT), THEME_LIST_TITLE).
  THEME_LIST_ROW_BEGIN.
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', 'User agent:'),                                    THEME_LIST_ITEM_LTEXT_U1).
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', htmlEntitiesEx($_SERVER['HTTP_USER_AGENT'])),      THEME_LIST_ITEM_LTEXT_U1).
  THEME_LIST_ROW_END.
  THEME_LIST_ROW_BEGIN.
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', 'IP:'),                                            THEME_LIST_ITEM_LTEXT_U2).
    str_replace(array('{WIDTH}', '{TEXT}'), array('auto', htmlEntitiesEx($_SERVER['REMOTE_ADDR'])),          THEME_LIST_ITEM_LTEXT_U2).
  THEME_LIST_ROW_END;

// CronJobs stat
echo str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(2, LNG_SYS_CRON_JOBS), THEME_LIST_TITLE);
echo '<tr><td colspan="2">';

$CRON = require 'system/cron.php'; /** @var CronJobsMan $CRON */

echo '<pre id="crontab">'.$CRON->crontab('system/cron.php', 'cron').'</pre>';

echo '<table id="cronjobs">';
foreach ($CRON->get_jobs() as $fullname => $job){ /** _CronJobMethod $job */
	echo '<tr>';
	echo '<td>', '<a href="system/cron.php/', $fullname, '?" target="_blank">', $fullname, '</a></td>';
	if (is_null($job->meta))
		echo '<td colspan=4>', LNG_SYS_CRON_JOB_NEVER, '</td>';
		else {
		echo '<td>',
			$job->meta->running? '(<i>'. LNG_SYS_CRON_JOB_RUNNING .'</i>)' : '',
			'</td>';
		echo '<td>',
				is_null($job->meta->last_error)
							? htmlspecialchars(json_encode($job->meta->last_result))
							: '<div class="error">'.htmlspecialchars($job->meta->last_error).'</div>',
				'</td>';
		$execs = $job->meta->exec_count;
		if ($execs>1000000) $execs = round($execs/1000000,1).'m';
		elseif ($execs>1000) $execs = round($execs/1000,1).'k';
		echo '<td>', $execs, ' ', LNG_SYS_CRON_JOB_TIMES, '</td>';
		echo '<td>',
			'<small>', timeago(time()-$job->meta->exec_last), '</small>',
			'</td>';
		}
	echo '<td>',
		'<small>', htmlspecialchars($job ? $job->get_description() : '?'), '</small>',
		'</td>';
	}
echo '<tr><td colspan="5"><a href="system/cron.php" target="_blank">All</a></td></tr>';
echo '</table>';

echo '</tr></td>';

echo THEME_LIST_END;
ThemeEnd();
