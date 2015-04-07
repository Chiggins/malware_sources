<?
  // Macroses Module
  $macro_dir = "./macro/";

  mt_srand(time());

  $adv_link_num = 0;

  //Эта функция для того,чтобы читать квадратные скобки в макросах
  function GetSkob($macro) {
    if ( (strpos($macro,"[") === false) || (strpos($macro,"]") === false) ) return "";
    $skob_start = strpos($macro,"[");
    $skob_end   = strpos($macro,"]");
    $skob_str   = substr($macro,$skob_start+1,$skob_end-$skob_start-1);
    return $skob_str;
  }

  //Читает квадратные скобки и возвращает нужное число
  function GetMacroCount($macro) {
    $skob_str = GetSkob($macro);
    if ($skob_str === "") return 1;
    if (strpos($skob_str,"-") === false) return $skob_str;
    else {
      $minus_pos = strpos($skob_str,"-");
      $first_digit = substr($skob_str,0,$minus_pos);
      $second_digit = substr($skob_str,$minus_pos+1,strlen($skob_str)-$minus_pos);
      if ($first_digit < $second_digit) {
        $rand_res = mt_rand($first_digit,$second_digit);
        return $rand_res;
      } elseif ($first_digit == $second_digit) {
        return $first_digit;
      } elseif ($first_digit > $second_digit) {
        $rand_res = mt_rand($second_digit,$first_digit);
        return $rand_res;
      }
    }
  }
  
  
   function GetRandLine($text_in)
   {   
     $words = explode("\r\n", $text_in);
     $c = count ($words);
     return $words[mt_rand(0,$c-1)];
   }
   
  
   

  //-------------------------------------------
  //--  Стандартные  макросы
  //-------------------------------------------
  
  function RND_NUMBER($str) {
    $diap = GetMacroCount($str);
    if ($diap == 1) {
      $RND_NUMBER = mt_rand(0,65535);
    } else {
      $RND_NUMBER = $diap;
    }
    return $RND_NUMBER;
  }

  function RND_DIGIT($str) {
    $diap = GetMacroCount($str);
    for ($i=0; $i < $diap; $i++) {
      $digi = mt_rand(0,9);
      $resstr .= "$digi";
    }
    return $resstr;
  }

  function RND_UC_CHAR($macro) {
    $resstr = "";
    $diap = GetMacroCount($macro);
    for ($i=0; $i < $diap; $i++) {
      $resstr .= Chr(mt_rand(65,90));
    }
    return $resstr;
  }

  function RND_LC_CHAR($macro) {
    $resstr = "";
    $diap = GetMacroCount($macro);
    for ($i=0; $i < $diap; $i++) {
      $resstr .= Chr(mt_rand(97,122));
    }
    return $resstr;
  }

  function RND_NUM_CHAR($macro) {
    $resstr = "";
    $diap = GetMacroCount($macro);
    for ($i=0; $i < $diap; $i++) {
      $resstr .= Chr(mt_rand(48,57));
    }
    return $resstr;
  }

  function FORMAT_DATE($macro) {
    $skob = GetSkob($macro);
    return date($skob);
  }
  
  
  function ADV_LINK($macro) {
    global $tasks;
    if (!is_dir('links'))
      mkdir('links');
    $cache_time_filename = "links/cache_time_".mysql_result($tasks,0,'links');
    $cache_links_filename = "links/cache_links_".mysql_result($tasks,0,'links');
    $cache_time = file_get_contents($cache_time_filename);
    $cache_links = file_get_contents($cache_links_filename);
    $contents = '';
    if ($cache_time + 60 < time()) {
      $page = 'http://'.mysql_result($tasks,0,'links_server').'/spm/get_links?links='.mysql_result($tasks,0,'links');
      $contents = file_get_contents($page);
      $file_cache_time = fopen($cache_time_filename, "w");
      fwrite($file_cache_time, time());
      fclose($file_cache_time);
      $file_cache_links = fopen($cache_links_filename, "w");
      fwrite($file_cache_links, $contents);
      fclose($file_cache_links);
    } else {
      $contents = file_get_contents($cache_links_filename);
    }

     $words = explode("\r\n", $contents);
     $c = count ($words) - 1;
     global $adv_link_num;
     $result = $words[$adv_link_num];
     $adv_link_num++;
     if ($adv_link_num >= $c )
       $adv_link_num = 0;
     return $result;
    //return GetRandLine($contents);
  }
  
  function SUBJECT($macro) {
    
    global $tasks;    
    $subjects = mysql_result($tasks,0,'subjects');    
    return GetRandLine($subjects);
  }
  
    
  $macro_base[] = array("name"=>"RND_NUMBER","func"=>RND_NUMBER);
  $macro_base[] = array("name"=>"RND_DIGIT","func"=>RND_DIGIT);
  $macro_base[] = array("name"=>"RND_UC_CHAR","func"=>RND_UC_CHAR);
  $macro_base[] = array("name"=>"RND_LC_CHAR","func"=>RND_LC_CHAR);
  $macro_base[] = array("name"=>"RND_NUM_CHAR","func"=>RND_NUM_CHAR);
  $macro_base[] = array("name"=>"FORMAT_DATE","func"=>FORMAT_DATE);
  
  $macro_base[] = array("name"=>"ADV_LINK","func"=>ADV_LINK);
  $macro_base[] = array("name"=>"SUBJECT","func"=>SUBJECT);

  function GetLine($file,$line) {
    global $macro_dir;
    $str = "-";
    $f=@fopen($macro_dir.$file,"r");
    if ($f) {
      $linecount = 0;
      while (!feof($f)) {
        $str1 = fgets($f,1024);
        $str2 = str_replace("\r","",$str1);
        $str = str_replace("\n","",$str2);
        
        if ($line == $linecount) {
          fclose($f);
          return $str;
        }
        
        $linecount++;
      }
      fclose($f);
    }
    return $str;
  }
  

  //-------------------------------------------
  //--  Юзерские  макросы
  //-------------------------------------------
