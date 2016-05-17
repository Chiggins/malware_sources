<?php
require_once 'system/lib/db.php';
require_once 'system/lib/shortcuts.php';

/** CronJobs concerning Scripts
 */
class cronjobs_scripts implements ICronJobs {
	/** Remove old scripts which are one-shot
	 * @cron period: 1d
	 */
	function cronjob_cleanse_old(){
		mysql_q(mkquery(
			'DELETE `botnet_scripts`, `botnet_scripts_stat`
			 FROM `botnet_scripts` CROSS JOIN `botnet_scripts_stat` USING(`extern_id`)
			 WHERE `botnet_scripts`.`flag_enabled`=0 AND `botnet_scripts`.`send_limit`=1 AND `botnet_scripts`.`time_created`<{i:time_thr}
			 ', array(
			'time_thr' => time() - 60*60*24*7,
			)));
		return array('removed' => mysql_affected_rows());
		}
	}
