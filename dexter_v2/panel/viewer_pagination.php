
<html>
<head>
<link href="style.css"  rel="stylesheet" type="text/css">
</head>


<?php


if(!isset($_SESSION['loggedin']))
{
die();
}

//Display all bots count
$query = "SELECT * FROM `logs`";
$result = mysql_query($query);
$AllBots = mysql_num_rows($result);
echo "<b> All Dumps:</b> " . $AllBots . "</br>";
echo "<b>Server Time: </b>" . date("r") . "</br></br>";
/////////////////////////////////////

	$tbl_name="logs";		//your table name
	// How many adjacent pages should be shown on each side?
	$adjacents = 3;
	
	/* 
	   First get total number of rows in data table. 
	   If you have a WHERE clause in your query, make sure you mirror it here.
	*/
	$query = "SELECT * FROM $tbl_name";  //FIXME: This is probably slowing the script
	$total_pages = mysql_num_rows(mysql_query($query));
	//$total_pages = $total_pages[num];
	
	/* Setup vars for query. */
	$targetpage = "viewer.php"; 	//your file name  (the name of this file)
	//$limit = 2; 								//how many items to show per page
	$query = "SELECT `Cnf_ValueInt` FROM `config` WHERE `Cnf_Name` = 'DumpsPerPage'";
	$row = mysql_fetch_array(mysql_query($query));
	$limit = $row["Cnf_ValueInt"];
	$page = isset($_GET['page']) ? $_GET['page'] : "";
	if($page) 
		$start = ($page - 1) * $limit; 			//first item to display on this page
	else
		$start = 0;								//if no page var is given, set start to 0
	
	/* Get data. */
	$sql = "SELECT * FROM $tbl_name LIMIT $start, $limit";
	$result = mysql_query($sql);
	
	/* Setup page vars for display. */
	if ($page == 0) $page = 1;					//if no page var is given, default to 1.
	$prev = $page - 1;							//previous page is page - 1
	$next = $page + 1;							//next page is page + 1
	$lastpage = ceil($total_pages/$limit);		//lastpage is = total pages / items per page, rounded up.
	$lpm1 = $lastpage - 1;						//last page minus 1
	
	/* 
		Now we apply our rules and draw the pagination object. 
		We're actually saving the code to a variable in case we want to draw it more than once.
	*/
	$pagination = "";
	if($lastpage > 1)
	{	
		$pagination .= "<div class=\"pagination\">";
		//previous button
		if ($page > 1) 
			$pagination.= "<a href=\"$targetpage?page=$prev\">previous</a>";
		else
			$pagination.= "<span class=\"disabled\">previous</span>";	
		
		//pages	
		if ($lastpage < 7 + ($adjacents * 2))	//not enough pages to bother breaking it up
		{	
			for ($counter = 1; $counter <= $lastpage; $counter++)
			{
				if ($counter == $page)
					$pagination.= "<span class=\"current\">$counter</span>";
				else
					$pagination.= "<a href=\"$targetpage?page=$counter\">$counter</a>";					
			}
		}
		elseif($lastpage > 5 + ($adjacents * 2))	//enough pages to hide some
		{
			//close to beginning; only hide later pages
			if($page < 1 + ($adjacents * 2))		
			{
				for ($counter = 1; $counter < 4 + ($adjacents * 2); $counter++)
				{
					if ($counter == $page)
						$pagination.= "<span class=\"current\">$counter</span>";
					else
						$pagination.= "<a href=\"$targetpage?page=$counter\">$counter</a>";					
				}
				$pagination.= "...";
				$pagination.= "<a href=\"$targetpage?page=$lpm1\">$lpm1</a>";
				$pagination.= "<a href=\"$targetpage?page=$lastpage\">$lastpage</a>";		
			}
			//in middle; hide some front and some back
			elseif($lastpage - ($adjacents * 2) > $page && $page > ($adjacents * 2))
			{
				$pagination.= "<a href=\"$targetpage?page=1\">1</a>";
				$pagination.= "<a href=\"$targetpage?page=2\">2</a>";
				$pagination.= "...";
				for ($counter = $page - $adjacents; $counter <= $page + $adjacents; $counter++)
				{
					if ($counter == $page)
						$pagination.= "<span class=\"current\">$counter</span>";
					else
						$pagination.= "<a href=\"$targetpage?page=$counter\">$counter</a>";					
				}
				$pagination.= "...";
				$pagination.= "<a href=\"$targetpage?page=$lpm1\">$lpm1</a>";
				$pagination.= "<a href=\"$targetpage?page=$lastpage\">$lastpage</a>";		
			}
			//close to end; only hide early pages
			else
			{
				$pagination.= "<a href=\"$targetpage?page=1\">1</a>";
				$pagination.= "<a href=\"$targetpage?page=2\">2</a>";
				$pagination.= "...";
				for ($counter = $lastpage - (2 + ($adjacents * 2)); $counter <= $lastpage; $counter++)
				{
					if ($counter == $page)
						$pagination.= "<span class=\"current\">$counter</span>";
					else
						$pagination.= "<a href=\"$targetpage?page=$counter\">$counter</a>";					
				}
			}
		}
		
		//next button
		if ($page < $counter - 1) 
			$pagination.= "<a href=\"$targetpage?page=$next\">next</a>";
		else
			$pagination.= "<span class=\"disabled\">next</span>";
		$pagination.= "</div>\n";		
	}
?>


	<?php
	
	echo '<table bgcolor="silver" border="1">';
    echo '<tr>';
    echo '<th>Type</th>';
	echo '<th>Dump</th>';
    echo '<th>Log Time</th>';
    echo '</tr>';


	$ValuesNames = array( "Type","Dump","InsertTime" );
	
		while($row = mysql_fetch_array($result)) {

	    $i = 0;	
        $html = '<tr>';	
		while(isset($ValuesNames[$i])) {
		
		$html.= '<td>';
		if($ValuesNames[$i]=="InsertTime") {
		$html.= date("r",$row[$ValuesNames[$i]]);
		} else {
        $html.= $row[$ValuesNames[$i]];
		}
		$html.= '</td>';
		
		$i++;
		}
		
		$html.= '</tr>';
		
		echo $html;
		
		}
		
		echo '</table>';
	?>

<?=$pagination?>
