<?

    $dir = "./stats";
    if (!is_dir($dir)) echo "error<BR>";        
    $handled = opendir($dir);
    
    $document = readdir($handled);        
    while (false !== ($document = readdir($handled)))
    {
      if($document != '.' && $document != '..')
        {           
           unlink("stats/".$document);
           
        }
    }
    
    echo "DELE";
  
  
  
?>