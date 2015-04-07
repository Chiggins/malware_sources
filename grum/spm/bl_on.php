<?
    //require("passwd.inc");
    
    $fs = @fopen("block.dat", "rb");
    if ($fs)
    {      
      $bl_fg = fread($fs, 1);
      fclose($fs);
    }
    else $bl_fg = 0;
    
    
    
    $fs = fopen("block.dat", "wb");
    if ($fs)
    {      
      if ($bl_fg == '1')    
         fwrite($fs, "0");
      else
         fwrite($fs, "1");
         
      fclose($fs);
    }
    
    
    if ($bl_fg == '0')    
       echo "<font color=#ff ><A href='bl_on.php'>Blocked ON</A></font>";    
    else
       echo "<font color=#ff ><A href='bl_on.php'>Blocked OFF</A></font>";    
?>