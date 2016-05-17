$(function(){
	// Language
	switch ($('html').attr('lang')){
		case 'ru':
			window.lexicon = {
				'fav': 'Избранное',
				'junk': 'Мусор',
				'expand': 'Развернуть/Свернуть'
				};
			break;
		default: // english fallback
			window.lexicon = {
				'fav': 'Favorite',
				'junk': 'Junk',
				'expand': 'Expand/Collapse'
				};
			break;
		}
	
	// AJAX buttons: parse more, mark all as checked, ...
	$('#ajax-buttons input').click(function(){
		var button = $(this);
		var span = button.parent();
		var interval_update = null;
		
		if (button.hasClass('display-new-reports')){
			var initial_reports_count = Number(button.data('reports'));
			interval_update = window.setInterval(function(){
				$.get(window.location, {'ajax': 'count-new-reports'}, function(data){
					var current_reports_count = Number(data);
					span.find('span').html('... ' + Math.round(100 - 100*(current_reports_count/initial_reports_count)) + '%');
					});
				}, 2000);
			}
		
		$.get(button.data('href'), function(data){
			span.empty().append(data);
			if (interval_update)
				window.clearInterval(interval_update);
			});
		span.empty().append('<img src="theme/throbber.gif" /><span></span>');
		return false;
		});
	
	// Context Menu
	$.contextMenu({
		selector: '#domains-list tr *', 
		callback: function(key, options) {
			var $tr = $(this).closest('tr');
			// Default callback
			$.get( $tr.data('href'), {'ajax': key}, function(){
				$tr.toggleClass(key); // Toggle the same class after click menu item's name :)
				});
			return true;
			},
		items: {
			'fav':	{ 
					name: window.lexicon['fav'],
					icon: 'favorite',
					disabled: function(key,opt){ return $(this).closest('tr').hasClass('junk'); }
					},
			'junk':	{ 
					name: window.lexicon['junk'],
					icon: 'junk',
					disabled: function(key,opt){ return $(this).closest('tr').hasClass('fav'); }
					},
			'expand':	{
					name: window.lexicon['expand'],
					icon: 'expand',
					callback: function(key,opt){
						$.get( $(this).closest('tr').data('href'), {ajax: 'expander'}, function(){
							$.get(window.location, function(data){
								$('#domains-list').replaceWith(  $('#domains-list', data)  );
								});
							});
						}
					}
			}
		});
	
	// Logs display
	$('#domains-list TBODY th a').live('click', function(){
		var $this = $(this);
		var $tr = $(this).closest('tr');
		var botId = $tr.data('prev-botid') || '';
		console.log(botId);
		$.get(window.location, $tr.data('href') + '&ajax=logs&botId='+botId, function(data){
			var $data = $(data);
			var onebyone = $data.find('.bot_logs').data('onebyone');
			// Next bot binding
			var $next_bot = $data.find('a#load-next-bot');
			$tr.data('prev-botid', $next_bot.data('prev-botid') );
			$next_bot.click(function(){ $this.click(); });
			// No more logs? close
			if (!$next_bot.length){ // No more logs
				if (onebyone == 1)
					$.colorbox.close();
				$tr.find('th').fadeTo('slow', 0.3).end().find('td').html(0);
				$tr.data('prev-botid', null);
				}
			// Display
			$.colorbox({html: $data.clone(true)});
			});
		$.colorbox({html: '<img src="theme/throbber.gif" />'});
		return false;
		});
	});
