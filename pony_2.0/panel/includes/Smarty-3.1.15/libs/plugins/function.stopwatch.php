<?php

// smarty function: stopwatch 
 // Descr : This function calculates parse time of Your templates 
 // in microtime 
 // Author: DEBO Jurgen E. G. 
 // Usage : Call this twice on top of Your template, and before </body> 
 // Ex: 
 // {stopwatch} 
 // <html> 
 // ... 
 // <p>This page was generated in {stopwatch} seconds</p> 
 // </body> 
 // Call : $smarty->register_function('stopwatch', 'stopwatch', false); 
 // note : Function may NOT be cached 
 // 
function smarty_function_stopwatch($params, &$smarty){ 
    static $mt_previous = 0; 

    //list($usec, $sec) = explode(" ",microtime()); 
    //$mt_current = (float)$usec + (float)$sec; 
    $mt_current = (float) array_sum(explode(' ', microtime())); 

    if (!$mt_previous) { 
       $mt_previous = $mt_current; 
       return ""; 
    } else { 
       $mt_diff = ($mt_current - $mt_previous); 
       $mt_previous = $mt_current; 
       return sprintf('%.4f',$mt_diff); 
    } 
 }
?>