<?php

function smarty_modifier_items($value = 0)
{
	$reminder = $value % 10;
	if ($value === null || $reminder == 0 || $value == 0 || ($reminder >= 5 && $reminder <= 9) )
		return 'записей';

	if ($reminder == 1)
		return 'запись';

	if ($reminder == 2 || $reminder == 3 || $reminder == 4)
		return 'записи';

	return 'записей';
}

?>