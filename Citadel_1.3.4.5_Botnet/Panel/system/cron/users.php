<?php
require_once 'system/lib/db.php';
require_once 'system/lib/notify.php';

/** CronJobs concerning users
 */
class cronjobs_users implements ICronJobs {
	/** Send pending Jabber notifications
	 * @cron period: 1m
	 * @cron weight: -10
	 */
	function cronjob_jabber_notify(){
		$ret = array('sent' => 0, 'errors' => 0);
		$errors = array();

		$R = mysql_q('SELECT `id`, `jid`, `msg`, `sent` FROM `jabber_messages` WHERE `sent`=0;');
		while ($R && !is_bool($r = mysql_fetch_array($R))){
			$j = jabber_notify_now($r['jid'], $r['msg']);

			if ($j === TRUE)
				$ret['sent']++;
				else {
				$ret['errors']++;
				$errors = array_merge($errors, $j);
				trigger_error('Jabber: '.implode("\n", $j), E_USER_WARNING);
				continue;
				}

			mysql_q(mkquery('UPDATE `jabber_messages` SET `sent`=1, `sent_time`=UNIX_TIMESTAMP() WHERE `id`={i:id};', $r));

			usleep(500000);
			}

		if ($ret['sent'] == 0 && $ret['errors']>0)
			throw new CronJobException(implode(' ; ', $errors));

		return $ret;
		}

	/** Remove old, archived Jabber notifications
	 * @cron period: 1d
	 */
	function cronjob_jabber_cleanse(){
		mysql_q(mkquery(
			'DELETE FROM `jabber_messages` WHERE `sent`=1 AND `sent_time` < {i:old};', array(
			'old' => time() - 60*60*24 * 10,
			)));
		return array(
			'cleansed' => mysql_affected_rows(),
			);
		}
	}
