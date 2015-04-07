<?
    
    include("cfg.php");
    
    
    $time=date("U")-3600;
        
    $sql = "select * from robo WHERE `time` > $time;";        
    $result = @mysql_query($sql);    
    $num = @mysql_num_rows($result);    
    echo "Count: ".$num . "<BR><BR>";
    
    
    $sql = "select * from robo WHERE `smtp` = 'ok';";        
    $result = @mysql_query($sql);    
    $num = @mysql_num_rows($result);    
    echo "Count: ".$num . "<BR><BR>";
        
?>

