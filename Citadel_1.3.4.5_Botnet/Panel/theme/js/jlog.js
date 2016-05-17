(function($, window, document){

	// TODO: ability to attach 'read more' message
	// TODO: ability to disable rm_timeout per call (or specify settings per severity)
	// TODO: dupe to window.console()

	/** Method entry point.
	 * Usage:
	 *  $('ul#jlog').jlog({ options })
	 *  $('ul#jlog').jlog('severity', 'message with {ph}'[, {key: value})
	 *  $.jlog('severity', 'message with {ph}'[, {key: value})
	 * @return jQuery
	 */
	$.fn.jlog = function(method){
		// Init: $().jlog({ option: value })
		if ( typeof method === 'object' || ! method )
			return this.jlog['init'].call(this, method || {}); // init(options)
		// Log: $.jlog('severity', 'message', { key: value })
		if (typeof method == 'string' && method!='init')
			return this.jlog['log'].apply(this, arguments);
		// Other methods
		return this.jlog[method].apply(this, arguments);
	};

	/** $.fn.jlog() proxy, applied to the default display */
	$.jlog = function(){
		return $.fn.jlog.apply($.jlog.global['this'], arguments);
	};
	$.jlog.global = {
		'this': undefined // Default display. ?jQuery
	};

	/** Init jLog on some appendable item.
	 * This is then used as the default display when used with $.jlog()
	 * @param options
	 */
	$.fn.jlog.init = function(options){
		// Defaults
		options = $.extend(true, {
			// Log line template to append. Text is wrapped with it. Severity class is added via addClass().
			logline: '<li></li>',

			// Method to use for adding items: append|prepend
			add_method: 'prepend',
			// Effect to display the logline
			add_effect: function(){ this.slideDown('slow'); },

			// Auto-hide timeout for every message
			rm_timeout: 3000,
			// Hide items on click
			rm_click: true,
			// Effect to remove the logline
			rm_effect: function(end){ this.hide('slow', end); }
		}, options);

		// Events
		this.on('add.jlog', function(e, logline){ // Log a message: e.logline
			var $jlog = $(this);
			var opts = $jlog.data('jlog');
			var $logline = $(logline);

			// Add
			$jlog[opts.add_method]($logline.hide());

			// Display effect
			opts.add_effect.apply($logline);

			// Timeout
			if (opts.rm_timeout)
				setTimeout((function($jlog, $logline){ return function(){ $jlog.trigger('rm.jlog', $logline); } })($jlog, $logline), opts.rm_timeout);
			return true;
		});
		this.on('rm.jlog', function(e, logline){ // Remove a displayed message: e.logline
			var $jlog = $(this);
			var opts = $jlog.data('jlog');
			var $logline = $(logline);

			// Remove effect
			opts.rm_effect.apply($logline, function(){ $logline.remove(); });

			return true;
		});
		if (options.rm_click)
			this.on('click', '*', function(e){
				var $jlog = $(e.delegateTarget);
				$jlog.trigger('rm.jlog', this);
				return false;
			});

		// Finish
		this.data('jlog', options);
		$.jlog.global['this'] = this;
		return this;
	};

	/** Log a message to the current display.
	 * When used statically, the default display is used
	 * @param severity string
	 * @param message string
	 * @param values object
	 */
	$.fn.jlog.log = function(severity, message, values){
		// Prepare the message: templating
		if (values)
			message = message
					.replace('%7B','{').replace('%7D','}')
					.replace(/{([^{}]*)}/g, function(match, key){
				var replace = values[key];
				if (replace === null) return ''; // empty
				if (replace === undefined) return match; // preserve template syntax
				return replace;
			});

		// Add the message
		var opts = this.data('jlog');
		var $logline = $(opts.logline).addClass(severity).wrapInner(message);
		$logline.data('jlog', {severity: severity, message: message, values: values});

		// Trigger the event
		this.trigger('add.jlog', $logline);
		return this;
	};

})(jQuery);
