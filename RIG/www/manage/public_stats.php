 <?php

include_once('../config.php');
include_once('../gears/functions.php');
include_once('../gears/di.php');
include_once('../gears/db.php');

cdim('db','connect',$config);

?>

<html>
<head>
<title>Public statistics</title>
</head>
<body>

<?php

$pkey = $_GET['pkey'];
if (!preg_match("/^[a-fA-F0-9]{32}$/",$pkey))
  die('Invalid pkey');

function FindData($arr, $where_data)
  {
  //query = FindData($arr, array('name'=>'val', 'name2'=>'val2'));
  if ($arr === FALSE)
    return false;
  $e = FALSE;
  if (count($arr) == 0)
    return false;
  foreach($arr AS $k=>$v)
    {
    $q = 0;
    $w_count = count($where_data);
    if ($w_count == 0)
      return false;
    foreach($where_data AS $ka=>$va)
      {
      if (isset($arr[$k][$ka]) && $arr[$k][$ka] == $va)
	$q++;
      }
    if ($q == $w_count)
      {
      $e = $k;
      break;
      }
    }
  if ($e !== FALSE)
    {
    $p = $e;
    $e = $arr[$e];
    $e['num'] = $p;
    unset($arr);
    return $e;
    }
  return false;
  }

  $ps_runfile = './addl/ps_runfile';
  $ps_file_arr = array();
    if (file_exists($ps_runfile))
      {
      $ps_filedata = @file_get_contents($ps_runfile);
      if ($ps_filedata !== FALSE)
	{
	$ps_file_arr = unserialize($ps_filedata);
	$fd = FindData($ps_file_arr, array('public_key'=>$pkey));
	if ($fd !== false)
	  {
	  $user_id = (int) $fd['user_id'];
	  $flow_id = (int) $fd['flow_id'];
	  }
	  else
	  {
	  die('Unknown pkey');
	  }
	}
      }

	$ard = array();

	$all_result = cdim('db','query',"SELECT COUNT(*) as cnt FROM `traff` WHERE user_id = ".$user_id." AND flow_id = ".$flow_id);
	$all_res_exp = cdim('db','query',"SELECT COUNT(*) as cnt FROM `traff` WHERE user_id = ".$user_id." AND flow_id = ".$flow_id." AND `exp` != ''");

	$top10 = cdim('db','query',"SELECT COUNT(*) as cnt, cc FROM `traff` WHERE user_id = ".$user_id." AND flow_id = ".$flow_id." GROUP BY cc ORDER BY cnt DESC LIMIT 10");

	foreach($top10 AS $k=>$v)
	  {
	  $ans = cdim('db','query',"SELECT COUNT(*) AS expl, cc FROM `traff` WHERE user_id = ".$user_id." AND flow_id = ".$flow_id." AND cc = '".$v->cc."' AND `exp` != ''");
	  $ah = array_shift($ans);

	  $ard[$v->cc]['all'] = $v->cnt;
	  $ard[$v->cc]['exp'] = $ah->expl;
	  }

	unset($top10);

	if (count($ard) > 0)
	  {
	  echo('
	  <center>
	  <table border=1 style="border-collapse:collapse; border-width:1px; border-style:solid; border-color:#444444;">
	    <tr style="background:#EFEFEF;"><td style="width:140px; text-align:center;">Country</td><td style="width:140px; text-align:center">All</td><td style="width:140px; text-align:center">Exploit</td>
	  ');
	
	  $asl = array_shift($all_res_exp);
	  unset($all_res_exp);

	  $other_exp = $asl->cnt;

	  $other_exp_percent = 0;
	  $other_traff = 0;

	  $all_traff = 0;
	  $all_exp = 0;
	  $top_view = 10;
	  $curr_view = 0;
	  foreach($ard AS $k=>$v)
	    {
	    $curr_view++;
	    $exp_percent = round(($v['exp'] / $v['all'] * 100),2);
	    $all_traff += $v['all'];
	    $all_exp += $v['exp'];
	    $all_exp_percent = round(($all_exp / $all_traff * 100),2);

	      echo('
	      <tr style="height:24px;"><td>&nbsp;<img src="./images/country/'.strtolower($k).'.gif"> '.$k.'</td><td style="text-align:center;">'.$v['all'].'</td><td style="text-align:center;">'.$v['exp'].' ('.$exp_percent.'%)</td>
	      ');

	    }
	  $th = array_shift($all_result);
	  unset($all_result);
	  $other_traff = $th->cnt - $all_traff;
	  $other_exp = $other_exp - $all_exp;
	  if ($other_traff > 0)
	      {
	      $all_exp = $other_exp + $all_exp;
	      $other_exp_percent = round(($other_exp / $other_traff * 100),2);
	      echo('
	      <tr style="height:24px; background:#FFBBFF;"><td style="text-align:center;">Other countries</td><td style="text-align:center;">'.$other_traff.'</td><td style="text-align:center;">'.$other_exp.' ('.$other_exp_percent.'%)</td>
	      ');
	      }
	  echo('<tr style="background:#BBFFFF;"><td style="text-align:center;">All countries</td><td style="text-align:center;">'.($all_traff + $other_traff).'</td><td style="text-align:center;">'.$all_exp.' ('.$all_exp_percent.'%)</td></table></center>');
	  }
	  else
	  {
	  echo('no data');
	  }
?>
</body>
</html>