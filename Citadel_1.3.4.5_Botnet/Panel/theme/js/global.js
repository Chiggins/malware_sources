/**
 * var delay = setTimeout.partial(undefined, 10);
 * delay(function(){ alert('delayed 10'); });
 */
Function.prototype.partial = function(){
	var fn = this, args = Array.prototype.slice.call(arguments);
	return function(){
		var arg = 0;
		for ( var i = 0; i < args.length && arg < arguments.length; i++ )
		if ( args[i] === undefined )
			args[i] = arguments[arg++];
		return fn.apply(this, args);
		};
	};

/** 
 * var f = function(a) { console.log(this, a); }
 * var g = f.appliedTo('lol')
 * g(1) -> ["lol", 1]
 */
Function.prototype.appliedTo = function(thisArg){
	var fn = this;
	return function(){
		return fn.apply(thisArg, arguments);
		};
	};

/** AJAX context menu
 */
window.AJAXcontextMenu = function(params, lexicon){
	// Items tuning
	for (var name in params['items']){
		var p = params['items'][name];
		// auto-icon
		if (p['icon'] === undefined)
			p['icon'] = name;
		// auto-name
		if (p['name'] === undefined)
			p['name'] = params['lexicon'][name];
		// auto-ajax
		if (p['ajaxSuccess'] !== undefined && p['callback'] === undefined)
			p['callback'] = function(p){ 
					return function(key,opt){
						// Call the default callback & give him the ajaxSuccess function
						return params['callback'].call(this, key, opt, p['ajaxSuccess'].appliedTo(this));
						};
					}(p);
		}
	return params;
	};

// Inits
$(function(){
	// Init jLog
	$('#jlog').jlog();
});
