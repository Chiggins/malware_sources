<?php
$notepad_file = 'system/data/svc_notes.htm';

if (isset($_GET['ajax'])){
	switch ($_GET['ajax']){
		case 'save_notepad':
			if (!file_put_contents($notepad_file, $_POST['content']))
				header('HTTP/1.1 400 Write error');
			break;
		}
	die();
	}

ThemeBegin(LNG_MM_SERVICE_NOTES, 0, getBotJsMenu('botmenu'), 0);
echo '<table><tr><td>';

# Check permissions
if (!is_writable(dirname($notepad_file)))
	echo '<div class="error">',
		LNG_DIR_MUST_BE_WRITABLE, $notepad_file,
		'</div>';
if (file_exists($notepad_file) && !is_writable($notepad_file))
	echo '<div class="error">',
		LNG_FILE_MUST_BE_WRITABLE, $notepad_file,
		'</div>';

# Read contents
$notepad_contents = '';
if (file_exists($notepad_file))
	$notepad_contents = file_get_contents($notepad_file);

# The notepad
echo '<div id="notepads">',
	'<div class="notepad" contenteditable="true" data-href="&id=0">',
		$notepad_contents,
		'</div>',
	'</div>';

echo '</td></tr></table>';

echo <<<HTML
<script src="theme/js/page-svc_notes.js"></script>
HTML;

echo THEME_DIALOG_END, ThemeEnd();
