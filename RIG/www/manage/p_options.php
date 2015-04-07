<?php

include_once('./gears/page_php_header.php');

if ($config['user']['rights']['pages']['p_options']['is']!='on') { Exit('<h1>Access denied</h1>'); } 

// ============================== CODE ============================== //

echo "<h1>Settings</h1>";

?>

<script>
	$(document).ready(function(){ $('#waitPageModal').modal('hide'); });
</script>

<?php

if ($config['user']['rights']['rolename']=='admin') {
// НАСТРОЙКИ ДЛЯ АДМИНА
?>

<script>
	function saveAdminOptions() {
		$.ajax({
			url: './gears/saveAdminOptions.php',
			type: 'POST',
			dataType: 'HTML',
			data : {
				rc4key: $('#rc4key').val(),
				tokenTTL: $('#tokenTTL').val(),
				siteurl: $('#siteurl').val(),
				real_path: $('#real_path').val(),
				lines_per_page: $('#lines_per_page').val(),
				exploit_count_fail: $('#exploit_count_fail').val(),
				fileKey: $('#fileKey').val()
			},
			success: function(data) {
				notify('success','Настройки успешно сохранены');	
			}
		});		
	}

</script>

<table class="listing">
<thead><tr><th></th><th></th></tr></thead>
<tbody>

	<tr>
		<td colspan=2><h3>UI</h3></td>
	</tr>
	<tr>
		<td valign="top">Lines on page</td>
		<td><span>#</span><input style="width:100%;" id="bots_per_page" value="<?php echo $config['options']['lines_per_page']; ?>"></td>
	</tr>

	<tr>
		<td colspan=2><h3>Crypt settings</h3></td></tr>
	<tr>
		<td width=20%>Data XOR key</td>
		<td><input style="width:100%;" id="rc4key" value="<?php echo $config['options']['rc4key'] ?>"></td>
	</tr>
	<tr>
		<td width=20%>File XOR key</td>
		<td><input style="width:100%;" id="fileKey" value="<?php echo $config['options']['fileKey'] ?>"></td>
	</tr>

	<tr>
		<td colspan=2><h3>Token settings</h3></td></tr>
	<tr>
		<td>TTL (sec)</td>
		<td><input style="width:100%;" id="tokenTTL" value="<?php echo $config['options']['tokenTTL'] ?>"></td>
	</tr>

	<tr>
		<td colspan=2><h3>Exploits</h3></td></tr>
	<tr>
		<td>AV warning count to kill proxy</td>
		<td><input style="width:100%;" id="exploit_count_fail" value="<?php echo $config['options']['exploit_count_fail'] ?>"></td>
	</tr>

	<tr>
		<td colspan=2><h3>Paths settings</h3></td></tr>
	<tr>
		<td>Site url</td>
		<td><input style="width:100%;" id="siteurl" value="<?php echo $config['options']['siteurl'] ?>"></td>
	</tr>
	<tr>
		<td>Real path</td>
		<td><input style="width:100%;" id="real_path" value="<?php echo $config['options']['real_path'] ?>"></td>
	</tr>
</tbody>
</table>
<div style="text-align:right;margin-top:10px;"><input value="Сохранить" type="button" class="btn" onclick="saveAdminOptions()"></div>

<?php 
} else {
// НАСТРОЙКИ ДЛЯ ПОЛЬЗОВАТЕЛЯ
?>
<script>
	function changePassword(id) {
		var newPass = prompt("New password:", "");
		if (newPass==null || newPass=='') {
			alert('Cant be empty!');
			return false;
		}
		var newPass2 = prompt("Re-enter new password:", "");
		if (newPass2==null || newPass2=='') {
			alert('Cant be empty!');
			return false;
		}
		if (newPass == newPass2) {
			$.ajax({
				url: './gears/changeUserPass.php',
				type: 'POST',
				data: {
					user_id: id,
					pass: newPass
				},
				dataType: 'JSON',
				success: function(data) {
					if (data.type=='error') alert(data.msg);
					if (data.type=='ok') alert('Password changed!\nUser must relogin.');
				}
			});				
		} else {
			alert('Passwords not equal!');
		}
	}
</script>

<input type="button" class="btn" value="Change password" onclick="changePassword(<?php echo $config['user']['id']; ?>);">


<?php } ?>