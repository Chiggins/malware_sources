<?php

include_once('./gears/page_php_header.php');

if ($config['user']['rights']['pages']['p_proxy']['is']!='on') { Exit('<h1>Access denied</h1>'); } 

// ============================== CODE ============================== //

?>

<h1>Proxy settings</h1>

<script>
	$(document).ready(function(){ $('#waitPageModal').modal('hide'); });
</script>


<script>
	function savePROXY() {
		var proxydata = {};
		$('.listing').find('.rig_line').each(function(){
			var url = $(this).find('.rig_line_1 input').val();
			var description = $(this).find('.rig_line_2 input').val();
			proxydata[$(this).attr('data-rigLineId')] = {id: $(this).attr('data-rigLineId'), url: url, description: description};
			if (url=='') $(this).remove();
		});
		
		//console.log(vpsdata);
		//return false;
		
		
		$.ajax({
			url: './gears/savePROXY.php',
			type: 'POST',
			dataType: 'JSON',
			async: false,
			data : proxydata,
			success: function(data) {
				notify(data.type,data.msg);
				pageLoad('proxy');
				//$('.listing tbody tr :last').attr('data-rigLineId', parseInt(data.proxy_id)+1); // последняя + 1
			},
			error: function(var1, var2, var3) {
				console.log(var1, var2, var3);
			}
		});
	}


	function saveMassPROXY() {
		var proxydata;
		proxydata = $('#massAdd textarea').val();
		proxydata = proxydata.replace(/[\n]+/g, "\n");
		proxydata = proxydata.replace(/\r\n/g, "\n").split("\n");
		//console.log(proxydata);
		for (key in proxydata) {
			if (proxydata[key].match(/^(http|https)/i)==null) {
				notify('error', '<strong>'+proxydata[key]+' must start with http://');
				return false; 
			}
		}
		
	
		var postFields = {}
		
		postFields.data = proxydata;

		
		$.ajax({
			url: './gears/saveMassPROXY.php',
			type: 'POST',
			dataType: 'JSON',
			async: false,
			data : postFields,
			success: function(data) {
				//notify(data.type,data.msg);
				pageLoad('proxy');
			},
			error: function(var1, var2, var3) {
				console.log(var1, var2, var3);
			}
		});
	}

	function addPROXYLine() {
		var trCount = parseInt($('.listing tbody tr :last').attr('data-rigLineId'))+1;
		if (!trCount) trCount = 1;
		var line = '<tr class="rig_line" data-rigLineId="'+trCount+'"><td class="rig_line_1" width="60%"><span>Proxy url</span><input style="width:99%;"></td><td class="rig_line_2"><input style="width:99%;"></td><td><strong class="btn btn-info" onClick="checkUrlAV('+trCount+');">check</strong></td></tr>';		
		$('.listing tbody').append(line);
	}	


	function checkUrlAV(id) {
		
		$('#waitModal').modal({show:true,backdrop: 'static',keyboard: false});
		
		var url = $('.listing tbody tr[data-rigLineId='+id+'] .rig_line_1 input').val();

		$.ajax({
			url: './gears/checkAvURL.php',
			type: 'POST',
			dataType: 'JSON',
			async: true,
			cache: false,
			data : {proxyURL: url},
			success: function(data) {
				$('#waitModal').modal('hide');
				$('#myModal .modal-body').html('<h4>'+data.msg+'</h4><br><pre>'+data.full+'</pre>');
				$('#myModal').modal({show:true,backdrop: true,keyboard: true});
				notify(data.type,data.msg);
				//console.log(data);
			},
			error: function(var1, var2, var3) {
				console.log(var1, var2, var3);
			}
		});		
	}

</script>

<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">Check results</h4>
      </div>
      <div class="modal-body">
        
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
<!--         <button type="button" class="btn btn-primary">Save changes</button> -->
      </div>
    </div>
  </div>
</div>

<!-- Modal -->
<div class="modal fade" id="waitModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title" id="myModalLabel">URL is checking...</h4>
      </div>
      <div class="modal-body">
		<div class="progress progress-striped active">
		  <div class="bar" style="width: 100%;"></div>
		</div>
		<h4 class="text-center">wait...</h4>
      </div>
    </div>
  </div>
</div>

<table class="listing">
<thead><tr><th>Host name (with path)</th><th>description</th><th>AV</th></tr></thead>
<tbody>
	<?php
	
		$vps = cdim('db','query',"SELECT * FROM `proxy` ORDER BY `id` ASC");
		if (isset($vps)) foreach($vps as $k=>$v) {

			echo '
					<tr class="rig_line" data-rigLineId="'.$v->id.'">
						<td class="rig_line_1"width="60%"><span>Host name (with path)</span><input style="width:99%;" value="'.$v->url.'"></td>
						<td class="rig_line_2"><input style="width:99%;" value="'.$v->description.'"></td>
						<td><strong class="btn btn-info" onClick="checkUrlAV('.$v->id.');">check</strong></td>
					</tr>
				';

			
		}

	?>

</tbody>
</table>
<small>To delete, just leave host url field empty</small><br>
<div style="text-align:left;float:left;margin-top:10px;"><input value="Add Proxy Line" type="button" class="btn" onclick="addPROXYLine()"></div>
<div style="text-align:right;margin-top:10px;"><input value="Save" type="button" class="btn" onclick="savePROXY()"></div>

<hr>
<h1>Mass adding (one url at line)</h1>
<div id="massAdd">
<textarea style="width:98%;height:150px;"></textarea>
<div style="text-align:right;margin:10px 10px 0 0;"><input value="Add" type="button" class="btn" onclick="saveMassPROXY()"></div>
</div>

