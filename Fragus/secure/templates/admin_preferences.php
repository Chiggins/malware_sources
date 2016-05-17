
<?php


////////
$CONTENT = '
<form method="post" id="preferences" name="preferences" action="' . $_SERVER['PHP_SELF'] . '?c=preferences">
<input type="hidden" name="action" value="save">
<b style="color: gray; font-size: 13px; padding-left: 18px; line-height: 28px;">Configuracion</b>
<table width="100%" cellpadding="0" cellspacing="0">
<tr>
	<td width="3"><img src="./images/stl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td width="3"><img src="./images/str.gif" width="3" height="3"></td>
</tr>
<tr>
	<td bgcolor="#273238"></td>
	<td bgcolor="#273238" style="padding: 5px;">
		<table width="100%">
		<tr>
			<td>
				Administrador:<br>
				<input type="text" style="width: 300px;" name="conf_login" value="' . htmlspecialchars($config['AdminLogin']) . '">
				<br><br>
			</td>
			<td>
				Admin password (Cambia Tu Password):<br>
				<input type="text" style="width: 100%;" name="conf_pass">
				<br><br>
			</td>
		</tr>
		<tr>
			<td>
				

				
			</td>
			<td width="300">
				Tiempo de Carga (Segundos):<br>
				<input type="text" style="width: 100%;" name="conf_ajaxseconds" value="' . htmlspecialchars($config['AdminAjaxSeconds']) . '">
			</td>

			

		</tr>
		</table>
		<br style="font-size: 3px;">
	</td>
	<td bgcolor="#273238"></td>
</tr>
<tr>
	<td><img src="./images/sbl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td><img src="./images/sbr.gif" width="3" height="3"></td>
</tr>
</table>

<br>
<b style="color: gray; font-size: 13px; padding-left: 18px; line-height: 28px;">Lenguaje:</b>
<table width="100%" cellpadding="0" cellspacing="0">
<tr>
	<td width="3"><img src="./images/stl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td width="3"><img src="./images/str.gif" width="3" height="3"></td>
</tr>
<tr>
	<td bgcolor="#273238"></td>
	<td bgcolor="#273238" style="padding: 5px;">
		Lenguaje:<br>
		<input type="text" style="width: 42%;" name="conf_Language" value="' . htmlspecialchars($config['AdminDefaultLanguage']) . '">
		<br><br>
		
	</td>
	<td bgcolor="#273238"></td>
</tr>
<tr>
	<td><img src="./images/sbl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td><img src="./images/sbr.gif" width="3" height="3"></td>
</tr>
</table>


<br>
<b style="color: gray; font-size: 13px; padding-left: 18px; line-height: 28px;">Opciones Dominio:</b>
<table width="100%" cellpadding="0" cellspacing="0">
<tr>
	<td width="3"><img src="./images/stl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td width="3"><img src="./images/str.gif" width="3" height="3"></td>
</tr>
<tr>
	<td bgcolor="#273238"></td>
	<td bgcolor="#273238" style="padding: 5px;">
		Host:<br>
		<input type="text" style="width: 42%;" name="conf_Host" value="' . htmlspecialchars($config['MysqlHost']) . '">
		<br><br>
		[Mysql] User:<br>
		<input type="text" style="width: 42%;" name="conf_us" value="' . htmlspecialchars($config['MysqlUser']) . '">
		<br><br>
                [Mysql] Password:<br>
		<input type="text" style="width: 42%;" name="conf_word" value="' . htmlspecialchars($config['MysqlPassword']) . '">
                <br><br>
                [Mysql] DataBase Name:<br>
                <input type="text" style="width: 42%;" name="conf_dt" value="' . htmlspecialchars($config['MysqlDbname']) . '">
		<br>Edita la nueva base de datos

	</td>
	<td bgcolor="#273238"></td>
</tr>
<tr>
	<td><img src="./images/sbl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td><img src="./images/sbr.gif" width="3" height="3"></td>
</tr>
</table>



