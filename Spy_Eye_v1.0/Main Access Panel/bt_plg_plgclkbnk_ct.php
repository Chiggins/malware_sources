<?

include "config.php";

$zip = $_GET['zip'];
if (!@$zip)
  exit();
$zip = substr($zip, 0, 5);

$cities = $_GET['cities'];
if (!@$cities)
  exit();

$dbase = mysqli_connect (DB_SERVER, DB_USER, DB_PASSWORD, DB_NAME);
if ($dbase)
{
  $sql = "SELECT state"
       . "  FROM usa_zip"
	   . " WHERE zip = '$zip'"
	   . " LIMIT 1";
  $res = mysqli_query($dbase, $sql);
  if ((!@$res) || !mysqli_num_rows($res))
    exit();
  list($state) = mysqli_fetch_row($res);
  
  $match = preg_split('[;]', $cities);
  $ln = count($match);
  for ($i = 0; $i < $ln; $i++) {
    $city = $match[$i];
    $sql = "SELECT city"
	     . "  FROM usa_zip"
		 . " WHERE state = '$state'"
		 . "   AND city like '$city'"
		 . " LIMIT 1";
	$res = mysqli_query($dbase, $sql);
	if ((!@$res) || !mysqli_num_rows($res))
	  continue;
	
	echo $city;
	mysqli_close($dbase);
	exit;
  }
  
  mysqli_close($dbase);
}

?>
