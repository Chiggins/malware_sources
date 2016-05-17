<?php
/** Scan4you antivirus scanner provider 
 */
class Scan4you {
	protected $_scan4you_auth;
	
	/** Create scan4you scanner
	 * @param string $id
	 * 	Scan4you id
	 * @param string $token
	 * 	Scan4you token
	 */
	function __construct($id, $token){
		$this->_scan4you_auth = array($id, $token);
		}
	
	/** Perform a scan of a file
	 * @param string $file
	 * 	File path
	 * @return AntivirusScanResults
	 */
	function scan($file){
		if (!file_exists($file)){
			$results = new AntivirusScanResults;
			trigger_error($results->error = "scan() error: File '$file' does not exist", E_USER_WARNING);
			return $results;
			}

		$response = $this->_request($file);
		#file_put_contents('/tmp/scan4you', var_export($response, 1));
		#$response = file_get_contents('/tmp/scan4you');

		if ($response === FALSE)
			return FALSE;
		return $this->_parse_response($file, $response);
		}
	
	/** Query scan4you for scan results of $file
	 * @param string $file
	 * 	Path to the file to scan
	 * @return string
	 */
	protected function _request($file){
		$ch = curl_init();
		curl_setopt($ch, CURLOPT_HEADER, 0);
		curl_setopt($ch, CURLOPT_VERBOSE, 0);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_URL, 'http://scan4you.net/remote.php');
		curl_setopt($ch, CURLOPT_POST, true);
		curl_setopt($ch, CURLOPT_POSTFIELDS, array(
				'id'		=> $this->_scan4you_auth[0], // User ID
				'token'	=> $this->_scan4you_auth[1], // Service Token
				'action'	=> 'file', // 'file', 'url', 'domain'
				'link'	=> 1, // Get URL to the results
				'uppload'	=> "@$file",
				));
		return curl_exec($ch);
		}
	
	/** Parse the response string
	 * @return AntivirusScanResults
	 */
	protected function _parse_response($filename, $response){
		$results = new AntivirusScanResults($filename);
		foreach(explode("\n", $response) as $line)
			if ($line = trim($line))
				if (FALSE !== $p = strpos($line, 'URL='))
					$results->url = trim(substr($line, $p+4));
				else {
					$l = explode(':', $line, 2); // [0] => Avir name, [1] => response
					$l[0] = trim($l[0]);
					$l[1] = trim($l[1]);
					
					if ($l[0] == 'ERROR')
						$results->error = $line;
						elseif ($l[1] == 'OK')
						$results->scan_okay[ $l[0] ] = 'OK';
						else
						$results->scan_threat[ $l[0] ] = $l[1];
					}
		return $results;
		}
	}




class AntivirusScanResults {
	/** If the scan failed with an error — this is the error string
	 * @var string|null
	 */
	public $error = null;

	/** Scanned filename
	 * @var string
	 */
	public $filename;

	function __construct($filename){
		$this->filename = $filename;
		}
	
	/** URL to the scan results
	 * @var string|null
	 */
	public $url;
	
	/** List of antivirus software that detected a thread
	 * @var string[] array( avir-name => threat-name )
	 */
	public $scan_threat = array();
	
	/** List of antivirus software that has detected no threat
	 * @var string[] array( avir-name => 'OK')
	 */
	public $scan_okay = array();

	/** Render as HTML
	 * @return string
	 */
	function render_html($table_attrs = ''){
		$details  = '<table '.$table_attrs.'>';
		$details .= '<caption>'.$this->filename.': <a href="'.$this->url.'" target="_blank">'.$this->url.'</a></caption>';

		if ($this->error)
			$details .= "<tr><th colspan=2 class=\"error\">ERROR: {$this->error}</th></tr>";

		foreach ($this->scan_threat as $avir => $react)
			$details .= "<tr><th>{$avir}</th><td class=\"threat\">{$react}</td></tr>";

		foreach ($this->scan_okay as $avir => $react)
			$details .= "<tr><th>{$avir}</th><td>{$react}</td></tr>";

		$details .= '</table>';
		return $details;
		}

	/** Render as plaintext
	 * @return string
	 */
	function render_text(){
		$details  = "File: {$this->filename}\n";
		$details .= "URL: {$this->url}\n";

		if ($this->error)
			$details .= "ERROR: {$this->error}\n";

		$details .= "\n";

		foreach (array_merge($this->scan_threat, $this->scan_okay) as $avir => $react)
			$details .= "{$avir}: {$react}\n";

		return $details;
		}
	}
