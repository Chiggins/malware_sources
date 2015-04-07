<?php

include_once('./gears/page_php_header.php');

if ($config['user']['rights']['pages']['p_users']['is']!='on') { Exit('<h1>Access denied</h1>'); } 

// ============================== CODE ============================== //

if (!isset($_GET['page']) || $_GET['page']<0) $page = 0; else $page = $_GET['page'];
if ($page <= 0) $pagePrev = false; else $pagePrev = true;
$pageNext = false;

?>

<script>
	$(document).ready(function(){ $('#waitPageModal').modal('hide'); });
</script>


<script>
	function showhide(id) {
		$('#'+id).slideToggle();
	}
	
	function updateProxy(id) {
		var v='';
		$('#userProxy'+id).find('select option:selected').each(function(){
			v = v+$(this).attr("value")+',';
		});
		
		$.ajax({
			url: './gears/updateProxy.php',
			type: 'POST',
			data: {
				query: v,
				user_id: id
			},
			dataType: 'JSON',
			success: function(data) {
				if (data.type=='error') alert(data.msg);
				//console.log(data);
				pageLoad('users','page=<?php echo $page ?>');
			}
		});
		
	}

	function deleteUser(id) {
		if (confirm("Вы подтверждаете удаление?")) {
			$.ajax({
				url: './gears/deleteUser.php',
				type: 'POST',
				data: {
					user_id: id
				},
				dataType: 'JSON',
				success: function(data) {
					if (data.type=='error') alert(data.msg);
					//console.log(data);
					pageLoad('users','page=<?php echo $page ?>');
				}
			});		
		}
	}

	function changePassword(id) {
		var newPass = prompt("Enter a new password:", "");
		if (newPass==null || newPass=='') {
			alert('Password can not be blank !');
			return false;
		}
		var newPass2 = prompt("Confirm your new password:", "");
		if (newPass2==null || newPass2=='') {
			alert('Пароль не может быть empty!');
			return false;
		}
		if (newPass == newPass2) {
			$.ajax({
				url: './gears/changeUserPass.php',
				type: 'POST',
				data: {
					user_id: id,
					pass: newPass
				},
				dataType: 'JSON',
				success: function(data) {
					if (data.type=='error') alert(data.msg);
					if (data.type=='ok') alert('Password successfully changed');
					//pageLoad('users','page=<?php echo $page ?>');
				}
			});				
		} else {
			alert('Пароли не идентичны!');
		}
	}

	function changeLogin(id){
		var newLogin = prompt("Введите новый Логин:", "");
		if (newLogin==null) {
			alert('Username can not be empty !');
			return false;
		}
		var newLogin2 = prompt("Confirm New Login:", "");
		if (newLogin == newLogin2) {
			$.ajax({
				url: './gears/changeUserLogin.php',
				type: 'POST',
				data: {
					user_id: id,
					login: newLogin
				},
				dataType: 'JSON',
				success: function(data) {
					if (data.type=='error') alert(data.msg);
					if (data.type=='ok') alert('Login successfully changed !');
					//pageLoad('users','page=<?php echo $page ?>');
				}
			});				
		} else {
			alert('Пароли не идентичны!');
		}		
	}
	
	function changeUserColor(id) {
		var userColor = $('#userColor'+id).find('input.colorHex').val();
		if (userColor=='#') return false;
		$.ajax({
			url: './gears/changeUserColor.php',
			type: 'POST',
			data: {
				user_id: id,
				color: userColor
			},
			dataType: 'JSON',
			success: function(data) {
				if (data.type=='error') alert(data.msg);
				if (data.type=='ok') {
					alert('Color successfully changed !');
					pageLoad('users','page=<?php echo $page ?>');
				}
			}
		});					
	}


	function changeUserTarif(user_id,newdate) {
		$.ajax({
			url: './gears/changeUserTarif.php',
			type: 'POST',
			dataType: 'JSON',
			data: {
				user_id: user_id,
				tarif: newdate
			},
			dataType: 'JSON',
			success: function(data) {
				if (data.type=='error') alert(data.msg);
				if (data.type=='ok') {
					notify('info', data.msg);
				}
			}
		});					
	}

	function showCal(id, value) {
		if (value == 0) value = new Date(); else value = new Date(value.date)
		$('#userTarif'+id).find('.cal').pickmeup({
			flat	: true,
			date: value,
			change: function(newdate) {
				changeUserTarif(id,newdate);
				showhide(id);
			}
		});		

	}

	
	function generatePassword() {
	
		$('#newUserCreater').find('.newUserPass1').attr('type','text');
		$('#newUserCreater').find('.newUserPass2').attr('type','text');
	
		var chars = "ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz1234567890";
		var string_length = 8;
		var randomstring = '';
		var charCount = 0;
		var numCount = 0;
		
		for (var i=0; i<string_length; i++) {
		    // If random bit is 0, there are less than 3 digits already saved, and there are not already 5 characters saved, generate a numeric value. 
		    if((Math.floor(Math.random() * 2) == 0) && numCount < 3 || charCount >= 5) {
		        var rnum = Math.floor(Math.random() * 10);
		        randomstring += rnum;
		        numCount += 1;
		    } else {
		        // If any of the above criteria fail, go ahead and generate an alpha character from the chars string
		        var rnum = Math.floor(Math.random() * chars.length);
		        randomstring += chars.substring(rnum,rnum+1);
		        charCount += 1;
		    }
		}
		$('#newUserCreater').find('.newUserPass1').val(randomstring);
		$('#newUserCreater').find('.newUserPass2').val(randomstring);
	}
	
	function createUser() {
		var userName = $('#newUserCreater').find('.newUserName').val();
		if (userName==null || userName=='') {
			alert('Name can not be empty !');
			return false;
		}

		var userPass1 = $('#newUserCreater').find('.newUserPass1').val();
		if (userPass1==null || userPass1=='') {
			alert('Password can not be blank !');
			$('#newUserCreater').find('.newUserPass1').focus();
			return false;
		}
				
		var userPass2 = $('#newUserCreater').find('.newUserPass2').val();
		if (userPass2==null || userPass2=='') {
			alert('Password can not be blank !');
			$('#newUserCreater').find('.newUserPass2').focus();
			return false;
		}
		if (userPass1!=userPass2) {
			alert('Passwords must match!');
			return false;
		}

		var userRole = $('#newUserCreater').find('select.newUserRights option:selected').val();

		$.ajax({
			url: './gears/createUser.php',
			type: 'POST',
			data: {
				newUserName: userName,
				newUserPass: userPass1,
				newUserRole: userRole
			},
			dataType: 'JSON',
			success: function(data) {
				if (data.type=='error') alert(data.msg);
				//console.log(data);
				pageLoad('users','page=<?php echo $page ?>');
			}
		});
	}
	
	function dropSid(id) {
		$.ajax({
			url: './gears/dropSid.php',
			type: 'POST',
			data: {
				user_id: id,
			},
			dataType: 'JSON',
			success: function(data) {
				if (data.type=='error') alert(data.msg);
				//console.log(data);
				pageLoad('users','page=<?php echo $page ?>');
			}
		});		
	}

