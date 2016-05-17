<?php
require_once 'system/lib/db.php';

/** CronJobs concerning reports
 */
class cronjobs_reports_dedup implements ICronJobs {

	protected $mintable;

	function __construct() {
		$this->mintable = date('ymd', time()-60*60*24);
	}


	/** Reports table deduplication
	 * @cron if: return !empty($GLOBALS['config']['reports_deduplication']);
	 * @cron period: 10m
	 */
	public function cronjob_reports_dedup(){
		# 0. Remove old records from the dedup table
		if (mysql_fetch_field(mysql_query('SELECT EXISTS(SELECT 1 FROM `botnet_rep_dedup` WHERE `table` < 20120601);')))
			mysql_query('TRUNCATE TABLE `botnet_rep_dedup`;'); # We now work only with fresh reports (2 days)
		mysql_query('DELETE FROM `botnet_rep_dedup` WHERE `table` < '.$this->mintable.';');
		$cleansed_old_rows = mysql_affected_rows();

		# Prepare
		$report_fields_dedup = array( # The list of fields to perform deduplication on
				'bot_id', 'botnet',
				'path_source', 'path_dest',
				'type', 'context'
				);
		$report_tables = list_reports_tables(true);
		
		# 1. Walk thru all new reports & fill-in the dedup-table
		list($max_yymmdd, $max_report_id) = mysql_fetch_row(mysql_q(
			'SELECT `table`, MAX(`report_id`) FROM `botnet_rep_dedup` GROUP BY `table` ORDER BY `table` DESC;'
			));
		
		foreach($report_tables as $yymmdd){
			if ($yymmdd < $this->mintable) continue;
			if (!is_null($max_yymmdd) && $yymmdd < $max_yymmdd) continue; # don't mess with the past
			$q = <<<SQL
				INSERT IGNORE INTO `botnet_rep_dedup`
				SELECT 
					{i:yymmdd} AS `table`, 
					`id` AS `report_id`, 
					UNHEX(SHA1(  CONCAT( {,:fields} )  )) AS `hash`
				FROM `botnet_reports_{=:yymmdd}`
				WHERE
					`id` > {i:id}
					AND `type` NOT IN({s,:ignored_types})
SQL;
			$q_data = array(
				'yymmdd' => $yymmdd,
				'fields' => $report_fields_dedup,
				'id' => ($yymmdd === $max_yymmdd) ? $max_report_id : 0,
				'ignored_types' => array(BLT_FILE_SEARCH),
				);
			mysql_q(mkquery($q, $q_data));
			}
		
		
		# 2. Perform deduplication on the dedup-table
		$q = <<<SQL
			SELECT DISTINCT
				`a`.`table`,
				`a`.`report_id`
			FROM `botnet_rep_dedup` `a`
				CROSS JOIN `botnet_rep_dedup` `b`
					ON(`a`.`hash` = `b`.`hash` AND(
						`a`.`table` > `b`.`table` OR (`a`.`table` = `b`.`table` AND `a`.`report_id` > `b`.`report_id`)
						))
			ORDER BY NULL
SQL;
		$R = mysql_q($q);

		# 4. Actually remove the duplicate rows
		$drop_reports = array();
		$removed_count = 0;
		while ($R && !is_bool($r = mysql_fetch_row($R))){
			$table = $r[0];
			if (!isset($drop_reports[$table]))
				$drop_reports[$table] = array();
			
			$drop_reports[$table][] = $r[1];
			
			# Drop accumulated reports
			if (count($drop_reports[$table]) > 100){
				$removed_count += $this->_drop_reports($drop_reports);
				$drop_reports = array();
				}
			}
		# Drop the remaining reports
		$removed_count += $this->_drop_reports($drop_reports);

		# Finish
		return array(
			'cleansed_old_rows' => $cleansed_old_rows,
			'reports_removed' => $removed_count,
			);
		}
	
	/** Drop reports on tables
	 * @param array $reports
	 * 	array( table_name => array(report_ids) )
	 */
	protected function _drop_reports($reports){
		$removed = 0;
		foreach ($reports as $yymmdd => $reports_ids){
			$reports_ids = implode(',', $reports_ids);
			$timestamp = yymmdd2timestamp($yymmdd);
			# Remove reports
			mysql_q("DELETE FROM `botnet_reports_$yymmdd` WHERE `id` IN($reports_ids);");
			$removed += mysql_affected_rows();
			# Remove dedup entries
			mysql_q("DELETE FROM `botnet_rep_dedup` WHERE `table`=$yymmdd AND `report_id` IN($reports_ids);");
			# Remove domains
			mysql_q("DELETE FROM `botnet_rep_domainlogs` WHERE `table`=$timestamp AND `report_id` IN($reports_ids);");
			}
		return $removed;
		}
	}
