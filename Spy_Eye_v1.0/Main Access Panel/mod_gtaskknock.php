<?php

require_once 'mod_dbase.php';

$dbase = db_open();
if (!$dbase) exit;

$knocklink = $_POST['knocklink'];
$knockscnt = $_POST['knockscnt'];
$note = $_POST['note'];
	
// Создаём глобальное задание
$sql = " INSERT INTO gtask_knock_t"
	 . " VALUES (null, '$knocklink', $knockscnt, '$note')";
$res = mysqli_query($dbase, $sql);
if (mysqli_affected_rows($dbase) != 1) {
	echo "Wrong query : (\"$sql\")";
	db_close($dbase);
	exit();
}

$idgtask = mysqli_insert_id($dbase);

for ($i = 0; $i < $knockscnt; $i++) {
	$sql = " INSERT INTO tasks_knock_t "
		 . " VALUES (null, $idgtask, NULL, 0, NULL)";
	$res = mysqli_query($dbase, $sql);
	if (mysqli_affected_rows($dbase) != 1) {
		echo "Cannot create task (\"$sql\")";
		db_close($dbase);
		exit();
	}
}

if ($knockscnt > 0)
	echo "<br><b>$knockscnt records</b> was <font class='ok'>successfully</font> inserted<br>";

db_close($dbase);

?>