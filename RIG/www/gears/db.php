<?php


/* !=== DB Class === */
class db {

	private $di;
	private $link;
	private $callsCount=0;
	private $callsDebug=Array();

	// конструктор
	function __construct($di=NULL) {
		if (isset($di) && is_object($di)) {
			$this->di = $di;
		} else { exit('Wl core controller is not set'); }
	}
	
	// функция соединения с БД
	function connect($dbdata) {
		$driver = $dbdata['db'][ "dbdriver" ];
		$dsn = "${driver}:" ;
		$user = $dbdata['db'][ "dbuser" ] ;
		$password = $dbdata['db'][ "dbpassword" ] ;
		$options = $dbdata['db'][ "dboptions" ] ;
		$attributes = $dbdata['db'][ "dbattributes" ] ;
		
		// перечитываем аттрибуты
		foreach ( $dbdata['db'][ "dsn" ] as $k => $v ) { $dsn .= "${k}=${v};"; }
		
		try {
			// стараемся создать подключение
			$this->link = new PDO ( $dsn, $user, $password, $options ) ;
			// устанавливаем аттрибуты
			foreach ( $attributes as $k => $v ) {
				$this->link -> setAttribute ( constant ( "PDO::{$k}" ), constant ( "PDO::{$v}" ) ) ;
			}
			
		} catch(PDOException $e) {
			// если что-то не так, то вываливаем ошибку	

		//file_put_contents('/var/www/html/bbb.bbb', $e->getMessage()."\r\n", FILE_APPEND);

			//errorHandler(0,$e -> getMessage(),__FILE__,__LINE__);
			
		}
	}
	
	function parseQuery($q) {
		$q = str_replace("\n", " ", $q);
		$q = str_replace("\r", " ", $q);
		$q = str_replace("\t", " ", $q);
		$q = preg_replace("/\/\*.*\*\//Uis",'',$q);
		$q = preg_replace("/\s+/is",' ',$q);
		$q = trim($q);
		$type = explode(" ",$q);
		$type = trim(mb_strtoupper($type[0],"UTF-8"));
		return $type;

	}
	
	// простой запрос к базе
	function query($query) {
		global $config;
		// разбираем запрос
		$type = $this->parseQuery($query);

		// выполняем запрос
		try {
			$result=$this->link->query($query);
			
			// получаем результаты 
			if (in_array($type,array('SELECT', 'SHOW'))) {
				$result->setFetchMode(PDO::FETCH_OBJ);
				while($row = $result->fetch()) {
					$res[]=$row;
				}
			} elseif(in_array($type,array('INSERT'))) {
				$res[]=$this->link->lastInsertId(); 
			}
			
			// увеличиваем счетчик запросов
			$this->callsCount++;
			// если дебаг включен то добавляем запрос в лог
			if ($config['debug']==true) $this->callsDebug[]=$query;
			
		} catch(PDOException $e) {
			errorHandler(0,array($e -> getMessage(),$query),__FILE__,__LINE__);
		}
		return (isset($res)) ? $res : NULL;
	}
	
	function queryInsertBinary($query) {
		global $config;
	}
	
	
	function getVar($var) {
		return $this->$var;
	}
	
}
$di->addClass('db', new db($di));

?>