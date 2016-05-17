function CBoxHacker($cbox_prev, $cbox_next){
	this.$current = null;

	// Key navigation simulation
	this.bindKeys = function(){
		$(document).on('keydown.cboxhacks', function (e) {
			if (e.keyCode === 37) $cbox_prev.click();
			if (e.keyCode === 39) $cbox_next.click();
			if (e.keyCode === 37 || e.keyCode === 39) {
				e.preventDefault();
				return false;
			}
		});
	};
	this.unbindKeys = function(){
		$(document).off('.cboxhacks');
	};

	// Next/Prev buttons click
	this.bindClicks = function($li){
		if (!$li.next().length)
			$cbox_next.hide();
		else
			$cbox_next.show().on('click.cboxhacks', function(){
				$li.next().click();
				return false;
			});
		if (!$li.prev().length)
			$cbox_prev.hide();
		else
			$cbox_prev.show().on('click.cboxhacks', function(){
				$li.prev().click();
				return false;
			});
	};
	this.unbindClicks = function(){
		$cbox_next.off('.cboxhacks');
		$cbox_prev.off('.cboxhacks');
	};

	// Shortcuts
	this.bind = function(li){
		if (this.$current)
			this.$current.removeClass('brief');
		this.$current = $(li).addClass('brief seen');

		this.bindKeys();
		this.bindClicks(this.$current);
	};
	this.unbind = function(){
		this.unbindKeys();
		this.unbindClicks();
	};

	return this;
}



$(function(){
	// Open in new window
	$('#botslist .botnet-search-results').on('click', 'ul.bot-search-results ol.bot-reports li a', function(e){
		$(this).attr('target', '_blank').closest('li').addClass('seen');
		e.stopPropagation();
	});

	// Disable the AJAX spinner here (useless)
	$(document).off('.ajax-spinner');

	// Brief view mode: colorbox hacks
	var $cbox = $('#colorbox'); // Colorbox display
	var cboxhacks = new CBoxHacker($cbox.find('#cboxPrevious'), $cbox.find('#cboxNext'));

	// Brief view mode
	$('#botslist .botnet-search-results').on('click', 'ul.bot-search-results ol.bot-reports li', function(){
		var $this = $(this);
		var href = $this.find('a').attr('href');

		// Init dynamic colorbox here
		$this.colorbox({
			loop: false,
			width: '90%',
			height: '90%',

			href: href + '&viewmode=brief',
			title: $('<a href="'+href+'" target="_blank">'+$this.text()+'</a>'),

			open: true,

			onComplete: function(){
				cboxhacks.unbind();
				cboxhacks.bind(this);
			},
			onClosed: function(){
				cboxhacks.unbind();
			}
		});
		return false;
	});
});