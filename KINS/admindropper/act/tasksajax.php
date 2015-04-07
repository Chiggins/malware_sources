<?php

switch ($_GET['s'])
{
	case 'extended' :

		echo "<td class='td_col_zag' width='30%'>Файл</td>
		<td class='td_col_list' width='70%'>
        <select style='width: 300px;' name='tCmdFile'>";
        $files = $db -> query('SELECT * FROM `files`') -> fetchAllAssoc();
        foreach ($files as $file)
        {
            echo "<option value='".$file['fId']."'>".$file['fName']."</option>";
        }
        echo "</select></td>";

    break;
}

?>
