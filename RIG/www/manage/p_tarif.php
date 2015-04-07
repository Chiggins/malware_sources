<?php

include_once('./gears/page_php_header.php');

if ($config['user']['rights']['pages']['p_tarif']['is']!='on') { Exit('<h1>Access denied</h1>'); } 

// ============================== CODE ============================== //

?>

<script>
	$(document).ready(function(){ $('#waitPageModal').modal('hide'); });
</script>


<?php

if ($config['user']['rights']['rolename']!='admin') {
?>

	<h1>Ваш тариф</h1>
	
	<?php
	
		$tarif = cdim('db','query',"SELECT * FROM `tarif` WHERE user_id = ".$config['user']['id']);
		if (isset($tarif)) {
			echo 'Окончание срока действия подписки '.date("Y/m/d H:i.s", $tarif[0]->len);
		}
	
	
	?>


	
<?php
}
?>