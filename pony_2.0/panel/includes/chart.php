<?php

if (!isset($authentication_success) || !$authentication_success)
	die();

$pchart_path = "includes/pchart";

/* pChart library inclusions */ 
require_once($pchart_path."/class/pData.class.php"); 
require_once($pchart_path."/class/pDraw.class.php"); 
require_once($pchart_path."/class/pImage.class.php"); 
require_once($pchart_path."/class/pPie.class.php"); 

$trim_os_versions = true;

// Trim OS Service Pack information
// Windows 7 SP1 => Windows 7
// Windows Server 2003 Service Pack 4 => Windows Server 2003
function trim_os_versions($os_values)
{
	$new_values = array();
	
	foreach ($os_values as $os_name=>$os_count)
	{
		$os_count = intval($os_count);
		$os_name_parts = explode(" ", $os_name);
		if (count($os_name_parts) > 2)
		{
			if (strpos($os_name, ' NT') > 0 || strpos($os_name, ' Server') > 0)
				$os_name = $os_name_parts[0].' '.$os_name_parts[1].' '.$os_name_parts[2];
			else
				$os_name = $os_name_parts[0].' '.$os_name_parts[1];
		}
		if (isset($new_values[$os_name]))
			$new_values[$os_name] += $os_count;
		else
			$new_values[$os_name] = $os_count;		
	}
	
	return $new_values;
}

function create_common_image($title, $width, $height, $data, $chart_type = 'line')
{
	global $pchart_path;
	
	/* Create the pChart object */ 
	$myPicture = new pImage($width, $height, $data); 

	/* Draw the background */ 
	$Settings = array("R"=>255, "G"=>255, "B"=>255, "Dash"=>1, "DashR"=>185, "DashG"=>225, "DashB"=>255); 
	$myPicture->drawFilledRectangle(0,0,$width,$height,$Settings); 

	/* Overlay with a gradient */ 
	$Settings = array("StartR"=>206, "StartG"=>235, "StartB"=>235, "EndR"=>71, "EndG"=>150, "EndB"=>205, "Alpha"=>50); 
	$myPicture->drawGradientArea(0,0,$width,$height,DIRECTION_VERTICAL,$Settings); 
	$myPicture->drawGradientArea(0,0,$width,20,DIRECTION_VERTICAL,array("StartR"=>0,"StartG"=>0,"StartB"=>0,"EndR"=>50,"EndG"=>50,"EndB"=>50,"Alpha"=>80)); 

	/* Add a border to the picture */ 
	$myPicture->drawRectangle(0,0,$width-1,$height-1,array("R"=>0,"G"=>0,"B"=>0)); 

	/* Write the picture title */  
	$myPicture->setFontProperties(array("FontName"=>$pchart_path."/fonts/arialbd.ttf","FontSize"=>9)); 
	$myPicture->drawText(24, 12, win2uni($title),array("R"=>255,"G"=>255,"B"=>255, "Align"=>TEXT_ALIGN_MIDDLELEFT));
	
	$myPicture->drawFromPNG(4, 4, "includes/design/images/chart_pie.png"); 

	if ($chart_type == 'line')
	{
		$myPicture->setFontProperties(array("FontName"=>$pchart_path."/fonts/arial.ttf","FontSize"=>8));

		/* Draw the scale and the 1st chart */ 
		$myPicture->setGraphArea(60, 64, 450+200, 190);
		$myPicture->drawFilledRectangle(60, 50, 450+200, 190, array("R"=>255,"G"=>255,"B"=>255,"Surrounding"=>-255,"Alpha"=>60));
		
		$myPicture->drawScale(array("Mode"=>SCALE_MODE_START0, "DrawSubTicks"=>FALSE, "GridR"=>151, "GridG"=>197, "GridB"=>254, "GridAlpha"=>30)); 
		$myPicture->setShadow(TRUE,array("X"=>1,"Y"=>1,"R"=>0,"G"=>0,"B"=>0,"Alpha"=>10)); 
	}
	
	$myPicture->setFontProperties(array("FontName"=>$pchart_path."/fonts/pf_arma_five.ttf","FontSize"=>6)); 
	
	return $myPicture;
}
	 
