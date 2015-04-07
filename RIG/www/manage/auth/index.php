<?php
if (!defined('REQ')) define('REQ','ok');
?>
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1">
	<link rel="stylesheet" href="./bootstrap/css/bootstrap.min.css" type="text/css">
	<link rel="stylesheet" href="./bootstrap/css/bootstrap-responsive.min.css" type="text/css">
	<link rel="apple-touch-icon" href="./images/favicon.png" />
	<link rel="shortcut icon" href="./images/favicon.png" />		

	<style>
		#auth table {
			font-size: 0.85em;
		}
		#auth {
			font-family: Arial;
			font-size: 0.85em;
			margin-left: auto;
			margin-right: auto;
			width: 600px;
			text-align: center;
			background-image: url('./images/logo.png');
			background-repeat: no-repeat;
			background-position: top center;
			padding-top: 60px;
			margin-top: 120px;
		}
		#authtip {
			font-family: Arial;
			font-size: 0.85em;
			margin-left: auto;
			margin-right: auto;
			width: 600px;
			text-align: center;
			position: absolute;
			top:0;
		}
		#auth input {
			width: 400px;
			margin-bottom: 10px;
		}
		@media (max-width: 767px) {
			html, body {
				margin: 0 0 0 10px;
				padding: 0 10px 0 0;
			}
			#auth {
				width: 100%;
				padding-top: 80px;
				margin-top: 20px;
			}

			#auth input {
				width: 90%;
				margin: 0px 0px 10px 0px;
			}
			
			#auth input.btn {
				width:90%;
			}

		}
	</style>
	<script src="<?php echo $config['options']['siteurl']; ?>/manage/js/jquery-2.0.0.min.js" type="text/javascript" ></script>
	<script>

		function checkAuth() {
			$.ajax({
				type: "POST",
				dataType: "JSON",
				url: "<?php echo $config['options']['siteurl']; ?>/manage/auth/login.php",
				data: "act="+$('#act').val()+"&login="+$('#login').val()+"&password="+$('#password').val(),
				success: function(msg){
					if (msg.error==1) {
						$('#authtip').fadeIn(function(){
							$('#auth').animate({opacity: 0.25}, 100, function() {});
							$('#auth').animate({opacity: 1}, 100, function() {});
							$('#auth').animate({opacity: 0.25}, 100, function() {});
							$('#auth').animate({opacity: 1}, 100, function() {});
							$('#auth').animate({opacity: 0.25}, 100, function() {});
							$('#auth').animate({opacity: 1}, 100, function() {});
							$('#auth').animate({opacity: 1}, 100, function() {$('#authtip').fadeOut();});
						});						
					} else {
						document.location.reload();
					} 
				},
				error: function (jqXHR, textStatus, errorThrown) {
					alert(jqXHR+' '+textStatus+' '+errorThrown);
				}
			});

		}

		$(document).ready(function(){
			$('#authtip').hAlign();
			$('input').attr('autocomplete','off');
			$('#password').bind('keyup',function(e){
				if (e.keyCode==13) checkAuth();
			});
			$('#login').focus();
		});

		(function ($) {
		$.fn.hAlign = function() {
			return this.each(function(i){
			var w = $(this).width();
			var ow = $(this).outerWidth();
			var mt = (w + (ow - w)) / 2;	
			$(this).css("margin-left", "-" + mt + "px");	
			$(this).css("left", "50%");
			$(this).css("position", "absolute");	
			});	
		};
		})(jQuery);			

	</script>
</head>

<body>
	<div id="authtip" style="display:none;"><h1>The username or password you entered is incorrect!</h1></div>
	<div id="auth">
		<form onsubmit="return false;">
		<input type="text" id="login" name="login" style="font-size:2em;"><br>
		<input type="password" id="password" name="password" style="font-size:2em;">
		<input type="button" class="btn" onclick="checkAuth();" value="Login">
		<input type="hidden" id="act" name="act" value="login">
		</form>
		
		<h4><i>0x43@exploit.im </i></h4>
		
	</div>
</body>
</html>