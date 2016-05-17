<?php if(!defined('__CP__'))die();
define('LNG_SYS', 'Options');

define('LNG_SYS_REPORTS',      'Reports');
define('LNG_SYS_REPORTS_PATH', 'Local path:');
define('LNG_SYS_REPORTS_TODB', 'Write reports to database.');
define('LNG_SYS_REPORTS_TOFS', 'Write reports to local path.');
define('LNG_SYS_REPORTS_GEOIP', 'Always-on GeoIP (high load, but is required for country-based script targeting)');

define('LNG_SYS_BOTNET',          'Botnet');
define('LNG_SYS_BOTNET_TIMEOUT',  'Timeout of online status (minutes):');
define('LNG_SYS_BOTNET_CRYPTKEY', 'Encryption key:');

define('LNG_SYS_ALLOWED_COUNTRIES',  'Allowed Countries');
define('LNG_SYS_ALLOWED_COUNTRIES_ENABLED',  'Filtering enabled');

define('LNG_SYS_FEATURES', 'Features');
define('LNG_SYS_FEATURES_REPORTS_DEDUPLICATION', 'Reports deduplication');

define('LNG_SYS_JABBER_BOT', 'Jabber bot');
define('LNG_SYS_JABBER_BOT_USER', 'Login');
define('LNG_SYS_JABBER_BOT_PASS', 'Password');
define('LNG_SYS_JABBER_BOT_HOST', 'Host[:port]');

define('LNG_SYS_E1', 'Bad format of local path for reports.');
define('LNG_SYS_E2', 'Bad format of timeout for botnet.');
define('LNG_SYS_E3', 'Bad format of encryption key for botnet.');
define('LNG_SYS_E4', 'Failed to update configuration file.');

define('LNG_SYS_SAVE', 'Save');

define('LNG_SYS_UPDATED', 'Options successfully updated.');
?>