$(function(){

	var $preparing = $('#preparing').show();
	var $gallery = $('#gallery');

	// Method to load a gallery
	$gallery.loadGallery = function(url, $display){
		$display = $display || $gallery
		$.get(url, function(data){
			$throbber.remove();
			var $data = $(data);
			// Colorbox
			$data.find('ul.botgallery li a').colorbox({
				loop: false,
				scalePhotos: true,
				maxWidth: '90%',
				maxHeight: '90%'
			});
			// Append the loaded contents
			$display.append($data);
			// jPager3k
			$display.find('.jPager3k').jPager3k('auto');
		});
		var $throbber = $('<img src="theme/throbber.gif" />').appendTo($gallery);
	};

	// Prepare the database
	$.get('?m=reports_images/ajaxPrepare', function(){
		$preparing.remove();
		$gallery.loadGallery($preparing.data('onfinish'));
	});

	// Click to go to the next page
	$('#gallery .botgallery-date .jPager3k a').live('click', function(){
		var $this = $(this);
		var $date_gallery = $this.closest('.botgallery-date');
		$date_gallery.empty();
		$gallery.loadGallery($this.attr('href'), $date_gallery);
		return false;
	});

	// Click to load more results
	$('#gallery #load_more').live('click', function(){
		var $this = $(this);
		$gallery.loadGallery($this.attr('href'));
		$this.remove();
		return false;
	});

	// Click to view bot logs
	$('#gallery h2 a').live('click', function(){
		var $this = $(this);
		$gallery.empty();
		$gallery.loadGallery($this.attr('href'));
		return false;
	})

});