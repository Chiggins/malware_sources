<?php
/** Cron jobs class, designed to be run every minute with internal handling of periods
 * - Tracks start/stop times
 * - Controls overlaps
 * - Launches cronjobs from multiple objects
 */
class CronJobs {
	/** Crontab line to add
	 * @param string $main_php
	 * 	Main file to be executed
	 * @return string
	 */
	public static function crontab($main_php, $argument=''){
		$main_php = realpath($main_php);
		
		$sched = '* * * * *';
		$cd = dirname($main_php);
		$php = '/usr/bin/env php';
		$script = basename($main_php);
		return "$sched	cd '$cd' && $php '$script' $argument";
		}
	
	/** Cron data storage file
	 * @var string
	 */
	protected $_cronfile;

	/** Cron jobs
	 * @var _CronJobMethod[]
	 */
	protected $_jobs;
	
	/** Cron jobs metadata
	 * @var _CronJobMeta[]
	 */
	protected $_jobs_meta;
	
	function __construct($cronfile){
		$this->_cronfile = $cronfile;
		}

	/** Get all jobs. If metadata is available, it's loaded
	 * @return _CronJobMethod[] array( job-name => job-meta )
	 */
	function get_jobs($of_class = null){
		if (is_null($this->_jobs_meta))
			$this->_cronfile_load();

		$jobs = array();
		foreach ($this->_jobs as $job){
			if (isset($this->_jobs_meta[$job->fullname]))
				$job->meta = $this->_jobs_meta[$job->fullname];

			if (is_null($of_class) || $of_class == get_class($job->object))
				$jobs[$job->fullname] = $job;
			}
		return $jobs;
		}
	
	/** Check whether the cron is configured (executed within the last hour)
	 * @return bool
	 */
	function is_configured(){
		if (!file_exists($this->_cronfile))
			return false;
		return (time() - filemtime($this->_cronfile)) < (60*10);
		}
	
	/** Load the contents of the cronfile
	 */
	protected function _cronfile_load(){
		$data = array(
			'_jobs_meta' => array(),
			);
		if (file_exists($this->_cronfile))
			$data = unserialize(file_get_contents($this->_cronfile));
		$this->_jobs_meta = $data['_jobs_meta'];
		}
	
	/** Store the contents of the cronfile
	 */
	protected function _cronfile_save(){
		$data = serialize(array(
			'_jobs_meta' => $this->_jobs_meta,
			));
		file_put_contents($this->_cronfile, $data);
		@chmod($this->_cronfile, 0666); # don't bark, just do the job
		}

	/** Update the cronfile with one job's result
	 * @param _CronJobMethod $job
	 */
	protected function _cronfile_update(_CronJobMethod $job){
		$this->_cronfile_load();
		$job->meta->exec_last = time();
		$this->_jobs_meta[$job->fullname] = $job->meta;
		$this->_cronfile_save();
		}

	const JOB_PREFIX = 'cronjob_';

	/** Register a class which implements ICronJobs interface
	 * Methods from this class which are public and starts with JOB_PREFIX are run as jobs.
	 * @param ICronJobs $object
	 */
	public function register(ICronJobs $object){
		$c = new ReflectionClass($object);
		$c_methods = $c->getMethods(ReflectionMethod::IS_PUBLIC);

		foreach ($c_methods as $method)
			if (strncmp($method->name, self::JOB_PREFIX, strlen(self::JOB_PREFIX)) == 0){
				$job_fullname = get_class($object).'::'.$method->name;
				$this->_jobs[$job_fullname] = new _CronJobMethod($job_fullname, $object, $method);
				}
		return false;
		}

	/** Execute a cronjob
	 * @param _CronJobMethod $job
	 * 	The job object to execute
	 * @param array $job_args
	 * 	Optional arguments list to pass
	 * @param bool $check_scheduled
	 * 	Whether to check if the job is scheduled
	 * @return _CronJobReport|null
	 */
	protected function _job_execute(_CronJobMethod $job, $job_args = array(), $check_scheduled = true){
		$this->_cronfile_load();
		# Get meta
		if (!isset($this->_jobs_meta[$job->fullname])){
			$meta = new _CronJobMeta;
			$meta->context = $job->object;
			$meta->exec_first = time();
			$this->_jobs_meta[$job->fullname] = $meta;
			}
		$job->meta = $this->_jobs_meta[$job->fullname];

		# Is scheduled?
		if ($check_scheduled && !$job->scheduled())
			return null;

		# Prepare
		$job->meta->exec_count++;
		$job->meta->exec_last = time();
		$job->meta->running = true;
		$job->meta->last_error = null;
		$job->meta->last_result = null;
		$this->_cronfile_update($job);

		# Execute it!
		$report = new _CronJobReport($job);
		try { $report->result = $job->execute($job_args); }
			catch (CronJobException $e){
			$report->exception = $e;
			$report->error = $e->getMessage();
			$job->meta->last_error = $report->error;
			}

		# Report success
		$job->meta->running = false;
		$job->meta->last_result = $report->result;
		$this->_cronfile_update($job);
		return $report;
		}

	/** Jobs sort callback
	 */
	protected static function _jobs_sort_cb(_CronJobMethod $a, _CronJobMethod $b){
		if ($a->crondoc_weight == $b->crondoc_weight)
			return 0;
		return  ($a->crondoc_weight < $b->crondoc_weight)? -1 : 1;
		}

	/** Execute the next job, destuctively iterating thru the list of all jobs
	 * @return _CronJobReport
	 * @return NULL on no more jobs
	 */
	function run_next(){
		uasort($this->_jobs, array('CronJobs', '_jobs_sort_cb'));

		$this->_cronfile_load();
		while (!is_null($job = array_shift($this->_jobs))){
			$report = $this->_job_execute($job);
			if (is_null($report))
				continue;
			return $report;
			}
		$this->_cronfile_save();
		return null;
		}
	}



