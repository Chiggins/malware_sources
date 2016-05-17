<form id='frm_createTaskKnock' onsubmit='var pdata = ajax_getInputs("frm_createTaskKnock"); ajax_pload("mod_gtaskknock.php", pdata, "div_ajax"); return false;'>

<table>
<tr align='left'>
	<td><label>KNOCK LINK:</label></td>
	<td><input size='80' name='knocklink' value='' maxlenght=1000></td>
</tr>
<tr align='left'>
	<td><label>KNOCKS COUNT:</label></td>
	<td><input size='4' name='knockscnt' value='' maxlenght=6></td>
</tr>

<tr align='left'>
	<td colspan='2'><label>NOTE:</label><br><textarea name='note' cols='100' rows='3' wrap='off'></textarea></td>
</tr>
</table>

<br><br><input type='submit' value='SAVE'>

</form>