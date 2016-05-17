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

	require_once 'mod_dbase.php';

	$dbase = db_open();
	if (!$dbase) exit;

	$sql = 'SELECT DISTINCT bot_guid'
		 . '  FROM rep2';
	$res = mysqli_query($dbase, $sql);
	while ( list($bot_guid) = mysqli_fetch_row($res) ) {
		$aGUID[] = $bot_guid;
		
		$sql = 'SELECT ip, bot_version, os_version, language_id'
			 . '  FROM rep'
			 . " WHERE rep.bot_guid = '$bot_guid'"
			 . ' LIMIT 1';
		$res2 = mysqli_query($dbase, $sql);
		if ((!@$res2) || !mysqli_num_rows($res2)) {
			$aInfo[] = 'unknown bot';
		}
		else {
			list($ip, $bot_version, $os_version, $language_id) = mysqli_fetch_row($res2);
			$aInfo[] = "$ip, $bot_version, $os_version, $language_id";
		}
		
	}

	db_close($dbase);
	
	$input = strtolower( $_GET['input'] );
	$len = strlen($input);
	$limit = isset($_GET['limit']) ? (int) $_GET['limit'] : 0;
	
	
	$aResults = array();
	$count = 0;
	
	if ($len)
	{
		for ($i=0;$i<count($aGUID);$i++)
		{
			// had to use utf_decode, here
			// not necessary if the results are coming from mysql
			//
			if (strtolower(substr(utf8_decode($aGUID[$i]),0,$len)) == $input)
			{
				$count++;
				$aResults[] = array( "id"=>($i+1) ,"value"=>htmlspecialchars($aGUID[$i]), "info"=>htmlspecialchars($aInfo[$i]) );
			}
			
			if ($limit && $count==$limit)
				break;
		}
	}
	
	
	
	
	
	header ("Expires: Mon, 26 Jul 1997 05:00:00 GMT"); // Date in the past
	header ("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT"); // always modified
	header ("Cache-Control: no-cache, must-revalidate"); // HTTP/1.1
	header ("Pragma: no-cache"); // HTTP/1.0
	
	sleep(0);
	
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