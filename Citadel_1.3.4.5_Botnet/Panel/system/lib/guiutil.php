<?php
/** Feed a form using JS */
function js_form_feeder($form_selector, $form_data){
	return '<script>(function(){ var f = function(){ window.js_form_feeder('.json_encode($form_selector).', '.json_encode($form_data).'); }; $(f); $(document).bind("cbox_complete", f); })();</script>';
	}

/** Set arbitrary JSON variables
 * Example: echo jsonset(array('window.data' => $data));
 */
function jsonset(array $variables){
	$ret  = '<script type="text/javascript">'."\n";
	foreach ($variables as $name => $value)
		$ret .= $name.' = '.json_encode($value).';'."\n";
	$ret .= '</script>'."\n";
	return $ret;
	}

/** Print datetime in a short format */
function date_short($timestamp, $fmt_tm = 'H:i:s', $fmt_dm = 'd.m', $fmt_dmy = 'd.m.Y'){
	if ((time() - $timestamp) < (60*60*20))
		return date($fmt_tm, $timestamp);
	if ((time() - $timestamp) < (60*60*24*30))
		return date($fmt_dm, $timestamp);
	return date($fmt_dmy, $timestamp);
	}

/** Print datetime in 'timeago' format.
 * @param int|null $delta
 * 	Time delta, seconds
 * @param string|null $lang
 * 	Language code. NULL looks into $GLOBALS['userData']['language']
 * @return string
 */
function timeago($seconds, $lang=NULL){
	if (is_null($lang))
		$lang = $GLOBALS['userData']['language'];

	# Language
	$pot = array(
		'en' => array(
				0 => 'sec', 1 => 'min', 2 => 'h',
				3 => 'days', 4 => 'months', 5 => 'years', 6 => 'cent', 7 => 'eras',
				'ago' => 'ago',
				'now' => 'just now',
				'never' => 'never',
				),
		'ru' => array(
				0 => 'сек', 1 => 'мин', 2 => 'ч',
				3 => 'дн', 4 => 'мес', 5 => 'лет', 6 => 'столетий', 7 => 'эр',
				'ago' => 'назад',
				'now' => 'только что',
				'never' => 'никогда',
				),
		);
	$l = isset($pot[$lang]) ? $pot[$lang] : $pot['en'];

	# Never?
	if (is_null($seconds))
		return $l['never'];

	# Units
	$K = array(1, 60, 60, 24, 30, 12, 365, 100, 1000); # coeff
	$N = count($K); # count

	# Calc
	$d = array(0 => $seconds);
	for ($i=1; $i<$N; $i++){
		$d[$i] = floor($d[$i-1]/$K[$i]);
		$d[$i-1] -= $d[$i]*$K[$i];
		}

	# Output
	for ($i=$N-1; $i>0; $i--)
		if ($d[$i] > 2 || ($d[$i]>0 && $d[$i-1]==0))
			return "{$d[$i]} {$l[$i]} {$l['ago']}";
		elseif ($d[$i] > 0)
			return "{$d[$i]} {$l[$i]} {$d[$i-1]} {$l[$i-1]} {$l['ago']}";

	# Seconds left
	if ($d[0] > 10)
		return "{$d[0]} {$l[0]} {$l['ago']}";
	return $l['now'];
	}

/** Recursive urlencode
 * Supports arrays & even streams!
 */
function urlenc(array $args, $_pre = '', $_post = '') {
	$ret = '';
	foreach ($args as $k => $v)
		if (is_array($v))
			$ret .= urlenc($v, $_pre.$k.$_post.'[', ']');
		else {
			if (is_resource($v))
				$v = stream_get_contents($v);
			$ret .= $_pre.$k.$_post .'='. urlencode($v) .'&';
			}
	return $ret;
	}

/** A caching arguments generator
 * It takes the current arguments array, and applies the action:
 * @param int $do	= 0 : Kill mode: kill arguments, others are saved
 * 				= 1 : Save mode: save arguments, others are deleted
 * @param string args..	List of $_GET varnames to apply the $do to
 * @return string The generated arguments list, startting from '?' and with trailing '&'
 * The results are cached on 1st invoke: it's CPU-safe to reinvoke.
 * @example GET: "a=1&b=2&c=3&d=4"
 * 		mkuri(0,'a','b'); // "c=3&d=4&" // kill a,b
 * 		mkuri(1,'a','b'); // "a=1&b=2&" // save a,b
 * 		mkuri(0) = "kill nothing" // "a=1&b=2&c=3&d=4&"
 */
function mkuri($do=0 /* , args... */) {
	static $getk = null;
	static $kcache = array();
	/* func args */
	$A = func_get_args();
	unset($A[0]);
	/* GET keys */
	if (is_null($getk))
		$getk = array_keys($_GET);
	/* Apply filter */
	$keys = ($do == 1) ? array_intersect($A, $getk) : array_diff($getk, $A);
	/* Finish */
	$ret = '';
	foreach ($keys as $k){
		if (!isset($kcache[$k]))
			$kcache[$k] = urlenc(array($k => $_GET[$k]));#urlencode($k).'='.urlencode($_GET[$k]).'&';
		$ret .= $kcache[$k];
		}
	return $ret;
	}


/** Format information size, given in bytes, to larger units
 */
function bytesz($sz, $decimals = 3){
	$szsi = ' KMGTPEZY';
	# Format
	$rem = 0; // remainder
	$i=0; // the current suffix
	while ($sz >= 1024 && $i++ < 8) {
		$rem = (($sz & 0x3ff) + $rem) / 1024;
		$sz = $sz >> 10; # /1024
		}
	$sz += $rem;
	# Print
	return round($sz, $decimals).$szsi[$i].'b';
	}
