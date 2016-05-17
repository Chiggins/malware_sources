<script type="text/javascript" defer>
function auth () {
	pass = document.getElementById('password').value;
	ajax_load('mod_auth_chkpsw.php?password=' + pass, 'div_auth');
}
</script>

<form onsubmit='auth(); return false;'>
	<label>Please, enter password: </label><input type='password' id='password' name='password'> <input type='submit' value='Enter'>
	<div id='div_auth'>
	</div>
</form>

<script type="text/javascript">
el = document.getElementById('password');
if (el)	el.focus();
</script>