/*
  $macro_user[] = array("name"=>"BOUNDARY",
                        "type"=>"s",
                        "file"=>"BOUNDARY.txt",
                        "count"=>3,
                        "value"=>"-");
  $macro_user[] = array("name"=>"X_MAILER",
                        "type"=>"s",
                        "file"=>"X_MAILER.txt",
                        "count"=>6,
                        "value"=>"-");
  $macro_user[] = array("name"=>"RND_IP",
                        "type"=>"d",
                        "file"=>"RND_IP.txt",
                        "count"=>1,
                        "value"=>"-");
*/

  $macros = @mysql_query("SELECT * FROM macro;");
  $macros_count = @mysql_num_rows($macros);
  if ($macros_count > 0) for ($i=0; $i < $macros_count; $i++) {
    $macro_user[] = array("name"=>mysql_result($macros,$i,'name'),
                          "type"=>mysql_result($macros,$i,'type'),
                          "file"=>mysql_result($macros,$i,'file'),
                          "count"=>mysql_result($macros,$i,'count'),
                          "value"=>"-");
  }

  /*
  Функция парсинга боди письма:
  1) Найти символ процента
  2) Отобрать все символы, которые идут в верхнем регистре и знак _
  3) Проверить есть ли тут квадратные скобки
  4) Получить полный размер макроса
  5) Взять начало строки до макроса и взять строку после макроса
  6) Пройтись по всем базкам, есть ли такой макрос у нас
  7) Склеить старт.замена_макроса.конец
  */

