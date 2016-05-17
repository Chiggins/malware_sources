<?php
/** PDO wrapper
 *
 * PDO: http://www.phpro.org/tutorials/Introduction-to-PHP-PDO.html
 */
class dbPDO extends PDO {
	/** @var dbPDO */
	static protected $_connection = null;

	/** Singleton connection that uses using config.php
	 * @return dbPDO
	 */
	static public function singleton(){
		if (is_null(self::$_connection)){
			$dsn = sprintf('mysql:host=%s;dbname=%s;port=%d', $GLOBALS['config']['mysql_host'], $GLOBALS['config']['mysql_db'], 3306);
			self::$_connection = new dbPDO($dsn, $GLOBALS['config']['mysql_user'], $GLOBALS['config']['mysql_pass']);
		}
		return self::$_connection;
	}

	/** Connect to the DB
	 * @param string $dsn Connection DSN: 'mysql:host=localhost;dbname=test;port=3333', 'mysql:dbname=testdb;unix_socket=/path/to/socket'
	 * @param string $username Login
	 * @param string $passwd Password
	 * @param array $options DB-specific options
	 * @throws PDOException
	 */
	public function __construct($dsn = 'mysql:host=localhost;dbname=test', $username = null, $passwd = null, $options = array()) {
		if (strncasecmp($dsn, 'mysql:', 6) === 0)
			$options[PDO::MYSQL_ATTR_INIT_COMMAND] = 'SET NAMES utf8;';
		parent::__construct($dsn, $username, $passwd, $options);

		$this->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	}

	/** Prepared statement for found_rows
	 * @var PDOStatement
	 */
	protected $_fr_stmt = null;

	/** SELECT FOUND_ROWS() after query with SQL_CALC_FOUND_ROWS
	 * @return int
	 */
	public function found_rows(){
		if (is_null($this->_fr_stmt))
			$this->_fr_stmt = $this->prepare('SELECT FOUND_ROWS();');
		$this->_fr_stmt->execute();
		$rows_count = $this->_fr_stmt->fetchColumn(0);
		$this->_fr_stmt->closeCursor();
		return $rows_count;
	}
}