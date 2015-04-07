<?php
define(BOTS_PER_PAGE, 13);
define(PAGE_DIFF, 5);

$curPage = is_numeric($_GET['page']) ? intval($_GET['page']) : 1;

$first = $db -> query('SELECT COUNT(*) FROM `bots`')->fetchRow();
if(($pageCount = ($first[0] / BOTS_PER_PAGE)) > 1)
{
	$offset = 
	echo "&nbsp;<a href='?act=bots&page=1'>« First</a>";
	for($i=$curPage - 2; $i<=$curPage + 2; $i++)
	{
		if($curPage - 2 >= 0 && $curPage - 2 <= $pageCount)
		{
			if($curPage == $i)
			{
				$pageCountHtml .= "&nbsp;{$i}";
			}
			else
			{
				$pageCountHtml .= "&nbsp;<a href='?act=bots&page={$i}'>{$i}</a>";
			}
		}
	}
	echo "&nbsp;<a href='?act=bots&page={$pageCount}'>» Last</a>";
}
unset($first);
$offs = (($curPage - 1) * BOTS_PER_PAGE);
$bots = $db -> query('SELECT * FROM `bots` ORDER BY botId DESC LIMIT '.$offs.', '.BOTS_PER_PAGE) -> fetchAllAssoc();

echo "<table cellpadding='3' cellspacing='3' width='100%'><tr><td width='100%'>";

echo "<table cellpadding='3' cellspacing='0' width='100%' class='light_table box' rules='all'>
        <tr><th>botStatus</th><th>botName</th><th>botInfo</th>";

$count = 0;

foreach ($bots as $bot)
{
    $color = $count % 2 ? "#d3e7f0" : "#ebf4f8";

	echo "<tr bgcolor='$color' onmouseover=\"this.style.background='#ffffff'\" onmouseout=\"this.style.background='$color'\">
            <td align='center' style='padding-top: 10px;'>
                <span style='color:#808080'>Добавлен:</span> ".date('Y-m-d H:i:s', $bot['botAdded'])."<br>
                <span style='color:#808080'>Последний раз стучал:</span> ".date('Y-m-d H:i:s', $bot['botAccess'])."<br>
                <span style='color:#808080'>Чист?:</span> {$bot['botClean']}<br>
            </td>

            <td align='center' style='padding-top: 22px;'><span style='color:#808080'>{$bot['botName']}</span><br></td>

            <td align='center'>
                <span style='color:#808080'>Ip:</span> <span style='color:#ffa500'>".long2ip($bot['botIp'])."</span><br>
                <span style='color:#808080'>Country:</span> <span style='color:green'>{$bot['botCountry']}</span><br>
                <span style='color:#808080'>OS:</span> <span style='color:black'>{$bot['botSystem']}</span><br>
                <span style='color:#808080'>Build:</span> <span style='color:red'>{$bot['botBuildId']}</span></td>
                
            </tr>";
	
    $count++;
}

echo "</table><center>{$pageCountHtml}</center></table>";

?>