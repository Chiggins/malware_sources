$(function(){
	// Account notes
	$('#notepads .notepad').blur(function(){
		var $this = $(this);
		$this.animate({'background-color': '#F99'}, 200);
		
		var target = window.location + '&ajax=save_notepad' + $this.data('href');
		$.post( target, {'content': $this.html()}, function(){
			$this.animate({'background-color': 'transparent'}, 1000);
			});
		});
	});