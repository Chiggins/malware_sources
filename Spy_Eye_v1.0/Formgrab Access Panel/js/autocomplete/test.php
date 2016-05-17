<?php

/*
note:
this is just a static test version using a hard-coded countries array.
normally you would be populating the array out of a database

the returned xml has the following structure
<results>
	<rs>foo</rs>
	<rs>bar</rs>
</results>
*/

	$aUsers = array(
		"Ädams, Egbert",
		"Altman, Alisha",
		"Archibald, Janna",
		"Auman, Cody",
		"Bagley, Sheree",
		"Ballou, Wilmot",
		"Bard, Cassian",
		"Bash, Latanya",
		"Beail, May",
		"Black, Lux",
		"Bloise, India",
		"Blyant, Nora",
		"Bollinger, Carter",
		"Burns, Jaycob",
		"Carden, Preston",
		"Carter, Merrilyn",
		"Christner, Addie",
		"Churchill, Mirabelle",
		"Conkle, Erin",
		"Countryman, Abner",
		"Courtney, Edgar",
		"Cowher, Antony",
		"Craig, Charlie",
		"Cram, Zacharias",
		"Cressman, Ted",
		"Crissman, Annie",
		"Davis, Palmer",
		"Downing, Casimir",
		"Earl, Missie",
		"Eckert, Janele",
		"Eisenman, Briar",
		"Fitzgerald, Love",
		"Fleming, Sidney",
		"Fuchs, Bridger",
		"Fulton, Rosalynne",
		"Fye, Webster",
		"Geyer, Rylan",
		"Greene, Charis",
		"Greif, Jem",
		"Guest, Sarahjeanne",
		"Harper, Phyllida",
		"Hildyard, Erskine",
		"Hoenshell, Eulalia",
		"Isaman, Lalo",
		"James, Diamond",
		"Jenkins, Merrill",
		"Jube, Bennett",
		"Kava, Marianne",
		"Kern, Linda",
		"Klockman, Jenifer",
		"Lacon, Quincy",
		"Laurenzi, Leland",
		"Leichter, Jeane",
		"Leslie, Kerrie",
		"Lester, Noah",
		"Llora, Roxana",
		"Lombardi, Polly",
		"Lowstetter, Louisa",
		"Mays, Emery",
		"Mccullough, Bernadine",
		"Mckinnon, Kristie",
		"Meyers, Hector",
		"Monahan, Penelope",
		"Mull, Kaelea",
		"Newbiggin, Osmond",
		"Nickolson, Alfreda",
		"Pawle, Jacki",
		"Paynter, Nerissa",
		"Pinney, Wilkie",
		"Pratt, Ricky",
		"Putnam, Stephanie",
		"Ream, Terrence",
		"Rumbaugh, Noelle",
		"Ryals, Titania",
		"Saylor, Lenora",
		"Schofield, Denice",
		"Schuck, John",
		"Scott, Clover",
		"Smith, Estella",
		"Smothers, Matthew",
		"Stainforth, Maurene",
		"Stephenson, Phillipa",
		"Stewart, Hyram",
		"Stough, Gussie",
		"Strickland, Temple",
		"Sullivan, Gertie",
		"Swink, Stefanie",
		"Tavoularis, Terance",
		"Taylor, Kizzy",
		"Thigpen, Alwyn",
		"Treeby, Jim",
		"Trevithick, Jayme",
		"Waldron, Ashley",
		"Wheeler, Bysshe",
		"Whishaw, Dodie",
		"Whitehead, Jericho",
		"Wilks, Debby",
		"Wire, Tallulah",
		"Woodworth, Alexandria",
		"Zaun, Jillie"
	);
	
	
	$aInfo = array(
		"Bedfordshire",
		"Buckinghamshire",
		"Cambridgeshire",
		"Cheshire",
		"Cornwall",
		"Cumbria",
		"Derbyshire",
		"Devon", 
		"Dorset", 
		"Durham", 
		"East Sussex",
		"Essex",
		"Gloucestershire",
		"Hampshire",
		"Hertfordshire", 
		"Kent", 
		"Lancashire",
		"Leicestershire",
		"Lincolnshire",
		"Norfolk",
		"Northamptonshire",
		"Northumberland", 
		"North Yorkshire", 
		"Nottinghamshire",
		"Oxfordshire",
		"Shropshire",
		"Somerset",
		"Staffordshire",
		"Suffolk", 
		"Surrey",
		"Warwickshire",
		"West Sussex",
		"Wiltshire",
		"Worcestershire", 
		"Durham", 
		"East Sussex",
		"Essex",
		"Gloucestershire",
		"Hampshire",
		"Hertfordshire", 
		"Kent", 
		"Lancashire",
		"Leicestershire",
		"Lincolnshire",
		"Norfolk",
		"Northamptonshire",
		"Northumberland", 
		"North Yorkshire", 
		"Nottinghamshire",
		"Oxfordshire",
		"Shropshire",
		"Somerset",
		"Staffordshire",
		"Suffolk", 
		"Surrey",
		"Warwickshire",
		"West Sussex",
		"Wiltshire",
		"Worcestershire", 
		"Durham", 
		"East Sussex",
		"Essex",
		"Gloucestershire",
		"Hampshire",
		"Hertfordshire", 
		"Kent", 
		"Lancashire",
		"Leicestershire",
		"Lincolnshire",
		"Norfolk",
		"Northamptonshire",
		"Northumberland", 
		"North Yorkshire", 
		"Nottinghamshire",
		"Oxfordshire",
		"Shropshire",
		"Somerset",
		"Staffordshire",
		"Suffolk", 
		"Surrey",
		"Warwickshire",
		"West Sussex",
		"Wiltshire",
		"Worcestershire", 
		"Durham", 
		"East Sussex",
		"Essex",
		"Gloucestershire",
		"Hampshire",
		"Hertfordshire", 
		"Kent", 
		"Lancashire",
		"Leicestershire",
		"Lincolnshire",
		"Norfolk",
		"Northamptonshire",
		"Northumberland", 
		"North Yorkshire", 
		"Nottinghamshire"
	);
	
	
	$input = strtolower( $_GET['input'] );
	$len = strlen($input);
	$limit = isset($_GET['limit']) ? (int) $_GET['limit'] : 0;
	
	
	$aResults = array();
	$count = 0;
	
	if ($len)
	{
		for ($i=0;$i<count($aUsers);$i++)
		{
			// had to use utf_decode, here
			// not necessary if the results are coming from mysql
			//
			if (strtolower(substr(utf8_decode($aUsers[$i]),0,$len)) == $input)
			{
				$count++;
				$aResults[] = array( "id"=>($i+1) ,"value"=>htmlspecialchars($aUsers[$i]), "info"=>htmlspecialchars($aInfo[$i]) );
			}
			
			if ($limit && $count==$limit)
				break;
		}
	}
	
	
	
	
	
	header ("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); // Date in the past
	header ("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT"); // always modified
	header ("Cache-Control: no-cache, must-revalidate"); // HTTP/1.1
	header ("Pragma: no-cache"); // HTTP/1.0
	
	sleep(2);
	
	if (isset($_REQUEST['json']))
	{
		header("Content-Type: application/json");
	
		echo "{\"results\": [";
		$arr = array();
		for ($i=0;$i<count($aResults);$i++)
		{
			$arr[] = "{\"id\": \"".$aResults[$i]['id']."\", \"value\": \"".$aResults[$i]['value']."\", \"info\":\"".$aResults[$i]['info']."\"}";
		}
		echo implode(", ", $arr);
		echo "]}";
	}
	else
	{
		header("Content-Type: text/xml");

		echo "<?xml version=\"1.0\" encoding=\"utf-8\" ?><results>";
		for ($i=0;$i<count($aResults);$i++)
		{
			echo "<rs id=\"".$aResults[$i]['id']."\" info=\"".$aResults[$i]['info']."\">".$aResults[$i]['value']."</rs>";
		}
		echo "</results>";
	}
?>