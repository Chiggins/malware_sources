<?php
/** Replace placeholders in a query with values from an array
 * Placeholder syntax:
 * 	{modifier:key}
 * 		`key` is taken from $data[key]
 * 	Available modifiers:
 * 		{=:table_name}		insert as is, without escaping
 * 		{`:identifier}		backtick-quoted identifier
 * 		{s,:array}			implode an array, escaping each item
 * 		{,:array}			implode an array, with no escape
 * 		{i:integer}
 * 		{d:float}
 * 		{s:string}
 * 		{s=:string}			Escape but don't surround with quotes
 * 		{SET:array}			Generate `col`={s:value} comma-separated pairs here. `array` gives column names, while keys are taken from $data (if isset)
 * 		{SETA:array}		Generate `col`={s:value} comma-separated pairs here from array( col => value )
 * @return string The query with inserted data
 */
function mkquery($query, array $data){
	$se = array();
	$re = array();
	preg_match_all('~{([^:]+):([^}]+)}~iUS', $query, $placeholders, PREG_SET_ORDER);
	foreach ($placeholders as $ph){
		$ph_fmt = $ph[1];
		$ph_key = $ph[2];
		# take the value
		$value = $data[$ph_key];
		if (is_null($value)){
			$value = 'NULL';
			$ph_fmt = '=';
			}
		# Process
		$se[] = $ph[0];
		switch ($ph_fmt){
			case '=': # as is
				$re[] = $value;
				break;
			case '`': # as is
				$re[] = '`'.mysql_real_escape_string($value).'`';
				break;
			case 's,': # implode with escaping
				foreach ($value as &$v)
					$v = '"'.mysql_real_escape_string($v).'"';
			case ',': # implode
				$re[] = implode(',', $value);
				break;
			case 'i':
				$re[] = (int)$value;
				break;
			case 'd':
				$re[] = (float)$value;
				break;
			case 's':
				$re[] = '"'.mysql_real_escape_string($value).'"';
				break;
			case 's=':
				$re[] = mysql_real_escape_string($value);
				break;
			case 'SET':
				$set = array();
				foreach ($value as $col)
					if (isset($data[$col]))
						$set[] = mkquery('{`:col}={s:val}', array('col' => $col, 'val' => $data[$col]));
				$re[] = implode(',', $set);
				break;
			case 'SETA':
				$set = array();
				foreach ($value as $col => $val)
					$set[] = mkquery('{`:col}={s:val}', array('col' => $col, 'val' => $val));
				$re[] = implode(',', $set);
				break;
			default:
				$re[] = '<unk-format>';
			}
		}
	# Replace
	return str_replace( $se , $re, $query );
	}

/** MySQL query which report errors
 * @param string $query
 * 	Query string
 * @param resource|null $link
 * 	Link to the DB connection
 */
function mysql_q($query, $link = null){
	$R = is_null($link)
			? mysql_query($query)
			: mysql_query($query, $link);

	if (FALSE === $R)
		trigger_error('mysql_query() error: '.mysql_error(), E_USER_WARNING);

	return $R;
	}

/** Convert YYMMDD string to UNIX timestamp at 00:00
 * @return int
 */
function yymmdd2timestamp($yymmdd){
		$y = substr($yymmdd, 0, 2) + 2000;
		$m = substr($yymmdd, 2, 2);
		$d = substr($yymmdd, 4, 2);
	return mktime(0,0,0, $m, $d, $y);
	}

/** List `botnet_reports_*` tables into array( timestamp => yymmdd )
 * @param bool $intmode
 * 	Instead of timestamps, give integers like '120401'
 */
function list_reports_tables($intmode = false){
	static $dates = null;
	if (!is_null($dates)) return $dates; # Cache
	
	$dates = array();
	$R = mysql_query("SHOW TABLES LIKE 'botnet_reports_%';");
	while (!is_bool($r = mysql_fetch_row($R))){
		$yymmdd = substr($r[0], 15);
		
		if ($intmode)
			$dates[ (int)$yymmdd ] = $yymmdd;
			else
			$dates[ yymmdd2timestamp($yymmdd) ] = $yymmdd;
		}
	return $dates;
	}

/** Produces SQL query parts for JOINing with multiple report tables.
 * That's the only way of JOINing a single table against all reports
 * @param string[]	$fields
 * 		Report tables' fields to select with COALESCE(). array( field_name => fields_alias )
 * 		A special field array( true => 'alias' ) is supported: 'yymmdd' of the reports table joined
 * @param string[]	$tables
 * 		List of report tables to join to: array(timestamp => yymmdd)
 * @param string	$join_alias
 * 		Alias format for report tables. Placeholders: {timestamp}, {yymmdd}
 * @param string	$join_rule
 * 		The joining rule. Placeholders: {timestamp}, {yymmdd}, {t_alias}
 * @return array($joins, $coalesce)
 * 		$joins: array of `botnet_reports_*` aliases, ready to be joined: implode('LEFT JOIN')
 * 		$coalesce: array( fields_alias => expr ) of $fields, COALESCE()d , aliased as `field_alias`
 */
