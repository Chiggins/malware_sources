<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
	<head>
		<title>Fragus</title>
		<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
		<script language="JavaScript">
		var stm = "";
		function setCookie(name, value, expires, path, domain, secure){
			document.cookie = name + "=" + escape(value) + ((expires) ? "; expires=" + expires : "") + ((path) ? "; path=" + path : "") + ((domain) ? "; domain=" + domain : "") + ((secure) ? "; secure" : "");
		}
		function getCookie(name){
			var cookie = " " + document.cookie;
			var search = " " + name + "=";
			var setStr = null;
			var offset = 0;
			var end = 0;
			if (cookie.length > 0) {
				offset = cookie.indexOf(search);
				if (offset != -1) {
					offset += search.length;
					end = cookie.indexOf(";", offset);
					if (end == -1) {
						end = cookie.length;
					}
					setStr = unescape(cookie.substring(offset, end));
				}
			}
			return(setStr);
		}
		function OnOffAjax(value){
			if (value == true){
				stm = setTimeout("LoadAjax()", <?php echo $config['AdminAjaxSeconds']; ?>000);
				setCookie("fragus", "1", "Mon, 01-Jan-2099 00:00:00 GMT", "/");
			} else {
				stm = clearTimeout(stm);
				setCookie("fragus", "", "Mon, 01-Jan-1000 00:00:00 GMT", "/");
			}
		}
		function getXmlHttp(){
			try {
				return new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				try {
					return new ActiveXObject("Microsoft.XMLHTTP");
				} catch (ee) { }
			}
			if (typeof XMLHttpRequest !='undefined'){
				return new XMLHttpRequest();
			}
		}
		function LoadAjax(){
			var xmlhttp = getXmlHttp();
			xmlhttp.open("GET", '<?php echo $_SERVER['PHP_SELF']; ?>?get_ajax=1&r='+Math.random());
			xmlhttp.onreadystatechange = function(){
				if (xmlhttp.readyState == 4){
					var ts = xmlhttp.responseText.split('|');
					document.getElementById('hosts').innerHTML = ts[0];
					document.getElementById('frags').innerHTML = ts[1];
					var floatValue = parseFloat(Math.round(ts[1] / ts[0] * 10000) / 100);
					if (isNaN(floatValue)) {
						document.getElementById('percent').innerHTML = 0;
					} else {
						document.getElementById('percent').innerHTML = floatValue;
					}
					stm = setTimeout("LoadAjax()", <?php echo $config['AdminAjaxSeconds']; ?>000);
				}
			}
			xmlhttp.send(null);
		}
		</script>
		<link href="style.css" rel="stylesheet" type="text/css"><style>
		BODY {
			background-color: black;
			font-family: Trebuchet MS, Verdana, Arial;
			color: white;
			font-size: 12px;
			background: black url('./images/bg.png');
		}
		TD {
			font-family: Trebuchet MS, Verdana, Arial;
			color: white;
			font-size: 12px;
		}
		INPUT, TEXTAREA, SELECT {
			font-family: Trebuchet MS, Verdana, Arial;
			font-size: 12px;
		}
		A.menu:link, A.menu:visited, A.menu:active {
			text-decoration: none;
			color: white;
			font-size: 13px;
			font-weight: bold;
		}
		A.menu:hover {
			color: #e3e3e3;
			text-decoration: none;
		}
		.pdlt {
			background-color: #101920;
			width: 100%;
			padding: 10px;
		}
		.tbg {
			background: #0f161e url('./images/tbg.gif');
			height: 25px;
			font-weight: bold;
			text-align: center;
			border-right: 1px solid #2b516b;
			border-left: 1px solid #0b1216;
		}
		.tdb {
			height: 30px;
			color: #0099ff;
			border-bottom: 1px solid #0099ff;
		}
		A.al:link, A.al:visited, A.al:active {
			background-color: #040404;
			padding: 1px;
			padding-left: 5px;
			padding-right: 5px;

			text-decoration: underline;
			color: #0099ff;
		}
		A.al:hover {
			color: #39b0ff;
			text-decoration: none;
		}
		A:link, A:visited, A:active {
			text-decoration: underline;
			color: white;
		}
		A:hover {
			color: #e3e3e3;
			text-decoration: none;
		}
		.tst {
			color: #66ccff;
		}
		.subtbl1, .subtbl2 {
			text-align: right;
			font-size: 10px;
		}
		.subtbl2 {
			background-color: #394850;
		}
		</style>
	</head>
	<body><div class="background"><div class="transbox">
		<br>
		<center>
		<table width="911" cellpadding="0" cellspacing="0" height="95">
			<tr>
				<td width="118"><a href="<?php echo $_SERVER['PHP_SELF']; ?>">
				<td align="right" valign="bottom">
					<table cellpadding="0" cellspacing="0" height="29" background="./images/menubg.gif">
						<tr>
							<td><img src="./images/menuleft.gif" width="11" height="29"></td>
							<td><a href="<?php echo $_SERVER['PHP_SELF']; ?>" class="menu">Estadisticas</a></td>
							<td width="26" align="center"><img src="./images/menuseporator.gif" width="3" height="29"></td>
							<td><a href="<?php echo $_SERVER['PHP_SELF']; ?>?c=files" class="menu">Files</a></td>
							<td width="26" align="center"><img src="./images/menuseporator.gif" width="3" height="29"></td>
							<td><a href="<?php echo $_SERVER['PHP_SELF']; ?>?c=sellers" class="menu">Exploits</a></td>
							<td width="26" align="center"><img src="./images/menuseporator.gif" width="3" height="29"></td>
							<td><a href="<?php echo $_SERVER['PHP_SELF']; ?>?c=trafficlinks" class="menu">Inframe</a></td>
							<td width="26" align="center"><img src="./images/menuseporator.gif" width="3" height="29"></td>
							<td><a href="<?php echo $_SERVER['PHP_SELF']; ?>?c=preferences" class="menu">Opcion</a></td>
							<td width="26" align="center"><img src="./images/menuseporator.gif" width="3" height="29"></td>
							<td><a href="<?php echo $_SERVER['PHP_SELF']; ?>?c=logout" class="menu">Salir</a></td>
	 				<td><img src="./images/menuright.gif" width="11" height="29"></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>

		<br><br>

		<table width="980" cellpadding="0" cellspacing="0">
		<tr>
			<td width="24"><img src="./images/tl.png" width="24" height="27"></td>
			<td background="./images/tc.png">&nbsp;</td>
			<td width="24"><img src="./images/tr.png" width="24" height="27"></td>
		</tr>
		<tr>
			<td background="./images/lc.png">&nbsp;</td>
			<td background="./images/cbg.png">
				<table>
				<tr>
					<td width="160" valign="top">
						<span style="font-size: 14px;">Estadisticas:</span><br><br>
						<table>
						<tr>
							<td><input type="checkbox" name="autoreload" id="autoreload" onchange="OnOffAjax(this.checked);"></td>
							<td><label for="autoreload">Tiempo</label></td>
						</tr>
						</table>
						<hr style="height: 1px; border: 0px; border-bottom: 1px solid #58bcff; width: 145px; margin-left: 0px;">
						<span style="color: #58bcff; font-size: 18px; line-height: 30px;">
						Hosts: <span id="hosts"><?php echo $globalstat['all']; ?></span><br>
						Black: <span id="Black"><?php echo $globalstat['frags']; ?></span><br>
						Total: <span  id="percent"><?php echo @round($globalstat['frags'] / $globalstat['all'] * 100, 2); ?></span>%
						</span>
						<script>
						if (getCookie("fragus")){
							document.getElementById('autoreload').checked = true;
							stm = setTimeout("LoadAjax()", <?php echo $config['AdminAjaxSeconds']; ?>000);
						}
						</script>
					</td>
					<td valign="top">
						<table width="760" cellpadding="0" cellspacing="0">
						<tr>
							<td width="5"><img src="./images/tl.gif" width="5" height="5"></td>
							<td bgcolor="#262626"><img src="" width="5" height="5"></td>
							<td width="5"><img src="./images/tr.gif" width="5" height="5"></td>
						</tr>
						<tr>
							<td width="5" bgcolor="#262626"><img src="" width="5" height="5"></td>
							<td bgcolor="#171717" style="padding: 5px;"><?php echo isset($CONTENT) ? $CONTENT : "<b>404</b> Page not found"; ?></td>
							<td width="5" bgcolor="#262626"><img src="" width="5" height="5"></td>
						</tr>
						<tr>
							<td width="5"><img src="./images/bl.gif" width="5" height="5"></td>
							<td bgcolor="#262626"><img src="" width="5" height="5"></td>
							<td width="5"><img src="./images/br.gif" width="5" height="5"></td>
						</tr>
						</table>
					</td>
				</tr>
				</table>
			</td>
			<td background="./images/rc.png">&nbsp;</td>
		</tr>
		<tr>
			<td width="24"><img src="./images/bl.png" width="24" height="27"></td>
			<td background="./images/bc.png">&nbsp;</td>
			<td width="24"><img src="./images/br.png" width="24" height="27"></td>
		</tr>
		</table>
		<br>
		<table width="900">
		<tr>
			<td align="right" valign="top"><b style="color: #66ccff;"><?php echo $config['.']; ?></b></td>
			<td width="300"></td>
			<td width="140"><b style="color:#66ccff;"><br>:&nbsp;&nbsp;&nbsp;&nbsp;<br></b></td>
		</tr>
		</table>
		<br><br>
	</center>
</body>
</html>