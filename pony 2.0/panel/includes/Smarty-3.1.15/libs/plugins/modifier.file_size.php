<?php
function smarty_modifier_file_size($b=0)
{
	if ($b == 0)
		return '0 bytes';

	$units = array("bytes","kB","MB","GB","TB","PB","EB","ZB","YB");
	$c=0;

	foreach($units as $k => $u) 
	{
		if(($b / pow(1024,$k)) >= 1) {
			$r["bytes"] = $b / pow(1024,$k);
		    $r["units"] = $u;
		    $c++;
		}
	}
	return number_format($r["bytes"],2)." ".$r["units"];	
}
?>