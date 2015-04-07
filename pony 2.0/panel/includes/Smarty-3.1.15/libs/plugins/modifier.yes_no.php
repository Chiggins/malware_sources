<?php
function smarty_modifier_yes_no($value = 0)
{
	if ($value === null)
		return "неизвестно";
	if ($value)
		return 'да';
	else
		return 'нет';
}
?>