function join_to_reports($fields, $tables = null, $join_alias = "r{yymmdd}", $join_rule='`a`.`table`="{timestamp}" AND `a`.`report_id` = `{t_alias}`.`id`'){
	$joins = array();
	$coalesce = array();
	foreach($fields as $f_name => $f_alias)
		$coalesce[$f_alias] = array();
	
	$se = array('{i}', '{timestamp}', '{yymmdd}', '{t_alias}');
	$re = array($i=0, '-','-','-');
	foreach($tables as $timestamp => $yymmdd){
		$re = array($i++, $timestamp, $yymmdd, '');
		$re[3] = $t_alias = str_replace($se, $re, $join_alias);
		$joins[] = sprintf("`botnet_reports_%s` AS `%s` ON(%s)",
						$yymmdd,
						$t_alias,
						str_replace($se, $re, $join_rule)
						);
		foreach($fields as $f_name => $f_alias)
			if (is_bool($f_name)) # Provide a name for the reports table
				$coalesce[$f_alias][] = "IF(`$t_alias`.`report_id` IS NOT NULL, '$yymmdd', NULL)";
				elseif (is_int($f_name)) # name = alias
				$coalesce[$f_alias][] = "`$t_alias`.`$f_alias`";
				else 
				$coalesce[$f_alias][] = "`$t_alias`.`$f_name`";
		}
	foreach($coalesce as $f_alias => &$c){
		if (count($c) == 0)
			$c = sprintf('NULL AS `%s`', $f_alias);
			else
			$c = sprintf('COALESCE(%s) AS `%s`', implode(',', $c), $f_alias);
		}
	return array($joins, $coalesce);
	}

/** Find botId by IP */
function bot_ip2id($ip){
	$d = array(
		'ip_bin' => pack('N', ip2long($ip)),
		);
	$R = mysql_query(mkquery('SELECT `bot_id` FROM `botnet_list` WHERE `ipv4`={s:ip_bin};', $d));
	if (!$R || mysql_num_rows($R)==0)
		return null;
	return array_shift(mysql_fetch_row($R));
	}




class Paginator {
	/** First page id
	 * @var int
	 * @readonly
	 */
	public $page_first = 1;

	/** The current page
	 * @var int|null
	 * @readonly
	 */
	public $page_current;

	/** Items per page
	 * @var int
	 * @readonly
	 */
	public $items_per_page;

	/** SQL LIMIT data: array(offset, perpage)
	 * @var int[]
	 * @readonly, cald'ed by total()
	 */
	public $sql_limit;

	/** The total number of items
	 * @var int
	 * @readonly, cald'ed by total()
	 */
	public $items_total = null;

	/** The number of pages
	 * @var int
	 * @readonly, cald'ed by total()
	 */
	public $page_count = null;

	/** The last page
	 * @var int
	 * @readonly, cald'ed by total()
	 */
	public $page_last = null;

	function __construct($current_page, $per_page, $first_page=1){
		$this->page_current = $current_page;
		$this->items_per_page = $per_page;
		$this->page_first = $first_page;
		$this->sql_limit = array(
			($this->page_current - $this->page_first) * $this->items_per_page,
			$this->items_per_page,
			);
		}

	function pdo_limit(PDOStatement $pdo, $ph_offset, $ph_rowcount){
		$pdo->bindValue($ph_offset,   $this->sql_limit[0], PDO::PARAM_INT);
		$pdo->bindValue($ph_rowcount, $this->sql_limit[1], PDO::PARAM_INT);
	}

	/** Set total items count
	 * @return int
	 */
	function total($set){
		$this->items_total = $set;
		$this->page_count = ceil($this->items_total / $this->items_per_page);
		$this->page_last = $this->page_count-1 + $this->page_first;
		}

	/** Create a <div> for jPager3k
	 * @param string $url
	 * @param null $id
	 * @param null $class
	 * @return string
	 */
	function jPager3k($url = '?page=%page%', $id=null, $class=null){
		$s = '<div ';
		if (!is_null($id))		$s .= ' id="'.$id.'" ';
		if (!is_null($class))	$s .= ' class="'.$class.'" ';
		$s .= ' data-jpager-url="'.$url.'" ';
		$s .= ' data-jpager-lang="'.$GLOBALS['userData']['language'].'" ';
		$s .= ' data-jpager-sets="'.$this->page_first.'/+1/'.$this->page_last.'|'.$this->page_current.'" ';
		$s .= '>';
		$s .= '</div>';
		return $s;
		}
	}
