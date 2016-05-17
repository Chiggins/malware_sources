<?php

	if(!defined('AthenaHTTP')) header('Location: ..');

	$HELP_CONTENT = @file_get_contents('./help.txt');
	$HELP_CONTENT = str_replace("\n", '<br />', $HELP_CONTENT);
	$HELP_CONTENT = str_replace("\t", '&nbsp;&nbsp;&nbsp;&nbsp;', $HELP_CONTENT);
	
	$PAGE_INCLUDE  = '			<div class="content">' . "\n";
	$PAGE_INCLUDE .= '				<span class="title">Help</span>' . "\n";
	$PAGE_INCLUDE .= '				<div id="help">' . "\n";
	$PAGE_INCLUDE .= $HELP_CONTENT;
	$PAGE_INCLUDE .= '				</div>' . "\n";
	$PAGE_INCLUDE .= '			</div>' . "\n";
	
?>