/*
  $bodytext =<<<END_OF_STR
From: %RND_NUM_CHAR[10-20]
To: %RND_UC_CHAR[20-30]



END_OF_STR;
*/

  function ReplaceMacro(&$macro,$ext) {
    global $macro_base,$macro_user,$macro_dir;

    for ($i=0; $i < count($macro_base); $i++) {
      $macro_len = strlen($macro_base[$i]['name']);
      if (strcmp(substr($macro,0,$macro_len),$macro_base[$i]['name']) == 0) {
        if ($ext) $macro = $macro_base[$i]['func']($macro);
        else {
          $tmacro = $macro_base[$i]['func']($macro).substr($macro,$macro_len,strlen($macro)-$macro_len);
          $macro = $tmacro;
        }
        return;
      }
    }

    for ($i=0; $i < count($macro_user); $i++) {
      $macro_len = strlen($macro_user[$i]['name']);
      if (strcmp(substr($macro,0,$macro_len),$macro_user[$i]['name']) == 0) {
        if ($macro_user[$i]['type'] === "s") { //Static macros
          if ($macro_user[$i]['value'] !== "-") {
            if ($ext) {
              $diap = GetMacroCount($macro);
              $tmacro = "";
              for ($j=0; $j < $diap; $j++) {
                $tmacro .= $macro_user[$i]['value'];
              }
              $macro = $tmacro;
            } else {
              $macro = $macro_user[$i]['value'].substr($macro,$macro_len,strlen($macro)-$macro_len);
            }
            return;
          } else {
            if (file_exists($macro_dir.$macro_user[$i]['file'])) {
              $macro_user[$i]['value'] = GetLine($macro_user[$i]['file'],mt_rand(0,$macro_user[$i]['count']-1));
              MacroBody($macro_user[$i]['value']);
              if ($ext) { //скобки есть
                $diap = GetMacroCount($macro);
                $tmacro = "";
                for ($j=0; $j < $diap; $j++) {
                  $tmacro .= $macro_user[$i]['value'];
                }
                $macro = $tmacro;
              } else { //скобок нет
                $macro = $macro_user[$i]['value'].substr($macro,$macro_len,strlen($macro)-$macro_len);
              }
            } else {
              $macro = "[File not found! (Static)]";
            }
            return;
          }
        } else { //Dinamic macros
          ////////////////////////////////////
          if (file_exists($macro_dir.$macro_user[$i]['file'])) {
            if ($ext) {
              $diap = GetMacroCount($macro);
              $tmacro = "";
              for ($j=0; $j < $diap; $j++) {
                $macro_user[$i]['value'] = GetLine($macro_user[$i]['file'],mt_rand(0,$macro_user[$i]['count']-1));
                MacroBody($macro_user[$i]['value']);
                $tmacro .= $macro_user[$i]['value'];
              }
              $macro = $tmacro;
            } else {
              $macro_user[$i]['value'] = GetLine($macro_user[$i]['file'],mt_rand(0,$macro_user[$i]['count']-1));
              MacroBody($macro_user[$i]['value']);
              $macro = $macro_user[$i]['value'].substr($macro,$macro_len,strlen($macro)-$macro_len);
            }
          } else {
            $macro = "[File not found! (Dinamic)]";
          }
          return;
          ////////////////////////////////////
        }
      }
    }
    return;
  }

 
  
  
  function MacroBody(&$body) {
    $pos = strpos($body,'%');
    
    
    while ($pos !== false) {
      $body_len = strlen($body);
      $macro = "";
      
      if ( (Ord($body[$pos+1]) >= 65) && (Ord($body[$pos+1]) <= 90) && ($body[$pos] === '%') )
      {
      
          for ($i=$pos+1; $i < $body_len; $i++) {
	  if (  ((Ord($body[$i]) >= 65) && (Ord($body[$i]) <= 90)) || ($body[$i] === '%') || ($body[$i] === '_') ) $macro .= $body[$i];
	  else break;
	}
	
	$extanded = 0;
	if ($body[$i] === '[') {
	  $extanded = 1;
	  for (; $i < $body_len; $i++) {
	    if ($body[$i] === ']') break;
	    else $macro .= $body[$i];
	  }
	  $macro .= $body[$i];
	  $i++;
	} else {
	  $extanded = 0;
	}
	
	
	
	$body_start = substr($body,0,$pos);
	$body_end   = substr($body,$i,$body_len-$i);
	$smacro = $macro;
	ReplaceMacro($macro,$extanded);
	
	if (strcmp($smacro,$macro) == 0) $body = $body_start."$".$smacro.$body_end;
	  else $body = $body_start.$macro.$body_end;
       }
        
        $pos = strpos($body,'%',$pos+1);
        
  //      echo "!!!!-$pos-!!!!!";
                              
    }
    
    
  }


//  MacroBody($bodytext);
//  echo $bodytext;
  
?>