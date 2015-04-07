<?php 

        ####################################### 
        # Simple PHP Mysql client (c) ShAnKaR # 
        ####################################### 

if(get_magic_quotes_gpc()){ 
while(list($key, $val)=each($_POST)){ 
$_POST[$key]=stripslashes($val);}} 
$text="<body bgcolor=#C2DDFF> 
<b>Mysql@server:user:pass:db</b> 
<form method='POST'>"; 
$a=array('server','user','password','db');$i=-1; 
while($i++<3){ 
$text.= "<input type='text' name='".$a[$i]."' value='".((!empty($_POST[$a[$i]]))?$_POST[$a[$i]]:'')."'>\n";} 
$text.="<input type='submit' name='sql' value='Connect'> 
<input type='submit' name='exitsql' value='Exit'>"; 
$text="\n<body bgcolor=#C2DDFF> 
<b>Mysql@server:user:pass:db</b> 
<form method='POST'>\n"; 
$a=array('srv','user','pass','db');$i=-1; 
while($i++<3){ 
$text.= "<input type='text' name='".$a[$i]."' value='".((!empty($_POST[$a[$i]]))?$_POST[$a[$i]]:(($i==0)?'localhost':null))."'>\n";} 
$text.="<input type='submit' name='sql' value='Connect'>\n"; 
if(isset($_POST['sql'])){ 
if(isset($_POST['user']))$user=$_POST['user']; 
if(isset($_POST['pass']))$password=$_POST['pass']; 
if(isset($_POST['srv'])){ 
$server=$_POST['srv']; 
$connect=mysql_connect($server,$user,$password) or die($text."</form>not connect");} 
else{die($text."</form>");} 
if(!empty($_POST['db'])){mysql_select_db($_POST['db'])or die("Could not select db<br>");} 
function write($data){ 
global $dump,$fp; 
if($_POST['save']==0)$dump.=$data; 
else{ 
switch($_POST['compr']){ 
case 0: 
fwrite($fp,$data); 
break; 
case 1: 
gzwrite($fp, $data); 
break; 
case 2: 
bzwrite($fp,$data); 
break;}}} 
function sqlh(){ 
global $dump,$server; 
write("#\n#Server : ".getenv('SERVER_NAME')." 
#DB_Host : ".$server." 
#DB : ".$_POST['db']." 
#Table : ".$_POST['table_sel']."\n#\n\n");} 
function sql(){ 
global $dump,$connect; 
$row=mysql_fetch_row(mysql_query("SHOW CREATE TABLE `".$_POST['table_sel']."`", $connect)); 
write("DROP TABLE IF EXISTS `".$_POST['table_sel']."`;\n".$row[1].";\n\n");} 
function sql1(){ 
global $connect; 
$result = mysql_query("SELECT * FROM `".$_POST['table_sel']."`",$connect); 
function test($aaa){ 
$d=array(); 
while (list($key, $val)=each($aaa)){$d[$key]=addslashes($val);} 
return($d);} 
while ($line = mysql_fetch_assoc($result)) { 
((!isset($key))?($key=implode('`, `',array_keys($line))):null); 
$ddd=test(array_values($line)); 
$val=implode('\', \'',$ddd); 
write("INSERT INTO `".$_POST['table_sel']."`(`".$key."`) VALUES ('".$val."');\n");} 
mysql_free_result($result);} 
function head($tmpfname,$name){ 
header("Content-Type: application/octet-stream; name=\"$name\""); 
header("Content-Length: ".filesize($tmpfname).""); 
header("Content-disposition: attachment; filename=\"$name\""); 
$fd=fopen($tmpfname, "r"); 
while(!feof($fd)){ 
echo fgets($fd, 4096);} 
fclose($fd); 
($_POST['save']==1)?unlink($tmpfname):null; 
exit;} 
if(isset($_POST['back']) && isset($_POST['table_sel'])){ 
$dump=''; 
if($_POST['save']>0){ 
$tmpfname=($_POST['save']==1)?tempnam($_POST['save_p'],"sess_"):$_POST['local']; 
switch($_POST['compr']){ 
case 0: 
$fp = fopen($tmpfname, "w"); 
break; 
case 1: 
$fp=gzopen($tmpfname, "w9"); 
break; 
case 2: 
$fp=bzopen($tmpfname, "w"); 
break;}} 
switch($_POST['as']){ 
case 0: 
switch($_POST['as_sql']){ 
case 0: 
sqlh(); 
sql(); 
break; 
case 1: 
sqlh(); 
sql(); 
sql1(); 
break; 
case 2: 
sqlh(); 
sql1(); 
break;} 
if($_POST['save']>0){ 
switch($_POST['compr']){ 
case 0: 
$n='.txt'; 
fclose($fp); 
break; 
case 1: 
$n='.gz'; 
gzclose($fp); 
break; 
case 2: 
$n='.bz2'; 
bzclose($fp); 
break;} 
($_POST['save']==1)?head($tmpfname,$_POST['table_sel'].$n):($message='<center><b>'.$_POST['local'].' Saved</b><center>');} 
break; 
case 1: 
$res = mysql_query("SELECT * FROM `".$_POST['table_sel']."`",$connect); 
if(mysql_num_rows($res) > 0) { 
while($row = mysql_fetch_assoc($res)) { 
$values = array_values($row); 
foreach($values as $k=>$v) {$values[$k] = addslashes($v);} 
$values = implode($_POST['cvs_term'], $values); 
write($values);}} 
break;}} 
echo "$text\n<table width=100% height=90% ><tr><td width=10% style='vertical-align:top'><table><tr><td>"; 
$db_list=mysql_list_dbs($connect); 
echo "<select name='db'>\n"; 
while($row=mysql_fetch_object($db_list)){ 
$db1=$row->Database; 
echo "<option value='$db1' ".(($db1===$_POST['db'])?'selected':'').">$db1</option>\n";} 
echo "</select></td></tr><tr><td>\n"; 
if(!empty($_POST['db'])){ 
$tb_list=mysql_list_tables($_POST['db']); 
echo "<select name='table_sel' multiple size=27>"; 
for($i=0;$i<mysql_num_rows($tb_list);$i++){ 
$n=mysql_fetch_array(mysql_query('select count(*) from '.mysql_tablename($tb_list,$i))); 
echo "<option value='".mysql_tablename($tb_list,$i)."'".($tr=((isset($_POST['table_sel']) && $_POST['table_sel']===($stt=mysql_tablename($tb_list,$i)) && $stn=$stt)?'selected':'')).">\n".mysql_tablename($tb_list, $i).'('.$n[0].")</option>";} 
echo "</select></td></tr></table></td><td style='vertical-align:top'> 
<table  width=100% height=100% bgcolor='#E3FFF2' ><tr><td height=20 bgcolor=#dfdfdf width=100%><nobr>\n"; 
if(isset($_POST['table_sel']) && isset($stn)){ 
$c=array('Browse','SQL','Insert','Export');$i=-1; 
while($i++<3){echo "<input type=radio Name='go' value='".($i)."'>".$c[$i];}} 
echo "&nbsp;&nbsp;<b>".((isset($_POST['table_sel']) && isset($stn))?$_POST['table_sel']:null)."</b></nobr></td></tr><tr width=100%><td width=100%>\n".(isset($message)?$message:'');} 
if(isset($_POST['push']) && isset($_POST['querysql']) && preg_match('/^\s*select /i',$_POST['querysql']) && $stn=$_POST['table_sel'])$_POST['go']=0; 
elseif(isset($_POST['push']))$_POST['go']=1; 
if(isset($_POST['back']))$_POST['go']=3; 
if(isset($_POST['brow']) && $stn=$_POST['table_sel'])$_POST['go']=0; 
if(isset($_POST['editr']) && isset($_POST['edit']))$_POST['go']=4; 
if(isset($_POST['ed_save']))$_POST['go']=5; 
if(isset($_POST['editr']) && !isset($_POST['edit']) && $stn=$_POST['table_sel'])$_POST['go']=0; 
if(isset($_POST['go'])){ 
switch($_POST['go']){ 
case 0: 
if(isset($_POST['table_sel']) && $stn===$_POST['table_sel']){ 
if(isset($_POST['querysql']) && preg_match('/^\s*select /i',$_POST['querysql']) && isset($_POST['push'])){ 
$n=mysql_fetch_array(mysql_query(preg_replace('/^\s*select\s+.+\s+from\s+/i','select count(*) from',$_POST['querysql']))); 
$result = mysql_query($_POST['querysql'],$connect);} 
else{ 
$n=mysql_fetch_array(mysql_query('select count(*) from '.$_POST['table_sel'])); 
$sort=''; 
if(!empty($_POST['sort']))$sort='ORDER BY `'.trim($_POST['sort']).'` '.(($_POST['asc']==='asc')?'ASC':'DESC').' '; 
$co='0,20'; 
if(isset($_POST['br_st']) && isset($_POST['br_en'])){ 
$co=$_POST['br_en'].','.$_POST['br_st'];} 
$result = mysql_query("SELECT * FROM `".$_POST['table_sel']."` $sort limit $co",$connect);} 
for ($i=0;$i<mysql_num_fields($result); $i++){ 
if(ereg('primary_key',mysql_field_flags($result, $i))) 
$prim=mysql_field_name($result, $i);} 
$up_e=''; 
echo "<div style='width:100%;height:450px;overflow:auto;'><table border=1>\n"; 
while($line=mysql_fetch_array($result,MYSQL_ASSOC)){echo "<tr bgcolor='#C1D2C5'>\n"; 
if(!isset($lk)){ 
echo "<td><b>EDIT</b></td>"; 
foreach(array_keys($line) as $lk){print((isset($prim) && $lk===$prim)?"<td><u><b>$lk</b></u></td>":"<td>$lk</td>\n");}} 
if(!isset($prim)){ 
while(list($key,$val)=each($line)){$up_e.="`$key`='".addslashes($val)."' and ";} 
$up_e=substr($up_e,0,-5);} 
else{ 
while(list($key,$val)=each($line)){ 
if($key===$prim){$up_e.="`$key`='".addslashes($val)."'";}}} 
$up_e=urlencode($up_e); 
echo "</tr><tr><td><input type=radio name=edit value='$up_e'></td>\n"; 
$up_e=''; 
foreach($line as $col_value){echo "<td>".((strlen($col_value)>40)?'<textarea cols=40 rows=7>'.htmlspecialchars($col_value).'</textarea>':htmlspecialchars($col_value))."</td>\n";} 
echo "</tr>\n";} 
echo "</table></div><input type=submit name='brow' value='Browse'><b>Sort by 
<input type=text name=sort size=10 value='".((isset($_POST['sort']))?$_POST['sort']:'')."'> 
<select name='asc'><option value='asc'>ASC</option><option value='desc'".((isset($_POST['asc']) && $_POST['asc']==='desc')?' selected':'').">DESC</option></select> 
Show <input type=text size=5 value=".((isset($_POST['br_st']))?$_POST['br_st']:$n[0])." name='br_st'>row(s) starting from<input type=text size=5 value=".((isset($_POST['br_en']))?$_POST['br_en']:'0')." name='br_en'></b> 
<input type=submit name=editr value=Edit>"; 
mysql_free_result($result);} 
break; 
case 1: 
echo "<input type=submit name=push value=Run><br> 
<textarea cols=70% rows=8 name='querysql'>\n".((!empty($_POST['querysql']))?htmlspecialchars($_POST['querysql'],ENT_QUOTES):((isset($_POST['table_sel']))?"SELECT * FROM `".$_POST['table_sel']."` WHERE 1":null))."</textarea><br><br>\n"; 
if(!empty($_POST['querysql'])){ 
$result = mysql_query($_POST['querysql'],$connect) or print("<div style='background-color:red;'>".mysql_error($connect)."</div>"); 
echo "<div style='background-color:green;'>".mysql_info($connect)."</div>";} 
break; 
case 2: 
echo "<div style='width:100%;height:430;overflow:auto;'><table>\n"; 
$fields=mysql_list_fields($_POST['db'],$_POST['table_sel'],$connect); 
for($i=0;$i<mysql_num_fields($fields);$i++){ 
echo "<tr><td bgcolor=#DBDCDD><b>".mysql_field_name($fields,$i).'</td><td bgcolor=#B9C3D7>'.mysql_field_type($fields, $i).'('.mysql_field_len($fields, $i).")</b></td><td>".((mysql_field_len($fields, $i)<40)?"<input type='text' name='ed_key:".mysql_field_name($fields,$i)."' value='' size=40>":"<textarea name='ed_key:".mysql_field_name($fields,$i)."' cols=31 rows=7></textarea>")."</td></tr>\n";} 
echo "</table></div><input type=hidden name=insert value=1><input type=submit name=ed_save value=Insert>"; 
break; 
case 3: 
if(!isset($_POST['back']))echo '<table height=250  align="center"><TR><TD> 
<table height=100%> 
<tr><td bgcolor="#A8B8F1" width="100" height="20"><b>&nbsp;&nbsp;Export as</b></td></tr> 
<tr><td bgcolor="#D0E0FF" width="100" height="20"><input type=radio Name="as" value="0" checked><b>&nbsp;&nbsp;SQL</b></td></tr> 
<tr><td bgcolor="#D0E0FF" width="100" height="20"><input type=radio Name="as" value="1"><b>&nbsp;&nbsp;CSV</b></td></tr> 
<tr><td height=100%></td></tr> 
</table></TD><td> 
<table width="140" height=100%> 
<TR><TD bgcolor="#A8B8F1"  height="20"><b>&nbsp;&nbsp;SQL</b></TD></TR> 
<TR><TD bgcolor="#D0E0FF"  height="20"><input type=radio Name="as_sql" value="0" ><b>Only structure</b></TD></TR> 
<TR><TD bgcolor="#D0E0FF"  height="20"><input type=radio Name="as_sql" value="1" checked><b>All</b></TD></TR> 
<TR><TD bgcolor="#D0E0FF"  height="20"><input type=radio Name="as_sql" value="2"><b>Only data</b></TD></TR> 
<TR><TD bgcolor="#A8B8F1"  height="20"><b>CSV</b></TD></TR> 
<TR><TD bgcolor="#D0E0FF"  height="20"><b>Terminated&nbsp;</b><input size=2 type=text Name="cvs_term" value=":"></TD></TR> 
<tr><td height=100%></tb></tr> 
</table> 
</td><td> 
<table height=100%> 
<tr><td bgcolor="#E6D29C" width="100" height="20"><input type=radio Name="save" value="0" checked><b>&nbsp;View</b></td></tr> 
<tr><td bgcolor="#E6D29C" width="100" height="20"><input type=radio Name="save" value="1"><b>&nbsp;Download</b></td></tr> 
<tr><td bgcolor="#E6D29C" width="130" height="40"><b>&nbsp;Temp path</b><br><input type=text Name="save_p" value="/tmp"></td></tr> 
<tr><td bgcolor="#E6D29C" width="100" height="20"> 
<input type=radio Name="save" value="2"><b>&nbsp;As local file</b><br> 
<input type=text value="./db_backup" name="local"> 
</td></tr> 
<tr><td height=100%></td></tr> 
</table></td><td> 
<table width="120" height=100%> 
<TR><TD bgcolor="#A8B8F1"  height="20"><b>&nbsp;&nbsp;Compression</b></TD></TR> 
<TR><TD bgcolor="#D0E0FF"  height="20"><input type=radio Name="compr" value="0" checked><b>None</b></TD></TR>'. 
((@function_exists('gzencode'))?'<TR><TD bgcolor="#D0E0FF"  height="20"><input type=radio Name="compr" value="1" ><b>Gzip</b></TD></TR>':''). 
((@function_exists('bzcompress'))?'<TR><TD bgcolor="#D0E0FF"  height="20"><input type=radio Name="compr" value="2"><b>Bzip2</b></TD></TR> 
<tr><td height=100%></td></tr>':'').'</table></td></TR> 
<tr><td><input type=submit value=backup name=back></td></tr> 
</table>'; 
if(isset($_POST['back']) && isset($_POST['table_sel'])){ 
if($_POST['save']==0){echo "<textarea cols=70 rows=10>".htmlspecialchars($dump)."</textarea>";}} 
break; 
case 4: 
if(isset($_POST['edit'])){ 
$up_e=$_POST['edit']; 
echo "<input type=hidden name=edit value='$up_e'>"; 
$up_e=urldecode($_POST['edit']); 
echo "<div style='width:100%;height:440;overflow:auto;'><table>\n"; 
$fi=0; 
$result = mysql_query("SELECT * FROM `".$_POST['table_sel']."` WHERE $up_e",$connect); 
while($line=mysql_fetch_array($result,MYSQL_ASSOC)){ 
foreach($line as $key=>$col_value) { 
echo "<tr><td bgcolor=#DBDCDD><b>".mysql_field_name($result,$fi).'</td><td bgcolor=#B9C3D7>'.mysql_field_type($result,$fi).'('.mysql_field_len($result,$fi).")</b></td><td>".((mysql_field_len($result,$fi)<40)?"<input type='text' name='ed_key:".mysql_field_name($result,$fi)."' value='".htmlspecialchars($col_value,ENT_QUOTES)."' size=40>":"<textarea name='ed_key:".mysql_field_name($result,$fi)."' cols=31 rows=7>".htmlspecialchars($col_value,ENT_QUOTES)."</textarea>")."</td></tr>\n"; 
$fi++;}} 
echo "</table></div><input type=submit name=ed_save value=Save>";} 
break; 
case 5: 
$ted=''; 
reset($_POST); 
while(list($key,$val)=each($_POST)){ 
if(preg_match('/^ed_key:(.+)/',$key,$m)) 
{$ted.="`".$m[1]."`= '".addslashes($val)."', ";}} 
$ted=substr($ted,0,-2); 
$query=((isset($_POST['insert']))?"INSERT":"UPDATE")." `".$_POST['table_sel']."` SET $ted ".((isset($_POST['insert']))?'':"WHERE ".urldecode($_POST['edit'])." LIMIT 1 "); 
echo "<div style='background-color:white;'>".htmlspecialchars($query,ENT_QUOTES)."</div><br>"; 
$result = mysql_query($query,$connect) or print("<div style='background-color:red;'>".mysql_error($connect)."</div>"); 
echo "<div style='background-color:green;'>".mysql_info($connect)."</div>"; 
break;}} 
echo "</td></tr></table></td></tr></table></tr><table><input type=hidden name=sql>\n";} 
else echo $text; 
echo "</form></body>"; 
exit; 
?>