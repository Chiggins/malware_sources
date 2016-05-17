<?php
require_once 'system/lib/db.php';
require_once 'system/lib/svc/scan4you.php';
require_once 'system/lib/notify.php';

/** CronJobs concerning files/
 */
class cronjobs_files implements ICronJobs {
	/** Scan files/ directory for new files
	 * @cron period: 1h
	 */
	function cronjob_files_discover(){
		$ret = array( 'new' => 0, 'updated' => 0, 'removed' => 0);

		# Search for new files or updates
		if (file_exists($files_dir = 'files/'))
			foreach (scandir($files_dir) as $file)
				if ($file[0] != '.' && strtolower(strrchr($file, '.')) == '.exe'){
					$q_data = array(
							'file' => $file,
							'hash' => md5_file("$files_dir/$file"),
							'time' => time(),
							);
					# try to add a new file (rely on the PK)
					mysql_query(mkquery('INSERT INTO `exe_updates` SET `file`={s:file}, `hash`={s:hash}, `ctime`={i:time}, `mtime`={i:time};', $q_data));
					if (mysql_affected_rows()>0)
						$ret['new']++;

					# try to update mtime & hash of an existing file
					mysql_query(mkquery('UPDATE `exe_updates` SET `mtime`={i:time}, `hash`={s:hash}, `scan_date`=0, `scan_threat`=0, `scan_count`=0 WHERE `file`={s:file} AND `hash`<>{s:hash};', $q_data));
					if (mysql_affected_rows()>0)
						$ret['updated']++;
					}

		# Remove missing files
		$res = mysql_q(mkquery('SELECT `id`, `file`, `mtime` FROM `exe_updates` WHERE `scan_date` < {i:date};', array( 'date' =>  time()-60*60*20  )));
		while($res && !is_bool($exe = mysql_fetch_assoc($res)))
			if (!file_exists('files/'.$exe['file'])){
				if (  (time()-$exe['mtime']) > 60*60*24  ){
					mysql_q(mkquery('DELETE FROM `exe_updates` WHERE `id`={i:id}', $exe));
					$ret['removed']++;
					}
				continue;
				}
		return $ret;
		}

	/** Scan exe files under files/ using scan4you
	 * @param int|null $id
	 * 	File id for force scan
	 * @param bool $html
	 * 	Return HTML along with raw data
	 * @cron if: return !empty($GLOBALS['config']['scan4you_id']) && !empty($GLOBALS['config']['scan4you_token']);
	 * @cron period: 1d
	 * @cron weight: 10
	 */
	function cronjob_avirscan_files($id = null){
		$jabber_notify = array();
		$scan4you = new Scan4you($GLOBALS['config']['scan4you_id'], $GLOBALS['config']['scan4you_token']);

		if (!is_null($id))
			mysql_q(mkquery('UPDATE `exe_updates` SET `scan_date`=0 WHERE `id`={i:id};', array('id' => $id)));

		$job_result = array();
		$res = mysql_q(mkquery('SELECT `id`, `file`, `mtime` FROM `exe_updates` WHERE `scan_date` < {i:date};', array( 'date' =>  time()-60*60*20  )));
		while($res && !is_bool($exe = mysql_fetch_assoc($res))){
			$exe_path = 'files/'.$exe['file'];

			# scan
			$results = $scan4you->scan($exe_path);
			$job_result[$exe['file']] = array('threat' => count($results->scan_threat), 'okay' => count($results->scan_okay) );
			if (!is_null($results->error))
				$job_result[$exe['file']]['error'] = $results->error;

			# store
			mysql_q(mkquery(
				"UPDATE `exe_updates` SET `scan_date`=UNIX_TIMESTAMP(), `scan_threat` = {i:threat}, `scan_count`={i:count}, `scan_details`={s:details} WHERE `id`={i:id}",
				array(
					'threat' => count($results->scan_threat),
					'count' => count($results->scan_threat) + count($results->scan_okay),
					'details' => $results->render_html('class="avirscan-results-map"'),
					'id' => $exe['id'],
					)
				));

			# notify
			if (count($results->scan_threat) >= 6)
				$jabber_notify[] =
						sprintf("%s: %d Antiviruses detect it!\n\n%s\n",
							$exe['file'],
							count($results->scan_threat),
							$results->render_text()
							);
			}

		# Jabber notify
		jabber_notify($GLOBALS['config']['scan4you_jid'], $jabber_notify);

		# Results
		return $job_result;
		}
	}
