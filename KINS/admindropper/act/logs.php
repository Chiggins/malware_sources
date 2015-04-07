<?php

if (isset($_GET['clear']))
{
	$db -> query('DELETE FROM logs');
}

if (isset($_GET['clearid']))
{
	$db -> query("DELETE FROM logs WHERE logBotName = '{$_GET['clearid']}'");
}

if (isset($_GET['id']))
{

    if (isset($_GET['color']))
    {
        $log = array("logColor" => $_GET['color']);

        $db -> update('logs', $log, "logBotName = '{$_GET['id']}'");
    }
    

    echo "
    <div style='padding: 20px'>  <div style='margin-bottom: 20px'>
    <a	class='razdel' href='?act=logs'>На страницу с логами</a>
    <a	class='razdel' href='?act=logs&clearid={$_GET['id']}'>Очистить логи по боту {$_GET['id']}</a>
    <a	class='razdel' href='?act=logs&id={$_GET['id']}&color=red'>Поменять цвет на красный</a>
    <a	class='razdel' href='?act=logs&id={$_GET['id']}&color=green'>Поменять цвет на зеленый</a>
    </div>";

     echo "<table cellpadding='3' cellspacing='3' width='100%' style=''><tr><td width='30%'>";

    echo "<table cellpadding='3' cellspacing='0' width='100%' class='light_table box' rules='all'>
    <tr><th>Айди</th><th>Текст</th></tr>";

    $colors = $db -> query("SELECT * FROM logs WHERE logBotName='{$_GET['id']}'") -> fetchAllAssoc();
    $db -> freeResult();

    $count = 0;
    $Sum = 0;

    foreach ($colors as $c)
    {
        $color = $count % 2 ? "#d3e7f0" : "#ebf4f8";
        $text = stripslashes(str_replace('\n', "<br>", $c['logText']));

        echo "<tr bgcolor='$color'>
        <td align='center'><font color='{$c['logColor']}'><b>{$c['logId']}</b></font></td>
        <td>$text</td>
        </tr>";

        $Sum += $c['count'];

        $count++;
    }

    echo "</table>";

    echo "</td></tr></table>";
}
else
{

    echo "
    <div style='padding: 20px'>  <div style='margin-bottom: 20px'>
    <a	class='razdel' href='?act=logs'>Обновить</a>
    <a	class='razdel' href='?act=logs&clear'>Очистить все логи</a>
    </div>";

    echo "<table cellpadding='3' cellspacing='3' width='100%' style=''><tr><td width='30%'>";

    echo "<table cellpadding='3' cellspacing='0' width='100%' class='light_table box' rules='all'>
    <tr><th>Цвет</th><th>Кол-во</th></tr>";

    $colors = $db -> query('SELECT logColor as logColor, COUNT(logColor) as count FROM logs GROUP BY logColor') -> fetchAllAssoc();
    $db -> freeResult();

    $count = 0;
    $Sum = 0;

    foreach ($colors as $c)
    {
        $color = $count % 2 ? "#d3e7f0" : "#ebf4f8";

        echo "<tr bgcolor='$color' onmouseover=\"this.style.background='#ffffff'\" onmouseout=\"this.style.background='$color'\">
        <td align='center'><font color='{$c['logColor']}'><b>{$c['logColor']}</b></font></td>
        <td align='center'>{$c['count']}</td>
        </tr>";

        $Sum += $c['count'];

        $count++;
    }

    echo "<tr style='background:#ffffff !important;'>
    <th> <b>Итого:</b></th>
    <th align='center'>$Sum</th>
    </tr></table>";


    echo "</td><td width='70%'>";


    echo "<table cellpadding='3' cellspacing='0' width='100%' class='light_table box' rules='all'>
    <tr><th>Бот</th><th>Цвет</th><th>Логов</th><th>Действие</th></tr>";

    $colors = $db -> query('SELECT *, COUNT(logBotName) as count FROM logs GROUP BY logBotName') -> fetchAllAssoc();
    $db -> freeResult();

    $count = 0;
    $Sum = 0;

    foreach ($colors as $c)
    {
        $color = $count % 2 ? "#d3e7f0" : "#ebf4f8";

        echo "<tr bgcolor='$color' onmouseover=\"this.style.background='#ffffff'\" onmouseout=\"this.style.background='$color'\">
        <td align='center'><b><a href='?act=logs&id={$c['logBotName']}'>N$count {$c['logBotName']}</a></b></td>
        <td align='center'><font color='{$c['logColor']}'><b>{$c['logColor']}</b></font></td>
        <td align='center'>{$c['count']}</td>
         <td align='center'><b><a href='?act=logs&clearid={$c['logBotName']}'>Очистить</a></b></td>
        </tr>";

        $Sum += $c['count'];

        $count++;
    }

    echo "<tr style='background:#ffffff !important;'>
    <th> <b>Итого:</b></th>
    <th align='center'> - </th>
    <th align='center'>$Sum</th>
    <th align='center'> - </th>
    </tr></table>";

    echo "</td></tr></table>";
}



?>
