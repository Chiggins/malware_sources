<?
    
    include("cfg.php");
        
    $sql = "delete from robo WHERE `bl` = '1';";
    $result = @mysql_query($sql);    
    
    echo "REFRESH BLOCKED";
        
?>

