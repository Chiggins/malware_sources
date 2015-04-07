<?php

echo "<div style='padding: 20px'>  <div style='margin-bottom: 20px'>
        <a class='razdel' href='?act=stats'>Общая статистика</a>
        <a class='razdel' href='act/cron.php'>Обновить статистику вручную</a>
      </div>";

$s = $db -> query("SELECT * FROM daily");
if(!$s) mysql_error($s);
$s = $s->fetchAllAssoc('dayBuildId');

if (isset($_POST['tBuild']) && $_POST['tBuild'] != 'all') $BuildId = $_POST['tBuild']; else $BuildId = "";

echo "<form action='?act=stats' method='post' enctype='multipart/form-data'>
            <table cellpadding='3' cellspacing='3' width='100%'>
                <tr>
                    <td class='td_col_zag' width='30%'>Билд</td>
                    <td class='td_col_list' width='70%'>";

                        $str = "<option value='$BuildId'>$BuildId</option><option value='all'>all</option>";
                        if ($BuildId == "") $str = "<option value='all'>all</option>";

                        echo "<select name='tBuild'>$str";

                        foreach ($s as $b => $d) if ($BuildId != $b) echo "<option value='$b'>$b</option>";

echo "                  </select>&nbsp;<input type='submit' value='Показать' name='fAdd'>
                    </td>
                </tr>
            </table>
      </form><br>";

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$BuildStr = $BuildId ? "WHERE dayBuildId = '$BuildId'" : "";

