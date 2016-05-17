<?php
function named_preset_picker($key, $bindto){
	$s = '';
	$s .= '<div class="namedPreset">';
	$s .= '<SELECT data-bind="'.$bindto.'"><option value=""></option>';
	if (isset($GLOBALS['config']['named_preset'][$key]))
		foreach (explode("\n", $GLOBALS['config']['named_preset'][$key]) as $preset)
			if (strlen($preset = trim($preset)) && FALSE !== strpos($preset, '=')){
				list($name, $values) = explode('=', $preset, 2);
				$s .= '<option value="'.htmlspecialchars(trim($values)).'">'.htmlspecialchars($name).'</option>';
			}
	$s .= '</SELECT>';
	$s .= ' <a href="?m=ajax_config&action=namedPresets&key='.$key.'" class="ajax_colorbox">'.'Edit'.'</a>';
	$s .= '</div>';

	return $s;
}

