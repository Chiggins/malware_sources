<?php

include_once('./gears/page_php_header.php');

if ($config['user']['rights']['pages']['p_files']['is']!='on') { Exit('<h1>Access denied</h1>'); } 

// ============================== CODE ============================== //

echo "<h1>Exe Control</h1>";

if ($config['user']['rights']['rolename']=='user') {

// process the file upload
if ($_FILES || $_POST) {
	print_r($_FILES);
}

?>

	<script type="text/javascript" src="./js/plupload/browserplus-min.js"></script>
	<script type="text/javascript" src="./js/plupload/plupload.js"></script>
	<script type="text/javascript" src="./js/plupload/plupload.gears.js"></script>
	<script type="text/javascript" src="./js/plupload/plupload.silverlight.js"></script>
	<script type="text/javascript" src="./js/plupload/plupload.flash.js"></script>
	<script type="text/javascript" src="./js/plupload/plupload.browserplus.js"></script>
	<script type="text/javascript" src="./js/plupload/plupload.html4.js"></script>
	<script type="text/javascript" src="./js/plupload/plupload.html5.js"></script>

	<script>
		
		$(document).ready(function(){ $('#waitPageModal').modal('hide'); });
	
		function delFileFromBase(id) {
			$.ajax({
				url: './gears/fileDelete.php',
				type: 'GET',
				data: {
					file_id: id,
					user_id: <?php echo $config['user']['id']; ?>,
				},
				success: function(data) {
					notify(data.type,data.msg);
					$('tr[data-FileIdRow='+id+']').hide();
				},
				dataType: "json"
			});	
		}
		
		
		function checkFile(file_id) {
			
			$('#waitModal').modal({show:true,backdrop: 'static',keyboard: false});
			
			$.ajax({
				url: './gears/fileCheck.php',
				type: 'POST',
				data: {
					file_id: file_id,
					user_id: <?php echo $config['user']['id']; ?>,
				},
				success: function(data) {
					notify(data.type,data.msg);
					$('#myModal #m_filename').html('Filename: '+data.fileName);
					$('#myModal #m_filesize').html('File Size: '+data.fileSize);
					$('#myModal #m_shortresults').html('AV check results: '+data.shortresult);
					$('#myModal #m_fulresults').html('Full results: <a href="'+data.avlink+'" target="_blank">here</a>');
		
					$('#waitModal').modal('hide');
					$('#myModal').modal({
		
						backdrop: true,
						keyboard: true,
						show: true,
						
					});

				},
				dataType: "json"
			});				
		}
		
		function autoupdate(form_id) {
			
			$('#waitModal').modal({show:true,backdrop: 'static',keyboard: false});
			
			$.ajax({
				url: './gears/autoupdate.php',
				type: 'POST',
				data: {
					form_id: form_id,
					user_id: <?php echo $config['user']['id']; ?>,
				},
				success: function(data) {
					notify(data.type,data.msg);
					$('#myModal #m_filename').html('Filename: '+data.fileName);
					$('#myModal #m_filesize').html('File Size: '+data.fileSize);
					$('#myModal #m_shortresults').html('AV check results: '+data.shortresult);
					$('#myModal #m_fulresults').html('Full results: <a href="'+data.avlink+'" target="_blank">here</a>');
		
					$('#waitModal').modal('hide');
					$('#myModal').modal({
		
						backdrop: true,
						keyboard: true,
						show: true,
						
					});

				},
				dataType: "json"
			});				
		}
	</script>


<!-- Modal -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">AV Check results</h4>
      </div>
      <div class="modal-body">
        <div id="m_filename"></div>
        <div id="m_filesize"></div>
        <div id="m_shortresults"></div>
        <div id="m_fulresults"></div>
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
        <h4 class="modal-title" id="myModalLabel">File in process...</h4>
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

<table class="listing" id="userFilesList">
<thead><tr><th>Filename</th><th>Size</th><th>AVCheck</th><th>AutoUpdate</th><th>Actions</th></tr></thead>
<tbody>
	<?php
	$autoupdate_user_id = $config['user']['id'];
	$autoupdate_filename = '';
	$autoupdate_url = '';
		$userFilesList = cdim('db','query',"SELECT * FROM `files` WHERE `user_id` = ".$config['user']['id']);
		if (isset($userFilesList)) foreach($userFilesList as $k=>$v) {
		  $autoupdate_runfile = './autoupdate/autoupdate_runfile_'.$autoupdate_user_id;
		  $a_file_arr = array();
		  if (file_exists($autoupdate_runfile))
		    {
		    $a_filedata = @file_get_contents($autoupdate_runfile);
		    if ($a_filedata !== FALSE)
		      {
		      $a_file_arr = unserialize($a_filedata);
		      $autoupdate_url = isset($a_file_arr[$v->filename]) ? $a_file_arr[$v->filename] : '';
		      }
		    }
			echo '
					<tr data-FileIdRow="'.$v->id.'">
						<td><span>Filename</span><a href="./gears/downloadFile.php?id='.$v->id.'" target="_blank">'.$v->filename.'</a></td>
						<td><span>Size</span>'.$v->filesize.'</td>
						<td><span>AvCheck</span>'.$v->avcheck.'</td>
						<td><form action="" method="POST" id="form_'.md5($v->filename).'"><input type="hidden" name="autoupdate_user_id" value="'.$config['user']['id'].'"><input type="hidden" name="autoupdate_filename" value="'.$v->filename.'"><input type="text" name="autoupdate_url" style="width:200px;" value="'.$autoupdate_url.'"> <a id="autoupdate" href="javascript:;" class="btn btn-success" title="Save" onclick="document.getElementById(\'form_'.md5($v->filename).'\').submit();">S</a></form></td>
						<td><b class="btn btn-warning" data-fileId="'.$v->id.'" onClick="delFileFromBase('.$v->id.')">del</b> <b class="btn btn-info" data-fileId="'.$v->id.'" onClick="checkFile('.$v->id.')">AV check</b></td>
					</tr>
				';

			
		} else {
			echo '
					<tr data-FileIdRow="empty">
						<td colspan=4><div class="text-center">No files</div></td>
					</tr>
				';			
		}

	?>

</tbody>
</table>


<div id="container">
	<div id="filelist" style="padding:20px 0 20px 0;"></div>
	<a id="pickfiles" href="javascript:;" class="btn btn-primary" style="width:100px;">browse</a><br><br>
	<a id="uploadfiles" href="javascript:;" class="btn btn-success" style="width:100px;">upload<span id="runtimeEngine"></span></a><br><br>
<!--     <strong>3. Clear list for future uploads</strong><br> <a id="clear" href="javascript:;" class="button_blue">clear</a> -->
</div>

<script type="text/javascript">

	// === DEFAULT UPLOAD DIRECTORY
	var downloadDir = 'download';
	
	// === PLUPLOAD CONFIG
	var uploader = new plupload.Uploader({
		runtimes : 'gears,html5,flash,silverlight,browserplus,html4',
		chunk_size: '1mb',
		unique_names: false,
		browse_button : 'pickfiles',
		container: 'container',
		max_file_size : '5mb',
		url : './gears/fileUpload.php',
		flash_swf_url : './js/plupload/plupload.flash.swf',
		silverlight_xap_url : './js/plupload/plupload.silverlight.xap',
		filters : [
			{title : "All files", extensions : "*"}
		]
	});
	
	// === INITIALISATION
	uploader.bind('Init', function(up, params) {
		$('#runtimeEngine').html('&nbsp;&nbsp;<img src="./images/rte_' + params.runtime + '.png" align="center" width="14px" height="14px" alt="'+params.runtime+'" title="Current runtime engine is: '+params.runtime+'">');
	});
	
	// === FILES ADDED
	uploader.bind('FilesAdded', function(up, files) {
		
		var filesId = uploader.splice();
		for (var i=0;i<filesId.length;i++) {
			$('#'+filesId[i].id).remove();
		}
		$('#link').innerHTML = '';
			
		for (var i in files) {
			$('#filelist').append('<div id="' + files[i].id + '">' + files[i].name + ' (' + plupload.formatSize(files[i].size) + ') <b></b><span class="btn btn-small btn-warning delQueueItem" rel="'+files[i].id+'">del</span></div>');
		}
		newItemBind();
	});
	
	// === UPLOAD PROGRESS
	uploader.bind('UploadProgress', function(up, file) {
		//console.log('UploadProgress');
		//console.log(file.status);
		//console.log(file.percent);	
		$('#'+file.id).find('b').html('<span>' + file.percent + "%</span>&nbsp;&nbsp;");
	});
	
	// === FILE UPLOADED
	uploader.bind('FileUploaded', function(up, file, info) {
		var realFile = JSON.parse(info.response);

		if (file.status == 5) $('#'+file.id).remove();

		// send a request to add the file to the database
		$.ajax({
			url: './gears/file2mysql.php',
			type: 'POST',
			data: {
				filename: realFile.fileName,
				user_id: <?php echo $config['user']['id']; ?>,
			},
			success: function(data) {
				notify(data.type,data.msg);
				var a = '';
				a = a + '<tr data-FileIdRow="'+data.fileid+'">';
				a = a + '<td><span>Filename</span><a href="./gears/downloadFile.php?id='+data.fileid+'" target="_blank">'+realFile.fileName+'</a></td>';
				a = a + '<td><span>Size</span>'+plupload.formatSize(file.size)+'</td>';
				a = a + '<td><span>AVCheck</span></td>';
				a = a + '<td><b class="btn btn-warning" data-fileId="'+data.fileid+'" onClick="delFileFromBase('+data.fileid+')">del</b> <b class="btn btn-info" data-fileId="'+data.fileid+'" onClick="checkFile('+data.fileid+')">AV check</b></td>';
				a = a + '</tr>';

				$('#waitModal').modal('hide');

				$('#userFilesList tbody tr[data-fileidrow=empty]').remove();
				$('#userFilesList tbody').append(a);

				//location.reload();
			},
			dataType: "json"
		});
	
	});
	
	// === CLEAR BUTTON CLICK
	$('#clear').click(function() {
		var filesId = uploader.splice();
		for (var i=0;i<filesId.length;i++) {
			$('#'+filesId[i].id).remove();
		}
		$('#link').innerHTML = '';
	});
	
	// === UPLOAD BUTTON CLICK
	$('#uploadfiles').click(function() {
		$('#waitModal').modal({show:true,backdrop: 'static',keyboard: false});
		uploader.start();
		return false;
	});
	
	
	function newItemBind() {
		$('.delQueueItem').click(function() {
			var files = uploader.files;
			for (var i=0;i<files.length;i++) {
				if (files[i].id==$(this).attr('rel')) {
					$('#'+files[i].id).remove();
					uploader.splice(i,1);
				}
			}
			return false;
		});
	}
	// === CALL INITIALISATION FUNCTION
	uploader.init();


</script>



<?php 
} 
?>