$stats = $db->query("SELECT dayDate, SUM(dayBotsOnline) as dayBotsOnline,
                        SUM(dayBots) as dayBots,
                        SUM(dayBotsDead) as dayBotsDead,
                        SUM(dayBotsMaxOnline) as dayBotsMaxOnline,
                        SUM(dayBotsMinOnline) as dayBotsMinOnline,
                        SUM(dayBotsNew) as dayBotsNew,
                        SUM(dayBotsLifeTime) as dayBotsLifeTime,
                        SUM(dayBotsNetTime) as dayBotsNetTime
                     FROM daily $BuildStr GROUP BY (dayDate) ORDER BY dayDate DESC")->fetchAllAssoc();

$s = $stats[0];

$NowBots = $s['dayBots'];
$dayBotsOnline = $s['dayBotsOnline'];
$dayBotsAlive = $s['dayBots'] - $s['dayBotsDead'];
$dayBotsDead = $s['dayBotsDead'];
$dayBotsNew = $s['dayBotsNew'];

$dayBotsOnlineP = percent($dayBotsOnline, $NowBots);
$dayBotsAliveP = percent($dayBotsAlive, $NowBots);
$dayBotsDeadP = percent($dayBotsDead, $NowBots);
$dayBotsNewP = percent($dayBotsNew, $NowBots);

echo "<div align='center' style='margin-bottom: 20px'>
            Ботов: <span class='zagolovok'>$NowBots</span>&nbsp;&nbsp;
	        <span style='color:green'>Живые: </span><span class='zagolovok' style='color:green'>$dayBotsAlive ($dayBotsAliveP%)</span>&nbsp;&nbsp;
	        <span style='color:#808080;'>Мертвые: </span><span class='zagolovok' style='color:#808080;'>$dayBotsDead ($dayBotsDeadP%)</span>&nbsp;&nbsp;
	        <span style='color:#ffa500'>Онлайн: </span><span class='zagolovok' style='color:#ffa500'>$dayBotsOnline ($dayBotsOnlineP%)</span>&nbsp;&nbsp;
	        Новые: <span class='zagolovok'>$dayBotsNew ($dayBotsNewP%)</span>&nbsp;&nbsp;
	  </div>";

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

echo "<table cellpadding='3' cellspacing='3' width='100%'><tr><td width='100%'>";

echo "<table cellpadding='3' cellspacing='0' width='100%' class='light_table box' rules='all'>
            <tr>
                <th>Дата</th>
                <th>Кол-во* (% от ботнета тогда)</th>
                <th>Ср. время жизни**</th>
                <th>% отмирания в месяц</th>
            </tr>";

$count = 0;

foreach ($stats as $s)
{
    $bots = $s['dayBots'];
    $botsDead = $s['dayBotsDead'];
    $botsAlive = $bots - $botsDead;
    $botsSrOnline = round(($s['dayBotsMaxOnline'] + $s['dayBotsMinOnline']) / 2, 2);
    $botsNew = $s['dayBotsNew'];

    $botsAlivePT = percent($botsAlive, $bots);
    $botsDeadPT = percent($botsDead, $bots);
    $botsSrOnlinePT = percent($botsSrOnline, $bots);
    $botsNewPT = percent($botsNew, $bots);

    $srLifeTime = round($s['dayBotsLifeTime'] / $bots, 2);
    $srBotNetTime = round($s['dayBotsNetTime'] / $bots, 2);
    $ovm = round((((($s['dayBotsNetTime'] / $bots) * $s['dayBotsDead']) / $bots) / 30) * 100, 2);

    $color = $count % 2 ? "#d3e7f0" : "#ebf4f8";

    echo "<tr bgcolor='$color' onmouseover=\"this.style.background='#ffffff'\" onmouseout=\"this.style.background='$color'\">
                <td align='center'><b>{$s['dayDate']}</b></td>
                <td align='center'>$bots /
                    <span style='color:green;'>$botsAlive ($botsAlivePT%)</span> /
                    <span style='color:#808080;'>$botsDead ($botsDeadPT%)</span> /
                    <span style='color:#ffa500;'>$botsSrOnline ($botsSrOnlinePT%)</span> / $botsNew ($botsNewPT%)</td>
                <td align='center'>$srLifeTime д. / $srBotNetTime д.</td>
                <td align='center'>$ovm%</td>
          </tr>";

    $count++;
}

echo "<tr style='background:#ffffff !important;'><th colspan='4'>&nbsp;</th></tr></table>";

echo "<small>*<i>« всего / <span style='color:green'>живые</span> / <span style='color:#808080'>мертвые</span> / <span style='color:#ffa500'>ср. онлайн</span> / новые »</i></small><br>
      <small>**<i>«среднее кол-во дней жизнеспособности ботов / среднее кол-во дней существования ботов»</i></small><br><br>";

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

echo "</td></tr><tr><td width='100%'>";

GetStatsByField('statBuildId');

echo "</td></tr><tr><td width='100%'>";

GetStatsByField('statSystem');

echo "</td></tr><tr><td width='100%'>";

GetStatsByField('statCountry');

echo "</td></tr></table>";

//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function GetStatsByField($fieldName)
{
    global $db, $NowBots, $BuildId;

    $BuildStr = $BuildId ? "WHERE statBuildId = '$BuildId'" : "";

    $stats = $db->query("SELECT $fieldName,
                        SUM(statBots) as statBots,
                        SUM(statBotsOnline) as statBotsOnline,
                        SUM(statBotsDead) as statBotsDead,
                        SUM(statBotsLifeTime) as statBotsLifeTime,
                        SUM(statBotsNetTime) as statBotsNetTime
                     FROM stats $BuildStr GROUP BY ($fieldName)")->fetchAllAssoc();

echo "<table cellpadding='3' cellspacing='0' width='100%' class='light_table box' rules='all'>
        <tr>
            <th>$fieldName</th>
            <th>Кол-во* (% от ботнета сейчас)</th>
            <th>Ср. время жизни **</th>
            <th>% отмирания в месяц</th>
        </tr>";

$count = 0;

foreach ($stats as $s)
{
    $bots = $s['statBots'];
    $botsDead = $s['statBotsDead'];
    $botsAlive = $bots - $botsDead;
    $botsSrOnline = $s['statBotsOnline'];

    $botsPC = percent($bots, $NowBots);
    $botsAlivePC = percent($botsAlive, $NowBots);
    $botsDeadPC = percent($botsDead, $NowBots);
    $botsSrOnlinePC = percent($botsSrOnline, $NowBots);

    $srLifeTime = round($s['statBotsLifeTime'] / $bots, 2);
    $srBotNetTime = round($s['statBotsNetTime'] / $bots, 2);
    $ovm = round((((($s['statBotsNetTime'] / $bots) * $s['statBotsDead']) / $bots) / 30) * 100, 2);

    $color = $count % 2 ? "#d3e7f0" : "#ebf4f8";

    echo "<tr bgcolor='$color' onmouseover=\"this.style.background='#ffffff'\" onmouseout=\"this.style.background='$color'\">
                <td align='center'><b>{$s[$fieldName]}</b></td>
                <td align='center'>$bots ($botsPC%) /
                    <span style='color:green;'>$botsAlive ($botsAlivePC%)</span> /
                    <span style='color:#808080;'>$botsDead ($botsDeadPC%)</span> /
                    <span style='color:#ffa500;'>$botsSrOnline ($botsSrOnlinePC%)</span></td>
                <td align='center'>$srLifeTime д. / $srBotNetTime д.</td>
                <td align='center'>$ovm%</td>
          </tr>";
    
    $count++;
}

echo "<tr style='background:#ffffff !important;'><th colspan='4'>&nbsp;</th></tr></table>";

echo "<small>*<i>« всего / <span style='color:green'>живые</span> / <span style='color:#808080'>мертвые</span> / <span style='color:#ffa500'>онлайн</span> »</i></small><br>
      <small>**<i>«среднее кол-во дней жизнеспособности ботов / среднее кол-во дней существования ботов»</i></small><br><br>";
}

?>

