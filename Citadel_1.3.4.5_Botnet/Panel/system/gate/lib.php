<?php
/** die() and log where and why.
 * Also flushes the logs.
 * @return never :)
 */
function gate_die($place, $reason, $levelshift=1){
	GateLog::get()->log(GateLog::L_DEBUG, $place, "die($reason)", $levelshift);
	GateLog::get()->flush();
	die();
	}

/** IPv4 to Country
 * @return (string) 2-letter country code
 */
function ipv4toc($ip_addr){
	static $cache = array();
	if (isset($cache[$ip_addr]))
		return $cache[$ip_addr];
	$cache[$ip_addr] = '--';

	$ip = sprintf('%u', ip2long($ip_addr));
	$q = "SELECT `c` FROM `ipv4toc` WHERE '$ip' BETWEEN `l` AND `h` ORDER BY NULL LIMIT 1";
	if (FALSE !== $R = mysql_query($q))
		if (FALSE !== $r = mysql_fetch_row($R))
			$cache[$ip_addr] = $r[0];
	return $cache[$ip_addr];
	}

/** Gate logger singleton */
class GateLog {
	private static $instance;
	
	const L_TRACE		= 1;
	const L_DEBUG		= 2;
	const L_INFO		= 3;
	const L_NOTICE		= 4;
	const L_WARNING	= 5;
	const L_ERROR		= 6;
	
	const L_PHP_ERROR		= 7;
	const L_PHP_EXCEPTION	= 8;
	
	protected $_levels = array(
		GateLog::L_TRACE => 'trace',
		GateLog::L_DEBUG => 'debug',
		GateLog::L_INFO => 'info',
		GateLog::L_NOTICE => 'Notice',
		GateLog::L_WARNING => 'WARNING',
		GateLog::L_ERROR => 'ERROR',
		
		GateLog::L_PHP_ERROR => 'PHP_ERROR',
		GateLog::L_PHP_EXCEPTION => 'PHP_EXCEPTION',
		);
	
	/** Logrecords accumulator
	 * @var string
	 */
	protected $_accum = '';
	
	protected $_fname; # Logfile path
	protected $_level; # Error messsage level limit
	protected $_datefmt; # date format
	protected $_threadid; # Uniq thread ID
	protected $_starttime; # Start microtime
	
	function __construct($logfile, $level){
		self::$instance = $this;
		$this->_fname = $logfile;
		$this->_level = $level;
		$this->_datefmt = 'Y.m.d H:i:s';
		$this->_threadid = strtoupper(base_convert(rand(10000000, 99999999), 10, 36));
		$this->_starttime = microtime(true);
		}
	function __destruct(){
		$this->flush();
		}
	
	/** PHP Error Handler binding */
	function php_error_handler($no, $str, $file, $line){
		$this->log_message(self::L_PHP_ERROR, 'PHP', sprintf(
			'%s:%s: %s (#%s)',
			basename($file), $line,
			$str,
			$no
			));
		return false;
		}
	
	/** Flush the bunch of logs to the logfile */
	function flush(){
		if (empty($this->_accum) || is_null($this->_fname))
			return;
		$f = fopen($this->_fname, 'a');
		if (!$f) return;
		flock($f, LOCK_EX);
		fwrite($f, $this->_accum);
		flock($f, LOCK_UN);
		fclose($f);
		$this->_accum = array();
		}
	
	/** Get the singleton */
	static function get(){
		return self::$instance;
		}
	
	/** Generic log message */
	function log_message($level, $place, $msg){
		if ($level < $this->_level)
			return;
		$this->_accum .= sprintf("[%s +% 6.3f] %s %s (%s): %s\n",
			date($this->_datefmt),
			microtime(true) - $this->_starttime,
			$this->_threadid,
			isset($this->_levels[$level])? $this->_levels[$level] : $level,
			$place,
			str_replace("\n", "\n\t\t", $msg)
			);
		}
	
	/** Log a message, with metainfo */
	function log($level, $place, $msg, $levelshift=0){
		$file = '?';
		$line = '?';
		$this->log_message($level, $place, sprintf(
			'%s', # TODO: log (file:line) backtraced
			$msg
			));
		}
	}