$(function(){
	var $td = $('#accounts td.iframed_pages');
	$td.find('a').live('click', function(){
		$(this).hide().parent().find('ol').show();
		return false;
		});
	$td.find('ol').live('click', function(){
		$(this).hide().parent().find('a').show();
		return false;
		});

	var $td = $('#accounts td.errors');
	$td.find('a').live('click', function(){
		$(this).hide().parent().find('ol').show();
		return false;
	});
	$td.find('ol').live('click', function(){
		$(this).hide().parent().find('a').show();
		return false;
	});

	var $td = $('#accounts td.statistics');
	$td.find('a').live('click', function(){
		$(this).hide().parent().find('table').show();
		return false;
	});
	$td.find('table').live('click', function(){
		$(this).hide().parent().find('a').show();
		return false;
	});

	// Manual cronjobs launch
	$('table#cronjobs th a').click(function(){
		var $this = $(this);
		var $tr = $this.closest('tr');
		$tr.addClass('querying');
		$tr.find('td').empty('...');
		$.get($this.attr('href'), function(data){
			$tr.removeClass('querying');
			$tr.find('td:eq(0)').text('now');
			$tr.find('td:last-child').text(data);
			});
		return false;
		});

	// Ignore button
	$('#accounts tr td.ignore a[data-action=ignore]').click(function(){
		var $this = $(this);
		var $tr = $this.closest('tr');
		$.get($this.attr('href'), function(){
			$tr.toggleClass('ignored');
			});
		return false;
		});

	// Filter
	$('#accounts-stat a').click(function(){
		var cls = $(this).data('filter');
		var $trs = $('#accounts TBODY tr');
		$trs.hide();
		$trs.filter(cls).show();
		return false;
		});
	});
