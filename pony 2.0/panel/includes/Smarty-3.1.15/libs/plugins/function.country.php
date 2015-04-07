<?php

function smarty_function_country($params, &$smarty) {
	
	if (!isset($params['country_code']))
		$params['country_code'] = '';
	$img_file = $params['base_path'].strtolower($params['country_code']).".gif";
	if (file_exists($img_file))
	{
		if (!isset($params['country_name']) || !strlen($params['country_name']))
		{
			$alt = $params['country_code'];
		}
		else
		{
			$alt = $params['country_name'];
		}

		$img_url = "<img src=\"".htmlspecialchars($img_file, ENT_QUOTES, 'cp1251')."\" width=\"16\" height=\"11\" alt=\"".htmlspecialchars($alt, ENT_QUOTES, 'cp1251')."\" /> ";
	} else
		$img_url = '';

	if (strlen($params['country_code']))
	{
		if (!isset($params['country_name']) || !strlen($params['country_name']))
			$params['country_name'] = '';
		if (isset($params['simple']) && $params['simple'])
		{
			if (!strlen($img_url))
				return '<div style="margin-left:20px">'.htmlspecialchars($params['country_name'], ENT_QUOTES, 'cp1251').'</div>';
			else
				return $img_url.' '.htmlspecialchars($params['country_name'], ENT_QUOTES, 'cp1251');
		}
		else
		{
			if (strlen($params['country_name']))
				$country_name = ' <small>('.htmlspecialchars($params['country_name'], ENT_QUOTES, 'cp1251').')</small>';
			else
				$country_name = '';
			if (!strlen($img_url))
				return '<div style="margin-left:20px">'.'<b>'.htmlspecialchars($params['country_code'], ENT_QUOTES, 'cp1251').'</b>'.$country_name.'</div>';
			else
				return $img_url.'<b>'.htmlspecialchars($params['country_code'], ENT_QUOTES, 'cp1251').'</b>'.$country_name;
		}
	} 

	return '';
}

?>
