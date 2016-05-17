<?php

	error_reporting(E_ERROR | E_WARNING | E_PARSE);
	
	define('AthenaHTTP', '');
	require_once './config.php';
	
	set_time_limit(0);

	if(mysql_num_rows(mysql_query('SELECT * FROM ip_country WHERE 1 LIMIT 1')) == 0)
	{	
		$handle = fopen('geoip.csv', 'r');
		if($handle !== FALSE)
		{
			$c = 0;
						
			while(($data = fgetcsv($handle, 1000, ',')) !== FALSE)
			{
				mysql_query("INSERT INTO ip_country (ip_start, ip_end, ip_start_long, ip_end_long, country_code, country_name) VALUES " . 
							"('" . $data[0] . "', '" . $data[1] . "', '" . $data[2] . "', '" . $data[3] . "', '" . $data[4] . "', '" . $data[5] . "');");
			}
		}
		
		print 'GeoIP database imported successfully';
	}
	else
	{
		print 'Seems like it\'s already imported';
	}
?>