<?php

	if(!defined('AthenaHTTP')) header('Location: ..');

	require_once './include/inc_botlist.php';
	
	if($SHOW_BOT_INFO)
	{
		$PAGE_INCLUDE .= '			<div class="content small">' . "\n";
		$PAGE_INCLUDE .= '				<span class="title">Bot Info</span>' . "\n";
		$PAGE_INCLUDE .= '				<p>' . "\n";
		$PAGE_INCLUDE .= '					<span class="left">Bot Id:</span>' . "\n";
		$PAGE_INCLUDE .= '					<span class="right"><input type="text" value="' . $BOT_INFO_ID . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '				</p>' . "\n";
		$PAGE_INCLUDE .= '				<p>' . "\n";
		$PAGE_INCLUDE .= '					<span class="left">Country:</span>' . "\n";
		$PAGE_INCLUDE .= '					<span class="right"><input type="text" value="' . $BOT_INFO_COUNTRY . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '				</p>' . "\n";
		$PAGE_INCLUDE .= '				<p>' . "\n";
		$PAGE_INCLUDE .= '					<span class="left">IP Address:</span>' . "\n";
		$PAGE_INCLUDE .= '					<span class="right"><input type="text" value="' . $BOT_INFO_IP . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '				</p>' . "\n";
		$PAGE_INCLUDE .= '				<p>' . "\n";
		$PAGE_INCLUDE .= '					<span class="left">Operating System:</span>' . "\n";
		$PAGE_INCLUDE .= '					<span class="right"><input type="text" value="' . $BOT_INFO_OS . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '				</p>' . "\n";
		$PAGE_INCLUDE .= '				<p>' . "\n";
		$PAGE_INCLUDE .= '					<span class="left">CPU Architecture:</span>' . "\n";
		$PAGE_INCLUDE .= '					<span class="right"><input type="text" value="' . $BOT_INFO_CPU . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '				</p>' . "\n";
		$PAGE_INCLUDE .= '				<p>' . "\n";
		$PAGE_INCLUDE .= '					<span class="left">Computer Type:</span>' . "\n";
		$PAGE_INCLUDE .= '					<span class="right"><input type="text" value="' . $BOT_INFO_TYPE . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '				</p>' . "\n";
		$PAGE_INCLUDE .= '				<p>' . "\n";
		$PAGE_INCLUDE .= '					<span class="left">CPU Cores:</span>' . "\n";
		$PAGE_INCLUDE .= '					<span class="right"><input type="text" value="' . $BOT_INFO_CORES . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '				</p>' . "\n";
		$PAGE_INCLUDE .= '				<p>' . "\n";
		$PAGE_INCLUDE .= '					<span class="left">Version:</span>' . "\n";
		$PAGE_INCLUDE .= '					<span class="right"><input type="text" value="' . $BOT_INFO_VER . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '				</p>' . "\n";
		$PAGE_INCLUDE .= '				<p>' . "\n";
		$PAGE_INCLUDE .= '					<span class="left">.NET:</span>' . "\n";
		$PAGE_INCLUDE .= '					<span class="right"><input type="text" value="' . $BOT_INFO_NET . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '				</p>' . "\n";
		$PAGE_INCLUDE .= '				<p>' . "\n";
		$PAGE_INCLUDE .= '					<span class="left">Killed Processes:</span>' . "\n";
		$PAGE_INCLUDE .= '					<span class="right"><input type="text" value="' . $BOT_INFO_BOTS . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '				</p>' . "\n";
		$PAGE_INCLUDE .= '				<p>' . "\n";
		$PAGE_INCLUDE .= '					<span class="left">File Modifications:</span>' . "\n";
		$PAGE_INCLUDE .= '					<span class="right"><input type="text" value="' . $BOT_INFO_FILE . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '				</p>' . "\n";
		$PAGE_INCLUDE .= '				<p>' . "\n";
		$PAGE_INCLUDE .= '					<span class="left">Registry Modifications:</span>' . "\n";
		$PAGE_INCLUDE .= '					<span class="right"><input type="text" value="' . $BOT_INFO_REG . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '				</p>' . "\n";
		$PAGE_INCLUDE .= '				<p>' . "\n";
		$PAGE_INCLUDE .= '					<span class="left">Rights:</span>' . "\n";
		$PAGE_INCLUDE .= '					<span class="right"><input type="text" value="' . $BOT_INFO_ADMIN . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '				</p>' . "\n";
		$PAGE_INCLUDE .= '				<p>' . "\n";
		$PAGE_INCLUDE .= '					<span class="left">Ram Usage:</span>' . "\n";
		$PAGE_INCLUDE .= '					<span class="right"><input type="text" value="' . $BOT_INFO_RAM . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '				</p>' . "\n";
		$PAGE_INCLUDE .= '				<p>' . "\n";
		$PAGE_INCLUDE .= '					<span class="left">Is Busy:</span>' . "\n";
		$PAGE_INCLUDE .= '					<span class="right"><input type="text" value="' . $BOT_INFO_BUSY . '" /></span>' . "\n";
		$PAGE_INCLUDE .= '				</p>' . "\n";
		
		$PAGE_INCLUDE .= '			</div>' . "\n";	
	}
	
	$PAGE_INCLUDE .= '			<div class="content">' . "\n";
	$PAGE_INCLUDE .= '				<span class="title">Botlist</span>' . "\n";
	$PAGE_INCLUDE .= '				<table>' . "\n";
	$PAGE_INCLUDE .= '					<tr>' . "\n";
	$PAGE_INCLUDE .= '						<th>Bot Id</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Country</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>IP Address</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Operating System</th>' . "\n";
	/*$PAGE_INCLUDE .= '						<th>CPU Arch.</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Cores</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Computer Type</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>.NET Version</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Admin/User</th>' . "\n";*/
	$PAGE_INCLUDE .= '						<th>Ram Usage</th>' . "\n";	
	$PAGE_INCLUDE .= '						<th>Version</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Last Seen</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Status</th>' . "\n";
	$PAGE_INCLUDE .= '						<th></th>' . "\n";
	$PAGE_INCLUDE .= '					</tr>' . "\n";
	$PAGE_INCLUDE .= $PAGE_INCLUDE_BOTLIST;
	$PAGE_INCLUDE .= '					<tr>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	/*$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";*/
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '					</tr>' . "\n";
	$PAGE_INCLUDE .= '				</table>' . "\n";
	$PAGE_INCLUDE .= $PAGE_INCLUDE_PAGINATE;
	$PAGE_INCLUDE .= '			</div>' . "\n";

?>