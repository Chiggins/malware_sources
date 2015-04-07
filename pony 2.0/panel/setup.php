<?php

error_reporting(E_ALL);

// make sure included files do not generate extra output
ob_start();

if (!isset($proxy_config))
{
    // use local config file
	$config_file = "config.php";
} else
{
	// use proxy config file
	$config_file = $proxy_config;
}

if (!file_exists($config_file))
{
	echo '<h4><font color="#b72525">Error! Server configuration problem!</font></h4>';
	echo '<div style="border:#ee0000 solid 1px;	background-color:#f6adad; color:#000000; width:500px; margin-bottom:20px">';
	echo 'Missing configuration file `<b>'.$config_file.'</b>`.';
	echo '</div>';
	die();
}

require_once($config_file);
require_once("includes/misc.php");
require_once("includes/password_modules.php");
require_once("includes/database.php");

// clean output buffer
ob_end_clean();

$pony_db = new pony_db();

if (!$pony_db->connect($mysql_host, $mysql_user, $mysql_pass))
{
	echo '<h4><font color="#b72525">Error! Server configuration problem!</font></h4>';
	echo '<div style="border:#ee0000 solid 1px;	background-color:#f6adad; color:#000000; width:500px; margin-bottom:20px">';
	echo 'Cannot connect to mysql database, check settings in configuration file `<b>config.php</b>`.<br />';
	echo 'MySQL error: '.mysql_error();
	echo '</div>';
	die();
}

if (!$pony_db->select_db($mysql_database))
{
	echo '<h4><font color="#b72525">Error! Server configuration problem!</font></h4>';
	echo '<div style="border:#ee0000 solid 1px;	background-color:#f6adad; color:#000000; width:500px; margin-bottom:20px">';
	echo('Cannot select mysql database, please, check if the `<b>'.$mysql_database.'</b>` database exists or you have enough rights to create new databases.<br />');
	echo 'MySQL error: '.mysql_error().'.';
	echo '</div>';
	die();
}

$all_tables_exist = $pony_db->all_tables_exist();
$some_tables_exist = $pony_db->some_tables_exist();

if (!$pony_db->state)
{
	echo '<h4><font color="#b72525">Error! Server configuration problem!</font></h4>';
	echo '<div style="border:#ee0000 solid 1px;	background-color:#f6adad; color:#000000; width:500px; margin-bottom:20px">';
	echo 'Unknown MySQL error occured: '.mysql_error().'.';
	echo '</div>';
	die();
}

if (!install_check(false, true))
{
	echo '<h4><font color="#b72525">Attention! Server configuration problem!</font></h4>';
	echo '<div style="border:#ee0000 solid 1px;	background-color:#f6adad; color:#000000; width:500px; margin-bottom:20px">';
	install_check(true, true);
	echo '</div>';
}

$set_admin_pass = trim(assign($_REQUEST['set_admin_pass'])) == '1';

if (!$all_tables_exist && $set_admin_pass)
{
	$admin_login = trim(assign($_REQUEST['login']));
	$admin_pass = trim(assign($_REQUEST['password']));
	$admin_pass_verify = trim(assign($_REQUEST['confirm_password']));

	if (!$admin_login)
	{
		die("Empty login names are now allowed!<br /><a href=\"".$_SERVER['SCRIPT_NAME']."\">Go back and try again</a>.");
	}

	if (!$admin_pass)
	{
		die("Empty passwords are now allowed!<br /><a href=\"".$_SERVER['SCRIPT_NAME']."\">Go back and try again</a>.");
	}

	if ($admin_pass != $admin_pass_verify)
	{
		die("Admin and confirm passwords mismatch!<br /><a href=\"".$_SERVER['SCRIPT_NAME']."\">Go back and try again</a>.");
	}

	if ($pony_db->create_tables() && $pony_db->add_user($admin_login, $admin_pass, 'admin_all'))
	{
		echo "Installation complete!<br />";
		echo "<a href=\"".htmlspecialchars(str_replace("setup", "admin", $_SERVER['SCRIPT_NAME']), ENT_QUOTES, 'cp1251')."\">Proceed to administration panel</a>.";
	} else
	{
		die("Installation failed: `<b>".mysql_error()."</b>`");
	}
	die();
}

if (!$all_tables_exist)
{
	if ($some_tables_exist && trim(assign($_REQUEST['delete_tables']) == '1'))
	{
		$pony_db->delete_tables();
		$some_tables_exist = $pony_db->some_tables_exist();
	}

	if ($some_tables_exist)
	{
		echo '<h4><font color="#b72525">Error! Server configuration problem!</font></h4>';
		echo '<div style="border:#ee0000 solid 1px;	background-color:#f6adad; color:#000000; width:500px; margin-bottom:20px">';
		echo 'Missing required MySQL tables. Please, delete Pony MySQL tables and try again.<br />';
		echo '</div>';
		echo '<a href="'.$_SERVER['SCRIPT_NAME'].'?delete_tables=1">Delete Pony MySQL tables and restart installation process</a>.';
		die();
	}

	die ("MySQL database installation. Please, provide administrator credentials:<table>".
		"<form action=\"".$_SERVER['SCRIPT_NAME']."\" method=\"post\">".
		"<input type=\"hidden\" name=\"set_admin_pass\" value=\"1\">".
		"<tr><td>Admin login: </td><td><input type=\"text\" name=\"login\"></td></tr>".
		"<tr><td>Admin password: </td><td><input type=\"password\" name=\"password\"></td></tr>".
		"<tr><td>Confirm password: </td><td><input type=\"password\" name=\"confirm_password\"></td></tr><br />".
		"<tr><td colspan=2 align=right><input type=\"submit\" value=\"Install\"></td></tr>".
		"</form>".
		"</table>");
} else
{
	die('Installation complete!<br />'.
		"<a href=\"".htmlspecialchars(str_replace("setup", "admin", $_SERVER['SCRIPT_NAME']), ENT_QUOTES, 'cp1251')."\">Proceed to administration panel</a>.".
		'<br /><br />To restart installation process, please, delete MySQL tables.<br />'
		);

}

