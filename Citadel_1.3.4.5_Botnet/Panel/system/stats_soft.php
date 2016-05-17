<?php if(!defined('__CP__'))die();

$limit = isset($_GET['limit'])? $_GET['limit'] : 50;
$type = isset($_GET['type']) ? (int)$_GET['type'] : BLT_ANALYTICS_SOFTWARE;

$stats = array(); // array(   array(name, count)  )
$R = mysql_query(sprintf(
			'SELECT `vendor`, `product`, `count` FROM `botnet_software_stat` 
			WHERE `type`=%d 
				AND `vendor` NOT LIKE "Microsoft%%"
				AND `vendor` NOT LIKE "Google%%"
				AND `vendor` NOT LIKE "Apple%%"
			ORDER BY `count` DESC LIMIT %d;',
			$type, $limit
			));
if (!$R) die();
while (!is_bool($r = mysql_fetch_row($R)))
	$stats[] = array("{$r[0]} / {$r[1]}", (int)$r[2]);




ThemeBegin(LNG_STATS, 0, 0, 0);

echo
str_replace('{WIDTH}', '100%', THEME_DIALOG_BEGIN).
  str_replace(array('{COLUMNS_COUNT}', '{TEXT}'), array(1, LNG_STATS.THEME_STRING_SPACE/*.botnetsToListBox($limit, '')*/), THEME_DIALOG_TITLE);
  
print '<tr><td><ul id="statMenu"></div>';
foreach (array(
			BLT_ANALYTICS_SOFTWARE => 'Software',
			BLT_ANALYTICS_FIREWALL => "Firewall",
			BLT_ANALYTICS_ANTIVIRUS => "Antivirus"
			) as $t => $tn) {
	if ($t == $type){
		print '<li class="active">'.$tn.'</li>';
		$typeName = $tn;
		} else 
		print '<li><a href="?m=stats_soft&type='.$t.'">'.$tn.'</a></li>';
	}
print '</ul></td></tr>';
  
echo THEME_DIALOG_ROW_BEGIN.
      str_replace('{COLUMNS_COUNT}', 1, THEME_DIALOG_ITEM_CHILD_BEGIN).
        str_replace('{WIDTH}', '33%', THEME_LIST_BEGIN).
        '<div id="PieChart" style="width: 100%; height: 500px;"></div>'.
        THEME_LIST_END.
      THEME_DIALOG_ITEM_CHILD_END.
    THEME_DIALOG_ROW_END.

    THEME_DIALOG_ROW_BEGIN.
      str_replace('{COLUMNS_COUNT}', 1, THEME_DIALOG_ITEM_CHILD_BEGIN).
        str_replace('{WIDTH}', '33%', THEME_LIST_BEGIN).
        '<div id="TableChart"></div>'.
        THEME_LIST_END.
      THEME_DIALOG_ITEM_CHILD_END.
    THEME_DIALOG_ROW_END.
    
  THEME_DIALOG_END;

$json = json_encode($stats);

echo <<<JSON
<script type="text/javascript">
window.dx_input_data = $json;
window.dx_typeName = '$typeName';
</script>
JSON;

echo <<<HTML
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<script type="text/javascript">
	google.load("visualization", "1.0", {packages:['corechart', 'table']});
	google.setOnLoadCallback(drawCharts);
	
	function drawCharts() {
		drawChart(window.dx_input_data, 'PieChart', 'TableChart', window.dx_typeName);
		}
	
	function drawChart(input_data, pie_display, table_display, title) {
		var data = new google.visualization.DataTable();
		data.addColumn('string', 'Company / Software');
		data.addColumn('number', 'Count');
		data.addRows(input_data);

		var options = {
			title: title
			};

		var chart = new google.visualization.PieChart(document.getElementById(pie_display));
		chart.draw(data, options);
		
		var table = new google.visualization.Table(document.getElementById(table_display));
		table.draw(data, {/*showRowNumber: true*/});
		}
	</script>
HTML;


ThemeEnd();