if ($admin_routine == 'last_24_hours')
{
	$ftp_count = array();
	if (!$pony_db->get_ftp_count_last_24_hours($ftp_count))
		die();

	$report_count = array();
	if (!$pony_db->get_report_count_last_24_hours($report_count))
		die();

	$http_count = array();
	if (!$pony_db->get_http_count_last_24_hours($http_count))
		die();

	$email_count = array();
	if (!$pony_db->get_email_count_last_24_hours($email_count))
		die();

	$chart_ftp_values = array();
	$chart_http_values = array();
	$chart_email_values = array();
	$points_reports = array();

	$MyData = new pData();
	
	$cur_time = time();
	$hour_labels = array();
	for ($i = 23; $i >= 0; $i--)
	{
		array_push($hour_labels, date('H', $cur_time-3600*$i));
		if (!isset($ftp_count[intval(date('H', $cur_time-3600*$i))]))
			array_push($chart_ftp_values, NULL);
		else
			array_push($chart_ftp_values, $ftp_count[intval(date('H', $cur_time-3600*$i))]);

		if (!isset($http_count[intval(date('H', $cur_time-3600*$i))]))
			array_push($chart_http_values, NULL);
		else
			array_push($chart_http_values, $http_count[intval(date('H', $cur_time-3600*$i))]);

		if (!isset($email_count[intval(date('H', $cur_time-3600*$i))]))
			array_push($chart_email_values, NULL);
		else
			array_push($chart_email_values, $email_count[intval(date('H', $cur_time-3600*$i))]);

		if (!isset($report_count[intval(date('H', $cur_time-3600*$i))]))
			array_push($points_reports, NULL);
		else
			array_push($points_reports, $report_count[intval(date('H', $cur_time-3600*$i))]);
	}
	
	if (count($ftp_count) == 0 && count($report_count) == 0)
		$chart_ftp_values[0] = 0;

	$legend_offset = 415+165;

	$MyData->addPoints($points_reports, "Reports");
	$MyData->setPalette("Reports",array("R"=>220,"G"=>82,"B"=>91,"Alpha"=>100));

	$MyData->addPoints($chart_ftp_values, "FTP");
	$MyData->setPalette("FTP",array("R"=>0,"G"=>39,"B"=>94,"Alpha"=>100));
	if ($enable_http_mode && ($show_http_to_users || $pony_db->priv_is_admin()))
	{
		$MyData->addPoints($chart_http_values, "HTTP");
		$MyData->setPalette("HTTP",array("R"=>150,"G"=>10,"B"=>150,"Alpha"=>100));
		$legend_offset -= 35;
	}
	if ($enable_email_mode && ($show_email_to_users || $pony_db->priv_is_admin()))
	{
		$MyData->addPoints($chart_email_values, "E-mail");
		$MyData->setPalette("E-mail",array("R"=>10,"G"=>150,"B"=>10,"Alpha"=>100));
		$legend_offset -= 40;
	}

	$MyData->setAxisName(0, win2uni($lang['Count'])); 
	$MyData->addPoints($hour_labels, "Labels"); 
	
	$MyData->setSerieDescription("Labels", win2uni($lang['Hours'])); 
	$MyData->setAbscissa("Labels"); 
	$MyData->setAbscissaName(win2uni($lang['Hours'])); 
	$MyData->setAxisDisplay(0, AXIS_FORMAT_METRIC);

	$myPicture = create_common_image($lang['New password additions in the past 24 hours'], 680, 230, $MyData);
	$myPicture->drawLineChart(array("DisplayValues"=>TRUE,"DisplayColor"=>DISPLAY_AUTO)); 
	$myPicture->drawLegend($legend_offset,215,array("Style"=>LEGEND_NOBORDER,"Mode"=>LEGEND_HORIZONTAL));

	$myPicture->stroke();
} else if ($admin_routine == 'last_month')
{
	$day_ftp_count = array();
	if (!$pony_db->get_ftp_count_last_month($day_ftp_count))
		die();

	$report_count = array();
	if (!$pony_db->get_report_count_last_month($report_count))
		die();

	$http_count = array();
	if (!$pony_db->get_http_count_last_month($http_count))
		die();

	$email_count = array();
	if (!$pony_db->get_email_count_last_month($email_count))
		die();

	$MyData = new pData();   

	$cur_time = time();
	$chart_day_labels = array();
	$reports_array = array();
	
	for ($i = 27; $i >= 0; $i--)
	{
		$day = (intval(date('d', $cur_time-24*3600*$i)));
		array_push($chart_day_labels, $day);
	}

	$ftp_count_values = array();
	$http_count_values = array();
	$email_count_values = array();
		
	for ($i = 27; $i >= 0; $i--)
	{
		$day = (intval(date('d', $cur_time-24*3600*$i)));
		if (!isset($day_ftp_count[strval($day)]))
			array_push($ftp_count_values, NULL);
		else
			array_push($ftp_count_values, $day_ftp_count[strval($day)]);
			
		if (!isset($report_count[strval($day)]))
			array_push($reports_array, NULL);
		else
			array_push($reports_array, $report_count[strval($day)]);

		if (!isset($http_count[strval($day)]))
			array_push($http_count_values, NULL);
		else
			array_push($http_count_values, $http_count[strval($day)]);

		if (!isset($email_count[strval($day)]))
			array_push($email_count_values, NULL);
		else
			array_push($email_count_values, $email_count[strval($day)]);
	}
	
	if (count($day_ftp_count) == 0 && count($report_count) == 0)
	{
		$ftp_count_values[0] = 0;
	}

	$legend_offset = 415+165;

	$MyData->addPoints($reports_array, "Reports");
	$MyData->setPalette("Reports",array("R"=>220,"G"=>82,"B"=>91,"Alpha"=>100));
	$MyData->addPoints($ftp_count_values, "FTP");
	$MyData->setPalette("FTP",array("R"=>0,"G"=>39,"B"=>94,"Alpha"=>100));
	if ($enable_http_mode && ($show_http_to_users || $pony_db->priv_is_admin()))
	{
		$MyData->addPoints($http_count_values, "HTTP");
		$MyData->setPalette("HTTP",array("R"=>150,"G"=>10,"B"=>150,"Alpha"=>100));
		$legend_offset -= 35;
	}
	if ($enable_email_mode && ($show_email_to_users || $pony_db->priv_is_admin()))
	{
		$MyData->addPoints($email_count_values, "E-mail");
		$MyData->setPalette("E-mail",array("R"=>10,"G"=>150,"B"=>10,"Alpha"=>100));
		$legend_offset -= 40;
	}

	$MyData->setAxisName(0, win2uni($lang['Count'])); 
	$MyData->addPoints($chart_day_labels, "Labels"); 
	$MyData->setSerieDescription("Labels", win2uni($lang['Days'])); 
	$MyData->setAbscissa("Labels"); 
	$MyData->setAbscissaName(win2uni($lang['Days'])); 
	$MyData->setAxisDisplay(0, AXIS_FORMAT_METRIC);
	
	$myPicture = create_common_image($lang['New password additions in the past month'], 680, 230, $MyData);
	$myPicture->drawLineChart(array("DisplayValues"=>TRUE, "DisplayColor"=>DISPLAY_AUTO)); 
	$myPicture->drawLegend($legend_offset, 215, array("Style"=>LEGEND_NOBORDER,"Mode"=>LEGEND_HORIZONTAL));

	$myPicture->stroke();
} else if ($admin_routine == 'os')
{
	$os_list = array();
	if (!$pony_db->get_os_stats($os_list))
		die();

	if ($trim_os_versions)
		$os_list = trim_os_versions($os_list);

	if (count($os_list))		
	{
		$points_labels = array();
		$points_values = array();
		
		$sum = 0;
		foreach ($os_list as $name=>$count)
			$sum += $count;
		if ($sum == 0)
			$sum = 1;
		
		foreach ($os_list as $os_name=>$count)
		{
			$os_name = trim($os_name);
			if (trim($os_name) == '')
				$os_name = 'Unknown';
			array_push($points_labels, $os_name.' ('.sprintf("%01.2f", $count/$sum*100).'%)');
			array_push($points_values, $count);
		}
		
		$MyDataOS = new pData();    
		$MyDataOS->addPoints($points_values, "OS values");   
		$MyDataOS->setSerieDescription("OS values", "Application A"); 
		$MyDataOS->addPoints($points_labels, "Labels"); 
		$MyDataOS->setAbscissa("Labels"); 

	    $myPicture = create_common_image($lang['OS popularity'], 680, 250, $MyDataOS, 'pie');
		$myPicture->setShadow(TRUE,array("X"=>2,"Y"=>2,"R"=>0,"G"=>0,"B"=>0,"Alpha"=>50)); 

		$PieChart = new pPie($myPicture, $MyDataOS); 

		$PieChart->draw2DPie(220,125,array("ValueR"=>0, "ValueG"=>0, "ValueB"=>0, "ValueAlpha"=>80, "ValuePosition"=>PIE_VALUE_OUTSIDE, "LabelStacked"=>TRUE, "DrawLabels"=>TRUE, "DataGapAngle"=>8,"DataGapRadius"=>6,"Border"=>TRUE,"BorderR"=>255,"BorderG"=>255,"BorderB"=>255));

		$myPicture->setShadow(TRUE,array("X"=>1,"Y"=>1,"R"=>0,"G"=>0,"B"=>0,"Alpha"=>20));
		$myPicture->drawText(220,230,"Operating systems",array("DrawBox"=>TRUE,"BoxRounded"=>TRUE,"R"=>0,"G"=>0,"B"=>0,"Align"=>TEXT_ALIGN_TOPMIDDLE));

		// Additional OS statistics

		$win64_list = array();
		if (!$pony_db->get_64bit_stats($win64_list))
			die();

		if (!isset($win64_list['0']))
			$win64_list['0'] = '0';
		if (!isset($win64_list['1']))
			$win64_list['1'] = '0';

		$admin_list = array();
		if (!$pony_db->get_admin_stats($admin_list))
			die();

		if (!isset($admin_list['0']))
			$admin_list['0'] = '0';
		if (!isset($admin_list['1']))
			$admin_list['1'] = '0';

		if (count($win64_list) && count($admin_list))
		{
			$MyData = new pData();

			$MyData->addPoints(array($win64_list['0'], $admin_list['1']),"Probe 1");
			$MyData->addPoints(array($win64_list['1'], $admin_list['0']),"Probe 2");

			$MyData->addPoints(array('Architecture', 'Privileges'), "Labels");
			$MyData->setAbscissa("Labels");

			$MyData->normalize(100,"%");

			$x = 460;
			$y = 60;
			$myPicture->setDataSet($MyData);
			$myPicture->setShadow(FALSE);
			$myPicture->setGraphArea($x,$y,$x+200,190);
			$myPicture->drawFilledRectangle($x,$y,$x+200,190,array("R"=>255,"G"=>255,"B"=>255,"Surrounding"=>-255,"Alpha"=>20));
			$AxisBoundaries = array(0=>array("Min"=>0,"Max"=>100));
			$ScaleSettings = array("YMargin"=>10, "Mode"=>SCALE_MODE_MANUAL,"ManualScale"=>$AxisBoundaries,"DrawSubTicks"=>TRUE,"DrawArrows"=>FALSE);
			$myPicture->drawScale($ScaleSettings);
			$myPicture->setShadow(TRUE,array("X"=>1,"Y"=>1,"R"=>0,"G"=>0,"B"=>0,"Alpha"=>10));
			$settings = array("Gradient"=>TRUE, "DisplayPos"=>LABEL_POS_OUTSIDE, "DisplayValues"=>TRUE, "DisplayR"=>0, "DisplayG"=>0, "DisplayB"=>0, "DisplayShadow"=>TRUE, "Surrounding"=>30);
			$myPicture->drawBarChart($settings);
			$myPicture->setShadow(FALSE);
			$myPicture->drawText($x+30, 183, '32-bit', array("Align"=>TEXT_ALIGN_TOPMIDDLE, "R"=>0,"G"=>0,"B"=>0));
			$myPicture->drawText($x+30+40, 183, '64-bit', array("Align"=>TEXT_ALIGN_TOPMIDDLE, "R"=>0,"G"=>0,"B"=>0));
			$myPicture->drawText($x+30+100, 183, 'admin', array("Align"=>TEXT_ALIGN_TOPMIDDLE, "R"=>0,"G"=>0,"B"=>0));
			$myPicture->drawText($x+30+140, 183, 'user', array("Align"=>TEXT_ALIGN_TOPMIDDLE, "R"=>0,"G"=>0,"B"=>0));
			$myPicture->setShadow(TRUE, array("X"=>1,"Y"=>1,"R"=>0,"G"=>0,"B"=>0,"Alpha"=>20));
			$myPicture->drawText($x+100,230,"Additional OS statistics",array("DrawBox"=>TRUE,"BoxRounded"=>TRUE,"R"=>0,"G"=>0,"B"=>0,"Align"=>TEXT_ALIGN_TOPMIDDLE));
		}
	} else
	{
		$myPicture = create_common_image($lang['OS popularity'], 680, 250, NULL, 'pie');
	}
	$myPicture->stroke();
}