/** Implement this interface to declare cronjobs collection
 *
 * Create cron jobs by implementing public methods starting with JOB_PREFIX
 * Each method can return an array which is printed in JSON.
 * Also it can throw CronJobException to report an error
 *
 * You can store persistent metadata in this class' properties.
 */
interface ICronJobs {
	}

class CronJobException extends Exception {}



/** Report of a cronjob execution
 */
class _CronJobReport {
	function __construct(_CronJobMethod $job){
		$this->job = $job;
		$this->fullname = $job->fullname;
		}

	/** Full name of the method been executed
	 * @var string
	 */
	public $fullname;

	/** Cronjob object
	 * @var _CronJobMethod
	 */
	public $job;

	/** Caught exception, if any
	 * @var Exception
	 */
	public $exception;

	/** Error string, if any.
	 * On exception, contains its string
	 * @var string|null
	 */
	public $error;

	/** Method's return value
	 * @var array
	 */
	public $result;
	}



/** CronJob metadata, persisted into the cronfile
 */
class _CronJobMeta {
	/** Persistent context
	 * @var ICronJobs
	 */
	public $context;
	
	/** First execution timestamp
	 * @var int
	 */
	public $exec_first = null;
	
	/** Last execution timestamp
	 * @var int|null
	 */
	public $exec_last = null;

	/** The number of launches
	 * @var int
	 */
	public $exec_count = 0;
	
	/** Whether the job is still running (overlap control)
	 * @var bool
	 */
	public $running = false;

	/** The result of the last execution, if not error
	 * @var array
	 */
	public $last_result = array();

	/** Error string, if the last CronJob execution ended-up with an error
	 * @var string
	 */
	public $last_error = null;
	}



/** A single cron jobs method parsing & handling.
 * A cronjob is a method within a subclass of CronJobs.
 * All metadata is given via the doccomment's @cron tag.
 * Format:
 * 	@cron <set>: <value>
 * Examples:
 * 	@cron period: 10m
 * 	@cron if: return $GLOBALS['config']['run_me']==1
 */
class _CronJobMethod {
	/** Fully-qualified task name: class::method
	 * @var string
	 */
	public $fullname;

	/** Cron collection object
	 * @var ICronJobs
	 */
	public $object;
	
	/** Cron task method
	 * @var ReflectionMethod
	 */
	public $method;

	/** Job-local metadata
	 * @var _CronJobMeta|null
	 */
	public $meta;

	function __construct($fullname, $object, $method){
		$this->fullname = $fullname;
		$this->object = $object;
		$this->method = $method;
		# Parse the doccomment
		preg_match_all('~@cron +([^:]+) *: *(.*) *$~imuS', $this->method->getDocComment(), $matches, PREG_SET_ORDER);
		foreach ($matches as $m){
			$method = "_docparse_{$m[1]}";
			$value = $m[2];
			$this->$method($value);
			}
		}

	/** Get job description from DocComment
	 * @return string
	 */
	function get_description(){
		$descr = $this->method->getDocComment();

		if (FALSE === $p = strpos($descr, '@'))
			$p = strlen($descr);

		$descr = substr($descr, 0, $p);
		$descr = preg_replace('~^\s*[/\*]+\s*~im', '', $descr);
		return trim($descr);
		}

	/** Check whether this cronjob should be run now
	 * @return bool
	 */
	function scheduled(){
		# Still running jobs
		if ($this->meta->running){
			# One exception: if it's running for more than the current time limit - it's probably dead
			if ((time() - $this->meta->exec_last) < ini_get('max_execution_time'))
				return false; # yep, really is still running
			}

		# @cron if:
		if (!is_null($this->crondoc_if))
			if (!$this->crondoc_if)
				return false;

		# @cron period:
		if (!is_null($this->crondoc_period)){
			if (is_null($this->meta->exec_last))
				return true;
			return ( time()+3 - $this->meta->exec_last ) >= $this->crondoc_period;
			}

		return true;
		}

	/** Execute the method
	 * @param array $args
	 * 	Optional method arguments
	 * @return mixed
	 */
	function execute(array $args = array()){
		return $this->method->invokeArgs($this->object, $args);
		}



	/** DocComment(period): Run schedule
	 * @var int|null seconds
	 */
	public $crondoc_period = null;
	
	/** DocComment(if): evalled condition
	 * @var bool|null
	 */
	public $crondoc_if = null;

	/** DocComment(weight): execution order. The lower - the earlier
	 * @var int
	 */
	public $crondoc_weight = 0;
	
	protected $TIME_UNITS = array(
		's' => 1,
		'm' => 60,
		'h' => 3600,
		'd' => 86400,
		);
	
	/** Parse DocComment(@cron period)
	 * The cronjob gets executed every <period> seconds
	 * Values:
	 * 	\d+[smhd]	The number of minutes, hours, days.
	 */
	protected function _docparse_period($value){
		$n = (float)$value; 
		$unit = trim(substr($value, strlen($n)));
		$mult = $this->TIME_UNITS[ $unit ];
		
		if (!is_null($mult)) # found
			$this->crondoc_period = (int)($n * $mult);
		}
	
	/** Parse DocComment(@cron if)
	 * This cronjob gets executed only when the PHP expression returns true
	 * Values:
	 * 	<php-code>
	 */
	protected function _docparse_if($value){
		$this->crondoc_if = eval($value.';');
		}

	/** Parse DocComment (@cron weight)
	 * Lower weights are run earlier
	 * Values:
	 * 	<int>
	 */
	protected function _docparse_weight($value){
		$this->crondoc_weight = (int)$value;
		}
	}
