<?php
require_once dirname(__FILE__).'/cronjobs.php';

/** Cronjobs with manual execution interface via WEB or CLI
 */
class CronJobsMan extends CronJobs {
	/** Manual execution interface.
	 * When HTTP, parses PATH_INFO for method name & $_GET for params
	 * When CLI, parses argv[1] for method name & argv[2] for url-encoded params
	 * @return array(job_name, args)
	 * @return NULL when not in manual execution state
	 */
	static public function manual_interface(){
		if (!is_null($ret = self::_manual_interface_cli()))
			return $ret;
		if (!is_null($ret = self::_manual_interface_http()))
			return $ret;
		return null;
		}

	/** Manual interface: CLI: parse CLI args */
	static protected function _manual_interface_cli(){
		if (php_sapi_name() != 'cli')
			return null;
		if (!isset($_SERVER['argv'][1]))
			return null;

		$job_name = $_SERVER['argv'][1];
		parse_str( implode(array_slice($_SERVER['argv'], 2)) , $job_args);
		return array($job_name, $job_args);
		}

	/** Manual interface: HTTP: parse REQUEST args */
	static protected function _manual_interface_http(){
		if (php_sapi_name() == 'cli')
			return null;
		if (!isset($_SERVER['PATH_INFO']))
			return null;

		$job_name = trim($_SERVER['PATH_INFO'], '/\\');
		$job_args = $_REQUEST;
		return array($job_name, $job_args);
		}

	/** Manually run a job, unconditionally
	 * @param string $job_name
	 * 	Name of the method to run
	 * @param array $args
	 * 	Associative array of method arguments. Args not found here are filled with nulls
	 * @return _CronJobReport
	 */
	public function manual_run($job_name, array $job_args = array()){
		# Find the job
		if (!isset($this->_jobs[$job_name])){
			trigger_error("CronJobs::run_manual(): Unknown cronjob: $job_name", E_USER_WARNING);
			return null;
			}
		$job = $this->_jobs[$job_name];

		# Map the arguments
		$args = array();
		foreach($job->method->getParameters() as $p)
			$args[$p->name] = isset($job_args[$p->name])? $job_args[$p->name] : null;

		# Invoke
		$report = $this->_job_execute($job, $args, false);
		return $report;
		}
	}
