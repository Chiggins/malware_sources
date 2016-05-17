
<html>
<body bgcolor="#C8C8C8">
</html>

<?php

session_start();
if(!isset($_SESSION['loggedin']))
{
die();
}
include ("config.php");
include("viewer_pagination.php");
?>