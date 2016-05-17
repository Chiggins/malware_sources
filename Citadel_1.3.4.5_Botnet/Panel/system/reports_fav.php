<?php
require_once 'system/lib/db.php';
require_once 'system/lib/dbpdo.php';
require_once 'system/lib/db-gui.php';

class reports_favController {
	function actionIndex(){
		ThemeBegin(LNG_MM_REPORTS_FAV, 0, getBotJsMenu('botmenu'), 0);

		// Query
		$db = dbPDO::singleton();
		$q = $db->prepare('
			SELECT
				`fav`.`id`,
				`fav`.`table`, `fav`.`report_id`,
				`fav`.`botId`, `fav`.`rtime`, `fav`.`path_source`,
				`fav`.`favtime`, `fav`.`comment`,

				UNIX_TIMESTAMP() - `b`.rtime_last AS `bot_online_time`,
				`b`.`comment` AS `bot_comment`
			FROM `botnet_rep_favorites` `fav`
				LEFT JOIN `botnet_list` `b` ON(`fav`.`botId` = `b`.`bot_id`)
			WHERE `fav`.`favorite`>=0
			ORDER BY
				`favtime` DESC
			');
		$q->setFetchMode(PDO::FETCH_OBJ);
		$q->execute();

		// Display
		echo '<table id="favorite-reports-list" class="lined zebra">',
			'<THEAD><tr>',
				'<th>', LNG_REPORTS_TH_BOT_REPORT, '</th>',
				'<th>', LNG_REPORTS_TH_RTIME, '</th>',
				'<th>', LNG_REPORTS_TH_COMMENT, '</th>',
				'</tr></THEAD>',
			'<TBODY>';
		foreach ($q as $report){
			$bot_online = $report->bot_online_time && $report->bot_online_time <= $GLOBALS['config']['botnet_timeout'];
			$report_url = sprintf('?m=reports_db&t=%s&id=%s', $report->table, $report->report_id);

			echo '<tr data-ajax="id=', $report->id, '">';
			echo '<th>',
				botPopupMenu($report->botId, 'botmenu', $report->bot_comment, $bot_online),
				'<a class="report" href="', $report_url, '" target="_blank">[+] ',
					htmlentities(  empty($report->path_source)? date('d.m.Y H:i:s', $report->rtime) : $report->path_source  ),
					'</a>',
				'</th>';
			echo '<td class="rtime">', date('d.m.Y H:i:s', $report->rtime), '</td>';
			echo '<td class="comment" contentEditable="false">', str_replace("\n", '<p>', htmlentities($report->comment)), '</td>';
			echo '</tr>';
		}
		echo
				'</TBODY>',
			'</table>';
		echo LNG_HINT_CONTEXT_MENU;

		echo <<<HTML
		<link rel="stylesheet" href="theme/js/contextMenu/src/jquery.contextMenu.css" />
		<script src="theme/js/contextMenu/src/jquery.contextMenu.js"></script>
		<script src="theme/js/contextMenu/src/jquery.ui.position.js"></script>
		<script src="theme/js/page-reports_fav.js"></script>
HTML;

	}

	/** Add a new report to the favorites list */
	function actionAjaxAdd($table, $report_id, $comment){
		$db = dbPDO::singleton();

		$phs = array(
			':table' => $table,
			':report_id' => $report_id,
			':botId' => null,
			':rtime' => null,
			':path_source' => null,
			':favtime' => time(),
			':comment' => $comment,
		);

		# Fetch more data
		$q = $db->prepare('
			SELECT `bot_id`, `rtime`, `path_source`
			FROM `botnet_reports_'.((int)$table).'`
			WHERE `id`=:report_id
			');
		$q->execute(array(':report_id' => $report_id));
		$q->bindColumn('bot_id', $phs[':botId']);
		$q->bindColumn('rtime', $phs[':rtime']);
		$q->bindColumn('path_source', $phs[':path_source']);
		$q->fetch(PDO::FETCH_BOUND);

		# Insert
		$db->prepare('
			REPLACE INTO `botnet_rep_favorites`
			SET `table`=:table, `report_id`=:report_id,
				`botId`=:botId, `rtime`=:rtime, `path_source`=:path_source,
				`favtime` = :favtime, `comment`=:comment
			;
			')->execute($phs);
	}

	/** Remove a report (mark removed) */
	function actionAjaxRemove($id){
		$db = dbPDO::singleton();
		$q = $db->prepare('UPDATE `botnet_rep_favorites` SET `favorite`=IF(`favorite`=0,-1,0) WHERE `id`=:id;');
		$q->execute(array(
			':id' => $id
		));
	}

	function actionAjaxUpdateComment($id, $comment){
		$db = dbPDO::singleton();
		$q = $db->prepare('UPDATE `botnet_rep_favorites` SET `comment`=:comment WHERE `id`=:id;');
		$q->execute(array(
			':id' => $id,
			':comment' => $comment,
		));
	}
}
