<?php

function GetTimeStamp($date) {
  list($year, $month, $day, $hour, $minute, $second) = split('[ :\/.-]', $date);
  return gmmktime ($hour, $minute, $second, $month, $day, $year);
}

?>