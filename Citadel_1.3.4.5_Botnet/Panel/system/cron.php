<?php
/* environment */
define('DIRECT_EXECUTION', realpath(__FILE__) == realpath($_SERVER['SCRIPT_FILENAME'])); # realpath(cron.php) gives NULL when executed after chdir(). So, do it here.
chdir(dirname(__FILE__).'/..');

/* citadel */
require_once('system/global.php');
require_once('system/config.php');

/* errors */
set_time_limit(60*60);
ignore_user_abort(true);
error_reporting(E_ALL);
ini_set('display_errors', 1); # we still need to see them
ini_set('html_errors', (php_sapi_name() == 'cli')? 0 : 1);

/* cron */
require_once 'system/lib/cronjobsman.php';

$cron = new CronJobsMan('system/data/cron.dat');
foreach (array('users', 'reports_dedup', 'files', 'scripts', 'iframer', 'filehunter') as $jobs_file)
	if (file_exists($f = "system/cron/$jobs_file.php")){
		require_once $f;
		$cls = "cronjobs_{$jobs_file}";
		$cron->register(new $cls);
		}

/* direct execution */
if (!DIRECT_EXECUTION)
	return $cron; # let 'em use it

/* citadel */
if(!connectToDb())
	die(mysqlErrorEx());

/* manual interface */
list($manual_job, $manual_args) = CronJobsMan::manual_interface();
if (is_null($manual_job))
	define('SILENT_MODE', false);
	elseif  ($manual_job === 'cron')
	define('SILENT_MODE', true);
	else {
	$report = $cron->manual_run($manual_job, $manual_args);
	if ($report->exception)
		throw new Exception($report->fullname, 0, $report->exception);
	if ($report->error)
		trigger_error($report->fullname.': '.$report->error, E_USER_WARNING);
	if (!is_null($report->result))
		print json_encode($report->result);
	return;
	}

/* run all cron jobs */
$results = array();
for ($i=0; $i<100; $i++){ # just in case
	$report = $cron->run_next();
	if (is_null($report))
		break;
	$results[ $report->fullname ] = $report->result;
	}

/* results */
if (!SILENT_MODE)
	print json_encode($results);
