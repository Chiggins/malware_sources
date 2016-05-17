<?php

	if(!defined('AthenaHTTP')) header('Location: ..');

	$PAGE_INCLUDE = '';
	
	require_once './include/inc_userlist.php';
	
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
	$PAGE_INCLUDE .= '				<span class="title">Add User</span>' . "\n";
	$PAGE_INCLUDE .= '				<form action="./index.php?p=userlist" method="POST">' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Username:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right"><input type="text" name="user_username" /></span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Password:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right"><input type="text" name="user_password" /></span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Admin:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right">' . "\n";
	$PAGE_INCLUDE .= '							<select name="user_admin">' . "\n";
	$PAGE_INCLUDE .= '								<option value="yes">Yes</option>' . "\n";
	$PAGE_INCLUDE .= '								<option value="no" selected>No</option>' . "\n";
	$PAGE_INCLUDE .= '							</select>' . "\n";
	$PAGE_INCLUDE .= '						</span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Command Privileges:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right">' . "\n";
	$PAGE_INCLUDE .= '							<select name="user_privs[]" multiple>' . "\n";
	$PAGE_INCLUDE .= '								<option value="priv1">Download & Execute/Shell</option>' . "\n";
	$PAGE_INCLUDE .= '								<option value="priv2">DDoS/View/SmartView</option>' . "\n";
	$PAGE_INCLUDE .= '								<option value="priv3">Botkill</option>' . "\n";
	$PAGE_INCLUDE .= '								<option value="priv4">Update/Uninstall</option>' . "\n";
	$PAGE_INCLUDE .= '							</select>' . "\n";
	$PAGE_INCLUDE .= '						</span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<span class="foot">' . "\n";
	$PAGE_INCLUDE .= '						<input type="submit" value="Add User" /> ' . "\n";
	$PAGE_INCLUDE .= '					</span>' . "\n";
	$PAGE_INCLUDE .= '				</form>' . "\n";
	$PAGE_INCLUDE .= '			</div>' . "\n";
	$PAGE_INCLUDE .= '			<div class="content">' . "\n";
	$PAGE_INCLUDE .= '				<span class="title">Userlist</span>' . "\n";
	$PAGE_INCLUDE .= '				<table>' . "\n";
	$PAGE_INCLUDE .= '					<tr>' . "\n";
	$PAGE_INCLUDE .= '						<th>User Id</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Username</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Last IP</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Last Seen</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Command Privileges</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Admin</th>' . "\n";
	$PAGE_INCLUDE .= '						<th></th>' . "\n";
	$PAGE_INCLUDE .= '					</tr>' . "\n";
	$PAGE_INCLUDE .= $PAGE_INCLUDE_USERLIST;
	$PAGE_INCLUDE .= '					<tr>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '					</tr>' . "\n";
	$PAGE_INCLUDE .= '				</table>' . "\n";
	$PAGE_INCLUDE .= '			</div>' . "\n";

?>