
<html>
<body bgcolor="#C8C8C8">
<center>
<form enctype="multipart/form-data" action="<?php echo $_SERVER['PHP_SELF']; ?>" method="POST">
<input type="hidden" name="MAX_FILE_SIZE" value="MAX_FILE_SIZE" />
<input name="uploadedfile" type="file" />

<!--</form>-->
<form action="<?php echo $_SERVER['PHP_SELF']; ?>" method="post">
<!--<input type="text" name="type" size="10" /> -->

<input type="submit" value="Upload File" />
<!--<input type="submit" name="submit" value="Typed!" /> -->

</form>
</form>
</center>
</body>
</html>
<?php
session_start();
if(!isset($_SESSION['loggedin']))
{
die();
}


   //Config
   $Site_Url = "http://192.168.83.1/CasinoLoader/"; 
   $DirName = "exes";
   ////////////////////////////////////////
   
if(!empty($_FILES['uploadedfile']['name']) && !empty($_FILES)) {

$target_path = $DirName . "\\" . basename( $_FILES['uploadedfile']['name']); 

if(move_uploaded_file($_FILES['uploadedfile']['tmp_name'], $target_path)) {
    echo "The file ".  basename( $_FILES['uploadedfile']['name']). 
    " has been uploaded";
} else{
    echo "There was an error uploading the file, please try again!";
}

}

   if(!empty($_GET["del"])) {
   
   unlink($_GET["del"]);
   }
  
   	echo '<center><table bgcolor="silver" border="1">';
	echo '<tr>';
	echo '<th></th>';
	echo '<th>File Name</th>';
	echo '<th>URL</th>';
	echo '</tr>';
		
	$handle = opendir($DirName);
	
    while (false !== ($entry = readdir($handle))) {
	if ($entry != "." && $entry != "..") {
	    echo '<tr>';
		echo "<td><a href=\"upload.php?del=" . $DirName . "\\" . $entry . "\">Delete</a></td>";
		echo "<td>" . $entry . "</td>";
        echo '<td>' . $Site_Url . "load.php?request=" . substr($entry, 0, -4)  . "\n" . '</td>';
	    echo '</tr>';
		}
    }
	
	echo '</table></center>';
?>