window.socks_stat = {'ok': 0, 'fail': 0, 'total': 0};

/** Add more info on socks # (int)this */
window.socks_add = function(status, geoloc, hostname){
	var $list = $('#socks_list TBODY');
	var $line = $list.find('tr:eq(' + this + ')');
	
	/* state */
	$line.removeClass('pending').addClass(status);
	
	/* info */
	$line.find('td:eq(1)').html(geoloc);
	$line.find('td:eq(2)').html(hostname);
	
	/* stat */
	window.socks_stat[status] += 1;
	window.socks_stat['total'] += 1;
	};

window.socks_finish = function(){
	$('#socks_list TBODY tr.fail').remove();
	$('#socks_list caption').empty().html(
		'OK: ' + window.socks_stat['ok'] + ' / ' +
		window.socks_stat['total']
		);
	};
