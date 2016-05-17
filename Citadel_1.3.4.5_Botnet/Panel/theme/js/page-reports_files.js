$(function(){
	$('#result a[rel]').live('click', function(){
		var $this = $(this);
		var rel = $this.attr('rel');

		// Build colorbox sequence
		$this.closest('tbody').find('a[rel]').colorbox({
			maxWidth: '90%',
			maxHeight: '90%',
			open: false,
			rel: rel,
			title: function(){
				return $(this).attr('href');
			}
		});

		// Open the specific link's colorbox
		//$.colorbox({  href: $(this).attr('href')  });
		$this.colorbox({open: true});
		return false;
	});
});