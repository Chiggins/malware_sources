<?php

$config = array (
  'db' => 
  array (
    'dbdriver' => 'mysql',
    'dbuser' => 'root',
    'dbpassword' => 'Viewmate#21',
    'dsn' => 
    array (
      'dbhost' => 'localhost',
      'dbport' => '3306',
      'dbname' => 'baza3',
      'charset' => 'utf8',
    ),
    'dboptions' => 
    array (
      'PDO::MYSQL_ATTR_INIT_COMMAND' => 'set names utf8',
    ),
    'dbattributes' => 
    array (
      'ATTR_ERRMODE' => 'ERRMODE_EXCEPTION',
    ),
  ),
  'cookiename' => 'dS1G86KwRZ',
  'debug' => false,
  'siteurl' => 'http://0x43.ru',
  'realpath' => '/var/www/',
);

date_default_timezone_set('Europe/Moscow');