</script>

<h1>users</h1>

<h2>New User</h2>
<table class='listing' border=0>
<thead><tr><th></th><th></th></tr></thead>
<tbody id="newUserCreater">
<tr><td width=30%>Username</td><td style="text-align:right;"><input style="width:100%;" class="newUserName"></td></tr>
<tr><td width=30%>Passowrd</td><td style="text-align:right;"><input type=password style="width:99%;" class="newUserPass1"></td></tr>
<tr><td width=30%>Confirm Passowrd<br><small>(must comply "a-z0-9#@$&_-")</small></td><td valign="top" style="text-align:right;"><input type=password style="width:99%;" class="newUserPass2"><br><input type="button" class="btn-tiny" value="Generate Password" onclick="generatePassword();"></td></tr>
<tr><td width=30%>user rights</td><td style="text-align:right;"><select class="newUserRights" style="width:100%;"><?php echo getRightsSelector(); ?></select></td></tr>
<tr><td colspan=2 style="text-align:right;"><input type="button" class="btn" value="create" onclick="createUser();"></tr>
</tbody>
</table>

<h2>editing users</h2>
<table class='listing' border=0>
<thead><tr><th>id</th><th>user</th><th>status</th><th>period</th><th>manage</th></tr></thead>
<tbody>
<?php	
	// select all users
	$users = cdim('db','query',"SELECT * FROM `users` ORDER BY `id` ASC");
	if (isset($users)) foreach($users as $k=>$v) {
		// Next there (although we do not know , but this precisely is =) )
		$pageNext = true;
		$tarifExp = cdim('db','query',"SELECT * FROM `tarif` WHERE user_id = ".$v->id);
		if (isset($tarifExp)) {
			$tarifExpInDays = ceil(($tarifExp[0]->len-time())/60/60/24);
			if ($tarifExpInDays<5) $tarifExpInDays = "<string style='color:red;'>".$tarifExpInDays.' days</strong>'; else $tarifExpInDays = $tarifExpInDays.' days</strong>';
			$tarifExp = str_replace('"', "'", json_encode(array('format'=>'Y-m-d', 'date'=>date('Y-m-d',$tarifExp[0]->len))));
		} else {
			$tarifExpInDays = 'not assigned';
			$tarifExp=0;
		}
		$oe = (!isset($oe) || $oe == 'odd') ? 'even' : 'odd';
?>
		<tr class="<?php echo $oe; ?>">
			<td><span>ID</span><?php echo $v->id; ?></td>
			<td style="color:#<?php echo $getUserColorBiId($v->id);?>;"><span>Login</span><?php echo $v->user_login; ?></td>
			<td><span>status</span><?php echo $v->rights; ?></td>
			<td><?php echo $tarifExpInDays; ?></td>
			<td>
				<input type="button" class="btn" value="Life" onclick="showCal(<?php echo $v->id.','.$tarifExp; ?>);showhide('userTarif<?php echo $v->id; ?>');">
				<input type="button" class="btn" value="change password" onclick="changePassword(<?php echo $v->id; ?>);">
				<input type="button" class="btn" value="change color" onclick="showhide('userColor<?php echo $v->id; ?>');">
				<input type="button" class="btn" value="change login" onclick="changeLogin(<?php echo $v->id; ?>);">
				<input type="button" class="btn" value="reset session" onclick="dropSid(<?php echo $v->id; ?>);">
				<input type="button" class="btn-danger" value="remove" onclick="deleteUser(<?php echo $v->id; ?>);">

				
				<div id="userColor<?php echo $v->id; ?>" style="margin: 10px 0 10px 0;padding:5px;display:none;">
					<input value="#<?php echo $getUserColorBiId($v->id);?>" class="colorHex"> 
					<input type="button" class="btn-warning" value="change color" onclick="changeUserColor(<?php echo $v->id; ?>);"><br>
					enter the color code ( you can play with colors here <a href="http://www.redirect.am/?http://getcolor.ru/" target="_blank">getcolor</a>)
				</div>

				<div id="userTarif<?php echo $v->id; ?>" style="margin: 10px 0 10px 0;padding:5px;display:none;">
					<div class="cal"></div>
				</div>

			</td>
		</tr>

<?php
	}
?>
</tbody>
</table>