<br>
<b style="color: gray; font-size: 13px; padding-left: 18px; line-height: 28px;">Sistema:</b>
<table width="100%" cellpadding="0" cellspacing="0">
<tr>
	<td width="3"><img src="./images/stl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td width="3"><img src="./images/str.gif" width="3" height="3"></td>
</tr>
<tr>
	<td bgcolor="#273238"></td>
	<td bgcolor="#273238" style="padding: 5px;">
		URL del Exploit Kit:<br>
		<input type="text" style="width: 100%;" name="conf_url" value="' . htmlspecialchars($config['UrlToFolder']) . '">
		<br><br>
		Redirecion de la URL:<br>
		<input type="text" style="width: 100%;" name="conf_finishurl" value="' . htmlspecialchars($config['FinishRedirect']) . '">
		<br><br>
		Redirecion de Visitas:<br>
		<input type="text" style="width: 100%;" name="conf_doubleurl" value="' . htmlspecialchars($config['DoubleIpRedirect']) . '">
		<br><br style="font-size: 3px;">
	</td>
	<td bgcolor="#273238"></td>
</tr>
<tr>
	<td><img src="./images/sbl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td><img src="./images/sbr.gif" width="3" height="3"></td>
</tr>
</table>

<br>
<b style="color: gray; font-size: 13px; padding-left: 18px; line-height: 28px;">Opciones:</b>
<table width="100%" cellpadding="0" cellspacing="0">
<tr>
	<td width="3"><img src="./images/stl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td width="3"><img src="./images/str.gif" width="3" height="3"></td>
</tr>
<tr>
	<td bgcolor="#273238"></td>
	<td bgcolor="#273238" style="padding: 5px;">
		<table width="100%">
		<tr>
			<td valign="top">
				Tiempo:<br>
				<select name="conf_ajaxcheck" style="width: 200px;"><option value="0">No</option><option value="1"' . ($config['AjaxCheckBeforeExploit'] ? ' selected' : '') . '>Yes</option></select>
				<br><br>
				Cargar Archivos:<br>
				<select name="conf_defaultfile" style="width: 200px;"><option value="0">-- Random file</option>' . $fileslist . '</select>
			</td>
			<td valign="top" width="300">
				Exploits (seleccion):<br>
				<table width="300" cellpadding="0" cellspacing="0"><tr>' . $exploits . '</tr></table>
			</td>
		</tr>
		</table>
	</td>
	<td bgcolor="#273238"></td>
</tr>
<tr>
	<td><img src="./images/sbl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td><img src="./images/sbr.gif" width="3" height="3"></td>
</tr>
</table>
<input type="image" src="./images/button.png" style="width: 160px; height: 25px; margin-left: margin-bottom: -40px; margin-top: 20px;"><a href="javascript:document.getElementById(\'preferences\').submit();" style="color: white; text-decoration: none; font-weight: bold; position: relative; top: -8px; left: -125px; font-size: 12px;">Guardar Cambios</a>
</form>

<br>
<b style="color: gray; font-size: 13px; padding-left: 18px; line-height: 28px;">Modulo</b>
<table width="100%" cellpadding="0" cellspacing="0">
<tr>
	<td width="3"><img src="./images/stl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td width="3"><img src="./images/str.gif" width="3" height="3"></td>
</tr>
<tr>
	<td bgcolor="#273238"></td>
	<td bgcolor="#273238" style="padding: 5px;">
		<table width="100%">
		<tr>
			<td valign="top">
				Selecciona:<br>
				<select name="conf_ajaxcheck" style="width: 200px;"><option value="0">Http</option><option value="1">Local</option></select>
				<br><br>
</td>			</font>
<td>
				Ingresa:<br>
				<input type="text" style="width: 200px;" name="conf_login" value="">
				<br><br>
			</td>

		

</td>
		</tr>
		</table>
	</td>
	<td bgcolor="#273238"></td>
</tr>
<tr>
	<td><img src="./images/sbl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td><img src="./images/sbr.gif" width="3" height="3"></td>
