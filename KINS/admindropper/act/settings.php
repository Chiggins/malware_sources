<?php

if (isset($_POST['opt']))
{
	foreach (array_keys($_POST['opt']) as $k)
	{
		$db -> query("REPLACE INTO options (name, data) VALUES ('{$k}', '{$_POST['opt'][$k]}')");
	}
}

$opt = array();

$r = $db -> query('SELECT * FROM options')-> fetchAllAssoc();;
foreach ($r as $f)
{
	$opt[$f['name']] = $f['data'];
}


echo "
    <div style='padding: 20px'>  <div style='margin-bottom: 20px'>
    <a class='razdel' href='?act=settings'>Обновить</a>
    </div>";
	
echo "
    <form class='formee' action='?act=settings' method='post'>
    <table cellpadding='3' cellspacing='3' width='100%'>
	<tr>
		<td class='td_col_zag' width='40%'>Онлайн боты (интервал Delay минуты)</td>
		<td class='td_col_list' width='60%'>
            <input style='width: 300px;' name='opt[delay]' type='text' value='{$opt['delay']}'>
        </td>
	</tr>
	<tr>
		<td class='td_col_zag' width='40%'>Живые боты (интервал дни)</td>
		<td class='td_col_list' width='60%'>
            <input style='width: 300px;' name='opt[alive]' type='text' value='{$opt['alive']}'>
        </td>
	</tr>
    
	<tr>
		<td>&nbsp;</td>
		<td><input type='submit' value='Сохранить' name='fSave'></td>
	</tr>
	
	</table>
	</form>";
	

?>
