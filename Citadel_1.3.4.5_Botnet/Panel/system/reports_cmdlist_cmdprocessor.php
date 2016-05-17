<?php 
/** Parse the entire command line and emit parsed content
 * @param int		$report_id	ID of the report (just for linking)
 * @param string	$content		The entire command-line history
 * @return CmdResult[]
 */
function process_command_list($report_id, $content){
	# ==========[ C:\Windows\system32 ]>ipconfig /all
	$ret = array();
	# Try to match. Return one big `Unknown` on error
	if (!preg_match_all('~^={10}\[(.*)\]>(.*)$~iUSm', $content, $matches, PREG_OFFSET_CAPTURE | PREG_SET_ORDER)){
		$className = (strlen($content)>127) ? 'UnknownLongCmdResult' : 'UnknownCmdResult';
		return array(
			new $className('', 'Unsupported', $content)
			);
		}
	# Pre-Parse commands
	$raw_cmds = array();
	foreach($matches as $m){
		$work_dir = $m[1][0];
		$command = $m[2][0];
		$raw_cmds[] = array(trim($work_dir), trim($command), array($m[0][1], $m[0][1] + strlen($m[0][0])));
		}
	# Extract the output
	for ($i=0, $iN = count($raw_cmds); $i<$iN; $i++){
		$from = $raw_cmds[$i][2][1];
		$till = ($i==($iN-1)) ? strlen($content) : $raw_cmds[$i+1][2][0];
		$raw_cmds[$i][2] = trim(substr($content, $from, $till-$from));
		}
	# Construct the classes
	foreach($raw_cmds as $raw_cmd)
		if (!is_null($cmd = command_choose($raw_cmd[0], $raw_cmd[1], $raw_cmd[2])))
			$ret[] = $cmd;
	return $ret;
	}

function command_choose($work_dir, $command, $output){
	# Slice-off junk
	if (in_array(strtolower($command), array('', 'set', 'exit')))
		return null;
	# Determine the class to use
	$className = (strlen($output)>512) ? 'UnknownLongCmdResult' : 'UnknownCmdResult';
	foreach (array(
		'~^hostname$~' => 'HostnameCmdResult',
		'~^net view /domain$~' => 'NetViewDomainCmdResult',
		'~^ipconfig~' => 'IpConfigCmdResult',
		'~^net view$~' => 'NetViewCmdResult',
		'~^osql -L$~' => 'SqlServersFinderCmdResult',
		'~^dir ~' => 'FileMatchCmdResult',
		) as $regexp => $cls)
		if (preg_match($regexp, $command)){
			$className = $cls;
			break;
			}
	# Use it
	return new $className($work_dir, $command, $output);
	}

/** Base class for parsed command results
 */
abstract class CmdResult {
	/** Current Working Directory
	 * @var string
	 */
	public $cwd;
	
	/** Command name
	 * @var string
	 */
	public $cmd;
	
	/** Command arguments: array( int => value, name => value )
	 * @var string[]
	 */
	public $args;
	
	/** Command output
	 * @var string
	 */
	public $out;
	
	/** Construct. Also splits the command-line.
	 * Extend to parse arguments
	 */
	function __construct($work_dir, $command, $output){
		# Parse command line
		$arguments = array();
		foreach(explode(' ', trim($command)) as $p)
			if (strlen($p = trim($p)))
				$arguments[] = $p;
		$command = array_shift($arguments);
		
		# Store
		$this->cwd = $work_dir;
		$this->cmd = trim($command);
		$this->args = $arguments;
		$this->out = trim($output);
		}
	
	/** Get an array of trimmed $this->out non-empty lines */
	function _linebyline(){
		$lines = array();
		foreach (explode("\n", $this->out) as $l)
			if (strlen($l = trim($l)))
				$lines[] = $l;
		return $lines;
		}
	
	/** Parse the command output & store it to local variables.
	 * @return string[] summarized contents
	 * @return FALSE on error: the command becomes 'Unknown'
	 */
	abstract function parse();
	
	function __toString(){
		return sprintf(
			"==========[ %s ]>%s %s\n%s",
			$this->cwd,
			$this->cmd,
			implode(' ', $this->args),
			$this->out
			);
		}
	}

/** Base class for command results with long output contents (JS-hidden in the UI)
 */
abstract class LongCmdResult extends CmdResult {}




#=== Unknown Commands ===#

/** Unknown command: displayed as plaintext
 */
class UnknownCmdResult extends CmdResult {
	function parse(){
		return array("?{$this->cmd}" => $this->out);
		}
	}

/** Unknown command: displayed as plaintext, JS-hidden
 */
class UnknownLongCmdResult extends LongCmdResult {
	function parse(){
		return array("?{$this->cmd}" => $this->out);
		}
	}




#=== Commands ===#


/** The HostName 
 * > hostname
 */
class HostnameCmdResult extends CmdResult {
	public $hostname;
	
	function parse(){
		return array(
			'Hostname' => ($this->hostname = $this->out),
			);
		}
	}

/** The Domain 
 * > net view /domain
 */
class NetViewDomainCmdResult extends CmdResult {
	public $domains = array();
	
	function parse(){
		$this->domains = array_slice($this->_linebyline(), 3, -1);
		return array(
			'Domain' => $this->domains,
			);
		}
	}

/** Directory Listings 
 * > dir ...
 */
class FileMatchCmdResult extends CmdResult {
	public $files = array();
	
	function parse(){
		$this->files = $this->_linebyline();
		return array(
			implode(' ', $this->args) => $this->files
			);
		}
	}

/** ipconfig 
 * > ipconfig ...
 */
class IpConfigCmdResult extends LongCmdResult {
	function parse(){
		return array('ipconfig' => preg_replace('~(\s\.)+\s?:~um', ':', $this->out));
		}
	}

/** net view 
 * > net view
 */
class NetViewCmdResult extends CmdResult {
	public $netview = array();
	
	function parse(){
		foreach ($this->_linebyline() as $l)
				if ($l[0] == '\\')
					$this->netview[] = $l;
		return array(
			'Network' => $this->netview,
			);
		}
	}

/** Searches for SQL servers on the net 
 * > osql -L
 */
class SqlServersFinderCmdResult extends CmdResult {
	public $servers = array();
	
	function parse(){
		if (strpos($this->out, "'osql'") === FALSE)
			$this->servers = $this->_linebyline();
		return array(
			'SQLs' => $this->servers,
			);
		}
	}