</tr>
</table>
<a href="Vercion">
<input type="image" src="./images/button.png" style="width: 160px; height: 25px; margin-left: margin-bottom: -40px; margin-top: 20px;"></a>

</form>



<br>
<br>
<b style="color: gray; font-size: 13px; padding-left: 18px; line-height: 28px;">Agregar Exploit</b>
<table width="100%" cellpadding="0" cellspacing="0">
<tr>
	<td width="3"><img src="./images/stl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td width="3"><img src="./images/str.gif" width="3" height="3"></td>
</tr>
<tr>
	<td bgcolor="#273238"></td>
	<td bgcolor="#273238" style="padding: 5px;">
		<table width="100%">
		<tr>
			<td valign="top">
				Selecciona:<br>


			<br>

En esta seccion podras subir tus exploits<br>
				
			</td>
			<td valign="top" width="300">
				
			</td>
		</tr>
		</table>
	</td>
	<td bgcolor="#273238"></td>
</tr>
<tr>
	<td><img src="./images/sbl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td><img src="./images/sbr.gif" width="3" height="3"></td>
</tr>
</table>
<a href="upload.php">
<input type="image" src="./images/button.png" style="width: 160px; height: 25px; margin-left: margin-bottom: -40px; margin-top: 20px;"></a>

</dl>
</form>


<br>

<input type="hidden" name="action" value="save">
<b style="color: gray; font-size: 13px; padding-left: 18px; line-height: 28px;">Opcion Especial:</b>
<table width="100%" cellpadding="0" cellspacing="0">
<tr>
	<td width="3"><img src="./images/stl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td width="3"><img src="./images/str.gif" width="3" height="3"></td>
</tr>
<tr>
	<td bgcolor="#273238"></td>
	<td bgcolor="#273238" style="padding: 5px;">
		New:<br>
		<input type="text" style="width: 42%;" name="conf_ZeuEsta" value="' . htmlspecialchars($config['ZeuEsta']) . '">
		<br> Ingresa URL
		
	</td>
	<td bgcolor="#273238"></td>
</tr>
<tr>
	<td><img src="./images/sbl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td><img src="./images/sbr.gif" width="3" height="3"></td>
</tr>
</table>
<a href="Vercion"><input type="image" src="./images/button.png" style="width: 160px; height: 25px; margin-left: margin-bottom: -40px; margin-top: 20px;"></a>
</form>

<br>
<b style="color: gray; font-size: 13px; padding-left: 18px; line-height: 28px;">Seguridad</b>
<table width="100%" cellpadding="0" cellspacing="0">
<tr>
	<td width="3"><img src="./images/stl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td width="3"><img src="./images/str.gif" width="3" height="3"></td>
</tr>
<tr>
	<td bgcolor="#273238"></td>
	<td bgcolor="#273238" style="padding: 5px;">
		<table width="100%">
		<tr>
			<td valign="top">
				Nivel de seguridad:<br>
				<select name="conf_ajaxcheck" style="width: 200px;"><option value="0">Bajo</option><option value="1">Normal</option><option value="3">Alto</select>
				<br><br>
				Filtro:<br>
				<select name="conf_defaultfile" style="width: 200px;"><option value="0">si</option><option value="0">No</option></select>
			</td>
			
		</tr>
		</table>
	</td>
	<td bgcolor="#273238"></td>
</tr>
<tr>
	<td><img src="./images/sbl.gif" width="3" height="3"></td>
	<td bgcolor="#273238"></td>
	<td><img src="./images/sbr.gif" width="3" height="3"></td>
</tr>
</table>
<a href="Vercion">
<input type="image" src="./images/button.png" style="width: 160px; height: 25px; margin-left: margin-bottom: -40px; margin-top: 20px;"></a>
</form>
<a href="Shop">
<input type="image" src="./images/button.png" style="width: 160px; height: 25px; margin-left: margin-bottom: -40px; margin-top: 20px;"></a>





';


?>



</body>
</html>

