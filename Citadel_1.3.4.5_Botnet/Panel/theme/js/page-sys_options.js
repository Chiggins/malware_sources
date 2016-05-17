$(function(){
	// Allowed countries
	var $on = $('input[name=allowed_countries_enabled]').data('toggle', $('#allowed_countries'));
	
	var state_change = function(){
		var $this = $(this);
		var $display = $this.data('toggle');
		
		if ($this.prop('checked'))
			$display.removeClass('disabled');
			else
			$display.addClass('disabled');
		};
	
	$on.change(state_change).change();
	});
