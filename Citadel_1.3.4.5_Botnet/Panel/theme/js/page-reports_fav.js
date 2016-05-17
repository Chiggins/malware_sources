$(function(){
	// Language
	switch ($('html').attr('lang')){
		case 'ru':
			window.lexicon = {
				'remove': 'Удалить'
			};
			break;
		default: // english fallback
			window.lexicon = {
				'remove': 'Remove'
			};
			break;
	}

	// Reports list: Edit comment
	$('#favorite-reports-list TBODY tr td.comment').blur(function(){
		var $this = $(this);
		$this.animate({'background-color': '#F99'}, 200);

		var ajax = '?m=/reports_fav/AjaxUpdateComment&' + $this.closest('tr').data('ajax');
		$.post( ajax, {'comment': $this.text()}, function(){
			$this.animate({'background-color': 'transparent'}, 1000);
		});
	});

	// Reports list: context menu
	$.contextMenu(window.AJAXcontextMenu({
		lexicon: window.lexicon,
		selector: '#favorite-reports-list TBODY tr *',
		callback: function(key, opt, ajaxSuccess){
			$.get( '?m=/reports_fav/Ajax' + key , $(this).closest('tr').data('ajax'), ajaxSuccess );
			return true;
		},
		items: {
			'remove': {
				ajaxSuccess: function(data){ $(this).closest('tr').remove(); }
			}
		}
	}));
});