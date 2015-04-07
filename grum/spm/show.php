<?php               

    
    echo date('l dS \of F Y h:i:s A');
    echo "<br><br>";
    
    require("cfg.php");
    
    
    $sql = "select * from `ld_spam` WHERE 1;";
    $result = @mysql_query($sql);    
    $num = @mysql_num_rows($result);    
    echo "All Count: ".$num . "<BR><BR>";
    
    
    $time_end = date("U") - 20*60;
    
    $sql = "select * from `ld_spam` WHERE `time` > $time_end;";
    $result = @mysql_query($sql);    
    $num = @mysql_num_rows($result);    
    echo "Online Count: ".$num . "<BR><BR>";
    
    
    $tmparr = array(0);
                
    $sql = "select * from `ld_spam` WHERE `time` > '$time_end' ORDER BY `co`;";
    
    $result = @mysql_query($sql);
    while ($Row = mysql_fetch_array($result))
    {         
      $str = $Row["co"];
      $tmparr[$str]++;
    }
  
    foreach($tmparr as $i=>$v)
    {                 
       if(round($tmparr[$i]*100/$num, 0) > 1) 
       {
         echo $i." = ".$tmparr[$i]. " (".  round($tmparr[$i]*100/$num, 2) ."%)<br>";
       }
    }
    
    
    
    echo "<br><br>";
               
    $dir = "./stats";
    if (!is_dir($dir)) echo "error<BR>";        
    $handled = opendir($dir);
    
    
    $document = readdir($handled);        
    while (false !== ($document = readdir($handled)))
    {
      
      if($document != '.' && $document != '..')
        {           
           echo $document. " = ", filesize("stats/".$document). "<br>";
        }
    }
    
   
?>