
<?php
session_start(); // This starts the session which is like a cookie, but it isn't saved on your hdd and is much more secure.

include("config.php");

if(isset($_SESSION['loggedin']))
{

} // That bit of code checks if you are logged in or not, and if you are, you can't log in again!
if(isset($_POST['submit']))
{
   $name = mysql_real_escape_string($_POST['username']); // The function mysql_real_escape_string() stops hackers!
   $pass = mysql_real_escape_string($_POST['password']); // We won't use MD5 encryption here because it is the simple tutorial, if you don't know what MD5 is, dont worry!
   $mysql = mysql_query("SELECT * FROM users WHERE name = '{$name}' AND password = '{$pass}'"); // This code uses MySQL to get all of the users in the database with that username and password.
 
   if(mysql_num_rows($mysql) < 1)
   {
     echo("Please disable your SOCKS,Proxy or VPN and try again.");
	 die();
   } else { // That snippet checked to see if the number of rows the MySQL query was less than 1, so if it couldn't find a row, the password is incorrect or the user doesn't exist!
   $_SESSION['loggedin'] = "YES"; // Set it so the user is logged in!
   $_SESSION['name'] = $name; // Make it so the username can be called by $_SESSION['name']
  $host  = $_SERVER['HTTP_HOST'];
  $uri   = rtrim(dirname($_SERVER['PHP_SELF']), '/\\');
  $extra = 'main.php';
  header("Location: http://$host$uri/$extra");
   }
} // That bit of code logs you in! The "$_POST['submit']" bit is the submission of the form down below VV
echo "<center><form type='login.php' method='POST'>
Username: <br>
<input type='text' name='username'><br>
Password: <br>
<input type='password' name='password'><br>
<input type='submit' name='submit' value='Login'>
</form></center>"; // That set up the form to enter your password and username to login.
?>
