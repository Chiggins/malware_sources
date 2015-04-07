<?php
include("parameters.php");
set_time_limit(0);

// You don't need to edit this file unless you change some filenames

//**************** these are the original comments ***************************
// ------------------------------------------------------------------------- //
// Insérer le contenu d'un fichier CSV dans une table MySQL.                 //
// ------------------------------------------------------------------------- //
// Auteur: Perrich                                                           //
// Email:  perrich@club-internet.fr                                          //
// Web:    http://www.frshop.net/                                            //
// ------------------------------------------------------------------------- //
// $fileName  : le nom du fichier
// $tableName : le nom de la table
// $con       : id de connexion à MySQL (recupéré avec $con = mysql_connect(...)
//**************** end of original comments *********************************

function multiple_query($q)
//**** Thanks a lot me@harveyball.com - http://www.php.net/manual/en/function.mysql-query.php
   {
   $tok = strtok($q, ";;\n");
   while ($tok)
       {
       $results=mysql_query("$tok");
       $tok = strtok(";;\n");
       }
   return $results;
   }

mysql_connect($db_host,$db_user,$db_pass) or die("Unable to connect to database");
mysql_select_db($database) or die("Unable to select database");

$fileName="ip-to-country.csv";
$tableName="ip2country";
$br=chr(13).chr(10);

// let's create the ip2country table
$query ="CREATE TABLE ".$tableName." (
IP_FROM bigint(20) unsigned NOT NULL,
IP_TO bigint(20) unsigned NOT NULL,
COUNTRY_CODE2 char(2) NOT NULL,
COUNTRY_CODE3 char(3) NOT NULL,
COUNTRY_NAME varchar(50) NOT NULL,
PRIMARY KEY (IP_FROM));";
if(mysql_query($query)==false){die('Error : impossible to create table "'.$tableName.'"'.$br.'MySQL said : '.mysql_error());}
echo '"'.$tableName.'" table created. We are now going to fill it. This may take a long time (there are around 70,000 lines).'.$br;

// now fill it
    $file = fopen( $fileName, 'r' );
    $k = 0;
  
    while ( ! feof( $file ) )
    {
        $k++;
	if(($k/5000)==intval($k/5000)){echo $k.' lines inserted...'.$br;}
        $line = fgets( $file, 1024 );

        if ( strlen( $line ) > 2 )
        {
	    $requete = 'INSERT INTO '.$tableName.' VALUES ('.$line.' ) ';
            if ( ! mysql_query ($requete) )
                echo 'Error on line '.$k.' : '.mysql_error().$br.'The MySQL query was :'.$requete.$br;
        }
        else
            echo 'Line # '.$k.' ignored (size<2).'.$br;
    }
    fclose( $file );

// now remove useless data
$query ="ALTER TABLE `ip2country`
  DROP `COUNTRY_CODE3`,
  DROP `COUNTRY_NAME`;";
if(mysql_query($query)==false){die('Error : impossible to edit table "'.$tableName.'"'.$br.'MySQL said : '.mysql_error());}

echo '"'.$tableName.'" table successfully filled. We are now creating the "country" table.';

// let's create the country table
$query ="CREATE TABLE country (
  iso CHAR(2) NOT NULL PRIMARY KEY,
  name VARCHAR(80) NOT NULL,
  printable_name VARCHAR(80) NOT NULL,
  iso3 CHAR(3),
  numcode SMALLINT);";
if(mysql_query($query)==false){die('Error : impossible to create table "country"'.$br.'MySQL said : '.mysql_error());}

if (file_exists("iso_country_list.sql"))
	{
	$query=file_get_contents("iso_country_list.sql");
	if(multiple_query($query)==false){die('Error creating country table.'.$br.'MySQL said : '.mysql_error());}
	}
else {die('Oops ! Where did you put the iso_country_list.sql file ?? - Couldn\'t create the country table !');}


echo 'Operation successful !';

mysql_close();
?>