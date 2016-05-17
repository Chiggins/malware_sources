<script type="text/javascript">
    var GB_ROOT_DIR = "js/greybox/";
</script>

<script type="text/javascript" src="js/greybox/AJS.js"></script>
<script type="text/javascript" src="js/greybox/AJS_fx.js"></script>
<script type="text/javascript" src="js/greybox/gb_scripts.js"></script>
<link href="js/greybox/gb_styles.css" rel="stylesheet" type="text/css" />

<script type="text/javascript">
function ajaxCardDelete(res) {
	if (res.indexOf('Error') == -1 && res.length != 0) {
		var el = document.getElementById('t' + res);
		if (el)
			el.innerHTML = '';
	}
	else {
		alert('Cannot delete this task\n\n' + res);
	}
}
function cardDelete(id) {
	ajax_load('mod_cards_del.php?id=' + id, ':restofunc:', ajaxCardDelete);
}

function cc(id, color) { // "cc" = changeColor
	var el = document.getElementById(id).style;
	var cols = '' + el.backgroundColor;
	(cols.indexOf('190') == -1) ? el.backgroundColor = '#bebeff' : el.backgroundColor = color; 
}
</script>

<?php

require_once 'mod_dbase.php';
require_once 'mod_crypt.php';

$dbase = db_open();
if (!$dbase) exit;

 $sql = "SELECT * " .
        "  FROM cards " .
		" LEFT JOIN tasks_t ON (tasks_t.fk_card_task = cards.id_card), " .
		" email_t, country_t, global_tasks_t " .
		" WHERE id_email = fk_email " .
		"   AND fk_country = id_country" .
		"   AND global_tasks_t.id_global_task = cards.fk_gtask " .
		" ORDER BY tasks_t.status_task DESC, cards.fk_gtask DESC, cards.id_card";
 $res = mysqli_query($dbase, $sql);
 echo "<table width='740px' border='1' cellspacing='0' cellpadding='0' style='border: 1px solid gray; font-size: 9px; border-collapse: collapse; background-color: white;'>
       <th>ID</th>
	   <th>Number</th>
	   <th>CSC</th>
	   <th>Name, Surname</th>
	   <!--<th>Address</th>-->
	   <th>City</th>
	   <th>State</th>
	   <!--<th>ZIP</th>-->
	   <th>Phone</th>
	   <th>E-Mail</th>
	   <th>Country</th>
	   <th>Edit</th>";
 while ($mres = mysqli_fetch_array($res))
 {
   switch ($mres['status_task'])
   {
     case NULL:
	   $color = "#fff";
	 break;
   
     case -1:
	   $color = '#ffbdbd';
	 break;
	 
     case 0:
	   $color = '#ffffbd';
	 break;
	 
     case 1:
	   $color = '#bdffbd';
	 break;
   }
   $bck_color = " background: $color";
   
 $num = encode(base64_decode($mres['NUM']), $mres['CSC']);
if ($mres['id_global_task']) {
 
	$num = substr($num, 0, strlen($num) - 4) . 'xxxx';
 
	$name = $mres['NAME'];
	$sname = $mres['SURNAME'];
	(strlen($sname)) ? $name .= " $sname" : $sname = "<i>$sname</i>";
	
	$email = $mres['value_email'];
	$pos = strpos($email, '@');
	if ($pos) {
		$email = substr($email, 0, $pos) . '<br>' . substr($email, $pos);
	}
	
echo "<tr onclick='cc(this.id, \"$color\");' style='$bck_color'; id='t" . $mres['id_card'] . "'>".
	   "<td>" . $mres['id_global_task'] . "</td>".
	   "<td>" . $num . "</td>".
	   "<td>" . $mres['CSC'] . "</td>".
	   "<td>" . $name . "</td>".
	   //"<!--<td>" . $mres['ADDRESS'] . "</td>-->".
	   "<td>" . $mres['CITY'] . "</td>".
	   "<td>" . $mres['STATE'] . "</td>".
	   //"<!--<td>" . $mres['POST_CODE'] . "</td>-->".
	   "<td>" . $mres['PHONE_NUM'] . "</td>".
	   "<td>" . $email . "</td>".
	   "<td>" . $mres['name_country'] . "</td>".
	   "<td>" . "<a href='#null' title='Edit this card' onclick=\"GB_show('Card editing', '../../frm_cards_edit.php?id=$mres[0]', 400, 500); return false;\"><img border='0' src='img/icos/edit.png'></a>".
	   "<a href=\"#null\" onclick=\"if (!confirm('Do you really want to delete this card?')) return false; cardDelete($mres[0]); return false;\"><img border='0' src='img/icos/delete.png'></a></td>".
	  "</tr>";
}

}
 echo "</table>"; 

?>