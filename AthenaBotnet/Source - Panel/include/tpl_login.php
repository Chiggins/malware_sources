<?php

	if(!defined('AthenaHTTP')) header('Location: ..');

	$PAGE  = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">' . "\n";
	$PAGE .= '<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US">' . "\n";
	$PAGE .= '	<head profile="http://gmpg.org/xfn/11">' . "\n";
	$PAGE .= '		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />' . "\n";
	$PAGE .= '		<title>Athena</title>' . "\n";
	$PAGE .= '		<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Arimo" type="text/css">' . "\n";
	$PAGE .= '		<link rel="stylesheet" href="../styles/reset.css" type="text/css" />' . "\n";
	$PAGE .= '		<link rel="stylesheet" href="../styles/main.css" type="text/css" />' . "\n";
	$PAGE .= '		<script type="text/javascript" charset="UTF-8" src="../js/main.js"></script>' . "\n";
	$PAGE .= '	</head>' . "\n";
	$PAGE .= '	<body>' . "\n";
	$PAGE .= '		<div id="header">' . "\n";
	$PAGE .= '			<div id="logo"></div>' . "\n";
	$PAGE .= '			<div id="sidemenu">' . "\n";
	$PAGE .= '			</div>' . "\n";
	$PAGE .= '		</div>' . "\n";
	$PAGE .= '		<div id="outer" class="login">' . "\n";
	$PAGE .= '			<div class="content small">' . "\n";
	$PAGE .= '				<span class="title">Login</span>' . "\n";
	$PAGE .= '				<form action="../index.php" method="POST">' . "\n";
	$PAGE .= '					<p>' . "\n";
	$PAGE .= '						<span class="left">Username:</span>' . "\n";
	$PAGE .= '						<span class="right"><input name="username" type="text" /></span>' . "\n";
	$PAGE .= '					</p>' . "\n";
	$PAGE .= '					<p>' . "\n";
	$PAGE .= '						<span class="left">Password:</span>' . "\n";
	$PAGE .= '						<span class="right"><input name="password" type="password" /></span>' . "\n";
	$PAGE .= '					</p>' . "\n";
	$PAGE .= '					<span class="foot">' . "\n";
	$PAGE .= '						<input type="submit" value="Log in" /> ' . "\n";
	$PAGE .= '					</span>' . "\n";
	$PAGE .= '				</form>' . "\n";
	$PAGE .= '			</div>' . "\n";
	$PAGE .= '		</div>' . "\n";
	$PAGE .= '	</body>' . "\n";
	$PAGE .= '</html>' . "\n";

?>