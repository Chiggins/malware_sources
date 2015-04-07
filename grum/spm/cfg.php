<?  
  $server = "http://mx1.alwaysdata.net/g/spm/";
  
  $dbserver = "mysql2.alwaysdata.com";
  $dbusrname="mx1";
  $passwrd="alwaysdata.com";
  
  $dbname="mx1_6";
  $dbNameDomains="Domains";

  $log_activity = false;

  $dbase=mysql_connect($dbserver,$dbusrname, $passwrd) or die ('I cannot connect to the database because: ' . mysql_error());
  mysql_select_db($dbname) or die("Could not select database: $dbname\n");
?>