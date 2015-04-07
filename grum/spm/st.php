<?php               

    
    echo date('l dS \of F Y h:i:s A');
    echo "<br><br>";
    
    $dir = "./stats";
    if (!is_dir($dir)) echo "error<BR>";        
    $handled = opendir($dir);
    
    $document = readdir($handled);        
    while (false !== ($document = readdir($handled)))
    {
      
      if($document != '.' && $document != '..')
        {           
           $tmp = explode("l",$document);
           echo $tmp[0]. " = ", filesize("stats/".$document). " : $tmp[1]<br>";
        }
    }
   
?>