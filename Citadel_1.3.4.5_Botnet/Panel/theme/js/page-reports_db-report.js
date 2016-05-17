$(function(){

	// Language
	switch ($('html').attr('lang')){
		case 'ru':
			window.lexicon = {
				'saved': 'Сохранено'
			};
			break;
		default: // english fallback
			window.lexicon = {
				'saved': 'Saved'
			};
			break;
	}

	var $report = $('#full-bot-report');

	// Whois
	$('aside.sidebar #aside-report-whois button').click(function(){
		var $btn = $(this);
		var btn_old_text = $btn.text();

		var ip_addr = $report.data('ipv4');
		$.get('?m=botnet_socks&ajax=whois', {ip: ip_addr}, function(whois){
			var whois_str = whois.join(' ');
			var $whois = $('<span class="whois"></span>').text(whois_str).hide();

			// Add to the report
			$report.data('whois', whois);
			$report.find('tr.field-ipv4 td').append($whois);

			// Add to favorite
			$('aside.sidebar #aside-report-favorite form textarea').prepend('Whois '+ ip_addr +' : ' + whois_str + "\n");

			// Animate
			$btn.text(btn_old_text);
			$whois.show('slow');
		});
		$btn.text('...');
		return false;
	});

	// Favorite initial
	(function(){
		var $btn = $('aside.sidebar #aside-report-favorite button');
		var $form = $btn.next('form');
		var $comment = $form.find('textarea');

		if ($comment.val()){
			$btn.hide();
			$form.show();
		}
	})();

	// Favorite
	$('aside.sidebar #aside-report-favorite button').click(function(){
		var $btn = $(this);
		var $form = $btn.next('form');
		var $comment = $form.find('textarea');
		var $submit = $form.find('input:submit');

		// Show
		$form.show('slow');
		$btn.hide();
		$('<h1></h1>').text($btn.text()).prependTo($btn.parent());
		return false;
	});

	// Favorite: save
	$('aside.sidebar #aside-report-favorite').on('submit', 'form', function(){
		var $form = $(this);
		var $submit = $form.find('input:submit');
		$.post($form.attr('action'), $form.serialize(), function(){
			$submit.fadeTo('fast', 1);
			$.jlog('ok', window.lexicon.saved);
		});
		$submit.fadeTo('slow', 0.2);
		return false;
	});
});