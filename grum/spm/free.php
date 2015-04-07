<?
    
    include("cfg.php");
    
    
    echo date('l dS \of F Y h:i:s A');
    echo "<br><br>";
       
    $sql = "delete from `ld_spm` WHERE 1;";
    $result = @mysql_query($sql);
    
    
    echo "Free base";
    
    
                  
?>

