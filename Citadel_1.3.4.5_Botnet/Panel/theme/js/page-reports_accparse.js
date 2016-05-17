$(function(){
	// Language
	switch ($('html').attr('lang')){
		case 'ru':
			window.lexicon = {
				'bot_info': 'Бот инфо',
				
				'enable': 'Включить',
				'disable': 'Выключить',
				'remove': 'Удалить',
				
				'fav': 'Избранное',
				'junk': 'Мусор'
				};
			break;
		default: // english fallback
			window.lexicon = {
				'bot_info': 'Bot info',
				
				'enable': 'Enable',
				'disable': 'Disable',
				'remove': 'Remove',
				
				'fav': 'Избранное',
				'junk': 'Мусор'
				};
			break;
		}
	
	// Rules editor: context menu
	$.contextMenu(window.AJAXcontextMenu({
		lexicon: window.lexicon,
		selector: '#accparse_rules TBODY tr *', 
		callback: function(key, opt, ajaxSuccess){
			var $tr = $(this).closest('tr');
			var target = window.location + $tr.data('href');
			$.get( target, {'ajax': key}, ajaxSuccess );
			return true;
			},
		items: {
			'enable':	{
					disabled: function(key,opt){ return !$(this).closest('tr').hasClass('disabled'); },
					ajaxSuccess: function(data){ $(this).closest('tr').removeClass('disabled'); }
					},
			'disable': {
					disabled: function(key,opt){ return $(this).closest('tr').hasClass('disabled'); },
					ajaxSuccess: function(data){ $(this).closest('tr').addClass('disabled'); }
					},
			'remove':	{
					ajaxSuccess: function(data){ $(this).closest('tr').remove(); }
					}
			}
		}));
	
	// Display junk accounts
	$('#junk-start a').click(function(){
		var $this = $(this);
		$this.closest('table').find('tr.junk-hide').removeClass('junk-hide');
		$this.closest('tr').remove();
		return false;
		});
	
	// Accounts list: context menu
	$.contextMenu(window.AJAXcontextMenu({
		lexicon: window.lexicon,
		selector: '#list-accounts TBODY tr *',
		callback: function(key, opt, ajaxSuccess){
			var $tr = $(this).closest('tr');
			var target = window.location + $tr.data('href');
			$.get( target, {'ajax': key}, ajaxSuccess );
			return true;
			},
		items: {
			'bot_info': {
					callback: function(key, opt){
						window.open('?botsaction=fullinfo&bots[]='
							+ $(this).closest('tr').data('bot')
							);
						return true;
						}
					},
			'--1--': '-----',
			'fav':	{
					disabled: function(key,opt){ return $(this).closest('tr').hasClass('junk'); },
					ajaxSuccess: function(data){ $(this).closest('tr').toggleClass('fav'); }
					},
			'junk': {
					disabled: function(key,opt){ return $(this).closest('tr').hasClass('fav'); },
					ajaxSuccess: function(data){ $(this).closest('tr').toggleClass('junk'); }
					}
			}
		}));
	
	// Account notes
	$('#list-accounts TBODY .acc_notes').blur(function(){
		var $this = $(this);
		$this.animate({'background-color': '#F99'}, 200);
		
		var target = window.location + $this.data('href') + '&ajax=acc_notes';
		$.post( target, {'notes': $this.html()}, function(){
			$this.animate({'background-color': 'transparent'}, 1000);
			});
		});
	}); 
