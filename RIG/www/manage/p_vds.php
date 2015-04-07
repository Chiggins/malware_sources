<?php

include_once('./gears/page_php_header.php');

if ($config['user']['rights']['pages']['p_vds']['is']!='on') { Exit('<h1>Access denied</h1>'); } 

// ============================== CODE ============================== //

?>

<h1>VDS Settings</h1>

<script>
	$(document).ready(function(){ $('#waitPageModal').modal('hide'); });
</script>

<?php
if ($config['user']['rights']['rolename']=='admin') {
// НАСТРОЙКИ ДЛЯ АДМИНА
?>

<script>
	function saveVDS() {
		var vdsdata = {};
		var flagstop = 0;
		$('.listing').find('.rig_line').each(function(){
			var ip = $(this).find('.rig_line_1 input').val();
			var description = $(this).find('.rig_line_2 input').val();
			vdsdata[$(this).attr('data-rigLineId')] = {id: $(this).attr('data-rigLineId'), ip: ip, description: description};

			if (ip=='') { 
				$(this).remove();
			} else {
				//if (!ip.match(/[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}\.[\d]{1,3}/i)) {
				if (ip.match(/^(http|https)/i)==null) {
					notify('error','<strong>'+ip+' must start with http or https');
					flagstop = 1;
				}				
			}
		});
		
		if (flagstop==1) return false;
		
		//console.log(vdsdata);

		$.ajax({
			url: './gears/saveVDS.php',
			type: 'POST',
			dataType: 'JSON',
			async: false,
			data : vdsdata,
			success: function(data) {
				notify(data.type,data.msg);
				pageLoad('vds');
				//$('.listing tbody tr :last').attr('data-rigLineId', parseInt(data.vds_id)+1); // последняя + 1
			},
			error: function(var1, var2, var3) {
				console.log(var1, var2, var3);
			}
		});		
	}

	function addVDSLine() {
		var trCount = parseInt($('.listing tbody tr :last').attr('data-rigLineId'))+1;
		if (!trCount) trCount = 1;
		var line = '<tr class="rig_line" data-rigLineId="'+trCount+'"><td class="rig_line_1" width="60%"><span>VDS IP</span><input style="width:99%;"></td><td class="rig_line_2"><input style="width:99%;"></td></tr>';		
		$('.listing tbody').append(line);
	}	

</script>

<table class="listing">
<thead><tr><th>VDS URL</th><th>description</th></tr></thead>
<tbody>
	<?php
	
		$vds = cdim('db','query',"SELECT * FROM `vds` ORDER BY `id` ASC");
		if (isset($vds)) foreach($vds as $k=>$v) {

			echo '
					<tr class="rig_line" data-rigLineId="'.$v->id.'">
						<td class="rig_line_1"width="60%"><span>VDS URL</span><input style="width:99%;" value="'.$v->ip.'"></td>
						<td class="rig_line_2"><input style="width:99%;" value="'.$v->description.'"></td>
					</tr>
				';

			
		}

	?>

</tbody>
</table>
<small>To delete, just leave host url field empty</small><br>
<div style="text-align:left;float:left;margin-top:10px;"><input value="Add VDS line" type="button" class="btn" onclick="addVDSLine()"></div>
<div style="text-align:right;margin-top:10px;"><input value="Save" type="button" class="btn" onclick="saveVDS()"></div>

<?php 
}
?>